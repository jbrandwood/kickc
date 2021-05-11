// Tests that inline kickasm supports the clobbering directive
byte* const SCREEN = (byte*)$400;
void main() {
    for(byte k : 0..10) {
        for(byte l: 0..10) {
            for(byte m: 0..10) {
                kickasm(uses SCREEN, clobbers "AX") {{
                    lda #0
                    ldx #0
                    sta SCREEN,x
                }}
            }
        }
    }
}
