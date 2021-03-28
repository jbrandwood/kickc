// The number of bobs rendered
const char NUM_BOBS = 5;
// The size of the BOB restore structure
const char SIZE_BOB_RESTORE = 18;

// The BOB x column position (0-24) (a column is 8 pixels)
char bobs_xcol[NUM_BOBS] = { 10, 10, 10, 10, 10, };
// The BOB y fine position (0-99). The y-position is a line on the screen. Since every second line is black each ypos represents a 2 pixel distance.
char bobs_yfine[NUM_BOBS] = { 45, 45, 45, 45, 45, };
// The BOB ID in the BOB data tables
char bobs_bob_id[NUM_BOBS] = { 0, 0, 0, 0, 0, };
// The BOB restore data: 18 bytes per BOB. Doubled for double-buffering.
// char * left_canvas;
// char left_ypos_inc_offset;
// char * right_canvas;
// char right_ypos_inc_offset;
// char[12] restore_pixels; 
__align(0x100) char bobs_restore[NUM_BOBS*SIZE_BOB_RESTORE*2];

// Pointer to the tile to render in the logic code
volatile char* logic_tile_ptr;
// The x-column of the tile to render
volatile char logic_tile_xcol;
// The y-fine of the tile to render
volatile char logic_tile_yfine;
// The ID*4 of the left tile to render
volatile char logic_tile_left_idx;
// The ID*4 of the right tile to render
volatile char logic_tile_right_idx;

// Initialize bobs_restore with data to prevent crash on the first call
void init_bobs_restore() {
    char * CANVAS_HIDDEN = 0xea00;
    char * bob_restore = bobs_restore;
    for(char bob=0;bob<NUM_BOBS*2;bob++) {
        for(char i=0;i<SIZE_BOB_RESTORE;i++)
            bob_restore[i] = 0;
        bob_restore[0] = <CANVAS_HIDDEN;
        bob_restore[1] = >CANVAS_HIDDEN;
        bob_restore[3] = <CANVAS_HIDDEN;
        bob_restore[4] = >CANVAS_HIDDEN;
        bob_restore += SIZE_BOB_RESTORE;
    }

    // Also set the logic tile to something sane
    logic_tile_ptr = LEVEL_TILES + 64*18 + 12 ;
    logic_tile_xcol = 12;
    logic_tile_yfine = 35;
}

// Variables used by the logic-code renderer and restorer
char * volatile left_render_index_xcol;
char * volatile left_canvas;
volatile char left_ypos_inc_offset;
char * volatile rigt_render_index_xcol;
char * volatile rigt_canvas;
volatile char rigt_ypos_inc_offset;
// The high-byte of the start-address of the canvas currently being rendered to
volatile char canvas_base_hi;
// The offset used for bobs_restore - used to achieve double buffering
volatile char bobs_restore_base;

// Empty logic-code to be merged into the raster-code for testing
char LOGIC_CODE_EMPTY[] = kickasm {{     
    .byte 00 // end of logic code
}};