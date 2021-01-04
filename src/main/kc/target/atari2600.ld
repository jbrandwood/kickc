// Atari 2600 VCS 2K ROM in A26 executable file
.file [name="%O", type="bin", segments="Code, Data, Vectors"]
.segmentdef Code [start=$f800,min=$f800,max=$fff9]
.segmentdef Data [startAfter="Code",max=$fff9]
.segmentdef Vectors [start=$fffa,max=$ffff]
.segment Vectors
.word %E // NMI
.word %E // RESET
.word %E // IRQ