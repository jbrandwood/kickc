// Test a constant word pointers (pointing to a word placed on zeropage).
// The result when running is "CML!" on the screen.
  // Commodore 64 PRG executable file
.file [name="const-word-pointer.prg", type="prg", segments="Program"]
.segmentdef Program [segments="Basic, Code, Data"]
.segmentdef Basic [start=$0801]
.segmentdef Code [start=$80d]
.segmentdef Data [startAfter="Code"]
.segment Basic
:BasicUpstart(main)
.segment Code
main: {
    .label screen = $400
    .label wp = w
    .label w = 2
    // w = $0d03
    lda #<$d03
    sta.z w
    lda #>$d03
    sta.z w+1
    // <*wp
    lda.z wp
    // screen[0] = <*wp
    sta screen
    // >*wp
    lda.z wp+1
    // screen[1] = >*wp
    sta screen+1
    // *wp = $210c
    lda #<$210c
    sta.z wp
    lda #>$210c
    sta.z wp+1
    // <*wp
    lda.z wp
    // screen[2] = <*wp
    sta screen+2
    // >*wp
    lda.z wp+1
    // screen[3] = >*wp
    sta screen+3
    // }
    rts
}
