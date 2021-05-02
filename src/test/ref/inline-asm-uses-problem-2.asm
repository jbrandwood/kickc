// Demonstrates problem with inline ASM usages - and early-detect constants
// zp2 should be forced to live at address $fc - but is identified to be constant by Pass1EarlyConstantIdentification
  // Commodore 64 PRG executable file
.file [name="inline-asm-uses-problem-2.prg", type="prg", segments="Program"]
.segmentdef Program [segments="Basic, Code, Data"]
.segmentdef Basic [start=$0801]
.segmentdef Code [start=$80d]
.segmentdef Data [startAfter="Code"]
.segment Basic
:BasicUpstart(main)
.segment Code
main: {
    .label zp2 = $fc
    // __address(0xfc) char * zp2 = 0x0400
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
