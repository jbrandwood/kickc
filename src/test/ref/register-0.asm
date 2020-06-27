// Test declaring a variable as at a hard-coded register
// hard-coded register parameter
.pc = $801 "Basic"
:BasicUpstart(__start)
.pc = $80d "Program"
  .label SCREEN = $400
  .label idx = 3
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
