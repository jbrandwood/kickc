// Example of inline kickasm in a function

void main() {
    byte* const SCREEN = $400;
    *(SCREEN+1000) = 0;

    kickasm {{
	    lda #0
        .for (var i = 0; i < 1000; i++) {
            sta SCREEN+i
        }
    }}
    
}
