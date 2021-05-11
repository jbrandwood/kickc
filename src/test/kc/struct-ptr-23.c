// Example of a struct containing an array

struct Person {
    char id;
    char initials[4];
};

struct Person persons[] =
 { { 1, "jgr" },
   { 8, "hbg" }
};

void main() {
    struct Person *person = persons;
    print_person(person);
    person++;
    print_person(person);
}

char* const SCREEN = (char*)0x0400;
char idx = 0;

void print_person(struct Person *person) {
    SCREEN[idx++] = '0'+person->id;
    SCREEN[idx++] = ' ';
    SCREEN[idx++] = person->initials[0];
    SCREEN[idx++] = person->initials[1];
    SCREEN[idx++] = person->initials[2];
    SCREEN[idx++] = ' ';
}