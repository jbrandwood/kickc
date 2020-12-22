// Test KickC performance for 16-bit array lookup function from article "Optimizing C array lookups for the 6502"
// http://8bitworkshop.com/blog/compilers/2019/03/17/cc65-optimization.html
  // Commodore 64 PRG executable file
.file [name="array-16bit-lookup.prg", type="prg", segments="Program"]
.segmentdef Program [segments="Basic, Code, Data"]
.segmentdef Basic [start=$0801]
.segmentdef Code [start=$80d]
.segmentdef Data [startAfter="Code"]
.segment Basic
:BasicUpstart(main)
.segment Code
main: {
    .label SCREEN = $400
    .label __0 = 4
    ldx #0
  __b1:
    // getValue(idx)
    txa
    sta.z getValue.index
    lda #0
    sta.z getValue.index+1
    jsr getValue
    // SCREEN[idx] = getValue(idx)
    txa
    asl
    tay
    lda.z __0
    sta SCREEN,y
    lda.z __0+1
    sta SCREEN+1,y
    // for(unsigned char idx : 0..128)
    inx
    cpx #$81
    bne __b1
    // }
    rts
}
// getValue(word zp(2) index)
getValue: {
    .label index = 2
    .label return = 4
    // index & 0x7f
    lda #$7f
    and.z index
    // arr16[index & 0x7f] & 0xff
    asl
    tay
    lda #$ff
    and arr16,y
    // (arr16[index & 0x7f] & 0xff) >> 1
    lsr
    // return (unsigned int)((arr16[index & 0x7f] & 0xff) >> 1);
    sta.z return
    lda #0
    sta.z return+1
    // }
    rts
}
.segment Data
  arr16: .fill 2*$80, 0
