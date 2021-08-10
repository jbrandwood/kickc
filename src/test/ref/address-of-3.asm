// Test address-of an array element
  // Commodore 64 PRG executable file
.file [name="address-of-3.prg", type="prg", segments="Program"]
.segmentdef Program [segments="Basic, Code, Data"]
.segmentdef Basic [start=$0801]
.segmentdef Code [start=$80d]
.segmentdef Data [startAfter="Code"]
.segment Basic
:BasicUpstart(main)
  .const SIZEOF_INT = 2
  .label SCREEN = $400
  .label idx = 3
.segment Code
main: {
    .label i = 2
    // print(VALS)
    lda #<VALS
    sta.z print.p
    lda #>VALS
    sta.z print.p+1
    lda #0
    sta.z idx
    jsr print
    // print(&VALS[1])
    lda #<VALS+1*SIZEOF_INT
    sta.z print.p
    lda #>VALS+1*SIZEOF_INT
    sta.z print.p+1
    jsr print
    lda #2
    sta.z i
  __b1:
    // &VALS[i]
    lda.z i
    asl
    // print(&VALS[i])
    clc
    adc #<VALS
    sta.z print.p
    lda #>VALS
    adc #0
    sta.z print.p+1
    jsr print
    // for(char i:2..3)
    inc.z i
    lda #4
    cmp.z i
    bne __b1
    // }
    rts
}
// void print(__zp(4) int *p)
print: {
    .label p = 4
    // SCREEN[idx++] = *p
    lda.z idx
    asl
    tax
    ldy #0
    lda (p),y
    sta SCREEN,x
    iny
    lda (p),y
    sta SCREEN+1,x
    // SCREEN[idx++] = *p;
    inc.z idx
    // }
    rts
}
.segment Data
  VALS: .word 1, 2, 3, 4
