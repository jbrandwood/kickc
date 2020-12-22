// Tests optimizing derefs of *(ptr+b) to ptr[b]
  // Commodore 64 PRG executable file
.file [name="deref-to-derefidx.prg", type="prg", segments="Program"]
.segmentdef Program [segments="Basic, Code, Data"]
.segmentdef Basic [start=$0801]
.segmentdef Code [start=$80d]
.segmentdef Data [startAfter="Code"]
.segment Basic
:BasicUpstart(main)
  .label SCREEN = $400
.segment Code
main: {
    // print(msg1)
    ldx #0
    lda #<msg1
    sta.z print.m
    lda #>msg1
    sta.z print.m+1
    jsr print
    // print(msg2)
    lda #<msg2
    sta.z print.m
    lda #>msg2
    sta.z print.m+1
    jsr print
    // }
    rts
}
// print(byte* zp(2) m)
print: {
    .label m = 2
    // SCREEN[idx++] = *(m+2)
    ldy #2
    lda (m),y
    sta SCREEN,x
    // SCREEN[idx++] = *(m+2);
    inx
    // }
    rts
}
.segment Data
  msg1: .byte 'a', 'b', 'c', 'd'
  msg2: .byte '1', '2', '3', '4'
