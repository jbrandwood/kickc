// Tests a sub-optimal fragment synthesis
// vbuaa=vbuxx_band_pbuz1_derefidx_vbuc1 < vbuaa=pbuz1_derefidx_vbuc1_band_vbuxx < vbuaa=pbuz1_derefidx_vbuaa_band_vbuxx < vbuaa=pbuz1_derefidx_vbuyy_band_vbuxx < vbuaa=pbuz1_derefidx_vbuyy_band_vbuaa < vbuaa=vbuaa_band_pbuz1_derefidx_vbuyy - clobber:A Y  cycles:11.5
.pc = $801 "Basic"
:BasicUpstart(main)
.pc = $80d "Program"
main: {
    .label screen = $400
    lda #$f0
    sta $450+2
    lda #$f
    sta $450+3
    lda #<$450
    sta fct.z
    lda #>$450
    sta fct.z+1
    ldx #$aa
    jsr fct
    sta screen
    lda #<$450+1
    sta fct.z
    lda #>$450+1
    sta fct.z+1
    ldx #$55
    jsr fct
    sta screen+1
    rts
}
fct: {
    .label z = 2
    ldy #2
    txa
    and (z),y
    rts
}
