// Illustrates a problem where absolute addressing is used for zeropage-access
// This is caused by the compiler believing the pointer is into memory" (not knowing the upper part is 0x00 )
  // Commodore 64 PRG executable file
.file [name="zeropage-detect-advanced.prg", type="prg", segments="Program"]
.segmentdef Program [segments="Basic, Code, Data"]
.segmentdef Basic [start=$0801]
.segmentdef Code [start=$80d]
.segmentdef Data [startAfter="Code"]
.segment Basic
:BasicUpstart(main)
.segment Code
main: {
    .label c = t
    .label t = 2
    // t
    lda #<0
    sta.z t
    sta.z t+1
    lda #<0>>$10
    sta.z t+2
    lda #>0>>$10
    sta.z t+3
    // *(unsigned char *)0x0400 = c[0]
    lda.z c
    sta $400
    // }
    rts
}
