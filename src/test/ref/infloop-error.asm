//  Results in infinite compile loop as the compiler keeps trying to remove the same (empty) alias
.pc = $801 "Basic"
:BasicUpstart(main)
.pc = $80d "Program"
  .label SCREEN = $400
main: {
    ldy #0
    ldx #$ff
    tya
  b2:
    clc
    adc #1
    stx $ff
    cmp $ff
    bcs b4
    tax
  b4:
    sta $ff
    cpy $ff
    bcs b5
    tay
  b5:
    stx SCREEN
    sty SCREEN+1
    sta SCREEN+2
    jmp b2
}
