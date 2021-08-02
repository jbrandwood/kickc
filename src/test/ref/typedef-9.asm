// https://gitlab.com/camelot/kickc/-/issues/586
// typedef enum not defining values
  // Commodore 64 PRG executable file
.file [name="typedef-9.prg", type="prg", segments="Program"]
.segmentdef Program [segments="Basic, Code, Data"]
.segmentdef Basic [start=$0801]
.segmentdef Code [start=$80d]
.segmentdef Data [startAfter="Code"]
.segment Basic
:BasicUpstart(main)
  .const A = 0
  .const I = 0
  .const J = 1
  .label SCREEN = $400
.segment Code
main: {
    // SCREEN[0] = a
    // <<<--- ERROR here
    lda #I
    sta SCREEN
    // SCREEN[1] = b
    lda #J
    sta SCREEN+1
    // SCREEN[2] = c
    lda #A
    sta SCREEN+2
    // }
    rts
}
