struct Tile {
    dword *Tiles;
    word Offset;
    byte Count;
    char Name[20];
};

dword PlayerSprites[12];
dword Enemy2Sprites[12];

struct Tile S1 = {PlayerSprites, 20, 64, "Sven" };
struct Tile S2 = {Enemy2Sprites, 50, 128, "Jesper" };
struct Tile *TileDB[2] = {&S1, &S2}; 

void main() {
    char * const SCREEN = (char*)0x0400;

    for(int i:0..1) {
        struct Tile *tile = TileDB[i];
        SCREEN[i] =  tile->Count;
    }
}
