  // Commodore 64 PRG executable file
.file [name="struct-ptr-35.prg", type="prg", segments="Program"]
.segmentdef Program [segments="Basic, Code, Data"]
.segmentdef Basic [start=$0801]
.segmentdef Code [start=$80d]
.segmentdef Data [startAfter="Code"]
.segment Basic
:BasicUpstart(main)
  .const OFFSET_STRUCT_TILE_COUNT = 4
.segment Code
main: {
    .label SCREEN = $400
    .label __1 = 4
    .label tile = 4
    .label i = 2
    .label __4 = 4
    .label __5 = 6
    lda #<0
    sta.z i
    sta.z i+1
  __b1:
    // struct Tile *tile = TileDB[i]
    lda.z i
    asl
    sta.z __1
    lda.z i+1
    rol
    sta.z __1+1
    clc
    lda #<TileDB
    adc.z __4
    sta.z __4
    lda #>TileDB
    adc.z __4+1
    sta.z __4+1
    ldy #0
    lda (tile),y
    pha
    iny
    lda (tile),y
    sta.z tile+1
    pla
    sta.z tile
    // SCREEN[i] =  tile->Count
    lda #<SCREEN
    clc
    adc.z i
    sta.z __5
    lda #>SCREEN
    adc.z i+1
    sta.z __5+1
    ldy #OFFSET_STRUCT_TILE_COUNT
    lda (tile),y
    ldy #0
    sta (__5),y
    // for(int i:0..1)
    inc.z i
    bne !+
    inc.z i+1
  !:
    lda.z i+1
    cmp #>2
    bne __b1
    lda.z i
    cmp #<2
    bne __b1
    // }
    rts
}
.segment Data
  PlayerSprites: .fill 4*$c, 0
  Enemy2Sprites: .fill 4*$c, 0
  TileDB: .word S1, S2
  S1: .word PlayerSprites, $14
  .byte $40
  .text "Sven"
  .byte 0
  .fill $f, 0
  S2: .word Enemy2Sprites, $32
  .byte $80
  .text "Jesper"
  .byte 0
  .fill $d, 0
