LIST  P=16F628A           
    INCLUDE <P16F628A.INC>    

    __CONFIG    _XT_OSC & _PWRTE_ON & _CP_OFF & _MCLRE_ON & _WDT_OFF 

    ORG   0x00                

    ; Configuración de puertos
    BSF     STATUS, RP0        ; Cambia al banco 1
    BCF     TRISA, RA0         ; RA0 como entrada (Botón 1)
    BCF     TRISA, RA1         ; RA1 como entrada (Botón 2)
    BCF     TRISB, RB0         ; RB0 como salida (Control de transistor 1 - Relay 1)
    BCF     TRISB, RB1         ; RB1 como salida (Control de transistor 2 - Relay 2)
    BCF     STATUS, RP0        ; Regresa al banco 0

    ; Inicialización
    BCF     PORTB, RB0         ; Asegura que Relay 1 esté apagado
    BCF     PORTB, RB1         ; Asegura que Relay 2 esté apagado

BUCLE_PRINCIPAL
    ; Control del motor
    BTFSC   PORTA, RA0         ; Si se presiona el Botón 1 (RA0)
    GOTO    GIRO_HORARIO       ; Gira en sentido horario
    BTFSC   PORTA, RA1         ; Si se presiona el Botón 2 (RA1)
    GOTO    GIRO_ANTIHORARIO   ; Gira en sentido antihorario
    GOTO    APAGAR_MOTOR       ; Si no se presiona ningún botón, apaga el motor

GIRO_HORARIO
    BSF     PORTB, RB0         ; Activa Relay 1 (Giro horario)
    BCF     PORTB, RB1         ; Asegura que Relay 2 esté apagado
    GOTO    BUCLE_PRINCIPAL    ; Regresa al bucle principal

GIRO_ANTIHORARIO
    BCF     PORTB, RB0         ; Asegura que Relay 1 esté apagado
    BSF     PORTB, RB1         ; Activa Relay 2 (Giro antihorario)
    GOTO    BUCLE_PRINCIPAL    ; Regresa al bucle principal

APAGAR_MOTOR
    BCF     PORTB, RB0         ; Apaga Relay 1
    BCF     PORTB, RB1         ; Apaga Relay 2
    GOTO    BUCLE_PRINCIPAL    ; Regresa al bucle principal

    END                        ; Fin del programa
