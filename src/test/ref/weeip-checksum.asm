/**
 * @file checksum.c
 * @brief Helper functions for calculating IP checksums.
 * @compiler CPIK 0.7.3 / MCC18 3.36
 * @author Bruno Basseto (bruno@wise-ware.org)
 */
  // Commodore 64 PRG executable file
.file [name="weeip-checksum.prg", type="prg", segments="Program"]
.segmentdef Program [segments="Basic, Code, Data"]
.segmentdef Basic [start=$0801]
.segmentdef Code [start=$80d]
.segmentdef Data [startAfter="Code"]
.segment Basic
:BasicUpstart(main)
  .const SIZEOF_WORD = 2
  .const SIZEOF_UNION___0 = 2
  .label SCREEN = $400
  .label _b16 = 4
  .label _b16_1 = 6
.segment Code
main: {
    // checksum_init
    lda #<0
    sta chks
    sta chks+1
    // add_checksum(0x1234)
    lda #<$1234
    sta.z add_checksum.v
    lda #>$1234
    sta.z add_checksum.v+1
    jsr add_checksum
    // SCREEN[0] = chks.u
    lda chks
    sta SCREEN
    lda chks+1
    sta SCREEN+1
    // add_checksum(0x2345)
    lda #<$2345
    sta.z add_checksum.v
    lda #>$2345
    sta.z add_checksum.v+1
    jsr add_checksum
    // SCREEN[1] = chks.u
    lda chks
    sta SCREEN+1*SIZEOF_WORD
    lda chks+1
    sta SCREEN+1*SIZEOF_WORD+1
    // add_checksum(0x3456)
    lda #<$3456
    sta.z add_checksum.v
    lda #>$3456
    sta.z add_checksum.v+1
    jsr add_checksum
    // SCREEN[1] = chks.u
    lda chks
    sta SCREEN+1*SIZEOF_WORD
    lda chks+1
    sta SCREEN+1*SIZEOF_WORD+1
    // }
    rts
}
/**
 * Sums a 16-bit word to the current checksum value.
 * Optimized for 8-bit word processors.
 * The result is found in chks.
 * @param v Value to sum.
 */
// add_checksum(word zp(2) v)
add_checksum: {
    .label __3 = 4
    .label __6 = 6
    .label __14 = 4
    .label __15 = 6
    .label v = 2
    // _a = chks.b[0]
    /*
    * First byte (MSB).
    */
    lda chks
    // HIGH
    ldx.z v+1
    // (uint16_t)_a + HIGH
    sta.z __14
    lda #0
    sta.z __14+1
    // _b16 = (uint16_t)_a + HIGH
    txa
    clc
    adc.z _b16
    sta.z _b16
    bcc !+
    inc.z _b16+1
  !:
    // _b = LOW
    ldx.z _b16
    // HIGH
    lda.z __3+1
    sta.z __3
    lda #0
    sta.z __3+1
    // _c = HIGH
    tay
    // chks.b[0] = _b
    stx chks
    // _a = chks.b[1]
    /*
    * Second byte (LSB).
    */
    lda chks+1
    // LOW
    ldx.z v
    // (uint16_t)_a + (LOW(v))
    sta.z __15
    tya
    sta.z __15+1
    txa
    clc
    adc.z __6
    sta.z __6
    bcc !+
    inc.z __6+1
  !:
    // _b16 = (uint16_t)_a + (LOW(v)) + _c
    tya
    clc
    adc.z _b16_1
    sta.z _b16_1
    bcc !+
    inc.z _b16_1+1
  !:
    // _b = LOW
    ldx.z _b16_1
    // _c = HIGH
    lda.z _b16_1+1
    // chks.b[1] = _b
    stx chks+1
    // if(_c)
    cmp #0
    beq __breturn
    // if(++chks.b[0] == 0)
    inc chks
    lda chks
    bne __breturn
    // chks.b[1]++;
    inc chks+1
  __breturn:
    // }
    rts
}
.segment Data
  /**
 * Last checksum computation result.
 */
  chks: .fill SIZEOF_UNION___0, 0
