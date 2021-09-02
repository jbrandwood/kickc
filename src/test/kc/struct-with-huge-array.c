#pragma struct_model(classic)

typedef struct {
	unsigned char header[282];
} bug;

char * SCREEN = (char*)0x0400;

void main() {
	bug b;
	for(unsigned int i=0;i<sizeof b;i++)
        SCREEN[i] = b.header[i];
}