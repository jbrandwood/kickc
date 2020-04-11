// Tests declaring variables as __ssa / __notssa

char __ssa idx_ssa_g;
char __ma idx_nssa_g;

char* const SCREEN1 = 0x0400;
char* const SCREEN2 = 0x0400+40;
char* const SCREEN3 = 0x0400+80;
char* const SCREEN4 = 0x0400+120;

void main() {
    char __ssa idx_ssa_l;
    char __ma idx_nssa_l;

    SCREEN1[idx_ssa_g++] = 'C';
    for( char i: 'M'..'L')
        SCREEN1[idx_ssa_g++] = i;
    SCREEN1[idx_ssa_g++] = '!';

    SCREEN2[idx_nssa_g++] = 'C';
    for( char i: 'M'..'L')
        SCREEN2[idx_nssa_g++] = i;
    SCREEN2[idx_nssa_g++] = '!';

    SCREEN3[idx_ssa_l++] = 'C';
    for( char i: 'M'..'L')
        SCREEN3[idx_ssa_l++] = i;
    SCREEN3[idx_ssa_l++] = '!';

    SCREEN4[idx_nssa_l++] = 'C';
    for( char i: 'M'..'L')
        SCREEN4[idx_nssa_l++] = i;
    SCREEN4[idx_nssa_l++] = '!';



}