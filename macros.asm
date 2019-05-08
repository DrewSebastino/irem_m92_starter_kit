;======================================================================
;======================================================================
;An example of using macros in debugging
;
;  cmp ax, 0
;  jne exception_1_done
;    
;	printstring DATA, exception, (ORIGIN_X), (ORIGIN_Y), [debug+0]
;	call draw_objects
;   wait word [controller1Press], BUTTON_1
;	deletestring [debug+0]
;  
;  exception_1_done:
;
;======================================================================
;======================================================================
;Arguments: list of constants to compare

%macro  findlargest 1-*
  %assign largest %1
  
  %rep %0
    %if (%1 > largest)
	  largest = %1
	%endif
  %rotate 1
  %endrep
  
%endmacro

;======================================================================
;======================================================================

%macro mov 3
  mov %2, %3
  mov %1, %2
%endmacro

;======================================================================
;======================================================================

%macro pushall 0
  pushf
  pusha
  push ds
  push es
%endmacro

;======================================================================
;======================================================================

%macro popall 0
  pop es
  pop ds
  popa
  popf
%endmacro

;======================================================================
;======================================================================
;Argument 1: memory address (presumably controller or coin)
;Argument 2: value to test

%macro wait 2
%%wait:
  test %1, %2
  je %%wait
%endmacro

;======================================================================
;======================================================================

%macro  startup 0
;Set stack location
  mov ss, sp, BSS
  xor sp, sp
  
  ;Set up interrupt controller (this is exactly what Gunforce II writes)
  mov al, 0x17
  out 0x40, al
  mov al, 0x20
  out 0x42, al
  mov al, 0x0F
  out 0x42, al
  mov al, 0x08
  out 0x42, al
  
  ;Set ds to WORKRAM
  mov ds, ax, WORKRAM
%endmacro

;======================================================================
;======================================================================
;Argument 1: string address high word
;Argument 2: string address low word
;Argument 3: x position
;Argument 4: y position
;Argument 5: address to store the index

%macro printstring 4-5
  pushall
  mov ds, ax, WORKRAM
  
  mov ax, empty_object
  xor si, si
  call find_object_forwards
  
  mov word [object+identity + si], string
  mov byte [object+metaspriteType + si], STRING
  mov word [object+metaspriteData+2 + si], %1
  mov word [object+metaspriteData+0 + si], %2
  mov word [object+attributes+2 + si], ABSOLUTE_POSITION
  mov word [object+font + si], sprite_text
  mov word [object+xPosition+1 + si], %3
  mov word [object+yPosition+1 + si], %4
  
  %if (%0 = 5)
    mov %5, si
  %endif
  
  popall
%endmacro

;======================================================================
;======================================================================
;Argument 1: hex address high word
;Argument 2: hex address low word
;Argument 3: hex size in bytes
;Argument 4: x position
;Argument 5: y position
;Argument 6: address to store the index

%macro printhex 5-6
  pushall
  mov ds, ax, WORKRAM
  
  mov ax, empty_object
  xor si, si
  call find_object_forwards
  
  mov word [object+identity + si], ram_value
  mov byte [object+metaspriteType + si], STRING
  mov word [object+metaspriteData+2 + si], WORKRAM
  mov word [object+metaspriteData+0 + si], object+internalBuffer
  add word [object+metaspriteData+0 + si], si
  mov word [object+attributes+2 + si], ABSOLUTE_POSITION
  mov word [object+font + si], sprite_text
  
  mov word [object+valueAddress+2 + si], %1
  mov word [object+valueAddress+0 + si], %2
  mov byte [object+valueSize + si], %3
  mov word [object+xPosition+1 + si], %4
  mov word [object+yPosition+1 + si], %5
  
  %if (%0 = 6)
    mov %6, si
  %endif
  
  ;so it at least prints out initially
  mov bx, si
  call ram_value
  
  popall
%endmacro

;======================================================================
;======================================================================
;Argument 1: hex address high word
;Argument 2: hex address low word
;Argument 3: hex size in bytes
;Argument 4: x position
;Argument 5: y position
;Argument 6: address to store the index

%macro printhexconst 5-6
  pushall
  mov ds, ax, WORKRAM
  
  mov ax, empty_object
  xor si, si
  call find_object_forwards
  
  mov word [object+identity + si], string
  mov byte [object+metaspriteType + si], STRING
  mov word [object+metaspriteData+2 + si], WORKRAM
  mov word [object+metaspriteData+0 + si], object+internalBuffer
  add word [object+metaspriteData+0 + si], si
  mov word [object+attributes+2 + si], ABSOLUTE_POSITION
  mov word [object+font + si], sprite_text
  mov word [object+xPosition+1 + si], %4
  mov word [object+yPosition+1 + si], %5
  
  %if (%0 = 6)
    mov %6, si
  %endif
  
  mov es, ax, WORKRAM
  mov di, object+internalBuffer
  add di, si
  
  mov ds, ax, %1
  mov si, %2
  
  xor cx, cx
  mov cl, %3
  
  call hex_to_string;
  
  popall
%endmacro

;======================================================================
;======================================================================
;Argument 1: address of string to delete

%macro deletestring 1
  push si
  mov si, %1
  mov word [object+identity + si], empty_object
  mov byte [object+metaspriteType + si], NONE
  pop si
%endmacro