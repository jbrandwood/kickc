// Variable used in inline kickasm must be __ma
// See https://gitlab.com/camelot/kickc/-/issues/558
  // Atari XL/XE executable XEX file with a single segment
// https://www.atarimax.com/jindroush.atari.org/afmtexe.html
.plugin "dk.camelot64.kickass.xexplugin.AtariXex"
.file [name="inline-kickasm-uses-problem.xex", type="bin", segments="XexFile"]
.segmentdef XexFile [segments="Program", modify="XexFormat", _RunAddr=main]
.segmentdef Program [segments="Code, Data"]
.segmentdef Code [start=$2000]
.segmentdef Data [startAfter="Code"]
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
// void foo(char *x1, char *x2)
foo: {
    .label v1 = $80
    .label v2 = $82
    .label a2 = $84
    // volatile uint8_t * v1
    lda #<0
    sta.z v1
    sta.z v1+1
    // uint8_t * v2
    sta.z v2
    sta.z v2+1
    // uint8_t a2 = 2
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
