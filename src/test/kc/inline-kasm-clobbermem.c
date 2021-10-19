// Demonstrate problem with inline kasm clobbering memory
// And the ASM peephole optimizer not realizing this

void main() {
    __ma char tile = 0;
    char * const SCREEN = (char*)0x0400;
    for(char i=0;i<10;i++) {
        kickasm(uses tile, clobbers "A") {{
            lda #4
            sta tile
            lda #2
            sta $02
        }}
        SCREEN[i] = tile;
    }
}