// Example of a struct containing an array

struct Person {
    char id;
    char name[16];
};

struct Person persons[] = {
    { 4, "jesper" },
    { 7, "henriette" }
};

void main() {
    print_person(persons);
    print_person(persons+1);
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



