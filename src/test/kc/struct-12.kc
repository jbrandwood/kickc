// Example of a struct containing an array
// Works because the struct is only handled as a value

struct Person {
    char id;
    char name[64];
};

void main() {
    struct Person jesper = { 4, "jesper" };
    print_person(jesper);

    struct Person henriette = { 7, "henriette" };
    print_person(henriette);
}

char* const SCREEN = 0x0400;
char idx = 0;
char DIGIT[] = "0123456789";

void print_person(struct Person person) {
    SCREEN[idx++] = DIGIT[person.id];
    SCREEN[idx++] = ' ';
    for(byte i=0; person.name[i]; i++)
        SCREEN[idx++] = person.name[i];
    SCREEN[idx++] = ' ';
}



