// Typedef const/volatile type
  // Commodore 64 PRG executable file
.file [name="typedef-4.prg", type="prg", segments="Program"]
.segmentdef Program [segments="Basic, Code, Data"]
.segmentdef Basic [start=$0801]
.segmentdef Code [start=$80d]
.segmentdef Data [startAfter="Code"]
.segment Basic
:BasicUpstart(__start)
  .const c = 'c'
  .label SCREEN = $400
  .label v = 2
.segment Code
__start: {
    // volatile V v = 'v'
    lda #'v'
    sta.z v
    jsr main
    rts
}
main: {
    // SCREEN[0] = c
    lda #c
    sta SCREEN
    // SCREEN[1] = v
    lda.z v
    sta SCREEN+1
    // }
    rts
}
