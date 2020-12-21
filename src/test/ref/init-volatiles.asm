// Illustrates a problem where volatiles with initializers are initialized outside the main()-routine
  // Commodore 64 PRG executable file
.file [name="init-volatiles.prg", type="prg", segments="Program"]
.segmentdef Program [segments="Basic, Code, Data"]
.segmentdef Basic [start=$0801]
.segmentdef Code [start=$80d]
.segmentdef Data [startAfter="Code"]
.segment Basic
:BasicUpstart(__start)
  .label x = 2
.segment Code
__start: {
    // x = 12
    lda #$c
    sta.z x
    jsr main
    rts
}
main: {
  __b1:
    // while(++x<50)
    inc.z x
    lda.z x
    cmp #$32
    bcc __b1
    // x = 0
    lda #0
    sta.z x
    // }
    rts
}
