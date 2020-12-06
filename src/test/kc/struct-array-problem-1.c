// Demonstrates problem with structs containing arrays and auto-type conversion
// https://gitlab.com/camelot/kickc/-/issues/593

typedef struct hostslots {
	// this should be [8][32], but kickc doesn't do double arrays
    unsigned char host[256];
} HostSlots;
#define HOSTSLOT_SIZE 32

char * const OUT = 0x8000;

void main() {
	__mem HostSlots slots1 = {"some data that would fit a normal 8x32 double array"};
	__mem HostSlots slots2 = {"more data that would fit a normal 8x32 double array"};
	doStuff(&slots1);
	doStuff(&slots2);
}

void doStuff(HostSlots *hs) {
	for(unsigned char i = 0; i < 8; i++) {
		// should be:
		// if (hs->host[i][0] != 0) {
		char *hsp = hs->host[i * HOSTSLOT_SIZE];
		if (*hsp != 0) {
			*(OUT + i) = 1;
		} else {
			*(OUT + i) = 2;
		}
	}
}
