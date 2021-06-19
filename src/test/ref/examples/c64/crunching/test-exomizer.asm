// Example showing how to crunch and decrunch part of a file using the KickAss Cruncher Plugins
// Exomizer Example
// https://github.com/p-a/kickass-cruncher-plugins
  // Commodore 64 PRG executable file - with the cruncher plugin enabled
.plugin "se.triad.kickass.CruncherPlugins"
.file [name="test-exomizer.prg", type="prg", segments="Program"]
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
  .label SPRITES_PTR = DEFAULT_SCREEN+OFFSET_SPRITE_PTRS
.segment Code
main: {
    .const toSpritePtr1_return = SPRITE/$40
    // kickasm
    // Decrunch sprite file into memory
    :EXO_DECRUNCH(CRUNCHED_SPRITE_END)
    
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
.segment Data
// The exomizer decruncher
EXOMIZER:
.const EXO_LITERAL_SEQUENCES_USED = true
    .const EXO_ZP_BASE = $02
    .const EXO_DECRUNCH_TABLE = $0200
    #import "exomizer_decrunch.asm"

// Array with crunched data created using inline kickasm
CRUNCHED_SPRITE:
.modify MemExomizer(false, true) {
	    .pc = SPRITE
        .var pic = LoadPicture("sprite.png", List().add($000000, $ffffff))
        .for (var y=0; y<21; y++)
            .for (var x=0;x<3; x++)
                .byte pic.getSinglecolorByte(x,y)
    }
    CRUNCHED_SPRITE_END:

