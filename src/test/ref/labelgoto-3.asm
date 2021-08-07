// Test labels/goto
// an infinite loop using goto
  // Commodore 64 PRG executable file
.file [name="labelgoto-3.prg", type="prg", segments="Program"]
.segmentdef Program [segments="Basic, Code, Data"]
.segmentdef Basic [start=$0801]
.segmentdef Code [start=$80d]
.segmentdef Data [startAfter="Code"]
.segment Basic
:BasicUpstart(main)
.segment Code
main: {
    .label SCREEN = $400
    ldx #0
  repeat:
    // SCREEN[i++] = '*'
    lda #'*'
    sta SCREEN,x
    // SCREEN[i++] = '*';
    inx
    jmp repeat
}
