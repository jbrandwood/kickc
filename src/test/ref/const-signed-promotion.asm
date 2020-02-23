// Test fragment promotion of a constant (400) to signed word even if it also matches an unsigned word
.pc = $801 "Basic"
:BasicUpstart(main)
.pc = $80d "Program"
main: {
    .label screen = $400
    ldx #0
  __b1:
    // world[i]= 400
    txa
    asl
    tay
    lda #<$190
    sta world,y
    lda #>$190
    sta world+1,y
    // for(byte i:0..2)
    inx
    cpx #3
    bne __b1
    // *screen = world[0]
    lda world
    sta screen
    lda world+1
    sta screen+1
    // }
    rts
}
  world: .fill 2*3, 0
