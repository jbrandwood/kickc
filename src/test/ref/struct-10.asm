// Illustrates a problem with pointer sizeof()-rewriting for pointers inside structs
  // Commodore 64 PRG executable file
.file [name="struct-10.prg", type="prg", segments="Program"]
.segmentdef Program [segments="Basic, Code, Data"]
.segmentdef Basic [start=$0801]
.segmentdef Code [start=$80d]
.segmentdef Data [startAfter="Code"]
.segment Basic
:BasicUpstart(main)
  .const SIZEOF_WORD = 2
.segment Code
main: {
    .label SCREEN = $400
    // SCREEN[0] = info.values[1]
    lda RADIX_DECIMAL_VALUES+1*SIZEOF_WORD
    sta SCREEN
    lda RADIX_DECIMAL_VALUES+1*SIZEOF_WORD+1
    sta SCREEN+1
    // SCREEN[1] = RADIX_DECIMAL_VALUES[1]
    lda RADIX_DECIMAL_VALUES+1*SIZEOF_WORD
    sta SCREEN+1*SIZEOF_WORD
    lda RADIX_DECIMAL_VALUES+1*SIZEOF_WORD+1
    sta SCREEN+1*SIZEOF_WORD+1
    // }
    rts
}
.segment Data
  RADIX_DECIMAL_VALUES: .word $2710, $3e8, $64, $a
