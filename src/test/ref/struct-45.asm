// https://gitlab.com/camelot/kickc/-/issues/590
  // Commodore 64 PRG executable file
.file [name="struct-45.prg", type="prg", segments="Program"]
.segmentdef Program [segments="Basic, Code, Data"]
.segmentdef Basic [start=$0801]
.segmentdef Code [start=$80d]
.segmentdef Data [startAfter="Code"]
.segment Basic
:BasicUpstart(main)
  .const SIZEOF_STRUCT_DEVICESLOT = $42
  .const SIZEOF_STRUCT_DEVICESLOTSA = $84
  .const OFFSET_STRUCT_DEVICESLOT_MODE = 1
  .label OUT = $8000
.segment Code
main: {
    .label slotsA = ssA
    // deviceslot_t s1 = {'A', 'R', "f1"}
    ldy #SIZEOF_STRUCT_DEVICESLOT
  !:
    lda __0-1,y
    sta s1-1,y
    dey
    bne !-
    // deviceslot_t s2 = {'B', 'W', "f2"}
    ldy #SIZEOF_STRUCT_DEVICESLOT
  !:
    lda __1-1,y
    sta s2-1,y
    dey
    bne !-
    // DeviceSlotsA ssA
    ldy #SIZEOF_STRUCT_DEVICESLOTSA
    lda #0
  !:
    dey
    sta ssA,y
    bne !-
    // slotsA->slot[0] = s1
    ldy #SIZEOF_STRUCT_DEVICESLOT
  !:
    lda s1-1,y
    sta slotsA-1,y
    dey
    bne !-
    // slotsA->slot[1] = s2
    ldy #SIZEOF_STRUCT_DEVICESLOT
  !:
    lda s2-1,y
    sta slotsA+1*SIZEOF_STRUCT_DEVICESLOT-1,y
    dey
    bne !-
    lda #0
    sta i
  __b1:
    // deviceslot_t ds = slotsA->slot[i]
    lda i
    asl
    asl
    asl
    asl
    asl
    clc
    adc i
    asl
    tax
    ldy #0
  !:
    lda slotsA,x
    sta ds,y
    inx
    iny
    cpy #SIZEOF_STRUCT_DEVICESLOT
    bne !-
    // *(OUT + i) = ds.mode
    lda ds+OFFSET_STRUCT_DEVICESLOT_MODE
    ldy i
    sta OUT,y
    // for(char i: 0..1)
    inc i
    lda #2
    cmp i
    bne __b1
    // }
    rts
  .segment Data
    s1: .fill SIZEOF_STRUCT_DEVICESLOT, 0
    s2: .fill SIZEOF_STRUCT_DEVICESLOT, 0
    ssA: .fill SIZEOF_STRUCT_DEVICESLOTSA, 0
    ds: .fill SIZEOF_STRUCT_DEVICESLOT, 0
    i: .byte 0
}
  __0: .byte 'A', 'R'
  .text "f1"
  .byte 0
  .fill $3d, 0
  __1: .byte 'B', 'W'
  .text "f2"
  .byte 0
  .fill $3d, 0
