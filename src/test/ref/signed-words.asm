/// @file
/// Commodore 64 Registers and Constants
/// @file
/// The MOS 6526 Complex Interface Adapter (CIA)
///
/// http://archive.6502.org/datasheets/mos_6526_cia_recreated.pdf
  // Commodore 64 PRG executable file
.file [name="signed-words.prg", type="prg", segments="Program"]
.segmentdef Program [segments="Basic, Code, Data"]
.segmentdef Basic [start=$0801]
.segmentdef Code [start=$80d]
.segmentdef Data [startAfter="Code"]
.segment Basic
:BasicUpstart(main)
  .const WHITE = 1
  .const g = -5
  /// Sprite X position register for sprite #0
  .label SPRITES_XPOS = $d000
  /// Sprite Y position register for sprite #0
  .label SPRITES_YPOS = $d001
  /// Sprite X position MSB register
  .label SPRITES_XMSB = $d010
  /// Sprite colors register for sprite #0
  .label SPRITES_COLOR = $d027
  /// Sprite enable register
  .label SPRITES_ENABLE = $d015
  /// Sprite expand Y register
  .label SPRITES_EXPAND_Y = $d017
  /// Sprite expand X register
  .label SPRITES_EXPAND_X = $d01d
  /// $D012 RASTER Raster counter
  .label RASTER = $d012
  .label SCREEN = $400
  .label SPRITES_PTR = SCREEN+$3f8
  .label SPRITE = $2000
  // Reset y velocity
  .label yvel_init = 2
  .label yvel = 2
  .label yvel_1 = 6
  // Reset position
  .label xpos = 8
  .label ypos = $a
  .label xvel = 4
.segment Code
main: {
    // init()
    jsr init
    lda #<$64
    sta.z yvel_init
    lda #>$64
    sta.z yvel_init+1
    lda #<$c8
    sta.z xvel
    lda #>$c8
    sta.z xvel+1
    lda #<0
    sta.z ypos
    sta.z ypos+1
    sta.z xpos
    sta.z xpos+1
    lda #<$64
    sta.z yvel_1
    lda #>$64
    sta.z yvel_1+1
  __b1:
    // while (*RASTER!=$ff)
    lda #$ff
    cmp RASTER
    bne __b1
    // anim()
    jsr anim
    jmp __b1
}
// Fill and show a sprite, clear the screen
init: {
    .label sc = 4
    // *SPRITES_ENABLE = %00000001
    lda #1
    sta SPRITES_ENABLE
    // *SPRITES_EXPAND_X = 0
    lda #0
    sta SPRITES_EXPAND_X
    // *SPRITES_EXPAND_Y = 0
    sta SPRITES_EXPAND_Y
    // SPRITES_XPOS[0] = 100
    lda #$64
    sta SPRITES_XPOS
    // SPRITES_YPOS[0] = 100
    sta SPRITES_YPOS
    // SPRITES_COLOR[0] = WHITE
    lda #WHITE
    sta SPRITES_COLOR
    // SPRITES_PTR[0] = (byte)(SPRITE/$40)
    lda #SPRITE/$40
    sta SPRITES_PTR
    lda #<SCREEN
    sta.z sc
    lda #>SCREEN
    sta.z sc+1
  __b1:
    // for(byte* sc=SCREEN; sc!=SCREEN+1000; sc++ )
    lda.z sc+1
    cmp #>SCREEN+$3e8
    bne __b2
    lda.z sc
    cmp #<SCREEN+$3e8
    bne __b2
    ldx #0
  __b3:
    // SPRITE[i] = $ff
    lda #$ff
    sta SPRITE,x
    // for(byte i : 0..63)
    inx
    cpx #$40
    bne __b3
    // }
    rts
  __b2:
    // *sc = ' '
    lda #' '
    ldy #0
    sta (sc),y
    // for(byte* sc=SCREEN; sc!=SCREEN+1000; sc++ )
    inc.z sc
    bne !+
    inc.z sc+1
  !:
    jmp __b1
}
anim: {
    .label __5 = $c
    .label __7 = $e
    .label sprite_x = $c
    .label sprite_y = $e
    // if(ypos<0)
    lda.z ypos+1
    bpl __b1
    // xvel = -xvel
    lda #0
    sec
    sbc.z xvel
    sta.z xvel
    lda #0
    sbc.z xvel+1
    sta.z xvel+1
    // yvel_init = yvel_init-10
    lda.z yvel_init
    sec
    sbc #$a
    sta.z yvel_init
    lda.z yvel_init+1
    sbc #>$a
    sta.z yvel_init+1
    // if(yvel_init<-200)
    lda.z yvel_init
    cmp #<-$c8
    lda.z yvel_init+1
    sbc #>-$c8
    bvc !+
    eor #$80
  !:
    bpl __b3
    lda #<$c8
    sta.z yvel
    lda #>$c8
    sta.z yvel+1
  __b3:
    lda.z yvel
    sta.z yvel_1
    lda.z yvel+1
    sta.z yvel_1+1
    lda #<0
    sta.z ypos
    sta.z ypos+1
    sta.z xpos
    sta.z xpos+1
  __b1:
    // yvel + g
    clc
    lda.z yvel_1
    adc #<g
    sta.z yvel_1
    lda.z yvel_1+1
    adc #>g
    sta.z yvel_1+1
    // xpos + xvel
    clc
    lda.z xpos
    adc.z xvel
    sta.z xpos
    lda.z xpos+1
    adc.z xvel+1
    sta.z xpos+1
    // ypos + yvel
    clc
    lda.z ypos
    adc.z yvel_1
    sta.z ypos
    lda.z ypos+1
    adc.z yvel_1+1
    sta.z ypos+1
    // xpos>>7
    lda.z xpos+1
    sta.z __5
    and #$80
    beq !+
    lda #$ff
  !:
    sta.z __5+1
    lda.z xpos
    rol
    rol.z __5
    rol.z __5+1
    // signed word sprite_x = xpos>>7 + 160
    clc
    lda.z sprite_x
    adc #<$a0
    sta.z sprite_x
    lda.z sprite_x+1
    adc #>$a0
    sta.z sprite_x+1
    // ypos>>5
    lda.z ypos
    sta.z $ff
    lda.z ypos+1
    sta.z __7
    lda #0
    bit.z ypos+1
    bpl !+
    lda #$ff
  !:
    sta.z __7+1
    rol.z $ff
    rol.z __7
    rol.z __7+1
    rol.z $ff
    rol.z __7
    rol.z __7+1
    rol.z $ff
    rol.z __7
    rol.z __7+1
    // signed word sprite_y = 230 - ypos>>5
    lda #<$e6
    sec
    sbc.z sprite_y
    sta.z sprite_y
    lda #>$e6
    sbc.z sprite_y+1
    sta.z sprite_y+1
    // SPRITES_XPOS[0] = (byte)sprite_x
    lda.z sprite_x
    sta SPRITES_XPOS
    // SPRITES_YPOS[0] = (byte)sprite_y
    lda.z sprite_y
    sta SPRITES_YPOS
    // BYTE1(sprite_x)
    lda.z sprite_x+1
    // *SPRITES_XMSB = BYTE1(sprite_x)
    sta SPRITES_XMSB
    // }
    rts
}
