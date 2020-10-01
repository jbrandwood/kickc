// Test array index pointer rewriting
// 16bit array with 8bit index

#define NUM_ENTITIES 25

unsigned short entities[NUM_ENTITIES];

void main() {
    for(char i=0;i<NUM_ENTITIES;i++)
        entities[i] = 7;

}