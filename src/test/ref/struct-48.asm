// https://gitlab.com/camelot/kickc/-/issues/590
// This version with +256 bytes struct
  // Commodore 64 PRG executable file
.file [name="struct-48.prg", type="prg", segments="Program"]
.segmentdef Program [segments="Basic, Code, Data"]
.segmentdef Basic [start=$0801]
.segmentdef Code [start=$80d]
.segmentdef Data [startAfter="Code"]
.segment Basic
:BasicUpstart(main)
  .const SIZEOF_STRUCT_DEVICESLOT = $102
  .const SIZEOF_STRUCT_DEVICESLOTSA = $204
  .const OFFSET_STRUCT_DEVICESLOT_MODE = 1
  .label OUT = $8000
.segment Code
main: {
    .label slotsA = ssA
    .label __0 = 6
    .label __4 = 2
    .label i = 4
    .label __13 = 2
    .label __14 = 2
    .label __15 = 2
    // deviceslot_t s1 = {'A', 'R', "f1"}
    lda #<@__0
    sta.z $fc
    lda #>@__0
    sta.z $fd
    lda #<s1
    sta.z $fe
    lda #>s1
    sta.z $ff
    ldy #0
    ldx #0
  !n:
    lda ($fc),y
    sta ($fe),y
    iny
    cpy #$ff
    bne !+
    inc.z $fd
    inc.z $ff
    inx
  !:
    cpy #<SIZEOF_STRUCT_DEVICESLOT
    bne !n-
    cpx #>SIZEOF_STRUCT_DEVICESLOT
    bne !n-
    // deviceslot_t s2 = {'B', 'W', "f2"}
    lda #<__1
    sta.z $fc
    lda #>__1
    sta.z $fd
    lda #<s2
    sta.z $fe
    lda #>s2
    sta.z $ff
    ldy #0
    ldx #0
  !n:
    lda ($fc),y
    sta ($fe),y
    iny
    cpy #$ff
    bne !+
    inc.z $fd
    inc.z $ff
    inx
  !:
    cpy #<SIZEOF_STRUCT_DEVICESLOT
    bne !n-
    cpx #>SIZEOF_STRUCT_DEVICESLOT
    bne !n-
    // DeviceSlotsA ssA
    lda #<ssA
    sta.z $fe
    lda #>ssA
    sta.z $ff
    lda #0
    tay
    tax
  !n:
    sta ($fe),y
    iny
    cpy #$ff
    bne !+
    inc.z $ff
    inx
  !:
    cpy #<SIZEOF_STRUCT_DEVICESLOTSA
    bne !n-
    cpx #>SIZEOF_STRUCT_DEVICESLOTSA
    bne !n-
    // slotsA->slot[0] = s1
    lda #<s1
    sta.z $fc
    lda #>s1
    sta.z $fd
    lda #<slotsA
    sta.z $fe
    lda #>slotsA
    sta.z $ff
    ldy #0
    ldx #0
  !n:
    lda ($fc),y
    sta ($fe),y
    iny
    cpy #$ff
    bne !+
    inc.z $fd
    inc.z $ff
    inx
  !:
    cpy #<SIZEOF_STRUCT_DEVICESLOT
    bne !n-
    cpx #>SIZEOF_STRUCT_DEVICESLOT
    bne !n-
    // slotsA->slot[1] = s2
    lda #<s2
    sta.z $fc
    lda #>s2
    sta.z $fd
    lda #<slotsA+1*SIZEOF_STRUCT_DEVICESLOT
    sta.z $fe
    lda #>slotsA+1*SIZEOF_STRUCT_DEVICESLOT
    sta.z $ff
    ldy #0
    ldx #0
  !n:
    lda ($fc),y
    sta ($fe),y
    iny
    cpy #$ff
    bne !+
    inc.z $fd
    inc.z $ff
    inx
  !:
    cpy #<SIZEOF_STRUCT_DEVICESLOT
    bne !n-
    cpx #>SIZEOF_STRUCT_DEVICESLOT
    bne !n-
    lda #<0
    sta.z i
    sta.z i+1
  __b1:
    // deviceslot_t ds = slotsA->slot[i]
    lda.z i+1
    lsr
    lda.z i
    ror
    sta.z __14+1
    lda #0
    ror
    sta.z __14
    clc
    lda.z __15
    adc.z i
    sta.z __15
    lda.z __15+1
    adc.z i+1
    sta.z __15+1
    asl.z __4
    rol.z __4+1
    lda.z __13
    clc
    adc #<slotsA
    sta.z __13
    lda.z __13+1
    adc #>slotsA
    sta.z __13+1
    lda.z __13
    sta.z $fc
    lda.z __13+1
    sta.z $fd
    lda #<ds
    sta.z $fe
    lda #>ds
    sta.z $ff
    ldy #0
    ldx #0
  !n:
    lda ($fc),y
    sta ($fe),y
    iny
    cpy #$ff
    bne !+
    inc.z $fd
    inc.z $ff
    inx
  !:
    cpy #<SIZEOF_STRUCT_DEVICESLOT
    bne !n-
    cpx #>SIZEOF_STRUCT_DEVICESLOT
    bne !n-
    // OUT + i
    lda.z i
    clc
    adc #<OUT
    sta.z __0
    lda.z i+1
    adc #>OUT
    sta.z __0+1
    // *(OUT + i) = ds.mode
    lda ds+OFFSET_STRUCT_DEVICESLOT_MODE
    ldy #0
    sta (__0),y
    // for(unsigned int i: 0..1)
    inc.z i
    bne !+
    inc.z i+1
  !:
    lda.z i+1
    bne __b1
    lda.z i
    cmp #2
    bne __b1
    // }
    rts
  .segment Data
    s1: .fill SIZEOF_STRUCT_DEVICESLOT, 0
    s2: .fill SIZEOF_STRUCT_DEVICESLOT, 0
    ssA: .fill SIZEOF_STRUCT_DEVICESLOTSA, 0
    ds: .fill SIZEOF_STRUCT_DEVICESLOT, 0
}
  __0: .byte 'A', 'R'
  .text "f1"
  .byte 0
  .fill $fd, 0
  __1: .byte 'B', 'W'
  .text "f2"
  .byte 0
  .fill $fd, 0
