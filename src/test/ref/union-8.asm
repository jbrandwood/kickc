// Minimal union with C-Standard behavior - union return value
  // Commodore 64 PRG executable file
.file [name="union-8.prg", type="prg", segments="Program"]
.segmentdef Program [segments="Basic, Code, Data"]
.segmentdef Basic [start=$0801]
.segmentdef Code [start=$80d]
.segmentdef Data [startAfter="Code"]
.segment Basic
:BasicUpstart(main)
  .const SIZEOF_UNION_DATA = 2
  .label SCREEN = $400
.segment Code
main: {
    .label d1 = 4
    .label d2 = 6
    // union Data d1 = data(0x1234)
    lda #<$1234
    sta.z data.i
    lda #>$1234
    sta.z data.i+1
    jsr data
    // union Data d1 = data(0x1234)
    ldy #SIZEOF_UNION_DATA
  !:
    lda data.return-1,y
    sta d1-1,y
    dey
    bne !-
    // SCREEN[idx++] = d1.b
    lda.z d1
    sta SCREEN
    // union Data d2 = data(0x5678)
    lda #<$5678
    sta.z data.i
    lda #>$5678
    sta.z data.i+1
    jsr data
    // union Data d2 = data(0x5678)
    ldy #SIZEOF_UNION_DATA
  !:
    lda data.return-1,y
    sta d2-1,y
    dey
    bne !-
    // SCREEN[idx++] = d2.b
    lda.z d2
    sta SCREEN+1
    // }
    rts
}
// __zp(8) union Data data(__zp(2) unsigned int i)
data: {
    .label return = 8
    .label i = 2
    // return { i };
    lda.z i
    sta.z return
    lda.z i+1
    sta.z return+1
    // }
    rts
}
