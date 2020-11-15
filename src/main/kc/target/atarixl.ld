// Atari XL/XE executable XEX file with a single segment
// https://www.atarimax.com/jindroush.atari.org/afmtexe.html
.plugin "dk.camelot64.kickass.xexplugin.AtariXex"
.file [name="%O", type="bin", segments="XexFile"]
.segmentdef XexFile [segments="Program", modify="XexFormat", _RunAddr=%E]
.segmentdef Program [segments="Code, Data"]
.segmentdef Code [start=%P]
.segmentdef Data [startAfter="Code"]