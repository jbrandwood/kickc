// Example of a struct containing an array

struct Person {
    char id;
    char name[64];
};

struct Person jesper = { 4, "jesper" };
struct Person henriette = { 7, "henriette" };

void main() {
    print_person(jesper);
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



