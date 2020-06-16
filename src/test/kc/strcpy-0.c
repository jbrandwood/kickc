
char* dst1 = (char*)0x0400;
char* dst2 = (char*)0x0428;

void str_cpy( char *dst, char const *src ) {
   while ( *dst++ = *src++ ) {}
}

void main() {
    str_cpy(dst1, "hello");
    str_cpy(dst2, "world");
}

