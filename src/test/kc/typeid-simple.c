// Test typeid() of the different types

typedef byte (*PROC_PTR)();

void main() {
    byte* const SCREEN = (char*)$400;
    byte idx = 0;
    // Simple types
    SCREEN[idx++] = typeid(void);
    SCREEN[idx++] = typeid(byte);
    SCREEN[idx++] = typeid(signed byte);
    SCREEN[idx++] = typeid(word);
    SCREEN[idx++] = typeid(signed word);
    SCREEN[idx++] = typeid(dword);
    SCREEN[idx++] = typeid(signed dword);
    SCREEN[idx++] = typeid(bool);
    // Pointer types
    SCREEN[idx++] = typeid(byte*);
    SCREEN[idx++] = typeid(signed byte*);
    SCREEN[idx++] = typeid(word*);
    SCREEN[idx++] = typeid(signed word*);
    SCREEN[idx++] = typeid(dword*);
    SCREEN[idx++] = typeid(signed dword*);
    SCREEN[idx++] = typeid(bool*);
    // Pointer to procedure
    SCREEN[idx++] = typeid(PROC_PTR);
    // Pointer to pointer
    SCREEN[idx++] = typeid(byte**);

    idx = 40;
    // Test C types
    SCREEN[idx++] = typeid(char);
    SCREEN[idx++] = typeid(unsigned char);
    SCREEN[idx++] = typeid(signed char);
    SCREEN[idx++] = typeid(short);
    SCREEN[idx++] = typeid(unsigned short);
    SCREEN[idx++] = typeid(signed short);
    SCREEN[idx++] = typeid(int);
    SCREEN[idx++] = typeid(unsigned int);
    SCREEN[idx++] = typeid(signed int);
    SCREEN[idx++] = typeid(long);
    SCREEN[idx++] = typeid(unsigned long);
    SCREEN[idx++] = typeid(signed long);


}
