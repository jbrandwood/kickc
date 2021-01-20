// ROM linking file
.file [name="%O", type="bin", segments="Rom"]
.segmentdef Rom [segments="RomCode, RomData"]
.segmentdef RomCode [start=%P]
.segmentdef RomData [startAfter="RomCode"]
.segmentdef TestRom