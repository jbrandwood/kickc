/// @file
/// PEEK and POKE macros for those who want to write BASIC code in C
///
/// Based on https://github.com/cc65/cc65/blob/master/include/peekpoke.h
  // Commodore 64 PRG executable file
.file [name="ducks-loop211.prg", type="prg", segments="Program"]
.segmentdef Program [segments="Basic, Code, Data"]
.segmentdef Basic [start=$0801]
.segmentdef Code [start=$80d]
.segmentdef Data [startAfter="Code"]
.segment Basic
:BasicUpstart(main)
  .const brick = $e6
.segment Code
main: {
    .label k = 2
    lda #1
    sta.z k
  __b1:
    // POKE
    lda.z k
    asl
    asl
    sta.z $d3
    // chrout(brick)
    lda #brick
    sta.z chrout.petscii
    jsr chrout
    // ++k;
    inc.z k
    // while (k<5)
    lda.z k
    cmp #5
    bcc __b1
    // }
    rts
}
// void chrout(__zp(3) volatile char petscii)
chrout: {
    .label petscii = 3
    // asm
    lda petscii
    jsr $ffd2
    // }
    rts
}
