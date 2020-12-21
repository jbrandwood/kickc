  // Commodore 64 PRG executable file
.file [name="incd020-2.prg", type="prg", segments="Program"]
.segmentdef Program [segments="Basic, Code, Data"]
.segmentdef Basic [start=$0801]
.segmentdef Code [start=$80d]
.segmentdef Data [startAfter="Code"]
.segment Basic
:BasicUpstart(main)
.segment Code
main: {
  __b1:
    // (*(unsigned char *)(53280))++;
    inc $d020
    // while ( (*(unsigned char *)(53280)) < 255)
    lda $d020
    cmp #$ff
    bcc __b1
    // }
    rts
}
