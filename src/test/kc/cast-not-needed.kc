// Tests a cast that is not needed

byte* sprite = $5000;
byte* SCREEN = $4400;

void main() {
    byte* sprite_ptr = SCREEN+$378;
    sprite_ptr[0] = (byte)(sprite/$40);
}
