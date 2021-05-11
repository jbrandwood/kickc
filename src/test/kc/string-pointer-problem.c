// Test adding integer index to a pointer that is a literal string
// https://gitlab.com/camelot/kickc/issues/315

void main() {
    set_process_name("keyboard");
}

char* process_name = (char*)0x0400;

void set_process_name(char* name) {
    for(signed int j = 0; j < 17; j++){
        process_name[j]=name[j];
    }
}