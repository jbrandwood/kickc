// https://gitlab.com/camelot/kickc/-/issues/588
// Struct offset calculation is ignoring the high byte

#pragma struct_model(classic)
#pragma var_model(struct_mem)

struct __dcb {
    unsigned char ddevic;
    unsigned char dunit;
};
typedef struct __dcb dcb_t;

struct __os {
	char filler1[0x100];
	dcb_t dcb; // this should start at 0x100
};

#define OS (*(struct __os*)0x0000)

void main() {
	OS.dcb.ddevic = 1;
	OS.dcb.dunit = 2;
}
