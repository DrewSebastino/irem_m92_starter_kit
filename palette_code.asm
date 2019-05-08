;======================================================================
;======================================================================
section code
;======================================================================
;======================================================================
;Destroys:
;  ax, bx, cx, dx
;  si, di
;  es

upload_palettes:
  push ds
  mov es, ax, VIDEO_HARDWARE_RAM + (paletteRam >> 4)
  mov ax, WORKRAM
  xor bx, bx
  xor di, di
  mov dx, 128
  cld			;set the source address to increase
  ;Start at the first palette bank
  mov ds, cx, VIDEO_HARDWARE_RAM
  mov byte [videoControl], 0x00
  
.loop:
  mov ds, ax	;WORKMRAM
  test word [paletteUseageTable + bx], UPDATE | CONSTANT_UPDATE
  jz .next_palette
  mov word [paletteUseageTable + bx], ~UPDATE	;clear the request
  
  mov si, [paletteLowWordTable + bx]
  mov ds, cx, [paletteHighWordTable + bx]
  mov cx, 16	;transfer 16 words
  rep movsw
  add bx, 2
  cmp bx, dx	;64 palettes
  jne .loop
  jmp .next_palette_bank
  
.next_palette:
  add di, 32	;the size of 1 palette in bytes
  add bx, 2
  cmp bx, dx	;64 palettes
  jne .loop
  
.next_palette_bank
  cmp dx, 256
  je .done
  xor di, di	;reset the pointer for paletteRam
  ;Move to the next bank
  add dx, 128
  mov ds, cx, VIDEO_HARDWARE_RAM
  mov byte [videoControl], 0x02
  jmp .loop
  
.done:
  pop ds
  ret
  
;======================================================================
;======================================================================
;Expects:
;  ds = WORKRAM
;Destroys:
;  ax, cx, dx
;  si, di
;  es
  
initialize_dynamic_palette_table:
  mov es, dx, ds
  mov ds, ax, PALETTE_TABLE
  mov di, dynamicPaletteLowWordTable
  xor si, si
  cld
  
  mov cx, (DYNAMIC_PALETTE_TABLE_SIZE / 2)
  
  rep movsw		;dynamicPaletteLowWordTable
  
  mov cx, (DYNAMIC_PALETTE_TABLE_SIZE / 2)
  mov ax, DATA
  
  rep stosw		;dynamicPaletteHighWordTable
  
  mov ds, dx
  ret
  
;======================================================================
;======================================================================
;Expects:
;  si = requested dynamic palette (offset of dynamicPaletteTable)
;  ds = WORKRAM
;Destroys:
;  ax, cx, dx
;  di
;  es
;Returns:
;  cx = sprite palette number
  
allocate_palette:
  inc word [dynamicPaletteUseageTable + si]
  cmp word [dynamicPaletteUseageTable + si], 1
  je .first_object_using
  mov cx, [dynamicPaletteNumberTable + si]
  ret
  
.first_object_using
  push bx				;preserve the offset of the object calling this function
  
  mov es, ax, ds		;WORKRAM
  mov bx, [dynamicPaletteLowWordTable + si]
  mov dx, [dynamicPaletteHighWordTable + si]
  
  mov di, paletteUseageTable + 254	;start from the top
  std
  xor ax, ax						;for compaing with 0
  mov cx, 128
  repne scasw			;loop until the first empty palette is found
  mov di, cx
  rol di, 1
  
  mov word [paletteUseageTable + di], UPDATE | 1	;palette has one object and needs to be uploaded
  mov [paletteLowWordTable + di], bx
  mov [paletteHighWordTable + di], dx
  mov [dynamicPaletteNumberTable + si], cx
  
  pop bx
  ret
  
;======================================================================
;======================================================================
;Expects:
;  si = requested dynamic palette (offset of dynamicPaletteTable)
;  ds = WORKRAM
;Destroys:
;  si
  
deallocate_palette:
  dec word [dynamicPaletteUseageTable + si]
  jz .no_objects_using
  ret
  
.no_objects_using
  mov si, [dynamicPaletteNumberTable + si]
  rol si, 1
  mov word [paletteUseageTable + si], 0
  ret