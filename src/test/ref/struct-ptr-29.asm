// Example of a struct containing a pointer
  // Commodore 64 PRG executable file
.file [name="struct-ptr-29.prg", type="prg", segments="Program"]
.segmentdef Program [segments="Basic, Code, Data"]
.segmentdef Basic [start=$0801]
.segmentdef Code [start=$80d]
.segmentdef Data [startAfter="Code"]
.segment Basic
:BasicUpstart(main)
  .const SIZEOF_STRUCT_PERSON = 3
  .const OFFSET_STRUCT_PERSON_NAME = 1
  .label SCREEN = $400
.segment Code
main: {
    // print_person(&persons[0])
    ldx #0
    lda #<persons
    sta.z print_person.person
    lda #>persons
    sta.z print_person.person+1
    jsr print_person
    // print_person(&persons[1])
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
    .label i = 4
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
    lda #0
    sta.z i
  __b1:
    // for(byte i=0; person->name[i]; i++)
    ldy #OFFSET_STRUCT_PERSON_NAME
    lda (person),y
    sta.z $fe
    iny
    lda (person),y
    sta.z $ff
    ldy.z i
    lda ($fe),y
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
    ldy #OFFSET_STRUCT_PERSON_NAME
    lda (person),y
    sta.z $fe
    iny
    lda (person),y
    sta.z $ff
    ldy.z i
    lda ($fe),y
    sta SCREEN,x
    // SCREEN[idx++] = person->name[i];
    inx
    // for(byte i=0; person->name[i]; i++)
    inc.z i
    jmp __b1
}
.segment Data
  persons: .byte 4
  .word person_name
  .byte 7
  .word person_name1
  DIGIT: .text "0123456789"
  .byte 0
  person_name: .text "jesper"
  .byte 0
  person_name1: .text "repsej"
  .byte 0
