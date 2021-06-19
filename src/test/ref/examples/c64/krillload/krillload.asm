// Tests Krill Loader
// Load a file to memory using the Krill loader
// The krillload.ld link file creates a D64 disk image containing the executable and the sprite.
// To execute the program succesfully you must mount the D64 disk image and execute the krillload.PRG program
  // Create a D64 disk containing the program and a sprite file
.disk [filename="krillload.d64", name="DISK", id=1] {
        [name="KRILLLOAD", type="prg", segments="Program"],
        [name="SPRITE", type="prg", segments="Sprite"]
}
.segmentdef Program [segments="Basic, Code, Data"]
.segmentdef Basic [start=$0801]
.segmentdef Code [start=$080d]
.segmentdef Data [startAfter="Code"]
.segmentdef Sprite
.segment Basic
:BasicUpstart(main)
.segment Code
  .const KRILL_OK = 0
  /// The offset of the sprite pointers from the screen start address
  .const OFFSET_SPRITE_PTRS = $3f8
  .const GREEN = 5
  .const OFFSET_STRUCT_MOS6569_VICII_BORDER_COLOR = $20
  .const OFFSET_STRUCT_MOS6569_VICII_SPRITES_ENABLE = $15
  .label SPRITES_XPOS = $d000
  .label SPRITES_YPOS = $d001
  .label SPRITES_COLOR = $d027
  /// The VIC-II MOS 6567/6569
  .label VICII = $d000
  .label SCREEN = $400
  .label SPRITES_PTR = SCREEN+OFFSET_SPRITE_PTRS
.segment Code
main: {
    .const toSpritePtr1_return = $ff&SPRITE/$40
    // krill_install()
    jsr krill_install
    // char status = krill_install()
    // if(status!=KRILL_OK)
    cmp #KRILL_OK
    beq __b1
    // VICII->BORDER_COLOR = 0x02
    lda #2
    sta VICII+OFFSET_STRUCT_MOS6569_VICII_BORDER_COLOR
    // }
    rts
  __b1:
    // krill_loadraw("sprite")
    jsr krill_loadraw
    // status = krill_loadraw("sprite")
    // if(status!=KRILL_OK)
    cmp #KRILL_OK
    beq __b2
    // VICII->BORDER_COLOR = 0x02
    lda #2
    sta VICII+OFFSET_STRUCT_MOS6569_VICII_BORDER_COLOR
    rts
  __b2:
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
    rts
  .segment Data
  .encoding "petscii_mixed"
    filename: .text "sprite"
    .byte 0
}
.segment Code
// Install drive-side code portion(s) must be installed in the active drive.
// Before the loader can operate, its drive-side code portion(s) must be installed in the drive(s).
// The drive-side portion remains resident in the drive. After successful
// installation, the install routine is not needed any more and may be overwritten.
// The KERNAL ROM may be disabled and zeropage variables clobbered.
// Returns the status of the installation
krill_install: {
    .label status = $ff
    // asm
    jsr KRILL_INSTALL
    sta status
    // return *status;
    // }
    rts
}
// Load a file from the active drive without decompression.
// While loading using filenames with wildcards ("?" and "*") is not possible,
// subsequent files following the previously-loaded file can be loaded via a
// zero-length filename
// - filename - The name of the file to load (zero-terminated in petscii encoding)
// Returns the status of the load
krill_loadraw: {
    .label status = $ff
    .label fname = $fe
    // *fname = filename
    lda #<main.filename
    sta fname
    lda #>main.filename
    sta fname+1
    // asm
    ldx fname
    tay
    jsr KRILL_LOADER
    sta status
    // return *status;
    // }
    rts
}
.segment Data
.pc = $3000 "KRILL_LOADER"
// The Krill loader routine that can load files.
KRILL_LOADER:
.import c64 "loader-c64.prg"

.pc = $3400 "KRILL_INSTALL"
// The Krill Install routine that can install the drive-side code
KRILL_INSTALL:
.import c64 "install-c64.prg"

.segment Sprite
.pc = $2040 "SPRITE"
// The sprite data
SPRITE:
.var pic = LoadPicture("sprite.png", List().add($000000, $ffffff))
    .for (var y=0; y<21; y++)
        .for (var x=0;x<3; x++)
            .byte pic.getSinglecolorByte(x,y)

