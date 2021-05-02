// Test a bit of array code from the NES forum
// https://forums.nesdev.com/viewtopic.php?f=2&t=18735
  // Commodore 64 PRG executable file
.file [name="nes-array.prg", type="prg", segments="Program"]
.segmentdef Program [segments="Basic, Code, Data"]
.segmentdef Basic [start=$0801]
.segmentdef Code [start=$80d]
.segmentdef Data [startAfter="Code"]
.segment Basic
:BasicUpstart(main)
  .const SIZEOF_SIGNED_WORD = 2
.segment Code
main: {
    .label SCREEN = $400
    .label y1 = 4
    .label y2 = 6
    .label __0 = 2
    .label __1 = 2
    // int y1 = 0x1234
    lda #<$1234
    sta.z y1
    lda #>$1234
    sta.z y1+1
    // int y2 = 0x1234
    lda #<$1234
    sta.z y2
    lda #>$1234
    sta.z y2+1
    // foo(1, &y1)
    lda #<y1
    sta.z foo.y
    lda #>y1
    sta.z foo.y+1
    ldx #1
    jsr foo
    // foo(1, &y1)
    // *SCREEN++ = foo(1, &y1)
    lda.z __0
    sta SCREEN
    lda.z __0+1
    sta SCREEN+1
    // foo(2, &y2)
    lda #<y2
    sta.z foo.y
    lda #>y2
    sta.z foo.y+1
    ldx #2
    jsr foo
    // foo(2, &y2)
    // *SCREEN++ = foo(2, &y2)
    lda.z __1
    sta SCREEN+SIZEOF_SIGNED_WORD
    lda.z __1+1
    sta SCREEN+SIZEOF_SIGNED_WORD+1
    // }
    rts
}
// foo(byte register(X) x, signed word* zp(2) y)
foo: {
    .label return = 2
    .label y = 2
    // wow[x] + *y
    txa
    asl
    tax
    ldy #0
    clc
    lda wow,x
    adc (return),y
    pha
    iny
    lda wow+1,x
    adc (return),y
    sta.z return+1
    pla
    sta.z return
    // }
    rts
}
.segment Data
  wow: .word $cafe, $babe, $1234, $5678
