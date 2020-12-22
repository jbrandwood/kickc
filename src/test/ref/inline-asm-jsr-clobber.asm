// Tests that inline ASM JSR clobbers all registers
  // Commodore 64 PRG executable file
.file [name="inline-asm-jsr-clobber.prg", type="prg", segments="Program"]
.segmentdef Program [segments="Basic, Code, Data"]
.segmentdef Basic [start=$0801]
.segmentdef Code [start=$80d]
.segmentdef Data [startAfter="Code"]
.segment Basic
:BasicUpstart(main)
.segment Code
main: {
    .label i = 2
    lda #0
    sta.z i
  __b1:
    // asm
    jsr $e544
    // for( byte i:0..10)
    inc.z i
    lda #$b
    cmp.z i
    bne __b1
    // }
    rts
}
