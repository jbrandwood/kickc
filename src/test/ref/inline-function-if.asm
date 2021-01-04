// Test inlining a slightly complex print function (containing an if)
  // Commodore 64 PRG executable file
.file [name="inline-function-if.prg", type="prg", segments="Program"]
.segmentdef Program [segments="Basic, Code, Data"]
.segmentdef Basic [start=$0801]
.segmentdef Code [start=$80d]
.segmentdef Data [startAfter="Code"]
.segment Basic
:BasicUpstart(main)
  .label screen = $400
.segment Code
main: {
    .const toUpper1_ch = 'c'
    .const toUpper2_ch = 'm'
    .const toUpper1_return = toUpper1_ch+$40
    // screen[0] = toUpper('c',true)
    lda #toUpper1_return
    sta screen
    // screen[1] = toUpper('m',false)
    lda #toUpper2_ch
    sta screen+1
    // }
    rts
}
