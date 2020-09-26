// Functions for using the F018 DMA for very fast copying or filling of memory
#include <mega65.h>

// Copy a memory block within the first 64K memory space using MEGA65 DMagic DMA
// Copies the values of num bytes from the location pointed to by source directly to the memory block pointed to by destination.
// - dest The destination address (within the MB and bank)
// - src The source address (within the MB and bank)
// - num The number of bytes to copy
void memcpy_dma(void* dest, void* src, unsigned int num);

// Copy a memory block anywhere in first 4MB memory space using MEGA65 DMagic DMA
// Copies the values of num bytes from the location pointed to by source directly to the memory block pointed to by destination.
// - dest_bank The 64KB bank for the destination (0-63)
// - dest The destination address (within the MB and bank)
// - src_bank The 64KB bank for the source (0-63)
// - src The source address (within the MB and bank)
// - num The number of bytes to copy
void memcpy_dma4(char dest_bank, void* dest, char src_bank, void* src, unsigned int num);

// Copy a memory block anywhere in the entire 256MB memory space using MEGA65 DMagic DMA
// Copies the values of num bytes from the location pointed to by source directly to the memory block pointed to by destination.
// - dest_mb The MB value for the destination (0-255)
// - dest_bank The 64KB bank for the destination (0-15)
// - dest The destination address (within the MB and bank)
// - src_mb The MB value for the source (0-255)
// - src_bank The 64KB bank for the source (0-15)
// - src The source address (within the MB and bank)
// - num The number of bytes to copy
void memcpy_dma256(char dest_mb, char dest_bank, void* dest, char src_mb, char src_bank, void* src, unsigned int num);