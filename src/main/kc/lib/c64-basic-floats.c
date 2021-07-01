// Library wrapping the BASIC floating point functions
// See https://www.c64-wiki.com/wiki/Floating_point_arithmetic
// See http://www.pagetable.com/c64rom/c64rom_sc.html

#include <c64-basic-floats.h>

// Zeropage addresses used to hold lo/hi-bytes of addresses of float numbers in MEM
char* const memLo = (char*)0xfe;
char* const memHi = (char*)0xff;

// Prepare MEM pointers for operations using MEM
inline void prepareMEM(unsigned int mem) {
    *memLo = BYTE0(mem);
    *memHi = BYTE1(mem);
}

// FAC = unsigned int
// Set the FAC (floating point accumulator) to the integer value of a 16bit unsigned int
void setFAC(unsigned int w) {
    prepareMEM(w);
    // Load unsigned int register Y,A into FAC (floating point accumulator)
    asm {
        ldy memLo
        lda memHi
        jsr $b391
    }
}

// unsigned int = FAC
// Get the value of the FAC (floating point accumulator) as an integer 16bit unsigned int
// Destroys the value in the FAC in the process
unsigned int getFAC() {
    // Load FAC (floating point accumulator) integer part into unsigned int register Y,A
    asm {
        jsr $b1aa
        sty memLo
        sta memHi
    }
    unsigned int w = MAKEWORD( *memHi, *memLo );
    return w;
}

// ARG = FAC
// Set the ARG (floating point argument) to the value of the FAC (floating point accumulator)
void setARGtoFAC() {
    asm(clobbers "AX") {
        jsr $bc0f
    }
}

// FAC = ARG
// Set the FAC (floating point accumulator) to the value of the ARG (floating point argument)
void setFACtoARG() {
    asm(clobbers "AX") {
        jsr $bbfc
    }
}

// MEM = FAC
// Stores the value of the FAC to memory
// Stores 5 chars (means it is necessary to allocate 5 chars to avoid clobbering other data using eg. char[] mem = {0, 0, 0, 0, 0};)
void setMEMtoFAC(char* mem) {
    prepareMEM((unsigned int)mem);
    asm {
        ldx memLo
        ldy memHi
        jsr $bbd4
    }
}

// FAC = MEM
// Set the FAC to value from MEM (float saved in memory)
// Reads 5 chars
void setFACtoMEM(char* mem) {
    prepareMEM((unsigned int)mem);
    asm(clobbers "AY") {
        lda memLo
        ldy memHi
        jsr $bba2
    }
}

// FAC = PI/2
// Set the FAC to PI/2
// Reads 5 chars from the BASIC ROM
void setFACtoPIhalf() {
    asm(clobbers "AY") {
        lda #$e0
        ldy #$e2
        jsr $bba2
    }
}

// FAC = 2*PI
// Set the FAC to 2*PI
// Reads 5 chars from the BASIC ROM
void setFACto2PI() {
    asm(clobbers "AY"){
        lda #$e5
        ldy #$e2
        jsr $bba2
    }
}

// ARG = MEM
// Load the ARG from memory
// Reads 5 chars
void setARGtoMEM(char* mem) {
    prepareMEM((unsigned int)mem);
    asm(clobbers "AY") {
        lda memLo
        ldy memHi
        jsr $ba8c
    }
}

// FAC = MEM+FAC
// Set FAC to MEM (float saved in memory) plus FAC (float accumulator)
// Reads 5 chars from memory
void addMEMtoFAC(char* mem) {
    prepareMEM((unsigned int)mem);
    asm {
        lda memLo //memLo
        ldy memHi //memHi
        jsr $b867
    }
}

// FAC = ARG+FAC
// Add ARG (floating point argument) to FAC (floating point accumulator)
void addARGtoFAC() {
    asm {
        jsr $b86a
    }
}

// FAC = MEM-FAC
// Set FAC to MEM (float saved in memory) minus FAC (float accumulator)
// Reads 5 chars from memory
void subFACfromMEM(char* mem) {
    prepareMEM((unsigned int)mem);
    asm {
        lda memLo
        ldy memHi
        jsr $b850
    }
}

// FAC = ARG-FAC
// Set FAC to ARG minus FAC
void subFACfromARG() {
    asm {
        jsr $b853
    }
}

// FAC = MEM/FAC
// Set FAC to MEM (float saved in memory) divided by FAC (float accumulator)
// Reads 5 chars from memory
void divMEMbyFAC(char* mem) {
    prepareMEM((unsigned int)mem);
    asm {
        lda memLo
        ldy memHi
        jsr $bb0f
    }
}

// FAC = MEM*FAC
// Set FAC to MEM (float saved in memory) multiplied by FAC (float accumulator)
// Reads 5 chars from memory
void mulFACbyMEM(char* mem) {
    prepareMEM((unsigned int)mem);
    asm {
        lda memLo
        ldy memHi
        jsr $ba28
    }
}

// FAC = MEM^FAC
// Set FAC to MEM (float saved in memory) raised to power of FAC (float accumulator)
// Reads 5 chars from memory
void pwrMEMbyFAC(char* mem) {
    prepareMEM((unsigned int)mem);
    asm {
        lda memLo
        ldy memHi
        jsr $bf78
    }
}

// FAC = int(FAC)
// Set FAC to integer part of the FAC - int(FAC)
// The integer part is defined as the next lower integer - like java floor()
void intFAC() {
    asm {
        jsr $bccc
    }
}

// FAC = sin(FAC)
// Set FAC to sine of the FAC - sin(FAC)
// Sine is calculated on radians (0-2*PI)
void sinFAC() {
    asm {
        jsr $e26b
    }
}

// FAC = cos(FAC)
// Set FAC to cosine of the FAC - cos(FAC)
// Cosine is calculated on radians (0-2*PI)
void cosFAC() {
    asm {
        jsr $e264
    }
}

// FAC = tan(FAC)
// Set FAC to the tangens of FAC - tan(FAC)
// Tangens is calculated on radians (0-2*PI)
void tanFAC() {
    asm {
        jsr $e2b4
    }
}

// FAC = atn(FAC)
// Set FAC to the arc tangens of FAC - atn(FAC)
// Arc Tangens is calculated on radians (0-2*PI)
void atnFAC() {
    asm {
        jsr $e303
    }
}

// FAC = sqr(FAC)
// Set FAC to the square root of FAC - sqr(FAC)
void sqrFAC() {
    asm {
        jsr $bf71
    }
}

// FAC = exp(FAC)
// Set FAC to the exponential function of FAC - exp(FAC)
// Exp is based on the natural logarithm e=2.71828183
void expFAC() {
    asm {
        jsr $bfed
    }
}

// FAC = log(FAC)
// Set FAC to the logarithm of FAC - log(FAC)
// Log is based on the natural logarithm e=2.71828183
void logFAC() {
    asm {
        jsr $b9ea
    }
}

// FAC = FAC/10
// Set FAC to FAC divided by 10
void divFACby10() {
    asm {
        jsr $bafe
    }
}

// FAC = FAC*10
// Set FAC to FAC multiplied by 10
void mulFACby10() {
    asm {
        jsr $bae2
    }
}
