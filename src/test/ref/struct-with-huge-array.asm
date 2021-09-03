  // Commodore 64 PRG executable file
.file [name="struct-with-huge-array.prg", type="prg", segments="Program"]
.segmentdef Program [segments="Basic, Code, Data"]
.segmentdef Basic [start=$0801]
.segmentdef Code [start=$80d]
.segmentdef Data [startAfter="Code"]
.segment Basic
:BasicUpstart(main)
  .const SIZEOF_STRUCT___0 = $11a
  .label SCREEN = $400
.segment Code
main: {
    .label i = 2
    .label __2 = 4
    .label __3 = 6
    // bug b
    lda #<b
    sta.z $fe
    lda #>b
    sta.z $ff
    lda #0
    tay
    tax
  !n:
    sta ($fe),y
    iny
    cpy #$ff
    bne !+
    inc.z $ff
    inx
  !:
    cpy #<$11a
    bne !n-
    cpx #>$11a
    bne !n-
    lda #<0
    sta.z i
    sta.z i+1
  __b1:
    // for(unsigned int i=0;i<sizeof b;i++)
    lda.z i+1
    cmp #>$11a
    bcc __b2
    bne !+
    lda.z i
    cmp #<$11a
    bcc __b2
  !:
    // }
    rts
  __b2:
    // SCREEN[i] = b.header[i]
    lda.z i
    clc
    adc #<b
    sta.z __2
    lda.z i+1
    adc #>b
    sta.z __2+1
    lda.z i
    clc
    adc #<SCREEN
    sta.z __3
    lda.z i+1
    adc #>SCREEN
    sta.z __3+1
    ldy #0
    lda (__2),y
    sta (__3),y
    // for(unsigned int i=0;i<sizeof b;i++)
    inc.z i
    bne !+
    inc.z i+1
  !:
    jmp __b1
  .segment Data
    b: .fill SIZEOF_STRUCT___0, 0
}
