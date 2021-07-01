// Test auto-casting of call-parameters
  // Commodore 64 PRG executable file
.file [name="call-parameter-autocast.prg", type="prg", segments="Program"]
.segmentdef Program [segments="Basic, Code, Data"]
.segmentdef Basic [start=$0801]
.segmentdef Code [start=$80d]
.segmentdef Data [startAfter="Code"]
.segment Basic
:BasicUpstart(main)
  .label SCREEN = $400
.segment Code
main: {
    .const w = $1234
    // print(0x1234)
    lda #<$1234
    sta.z print.w
    lda #>$1234
    sta.z print.w+1
    ldx #0
    jsr print
    // print(w)
    lda #<w
    sta.z print.w
    lda #>w
    sta.z print.w+1
    jsr print
    // print( MAKEWORD(0x12,0x34) )
    lda #<$12*$100+$34
    sta.z print.w
    lda #>$12*$100+$34
    sta.z print.w+1
    jsr print
    // }
    rts
}
// print(word zp(2) w)
print: {
    .label w = 2
    // SCREEN[idx++] = w
    txa
    asl
    tay
    lda.z w
    sta SCREEN,y
    lda.z w+1
    sta SCREEN+1,y
    // SCREEN[idx++] = w;
    inx
    // }
    rts
}
