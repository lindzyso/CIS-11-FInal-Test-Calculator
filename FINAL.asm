;CIS11 FINAL PROJECT
;LINDZY TYLER MARIE SO, JORGE HERNANDEZ, NOUR
;TEST CALCULATOR
;INPUT: 5 TEST SCORES 1-100
;OUTPUT: MIN, MAX, AND AVERAGE SCORE WITH THE CORRESPONDING GRADE LETTER
;A = 100-90
;B = 89-80
;C = 79-70
;D = 69-60
;F = 59-0

.ORIG x3000
LD R1, LOOPCOUNT                            ;LOAD 5 INTO THE LOOP COUNT
LD R6, BASE                                 ;STACK POINTER

START                                       ;START OF LOOP LABEL
BRz COMPARE                                 ;WHEN COUNTER = 0 BRANCH TO COMPARE
LEA R0, PROMPT                              ;PROMPT USER TO INPUT FIRST DIGIT AND DISPLAY
PUTS
GETC
OUT
AND R3, R3, #0                              ;CLEAR R3 AND LOAD ASCII INTO IT
LD R3, ASCII
ADD R2, R0, R3                              ;ASCII CONVERT
AND R0, R0, #0                              ;CLEAR R0
LEA R0, ENTER2
PUTS
LEA R0, PROMPT1                             ;PROMPT USER TO INPUT SECOND DIGIT
PUTS
GETC
OUT
AND R4, R4, #0                              ;CLEAR R4 TO PUT SECOND DIGIT INTO IT
ADD R4, R0, R3                              ;ASCII CONVERT
JSR MULT                                    ;SCORE = 10(R2)
ADD R0, R5, R4                              ;COPY VALUE WITH R4 SCORE = 10(R2) + R4

JSR PUSH                                    ;JUMP TO STACK SUBROUTINE
LEA R0, ENTER2
PUTS

ADD R1, R1, #-1                             ;MINUS ONE TO COUNTER
JSR START

LOOPCOUNT           .FILL #5
BASE                .FILL x4000
ASCII               .FILL #-48
ENTER2              .STRINGZ "\n"

;MULT SUBROUTINE;
;MULTIPLIES THE FIRST NUMBER BY 10;
MULT
AND R3, R3, x0
ADD R3, R3, #10                             ;SET R3 TO 10 AS LC

MULTLOOP
ADD R5, R5, R2                              ;ADD R2 TO R4
ADD R3, R3, #-1                             ;DECREMENT LOOP
BRp MULTLOOP                                ;CONTINUE LOOP IF THE COUTNER STILL NEEDS TO GO THROUGH
RET                                         ;ELSE RETURN TO CALLING ROUTINE

;COMPARE SUBROUTINE;
;COMPARES THE TESTSCORES;
;LOOPS WITHIN ITSELF TO COMPARE ALL 5 TEST SCORES;

COMPARE
JSR POP
AND R1, R1, #0                              ;CLEAR R1
ADD R1, R0, #0                              ;COPY SCORE OFF STACK TO R1
ST R1, TOTAL
ST R1, MINVAL                               ;STORE R1 TO MIN AND MAX TO PREPARE TO COMPARE WITH A LOOP
ST R1, MAXVAL
AND R4, R4, #0
LD R4, LOOPCOUNT2                           ;PREPARE LOOPCOUNTER

COMPLOOP                                    ;COMPARE LOOP
BRnz CALCAVG
JSR POP
AND R1, R1, #0                              ;CLEAR R1
ADD R1, R0, #0                              ;COPY SCORE OFF STACK TO R1
AND R0, R0, #0                              ;CLEAR R0
LD R0, TOTAL                                ;LOAD TOTAL TO R0
ADD R0, R0, R1                              ;INCREMENT TOTAL
ST R0, TOTAL

LD R3, MINVAL
NOT R3, R3                                  ;2S COMPLIMENT
ADD R3, R3, #1
ADD R2, R1, R3                              ;COMPARE THE NUMBERS
BRn SETMIN                                  ;IF NEGATIVE BRANCH TO THE SET MIN
AND R3, R3, #0
LD R3, MAXVAL                               ;LOAD CURRENT MAX VAL AND TWOS COMPLIMENT IT
NOT R3, R3
ADD R3, R3, #1
AND R2, R2, #0                              ;CLEAR R2 SO WE CAN COMPARE THE CURRENT INPUT WITH THE MAXVAL
ADD R2, R1, R3
BRp SETMAX                                  ;IF POSITIVE BRANCH TO THE SETMAX SUBROUTINE

ADD R4, R4, #-1
BRp COMPLOOP


CALCAVG
AND R0, R0, #0
LDI R0, TOTAL                                ;LOAD TOTAL TO R0
JSR DIVISION
ADD R4, R4, #0
ST R4, AVERAGE                              ;STORE THE CALCULATED AVERAGE INTO AVERAGE
JSR DISPLAY


LOOPCOUNT2          .FILL #4

;DIVISION SUBROUTINE;
DIVISION
AND R1, R1, #0
ST R0, SAVE1
LDI R1, FIVE                                 ;LOAD DECIMAL 5 INTO R1
AND R4, R4, #0                              ;CLEAR R4 FOR QUOTIENT
NOT R1, R1                                  ;2S COMPLIMENT
ADD R1, R1, #1
DLOOP
ADD R4, R4, #1                              ;INCREMENT QUOTIENT
ADD R0, R0, R1
BRzp DLOOP
ADD R4, R4, #-1
RET

FIVE        .FILL #5
SAVE1       .FILL x0
AVERAGE     .FILL x0

;DISPLAY GRADE;
;DISPLAYS THE GRADE LETTER BASED ON THE AVERAGE GRADE;

DISPLAY
LEA R0, MAXMSG                              ;LOAD "MAX SCORE: " AND DISPLAY ON CONSOLE
PUTS
AND R2, R2, x0
LD R2, MAXVAL
JSR DISPLAYDIV                              ;SPLIT THE TWO DIGITS IN ORDE TO DISPLAY
LD R6, CONVERT                              ;LOAD THE ASCII CONVERSION TO GO FROM DECIMAL TO ASCII FOR DISPLAY
AND R0, R0, #0
ADD R0, R4, R6
OUT
AND R0, R0, #0
ADD R0, R5, R6
OUT
LEA R0, ENTER
PUTS
LEA R0, MINMSG                              ;DISPLAY "MIN SCORE: "
PUTS
AND R2, R2, x0
LD R2, MINVAL
JSR DISPLAYDIV                              ;SPLIT THE TWO DIGITSIN ORDER TO DISPALY
LD R6, CONVERT                              ;LOAD THE ASCII CONVERSION TO GO FROM DECIMAL TO ASCII FOR DISPLAY
AND R0, R0, #0
ADD R0, R4, R6
OUT                                         ;DISPLAY FIRST DIGIT
AND R0, R0, #0
ADD R0, R5, R6
OUT                                         ;DISPLAY SECOND DIGIT
LEA R0, ENTER
PUTS
LEA R0, AVEMSG                              ;LOAD AND DISPLAY
PUTS
AND R2, R2, x0
LD R2, AVERAGE
JSR DISPLAYDIV                              ;SPLIT THE TWO DIGITS IN ORDER TO DISPLAY
LD R6, CONVERT
AND R0, R0, #0
ADD R0, R4, R6                              ;DECIMAL TO INTEGER
OUT
AND R0, R0, #0
ADD R0, R5, R6
OUT
LEA R0, ENTER
PUTS
JSR GRADE

CONVERT             .FILL #48

;GRADE;
;GRADE DECIPHERS THE GRADE;
GRADE
AND R5, R5, #0
LEA R0, GRADEMSG                            ;LOAD GRADE MSG AND DISPLAY ON CONSOLE
PUTS
LDI R5, AVERAGE                              ;LOAD THE VALUES NEEDED INTO THE REGISTERS
LDI R3, GRADEF
ADD R5, R5, R3                              ;DECIPHER IF THE PERSON HAS AN F
BRnz FGRADE                                 ;IF SCORE IS 59 OR LOWER BRANCHES TO DISPLAY THE GRADE F

ADD R5, R5, #-10
BRnz DGRADE                                 ;IF SCORE IS 69-60 BRANCHES TO DISPLAY THE GRADE D

ADD R5, R5, #-10
BRnz CGRADE                                 ;IF SCORE IS 79-70 BRANCHES TO DISPLAY THE GRADE C

ADD R5, R5, #-10
BRnz BGRADE                                 ;IF SCORE IS 89-80 BRANCHES TO DISPLAY THE GRADE B

ADD R5, R5, #-10
BRnz AGRADE                                 ;IF SCORE IS 100-90 BRANCHES TO DISPLAY THE GRADE A

;FGRADE;
;DISPLAYS THE ASCII OF F;
FGRADE
AND R4, R4, #0
LD R4, F                                    ;LOAD ASCII VALUE NTO R4
ADD R0, R4, #0
OUT
HALT

;DGRADE;
;DISPLAYS THE ASCII OF D;
DGRADE
AND R4, R4, #0
LD R4, D                                    ;LOAD ASCII VALUE NTO R4
ADD R0, R4, #0
OUT
HALT

;CGRADE;
;DISPLAYS THE ASCII OF C;
CGRADE
AND R4, R4, #0
LD R4, C                                    ;LOAD ASCII VALUE NTO R4
ADD R0, R4, #0
OUT
HALT

;BGRADE;
;DISPLAYS THE ASCII OF B;
BGRADE
AND R4, R4, #0
LD R4, B                                    ;LOAD ASCII VALUE NTO R4
ADD R0, R4, #0
OUT
HALT

;AGRADE;
;DISPLAYS THE ASCII OF A;
AGRADE
AND R4, R4, #0
LD R4, A                                    ;LOAD ASCII VALUE NTO R4
ADD R0, R4, #0
OUT
HALT



;DISPLAYDIV;
;DIVIDES THE SCORE BY 10 TO DISPLAY THE SCORE;
DISPLAYDIV
AND R1, R1, #0
ST R2, SAVE2
LD R1, TEN                                  ;LOAD DECIMAL 10 INTO R1
AND R4, R4, #0                              ;CLEAR R4 FOR QUOTIENT
NOT R1, R1                                  ;2S COMPLIMENT
ADD R1, R1, #1
DIVLOOP
AND R5, R5, x0                              ;R5 HOLDS THE MODULUS
ADD R4, R4, #1                              ;INCREMENT QUOTIENT
ADD R5, R2, x0
ADD R2, R2, R1
BRzp DIVLOOP
ADD R4, R4, #-1
RET



SAVE2       .FILL x0

;SETMIN SUBROUTINE;
;SETS THE VALUE TO MINVAL;
SETMIN
ST R1, MINVAL                               ;store the minimum value into the address minval
RET

;SETMAX SUBROUTINE;
;SETS THE VALUE TO MAXVAL;
SETMAX
ST R1, MAXVAL                               ;STORE THE MAX VALUE INTO THE ADDRESS OF MAXVAL
RET

MINVAL      .FILL x0
MAXVAL      .FILL x0
TOTAL       .FILL x0



;PUSH SUBROUTINE;
;PUSHES THE SCORE ONTO THE STACK;

PUSH
ADD R6, R6, #-1                             ;DECREMENT STACK PTR
STR R0, R6, #0                              ;STORE DATA
RET

;POP SUBROUTINE;
;POPS A SCORE OFF THE STACK;

POP
LD R1, EMPTY                                ;CHECK IF EMPTY
ADD R2, R6, R1                              ;COMPARE STACK POINTER
BRz FAIL
LDR R0, R6, #0
ADD R6, R6, #1
AND R5, R5, #0
RET

FAIL
AND R5, R5, #0
ADD R5, R5, #1
RET


;STRINGZ
PROMPT              .STRINGZ "PLEASE INPUT THE FIRST DIGIT OF THE TEST SCORE: "
PROMPT1             .STRINGZ "PLEASE INPUT THE SECOND DIGIT OF THE TEST SCORE: "
MINMSG              .STRINGZ "MIN SCORE: "
MAXMSG              .STRINGZ "MAX SCORE: "
AVEMSG              .STRINGZ "AVERAGE SCORE: "
GRADEMSG            .STRINGZ "GRADE: "
ENTER               .STRINGZ "\n"


;VARIABLES
EMPTY               .FILL xC000
TEN                 .FILL #10
GRADEF              .FILL #-59
A                   .FILL x41
B                   .FILL x42
C                   .FILL x43
D                   .FILL x44
F                   .FILL x46

.END         