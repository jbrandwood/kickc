// Call returns wrong value
// Reported by Clay Cowgill as an NPE (which has been fixed - but this return-value problem has popped up instead)
// Caused by constant loop head unroll
.pc = $801 "Basic"
:BasicUpstart(main)
.pc = $80d "Program"
main: {
    .label screen = $400
    jsr scan_for_lowest
    lda.z scan_for_lowest.lowest
    sta screen
    asl
    tax
    lda ball_y,x
    sta screen+2
    lda ball_y+1,x
    sta screen+3
    rts
}
scan_for_lowest: {
    .label height = 2
    .label lowest = 4
    lda #$ff
    sta.z lowest
    lda #<$258
    sta.z height
    lda #>$258
    sta.z height+1
    ldx #0
  __b1:
    cpx #8
    bcc __b2
    rts
  __b2:
    txa
    asl
    tay
    lda ball_y,y
    cmp.z height
    lda ball_y+1,y
    sbc.z height+1
    bvc !+
    eor #$80
  !:
    bpl __b3
    txa
    asl
    tay
    lda ball_y,y
    sta.z height
    lda ball_y+1,y
    sta.z height+1
    stx.z lowest
  __b3:
    inx
    jmp __b1
}
  ball_y: .word $32, $64, -$c8, $c, -$64, $4b, 0, -$79
