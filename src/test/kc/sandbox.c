#include <division.h>

byte * const zp1 = (byte*)0x61; // #define zp1 *(byte *)0x61 -- allows "zp1" vs "*zp1" below -- not supported --  https://gitlab.com/camelot/kickc/issues/169
byte * const zp2 = (byte*)0x62;
byte * const TIMEHI = (byte*)0xA1;
byte * const TIMELO = (byte*)0xA2;
byte * const VICBANK = (byte*)0xD018;
byte  buf16[16]; // "char buf16[16]" is the normal way -- not supported -- https://gitlab.com/camelot/kickc/issues/162
byte strTemp[100];

// simple 'utoa' without using multiply or divide
word append(byte *dst, word value, word sub){
    *dst = '0';
    while (value >= sub){ ++*dst; value -= sub; }
    return value;
}

void utoa(word value, byte *dst){
    byte bStarted = 0;
    if (bStarted == 1 || value >= 10000){ value = append(dst++, value, 10000); bStarted = 1; }
    if (bStarted == 1 || value >= 1000){ value = append(dst++, value, 1000); bStarted = 1; }
    if (bStarted == 1 || value >= 100){ value = append(dst++, value, 100); bStarted = 1; }
    if (bStarted == 1 || value >= 10){ value = append(dst++, value, 10); bStarted = 1; }
    *dst++ = '0' + (byte)value;
    *dst = 0;
}

byte myprintf(byte *dst, byte *str, word w1, word w2, word w3) {
	byte bArg = 0, bFormat = 0, bLen = 0;
    byte bLeadZero, bDigits, bTrailing; // formats
	byte b, digit;
	byte buf6[6];
	word w;
	for (; *str != 0; ++str) {
        b = *str; 
		if (bFormat != 0) { // "(bFormat)" is the normal way -- not supported -- https://gitlab.com/camelot/kickc/issues/135
			if (b == '0') { bLeadZero = 1; continue; }
			if (b >= '1' && b <= '9') { bDigits = b - '0'; continue; }
			if (b == '-') { bTrailing = 1; continue; }
			if (b == 'c'){ // "switch" is the normal way -- not supported -- https://gitlab.com/camelot/kickc/issues/170
				dst[bLen++] = (byte)w;
			} else if (b == 'd') { 
				utoa(w, buf6);
				b = 1; while(buf6[b] != 0) ++b; // strlen() not supported -- https://gitlab.com/camelot/kickc/issues/182
                // if (bDigits > b) is used because non-executing for loop is not supported -- https://gitlab.com/camelot/kickc/issues/183
				if (bTrailing == 0 && bDigits > b) for (; bDigits > b; --bDigits) dst[bLen++] = (bLeadZero == 0) ? ' ' : '0';
				for (digit = 0; digit < b; ++digit) dst[bLen++] = buf6[digit];
				if (bTrailing != 0 && bDigits > b) for (; bDigits > b; --bDigits) dst[bLen++] = ' '; 
            } else if (b == 'x' || b == 'X'){ // hex
				b = ((byte)w >> 4) & 0xF;
				dst[bLen++] = (b < 10 ? '0' : 0x57) + b;
				// "('a' - 10)" is the normal way -- not supported  -- https://gitlab.com/camelot/kickc/issues/184 [FIXED]
				// (b < 10 ? '0' : 0x57) not supported
				b = (byte)w & 0xF; dst[bLen++] = (b < 10 ? '0' : 0x57) + b;
			}
            bFormat = 0;
			continue;
		}
		if (b == '%') {
			bFormat = 1;
			bLeadZero = 0; bDigits = 1; bTrailing = 0; // default format
			//w = (bArg == 0) ? w1 : ((bArg == 1) ? w2 : w3); -- "?" is the normal way, but error "sequence does not contain all blocks" -- https://gitlab.com/camelot/kickc/issues/185 [FIXED]
            if (bArg == 0) w = w1;
            else if (bArg == 1) w = w2;
            else w = w3; 
			++bArg;
			continue;
		}
        if (b >= 0x41 && b <= 0x5A) b += 0x20; // swap 0x41 / 0x61 when in lower case mode
		dst[bLen++] = b;
	}
	dst[bLen] = 0;
	return bLen;
}

void Print(){ // can this assembly be placed in a separate file and call it from the C code here?
    asm {
        ldy #0
        loop:
        lda strTemp,y
        beq done
        jsr $FFD2
        iny
        jmp loop
        done:
    }
}

word div10(word val){
    val = (val >> 1) + 1;
    val += val << 1;
    val += val >> 4;
    val += val >> 8; // >> 8 is not supported? FIXED!
    return val >> 4;
}

int main(void) {
	word u;
	word v;
    *VICBANK = 23;  // lower case mode

    // test performance of 'div16u(10)'
    u = 28293;
	for (*zp1 = 0; *zp1 < 10; ++*zp1){
        *TIMEHI = 0;
        *TIMELO = 0;
        for (*zp2 = 0; *zp2 < 200; ++*zp2) v = div16u(u, 10);
        // lower case letters in string literal are placed in string as 0x01-0x1A, should be 0x61-0x7A
        // -- as a side-effect of above issue, we can use "m" for carriage return.  The normal way is the escape code "\r" but that is not supported --
		myprintf(strTemp, "200 DIV16U: %5d,%4d IN %04d FRAMESm", u, v, ((word)*TIMEHI << 8) + (word)*TIMELO);
        Print();
        u -= 1234;
    }

    // test performance of 'div10'
    u = 28293;
	for (*zp1 = 0; *zp1 < 10; ++*zp1){
        *TIMEHI = 0;
        *TIMELO = 0;
        for (*zp2 = 0; *zp2 < 200; ++*zp2) v = div10(u);
		myprintf(strTemp, "200 DIV10 : %5d,%4d IN %04d FRAMESm", u, v, ((word)*TIMEHI << 8) + (word)*TIMELO);
        Print();
        u -= 1234;
    }
	return 0;
}


