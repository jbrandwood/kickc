// Casting sprites/$40 to byte results in lda #$ff & sprite/$40 - proper constant calculation & type inference should detect that "$ff &" is not necessary as $2000/$40 is already a byte.

byte* sprite = $2000;
byte* SCREEN = $400;

void main() {
    byte* sprite_ptr = SCREEN+$378;
    sprite_ptr[0] = (byte)(sprite/$40);
}