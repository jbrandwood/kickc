// Example of a struct containing an array
// Works because the struct is only handled as a value
.pc = $801 "Basic"
:BasicUpstart(main)
.pc = $80d "Program"
  .label SCREEN = $400
  .label idx = 2
main: {
    .const jesper_id = 4
    .const henriette_id = 7
    // jesper = { 4, "jesper" }
    ldy #$40
  !:
    lda __0-1,y
    sta jesper_name-1,y
    dey
    bne !-
    // print_person(jesper)
    lda #<jesper_name
    sta.z print_person.person_name
    lda #>jesper_name
    sta.z print_person.person_name+1
    lda #0
    sta.z idx
    ldx #jesper_id
    jsr print_person
    // henriette = { 7, "henriette" }
    ldy #$40
  !:
    lda __1-1,y
    sta henriette_name-1,y
    dey
    bne !-
    // print_person(henriette)
    lda #<henriette_name
    sta.z print_person.person_name
    lda #>henriette_name
    sta.z print_person.person_name+1
    ldx #henriette_id
    jsr print_person
    // }
    rts
    jesper_name: .fill $40, 0
    henriette_name: .fill $40, 0
}
// print_person(byte register(X) person_id, byte* zp(3) person_name)
print_person: {
    .label person_name = 3
    // SCREEN[idx++] = DIGIT[person.id]
    lda DIGIT,x
    ldy.z idx
    sta SCREEN,y
    // SCREEN[idx++] = DIGIT[person.id];
    ldx.z idx
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
    inx
    stx.z idx
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
  __0: .text "jesper"
  .byte 0
  .fill $39, 0
  __1: .text "henriette"
  .byte 0
  .fill $36, 0
