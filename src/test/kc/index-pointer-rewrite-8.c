// Test array index pointer rewriting
// struct array with 8bit index

#define NUM_BALLS 25

struct Ball {
    char pos;
    char vel;
    char sym;
};

struct Ball balls[NUM_BALLS];

void main() {
    for(char i=0;i<NUM_BALLS;i++) {
        balls[i].pos += balls[i].vel;
        balls[i].vel += 10;
        balls[i].sym ='*';
    }
}