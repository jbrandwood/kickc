// ATARI Graphic Television Interface Adaptor (GTIA)
// Used in Atari 5200 and the 8-bit series (400, 800, XL, XE)
// https://en.wikipedia.org/wiki/CTIA_and_GTIA

struct ATARI_GTIA_READ {
    // Missile 0 to Playfield collisions	Read	$D000
    char M0PF;
    // Missile 1 to Playfield collisions	Read	$D001
    char M1PF;
    // Missile 2 to Playfield collisions	Read	$D002
    char M2PF;
    // Missile 3 to Playfield collisions	Read	$D003
    char M3PF;
    // Player 0 to Playfield collisions	Read	$D004
    char P0PF;
    // Player 1 to Playfield collisions	Read	$D005
    char P1PF;
    // Player 2 to Playfield collisions	Read	$D006
    char P2PF;
    // Player 3 to Playfield collisions	Read	$D007
    char P3PF;
    // Missile 0 to Player collisions	Read	$D008
    char M0PL;
    // Missile 1 to Player collisions	Read	$D009
    char M1PL;
    // Missile 2 to Player collisions	Read	$D00A
    char M2PL;
    // Missile 3 to Player collisions	Read	$D00B
    char M3PL;
    // Player 0 to Player collisions	Read	$D00C
    char P0PL;
    // Player 1 to Player collisions	Read	$D00D
    char P1PL;
    // Player 2 to Player collisions	Read	$D00E
    char P2PL;
    // Player 3 to Player collisions	Read	$D00F
    char P3PL;
    // Joystick 0 trigger.	Read	$D010
    char TRIG0;
    // Joystick 1 trigger.	Read	$D011
    char TRIG1;
    // Joystick 2 trigger.	Read	$D012
    char TRIG2;
    // Joystick 3 trigger.	Read	$D013
    char TRIG3;
    // flags.	Read	$D014
    char PAL;
    // Unused READ registers
    char UNUSED[10];
    // Console Keys	Read	$D01F
    char CONSOL;
};

struct ATARI_GTIA_WRITE {
    // Horizontal Position of Player 0	Write	$D000
    char HPOSP0;
    // Horizontal Position of Player 1	Write	$D001
    char HPOSP1;
    // Horizontal Position of Player 2	Write	$D002
    char HPOSP2;
    // Horizontal Position of Player 3	Write	$D003
    char HPOSP3;
    // Horizontal Position of Missile 0	Write	$D004
    char HPOSM0;
    // Horizontal Position of Missile 1	Write	$D005
    char HPOSM1;
    // Horizontal Position of Missile 2	Write	$D006
    char HPOSM2;
    // Horizontal Position of Missile 3	Write	$D007
    char HPOSM3;
    // Size of Player 0	Write	$D008
    char SIZEP0;
    // Size of Player 1	Write	$D009
    char SIZEP1;
    // Size of Player 2	Write	$D00A
    char SIZEP2;
    // Size of Player 3	Write	$D00B
    char SIZEP3;
    // Size of all Missiles	Write	$D00C
    char SIZEM;
    // Graphics pattern for Player 0	Write	$D00D
    char GRAFP0;
    // Graphics pattern for Player 1	Write	$D00E
    char GRAFP1;
    // Graphics pattern for Player 2	Write	$D00F
    char GRAFP2;
    // Graphics pattern for Player 3	Write	$D010
    char GRAFP3;
    // Graphics pattern for all Missiles	Write	$D011
    char GRAFM;
    // Color/luminance of Player and Missile 0.	Write	$D012
    char COLPM0;
    // Color/luminance of Player and Missile 1.	Write	$D013
    char COLPM1;
    // Color/luminance of Player and Missile 2.	Write	$D014
    char COLPM2;
    // Color/luminance of Player and Missile 3.	Write	$D015
    char COLPM3;
    // Color/luminance of Playfield 0.	Write	$D016	53270
    char COLPF0;
    // Color/luminance of Playfield 1.	Write	$D017	53271
    char COLPF1;
    // Color/luminance of Playfield 2.	Write	$D018	53272
    char COLPF2;
    // Color/luminance of Playfield 3.	Write	$D019	53273
    char COLPF3;
    // Color/luminance of Playfield background.	Write	$D01A
    char COLBK;
    // Priority selection, fifth player, and GTIA modes	Write
    char PRIOR;
    // Vertical Delay P/M Graphics	Write	$D01C
    char VDELAY;
    // Graphics Control.	Write	$D01D
    char GRACTL;
    // Clear Collisions	Write	$D01E
    char HITCLR;
    // Console Speaker	Write	$D01F
    char CONSPK;
};