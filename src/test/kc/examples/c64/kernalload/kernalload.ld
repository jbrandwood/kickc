// Create a D64 disk containing the program and a sprite file
.disk [filename="%O", name="DISK", id=1] {
        [name="KERNALLOAD", type="prg", segments="Program"],
        [name="SPRITE", type="prg", segments="Sprite"]
}
.segmentdef Program [segments="Basic, Code, Data"]
.segmentdef Basic [start=$0801]
.segmentdef Code [start=$0810]
.segmentdef Data [startAfter="Code"]
.segmentdef Sprite
.segment Basic
:BasicUpstart(%E)
.segment Code