/// @file
/// Nintendo Entertainment System (NES
/// https://en.wikipedia.org/wiki/Nintendo_Entertainment_System_(Model_NES-101)
/// https://github.com/gregkrsak/first_nes
#ifndef __NES__
#error "Target platform must be NES"
#endif
#include <ricoh_2c02.h>
#include <ricoh_2a03.h>

/// NES Picture Processing Unit (PPU)
struct RICOH_2C02 * PPU = (struct RICOH_2C02 *)0x2000;

/// NES CPU and audion processing unit (APU)
struct RICOH_2A03 * APU = (struct RICOH_2A03 *)0x4000;

/// Pointer to the start of RAM memory
char * const MEMORY = (char *)0;

/// Sprite Object Attribute Memory Structure
/// The memory layout of a sprite in the PPU's OAM memory
struct SpriteData {
    char y;
    char tile;
    char attributes;
    char x;
};

/// DMA transfer a complete sprite memory buffer to the PPU
/// - The Sprite OAM buffer to transfer (must be aligned to $100 in memory)
void ppuSpriteBufferDmaTransfer(struct SpriteData* spriteBuffer);

/// Disable audio output
void disableAudioOutput();

/// Disable video output. This will cause a black screen and disable vblank.
void disableVideoOutput();

/// Enable video output. This will enable vblank.
void enableVideoOutput();

/// Wait for vblank to start
void waitForVBlank();

/// Clear the vblank flag
void clearVBlankFlag();

/// Initialize the NES after a RESET.
/// Clears the memory and sets up the stack
/// Note: Calling this will destroy the stack, so it only works if called directly inside the reset routine.
void initNES();

/// Read Standard Controller #1
/// Returns a byte representing the pushed buttons
/// - bit 0: right
/// - bit 1: left
/// - bit 2: down
/// - bit 3: up
/// - bit 4: start
/// - bit 5: select
/// - bit 6: B
/// - bit 7: A
char readJoy1();

/// Standard Controller Right Button
const char JOY_RIGHT =  0b00000001;
/// Standard Controller Left Button
const char JOY_LEFT =   0b00000010;
/// Standard Controller Down Button
const char JOY_DOWN =   0b00000100;
/// Standard Controller Up Button
const char JOY_UP =     0b00001000;
/// Standard Controller Start Button
const char JOY_START =  0b00010000;
/// Standard Controller Select Button
const char JOY_SELECT = 0b00100000;
/// Standard Controller B Button
const char JOY_B =      0b01000000;
/// Standard Controller A Button
const char JOY_A =      0b10000000;

/// Prepare for transferring data from the CPU to the PPU
/// - ppuData : Pointer in the PPU memory
void ppuDataPrepare(void* const ppuData);

/// Put one byte into PPU memory
/// The byte is put into the current PPU address pointed to by the (autoincrementing) PPU->PPUADDR
void ppuDataPut(char val);

/// Read one byte from PPU memory
/// The byte is read from the current PPU address pointed to by the (autoincrementing) PPU->PPUADDR
char ppuDataRead();

/// Fill a number of bytes in the PPU memory
/// - ppuData : Pointer in the PPU memory
/// - size : The number of bytes to transfer
void ppuDataFill(void* const ppuData, char val, unsigned int size);

/// Transfer a number of bytes from the CPU memory to the PPU memory
/// - ppuData : Pointer in the PPU memory
/// - cpuData : Pointer to the CPU memory (RAM of ROM)
/// - size : The number of bytes to transfer
void ppuDataTransfer(void* const ppuData, void* const cpuData, unsigned int size);

/// Transfer a number of bytes from the PPU memory to the CPU memory
/// - cpuData : Pointer to the CPU memory (RAM of ROM)
/// - ppuData : Pointer in the PPU memory
/// - size : The number of bytes to transfer
void ppuDataFetch(void* const cpuData, void* const ppuData, unsigned int size);

/// Transfer a 2x2 tile into the PPU memory
/// - ppuData : Pointer in the PPU memory
/// - tile : The tile to transfer
void ppuDataPutTile(void* const ppuData, char* tile);

/// Set one byte in PPU memory
/// - ppuData : Pointer in the PPU memory
/// - val : The value to set
void ppuDataSet(void* const ppuData, char val);

/// Get one byte from PPU memory
/// - ppuData : Pointer in the PPU memory
char ppuDataGet(void* const ppuData);
