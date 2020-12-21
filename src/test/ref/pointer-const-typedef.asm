// Test pointer to const and const pointer combined with typedef
  // Commodore 64 PRG executable file
.file [name="pointer-const-typedef.prg", type="prg", segments="Program"]
.segmentdef Program [segments="Basic, Code, Data"]
.segmentdef Basic [start=$0801]
.segmentdef Code [start=$80d]
.segmentdef Data [startAfter="Code"]
.segment Basic
:BasicUpstart(main)
  // Const pointer
  .label cp0 = $400
  .label cp1 = $400
  .label cp2 = $400
  // Const pointer to const
  .label cpc0 = $400
  .label cpc1 = $400
  .label cpc2 = $400
  // Pointer to const
  .label pc0 = $400
  .label pc1 = $400
  .label pc2 = $400
  .label SCREEN = $400
.segment Code
main: {
    // SCREEN[idx++] = *pc0
    lda pc0
    sta SCREEN
    // SCREEN[idx++] = *pc1
    lda pc1
    sta SCREEN+1
    // SCREEN[idx++] = *pc2
    lda pc2
    sta SCREEN+2
    // SCREEN[idx++] = *cp0
    lda cp0
    sta SCREEN+3
    // SCREEN[idx++] = *cp1
    lda cp1
    sta SCREEN+4
    // SCREEN[idx++] = *cp2
    lda cp2
    sta SCREEN+5
    // SCREEN[idx++] = *cpc0
    lda cpc0
    sta SCREEN+6
    // SCREEN[idx++] = *cpc1
    lda cpc1
    sta SCREEN+7
    // SCREEN[idx++] = *cpc2
    lda cpc2
    sta SCREEN+8
    // }
    rts
}
