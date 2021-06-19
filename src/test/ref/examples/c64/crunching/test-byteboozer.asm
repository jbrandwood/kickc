// Example showing how to crunch and decrunch part of a file using the KickAss Cruncher Plugins
// ByteBoozer example
// https://github.com/p-a/kickass-cruncher-plugins
  // Commodore 64 PRG executable file - with the cruncher plugin enabled
.plugin "se.triad.kickass.CruncherPlugins"
.file [name="test-byteboozer.prg", type="prg", segments="Program"]
.segmentdef Program [segments="Basic, Code, Data"]
.segmentdef Basic [start=$0801]
.segmentdef Code [start=$80d]
.segmentdef Data [startAfter="Code"]
.segment Basic
:BasicUpstart(main)
  /// The offset of the sprite pointers from the screen start address
  .const OFFSET_SPRITE_PTRS = $3f8
  .const GREEN = 5
  .const OFFSET_STRUCT_MOS6569_VICII_SPRITES_ENABLE = $15
  .label SPRITES_XPOS = $d000
  .label SPRITES_YPOS = $d001
  .label SPRITES_COLOR = $d027
  /// The VIC-II MOS 6567/6569
  .label VICII = $d000
  /// Default address of screen character matrix
  .label DEFAULT_SCREEN = $400
  // Address to decrunch the sprite to
  .label SPRITE = $2000
  // The sprite pointers
  .label SPRITES_PTR = DEFAULT_SCREEN+OFFSET_SPRITE_PTRS
.segment Code
main: {
    .const toSpritePtr1_return = SPRITE/$40
    // byteboozer_decrunch(CRUNCHED_SPRITE)
    lda #<CRUNCHED_SPRITE
    sta.z byteboozer_decrunch.crunched
    lda #>CRUNCHED_SPRITE
    sta.z byteboozer_decrunch.crunched+1
    // Decrunch sprite file into memory
    jsr byteboozer_decrunch
    // VICII->SPRITES_ENABLE = %00000001
    // Show the loaded sprite on screen
    lda #1
    sta VICII+OFFSET_STRUCT_MOS6569_VICII_SPRITES_ENABLE
    // SPRITES_PTR[0] = toSpritePtr(SPRITE)
    lda #toSpritePtr1_return
    sta SPRITES_PTR
    // SPRITES_COLOR[0] = GREEN
    lda #GREEN
    sta SPRITES_COLOR
    // SPRITES_XPOS[0] = 0x15
    lda #$15
    sta SPRITES_XPOS
    // SPRITES_YPOS[0] = 0x33
    lda #$33
    sta SPRITES_YPOS
    // }
    rts
}
// Decrunch crunched data using ByteBoozer
// - crunched: Pointer to the start of the crunched data
// byteboozer_decrunch(byte* zp(2) crunched)
byteboozer_decrunch: {
    .label crunched = 2
    // asm
    ldy crunched
    ldx crunched+1
    jsr b2.Decrunch
    // }
    rts
}
.segment Data
// The byteboozer decruncher
BYTEBOOZER:
.const B2_ZP_BASE = $fc
    #import "byteboozer_decrunch.asm"

// Array with crunched data created using inline kickasm
CRUNCHED_SPRITE:
.modify B2() {
	    .pc = SPRITE
        .var pic = LoadPicture("sprite.png", List().add($000000, $ffffff))
        .for (var y=0; y<21; y++)
            .for (var x=0;x<3; x++)
                .byte pic.getSinglecolorByte(x,y)
    }

