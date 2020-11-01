// Illustrates how inline assembler referencing variables is automatically converted to __ma
.pc = $801 "Basic"
:BasicUpstart(main)
.pc = $80d "Program"
  .label SCREEN = $400
main: {
    .label i = 2
    // for(byte i: 0..10)
    lda #0
    sta.z i
  __b1:
    // asm
    lda #'a'
    ldx i
    sta SCREEN,x
    // for(byte i: 0..10)
    inc.z i
    lda #$b
    cmp.z i
    bne __b1
    // }
    rts
}
