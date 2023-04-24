
#include <conio.h>
#include <stdio.h>

#if defined(__CX16__) // For the moment only supported for the CX16 ...

#include <kernal.h>

volatile FILE __stdio_file;
volatile unsigned char __stdio_filecount = 0;

#define __filename (&__stdio_file.filename[sp * __STDIO_FILECOUNT])
#define __logical (__stdio_file.channel[sp])
#define __device (__stdio_file.device[sp])
#define __channel (__stdio_file.secondary[sp])
#define __status (__stdio_file.status[sp])

/**
 * @brief Load a file to banked ram located between address 0xA000 and 0xBFFF incrementing the banks.
 *
 * @param channel Input channel.
 * @param device Input device.
 * @param secondary Secondary channel.
 * @param filename Name of the file to be loaded.
 * @return
 *  - 0x0000: Something is wrong! Kernal Error Code (https://commodore.ca/manuals/pdfs/commodore_error_messages.pdf)
 *  - other: OK! The last pointer between 0xA000 and 0xBFFF is returned. Note that the last pointer is indicating the first free byte.
 */
FILE *fopen(const char *path, const char *mode) {

    unsigned char sp = __stdio_filecount;
    FILE *stream = (FILE *)((unsigned int)sp | 0x8000); // We set bit 7 of the high byte, to differentiate from NULL.

    // Parse path
    char pathstep = 0;
    char *pathtoken = path;
    char pathlen = 0;
    char pathpos = sp * __STDIO_FILECOUNT;

    __logical = 0;
    __device = 0;
    __channel = 0;

    char num;

    // Iterate while path is not \0.
    do {
        if (*pathtoken == ',' || *pathtoken == '\0') {
            if (pathstep > 0) {
                char pathcmp = *path;
                switch (pathcmp) {
                case 'D':
                case 'L':
                case 'C':
                    num = (char)atoi(path + 1);
                    path = pathtoken + 1;
                }
                switch (pathcmp) {
                case 'L':
                    __logical = num;
                    break;
                case 'D':
                    __device = num;
                    break;
                case 'C':
                    __channel = num;
                    break;
                }
            } else {
                __stdio_file.filename[pathpos] = '\0';
                path = pathtoken + 1;
            }
            pathstep++;
        } else {
            if (pathstep == 0) {
                __stdio_file.filename[pathpos] = *pathtoken;
                pathpos++;
            }
        }
        pathtoken++;
    } while (*(pathtoken - 1));

    __status = 0;

    if(!__logical)
        __logical = __stdio_filecount+1;
    if(!__device)
        __device = 8;
    if(!__channel)
        __channel = __stdio_filecount+2;

#ifdef __DEBUG_FILE
    printf("open file, l=%u, d=%u, c=%u, f=%s", __logical, __device, __channel, __filename);
#endif

    cbm_k_setnam(__filename);
    cbm_k_setlfs(__logical, __device, __channel);

    cbm_k_open();

    __status = cbm_k_readst();

    if (ferror(stream)) {
        // The POSIX standard specifies that in case of file not found, NULL is returned.
        // However, the error needs to be cleared from the device.
        // This needs to be done using ferror, but this function needs a FILE* stream.
        // As fopen returns NULL in case file not found, the ferror must be called before return
        // to clear the error from the device. Otherwise the device is left with a red blicking led.
        cbm_k_close(__logical);
        return NULL;
    }

    __stdio_filecount++;

#ifdef __DEBUG_FILE
    while(!kbhit());
#endif


    return (FILE *)stream;
}

/**
 * @brief Load a file to ram or (banked ram located between address 0xA000 and 0xBFFF), incrementing the banks.
 * This function uses the new CX16 macptr kernal API at address $FF44.
 *
 * @param sptr The pointer between 0xA000 and 0xBFFF in banked ram.
 * @param size The amount of bytes to be read.
 * @param filename Name of the file to be loaded.
 * @return ptr the pointer advanced to the point where the stream ends.
 */
unsigned int fgets(char *ptr, unsigned int size, FILE *stream) {
    unsigned char sp = (unsigned char)stream;

#ifdef __DEBUG_FILE
    printf("load file, l=%u, d=%u, c=%u, b=%x, p=%p, si=%u", __logical, __device, __channel, bank_get_bram(), ptr, size);
#endif

    unsigned int read = 0;
    unsigned int remaining = size;

    cbm_k_chkin(__logical);
    __status = cbm_k_readst();
#ifdef __DEBUG_FILE
    printf(", chkin s=%u", __status);
#endif
    if (__status)
        return 0;

    unsigned int bytes = 0;
    do {
        if (!size) {
#ifdef __DEBUG_FILE
            printf(", reading max ptr=%p", ptr);
#endif
            bytes = cx16_k_macptr(0, ptr);
        } else {
            if (remaining >= 128) {
#ifdef __DEBUG_FILE
                printf(", reading 128 ptr=%p", ptr);
#endif
                bytes = cx16_k_macptr(128, ptr);
            } else {
#ifdef __DEBUG_FILE
                printf(", reading remaining=%u ptr=%p", remaining, ptr);
#endif
                bytes = cx16_k_macptr(remaining, ptr);
            }
        }

        __status = cbm_k_readst();
#ifdef __DEBUG_FILE
        printf(", macptr s=%u", __status);
#endif
        if (__status & 0xBF) {
#ifdef __DEBUG_FILE
            printf("macptr error s=%u", __status);
#endif
            return 0;
        }

        if (bytes == 0xFFFF) {
#ifdef __DEBUG_FILE
            printf("read error in file %s, s=%u, bank=%u, ptr=%p\n", __filename, __status, bank_get_bram(), ptr);
#endif
            return 0;
        }

#ifdef __DEBUG_FILE
        printf(", bytes=%u", bytes);
#endif

        read += bytes;
        ptr += bytes;

        if (BYTE1(ptr) == 0xC0)
            ptr -= 0x2000;
        remaining -= bytes;

#ifdef __DEBUG_FILE
        printf(", size=%u, remaining=%u, read=%u", size, remaining, read);
#endif

    } while ((__status == 0) && ((size && remaining) || !size));

#ifdef __DEBUG_FILE
    printf(", read bytes r=%u, s=%u\n", read, __status);
#endif

#ifdef __DEBUG_FILE
    while (!kbhit())
        ;
#endif

    return read;
}

/**
 * @brief Close a file.
 *
 * @param fp The FILE pointer.
 * @return
 *  - 0x0000: Something is wrong! Kernal Error Code (https://commodore.ca/manuals/pdfs/commodore_error_messages.pdf)
 *  - other: OK! The last pointer between 0xA000 and 0xBFFF is returned. Note that the last pointer is indicating the first free byte.
 */
int fclose(FILE *stream) {

    unsigned char sp = (unsigned char)stream;

#ifdef __DEBUG_FILE
    printf("close file, l=%u", __logical);
#endif

    cbm_k_chkin(__logical);

    __status = cbm_k_readst();

#ifdef __DEBUG_FILE
    printf(", chkin s=%u", __status);
#endif
    if (__status)
        return 0;

    cbm_k_close(__logical);
    __status = cbm_k_readst();

#ifdef __DEBUG_FILE
    printf(", close s=%u", __status);
#endif

    if (__status)
        return -1;

        // cbm_k_clrchn();
        // #ifdef __DEBUG_FILE
        //     printf(", status=%u\n", __stdio_file.status);
        // #endif

#ifdef __DEBUG_FILE
        // cbm_k_chkin(0);
        // while(!kbhit());
#endif

    __logical = 0;
    __device = 0;
    __channel = 0;
    *__filename = '\0';

    __stdio_filecount--;

    return 0;
}

/**
 * @brief POSIX equivalent of ferror for the CBM C language.
 * This routine reads from secondary 15 the error message from the device!
 * The result is an error string, including the error code, message, track, sector.
 * The error string can be a maximum of 32 characters.
 *
 * @param stream FILE* stream.
 * @return int Contains a non-zero value if there is an error.
 */
int ferror(FILE *stream) {

    unsigned char sp = (unsigned char)stream;

    cbm_k_setlfs(15, 8, 15);
    cbm_k_setnam("");
    cbm_k_open();
    cbm_k_chkin(15);

    unsigned char st;
    unsigned char errno_parsed = 0;
    register char errno_len = 0;

    char ch = cbm_k_chrin();
    while (!(st = cbm_k_readst())) {
        if (!errno_parsed) {
            if (ch == ',') {
                errno_parsed++;
                char temp[4];
                strncpy(temp, __errno_error, errno_len+1);
                __errno = atoi(temp);
            }
        }
        __errno_error[errno_len] = ch;
        errno_len++;
        ch = cbm_k_chrin();
        // {asm {.byte $DB}}
    }
    __status = st;
    cbm_k_close(15);

#ifdef __DEBUG_FILE
    printf("error: %s ", __errno_error);
#endif

    return __errno;
}

/**
 * @brief The POSIX error function,
 * [perror](https://en.wikibooks.org/wiki/C_Programming/stdio.h/perror),
 * is used in C and C++ to print an error message to stderr,
 * based on the error state stored in errno.[1]It prints str and an implementation-defined error message corresponding to the global variable errno.
 *
 *
 * @param prefix If the parameter prefix is non-NULL, perror will first print prefix followed by a colon and a space to standard error.
 * Then, it will print the result of strerror to standard error, followed by a newline character.
 */
void perror(char *prefix) {
    if (prefix) {
        cputs(prefix);
        cputs(": ");
    }
    cputs(__errno_error);
    cputc('\n');
}

#endif