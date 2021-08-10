// Demonstrates global directive reserving a range of addresses on zeropage
  // Commodore 64 PRG executable file
.file [name="reserve-zp-global-range.prg", type="prg", segments="Program"]
.segmentdef Program [segments="Basic, Code, Data"]
.segmentdef Basic [start=$0801]
.segmentdef Code [start=$80d]
.segmentdef Data [startAfter="Code"]
.segment Basic
:BasicUpstart(main)
.segment Code
main: {
    .label SCREEN = $400
    .label i = $81
    // for( volatile byte i : 0..2)
    lda #0
    sta.z i
  __b1:
    // sub1(i)
    lda.z i
    jsr sub1
    // SCREEN[i] = sub1(i)
    ldy.z i
    sta SCREEN,y
    // for( volatile byte i : 0..2)
    inc.z i
    lda #3
    cmp.z i
    bne __b1
    // }
    rts
}
// __register(A) char sub1(__register(A) char i)
sub1: {
    // i+i
    asl
    // }
    rts
}
