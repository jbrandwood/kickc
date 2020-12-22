// Inner increment is not being done properly (screen++)
  // Commodore 64 PRG executable file
.file [name="inner-increment-problem.prg", type="prg", segments="Program"]
.segmentdef Program [segments="Basic, Code, Data"]
.segmentdef Basic [start=$0801]
.segmentdef Code [start=$80d]
.segmentdef Data [startAfter="Code"]
.segment Basic
:BasicUpstart(main)
.segment Code
main: {
    // Count the number of the different chars on the screen
    .label screen = 2
    .label i = 4
    lda #<0
    sta.z i
    sta.z i+1
    lda #<$400
    sta.z screen
    lda #>$400
    sta.z screen+1
  __b1:
    // CHAR_COUNTS[*screen++]++;
    ldy #0
    lda (screen),y
    asl
    tax
    inc CHAR_COUNTS,x
    bne !+
    inc CHAR_COUNTS+1,x
  !:
    inc.z screen
    bne !+
    inc.z screen+1
  !:
    // for( word i:0..999)
    inc.z i
    bne !+
    inc.z i+1
  !:
    lda.z i+1
    cmp #>$3e8
    bne __b1
    lda.z i
    cmp #<$3e8
    bne __b1
    // }
    rts
}
.segment Data
  CHAR_COUNTS: .fill 2*$100, 0
