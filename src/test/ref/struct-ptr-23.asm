// Example of a struct containing an array
  // Commodore 64 PRG executable file
.file [name="struct-ptr-23.prg", type="prg", segments="Program"]
.segmentdef Program [segments="Basic, Code, Data"]
.segmentdef Basic [start=$0801]
.segmentdef Code [start=$80d]
.segmentdef Data [startAfter="Code"]
.segment Basic
:BasicUpstart(main)
  .const SIZEOF_STRUCT_PERSON = 5
  .const OFFSET_STRUCT_PERSON_INITIALS = 1
  .label SCREEN = $400
.segment Code
main: {
    .label person = persons+SIZEOF_STRUCT_PERSON
    // print_person(person)
    ldx #0
    lda #<persons
    sta.z print_person.person
    lda #>persons
    sta.z print_person.person+1
    jsr print_person
    // print_person(person)
    lda #<person
    sta.z print_person.person
    lda #>person
    sta.z print_person.person+1
    jsr print_person
    // }
    rts
}
// void print_person(__zp(2) struct Person *person)
print_person: {
    .label __3 = 4
    .label __4 = 2
    .label person = 2
    // '0'+person->id
    lda #'0'
    clc
    ldy #0
    adc (person),y
    // SCREEN[idx++] = '0'+person->id
    sta SCREEN,x
    // SCREEN[idx++] = '0'+person->id;
    inx
    // SCREEN[idx++] = ' '
    lda #' '
    sta SCREEN,x
    // SCREEN[idx++] = ' ';
    inx
    // SCREEN[idx++] = person->initials[0]
    ldy #OFFSET_STRUCT_PERSON_INITIALS
    lda (person),y
    sta SCREEN,x
    // SCREEN[idx++] = person->initials[0];
    inx
    // SCREEN[idx++] = person->initials[1]
    tya
    clc
    adc.z person
    sta.z __3
    lda #0
    adc.z person+1
    sta.z __3+1
    ldy #1
    lda (__3),y
    sta SCREEN,x
    // SCREEN[idx++] = person->initials[1];
    inx
    // SCREEN[idx++] = person->initials[2]
    lda #OFFSET_STRUCT_PERSON_INITIALS
    clc
    adc.z __4
    sta.z __4
    bcc !+
    inc.z __4+1
  !:
    ldy #2
    lda (__4),y
    sta SCREEN,x
    // SCREEN[idx++] = person->initials[2];
    inx
    // SCREEN[idx++] = ' '
    lda #' '
    sta SCREEN,x
    // SCREEN[idx++] = ' ';
    inx
    // }
    rts
}
.segment Data
  persons: .byte 1
  .text "jgr"
  .byte 0, 8
  .text "hbg"
  .byte 0
