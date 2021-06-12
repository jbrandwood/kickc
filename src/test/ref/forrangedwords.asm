  // Commodore 64 PRG executable file
.file [name="forrangedwords.prg", type="prg", segments="Program"]
.segmentdef Program [segments="Basic, Code, Data"]
.segmentdef Basic [start=$0801]
.segmentdef Code [start=$80d]
.segmentdef Data [startAfter="Code"]
.segment Basic
:BasicUpstart(main)
.segment Code
main: {
    .label SCREEN = $400
    .label w = 2
    .label sw = 4
    lda #<0
    sta.z w
    sta.z w+1
  __b1:
    // BYTE0(w)
    lda.z w
    // SCREEN[0] = BYTE0(w)
    sta SCREEN
    // BYTE1(w)
    lda.z w+1
    // SCREEN[1] = BYTE1(w)
    sta SCREEN+1
    // for( word w: 0..$ffff)
    inc.z w
    bne !+
    inc.z w+1
  !:
    lda.z w
    ora.z w+1
    bne __b1
    lda #<-$7fff
    sta.z sw
    lda #>-$7fff
    sta.z sw+1
  __b2:
    // BYTE0(sw)
    lda.z sw
    // SCREEN[3] = BYTE0(sw)
    sta SCREEN+3
    // BYTE1(sw)
    lda.z sw+1
    // SCREEN[4] = BYTE1(sw)
    sta SCREEN+4
    // for( signed word sw: -$7fff..$7ffe)
    inc.z sw
    bne !+
    inc.z sw+1
  !:
    lda.z sw+1
    cmp #>$7fff
    bne __b2
    lda.z sw
    cmp #<$7fff
    bne __b2
    // }
    rts
}
