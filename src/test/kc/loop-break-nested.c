// Tests break statement in a simple loop

byte* const SCREEN = (char*)$400;

void main() {
    for(byte* line = (char*)$400; line<$400+40*25;line+=40 ) {
        if(*line=='a') break;
        for( byte i: 0..39) {
            if(line[i]=='a') break;
            line[i] = 'a';
        }
    }
}