.segmentdef Program                 [segments="Basic, Code, Data, Bank1, Bank2"]
.segmentdef Basic                   [start=$0801]a
.segmentdef Code                    [start=%P]
.segmentdef Data                    [startAfter="Code"]
.segmentdef Bank1                   [start=$A000, min=$A000, max=$BFFF, align=$100]
.segmentdef Bank2                   [start=$C000, min=$C000, max=$FFFF, align=$100]

