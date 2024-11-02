.model small
.stack 100h

; Ajustes en las definiciones
MIN_COL_INSERT EQU 450
MAX_COL_INSERT EQU 620
MIN_ROW_INSERT EQU 420
MAX_ROW_INSERT EQU 470

.data
    COLOR_SELECTED db 4
    COLORS         db "COLORS$"
    CLEAR          db "CLEAR$"
    SAVE           db "SAVE$"
    LOAD           db "LOAD$"
    INSERT         db "INSERT$"
    FILENAME       db "File Name:$"
    XPOS           db "X:$"
    YPOS           db "Y:$"
    buffer         DB 6 DUP(0)        ; Buffer para almacenar el número convertido a cadena
    TEN            DW 10              ; Valor constante 10 para la división
    text           DB 100 DUP('$')    ; Buffer para almacenar el texto ingresado por el usuario
    COL            DW ?
    FIL            DW ?
    X              DW 220
    Y              DW 305
    SKETCH_X       DW 220
    SKETCH_Y       DW 305
    fileNameBuffer DB 'FILE.txt', 0
    matrixBuffer   DB 500 DUP(0)
    handle         DW ?

    SETPOSITION MACRO x, y
        MOV ah, 02h
        MOV bh, 0
        MOV dh, x 
        MOV dl, y
        INT 10h
    ENDM

    DRAW_PIXEL MACRO color, x, y
        MOV ah, 0CH
        MOV AL, color 
        MOV bh, 00
        MOV cx, x
        MOV dx, y
        INT 10H
    ENDM

    PRINTMESSAGE MACRO msg
        MOV ah, 9
        MOV dx, OFFSET msg
        INT 21h 
    ENDM

    DRAW_SQUARE MACRO x_inicial, x_final, y_inicial, y_final, color
        MOV AH, 6          ; Función para scroll hacia arriba (limpiar pantalla)
        MOV AL, 0          ; Número de líneas a desplazar (0 significa llenar con el color)
        MOV BH, color      ; Color de fondo
        MOV CH, y_inicial  ; Coordenada Y inicial
        MOV CL, x_inicial  ; Coordenada X inicial
        MOV DH, y_final    ; Coordenada Y final
        MOV DL, x_final    ; Coordenada X final
        INT 10H            ; Llamada a la interrupción del BIOS de video
    ENDM

.code
main PROC
    ; Inicialización de datos
    MOV ax, @DATA
    MOV ds, ax

    ; Configuración de color de fondo
    MOV ah, 00
    MOV al, 12H
    INT 10H

    ; Inicialización del ratón
    MOV ax, 00 
    INT 33h
    MOV ax, 01h 
    INT 33h

    ; Imprimir etiquetas para cada botón
    SETPOSITION 1, 24
    PRINTMESSAGE COLORS

    SETPOSITION 24, 64
    PRINTMESSAGE CLEAR

    SETPOSITION 27, 64
    PRINTMESSAGE INSERT

    SETPOSITION 1, 64
    PRINTMESSAGE SAVE

    SETPOSITION 4, 64
    PRINTMESSAGE LOAD

    SETPOSITION 8, 62
    PRINTMESSAGE FILENAME

    SETPOSITION 19, 61
    PRINTMESSAGE XPOS

    SETPOSITION 20, 61
    PRINTMESSAGE YPOS

    ; Pintar los colores
    DRAW_SQUARE 5, 10, 2, 3, 1
    DRAW_SQUARE 15, 20, 2, 3, 2
    DRAW_SQUARE 25, 30, 2, 3, 3 
    DRAW_SQUARE 35, 40, 2, 3, 4 
    DRAW_SQUARE 45, 50, 2, 3, 5

    DRAW_SQUARE 5, 10, 5, 6, 6
    DRAW_SQUARE 15, 20, 5, 6, 10
    DRAW_SQUARE 25, 30, 5, 6, 13
    DRAW_SQUARE 35, 40, 5, 6, 14
    DRAW_SQUARE 45, 50, 5, 6, 15  

    ; Área del botón de guardar
    MOV COL, 485
    MOV cx, 100
Save_Horizontal: 
    PUSH cx
    DRAW_PIXEL 11, COL, 5
    DRAW_PIXEL 11, COL, 45
    INC COL
    POP cx
    LOOP Save_Horizontal

    MOV FIL, 5
    MOV cx, 40
Save_Vertical:
    PUSH cx
    DRAW_PIXEL 11, 485, FIL
    DRAW_PIXEL 11, 585, FIL 
    INC FIL
    POP cx 
    LOOP Save_Vertical

    ; Área del botón de cargar
    MOV COL, 450
    MOV cx, 170
Load_Horizontal:
    PUSH cx
    DRAW_PIXEL 4, COL, 55
    DRAW_PIXEL 4, COL, 110
    INC COL
    POP cx
    LOOP Load_Horizontal

    MOV FIL, 55
    MOV cx, 55
Load_Vertical:
    PUSH cx
    DRAW_PIXEL 4, 450, FIL
    DRAW_PIXEL 4, 620, FIL
    INC FIL
    POP cx
    LOOP Load_Vertical

    ; Área del nombre de archivo
    MOV COL, 450 
    MOV cx, 170
Name_Horizontal:
    PUSH cx
    DRAW_PIXEL 5, COL, 125
    DRAW_PIXEL 5, COL, 180
    INC COL
    POP cx
    LOOP Name_Horizontal

    MOV FIL, 125
    MOV cx, 55
Name_Vertical:
    PUSH cx
    DRAW_PIXEL 5, 450, FIL
    DRAW_PIXEL 5, 620, FIL
    INC FIL
    POP cx 
    LOOP Name_Vertical

    ; Área del botón de limpiar
    MOV COL, 485
    MOV cx, 100
Clear_Horizontal:
    PUSH cx
    DRAW_PIXEL 12, COL, 370
    DRAW_PIXEL 12, COL, 400
    INC COL
    POP cx
    LOOP Clear_Horizontal

    MOV FIL, 370
    MOV cx, 30
Clear_Vertical:
    PUSH cx
    DRAW_PIXEL 12, 485, FIL
    DRAW_PIXEL 12, 585, FIL
    INC FIL
    POP cx
    LOOP Clear_Vertical

    ; Área del botón de insertar
    MOV COL, 450
    MOV cx, 170
Insert_Horizontal:
    PUSH cx
    DRAW_PIXEL 10, COL, 420
    DRAW_PIXEL 10, COL, 470
    INC COL
    POP cx
    LOOP Insert_Horizontal

    MOV FIL, 420
    MOV cx, 50
Insert_Vertical:
    PUSH cx
    DRAW_PIXEL 10, 450, FIL
    DRAW_PIXEL 10, 620, FIL
    INC FIL
    POP cx
    LOOP Insert_Vertical

    ; Dibujar áreas de zona de trabajo
    MOV cx, 400
    MOV COL, 20
Sketch_horizontal: 
    PUSH cx
    DRAW_PIXEL 15, COL, 140
    DRAW_PIXEL 15, COL, 470
    INC COL 
    POP cx
    LOOP Sketch_horizontal

    MOV cx, 331
    MOV FIL, 140
Sketch_vertical:
    PUSH cx
    DRAW_PIXEL 15, 20, FIL
    DRAW_PIXEL 15, 420, FIL
    INC FIL     
    POP cx
    LOOP Sketch_vertical

    ; Área de selección de color
    MOV COL, 20
    MOV cx, 400
Colors_Horizontal:
    PUSH cx
    DRAW_PIXEL 1, COL, 10
    DRAW_PIXEL 14, COL, 130
    INC COL
    POP cx
    LOOP Colors_Horizontal

    MOV FIL, 10
    MOV cx, 120
Colors_Vertical:
    PUSH cx
    DRAW_PIXEL 4, 20, FIL
    DRAW_PIXEL 2, 420, FIL
    INC FIL     
    POP cx
    LOOP Colors_Vertical

principal_Loop:
    CALL read_Key
    CALL CheckMouse
    JMP principal_Loop

PRINT_COORDINATES PROC
    MOV AX, X
    CALL NUM_TO_STRING
    SETPOSITION 19, 68
    PRINTMESSAGE buffer

    MOV AX, Y
    CALL NUM_TO_STRING
    SETPOSITION 20, 68
    PRINTMESSAGE buffer
PRINT_COORDINATES ENDP

NUM_TO_STRING PROC
    ; Convertir el número en AX a cadena en el buffer
    PUSH DX
    PUSH CX
    PUSH BX
    MOV SI, OFFSET buffer
    MOV CX, 0

    CMP AX, 0
    JNE ConvertLoop
    MOV BYTE PTR [SI], '0'
    INC SI
    JMP EndConvert

ConvertLoop:
    MOV DX, 0
    DIV TEN
    ADD DL, '0'
    PUSH DX
    INC CX
    TEST AX, AX
    JNZ ConvertLoop

PopDigits:
    POP DX
    MOV [SI], DL
    INC SI
    LOOP PopDigits

EndConvert:
    MOV BYTE PTR [SI], '$'
    INC SI
    POP BX
    POP CX
    POP DX
    RET
NUM_TO_STRING ENDP

CheckMouse PROC
    ; Verificar si el botón izquierdo del ratón se ha presionado
    MOV ax, 03h
    INT 33h

    TEST bx, 01h
    JZ NoClick

    MOV X, CX
    MOV Y, DX

    CALL CLEAR_SCREEN
    CALL PRINT_COORDINATES
    CALL CheckInterSketchZone
    CALL CheckClearZone
    CALL CheckClick
    CALL CheckGuardar
    CALL CheckCargar

NoClick:
    RET
CheckMouse ENDP

CheckInterSketchZone PROC
    CMP X, 20
    JL CheckInterSketchZoneEnd
    CMP X, 420
    JG CheckInterSketchZoneEnd
    CMP Y, 140
    JL CheckInterSketchZoneEnd
    CMP Y, 470
    JG CheckInterSketchZoneEnd

    MOV AX, X
    MOV SKETCH_X, AX
    MOV BX, Y
    MOV SKETCH_Y, BX

CheckInterSketchZoneEnd:
    RET
CheckInterSketchZone ENDP 

CheckClearZone PROC
    CMP X, 485
    JL ENDZONE
    CMP X, 585
    JG ENDZONE
    CMP Y, 370
    JL ENDZONE
    CMP Y, 410
    JG ENDZONE

    CALL PINTARLIMPIAR

ENDZONE:
    RET
CheckClearZone ENDP

PINTARLIMPIAR PROC
    DRAW_SQUARE 02, 52, 08, 29, 0
    MOV cx, 400
    MOV COL, 20
Sketch_horizontal1: 
    PUSH cx
    DRAW_PIXEL 15, COL, 140
    DRAW_PIXEL 15, COL, 470
    INC COL 
    POP cx
    LOOP Sketch_horizontal1

    MOV cx, 331
    MOV FIL, 140
Sketch_vertical1:
    PUSH cx
    DRAW_PIXEL 15, 20, FIL
    DRAW_PIXEL 15, 420, FIL
    INC FIL     
    POP cx
    LOOP Sketch_vertical1

    MOV COL, 20
    MOV cx, 400
Colors_Horizontal1:
    PUSH cx
    DRAW_PIXEL 1, COL, 10
    DRAW_PIXEL 14, COL, 130
    INC COL
    POP cx
    LOOP Colors_Horizontal1

    MOV FIL, 10
    MOV cx, 120
Colors_Vertical1:
    PUSH cx
    DRAW_PIXEL 4, 20, FIL
    DRAW_PIXEL 2, 420, FIL
    INC FIL     
    POP cx
    LOOP Colors_Vertical1
PINTARLIMPIAR ENDP

read_Key PROC 
    ; Leer el estado de una tecla
    MOV ah, 01h
    INT 16h
    JZ NoKeyFirstTwoTeclas

    MOV ah, 00h
    INT 16h

    ; Verificar los códigos de las teclas de dirección
    CMP ah, 48h
    JE Tcl_up
    CMP ah, 50h
    JE Tcl_down
    CMP ah, 4Bh
    JE Tcl_left
    CMP ah, 4Dh
    JE Tcl_right

    JMP NoKeyFirstTwoTeclas

Tcl_up:
    CMP SKETCH_Y, 141
    JLE Tcl_end
    CMP SKETCH_X, 21
    JL Tcl_end
    CMP SKETCH_X, 419
    JG Tcl_end
    DEC SKETCH_Y
    JMP Tcl_end

Tcl_down:
    CMP SKETCH_Y, 469
    JGE Tcl_end
    CMP SKETCH_X, 21
    JL Tcl_end
    CMP SKETCH_X, 419
    JG Tcl_end
    INC SKETCH_Y
    JMP Tcl_end

NoKeyFirstTwoTeclas:
    RET

Tcl_left:
    CMP SKETCH_X, 21
    JLE Tcl_end
    CMP SKETCH_Y, 141
    JL Tcl_end
    CMP SKETCH_Y, 469
    JG Tcl_end
    DEC SKETCH_X
    JMP Tcl_end

Tcl_right:
    CMP SKETCH_X, 419
    JGE Tcl_end
    CMP SKETCH_Y, 141
    JL Tcl_end
    CMP SKETCH_Y, 469
    JG Tcl_end
    INC SKETCH_X
    JMP Tcl_end

Tcl_end:
    CMP SKETCH_X, 21
    JL No_draw
    CMP SKETCH_X, 419
    JG No_draw
    CMP SKETCH_Y, 141
    JL No_draw
    CMP SKETCH_Y, 469
    JG No_draw

    DRAW_PIXEL COLOR_SELECTED, SKETCH_X, SKETCH_Y
    MOV AX, SKETCH_X
    MOV X, AX
    MOV BX, SKETCH_Y
    MOV Y, BX
    CALL CLEAR_SCREEN
    CALL PRINT_COORDINATES
    JMP Done

No_draw:
    JMP Done

Done:
    RET

No_key:
    RET
read_Key ENDP

CLEAR_SCREEN PROC
    PUSH AX
    PUSH CX
    PUSH DX
    PUSH BX
    MOV AX, 0600h
    MOV BH, 00h
    MOV CX, 153Fh
    MOV DX, 164Fh
    INT 10h
    POP BX
    POP DX
    POP CX
    POP AX
    RET
CLEAR_SCREEN ENDP

CheckClick PROC
CheckColor1:
    CMP X, 040
    JL CheckColor2
    CMP X, 086
    JG CheckColor2
    CMP Y, 032
    JL CheckColor2
    CMP Y, 063
    JG CheckColor2
    MOV COLOR_SELECTED, 1
    JMP EndCheck1

CheckColor2:
    CMP X, 120
    JL CheckColor3
    CMP X, 166
    JG CheckColor3
    CMP Y, 032
    JL CheckColor3
    CMP Y, 063
    JG CheckColor3
    MOV COLOR_SELECTED, 2
    JMP EndCheck1

CheckColor3:
    CMP X, 200
    JL CheckColor4
    CMP X, 246
    JG CheckColor4
    CMP Y, 032
    JL CheckColor4
    CMP Y, 063
    JG CheckColor4
    MOV COLOR_SELECTED, 3
    JMP EndCheck1

CheckColor4:
    CMP X, 280
    JL CheckColor5
    CMP X, 326
    JG CheckColor5
    CMP Y, 032
    JL CheckColor5
    CMP Y, 063
    JG CheckColor5
    MOV COLOR_SELECTED, 4
    JMP EndCheck1

CheckColor5:
    CMP X, 406
    JG CheckColor6
    CMP Y, 032
    JL CheckColor6
    CMP X, 360
    JL CheckColor6
    CMP Y, 063
    JG CheckColor6
    MOV COLOR_SELECTED, 5
    JMP EndCheck1

EndCheck1:
    JMP EndCheck

CheckColor6:
    CMP X, 040
    JL EndCheck2
    CMP X, 086
    JG CheckColor7
    CMP Y, 080
    JL EndCheck2
    CMP Y, 110
    JG EndCheck2
    MOV COLOR_SELECTED, 6
    JMP EndCheck

CheckColor7:
    CMP X, 120
    JL EndCheck2
    CMP X, 166
    JG CheckColor8
    CMP Y, 080
    JL EndCheck2
    CMP Y, 110
    JG EndCheck
    MOV COLOR_SELECTED, 10
    JMP EndCheck2
 
EndCheck2:
    JMP EndCheck

CheckColor8:
    CMP X, 200
    JL EndCheck
    CMP X, 246
    JG CheckColor9
    CMP Y, 080
    JL EndCheck
    CMP Y, 110
    JG EndCheck
    MOV COLOR_SELECTED, 13
    JMP EndCheck

CheckColor9:
    CMP X, 280
    JL EndCheck
    CMP X, 326
    JG CheckColor10
    CMP Y, 080
    JL EndCheck
    CMP Y, 110
    JG EndCheck
    MOV COLOR_SELECTED, 14
    JMP EndCheck

CheckColor10:
    CMP X, 360
    JL EndCheck
    CMP X, 406
    JG EndCheck
    CMP Y, 080
    JL EndCheck
    CMP Y, 110
    JG EndCheck
    MOV COLOR_SELECTED, 15
    JMP EndCheck

EndCheck:
    RET
CheckClick ENDP

CheckGuardar PROC
    CMP X, 485
    JL CheckGuardarEndCheck
    CMP X, 585
    JG CheckGuardarEndCheck
    CMP Y, 5
    JL CheckGuardarEndCheck 
    CMP Y, 45
    JG CheckGuardarEndCheck
    CALL SAVE_MATRIX

CheckGuardarEndCheck:
    RET
CheckGuardar ENDP

CheckCargar PROC
    CMP X, 450
    JL CheckCargarEndCheck
    CMP X, 620
    JG CheckCargarEndCheck
    CMP Y, 55
    JL CheckCargarEndCheck 
    CMP Y, 100
    JG CheckCargarEndCheck
    CALL loadFile

CheckCargarEndCheck:
    RET
CheckCargar ENDP

loadFile PROC
    PUSH AX DX CX BX
    MOV AH, 3DH
    MOV AL, 0
    LEA DX, fileNameBuffer
    INT 21h
    JC LoadExit

    MOV handle, AX

    MOV AH, 3FH
    LEA DX, matrixBuffer
    MOV CX, 500
    INT 21H
    JC LoadError

    MOV AH, 3EH
    MOV BX, handle
    INT 21H

    CALL DisplayMatrix
    JMP LoadExit

LoadError:
    MOV DX, OFFSET SAVE
    MOV AH, 09H
    INT 21H

LoadExit:
    POP BX CX DX AX
    RET
loadFile ENDP

DisplayMatrix PROC
    MOV SI, OFFSET matrixBuffer
    MOV Y, 141
    MOV DI, 0
DisplayRows:
    MOV X, 21
DisplayColumns:
    MOV AL, [matrixBuffer + DI]
    CMP AL, '@'
    JE NextRow
    CMP AL, '%'
    JE EndDisplay

    CALL HexToByte
    DRAW_PIXEL AL, X, Y
    PUSH AX

    INC X
    INC DI
    JMP DisplayColumns

NextRow:
    INC Y
    INC DI
    JMP DisplayRows

EndDisplay:
    RET
DisplayMatrix ENDP

HexToByte PROC
    CMP AL, '0'
    JB NotHexChar
    CMP AL, '9'
    JA CheckAlpha
    SUB AL, '0'
    JMP Echo

CheckAlpha:
    CMP AL, 'A'
    JB CheckLower
    CMP AL, 'F'
    JA CheckLower
    SUB AL, 'A'
    ADD AL, 10
    JMP Echo

CheckLower:
    CMP AL, 'a'
    JB NotHexChar
    CMP AL, 'f'
    JA NotHexChar
    SUB AL, 'a'
    ADD AL, 10

Echo:
    RET

NotHexChar:
    MOV AL, 0
    RET
HexToByte ENDP

SAVE_MATRIX PROC
    MOV AH, 3CH
    LEA DX, fileNameBuffer
    MOV CX, 1
    INT 21h
    JC ErrorSaveFile

    MOV handle, AX
    MOV Y, 141

SaveRows:
    MOV DI, 0
    MOV X, 21
SaveColummns:
    MOV AH, 0DH
    MOV BH, 00H
    MOV CX, X
    MOV DX, Y
    INT 10h
    CALL ByteToHex
    MOV [matrixBuffer + DI], AL
    INC DI
    INC X
    CMP X, 420
    JL SaveColummns

    MOV BYTE PTR [matrixBuffer + DI], '@'
    INC DI
    LEA DX, matrixBuffer
    MOV AH, 40H
    MOV BX, handle
    MOV CX, DI
    INT 21H
    INC Y
    CMP Y, 470
    JL SaveRows

    MOV BYTE PTR [matrixBuffer + DI], '%'
    MOV AH, 40h
    LEA DX, [matrixBuffer + DI]
    MOV BX, handle
    MOV CX, 1
    INT 21h

    MOV AH, 3Eh
    MOV BX, handle
    INT 21h

    CALL CLEAR_SCREEN
    CALL PRINT_COORDINATES

ErrorSaveFile:
    RET
SAVE_MATRIX ENDP

ByteToHex PROC
    MOV AL, AL
    AND AL, 0Fh
    ADD AL, '0'
    CMP AL, '9'
    JLE SaveHex
    ADD AL, 7
SaveHex:
    MOV [matrixBuffer], AL
    RET
ByteToHex ENDP

ReadLoop:
    MOV ah, 00h
    INT 16h
    CMP al, 0dh
    JE Exit
    CMP al, 08h
    JE HandleBackspace
    CMP al, 20h
    JB ReadLoop
    CMP al, 7Eh
    JA ReadLoop

    MOV ah, 03h
    INT 10h
    CMP dl, 90
    JAE ReadLoop
    MOV ah, 0Eh
    INT 10h
    JMP ReadLoop

HandleBackspace:
    MOV ah, 03h
    INT 10h
    CMP dl, 56
    JLE ReadLoop
    DEC dl
    MOV ah, 02h
    INT 10h
    MOV al, ' '
    MOV ah, 0Eh
    INT 10h
    DEC dl
    MOV ah, 02h
    INT 10h
    JMP ReadLoop

Exit:
    MOV ax, 4C00h
    INT 21h

main ENDP
end main
