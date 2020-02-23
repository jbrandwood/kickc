// Reference file for Minimal struct -  using address-of
.pc = $801 "Basic"
:BasicUpstart(main)
.pc = $80d "Program"
main: {
    .label SCREEN = $400
    .label q = p
    .label p = 2
    // p = { 2, 3 }
    lda #<2*$100+3
    sta.z p
    lda #>2*$100+3
    sta.z p+1
    // <*q
    lda.z q
    // SCREEN[0] = <*q
    sta SCREEN
    // >*q
    lda.z q+1
    // SCREEN[1] = >*q
    sta SCREEN+1
    // }
    rts
}
