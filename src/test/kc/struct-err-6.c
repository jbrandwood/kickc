// Example of error using initializer on struct*

struct Person {
    char id;
    char age;
    char kids;
};

void main() {
    struct Person* jesper = { 4, 46, 2 };
    char* const SCREEN = (char*)0x0400;
    SCREEN[0] = jesper->id;
}


