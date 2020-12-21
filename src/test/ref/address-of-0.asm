// Test address-of - use the pointer to get the value
  // Commodore 64 PRG executable file
.file [name="address-of-0.prg", type="prg", segments="Program"]
.segmentdef Program [segments="Basic, Code, Data"]
.segmentdef Basic [start=$0801]
.segmentdef Code [start=$80d]
.segmentdef Data [startAfter="Code"]
.segment Basic
:BasicUpstart(main)
.segment Code
main: {
    .label SCREEN = $400
    .label bp = b
    .label b = 2
    // for( byte b: 0..10)
    lda #0
    sta.z b
  __b1:
    // c = *bp +1
    lda.z bp
    clc
    adc #1
    // SCREEN[b] = c
    ldy.z b
    sta SCREEN,y
    // for( byte b: 0..10)
    inc.z b
    lda #$b
    cmp.z b
    bne __b1
    // }
    rts
}
