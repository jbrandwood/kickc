// Tests that references to labels in other scopes is possible from inline ASM

void main() {
    asm {
        lda #'c'
        sta sub.ll+1
    }
    sub();
}

void sub() {
    asm {
        ll:
        lda #0
        sta $400
    }
}