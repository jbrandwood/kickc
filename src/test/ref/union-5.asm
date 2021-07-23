// Minimal union with C-Standard behavior - union initializer
  // Commodore 64 PRG executable file
.file [name="union-5.prg", type="prg", segments="Program"]
.segmentdef Program [segments="Basic, Code, Data"]
.segmentdef Basic [start=$0801]
.segmentdef Code [start=$80d]
.segmentdef Data [startAfter="Code"]
.segment Basic
:BasicUpstart(main)
  .label SCREEN = $400
.segment Code
main: {
    // SCREEN[0] = ipv4.b[3]
    lda ipv4+3
    sta SCREEN
    // SCREEN[1] = ipv4.b[2]
    lda ipv4+2
    sta SCREEN+1
    // SCREEN[2] = ipv4.b[1]
    lda ipv4+1
    sta SCREEN+2
    // SCREEN[3] = ipv4.b[0]
    lda ipv4
    sta SCREEN+3
    // }
    rts
}
.segment Data
  ipv4: .dword $12345678
