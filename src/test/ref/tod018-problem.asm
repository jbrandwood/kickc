// Tests a problem with tod018 not calculating types correctly
.pc = $801 "Basic"
:BasicUpstart(main)
.pc = $80d "Program"
main: {
    .label D018 = $d018
    .label screen = $400
    .const d018val = >screen&$3fff
    lda #d018val
    sta D018
    rts
}
