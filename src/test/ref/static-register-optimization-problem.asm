// https://gitlab.com/camelot/kickc/issues/336
// ASM Static Register Value analysis erronously believes >-1 == 0
  // Commodore 64 PRG executable file
.file [name="static-register-optimization-problem.prg", type="prg", segments="Program"]
.segmentdef Program [segments="Basic, Code, Data"]
.segmentdef Basic [start=$0801]
.segmentdef Code [start=$80d]
.segmentdef Data [startAfter="Code"]
.segment Basic
:BasicUpstart(main)
.segment Code
main: {
    .label screen = $400
    .label lasti = 4
    .label i = 2
    .label __1 = 6
    lda #<-1
    sta.z lasti
    sta.z lasti+1
    lda #<0
    sta.z i
    sta.z i+1
  __b1:
    // for(int i=0;i<10;i++)
    lda.z i+1
    bmi __b2
    cmp #>$a
    bcc __b2
    bne !+
    lda.z i
    cmp #<$a
    bcc __b2
  !:
    // }
    rts
  __b2:
    // screen[i] = (char)lasti
    lda #<screen
    clc
    adc.z i
    sta.z __1
    lda #>screen
    adc.z i+1
    sta.z __1+1
    lda.z lasti
    ldy #0
    sta (__1),y
    // lasti = i
    lda.z i
    sta.z lasti
    lda.z i+1
    sta.z lasti+1
    // for(int i=0;i<10;i++)
    inc.z i
    bne !+
    inc.z i+1
  !:
    jmp __b1
}
