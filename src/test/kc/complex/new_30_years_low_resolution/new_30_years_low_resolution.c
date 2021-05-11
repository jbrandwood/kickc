// The Demo collects the parts and handles overall control

#pragma target(c64)
#pragma link("demo.ld")
#pragma zp_reserve(0xfa..0xfb) // Reserved for music player
#pragma interrupt(hardware_clobber) 
#pragma emulator("C64Debugger")
    
#include <c64.h>
#include <6502.h>

#include <string.h>
#include "demo.h"
#include "byteboozer.h"
#include "part1-happynewyear.c"
#include "part2-swingplex.c"

#pragma code_seg(Code)
#pragma data_seg(Data)

char* const DEMO_MUSIC = (char*)0xAC00;
// Pointer to the music init routine
void()* const musicInit = (void()*) DEMO_MUSIC;
// Pointer to the music play routine
void()* const musicPlay = (void()*) DEMO_MUSIC+3;

#pragma data_seg(InitDemo)

// SID tune
char DEMO_MUSIC_CRUNCHED[] = kickasm(resource "do-it-again-$AC00-$FA-8580.sid", uses DEMO_MUSIC) {{
    .modify B2() {
        .pc = DEMO_MUSIC "MUSIC"
        .const music = LoadSid("do-it-again-$AC00-$FA-8580.sid")
        .fill music.size, music.getData(i)
    }
}};

#pragma data_seg(Data)

void main() {
    // Initialize the demo - start the IRQ
    demo_init();
    // Decrunch music
    byteboozer_decrunch(DEMO_MUSIC_CRUNCHED);
    // Init music
    asm { lda #0 }
    (*musicInit)();
    // Initialize the demo - start the IRQ
    demo_start();
    // Initialize Part 1 (Revealing "Happy New Year" logo)
    part1_init();
    // Start part 1 at 0:04,5
    while(demo_frame_count<5*50) ;
    // Run Part 1 (Revealing "Happy New Year" logo)
    part1_run();
    // Initialize part 2
    part2_init();
    // Wait for the right place to start part 2
    while(demo_frame_count<16*50) ;   
    // Disable sparkler
    sparkler_active = 0;
    // Run part 2
    part2_run();

    for(;;) ;

}

// Initialize demo code. 
// Can be called multiple times!
// Setting IRQ to the "demo" IRQ running outside the parts and 
// Setting memory to IO + RAM (no kernal/basic)
void demo_init() {
    SEI();
    // Disable kernal & basic
    *PROCPORT_DDR = PROCPORT_DDR_MEMORY_MASK;
    *PROCPORT = PROCPORT_RAM_IO;
    // Disable CIA 1 Timer IRQ
    CIA1->INTERRUPT = CIA_INTERRUPT_CLEAR;
    // Acknowledge any timer IRQ
    asm { lda CIA1_INTERRUPT }
    // Acknowledge any VIC IRQ
    *IRQ_STATUS = 0x0f;
}

// Start the demo IRQ. Can be called multiple times!
// Setting IRQ to the "demo" IRQ running outside the parts and 
// Setting memory to IO + RAM (no kernal/basic)
void demo_start() {
    demo_init();
    // Set raster line to 0x00
    *VICII_CONTROL1 &= 0x7f;
    *RASTER = 0;
    // Set the IRQ routine
    *HARDWARE_IRQ = &irq_demo;
    // Enable Raster Interrupt
    *IRQ_ENABLE = IRQ_RASTER;
    CLI();
}

// Counts total demo frames
volatile unsigned int demo_frame_count = 0;

// Work to be performed every frame while the demo runs
// Assumes that I/O is enabled
void demo_work() {
    // Increase frame count
    demo_frame_count++;
    // Play music
    (*musicPlay)();
    // Animate the sparkler
    if(sparkler_active)
        sparkler_anim();
}

// Is the sparkler active
volatile char sparkler_active = 0;

// The sparkler sprite idx
volatile char sparkler_idx = 0;

// Animate the sparkler sprite
void sparkler_anim() {
    if(++sparkler_idx==30) sparkler_idx=0;
    P1_SCREEN_SPRITE_PTRS[0] = toSpritePtr(P1_SPRITES)+sparkler_idx/2;
}

// IRQ running during between parts
__interrupt void irq_demo() {
    // Remember processor port value
    *PROCPORT_DDR = PROCPORT_DDR_MEMORY_MASK;
    char port_value = *PROCPORT;
    // Enable IO
    *PROCPORT_DDR = PROCPORT_DDR_MEMORY_MASK;
    *PROCPORT = PROCPORT_RAM_IO;
    // Perform any demo work
    demo_work();
    // Acknowledge the IRQ
    *IRQ_STATUS = IRQ_RASTER;    
    // Restore processor port value
    *PROCPORT_DDR = PROCPORT_DDR_MEMORY_MASK;
    *PROCPORT = port_value;
}