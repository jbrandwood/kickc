// Test inference of number types using a long sum
// Currently fails - because the compiler does not handle byte+byte correctly (not truncating the result to 8 bits)
  // Commodore 64 PRG executable file
.file [name="number-inference-sum.prg", type="prg", segments="Program"]
.segmentdef Program [segments="Basic, Code, Data"]
.segmentdef Basic [start=$0801]
.segmentdef Code [start=$80d]
.segmentdef Data [startAfter="Code"]
.segment Basic
:BasicUpstart(main)
.segment Code
main: {
    .const RED = 2
    .const b1 = $fa
    .const b2 = b1+$fa
    .const w = b2+1
    .label screen = $400
    .label BG_COLOR = $d020
    // screen[0] = w
    lda #<w
    sta screen
    lda #>w
    sta screen+1
    // *BG_COLOR = RED
    lda #RED
    sta BG_COLOR
    // }
    rts
}
