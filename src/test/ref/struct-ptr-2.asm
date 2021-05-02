// Minimal struct - array of struct - far pointer math indexing
  // Commodore 64 PRG executable file
.file [name="struct-ptr-2.prg", type="prg", segments="Program"]
.segmentdef Program [segments="Basic, Code, Data"]
.segmentdef Basic [start=$0801]
.segmentdef Code [start=$80d]
.segmentdef Data [startAfter="Code"]
.segment Basic
:BasicUpstart(main)
  .const OFFS_Y = 1
.segment Code
main: {
    .label SCREEN = $400
    .label point_i = 2
    .label point_i1 = 4
    ldx #0
  __b1:
    // points+i
    txa
    asl
    tay
    // struct Point* point_i = points+i
    tya
    clc
    adc #<points
    sta.z point_i
    lda #>points
    adc #0
    sta.z point_i+1
    // *((byte*)point_i+OFFS_X) = i
    txa
    sta points,y
    // i+4
    txa
    clc
    adc #4
    // *((byte*)point_i+OFFS_Y)  = i+4
    // points[i].x = i;
    ldy #OFFS_Y
    sta (point_i),y
    // for( byte i: 0..3)
    inx
    cpx #4
    bne __b1
    ldx #0
  __b2:
    // points+i
    txa
    asl
    tay
    // struct Point* point_i = points+i
    tya
    clc
    adc #<points
    sta.z point_i1
    lda #>points
    adc #0
    sta.z point_i1+1
    // SCREEN[i] = *((byte*)point_i+OFFS_X)
    lda points,y
    sta SCREEN,x
    // (SCREEN+40)[i] = *((byte*)point_i+OFFS_Y)
    // SCREEN[i] = points[i].x;
    ldy #OFFS_Y
    lda (point_i1),y
    sta SCREEN+$28,x
    // for( byte i: 0..3)
    inx
    cpx #4
    bne __b2
    // }
    rts
}
.segment Data
  points: .fill 2*4, 0
