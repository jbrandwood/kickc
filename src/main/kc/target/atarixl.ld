// Atari XL/XE executable XEX file with a single segment
// https://www.atarimax.com/jindroush.atari.org/afmtexe.html
.file [name="%O", type="bin", segments="XexFile"]
.segmentdef XexFile
.segment XexFile
// Binary File Header
.byte $ff, $ff
// Program segment [start address, end address, data]
.word ProgramStart, ProgramEnd-1
.segmentout [ segments="Program" ]
// RunAd - Run Address Segment [start address, end address, data]
.word $02e0, $02e1
.word %E
.segmentdef Program [segments="ProgramStart, Code, Data, ProgramEnd"]
.segmentdef ProgramStart [start=$2000]
.segment ProgramStart
ProgramStart:
.segmentdef Code [startAfter="ProgramStart"]
.segmentdef Data [startAfter="Code"]
.segmentdef ProgramEnd [startAfter="Data"]
.segment ProgramEnd
ProgramEnd:
