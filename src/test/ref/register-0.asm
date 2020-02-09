// Test declaring a variable as at a hard-coded register
// hard-coded register parameter
.pc = $801 "Basic"
:BasicUpstart(__b1)
.pc = $80d "Program"
  .label SCREEN = $400
  .label idx = 3
__b1:
  lda #0
  sta.z idx
  jsr main
  rts
main: {
    lda #'c'
    jsr print
    lda #'m'
    jsr print
    lda #'l'
    jsr print
    rts
}
// print(byte register(A) ch)
print: {
    // Force usage of ch
    
    ldx idx
    sta SCREEN,x
    inc idx
    rts
}
