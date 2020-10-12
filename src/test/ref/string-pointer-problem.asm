// Test adding integer index to a pointer that is a literal string
// https://gitlab.com/camelot/kickc/issues/315
.pc = $801 "Basic"
:BasicUpstart(main)
.pc = $80d "Program"
  .label process_name = $400
main: {
    // set_process_name("keyboard")
    jsr set_process_name
    // }
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
    // for(signed int j = 0; j < 17; j++)
    lda.z j+1
    bmi __b2
    cmp #>$11
    bcc __b2
    bne !+
    lda.z j
    cmp #<$11
    bcc __b2
  !:
    // }
    rts
  __b2:
    // process_name[j]=name[j]
    clc
    lda.z j
    adc #<main.name
    sta.z __1
    lda.z j+1
    adc #>main.name
    sta.z __1+1
    clc
    lda.z j
    adc #<process_name
    sta.z __2
    lda.z j+1
    adc #>process_name
    sta.z __2+1
    ldy #0
    lda (__1),y
    sta (__2),y
    // for(signed int j = 0; j < 17; j++)
    inc.z j
    bne !+
    inc.z j+1
  !:
    jmp __b1
}
