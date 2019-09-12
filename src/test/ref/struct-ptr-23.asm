// Example of a struct containing an array
.pc = $801 "Basic"
:BasicUpstart(main)
.pc = $80d "Program"
  .const SIZEOF_STRUCT_PERSON = 5
  .const OFFSET_STRUCT_PERSON_INITIALS = 1
  .label SCREEN = $400
main: {
    .label person = persons+SIZEOF_STRUCT_PERSON
    ldx #0
    lda #<persons
    sta.z print_person.person
    lda #>persons
    sta.z print_person.person+1
    jsr print_person
    lda #<person
    sta.z print_person.person
    lda #>person
    sta.z print_person.person+1
    jsr print_person
    rts
}
// print_person(struct Person* zeropage(2) person)
print_person: {
    .label _3 = 4
    .label _4 = 2
    .label person = 2
    lda #'0'
    clc
    ldy #0
    adc (person),y
    sta SCREEN,x
    inx
    lda #' '
    sta SCREEN,x
    inx
    ldy #OFFSET_STRUCT_PERSON_INITIALS
    lda (person),y
    sta SCREEN,x
    inx
    tya
    clc
    adc.z person
    sta.z _3
    lda #0
    adc.z person+1
    sta.z _3+1
    ldy #1
    lda (_3),y
    sta SCREEN,x
    inx
    lda #OFFSET_STRUCT_PERSON_INITIALS
    clc
    adc.z _4
    sta.z _4
    bcc !+
    inc.z _4+1
  !:
    ldy #2
    lda (_4),y
    sta SCREEN,x
    inx
    lda #' '
    sta SCREEN,x
    inx
    rts
}
  _0: .text "jgr"
  .byte 0
  _1: .text "hbg"
  .byte 0
  persons: .byte 1
  .text "jgr"
  .byte 0, 8
  .text "hbg"
  .byte 0
