// Example of a struct containing a pointer

struct Person {
    char id;
    char* name;
};

struct Person persons[2] = {
    { 4, "jesper" },
    { 7, "repsej" }
};

void main() {
    print_person(&persons[0]);
    print_person(&persons[1]);
}

char* const SCREEN = 0x0400;
char idx = 0;
char DIGIT[] = "0123456789";

void print_person(struct Person *person) {
    SCREEN[idx++] = DIGIT[person->id];
    SCREEN[idx++] = ' ';
    for(byte i=0; person->name[i]; i++)
        SCREEN[idx++] = person->name[i];
    SCREEN[idx++] = ' ';
}



