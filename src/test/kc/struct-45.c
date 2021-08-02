// https://gitlab.com/camelot/kickc/-/issues/590

#pragma struct_model(classic)
#pragma var_model(struct_mem)

struct deviceslot {
	unsigned char hostSlot;
	unsigned char mode;
	unsigned char file[64];
};

typedef struct deviceslot deviceslot_t;

typedef struct deviceslotsA {
	deviceslot_t slot[2];
} DeviceSlotsA;

char * const OUT = (char *)0x8000;

void main() {
	deviceslot_t s1 = {'A', 'R', "f1"};
	deviceslot_t s2 = {'B', 'W', "f2"};

	DeviceSlotsA ssA;
	DeviceSlotsA *slotsA = &ssA;
	slotsA->slot[0] = s1;
	slotsA->slot[1] = s2;

	for(char i: 0..1) {
		deviceslot_t ds = slotsA->slot[i];
		*(OUT + i) = ds.mode;
	}
}
