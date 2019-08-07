// Reference file for Minimal struct -  using address-of
.pc = $801 "Basic"
:BasicUpstart(main)
.pc = $80d "Program"
main: {
    .label q = p
    .label SCREEN = $400
    .label p = 2
    lda #<2*$100+3
    sta.z p
    lda #>2*$100+3
    sta.z p+1
    lda q
    sta SCREEN
    lda q+1
    sta SCREEN+1
    rts
}
