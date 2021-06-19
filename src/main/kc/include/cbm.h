/// Commodore Kernal functions
/// See http://www.c64os.com/post/c64kernalrom#iec_acptr
/// Compatible with https://github.com/cc65/cc65/blob/master/include/cbm.h

/// Constants to use with cbm_open() for opening a file for reading or writing without the need to append ",r" or ",w" to the filename.
#define CBM_READ        0       /* default is ",p" */
#define CBM_WRITE       1       /* ditto */
#define CBM_SEQ         2       /* default is ",r" -- or ",s" when writing */

/// IEC
/// Read one byte from talking device
unsigned char cbm_k_acptr (void);

unsigned char cbm_k_chkin (unsigned char FN);
void cbm_k_ciout (unsigned char C);
unsigned char cbm_k_ckout (unsigned char FN);
void cbm_k_clall (void);
void cbm_k_clrch (void);

/// Read a byte from the input channel
/// return: next byte in buffer or 0 if buffer is empty.
unsigned char cbm_k_getin (void);

unsigned cbm_k_iobase (void);
void cbm_k_listen (unsigned char dev);
unsigned char cbm_k_readst (void);
void cbm_k_scnkey (void);
void cbm_k_second (unsigned char addr);

/// Set logical file number, device number and secondary address
/// lfn: logical file number
/// dev: device number
/// sa: secondary address
void cbm_k_setlfs(unsigned char lfn, unsigned char dev, unsigned char sa);

/// Set filename or command string
/// name: file name
void cbm_k_setnam (const char* name);

/// Open logical file
unsigned char cbm_k_open (void);

/// Close logical file
/// lfn: Logical file number
void cbm_k_close (unsigned char lfn);

/// Load or Verify data
/// flag: load=0, verify=1
/// addr: pointer to start address
/// returns pointer to last byte loaded
char* cbm_k_load(unsigned char flag, char* addr);

/// Save memory to disk/tape
/// start: pointer to start address
/// end: End address
/// return:
unsigned char cbm_k_save(char* start, char* end);

void cbm_k_settim (unsigned long timer);
void cbm_k_talk (unsigned char dev);
void cbm_k_tksa (unsigned char addr);
void cbm_k_udtim (void);
void cbm_k_unlsn (void);
void cbm_k_untlk (void);