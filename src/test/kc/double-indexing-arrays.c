// Tests that constant offset indexing into arrays is handled correctly

byte MAPDATA[1000];
byte COLORMAP1[256];
byte COLORMAP2[256];

byte* SCREEN = $0400;
byte* COLS = $d800;

void main() {
    for (byte x: 0..200) {
        SCREEN[x] = MAPDATA[x];
        COLS[x] = COLORMAP1[MAPDATA[x]];
        SCREEN[200+x] = MAPDATA[200+x];
        COLS[200+x] = COLORMAP1[MAPDATA[200+x]];
        SCREEN[400+x] = MAPDATA[400+x];
        COLS[400+x] = COLORMAP1[MAPDATA[400+x]];
        SCREEN[600+x] = MAPDATA[600+x];
        COLS[600+x] = COLORMAP2[MAPDATA[600+x]];
        SCREEN[800+x] = MAPDATA[800+x];
        COLS[800+x] = COLORMAP2[MAPDATA[800+x]];
    }
}