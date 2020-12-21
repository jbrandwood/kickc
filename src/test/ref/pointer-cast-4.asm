// Tests casting pointer types to other pointer types does not produce any ASM code
  // Commodore 64 PRG executable file
.file [name="pointer-cast-4.prg", type="prg", segments="Program"]
.segmentdef Program [segments="Basic, Code, Data"]
.segmentdef Basic [start=$0801]
.segmentdef Code [start=$80d]
.segmentdef Data [startAfter="Code"]
.segment Basic
:BasicUpstart(main)
.segment Code
main: {
    .label bscreen = $400
    .label wscreen = bscreen
    ldx #0
  __b1:
    // wscreen[i] = (word)i
    txa
    asl
    tay
    txa
    sta wscreen,y
    lda #0
    sta wscreen+1,y
    // for(byte i: 0..2)
    inx
    cpx #3
    bne __b1
    // }
    rts
}
