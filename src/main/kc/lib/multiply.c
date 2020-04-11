// Simple binary multiplication implementation

#include <multiply.h>

// Perform binary multiplication of two unsigned 8-bit bytes into a 16-bit unsigned word
word mul8u(byte a, byte b) {
    word res = 0;
    word mb = b;
    while(a!=0) {
        if( (a&1) != 0) {
            res = res + mb;
        }
        a = a>>1;
        mb = mb<<1;
    }
    return res;
}

// Multiply of two signed bytes to a signed word
// Fixes offsets introduced by using unsigned multiplication
signed word mul8s(signed byte a, signed byte b) {
    word m = mul8u((byte)a, (byte) b);
    if(a<0) {
        >m = (>m)-(byte)b;
    }
    if(b<0) {
        >m = (>m)-(byte)a;
    }
    return (signed word)m;
}

// Multiply a signed byte and an unsigned byte (into a signed word)
// Fixes offsets introduced by using unsigned multiplication
signed word mul8su(signed byte a, byte b) {
    word m = mul8u((byte)a, (byte) b);
    if(a<0) {
        >m = (>m)-(byte)b;
    }
    return (signed word)m;
}

// Perform binary multiplication of two unsigned 16-bit words into a 32-bit unsigned double word
dword mul16u(word a, word b) {
    dword res = 0;
    dword mb = b;
    while(a!=0) {
        if( (a&1) != 0) {
            res = res + mb;
        }
        a = a>>1;
        mb = mb<<1;
    }
    return res;
}

// Multiply of two signed words to a signed double word
// Fixes offsets introduced by using unsigned multiplication
signed dword mul16s(signed word a, signed word b) {
    dword m = mul16u((word)a, (word) b);
    if(a<0) {
        >m = (>m)-(word)b;
    }
    if(b<0) {
        >m = (>m)-(word)a;
    }
    return (signed dword)m;
}
