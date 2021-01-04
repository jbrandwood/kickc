// Tests a number of constant declarations
  // Commodore 64 PRG executable file
.file [name="const-declaration.prg", type="prg", segments="Program"]
.segmentdef Program [segments="Basic, Code, Data"]
.segmentdef Basic [start=$0801]
.segmentdef Code [start=$80d]
.segmentdef Data [startAfter="Code"]
.segment Basic
:BasicUpstart(main)
  .const LINE_LEN = $28
  .const MARGIN_TOP = 4
  .const MARGIN_LEFT = 4
  .const OFFSET = $28*5+5
  .label SCREEN = $400
  .label BODY1 = SCREEN+MARGIN_TOP*LINE_LEN+MARGIN_LEFT
  .label BODY2 = SCREEN+OFFSET
.segment Code
main: {
    // *BODY1 = '*'
    lda #'*'
    sta BODY1
    // *BODY2 = '*'
    sta BODY2
    // }
    rts
}
