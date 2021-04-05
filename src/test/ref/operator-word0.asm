// Test operator WORD0()
  // Commodore 64 PRG executable file
.file [name="operator-word0.prg", type="prg", segments="Program"]
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
    .label bu = 2
    .label bs = 3
    .label wu = 4
    .label ws = 6
    .label du = 8
    .label ds = $c
    .label ptr = $10
    .label __0 = $12
    .label __1 = $14
    .label __2 = $16
    .label __3 = $18
    .label __4 = $1a
    .label __5 = $1c
    .label __6 = $1e
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
    // SCREEN[i++] = WORD0(17)
    lda #<$11&$ffff
    sta SCREEN
    lda #>$11&$ffff
    sta SCREEN+1
    // SCREEN[i++] = WORD0(377)
    lda #<$179&$ffff
    sta SCREEN+1*SIZEOF_WORD
    lda #>$179&$ffff
    sta SCREEN+1*SIZEOF_WORD+1
    // WORD0(bu)
    lda.z bu
    sta.z __0
    lda #0
    sta.z __0+1
    // SCREEN[i++] = WORD0(bu)
    lda.z __0
    sta SCREEN+2*SIZEOF_WORD
    lda.z __0+1
    sta SCREEN+2*SIZEOF_WORD+1
    // WORD0(bs)
    lda.z bs
    sta.z __1
    ora #$7f
    bmi !+
    lda #0
  !:
    sta.z __1+1
    // SCREEN[i++] = WORD0(bs)
    lda.z __1
    sta SCREEN+3*SIZEOF_WORD
    lda.z __1+1
    sta SCREEN+3*SIZEOF_WORD+1
    // WORD0(wu)
    lda.z wu
    sta.z __2
    lda.z wu+1
    sta.z __2+1
    // SCREEN[i++] = WORD0(wu)
    lda.z __2
    sta SCREEN+4*SIZEOF_WORD
    lda.z __2+1
    sta SCREEN+4*SIZEOF_WORD+1
    // WORD0(ws)
    lda.z ws
    sta.z __3
    lda.z ws+1
    sta.z __3+1
    // SCREEN[i++] = WORD0(ws)
    lda.z __3
    sta SCREEN+5*SIZEOF_WORD
    lda.z __3+1
    sta SCREEN+5*SIZEOF_WORD+1
    // WORD0(du)
    lda.z du
    sta.z __4
    lda.z du+1
    sta.z __4+1
    // SCREEN[i++] = WORD0(du)
    lda.z __4
    sta SCREEN+6*SIZEOF_WORD
    lda.z __4+1
    sta SCREEN+6*SIZEOF_WORD+1
    // WORD0(ds)
    lda.z ds
    sta.z __5
    lda.z ds+1
    sta.z __5+1
    // SCREEN[i++] = WORD0(ds)
    lda.z __5
    sta SCREEN+7*SIZEOF_WORD
    lda.z __5+1
    sta SCREEN+7*SIZEOF_WORD+1
    // WORD0(ptr)
    lda.z ptr
    sta.z __6
    lda.z ptr+1
    sta.z __6+1
    // SCREEN[i++] = WORD0(ptr)
    lda.z __6
    sta SCREEN+8*SIZEOF_WORD
    lda.z __6+1
    sta SCREEN+8*SIZEOF_WORD+1
    // }
    rts
}
