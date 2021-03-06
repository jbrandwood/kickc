// Example of a struct containing an array
// It works on the surface - but illustrates the problem with structs containing arrays treating them like pointers.
// https://gitlab.com/camelot/kickc/issues/314

struct Person {
    char id;
    char name[16];
};

void main() {
    struct Person jesper = { 4, "jesper" };
    print_person(&jesper);

    struct Person henriette = { 7, "henriette" };
    print_person(&henriette);
}

char* const SCREEN = (char*)0x0400;
char idx = 0;
char DIGIT[] = "0123456789";

void print_person(struct Person *person) {
    SCREEN[idx++] = DIGIT[person->id];
    SCREEN[idx++] = ' ';
    for(byte i=0; person->name[i]; i++)
        SCREEN[idx++] = person->name[i];
    SCREEN[idx++] = ' ';
}



