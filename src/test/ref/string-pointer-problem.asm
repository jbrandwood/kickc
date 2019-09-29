// Test adding integer index to a pointer that is a literal string
// https://gitlab.com/camelot/kickc/issues/315
.pc = $801 "Basic"
:BasicUpstart(main)
.pc = $80d "Program"
  .label process_name = $400
main: {
    jsr set_process_name
    rts
    name: .text "keyboard"
    .byte 0
}
set_process_name: {
    .label j = 2
    .label __1 = 4
    .label __2 = 6
    lda #<0
    sta.z j
    sta.z j+1
  __b1:
    lda.z j+1
    bmi __b2
    cmp #>$11
    bcc __b2
    bne !+
    lda.z j
    cmp #<$11
    bcc __b2
  !:
    rts
  __b2:
    lda #<main.name
    clc
    adc.z j
    sta.z __1
    lda #>main.name
    adc.z j+1
    sta.z __1+1
    lda #<process_name
    clc
    adc.z j
    sta.z __2
    lda #>process_name
    adc.z j+1
    sta.z __2+1
    ldy #0
    lda (__1),y
    sta (__2),y
    inc.z j
    bne !+
    inc.z j+1
  !:
    jmp __b1
}
