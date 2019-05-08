;======================================================================
;======================================================================
section code
;======================================================================
;======================================================================
;Expects:
;  ds = WORKRAM
;Destroys:
;  ax, bx, cx
  
initialize_objects:
  xor bx, bx
  
.loop
  mov word [object+identity + bx], empty_object
  add bx, OBJECT_SIZE
  cmp bx, NUMBER_OF_OBJECTS * OBJECT_SIZE
  jne .loop
  
  
  
;Copy the various jump tables to RAM
  mov ax, ds
  mov es, di, WORKRAM
  cld
  
;Table 1
  mov di, metaspriteJumpTable
  mov ds, si, METASPRITE_TYPES
  xor si, si
  mov cx, METASPRITE_JUMP_TABLE_SIZE / 2
  rep movsw
  
;Table 2
  mov di, complexJumpTable
  mov ds, si, DATA
  mov si, complexJumpTableROM
  movsw
  movsw
  movsw
  movsw
  
;Table 3
  mov di, complexReflectXJumpTable
  mov ds, si, DATA
  mov si, complexReflectXJumpTableROM
  movsw
  movsw
  movsw
  movsw
  
;Table 4
  mov di, complexReflectYJumpTable
  mov ds, si, DATA
  mov si, complexReflectYJumpTableROM
  movsw
  movsw
  movsw
  movsw
  
;Table 5
  mov di, complexReflectYXJumpTable
  mov ds, si, DATA
  mov si, complexReflectYXJumpTableROM
  mov cx, 16
  rep movsw
  
  mov ds, ax
  ret
  
;======================================================================
;======================================================================
;Expects:
;  ax = requested object identity
;  si = starting index
;  ds = WORKRAM
;Returns:
;  si = index of object if found (greater than or equal to NUMBER_OF_OBJECTS * OBJECT_SIZE if not found)
  
find_object_forwards:
  cmp ax, [object+identity + si]
  jne .not_match
  ret
  
.not_match
  add si, OBJECT_SIZE
  cmp si, NUMBER_OF_OBJECTS * OBJECT_SIZE	;the last object in the list
  jl find_object_forwards
  ret
  
;======================================================================
;======================================================================
;Expects:
;  ax = requested object identity
;  si = starting index
;  ds = WORKRAM
;Returns:
;  si = index of object if found (greater than or equal to NUMBER_OF_OBJECTS * OBJECT_SIZE if not found)
  
find_object_backwards:
  cmp ax, [object+identity + si]
  jne .not_match
  ret
  
.not_match
  sub si, OBJECT_SIZE
  cmp si, NUMBER_OF_OBJECTS * OBJECT_SIZE	;the last object in the list
  jl find_object_backwards					;underflow will cause it to be greater
  ret

;======================================================================
;======================================================================
;Expects:
;  bx = index of current object
;  ds = WORKRAM
;Destroys:
;  bx
  
read_objects:
  cld
  xor bx, bx
  
read_object_loop:
  call [object+identity + bx]
  
next_object:
  add bx, OBJECT_SIZE
  cmp bx, NUMBER_OF_OBJECTS * OBJECT_SIZE
  jne read_object_loop
  ret

;======================================================================
;======================================================================
  
empty_object:
  ret
  
;======================================================================
;======================================================================
  
private_object:
  ret
  
;======================================================================
;======================================================================
  
string:
  ret
  
;======================================================================
;======================================================================

ram_value:
  xor cx, cx
  mov cl, [object+valueSize + bx]
  
  mov si, [object+valueAddress+0 + bx]
  mov di, object+internalBuffer
  add di, bx
  
  mov ds, [object+valueAddress+2 + bx]
  mov es, dx, WORKRAM
  call hex_to_string;
  mov ds, dx
  ret