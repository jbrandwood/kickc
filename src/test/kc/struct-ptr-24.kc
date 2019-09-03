typedef unsigned char BYTE;

struct fileentry {
    BYTE bFlag;
    BYTE bError;
};

typedef struct fileentry ENTRY;

ENTRY *filesEnd;
ENTRY *dir;

void main(){
    ENTRY *file;
    while(file != filesEnd){
        PrintName(file);
        ++file;
    }
}

void PrintName(ENTRY *file) {
    if (file == dir) *(BYTE *)0xC7 = 1;
}