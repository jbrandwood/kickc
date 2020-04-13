// Implementing a semi-struct without the struct keyword by using pointer math and inline functions
//
// struct fileentry {
//    BYTE *bufDisk; // file position in disk buffer.
//    BYTE *bufEdit; // file edits
//    WORD tsLen; // num of sectors
//    TS *tsOrder;
//    BYTE tLastLink;
//    BYTE sLastLink;
//    BYTE bFlag;
//    BYTE bError;
//    WORD uCross; // num of crosslinked sectors
//    BYTE bAddrLo; // start address
//    BYTE bAddrHi;
//    BYTE tHi; // highest track
//    BYTE tLo; // lowest track
//    };
//    typedef struct fileentry ENTRY;
//    ENTRY files[MAX_FILES];

#include <multiply.h>
#include <print.h>
#include <keyboard.h>

// The size of a file ENTRY
const byte SIZEOF_ENTRY = 18;

// The maximal number of files
const byte MAX_FILES = 144;

// All files
byte files[(word)MAX_FILES*SIZEOF_ENTRY];

// Get pointer to a numbered file entry in the files-table
inline byte* fileEntry(byte idx) {
    return files+mul8u(idx, SIZEOF_ENTRY);
}

// Get file position in disk buffer.
inline byte** entryBufDisk(byte* entry) {
    return (byte**)(entry+0);
}

// Get file edits
inline byte** entryBufEdit(byte* entry) {
    return (byte**)(entry+2);
}

// Get number of sectors
inline word* entryTsLen(byte* entry) {
    return (word*)(entry+4);
}

inline word** entryTsOrder(byte* entry) {
    return (word**)(entry+6);
}

inline byte* entryTLastLink(byte* entry) {
    return (byte*)(entry+8);
}

inline byte* entrySLastLink(byte* entry) {
    return (byte*)(entry+9);
}

inline byte* entryBFlag(byte* entry) {
    return (byte*)(entry+10);
}

inline byte* entryBError(byte* entry) {
    return (entry+11);
}

// Get num of crosslinked sectors
inline word* entryUCross(byte* entry) {
    return (word*)(entry+12);
}

// Get start address low byte
inline byte* entryBAddrLo(byte* entry) {
    return (byte*)(entry+14);
}

// Get start address high byte
inline byte* entryBAddrHi(byte* entry) {
    return (byte*)(entry+15);
}

// Get highest track
inline byte* entryTHi(byte* entry) {
    return (byte*)(entry+16);
}

// Get lowest track
inline byte* entryTLo(byte* entry) {
    return (byte*)(entry+17);
}

// Initialize 2 file entries and print them
void main() {
    keyboard_init();
    byte* entry1 = fileEntry(1);
    byte* entry2 = fileEntry(2);
    initEntry(entry1,0x00);
    initEntry(entry2,0x11);
    print_cls();
    print_str("** entry 1 **");
    print_ln();
    print_ln();
    printEntry(entry1);
    print_ln();
    print_str("- press space -");
    while(keyboard_key_pressed(KEY_SPACE)==0) {}
    print_cls();
    print_str("** entry 2 **");
    print_ln();
    print_ln();
    printEntry(entry2);
    print_ln();
    print_str("- press space -");
    while(keyboard_key_pressed(KEY_SPACE)==0) {}
    print_cls();
}

// Set all values in the passed struct
// Sets the values to n, n+1, n... to help test that everything works as intended
void initEntry(byte* entry, byte n) {
    *entryBufDisk(entry) = 0x1111+n;
    *entryBufEdit(entry) = 0x2222+n;
    *entryTsLen(entry) = 0x3333+n;
    *entryTsOrder(entry) = 0x4444+n;
    *entryTLastLink(entry) = 0x55+n;
    *entrySLastLink(entry) = 0x66+n;
    *entryBFlag(entry) = 0x77+n;
    *entryBError(entry) = 0x88+n;
    *entryUCross(entry) = 0x9999+n;
    *entryBAddrLo(entry) = 0xaa+n;
    *entryBAddrHi(entry) = 0xbb+n;
    *entryTHi(entry) = 0xcc+n;
    *entryTLo(entry) = 0xdd+n;
}

// Print the contents of a file entry
void printEntry(byte* entry) {
    print_str("bufdisk   ");
    print_uint((word)*entryBufDisk(entry));
    print_ln();
    print_str("bufedit   ");
    print_uint((word)*entryBufEdit(entry));
    print_ln();
    print_str("tslen     ");
    print_uint(*entryTsLen(entry));
    print_ln();
    print_str("tsorder   ");
    print_uint((word)*entryTsOrder(entry));
    print_ln();
    print_str("tlastlink   ");
    print_uchar(*entryTLastLink(entry));
    print_ln();
    print_str("slastlink   ");
    print_uchar(*entrySLastLink(entry));
    print_ln();
    print_str("bflag       ");
    print_uchar(*entryBFlag(entry));
    print_ln();
    print_str("berror      ");
    print_uchar(*entryBError(entry));
    print_ln();
    print_str("ucross    ");
    print_uint(*entryUCross(entry));
    print_ln();
    print_str("baddrlo     ");
    print_uchar(*entryBAddrLo(entry));
    print_ln();
    print_str("baddrhi     ");
    print_uchar(*entryBAddrHi(entry));
    print_ln();
    print_str("thi         ");
    print_uchar(*entryTHi(entry));
    print_ln();
    print_str("tlo         ");
    print_uchar(*entryTLo(entry));
    print_ln();
}


