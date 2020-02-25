// Test declaring a variable as at a hard-coded address
// mainmem-page hard-coded address parameter
.pc = $801 "Basic"
:BasicUpstart(__b1)
.pc = $80d "Program"
  .label SCREEN = $400
  .label idx = $3000
__b1:
  // idx
  lda #0
  sta idx
  jsr main
  rts
main: {
    // print('c')
    lda #'c'
    sta print.ch
    jsr print
    // print('m')
    lda #'m'
    sta print.ch
    jsr print
    // print('l')
    lda #'l'
    sta print.ch
    jsr print
    // }
    rts
}
// print(byte mem($3001) ch)
print: {
    .label ch = $3001
    // asm
    ldx idx
    lda ch
    sta SCREEN,x
    inc idx
    // }
    rts
}
