// Demonstrates initializing an object using = { ... } syntax
// Array of words
.pc = $801 "Basic"
:BasicUpstart(main)
.pc = $80d "Program"
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
  words: .word 1, 2, 3
