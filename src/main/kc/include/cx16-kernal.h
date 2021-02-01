// Kernal SETNAM function
// SETNAM. Set file name parameters.
void setnam(char* filename);

// SETLFS. Set file parameters.
void setlfs(char device);

// LOAD. Load or verify file. (Must call SETLFS and SETNAM beforehands.)
// - verify: 0 = Load, 1-255 = Verify
// Returns a status, 0xff: Success other: Kernal Error Code
char load(char* address, char verify);

// GETIN. Read a byte from the input channel
// return: next byte in buffer or 0 if buffer is empty.
char getin();
