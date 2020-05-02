// Tetris Game for the Commodore 64
// The tetris game tries to match NES tetris gameplay pretty closely
// Source: https://meatfighter.com/nintendotetrisai/

#include <c64.h>
#include <keyboard.h>
#include "tetris-data.c"
#include "tetris-render.c"
#include "tetris-sprites.c"
#include "tetris-play.c"

void main() {
	sid_rnd_init();
	asm { sei }
	render_init();
	sprites_init();
	sprites_irq_init();
	play_init();
	// Spawn twice to spawn both current & next
	play_spawn_current();
	play_spawn_current();
	render_playfield();
	render_moving();
	render_next();
	while(true) {
		// Wait for a frame to pass
		while(*RASTER!=0xff) {}
		//*BORDER_COLOR = render_screen_show/0x10;
		// Update D018 to show the selected screen
        render_show();
		// Scan keyboard events
		keyboard_event_scan();
		char key_event = keyboard_event_get();
		char render = 0;
		if(game_over==0) {
		    render = play_movement(key_event);
		} else {
		    while(true) {
		        (*BORDER_COLOR)++;
		    }
		}
		if(render!=0) {
			render_playfield();
			render_moving();
			render_next();
			render_score();
			render_screen_swap();
		}
		//*BORDER_COLOR = 0;
	}
}
