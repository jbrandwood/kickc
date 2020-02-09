// Test that volatile vars are turned into load/store
.pc = $801 "Basic"
:BasicUpstart(main)
.pc = $80d "Program"
  .label SCREEN = $400
main: {
    .label i = 2
    lda #3
    sta.z i
  __b1:
    lda.z i
    cmp #7
    bcc __b2
    rts
  __b2:
    ldy.z i
    tya
    sta SCREEN,y
    inc.z i
    jmp __b1
}
