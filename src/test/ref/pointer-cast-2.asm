// Tests casting pointer types to other pointer types
  // Commodore 64 PRG executable file
.file [name="pointer-cast-2.prg", type="prg", segments="Program"]
.segmentdef Program [segments="Basic, Code, Data"]
.segmentdef Basic [start=$0801]
.segmentdef Code [start=$80d]
.segmentdef Data [startAfter="Code"]
.segment Basic
:BasicUpstart(main)
.segment Code
main: {
    .label ub_screen = $400
    .label sb_screen = $428
    .label sb_ptr = ub
    .label ub_ptr = sb
    .label ub = 2
    .label sb = 3
    // byte ub = 0xff
    lda #$ff
    sta.z ub
    // *sb_ptr = 1
    lda #1
    sta.z sb_ptr
    // *ub_screen = ub
    lda.z ub
    sta ub_screen
    // signed byte sb = (signed byte)0x7f
    lda #$7f
    sta.z sb
    // *ub_ptr = 1
    lda #1
    sta.z ub_ptr
    // *sb_screen = sb
    lda.z sb
    sta sb_screen
    // }
    rts
}
