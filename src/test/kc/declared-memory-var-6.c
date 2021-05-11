// Test declaring a variable as "memory", meaning it will be stored in memory and accessed through an implicit pointer (using load/store)

char* const SCREEN = (char*)0x0400;
char i=0;

void main(void) {

    char __ssa __zp reg_zp_flex = '.';
    char __ssa __address(0x10) reg_zp_abs = '.';
    char __ssa __mem reg_mem_flex = '.';
    char __ssa __address(0x1000) reg_mem_abs = '.';

    char default_default = '.';
    char reg_default = '.';
    char __ssa __zp  default_zp_flex = '.';
    char __address(0x11)  default_zp_abs = '.';
    char __mem default_mem_flex = '.';
    char __address(0x1001) default_mem_abs = '.';

    out(reg_zp_flex);
    out(reg_zp_abs);
    out(reg_mem_flex);
    out(reg_mem_abs);

    out(default_default);
    out(reg_default);
    out(default_zp_flex);
    out(default_zp_abs);
    out(default_mem_flex);
    out(default_mem_abs);

}

void out(char c) {
	SCREEN[i++] = c;
}



