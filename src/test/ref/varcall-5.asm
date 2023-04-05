// Test __varcall calling convention
// Struct return value
  // Commodore 64 PRG executable file
.file [name="varcall-5.prg", type="prg", segments="Program"]
.segmentdef Program [segments="Basic, Code, Data"]
.segmentdef Basic [start=$0801]
.segmentdef Code [start=$80d]
.segmentdef Data [startAfter="Code"]
.segment Basic
:BasicUpstart(main)
  .const OFFSET_STRUCT_COLS_BG = 1
  .const SIZEOF_STRUCT_COLS = 2
  .label COLS = $d020
.segment Code
main: {
    // make(1)
    lda #1
    sta.z make.v
    jsr make
    ldx.z make.return_border
    lda.z make.return_bg
    // a = make(1)
    stx a
    sta a+OFFSET_STRUCT_COLS_BG
    // *COLS = a
    ldy #SIZEOF_STRUCT_COLS
  !:
    lda a-1,y
    sta COLS-1,y
    dey
    bne !-
    // make(2)
    lda #2
    sta.z make.v
    jsr make
    ldx.z make.return_border
    lda.z make.return_bg
    // a = make(2)
    stx a
    sta a+OFFSET_STRUCT_COLS_BG
    // *COLS = a
    ldy #SIZEOF_STRUCT_COLS
  !:
    lda a-1,y
    sta COLS-1,y
    dey
    bne !-
    // }
    rts
}
// struct Cols make(__zp(2) char v)
make: {
    .label v = 2
    .label return_border = 3
    .label return_bg = 4
    // c.border = v
    ldx.z v
    // v+v
    txa
    asl
    // c.bg = v+v
    // return c;
    stx.z return_border
    sta.z return_bg
    // }
    rts
}
.segment Data
  a: .fill SIZEOF_STRUCT_COLS, 0
