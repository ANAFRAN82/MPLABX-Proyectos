LIST  P=16F628A ;MICROCONTROLADOR A USAR

INCLUDE <P16F628A.INC>   ;IMPORTAMOS LAS INTRUCCIONES DEL MICROCONTROLADOR

__CONFIG    _XT_OSC & _PWRTE_ON & _CP_OFF & _MCLRE_ON & _WDT_OFF       

#define LEDS        PORTA
#define BOTON_RRF   RA0             ; Botón para RRF
#define BOTON_LRF   RA1             ; Botón para LRF

ORG     0x00
GOTO    INICIO 
INICIO
    BSF     STATUS, RP0             ; Seleccionar el banco 1
    CLRF    LEDS                    ; Limpiar el puerto B (LEDs apagados)
    MOVLW   0x03                    ; Cargar el valor 0xFF en W
    MOVWF   CMCON                   
    MOVLW   b'00000011'           ; Configurar RB0 y RB1 como entradas
    MOVWF   TRISB                   ; Configurar el puerto B como entrada
    BCF     STATUS, RP0             ; Volver al banco 0

    LOOP
        BTFSS   BOTON_RRF, 0        ; Si el botón de RRF 
        CALL    DERECHA             ; Llamar a la función para rotar
        BTFSS   BOTON_LRF, 0        ; Si el botón de LRF está presionado
        CALL    IZQUIERDA           ; Llamar a la función para rotar a la izq
    GOTO    LOOP                    ; Volver al principio del bucle

DERECHA
    RRF     LEDS, F                ; Rotar a la derecha el valor de LEDS
    BTFSC   PORTA,BOTON_RRF
    GOTO $-1
    NOP
    RETURN

IZQUIERDA
    RRF     LEDS, F                ; Rotar a la IZQUIERDA el valor de LEDS
    BTFSC   PORTA,BOTON_LRF
    GOTO $-1
    NOP
    RETURN
     
END
