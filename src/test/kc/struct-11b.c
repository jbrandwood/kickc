// Example of a struct containing an array

unsigned long jesper_id = 111172;
char jesper_initials[64] = "jg";

unsigned long henry_id = 280173;
char henry_initials[64] = "hg";

void main() {
    print_person(jesper_id, jesper_initials);
    print_person(henry_id, henry_initials);
}

char* const SCREEN = (char*)0x0400;
char idx = 0;

void print_person(unsigned long person_id, char* person_initials) {
    for(byte i=0; person_initials[i]; i++)
        SCREEN[idx++] = person_initials[i];
    SCREEN[idx++] = ' ';
}