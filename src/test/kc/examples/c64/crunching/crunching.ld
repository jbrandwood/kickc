// Commodore 64 PRG executable file - with the cruncher plugin enabled
.plugin "se.triad.kickass.CruncherPlugins"
.file [name="%O", type="prg", segments="Program"]
.segmentdef Program [segments="Basic, Code, Data"]
.segmentdef Basic [start=$0801]
.segmentdef Code [start=%P]
.segmentdef Data [startAfter="Code"]
.segment Basic
:BasicUpstart(%E)