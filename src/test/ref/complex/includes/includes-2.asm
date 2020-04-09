// Includes a local file with the same name as a system library
.pc = $801 "Basic"
:BasicUpstart(main)
.pc = $80d "Program"
  .label SCREEN = $400
main: {
    // strlen(STR)
    jsr strlen
    // SCREEN [0] = (char) strlen(STR)
    lda #strlen.return
    sta SCREEN
    // }
    rts
}
// A local stdlib include file
strlen: {
    .label return = 'x'
    rts
}
