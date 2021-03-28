// Test the code-merger by merging unrolled cycle-exact logic code into an unrolled cycle-exact raster code.

#pragma target(c64)
#include <6502.h>
#include "code-merger.c"

void main() {
    merge_code(DEST_CODE, RASTER_CODE, LOGIC_CODE);
}

// Unrolled raster code. 
// The format is a bunch of blocks with the following structure: 
// <nn>* $ff <cc> 
// <nn>* : some bytes of code. any number of bytes are allowed.
// $ff    : signals the end of a block.
// <cc> : if <cc> is 00 then this is the end of the unrolled raster code. 
//        If <cc> is non-zero it means that <cc> cycles must be spent here. The merger merges logic code into the slot and fills with NOP's to match the number of cycles needed.
char RASTER_CODE[] = kickasm {{ 
    .macro RASTER_CYCLES(cycles) {
        .byte $ff, cycles
    }
    lda #0
    sta $d020
    RASTER_CYCLES(10)
    lda #1
    sta $d020
    RASTER_CYCLES(20)
    lda #2
    sta $d020
    RASTER_CYCLES(20)
    lda #3
    sta $d020
    RASTER_CYCLES(0) // End of raster code
}};

// Unrolled logic code.
// The format is a bunch of blocks with the following structure: 
// <cc> <nn>* $ff
// <cc> : if <cc> is 00 then this is the end of the unrolled logic code. 
//        If <cc> is non-zero it holds the number of cycles used by the block of code.
// <nn>* : some bytes of code. any number of bytes are allowed. This code uses exactly the number of cycles specified by <cc>
// $ff    : signals the end of a block.
char LOGIC_CODE[] = kickasm {{     
    .macro LOGIC_BEGIN(cycles) {
        .byte cycles
    }
    .macro LOGIC_END() {
        .byte $ff
    }
    LOGIC_BEGIN(2)
    clc
    LOGIC_END()
    LOGIC_BEGIN(8)
    lda #4
    adc $fc
    sta $fc
    LOGIC_END()
    LOGIC_BEGIN(8)
    lda #0
    adc $fd
    sta $fd
    LOGIC_END()
    LOGIC_BEGIN(8)
    lda #0
    sta $fa
    sta $fb
    LOGIC_END()
    LOGIC_BEGIN(2)
    ldy #0
    LOGIC_END()    
    LOGIC_BEGIN(9)
    lda ($fc),y
    sta $fa
    sta $fb
    LOGIC_END()
    LOGIC_BEGIN(9)
    lda ($fc),y
    sta $fa
    sta $fb
    LOGIC_END()
    LOGIC_BEGIN(9)
    lda ($fc),y
    sta $fa
    sta $fb
    LOGIC_END()
    LOGIC_BEGIN(9)
    lda ($fc),y
    sta $fa
    sta $fb
    LOGIC_END()    
    LOGIC_BEGIN(0) // end of logic code
}};

// The destination code
char DEST_CODE[1000];

