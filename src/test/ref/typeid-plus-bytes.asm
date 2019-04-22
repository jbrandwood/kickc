// Test that plus creates the expected type for all legal combinations of bytes (signed/unsigned - constant/variable)
.pc = $801 "Basic"
:BasicUpstart(main)
.pc = $80d "Program"
  .const TYPEID_BYTE = 1
  .const TYPEID_SIGNED_BYTE = 2
  .label SCREEN = $400
main: {
    jsr testUnsigned
    jsr testSigned
    rts
}
testSigned: {
    .label sbv1 = 3
    lda #$13
    sta sbv1
    lda #TYPEID_SIGNED_BYTE
    sta SCREEN+$28
    sta SCREEN+$29
    sta SCREEN+$2a
    sta SCREEN+$2b
    sta SCREEN+$2c
    sta SCREEN+$2d
    sta SCREEN+$2e
    sta SCREEN+$2f
    rts
}
testUnsigned: {
    .label ubv1 = 2
    lda #$5b
    sta ubv1
    lda #TYPEID_BYTE
    sta SCREEN
    sta SCREEN+1
    sta SCREEN+2
    sta SCREEN+3
    sta SCREEN+4
    sta SCREEN+5
    rts
}
