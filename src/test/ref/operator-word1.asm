// Test operator WORD1()
  // Commodore 64 PRG executable file
.file [name="operator-word1.prg", type="prg", segments="Program"]
.segmentdef Program [segments="Basic, Code, Data"]
.segmentdef Basic [start=$0801]
.segmentdef Code [start=$80d]
.segmentdef Data [startAfter="Code"]
.segment Basic
:BasicUpstart(main)
  .const SIZEOF_UNSIGNED_INT = 2
.segment Code
main: {
    .label SCREEN = $400
    .label du = 6
    .label ds = $a
    .label __4 = 2
    .label __5 = 4
    // volatile unsigned long du = 2000000
    lda #<$1e8480
    sta.z du
    lda #>$1e8480
    sta.z du+1
    lda #<$1e8480>>$10
    sta.z du+2
    lda #>$1e8480>>$10
    sta.z du+3
    // volatile signed long ds = -3777777
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
    sta SCREEN+1*SIZEOF_UNSIGNED_INT
    sta SCREEN+1*SIZEOF_UNSIGNED_INT+1
    // SCREEN[i++] = WORD1(bu)
    sta SCREEN+2*SIZEOF_UNSIGNED_INT
    sta SCREEN+2*SIZEOF_UNSIGNED_INT+1
    // SCREEN[i++] = WORD1(bs)
    sta SCREEN+3*SIZEOF_UNSIGNED_INT
    sta SCREEN+3*SIZEOF_UNSIGNED_INT+1
    // SCREEN[i++] = WORD1(wu)
    sta SCREEN+4*SIZEOF_UNSIGNED_INT
    sta SCREEN+4*SIZEOF_UNSIGNED_INT+1
    // SCREEN[i++] = WORD1(ws)
    sta SCREEN+5*SIZEOF_UNSIGNED_INT
    sta SCREEN+5*SIZEOF_UNSIGNED_INT+1
    // WORD1(du)
    lda.z du+2
    sta.z __4
    lda.z du+3
    sta.z __4+1
    // SCREEN[i++] = WORD1(du)
    lda.z __4
    sta SCREEN+6*SIZEOF_UNSIGNED_INT
    lda.z __4+1
    sta SCREEN+6*SIZEOF_UNSIGNED_INT+1
    // WORD1(ds)
    lda.z ds+2
    sta.z __5
    lda.z ds+3
    sta.z __5+1
    // SCREEN[i++] = WORD1(ds)
    lda.z __5
    sta SCREEN+7*SIZEOF_UNSIGNED_INT
    lda.z __5+1
    sta SCREEN+7*SIZEOF_UNSIGNED_INT+1
    // SCREEN[i++] = WORD1(ptr)
    lda #<0
    sta SCREEN+8*SIZEOF_UNSIGNED_INT
    sta SCREEN+8*SIZEOF_UNSIGNED_INT+1
    // }
    rts
}
