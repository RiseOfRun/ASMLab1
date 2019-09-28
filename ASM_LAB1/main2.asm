.386
.MODEL FLAT, STDCALL
; ��������� ������� ������� (��������) ����������� ���������� EXTERN, 
; ����� ����� @ ����������� ����� ����� ������������ ����������,
; ����� ��������� ����������� ��� �������� ������� � ���������
EXTERN  GetStdHandle@4: PROC
EXTERN  WriteConsoleA@20: PROC
EXTERN  CharToOemA@8: PROC
EXTERN  ReadConsoleA@20: PROC
EXTERN  ExitProcess@4: PROC; ������� ������ �� ���������
EXTERN  lstrlenA@4: PROC; ������� ����������� ����� ������
EXTERN  wsprintfA: PROC; �.�. ����� ���������� ������� �� �����������,
			; ������������ ����������, �������� �������� ������� ���� 
			; ���������� ���������


.DATA; ������� ������
STRN DB "������� ������: ",13,10,0; ��������� ������, � ����� ���������
; ����������� �������: 13 � ������� �������, 10 � ������� �� ����� 
; ������, 0 � ����� ������; � �������������� ��������� DB 
; ������������� ������ ������
FMT DB "����� %d", 0; ������ �� ������� �������� ��� ������� wsprintfA
DIN DD ?; ���������� �����; ��������� DD ����������� ������ �������
; 32 ���� (4 �����), ���� �?� ������������ ��� �������������������� ������
DOUT DD ?; ���������� 
X DW ?
Y dw ?
digit dw ?
sign dw 1
complite db 0
compliteAllert db "complite",13,10,0
BUF  DB 200 dup (?); ����� ��� ��������/��������� ����� ������ 200 ������
LENS DD ?; ���������� ��� ���������� ���������� ��������



.CODE; ������� ���� 
MAIN PROC; �������� ���������
MOV EAX, 10Q
; ������������ ������ STRN
MOV  EAX, OFFSET STRN;	�������� MOV  �������� ������� �������� 
; ������������ � ������, OFFSET � ��������, ������������ �����
PUSH EAX; ��������� ������� ���������� � ���� �������� PUSH
PUSH EAX
CALL CharToOemA@8; ����� �������
; ������������ ������ FMT
MOV  EAX, OFFSET FMT
PUSH EAX 
PUSH EAX
CALL CharToOemA@8; ����� �������
; ������� ���������� ����� 
PUSH -10
CALL GetStdHandle@4
MOV DIN, EAX 	; ����������� ��������� �� �������� EAX 
; � ������ ������ � ������ DIN
; ������� ���������� ������
PUSH -11
CALL GetStdHandle@4
MOV DOUT, EAX 
; ��������� ����� ������ STRN
PUSH OFFSET STRN; � ���� ���������� ����� ������
CALL lstrlenA@4; ����� � EAX
; ����� ������� WriteConsoleA ��� ������ ������ STRN
PUSH 0; � ���� ���������� 5-� ��������
PUSH OFFSET LENS; 4-� ��������
PUSH EAX; 3-� ��������
PUSH OFFSET STRN; 2-� ��������
PUSH DOUT; 1-� ��������
CALL WriteConsoleA@20


;���� ������� �����
Input1: PUSH 0; � ���� ���������� 5-� ��������
PUSH OFFSET LENS; 4-� ��������
PUSH 200; 3-� ��������
PUSH OFFSET BUF; 2-� ��������
PUSH DIN; 1-� ��������
CALL ReadConsoleA@20 ; �������� ��������: LENS ������ ����� ���������
; �������� �� ���, ������������� ��������� �������: 13 � ������� ������� � 
; 10 � ������� �� ����� ������

call ToNum
cmp complite,0
je input1
mov X,AX
push offset compliteAllert
call lstrlenA@4
mov lens, eax
push 0
push offset lens
push lens
push offset compliteAllert
push dout
call writeconsoleA@20

;���� ������� �����
xor eax,eax
mov lens,eax
Input2: PUSH 0; � ���� ���������� 5-� ��������
PUSH OFFSET LENS; 4-� ��������
PUSH 200; 3-� ��������
PUSH OFFSET BUF; 2-� ��������
PUSH DIN; 1-� ��������
CALL ReadConsoleA@20 ; �������� ��������: LENS ������ ����� ���������
; �������� �� ���, ������������� ��������� �������: 13 � ������� ������� � 
; 10 � ������� �� ����� ������

call ToNum
cmp complite,0
je input2
mov Y,AX
push offset compliteAllert
call lstrlenA@4
mov lens, eax
push 0
push offset lens
push lens
push offset compliteAllert
push dout
call writeconsoleA@20

;��������� �����

mov ax, x
mov bx, y
sub ax,bx

;����� �����

call PrintResult
push 0
push offset lens
push lens
push offset BUF
push dout
call writeconsoleA@20

PUSH 0; ��������: ��� ������
CALL ExitProcess@4
MAIN ENDP

ToNum PROC far
mov eax,lens
SUB eax,2
mov ecx, eax
mov di, 10
xor bx,bx
xor ax,ax
mov esi, offset buf
mov bl, [esi]
mov sign,0
mov complite,0

cmp bl, '-'
jne p
inc sign
inc esi
dec ecx

P:
Convert:
	mov bl, [esi]
	cmp bl, '0'
	jb uncomplite
	cmp bl,'9'
	ja uncomplite
	sub bl,'0'
	mul di
	add ax,bx
	inc esi
LOOP Convert
inc complite
cmp sign,1
jne uncomplite
neg ax
; ���� ���������
uncomplite: RET
ToNum ENDP

PrintResult PROC far
mov sign, 0
xor edx,edx
xor ebx,ebx
xor ecx,ecx
cmp ax,0
mov esi, offset buf
JGE P
mov sign,1
neg ax
P:
mov bx, 16
div bx
cmp dx,9
jbe decc
add dx,55
decc:
jae strs
add dx,'0'
strs:
push edx
inc cx
xor edx, edx
cmp ax, 0
JNE P
cmp sign,0
je toPrint
push '-'
inc cx
mov lens, Ecx
xor EBX,EBX

toPrint:
	
	pop ebx
	mov [esi], bx
	inc esi
LOOP toPrint
RET
PrintResult ENDP
END MAIN