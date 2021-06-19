/// @file
/// Atari Television Interface Adaptor (TIA)
/// https://en.wikipedia.org/wiki/Television_Interface_Adaptor
/// http://www.qotile.net/minidig/docs/stella.pdf
/// Based on https://github.com/munsie/dasm/blob/master/machines/atari2600/vcs.h

/// The number of CPU cycles per scanline
const char CYCLES_PER_SCANLINE = 76;

/// The TIA WSYNC register (for access from inline ASM)
char* const TIA_WSYNC = (char*)0x02;
/// The TIA RESP0 register (for access from inline ASM)
char* const TIA_RESP0 = (char*)0x10;
/// The TIA RESP1 register (for access from inline ASM)
char* const TIA_RESP1 = (char*)0x11;
/// The TIA HMP0 register (for access from inline ASM)
char* const TIA_HMP0 = (char*)0x20;

/// Atari Television Interface Adaptor (TIA)
struct ATARI_TIA_WRITE {
    /// $00   0000 00x0   Vertical Sync Set-Clear
    char VSYNC;
    /// $01   xx00 00x0   Vertical Blank Set-Clear
    char VBLANK;
    /// $02   ---- ----   Wait for Horizontal Blank
    char WSYNC;
    /// $03   ---- ----   Reset Horizontal Sync Counter
    char RSYNC;
    /// $04   00xx 0xxx   Number-Size player/missle 0
    char NUSIZ0;
    /// $05   00xx 0xxx   Number-Size player/missle 1
    char NUSIZ1;
    /// $06   xxxx xxx0   Color-Luminance Player 0
    char COLUP0;
    /// $07   xxxx xxx0   Color-Luminance Player 1
    char COLUP1;
    /// $08   xxxx xxx0   Color-Luminance Playfield
    char COLUPF;
    /// $09   xxxx xxx0   Color-Luminance Background
    char COLUBK;
    /// $0A   00xx 0xxx   Control Playfield, Ball, Collisions
    char CTRLPF;
    /// $0B   0000 x000   Reflection Player 0
    char REFP0;
    /// $0C   0000 x000   Reflection Player 1
    char REFP1;
    /// $0D   xxxx 0000   Playfield Register Byte 0
    char PF0;
    /// $0E   xxxx xxxx   Playfield Register Byte 1
    char PF1;
    /// $0F   xxxx xxxx   Playfield Register Byte 2
    char PF2;
    /// $10   ---- ----   Reset Player 0
    char RESP0;
    /// $11   ---- ----   Reset Player 1
    char RESP1;
    /// $12   ---- ----   Reset Missle 0
    char RESM0;
    /// $13   ---- ----   Reset Missle 1
    char RESM1;
    /// $14   ---- ----   Reset Ball
    char RESBL;
    /// $15   0000 xxxx   Audio Control 0
    char AUDC0;
    /// $16   0000 xxxx   Audio Control 1
    char AUDC1;
    /// $17   000x xxxx   Audio Frequency 0
    char AUDF0;
    /// $18   000x xxxx   Audio Frequency 1
    char AUDF1;
    /// $19   0000 xxxx   Audio Volume 0
    char AUDV0;
    /// $1A   0000 xxxx   Audio Volume 1
    char AUDV1;
    /// $1B   xxxx xxxx   Graphics Register Player 0
    char GRP0;
    /// $1C   xxxx xxxx   Graphics Register Player 1
    char GRP1;
    /// $1D   0000 00x0   Graphics Enable Missile 0
    char ENAM0;
    /// $1E   0000 00x0   Graphics Enable Missile 1
    char ENAM1;
    /// $1F   0000 00x0   Graphics Enable Ball
    char ENABL;
    /// $20   xxxx 0000   Horizontal Motion Player 0
    char HMP0;
    /// $21   xxxx 0000   Horizontal Motion Player 1
    char HMP1;
    /// $22   xxxx 0000   Horizontal Motion Missile 0
    char HMM0;
    /// $23   xxxx 0000   Horizontal Motion Missile 1
    char HMM1;
    /// $24   xxxx 0000   Horizontal Motion Ball
    char HMBL;
    /// $25   0000 000x   Vertical Delay Player 0
    char VDELP0;
    /// $26   0000 000x   Vertical Delay Player 1
    char VDELP1;
    /// $27   0000 000x   Vertical Delay Ball
    char VDELBL;
    /// $28   0000 00x0   Reset Missile 0 to Player 0
    char RESMP0;
    /// $29   0000 00x0   Reset Missile 1 to Player 1
    char RESMP1;
    /// $2A   ---- ----   Apply Horizontal Motion
    char HMOVE;
    /// $2B   ---- ----   Clear Horizontal Move Registers
    char HMCLR;
    /// $2C   ---- ----   Clear Collision Latches
    char CXCLR;
};

/// Atari Television Interface Adaptor (TIA)
struct ATARI_TIA_READ {
    ///                                bit 7   bit 6
    /// $00 xx00 0000  Read Collision  M0-P1   M0-P0
    char CXM0P;
    /// $01 xx00 0000  Read Collision  M1-P0   M1-P1
    char CXM1P;
    /// $02 xx00 0000  Read Collision  P0-PF   P0-BL
    char CXP0FB;
    /// $03 xx00 0000  Read Collision  P1-PF   P1-BL
    char CXP1FB;
    /// $04 xx00 0000  Read Collision  M0-PF   M0-BL
    char CXM0FB;
    /// $05 xx00 0000  Read Collision  M1-PF   M1-BL
    char CXM1FB;
    /// $06 x000 0000  Read Collision  BL-PF   -----
    char CXBLPF;
    /// $07 xx00 0000  Read Collision  P0-P1   M0-M1
    char CXPPMM;
    /// $08 x000 0000  Read Pot Port 0
    char INPT0;
    /// $09 x000 0000  Read Pot Port 1
    char INPT1;
    /// $0A x000 0000  Read Pot Port 2
    char INPT2;
    /// $0B x000 0000  Read Pot Port 3
    char INPT3;
    /// $0C x000 0000  Read Input (Trigger) 0
    char INPT4;
    /// $0D x000 0000  Read Input (Trigger) 1
    char INPT5;
};

