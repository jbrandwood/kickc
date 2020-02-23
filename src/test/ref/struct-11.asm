// Example of a struct containing an array
.pc = $801 "Basic"
:BasicUpstart(main)
.pc = $80d "Program"
  .label SCREEN = $400
  .const OFFSET_STRUCT_PERSON_NAME = 1
main: {
    // print_person(jesper)
    ldx jesper
    lda #<jesper+OFFSET_STRUCT_PERSON_NAME
    sta.z print_person.person_name
    lda #>jesper+OFFSET_STRUCT_PERSON_NAME
    sta.z print_person.person_name+1
    ldy #0
    jsr print_person
    // print_person(henriette)
    ldx henriette
    lda #<henriette+OFFSET_STRUCT_PERSON_NAME
    sta.z print_person.person_name
    lda #>henriette+OFFSET_STRUCT_PERSON_NAME
    sta.z print_person.person_name+1
    jsr print_person
    // }
    rts
}
// print_person(byte register(X) person_id, byte* zp(2) person_name)
print_person: {
    .label person_name = 2
    // SCREEN[idx++] = DIGIT[person.id]
    lda DIGIT,x
    sta SCREEN,y
    // SCREEN[idx++] = DIGIT[person.id];
    tya
    tax
    inx
    // SCREEN[idx++] = ' '
    lda #' '
    sta SCREEN,x
    // SCREEN[idx++] = ' ';
    inx
    ldy #0
  __b1:
    // for(byte i=0; person.name[i]; i++)
    lda (person_name),y
    cmp #0
    bne __b2
    // SCREEN[idx++] = ' '
    lda #' '
    sta SCREEN,x
    // SCREEN[idx++] = ' ';
    txa
    tay
    iny
    // }
    rts
  __b2:
    // SCREEN[idx++] = person.name[i]
    lda (person_name),y
    sta SCREEN,x
    // SCREEN[idx++] = person.name[i];
    inx
    // for(byte i=0; person.name[i]; i++)
    iny
    jmp __b1
}
  DIGIT: .text "0123456789"
  .byte 0
  jesper: .byte 4
  .text "jesper"
  .byte 0
  .fill $39, 0
  henriette: .byte 7
  .text "henriette"
  .byte 0
  .fill $36, 0
