// Example of a struct containing an array

struct Person {
    char id;
    char name[13];
    unsigned int age;
};

struct Person persons[2];

void main() {
    persons[0].id = 7;
    persons[1].id = 9;
    persons[0].name[8] = 'a';
    persons[1].name[8] = 'b';
    persons[0].age = 321;
    persons[1].age = 123;
    char* const SCREEN = (char*)0x0400;
    struct Person* person = persons;
    SCREEN[0] = person->name[8];
    person++;
    SCREEN[1] = person->name[8];
}



