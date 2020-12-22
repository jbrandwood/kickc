// Example of a struct containing an array
  // Commodore 64 PRG executable file
.file [name="struct-ptr-32.prg", type="prg", segments="Program"]
.segmentdef Program [segments="Basic, Code, Data"]
.segmentdef Basic [start=$0801]
.segmentdef Code [start=$80d]
.segmentdef Data [startAfter="Code"]
.segment Basic
:BasicUpstart(main)
  .const SIZEOF_STRUCT_PERSON = $10
  .const OFFSET_STRUCT_PERSON_NAME = 1
  .const OFFSET_STRUCT_PERSON_AGE = $e
.segment Code
main: {
    .label SCREEN = $400
    .label person = persons+SIZEOF_STRUCT_PERSON
    // persons[0].id = 7
    lda #7
    sta persons
    // persons[1].id = 9
    lda #9
    sta persons+1*SIZEOF_STRUCT_PERSON
    // persons[0].name[8] = 'a'
    lda #'a'
    sta persons+OFFSET_STRUCT_PERSON_NAME+8
    // persons[1].name[8] = 'b'
    lda #'b'
    sta persons+OFFSET_STRUCT_PERSON_NAME+1*SIZEOF_STRUCT_PERSON+8
    // persons[0].age = 321
    lda #<$141
    sta persons+OFFSET_STRUCT_PERSON_AGE
    lda #>$141
    sta persons+OFFSET_STRUCT_PERSON_AGE+1
    // persons[1].age = 123
    lda #0
    sta persons+1*SIZEOF_STRUCT_PERSON+OFFSET_STRUCT_PERSON_AGE+1
    lda #<$7b
    sta persons+1*SIZEOF_STRUCT_PERSON+OFFSET_STRUCT_PERSON_AGE
    // SCREEN[0] = person->name[8]
    lda persons+OFFSET_STRUCT_PERSON_NAME+8
    sta SCREEN
    // SCREEN[1] = person->name[8]
    lda person+OFFSET_STRUCT_PERSON_NAME+8
    sta SCREEN+1
    // }
    rts
}
.segment Data
  persons: .fill $10*2, 0
