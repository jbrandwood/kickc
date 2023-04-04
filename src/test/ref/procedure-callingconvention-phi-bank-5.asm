// Test a far call procedure with a calling convention phi
.cpu _65c02
  .segmentdef Program                 [segments="Basic, Code, Data, stage, platform"]
.segmentdef Basic                   [start=$0801]
.segmentdef Code                    [start=$80d]
.segmentdef Data                    [startAfter="Code"]
.segmentdef stage                   [start=$0400, min=$0400, max=$07FF, align=$100]
.segmentdef platform                [start=$C000, min=$C000, max=$C7FF, align=$100]


  .label SCREEN = $400
.segment Code
main: {
    // func_bank1_a('0', 7)
    lda #7
    ldx #'0'
    jsr $ff6e
    .byte <func_bank1_a
    .byte >func_bank1_a
    .byte 1
    // func_bank1_a('0', 7)
    // SCREEN[0] = func_bank1_a('0', 7)
    // far call
    sta SCREEN
    // func_bank1_b('0', 7)
    lda #7
    ldx #'0'
    jsr func_bank1_b
    // func_bank1_b('0', 7)
    // SCREEN[0] = func_bank1_b('0', 7)
    // far call
    sta SCREEN
    // func_bank1_c('0', 7)
    jsr $ff6e
    .byte <func_bank1_c
    .byte >func_bank1_c
    .byte 1
    // func_bank1_c('0', 7)
    // SCREEN[0] = func_bank1_c('0', 7)
    // far call
    sta SCREEN
    // func_bank1_d('0', 7)
    jsr $ff6e
    .byte <func_bank1_d
    .byte >func_bank1_d
    .byte 1
    // func_bank1_d('0', 7)
    // SCREEN[0] = func_bank1_d('0', 7)
    // far call
    sta SCREEN
    // func_bank1_e('0', 7)
    jsr func_bank1_e
    // func_bank1_e('0', 7)
    // SCREEN[0] = func_bank1_e('0', 7)
    // near call
    sta SCREEN
    // func_bank1_f('0', 7)
    jsr func_bank1_f
    // func_bank1_f('0', 7)
    // SCREEN[0] = func_bank1_f('0', 7)
    // near call
    sta SCREEN
    // func_bank2_a('0', 7)
    lda #7
    ldx #'0'
    jsr $ff6e
    .byte <func_bank2_a
    .byte >func_bank2_a
    .byte 2
    // func_bank2_a('0', 7)
    // SCREEN[0] = func_bank2_a('0', 7)
    // far call
    sta SCREEN
    // func_bank2_b('0', 7)
    lda #7
    ldx #'0'
    jsr func_bank2_b
    // func_bank2_b('0', 7)
    // SCREEN[0] = func_bank2_b('0', 7)
    // far call
    sta SCREEN
    // func_bank2_c('0', 7)
    jsr $ff6e
    .byte <func_bank2_c
    .byte >func_bank2_c
    .byte 2
    // func_bank2_c('0', 7)
    // SCREEN[0] = func_bank2_c('0', 7)
    // far call
    sta SCREEN
    // func_bank2_d('0', 7)
    jsr $ff6e
    .byte <func_bank2_d
    .byte >func_bank2_d
    .byte 2
    // func_bank2_d('0', 7)
    // SCREEN[0] = func_bank2_d('0', 7)
    // far call
    sta SCREEN
    // func_bank2_e('0', 7)
    jsr $ff6e
    .byte <func_bank2_e
    .byte >func_bank2_e
    .byte 2
    // func_bank2_e('0', 7)
    // SCREEN[0] = func_bank2_e('0', 7)
    // far call
    sta SCREEN
    // func_bank2_f('0', 7)
    jsr $ff6e
    .byte <func_bank2_f
    .byte >func_bank2_f
    .byte 2
    // func_bank2_f('0', 7)
    // SCREEN[0] = func_bank2_f('0', 7)
    // far call
    sta SCREEN
    // }
    rts
}
.segment stage
// __register(A) char func_bank1_a(__register(X) char a, __register(A) char b)
func_bank1_a: {
    // a+b
    stx.z $ff
    clc
    adc.z $ff
    // }
    rts
}
.segment platform
// __register(A) char func_bank1_b(__register(X) char a, __register(A) char b)
func_bank1_b: {
    // a+b
    stx.z $ff
    clc
    adc.z $ff
    // }
    rts
}
.segment stage
// __register(A) char func_bank1_c(char a, char b)
func_bank1_c: {
    .const a = '0'
    .const b = 7
    // func_bank1_a(a,b)
    lda #b
    ldx #a
    jsr func_bank1_a
    // func_bank1_a(a,b)
    // }
    rts
}
// __register(A) char func_bank1_d(char a, char b)
func_bank1_d: {
    .const a = '0'
    .const b = 7
    // func_bank2_a(a,b)
    lda #b
    ldx #a
    jsr $ff6e
    .byte <func_bank2_a
    .byte >func_bank2_a
    .byte 2
    // func_bank2_a(a,b)
    // }
    rts
}
.segment platform
// __register(A) char func_bank1_e(char a, char b)
func_bank1_e: {
    .const a = '0'
    .const b = 7
    // func_bank1_a(a,b)
    lda #b
    ldx #a
    jsr $ff6e
    .byte <func_bank1_a
    .byte >func_bank1_a
    .byte 1
    // func_bank1_a(a,b)
    // }
    rts
}
// __register(A) char func_bank1_f(char a, char b)
func_bank1_f: {
    .const a = '0'
    .const b = 7
    // func_bank2_a(a,b)
    lda #b
    ldx #a
    jsr $ff6e
    .byte <func_bank2_a
    .byte >func_bank2_a
    .byte 2
    // func_bank2_a(a,b)
    // }
    rts
}
// __register(A) char func_bank2_a(__register(X) char a, __register(A) char b)
func_bank2_a: {
    // a+b
    stx.z $ff
    clc
    adc.z $ff
    // }
    rts
}
// __register(A) char func_bank2_b(__register(X) char a, __register(A) char b)
func_bank2_b: {
    // a+b
    stx.z $ff
    clc
    adc.z $ff
    // }
    rts
}
// __register(A) char func_bank2_c(char a, char b)
func_bank2_c: {
    .const a = '0'
    .const b = 7
    // func_bank1_a(a,b)
    lda #b
    ldx #a
    jsr $ff6e
    .byte <func_bank1_a
    .byte >func_bank1_a
    .byte 1
    // func_bank1_a(a,b)
    // }
    rts
}
// __register(A) char func_bank2_d(char a, char b)
func_bank2_d: {
    .const a = '0'
    .const b = 7
    // func_bank2_a(a,b)
    lda #b
    ldx #a
    jsr func_bank2_a
    // func_bank2_a(a,b)
    // }
    rts
}
// __register(A) char func_bank2_e(char a, char b)
func_bank2_e: {
    .const a = '0'
    .const b = 7
    // func_bank2_b(a,b)
    lda #b
    ldx #a
    jsr func_bank2_b
    // func_bank2_b(a,b)
    // }
    rts
}
// __register(A) char func_bank2_f(char a, char b)
func_bank2_f: {
    .const a = '0'
    .const b = 7
    // func_bank1_b(a,b)
    lda #b
    ldx #a
    jsr func_bank1_b
    // func_bank1_b(a,b)
    // }
    rts
}
