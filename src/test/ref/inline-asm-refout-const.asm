// Illustrates how inline assembler can reference data from the outside program without the data being optimized away as unused
.pc = $801 "Basic"
:BasicUpstart(main)
.pc = $80d "Program"
  .label SCREEN = $400
main: {
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
