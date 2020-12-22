// Tests that mixing types can synthesize a fragment correctly
  // Commodore 64 PRG executable file
.file [name="type-mix.prg", type="prg", segments="Program"]
.segmentdef Program [segments="Basic, Code, Data"]
.segmentdef Basic [start=$0801]
.segmentdef Code [start=$80d]
.segmentdef Data [startAfter="Code"]
.segment Basic
:BasicUpstart(main)
.segment Code
main: {
    .label SCREEN = $400
    .label w = 2
    ldx #0
    txa
    sta.z w
    sta.z w+1
  __b1:
    // w = w - 12
    lda.z w
    sec
    sbc #$c
    sta.z w
    lda.z w+1
    sbc #>$c
    sta.z w+1
    // <w
    lda.z w
    // SCREEN[i] = <w
    sta SCREEN,x
    // for (byte i: 0..10)
    inx
    cpx #$b
    bne __b1
    // }
    rts
}
