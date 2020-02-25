// Example of a struct containing an array
.pc = $801 "Basic"
:BasicUpstart(main)
.pc = $80d "Program"
  .label SCREEN = $400
main: {
    // print_person(jesper_id, jesper_initials)
    ldx #0
    lda #<jesper_initials
    sta.z print_person.person_initials
    lda #>jesper_initials
    sta.z print_person.person_initials+1
    jsr print_person
    // print_person(henry_id, henry_initials)
    lda #<henry_initials
    sta.z print_person.person_initials
    lda #>henry_initials
    sta.z print_person.person_initials+1
    jsr print_person
    // }
    rts
}
// print_person(byte* zp(2) person_initials)
print_person: {
    .label person_initials = 2
    ldy #0
  __b1:
    // for(byte i=0; person_initials[i]; i++)
    lda (person_initials),y
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
    // SCREEN[idx++] = person_initials[i]
    lda (person_initials),y
    sta SCREEN,x
    // SCREEN[idx++] = person_initials[i];
    inx
    // for(byte i=0; person_initials[i]; i++)
    iny
    jmp __b1
}
  jesper_initials: .text "jg"
  .byte 0
  .fill $3d, 0
  henry_initials: .text "hg"
  .byte 0
  .fill $3d, 0
