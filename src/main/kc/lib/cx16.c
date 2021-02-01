// Commander X16 Functions
// https://www.commanderx16.com/forum/index.php?/about-faq/
// https://github.com/commanderx16/x16-docs/blob/master/Commander%20X16%20Programmer's%20Reference%20Guide.md

#include <cx16.h>
#include <cx16-kernal.h>
#include <peekpoke.h>

// Load a file to memory
// Returns a status:
// - 0xff: Success
// - other: Kernal Error Code (https://commodore.ca/manuals/pdfs/commodore_error_messages.pdf)
char LoadFileBanked( char device, char* filename, dword address) {
    setnam(filename);
    setlfs(device);
    char bank = (byte)(((((word)<(>address)<<8)|>(<address))>>5)+((word)<(>address)<<3));
    char* addr = ((<address)&0x1FFF); // stip off the top 3 bits, which are representing the bank of the word!
    addr += 0xA000;
    VIA1->PORT_A = (char)bank; // select the bank
    return load(addr, 0);
}

// Put a single byte into VRAM.
// Uses VERA DATA0
// - bank: Which 64K VRAM bank to put data into (0/1)
// - addr: The address in VRAM
// - data: The data to put into VRAM
void vpoke(char vbank, char* vaddr, char data) {
    // Select DATA0
    *VERA_CTRL &= ~VERA_ADDRSEL;
    // Set address
    *VERA_ADDRX_L = <vaddr;
    *VERA_ADDRX_M = >vaddr;
    *VERA_ADDRX_H = VERA_INC_0 | vbank;
    // Set data
    *VERA_DATA0 = data;
}

// Read a single byte from VRAM.
// Uses VERA DATA0
// - bank: Which 64K VRAM bank to put data into (0/1)
// - addr: The address in VRAM
// - returns: The data to put into VRAM
char vpeek(char vbank, char* vaddr) {
    // Select DATA0
    *VERA_CTRL &= ~VERA_ADDRSEL;
    // Set address
    *VERA_ADDRX_L = <vaddr;
    *VERA_ADDRX_M = >vaddr;
    *VERA_ADDRX_H = VERA_INC_0 | vbank;
    // Get data
    return *VERA_DATA0;
}

// Copy block of memory (from RAM to VRAM)
// Copies the values of num bytes from the location pointed to by source directly to the memory block pointed to by destination in VRAM.
// - vbank: Which 64K VRAM bank to put data into (0/1)
// - vdest: The destination address in VRAM
// - src: The source address in RAM
// - num: The number of bytes to copy
void memcpy_to_vram(char vbank, void* vdest, void* src, unsigned int num ) {
    // Select DATA0
    *VERA_CTRL &= ~VERA_ADDRSEL;
    // Set address
    *VERA_ADDRX_L = <vdest;
    *VERA_ADDRX_M = >vdest;
    *VERA_ADDRX_H = VERA_INC_1 | vbank;
    // Transfer the data
    char *end = (char*)src+num;
    for(char *s = src; s!=end; s++)
        *VERA_DATA0 = *s;
}

// Copy block of banked internal memory (256 banks at A000-BFFF) to VERA VRAM.
// Copies the values of num bytes from the location pointed to by source directly to the memory block pointed to by destination in VRAM.
// - vdest: dword of the destination address in VRAM
// - src: dword of source banked address in RAM. This address is a linair project of the banked memory of 512K to 2048K.
// - num: dword of the number of bytes to copy
void bnkcpy_vram_address(dword vdest, dword src, dword num ) {
    // Select DATA0
    *VERA_CTRL &= ~VERA_ADDRSEL;
    // Set address
    *VERA_ADDRX_L = <(<vdest);
    *VERA_ADDRX_M = >(<vdest);
    *VERA_ADDRX_H = <(>vdest);
    *VERA_ADDRX_H |= VERA_INC_1;

    dword beg = src;
    dword end = src+num; 

    char bank = (byte)(((((word)<(>beg)<<8)|>(<beg))>>5)+((word)<(>beg)<<3));

    char* addr = ((<beg)&0x1FFF); // stip off the top 3 bits, which are representing the bank of the word!
    addr += 0xA000;

    POKE(0x9f61, (byte)bank); // select the bank
    for(dword pos=beg; pos<end; pos++) {
        if(addr == 0xC000) {
            POKE(0x9f61, (byte)++bank); // select the bank
            addr = 0xA000;
        }
        *VERA_DATA0 = *addr;
        addr++;
    }
}

// Set block of memory to a value in VRAM.
// Sets num bytes to a value to the memory block pointed to by destination in VRAM.
// - vbank: Which 64K VRAM bank to put data into (0/1)
// - vdest: The destination address in VRAM
// - data: The value to set the vram with.
// - num: The number of bytes to set
void memset_vram(char vbank, void* vdest, char data, unsigned long num ) {
    // Select DATA0
    *VERA_CTRL &= ~VERA_ADDRSEL;
    // Set address
    *VERA_ADDRX_L = <vdest;
    *VERA_ADDRX_M = >vdest;
    *VERA_ADDRX_H = VERA_INC_1 | vbank;
    // Transfer the data
    for(unsigned long i = 0; i<num; i++)
        *VERA_DATA0 = data;
}

// Set block of memory in VRAM to a word value .
// Sets num words  to a value to the memory block pointed to by destination in VRAM.
// - vbank: Which 64K VRAM bank to put data into (0/1)
// - vdest: The destination address in VRAM
// - data: The value to set the vram with.
// - num: The number of bytes to set
void memset_vram_word(char vbank, void* vdest, unsigned int data, unsigned long num ) {
    // Select DATA0
    *VERA_CTRL &= ~VERA_ADDRSEL;
    // Set address
    *VERA_ADDRX_L = <vdest;
    *VERA_ADDRX_M = >vdest;
    *VERA_ADDRX_H = VERA_INC_1 | vbank;
    // Transfer the data
    for(unsigned long i = 0; i<num; i++) {
        *VERA_DATA0 = <data;
        *VERA_DATA0 = >data;
    }
}

// Copy block of memory (from VRAM to VRAM)
// Copies the values from the location pointed by src to the location pointed by dest.
// The method uses the VERA access ports 0 and 1 to copy data from and to in VRAM.
// - src_bank:  64K VRAM bank number to copy from (0/1).
// - src: pointer to the location to copy from. Note that the address is a 16 bit value!
// - src_increment: the increment indicator, VERA needs this because addressing increment is automated by VERA at each access.
// - dest_bank:  64K VRAM bank number to copy to (0/1).
// - dest: pointer to the location to copy to. Note that the address is a 16 bit value!
// - dest_increment: the increment indicator, VERA needs this because addressing increment is automated by VERA at each access.
// - num: The number of bytes to copy
void memcpy_in_vram(char dest_bank, void *dest, char dest_increment, char src_bank, void *src, char src_increment, unsigned int num ) {
    // Select DATA0
    *VERA_CTRL &= ~VERA_ADDRSEL;
    // Set address
    *VERA_ADDRX_L = <src;
    *VERA_ADDRX_M = >src;
    *VERA_ADDRX_H = src_increment | src_bank;

    // Select DATA1
    *VERA_CTRL |= VERA_ADDRSEL;
    // Set address
    *VERA_ADDRX_L = <dest;
    *VERA_ADDRX_M = >dest;
    *VERA_ADDRX_H = dest_increment | dest_bank;

    // Transfer the data
    for(unsigned int i=0; i<num; i++) {
        *VERA_DATA1 = *VERA_DATA0;
        }
}

