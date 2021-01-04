// Test ATARI chipset variations
// Pointer to struct versus MAcro pointer to struct
  // Commodore 64 PRG executable file
.file [name="chipset-test.prg", type="prg", segments="Program"]
.segmentdef Program [segments="Basic, Code, Data"]
.segmentdef Basic [start=$0801]
.segmentdef Code [start=$80d]
.segmentdef Data [startAfter="Code"]
.segment Basic
:BasicUpstart(main)
  .label PIA2 = $d300
.segment Code
main: {
    // PIA1.porta = 7
    lda #7
    sta $d300
    // PIA2->PORTA = 7
    sta PIA2
    // }
    rts
}
