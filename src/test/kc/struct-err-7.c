// Example of error referencing unknown struct member in rvalue

struct Person {
    char id;
    char age;
};

void main() {
    struct Person* per;
    int x = per->qwe;
}


