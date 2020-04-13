// Demonstrates problem with missing parenthesis in double-dereferencing
// https://gitlab.com/camelot/kickc/issues/270


#include <print.h>

struct fileentry {
    char *bufEdit;
};

typedef struct fileentry ENTRY;

ENTRY files[10];
ENTRY *file;

int main(void) {
    file = files;
    file->bufEdit = 0x4000;
    file->bufEdit[3] = 0xAA; // writes address 0x0000 (wrong!)
    ((char *)file->bufEdit)[4] = 0xCC; // writes address 0x4004 (right!)
    print_cls();
    print_str("$0000="); print_u8(*(char *)0x0000); print_ln();
    print_str("$4004="); print_u8(*(char *)0x4004); print_ln();
    return 0;
}