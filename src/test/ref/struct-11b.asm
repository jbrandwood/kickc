// Example of a struct containing an array
  // Commodore 64 PRG executable file
.file [name="struct-11b.prg", type="prg", segments="Program"]
.segmentdef Program [segments="Basic, Code, Data"]
.segmentdef Basic [start=$0801]
.segmentdef Code [start=$80d]
.segmentdef Data [startAfter="Code"]
.segment Basic
:BasicUpstart(main)
  .label SCREEN = $400
.segment Code
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
// void print_person(unsigned long person_id, __zp(2) char *person_initials)
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
.segment Data
  jesper_initials: .text "jg"
  .byte 0
  .fill $3d, 0
  henry_initials: .text "hg"
  .byte 0
  .fill $3d, 0
