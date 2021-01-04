// Demonstrates initializing an object using = { ... } syntax
// Array of words
  // Commodore 64 PRG executable file
.file [name="initializer-1.prg", type="prg", segments="Program"]
.segmentdef Program [segments="Basic, Code, Data"]
.segmentdef Basic [start=$0801]
.segmentdef Code [start=$80d]
.segmentdef Data [startAfter="Code"]
.segment Basic
:BasicUpstart(main)
.segment Code
main: {
    .label SCREEN = $400
    .label i = 2
    ldx #0
    txa
    sta.z i
  __b1:
    // <words[i]
    lda.z i
    asl
    tay
    lda words,y
    // SCREEN[idx++] = <words[i]
    sta SCREEN,x
    // SCREEN[idx++] = <words[i];
    inx
    // >words[i]
    lda words+1,y
    // SCREEN[idx++] = >words[i]
    sta SCREEN,x
    // SCREEN[idx++] = >words[i];
    inx
    // for( char i: 0..2)
    inc.z i
    lda #3
    cmp.z i
    bne __b1
    // }
    rts
}
.segment Data
  words: .word 1, 2, 3
