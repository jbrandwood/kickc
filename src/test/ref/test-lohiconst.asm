//  PI in u[4.28] format
.pc = $801 "Basic"
:BasicUpstart(main)
.pc = $80d "Program"
  .const PI_u4f28 = $3243f6a9
main: {
    .label SCREEN = $400
    lda #>PI_u4f28>>$10
    sta SCREEN
    lda #<PI_u4f28>>$10
    sta SCREEN+1
    lda #>PI_u4f28&$ffff
    sta SCREEN+2
    lda #<PI_u4f28&$ffff
    sta SCREEN+3
    rts
}
