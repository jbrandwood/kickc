// Tests literal strings with and without zero-termination

byte* const SCREEN = (char*)$400;

byte msgz[] = "cml"z;
byte msg[] = "cml";

void main() {
    for( byte i:0..3) {
        SCREEN[i] = msg[i];
        (SCREEN+40)[i] = msgz[i];
    }
}

