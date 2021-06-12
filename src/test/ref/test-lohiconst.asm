// PI in u[4.28] format
  // Commodore 64 PRG executable file
.file [name="test-lohiconst.prg", type="prg", segments="Program"]
.segmentdef Program [segments="Basic, Code, Data"]
.segmentdef Basic [start=$0801]
.segmentdef Code [start=$80d]
.segmentdef Data [startAfter="Code"]
.segment Basic
:BasicUpstart(main)
  .const PI_u4f28 = $3243f6a9
.segment Code
main: {
    .label SCREEN = $400
    // SCREEN[0] = BYTE3(PI_u4f28)
    lda #>PI_u4f28>>$10
    sta SCREEN
    // SCREEN[1] = BYTE2(PI_u4f28)
    lda #<PI_u4f28>>$10
    sta SCREEN+1
    // SCREEN[2] = BYTE1(PI_u4f28)
    lda #>PI_u4f28
    sta SCREEN+2
    // SCREEN[3] = BYTE0(PI_u4f28)
    lda #<PI_u4f28
    sta SCREEN+3
    // }
    rts
}
