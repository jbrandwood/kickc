// Load a file to memory using the C64 KERNAL LOAD functions
// The kernalload.ld link file creates a D64 disk image containing the executable and the sprite.
// To execute the program succesfully you must mount the D64 disk image and execute the kernalload.PRG program
  // Create a D64 disk containing the program and a sprite file
.file [name="kernalload.prg", type="prg", segments="Program"]
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
  // The offset of the sprite pointers from the screen start address
  .const SPRITE_PTRS = $3f8
  .label SPRITES_XPOS = $d000
  .label SPRITES_YPOS = $d001
  .label SPRITES_ENABLE = $d015
  .label BORDERCOL = $d020
  .label SPRITES_COLS = $d027
  .const GREEN = 5
  // Address to load to
  .label LOAD_SPRITE = $3000
  .label SCREEN = $400
  .label SPRITES_PTR = SCREEN+SPRITE_PTRS
.segment Code
main: {
    .const toSpritePtr1_return = LOAD_SPRITE/$40
    jsr loadFileToMemory
    tax
    cpx #$ff
    beq __b1
    lda #2
    sta BORDERCOL
    txa
    jsr error
  __b1:
    // Show the loaded sprite on screen
    lda #1
    sta SPRITES_ENABLE
    lda #toSpritePtr1_return
    sta SPRITES_PTR
    lda #GREEN
    sta SPRITES_COLS
    lda #$15
    sta SPRITES_XPOS
    lda #$33
    sta SPRITES_YPOS
    rts
  .segment Data
    filename: .text "SPRITE"
    .byte 0
}
.segment Code
// Basic ERROR function
// ERROR. Show error.
// error(byte register(A) err)
error: {
    .label errCode = $ff
    sta errCode
    tax
    jsr $a437
    rts
}
// Load a file to memory
// Returns a status:
// - 0xff: Success
// - other: Kernal Error Code (https://commodore.ca/manuals/pdfs/commodore_error_messages.pdf)
loadFileToMemory: {
    .label device = 8
    jsr setnam
    jsr setlfs
    jsr load
    rts
}
//LOAD. Load or verify file. (Must call SETLFS and SETNAM beforehands.)
// Returns a status, 0xff: Success other: Kernal Error Code
load: {
    .label loadOrVerify = $fd
    .label loadAddress = $fe
    .label status = $fd
    lda #0
    sta loadOrVerify
    lda #<LOAD_SPRITE
    sta loadAddress
    lda #>LOAD_SPRITE
    sta loadAddress+1
    ldx loadAddress
    tay
    lda loadOrVerify
    jsr $ffd5
    bcs error
    lda #$ff
  error:
    sta status
    rts
}
// SETLFS. Set file parameters.
setlfs: {
    .label deviceNum = $ff
    lda #loadFileToMemory.device
    sta deviceNum
    tax
    lda #1
    ldy #0
    jsr $ffba
    rts
}
// Kernal SETNAM function
// SETNAM. Set file name parameters.
setnam: {
    .label filename_len = $fd
    .label filename_ptr = $fe
    .label __0 = 4
    jsr strlen
    lda.z __0
    sta filename_len
    lda #<main.filename
    sta filename_ptr
    lda #>main.filename
    sta filename_ptr+1
    lda filename_len
    ldx filename_ptr
    ldy filename_ptr+1
    jsr $ffbd
    rts
}
// Computes the length of the string str up to but not including the terminating null character.
// strlen(byte* zp(2) str)
strlen: {
    .label len = 4
    .label str = 2
    .label return = 4
    lda #<0
    sta.z len
    sta.z len+1
    lda #<main.filename
    sta.z str
    lda #>main.filename
    sta.z str+1
  __b1:
    ldy #0
    lda (str),y
    cmp #0
    bne __b2
    rts
  __b2:
    inc.z len
    bne !+
    inc.z len+1
  !:
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

