// Create a bunch of files
.file [name="%O", type="prg", segments="Program"]
.file [name="SPRITES", type="bin", segments="Sprites"]
.file [name="TILES", type="bin", segments="TileS"]
.file [name="TILEB", type="bin", segments="TileB"]
.file [name="PALETTES", type="bin", segments="Palettes"]
.segmentdef Program [segments="Basic, Code, Data"]
.segmentdef Basic [start=$0801]
.segmentdef Code [start=%P]
.segmentdef Data [startAfter="Code"]
.segment Basic
:BasicUpstart(%E)
.segmentdef Sprites
.segmentdef TileS
.segmentdef TileB
.segmentdef Palettes
