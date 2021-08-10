// Minimal classic for() loop - coded using while() to test optimization of loop heads
  // Commodore 64 PRG executable file
.file [name="loop-memset-min.prg", type="prg", segments="Program"]
.segmentdef Program [segments="Basic, Code, Data"]
.segmentdef Basic [start=$0801]
.segmentdef Code [start=$80d]
.segmentdef Data [startAfter="Code"]
.segment Basic
:BasicUpstart(main)
  .label SCREEN = $400
.segment Code
main: {
    // memset(SCREEN, 'c', 1000)
    jsr memset
    // }
    rts
}
// Copies the character c (an unsigned char) to the first num characters of the object pointed to by the argument str.
// void * memset(void *str, char c, unsigned int num)
memset: {
    .const c = 'c'
    .const num = $3e8
    .label str = SCREEN
    .label end = str+num
    .label dst = 2
    lda #<str
    sta.z dst
    lda #>str
    sta.z dst+1
  __b1:
    // while(dst!=end)
    lda.z dst+1
    cmp #>end
    bne __b2
    lda.z dst
    cmp #<end
    bne __b2
    // }
    rts
  __b2:
    // *dst = c
    lda #c
    ldy #0
    sta (dst),y
    // dst++;
    inc.z dst
    bne !+
    inc.z dst+1
  !:
    jmp __b1
}
