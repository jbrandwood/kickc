// Commodore 64 PRG executable file
.file [name="%O", type="prg", segments="Program"]
.segmentdef Program [segments="Basic, Code, Data"]
.segmentdef Basic [start=$0801]
.segmentdef Code [start=$080d]
.segmentdef Data [startAfter="Code"]
.segment Basic
:BasicUpstart(%E)
.segment Code

