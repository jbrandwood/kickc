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
    .label _1 = 4
    .label _2 = 6
    lda #<0
    sta.z j
    sta.z j+1
  b1:
    lda.z j+1
    bmi b2
    cmp #>$11
    bcc b2
    bne !+
    lda.z j
    cmp #<$11
    bcc b2
  !:
    rts
  b2:
    lda #<main.name
    clc
    adc.z j
    sta.z _1
    lda #>main.name
    adc.z j+1
    sta.z _1+1
    lda #<process_name
    clc
    adc.z j
    sta.z _2
    lda #>process_name
    adc.z j+1
    sta.z _2+1
    ldy #0
    lda (_1),y
    sta (_2),y
    inc.z j
    bne !+
    inc.z j+1
  !:
    jmp b1
}
