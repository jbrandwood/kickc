// An unrolled loop modifying a var used later
  // Commodore 64 PRG executable file
.file [name="unroll-loop-modifyvar.prg", type="prg", segments="Program"]
.segmentdef Program [segments="Basic, Code, Data"]
.segmentdef Basic [start=$0801]
.segmentdef Code [start=$80d]
.segmentdef Data [startAfter="Code"]
.segment Basic
:BasicUpstart(main)
.segment Code
main: {
    .label SCREEN = $400
    // SCREEN[a]=a
    lda #3
    sta SCREEN+3
    lda #4
    sta SCREEN+4
    lda #5
    sta SCREEN+5
    lda #6
    sta SCREEN+6
    lda #7
    sta SCREEN+7
    lda #8
    sta SCREEN+8
    lda #9
    sta SCREEN+9
    lda #$a
    sta SCREEN+$a
    lda #$b
    sta SCREEN+$b
    lda #$c
    sta SCREEN+$c
    lda #$d
    sta SCREEN+$d
    lda #$e
    sta SCREEN+$e
    // }
    rts
}
