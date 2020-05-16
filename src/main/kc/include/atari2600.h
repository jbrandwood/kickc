// Atari 2600 Registers and Constants
// https://web.archive.org/web/20170215054248/http://www.atariguide.com/pdfs/Atari_2600_VCS_Domestic_Field_Service_Manual.pdf

#include <atari-tia.h>
#include <mos6532.h>

// Atari TIA write registers
struct ATARI_TIA_WRITE * const TIA = 0x00;

// Atari TIA read registers
struct ATARI_TIA_READ * const TIA_READ = 0x00;

// Atari RIOT registers
struct MOS6532_RIOT * const RIOT = 0x280;
