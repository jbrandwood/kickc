// Demonstrates problem with conditions using negated struct references
.pc = $801 "Basic"
:BasicUpstart(main)
.pc = $80d "Program"
  .label SCREEN = $400
  .const OFFSET_STRUCT_SETTING_BUF = 1
main: {
    ldx #0
  __b1:
    cpx settings
    bcc __b2
    rts
  __b2:
    txa
    asl
    tay
    lda settings+OFFSET_STRUCT_SETTING_BUF
    sta.z $fe
    lda settings+OFFSET_STRUCT_SETTING_BUF+1
    sta.z $ff
    lda ($fe),y
    sta SCREEN,y
    iny
    lda ($fe),y
    sta SCREEN,y
    inx
    jmp __b1
}
  seq: .word 1, 2, 3
  settings: .byte 3
  .word seq
