// Tests that variables overflow to main memory when zeropage is exhausted
  // Commodore 64 PRG executable file
.file [name="zeropage-overflow.prg", type="prg", segments="Program"]
.segmentdef Program [segments="Basic, Code, Data"]
.segmentdef Basic [start=$0801]
.segmentdef Code [start=$80d]
.segmentdef Data [startAfter="Code"]
.segment Basic
:BasicUpstart(main)
.segment Code
// And then allocate a bunch of variables
main: {
    .label SCREEN = $400
    .label b = $fd
    .label a_1 = $fb
    lda #<0
    sta h
    sta h+1
    sta g
    sta g+1
    sta f
    sta f+1
    sta e
    sta e+1
    sta d
    sta d+1
    sta c
    sta c+1
    sta.z b
    sta.z b+1
    sta.z a_1
    sta.z a_1+1
    tay
  __b1:
    // for(char i=0;i<10;i++)
    cpy #$a
    bcc __b2
    // }
    rts
  __b2:
    // SCREEN[i] = a++
    tya
    asl
    tax
    lda.z a_1
    sta SCREEN,x
    lda.z a_1+1
    sta SCREEN+1,x
    // SCREEN[i] = a++;
    clc
    lda.z a_1
    adc #1
    sta a
    lda.z a_1+1
    adc #0
    sta a+1
    // SCREEN[i] = b++
    lda.z b
    sta SCREEN,x
    lda.z b+1
    sta SCREEN+1,x
    // SCREEN[i] = b++;
    inc.z b
    bne !+
    inc.z b+1
  !:
    // SCREEN[i] = c++
    lda c
    sta SCREEN,x
    lda c+1
    sta SCREEN+1,x
    // SCREEN[i] = c++;
    inc c
    bne !+
    inc c+1
  !:
    // SCREEN[i] = d++
    lda d
    sta SCREEN,x
    lda d+1
    sta SCREEN+1,x
    // SCREEN[i] = d++;
    inc d
    bne !+
    inc d+1
  !:
    // SCREEN[i] = a++
    lda a
    sta SCREEN,x
    lda a+1
    sta SCREEN+1,x
    // SCREEN[i] = a++;
    inc a
    bne !+
    inc a+1
  !:
    // SCREEN[i] = e++
    lda e
    sta SCREEN,x
    lda e+1
    sta SCREEN+1,x
    // SCREEN[i] = e++;
    inc e
    bne !+
    inc e+1
  !:
    // SCREEN[i] = f++
    lda f
    sta SCREEN,x
    lda f+1
    sta SCREEN+1,x
    // SCREEN[i] = f++;
    inc f
    bne !+
    inc f+1
  !:
    // SCREEN[i] = g++
    lda g
    sta SCREEN,x
    lda g+1
    sta SCREEN+1,x
    // SCREEN[i] = g++;
    inc g
    bne !+
    inc g+1
  !:
    // SCREEN[i] = h++
    lda h
    sta SCREEN,x
    lda h+1
    sta SCREEN+1,x
    // SCREEN[i] = h++;
    inc h
    bne !+
    inc h+1
  !:
    // SCREEN[i] = a++
    lda a
    sta SCREEN,x
    lda a+1
    sta SCREEN+1,x
    // SCREEN[i] = a++;
    clc
    lda a
    adc #1
    sta.z a_1
    lda a+1
    adc #0
    sta.z a_1+1
    // for(char i=0;i<10;i++)
    iny
    jmp __b1
  .segment Data
    a: .word 0
    c: .word 0
    d: .word 0
    e: .word 0
    f: .word 0
    g: .word 0
    h: .word 0
}
