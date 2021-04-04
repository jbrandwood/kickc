// Test operator BYTE2()
  // Commodore 64 PRG executable file
.file [name="operator-byte2.prg", type="prg", segments="Program"]
.segmentdef Program [segments="Basic, Code, Data"]
.segmentdef Basic [start=$0801]
.segmentdef Code [start=$80d]
.segmentdef Data [startAfter="Code"]
.segment Basic
:BasicUpstart(main)
.segment Code
main: {
    .label SCREEN = $400
    .label du = 2
    .label ds = 6
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
    // SCREEN[i++] = BYTE2(17)
    lda #0
    sta SCREEN
    // SCREEN[i++] = BYTE2(377)
    sta SCREEN+1
    // SCREEN[i++] = BYTE2(377777)
    lda #<($5c3b1>>$10)
    sta SCREEN+2
    // SCREEN[i++] = BYTE2(bu)
    lda #0
    sta SCREEN+3
    // SCREEN[i++] = BYTE2(bs)
    sta SCREEN+4
    // SCREEN[i++] = BYTE2(wu)
    sta SCREEN+5
    // SCREEN[i++] = BYTE2(ws)
    sta SCREEN+6
    // BYTE2(du)
    lda.z du+2
    // SCREEN[i++] = BYTE2(du)
    sta SCREEN+7
    // BYTE2(ds)
    lda.z ds+2
    // SCREEN[i++] = BYTE2(ds)
    sta SCREEN+8
    // SCREEN[i++] = BYTE2(ptr)
    lda #0
    sta SCREEN+9
    // }
    rts
}
