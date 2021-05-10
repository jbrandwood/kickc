  // Commodore 64 PRG executable file
.file [name="true-inline-words.prg", type="prg", segments="Program"]
.segmentdef Program [segments="Basic, Code, Data"]
.segmentdef Basic [start=$0801]
.segmentdef Code [start=$80d]
.segmentdef Data [startAfter="Code"]
.segment Basic
:BasicUpstart(main)
.segment Code
main: {
    // constant byte array
    .const b = 4
    .const w = b*$100
    .const w2 = 1*$100+1+w
    // Test the result
    .label pos = $501
    .label BG_COLOR = $d021
    // constant inline words inside expression
    .label sc = w2
    // *sc = bs[1]
    // cast to (byte*)
    lda bs+1
    sta sc
    // if(*pos=='m')
    lda #'m'
    cmp pos
    beq __b1
    // *BG_COLOR = 2
    lda #2
    sta BG_COLOR
    // }
    rts
  __b1:
    // *BG_COLOR = 5
    lda #5
    sta BG_COLOR
    rts
  .segment Data
    bs: .byte 'c', 'm'
}
