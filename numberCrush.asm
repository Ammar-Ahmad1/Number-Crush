 .model small
.stack
.data
;----------------------
mouse_y word ?			;form dx
	mouse_x word ?			;from cx
	buttonPressed byte 9	;from bx

	newline db 10,13,'$'
	count db 0
	number dw ? 

	
	num1 byte ?
	num2 byte ?
	
	box_col byte 12
	box_row byte 12
	
	box1_row byte 13
	box1_col byte 13
	box2_row byte 13
	box2_col byte 13
;----------------------
handler dw 0
filename db "data.txt", 0
delaytime dw 120
var4 dw ?
var2 dw ?
temp db ?
flag db 0
;gridArr db 10 dup(10 dup(?))
gridArr db 100 dup(0)
name1 db 10 dup(?)
inpu db 0
tam db 10,13,'$'
loading db "Loading,please wait... ",'$'
namee db "enter your name(max 10 characters): ",'$'
WelComeMsg db "We WelCome you To Number Crush Game",'$'
DevelopMsg db " That is Developed By",'$'
DevelopbyMsg db "Ammar Ahmed 19i-0678---Husnain Zahid 19i-2193---Naeem Mustafa 19i-2156",'$'
AnyKeyPressMsg db "Press any key to Continue",'$'
score db "score: ",'$'
moves db "moves: ",'$'
_name db "Name: ",'$'
level1 db "LEVEL1",'$'
_Level2 db "LEVEL2",'$'
_Level3 db "LEVEL3",'$'
move db 15
user_score db 0
max_move db 15
num_moves db 15
rem db ?
x_start word 100
x_start1 word 500
len word 400
y_start word 77
y_start1 word 350
lenY word 317
len_box_x dw 40
len_box_y dw 30
len_pop_x dw 20
len_pop_y dw 20
lop dw 0
lop1 dw 0
color db ?
RanNum db ?
RanNum_L3 db ?
pop_x db 15
pop_y db 5
popu db 0
popu1 db 0
r db 4
co db 30
;---------LEVEL 2-----
x_start_l2 word 200	;top left, less = left
x_start1_l2 word 320
len_l2 word 120
y_start_l2 word 100		;top left, less = up
y_start1_l2 word 385
lenY_l2 word 285
len_box_col_l2 dw 40
len_box_row_l2 dw 30
lop_l2 dw 0
lop1_l2 dw 0
;------------
x_start_l2_mid word 80	;top left, less = left
x_start1_l2_mid word 360
len_l2_mid word 360
y_start_l2_mid word 165		;top left, less = up
y_start1_l2_mid word 360
lenY_l2_mid word 285
len_box_col_l2_mid dw 40
len_box_row_l2_mid dw 30
lop_l2_mid dw 0
lop1_l2_mid dw 0
left_x dw 80
left_y dw 95
leftY dw 195
lop_l2_l db 0
line db 0
;---------------------
;------------------level 2 populate-------------------

color_L2 db ?
RanNum_L2 db ?
pop_x_L2 db 27
pop_y_L2 db 7
popu_L2 db 0
popu1_L2 db 0
pop_x_L2_left db 12
pop_y_L2_left db 13
popu_L2_left db 0
popu1_L2_left db 0
pop_x_L2_down db 27
pop_y_L2_down db 17
popu_L2_down db 0
popu1_L2_down db 0
pop_x_L2_right db 42
pop_y_L2_right db 13
popu_L2_right db 0
popu1_L2_right db 0


.code
Background macro color
pusha
		mov ah,06h	     
		mov al,0
		mov cx,0
		mov dh,128
		mov dl,128
		mov bh,color		;colour of background
		int 10h
popa
endm
;--------------------------------------
doubledigitout macro val
	
	mov ah, 0
	mov al, val
	mov bl, 10
	div bl
	mov rem, ah

	mov dl, al
	add dl, 48
	mov ah, 02h
	int 21h
	
	mov dl, rem
	add dl, 48
	mov ah, 02h
	int 21h	
	
endm
;------------------------------------

TimeDelay2 proc

	mov cx,0001h
	mov dx,4240h
	mov ah,86h
	int 15h
	;pop si 
ret
TimeDelay2 endp

delay proc near                ;requires delaytime
     push ax
	push bx 
	push cx 
	push dx 
	push si 
	push di
      
	  cmp delaytime,0
      je delay_exit_12

      mov si,0
      loopdel:
            mov cx,2000
            loop $
            inc si
            mov dx,delaytime
            cmp si,dx
            jle loopdel
      delay_exit_12:
   	 pop di
	pop si 
	pop dx 
	pop cx 
	pop bx 
	pop ax
      ret
delay endp
;delaytime dw 0

;--------------------------------------
getRanNum proc
;call Timedelay2
	mov ah, 0
	int 1ah
	
	mov ax, dx
	mov dx, 0
	mov bx, 7	;div by 7 to get nums from 0 to 6
	div bx
	mov RanNum, dl
	cmp RanNum,6
	jne exit
	mov RanNum,18
	exit: 
	ret
getRanNum endp
;----------
getRanNum_L3 proc
	mov ah, 0
	int 1ah
	
	mov ax, dx
	mov dx, 0
	mov bx, 7	;div by 7 to get nums from 0 to 6
	div bx
	mov RanNum_L3, dl

	cmp RanNum_L3,5
	jne l1
	mov RanNum_L3,40
	jmp exit
	l1:
	cmp RanNum_L3,6
	jne exit
	mov RanNum_L3,18
	exit: 
	ret
getRanNum_L3 endp
;-----------------------------------
getRanNum_L2 proc
	mov ah, 0
	int 1ah
	
	mov ax, dx
	mov dx, 0
	mov bx, 6	;div by 6 to get nums from 0 to 5
	div bx
	mov RanNum_L2,dl
	cmp RanNum_L2,5
	jne exit
	mov RanNum_L2,18
	exit:
	ret
getRanNum_L2 endp
;--------------------------------------
grid proc
;background 2
	mov al,12h
	mov ah,0
	int 10h

mov ah,02h				
mov dh,4 ;row number	
mov dl,12 ;colls number	
int 10h		

mov ah,09h
mov dx,offset score
int 21h
doubledigitout user_score

mov ah,02h				
mov dh,10 ;row number	
mov dl,65 ;colls number	
int 10h		

mov ah,09h
mov dx,offset level1
int 21h


mov si,-1
name_out:
mov dl,name1[si]
mov ah,02h		
int 21h	
inc co
mov dh,r ;row number	
mov dl,co ;colls number	
int 10h
inc si	
inc co	
cmp name1[si],13
jne name_out


mov ah,02h				
mov dh,4 ;row number	
mov dl,55 ;colls number	
int 10h		

;print out moves
mov ah,09h
mov dx,offset moves
int 21h

doubledigitout num_moves


;top
	mov cx,x_start		;starting of x-axis
	add cx,len			;end of line
	loop1:
	mov al,50       ;color
	mov dx,y_start  ;Y-coordinate
	mov ah, 0ch		;graphics printing
	int 10h

	sub cx,1
	cmp cx,x_start

	jae loop1
;left
	mov dx,y_start
	add dx,lenY
	loop2:
	mov al,50
	mov cx,x_start
	mov ah, 0ch
	int 10h

	sub dx,1
	cmp dx,y_start

	jae loop2
;down
mov cx,x_start
	add cx,len
	loop3:
	mov al,50       ;color
	mov dx,y_start1  ;Y-coordinate
	mov ah, 0ch
	int 10h

	sub cx,1
	cmp cx,x_start

	jbe loop3
;right
	mov dx,y_start
	add dx,lenY
	loop4:
	mov al,50
	mov cx,x_start1
	mov ah, 0ch
	int 10h

	sub dx,1
	cmp dx,y_start

	jae loop4
loop_line_X:		; grid vertical lines
	
	mov dx,y_start
	add dx,lenY
	loop5:
	mov al,50
	mov cx,x_start
	add cx,len_box_x
	mov ah, 0ch
	int 10h

	sub dx,1
	cmp dx,y_start
	jae loop5
	add len_box_x,40
	inc lop
	cmp lop,10
	jne loop_line_X


loop_line_Y:		; grid horizontal lines
	mov cx,x_start
	add cx,len
	loop8:
	mov al,50       ;color
	mov dx,y_start  ;Y-coordinate
	add dx,len_box_y
	mov ah, 0ch
	int 10h

	sub cx,1
	cmp cx,x_start
	jae loop8
	add len_box_y,32
	inc lop1
	cmp lop1,10
	jne loop_line_Y
	
	
mov x_start,100
mov x_start1, 500
mov len , 400
mov y_start, 77
mov y_start1, 350
mov lenY, 317
mov len_box_x , 40
mov len_box_y , 30
mov len_pop_x,  20
mov len_pop_y, 20
mov lop , 0
mov lop1 , 0
mov r , 4
mov co , 30
ret
grid endp
;-------------------------------------------------------------------------------------
populate1 proc

mov ah,02
mov dh,15
mov dl,55
int 10h
mov al,move
add al,'0'
mov bl,11
mov cx,1
mov ah,09
int 10h

mov si,0
loop_populate2_:	
	;mov si,0
loop_populate1_:
	mov ah,02
	mov dh,pop_y
	mov dl,pop_x
	int 10h
	


	mov al,gridArr[si]
	
	inc si
	mov color,al
	add color,1
;	mov al,gridArr[si]
	add al,'0'
	;mov al,RanNum
	;mov bh,0
	mov bl,color
	mov cx,1
	mov ah,09
	int 10h
	add pop_x,5
	inc popu
	cmp popu,10
	jne loop_populate1_
	mov popu,0
	mov pop_x,15
	add pop_y,2
	inc popu1
	cmp popu1,10
	jne loop_populate2_
	;mov si,0
mov pop_x , 15
mov pop_y , 5
mov popu , 0
mov popu1 , 0

ret
populate1 endp
;--------------------------------------

populate proc
mov si,0
loop_populate2:	
	;mov si,0
loop_populate1:
	mov ah,02
	mov dh,pop_y
	mov dl,pop_x
	int 10h
	
	
	mov al,gridArr[si]
	inc si
	mov color,al
	add color,1
	add al,'0'
	;mov al,RanNum
	;mov bh,0
	mov bl,color
	mov cx,1
	mov ah,09
	int 10h
	add pop_x,5
	inc popu
	cmp popu,10
	jne loop_populate1
	mov popu,0
	mov pop_x,15
	add pop_y,2
	inc popu1
	cmp popu1,10
	jne loop_populate2
 	
mov pop_x , 15
mov pop_y , 5
mov popu , 0
mov popu1 , 0
ret
populate endp
;------------------------------------

populate2 proc
loop_populate2_L2:	
loop_populate1_L2:
	mov ah,02
	mov dh,pop_y_L2
	mov dl,pop_x_L2
	int 10h
	call getRanNum_L2
	call Timedelay2
	mov al,RanNum_L2
	mov color,al
	add color,1
	add RanNum_L2,'0'	;making the number into string
	mov al,RanNum_L2
	;mov bh,0
	mov bl,color
	mov cx,1
	mov ah,09
	int 10h
	add pop_x_L2, 5
	inc popu_L2
	cmp popu_L2,3
	jne loop_populate1_L2
	mov popu_L2,0
	mov pop_x_L2,27
	add pop_y_L2,2	;move to next row
	inc popu1_L2
	cmp popu1_L2,4
	jne loop_populate2_L2
	;-----------
	_line4:
	line4:
		mov ah,02
	mov dh,pop_y_L2_left
	mov dl,pop_x_L2_left
	int 10h
	call getRanNum_L2
	call Timedelay2
	mov al,RanNum_L2
	mov color,al
	add color,1
	add RanNum_L2,'0'	;making the number into string
	mov al,RanNum_L2
	;mov bh,0
	mov bl,color
	mov cx,1
	mov ah,09
	int 10h
	add pop_x_L2_left, 5
	inc popu_L2_left
	cmp popu_L2_left,3
	jne line4
	mov popu_L2_left,0
	mov pop_x_L2_left,12
	add pop_y_L2_left,2	;move to next row
	inc popu1_L2_left
	cmp popu1_L2_left,3
	jne _line4
	
	;-----------
	loop_populate2_L2_down:	
loop_populate1_L2_down:
	mov ah,02
	mov dh,pop_y_L2_down
	mov dl,pop_x_L2_down
	int 10h
	call getRanNum_L2
	call Timedelay2
	mov al,RanNum_L2
	mov color,al
	add color,1
	add RanNum_L2,'0'	;making the number into string
	mov al,RanNum_L2
	;mov bh,0
	mov bl,color
	mov cx,1
	mov ah,09
	int 10h
	add pop_x_L2_down, 5
	inc popu_L2_down
	cmp popu_L2_down,3
	jne loop_populate1_L2_down
	mov popu_L2_down,0
	mov pop_x_L2_down,27
	add pop_y_L2_down,2	;move to next row
	inc popu1_L2_down
	cmp popu1_L2_down,4
	jne loop_populate2_L2_down
	;-----------
	_line4_right:
	line4_right:
		mov ah,02
	mov dh,pop_y_L2_right
	mov dl,pop_x_L2_right
	int 10h
	call getRanNum_L2
	call Timedelay2
	mov al,RanNum_L2
	mov color,al
	add color,1
	add RanNum_L2,'0'	;making the number into string
	mov al,RanNum_L2
	;mov bh,0
	mov bl,color
	mov cx,1
	mov ah,09
	int 10h
	add pop_x_L2_right, 5
	inc popu_L2_right
	cmp popu_L2_right,3
	jne line4_right
	mov popu_L2_right,0
	mov pop_x_L2_right,42
	add pop_y_L2_right,2	;move to next row
	inc popu1_L2_right
	cmp popu1_L2_right,3
	jne _line4_right
	
ret
populate2 endp
;------------------------------------

populate3 proc
loop_populate2:	
loop_populate1:
	mov ah,02
	mov dh,pop_y
	mov dl,pop_x
	int 10h
	call TimeDelay2
	call getRanNum_L3
	mov al,RanNum_L3
	mov color,al
	add color,1
	add al,'0'
	mov bl,color
	mov cx,1
	mov ah,09
	int 10h
	add pop_x,5
	inc popu
	cmp popu,10
	jne loop_populate1
	mov popu,0
	mov pop_x,15
	add pop_y,2
	inc popu1
	cmp popu1,10
	jne loop_populate2
 	
mov pop_x , 15
mov pop_y , 5
mov popu , 0
mov popu1 , 0
ret
populate3 endp
;------------------------------------

;-----------------------------------------
level3 proc
;background 2
	mov al,12h
	mov ah,0
	int 10h

mov ah,02h				
mov dh,4 ;row number	
mov dl,12 ;colls number	
int 10h		

mov ah,09h
mov dx,offset score
int 21h
doubledigitout user_score

mov ah,02h				
mov dh,10 ;row number	
mov dl,65 ;colls number	
int 10h		

mov ah,09h
mov dx,offset _level3
int 21h


mov si,-1
name_out:
mov dl,name1[si]
mov ah,02h		
int 21h	
inc co
mov dh,r ;row number	
mov dl,co ;colls number	
int 10h
inc si	
inc co	
cmp name1[si],13
jne name_out


mov ah,02h				
mov dh,4 ;row number	
mov dl,55 ;colls number	
int 10h		

;print out moves
mov ah,09h
mov dx,offset moves
int 21h

doubledigitout num_moves


;top
	mov cx,x_start		;starting of x-axis
	add cx,len			;end of line
	loop1:
	mov al,50       ;color
	mov dx,y_start  ;Y-coordinate
	mov ah, 0ch		;graphics printing
	int 10h

	sub cx,1
	cmp cx,x_start

	jae loop1
;left
	mov dx,y_start
	add dx,lenY
	loop2:
	mov al,50
	mov cx,x_start
	mov ah, 0ch
	int 10h

	sub dx,1
	cmp dx,y_start

	jae loop2
;down
mov cx,x_start
	add cx,len
	loop3:
	mov al,50       ;color
	mov dx,y_start1  ;Y-coordinate
	mov ah, 0ch
	int 10h

	sub cx,1
	cmp cx,x_start

	jbe loop3
;right
	mov dx,y_start
	add dx,lenY
	loop4:
	mov al,50
	mov cx,x_start1
	mov ah, 0ch
	int 10h

	sub dx,1
	cmp dx,y_start

	jae loop4
loop_line_X:		; grid vertical lines
	
	mov dx,y_start
	add dx,lenY
	loop5:
	mov al,50
	mov cx,x_start
	add cx,len_box_x
	mov ah, 0ch
	int 10h

	sub dx,1
	cmp dx,y_start
	jae loop5
	add len_box_x,40
	inc lop
	cmp lop,10
	jne loop_line_X


loop_line_Y:		; grid horizontal lines
	mov cx,x_start
	add cx,len
	loop8:
	mov al,50       ;color
	mov dx,y_start  ;Y-coordinate
	add dx,len_box_y
	mov ah, 0ch
	int 10h

	sub cx,1
	cmp cx,x_start
	jae loop8
	add len_box_y,32
	inc lop1
	cmp lop1,10
	jne loop_line_Y
	
	
mov x_start,100
mov x_start1, 500
mov len , 400
mov y_start, 77
mov y_start1, 350
mov lenY, 317
mov len_box_x , 40
mov len_box_y , 30
mov len_pop_x,  20
mov len_pop_y, 20
mov lop , 0
mov lop1 , 0
mov r , 4
mov co , 30
call populate3
ret
level3 endp
 
;--------------------------------------
PrintWelcome proc
background 2
mov ah,02h				
mov dh,7 ;row number	
mov dl,5 ;colls number	
int 10h		

mov ah,09h
mov dx,offset WelComeMsg
int 21h
mov ah,02h				
mov dh,10 ;row number	
mov dl,13 ;colls number	
int 10h		

mov ah,09h
mov dx,offset AnyKeyPressMsg
int 21h

mov ah,02h				
mov dh,17 ;row number	
mov dl,15 ;colls number	
int 10h		

mov ah,09h
mov dx,offset DevelopMsg
int 21h

mov ah,02h				
mov dh,20 ;row number	
mov dl,10
 ;colls number	
int 10h		

mov ah,09h
mov dx,offset DevelopbyMsg
int 21h

mov ah,0
int 16h
ret
PrintWelcome endp
;----------------------------------
level2 proc
;background 2
	mov al,12h
	mov ah,0
	int 10h

mov ah,02h				
mov dh,3  ;row number original = 4
mov dl,12 ;colls number	original = 12
int 10h		

;print out score
mov ah,09h
mov dx,offset score
int 21h

doubledigitout user_score

mov ah,02h				
mov dh,10 ;row number	
mov dl,65 ;colls number	
int 10h		

mov ah,09h
mov dx,offset _Level2
int 21h

;print out user name over grid
mov si,-1
name_out:
mov dl,name1[si]
mov ah,02h		
int 21h	
;inc co
mov dh,r ;row number	
mov dl,co ;colls number	
int 10h
inc si	
inc co	
cmp name1[si],13
jne name_out

mov ah,02h				
mov dh,3 ;row number	
mov dl,55 ;colls number	
int 10h		

;print out moves
mov ah,09h
mov dx,offset moves
int 21h

doubledigitout num_moves


;top
	mov cx,x_start_l2		;starting of x-axis
	add cx,len_l2			;end of line
	loop1:
	mov al,50       ;color
	mov dx,y_start_l2  ;Y-coordinate
	mov ah, 0ch		;graphics printing
	int 10h

	sub cx,1
	cmp cx,x_start_l2

	jae loop1
	
mov cx,x_start_l2		;starting of x-axis
	add cx,len_l2			;end of line
	loopx:
	mov al,50       ;color
	mov dx,y_start1_l2  ;Y-coordinate
	mov ah, 0ch		;graphics printing
	int 10h

	sub cx,1
	cmp cx,x_start_l2

	jae loopx

;left
	mov dx,y_start_l2
	add dx,lenY_l2
	loop2:
	mov al,50
	mov cx,x_start_l2
	mov ah, 0ch
	int 10h

	sub dx,1
	cmp dx,y_start_l2

	jae loop2
;down
mov cx,x_start_l2
	add cx,len_l2
	loop3:
	mov al,50       ;color
	mov dx,100  ;Y-coordinate
	mov ah, 0ch
	int 10h

	sub cx,1
	cmp cx,x_start_l2

	jbe loop3
;right
	mov dx,y_start_l2
	add dx,lenY_l2
	loop4:
	mov al,50
	mov cx,x_start1_l2
	mov ah, 0ch
	int 10h

	sub dx,1
	cmp dx,y_start_l2

	jae loop4
	loop_line_X:		; grid vertical lines
	
	mov dx,y_start_l2
	add dx,lenY_l2
	loop5:
	mov al,50
	mov cx,x_start_l2
	add cx,len_box_col_l2
	mov ah, 0ch
	int 10h

	sub dx,1
	cmp dx,y_start_l2
	jae loop5
	add len_box_col_l2,40
	inc lop_l2
	cmp lop_l2,2
	jne loop_line_X
	
	loop_line_Y1:		; grid horizontal lines
	mov cx,x_start_l2
	add cx,len_l2
	loop8:
	mov al,50       ;color
	mov dx,y_start_l2  ;Y-coordinate
	add dx,len_box_row_l2
	mov ah, 0ch
	int 10h

	sub cx,1
	cmp cx,x_start_l2
	jae loop8
	add len_box_row_l2,32
	inc lop1_l2
	cmp lop1_l2,8
	jne loop_line_Y1
	
loop_line_Y2:		; grid horizontal lines
	mov cx,x_start_l2_mid
	add cx,len_l2_mid
	loop9:
	mov al,50       ;color
	mov dx,y_start_l2_mid  ;Y-coordinate
	add dx,len_box_row_l2_mid
	mov ah, 0ch
	int 10h

	sub cx,1
	cmp cx,x_start_l2_mid
	jae loop9
	add len_box_row_l2_mid,32
	inc lop1_l2_mid
	cmp lop1_l2_mid,4
	jne loop_line_Y2
	
	
lab1:	
mov dx,left_y
add dx,leftY
	loop10:
	mov al,50
	mov cx,left_x
	mov ah, 0ch
	int 10h

	sub dx,1
	cmp dx,leftY
	jae loop10
	add left_x,40
	inc line
	cmp line,10
	jne lab1



loop_line_X_left:		; grid vertical lines
	
	mov dx,95
	add dx,195
	loop11:
	mov al,50
	mov cx,80
	add cx,len_box_col_l2
	mov ah, 0ch
	int 10h

	sub dx,1
	cmp dx,290
	jae loop11
	add len_box_col_l2,40
	inc lop_l2_l
	cmp lop_l2_l,2
	jne loop_line_X_left


mov cx,200
	add cx,len_l2
	loop12:
	mov al,50       ;color
	mov dx,50  ;Y-coordinate
	mov ah, 0ch
	int 10h

	sub cx,1
	cmp cx,240

	jbe loop12


call populate2
ret
level2 endp

;-------------------------------------


;-------------------------------------
take_name proc
	background 1
mov ah,02h				
mov dh,7 ;row number	
mov dl,5 ;colls number	
int 10h		

mov ah,09h
mov dx,offset namee
int 21h


mov ah,08
mov si,0
name_in:
mov ah,01
int 21h
mov ah,02
mov name1[si],al
inc si
cmp al,13
jne name_in
int 10h

ret 
take_name endp

;--------------------------------------

;--------------------------------------
Getmouse proc
mov ax,01
int 33h
again:
	;getting vals for mouse
	mov ax,03
	int 33h
	mov mouse_y,dx
	mov mouse_x,cx
	mov buttonPressed,bl
	
	cmp buttonPressed, 1
	jne again
ret
Getmouse endp
;--------------------------------------

checkbox proc
	;getting row of box
	.if (mouse_y > 70 && mouse_y < 100)
		mov box_row, 0

	.elseif (mouse_y > 100 && mouse_y < 130)
		mov box_row, 1

	.elseif (mouse_y > 130 && mouse_y < 160)
		mov box_row, 2

	.elseif (mouse_y > 160 && mouse_y < 190)
		mov box_row, 3

	.elseif (mouse_y > 190 && mouse_y < 220)
		mov box_row, 4

	.elseif (mouse_y > 220 && mouse_y < 250)
		mov box_row, 5

	.elseif (mouse_y > 250 && mouse_y < 280)
		mov box_row, 6

	.elseif (mouse_y > 280 && mouse_y < 320)
		mov box_row, 7

	.elseif (mouse_y > 330 && mouse_y < 360)
		mov box_row, 8

	.elseif (mouse_y > 360 && mouse_y < 390)
		mov box_row, 9
.endif

;getting col of box
	.if (mouse_x > 100 && mouse_x < 140)
		mov box_col, 0

	.elseif (mouse_x > 140 && mouse_x < 180)
		mov box_col, 1

	.elseif (mouse_x > 180 && mouse_x < 220)
		mov box_col, 2

	.elseif (mouse_x > 220 && mouse_x < 260)
		mov box_col, 3

	.elseif (mouse_x > 260 && mouse_x < 300)
		mov box_col, 4

	.elseif (mouse_x > 300 && mouse_x < 340)
		mov box_col, 5

	.elseif (mouse_x > 340 && mouse_x < 380)
		mov box_col, 6

	.elseif (mouse_x > 380 && mouse_x < 420)
		mov box_col, 7

	.elseif (mouse_x > 420 && mouse_x < 460)
		mov box_col, 8

	.elseif (mouse_x > 460 && mouse_x < 500)
		mov box_col, 9
.endif

ret
checkbox endp
;--------------------------------------
TimeDelay1 proc;used to get 2nd mouse input
	mov cx,0004h;can use Timedelay2 if wanted
	mov dx,4240h
	mov ah,86h
	int 15h
ret
TimeDelay1 endp
;--------------------------------------
takeinput proc
mov box_row,0
mov box1_row,0
mov box_col,0
mov box1_col,0
	;for box1_col
	call Getmouse
	call checkbox

	mov al, box_row
	mov box1_row, al

	mov al, box_col
	mov box1_col, al
	
	mov buttonPressed, 0
	call TimeDelay1

	call Getmouse
	call checkbox
	
	mov al, box_row
	mov box2_row, al

	mov al, box_col
	mov box2_col, al
 
ret
takeinput endp
fileWriting proc
	mov  ah, 3ch
  mov  cx, 0
  mov  dx, offset filename
  int  21h  
  mov  handler, ax

;WRITE STRING.
  mov  ah, 40h
  mov  bx, handler
  mov  cx, 5  ;STRING LENGTH.
  mov  dx, offset _name
  int  21h

;WRITE STRING.
  mov  ah, 40h
  mov  bx, handler
  mov  cx, 10  ;STRING LENGTH.
  mov  dx, offset name1
  int  21h
    ;WRITE STRING.
  mov  ah, 40h
  mov  bx, handler
  mov  cx, lengthof newline  ;STRING LENGTH.
  mov  dx, offset newline
  int  21h
    ;WRITE STRING.
  mov  ah, 40h
  mov  bx, handler
  mov  cx, lengthof score ;STRING LENGTH.
  mov  dx, offset score
  int  21h
  ;WRITE STRING.
  mov  ah, 40h
  mov  bx, handler
  mov  cx, lengthof user_score  ;STRING LENGTH.
  mov  dx, word ptr user_score
  int  21h

;CLOSE FILE (OR DATA WILL BE LOST).
  mov  ah, 3eh
  mov  bx, handler
  int  21h      
  
ret
fileWriting endp
;--------------------------------------

main proc
mov ax,@data
mov ds,ax
	mov ah,0	   ;start code for visual mode
	mov al,12h
	int 10h
mov ah,02h				
mov dh,15  
mov dl,12 
int 10h		

mov ah,09h
mov dx,offset loading
int 21h

mov si,0
	fillArray:
	call getRanNum
	call delay
	mov al,RanNum
	mov gridArr[si],al
	inc si
	cmp si,100
	jne fillArray
	

	call PrintWelcome		;calling procedure for welcome screen
	
	;setting background colour of our game
	Background 11
	call take_name
	call grid
	call populate
_move: 
call TimeDelay1	
call takeinput	
mov al,box1_row
	
 mov bl,10
 mul bl
 mov dx,ax
 mov ax,0
 mov al,box1_col
  add dx,ax
 mov var2,dx
 
  
 mov si,var2
 mov dl,gridArr[si]				;si = var2 of box1
 mov temp ,dl			;temp = val of box1
 
  
  
 mov si,dx
  mov ax,0
 mov bx,0
 mov cx,0
 mov dx,0
 
	mov al,box2_row
	mov bl,10
  mul bl
 mov dx,ax
 mov ax,0
 mov al,box2_col
  add dx,ax
 mov var4,dx
  
  
  mov si,var4
  mov dl,gridArr[si]  ;si=var4 of box2
 
 ;swaping vals of box1 and box2
 mov si,var2 
 mov gridArr[si],dl     ;moving box 2 in box 1
 mov si,var4
 mov dl,temp
 mov gridArr[si],dl

  
  
  
  
  
  
  
  ; for storing
 mov dl,gridArr[si+1]
 mov si,var2
mov bl,gridArr[si-1]
;........this condition will check for the match in horizontal direction  
.if(dl==gridArr[si])
.if(bl==gridArr[si])
mov si,var4
mov gridArr[si],'*'
sub gridArr[si],48
mov gridArr[si+1],'*'
sub gridArr[si+1],48

mov gridArr[si-1],'*'
sub gridArr[si-1],48
 
mov si,0
.endif
dec num_moves
add user_score,3	
.endif



; this will check in vertical direction

 mov dl,gridArr[si+10]
 mov si,var2
mov bl,gridArr[si-10]
;........this condition will check for the match in horizontal direction  
.if(dl==gridArr[si])
.if(bl==gridArr[si])
mov si,var4
mov gridArr[si],'*'
sub gridArr[si],48
mov gridArr[si+10],'*'
sub gridArr[si+10],48

mov gridArr[si-10],'*'
sub gridArr[si-10],48
mov si,0
.endif
dec num_moves
add user_score,3
.endif

 Background 0
call grid
call populate1
 mov si,0
 mov ax,0
 mov bx,0
 mov cx,0
 mov dx,0
 mov box1_row,0
 mov box1_col,0
 mov box2_row,0
 mov box2_col,0
 mov box_row,0
 mov box_col,0
 mov var2,0
 mov var4,0
 mov temp,0
 mov gridARR[si],0
 mov gridARR[si+1],0
 mov gridARR[si-1],0
 mov gridARR[si+10],0
 mov gridARR[si-10],0
  
cmp num_moves,0
jne _move
mov num_moves,15
call level2
call level3

call fileWriting
mov ah,4ch
int 21h
main endp
end main