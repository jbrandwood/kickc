// Test declaring a variable as at a hard-coded register
// hard-coded register parameter
  // Commodore 64 PRG executable file
.file [name="register-0.prg", type="prg", segments="Program"]
.segmentdef Program [segments="Basic, Code, Data"]
.segmentdef Basic [start=$0801]
.segmentdef Code [start=$80d]
.segmentdef Data [startAfter="Code"]
.segment Basic
:BasicUpstart(__start)
  .label SCREEN = $400
  .label idx = 3
.segment Code
__start: {
    // idx
    lda #0
    sta.z idx
    jsr main
    rts
}
main: {
    // print('c')
    lda #'c'
    jsr print
    // print('m')
    lda #'m'
    jsr print
    // print('l')
    lda #'l'
    jsr print
    // }
    rts
}
// print(byte register(A) ch)
print: {
    // kickasm
    // Force usage of ch
    
    // asm
    ldx idx
    sta SCREEN,x
    inc idx
    // }
    rts
}
