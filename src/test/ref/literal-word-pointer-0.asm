// Tests assigning a literal word pointer
  // Commodore 64 PRG executable file
.file [name="literal-word-pointer-0.prg", type="prg", segments="Program"]
.segmentdef Program [segments="Basic, Code, Data"]
.segmentdef Basic [start=$0801]
.segmentdef Code [start=$80d]
.segmentdef Data [startAfter="Code"]
.segment Basic
:BasicUpstart(main)
.segment Code
main: {
    // print("qwe")
    jsr print
    // }
    rts
  .segment Data
    str: .text "qwe"
    .byte 0
}
.segment Code
// void print(char *str)
print: {
    // *(char**)0x80 = (char*)str
    lda #<main.str
    sta.z $80
    lda #>main.str
    sta.z $80+1
    // }
    rts
}
