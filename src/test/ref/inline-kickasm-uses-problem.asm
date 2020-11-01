// Variable used in inline kickasm must be __ma
// See https://gitlab.com/camelot/kickc/-/issues/558
  // Atari XL/XE executable XEX file with a single segment
// https://www.atarimax.com/jindroush.atari.org/afmtexe.html
.file [name="inline-kickasm-uses-problem.xex", type="bin", segments="XexFile"]
.segmentdef XexFile
.segment XexFile
// Binary File Header
.byte $ff, $ff
// Program segment [start address, end address, data]
.word ProgramStart, ProgramEnd-1
.segmentout [ segments="Program" ]
// RunAd - Run Address Segment [start address, end address, data]
.word $02e0, $02e1
.word main
.segmentdef Program [segments="ProgramStart, Code, Data, ProgramEnd"]
.segmentdef ProgramStart [start=$2000]
.segment ProgramStart
ProgramStart:
.segmentdef Code [startAfter="ProgramStart"]
.segmentdef Data [startAfter="Code"]
.segmentdef ProgramEnd [startAfter="Data"]
.segment ProgramEnd
ProgramEnd:

  .label OUT = $8000
.segment Code
main: {
    // foo(a, b)
    jsr foo
    // }
    rts
  .segment Data
    a: .byte $80, $4f, 2, $d
}
.segment Code
foo: {
    .label v1 = $80
    .label v2 = $82
    .label a2 = $84
    // v1
    lda #<0
    sta.z v1
    sta.z v1+1
    // v2
    sta.z v2
    sta.z v2+1
    // a2 = 2
    lda #2
    sta.z a2
    // v1 = x1
    lda #<main.a
    sta.z v1
    lda #>main.a
    sta.z v1+1
    // v2 = &a2
    lda #<a2
    sta.z v2
    lda #>a2
    sta.z v2+1
    // kickasm
    lda v1
		sta v2
	
    // *(OUT) = a2
    lda.z a2
    sta OUT
    // }
    rts
}
