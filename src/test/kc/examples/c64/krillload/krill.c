// Krill's Loader for C64 v184
// https://csdb.dk/release/?id=189130
// Uses Install/Loader files built using the following command.
// > make PLATFORM=c64 prg INSTALL=3400 RESIDENT=3000 ZP=e8
// To place the loader routines elsewhere in memory: re-make the krill loader, update the 2 prg-files and update the __address() below.

// Reserve the zero-page addresses used by the Krill routines
#pragma zp_reserve(0xe8..0xfd)

// The Krill loader routine that can load files.
__address(0x3000) char KRILL_LOADER[] = kickasm(resource "loader-c64.prg") {{
	.import c64 "loader-c64.prg"
}};

// The Krill Install routine that can install the drive-side code
__address(0x3400) char KRILL_INSTALL[] = kickasm(resource "install-c64.prg") {{
	.import c64 "install-c64.prg"
}};

// Status returned from the Krill functions
enum KrillStatus {
    KRILL_OK                       = 0x00,
    KRILL_DEVICE_INCOMPATIBLE      = 0xfb,
    KRILL_TOO_MANY_DEVICES         = 0xfc,
    KRILL_GENERIC_KERNAL_ERROR     = 0xfd,
    KRILL_DEVICE_NOT_PRESENT       = 0xfe,
    KRILL_FILE_NOT_FOUND           = 0xff
};

// Install drive-side code portion(s) must be installed in the active drive.
// Before the loader can operate, its drive-side code portion(s) must be installed in the drive(s).
// The drive-side portion remains resident in the drive. After successful
// installation, the install routine is not needed any more and may be overwritten.
// The KERNAL ROM may be disabled and zeropage variables clobbered.
// Returns the status of the installation
enum KrillStatus krill_install() {
    enum KrillStatus* const status = (enum KrillStatus*)0xff;
    asm(clobbers "AXY") {
        jsr KRILL_INSTALL
        sta status
    }
    return *status;
}

// Load a file from the active drive without decompression.
// While loading using filenames with wildcards ("?" and "*") is not possible,
// subsequent files following the previously-loaded file can be loaded via a
// zero-length filename
// - filename - The name of the file to load (zero-terminated in petscii encoding)
// Returns the status of the load
enum KrillStatus krill_loadraw(char* filename) {
    enum KrillStatus* const status = (enum KrillStatus*)0xff;
    char** const fname = (char**)0xfe;
    *fname = filename;
    asm(clobbers "AXY") {
        ldx fname
        ldy fname+1
        jsr KRILL_LOADER
        sta status
    }
    return *status;
}
