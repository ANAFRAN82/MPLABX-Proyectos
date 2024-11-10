INCLUDE "P16F84A.INC"
ORG 0X00
BSF STATUS,5
CLRF PORTA                ;puerto A es de salida
MOVLW B'11111111'
MOVWF TRISB            ;puerto B es  entrada de sensores
BCF STATUS,5
CLRF PORTB

;programa principal

INICIO
SUBEPISO1  BTFSS PORTB,0
                      GOTO SUBEPISO1
                      CALL SUBE
STOP1           BTFSS PORTB,5
                      GOTO STOP1
                      CALL STOP
SUBEPISO2  BTFSS PORTB,1
                      GOTO SUBEPISO2
                      CALL SUBE
STOP2          BTFSS PORTB,6
                      GOTO STOP2
                      CALL STOP
SUBEPISO3  BTFSS PORTB,2
                      GOTO SUBEPISO3
                     CALL SUBE
STOP3         BTFSS PORTB,7
                    GOTO STOP3
                    CALL STOP

BAJAPISO2   BTFSS PORTB,1
                      GOTO BAJAPISO2
                      CALL BAJA
PARADA2    BTFSS PORTB,6
                     GOTO PARADA2
                     CALL STOP
BAJAPISO1  BTFSS PORTB,0
                      GOTO BAJAPISO1
                      CALL BAJA
PARADA1    BTFSS PORTB,5
                     GOTO PARADA1
                     CALL STOP
                     GOTO INICIO

;Subrutinas de stop, bajada y subida de motor

STOP            MOVLW B'00000000'
                      MOVWF PORTA
                      RETURN
SUBE            MOVLW B'00000010'
                      MOVWF PORTA
                      RETURN
BAJA             MOVLW B'00000100'
                       MOVWF PORTA
                       RETURN
                       END