// Demonstrates missing fragment _deref_pwuc1=_deref_pwuc1_plus_vwuc2
// https://gitlab.com/camelot/kickc/-/issues/435 reported by G.B.
  // Commodore 64 PRG executable file
.file [name="struct-pointer-ints.prg", type="prg", segments="Program"]
.segmentdef Program [segments="Basic, Code, Data"]
.segmentdef Basic [start=$0801]
.segmentdef Code [start=$80d]
.segmentdef Data [startAfter="Code"]
.segment Basic
:BasicUpstart(main)
  .const SIZEOF_STRUCT_MYSTRUCT = 4
.segment Code
main: {
    .label s = 2
    // myStruct s
    ldy #SIZEOF_STRUCT_MYSTRUCT
    lda #0
  !:
    dey
    sta s,y
    bne !-
    // update(&s, 1000)
    jsr update
    // }
    rts
}
update: {
    .const size = $3e8
    .label s = main.s
    // s->a += size
    clc
    lda.z s
    adc #<size
    sta.z s
    lda.z s+1
    adc #>size
    sta.z s+1
    // }
    rts
}
