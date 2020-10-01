// Test array index pointer rewriting
// 8bit array with 16bit index

#define NUM_ENTITIES 25

char entities[NUM_ENTITIES];

void main() {
    for(unsigned short i=0;i<NUM_ENTITIES;i++)
        entities[i] = 7;

}