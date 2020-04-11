// Tests assigning a literal word pointer

void main() {
    print("qwe");
}

void print(char* str) {
    *(word*)0x80 = (word)str;
}