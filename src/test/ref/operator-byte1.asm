// Test operator BYTE0()
  // Commodore 64 PRG executable file
.file [name="operator-byte1.prg", type="prg", segments="Program"]
.segmentdef Program [segments="Basic, Code, Data"]
.segmentdef Basic [start=$0801]
.segmentdef Code [start=$80d]
.segmentdef Data [startAfter="Code"]
.segment Basic
:BasicUpstart(main)
.segment Code
main: {
    .label SCREEN = $400
    .label bu = 2
    .label bs = 3
    .label wu = 4
    .label ws = 6
    .label du = 8
    .label ds = $c
    .label ptr = $10
    // bu = 7
    lda #7
    sta.z bu
    // bs = 7
    sta.z bs
    // wu = 20000
    lda #<$4e20
    sta.z wu
    lda #>$4e20
    sta.z wu+1
    // ws = -177
    lda #<-$b1
    sta.z ws
    lda #>-$b1
    sta.z ws+1
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
    // ptr = 0x0000
    lda #<0
    sta.z ptr
    sta.z ptr+1
    // SCREEN[i++] = BYTE1(17)
    sta SCREEN
    // SCREEN[i++] = BYTE1(377)
    lda #>($179)
    sta SCREEN+1
    // BYTE1(bu)
    lda #0
    // SCREEN[i++] = BYTE1(bu)
    sta SCREEN+2
    // BYTE1(bs)
    // SCREEN[i++] = BYTE1(bs)
    sta SCREEN+3
    // BYTE1(wu)
    lda.z wu+1
    // SCREEN[i++] = BYTE1(wu)
    sta SCREEN+4
    // BYTE1(ws)
    lda.z ws+1
    // SCREEN[i++] = BYTE1(ws)
    sta SCREEN+5
    // BYTE1(du)
    lda.z du+1
    // SCREEN[i++] = BYTE1(du)
    sta SCREEN+6
    // BYTE1(ds)
    lda.z ds+1
    // SCREEN[i++] = BYTE1(ds)
    sta SCREEN+7
    // BYTE1(ptr)
    lda.z ptr+1
    // SCREEN[i++] = BYTE1(ptr)
    sta SCREEN+8
    // }
    rts
}
