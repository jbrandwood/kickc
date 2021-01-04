// ByteBoozer decruncher
// https://github.com/p-a/kickass-cruncher-plugins

// Decrunch crunched data using ByteBoozer
// - crunched: Pointer to the start of the crunched data
void byteboozer_decrunch(char* crunched) {
    asm {
        ldy crunched
        ldx crunched+1
        jsr b2.Decrunch
    }
}

// The byteboozer decruncher
export char BYTEBOOZER[] = kickasm(resource "byteboozer_decrunch.asm") {{
    .const B2_ZP_BASE = $fc
    #import "byteboozer_decrunch.asm"
}};