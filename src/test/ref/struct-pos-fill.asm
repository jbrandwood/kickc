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
    sta.z y
    sta.z idx
    sta.z x
    sta.z line
  __b1:
    lda.z line
    cmp #8
    bcc __b2
    rts
  __b2:
    inc.z x
    ldy #0
  __b3:
    cpy #8
    bcc __b4
    lax.z y
    axs #-[YSPACE]
    stx.z y
    inc.z line
    jmp __b1
  __b4:
    lda.z idx
    asl
    tax
    lda.z y
    sta p+OFFSET_STRUCT_POS_Y,x
    lda.z x
    sta p,x
    inc.z idx
    lax.z x
    axs #-[XSPACE]
    stx.z x
    iny
    jmp __b3
}
  p: .fill 2*$40, 0
