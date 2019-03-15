// Tests that references to labels in other scopes is possible from inline ASM
.pc = $801 "Basic"
:BasicUpstart(main)
.pc = $80d "Program"
main: {
    lda #'c'
    sta sub.ll+1
    jsr sub
    rts
}
sub: {
  ll:
    lda #0
    sta $400
    rts
}
