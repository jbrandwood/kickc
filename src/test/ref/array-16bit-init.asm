// Demonstrates wrong padding for non-byte arrays.
// https://gitlab.com/camelot/kickc/-/issues/497
  // Commodore 64 PRG executable file
.file [name="array-16bit-init.prg", type="prg", segments="Program"]
.segmentdef Program [segments="Basic, Code, Data"]
.segmentdef Basic [start=$0801]
.segmentdef Code [start=$80d]
.segmentdef Data [startAfter="Code"]
.segment Basic
:BasicUpstart(main)
  .const SIZEOF_POINTER = 2
.segment Code
main: {
    ldx #0
  __b1:
    // for(char c=0;c<sizeof(levelRowOff)/sizeof(char*); c++)
    cpx #$1f*SIZEOF_POINTER/SIZEOF_POINTER
    bcc __b2
    // }
    rts
  __b2:
    // levelRowOff[c] = 12345
    txa
    asl
    tay
    lda #<$3039
    sta levelRowOff,y
    lda #>$3039
    sta levelRowOff+1,y
    // for(char c=0;c<sizeof(levelRowOff)/sizeof(char*); c++)
    inx
    jmp __b1
}
.segment Data
  levelRowOff: .word 1, 2, 3
  .fill 2*$1c, 0
