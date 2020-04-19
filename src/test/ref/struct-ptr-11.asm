// Minimal struct -  array of 3-byte structs (required *3)
.pc = $801 "Basic"
:BasicUpstart(main)
.pc = $80d "Program"
  .const SIZEOF_STRUCT_POINT = 3
  .const OFFSET_STRUCT_POINT_Y = 1
  .const OFFSET_STRUCT_POINT_Z = 2
main: {
    .label SCREEN = $400
    .label __0 = 3
    .label i1 = 2
    ldx #0
  __b1:
    // -(signed byte)i
    txa
    eor #$ff
    clc
    adc #1
    sta.z __0
    // points[i] = { (signed byte)i, -(signed byte)i, (signed byte)i }
    txa
    asl
    stx.z $ff
    clc
    adc.z $ff
    tay
    txa
    sta points,y
    lda.z __0
    sta points+OFFSET_STRUCT_POINT_Y,y
    txa
    sta points+OFFSET_STRUCT_POINT_Z,y
    // for( byte i: 0..3)
    inx
    cpx #4
    bne __b1
    lda #0
    sta.z i1
  __b2:
    // SCREEN[i] = points[i]
    lda.z i1
    asl
    clc
    adc.z i1
    ldx #SIZEOF_STRUCT_POINT
    tay
  !:
    lda points,y
    sta SCREEN,y
    iny
    dex
    bne !-
    // for( byte i: 0..3)
    inc.z i1
    lda #4
    cmp.z i1
    bne __b2
    // }
    rts
}
  points: .fill 3*4, 0
