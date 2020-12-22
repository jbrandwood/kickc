// Tests uninitialized values of variables.
  // Commodore 64 PRG executable file
.file [name="uninitialized.prg", type="prg", segments="Program"]
.segmentdef Program [segments="Basic, Code, Data"]
.segmentdef Basic [start=$0801]
.segmentdef Code [start=$80d]
.segmentdef Data [startAfter="Code"]
.segment Basic
:BasicUpstart(main)
  .const b = 0
  .label SCREEN = $400
.segment Code
main: {
    // SCREEN[0] = b
    lda #b
    sta SCREEN
    // SCREEN[2] = <w
    lda #0
    sta SCREEN+2
    // SCREEN[3] = >w
    sta SCREEN+3
    // SCREEN[5] = (byte)<ptr
    sta SCREEN+5
    // SCREEN[5] = (byte)>ptr
    sta SCREEN+5
    // }
    rts
}
