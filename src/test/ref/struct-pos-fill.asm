// Example of structs that can be optimized by going planar
// https://cc65.github.io/mailarchive/2010-09/8593.html?fbclid=IwAR1IF_cTdyWcFeKU93VfL2Un1EuLjkGh7O7dQ4EVj4kpJzJAj01dbmEFQt8
.pc = $801 "Basic"
:BasicUpstart(main)
.pc = $80d "Program"
  .const OFFSET_STRUCT_POS_Y = 1
  .const XSPACE = $14
  .const YSPACE = $14
  .label x = 3
  .label idx = 4
  .label y = 5
  .label line = 2
main: {
    lda #0
    sta y
    sta idx
    sta x
    sta line
  b1:
    lda line
    cmp #8
    bcc b2
    rts
  b2:
    inc x
    ldy #0
  b3:
    cpy #8
    bcc b4
    lax y
    axs #-[YSPACE]
    stx y
    inc line
    jmp b1
  b4:
    lda idx
    asl
    tax
    lda y
    sta p+OFFSET_STRUCT_POS_Y,x
    lda x
    sta p,x
    inc idx
    lax x
    axs #-[XSPACE]
    stx x
    iny
    jmp b3
}
  p: .fill 2*$40, 0
