/**
 * @file cx16-mouse.c
 * @author Sven Van de Velde (sven.van.de.velde@telenet.be)
 * @brief  See documentation of the [mouse pointer](https://github.com/commanderx16/x16-docs/blob/master/X16%20Reference%20-%2004%20-%20KERNAL.md#mouse) in the commander X16 manual:
 * 
 * @note Compatible ONLY with the commander X16 version R39 ROM.
 * 
 * @version 0.1
 * @date 2022-03-31
 * 
 * @copyright Copyright (c) 2022
 * 
 */

#include <cx16-mouse.h>

// The mouse work area.

__mem cx16_mouse_t cx16_mouse;

/**
 * @brief Configures the mouse pointer.
 * 
 * 
 * @param visible Turn the mouse pointer on or off. Provide a value of 0xFF to set your own mouse pointer graphic (sprite 0).
 * @param scalex Specify x axis screen resolution in 8 pixel increments.
 * @param scaley Specify y axis screen resolution in 8 pixel increments.
 * 
 */
void cx16_mouse_config(char visible, char scalex, char scaley) 
{
    asm {
        //.byte $db
        lda visible
        ldx scalex
        ldy scaley
        jsr CX16_MOUSE_CONFIG
    }
}

/**
 * @brief Scan the mouse
 * 
 */
void cx16_mouse_scan() 
{
    asm {
        // .byte $db
        jsr CX16_MOUSE_SCAN
    }
}

/**
 * @brief Retrieves the status of the mouse pointer and will fill the mouse position in the defined mouse registers.
 * 
 * @return char Current mouse status.
 * 
 * The pre-defined variables cx16_mousex and cx16_mousey contain the position of the mouse pointer.
 * 
 *     volatile int cx16_mousex = 0;
 *     volatile int cx16_mousey = 0;
 * 
 * The state of the mouse buttons is returned:
 * 
 *   |Bit|Description|
 *   |---|-----------|
 *   |0|Left Button|
 *   |1|Right Button|
 *   |2|Middle Button|
 * 
 *   If a button is pressed, the corresponding bit is set.
 */
char cx16_mouse_get() 
{
    __mem char status;
    __address(0xfc) int x;
    __address(0xfe) int y;

    cx16_mouse.px = cx16_mouse.x;
    cx16_mouse.py = cx16_mouse.y;

    asm {
        // .byte $db
        ldx #$fc
        jsr CX16_MOUSE_GET
        sta status
    }

    cx16_mouse.x = x;
    cx16_mouse.y = y;
    cx16_mouse.status = status;
    
    return status;
}
