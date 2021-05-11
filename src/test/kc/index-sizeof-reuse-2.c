// Test that the multiplication of a idx*sizeof(element) is reused inside loops

#define NUM_ENTITIES 25

unsigned int entities[NUM_ENTITIES];

char * const VICII_RASTER = (char*)0xd012;
char * const VICII_BG_COLOR = (char*)0xd020;
char * const SCREEN = (char*)0x0400;

void main() {

    asm { sei }
    
    while(1) {
        // Wait for raster refresh
        while(*VICII_RASTER!=0xff) ;
        *VICII_BG_COLOR = 0;
        // Move the entities
        char * line = SCREEN;
        for(char i=0;i<NUM_ENTITIES;i++) {
            // Delete old symbol
            line[(char)entities[i]] = ' ';
            // Move by velocity
            entities[i] += 1;
            // Reset if needed
            if(entities[i]>39) {
                entities[i] =0;
            }
            // Draw symbol
            line[entities[i]] = '*';
            // Next line
            line +=40;            
        }
        *VICII_BG_COLOR = 15;
    }


}