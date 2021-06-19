/// @file
/// Atari 2600 Registers and Constants
///
/// https://web.archive.org/web/20170215054248/http://www.atariguide.com/pdfs/Atari_2600_VCS_Domestic_Field_Service_Manual.pdf

#ifndef __ATARI2600__
#error "Target platform must be atari2600"
#endif

#include <atari-tia.h>
#include <mos6532.h>

/// Atari TIA write registers
struct ATARI_TIA_WRITE * const TIA = (struct ATARI_TIA_WRITE *)0x00;

/// Atari TIA read registers
struct ATARI_TIA_READ * const TIA_READ = (struct ATARI_TIA_READ *)0x00;

/// Atari RIOT registers
struct MOS6532_RIOT * const RIOT = (struct MOS6532_RIOT *)0x280;

