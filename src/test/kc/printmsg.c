#include <print.h>

byte msg[] = "hello world! ";
byte msg2[] = "hello c64! ";
byte msg3[] = "hello 2017! ";

void main() {
    print_str(msg);
    print_ln();
    print_str(msg2);
    print_ln();
    print_str(msg3);
    print_ln();
}
