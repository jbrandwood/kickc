// Nintendo Entertainment System (NES
// https://en.wikipedia.org/wiki/Nintendo_Entertainment_System_(Model_NES-101)
// https://github.com/gregkrsak/first_nes
#include <nes.h>

// Disable audio output
inline void disableAudioOutput() {
    // Disable APU frame IRQ
    *FR_COUNTER = 0b01000000;
    // Disable digital sound IRQs
    APU->DMC_FREQ  = 0b01000000;
}

// Disable video output. This will cause a black screen and disable vblank.
inline void disableVideoOutput() {
    // Disable vertical blank interrupt
    PPU->PPUCTRL = 0;
    // Disable sprite rendering
    PPU->PPUMASK = 0;
}

// Enable video output. This will enable vblank.
inline void enableVideoOutput() {
    // Enable vertical blank interrupt
    PPU->PPUCTRL = 0b10000000;
    // Enable sprite and tile rendering
    PPU->PPUMASK = 0b00011110;
}

// Wait for vblank to start
inline void waitForVBlank() {
    while(!(PPU->PPUSTATUS&0x80)) { }
}

// Clear the vblank flag
inline void clearVBlankFlag() {
    asm { lda PPU_PPUSTATUS }
}

// Initialize the NES after a RESET.
// Clears the memory and sets up the stack
// Note: Calling this will destroy the stack, so it only works if called directly inside the reset routine.  
inline void initNES() {
    // Initialize decimal-mode and stack
    asm {
        cld
        ldx #$ff
        txs
    }
    // Initialize the video & audio
    disableVideoOutput();
    disableAudioOutput();
    // Note: When the system is first turned on or reset, the PPU may not be in a usable state right
    // away. You should wait at least 30,000 (thirty thousand) CPU cycles for the PPU to initialize,
    // which may be accomplished by waiting for 2 (two) vertical blank intervals.
    clearVBlankFlag();
    waitForVBlank();
    // Clear RAM - since it has all variables and the stack it is necessary to do it inline
    char i=0;
    do {
        (MEMORY+0x000)[i] = 0;
        (MEMORY+0x100)[i] = 0;
        (MEMORY+0x200)[i] = 0;
        (MEMORY+0x300)[i] = 0;
        (MEMORY+0x400)[i] = 0;
        (MEMORY+0x500)[i] = 0;
        (MEMORY+0x600)[i] = 0;
        (MEMORY+0x700)[i] = 0;
    } while (++i);
    waitForVBlank();
    // Now the PPU is ready.

    // Reset the high/low latch to "high"
    asm { lda PPU_PPUSTATUS }

}

// DMA transfer the entire sprite buffer to the PPU
// - The Sprite OAM buffer to transfer (must be aligned to $100 in memory)
inline void ppuSpriteBufferDmaTransfer(struct SpriteData* spriteBuffer) {
    // Set OAM start address to sprite#0
    PPU->OAMADDR = 0;
    // Set the high byte (02) of the RAM address and start the DMA transfer to OAM memory
    APU->OAMDMA = >spriteBuffer;
}

// Read Standard Controller #1
// Returns a byte representing the pushed buttons
// - bit 0: right
// - bit 1: left
// - bit 2: down
// - bit 3: up
// - bit 4: start
// - bit 5: select
// - bit 6: B
// - bit 7: A
char readJoy1() {
    // Latch the controller buttons
    APU->JOY1 = 1;
    APU->JOY1 = 0;
    char joy = 0;
    for(char i=0;i<8;i++)
        joy = joy<<1 | APU->JOY1&1;
    return joy;
}

// Prepare for transferring data to/from the CPU to the PPU
// - ppuData : Pointer in the PPU memory
inline void ppuDataPrepare(void* const ppuData) {
    // Write the high byte of PPU address
    PPU->PPUADDR = >ppuData;
    // Write the low byte of PPU  address
    PPU->PPUADDR = <ppuData;
}

// Put one byte into PPU memory
// The byte is put into the current PPU address pointed to by the (auto-incrementing) PPU->PPUADDR
inline void ppuDataPut(char val) {
    // Transfer to PPU
    PPU->PPUDATA = val;
}

// Read one byte from the PPU memory
// Note: Reading from the PPU works in a somewhat un-intuitive way.
// The read operation returns the current contents of the read-buffer and then fills the buffer from the current
// PPU->PPUADDR, which is also auto-incremented.
// This means the value returned is from the previous read address.
// If you want to get the value at PPU->PPUADDR you must call read twice.
inline char ppuDataRead() {
    // Transfer from PPU
    return PPU->PPUDATA;
}

// Fill a number of bytes in the PPU memory
// - ppuData : Pointer in the PPU memory
// - size : The number of bytes to transfer
void ppuDataFill(void* const ppuData, char val, unsigned int size) {
    ppuDataPrepare(ppuData);
    // Transfer to PPU
    for(unsigned int i=0;i<size;i++)
        ppuDataPut(val);
}

// Transfer a number of bytes from the CPU memory to the PPU memory
// - cpuData : Pointer to the CPU memory (RAM of ROM)
// - ppuData : Pointer in the PPU memory
// - size : The number of bytes to transfer
void ppuDataTransfer(void* const ppuData, void* const cpuData, unsigned int size) {
    ppuDataPrepare(ppuData);
    // Transfer to PPU
    char* cpuSrc = (char*)cpuData;
    for(unsigned int i=0;i<size;i++)
        ppuDataPut(*cpuSrc++);
}

// Transfer a number of bytes from the PPU memory to the CPU memory
// - ppuData : Pointer in the PPU memory
// - cpuData : Pointer to the CPU memory (RAM of ROM)
// - size : The number of bytes to transfer
void ppuDataFetch(void* const cpuData, void* const ppuData, unsigned int size) {
    ppuDataPrepare(ppuData);
    // Perform a dummy-read to discard the current value in the data read buffer and update it with the first byte from the PPU address
    asm { lda PPU_PPUDATA }
    // Fetch from PPU to CPU
    char* cpuDst = (char*)cpuData;
    for(unsigned int i=0;i<size;i++)
        *cpuDst++ = ppuDataRead();
}

// Transfer a 2x2 tile into the PPU memory
// - ppuData : Pointer in the PPU memory
// - tile : The tile to transfer
void ppuDataPutTile(void* const ppuData, char* tile) {
    ppuDataPrepare(ppuData);
    ppuDataPut(tile[0]);
    ppuDataPut(tile[1]);
    ppuDataPrepare((char*)ppuData+32);
    ppuDataPut(tile[2]);
    ppuDataPut(tile[3]);
}

// Set one byte in PPU memory
// - ppuData : Pointer in the PPU memory
// - val : The value to set
void ppuDataSet(void* const ppuData, char val) {
    ppuDataPrepare(ppuData);
    ppuDataPut(val);
}

// Get one byte from PPU memory
// - ppuData : Pointer in the PPU memory
char ppuDataGet(void* const ppuData) {
    ppuDataPrepare(ppuData);
    // Perform a dummy-read to discard the current value in the data read buffer and update it with the byte we want
    asm { lda PPU_PPUDATA }
    // Get the data we want out of the buffer (this unfortunately performs a second increment of the pointer)
    return ppuDataRead();
}