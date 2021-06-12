// Tests that mixing types can synthesize a fragment correctly

void main() {

    signed word w = 0;
    byte* SCREEN = (char*)$400;

    for (byte i: 0..10) {
        w = w - 12;
        SCREEN[i] = BYTE0(w);
    }

}