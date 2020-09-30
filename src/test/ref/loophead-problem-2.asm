// Call returns wrong value
// Reported by Clay Cowgill as an NPE (which has been fixed - but this return-value problem has popped up instead)
// Caused by constant loop head unroll
.pc = $801 "Basic"
:BasicUpstart(main)
.pc = $80d "Program"
main: {
    .label screen = $400
    // scan_for_lowest()
    jsr scan_for_lowest
    // scan_for_lowest()
    lda.z scan_for_lowest.lowest
    // hit_check=scan_for_lowest()
    // screen[0] = hit_check
    sta screen
    // <ball_y[hit_check]
    asl
    tax
    lda ball_y,x
    // screen[2] = <ball_y[hit_check]
    sta screen+2
    // >ball_y[hit_check]
    lda ball_y+1,x
    // screen[3] = >ball_y[hit_check]
    sta screen+3
    // }
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
    ldy #0
  __b1:
    // for (char i=0;i<8;i++)
    cpy #8
    bcc __b2
    // }
    rts
  __b2:
    // ball_y[i]<height
    tya
    asl
    tax
    // if (ball_y[i]<height)
    lda ball_y,x
    cmp.z height
    lda ball_y+1,x
    sbc.z height+1
    bvc !+
    eor #$80
  !:
    bpl __b3
    // height=ball_y[i]
    lda ball_y,x
    sta.z height
    lda ball_y+1,x
    sta.z height+1
    sty.z lowest
  __b3:
    // for (char i=0;i<8;i++)
    iny
    jmp __b1
}
  ball_y: .word $32, $64, -$c8, $c, -$64, $4b, 0, -$79
