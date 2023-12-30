.MODEL SMALL
.STACK 64
.DATA
    NL      DB 13,10,'$'
    MSG     DB 'GAME Instruction: Rock=0, Paper= 1, Scissors= 2, $', 0
    PL      DB 'Player : $', 0
    COMP    DB 'Computer: $', 0
    WIN_MSG DB 'Winner Winner Chicken Dinner! $', 0
    LST_MSG DB 'Loser, Loser, Nyquil Boozer! $', 0
    DR_MSG  DB 'It is draw $', 0
    ROCK    DB 'Rock $', 0
    PAPER   DB 'Paper $', 0
    SCISS   DB 'Scissors $', 0
.CODE
;======================================
        ; Entery point
    MAIN PROC FAR
        .STARTUP
    START:
        ; Display Game Instruction Message
        LEA DX, MSG      
        MOV AH, 09h
        INT 21h
        ; print new line
        LEA DX, NL      
        MOV AH, 09h
        INT 21h
        ; Print player 1 message
        LEA DX, PL      
        MOV AH, 09h
        INT 21h
        ; Take player 1 Choice
        MOV AH,08              
        INT 21h                
        MOV AH,02              
        MOV BL,AL              

;========================================
        ; Print player 1 choice like 0 => Rock, 1 => Paper, 2 => Scissors
        CMP AL, '0'
        JE C_ROCK
        JL START ; CHECK USER INPUT IS VALID?
        CMP AL, '1'
        JE C_PAPER
        CMP AL, '2'
        JE C_SCISS
        JG START ; CHECK USER INPUT IS VALID?
        
    C_ROCK:
        CALL PR_ROCK
        JMP COMPUTER
    C_PAPER:
        CALL PR_PAPER
        JMP COMPUTER
    C_SCISS:
        CALL PR_SCISS
        JMP COMPUTER
;========================================
    COMPUTER:
        LEA DX, NL       
        MOV AH, 09h
        INT 21h
        ; Print Computer message
        LEA DX, COMP      
        MOV AH, 09h
        INT 21h
        ; Generate a random number start from 0 to 2 for computer choice
        MOV AH, 00h 
        INT 1AH 
        MOV AX, DX
        XOR DX, DX
        MOV CX, 3
        DIV CX 
        ADD DL, '0' 
        MOV AH, 2h   
        MOV BH,DL
;========================================
        ; Print computer choice like 0 => Rock, 1 => Paper, 2 => Scissors
        CMP BH, '0'
        JE C_ROCK2
        CMP BH, '1'
        JE C_PAPER2
        CMP BH, '2'
        JE C_SCISS2
        
    C_ROCK2:
        CALL PR_ROCK
        JMP RESULT
    C_PAPER2:
        CALL PR_PAPER
        JMP RESULT
    C_SCISS2:
        CALL PR_SCISS
        JMP RESULT
;=========================================
        ; Checking the game propabilities
    RESULT: 
        LEA DX, NL       
        MOV AH, 09h
        INT 21h  

        ; DRAW
        CMP BL, BH
        JE  DRAW    
       
        CMP BL, '0' 
        JE  PROP0   
        CMP BL, '1' 
        JE  PROP1
        CMP BL, '2'
        JE  PROP2
        ; Player choose rock
    PROP0:
        CMP BH, '1' ; computer choose paper
        JE  LOST   
        CMP BH, '2' ; computer choose scissors
        JE  WIN   
        ; Player choose paper
    PROP1:  
        CMP BH, '0' ; computer choose rock
        JE  WIN   
        CMP BH, '2' ; computer choose scissors
        JE  LOST 
        ; Player choose scissors
    PROP2:  
        CMP BH, '0' ; computer choose rock
        JE  LOST   
        CMP BH, '1' ; computer choose paper
        JE  WIN 
;=======================================
        ; Print win message
    WIN:                     
        LEA DX, WIN_MSG     
        MOV AH, 09h
        INT 21h
        JMP Final
        ; Print draw message
    DRAW:                      
        LEA DX, DR_MSG   
        MOV AH, 09h
        INT 21h
        JMP Final
        ; Print loss message
    LOST:                     
        LEA DX, LST_MSG     
        MOV AH, 09h
        INT 21h
        JMP Final
;=======================================
        ; Exit point
    Final:   
        .EXIT
        INT 21h
        
    MAIN ENDP   
;=======================================
        ; Procedure to print rock
    PR_ROCK PROC NEAR
        LEA DX, ROCK      
        MOV AH, 09h
        INT 21h 
      RET  
    PR_ROCK ENDP
        ; Procedure to print paper    
    PR_PAPER PROC NEAR
        LEA DX, PAPER      
        MOV AH, 09h
        INT 21h
        RET
    PR_PAPER ENDP    
        ; Procedure to print Scissors        
    PR_SCISS PROC NEAR
        LEA DX, SCISS     
        MOV AH, 09h
        INT 21h
        RET
    PR_SCISS ENDP
        
    
END MAIN