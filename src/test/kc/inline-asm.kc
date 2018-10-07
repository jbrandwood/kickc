
void main() {
    asm {
        lda #'a'
        ldx #$ff
      !:
        sta $0400,x
        sta $0500,x
        sta $0600,x
        sta $0700,x
        dex
        bne !-
    }
}
