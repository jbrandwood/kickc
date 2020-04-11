// SID registers for random number generation
unsigned int* const SID_VOICE3_FREQ = 0xd40e;
char* const SID_VOICE3_FREQ_LOW = 0xd40e;
char* const SID_VOICE3_FREQ_HIGH = 0xd40f;
char* const SID_VOICE3_CONTROL = 0xd412;
const char SID_CONTROL_NOISE = 0x80;
const char SID_CONTROL_PULSE = 0x40;
const char SID_CONTROL_SAWTOOTH = 0x20;
const char SID_CONTROL_TRIANGLE = 0x10;
const char SID_CONTROL_TEST = 0x08;
const char SID_CONTROL_RING = 0x04;
const char SID_CONTROL_SYNC = 0x02;
const char SID_CONTROL_GATE = 0x01;
char* const SID_VOICE3_OSC = 0xd41b;

// Initialize SID voice 3 for random number generation
void sid_rnd_init() {
	*SID_VOICE3_FREQ = 0xffff;
	*SID_VOICE3_CONTROL = SID_CONTROL_NOISE;
}

// Get a random number from the SID voice 3,
// Must be initialized with sid_rnd_init()
inline char sid_rnd() {
	return *SID_VOICE3_OSC;
}

