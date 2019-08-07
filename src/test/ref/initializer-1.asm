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
  b1:
    lda.z i
    asl
    tay
    lda words,y
    sta SCREEN,x
    inx
    lda words+1,y
    sta SCREEN,x
    inx
    inc.z i
    lda #3
    cmp.z i
    bne b1
    rts
}
  words: .word 1, 2, 3
