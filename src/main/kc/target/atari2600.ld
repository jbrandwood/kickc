// Atari 2600 VCS 4K ROM
.file [name="%O", type="bin", segments="Code, Vectors"]
.segmentdef Code [start=$f800,min=$f800,max=$fff9]
.segmentdef Data [start=$80,max=$ff, virtual]
.segmentdef Vectors [start=$fffa,max=$ffff]
.segment Vectors
.word %E // NMI
.word %E // RESET
.word %E // IRQ
.segment Code
