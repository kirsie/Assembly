;   PROGRAM  "pierwszy.asm"

dane SEGMENT 	;segment danych
	tab1 db "13865434", 56 dup ("2"), "$"
	tab2 db 65 dup ("2")
	koniec db ?
dane ENDS

rozkazy SEGMENT 'CODE' use16 	;segment zawierajacycy rozkazy programu
		ASSUME cs:rozkazy, ds:dane
wystartuj:
	mov ax, SEG dane
	mov ds, ax
;----------------------------------------------------------------------------
	mov cx, tab2 - tab1
	sub cx, 1 ;pomijamy wypiasanie ostatniego znaku dolara 
	mov bx, OFFSET tab1
pt0:
	mov dl, [bx]
	mov ah, 2
	inc bx
	int 21H
	
loop pt0
	
	MOV dl, 10 ;znak nowej lini
	MOV ah, 2
	INT 21h
	MOV dl, 13
	MOV ah, 2
	INT 21h ;wypisujemy znak nowej lini
	
	MOV dl, 10 ;znak nowej lini
	MOV ah, 2
	INT 21h
	MOV dl, 13
	MOV ah, 2
	INT 21h ;wypisujemy znak nowej lini
	
	mov cx, tab2 - tab1 ; dlugosc tablicy 2
	sub cx,	2 ; pomijamy znak konca lini i ostatnia cyfre tab1
	mov bx, OFFSET tab1 ; wskaznik na tab1
	mov si, OFFSET tab2 ; wskaznik na tab2
pt1:
	mov dl, [bx] ; nalezy wpisac do dl bo jak wpisuje sie do ax to wpisuje zla wartosc
	sub dl, 48 ; kod ascii wiec odejmujemy 48 aby wyszla liczba
	add dl, [bx + 1]
	sub dl, 48
	mov ah, 0
	mov al, dl
	mov dx, 0
	mov sp, 10
	div sp
	mov ax, dx
	add ax, 48
	mov [si], ax ; ladujemy w sposob posredni bo inaczej wywala blad
	mov dl, [si]
	inc si
	inc bx
	
	mov ah, 2
	inc tab2
	int 21H 
	
loop pt1
	; Dodanie ostatniej cyfry do drugiej tablicy
	mov si, OFFSET tab2
	sub si, 2
	mov bx, OFFSET koniec
	sub bx, 1
	mov dl, [si]
	mov [bx], dl
	
	mov ah, 2
	inc tab2
	int 21H 
	
	;----------------------------------------------------------------------------
	;MOV dl, 10 ;znak nowej lini
	;MOV ah, 2
	;INT 21h
	;MOV dl, 13
	;MOV ah, 2
	;INT 21h ;wypisujemy znak nowej lini
	
	;mov ax, 9 ;sprawdzanie dzielenia jak dziala (9/10)
	;mov sp, 10
	;mov dx, 0
	;div sp
	;mov [si], dx
	;mov dl, [si] ;wynik powinien byc 9
	;add dl, 48
	;mov ah, 2
	;inc tab2
	;int 21H 
	;----------------------------------------------------------------------------
	
;----------------------------------------------------------------------------
	mov al, 0 	;wywolanie zakonczenia programu z kodem tego zakonczenia
	mov ah, 4CH 					
	int 21H
rozkazy ENDS

nasz_stos SEGMENT stack 	;segment stosu
dw 128 dup (?)
nasz_stos ENDS
END wystartuj 			;wykonanie programu zacznie sie od rozkazu
				;opatrzonego etykieta wystartuj