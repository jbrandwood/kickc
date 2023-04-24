/**
 * @file sprites.c
 * @author Sven Van de Velde (sven.van.de.velde@telenet.be)
 * @brief This program is a little exercise we did in retro computer
 * initiation in school on the Commodore 128 using the KICKC compiler!
 * 
 * We play with sprites on the Commodore 128. 
 * The reason I chose the Commodore 128 for this exercise is because 
 * this machine contains commands in BASIC that help define sprites and 
 * that you can float around.
 * However, this is all in BASIC and those commands are made for simple users, 
 * and these were only introduced very late by Commodore in the BASIC language. 
 * The Commodore 64 does not have these BASIC instructions.
 * 
 * We are now going to learn how to use the C language to control the sprites ourselves.
 * We do this by directly controlling the registers of the VIC II chip, 
 * who draws the screen on the Commodore 128 and in the Commodore 64.
 * 
 * Follow the link below for a full description of the VIC II chip and its registers. 
 * It's all very technical, but in class we will see that it is not so bad and 
 * that it is very nice after you have practiced a bit!
 * [VIC II chip registers](https://handwiki.org/wiki/Engineering:MOS_Technology_VIC-II).
 * 
 * As mentioned, we work with sprites today.
 * This link [sprites](https://codebase64.org/doku.php?id=base:spriteintro) explains how we control sprites in the VIC II chip. We learn how they are turned on and off.
 * We position them on the x-axis and y-axis. We indicate where the bitmap of the sprite is located in the internet memory.
 * We play with sprites. In class we will go over this explanation together.
 * 
 * In this lesson we will learn:
 *   - What registers the VICII has for sprite operations.
 *   - How these registries work.
 *   - We learn to address them binary (with &, |, ~ operators).
 *   - We learn how to build C-functions to edit the sprite registers in a simple way.
 *   - We play with our C functions and learn to move sprites across the screen.
 *   - We learn how to make a scan line interrupt and how to make very smooth sprite movements.
 *   - We learn to animate sprites.
 *   - We learn all kinds of other properties of sprites.
 * 
 * We create the following features and we learn how they work:
 * 
 * inline void screen_color(char color)
 * inline void border_color(char color)
 * inline void sprite_enable(char sprite)
 * inline void sprite_position_x(char sprite, unsigned int x)
 * inline void sprite_position_y(char sprite, char y)
 * inline void sprite_color(char sprite, char color)
 * inline void sprite_bitmap(char sprite, char* bitmap)
 * 
 * Note that you will type in your program yourself, but we make the exercises together, because it is all new.
 * So don't worry, you will learn a lot and later you will be able to play with this yourself :-).
 * 
 * 
 * EXERCISE 15.1: We give the screen a different color.
 * - We use VIC II register 0xD020 to color the edge of the screen.
 * - We use VIC II register 0xD021 to color the screen.
 * - We complete functions screen_color and border_color.
 * 
 * EXERCISE 15.2: Position the sprite in a different place on the x-axis and the y-axis!
 * - Which VIC II registers do you use for this?
 * - Do you understand how the registers work?
 * - We complete function sprite_enable to turn on the sprite.
 * - We complete function sprite_position_x to position the sprite on the x-axis.
 * - We complete function sprite_position_y to position the sprite on the y-axis.
 * - We complete function sprite_bitmap to refer the sprite to the sprite bitmap.
 * - We position the sprite on x-axis at 100 and on y-axis at 100.
 * 
 * EXERCISE 15.3: Now try to change the color of the sprite.
 * - We use VIC II registers D027 to D02E.
 * - We complete function sprite_color to give the sprite a color. 
 * 
 * EXERCISE 15.4: Draw your own sprite in the excel sheet, and cut/paste the binary data into your c program.
 * - Recompile and run your program. Does it work?
 * - Ideas for a sprite are spaceships, planes, faces. Keep it simple.
 * 
 * EXERCISE 15.5: Now make a 2nd and a 3rd sprite, based on the 1st sprite, but change it a bit.
 * - Declare and allocate the bitmap of the 2nd and 3rd sprite.
 * - Now try to adjust your program so that the 2nd sprite appears after a random keystroke.
 * - To achieve this, you need to use the function to adjust the sprite bitmap register.
 * 
 * EXERCISE 15.6: Now try to switch the sprite bitmap every 16 frames between the 1st sprite and the 2nd and the 3rd sprite.
 * - We use the "grid line" method. Let me explain. The code scheleton contains all this logic.
 * - We have to declare a counter that adds up every time.
 * - For every 16 frames, we adjust the sprite bitmap to the next bitmap.
 * 
 * EXERCISE 15.7: Now try to move the sprite on the x-axis, from position 50 to position 255.
 * - If the sprite has landed at position 255, the position should be set back to 50 and we start from scratch.
 * - We use a scan line interrupt to do this.
 * 
 * EXERCISE 15.8: Now try to put the sprite BEYOND the position 255 on the x-axis!
 * - You need a special register here!
 * - You have to ask Sven how this register works.
 * - We will learn here how to create a '|' (OR), use a '&' (AND), and a '~' (NOT) operator.
 * 
 * EXERCISE 15.9: Now we try to move the sprite on the y-axis as well...
 * 
 * @version 0.1
 * @date 2022-01-13
 *
 * @copyright Copyright (c) 2023
 *
 */

#pragma encoding(petscii_mixed)
#pragma var_model(zp)
#pragma target(C128)

#include <conio.h>
#include <kernal.h>
#include <printf.h>

#include <mos6569.h>

// We declare and initialize the registers to give the screen and border a color.
// For the color of the screen we use VIC II register 0xD021.
// For the color of the border we use VIC II register 0xD020.
char* const vic_background_color_0 = (char*)0xD021;
char* const vic_border_color = (char*)0xD020;

// We declare and initialize the registers that contain the sprite pointers.
// Sprite pointers refer to the addresses where the sprite drawing is located.
char* const vic_sprite_bitmap_base = (char*)0x07F8;

// We declare the variables to place sprites on the x-axis and y-axis.
char* const vic_sprite_x_base = (char*)0xD000;
char* const vic_sprite_y_base = (char*)0xD001;
char* const vic_sprite_x_msb = (char*)0xD010;

// We declare the variables to give sprites a color.
// There are 8 registers from D027 to D02E that contain the color of sprite 0 to 7.
char* const vic_sprite_color_base = (char*)0xD027;

// We declare the VICII register to show or hide a sprite.
// Each bit represents 1 sprite.
char* const vic_sprite_enable = (char*)0xD015; 

// We declare the VIC II register which contains the current grid (character) line of the screen.
// This grid line register is at address 0xD012 in bit 0 to 7, 
// But register 0xD011 in bit 7, contains the 8th grid line bit which can test the values after 255!
// In other words, if bit 7 of register is 0xD011 at 1, then the scan line is past the 255th line!
char* const vic_raster_low = (char*)0xD012;
char* const vic_raster_high = (char*)0xD011; // We gebruiken hier ENKEL de 7de bit!

// spite_bitmap0
// SOLUTION 15.4:
static __address(0x2000) char sprite_bitmap_0[3*21] = {
0b00000000,	0b00000000,	0b00000000,
0b00000000,	0b00000000,	0b00000000,
0b00000000,	0b00011000,	0b00000000,
0b00000000,	0b00000000,	0b00000000,
0b00000000,	0b01111110,	0b00000000,
0b00000001,	0b11111111,	0b10000000,
0b00000011,	0b11111111,	0b11000000,
0b00000111,	0b11111111,	0b11100000,
0b00011100,	0b10010010,	0b01111000,
0b00000111,	0b11111111,	0b11100000,
0b00000001,	0b11111111,	0b10000000,
0b00000000,	0b01000010,	0b00000000,
0b00000000,	0b10000001,	0b00000000,
0b00000011,	0b00000000,	0b11000000,
0b00000000,	0b00000000,	0b00000000,
0b00000000,	0b00000000,	0b00000000,
0b00000000,	0b00000000,	0b00000000,
0b00000000,	0b00000000,	0b00000000,
0b00000000,	0b00000000,	0b00000000,
0b00000000,	0b00000000,	0b00000000,
0b00000000,	0b00000000,	0b00000000
};

// Ship1
// SOLUTION 15.5:
static __address(0x2040) char sprite_bitmap_1[3*21] = {
0b00000000,	0b00000000,	0b00000000,
0b00000000,	0b00000000,	0b00000000,
0b00000000,	0b00001100,	0b00000000,
0b00000000,	0b00000000,	0b00000000,
0b00000000,	0b01111110,	0b00000000,
0b00000001,	0b11111111,	0b10000000,
0b00000011,	0b11111111,	0b11000000,
0b00000111,	0b11111111,	0b11100000,
0b00011110,	0b01001001,	0b00111000,
0b00000111,	0b11111111,	0b11100000,
0b00000001,	0b11111111,	0b10000000,
0b00000000,	0b01000010,	0b00000000,
0b00000000,	0b10000001,	0b00000000,
0b00000011,	0b00000000,	0b11000000,
0b00000000,	0b00000000,	0b00000000,
0b00000000,	0b00000000,	0b00000000,
0b00000000,	0b00000000,	0b00000000,
0b00000000,	0b00000000,	0b00000000,
0b00000000,	0b00000000,	0b00000000,
0b00000000,	0b00000000,	0b00000000,
0b00000000,	0b00000000,	0b00000000
};

// Ship2
// SOLUTION 15.5:
static __address(0x2080) char sprite_bitmap_2[3*21] = {
0b00000000,	0b00000000,	0b00000000,
0b00000000,	0b00000000,	0b00000000,
0b00000000,	0b00110000,	0b00000000,
0b00000000,	0b00000000,	0b00000000,
0b00000000,	0b01111110,	0b00000000,
0b00000001,	0b11111111,	0b10000000,
0b00000011,	0b11111111,	0b11000000,
0b00000111,	0b11111111,	0b11100000,
0b00011101,	0b00100100,	0b10111000,
0b00000111,	0b11111111,	0b11100000,
0b00000001,	0b11111111,	0b10000000,
0b00000000,	0b01000010,	0b00000000,
0b00000000,	0b10000001,	0b00000000,
0b00000011,	0b00000000,	0b11000000,
0b00000000,	0b00000000,	0b00000000,
0b00000000,	0b00000000,	0b00000000,
0b00000000,	0b00000000,	0b00000000,
0b00000000,	0b00000000,	0b00000000,
0b00000000,	0b00000000,	0b00000000,
0b00000000,	0b00000000,	0b00000000,
0b00000000,	0b00000000,	0b00000000
};

char* sprite_bitmap_array[3] = {sprite_bitmap_0, sprite_bitmap_1, sprite_bitmap_2};


inline void screen_color(char color) {
    // SOLUTION 15.1:
    *vic_background_color_0 = color;
}

inline void border_color(char color) {
    // SOLUTION 15.1:
    *vic_border_color = color;
}

inline void sprite_enable(char sprite) {
    // SOLUTION 15.2:
    // We activate the sprite 0 and 1 by setting bit 0 and 1 to 1 in the enable register.
    *vic_sprite_enable = 1 << sprite;
}

inline void sprite_position_x(char sprite, unsigned int x) {
    // SOLUTION 15.2:
    char* vic_sprite_x = vic_sprite_x_base;
    vic_sprite_x += sprite << 1;
    *vic_sprite_x = BYTE0(x);

    // SOLUTION 15.8:
    if(BYTE1(x))
        *vic_sprite_x_msb = *vic_sprite_x_msb | 1;
    else 
        *vic_sprite_x_msb  = *vic_sprite_x_msb & ~1;
}

inline void sprite_position_y(char sprite, char y) {
    // SOLUTION 15.2:
    char* vic_sprite_y =  vic_sprite_y_base;
    vic_sprite_y += sprite;
    *vic_sprite_y = y;
}

inline void sprite_color(char sprite, char color) {
    // SOLUTION 15.3:
    char* vic_sprite_color = vic_sprite_color_base;
    vic_sprite_color += sprite;
    *vic_sprite_color = color;
}

inline void sprite_bitmap(char sprite, char* bitmap) {
    // SOLUTION 15.2:
    char* vic_sprite_bitmap = vic_sprite_bitmap_base;
    vic_sprite_bitmap += sprite;
    *vic_sprite_bitmap = (char)((unsigned int)bitmap >> 6);
}

int main() {

    // You can skip these 2 instructions (ignore). Here we just put on the Commodore 128
    // the BASIC logic out that the sprite control does.
    // On the Commodore 64, these instructions are not necessary.
    *((char*)0216) = 255;
    *((char*)0xA04) = *((char*)0xA04) & ~1;

    // We clear the screen.
    clrscr();

    // We do a loop in the main logic of this program, and we tested if a key was pressed.
    // The character of the last keystroke used we store in ch, 
    // But now we initialize this value with 0 to indicate that no key was pressed.
    unsigned char ch = 0;

    // This is a work variable that we keep track of to make sure we have the grid line
    // Run logic only if bit 8 of the grid line falls back to 0.
    // I'll explain it in class, why we have and do this.
    // We perform the main logic only if raster_test equals 1.
    unsigned raster_test = 1;

    // We keep track of the x position in a counter.
    // The type of the x position must be an int, 
    // Because the screen has 320 pixels on the x-axis.
    // We only have 256 possible values in a char.
    // So we count with 2 bytes, and we use the type int.
    // SOLUTION 15.7:
    unsigned int x = 24;

    // Here is the sprite telletje, we use it to change the array of sprite bitmaps.
    // SOLUTION 15.6:
    unsigned char sprite_counter = 0;
    
    // This is the counter that counts every frame.
    // SOLUTION 15.6:
    unsigned char frame = 0;




    // We give the screen a color of your choice.
    // SOLUTION 15.1:
    screen_color(1);

    // We give the border a color of your choice.
    // SOLUTION 15.1:
    border_color(1);

    // We activate sprite 0.
    // SOLUTION 15.2:
    sprite_enable(0);

    // We set the sprite pointer to the address of the sprite bitmap.
    // SOLUTION 15.2:
    sprite_bitmap(0, sprite_bitmap_0);

    // We put the sprite at a position on the x-axis an y-axis.
    // SOLUTION 15.2:
    sprite_position_x(0, 100);
    sprite_position_y(0, 100);

    // We set the color of the sprites to a color of your choice.
    // SOLUTION 15.3:
    sprite_color(0, 0);


    // We continue to run this logic until a key is pressed.
    while(!ch) {

        // We tested whether we can raster_lijn tested and whether the 8th bit of the grid is set to 1.
        // If the value of this bit is on, then we execute the logic.
        if(raster_test && *vic_raster_high & 0x80) {

            // We put the sprite 0 x-axis an y-axis.
            // SOLUTION 15.7:
            sprite_position_x(0, x);

            sprite_position_y(0, 100);

            // We put the sprite pointer at the address of the sprite_bitmap counter.
            // SOLUTION 15.6:
            sprite_bitmap(0, sprite_bitmap_array[sprite_counter]);


            // We now position our sprite at position +1 on the x-axis.
            // If the position is equal to 0 (EXERCISE 15.7), 
            // or equal to 320 (EXERCISE 15.8),
            // Then we position our sprite at position 24, the starting position.
            // SOLUTION 15.7 and 15.8 :
            if(x < 320) {
                x++;
            } else {
                x = 24;
            }

            // Here we add 1 to frame to keep track of how many frames we have had.
            // SOLUTION 15.6:
            frame += 1;

            // To ensure that we sprite_bitmap increase every 16 frames, 
            // we calculate the current frame AND 0b00010000.
            // If the result is not 0, then the logic of the if is executed.
            if((frame & 0x0F) == 0x0F) {
                sprite_counter++;             // We now increase the counter sprite_bitmap by 1. 
                if(sprite_counter == 3) {     // If sprite_bitmap equals 3?
                    sprite_counter = 0;       // Then we put sprite_bitmap back to 0.
                }
            }

            // We just read a character from the keyboard.
            ch = kbhit();

            // To ensure that we only run the logic 1 time, we put it
            // raster_test flag at 0.
            // We perform the main logic only if raster_test equals 1.
            raster_test = 0;

        } else {
            // Otherwise... Now we tested whether we can test the current grid line.
            // If we are allowed to test raster_lijn, so if raster_test equals 0
            // AND or bit 8 of grid line equals 0.
            if(!raster_test && !(*vic_raster_high & 0x80)) {
                raster_test = 1; // Then we put raster_test back to 1;
            }
        }

    }

    return 1;
}
