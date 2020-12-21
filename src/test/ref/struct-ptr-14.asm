// Minimal struct -  using address-of and passing it to a function
  // Commodore 64 PRG executable file
.file [name="struct-ptr-14.prg", type="prg", segments="Program"]
.segmentdef Program [segments="Basic, Code, Data"]
.segmentdef Basic [start=$0801]
.segmentdef Code [start=$80d]
.segmentdef Data [startAfter="Code"]
.segment Basic
:BasicUpstart(main)
  .const SIZEOF_STRUCT_POINT = 2
  .const OFFSET_STRUCT_POINT_Y = 1
.segment Code
main: {
    .label SCREEN = $400
    .label q = p
    .label p = 2
    // p = { 2, 3 }
    ldy #SIZEOF_STRUCT_POINT
  !:
    lda __0-1,y
    sta p-1,y
    dey
    bne !-
    // set(q)
    jsr set
    // SCREEN[0] = q->x
    lda.z q
    sta SCREEN
    // SCREEN[1] = q->y
    lda q+OFFSET_STRUCT_POINT_Y
    sta SCREEN+1
    // }
    rts
}
set: {
    // ptr->x = 4
    lda #4
    sta.z main.q
    // ptr->y = 5
    lda #5
    sta main.q+OFFSET_STRUCT_POINT_Y
    // }
    rts
}
.segment Data
  __0: .byte 2, 3
