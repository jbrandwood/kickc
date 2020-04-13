#include <sinus.h>
#include <print.h>

word wavelength = 192;
signed byte sintab2[192];
// .fill $c0, round(127.5*sin(i*2*PI/$c0))
byte sintabref[] = {
     $00, $04, $08, $0c, $11, $15, $19, $1d, $21, $25, $29, $2d, $31, $35, $38, $3c,
     $40, $43, $47, $4a, $4e, $51, $54, $57, $5a, $5d, $60, $63, $65, $68, $6a, $6c,
     $6e, $70, $72, $74, $76, $77, $79, $7a, $7b, $7c, $7d, $7e, $7e, $7f, $7f, $7f,
     $80, $7f, $7f, $7f, $7e, $7e, $7d, $7c, $7b, $7a, $79, $77, $76, $74, $72, $70,
     $6e, $6c, $6a, $68, $65, $63, $60, $5d, $5a, $57, $54, $51, $4e, $4a, $47, $43,
     $40, $3c, $38, $35, $31, $2d, $29, $25, $21, $1d, $19, $15, $11, $0c, $08, $04,
     $00, $fc, $f8, $f4, $ef, $eb, $e7, $e3, $df, $db, $d7, $d3, $cf, $cb, $c8, $c4,
     $c0, $bd, $b9, $b6, $b2, $af, $ac, $a9, $a6, $a3, $a0, $9d, $9b, $98, $96, $94,
     $92, $90, $8e, $8c, $8a, $89, $87, $86, $85, $84, $83, $82, $82, $81, $81, $81,
     $81, $81, $81, $81, $82, $82, $83, $84, $85, $86, $87, $89, $8a, $8c, $8e, $90,
     $92, $94, $96, $98, $9b, $9d, $a0, $a3, $a6, $a9, $ac, $af, $b2, $b6, $b9, $bd,
     $c0, $c4, $c8, $cb, $cf, $d3, $d7, $db, $df, $e3, $e7, $eb, $ef, $f4, $f8, $fc
};

void main() {
    sin8s_gen(sintab2, wavelength);
    print_cls();
    for(byte i: 0..191) {
        signed byte sb = sintab2[i]-(signed byte)sintabref[i];
        print_s8(sb);
        print_str("  ");
    }
}
