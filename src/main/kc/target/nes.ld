// Nintendo Entertainment System (NES) ROM (Mapper 0 NROM, Vertical Mirroring)
// https://sadistech.com/nesromtool/romdoc.html
// https://forums.nesdev.com/viewtopic.php?f=2&t=9896
// https://github.com/gregkrsak/first_nes
.file [name="%O", type="bin", segments="NesRom"]
.file [name="%O_hdr", type="bin", segments="Header"]
.file [name="%O_prg", type="bin", segments="ProgramRom"]
.file [name="%O_chr", type="bin", segments="CharacterRom"]
.segmentdef Header  [ start=$0000,       min=$0000, max=$000f, fill ]
.segmentdef Tiles   [ start=$0000,       min=$0000, max=$1fff, fill ]
.segmentdef Code    [ start=$c000,       min=$c000, max=$fff9 ]
.segmentdef Data    [ startAfter="Code", min=$c000, max=$fff9 ]
.segmentdef Vectors [ start=$fffa,       min=$fffa, max=$ffff ]
.segmentdef GameRam [start=$200,max=$7ff, virtual]
.segmentdef ProgramRom [ segments="Code, Data, Vectors" ]
.segmentdef CharacterRom [ segments="Tiles" ]
.segmentdef NesRom
.segment NesRom
.segmentout [ segments="Header" ]
.segmentout [ segments="ProgramRom" ]
.segmentout [ segments="CharacterRom" ]
.segment Header
.text   @"NES\$1a"
.byte   $01           // 1x 16KB ROM (PRG)
.byte   $01           // 1x 8KB VROM (CHR)
.byte   %00000001     // Mapper nibble 0000 == No mapping (a simple 16KB PRG + 8KB CHR game)
                      // Mirroring nibble 0001 == Vertical mirroring only
.segment Code
