// Test fragment promotion of a constant (400) to signed word even if it also matches an unsigned word
.pc = $801 "Basic"
:BasicUpstart(main)
.pc = $80d "Program"
  .const SIZEOF_SIGNED_WORD = 2
main: {
    .label screen = $400
    ldx #0
  b1:
    txa
    asl
    tay
    lda #<$190
    sta world,y
    lda #>$190
    sta world+1,y
    inx
    cpx #3
    bne b1
    lda world
    sta screen
    lda world+1
    sta screen+1
    rts
}
  world: .fill 2*3, 0
