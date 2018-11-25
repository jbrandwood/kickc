.pc = $801 "Basic"
:BasicUpstart(main)
.pc = $80d "Program"
  .label BORDERCOL = $d020
  .label COLS = $d800
  .const BLACK = 0
  .const GREEN = 5
  .const DARK_GREY = $b
  .label SCREEN = $400
  jsr main
main: {
    jsr init
    jsr render_playfield
    jsr render_current_piece
  b2:
    inc BORDERCOL
    jmp b2
}
render_current_piece: {
    rts
}
render_playfield: {
    .label _1 = 6
    .label line = 4
    .label i = 3
    .label l = 2
    lda #0
    sta i
    sta l
  b1:
    lda l
    asl
    tay
    lda screen_lines,y
    sta line
    lda screen_lines+1,y
    sta line+1
    ldx #0
  b2:
    txa
    clc
    adc line
    sta _1
    lda #0
    adc line+1
    sta _1+1
    ldy i
    lda playfield,y
    ldy #0
    sta (_1),y
    inc i
    inx
    cpx #$a
    bne b2
    inc l
    lda l
    cmp #$14
    bne b1
    rts
}
init: {
    .label _7 = 6
    .label li = 4
    .label line = 4
    .label l = 2
    lda #GREEN
    sta current_piece
    sta current_piece+1
    sta current_piece+2
    sta current_piece+4
    ldx #$a0
    lda #<SCREEN
    sta fill.addr
    lda #>SCREEN
    sta fill.addr+1
    jsr fill
    ldx #BLACK
    lda #<COLS
    sta fill.addr
    lda #>COLS
    sta fill.addr+1
    jsr fill
    lda #<COLS+$28+$f
    sta li
    lda #>COLS+$28+$f
    sta li+1
    ldx #0
  b1:
    txa
    asl
    tay
    lda li
    sta screen_lines,y
    lda li+1
    sta screen_lines+1,y
    lda li
    clc
    adc #$28
    sta li
    bcc !+
    inc li+1
  !:
    inx
    cpx #$14
    bne b1
    lda #0
    sta l
    lda #<COLS+$e
    sta line
    lda #>COLS+$e
    sta line+1
  b2:
    ldx #0
  b3:
    txa
    clc
    adc line
    sta _7
    lda #0
    adc line+1
    sta _7+1
    lda #DARK_GREY
    ldy #0
    sta (_7),y
    inx
    cpx #$c
    bne b3
    lda line
    clc
    adc #$28
    sta line
    bcc !+
    inc line+1
  !:
    inc l
    lda l
    cmp #$16
    bne b2
    rts
}
fill: {
    .label end = 6
    .label addr = 4
    lda addr
    clc
    adc #<$3e8
    sta end
    lda addr+1
    adc #>$3e8
    sta end+1
  b1:
    txa
    ldy #0
    sta (addr),y
    inc addr
    bne !+
    inc addr+1
  !:
    lda addr+1
    cmp end+1
    bne b1
    lda addr
    cmp end
    bne b1
    rts
}
  screen_lines: .fill 2*$14, 0
  playfield: .fill $14*$a, 0
  current_piece: .fill 4*4, 0
