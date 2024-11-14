    list p=16F628A
    include "P16F628A.inc"
    __CONFIG _FOSC_XT & _WDTE_OFF & _PWRTE_ON & _MCLRE_ON & _BOREN_ON & _LVP_OFF & _CP_OFF & _CPD_OFF

; Definición de pines
ROJO1       EQU     0x05    ; RB5 (Semáforo 1 Rojo)
AMARILLO1   EQU     0x04    ; RB4 (Semáforo 1 Amarillo)
VERDE1      EQU     0x03    ; RB3 (Semáforo 1 Verde)
ROJO2       EQU     0x02    ; RB2 (Semáforo 2 Rojo)
AMARILLO2   EQU     0x01    ; RB1 (Semáforo 2 Amarillo)
VERDE2      EQU     0x00    ; RB0 (Semáforo 2 Verde)
BOTON1      EQU     0x00    ; RA0 (Pulsador 1)
BOTON2      EQU     0x01    ; RA1 (Pulsador 2)

; Variables
    CBLOCK 0x20
    estado          ; Estado del semáforo (0: apagado, 1: encendido)
    ENDC

; Inicio del programa
    ORG 0x0000
    goto INICIO

INICIO:
    bsf STATUS, RP0       ; Cambiar a banco 1
    movlw 0x00
    movwf TRISB           ; Puerto B como salida (LEDs)
    movlw 0x03            ; RA0 y RA1 como entradas (Pulsadores)
    movwf TRISA
    bcf STATUS, RP0       ; Volver a banco 0

    ; Inicializar LEDs apagados
    clrf PORTB            ; Apagar todos los LEDs al inicio
    movlw 0x00
    movwf estado          ; Inicializar estado a apagado

MAIN_LOOP:
    ; Comprobar si se presiona el BOTON1
    btfsc PORTA, BOTON1   ; Si BOTON1 está presionado
    call INICIO_SEMAFORO  ; Iniciar secuencia de semáforo

    ; Comprobar si se presiona el BOTON2
    btfsc PORTA, BOTON2   ; Si BOTON2 está presionado
    call APAGAR_SEMAFORO  ; Apagar semáforo

    goto MAIN_LOOP        ; Volver al bucle principal

INICIO_SEMAFORO:
    ; Verificar que el semáforo no esté encendido ya
    movf estado, W
    btfsc STATUS, Z       ; Si el estado es 0 (apagado), proceder
    goto ENCENDER_SEMAFOROS

    return                ; Si ya están encendidos, no hacer nada

ENCENDER_SEMAFOROS:
    ; Cambiar el estado a encendido
    movlw 0x01
    movwf estado

    ; Secuencia de semáforos
    ; Semáforo 1 en rojo, Semáforo 2 en verde
    bsf PORTB, ROJO1      ; Encender ROJO1
    bcf PORTB, VERDE2     ; Apagar VERDE2
    bcf PORTB, AMARILLO2  ; Apagar AMARILLO2
    bsf PORTB, VERDE2     ; Encender VERDE2
    call RETARDO_5S       ; Esperar 5 segundos

    ; Semáforo 1 sigue en rojo, Semáforo 2 en amarillo
    bcf PORTB, VERDE2     ; Apagar VERDE2
    bsf PORTB, AMARILLO2  ; Encender AMARILLO2
    call RETARDO_2S       ; Esperar 2 segundos

    ; Semáforo 1 en verde, Semáforo 2 en rojo
    bcf PORTB, ROJO1      ; Apagar ROJO1
    bsf PORTB, VERDE1     ; Encender VERDE1
    bcf PORTB, AMARILLO2  ; Apagar AMARILLO2
    bsf PORTB, ROJO2      ; Encender ROJO2
    call RETARDO_5S       ; Esperar 5 segundos

    ; Semáforo 1 en amarillo, Semáforo 2 en rojo
    bcf PORTB, VERDE1     ; Apagar VERDE1
    bsf PORTB, AMARILLO1  ; Encender AMARILLO1
    call RETARDO_2S       ; Esperar 2 segundos

    goto MAIN_LOOP

APAGAR_SEMAFORO:
    clrf PORTB            ; Apagar todos los LEDs
    movlw 0x00
    movwf estado          ; Estado en apagado
    return

; Rutinas de retardo
RETARDO_5S:
    movlw D'100'          ; Ajusta esto para obtener aproximadamente 5 segundos
RETARDO_5S_LOOP:
    nop
    nop
    nop
    nop
    nop
    decfsz estado, f      ; Decrementar estado y repetir si no es cero
    goto RETARDO_5S_LOOP
    return

RETARDO_2S:
    movlw D'40'           ; Ajusta esto para obtener aproximadamente 2 segundos
RETARDO_2S_LOOP:
    nop
    nop
    nop
    nop
    nop
    decfsz estado, f      ; Decrementar estado y repetir si no es cero
    goto RETARDO_2S_LOOP
    return

    END
