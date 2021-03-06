#include <c64-print.h>
byte* const BG_COLOR = (char*)$d021;
const byte GREEN = 5;
const byte RED = 2 ;

void main() {
    print_cls();
    *BG_COLOR = GREEN;
    test_bytes();
    test_sbytes();
}

// Test different byte constants
void test_bytes() {
    byte bb=0;
    assert_byte("0=0", bb, 0);
    byte bc=bb+2;
    assert_byte("0+2=2", bc, 2);
    byte bd=(byte)((signed byte)bc-4);
    assert_byte("0+2-4=254", bd, 254);
}

void assert_byte(byte* msg, byte b, byte c) {
    print_str(msg);
    print_str(" ");
    if(b!=c) {
        *BG_COLOR = RED;
        print_str("fail!");
    } else {
        print_str("ok");
    }
    print_ln();
}

// Test different signed byte constants
void test_sbytes() {
    signed byte bb=0;
    assert_sbyte("0=0", bb, 0);
    signed byte bc=bb+2;
    assert_sbyte("0+2=2", bc, 2);
    signed byte bd=bc-4;
    assert_sbyte("0+2-4=-2", bd, -2);
    signed byte be=-bd;
    assert_sbyte("-(0+2-4)=2", be, 2);
    signed byte bf=(signed byte)(-127-127);
    assert_sbyte("-127-127=2", bf, 2);
}

void assert_sbyte(byte* msg, signed byte b, signed byte c) {
    print_str(msg);
    print_str(" ");
    if(b!=c) {
        *BG_COLOR = RED;
        print_str("fail!");
    } else {
        print_str("ok");
    }
    print_ln();
}
