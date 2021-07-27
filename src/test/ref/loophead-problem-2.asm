// Call returns wrong value
// Reported by Clay Cowgill as an NPE (which has been fixed - but this return-value problem has popped up instead)
// Caused by constant loop head unroll
  // Commodore 64 PRG executable file
.file [name="loophead-problem-2.prg", type="prg", segments="Program"]
.segmentdef Program [segments="Basic, Code, Data"]
.segmentdef Basic [start=$0801]
.segmentdef Code [start=$80d]
.segmentdef Data [startAfter="Code"]
.segment Basic
:BasicUpstart(main)
.segment Code
main: {
    .label screen = $400
    // char hit_check=scan_for_lowest()
    jsr scan_for_lowest
    // char hit_check=scan_for_lowest()
    lda.z scan_for_lowest.lowest
    // screen[0] = hit_check
    sta screen
    // BYTE0(ball_y[hit_check])
    asl
    tax
    lda ball_y,x
    // screen[2] = BYTE0(ball_y[hit_check])
    sta screen+2
    // BYTE1(ball_y[hit_check])
    lda ball_y+1,x
    // screen[3] = BYTE1(ball_y[hit_check])
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
.segment Data
  ball_y: .word $32, $64, -$c8, $c, -$64, $4b, 0, -$79
