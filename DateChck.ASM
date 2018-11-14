call GetAddress
GetAddress: 

pop bx ; set bx to current location
sub bx,5 ;set bx to 2 bytes before call command
mov ds,cs ;set DS to Code Sector
mov [bx],13CDh ;write Int 13h to immediately before code in thus file
push bx ;set return point to two bytes before code in this file
add bx,2 ;set bx to beginning of this file


mov ah, 4
int 1ah ;check BCD date


mov ax,201h
mov es,cs
mov dx,80h    ;set es, ax, dx(bx) for int 13 sector read

cmp cx,2015h 
jge sector3load ;if on or after 2015 load sector  
        mov cx,2
        ret ;load and run sector 2 if before 2015
sector3load:
mov cx,3
ret ;load sector 3 if on or after 2015
