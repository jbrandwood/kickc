// Test array index pointer rewriting
// 16bit array with 16bit index
// Fibonacci calculation uses adjacent indices inside the loop

#define NUM_FIBS 25

unsigned short fibs[NUM_FIBS];

void main() {
    fibs[0] = 0;
    fibs[1] = 1;
    for(unsigned short i=0;i<NUM_FIBS-2;i++)
        fibs[i+2] = fibs[i]+fibs[i+1];
}