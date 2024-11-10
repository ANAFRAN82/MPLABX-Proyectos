LIST P=16F84A
INCLUDE <P16F84A.INC>

CBLOCK 0X0C
    ; Nuevas variables
    Cont1
ENDC

ORG 0

bsf STATUS, RP0
movlw 0x00
movwf TRISB
bsf TRISA, RA0 ; Configura RA0 como entrada para incrementar
bsf TRISA, RA1 ; Configura RA1 como entrada para decrementar
bsf TRISA, RA2 ; Configura RA2 como entrada para reiniciar
bcf STATUS, RP0
clrf Cont1
clrf PORTB

Bucle
    ; Incrementa el contador si se activa el pulsador RA0
    btfss PORTA, RA0 ; Verifica si el pulsador RA0 está presionado
    goto NoIncrementar ; Si no está presionado, salta a la comprobación del decremento
    incf Cont1, F ; Incrementa el contador
    call ActualizarDisplay ; Actualiza el display de inmediato
    goto Esperar ; Espera hasta que se suelte el botón antes de continuar

NoIncrementar
    ; Decrementa el contador si se activa el pulsador RA1
    btfss PORTA, RA1 ; Verifica si el pulsador RA1 está presionado
    goto NoReiniciar ; Si no está presionado, salta a la comprobación de reinicio
    decf Cont1, F ; Decrementa el contador
    call ActualizarDisplay ; Actualiza el display de inmediato
    goto Esperar ; Espera hasta que se suelte el botón antes de continuar

NoReiniciar
    ; Reinicia el contador si se activa el pulsador RA2
    btfss PORTA, RA2 ; Verifica si el pulsador RA2 está presionado
    goto Esperar ; Si no está presionado, espera hasta que se presione algún botón
    clrf Cont1 ; Reinicia el contador a cero
    call ActualizarDisplay ; Actualiza el display de inmediato
    goto Esperar ; Espera hasta que se suelte el botón antes de continuar

Esperar
    ; Espera hasta que se suelten los botones antes de continuar
    btfsc PORTA, RA0
    goto Esperar
    btfsc PORTA, RA1
    goto Esperar
    btfsc PORTA, RA2
    goto Esperar

    goto Bucle

ActualizarDisplay
    movf Cont1, W
    call TABLA
    movwf PORTB
    return

TABLA
    addwf PCL, F
    DT 0x3F, 0x06, 0x5B, 0x4F, 0x66, 0x6D, 0x7D, 0x07, 0x7F, 0x67, 0x77, 0x7C, 0x39, 0x5E, 0x79, 0x71
    END
