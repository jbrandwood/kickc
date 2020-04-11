// SID registers for random number generation
unsigned int* const SID_VOICE3_FREQ = $d40e;
char* const SID_VOICE3_FREQ_LOW = $d40e;
char* const SID_VOICE3_FREQ_HIGH = $d40f;
char* const SID_VOICE3_CONTROL = $d412;
const char SID_CONTROL_NOISE = $80;
const char SID_CONTROL_PULSE = $40;
const char SID_CONTROL_SAWTOOTH = $20;
const char SID_CONTROL_TRIANGLE = $10;
const char SID_CONTROL_TEST = $08;
const char SID_CONTROL_RING = $04;
const char SID_CONTROL_SYNC = $02;
const char SID_CONTROL_GATE = $01;
char* const SID_VOICE3_OSC = $d41b;

// Initialize SID voice 3 for random number generation
void sid_rnd_init() {
	*SID_VOICE3_FREQ = $ffff;
	*SID_VOICE3_CONTROL = SID_CONTROL_NOISE;
}

// Get a random number from the SID voice 3,
// Must be initialized with sid_rnd_init()
char sid_rnd() {
	return *SID_VOICE3_OSC;
}

