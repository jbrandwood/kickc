// Rolling constants by a variable amount
  // Commodore 64 PRG executable file
.file [name="roll-variable.prg", type="prg", segments="Program"]
.segmentdef Program [segments="Basic, Code, Data"]
.segmentdef Basic [start=$0801]
.segmentdef Code [start=$80d]
.segmentdef Data [startAfter="Code"]
.segment Basic
:BasicUpstart(main)
.segment Code
main: {
    .label screen = $400
    .label b = 2
    lda #0
    sta.z b
  __b1:
    // $55 << b
    lda #$55
    ldy.z b
    cpy #0
    beq !e+
  !:
    asl
    dey
    bne !-
  !e:
    // screen[b] = $55 << b
    ldy.z b
    sta screen,y
    // for( byte b: 0..7)
    inc.z b
    lda #8
    cmp.z b
    bne __b1
    // }
    rts
}
