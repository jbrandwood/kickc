// Create a bunch of files
.file [name="%O", type="prg", segments="Program"]
.file [name="SPRITE", type="bin", segments="Sprite"]
.segmentdef Program [segments="Basic, Code, Data"]
.segmentdef Basic [start=$0801]
.segmentdef Code [start=%P]
.segmentdef Data [startAfter="Code"]
.segment Basic
:BasicUpstart(%E)
.segmentdef Sprite
