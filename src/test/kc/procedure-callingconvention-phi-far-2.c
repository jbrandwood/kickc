// Test a far call procedure with a calling convention sp

char* const SCREEN = (char*)0x0400;

void main(void) {
    SCREEN[0] = plus('0', 7);
}

#pragma code_seg(stage)
#pragma far(rubbish, 1, stage_prepare, stage_execution, stage_exit)

char plus(char a, char b) {
    return a+b;
}

void stage_entry() {
    asm {
        lda 0
        pha
        lda #1
        sta 0
    }
}

void stage_exit() {
    asm {
        pla
        sta 0
    }
}
