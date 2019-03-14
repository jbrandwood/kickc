// Illustrates how inline assembler can reference data from the outside program
.pc = $801 "Basic"
:BasicUpstart(main)
.pc = $80d "Program"
main: {
    .label SCREEN = $400
    lda table
    sta SCREEN+$28
    ldx #0
  !:
    lda table,x
    sta SCREEN+1,x
    inx
    cpx #4
    bne !-
    rts
}
  table: .text "cml!"
