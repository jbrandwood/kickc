  // Commodore 64 PRG executable file
.file [name="arrays-init.prg", type="prg", segments="Program"]
.segmentdef Program [segments="Basic, Code, Data"]
.segmentdef Basic [start=$0801]
.segmentdef Code [start=$80d]
.segmentdef Data [startAfter="Code"]
.segment Basic
:BasicUpstart(main)
  .label SCREEN = $400
.segment Code
main: {
    // b[0] = 'c'
    lda #'c'
    sta b
    // *SCREEN = b[0]
    sta SCREEN
    // *(SCREEN+1) = c[1]
    lda c+1
    sta SCREEN+1
    // *(SCREEN+2) = d[2]
    lda d+2
    sta SCREEN+2
    // }
    rts
}
.segment Data
  b: .fill 3, 0
  c: .byte 'c', 'm', 'l'
  d: .text "cml"
