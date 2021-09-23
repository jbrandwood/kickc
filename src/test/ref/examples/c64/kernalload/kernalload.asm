// Load a file to memory using the C64 KERNAL LOAD functions
// The kernalload.ld link file creates a D64 disk image containing the executable and the sprite.
// To execute the program succesfully you must mount the D64 disk image and execute the kernalload.PRG program
  // Create a D64 disk containing the program and a sprite file
.disk [filename="kernalload.d64", name="DISK", id=1] {
        [name="KERNALLOAD", type="prg", segments="Program"],
        [name="SPRITE", type="prg", segments="Sprite"]
}
.segmentdef Program [segments="Basic, Code, Data"]
.segmentdef Basic [start=$0801]
.segmentdef Code [start=$0810]
.segmentdef Data [startAfter="Code"]
.segmentdef Sprite
.segment Basic
:BasicUpstart(main)
.segment Code
  /// The offset of the sprite pointers from the screen start address
  .const OFFSET_SPRITE_PTRS = $3f8
  .const GREEN = 5
  .const OFFSET_STRUCT_MOS6569_VICII_SPRITES_ENABLE = $15
  .const OFFSET_STRUCT_MOS6569_VICII_BORDER_COLOR = $20
  /// Sprite X position register for sprite #0
  .label SPRITES_XPOS = $d000
  /// Sprite Y position register for sprite #0
  .label SPRITES_YPOS = $d001
  /// Sprite colors register for sprite #0
  .label SPRITES_COLOR = $d027
  /// The VIC-II MOS 6567/6569
  .label VICII = $d000
  // Address to load to
  .label LOAD_SPRITE = $3000
  .label SCREEN = $400
  .label SPRITES_PTR = SCREEN+OFFSET_SPRITE_PTRS
.segment Code
main: {
    .const toSpritePtr1_return = LOAD_SPRITE/$40
    // char status = loadFileToMemory(8, "SPRITE", LOAD_SPRITE)
    // Load sprite file into memory
    jsr loadFileToMemory
    tax
    // if(status!=0xff)
    cpx #$ff
    beq __b1
    // VICII->BORDER_COLOR = 0x02
    lda #2
    sta VICII+OFFSET_STRUCT_MOS6569_VICII_BORDER_COLOR
    // error(status)
    stx.z error.err
    jsr error
  __b1:
    // VICII->SPRITES_ENABLE = %00000001
    // Show the loaded sprite on screen
    lda #1
    sta VICII+OFFSET_STRUCT_MOS6569_VICII_SPRITES_ENABLE
    // SPRITES_PTR[0] = toSpritePtr(LOAD_SPRITE)
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
  .segment Data
    filename: .text "SPRITE"
    .byte 0
}
.segment Code
// Load a file to memory
// Returns a status:
// - 0xff: Success
// - other: Kernal Error Code (https://commodore.ca/manuals/pdfs/commodore_error_messages.pdf)
// __register(A) char loadFileToMemory(char device, char *filename, char *address)
loadFileToMemory: {
    .const device = 8
    // setnam(filename)
    lda #<main.filename
    sta.z setnam.filename
    lda #>main.filename
    sta.z setnam.filename+1
    jsr setnam
    // setlfs(device)
    lda #device
    sta.z setlfs.device
    jsr setlfs
    // load(address, 0)
    lda #<LOAD_SPRITE
    sta.z load.address
    lda #>LOAD_SPRITE
    sta.z load.address+1
    lda #0
    sta.z load.verify
    jsr load
    // }
    rts
}
// Basic ERROR function
// ERROR. Show error.
// void error(__zp($e) volatile char err)
error: {
    .label err = $e
    // asm
    ldx err
    jsr $a437
    // }
    rts
}
// Kernal SETNAM function
// SETNAM. Set file name parameters.
// void setnam(__zp(8) char * volatile filename)
setnam: {
    .label filename = 8
    .label filename_len = 6
    .label __0 = 4
    // strlen(filename)
    lda.z filename
    sta.z strlen.str
    lda.z filename+1
    sta.z strlen.str+1
    jsr strlen
    // strlen(filename)
    // char filename_len = (char)strlen(filename)
    lda.z __0
    sta.z filename_len
    // asm
    ldx filename
    ldy filename+1
    jsr $ffbd
    // }
    rts
}
// SETLFS. Set file parameters.
// void setlfs(__zp($a) volatile char device)
setlfs: {
    .label device = $a
    // asm
    ldx device
    lda #1
    ldy #0
    jsr $ffba
    // }
    rts
}
// LOAD. Load or verify file. (Must call SETLFS and SETNAM beforehands.)
// - verify: 0 = Load, 1-255 = Verify
//
// Returns a status, 0xff: Success other: Kernal Error Code
// __register(A) char load(__zp($c) char * volatile address, __zp($b) volatile char verify)
load: {
    .label address = $c
    .label verify = $b
    .label status = 7
    // char status
    lda #0
    sta.z status
    // asm
    ldx address
    ldy address+1
    lda verify
    jsr $ffd5
    bcs error
    lda #$ff
  error:
    sta status
    // return status;
    // }
    rts
}
// Computes the length of the string str up to but not including the terminating null character.
// __zp(4) unsigned int strlen(__zp(2) char *str)
strlen: {
    .label len = 4
    .label str = 2
    .label return = 4
    lda #<0
    sta.z len
    sta.z len+1
  __b1:
    // while(*str)
    ldy #0
    lda (str),y
    cmp #0
    bne __b2
    // }
    rts
  __b2:
    // len++;
    inc.z len
    bne !+
    inc.z len+1
  !:
    // str++;
    inc.z str
    bne !+
    inc.z str+1
  !:
    jmp __b1
}
.segment Sprite
SPRITE:
.var pic = LoadPicture("sprite.png", List().add($000000, $ffffff))
    .for (var y=0; y<21; y++)
        .for (var x=0;x<3; x++)
            .byte pic.getSinglecolorByte(x,y)

