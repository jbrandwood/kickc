// Example of a struct containing an array
.pc = $801 "Basic"
:BasicUpstart(main)
.pc = $80d "Program"
  .label SCREEN = $400
  .const SIZEOF_STRUCT_PERSON = $11
  .const OFFSET_STRUCT_PERSON_NAME = 1
main: {
    // print_person(persons)
    ldx #0
    lda #<persons
    sta.z print_person.person
    lda #>persons
    sta.z print_person.person+1
    jsr print_person
    // print_person(persons+1)
    lda #<persons+1*SIZEOF_STRUCT_PERSON
    sta.z print_person.person
    lda #>persons+1*SIZEOF_STRUCT_PERSON
    sta.z print_person.person+1
    jsr print_person
    // }
    rts
}
// print_person(struct Person* zp(2) person)
print_person: {
    .label __1 = 4
    .label __2 = 6
    .label person = 2
    // SCREEN[idx++] = DIGIT[person->id]
    ldy #0
    lda (person),y
    tay
    lda DIGIT,y
    sta SCREEN,x
    // SCREEN[idx++] = DIGIT[person->id];
    inx
    // SCREEN[idx++] = ' '
    lda #' '
    sta SCREEN,x
    // SCREEN[idx++] = ' ';
    inx
    ldy #0
  __b1:
    // for(byte i=0; person->name[i]; i++)
    lda #OFFSET_STRUCT_PERSON_NAME
    clc
    adc.z person
    sta.z __1
    lda #0
    adc.z person+1
    sta.z __1+1
    lda (__1),y
    cmp #0
    bne __b2
    // SCREEN[idx++] = ' '
    lda #' '
    sta SCREEN,x
    // SCREEN[idx++] = ' ';
    inx
    // }
    rts
  __b2:
    // SCREEN[idx++] = person->name[i]
    lda #OFFSET_STRUCT_PERSON_NAME
    clc
    adc.z person
    sta.z __2
    lda #0
    adc.z person+1
    sta.z __2+1
    lda (__2),y
    sta SCREEN,x
    // SCREEN[idx++] = person->name[i];
    inx
    // for(byte i=0; person->name[i]; i++)
    iny
    jmp __b1
}
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
