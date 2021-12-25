// Test using some simple supported string escape characters in PETSCII
  // Commodore 64 PRG executable file
.file [name="string-escapes-2.prg", type="prg", segments="Program"]
.segmentdef Program [segments="Basic, Code, Data"]
.segmentdef Basic [start=$0801]
.segmentdef Code [start=$80d]
.segmentdef Data [startAfter="Code"]
.segment Basic
:BasicUpstart(main)
  .label memA = $ff
.segment Code
main: {
    .label i = 2
    lda #0
    sta.z i
  __b1:
    // while(MESSAGE[i])
    ldy.z i
    lda MESSAGE,y
    cmp #0
    bne __b2
    // }
    rts
  __b2:
    // chrout(MESSAGE[i++])
    ldy.z i
    lda MESSAGE,y
    jsr chrout
    // chrout(MESSAGE[i++]);
    inc.z i
    jmp __b1
}
// void chrout(__register(A) char c)
chrout: {
    // *memA = c
    sta.z memA
    // asm
    jsr $ffd2
    // }
    rts
}
.segment Data
.encoding "petscii_mixed"
  MESSAGE: .text @"hello\nworld\\"
  .byte 0
