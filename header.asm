;======================================================================
;Memory Map of the Program
;======================================================================

section ivt start=0x0000
  IVT				equ (section.ivt.start >> 4)
  
section code vstart=0
  CODE				equ (section.code.start >> 4)

section metasprite_types vstart=0 align=16
  METASPRITE_TYPES	equ (section.metasprite_types.start >> 4)
  
section metasprite vstart=0 align=16
  METASPRITE		equ (section.metasprite.start >> 4)
  
section palette_table vstart=0 align=16
  PALETTE_TABLE		equ (section.palette_table.start >> 4)
  
section data vstart=0 align=16
  DATA				equ (section.data.start >> 4)
  
  
;User defined sections go here:



;User defined sections end here
  
  
section reset start=0x7FFF0 vstart=0
  RESET				equ (section.reset.start >> 4)
  
segment bss start=0xE0000 vstart=0 nobits align=16
  BSS				equ (section.bss.start >> 4)

;======================================================================
;======================================================================
segment bss
;======================================================================
;======================================================================

;Define Variables:
  debug		resb 16
  temp		resb 16
  
  testBuffer	resb 64
  
  controller1			resw 1
  controller2			resw 1
  controller1Press		resw 1
  controller2Press		resw 1
  
  cameraXPosition		resw 1
  cameraYPosition		resw 1
  
  bg1XPosition			resw 1
  bg1YPosition			resw 1
  bg2XPosition			resw 1
  bg2YPosition			resw 1
  bg3XPosition			resw 1
  bg3YPosition			resw 1
  
  spritesRequested		resw 1
  tileUploadOffset		resw 1
  
  struc tileUploadStruct
    uploadDimensions	resb 2	;first byte is width, second byte is height
	rowOffset			resw 1
	vramAddress			resw 1
	tileDataAddress		resw 2
  endstruc
  tileUpload			resb tileUploadStruct_size * 64
  
  paletteUseageTable	resw 128
    UPDATE				equ 0x8000
    CONSTANT_UPDATE		equ 0x4000
  paletteLowWordTable	resw 128
  paletteHighWordTable	resw 128
  
  DYNAMIC_PALETTE_TABLE_SIZE	equ (dynamicPaletteTableROMEnd - dynamicPaletteTableROM)
  dynamicPaletteUseageTable		resb DYNAMIC_PALETTE_TABLE_SIZE
  dynamicPaletteNumberTable		resb DYNAMIC_PALETTE_TABLE_SIZE
  dynamicPaletteLowWordTable	resb DYNAMIC_PALETTE_TABLE_SIZE
  dynamicPaletteHighWordTable	resb DYNAMIC_PALETTE_TABLE_SIZE
  
  METASPRITE_JUMP_TABLE_SIZE	equ (metaspriteTypeTableEnd - metaspriteTypeTable)
  metaspriteJumpTable			resb METASPRITE_JUMP_TABLE_SIZE
  
  complexJumpTable	resw 4
  complexReflectXJumpTable	resw 4
  complexReflectYJumpTable	resw 4
  complexReflectYXJumpTable	resw 16
  
;======================================================================
  
  struc collisionStruct
	upperBound			resw 1
	lowerBound			resw 1
	leftBound			resw 1
	rightBound			resw 1
  endstruc
  
;======================================================================
  
  object: struc objectStruct
    identity			resw 1	;this must always be included
	metaspriteType		resb 1	;this must always be included
	
	xPosition			resb 3
    yPosition			resb 3
	metaspriteData		resw 2
	attributes			resw 2
	;Word 0:
	  ;only for "simple" metasprites (defined in metasprite data for others)
	  HEIGHT_16			equ 0x00
	  HEIGHT_32			equ 0x02
	  HEIGHT_64			equ 0x04
	  HEIGHT_128		equ 0x06
	  WIDTH_16			equ 0x00
	  WIDTH_32			equ 0x08
	  WIDTH_64			equ 0x10
	  WIDTH_128			equ 0x18
	  ;for all metasprites
	  LAYER				equ 0xE0
	;Word 1:
	  PALETTE			equ 0x007F
	  PRIORITY			equ 0x0080
	  REFLECT_X			equ 0x0100
	  REFLECT_Y			equ 0x0200
	  ABSOLUTE_POSITION	equ 0x0400
	
	hitbox		resb collisionStruct_size
	hurtbox		resb collisionStruct_size
  endstruc
  
  ;Declare object specific structs here
  struc stringStruct
	resb			hitbox	;include everything up to (but not including) this label
	valueSize		resw 1
	valueAddress	resw 2
	font			resw 1
	internalBuffer	resb 16
  endstruc
  ;Object specific structs end here
  
  ;yasm is particular about the order here, for some odd reason
  findlargest stringStruct_size, objectStruct_size
  
  OBJECT_SIZE		equ (largest + 1) / 2 * 2	;to ensure the struct is word aligned for performance
  NUMBER_OF_OBJECTS	equ 256
  resb NUMBER_OF_OBJECTS * OBJECT_SIZE
  
;======================================================================
  
;Define	Constants:
  TRUE				equ 1
  FALSE				equ 0
  
  ORIGIN_X			equ 96
  ORIGIN_Y			equ 136
  
  RIGHT_INPUT		equ 0x01
  LEFT_INPUT		equ 0x02
  DOWN_INPUT		equ 0x04
  UP_INPUT			equ 0x08
  BUTTON_1			equ 0x80
  BUTTON_2			equ 0x40
  BUTTON_3			equ 0x20
  P1_BUTTON_4		equ 0x02	;I think?
  P1_BUTTON_5		equ 0x04	;I think?
  P1_BUTTON_6		equ 0x08	;I think?
  P2_BUTTON_4		equ 0x20	;I think?
  P2_BUTTON_5		equ 0x40	;I think?
  P2_BUTTON_6		equ 0x80	;I think?
  
  STOP				equ 0xFFFF

;======================================================================
  
;Define	Video RAM and Hardware Registers:
  VRAM					equ 0xD000
  ;       FEDC BA98 7654 3210
  ;Word 0 tttt tttt tttt tttt
  ;Word 1       YXp plll llll
  ;		  X,Y - reflect X,Y
  ;		  t   - tile
  ;		  p   - priority
  ;		  l   - palette
	bg1Rowscroll		equ 0x0F400
	bg2Rowscroll		equ 0x0F800
	bg3Rowscroll		equ 0x0FC00
  
  WORKRAM				equ 0xE000
  
  VIDEO_HARDWARE_RAM	equ 0xF000
	spriteRam			equ 0x08000
	;       FEDC BA98 7654 3210
	;Word 0 LLLW WHHy yyyy yyyy
	;Word 1 tttt tttt tttt tttt
	;Word 2        YX plll llll
	;Word 3         x xxxx xxxx
	;		L   - layer
	;		W,H - width, height (0,1,2,3 = 1,2,4,8 16x16 tiles)
	;		X,Y - reflect X,Y
	;		x,y - x,y coordinate
	;		t   - tile
	;		p   - priority
	;		l   - palette
	paletteRam			equ 0x08800
	spriteControl		equ 0x09000
	;Offset 0: sprite list size	
	;Offset 4: sprite control
	;  When 0x08:			  DMA (256 - sprite list size) sprites as long as the sprite list size isn't 0 (otherwise DMA 0 sprites)
	;  When anything but 0x08: DMA all 256 sprites, regardless of sprite list size.
	;Offset 8: sprite dma
	;  Write any value here to DMA spriteRam.
	videoControl		equ 0x09800
	;Bit  0x02:	Current palette bank (all of paletteRam cannot be accessed at once)

;======================================================================
  
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
  ;Bit  0x40:	1 = Rowscroll enable, 0 = disable
  ;Bit  0x10:	0 = Playfield enable, 1 = disable
  ;Bit  0x04:	0 = 512 x 512 playfield, 1 = 1024 x 512 playfield
  ;Bits 0x03:	Playfield location in VRAM (0x0000, 0x4000, 0x8000, 0xc000)
  RASTERIRQ		equ 0x9E
  ;The raster IRQ position is offset by 128+8 from the first visible line

;======================================================================
;======================================================================
section reset
;======================================================================
;======================================================================

  cli
  jmp CODE:main
  
  times 16-($-$$) db 0

;======================================================================
;======================================================================
section ivt
;======================================================================
;======================================================================

ivt: 
  dw diverr_handler,		CODE
  dw brk_handler,			CODE
  dw nmi_handler,			CODE
  dw int3_handler,			CODE
  dw into_handler,			CODE
  dw bound_handler,			CODE
  dw undefinst_handler,		CODE
  dw nococpu_handler,		CODE
  dw vblank_handler,		CODE
  dw sprbuf_handler,		CODE
  dw raster_handler,		CODE
  dw sound_handler,			CODE
  dw def_handler,			CODE
  dw def_handler,			CODE
  dw def_handler,			CODE
  dw def_handler,			CODE
  dw cocpuerror_handler,	CODE
  dw def_handler,			CODE
  dw def_handler,			CODE
  dw def_handler,			CODE
  dw def_handler,			CODE
  dw def_handler,			CODE
  dw def_handler,			CODE
  dw def_handler,			CODE
  dw def_handler,			CODE
  dw def_handler,			CODE
  dw def_handler,			CODE
  dw def_handler,			CODE
  dw def_handler,			CODE
  dw def_handler,			CODE
  dw def_handler,			CODE
  dw def_handler,			CODE
  dw def_handler,			CODE
  dw vblank_handler,		CODE
  dw sprbuf_handler,		CODE
  dw raster_handler,		CODE
  dw sound_handler,			CODE
  dw def_handler,			CODE
  dw def_handler,			CODE
  dw def_handler,			CODE
  dw def_handler,			CODE
  dw def_handler,			CODE
  dw def_handler,			CODE
  dw def_handler,			CODE
  dw def_handler,			CODE
  dw def_handler,			CODE
  dw def_handler,			CODE
  dw def_handler,			CODE
  dw def_handler,			CODE
  dw def_handler,			CODE
  dw def_handler,			CODE
  dw def_handler,			CODE
  dw def_handler,			CODE
  dw def_handler,			CODE
  dw def_handler,			CODE
  dw def_handler,			CODE
  dw def_handler,			CODE
  dw def_handler,			CODE
  dw def_handler,			CODE
  dw def_handler,			CODE
  dw def_handler,			CODE
  dw def_handler,			CODE
  dw def_handler,			CODE
  dw def_handler,			CODE
  dw def_handler,			CODE
  dw def_handler,			CODE
  dw def_handler,			CODE
  dw def_handler,			CODE
  dw def_handler,			CODE
  dw def_handler,			CODE
  dw def_handler,			CODE
  dw def_handler,			CODE
  dw def_handler,			CODE
  dw def_handler,			CODE
  dw def_handler,			CODE
  dw def_handler,			CODE
  dw def_handler,			CODE
  dw def_handler,			CODE
  dw def_handler,			CODE
  dw def_handler,			CODE
  dw def_handler,			CODE
  dw def_handler,			CODE
  dw def_handler,			CODE
  dw def_handler,			CODE
  dw def_handler,			CODE
  dw def_handler,			CODE
  dw def_handler,			CODE
  dw def_handler,			CODE
  dw def_handler,			CODE
  dw def_handler,			CODE
  dw def_handler,			CODE
  dw def_handler,			CODE
  dw def_handler,			CODE
  dw def_handler,			CODE
  dw def_handler,			CODE
  dw def_handler,			CODE
  dw def_handler,			CODE
  dw def_handler,			CODE
  dw def_handler,			CODE
  dw def_handler,			CODE
  dw def_handler,			CODE
  dw def_handler,			CODE
  dw def_handler,			CODE
  dw def_handler,			CODE
  dw def_handler,			CODE
  dw def_handler,			CODE
  dw def_handler,			CODE
  dw def_handler,			CODE
  dw def_handler,			CODE
  dw def_handler,			CODE
  dw def_handler,			CODE
  dw def_handler,			CODE
  dw def_handler,			CODE
  dw def_handler,			CODE
  dw def_handler,			CODE
  dw def_handler,			CODE
  dw def_handler,			CODE
  dw def_handler,			CODE
  dw def_handler,			CODE
  dw def_handler,			CODE
  dw def_handler,			CODE
  dw def_handler,			CODE
  dw def_handler,			CODE
  dw def_handler,			CODE
  dw def_handler,			CODE
  dw def_handler,			CODE
  dw def_handler,			CODE
  dw def_handler,			CODE
  dw def_handler,			CODE
  dw def_handler,			CODE
  dw def_handler,			CODE
  dw def_handler,			CODE
  dw def_handler,			CODE
  dw def_handler,			CODE
  dw def_handler,			CODE
  dw def_handler,			CODE
  dw def_handler,			CODE
  dw def_handler,			CODE
  dw def_handler,			CODE
  dw def_handler,			CODE
  dw def_handler,			CODE
  dw def_handler,			CODE
  dw def_handler,			CODE
  dw def_handler,			CODE
  dw def_handler,			CODE
  dw def_handler,			CODE
  dw def_handler,			CODE
  dw def_handler,			CODE
  dw def_handler,			CODE
  dw def_handler,			CODE
  dw def_handler,			CODE
  dw def_handler,			CODE
  dw def_handler,			CODE
  dw def_handler,			CODE
  dw def_handler,			CODE
  dw def_handler,			CODE
  dw def_handler,			CODE
  dw def_handler,			CODE
  dw def_handler,			CODE
  dw def_handler,			CODE
  dw def_handler,			CODE
  dw def_handler,			CODE
  dw def_handler,			CODE
  dw def_handler,			CODE
  dw def_handler,			CODE
  dw def_handler,			CODE
  dw def_handler,			CODE
  dw def_handler,			CODE
  dw def_handler,			CODE
  dw def_handler,			CODE
  dw def_handler,			CODE
  dw def_handler,			CODE
  dw def_handler,			CODE
  dw def_handler,			CODE
  dw def_handler,			CODE
  dw def_handler,			CODE
  dw def_handler,			CODE
  dw def_handler,			CODE
  dw def_handler,			CODE
  dw def_handler,			CODE
  dw def_handler,			CODE
  dw def_handler,			CODE
  dw def_handler,			CODE
  dw def_handler,			CODE
  dw def_handler,			CODE
  dw def_handler,			CODE
  dw def_handler,			CODE
  dw def_handler,			CODE
  dw def_handler,			CODE
  dw def_handler,			CODE
  dw def_handler,			CODE
  dw def_handler,			CODE
  dw def_handler,			CODE
  dw def_handler,			CODE
  dw def_handler,			CODE
  dw def_handler,			CODE
  dw def_handler,			CODE
  dw def_handler,			CODE
  dw def_handler,			CODE
  dw def_handler,			CODE
  dw def_handler,			CODE
  dw def_handler,			CODE
  dw def_handler,			CODE
  dw def_handler,			CODE
  dw def_handler,			CODE
  dw def_handler,			CODE
  dw def_handler,			CODE
  dw def_handler,			CODE
  dw def_handler,			CODE
  dw def_handler,			CODE
  dw def_handler,			CODE
  dw def_handler,			CODE
  dw def_handler,			CODE
  dw def_handler,			CODE
  dw def_handler,			CODE
  dw def_handler,			CODE
  dw def_handler,			CODE
  dw def_handler,			CODE
  dw def_handler,			CODE
  dw def_handler,			CODE
  dw def_handler,			CODE
  dw def_handler,			CODE
  dw def_handler,			CODE
  dw def_handler,			CODE
  dw def_handler,			CODE
  dw def_handler,			CODE
  dw def_handler,			CODE
  dw def_handler,			CODE
  dw def_handler,			CODE
  dw def_handler,			CODE
  dw def_handler,			CODE
  dw def_handler,			CODE
  dw def_handler,			CODE
  dw def_handler,			CODE
  dw def_handler,			CODE
  dw def_handler,			CODE
  dw def_handler,			CODE
  dw def_handler,			CODE
  dw def_handler,			CODE
  dw def_handler,			CODE
  dw def_handler,			CODE
  dw def_handler,			CODE
  dw def_handler,			CODE
  dw def_handler,			CODE
  dw def_handler,			CODE
  dw def_handler,			CODE
  dw def_handler,			CODE
  dw def_handler,			CODE
  dw def_handler,			CODE
  dw def_handler,			CODE
  dw def_handler,			CODE
  dw def_handler,			CODE
  dw def_handler,			CODE
  dw def_handler,			CODE
  dw def_handler,			CODE
  dw def_handler,			CODE