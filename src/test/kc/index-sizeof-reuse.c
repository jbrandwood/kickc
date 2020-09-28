// Test that the multiplication of a idx*sizeof(element) is reused inside loops

struct Entity {
    signed char x_pos;
    signed char x_vel;
    char symbol;
};

#define NUM_ENTITIES 25

struct Entity entities[NUM_ENTITIES];

char * const VIC_RASTER = 0xd012;
char * const VIC_BG_COLOR = 0xd020;
char * const SCREEN = 0x0400;

void main() {

    asm { sei }
    
    // Initialize velocities
    signed char v = -1;    
    for(char i=0;i<NUM_ENTITIES;i++) {
        entities[i].x_pos = (signed char)i;
        entities[i].x_vel = v;
        entities[i].symbol = i;
        v = -v;
    }

    while(1) {
        // Wait for raster refresh
        while(*VIC_RASTER!=0xff) ;
        *VIC_BG_COLOR = 0;
        // Move the entities
        char * line = SCREEN;
        for(char i=0;i<NUM_ENTITIES;i++) {
            // Delete old symbol
            line[entities[i].x_pos] = ' ';
            // Move by velocity
            entities[i].x_pos += entities[i].x_vel;
            // Turn around if needed
            if(entities[i].x_pos<0 || entities[i].x_pos>39) {
                entities[i].x_vel = -entities[i].x_vel;
                entities[i].x_pos += entities[i].x_vel;
            }
            // Draw symbol
            line[entities[i].x_pos] = entities[i].symbol;
            // Next line
            line +=40;            
        }
        *VIC_BG_COLOR = 15;
    }


}