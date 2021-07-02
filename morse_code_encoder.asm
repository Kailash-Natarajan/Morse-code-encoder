ORG 0000H
MOV P3,#00H
MOV P2,#0FFH ;make P2 an input port
MOV P0,#0FFH
MOV P3,#00H   ;  P3.1 DOT  P3.0 DASH ;P3.2 MORSE STATUS

;-------keypad--------------
K1: MOV P1,#00H ;ground all rows at once
MOV A,P2 ;read all col(ensure keys open)
ANL A,00001111B ;masked unused bits
K2: 
ACALL DELAY ;call 20 msec del
MOV A,P2 ;see if any key is pressed
ANL A,00001111B ;mask unused bits
CJNE A,#00001111B,OVER ;key pressed, find row
SJMP K2 ;check till key pressed
OVER: 
ACALL DELAY ;wait 20 msec debounce time
MOV A,P2 ;check key closure
ANL A,00001111B ;mask unused bits
CJNE A,#00001111B,OVER1 ;key pressed, find row
SJMP K2 ;if none, keep polling
OVER1: 
MOV P1, #11111110B ;ground row 0
MOV A,P2 ;read all columns
ANL A,#00001111B ;mask unused bits
CJNE A,#00001111B,ROW_0 ;key row 0, find col.
MOV P1,#11111101B ;ground row 1
MOV A,P2 ;read all columns
ANL A,#00001111B ;mask unused bits
CJNE A,#00001111B,ROW_1 ;key row 1, find col.
MOV P1,#11111011B ;ground row 2
MOV A,P2 ;read all columns
ANL A,#00001111B ;mask unused bits
CJNE A,#00001111B,ROW_2 ;key row 2, find col.
MOV P1,#11110111B ;ground row 3
MOV A,P2 ;read all columns
ANL A,#00001111B ;mask unused bits
CJNE A,#00001111B,ROW_3 ;key row 3, find col.
LJMP K2 ;if none, false input, repeat
ROW_0: MOV DPTR,#KCODE0 ;set DPTR=start of row 0
SJMP FIND ;find col. Key belongs to
ROW_1: MOV DPTR,#KCODE1 ;set DPTR=start of row
SJMP FIND ;find col. Key belongs to
ROW_2: MOV DPTR,#KCODE2 ;set DPTR=start of row 2
SJMP FIND ;find col. Key belongs to
ROW_3: MOV DPTR,#KCODE3 ;set DPTR=start of row 3
FIND: RRC A ;see if any CY bit low
JNC MATCH ;if zero, get ASCII code
INC DPTR ;point to next col. addr
SJMP FIND ;keep searching
MATCH: CLR A ;set A=0 (match is found)
MOVC A,@A+DPTR ;get ASCII from table

;----------check switch number--------------------
MOV B,A
MOV A,P0
ANL A,#00000111B
RRC A
JC SWITCHONE 
RRC A   
JC SWITCHTWO
RRC A
JC SWITCHTHREE
SWITCHONE: MOV A,B
           LJMP ONESWITCH
SWITCHTWO: MOV A,B
           LJMP TWOSWITCH
SWITCHTHREE: MOV A,B 
             LJMP THREESWITCH

;--------------switch position 1---------------------
ONESWITCH:
	CJNE A,#00111000B,S1 ;1
	ACALL DOT            ;if 1
	MOV R1,#04
X1:	ACALL DAS
	DJNZ R1,X1
S1: CJNE A,#00111001B,S2 ;2 
	MOV R1,#02       ;if 2   
X2:	ACALL DOT
	DJNZ R1,X2
	MOV R2,#03
X3: ACALL DAS            
	DJNZ R2,X3
S2: CJNE A,#01000001B,S3 ;3
	MOV R1,#03       ;if 3
X4:	ACALL DOT
	DJNZ R1,X4
	MOV R2,#02
X5:	ACALL DAS 
	DJNZ R2,X5
S3: CJNE A,#00110100B,S4 ;4
	MOV R1,#04       ;if 4
X6:	ACALL DOT
	DJNZ R1,X6
	ACALL DAS
S4: CJNE A,#00110101B,S5 ;5
	MOV R1,#05       ;if 5
X7: ACALL DOT
	DJNZ R1,X7
S5: CJNE A,#00110110B,S6 ;6
	ACALL DAS        ;if 6
	MOV R1,#04
X8:	ACALL DOT
	DJNZ R1,X8
S6: CJNE A,#00110000B,S7 ;7
	MOV R1,#02       ;if 7
X9:	ACALL DAS
	DJNZ R1,X9
	MOV R2,#03
X10:ACALL DOT
	DJNZ R2,X10
S7: CJNE A,#00110001B,S8 ;8
	MOV R1,#03       ;if 8
X11:ACALL DAS
	DJNZ R1,X11
	MOV R2,#02
X12:ACALL DOT
	DJNZ R2,X12
S8: CJNE A,#00110010B,S9 ;9
	MOV R1,#04       ;if 9
X13:ACALL DAS
	DJNZ R1,X13
	ACALL DOT
S9: CJNE A,#01000100B,S10 ;0
	MOV R1,#05        ;if 0
X14:ACALL DAS
	DJNZ R1,X14
S10:CJNE A,#00110011B,S11 ;A
	ACALL DOT         ;if A
	ACALL DAS
S11:CJNE A,#00110111B,S12 ;B
	ACALL DAS         ;if B
	MOV R1,#03
X15:ACALL DOT
	DJNZ R1,X15
S12:CJNE A,#01000010B,S13 ;C
	ACALL DAS         ;if C
	ACALL DOT
	ACALL DAS
	ACALL DOT
S13:CJNE A,#01000110B,S14 ;D
	ACALL DAS         ;if D
	ACALL DOT
	ACALL DOT
S14:CJNE A,#01000101B,S15 ;E
	ACALL DOT         ;if E
S15:CJNE A,#01000011B,ES1 ;F
	ACALL DOT         ;if F
	ACALL DOT
	ACALL DAS
	ACALL DOT
ES1:LJMP REPEAT

;----------------------switch 2----------------------
TWOSWITCH:
	CJNE A,#00110000B,S17 ;G
	ACALL DAS             ; if G
	ACALL DAS
	ACALL DOT
S17:CJNE A,#00110001B,S18 ;H
	MOV R1,#04        ;if H
X16:ACALL DOT
	DJNZ R1,X16
S18:CJNE A,#00110010B,S19 ;I
	ACALL DOT         ;if I
	ACALL DOT
S19:CJNE A,#00110011B,S20 ;J
	ACALL DOT         ;if J
	ACALL DAS
	ACALL DAS
	ACALL DAS
S20:CJNE A,#00110100B,S21 ;K
	ACALL DAS         ;if K
	ACALL DOT
	ACALL DAS
S21:CJNE A,#00110101B,S22 ;L
	ACALL DOT         ;if L
	ACALL DAS
	ACALL DOT
	ACALL DOT
S22:CJNE A,#00110110B,S23 ;M
	ACALL DAS         ;if M
	ACALL DAS
S23:CJNE A,#00110111B,S24 ;N
	ACALL DAS         ;if N
	ACALL DOT
S24:CJNE A,#00111000B,S25 ;O
	ACALL DAS         ;if O
	ACALL DAS
	ACALL DAS
S25:CJNE A,#00111001B,S26 ;P
	ACALL DOT         ;if P
	ACALL DAS
	ACALL DAS
	ACALL DOT
S26:CJNE A,#01000001B,S27 ;Q
	ACALL DAS         ;if Q
	ACALL DAS
	ACALL DOT 
	ACALL DAS
S27:CJNE A,#00110100B,S28 ;R
	ACALL DOT         ;if R
	ACALL DAS
	ACALL DOT
S28:CJNE A,#01000011B,S29 ;S
	ACALL DOT         ;if S
	ACALL DOT
	ACALL DOT
S29:CJNE A,#01000100B,S30 ;T
	ACALL DAS         ;if T
S30:CJNE A,#01000101B,S31 ;U
	ACALL DOT         ;if U
	ACALL DOT
	ACALL DAS
S31:CJNE A,#01000110B,ES2 ;V
	ACALL DOT         ;if V
	ACALL DOT
	ACALL DOT
	ACALL DAS
ES2:LJMP REPEAT

;------------switch 3--------------------
THREESWITCH:
CJNE A,#00110000B,S33 ;W
	ACALL DOT     ;if W
	ACALL DAS
	ACALL DAS
S33:CJNE A,#00110001B,S34 ;X
	ACALL DAS         ;if X
	ACALL DOT 
	ACALL DOT
	ACALL DAS
S34:CJNE A,#00110010B,S35 ;Y
	ACALL DAS         ;if Y
	ACALL DOT
	ACALL DAS
	ACALL DAS
S35:CJNE A,#00110011B,ES3 ;Z
	ACALL DAS         ;if Z
	ACALL DAS
	ACALL DOT
	ACALL DOT
ES3:LJMP REPEAT

REPEAT: LJMP K1

;------delay module for dot and dash---
DEL:MOV TMOD,#01H
	MOV R0,#10
L1:	MOV TH0,#00H
	MOV TL0,#00H
	SETB TR0
L:  JNB TF0,L
	CLR TR0
	CLR TF0
	DJNZ R0,L1
	RET
;------module to blink dot and dash------------	
DOT: SETB P3.2
     SETB P3.1
	 ACALL DEL
	 CLR P3.2
	 CLR P3.1
	 ACALL DEL
	 RET
DAS: SETB P3.2
     SETB P3.0
     ACALL DEL
	 ACALL DEL
	 ACALL DEL
	 CLR P3.2
	 CLR P3.0
	 ACALL DEL
	 RET
;--------------------------------------
ORG 300H ;ASCII LOOK-UP TABLE FOR EACH ROW
KCODE0: DB '0','1','2','3' ;ROW 0
KCODE1: DB '4','5','6','7' ;ROW 1
KCODE2: DB '8','9','A','B' ;ROW 2
KCODE3: DB 'C','D','E','F' ;ROW 3

;-----------delay for keypad functions-----------
DELAY:MOV TMOD,#01H
	MOV R0,#10
L4:	MOV TH0,#00H
	MOV TL0,#00H
	SETB TR0
L3:  JNB TF0,L3
	CLR TR0
	CLR TF0
	DJNZ R0,L4
	RET	
END
