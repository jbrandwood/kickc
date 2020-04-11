// Draws a chess board in the upper left corner of the screen
void main() {
    byte* screen = $0400;
    byte* colors = $d800;
    byte color = 1;
    for( byte row: 0..7) {
        for( byte column: 0..7) {
            screen[column] = $a0;
            colors[column] = color;
            color = color^1;
        }
        color = color^1;
        screen = screen+40;
        colors = colors+40;
    }
}
