// Example of a struct containing an array

struct Person {
    char id;
    char name[13];
    unsigned int age;
};

struct Person persons[2] = {
    { 7, "jesper", 321 },
    { 9, "henry", 123}
};

void main() {
    char* const SCREEN = (char*)0x0400;
    struct Person* person = persons;
    SCREEN[0] = person->name[2];
    person++;
    SCREEN[1] = person->name[2];
}



