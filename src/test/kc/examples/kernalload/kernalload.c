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
char* const LOAD_SPRITE = 0x3000;

char* const SCREEN = 0x0400;
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
    return load(address, false);
}

// Basic ERROR function
// ERROR. Show error.
void error(char err) {
    char* const errCode = 0xff;
    *errCode = err;
    asm {
        // Basic SHOWERR function
        // Input: X = Error Code
        ldx errCode
        jsr $a437
    }
}

// Kernal SETNAM function
// SETNAM. Set file name parameters.
void setnam(char* filename) {
    char* const filename_len = 0xfd;
    char** const filename_ptr = 0xfe;
    *filename_len = (char)strlen(filename);
    *filename_ptr = filename;
    asm {
        // Kernal SETNAM function
        // SETNAM. Set file name parameters.
        // Input: A = File name length; X/Y = Pointer to file name.
        lda filename_len
        ldx filename_ptr
        ldy filename_ptr+1
        jsr $ffbd
    }
}

// SETLFS. Set file parameters.
void setlfs(char device) {
    char* const deviceNum = 0xff;
    *deviceNum = device;
    asm {
        // SETLFS. Set file parameters.
        // Input: A = Logical number; X = Device number; Y = Secondary address.
        ldx deviceNum
        lda #1
        ldy #0
        jsr $ffba
    }
}

//LOAD. Load or verify file. (Must call SETLFS and SETNAM beforehands.)
// Returns a status, 0xff: Success other: Kernal Error Code
char load(char* address, bool verify) {
    char* loadOrVerify = 0xfd;
    char** loadAddress = 0xfe;
    char* status = 0xfd;
    *loadOrVerify = (char)verify;
    *loadAddress = address;
    asm {
        //LOAD. Load or verify file. (Must call SETLFS and SETNAM beforehands.)
        // Input: A: 0 = Load, 1-255 = Verify; X/Y = Load address (if secondary address = 0).
        // Output: Carry: 0 = No errors, 1 = Error; A = KERNAL error code (if Carry = 1); X/Y = Address of last byte loaded/verified (if Carry = 0).
        ldx loadAddress
        ldy loadAddress+1
        lda loadOrVerify
        jsr $ffd5
        bcs error
        lda #$ff
        error:
        sta status
    }
    return *status;
}





