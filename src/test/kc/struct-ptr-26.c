#include <c64-print.h>
typedef unsigned char BYTE;
typedef unsigned short WORD;
struct fileentry {
    BYTE *bufEdit;
	BYTE bFlag;
	BYTE bError;
};
typedef struct fileentry ENTRY;
void main(){
	ENTRY *file;
    WORD uSize;
    file = (ENTRY *)0x4000;
    file->bufEdit = (BYTE*)4;
    word* ptrw = (WORD *)(file->bufEdit + 30);
    uSize = *ptrw;
    print_uint(uSize);
}