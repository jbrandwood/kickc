// Camelot Borderline Entry
// Pacman made with 9 sprites in in the borders

// The level is constructed from tiles that are 2MC-pixels * 4 lines of rendered graphics.
// Coordinate systems used in the code
// x_col: X column. Each X-column is 1 byte of data wide. This represents 4 MC pixels. Values [0-24].
// x_tile: X tile. Each X-tile is 4 bits of data wide. This represents 2 MC pixels. Values [0-49]. x_tile = 2*x_col 
// x_fine: X fine. Each x-fine is 2 bits of data wide. This represents a single MC pixel. Values [0-99]. x_fine = 2*x_tile = 4*x_col
// x_pos: X position. Each x-position is 2 bits of data wide. This represents a single MC pixel. Values [0-99]. x_pos = x_fine
// y_tile: Y tile. Each Y-tile is 4 rendered lines of graphics high. Values [0-36].
// y_fine: Y fine. Each Y-fine is 2 rendered lines of graphics high. Values [0-74]. y_fine = 2*y_tile
// y_pos: Y position. Each Y-position is 1 rendered lines of graphics high. Values [0-149]. y_pos = 2*y_fine = 4*y_tile

// A level is 50 * 37 tiles large. The first 2 rendered lines are not shown. Since 9 sprites are utilized every second line is empty/black.
// The level covers 400px * 292px on the screen, which is the entire visible area on screen showing most pixels - except 2-8 pixels on the x-axis depending on which article you trust.

#pragma target(c64)
#pragma link("pacman.ld")
#pragma start_address(0x0810)
#pragma interrupt(hardware_clobber)
#pragma emulator("C64Debugger")
#include <c64.h>
#include <6502.h>
#include <string.h>
#include "byteboozer.h"
#include "code-merger.c"
#include "pacman-sounds.c"

// Graphics Bank 1
// Address of the sprites
char * const BANK_1 = (char*)0x4000;
// Address of the sprites
char * const SPRITES_1 = (char*)0x6000;
// Use sprite pointers on all screens (0x43f8, 0x47f8, ...)
char * const SCREENS_1  = (char*)0x4000;
// Graphics Bank 2
// Address of the sprites
char * const BANK_2 = (char*)0xc000;
// Address of the sprites
char * const SPRITES_2 = (char*)0xe000;
// Use sprite pointers on all screens (0x43f8, 0x47f8, ...)
char * const SCREENS_2  = (char*)0xc000;

// The location where the logic code will be located before merging
char * const LOGIC_CODE_UNMERGED = (char*)0xe000;
// The location where the screen raster code will be located before merging
char * const RASTER_CODE_UNMERGED = (char*)0x6000;
// The location where the screen raster code will be located when running
char * const RASTER_CODE = (char*)0x8000;

// Address of the (decrunched) splash screen
char * const SPLASH = (char*)0x4000;
// Address for the victory graphics
char * const WIN_GFX = (char*)0xa700;
// Address for the gameover graphics
char * const GAMEOVER_GFX = (char*)0xa700;

// Address used by (decrunched) tiles
char * const LEVEL_TILES = (char*)0x4800;
char * const TILES_LEFT = LEVEL_TILES+0x0a00;
char * const TILES_RIGHT = LEVEL_TILES+0x0a80;
char * const TILES_TYPE = LEVEL_TILES+0x0b00;

// The different tile types in TILES_TYPE
enum TILE_TYPE {
    EMPTY=0,
    PILL=1,
    POWERUP=2,
    WALL=4
};

// Address used for table containing available directions for all tiles
// TABLE LEVEL_TILES_DIRECTIONS[64*37]
// The level data is organized as 37 rows of 64 bytes. Each row is 50 bytes containing DIRECTION bits plus 14 unused bytes to achieve 64-byte alignment.
char * const LEVEL_TILES_DIRECTIONS = (char*)0x3e00;

// Address of the (decrunched) splash screen
const char BOB_ROW_SIZE = 0x80;
char * const BOB_MASK_LEFT = (char*)0x5400;
char * const BOB_MASK_RIGT = BOB_MASK_LEFT+BOB_ROW_SIZE*6;
char * const BOB_PIXEL_LEFT = BOB_MASK_LEFT+BOB_ROW_SIZE*12;
char * const BOB_PIXEL_RIGT = BOB_MASK_LEFT+BOB_ROW_SIZE*18;

// Tables pointing to the graphics.
// Each page represents one X column (1 byte wide, 4 MC pixels)
// On each page:
// - 0xNN00-0xNN4A : low-byte of the graphics for (X-column, Y-fine)
// - 0xNN50-0xNN9A : high-byte of the graphics for (X-column, Y-fine)
// - 0xNNA0-0xNNEA : index into RENDER_YPOS_INC for incrementing the y-pos.
char * const RENDER_INDEX = (char*)0xb600;

#include "pacman-render.c"
#include "pacman-logic-data.c"

// Sprite settings used for the top/side/bottom sprites. 
// Used for achieving single-color sprites on the splash and multi-color sprites in the game
volatile char top_sprites_color;
volatile char top_sprites_mc;
volatile char side_sprites_color;
volatile char side_sprites_mc;
volatile char bottom_sprites_color;
volatile char bottom_sprites_mc;

#pragma data_seg(Init)
#include "pacman-tiles.c"
#include "pacman-bobs.c"
#include "pacman-splash.c"
#include "pacman-win.c"
#include "pacman-gameover.c"
#include "pacman-logic-code.c"
#include "pacman-raster-code.c"
#pragma data_seg(Data)

// Upper memory location used during decrunching
char * const INTRO_MUSIC_CRUNCHED_UPPER = (char*)0xa700;
// Size of the crunched music
const unsigned int INTRO_MUSIC_CRUNCHED_SIZE = 0x0600;

// Address of the music during run-time
char* const INTRO_MUSIC = (char*)0x3000;
// Pointer to procedure
typedef void (*PROC_PTR)(void);
// Pointer to the music init routine
PROC_PTR const musicInit = (PROC_PTR) INTRO_MUSIC+0x00;
// Pointer to the music play routine
PROC_PTR const musicPlay = (PROC_PTR) INTRO_MUSIC+0x06;

#pragma data_seg(Init)
// SID tune
// Pacman 2 channel music by Metal/Camelot
char INTRO_MUSIC_CRUNCHED[] = kickasm(resource "pacman-2chn-simpler.prg", uses INTRO_MUSIC) {{
    .modify B2() {
        .pc = INTRO_MUSIC "INTRO MUSIC"
        .const music = LoadBinary("pacman-2chn-simpler.prg", BF_C64FILE)
        .fill music.getSize(), music.get(i)
    }
}};
#pragma data_seg(Data)

void main() {
    // Show the splash screen
    splash_run();
    for(;;) {
        // Run the gameplay
        gameplay_run();
        // Show victory or game over image
        done_run();
    }
}

// Show Victory or Game Over Image 
// Returns when the user clicks the joystick button
void done_run() {
    // Stop the game play
    game_playable = 0;
    // Set phase to intro
    phase = 0;
    // Stop any sound
    for(char i=0;i<0x2f;i++) 
        ((char*)SID)[i] = 0;
    // Move the bobs to the center to avoid interference while rendering the level
    for(char i=0;i<4;i++) {
        bobs_xcol[i] = 10;
        bobs_yfine[i] = 45;
        bobs_bob_id[i] = 0;
    }
    // Init music
    asm { lda #0 }
    (*musicInit)();
    if(pacman_wins) {
        // decrunch win graphics 
        byteboozer_decrunch(WIN_GFX_CRUNCHED); 
    } else {
        // decrunch game over graphics 
        byteboozer_decrunch(GAMEOVER_GFX_CRUNCHED); 
    }
    // Show the win graphics
    char * gfx = WIN_GFX;
    for(char xcol=0;xcol<25;xcol++) {
        for(char ypos=0;ypos<25;ypos++) {
            // Render 8px x 1px
            char pixels = *gfx++;
            render(xcol, ypos, pixels);
        }
    }

    // Wait for fire
    music_play_next = 0;
    while(!joyfire()) {
        // While playing music
        if(music_play_next) {
            //VICII->BG_COLOR=1;
            (*musicPlay)();
            //VICII->BG_COLOR=0;
            music_play_next = 0;
        }            
    }   

}

// Initializes all data for the splash and shows the splash.
// Returns when the splash is complete and the user clicks the joystidk #2 button
void splash_run() {
    // Stop kernel IRQ
    SEI();
    // Disable CIA 1 Timer IRQ
    CIA1->INTERRUPT = CIA_INTERRUPT_CLEAR;
    // Disable kernal & basic & IO
    *PROCPORT_DDR = PROCPORT_DDR_MEMORY_MASK;
    *PROCPORT = PROCPORT_RAM_ALL;
    // Reset memory to avoid crashes
    memset((char*)0x4000, 0, 0xc00);
    // Decrunch raster code
    byteboozer_decrunch(RASTER_CODE_CRUNCHED);
    // Decrunch logic code
    byteboozer_decrunch(LOGIC_CODE_CRUNCHED);
    // Merge the raster with the logic-code
    merge_code(RASTER_CODE, RASTER_CODE_UNMERGED, LOGIC_CODE_UNMERGED);
    // Clear the graphics banks
    memset(BANK_1+0x2000, 0x00, 0x1fff);
    memset(BANK_2, 0x00, 0x3fff);
    // Initialize the renderer tables
    init_render_index();
    // decrunch splash screen 
    byteboozer_decrunch(SPLASH_CRUNCHED); 
    // Show the splash screen
    splash_show();
    // Clear the graphics bank
    memset(BANK_1, 0x00, 0x1fff);
    // Initialize bobs_restore to "safe" values
    init_bobs_restore();
    // decrunch bobs graphics tables 
    byteboozer_decrunch(BOB_GRAPHICS_CRUNCHED); 
    // Set sprite pointers on all screens (in both graphics banks)
    init_sprite_pointers();
    // Move the crunched music to upper memory before decrunching it
    memcpy(INTRO_MUSIC_CRUNCHED_UPPER, INTRO_MUSIC_CRUNCHED, INTRO_MUSIC_CRUNCHED_SIZE);
    // zero-fill the entire Init segment
    //memset(LEVEL_TILES_CRUNCHED, 0, INTRO_MUSIC_CRUNCHED+INTRO_MUSIC_CRUNCHED_SIZE-LEVEL_TILES_CRUNCHED);
    // decrunch intro music
    byteboozer_decrunch(INTRO_MUSIC_CRUNCHED_UPPER);
    // Zero-fill the upper memory
    memset(INTRO_MUSIC_CRUNCHED_UPPER, 0, INTRO_MUSIC_CRUNCHED_SIZE);

    // Disable kernal & basic - enable IO
    *PROCPORT_DDR = PROCPORT_DDR_MEMORY_MASK;
    *PROCPORT = PROCPORT_RAM_IO;

    // Sprite positions
    unsigned int sprites_xpos[] = { 0x1e7, 0x13f, 0x10f, 0x0df, 0x0af, 0x07f, 0x04f, 0x01f } ;
    char msb = 0;
    for(char i=0;i<8;i++) {
        SPRITES_YPOS[i*2] = 7;
        unsigned int xpos = sprites_xpos[i];
        SPRITES_XPOS[i*2] = (char)xpos;
        msb /= 2;
        if(BYTE1(xpos)) msb |=0x80;
    }

    // Set initial graphics bank
    CIA2->PORT_A = toDd00(SCREENS_1);
    // Set initial render/restore buffer
    canvas_base_hi = BYTE1(SPRITES_2);
    bobs_restore_base = NUM_BOBS*SIZE_BOB_RESTORE;

    // Select first screen
    VICII->MEMORY = toD018(SCREENS_1, SCREENS_1);

    VICII->SPRITES_XMSB = msb;    
    VICII->SPRITES_ENABLE = 0xff;
    VICII->SPRITES_EXPAND_X = 0xff;
    VICII->BORDER_COLOR = BLACK;
    VICII->BG_COLOR = BLACK;

    VICII->SPRITES_MCOLOR1 = BLUE;
    VICII->SPRITES_MCOLOR2 = RED;

    // On the splash screen sprites all sprites are SC - except sprite #0,1 on the top/bottom of the screen
    top_sprites_mc = 0x03;
    side_sprites_mc = 0x00;
    bottom_sprites_mc = 0x03;;
    // On the splash top/bottom sc-sprites are yellow and side-sprites are blue
    top_sprites_color = YELLOW;
    side_sprites_color = BLUE;
    bottom_sprites_color = YELLOW;

    // Set the initial top colors/MC
    VICII->SPRITES_MC = top_sprites_mc;
    // Set initial Sprite Color
    for(char i=0;i<8;i++)
        SPRITES_COLOR[i] = top_sprites_color;

    // Set VICII CONTROL2 ($d016) to 8 to allow ASL, LSR to be used for opening the border
    VICII->CONTROL2 = 0x08;

    // Move the bobs to the center to avoid interference while rendering the level
    for(char i=0;i<4;i++) {
        bobs_xcol[i] = 10;
        bobs_yfine[i] = 45;
        bobs_bob_id[i] = 0;
    }
    
    // Disable SID CH#3
    asm { 
        lda #1
        sta INTRO_MUSIC+$69
        }
    // Init music
    asm { lda #0 }
    (*musicInit)();

    // Set phase to intro
    phase = 0;

    // Start a hyperscreen with no badlines and open borders
    // Set screen height to 25 lines (preparing for the hyperscreen), enable display
    // Set an illegal mode to prevent any character graphics
    VICII->CONTROL1 = VICII_RSEL|VICII_DEN|VICII_ECM|VICII_BMM;
    // Wait for line 0xfa (lower border)
    while(VICII->RASTER!=0xfa) ;
    // Open lower/upper border using RSEL - and disable all graphics (except sprites)
    // Set up RASTER IRQ to start at irq_screen_top() (RST8=0)
    VICII->CONTROL1 &= ~(VICII_RST8|VICII_RSEL|VICII_DEN) ;
    VICII->RASTER = IRQ_SCREEN_TOP_LINE;
    *HARDWARE_IRQ = &irq_screen_top;
    // Enable Raster Interrupt
    VICII->IRQ_ENABLE = IRQ_RASTER;
    // Acknowledge any timer IRQ
    asm { lda CIA1_INTERRUPT }
    // Acknowledge any VIC IRQ
    *IRQ_STATUS = 0x0f;
    // Start the IRQ again
    CLI();

    // Prepare for joystick control
    joyinit();

    // Wait for fire
    music_play_next = 0;
    while(!joyfire()) {
        // While playing music
        if(music_play_next) {
            //VICII->BG_COLOR=1;
            (*musicPlay)();
            //VICII->BG_COLOR=0;
            music_play_next = 0;
        }            
    }   
}

// Initialize all data for gameplay and runs the game. 
// Exits when the user has won or lost
void gameplay_run() {

    // Turn off raster during transition
    SEI();

    // Stop any sound
    for(char i=0;i<0x2f;i++) 
        ((char*)SID)[i] = 0;

    // Pacman has not won yet
    pacman_wins = 0;
    // Pacman has 3 lives
    pacman_lives = 3;

    // During transition all sprites are black
    VICII->SPRITES_MCOLOR1 = BLACK;
    VICII->SPRITES_MCOLOR2 = BLACK;
    for(char i=0;i<8;i++)
        SPRITES_COLOR[i] = BLACK;

    // decrunch level tiles 
    byteboozer_decrunch(LEVEL_TILES_CRUNCHED);         
    // Initialize tile directions
    init_level_tile_directions();
    // Set sprite pointers on all screens (in both graphics banks)
    init_sprite_pointers();

    // Show the level
    pill_count = level_show();

    // During gameplay all sprites are MC.
    top_sprites_mc = 0xff;
    side_sprites_mc = 0xff;
    bottom_sprites_mc = 0xff;
    // During gameplay all sprites are yellow
    top_sprites_color = YELLOW;
    side_sprites_color = YELLOW;
    bottom_sprites_color = YELLOW;
    // Set the initial top colors/MC
    VICII->SPRITES_MC = top_sprites_mc;
    // Set initial Sprite Color
    for(char i=0;i<8;i++)
        SPRITES_COLOR[i] = top_sprites_color;
    // Set sprite MC-colors for the game
    VICII->SPRITES_MCOLOR1 = BLUE;
    VICII->SPRITES_MCOLOR2 = RED;

    // Set phase to game
    phase = 1;
    // Spawn pacman and all ghosts
    spawn_all();
    // Initialize the game sound
    pacman_sound_init();
    // Start the game play
    game_playable = 1;

    // Turn on raster after transition
    // Start a hyperscreen with no badlines and open borders
    // Set screen height to 25 lines (preparing for the hyperscreen), enable display
    VICII->CONTROL1 = VICII_RSEL|VICII_DEN|VICII_ECM|VICII_BMM;
    // Wait at least one frames for DEN to take effect
    while(VICII->RASTER!=0xfb) ;
    while(VICII->RASTER!=0xfa) ;
    // Open lower/upper border using RSEL - and disable all graphics (except sprites)
    // Set up RASTER IRQ to start at irq_screen_top() (RST8=0)
    VICII->CONTROL1 &= ~(VICII_RST8|VICII_RSEL|VICII_DEN) ;
    VICII->RASTER = IRQ_SCREEN_TOP_LINE;
    *HARDWARE_IRQ = &irq_screen_top;
    // Enable Raster Interrupt
    VICII->IRQ_ENABLE = IRQ_RASTER;
    // Acknowledge any timer IRQ
    asm { lda CIA1_INTERRUPT }
    // Acknowledge any VIC IRQ
    *IRQ_STATUS = 0x0f;
    // Start the IRQ again
    CLI();

    // Wait for the player to wins or looses
    for(;;)
        if(pacman_wins || pacman_lives==0)
            return;

}


// The number of pills left
volatile unsigned int pill_count;

// 1 When pacman wins
volatile char pacman_wins = 0;

// The number of pacman lives left
volatile char pacman_lives = 3;

// Signal for playing th next music frame during the intro
volatile char music_play_next = 0;

// Prepare for joystick control
void joyinit() {
    // Joystick  Read Mode
    CIA1->PORT_A_DDR = 0x00;
}

// Return 1 if joy #2 fire is pressed
char joyfire() {    
    if( (CIA1->PORT_A & 0x10) == 0 ) {
        return 1;
    } else {
        return 0;
    }
}

// Initialize keyboard for reading
void kbinit() {
    // Keyboard Matrix Columns Write Mode
    CIA1->PORT_A_DDR = 0xff;
    // Keyboard Matrix Columns Read Mode
    CIA1->PORT_B_DDR = 0x00;
}

// Return true if there's a key waiting, return false if not
unsigned char kbhit (void) {
    // Write 00 (all columns)
    CIA1->PORT_A = 0;
    // Read 00 (all rows)
    return ~CIA1->PORT_B;
}

// Show the splash screen
void splash_show() {
    // Show splash screen
    char * splash = SPLASH;
    for(char xcol=0;xcol<25;xcol++) {
        for(char ypos=0;ypos<147;ypos++) {
            // Render 8px x 1px
            char pixels = *splash++;
            render(xcol, ypos, pixels);
        }
    }    
}

// Show the level by rendering all tiles
// Returns the number of pills on the level
unsigned int level_show() {
    unsigned int count = 0;
    char * level = LEVEL_TILES;
    for(char ytile=0;ytile<37;ytile++) {
        for(char xcol=0, xtile=0; xcol<25; xcol++) {
            char tile_left = level[xtile++]; 
            if(TILES_TYPE[tile_left]==PILL) count++;           
            char tile_right = level[xtile++];            
            if(TILES_TYPE[tile_right]==PILL) count++;           
            render_tiles(xcol, ytile, tile_left, tile_right);
        }
        level += 0x40;
    }
    return count;
}

// Offset of the LEVEL_TILE data within the LEVEL_TILE data (each row is 64 bytes of data)
unsigned int LEVEL_YTILE_OFFSET[37] = { 
    0x0000, 0x0040, 0x0080, 0x00c0, 
    0x0100, 0x0140, 0x0180, 0x01c0, 
    0x0200, 0x0240, 0x0280, 0x02c0, 
    0x0300, 0x0340, 0x0380, 0x03c0, 
    0x0400, 0x0440, 0x0480, 0x04c0, 
    0x0500, 0x0540, 0x0580, 0x05c0, 
    0x0600, 0x0640, 0x0680, 0x06c0, 
    0x0700, 0x0740, 0x0780, 0x07c0, 
    0x0800, 0x0840, 0x0880, 0x08c0, 
    0x0900
}; 

// Get the level tile at a given (xtile, ytile) position
// Returns the TILE ID
// If xtile of ytile is outside the legal range the empty tile (0) is returned
char level_tile_get(char xtile, char ytile) {
    if(xtile>49 || ytile>36) return 0;
    char* ytiles = LEVEL_TILES + LEVEL_YTILE_OFFSET[ytile];
    return ytiles[xtile];
}

// Get the open directions at a given (xtile, ytile) position
// Returns the open DIRECTIONs as bits
// If xtile of ytile is outside the legal range the empty tile (0) is returned
char level_tile_directions(char xtile, char ytile) {
    if(xtile>49 || ytile>36) return 0;
    char* ytiles = LEVEL_TILES_DIRECTIONS + LEVEL_YTILE_OFFSET[ytile];
    return ytiles[xtile];
}

// Initialize the LEVEL_TILES_DIRECTIONS table with bits representing all open (non-blocked) movement directions from a tile
void init_level_tile_directions() {
    char * directions = LEVEL_TILES_DIRECTIONS;
    for(char ytile=0;ytile<37;ytile++) {
        for(char xtile=0; xtile<50; xtile++) {
            char open_directions = 0;
            if(TILES_TYPE[level_tile_get(xtile-1, ytile)]!=WALL) open_directions |= LEFT;
            if(TILES_TYPE[level_tile_get(xtile+1, ytile)]!=WALL) open_directions |= RIGHT;
            if(TILES_TYPE[level_tile_get(xtile, ytile-1)]!=WALL) open_directions |= UP;
            if(TILES_TYPE[level_tile_get(xtile, ytile+1)]!=WALL) open_directions |= DOWN;
            directions[xtile] = open_directions;
        }
        directions += 0x40;
    }
}

// Initialize sprite pointers on all screens (in both graphics banks)
void init_sprite_pointers() {
    const char SPRITE_ID_0 = (SPRITES_1&0x3fff)/0x40;
    char sprites_id[] = { 0x00, 0x70, 0x60, 0x50, 0x40, 0x30, 0x20, 0x10 };
    char * sprites_ptr_1 = SCREENS_1+OFFSET_SPRITE_PTRS;
    char * sprites_ptr_2 = SCREENS_2+OFFSET_SPRITE_PTRS;
    for(char screen=0;screen<14;screen++) {
        for(char sprite=0; sprite<8; sprite++) {
            char sprite_id = SPRITE_ID_0 + screen + sprites_id[sprite];
            sprites_ptr_1[sprite] = sprite_id;
            sprites_ptr_2[sprite] = sprite_id;
        }
        sprites_ptr_1 += 0x400;        
        sprites_ptr_2 += 0x400;        
    }
}


// 0: intro, 1: game
volatile char phase = 0;

// The double buffer frame (0=BANK_1, 1=BANK_2)
volatile char frame = 0;

// The raster line for irq_screen_top()
const char IRQ_SCREEN_TOP_LINE = 0x05;

// Interrupt Routine at Screen Top
__interrupt void irq_screen_top() {
    kickasm(uses HARDWARE_IRQ, uses RASTER, uses IRQ_STATUS, uses IRQ_RASTER, uses VICII_CONTROL1, uses VICII_RSEL, uses VICII_MEMORY, clobbers "AX") {{
        // Stabilize the raster by using the double IRQ method
        // Acknowledge the IRQ
        lda #IRQ_RASTER
        sta IRQ_STATUS
        // Set-up IRQ for the next line
        inc RASTER
        // Point IRQ to almost stable code
        lda #<stable
        sta HARDWARE_IRQ
        lda #>stable
        sta HARDWARE_IRQ+1
        tsx       // Save stack pointer
        cli       // Reenable interrupts
        // Wait for new IRQ using NOP's to ensure minimal jitter when it hits
        .fill 15, NOP
        .align $20
    stable:
        txs             // Restore stack pointer
        ldx #9          // Wait till the raster has almost crossed to the next line (48 cycles)
        !: dex
        bne !-
        nop
        lda RASTER
        cmp RASTER
        bne !+          // And correct the last cycle of potential jitter
        !:
        // Raster is now completely stable! (Line 0x007 cycle 7)
    }}
    asm {  
        // Call the screen raster code        
        jsr RASTER_CODE
    }
    // Move sprites back to the top
    VICII->SPRITE0_Y =7;
    VICII->SPRITE1_Y =7;
    VICII->SPRITE2_Y =7;
    VICII->SPRITE3_Y =7;
    VICII->SPRITE4_Y =7;
    VICII->SPRITE5_Y =7;
    VICII->SPRITE6_Y =7;
    VICII->SPRITE7_Y =7;
    // Select first screen (graphics bank not important since layout in the banks is identical)
    VICII->MEMORY = toD018(SCREENS_1, SCREENS_1);

    // Set the top sprites color/MC
    VICII->SPRITES_MC = top_sprites_mc;
    VICII->SPRITE0_COLOR = top_sprites_color;
    VICII->SPRITE1_COLOR = top_sprites_color;

    // Move to next frame
    frame = (frame+1) & 1;
    if(frame) {
        // Change graphics bank
        CIA2->PORT_A = toDd00(SCREENS_2);
        // Set the next canvas base address
        canvas_base_hi = BYTE1(SPRITES_1);
        bobs_restore_base = 0;
    } else {
        // Change graphics bank
        CIA2->PORT_A = toDd00(SCREENS_1);
        // Set the next canvas base address
        canvas_base_hi = BYTE1(SPRITES_2);
        bobs_restore_base = NUM_BOBS*SIZE_BOB_RESTORE;
    }

    if(phase==0) {
        // intro phase
        // Play intro music
        music_play_next = 1;
    } else {
        // Game phase
        // Perform game logic
        game_logic();
        // Play sounds
        pacman_sound_play();
    }

    // Acknowledge the IRQ
    VICII->IRQ_STATUS = IRQ_RASTER;
    // Trigger IRQ at screen top again
    VICII->RASTER = IRQ_SCREEN_TOP_LINE;
    *HARDWARE_IRQ = &irq_screen_top;
}

// Movement directions. 
// Each active direction is also a bit enabling efficient storage of potential directions from a tile
// The directions are also used as indices into the animation frames for the BOBs.
// The directions are also arranged so they match the C64 joystick #2 CIA#1 PORT A bits shifted twice.
enum DIRECTION {
    STOP=0,
    UP=4,
    DOWN=8,
    LEFT=16,
    RIGHT=32
};

// Used to choose a single direction when presented with multiple potential directions.
// Used to eliminate diagonal joy directions and convert them to a single direction
// Priority: (4)up, (8)down, (16)left, (32)right
__align(0x40) char DIRECTION_SINGLE[0x40] = {
    0x00, 0x00, 0x00, 0x00, // 00
    0x04, 0x04, 0x04, 0x04, // 04
    0x08, 0x08, 0x08, 0x08, // 08
    0x04, 0x04, 0x04, 0x04, // 0c: 4 wins
    0x10, 0x10, 0x10, 0x10, // 10
    0x04, 0x04, 0x04, 0x04, // 14: 4 wins
    0x08, 0x08, 0x08, 0x08, // 18: 8 wins
    0x04, 0x04, 0x04, 0x04, // 1c: 4 wins
    0x20, 0x20, 0x20, 0x20, // 20
    0x04, 0x04, 0x04, 0x04, // 24: 4 wins
    0x08, 0x08, 0x08, 0x08, // 28: 8 wins
    0x04, 0x04, 0x04, 0x04, // 2c: 4 wins
    0x10, 0x10, 0x10, 0x10, // 30: 10 wins
    0x04, 0x04, 0x04, 0x04, // 34: 4 wins
    0x08, 0x08, 0x08, 0x08, // 38: 8 wins
    0x04, 0x04, 0x04, 0x04, // 3c: 4 wins
};

// Used to eliminate a single direction (the one that the ghost came from)
// The value DIRECTION_ELIMINATE[current_direction] is ANDed onto the open directions to remove the current direction 
__align(0x40) char DIRECTION_ELIMINATE[0x21] = {
    0xff, 0x00, 0x00, 0x00, // 00
    0xf7, 0x00, 0x00, 0x00, // 04: Moving Up - eliminate Down from the open directions
    0xfb, 0x00, 0x00, 0x00, // 08: Moving Down - eliminate Up from the open directions
    0x00, 0x00, 0x00, 0x00, // 0c
    0xdf, 0x00, 0x00, 0x00, // 10: Moving Left - eliminate Right from the open directions
    0x00, 0x00, 0x00, 0x00, // 14
    0x00, 0x00, 0x00, 0x08, // 18
    0x00, 0x00, 0x00, 0x00, // 1c
    0xef                    // 20 Moving Right - eliminate Left from the open directions
};

// Used to reverse direction direction (when a ghost changes between chase and scatter)
__align(0x40) char DIRECTION_REVERSE[0x21] = {
    0x00, 0x00, 0x00, 0x00, // 00
    0x08, 0x00, 0x00, 0x00, // 04: Moving Up 
    0x04, 0x00, 0x00, 0x00, // 08: Moving Down 
    0x00, 0x00, 0x00, 0x00, // 0c
    0x20, 0x00, 0x00, 0x00, // 10: Moving Left 
    0x00, 0x00, 0x00, 0x00, // 14
    0x00, 0x00, 0x00, 0x08, // 18
    0x00, 0x00, 0x00, 0x00, // 1c
    0x10                    // 20 Moving Right 
};


// The animation frames for pacman. The index into this is DIRECTION + anim_frame_idx.
 __align(0x40) char pacman_frames[] = { 
     8,  8,  8,  8, //  0: Stop 
     8, 24, 20, 24, //  4: Up
     8, 32, 28, 32, //  8: Down
     0,  0,  0,  0, //     Unused
     8,  4,  0,  4, // 16: Left
     0,  0,  0,  0, //     Unused
     0,  0,  0,  0, //     Unused
     0,  0,  0,  0, //     Unused
     8, 12, 16, 12, // 32: Right
};

// The animation frames for ghost. The index into thos is DIRECTION + anim_frame_idx.
__align(0x80) char ghost_frames[] = { 
    0,   0,  0,  0, // 00: Stop     RED
    60, 64, 60, 64, // 04: Up       RED
    52, 56, 52, 56, // 08: Down     RED
     0,  0,  0,  0, // 0c: Unused   RED
    44, 48, 44, 48, // 10: Left     RED
     0,  0,  0,  0, // 14  Unused   RED
     0,  0,  0,  0, // 18  Unused   RED
     0,  0,  0,  0, // 1c  Unused   RED     
    36, 40, 36, 40, // 20: Right    RED
     0,  0,  0,  0, // 24  Unused   RED     
     0,  0,  0,  0, // 28  Unused   RED     
     0,  0,  0,  0, // 2c  Unused   RED     
     0,  0,  0,  0, // 30  Unused   RED     
     0,  0,  0,  0, // 34  Unused   RED     
     0,  0,  0,  0, // 38  Unused   RED     
     0,  0,  0,  0, // 3c  Unused   RED
     0,  0,  0,  0, // 40: Stop     BLUE
    92, 96, 92, 96, // 44: Up       BLUE
    84, 88, 84, 88, // 48: Down     BLUE
     0,  0,  0,  0, // 4c  Unused   BLUE
    76, 80, 76, 80, // 50: Left     BLUE
     0,  0,  0,  0, // 54  Unused   BLUE
     0,  0,  0,  0, // 58  Unused   BLUE
     0,  0,  0,  0, // 5c  Unused   BLUE
    68, 72, 68, 72, // 60: Right    BLUE
};

// The animation frame IDX (within the current direction) [0-3] 
volatile char anim_frame_idx = 0;

// Pacman x fine position (0-99). 
volatile char pacman_xfine = 45;
// Pacman y fine position (0-70). 
volatile char pacman_yfine = 35;
// The pacman movement current direction 
volatile enum DIRECTION pacman_direction = STOP;
// Pacman movement substep (0: on tile, 1: between tiles). 
volatile char pacman_substep = 0;

// Ghost target modes
// See https://gameinternals.com/understanding-pac-man-ghost-behavior
enum GHOSTS_MODE {
    CHASE=0,
    SCATTER=1,
    FRIGHTENED=2
};

// Mode determining ghost target mode. 0: chase, 1: scatter
volatile enum GHOSTS_MODE ghosts_mode = 1;

// Counts frames to change ghost mode (7 seconds scatter, 20 seconds chase )
volatile char ghosts_mode_count = 0;

// Ghost 1 x fine position (0-99). 
volatile char ghost1_xfine = 45;
// Ghost 1 y fine position (0-70). 
volatile char ghost1_yfine = 35;
// Ghost 1 movement current direction 
volatile enum DIRECTION ghost1_direction = STOP;
// Ghost 1 movement substep (0: on tile, 1: between tiles). 
volatile char ghost1_substep = 0;
// Ghost 1 movement should be reversed  (0: normal, 1: reverse direction)
volatile char ghost1_reverse = 0;
// Ghost 1 respawn timer
volatile char ghost1_respawn = 0;

// Ghost 2 x fine position (0-99). 
volatile char ghost2_xfine = 45;
// Ghost 2 y fine position (0-70). 
volatile char ghost2_yfine = 35;
// Ghost 2 movement current direction 
volatile enum DIRECTION ghost2_direction = STOP;
// Ghost 2 movement substep (0: on tile, 1: between tiles). 
volatile char ghost2_substep = 0;
// Ghost 2 movement should be reversed  (0: normal, 1: reverse direction)
volatile char ghost2_reverse = 0;
// Ghost 2 respawn timer
volatile char ghost2_respawn = 0;

// Ghost 3 x fine position (0-99). 
volatile char ghost3_xfine = 45;
// Ghost 3 y fine position (0-70). 
volatile char ghost3_yfine = 35;
// Ghost 3 movement current direction 
volatile enum DIRECTION ghost3_direction = STOP;
// Ghost 3 movement substep (0: on tile, 1: between tiles). 
volatile char ghost3_substep = 0;
// Ghost 3 movement should be reversed  (0: normal, 1: reverse direction)
volatile char ghost3_reverse = 0;
// Ghost 3 respawn timer
volatile char ghost3_respawn = 0;

// Ghost 4 x fine position (0-99). 
volatile char ghost4_xfine = 45;
// Ghost 4 y fine position (0-70). 
volatile char ghost4_yfine = 35;
// Ghost 4 movement current direction 
volatile enum DIRECTION ghost4_direction = STOP;
// Ghost 4 movement substep (0: on tile, 1: between tiles). 
volatile char ghost4_substep = 0;
// Ghost 4 movement should be reversed  (0: normal, 1: reverse direction)
volatile char ghost4_reverse = 0;
// Ghost 4 respawn timer
volatile char ghost4_respawn = 0;

// Game logic sub-step [0-7]. Each frame a different sub-step is animated
volatile char game_logic_substep = 0;

// 1 when the game is playable and characters should move around
volatile char game_playable = 0;

// Perform game logic such as moving pacman and ghosts
void game_logic() {

    // Exit if game is not playable
    if(game_playable==0) return;

    // Move to next sub-step
    game_logic_substep = (game_logic_substep+1)&7;

    if(game_logic_substep==0) {
        // Animate pacman
        // Move pacman in the current direction (unless he is stopped)
        if(pacman_direction==RIGHT) {
            ++pacman_xfine;
        } else if(pacman_direction==DOWN) {
            ++pacman_yfine;
        } else if(pacman_direction==LEFT) {
            --pacman_xfine;
        } else if(pacman_direction==UP) {
            --pacman_yfine;
        }
        if(pacman_substep==0 && pacman_direction!=STOP) {
            // Pacman was on a tile and is moving, so he is now between tiles
            pacman_substep = 1;
            // Enable the eating sound whenever pacman is moving
            pacman_ch1_enabled = 1;
            // Teleport if we are in the magic positions
            if(pacman_xfine==1) {
                pacman_xfine = 97;
            } else if(pacman_xfine==97) {
                pacman_xfine = 1;
            }
        } else  {            
            // Pacman is on a (new) tile
            pacman_substep = 0;
            // Examine open directions from the new tile to determine next action
            char pacman_xtile = pacman_xfine/2;
            char pacman_ytile = pacman_yfine/2;
            char open_directions = level_tile_directions(pacman_xtile, pacman_ytile);
            // Read joystick#2 - arrange bits to match DIRECTION
            char joy_directions = ((CIA1->PORT_A & 0x0f)^0x0f)*4;            
            if(joy_directions!=0) {
                char new_direction = DIRECTION_SINGLE[joy_directions&open_directions];
                if(new_direction!=0)
                    pacman_direction = new_direction;
            }
            // Stop pacman if the current direction is no longer open
            pacman_direction &= open_directions;
        }

    } else if(game_logic_substep==1) {        
        // Ghost spawn timer
        if(ghost1_respawn) {
            if(--ghost1_respawn==0) {
                // Spawn ghost 1
                ghost1_direction = DOWN; ghost1_xfine = 96; ghost1_yfine = 2; ghost1_substep = 0;
            }
        } else {
            // Ghost 1 animation
            // Move in the current direction (unless he is stopped)
            if(ghost1_direction==RIGHT) {
                ++ghost1_xfine;
            } else if(ghost1_direction==DOWN) {
                ++ghost1_yfine;
            } else if(ghost1_direction==LEFT) {
                --ghost1_xfine;
            } else if(ghost1_direction==UP) {
                --ghost1_yfine;
            }
            if(ghost1_substep==0 && ghost1_direction!=STOP) {
                // Ghost was on a tile and is moving, so he is now between tiles
                ghost1_substep = 1;
                // Teleport if we are in the magic positions
                if(ghost1_xfine==1) {
                    ghost1_xfine = 97;
                } else if(ghost1_xfine==97) {
                    ghost1_xfine = 1;
                }
            } else  {
                // Ghost is on a tile
                ghost1_substep = 0;
                if(ghost1_reverse) {
                    // If we are changing between scatter & chase then reverse the direction
                    ghost1_direction = DIRECTION_REVERSE[ghost1_direction];
                    ghost1_reverse = 0;
                } else {
                    // Examine open directions from the new tile to determine next action
                    char ghost1_xtile = ghost1_xfine/2;
                    char ghost1_ytile = ghost1_yfine/2;
                    char open_directions = level_tile_directions(ghost1_xtile, ghost1_ytile);            
                    // Eliminate the direction ghost came from
                    open_directions &= DIRECTION_ELIMINATE[ghost1_direction];
                    if(ghosts_mode==FRIGHTENED) {
                        // Choose a random direction between the open directions
                        ghost1_direction = DIRECTION_SINGLE[open_directions];
                    } else {
                        char target_xtile;
                        char target_ytile;
                        if(ghosts_mode==SCATTER) {
                            target_xtile = 2;
                            target_ytile = 2;                
                        } else {
                            // "Blinky" Choose the direction bringine me closer to pacman. https://gameinternals.com/understanding-pac-man-ghost-behavior
                            target_xtile = pacman_xfine/2;
                            target_ytile = pacman_yfine/2;
                        }
                        ghost1_direction = choose_direction( open_directions, ghost1_xtile, ghost1_ytile, target_xtile, target_ytile );
                    }
                }
            }
        }
    } else if(game_logic_substep==2) {
        // Ghost spawn timer
        if(ghost2_respawn) {
            if(--ghost2_respawn==0) {
                // Spawn ghost
                ghost2_direction = LEFT; ghost2_xfine = 96; ghost2_yfine = 70; ghost2_substep = 0;
            }
        } else {
            // Move in the current direction (unless he is stopped)
            if(ghost2_direction==RIGHT) {
                ++ghost2_xfine;
            } else if(ghost2_direction==DOWN) {
                ++ghost2_yfine;
            } else if(ghost2_direction==LEFT) {
                --ghost2_xfine;
            } else if(ghost2_direction==UP) {
                --ghost2_yfine;
            }
            if(ghost2_substep==0 && ghost2_direction!=STOP) {
                // Ghost was on a tile and is moving, so he is now between tiles
                ghost2_substep = 1;
                // Teleport if we are in the magic positions
                if(ghost2_xfine==1) {
                    ghost2_xfine = 97;
                } else if(ghost2_xfine==97) {
                    ghost2_xfine = 1;
                }
            } else  {
                // Ghost is on a tile
                ghost2_substep = 0;
                if(ghost2_reverse) {
                    // If we are changing between scatter & chase then reverse the direction
                    ghost2_direction = DIRECTION_REVERSE[ghost2_direction];
                    ghost2_reverse = 0;
                } else {
                    // Examine open directions from the new tile to determine next action
                    char ghost2_xtile = ghost2_xfine/2;
                    char ghost2_ytile = ghost2_yfine/2;
                    char open_directions = level_tile_directions(ghost2_xtile, ghost2_ytile);            
                    // Eliminate the direction ghost came from
                    open_directions &= DIRECTION_ELIMINATE[ghost2_direction];
                    if(ghosts_mode==FRIGHTENED) {
                        // Choose a random direction between the open directions
                        ghost2_direction = DIRECTION_SINGLE[open_directions];
                    } else {
                        char target_xtile;
                        char target_ytile;
                        if(ghosts_mode==SCATTER) {
                            target_xtile = 2;
                            target_ytile = 2;                
                        } else {
                            // "Blinky" Choose the direction bringine me closer to pacman. https://gameinternals.com/understanding-pac-man-ghost-behavior
                            target_xtile = pacman_xfine/2;
                            target_ytile = pacman_yfine/2;
                        }
                        ghost2_direction = choose_direction( open_directions, ghost2_xtile, ghost2_ytile, target_xtile, target_ytile );
                    }
                }
            }
        }
    } else if(game_logic_substep==4) {
        // Ghost spawn timer
        if(ghost3_respawn) {
            if(--ghost3_respawn==0) {
                // Spawn ghost
                ghost3_direction = UP; ghost3_xfine = 2; ghost3_yfine = 70; ghost3_substep = 0;
            }
        } else {
            // Move in the current direction (unless he is stopped)
            if(ghost3_direction==RIGHT) {
                ++ghost3_xfine;
            } else if(ghost3_direction==DOWN) {
                ++ghost3_yfine;
            } else if(ghost3_direction==LEFT) {
                --ghost3_xfine;
            } else if(ghost3_direction==UP) {
                --ghost3_yfine;
            }
            if(ghost3_substep==0 && ghost3_direction!=STOP) {
                // Ghost was on a tile and is moving, so he is now between tiles
                ghost3_substep = 1;
                // Teleport if we are in the magic positions
                if(ghost3_xfine==1) {
                    ghost3_xfine = 97;
                } else if(ghost3_xfine==97) {
                    ghost3_xfine = 1;
                }
            } else  {
                // Ghost is on a tile
                ghost3_substep = 0;
                if(ghost3_reverse) {
                    // If we are changing between scatter & chase then reverse the direction
                    ghost3_direction = DIRECTION_REVERSE[ghost3_direction];
                    ghost3_reverse = 0;
                } else {
                    // Examine open directions from the new tile to determine next action
                    char ghost3_xtile = ghost3_xfine/2;
                    char ghost3_ytile = ghost3_yfine/2;
                    char open_directions = level_tile_directions(ghost3_xtile, ghost3_ytile);            
                    // Eliminate the direction ghost came from
                    open_directions &= DIRECTION_ELIMINATE[ghost3_direction];
                    if(ghosts_mode==FRIGHTENED) {
                        // Choose a random direction between the open directions
                        ghost3_direction = DIRECTION_SINGLE[open_directions];
                    } else {
                        char target_xtile;
                        char target_ytile;
                        if(ghosts_mode==SCATTER) {
                            target_xtile = 2;
                            target_ytile = 2;                
                        } else {
                            // "Blinky" Choose the direction bringine me closer to pacman. https://gameinternals.com/understanding-pac-man-ghost-behavior
                            target_xtile = pacman_xfine/2;
                            target_ytile = pacman_yfine/2;
                        }
                        ghost3_direction = choose_direction( open_directions, ghost3_xtile, ghost3_ytile, target_xtile, target_ytile );
                    }
                }
            }
        }
    } else if(game_logic_substep==5) {
        // Ghost spawn timer
        if(ghost4_respawn) {
            if(--ghost4_respawn==0) {
                // Spawn ghost
                ghost4_direction = RIGHT; ghost4_xfine = 2; ghost4_yfine = 2; ghost4_substep = 0;
            }
        } else {
            // Move in the current direction (unless he is stopped)
            if(ghost4_direction==RIGHT) {
                ++ghost4_xfine;
            } else if(ghost4_direction==DOWN) {
                ++ghost4_yfine;
            } else if(ghost4_direction==LEFT) {
                --ghost4_xfine;
            } else if(ghost4_direction==UP) {
                --ghost4_yfine;
            }
            if(ghost4_substep==0 && ghost4_direction!=STOP) {
                // Ghost was on a tile and is moving, so he is now between tiles
                ghost4_substep = 1;
                // Teleport if we are in the magic positions
                if(ghost4_xfine==1) {
                    ghost4_xfine = 97;
                } else if(ghost4_xfine==97) {
                    ghost4_xfine = 1;
                }
            } else  {
                // Ghost is on a tile
                ghost4_substep = 0;
                if(ghost4_reverse) {
                    // If we are changing between scatter & chase then reverse the direction
                    ghost4_direction = DIRECTION_REVERSE[ghost4_direction];
                    ghost4_reverse = 0;
                } else {
                    // Examine open directions from the new tile to determine next action
                    char ghost4_xtile = ghost4_xfine/2;
                    char ghost4_ytile = ghost4_yfine/2;
                    char open_directions = level_tile_directions(ghost4_xtile, ghost4_ytile);            
                    // Eliminate the direction ghost came from
                    open_directions &= DIRECTION_ELIMINATE[ghost4_direction];
                    if(ghosts_mode==FRIGHTENED) {
                        // Choose a random direction between the open directions
                        ghost4_direction = DIRECTION_SINGLE[open_directions];
                    } else {
                        char target_xtile;
                        char target_ytile;
                        if(ghosts_mode==SCATTER) {
                            target_xtile = 2;
                            target_ytile = 2;                
                        } else {
                            // "Blinky" Choose the direction bringine me closer to pacman. https://gameinternals.com/understanding-pac-man-ghost-behavior
                            target_xtile = pacman_xfine/2;
                            target_ytile = pacman_yfine/2;
                        }
                        ghost4_direction = choose_direction( open_directions, ghost4_xtile, ghost4_ytile, target_xtile, target_ytile );
                    }
                }
            }
        }
    } else if(game_logic_substep==6) {
        // Update ghosts mode 
        ghosts_mode_count++;
        char do_reverse = 0;
        if(ghosts_mode==SCATTER) {
            if(ghosts_mode_count>50) {
                ghosts_mode = CHASE; 
                ghosts_mode_count = 0;
                do_reverse = 1;
            }
        } else if(ghosts_mode==CHASE) {
            if(ghosts_mode_count>150) {
                ghosts_mode = SCATTER;
                ghosts_mode_count = 0;
                do_reverse = 1;
            }
        } else if(ghosts_mode==FRIGHTENED) {
            // Frightened mode
            if(ghosts_mode_count>50) {
                ghosts_mode = CHASE;
                ghosts_mode_count = 0;
                do_reverse = 1;
            }
        }

        // Reverse direction for all ghosts if needed
        if(do_reverse) {
                ghost1_reverse = 1;
                ghost2_reverse = 1;
                ghost3_reverse = 1;
                ghost4_reverse = 1;
        }

        // Examine if pacman is on a pill tile - and handle it
        char pacman_xtile = pacman_xfine/2;
        char pacman_ytile = pacman_yfine/2;
        char* ytiles = LEVEL_TILES + LEVEL_YTILE_OFFSET[pacman_ytile];
        char tile_id = ytiles[pacman_xtile];
        if(TILES_TYPE[tile_id]==PILL) {
            // Empty the tile
            ytiles[pacman_xtile] = EMPTY;
            // Ask the logic code renderer to update the tile
            logic_tile_xcol = pacman_xtile/2;
            logic_tile_ptr = ytiles + (pacman_xtile & 0xfe);
            logic_tile_yfine = pacman_ytile*2;
            // Decrease the number of pills
            if(--pill_count==0)
                pacman_wins = 1;;
        } else if(TILES_TYPE[tile_id]==POWERUP) {
            // Empty the tile
            ytiles[pacman_xtile] = EMPTY;
            // Ask the logic code renderer to update the tile
            logic_tile_xcol = pacman_xtile/2;
            logic_tile_ptr = ytiles + (pacman_xtile & 0xfe);
            logic_tile_yfine = pacman_ytile*2;
            // Start power-up mode
            ghosts_mode = FRIGHTENED;
            ghosts_mode_count = 0;
        } 

        // Check if anyone dies
        if(ABS[pacman_xfine-ghost1_xfine]<2 && ABS[pacman_yfine-ghost1_yfine]<2) {
            if(ghosts_mode==FRIGHTENED) {
                // ghost dies
                ghost1_direction = STOP; ghost1_xfine = 50; ghost1_yfine = 35; ghost1_substep = 0; ghost1_respawn = 50;
            } else {
                // pacman dies
                pacman_lives--;
                spawn_all(); 
            }
        } else if(ABS[pacman_xfine-ghost2_xfine]<2 && ABS[pacman_yfine-ghost2_yfine]<2) {
            if(ghosts_mode==FRIGHTENED) {
                ghost2_direction = STOP; ghost2_xfine = 50; ghost2_yfine = 35; ghost2_substep = 0; ghost2_respawn = 50;
            } else {
                // pacman dies
                pacman_lives--;
                spawn_all(); 
            }
        } else if(ABS[pacman_xfine-ghost3_xfine]<2 && ABS[pacman_yfine-ghost3_yfine]<2) {
            if(ghosts_mode==FRIGHTENED) {
                ghost3_direction = STOP; ghost3_xfine = 50; ghost3_yfine = 35; ghost3_substep = 0; ghost3_respawn = 50;
            } else {
                // pacman dies
                pacman_lives--;
                spawn_all(); 
            }
        } else if(ABS[pacman_xfine-ghost4_xfine]<2 && ABS[pacman_yfine-ghost4_yfine]<2) {
            if(ghosts_mode==FRIGHTENED) {
                ghost4_direction = STOP; ghost4_xfine = 50; ghost4_yfine = 35; ghost4_substep = 0; ghost4_respawn = 50;
            } else {
                // pacman dies
                pacman_lives--;
                spawn_all(); 
            }
        }
    } else if(game_logic_substep==3 || game_logic_substep==7) {
        // Update animation and bobs

        anim_frame_idx = (anim_frame_idx+1) & 3;

        char pacman_bob_xfine = pacman_xfine-1;
        bobs_xcol[0] = pacman_bob_xfine/4;
        bobs_yfine[0] = pacman_yfine-1;
        bobs_bob_id[0] = pacman_frames[pacman_direction|anim_frame_idx] +  (pacman_bob_xfine&3);

        char ghost_frame_idx = anim_frame_idx;
        if(ghosts_mode==FRIGHTENED)
            ghost_frame_idx |= 0x40;

        char ghost1_bob_xfine = ghost1_xfine-1;
        bobs_xcol[1] = ghost1_bob_xfine/4;
        bobs_yfine[1] = ghost1_yfine-1;
        bobs_bob_id[1] = ghost_frames[ghost1_direction|ghost_frame_idx] +  (ghost1_bob_xfine&3);

        char ghost2_bob_xfine = ghost2_xfine-1;
        bobs_xcol[2] = ghost2_bob_xfine/4;
        bobs_yfine[2] = ghost2_yfine-1;
        bobs_bob_id[2] = ghost_frames[ghost2_direction|ghost_frame_idx] +  (ghost2_bob_xfine&3);

        char ghost3_bob_xfine = ghost3_xfine-1;
        bobs_xcol[3] = ghost3_bob_xfine/4;
        bobs_yfine[3] = ghost3_yfine-1;
        bobs_bob_id[3] = ghost_frames[ghost3_direction|ghost_frame_idx] +  (ghost3_bob_xfine&3);

        char ghost4_bob_xfine = ghost4_xfine-1;
        bobs_xcol[4] = ghost4_bob_xfine/4;
        bobs_yfine[4] = ghost4_yfine-1;
        bobs_bob_id[4] = ghost_frames[ghost4_direction|ghost_frame_idx] +  (ghost4_bob_xfine&3);
    }

}

// Lookup the absolute value of a signed number
// PRE_ and POST_ are used to ensure lookup of ABS-1,y works for y=0 and ABS+1,y works for y=0xff
export __align(0x100) char ABS_PRE[1] = { 1 }; 
export char ABS[0x100] = kickasm {{
    .for(var i=0;i<$100;i++) {
        .var x = (i<$80)?i:($100-i);
        .byte abs(x)
    }
}};
export char ABS_POST[1] = { 0 }; 

// Choose the open direction that brings the ghost closest to the target
// Uses Manhattan distance calculation
char choose_direction( char open_directions, char ghost_xtile, char ghost_ytile, char target_xtile, char target_ytile ) {
    char xdiff = ghost_xtile-target_xtile;
    char ydiff = ghost_ytile-target_ytile;
    char direction = STOP;
    char dist_min = 0xff;
    if(open_directions&UP) {
        char dist_up = ABS[xdiff] + ABS[ydiff-1];
        if(dist_up<dist_min) {
            direction = UP;
            dist_min = dist_up;
        }
    } 
    if(open_directions&DOWN) {
        char dist_down = ABS[xdiff] + ABS[ydiff+1];
        if(dist_down<dist_min) {
            direction = DOWN;
            dist_min = dist_down;
        }
    } 
    if(open_directions&LEFT) {
        char dist_left = ABS[xdiff-1] + ABS[ydiff];
        if(dist_left<dist_min) {
            direction = LEFT;
            dist_min = dist_left;
        }
    } 
    if(open_directions&RIGHT) {
        char dist_right = ABS[xdiff+1] + ABS[ydiff];
        if(dist_right<dist_min) {
            direction = RIGHT;
            dist_min = dist_right;
        }
    }
    return direction;
}


// Spawn pacman and all ghosts
void spawn_all() {
    ghosts_mode_count = 0;
    pacman_substep = 0;
    ghost1_substep = 0;
    ghost2_substep = 0;
    ghost3_substep = 0;
    ghost4_substep = 0;
    pacman_direction = STOP;
    ghost1_direction = STOP;
    ghost2_direction = STOP;
    ghost3_direction = STOP;
    ghost4_direction = STOP;
    pacman_xfine = 50;
    ghost1_xfine = 50;
    ghost2_xfine = 50;
    ghost3_xfine = 50;
    ghost4_xfine = 50;
    ghost1_yfine = 35;
    ghost2_yfine = 35;
    ghost3_yfine = 35;
    ghost4_yfine = 35;    
    pacman_yfine = 62;
    ghost1_respawn = 10;
    ghost2_respawn = 20;
    ghost3_respawn = 30;
    ghost4_respawn = 40;
}
