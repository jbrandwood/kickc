// Load a file to memory using the C64 KERNAL LOAD functions
// The kernalload.ld link file creates a D64 disk image containing the executable and the sprite.
// To execute the program succesfully you must mount the D64 disk image and execute the kernalload.PRG program
#pragma link("kernalload.ld")
#pragma extension("d64")

#include <string.h>
#include <c64.h>

// Sprite file
#pragma data_seg(Sprite)
export char SPRITE[] = kickasm(resource "sprite.png") {{
    .var pic = LoadPicture("sprite.png", List().add($000000, $ffffff))
    .for (var y=0; y<21; y++)
        .for (var x=0;x<3; x++)
            .byte pic.getSinglecolorByte(x,y)
}};

// Program file
#pragma data_seg(Data)

// Address to load to
char* const LOAD_SPRITE = (char*)0x3000;

char* const SCREEN = (char*)0x0400;
char* const SPRITES_PTR = SCREEN+OFFSET_SPRITE_PTRS;

void main() {
    // Load sprite file into memory
    char status = loadFileToMemory(8, "SPRITE", LOAD_SPRITE);
    if(status!=0xff) {
        VICII->BORDER_COLOR = 0x02;
        error(status);
    }
    // Show the loaded sprite on screen
    VICII->SPRITES_ENABLE = %00000001;
    SPRITES_PTR[0] = toSpritePtr(LOAD_SPRITE);
    SPRITES_COLOR[0] = GREEN;
    SPRITES_XPOS[0] = 0x15;
    SPRITES_YPOS[0] = 0x33;
}

// Load a file to memory
// Returns a status:
// - 0xff: Success
// - other: Kernal Error Code (https://commodore.ca/manuals/pdfs/commodore_error_messages.pdf)
char loadFileToMemory( char device, char* filename, char* address) {
    setnam(filename);
    setlfs(device);
    return load(address, 0);
}

// Basic ERROR function
// ERROR. Show error.
void error(char err) {
    asm {
        // Basic SHOWERR function
        // Input: X = Error Code
        ldx err
        jsr $a437
    }
}

// Kernal SETNAM function
// SETNAM. Set file name parameters.
void setnam(char* filename) {
    char filename_len = (char)strlen(filename);
    asm {
        // Kernal SETNAM function
        // SETNAM. Set file name parameters.
        // Input: A = File name length; X/Y = Pointer to file name.
        lda filename_len
        ldx filename
        ldy filename+1
        jsr $ffbd
    }
}

// SETLFS. Set file parameters.
void setlfs(char device) {
    asm {
        // SETLFS. Set file parameters.
        // Input: A = Logical number; X = Device number; Y = Secondary address.
        ldx device
        lda #1
        ldy #0
        jsr $ffba
    }
}

// LOAD. Load or verify file. (Must call SETLFS and SETNAM beforehands.)
// - verify: 0 = Load, 1-255 = Verify
//
// Returns a status, 0xff: Success other: Kernal Error Code
char load(char* address, char verify) {
    char status;
    asm {
        //LOAD. Load or verify file. (Must call SETLFS and SETNAM beforehands.)
        // Input: A: 0 = Load, 1-255 = Verify; X/Y = Load address (if secondary address = 0).
        // Output: Carry: 0 = No errors, 1 = Error; A = KERNAL error code (if Carry = 1); X/Y = Address of last byte loaded/verified (if Carry = 0).
        ldx address
        ldy address+1
        lda verify
        jsr $ffd5
        bcs error
        lda #$ff
        error:
        sta status
    }
    return status;
}





