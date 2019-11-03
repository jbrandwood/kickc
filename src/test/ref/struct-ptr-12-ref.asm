// Reference file for Minimal struct -  using address-of
.pc = $801 "Basic"
:BasicUpstart(main)
.pc = $80d "Program"
main: {
    .label SCREEN = $400
    .label q = p
    .label p = 2
    lda #<2*$100+3
    sta.z p
    lda #>2*$100+3
    sta.z p+1
    lda.z q
    sta SCREEN
    lda.z q+1
    sta SCREEN+1
    rts
}
