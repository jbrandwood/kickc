// Address of the first pixel each x column
char* RENDER_XCOLS[26] = { 
    0x0000, 0x0001, 0x0002, 
    0x0400, 0x0401, 0x0402, 
    0x0800, 0x0801, 0x0802, 
    0x0c00, 0x0c01, 0x0c02, 
    0x1000, 0x1001, 0x1002, 
    0x1400, 0x1401, 0x1402, 
    0x1800, 0x1801, 0x1802, 
    0x1c00, 0x1c01, 0x1c02, 
    0x0000, 0x0000
};

// Offset for each y-position from the first pixel of an X column
unsigned int RENDER_YPOS[149] = {
    0x000+0, 0x000+0, 
    0x000+0, 0x000+6, 0x000+12, 0x000+18, 0x000+24, 0x000+30, 0x000+36, 0x000+42, 0x000+48, 0x000+54, 0x000+60, 
    0x040+3, 0x040+9, 0x040+15, 0x040+21, 0x040+27, 0x040+33, 0x040+39, 0x040+45, 0x040+51, 0x040+57, 
    0x080+0, 0x080+6, 0x080+12, 0x080+18, 0x080+24, 0x080+30, 0x080+36, 0x080+42, 0x080+48, 0x080+54, 0x080+60, 
    0x0c0+3, 0x0c0+9, 0x0c0+15, 0x0c0+21, 0x0c0+27, 0x0c0+33, 0x0c0+39, 0x0c0+45, 0x0c0+51, 0x0c0+57, 
    0x100+0, 0x100+6, 0x100+12, 0x100+18, 0x100+24, 0x100+30, 0x100+36, 0x100+42, 0x100+48, 0x100+54, 0x100+60, 
    0x140+3, 0x140+9, 0x140+15, 0x140+21, 0x140+27, 0x140+33, 0x140+39, 0x140+45, 0x140+51, 0x140+57, 
    0x180+0, 0x180+6, 0x180+12, 0x180+18, 0x180+24, 0x180+30, 0x180+36, 0x180+42, 0x180+48, 0x180+54, 0x180+60, 
    0x1c0+3, 0x1c0+9, 0x1c0+15, 0x1c0+21, 0x1c0+27, 0x1c0+33, 0x1c0+39, 0x1c0+45, 0x1c0+51, 0x1c0+57, 
    0x200+0, 0x200+6, 0x200+12, 0x200+18, 0x200+24, 0x200+30, 0x200+36, 0x200+42, 0x200+48, 0x200+54, 0x200+60, 
    0x240+3, 0x240+9, 0x240+15, 0x240+21, 0x240+27, 0x240+33, 0x240+39, 0x240+45, 0x240+51, 0x240+57, 
    0x280+0, 0x280+6, 0x280+12, 0x280+18, 0x280+24, 0x280+30, 0x280+36, 0x280+42, 0x280+48, 0x280+54, 0x280+60, 
    0x2c0+3, 0x2c0+9, 0x2c0+15, 0x2c0+21, 0x2c0+27, 0x2c0+33, 0x2c0+39, 0x2c0+45, 0x2c0+51, 0x2c0+57,    
    0x300+0, 0x300+6, 0x300+12, 0x300+18, 0x300+24, 0x300+30, 0x300+36, 0x300+42, 0x300+48, 0x300+54, 0x300+60, 
    0x340+3, 0x340+9, 0x340+15, 0x340+21, 0x340+27, 0x340+33, 0x340+39, 0x340+45, 0x340+51, 0x340+57, 
};

// Offset for each y-position from the first pixel of an X column in sprite#9
unsigned int RENDER_YPOS_9TH[149] = {
    0x000+3, 0x000+3, 
    0x000+3, 0x000+9, 0x000+15, 0x000+21, 0x000+27, 0x000+33, 0x000+39, 0x000+45, 0x000+51, 0x000+57, 
    0x040+0, 0x040+6, 0x040+12, 0x040+18, 0x040+24, 0x040+30, 0x040+36, 0x040+42, 0x040+48, 0x040+54, 0x040+60, 
    0x080+3, 0x080+9, 0x080+15, 0x080+21, 0x080+27, 0x080+33, 0x080+39, 0x080+45, 0x080+51, 0x080+57, 
    0x0c0+0, 0x0c0+6, 0x0c0+12, 0x0c0+18, 0x0c0+24, 0x0c0+30, 0x0c0+36, 0x0c0+42, 0x0c0+48, 0x0c0+54, 0x0c0+60, 
    0x100+3, 0x100+9, 0x100+15, 0x100+21, 0x100+27, 0x100+33, 0x100+39, 0x100+45, 0x100+51, 0x100+57, 
    0x140+0, 0x140+6, 0x140+12, 0x140+18, 0x140+24, 0x140+30, 0x140+36, 0x140+42, 0x140+48, 0x140+54, 0x140+60, 
    0x180+3, 0x180+9, 0x180+15, 0x180+21, 0x180+27, 0x180+33, 0x180+39, 0x180+45, 0x180+51, 0x180+57, 
    0x1c0+0, 0x1c0+6, 0x1c0+12, 0x1c0+18, 0x1c0+24, 0x1c0+30, 0x1c0+36, 0x1c0+42, 0x1c0+48, 0x1c0+54, 0x1c0+60, 
    0x200+3, 0x200+9, 0x200+15, 0x200+21, 0x200+27, 0x200+33, 0x200+39, 0x200+45, 0x200+51, 0x200+57, 
    0x240+0, 0x240+6, 0x240+12, 0x240+18, 0x240+24, 0x240+30, 0x240+36, 0x240+42, 0x240+48, 0x240+54, 0x240+60, 
    0x280+3, 0x280+9, 0x280+15, 0x280+21, 0x280+27, 0x280+33, 0x280+39, 0x280+45, 0x280+51, 0x280+57,    
    0x2c0+0, 0x2c0+6, 0x2c0+12, 0x2c0+18, 0x2c0+24, 0x2c0+30, 0x2c0+36, 0x2c0+42, 0x2c0+48, 0x2c0+54, 0x2c0+60, 
    0x300+3, 0x300+9, 0x300+15, 0x300+21, 0x300+27, 0x300+33, 0x300+39, 0x300+45, 0x300+51, 0x300+57, 
    0x340+0, 0x340+6, 0x340+12, 0x340+18, 0x340+24, 0x340+30, 0x340+36, 0x340+42, 0x340+48, 0x340+54, 0x340+60, 
};

// Increment for each y-position from the first pixel of an X column
__align(0x20) char RENDER_YPOS_INC[160] = {
    0, 0, 
    6, 6, 6, 6, 6, 6, 6, 6, 6, 6, 7, 
    6, 6, 6, 6, 6, 6, 6, 6, 6, 7, 
    6, 6, 6, 6, 6, 6, 6, 6, 6, 6, 7, 
    6, 6, 6, 6, 6, 6, 6, 6, 6, 7, 
    6, 6, 6, 6, 6, 6, 6, 6, 6, 6, 7, 
    6, 6, 6, 6, 6, 6, 6, 6, 6, 7, 
    6, 6, 6, 6, 6, 6, 6, 6, 6, 6, 7, 
    6, 6, 6, 6, 6, 6, 6, 6, 6, 7, 
    6, 6, 6, 6, 6, 6, 6, 6, 6, 6, 7, 
    6, 6, 6, 6, 6, 6, 6, 6, 6, 7, 
    6, 6, 6, 6, 6, 6, 6, 6, 6, 6, 7, 
    6, 6, 6, 6, 6, 6, 6, 6, 6, 7, 
    6, 6, 6, 6, 6, 6, 6, 6, 6, 6, 7, 
    6, 6, 6, 6, 6, 6, 6, 6, 6, 7, 
    6, 6, 6, 6, 6, 6, 6, 6, 6, 6, 7, 
};

const char RENDER_OFFSET_CANVAS_LO = 0x00;
const char RENDER_OFFSET_CANVAS_HI = 0x50;
const char RENDER_OFFSET_YPOS_INC = 0xa0;

// Initialize the RENDER_INDEX table from sub-tables
void init_render_index() {
    char* render_index = RENDER_INDEX;
    for(char x_col=0;x_col<26;x_col++) {
        unsigned int * render_ypos_table = RENDER_YPOS;
        char ypos_inc_offset = 0;
        if(x_col>=24) {
            // Special column in sprite#9
             render_ypos_table = RENDER_YPOS_9TH;
             ypos_inc_offset = 11;
        }
        char * render_index_xcol = render_index;
        char * canvas_xcol = RENDER_XCOLS[x_col];
        for(char y_pos=0;y_pos<148;y_pos+=2) {
            char * canvas = canvas_xcol + render_ypos_table[(unsigned int)y_pos];
            render_index_xcol[RENDER_OFFSET_CANVAS_LO] = BYTE0(canvas);
            render_index_xcol[RENDER_OFFSET_CANVAS_HI] = BYTE1(canvas);
            render_index_xcol[RENDER_OFFSET_YPOS_INC] = ypos_inc_offset;
            ypos_inc_offset += 2;
            if(ypos_inc_offset>=23) ypos_inc_offset-=21; // Keep ypos_inc_index as low as possible
            render_index_xcol++;
        }
        render_index += 0x100;
    }
    // Fix the first entry of the inc_offset in the last column (set it to point to 0,0,6,6...)
    (RENDER_INDEX+24*0x100)[RENDER_OFFSET_YPOS_INC] = 0;
    (RENDER_INDEX+25*0x100)[RENDER_OFFSET_YPOS_INC] = 0;
}

// Render graphic pixels into the 9 all-border sprites
// - xcol: x column (0-24). The x-column represents 8 bits of data, 4 mc pixels, 16 on-screen pixels (due to x-expanded sprites)
// - ypos: y position (0-145). The y-position is a line on the screen. Since every second line is black each ypos represents a 2 pixel distance.
// - pixels: The pixel data to set 
void render(char xcol, char ypos, char pixels) {
    char ytile = ypos/4;
    char * render_index_xcol = (char*){ BYTE1(RENDER_INDEX) + xcol, ytile*2 };
    unsigned int canvas_offset = { render_index_xcol[RENDER_OFFSET_CANVAS_HI], render_index_xcol[RENDER_OFFSET_CANVAS_LO] };
    char * canvas1 = SPRITES_1 + canvas_offset;
    char * canvas2 = SPRITES_2 + canvas_offset;
    char ypos_inc_offset = render_index_xcol[RENDER_OFFSET_YPOS_INC];
    // Move the last few y-pixels
    char ypix = ypos&3;
    for(char i=0;i<ypix;i++) {
        canvas1 += RENDER_YPOS_INC[ypos_inc_offset];
        canvas2 += RENDER_YPOS_INC[ypos_inc_offset];
        ypos_inc_offset++;
    }
    // Render the pixels
    *canvas1 = pixels;
    *canvas2 = pixels;
} 

// Renders 2x1 tiles on the canvas. 
// Tiles are 4x4 px. This renders 8px x 4px. 
// - xcol: The x column position (0-24) (a column is 8 pixels)
// - ytile: The y tile position (0-37). Tile y position 0 is a special half-tile at the top of the screen.
// - tile_left:  The left tile ID.
// - tile_right:  The right tile ID.
void render_tiles(char xcol, char ytile, char tile_left, char tile_right) {
    char * tile_left_pixels = TILES_LEFT + tile_left*4;
    char * tile_right_pixels = TILES_RIGHT + tile_right*4;
    char * render_index_xcol = (char*){ BYTE1(RENDER_INDEX) + xcol, ytile*2 };
    unsigned int canvas_offset = {render_index_xcol[RENDER_OFFSET_CANVAS_HI], render_index_xcol[RENDER_OFFSET_CANVAS_LO] };
    char * canvas1 = SPRITES_1 + canvas_offset;
    char * canvas2 = SPRITES_2 + canvas_offset;
    char ypos_inc_offset = render_index_xcol[RENDER_OFFSET_YPOS_INC];
    for(char y=0;y<4;y++) {
        char pixels = tile_left_pixels[y] | tile_right_pixels[y];
        *canvas1 = pixels;
        *canvas2 = pixels;
        canvas1 += RENDER_YPOS_INC[ypos_inc_offset];
        canvas2 += RENDER_YPOS_INC[ypos_inc_offset];
        ypos_inc_offset++;
    }
}
