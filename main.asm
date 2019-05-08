cpu 80186

%include 'macros.asm'
%include 'header.asm'
%include 'objects.asm'
%include 'draw_objects.asm'
%include 'palette_code.asm'
%include 'data.asm'
%include 'sprite_chr_map.asm'

;======================================================================
;======================================================================
section code
;======================================================================
;======================================================================

main:
  startup
  call initialize_dynamic_palette_table
  call initialize_objects
  sti	;Enable Interupts
  
  
  
  mov al, 0x00
  out BG1CONTROL, al
  mov al, 0x11
  out BG2CONTROL, al
  mov al, 0x12
  out BG3CONTROL, al
  
  mov word [paletteUseageTable], UPDATE
  mov word [paletteLowWordTable], palette1
  mov word [paletteHighWordTable], DATA
  
  mov si, Palette2
  call allocate_palette
  mov si, Palette3
  call allocate_palette
  mov si, Palette4
  call allocate_palette
  
  printstring	DATA, Cam,						(ORIGIN_X), (ORIGIN_Y + 240-8)
  
  printstring	DATA, X,						(ORIGIN_X + 3*8), (ORIGIN_Y + 240-8)
  printhex		WORKRAM, cameraXPosition, 2,	(ORIGIN_X + 5*8), (ORIGIN_Y + 240-8)	
  printstring	DATA, Y,						(ORIGIN_X + 3*8), (ORIGIN_Y + 240-16)						
  printhex		WORKRAM, cameraYPosition, 2,	(ORIGIN_X + 5*8), (ORIGIN_Y + 240-16)
  
  printstring	DATA, Hello_World,				(ORIGIN_X + 320/2 - 40), (ORIGIN_Y + 240/2)
  
  mov ax, empty_object
  xor si, si
  call find_object_forwards
  mov word [object+identity + si], private_object
  mov word [object+metaspriteType + si], COMPLEX
  mov word [object+metaspriteData+0 + si], metasprite1
  mov word [object+xPosition+1 + si], ORIGIN_X
  mov word [object+yPosition+1 + si], ORIGIN_Y
  mov [debug+0], si
  
  mov word [testBuffer+0],  'A'-32
  mov word [testBuffer+4],  'B'-32
  mov word [testBuffer+8],  'C'-32
  mov word [testBuffer+12], 'D'-32
  mov word [testBuffer+16], 'E'-32
  mov word [testBuffer+20], 'F'-32
  mov word [testBuffer+24], 'G'-32
  mov word [testBuffer+28], 'H'-32
  mov word [tileUpload+uploadDimensions], 0x0204
  mov word [tileUpload+rowOffset], 0
  mov word [tileUpload+vramAddress], 0
  mov word [tileUpload+tileDataAddress+0], testBuffer
  mov word [tileUpload+tileDataAddress+2], WORKRAM
  add word [tileUploadOffset], tileUploadStruct_size
  
  
  
infinite_loop:
  mov ax, [controller1]
  mov dx, [controller1Press]
  mov bx, [debug+0]
  
  
  
  test ax, UP_INPUT
  jz .up_done
  inc word [cameraYPosition]
  .up_done:
  
  test ax, DOWN_INPUT
  jz .down_done
  dec word [cameraYPosition]
  .down_done:
  
  test ax, LEFT_INPUT
  jz .left_done
  dec word [cameraXPosition]
  .left_done:
  
  test ax, RIGHT_INPUT
  jz .right_done
  inc word [cameraXPosition]
  .right_done:
  
  
  
  test dx, BUTTON_1
  jz .button1_done
  xor word [object+attributes+2 + bx], REFLECT_X
  .button1_done:
  
  test dx, BUTTON_2
  jz .button2_done
  xor word [object+attributes+2 + bx], REFLECT_Y
  .button2_done:
  
  
  
  call read_objects
  call draw_objects
  hlt
  jmp infinite_loop
  
;======================================================================
;======================================================================
;Interrupt Handlers
  
diverr_handler:
  iret
  
brk_handler:
  iret
  
nmi_handler:
  iret
  
int3_handler:
  iret
  
into_handler:
  iret
  
bound_handler:
  iret
  
undefinst_handler:
  iret
  
nococpu_handler:
  iret
  
sprbuf_handler:
  iret
  
raster_handler:
  iret
  
sound_handler:
  iret
  
cocpuerror_handler:
  iret
  
vblank_handler:
  iret

def_handler:
  pushall
  mov ds, ax, WORKRAM
  call update_controllers
  call update_bg_scroll
  call upload_bg_tiles
  call upload_sprites
  call upload_palettes
  popall
  iret
  
;======================================================================
;======================================================================
;Expects:
;  cx = number of bytes for the hex value
;  si = source address low word
;  di = destination address low word
;  ds = source address high word
;  es = destination address high word
;Destroys:
;  ax, cx
;  si, di

hex_to_string:
  cmp cl, 0
  jne .continue
  ret
  
.continue:  
  add si, cx
  dec si
  
.nibble1
  std					;set direction to backward
  lodsb					;get the byte to print
  cld					;set direction to forward
  mov ah, al			;make a copy of the byte
  rol al, 4				;the top nibble is now at the bottom
  
  and al, 0x0F
  cmp al, 0x0A			;check if the nibble is A through F
  jae .nibble_1_AF
  
  add al, 48
  jmp .nibble_1_next
  
.nibble_1_AF:
  add al, 55
  
.nibble_1_next:
  stosb
  
  
  
.nibble_0:
  mov al, ah
  and al, 0x0F
  cmp al, 0x0A			;check if the nibble is A through F
  jae .nibble_0_AF
  
  add al, 48
  jmp .nibble_0_next
  
.nibble_0_AF:
  add al, 55
  
.nibble_0_next:
  stosb
  dec cl
  jnz .nibble1
  
  xor al, al
  stosb					;store the terminating character at the end
  ret

;======================================================================
;======================================================================
;Expects:
;  ds = WORKRAM
;Destroys:
;  ax, dx

upload_sprites:
  mov word ax, [spritesRequested]
  mov ds, dx, VIDEO_HARDWARE_RAM
  
  cmp ah, 1							;see if all 256 sprites are used
  je .all_sprites_used
  
  neg al							;ax is now effectively 256 - spritesRequested
  mov word [spriteControl + 0], ax
  mov word [spriteControl + 4], 8	;8, so the number of sprites defined by spriteControl are uploaded
  mov word [spriteControl + 8], ax	;DMA spriteRam
  mov ds, ax, WORKRAM
  ret

.all_sprites_used:
  mov word [spriteControl + 4], 0	;not 8, so all sprites are uploaded
  mov word [spriteControl + 8], ax	;DMA spriteRam
  mov ds, ax, WORKRAM
  ret

;======================================================================
;======================================================================
;Expects:
;  ds = WORKRAM
;Destroys:
;  ax

update_bg_scroll:
  mov ax, [bg1XPosition]
  out BG1X, ax
  mov ax, [bg1YPosition]
  out BG1Y, ax
  mov ax, [bg2XPosition]
  out BG2X, ax
  mov ax, [bg2YPosition]
  out BG2Y, ax
  mov ax, [bg3XPosition]
  out BG3X, ax
  mov ax, [bg3YPosition]
  out BG3Y, ax
  ret
  
;======================================================================
;======================================================================
;Expects:
;  ds = WORKRAM
;Destroys:
;  ax, bx, cx, dx
;  si, di
;  es

upload_bg_tiles:
  cmp word [tileUploadOffset], 0
  je .done
  xor bx, bx
  mov es, dx, VRAM
  cld			;set transfer address to increment
  
  
  
.read_table_loop:
  mov ax, [tileUpload+uploadDimensions + bx]	;low byte is width, high byte is height
  mov dx, [tileUpload+rowOffset + bx]
  mov di, [tileUpload+vramAddress + bx]		
  mov si, [tileUpload+tileDataAddress+0 + bx]
  mov ds, cx, [tileUpload+tileDataAddress+2 + bx]
  rol al, 1		;because each tile is 2 words
  xor ch, ch	;we'll only ever be concerned with the bottom byte of cx
    
  .upload_loop
	mov cl, al
	rep movsw
	
	mov cl, al
	rol cx, 1	;convert the offset in words to bytes
	sub di, cx	;go back to the start position for the row
	add di, 256	;go to the next row (assumes 512*512 background)
	add si, dx	;add the offset to the source address
	dec ah		;reduce the height (loop control)
	jnz .upload_loop
  
  mov ds, dx, WORKRAM
  add bx, tileUploadStruct_size
  cmp bx, [tileUploadOffset]
  jl .read_table_loop
  
  
  
  mov word [tileUploadOffset], 0
.done:
  ret
  
;======================================================================
;======================================================================
;Expects:
;  ds = WORKRAM
;Destroys:
;  ax, dx

update_controllers:
  mov dx, [controller1]
  
  mov ah, 0
  in al, P1INPUT
  not al
  mov [controller1], ax
  
  xor dx, ax 					;detect what was changed
  and dx, ax					;this is done so releases aren't counted as presses 
  mov [controller1Press], dx
  
  
  
  mov dx, [controller2]
  
  mov ah, 0
  in al, P2INPUT
  not al
  mov [controller2], ax
  
  xor dx, ax 					;detect what was changed
  and dx, ax					;this is done so releases aren't counted as presses 
  mov [controller2Press], dx
  ret