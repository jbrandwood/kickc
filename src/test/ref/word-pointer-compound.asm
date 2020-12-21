// Test word pointer compound assignment
  // Commodore 64 PRG executable file
.file [name="word-pointer-compound.prg", type="prg", segments="Program"]
.segmentdef Program [segments="Basic, Code, Data"]
.segmentdef Basic [start=$0801]
.segmentdef Code [start=$80d]
.segmentdef Data [startAfter="Code"]
.segment Basic
:BasicUpstart(main)
  .const SIZEOF_WORD = 2
.segment Code
main: {
    .label SCREEN = $400
    ldx #0
  __b1:
    // words[i] += $0101
    txa
    asl
    tay
    clc
    lda words,y
    adc #<$101
    sta words,y
    lda words+1,y
    adc #>$101
    sta words+1,y
    // for( byte i: 0..2)
    inx
    cpx #3
    bne __b1
    // >words[0]
    lda words+1
    // SCREEN[0] = >words[0]
    sta SCREEN
    // <words[0]
    lda words
    // SCREEN[1] = <words[0]
    sta SCREEN+1
    // >words[1]
    lda words+1*SIZEOF_WORD+1
    // SCREEN[2] = >words[1]
    sta SCREEN+2
    // <words[1]
    lda words+1*SIZEOF_WORD
    // SCREEN[3] = <words[1]
    sta SCREEN+3
    // >words[2]
    lda words+2*SIZEOF_WORD+1
    // SCREEN[4] = >words[2]
    sta SCREEN+4
    // <words[2]
    lda words+2*SIZEOF_WORD
    // SCREEN[5] = <words[2]
    sta SCREEN+5
    // }
    rts
  .segment Data
    words: .word $3031, $3233, $3435
}
