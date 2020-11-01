// Variable used in inline kickasm must be __ma
// See https://gitlab.com/camelot/kickc/-/issues/558

#pragma target(atarixl)
#pragma encoding(atascii)
#pragma zp_reserve(0x00..0x7f)

#include <stdint.h>

uint8_t const * OUT = 0x8000;

__ma uint8_t l[1];
__ma uint8_t m[1];

void main() {
	uint8_t a[] = { 0x80, 0x4F, 0x02, 0x0D }; // 1.2345
	uint8_t b[] = { 0x80, 0x6E, 0xD9, 0xEC }; // sqrt(3) = 1.7320509
	uint32_t r;

	foo(a, b);
	// foo(b, a);
}

void foo(uint8_t *x1, uint8_t *x2) {
	uint8_t * v1;
	uint8_t * v2;
	uint8_t a1 = 1;
	uint8_t a2 = 2;
	v1 = x1;
	v2 = &a2;

	kickasm(
		uses v1,
		uses v2
	) {{
		lda v1
		sta v2
	}}

	*(OUT) = a2;
}
