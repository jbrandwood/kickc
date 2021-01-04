// Example of structs that can be optimized by going planar
// https://cc65.github.io/mailarchive/2010-09/8593.html?fbclid=IwAR1IF_cTdyWcFeKU93VfL2Un1EuLjkGh7O7dQ4EVj4kpJzJAj01dbmEFQt8
  // Commodore 64 PRG executable file
.file [name="struct-pos-fill.prg", type="prg", segments="Program"]
.segmentdef Program [segments="Basic, Code, Data"]
.segmentdef Basic [start=$0801]
.segmentdef Code [start=$80d]
.segmentdef Data [startAfter="Code"]
.segment Basic
:BasicUpstart(main)
  .const OFFSET_STRUCT_POS_Y = 1
  .const XSPACE = $14
  .const YSPACE = $14
  .label x = 3
  .label idx = 4
  .label y = 5
  .label line = 2
.segment Code
main: {
    lda #0
    sta.z y
    sta.z idx
    sta.z x
    sta.z line
  __b1:
    // for (line=0;line<8;++line)
    lda.z line
    cmp #8
    bcc __b2
    // }
    rts
  __b2:
    // ++x;
    inc.z x
    ldy #0
  __b3:
    // for (row=0;row<8;++row)
    cpy #8
    bcc __b4
    // y+=YSPACE
    lax.z y
    axs #-[YSPACE]
    stx.z y
    // for (line=0;line<8;++line)
    inc.z line
    jmp __b1
  __b4:
    // p[idx].y=y
    lda.z idx
    asl
    tax
    lda.z y
    sta p+OFFSET_STRUCT_POS_Y,x
    // p[idx].x=x
    lda.z x
    sta p,x
    // ++idx;
    inc.z idx
    // x+=XSPACE
    lax.z x
    axs #-[XSPACE]
    stx.z x
    // for (row=0;row<8;++row)
    iny
    jmp __b3
}
.segment Data
  p: .fill 2*$40, 0
