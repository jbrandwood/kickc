// Commodore 64 PRG executable file
.plugin "se.triad.kickass.CruncherPlugins"
.file [name="%O", type="prg", segments="Program"]
.segmentdef Program [segments="Basic, Common, Part2, Part1, InitDemo"]
.segmentdef Basic [start=$0801]
.segmentdef Common [segments="Code, Data"]
.segmentdef   Code [start=%P]
.segmentdef   Data [startAfter="Code"]
.segmentdef Part2 [segments="CodePart2, DataPart2, InitPart2"]
.segmentdef   CodePart2 [startAfter="Data"]
.segmentdef   DataPart2 [startAfter="CodePart2"]
.segmentdef   InitPart2 [startAfter="DataPart2"]
.segmentdef Part1 [segments="CodePart1, DataPart1, InitPart1"]
.segmentdef   CodePart1 [startAfter="InitPart2"]
.segmentdef   DataPart1 [startAfter="CodePart1"]
.segmentdef   InitPart1 [startAfter="DataPart1"]
.segmentdef InitDemo [startAfter="InitPart1"]
.segment Basic
:BasicUpstart(%E)