// Demonstrates that a local __ma variable overwrites a parameter§
.pc = $801 "Basic"
:BasicUpstart(__start)
.pc = $80d "Program"
  .label h1 = 2
__start: {
    // h1
    lda #<0
    sta.z h1
    sta.z h1+1
    jsr main
    rts
}
main: {
    // test(h1, 0xD800, 0xC000)
    lda.z h1
    sta.z test.videoMem
    lda.z h1+1
    sta.z test.videoMem+1
    jsr test
    // }
    rts
}
// This must be volatile because is used in an interrupt routine...
// test(byte* zp(4) videoMem)
test: {
    .label colorMem = $d800
    .label other = $c000
    .label dst = 6
    .label __1 = 6
    .label diff = 4
    .label videoMem = 4
    // dst
    lda #<0
    sta.z dst
    sta.z dst+1
    // colorMem - videoMem
    sec
    lda #<colorMem
    sbc.z diff
    sta.z diff
    lda #>colorMem
    sbc.z diff+1
    sta.z diff+1
    // other + ((unsigned int)diff)
    clc
    lda.z diff
    adc #<other
    sta.z __1
    lda.z diff+1
    adc #>other
    sta.z __1+1
    // dst = other + ((unsigned int)diff)
    // dst[0] = 1
    lda #1
    ldy #0
    sta (dst),y
    // asm
    sta (dst),y
    // }
    rts
}
