// Test that the multiplication of a idx*sizeof(element) is reused inside loops

#define NUM_ENTITIES 25

unsigned int entities[NUM_ENTITIES];

char * const VIC_RASTER = 0xd012;
char * const VIC_BG_COLOR = 0xd020;
char * const SCREEN = 0x0400;

void main() {

    asm { sei }
    
    while(1) {
        // Wait for raster refresh
        while(*VIC_RASTER!=0xff) ;
        *VIC_BG_COLOR = 0;
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
        *VIC_BG_COLOR = 15;
    }


}