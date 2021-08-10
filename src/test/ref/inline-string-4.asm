// Test casting the address of an inline string to a dword.
  // Commodore 64 PRG executable file
.file [name="inline-string-4.prg", type="prg", segments="Program"]
.segmentdef Program [segments="Basic, Code, Data"]
.segmentdef Basic [start=$0801]
.segmentdef Code [start=$80d]
.segmentdef Data [startAfter="Code"]
.segment Basic
:BasicUpstart(main)
  .label screen = $400
.segment Code
main: {
    .label dw = msg
    // output(dw)
    jsr output
    // }
    rts
  .segment Data
    msg: .text "camelot"
    .byte 0
}
.segment Code
// void output(unsigned long dw)
output: {
    // *screen = dw
    lda #<main.dw
    sta screen
    lda #>main.dw
    sta screen+1
    lda #<main.dw>>$10
    sta screen+2
    lda #>main.dw>>$10
    sta screen+3
    // }
    rts
}
