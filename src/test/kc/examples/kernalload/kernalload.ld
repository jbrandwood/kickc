// Load a file to memory using the C64 KERNAL LOAD functions
.file [name="kernalload.prg", type="prg", segments="Program"]
.disk [filename="kernalload.d64", name="DISK", id=1] {
        [name="KERNALLOAD", type="prg", segments="Program"],
        [name="SPRITE", type="prg", segments="Sprite"]
}
.segmentdef Program [segments="Basic, Code, Data"]
.segmentdef Basic [start=$0801]
.segmentdef Code [start=$0810]
.segmentdef Data [startAfter="Code"]
.segmentdef Sprite
.segment Basic
:BasicUpstart(main)