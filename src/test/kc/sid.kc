// SID registers for random number generation
word* const SID_VOICE3_FREQ = $d40e;
byte* const SID_VOICE3_FREQ_LOW = $d40e;
byte* const SID_VOICE3_FREQ_HIGH = $d40f;
byte* const SID_VOICE3_CONTROL = $d412;
const byte SID_CONTROL_NOISE = $80; 
const byte SID_CONTROL_PULSE = $40; 
const byte SID_CONTROL_SAWTOOTH = $20; 
const byte SID_CONTROL_TRIANGLE = $10; 
const byte SID_CONTROL_TEST = $08; 
const byte SID_CONTROL_RING = $04; 
const byte SID_CONTROL_SYNC = $02; 
const byte SID_CONTROL_GATE = $01; 
byte* const SID_VOICE3_OSC = $d41b;

// Initialize SID voice 3 for random number generation
void sid_rnd_init() {
	*SID_VOICE3_FREQ = $ffff;
	*SID_VOICE3_CONTROL = SID_CONTROL_NOISE;
}

// Get a random number from the SID voice 3,
// Must be initialized with sid_rnd_init()
byte sid_rnd() {
	return *SID_VOICE3_OSC;
}

