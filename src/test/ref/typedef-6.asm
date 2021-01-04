// Typedef pointer to const/volatile type and instantiate it
  // Commodore 64 PRG executable file
.file [name="typedef-6.prg", type="prg", segments="Program"]
.segmentdef Program [segments="Basic, Code, Data"]
.segmentdef Basic [start=$0801]
.segmentdef Code [start=$80d]
.segmentdef Data [startAfter="Code"]
.segment Basic
:BasicUpstart(main)
  .label SCREEN = $400
  .label cp = $a003
  .label vp = $a004
.segment Code
main: {
    // SCREEN[0] = *cp
    lda cp
    sta SCREEN
    // SCREEN[1] = *vp
    lda vp
    sta SCREEN+1
    // }
    rts
}
