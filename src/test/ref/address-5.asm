// Test declaring a variable as at a hard-coded address
// zero-page hard-coded address parameter
.pc = $801 "Basic"
:BasicUpstart(__b1)
.pc = $80d "Program"
  .label SCREEN = $400
  .label idx = 3
__b1:
  // idx
  lda #0
  sta.z idx
  jsr main
  rts
main: {
    // print('c')
    lda #'c'
    sta.z print.ch
    jsr print
    // print('m')
    lda #'m'
    sta.z print.ch
    jsr print
    // print('l')
    lda #'l'
    sta.z print.ch
    jsr print
    // }
    rts
}
// print(byte zp(2) ch)
print: {
    .label ch = 2
    // asm
    ldx idx
    lda ch
    sta SCREEN,x
    inc idx
    // }
    rts
}
