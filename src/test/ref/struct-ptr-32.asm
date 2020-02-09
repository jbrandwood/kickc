// Example of a struct containing an array
.pc = $801 "Basic"
:BasicUpstart(main)
.pc = $80d "Program"
  .const SIZEOF_STRUCT_PERSON = $10
  .const OFFSET_STRUCT_PERSON_NAME = 1
  .const OFFSET_STRUCT_PERSON_AGE = $e
main: {
    .label SCREEN = $400
    .label person = persons+SIZEOF_STRUCT_PERSON
    lda #7
    sta persons
    lda #9
    sta persons+1*SIZEOF_STRUCT_PERSON
    lda #'a'
    sta persons+OFFSET_STRUCT_PERSON_NAME+8
    lda #'b'
    sta persons+OFFSET_STRUCT_PERSON_NAME+1*SIZEOF_STRUCT_PERSON+8
    lda #<$141
    sta persons+OFFSET_STRUCT_PERSON_AGE
    lda #>$141
    sta persons+OFFSET_STRUCT_PERSON_AGE+1
    lda #0
    sta persons+OFFSET_STRUCT_PERSON_AGE+1*SIZEOF_STRUCT_PERSON+1
    lda #<$7b
    sta persons+OFFSET_STRUCT_PERSON_AGE+1*SIZEOF_STRUCT_PERSON
    lda persons+OFFSET_STRUCT_PERSON_NAME+8
    sta SCREEN
    lda person+OFFSET_STRUCT_PERSON_NAME+8
    sta SCREEN+1
    rts
}
  persons: .fill $10*2, 0
