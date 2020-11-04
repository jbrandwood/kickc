// Demonstrates problem with assigning a pointer to pointer inside inline function
// https://gitlab.com/camelot/kickc/-/issues/564

typedef char uint8_t;

uint8_t sieveFlags[128];

void main() {
    clearSieveData();
}

inline void clearSieveData() {
	uint8_t *p = sieveFlags;
	uint8_t **pp = &p + 1;
	for (register uint8_t i: 0..0x1f) {
		for (register uint8_t j: 0..0xff) {
			*(p + j) = 1;
		}
		(*pp)++;
	}
}
