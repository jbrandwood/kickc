// Test adding integer index to a pointer that is a literal string
// https://gitlab.com/camelot/kickc/issues/315
  // Commodore 64 PRG executable file
.file [name="string-pointer-problem.prg", type="prg", segments="Program"]
.segmentdef Program [segments="Basic, Code, Data"]
.segmentdef Basic [start=$0801]
.segmentdef Code [start=$80d]
.segmentdef Data [startAfter="Code"]
.segment Basic
:BasicUpstart(main)
  .label process_name = $400
.segment Code
main: {
    // set_process_name("keyboard")
    jsr set_process_name
    // }
    rts
  .segment Data
    name: .text "keyboard"
    .byte 0
}
.segment Code
// void set_process_name(char *name)
set_process_name: {
    .label j = 2
    .label __1 = 6
    .label __2 = 4
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
    // for(signed int j = 0; j < 17; j++)
    inc.z j
    bne !+
    inc.z j+1
  !:
    jmp __b1
}
