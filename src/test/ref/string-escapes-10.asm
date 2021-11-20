// Test octal escapes in chars
  // Commodore 64 PRG executable file
.file [name="string-escapes-10.prg", type="prg", segments="Program"]
.segmentdef Program [segments="Basic, Code, Data"]
.segmentdef Basic [start=$0801]
.segmentdef Code [start=$80d]
.segmentdef Data [startAfter="Code"]
.segment Basic
:BasicUpstart(main)
  .const MSG1 = 'a'
  .const MSG2 = 'b'
  .const MSG3 = 'c'
  .const MSG4 = '\$ff'
  .label SCREEN = $400
.segment Code
main: {
    // SCREEN[0] = MSG1
    lda #MSG1
    sta SCREEN
    // SCREEN[1] = MSG2
    lda #MSG2
    sta SCREEN+1
    // SCREEN[2] = MSG3
    lda #MSG3
    sta SCREEN+2
    // SCREEN[3] = MSG4
    lda #MSG4
    sta SCREEN+3
    // }
    rts
}
