// Load a file to memory using the C64 KERNAL LOAD functions
// The kernalload.ld link file creates a D64 disk image containing the executable and the sprite.
// To execute the program succesfully you must mount the D64 disk image and execute the kernalload.PRG program
  // Create a D64 disk containing the program and a sprite file
.disk [filename="kernalload.d64", name="DISK", id=1] {
        [name="KERNALLOAD.D64", type="prg", segments="Program"],
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
  // The offset of the sprite pointers from the screen start address
  .const SPRITE_PTRS = $3f8
  .const GREEN = 5
  .const OFFSET_STRUCT_MOS6569_VICII_SPRITES_ENABLE = $15
  .const OFFSET_STRUCT_MOS6569_VICII_BORDER_COLOR = $20
  .label SPRITES_XPOS = $d000
  .label SPRITES_YPOS = $d001
  .label SPRITES_COLOR = $d027
  // The VIC-II MOS 6567/6569
  .label VICII = $d000
  // Address to load to
  .label LOAD_SPRITE = $3000
  .label SCREEN = $400
  .label SPRITES_PTR = SCREEN+SPRITE_PTRS
.segment Code
main: {
    .const toSpritePtr1_return = LOAD_SPRITE/$40
    // loadFileToMemory(8, "SPRITE", LOAD_SPRITE)
    jsr loadFileToMemory
    // loadFileToMemory(8, "SPRITE", LOAD_SPRITE)
    // status = loadFileToMemory(8, "SPRITE", LOAD_SPRITE)
    tax
    // if(status!=0xff)
    cpx #$ff
    beq __b1
    // VICII->BORDER_COLOR = 0x02
    lda #2
    sta VICII+OFFSET_STRUCT_MOS6569_VICII_BORDER_COLOR
    // error(status)
    txa
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
// Basic ERROR function
// ERROR. Show error.
// error(byte register(A) err)
error: {
    .label errCode = $ff
    // *errCode = err
    sta errCode
    // asm
    tax
    jsr $a437
    // }
    rts
}
// Load a file to memory
// Returns a status:
// - 0xff: Success
// - other: Kernal Error Code (https://commodore.ca/manuals/pdfs/commodore_error_messages.pdf)
loadFileToMemory: {
    .label device = 8
    // setnam(filename)
    jsr setnam
    // setlfs(device)
    jsr setlfs
    // load(address, false)
    jsr load
    // }
    rts
}
//LOAD. Load or verify file. (Must call SETLFS and SETNAM beforehands.)
// Returns a status, 0xff: Success other: Kernal Error Code
load: {
    .label loadOrVerify = $fd
    .label loadAddress = $fe
    .label status = $fd
    // *loadOrVerify = (char)verify
    lda #0
    sta loadOrVerify
    // *loadAddress = address
    lda #<LOAD_SPRITE
    sta loadAddress
    lda #>LOAD_SPRITE
    sta loadAddress+1
    // asm
    ldx loadAddress
    tay
    lda loadOrVerify
    jsr $ffd5
    bcs error
    lda #$ff
  error:
    sta status
    // return *status;
    // }
    rts
}
// SETLFS. Set file parameters.
setlfs: {
    .label deviceNum = $ff
    // *deviceNum = device
    lda #loadFileToMemory.device
    sta deviceNum
    // asm
    tax
    lda #1
    ldy #0
    jsr $ffba
    // }
    rts
}
// Kernal SETNAM function
// SETNAM. Set file name parameters.
setnam: {
    .label filename_len = $fd
    .label filename_ptr = $fe
    .label __0 = 4
    // strlen(filename)
    jsr strlen
    // strlen(filename)
    // *filename_len = (char)strlen(filename)
    lda.z __0
    sta filename_len
    // *filename_ptr = filename
    lda #<main.filename
    sta filename_ptr
    lda #>main.filename
    sta filename_ptr+1
    // asm
    lda filename_len
    ldx filename_ptr
    ldy filename_ptr+1
    jsr $ffbd
    // }
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

