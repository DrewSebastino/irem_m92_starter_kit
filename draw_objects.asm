;======================================================================
;======================================================================
section code
;======================================================================
;======================================================================
;Expects:
;  ds = WORKRAM
;Destroys:
;  ax, bx, cx, dx
;  si, di
;  es

draw_objects:
  mov es, ax, VIDEO_HARDWARE_RAM + (spriteRam >> 4)
  xor di, di
  xor bx, bx
  cld
  
draw_objects_loop:
  mov si, [object+metaspriteType + bx]
  jmp [metaspriteJumpTable + si]
  
draw_next_object:
  add bx, OBJECT_SIZE
  cmp bx, NUMBER_OF_OBJECTS * OBJECT_SIZE
  jl draw_objects_loop
  
done_drawing_objects:
  ror di, 3
  mov word [spritesRequested], di
  ret
  
;======================================================================
  
draw_none:
  jmp draw_next_object
  
;======================================================================
  
draw_simple:
  mov ax, [object+yPosition+1 + bx]
  mov cx, [object+xPosition+1 + bx]
  test word [object+attributes+2 + bx], ABSOLUTE_POSITION
  jne .absolute_position
  sub ax, [cameraYPosition]
  sub cx, [cameraXPosition]
.absolute_position:

  ;Sprite Word 0
  and ax, 0x01FF
  or ah, [object+attributes+0 + bx]
  stosw
  
  ;Sprite Word 1
  mov ax, [object+metaspriteData + bx]
  stosw
  
  ;Sprite Word 2
  mov ax, [object+attributes+2 + bx]
  stosw
  
  ;Sprite Word 3
  mov ax, cx
  stosw
  
  cmp di, 2048
  jl simple_draw_next_object
  jmp done_drawing_objects
  
simple_draw_next_object:
  jmp draw_next_object
  
;======================================================================
;======================================================================
  
draw_complex:
  mov cx, [object+xPosition+1 + bx]
  mov ax, [object+yPosition+1 + bx]

  mov dx, [object+attributes+2 + bx]
  test dx, ABSOLUTE_POSITION
  jne .absolute_position
  sub cx, [cameraXPosition]
  sub ax, [cameraYPosition]
  
.absolute_position:
  mov [temp+0], cx
  mov [temp+2], ax
  
;Use REFLECT_Y and REFLECT_X as an offset for a jump table
  mov si, [object+attributes+3 + bx]
  and si, (REFLECT_Y | REFLECT_X) >> 8
  rol si, 1
  jmp [complexJumpTable + si]
  
;======================================================================

complex_reflect_jmp_to_draw_next_object:
  mov ds, ax, WORKRAM
  jmp draw_next_object



complex_reflect:
  mov si, [object+metaspriteData + bx]
  add si, 4	;skip the data for width and height
  mov ds, dx, METASPRITE
  
.loop:
  lodsw
  cmp ax, STOP
  je complex_reflect_jmp_to_draw_next_object
  mov dx, ax
  lodsw
  mov cx, ax
  lodsw
  
  push WORKRAM
  pop ds
  add cx, [temp+0]	;sprite x position
  add ax, [temp+2]	;sprite y position
  and ax, 0x01FF
  or ax, [object+attributes+0 + bx]		;layer
  or ah, dl								;width and height
  ;Sprite Word 0
  stosw
  xor dl, dl
  xor dx, [object+attributes+2 + bx]	;reflect, priority, and palette
  mov ds, ax, METASPRITE				;back to metasprite data
  ;Sprite Word 1
  movsw
  ;Sprite Word 2
  mov ax, dx
  stosw
  ;Sprite Word 3
  mov ax, cx
  stosw
  
  cmp di, 2048
  jl .loop
  mov ds, ax, WORKRAM
  jmp done_drawing_objects
  
;======================================================================

complex_reflect_x_jmp_to_draw_next_object:
  mov ds, ax, WORKRAM
  jmp draw_next_object
  
  
  
complex_reflect_x:
  mov si, [object+metaspriteData + bx]
  mov ds, dx, METASPRITE
  lodsw
  mov ds, dx, WORKRAM
  add [temp+0], ax
  mov ds, dx, METASPRITE
  add si, 2	;skip the data for height
  
complex_reflect_x_loop:
  lodsw
  cmp ax, STOP
  je complex_reflect_x_jmp_to_draw_next_object
  mov dx, ax
  lodsw
  mov cx, ax
  lodsw
  
  push WORKRAM
  pop ds
  neg cx
  add cx, [temp+0]	;sprite x position
  add ax, [temp+2]	;sprite y position
  
  
  
;move the sprite down by its width
  mov [temp+4], bx
  mov bx, dx
  and bx, WIDTH_128
  ror bx, 2
  jmp [complexReflectXJumpTable + bx]
  
w16:
  sub cx, 16
  jmp complex_reflect_x_continue
  
w32:
  sub cx, 32
  jmp complex_reflect_x_continue
  
w64:
  sub cx, 64
  jmp complex_reflect_x_continue
  
w128:
  sub cx, 128
  jmp complex_reflect_x_continue
  
  
  
complex_reflect_x_continue:
  mov bx, [temp+4]
  and ax, 0x01FF
  or ax, [object+attributes+0 + bx]		;layer
  or ah, dl								;width and height
;Sprite Word 0
  stosw
  xor dl, dl
  xor dx, [object+attributes+2 + bx]	;reflect, priority, and palette
  mov ds, ax, METASPRITE				;back to metasprite data
;Sprite Word 1
  movsw
;Sprite Word 2
  mov ax, dx
  stosw
;Sprite Word 3
  mov ax, cx
  stosw
  
  cmp di, 2048
  jl complex_reflect_x_loop
  mov ds, ax, WORKRAM
  jmp done_drawing_objects
  
;======================================================================

complex_reflect_y_jmp_to_draw_next_object:
  mov ds, ax, WORKRAM
  jmp draw_next_object
  
  
  
complex_reflect_y:
  mov si, [object+metaspriteData + bx]
  add si, 2	;skip the data for width
  mov ds, dx, METASPRITE
  lodsw
  mov ds, dx, WORKRAM
  add [temp+2], ax
  mov ds, dx, METASPRITE
  
complex_reflect_y_loop:
  lodsw
  cmp ax, STOP
  je complex_reflect_y_jmp_to_draw_next_object
  mov dx, ax
  lodsw
  mov cx, ax
  lodsw
  
  push WORKRAM
  pop ds
  add cx, [temp+0]	;sprite x position
  neg ax
  add ax, [temp+2]	;sprite y position
  
  
  
;move the sprite down by its height
  mov [temp+4], bx
  mov bx, dx
  and bx, HEIGHT_128
  jmp [complexReflectYJumpTable + bx]
  
h16:
  sub ax, 16
  jmp complex_reflect_y_continue
  
h32:
  sub ax, 32
  jmp complex_reflect_y_continue
  
h64:
  sub ax, 64
  jmp complex_reflect_y_continue
  
h128:
  sub ax, 128
  jmp complex_reflect_y_continue
  
  
  
complex_reflect_y_continue:
  mov bx, [temp+4]
  and ax, 0x01FF
  or ax, [object+attributes+0 + bx]		;layer
  or ah, dl								;width and height
;Sprite Word 0
  stosw
  xor dl, dl
  xor dx, [object+attributes+2 + bx]	;reflect, priority, and palette
  mov ds, ax, METASPRITE				;back to metasprite data
;Sprite Word 1
  movsw
;Sprite Word 2
  mov ax, dx
  stosw
;Sprite Word 3
  mov ax, cx
  stosw
  
  cmp di, 2048
  jl complex_reflect_y_loop
  mov ds, ax, WORKRAM
  jmp done_drawing_objects

;======================================================================

complex_reflect_y_x_jmp_to_draw_next_object:
  mov ds, ax, WORKRAM
  jmp draw_next_object
  
  

complex_reflect_y_x:
  mov si, [object+metaspriteData + bx]
  mov ds, dx, METASPRITE
  lodsw
  mov cx, ax
  lodsw
  mov ds, dx, WORKRAM
  add [temp+0], cx
  add [temp+2], ax
  mov ds, dx, METASPRITE
  
complex_reflect_y_x_loop:
  lodsw
  cmp ax, STOP
  je complex_reflect_y_x_jmp_to_draw_next_object
  mov dx, ax
  lodsw
  mov cx, ax
  lodsw
  
  push WORKRAM
  pop ds
  neg cx
  add cx, [temp+0]	;sprite x position
  neg ax
  add ax, [temp+2]	;sprite y position
  
  

;move the sprite down by its height and left by its width
  mov [temp+4], bx
  mov bx, dx
  xor bh, bh
  jmp [complexReflectYXJumpTable + bx]
  
w16h16:
  sub cx, 16
  sub ax, 16
  jmp complex_reflect_y_x_continue
  
w16h32:
  sub cx, 16
  sub ax, 32
  jmp complex_reflect_y_x_continue
  
w16h64:
  sub cx, 16
  sub ax, 64
  jmp complex_reflect_y_x_continue
  
w16h128:
  sub cx, 16
  sub ax, 128
  jmp complex_reflect_y_x_continue
  
w32h16:
  sub cx, 32
  sub ax, 16
  jmp complex_reflect_y_x_continue
  
w32h32:
  sub cx, 32
  sub ax, 32
  jmp complex_reflect_y_x_continue
  
w32h64:
  sub cx, 32
  sub ax, 64
  jmp complex_reflect_y_x_continue
  
w32h128:
  sub cx, 32
  sub ax, 128
  jmp complex_reflect_y_x_continue
  
w64h16:
  sub cx, 64
  sub ax, 16
  jmp complex_reflect_y_x_continue
  
w64h32:
  sub cx, 64
  sub ax, 32
  jmp complex_reflect_y_x_continue
  
w64h64:
  sub cx, 64
  sub ax, 64
  jmp complex_reflect_y_x_continue
  
w64h128:
  sub cx, 64
  sub ax, 128
  jmp complex_reflect_y_x_continue
  
w128h16:
  sub cx, 128
  sub ax, 16
  jmp complex_reflect_y_x_continue
  
w128h32:
  sub cx, 128
  sub ax, 32
  jmp complex_reflect_y_x_continue
  
w128h64:
  sub cx, 128
  sub ax, 64
  jmp complex_reflect_y_x_continue
  
w128h128:
  sub cx, 128
  sub ax, 128
  jmp complex_reflect_y_x_continue
  
  
  
complex_reflect_y_x_continue:
  mov bx, [temp+4]
  and ax, 0x01FF
  or ax, [object+attributes+0 + bx]		;layer
  or ah, dl								;width and height
;Sprite Word 0
  stosw
  xor dl, dl
  xor dx, [object+attributes+2 + bx]	;reflect, priority, and palette
  mov ds, ax, METASPRITE				;back to metasprite data
;Sprite Word 1
  movsw
;Sprite Word 2
  mov ax, dx
  stosw
;Sprite Word 3
  mov ax, cx
  stosw
  
  cmp di, 2048
  jl jmp_to_complex_reflect_y_x_loop
  mov ds, ax, WORKRAM
  jmp done_drawing_objects
  
jmp_to_complex_reflect_y_x_loop:
  jmp complex_reflect_y_x_loop

;======================================================================
;======================================================================
  
draw_string:
;Sprite Word 0
  mov ax, [object+yPosition+1 + bx]
;Sprite Word 3 
  mov cx, [object+xPosition+1 + bx]
  
  test word [object+attributes+2 + bx], ABSOLUTE_POSITION
  jne .continue1
    sub ax, [cameraYPosition]
    sub cx, [cameraXPosition]
  .continue1:
  
  and ax, 0x01FF
  or ax, [object+attributes + bx]
  mov [temp+0], ax
  
;Sprite Word 1
  mov [temp+2], ax, [object+font + bx]  
;Sprite Word 2
  mov [temp+4], ax, [object+attributes+2 + bx]
  
  mov si, [object+metaspriteData+0 + bx]
  cld
  
.loop:
  mov ds, dx, [object+metaspriteData+2 + bx]
  xor ax, ax
  lodsb
  mov ds, dx, WORKRAM
  
  cmp ax, 0
  jne .continue2
    jmp draw_next_object
  .continue2:

  sub ax, 32	;because ASCII characters start at 32
  jnz .not_space
  add cx, 8
  jmp .loop

.not_space:
  mov dx, ax
  mov ax, [temp+0]
  stosw	;[spriteRam + 0]
  
  add dx, [temp+2]
  mov ax, dx
  stosw	;[spriteRam + 2]
  
  mov ax, [temp+4]
  stosw	;[spriteRam + 4]
  
  mov ax, cx
  stosw	;[spriteRam + 6]
  add cx, 8
  
  cmp di, 2048
  jl .loop
  jmp done_drawing_objects