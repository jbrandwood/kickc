// Atari 2600 VCS 2K ROM
.file [name="%O", type="bin", segments="Code, Data, Vectors"]
.segmentdef Code [start=$f800,min=$f800,max=$fff9]
.segmentdef Data [startAfter="Code",max=$fff9]
.segmentdef Vectors [start=$fffa,max=$ffff]
.segmentdef Vars [start=$80,max=$ff, virtual]
.segment Vectors
.word %E // NMI
.word %E // RESET
.word %E // IRQ
.segment Code
