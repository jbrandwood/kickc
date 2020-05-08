// Filling a simple 16x16 2D polygon using EOR-filling
// - Clearing canvas
// - Trivial 2D rotation using sine tables
// - Line-drawing polygon edges (fill-ready lines)
// - Up-to-down EOR filling 
// - Double buffering

#include <string.h>
#include <c64.h>
#include <time.h>
#include <stdio.h>
#include <conio.h>

#undef DEBUG

// The line buffer
char* const LINE_BUFFER = 0x2000;
// The two charsets used as screen buffers
char* const CANVAS1 = 0x3000;
char* const CANVAS2 = 0x3800;
// The screen matrix
char* const SCREEN = 0x2c00;

// The screen console
char* const CONSOLE = 0x0400;
// The default charset address
char* const PETSCII = 0x1000;

// The current canvas being rendered to the screen - in D018 format.
char volatile canvas_show_memory = toD018(SCREEN, CANVAS2);
// Flag signalling that the canvas on screen needs to be updated.
// Set to 1 by the renderer when a new canvas is ready for showing, and to 0 by the raster when the canvas is shown on screen.
char volatile canvas_show_flag = 0;

// SIN/COS tables
char align(0x100) SINTAB[0x140] = kickasm {{
    .fill $200, 63 + 63*sin(i*2*PI/$100)
}};
char* COSTAB = SINTAB+0x40;

void main() {
    // Clear the console
    memset(CONSOLE, ' ', 40*25);
    // Clear the screen
    memset(SCREEN, 0, 40*25);
    memset(COLS, BLACK, 40*25);
    // Setup 16x16 canvas for rendering
    char *screen= SCREEN+12, *cols=COLS+12;
    for(char y=0;y<16;y++) {
        char c=y;
        for(char x=0;x<16;x++) {
            cols[x] = WHITE;
            screen[x] = c;
            c+=0x10;
        }
        cols += 40;
        screen += 40;
    }
    VICII->BORDER_COLOR = BLACK;
    VICII->BG_COLOR = BLACK;

    // Set-up the raster IRQ
    setup_irq();
    // Set text color
    textcolor(WHITE);

    char p0_idx = 0xf0;
    char p1_idx = p0_idx+15;
    char p2_idx = p0_idx+170;

    // The current canvas being rendered to
    char* canvas = CANVAS1;

    while(1) {
        clock_start();
        // Clear line buffer
        memset(LINE_BUFFER, 0, 0x0800);
        // Plot in line buffer
        char x0 = COSTAB[p0_idx];
        char y0 = SINTAB[p0_idx];
        char x1 = COSTAB[p1_idx];
        char y1 = SINTAB[p1_idx];
        line(LINE_BUFFER, x0, y0, x1, y1);
        char x2 = COSTAB[p2_idx];
        char y2 = SINTAB[p2_idx];
        line(LINE_BUFFER, x1, y1, x2, y2);
        line(LINE_BUFFER, x2, y2, x0, y0);
        // Move idx
        p0_idx++;
        p1_idx++;
        p2_idx++;
        // Wait until the canvas on screen has been switched before starting work on the next frame
        VICII->BORDER_COLOR = RED;
        while(canvas_show_flag) {}
        VICII->BORDER_COLOR = BLACK;
        // Fill canvas
        eorfill(LINE_BUFFER, canvas);
        // swap canvas being rendered to (using XOR)
        canvas ^= (CANVAS1^CANVAS2);
        // Swap canvas to show on screen (using XOR)
        canvas_show_memory ^= toD018(SCREEN,CANVAS1)^toD018(SCREEN,CANVAS2);
        // Set flag used to signal when the canvas has been shown
        canvas_show_flag = 1;
        // Read and display cycles
        clock_t cyclecount = clock()-CLOCKS_PER_INIT;
        gotoxy(0,24);
        printf("frame: %02x cycles: %6lu", p0_idx, cyclecount);
        //printf("(%02x,%02x)-(%02x,%02x)", x0, y0, x1, y1);
    }
}

// Setup raster IRQ to change charset at different lines
void setup_irq() {
    asm { sei }
    // Disable CIA 1 Timer IRQ
    CIA1->INTERRUPT = CIA_INTERRUPT_CLEAR;
    // Set raster line to 8 pixels before the border
    VICII->CONTROL1 &= 0x7f;
    VICII->RASTER = BORDER_YPOS_BOTTOM-8;
    // Enable Raster Interrupt
    VICII->IRQ_ENABLE = IRQ_RASTER;
    // Set the IRQ routine
    *KERNEL_IRQ = &irq_bottom_1;
    asm { cli }
}

// Interrupt Routine 1: Just above last text line.
interrupt(kernel_min) void irq_bottom_1() {
    // Change border color
    VICII->BORDER_COLOR = WHITE;
    // Show the cycle counter
    VICII->MEMORY = toD018(CONSOLE, PETSCII);
    // Acknowledge the IRQ
    VICII->IRQ_STATUS = IRQ_RASTER;
    // Trigger IRQ 2 at bottom of text-line
    VICII->RASTER = BORDER_YPOS_BOTTOM;
    *KERNEL_IRQ = &irq_bottom_2;
}

// Interrupt Routine 2
interrupt(kernel_keyboard) void irq_bottom_2() {
    // Change border color
    VICII->BORDER_COLOR = BLACK;
    // Show the current canvas (unless a key is being pressed)
    if(!kbhit()) {
        VICII->MEMORY = canvas_show_memory;
    }
    canvas_show_flag = 0;
    // Acknowledge the IRQ
    VICII->IRQ_STATUS = IRQ_RASTER;
    // Trigger IRQ 1 at 8 pixels before the border
    VICII->RASTER = BORDER_YPOS_BOTTOM-8;
    *KERNEL_IRQ = &irq_bottom_1;
}

// Draw a EOR friendly line between two points
// Uses bresenham line drawing routine
void line(char* canvas, char x1, char y1, char x2, char y2) {
    char x = x1;
    char y = y1;
    char dx = abs_u8(x2-x1);
    char dy = abs_u8(y2-y1);
    char sx = sgn_u8(x2-x1);
    char sy = sgn_u8(y2-y1);
    if(sx==0xff) {
        // The sign of the x-difference determines if this is a line at the top of the face
        // being filled or a line at the bottom of the face. Because the points are organized in a clockwise
        // fashion any line pointing right is filled below the line and any line pointing left is filled above
        // If this line is pointing left then move it down one pixel to ensure the fill is stopped correctly
        y++; y2++;
    }
    if(dx > dy) {
        // X is the driver - plot every X using bresenham
        char e = dx/2;
        do  {
            plot(x, y);
            x += sx;
            e += dy;
            if(dx < e) {
                y += sy;
                e -= dx;
            }
        } while (x != x2);
        plot(x, y);
    } else {
        // Y is the driver - only plot one plot per X
        char e = dy/2;
        plot(x, y);
        do  {
            y += sy;
            e += dx;
            if(dy<e) {
                x += sx;
                e -= dy;
                plot(x, y);
            }
        } while (y != y2);
    }
}

// Column offsets
char* plot_column[16] = { LINE_BUFFER+0, LINE_BUFFER+1*128, LINE_BUFFER+2*128, LINE_BUFFER+3*128, LINE_BUFFER+4*128, LINE_BUFFER+5*128, LINE_BUFFER+6*128, LINE_BUFFER+7*128, LINE_BUFFER+8*128, LINE_BUFFER+9*128, LINE_BUFFER+10*128, LINE_BUFFER+11*128, LINE_BUFFER+12*128, LINE_BUFFER+13*128, LINE_BUFFER+14*128, LINE_BUFFER+15*128 };
// The bits used for plotting a pixel
char plot_bit[8] = { 0x80, 0x40, 0x20, 0x10, 0x08, 0x04, 0x02, 0x01};

// Plot a single point on the canvas
inline void plot(char x, char y) {
    // Find the canvas column
    char* column = plot_column[x/8];
    // Plot the bit
    column[y] |= plot_bit[x&7];
}

// EOR fill from the line buffer onto the canvas
void eorfill(char* line_buffer, char* canvas) {
    char* line_column = line_buffer;
    char* fill_column = canvas;
    for(char x=0;x<16;x++) {
        char eor = line_column[0];
        for(char y=1;y<16*8;y++) {
            eor ^= line_column[y];
            fill_column[y] = eor;
        }
        line_column += 16*8;
        fill_column += 16*8;
    }
}

// Get the absolute value of a u-bit unsigned number treated as a signed number.
unsigned char abs_u8(unsigned char u) {
    if(u & 0x80) {
        return -u;
    } else {
        return u;
    }
}

// Get the sign of a 8-bit unsigned number treated as a signed number.
// Returns unsigned -1 if the number is negative
unsigned char sgn_u8(unsigned char u) {
    if(u & 0x80) {
        return -1;
    } else {
        return 1;
    }
}
