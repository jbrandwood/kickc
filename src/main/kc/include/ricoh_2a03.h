// Ricoh 2A03 Nintendo Entertainment System CPU and audio processing unit (APU)
// Ricoh 2A03 or RP2A03 (NTSC version) / Ricoh 2A07 or RP2A07 (PAL version)
// https://en.wikipedia.org/wiki/Ricoh_2A03
// https://www.nesdev.com/2A03%20technical%20reference.txt
// https://wiki.nesdev.com/w/index.php/2A03
// https://wiki.nesdev.com/w/index.php/APU
// Based on: https://github.com/gregkrsak/first_nes written by Greg M. Krsak, 2018. 


// The APU (Audio Processing Unit) is the sound hardware the NES console which generates sound.
struct RICOH_2A03 {
    // APU Square wave channels 1 and 2
    // Reference: https://wiki.nesdev.com/w/index.php/APU_Pulse
    // Duty and volume for square wave 1
    // $4000	SQ1_VOL	Duty and volume for square wave 1
    char SQ1_VOL;
    // $4001	SQ1_SWEEP	Sweep control register for square wave 1
    char SQ1_SWEEP;
    // $4002	SQ1_LO	Low byte of period for square wave 1
    char SQ1_LO;
    // $4003	SQ1_HI	High byte of period and length counter value for square wave 1
    char SQ1_HI;
    // $4004	SQ2_VOL	Duty and volume for square wave 2
    char SQ2_VOL;
    // $4005	SQ2_SWEEP	Sweep control register for square wave 2
    char SQ2_SWEEP;
    // $4006	SQ2_LO	Low byte of period for square wave 2
    char SQ2_LO;
    // $4007	SQ2_HI	High byte of period and length counter value for square wave 2
    char SQ2_HI; 
    // APU Triangle wave channel
    // Reference: https://wiki.nesdev.com/w/index.php/APU_Triangle
    // $4008	TRI_LINEAR	Triangle wave linear counter
    char TRI_LINEAR;
    // $4009		Unused, but is eventually accessed in memory-clearing loops
    char UNUSED1;
    // $400A	TRI_LO	Low byte of period for triangle wave
    char TRI_LO;
    // $400B	TRI_HI	High byte of period and length counter value for triangle wave
    char TRI_HI;
    // APU Noise generator
    // Reference: https://wiki.nesdev.com/w/index.php/APU_Noise
    // $400C	NOISE_VOL	Volume for noise generator
    char NOISE_VOL;
    // $400D		Unused, but is eventually accessed in memory-clearing loops
    char UNUSED2;
    // $400E	NOISE_LO	Period and waveform shape for noise generator
    char NOISE_LO;
    // $400F	NOISE_HI	Length counter value for noise generator
    char NOISE_HI;
    // APU Delta Modulation Channel
    // Reference: https://wiki.nesdev.com/w/index.php/APU_DMC
    //  ------+-----+---------------------------------------------------------------
    //  $4010 |	 W  | DMC_FREQ	Play mode FLAGS and frequency for DMC samples
    //  ------+-----+---------------------------------------------------------------
    //        |   7	| IRQ enabled flag. If clear, the interrupt flag is cleared.
    //        |   6	| Loop flag
    //        | 3-0	| Rate index
    //  ------+-----+---------------------------------------------------------------
    //  Rate   $0   $1   $2   $3   $4   $5   $6   $7   $8   $9   $A   $B   $C   $D   $E   $F
    //        ------------------------------------------------------------------------------
    //  NTSC  428, 380, 340, 320, 286, 254, 226, 214, 190, 160, 142, 128, 106,  84,  72,  54
    //  PAL   398, 354, 316, 298, 276, 236, 210, 198, 176, 148, 132, 118,  98,  78,  66,  50
    //
    //  The rate determines for how many CPU cycles happen between changes in the output level during automatic delta-encoded sample playback. 
    //  For example, on NTSC (1.789773 MHz), a rate of 428 gives a frequency of 1789773/428 Hz = 4181.71 Hz. 
    //  These periods are all even numbers because there are 2 CPU cycles in an APU cycle. A rate of 428 means the output level changes every 214 APU cycles.    
    char DMC_FREQ;
    // $4011	DMC_RAW	7-bit DAC
    char DMC_RAW;
    // $4012	DMC_START	Start of DMC waveform is at address $C000 + $40*$xx
    char DMC_START;
    // $4013	DMC_LEN	Length of DMC waveform is $10*$xx + 1 bytes (128*$xx + 8 samples)
    char DMC_LEN;
    // $4014	OAMDMA	Writing $xx copies 256 bytes by reading from $xx00-$xxFF and writing to OAMDATA ($2004). The CPU is suspended while the transfer is taking place.
    // Reference: https://wiki.nesdev.com/w/index.php/PPU_registers#OAMDMA
    char OAMDMA;
    // ------+-----+---------------------------------------------------------------
    // $4015 |  W  | Sound Channel Switch
    //       |   0 | Channel 1, 1 = enable sound.
    //       |   1 | Channel 2, 1 = enable sound.
    //       |   2 | Channel 3, 1 = enable sound.
    //       |   3 | Channel 4, 1 = enable sound.
    //       |   4 | Channel 5, 1 = enable sound.
    //       | 5-7 | Unused (???)
    // ------+-----+---------------------------------------------------------------
    // $4015	SND_CHN	Sound channels enable and status
    // Reference: https://wiki.nesdev.com/w/index.php/APU#Status_.28.244015.29
    char SND_CHN;     
    // ------+-----+---------------------------------------------------------------
    // $4016 |  W  | JOY1	Joystick 1 data (R) and joystick strobe (W)
    //       |  0  | Controller port latch bit
    //       | 1-2 | Expansion port latch bits    
    // ------+-----+---------------------------------------------------------------
    // $4016 |  R  | JOY1	Joystick 1 data (R) and joystick strobe (W)
    //       | 0-4 | Input data lines /D4 D3 D2 D1 D0) controller port 1
    // ------+-----+---------------------------------------------------------------
    // https://wiki.nesdev.com/w/index.php/Input_devices
    // https://wiki.nesdev.com/w/index.php/Controller_reading
    char JOY1;
    // ------+-----+---------------------------------------------------------------
    // $4017 |  R  | JOY2	Joystick 2 data (R) and frame counter control (W)
    //       | 0-4 | Input data lines /D4 D3 D2 D1 D0) controller port 2
    // ------+-----+---------------------------------------------------------------
    char JOY2;
};

// APU Frame Counter
// generates low-frequency clocks for the channels and an optional 60 Hz interrupt.
// https://wiki.nesdev.com/w/index.php/APU_Frame_Counter
// ------+-----+---------------------------------------------------------------
//  $4017 |	 W  | FR_COUNTER Frame Counter	Set mode and interrupt
//  ------+-----+---------------------------------------------------------------
//        |   7	| Sequencer mode: 0 selects 4-step sequence, 1 selects 5-step sequence
//        |   6	| Interrupt inhibit flag. If set, the frame interrupt flag is cleared, otherwise it is unaffected.
//  ------+-----+---------------------------------------------------------------
// Side effects	After 3 or 4 CPU clock cycles*, the timer is reset.
// If the mode flag is set, then both "quarter frame" and "half frame" signals are also generated.
char * const FR_COUNTER = (char*)0x4017;




