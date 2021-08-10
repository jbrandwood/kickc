// https://gitlab.com/camelot/kickc/-/issues/650
  // Commodore 64 PRG executable file
.file [name="init-value-npe.prg", type="prg", segments="Program"]
.segmentdef Program [segments="Basic, Code, Data"]
.segmentdef Basic [start=$0801]
.segmentdef Code [start=$80d]
.segmentdef Data [startAfter="Code"]
.segment Basic
:BasicUpstart(main)
  .label myscreen = $7000
.segment Code
main: {
    // memset(myscreen)
    jsr memset
    // }
    rts
}
// void memset(void *str)
memset: {
    .label str = myscreen
    .label dst = str
    // *dst = 0
    lda #0
    sta dst
    // }
    rts
}
