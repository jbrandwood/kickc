// Test that plus creates the expected type for all legal combinations of bytes (signed/unsigned - constant/variable)
  // Commodore 64 PRG executable file
.file [name="typeid-plus-bytes.prg", type="prg", segments="Program"]
.segmentdef Program [segments="Basic, Code, Data"]
.segmentdef Basic [start=$0801]
.segmentdef Code [start=$80d]
.segmentdef Data [startAfter="Code"]
.segment Basic
:BasicUpstart(main)
  .const TYPEID_BYTE = 1
  .const TYPEID_SIGNED_BYTE = 2
  .label SCREEN = $400
  .label SSCREEN = $400
.segment Code
main: {
    // testUnsigned()
    jsr testUnsigned
    // testUnsignedVals()
    jsr testUnsignedVals
    // testSigned()
    jsr testSigned
    // testSignedVals()
    jsr testSignedVals
    // }
    rts
}
testUnsigned: {
    // SCREEN[idx++] = typeid(250)
    lda #0
    sta SCREEN
    // SCREEN[idx++] = typeid(ubc1)
    lda #TYPEID_BYTE
    sta SCREEN+1
    // SCREEN[idx++] = typeid(ubv1)
    sta SCREEN+2
    // SCREEN[idx++] = typeid(120+130)
    lda #0
    sta SCREEN+3
    // SCREEN[idx++] = typeid(ubc1+250)
    lda #TYPEID_BYTE
    sta SCREEN+4
    // SCREEN[idx++] = typeid(250+ubc1)
    sta SCREEN+5
    // SCREEN[idx++] = typeid(ubv1+250)
    sta SCREEN+6
    // SCREEN[idx++] = typeid(250+ubv1)
    sta SCREEN+7
    // SCREEN[idx++] = typeid(ubv1+ubc1)
    sta SCREEN+8
    // SCREEN[idx++] = typeid(ubc1+ubv1)
    sta SCREEN+9
    // SCREEN[idx++] = typeid(ubv1+ubv1)
    sta SCREEN+$a
    // }
    rts
}
testUnsignedVals: {
    .const ubc1 = $fa
    .label ubv1 = 2
    // volatile unsigned byte ubv1 = 250
    lda #$fa
    sta.z ubv1
    // SCREEN[idx++] = 250
    sta SCREEN+$28
    // SCREEN[idx++] = ubc1
    lda #ubc1
    sta SCREEN+$29
    // SCREEN[idx++] = ubv1
    lda.z ubv1
    sta SCREEN+$2a
    // SCREEN[idx++] = 120+130
    lda #$78+$82
    sta SCREEN+$2b
    // SCREEN[idx++] = ubc1+250
    lda #ubc1+$fa
    sta SCREEN+$2c
    // SCREEN[idx++] = 250+ubc1
    lda #$fa+ubc1
    sta SCREEN+$2d
    // ubv1+250
    lax.z ubv1
    axs #-[$fa]
    // SCREEN[idx++] = ubv1+250
    stx SCREEN+$2e
    // 250+ubv1
    lax.z ubv1
    axs #-[$fa]
    // SCREEN[idx++] = 250+ubv1
    stx SCREEN+$2f
    // ubv1+ubc1
    lda #ubc1
    clc
    adc.z ubv1
    // SCREEN[idx++] = ubv1+ubc1
    sta SCREEN+$30
    // ubc1+ubv1
    lda #ubc1
    clc
    adc.z ubv1
    // SCREEN[idx++] = ubc1+ubv1
    sta SCREEN+$31
    // ubv1+ubv1
    lda.z ubv1
    asl
    // SCREEN[idx++] = ubv1+ubv1
    sta SCREEN+$32
    // }
    rts
}
testSigned: {
    // SCREEN[idx++] = typeid(-120)
    lda #0
    sta SCREEN+$28*2
    // SCREEN[idx++] = typeid(sbc1)
    lda #TYPEID_SIGNED_BYTE
    sta SCREEN+$28*2+1
    // SCREEN[idx++] = typeid(sbv1)
    sta SCREEN+$28*2+1+1
    // SCREEN[idx++] = typeid(-120+-130)
    lda #0
    sta SCREEN+$28*2+1+1+1
    // SCREEN[idx++] = typeid(sbc1+-120)
    lda #TYPEID_SIGNED_BYTE
    sta SCREEN+$28*2+1+1+1+1
    // SCREEN[idx++] = typeid(-120+sbc1)
    sta SCREEN+$28*2+1+1+1+1+1
    // SCREEN[idx++] = typeid(sbv1+-120)
    sta SCREEN+$28*2+1+1+1+1+1+1
    // SCREEN[idx++] = typeid(-120+sbv1)
    sta SCREEN+$28*2+1+1+1+1+1+1+1
    // SCREEN[idx++] = typeid(sbv1+sbc1)
    sta SCREEN+$28*2+1+1+1+1+1+1+1+1
    // SCREEN[idx++] = typeid(sbc1+sbv1)
    sta SCREEN+$28*2+1+1+1+1+1+1+1+1+1
    // SCREEN[idx++] = typeid(sbv1+sbv1)
    sta SCREEN+$28*2+1+1+1+1+1+1+1+1+1+1
    // }
    rts
}
testSignedVals: {
    .const sbc1 = -$78
    .label sbv1 = 3
    // volatile signed byte sbv1 = -120
    lda #-$78
    sta.z sbv1
    // SSCREEN[idx++] = (-120)
    sta SSCREEN+$28*3
    // SSCREEN[idx++] = (sbc1)
    lda #sbc1
    sta SSCREEN+$28*3+1
    // SSCREEN[idx++] = (sbv1)
    lda.z sbv1
    sta SSCREEN+$28*3+1+1
    // SSCREEN[idx++] = (-70+-50)
    lda #-$46+-$32
    sta SSCREEN+$28*3+1+1+1
    // SSCREEN[idx++] = (sbc1+-120)
    lda #sbc1+-$78
    sta SSCREEN+$28*3+1+1+1+1
    // SSCREEN[idx++] = (-120+sbc1)
    lda #-$78+sbc1
    sta SSCREEN+$28*3+1+1+1+1+1
    // sbv1+-120
    lax.z sbv1
    axs #-[-$78]
    // SSCREEN[idx++] = (sbv1+-120)
    stx SSCREEN+$28*3+1+1+1+1+1+1
    // -120+sbv1
    lax.z sbv1
    axs #-[-$78]
    // SSCREEN[idx++] = (-120+sbv1)
    stx SSCREEN+$28*3+1+1+1+1+1+1+1
    // sbv1+sbc1
    lda #sbc1
    clc
    adc.z sbv1
    // SSCREEN[idx++] = (sbv1+sbc1)
    sta SSCREEN+$28*3+1+1+1+1+1+1+1+1
    // sbc1+sbv1
    lda #sbc1
    clc
    adc.z sbv1
    // SSCREEN[idx++] = (sbc1+sbv1)
    sta SSCREEN+$28*3+1+1+1+1+1+1+1+1+1
    // sbv1+sbv1
    lda.z sbv1
    asl
    // SSCREEN[idx++] = (sbv1+sbv1)
    sta SSCREEN+$28*3+1+1+1+1+1+1+1+1+1+1
    // }
    rts
}
