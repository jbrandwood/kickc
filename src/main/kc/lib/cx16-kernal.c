#include <cx16-kernal.h>
#include <string.h>

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

// GETIN. Read a byte from the input channel
// return: next byte in buffer or 0 if buffer is empty.
char getin() {
    char ch;
    asm {
        jsr $ffe4
        sta ch
    }
    return ch;
}
