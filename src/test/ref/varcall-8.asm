// Test __varcall calling convention
// Pointer to Struct parameter & return value
  // Commodore 64 PRG executable file
.file [name="varcall-8.prg", type="prg", segments="Program"]
.segmentdef Program [segments="Basic, Code, Data"]
.segmentdef Basic [start=$0801]
.segmentdef Code [start=$80d]
.segmentdef Data [startAfter="Code"]
.segment Basic
:BasicUpstart(main)
  .const SIZEOF_STRUCT_COLS = 2
  .const OFFSET_STRUCT_COLS_BG = 1
  .label COLS = $d020
.segment Code
main: {
    .label a = 6
    .label b = 8
    .label c = $a
    .label m = 2
    // struct Cols a = { 1, 7 }
    ldy #SIZEOF_STRUCT_COLS
  !:
    lda __0-1,y
    sta a-1,y
    dey
    bne !-
    // struct Cols b = { 2, 6 }
    ldy #SIZEOF_STRUCT_COLS
  !:
    lda __1-1,y
    sta b-1,y
    dey
    bne !-
    // struct Cols c = { 3, 5 }
    ldy #SIZEOF_STRUCT_COLS
  !:
    lda __2-1,y
    sta c-1,y
    dey
    bne !-
    // struct Cols *m = min(&a,&b)
    lda #<a
    sta.z min.a
    lda #>a
    sta.z min.a+1
    lda #<b
    sta.z min.b
    lda #>b
    sta.z min.b+1
    jsr min
    // *COLS = *m
    ldx #SIZEOF_STRUCT_COLS
    ldy #0
  !:
    lda (m),y
    sta COLS,y
    iny
    dex
    bne !-
    // min(m,&c)
    lda #<c
    sta.z min.b
    lda #>c
    sta.z min.b+1
    jsr min
    // m = min(m,&c)
    // *COLS = *m
    ldx #SIZEOF_STRUCT_COLS
    ldy #0
  !:
    lda (m),y
    sta COLS,y
    iny
    dex
    bne !-
    // }
    rts
}
// __zp(2) struct Cols * min(__zp(2) struct Cols *a, __zp(4) struct Cols *b)
min: {
    .label a = 2
    .label b = 4
    .label return = 2
    // if(a->bg < b->bg)
    ldy #OFFSET_STRUCT_COLS_BG
    lda (b),y
    cmp (a),y
    bcc __breturn
    // return b;
    lda.z b
    sta.z return
    lda.z b+1
    sta.z return+1
  __breturn:
    // }
    rts
    // return a;
}
.segment Data
  __0: .byte 1, 7
  __1: .byte 2, 6
  __2: .byte 3, 5
