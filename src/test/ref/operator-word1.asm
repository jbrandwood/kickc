// Test operator WORD1()
  // Commodore 64 PRG executable file
.file [name="operator-word1.prg", type="prg", segments="Program"]
.segmentdef Program [segments="Basic, Code, Data"]
.segmentdef Basic [start=$0801]
.segmentdef Code [start=$80d]
.segmentdef Data [startAfter="Code"]
.segment Basic
:BasicUpstart(main)
  .const SIZEOF_WORD = 2
.segment Code
main: {
    .label SCREEN = $400
    .label du = 2
    .label ds = 6
    .label __4 = $a
    .label __5 = $c
    // du = 2000000
    lda #<$1e8480
    sta.z du
    lda #>$1e8480
    sta.z du+1
    lda #<$1e8480>>$10
    sta.z du+2
    lda #>$1e8480>>$10
    sta.z du+3
    // ds = -3777777
    lda #<-$39a4f1
    sta.z ds
    lda #>-$39a4f1
    sta.z ds+1
    lda #<-$39a4f1>>$10
    sta.z ds+2
    lda #>-$39a4f1>>$10
    sta.z ds+3
    // SCREEN[i++] = WORD1(17)
    lda #<0
    sta SCREEN
    sta SCREEN+1
    // SCREEN[i++] = WORD1(377)
    sta SCREEN+1*SIZEOF_WORD
    sta SCREEN+1*SIZEOF_WORD+1
    // SCREEN[i++] = WORD1(bu)
    sta SCREEN+2*SIZEOF_WORD
    sta SCREEN+2*SIZEOF_WORD+1
    // SCREEN[i++] = WORD1(bs)
    sta SCREEN+3*SIZEOF_WORD
    sta SCREEN+3*SIZEOF_WORD+1
    // SCREEN[i++] = WORD1(wu)
    sta SCREEN+4*SIZEOF_WORD
    sta SCREEN+4*SIZEOF_WORD+1
    // SCREEN[i++] = WORD1(ws)
    sta SCREEN+5*SIZEOF_WORD
    sta SCREEN+5*SIZEOF_WORD+1
    // WORD1(du)
    lda.z du+2
    sta.z __4
    lda.z du+3
    sta.z __4+1
    // SCREEN[i++] = WORD1(du)
    lda.z __4
    sta SCREEN+6*SIZEOF_WORD
    lda.z __4+1
    sta SCREEN+6*SIZEOF_WORD+1
    // WORD1(ds)
    lda.z ds+2
    sta.z __5
    lda.z ds+3
    sta.z __5+1
    // SCREEN[i++] = WORD1(ds)
    lda.z __5
    sta SCREEN+7*SIZEOF_WORD
    lda.z __5+1
    sta SCREEN+7*SIZEOF_WORD+1
    // SCREEN[i++] = WORD1(ptr)
    lda #<0
    sta SCREEN+8*SIZEOF_WORD
    sta SCREEN+8*SIZEOF_WORD+1
    // }
    rts
}
