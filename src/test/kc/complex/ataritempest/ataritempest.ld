.file [name="%O", type="bin", segments="AtariTempest"]
.segmentdef AtariTempest [segments="Code, RomData, Vectors"]
.segmentdef Code [start=$9000, min=$9000, max=$Fff9]
.segmentdef RomData [startAfter="Code", min=$9000, max=$Fff9]
.segmentdef RamData [start=$200, min=$200, max=$7ff]
.segmentdef Vectors [start=$FFFA, min=$FFFA, max=$FFFF, fill]
.segment Code
init: