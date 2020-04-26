// Commodore 64 Registers and Constants

// Processor port data direction register
char*  const PROCPORT_DDR = $00;
// Mask for PROCESSOR_PORT_DDR which allows only memory configuration to be written
const char PROCPORT_DDR_MEMORY_MASK = %00000111;

// Processor Port Register controlling RAM/ROM configuration and the datasette
char*  const PROCPORT = $01;
// RAM in all three areas $A000, $D000, $E000
const char PROCPORT_RAM_ALL         = %00000000;
// RAM in $A000, $E000 I/O in $D000
const char PROCPORT_RAM_IO          = %00000101;
// RAM in $A000, $E000 CHAR ROM in $D000
const char PROCPORT_RAM_CHARROM     = %00000001;
// RAM in $A000, I/O in $D000, KERNEL in $E000
const char PROCPORT_KERNEL_IO       = %00000110;
// BASIC in $A000, I/O in $D000, KERNEL in $E000
const char PROCPORT_BASIC_KERNEL_IO = %00000111;

// The address of the CHARGEN character set
char*  const CHARGEN = $d000;

// Positions of the border (in sprite positions)
const char BORDER_XPOS_LEFT=24;
const unsigned int BORDER_XPOS_RIGHT=344;
const char BORDER_YPOS_TOP=50;
const char BORDER_YPOS_BOTTOM=250;

// The offset of the sprite pointers from the screen start address
const unsigned int SPRITE_PTRS = $3f8;

char*  const SPRITES_XPOS = $d000;
char*  const SPRITES_YPOS = $d001;
char*  const SPRITES_XMSB = $d010;
char*  const RASTER = $d012;
char*  const SPRITES_ENABLE = $d015;
char*  const SPRITES_EXPAND_Y = $d017;
char*  const SPRITES_PRIORITY = $d01b;
char*  const SPRITES_MC = $d01c;
char*  const SPRITES_EXPAND_X = $d01d;
char*  const BORDERCOL = $d020;
char*  const BGCOL = $d021;
char*  const BGCOL1 = $d021;
char*  const BGCOL2 = $d022;
char*  const BGCOL3 = $d023;
char*  const BGCOL4 = $d024;
char*  const SPRITES_MC1 = $d025;
char*  const SPRITES_MC2 = $d026;
char*  const SPRITES_COLS = $d027;

char*  const VIC_CONTROL = $d011;
char*  const D011 = $d011;
const char VIC_RST8 = %10000000;
const char VIC_ECM =  %01000000;
const char VIC_BMM =  %00100000;
const char VIC_DEN =  %00010000;
const char VIC_RSEL = %00001000;

char*  const VIC_CONTROL2 = $d016;
char*  const D016 = $d016;
const char VIC_MCM =  %00010000;
const char VIC_CSEL = %00001000;

char*  const D018 = $d018;
char*  const VIC_MEMORY = $d018;

char*  const LIGHTPEN_X = $d013;
char*  const LIGHTPEN_Y = $d014;

// VIC II IRQ Status Register
char*  const IRQ_STATUS = $d019;
// VIC II IRQ Enable Register
char*  const IRQ_ENABLE = $d01a;
// Bits for the IRQ Status/Enable Registers
const char IRQ_RASTER = %00000001;
const char IRQ_COLLISION_BG = %00000010;
const char IRQ_COLLISION_SPRITE = %00000100;
const char IRQ_LIGHTPEN = %00001000;

// Color Ram
char*  const COLS = $d800;

// The MOS 6526 Complex Interface Adapter (CIA)
// http://archive.6502.org/datasheets/mos_6526_cia_recreated.pdf
struct MOS6526_CIA {
    // Port A
    char PORT_A;
    // Port B
    char PORT_B;
    // Port A data direction register.
    char PORT_A_DDR;
    // Port B data direction register.
    char PORT_B_DDR;
    // Timer A Value
    unsigned int TIMER_A;
    // Timer B Value
    unsigned int TIMER_B;
    // Time-of-day real-time-clock tenth seconds (BCD)
    char TOD_10THS;
    // Time-of-day real-time-clock seconds (BCD)
    char TOD_SEC;
    // Time-of-day real-time-clock minutes (BCD)
    char TOD_MIN;
    // Time-of-day real-time-clock hours (BCD)
    char TOD_HOURS;
    // Serial Shift Register
    char SERIAL_DATA;
    // Interrupt Status & Control Register
    char INTERRUPT;
    // Timer A Control Register
    char TIMER_A_CONTROL;
    // Timer B Control Register
    char TIMER_B_CONTROL;
};

// The CIA#1: keyboard matrix, joystick #1/#2
struct MOS6526_CIA * const CIA1 = 0xdc00;

// The CIA#2: Serial bus, RS-232, VIC memory bank
struct MOS6526_CIA * const CIA2 = 0xdd00;

// CIA#1 Interrupt for reading in ASM
char * const CIA1_INTERRUPT = 0xdc0d;
// CIA#2 Interrupt for reading in ASM
char * const CIA2_INTERRUPT = 0xdd0d;
// CIA#2 timer A&B as one single 32-bit value
unsigned long* const CIA2_TIMER_AB = 0xdd04;

// Value that disables all CIA interrupts when stored to the CIA Interrupt registers
const char CIA_INTERRUPT_CLEAR = $7f;

// Timer Control - Start/stop timer (0:stop, 1: start)
const char CIA_TIMER_CONTROL_STOP = 0b00000000;
// Timer Control - Start/stop timer (0:stop, 1: start)
const char CIA_TIMER_CONTROL_START = 0b00000001;
// Timer Control - Time CONTINUOUS/ONE-SHOT (0:CONTINUOUS, 1: ONE-SHOT)
const char CIA_TIMER_CONTROL_CONTINUOUS = 0b00000000;
// Timer Control - Time CONTINUOUS/ONE-SHOT (0:CONTINUOUS, 1: ONE-SHOT)
const char CIA_TIMER_CONTROL_ONESHOT = 0b00001000;
// Timer A Control - Timer counts (0:system cycles, 1: CNT pulses)
const char CIA_TIMER_CONTROL_A_COUNT_CYCLES = 0b00000000;
// Timer A Control - Timer counts (0:system cycles, 1: CNT pulses)
const char CIA_TIMER_CONTROL_A_COUNT_CNT = 0b00100000;
// Timer A Control - Serial Port Mode (0: Serial Port Input, 1: Serial Port Output)
const char CIA_TIMER_CONTROL_A_SERIAL_IN = 0b00000000;
// Timer A Control - Serial Port Mode (0: Serial Port Input, 1: Serial Port Output)
const char CIA_TIMER_CONTROL_A_SERIAL_OUT = 0b01000000;
// Timer A Control - time-of-day clock Mode (0: 60Hz, 1: 50Hz)
const char CIA_TIMER_CONTROL_A_TOD_60HZ = 0b00000000;
// Timer A Control - time-of-day clock Mode (0: 60Hz, 1: 50Hz)
const char CIA_TIMER_CONTROL_A_TOD_50HZ = 0b10000000;
// Timer B Control - Timer counts (00:system cycles, 01: CNT pulses, 10: timer A underflow, 11: time A underflow while CNT is high)
const char CIA_TIMER_CONTROL_B_COUNT_CYCLES = 0b00000000;
// Timer B Control - Timer counts (00:system cycles, 01: CNT pulses, 10: timer A underflow, 11: time A underflow while CNT is high)
const char CIA_TIMER_CONTROL_B_COUNT_CNT = 0b00100000;
// Timer B Control - Timer counts (00:system cycles, 01: CNT pulses, 10: timer A underflow, 11: time A underflow while CNT is high)
const char CIA_TIMER_CONTROL_B_COUNT_UNDERFLOW_A = 0b01000000;
// Timer B Control - Timer counts (00:system cycles, 01: CNT pulses, 10: timer A underflow, 11: time A underflow while CNT is high)
const char CIA_TIMER_CONTROL_B_COUNT_UNDERFLOW_A_CNT = 0b01100000;
// Timer B Control - time-of-day write mode (0: TOD clock, 1: TOD alarm)
const char CIA_TIMER_CONTROL_B_TOD_CLOCK_SET = 0b00000000;
// Timer B Control - time-of-day write mode (0: TOD clock, 1: TOD alarm)
const char CIA_TIMER_CONTROL_B_TOD_ALARM_SET = 0b10000000;

// The vector used when the KERNAL serves IRQ interrupts
void()** const KERNEL_IRQ = $0314;
// The vector used when the KERNAL serves NMI interrupts
void()** const KERNEL_NMI = $0318;

// The vector used when the HARDWARE serves IRQ interrupts
void()** const HARDWARE_IRQ = $fffe;

// The SID volume
char*  const SID_VOLUME = $d418;


// The colors of the C64
const char BLACK = $0;
const char WHITE = $1;
const char RED = $2;
const char CYAN = $3;
const char PURPLE = $4;
const char GREEN = $5;
const char BLUE = $6;
const char YELLOW = $7;
const char ORANGE = $8;
const char BROWN = $9;
const char PINK = $a;
const char DARK_GREY= $b;
const char GREY = $c;
const char LIGHT_GREEN = $d;
const char LIGHT_BLUE = $e;
const char LIGHT_GREY = $f;

// Get the value to store into D018 to display a specific screen and charset/bitmap
// Optimized for ASM from (char)((((unsigned int)screen&0x3fff)/$40)|(((unsigned int)charset&$3fff)/$400));
inline char toD018(char*  screen, char*  gfx);

// Get the value to store into DD00 (CIA 2 port A) to choose a specific VIC bank
// Optimized for ASM from %00000011 ^ (char)((unsigned int)gfx/$4000)
inline char toDd00(char*  gfx);

// Get the sprite pointer for a sprite.
// The sprite pointer is the index of the sprite within the graphics bank and equal to the sprite (char)(sprite_addr/64)
// The sprite pointers are stored SCREEN+$3f8+sprite_id to set the pointer of each sprite
inline char toSpritePtr(char*  sprite);

// Select a specific VIC graphics bank by setting the CIA 2 port A ($dd00) as needed
inline void vicSelectGfxBank(char*  gfx);
