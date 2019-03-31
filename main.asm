;======================================================================
;Section IVT
;======================================================================

cpu 80186

section ivt start=0
IVT_START	equ (section.ivt.start >> 4)

ivt: 
  dw diverr_handler, CODE_START
  dw brk_handler, CODE_START
  dw nmi_handler, CODE_START
  dw int3_handler, CODE_START
  dw into_handler, CODE_START
  dw bound_handler, CODE_START
  dw undefinst_handler, CODE_START
  dw nocoprocessor_handler, CODE_START
  dw vbl_handler, CODE_START
  dw sprbuf_handler, CODE_START
  dw raster_handler, CODE_START
  dw sound_handler, CODE_START
  dw def_handler, CODE_START
  dw def_handler, CODE_START
  dw def_handler, CODE_START
  dw def_handler, CODE_START
  dw coprocessorerror_handler, CODE_START
  dw def_handler, CODE_START
  dw def_handler, CODE_START
  dw def_handler, CODE_START
  dw def_handler, CODE_START
  dw def_handler, CODE_START
  dw def_handler, CODE_START
  dw def_handler, CODE_START
  dw def_handler, CODE_START
  dw def_handler, CODE_START
  dw def_handler, CODE_START
  dw def_handler, CODE_START
  dw def_handler, CODE_START
  dw def_handler, CODE_START
  dw def_handler, CODE_START
  dw def_handler, CODE_START
  dw def_handler, CODE_START
  dw vbl_handler, CODE_START
  dw sprbuf_handler, CODE_START
  dw raster_handler, CODE_START
  dw sound_handler, CODE_START
  dw def_handler, CODE_START
  dw def_handler, CODE_START
  dw def_handler, CODE_START
  dw def_handler, CODE_START
  dw def_handler, CODE_START
  dw def_handler, CODE_START
  dw def_handler, CODE_START
  dw def_handler, CODE_START
  dw def_handler, CODE_START
  dw def_handler, CODE_START
  dw def_handler, CODE_START
  dw def_handler, CODE_START
  dw def_handler, CODE_START
  dw def_handler, CODE_START
  dw def_handler, CODE_START
  dw def_handler, CODE_START
  dw def_handler, CODE_START
  dw def_handler, CODE_START
  dw def_handler, CODE_START
  dw def_handler, CODE_START
  dw def_handler, CODE_START
  dw def_handler, CODE_START
  dw def_handler, CODE_START
  dw def_handler, CODE_START
  dw def_handler, CODE_START
  dw def_handler, CODE_START
  dw def_handler, CODE_START
  dw def_handler, CODE_START
  dw def_handler, CODE_START
  dw def_handler, CODE_START
  dw def_handler, CODE_START
  dw def_handler, CODE_START
  dw def_handler, CODE_START
  dw def_handler, CODE_START
  dw def_handler, CODE_START
  dw def_handler, CODE_START
  dw def_handler, CODE_START
  dw def_handler, CODE_START
  dw def_handler, CODE_START
  dw def_handler, CODE_START
  dw def_handler, CODE_START
  dw def_handler, CODE_START
  dw def_handler, CODE_START
  dw def_handler, CODE_START
  dw def_handler, CODE_START
  dw def_handler, CODE_START
  dw def_handler, CODE_START
  dw def_handler, CODE_START
  dw def_handler, CODE_START
  dw def_handler, CODE_START
  dw def_handler, CODE_START
  dw def_handler, CODE_START
  dw def_handler, CODE_START
  dw def_handler, CODE_START
  dw def_handler, CODE_START
  dw def_handler, CODE_START
  dw def_handler, CODE_START
  dw def_handler, CODE_START
  dw def_handler, CODE_START
  dw def_handler, CODE_START
  dw def_handler, CODE_START
  dw def_handler, CODE_START
  dw def_handler, CODE_START
  dw def_handler, CODE_START
  dw def_handler, CODE_START
  dw def_handler, CODE_START
  dw def_handler, CODE_START
  dw def_handler, CODE_START
  dw def_handler, CODE_START
  dw def_handler, CODE_START
  dw def_handler, CODE_START
  dw def_handler, CODE_START
  dw def_handler, CODE_START
  dw def_handler, CODE_START
  dw def_handler, CODE_START
  dw def_handler, CODE_START
  dw def_handler, CODE_START
  dw def_handler, CODE_START
  dw def_handler, CODE_START
  dw def_handler, CODE_START
  dw def_handler, CODE_START
  dw def_handler, CODE_START
  dw def_handler, CODE_START
  dw def_handler, CODE_START
  dw def_handler, CODE_START
  dw def_handler, CODE_START
  dw def_handler, CODE_START
  dw def_handler, CODE_START
  dw def_handler, CODE_START
  dw def_handler, CODE_START
  dw def_handler, CODE_START
  dw def_handler, CODE_START
  dw def_handler, CODE_START
  dw def_handler, CODE_START
  dw def_handler, CODE_START
  dw def_handler, CODE_START
  dw def_handler, CODE_START
  dw def_handler, CODE_START
  dw def_handler, CODE_START
  dw def_handler, CODE_START
  dw def_handler, CODE_START
  dw def_handler, CODE_START
  dw def_handler, CODE_START
  dw def_handler, CODE_START
  dw def_handler, CODE_START
  dw def_handler, CODE_START
  dw def_handler, CODE_START
  dw def_handler, CODE_START
  dw def_handler, CODE_START
  dw def_handler, CODE_START
  dw def_handler, CODE_START
  dw def_handler, CODE_START
  dw def_handler, CODE_START
  dw def_handler, CODE_START
  dw def_handler, CODE_START
  dw def_handler, CODE_START
  dw def_handler, CODE_START
  dw def_handler, CODE_START
  dw def_handler, CODE_START
  dw def_handler, CODE_START
  dw def_handler, CODE_START
  dw def_handler, CODE_START
  dw def_handler, CODE_START
  dw def_handler, CODE_START
  dw def_handler, CODE_START
  dw def_handler, CODE_START
  dw def_handler, CODE_START
  dw def_handler, CODE_START
  dw def_handler, CODE_START
  dw def_handler, CODE_START
  dw def_handler, CODE_START
  dw def_handler, CODE_START
  dw def_handler, CODE_START
  dw def_handler, CODE_START
  dw def_handler, CODE_START
  dw def_handler, CODE_START
  dw def_handler, CODE_START
  dw def_handler, CODE_START
  dw def_handler, CODE_START
  dw def_handler, CODE_START
  dw def_handler, CODE_START
  dw def_handler, CODE_START
  dw def_handler, CODE_START
  dw def_handler, CODE_START
  dw def_handler, CODE_START
  dw def_handler, CODE_START
  dw def_handler, CODE_START
  dw def_handler, CODE_START
  dw def_handler, CODE_START
  dw def_handler, CODE_START
  dw def_handler, CODE_START
  dw def_handler, CODE_START
  dw def_handler, CODE_START
  dw def_handler, CODE_START
  dw def_handler, CODE_START
  dw def_handler, CODE_START
  dw def_handler, CODE_START
  dw def_handler, CODE_START
  dw def_handler, CODE_START
  dw def_handler, CODE_START
  dw def_handler, CODE_START
  dw def_handler, CODE_START
  dw def_handler, CODE_START
  dw def_handler, CODE_START
  dw def_handler, CODE_START
  dw def_handler, CODE_START
  dw def_handler, CODE_START
  dw def_handler, CODE_START
  dw def_handler, CODE_START
  dw def_handler, CODE_START
  dw def_handler, CODE_START
  dw def_handler, CODE_START
  dw def_handler, CODE_START
  dw def_handler, CODE_START
  dw def_handler, CODE_START
  dw def_handler, CODE_START
  dw def_handler, CODE_START
  dw def_handler, CODE_START
  dw def_handler, CODE_START
  dw def_handler, CODE_START
  dw def_handler, CODE_START
  dw def_handler, CODE_START
  dw def_handler, CODE_START
  dw def_handler, CODE_START
  dw def_handler, CODE_START
  dw def_handler, CODE_START
  dw def_handler, CODE_START
  dw def_handler, CODE_START
  dw def_handler, CODE_START
  dw def_handler, CODE_START
  dw def_handler, CODE_START
  dw def_handler, CODE_START
  dw def_handler, CODE_START
  dw def_handler, CODE_START
  dw def_handler, CODE_START
  dw def_handler, CODE_START
  dw def_handler, CODE_START
  dw def_handler, CODE_START
  dw def_handler, CODE_START
  dw def_handler, CODE_START
  dw def_handler, CODE_START
  dw def_handler, CODE_START
  dw def_handler, CODE_START
  dw def_handler, CODE_START
  dw def_handler, CODE_START
  dw def_handler, CODE_START
  dw def_handler, CODE_START
  dw def_handler, CODE_START
  dw def_handler, CODE_START
  dw def_handler, CODE_START
  dw def_handler, CODE_START
  dw def_handler, CODE_START
  dw def_handler, CODE_START
  dw def_handler, CODE_START
  dw def_handler, CODE_START
  dw def_handler, CODE_START
  dw def_handler, CODE_START
  dw def_handler, CODE_START
  dw def_handler, CODE_START

;======================================================================
;Section Code
;======================================================================

section code vstart=0 align=16
CODE_START	equ (section.code.start >> 4)

def_handler:
  iret

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

nocoprocessor_handler:
  iret

vbl_handler:
  iret

sprbuf_handler:
  iret

raster_handler:
  iret

sound_handler:
  iret

coprocessorerror_handler:
  iret

;======================================================================

start:
;Set Stack Location
  mov sp, BSS_START
  mov ss, sp
  xor sp, sp
  
;Set Up Interrupt Controller (This is exactly what Gunforce II writes)
  mov al, 0x17
  out 0x40, al
  mov al, 0x20
  out 0x42, al
  mov al, 0x0F
  out 0x42, al
  mov al, 0x08
  out 0x42, al

;Enable Sprites
  mov ax, VIDEO_HARDWARE_RAM_START
  mov ds, ax
  mov word [spriteRam + 0x100], 0x0100
  mov word [spriteRam + 0x102], 0x0001
  mov word [spriteRam + 0x104], 0x0000
  mov word [spriteRam + 0x106], 0x0100
  xor ax, ax
  mov word [spriteControlRam + 0], ax	;sets up DMA
  mov word [spriteControlRam + 4], ax	;sets up DMA
  mov word [spriteControlRam + 8], ax	;DMA spriteRam

;Set Up BGs
  mov al, 0x00
  out BG1CONTROL, al
  mov al, 0x11
  out BG2CONTROL, al
  mov al, 0x12
  out BG3CONTROL, al
  
  mov ax, 0x0000
  out BG1X, ax
  mov ax, 0x0000
  out BG1Y, ax

;Write Tile
  mov ax, VRAM_START
  mov ds, ax
  mov word [0x0000], 0x0001

;Upload Palette
  mov dx, WORKRAM_START
  mov ds, dx
  mov word [palettesRequested], 2
  mov word [paletteRequestTable + PALETTE_SOURCE], PALETTE1
  mov word [paletteRequestTable + PALETTE_DESTINATION], 0x0000
  mov word [paletteRequestTable + PALETTE_SOURCE + 4], PALETTE1
  mov word [paletteRequestTable + PALETTE_DESTINATION + 4], 0x0040
  call upload_palette
  sti				;Enable Interupts
  
;Horrible demo for demonstrating that interrupts now work (scrolls BG1)
infinite_loop:
  mov dx, WORKRAM_START
  mov ds, dx
  
  mov ax, [bg1XPosition]
  out BG1X, ax
  mov ax, [bg1XPosition]
  out BG1X, ax
  mov ax, [bg1YPosition]
  out BG1Y, ax
  mov ax, [bg1YPosition]
  out BG1Y, ax
  
  inc word [bg1XPosition]
  inc word [bg1YPosition]
  inc word [bg1YPosition]
  
  hlt
  jmp infinite_loop

  ;mov dx, WORKRAM_START
  ;mov ds, dx
  ;in  ax, P1INPUT
  ;and ax, byte RIGHT_INPUT
  ;jnz check_left
  ;inc word [bg1XPosition]
  ;mov ax, [bg1XPosition]
  ;out BG1X, ax

;check_left:
  ;in  ax, P1INPUT
  ;and ax, byte LEFT_INPUT
  ;jnz check_down
  ;dec word [bg1XPosition]
  ;mov ax, [bg1XPosition]
  ;out BG1X, ax

;check_down:
  ;in  ax, P1INPUT
  ;and ax, byte DOWN_INPUT
  ;jnz check_up
  ;inc word [bg1YPosition]
  ;mov ax, [bg1YPosition]
  ;out BG1Y, ax

;check_up:
  ;in  ax, P1INPUT
  ;and ax, byte UP_INPUT
  ;jnz done
  ;dec word [bg1YPosition]
  ;mov ax, [bg1YPosition]
  ;out BG1Y, ax

;======================================================================
;Modifies: ax, bx, cx, dx, si, di, ds, es

upload_palette:
  mov dx, WORKRAM_START
  mov ds, dx
  mov ax, [palettesRequested]
  cmp ax, 0
  jz upload_palette_done
  
  mov word [palettesRequested], 0
  mov cx, VIDEO_HARDWARE_RAM_START + (paletteRam >> 4)
  mov es, cx
  mov bx, paletteRequestTable
  jmp upload_palette_first_loop
  
  
  
upload_palette_loop:
  mov ds, dx		;dx is WORKRAM_START
  add bx, word PALETTE_REQUEST_SLOT_SIZE
  
upload_palette_first_loop:
  mov di, [bx + PALETTE_DESTINATION]
  mov ds, [bx + PALETTE_SOURCE]			;WARNING: must come after loading PALETTE_DESTINATION
  
  mov si, 0
  mov cx, 16
  cld
  rep movsw
  
  dec ax
  jnz upload_palette_loop
  
upload_palette_done:
  ret

;======================================================================
;Color Palettes
;======================================================================

section palette1 vstart=0 align=16
PALETTE1	equ (section.palette1.start >> 4)
incbin "palettes\palette1.bin"

;======================================================================
;Section Reset
;======================================================================

section reset start=0x7FFF0 vstart=0
RESET_START	equ (section.reset.start >> 4)

  cli
  jmp CODE_START:start
  
  times 16-($-$$) db 0

;======================================================================
;Section RAM
;======================================================================

segment bss start=0xE0000 vstart=0 nobits align=16
BSS_START	equ (section.bss.start >> 4)

;Define Variables:
  bg1XPosition			resb 2
  bg1YPosition			resb 2
  palettesRequested		resb 2
  
  PALETTE_REQUEST_SLOT_SIZE		equ 4
  PALETTE_SOURCE				equ 0
  PALETTE_DESTINATION			equ 2
  
  PALETTE_REQUEST_TABLE_SIZE	equ (PALETTE_REQUEST_SLOT_SIZE * 128)
  paletteRequestTable			resb PALETTE_REQUEST_TABLE_SIZE
  
;Define	Values:
  SCREEN_WivtH 		equ 320
  SCREEN_HEIGHT 	equ 240

  RIGHT_INPUT		equ 0x01
  LEFT_INPUT		equ 0x02
  DOWN_INPUT		equ 0x04
  UP_INPUT			equ 0x08
  BUTTON_1			equ 0x20
  BUTTON_2			equ 0x40
  BUTTON_3			equ 0x80
  
  P1_BUTTON_4		equ 0x20
  P1_BUTTON_5		equ 0x40
  P1_BUTTON_6		equ 0x80
  
  P2_BUTTON_1		equ 0x20
  P2_BUTTON_2		equ 0x40
  P2_BUTTON_3		equ 0x80

  VRAM_START		equ 0xD000
	bg1Rowscroll	equ 0xF400
	bg2Rowscroll	equ 0xF800
	bg3Rowscroll	equ 0xFC00
  
  WORKRAM_START		equ 0xE000
  
  VIDEO_HARDWARE_RAM_START	equ 0xF000
	spriteRam				equ 0x8000
	;       FEDC BA98 7654 3210
	;Word 0 LLLW WHHy yyyy yyyy
	;Word 1 tttt tttt tttt tttt
	;Word 2        YX plll llll
	;Word 3         x xxxx xxxx
	;
	;		L	- layer
	;		W,H	- wivth, height (0,1,2,3 = 1,2,4,8 16x16 tiles)
	;		X,Y	- reflect X,Y
	;		x,y	- x,y coordinate
	;		t	- tile
	;		p	- priority
	;		l	- color
	paletteRam			equ 0x8800
	spriteControlRam	equ 0x9000
	;Offset 0: sprite list size	
	;Offset 2: sprite control
	;	When 0x08:				DMA (256 - sprite list size) sprites as long as sprite list size != 0 (otherwise DMA 0 sprites)
	;	When anything but 0x08:	DMA all 256 sprites, regardless of sprite list size.
	;Offset 4: sprite dma
	;	Write any value here to DMA spriteRam.

;Define Read Ports
  P1INPUT 		equ 0x00
  P2INPUT 		equ 0x01
  COINS			equ 0x02
  DIP3			equ 0x03
  DIP2			equ 0x04
  DIP1			equ 0x05
  P3INPUT		equ 0x06
  P4INPUT		equ 0x07

;Define Write Ports
  BG1Y			equ 0x80
  BG1X			equ 0x84
  BG2Y			equ 0x88
  BG2X			equ 0x8C
  BG3Y			equ 0x90
  BG3X			equ 0x94
  BG1CONTROL	equ 0x98
  BG2CONTROL	equ 0x9A
  BG3CONTROL	equ 0x9C
  ;Bit  0x40:		1 = Rowscroll enable, 0 = disable
  ;Bit  0x10:		0 = Playfield enable, 1 = disable
  ;Bit  0x04:		0 = 512 x 512 playfield, 1 = 1024 x 512 playfield
  ;Bits 0x03:		Playfield location in VRAM (0, 0x4000, 0x8000, 0xc000)