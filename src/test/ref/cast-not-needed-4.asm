// Tests a cast that is not needed
// When assigning a char from an integer
  // Commodore 64 PRG executable file
.file [name="cast-not-needed-4.prg", type="prg", segments="Program"]
.segmentdef Program [segments="Basic, Code, Data"]
.segmentdef Basic [start=$0801]
.segmentdef Code [start=$80d]
.segmentdef Data [startAfter="Code"]
.segment Basic
:BasicUpstart(main)
.segment Code
main: {
    .label screen = 4
    .label i = 2
    lda #<$400
    sta.z screen
    lda #>$400
    sta.z screen+1
    lda #<-$3e8
    sta.z i
    lda #>-$3e8
    sta.z i+1
  __b1:
    // for(int i=-1000;i<1000;i++)
    lda.z i
    cmp #<$3e8
    lda.z i+1
    sbc #>$3e8
    bvc !+
    eor #$80
  !:
    bmi __b2
    // }
    rts
  __b2:
    // char c = i
    lda.z i
    // *(screen++) = c
    ldy #0
    sta (screen),y
    // *(screen++) = c;
    inc.z screen
    bne !+
    inc.z screen+1
  !:
    // for(int i=-1000;i<1000;i++)
    inc.z i
    bne !+
    inc.z i+1
  !:
    jmp __b1
}
