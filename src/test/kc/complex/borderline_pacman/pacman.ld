// Commodore 64 PRG executable file
.plugin "se.triad.kickass.CruncherPlugins"
.file [name="%O", type="prg", segments="Program", modify="B2exe", _jmpAdress=%E]
.segmentdef Program [segments="Code, Data, Init"]
.segmentdef Code [start=%P]
.segmentdef Data [startAfter="Code"]
.segmentdef Init [startAfter="Data"]