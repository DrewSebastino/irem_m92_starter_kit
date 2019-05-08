;======================================================================
;======================================================================
section metasprite_types
;======================================================================
;======================================================================
  
metaspriteTypeTable:
  NONE		dw draw_none
  SIMPLE	dw draw_simple
  COMPLEX	dw draw_complex
  STRING	dw draw_string
metaspriteTypeTableEnd:
  
;======================================================================
;======================================================================
section metasprite
;======================================================================
;======================================================================
  
metasprite1:
  dw 24, 16		;metasprite visual width and height (for flipping)
  
  dw WIDTH_16 | HEIGHT_16	;sprite attributes	____ __XY ___W WHH_
  dw 0, 8					;sprite x and y offsets
  dw 'A'-32					;sprite tile number
  
  dw REFLECT_X | WIDTH_16 | HEIGHT_16
  dw 0, 8
  dw 'B'-32
  
  dw WIDTH_16 | HEIGHT_16
  dw 16, 8
  dw 'C'-32
  
  dw WIDTH_16 | HEIGHT_16
  dw 12, 0
  dw 'D'-32
  
  dw STOP
  
;======================================================================
;======================================================================
section palette_table
;======================================================================
;======================================================================
  
dynamicPaletteTableROM:
  Palette1	dw palette1
  Palette2	dw palette2
  Palette3	dw palette3
  Palette4	dw palette4
dynamicPaletteTableROMEnd:

;======================================================================
;======================================================================
section data
;======================================================================
;======================================================================

palette1: incbin "palettes\palette1.bin"
palette2: incbin "palettes\palette2.bin"
palette3: incbin "palettes\palette3.bin"
palette4: incbin "palettes\palette4.bin"

Cam: db 'Cam', 0
X: db 'X:', 0
Y: db 'Y:', 0
Hello_World: db 'Hello World', 0
exception: db 'y % 256 is 0', 0

complexJumpTableROM:				dw complex_reflect, complex_reflect_x, complex_reflect_y, complex_reflect_y_x
complexReflectXJumpTableROM:		dw w16, w32, w64, w128
complexReflectYJumpTableROM:		dw h16, h32, h64, h128
complexReflectYXJumpTableROM:		dw w16h16,  w16h32,  w16h64,  w16h128
									dw w32h16,  w32h32,  w32h64,  w32h128
									dw w64h16,  w64h32,  w64h64,  w64h128
									dw w128h16, w128h32, w128h64, w128h128