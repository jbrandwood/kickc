#include <c64.h>
#include <print.h>

byte* SCREEN = $0400;

// joystick
byte* JOY2 = $dc00;
const byte JOY_UP = 1;
const byte JOY_DOWN = 2;
const byte JOY_LEFT = 4;
const byte JOY_RIGHT = 8;
const byte JOY_FIRE = 16;

// game states
const byte TITLE_FADE_IN = 1;
const byte TITLE_MAIN = 2;
const byte TITLE_FADE_OUT = 3;

const byte GAME_FADE_IN = 10;
const byte GAME_FADE_OUT = 11;

const byte GAME_LIVE_WAIT = 20;
const byte GAME_LIVE_WEAPON_PLUS = 21;
const byte GAME_LIVE_WEAPON_MINUS = 22;
const byte GAME_LIVE_PATH_PLUS = 23;
const byte GAME_LIVE_PATH_MINUS = 24;
const byte GAME_LIVE_READY = 25;
const byte GAME_LIVE_AIM = 26;
const byte GAME_LIVE_FIRE = 27;

const byte GAME_DEAD_FALL = 100;
const byte GAME_DEAD_WAIT = 101;

// control speeds
const byte WEAPON_SWITCH_FRAMES = 4;
const byte PATH_SWITCH_FRAMES = 8;
const byte READY_FRAMES = 4;
const byte DEAD_FALL_FRAMES = 20;
const byte DEAD_WAIT_FRAMES = 10;

//
byte main_state = TITLE_FADE_IN;
byte action_count = 0;

byte fade_in_title() {
fillscreen(SCREEN, $20);
print_str("lone archer -- title");
print_ln();
return 1;
}

byte fade_out_title() {
fillscreen(SCREEN, $20);
return 1;
}

void title_main() {
state1 = 0;
do {
do {} while (*RASTER!=$fe);
if (main_state == TITLE_FADE_IN) {
if (fade_in_title())
main_state = TITLE_MAIN;
} else if (main_state == TITLE_MAIN) {
if (*JOY2 & JOY_FIRE == 0)
main_state = TITLE_FADE_OUT;
} else if (main_state == TITLE_FADE_OUT) {
if (fade_out_title())
main_state = GAME_FADE_IN;
}
} while (main_state <= TITLE_FADE_OUT);
}

byte fade_in_game() {
fillscreen(SCREEN, $20);
print_str("lone archer -- game");
print_ln();
return 1;
}

byte fade_out_game() {
fillscreen(SCREEN, $20);
return 1;
}

byte game_weapon_plus() {
if (action_count == 0)
action_count = WEAPON_SWITCH_FRAMES;
print_str("weapon plus");
print_ln();
action_count--;
return (action_count==0);
}

byte game_weapon_minus() {
if (action_count == 0)
action_count = WEAPON_SWITCH_FRAMES;
print_str("weapon minus");
print_ln();
action_count--;
return (action_count==0);
}

byte game_path_plus() {
if (action_count == 0)
action_count = PATH_SWITCH_FRAMES;
print_str("path plus");
print_ln();
action_count--;
return (action_count==0);
}

byte game_path_minus() {
if (action_count == 0)
action_count = PATH_SWITCH_FRAMES;
print_str("path minus");
print_ln();
action_count--;
return (action_count==0);
}

byte game_ready() {
if (action_count == 0)
action_count = READY_FRAMES;
print_str("ready");
print_ln();
action_count--;
return (action_count==0);
}

byte game_aim() {
byte joy = *JOY2;
if (joy & JOY_FIRE == 1)
main_state = GAME_LIVE_FIRE;
else if (joy & JOY_LEFT == 0)
print_str("<");
else if (joy & JOY_RIGHT == 0)
print_str(">");
else if (joy & JOY_UP == 0)
print_str("u");
else if (joy & JOY_DOWN == 0)
print_str("d");
}

byte game_fire() {
print_str("fire!");
print_ln();
return 1;
}

byte game_dead_fall() {
if (action_count == 0)
action_count = DEAD_FALL_FRAMES;
print_str("dead fall...");
print_ln();
action_count--;
return (action_count==0);
}

byte game_dead_wait() {
if (action_count == 0)
action_count = DEAD_WAIT_FRAMES;
print_str("dead wait...");
print_ln();
action_count--;
return (action_count==0);
}

byte game_run_frame() {
print_str("-");
return 0;
}

void game_main() {
do {
if (main_state == GAME_FADE_IN) {
if (fade_in_game())
main_state = GAME_LIVE_WAIT;
} else if (main_state == GAME_FADE_OUT) {
if (fade_out_game())
main_state = TITLE_FADE_IN;
} else if (main_state == GAME_LIVE_WAIT) {
byte joy = *JOY2;
if (joy & JOY_FIRE == 0)
main_state = GAME_LIVE_DRAW;
else if (joy & JOY_LEFT == 0)
main_state = GAME_LIVE_WEAPON_MINUS;
else if (joy & JOY_RIGHT == 0)
main_state = GAME_LIVE_WEAPON_PLUS;
else if (joy & JOY_UP == 0)
main_state = GAME_LIVE_PATH_PLUS;
else if (joy & JOY_DOWN == 0)
main_state = GAME_LIVE_PATH_MINUS;
} else if (main_state == GAME_LIVE_WEAPON_PLUS) {
if (game_weapon_plus())
main_state = GAME_LIVE_WAIT;
} else if (main_state == GAME_LIVE_WEAPON_MINUS) {
if (game_weapon_minus())
main_state = GAME_LIVE_WAIT;
} else if (main_state == GAME_LIVE_PATH_PLUS) {
if (game_path_plus())
main_state = GAME_LIVE_WAIT;
} else if (main_state == GAME_LIVE_PATH_MINUS) {
if (game_path_minus())
main_state = GAME_LIVE_WAIT;
} else if (main_state == GAME_LIVE_READY) {
if (game_ready())
main_state = GAME_LIVE_AIM;
} else if (main_state == GAME_LIVE_AIM) {
if (game_aim())
main_state = GAME_LIVE_FIRE;
} else if (main_state == GAME_LIVE_FIRE) {
if (game_fire())
main_state = GAME_LIVE_WAIT;
} else if (main_state == GAME_DEAD_FALL) {
if (game_dead_fall())
main_state = GAME_DEAD_WAIT;
} else if (main_state == GAME_DEAD_WAIT) {
if (game_dead_wait())
main_state = GAME_FADE_OUT;
}
if (game_run_frame())
main_state = GAME_DEAD_FALL;
} while (main_state >= GAME_FADE_IN);
}

void main() {
main_state = TITLE_FADE_IN;
do {
title_main();
game_main();
} while (true);
}