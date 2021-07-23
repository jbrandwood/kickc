// Minimal union with C-Standard behavior - union initializer with first element smaller than second
  // Commodore 64 PRG executable file
.file [name="union-6.prg", type="prg", segments="Program"]
.segmentdef Program [segments="Basic, Code, Data"]
.segmentdef Basic [start=$0801]
.segmentdef Code [start=$80d]
.segmentdef Data [startAfter="Code"]
.segment Basic
:BasicUpstart(main)
  .label SCREEN = $400
.segment Code
main: {
    // data.w = 0x1234
    lda #<$1234
    sta data
    lda #>$1234
    sta data+1
    // BYTE1(data.w)
    // SCREEN[0] = BYTE1(data.w)
    sta SCREEN
    // BYTE0(data.w)
    lda data
    // SCREEN[1] = BYTE0(data.w)
    sta SCREEN+1
    // }
    rts
}
.segment Data
  data: .byte $c
  .fill 1, 0
