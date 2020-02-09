// Create a D64 disk containing the program and a sprite file
.file [name="%O.prg", type="prg", segments="Program"]
.disk [filename="%O.d64", name="DISK", id=1] {
        [name="%^O", type="prg", segments="Program"],
        [name="SPRITE", type="prg", segments="Sprite"]
}
.segmentdef Program [segments="Basic, Code, Data"]
.segmentdef Basic [start=$0801]
.segmentdef Code [start=$0810]
.segmentdef Data [startAfter="Code"]
.segmentdef Sprite
.segment Basic
:BasicUpstart(main)