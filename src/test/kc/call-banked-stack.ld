.file                               [name="%O", type="prg", segments="Program"]
.segmentdef Program                 [segments="Basic, Code, Data"]
.segmentdef Basic                   [start=$0801]
.segmentdef Code                    [start=%P]
.segmentdef Data                    [startAfter="Code"]
.segmentdef RAM_Bank1               [start=$A000, min=$A000, max=$BFFF, align=$100]
.segmentdef RAM_Bank2               [start=$A000, min=$A000, max=$BFFF, align=$100]
.segmentdef ROM_Bank1               [start=$C000, min=$C000, max=$FFFF, align=$100]
.segment Basic
:BasicUpstart(%E)
.segment Code
.segment Data

