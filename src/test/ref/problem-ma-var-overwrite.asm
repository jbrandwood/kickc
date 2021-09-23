// Demonstrates that a local __ma variable overwrites a parameter§
  // Commodore 64 PRG executable file
.file [name="problem-ma-var-overwrite.prg", type="prg", segments="Program"]
.segmentdef Program [segments="Basic, Code, Data"]
.segmentdef Basic [start=$0801]
.segmentdef Code [start=$80d]
.segmentdef Data [startAfter="Code"]
.segment Basic
:BasicUpstart(__start)
  .label h1 = 6
.segment Code
__start: {
    // unsigned char *volatile h1
    lda #<0
    sta.z h1
    sta.z h1+1
    jsr main
    rts
}
main: {
    // test(h1, (char*)0xD800, (char*)0xC000)
    lda.z h1
    sta.z test.videoMem
    lda.z h1+1
    sta.z test.videoMem+1
    jsr test
    // }
    rts
}
// This must be volatile because is used in an interrupt routine...
// void test(__zp(2) char *videoMem, char *colorMem, char *other)
test: {
    .label colorMem = $d800
    .label other = $c000
    .label dst = 4
    .label __1 = 2
    .label diff = 2
    .label videoMem = 2
    // __ma unsigned char *dst
    lda #<0
    sta.z dst
    sta.z dst+1
    // colorMem - videoMem
    lda #<colorMem
    sec
    sbc.z diff
    sta.z diff
    lda #>colorMem
    sbc.z diff+1
    sta.z diff+1
    // other + ((unsigned int)diff)
    lda.z __1
    clc
    adc #<other
    sta.z __1
    lda.z __1+1
    adc #>other
    sta.z __1+1
    // dst = other + ((unsigned int)diff)
    lda.z __1
    sta.z dst
    lda.z __1+1
    sta.z dst+1
    // dst[0] = 1
    lda #1
    ldy #0
    sta (dst),y
    // asm
    sta (dst),y
    // }
    rts
}
