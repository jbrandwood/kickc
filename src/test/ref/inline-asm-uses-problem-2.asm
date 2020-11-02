// Demonstrates problem with inline ASM usages - and early-detect constants
// zp2 should be forced to live at address $fc - but is identified to be constant by Pass1EarlyConstantIdentification
.pc = $801 "Basic"
:BasicUpstart(main)
.pc = $80d "Program"
main: {
    .label zp2 = $fc
    // zp2 = 0x0400
    lda #<$400
    sta.z zp2
    lda #>$400
    sta.z zp2+1
    // zp2[1] = '*'
    lda #'*'
    ldy #1
    sta (zp2),y
    // asm
    lda #$28
    sta zp2
    // zp2[2] = '*'
    lda #'*'
    ldy #2
    sta (zp2),y
    // }
    rts
}
