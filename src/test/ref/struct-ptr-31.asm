// Example of a struct containing an array
.pc = $801 "Basic"
:BasicUpstart(main)
.pc = $80d "Program"
  .const SIZEOF_STRUCT_PERSON = $11
  .const OFFSET_STRUCT_PERSON_NAME = 1
  .label SCREEN = $400
main: {
    ldx #0
    lda #<persons
    sta.z print_person.person
    lda #>persons
    sta.z print_person.person+1
    jsr print_person
    lda #<persons+1*SIZEOF_STRUCT_PERSON
    sta.z print_person.person
    lda #>persons+1*SIZEOF_STRUCT_PERSON
    sta.z print_person.person+1
    jsr print_person
    rts
}
// print_person(struct Person* zeropage(2) person)
print_person: {
    .label _1 = 4
    .label _2 = 6
    .label person = 2
    ldy #0
    lda (person),y
    tay
    lda DIGIT,y
    sta SCREEN,x
    inx
    lda #' '
    sta SCREEN,x
    inx
    ldy #0
  b1:
    lda #OFFSET_STRUCT_PERSON_NAME
    clc
    adc.z person
    sta.z _1
    lda #0
    adc.z person+1
    sta.z _1+1
    lda (_1),y
    cmp #0
    bne b2
    lda #' '
    sta SCREEN,x
    inx
    rts
  b2:
    lda #OFFSET_STRUCT_PERSON_NAME
    clc
    adc.z person
    sta.z _2
    lda #0
    adc.z person+1
    sta.z _2+1
    lda (_2),y
    sta SCREEN,x
    inx
    iny
    jmp b1
}
  _0: .text "jesper"
  .byte 0
  _1: .text "henriette"
  .byte 0
  persons: .byte 4
  .text "jesper"
  .byte 0
  .fill 9, 0
  .byte 7
  .text "henriette"
  .byte 0
  .fill 6, 0
  DIGIT: .text "0123456789"
  .byte 0
