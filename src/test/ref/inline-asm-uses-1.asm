// Demonstrates inline ASM using a variable (res)
  // Commodore 64 PRG executable file
.file [name="inline-asm-uses-1.prg", type="prg", segments="Program"]
.segmentdef Program [segments="Basic, Code, Data"]
.segmentdef Basic [start=$0801]
.segmentdef Code [start=$80d]
.segmentdef Data [startAfter="Code"]
.segment Basic
:BasicUpstart(main)
  .label CHKIN = $1000
  .label GETIN = $1003
  .label CLRCHN = $1006
.segment Code
main: {
    .label SCREEN = $1009
    // char x = fgetc(7)
    lda #7
    sta.z fgetc.channel
    jsr fgetc
    // *SCREEN = x
    sta SCREEN
    // }
    rts
}
// fgetc(byte zp(2) channel)
fgetc: {
    .label channel = 2
    .label ret = 3
    // char ret
    lda #0
    sta.z ret
    // asm
    ldx channel
    jsr CHKIN
    jsr GETIN
    sta ret
    jsr CLRCHN
    // return ret;
    lda.z ret
    // }
    rts
}
