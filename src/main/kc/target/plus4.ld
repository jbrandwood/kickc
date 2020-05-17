.file [name="%O", type="prg", segments="Program"]
.segmentdef Program [segments="Basic, Code, Data"]
.segmentdef Basic [start=$1001]
.segmentdef Code [start=$100d]
.segmentdef Data [startAfter="Code"]
.segment Basic
:BasicUpstart(%E)
.segment Code

