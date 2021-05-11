// Test operator BYTE0()
  // Commodore 64 PRG executable file
.file [name="operator-byte0.prg", type="prg", segments="Program"]
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
    // volatile unsigned char bu = 7
    lda #7
    sta.z bu
    // volatile signed char bs = 7
    sta.z bs
    // volatile unsigned int wu = 20000
    lda #<$4e20
    sta.z wu
    lda #>$4e20
    sta.z wu+1
    // volatile signed int ws = -177
    lda #<-$b1
    sta.z ws
    lda #>-$b1
    sta.z ws+1
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
    // char * volatile ptr = (char*)0x0000
    lda #<0
    sta.z ptr
    sta.z ptr+1
    // SCREEN[i++] = BYTE0(17)
    lda #<($11)
    sta SCREEN
    // SCREEN[i++] = BYTE0(377)
    lda #<($179)
    sta SCREEN+1
    // BYTE0(bu)
    lda.z bu
    // SCREEN[i++] = BYTE0(bu)
    sta SCREEN+2
    // BYTE0(bs)
    lda.z bs
    // SCREEN[i++] = BYTE0(bs)
    sta SCREEN+3
    // BYTE0(wu)
    lda.z wu
    // SCREEN[i++] = BYTE0(wu)
    sta SCREEN+4
    // BYTE0(ws)
    lda.z ws
    // SCREEN[i++] = BYTE0(ws)
    sta SCREEN+5
    // BYTE0(du)
    lda.z du
    // SCREEN[i++] = BYTE0(du)
    sta SCREEN+6
    // BYTE0(ds)
    lda.z ds
    // SCREEN[i++] = BYTE0(ds)
    sta SCREEN+7
    // BYTE0(ptr)
    lda.z ptr
    // SCREEN[i++] = BYTE0(ptr)
    sta SCREEN+8
    // }
    rts
}
