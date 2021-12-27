#include <stdint.h>

// Declaration of typed variables used in fragments

uint8_t __register(A) vbuaa;
uint8_t __register(X) vbuxx;
uint8_t __register(Y) vbuyy;
uint8_t __register(Z) vbuzz;
int8_t __register(A) vbsaa;
int8_t __register(X) vbsxx;
int8_t __register(Y) vbsyy;
int8_t __register(Z) vbszz;

uint8_t __zp vbuz1, vbuz2, vbuz3, vbuz4;
uint8_t __mem vbum1, vbum2, vbum3, vbum4;
uint8_t const vbuc1, vbuc2, vbuc3, vbuc4;
int8_t __zp vbsz1, vbsz2, vbsz3, vbsz4;
int8_t __mem vbsm1, vbsm2, vbsm3, vbsm4;
int8_t const vbsc1, vbsc2, vbsc3, vbsc4;
uint16_t __zp vwuz1, vwuz2, vwuz3, vwuz4;
uint16_t __mem vwum1, vwum2, vwum3, vwum4;
uint16_t const vwuc1, vwuc2, vwuc3, vwuc4;
int16_t __zp vwsz1, vwsz2, vwsz3, vwsz4;
int16_t __mem vwsm1, vwsm2, vwsm3, vwsm4;
int16_t const vwsc1, vwsc2, vwsc3, vwsc4;
uint32_t __zp vduz1, vduz2, vduz3, vduz4;
uint32_t __mem vdum1, vdum2, vdum3, vdum4;
uint32_t const vduc1, vduc2, vduc3, vduc4;
int32_t __zp vdsz1, vdsz2, vdsz3, vdsz4;
int32_t __mem vdsm1, vdsm2, vdsm3, vdsm4;
int32_t const vdsc1, vdsc2, vdsc3, vdsc4;

typedef uint8_t * __zp PBUZ;
PBUZ pbuz1, pbuz2, pbuz3, pbuz4;
typedef uint8_t * __mem PBUM;
PBUM pbum1, pbum2, pbum3, pbum4;
typedef uint8_t * const PBUC;
PBUC pbuc1, pbuc2, pbuc3, pbuc4;
typedef int8_t * __zp PBSZ;
PBSZ pbsz1, pbsz2, pbsz3, pbsz4;
typedef int8_t * __mem PBSM;
PBSM pbsm1, pbsm2, pbsm3, pbsm4;
typedef int8_t * const PBSC;
PBSC pbsc1, pbsc2, pbsc3, pbsc4;
typedef uint16_t * __zp PWUZ;
PWUZ pwuz1, pwuz2, pwuz3, pwuz4;
typedef uint16_t * __mem PWUM;
PWUM pwum1, pwum2, pwum3, pwum4;
typedef uint16_t * const PWUC;
PWUC pwuc1, pwuc2, pwuc3, pwuc4;
typedef int16_t * __zp PWSZ;
PWSZ pwsz1, pwsz2, pwsz3, pwsz4;
typedef int16_t * __mem PWSM;
PWSM pwsm1, pwsm2, pwsm3, pwsm4;
typedef int16_t * const PWSC;
PWSC pwsc1, pwsc2, pwsc3, pwsc4;
typedef uint32_t * __zp PDUZ;
PDUZ pwuz1, pwuz2, pwuz3, pwuz4;
typedef uint32_t * __mem PDUM;
PDUM pwum1, pwum2, pwum3, pwum4;
typedef uint32_t * const PDUC;
PDUC pwuc1, pwuc2, pwuc3, pwuc4;
typedef int32_t * __zp PDSZ;
PDSZ pwsz1, pwsz2, pwsz3, pwsz4;
typedef int32_t * __mem PDSM;
PDSM pwsm1, pwsm2, pwsm3, pwsm4;
typedef int32_t * const PDSC;
PDSC pwsc1, pwsc2, pwsc3, pwsc4;
typedef void * __zp PVOZ;
PVOZ pvoz1, pvoz2, pvoz3, pvoz4;
typedef void * __mem PVOM;
PVOM pvom1, pvom2, pvom3, pvom4;
typedef void * const PVOC;
PVOC pvoc1, pvoc2, pvoc3, pvoc4;

typedef uint8_t * __zp QBUZ;
QBUZ qbuz1, qbuz2, qbuz3, qbuz4;
typedef uint8_t * __mem QBUM;
QBUM qbum1, qbum2, qbum3, qbum4;
typedef uint8_t * const QBUC;
QBUC qbuc1, qbuc2, qbuc3, qbuc4;
typedef int8_t * __zp QBSZ;
QBSZ qbsz1, qbsz2, qbsz3, qbsz4;
typedef int8_t * __mem QBSM;
QBSM qbsm1, qbsm2, qbsm3, qbsm4;
typedef int8_t * const QBSC;
QBSC qbsc1, qbsc2, qbsc3, qbsc4;
typedef uint16_t * __zp QWUZ;
QWUZ qwuz1, qwuz2, qwuz3, qwuz4;
typedef uint16_t * __mem QWUM;
QWUM qwum1, qwum2, qwum3, qwum4;
typedef uint16_t * const QWUC;
QWUC qwuc1, qwuc2, qwuc3, qwuc4;
typedef int16_t * __zp QWSZ;
QWSZ qwsz1, qwsz2, qwsz3, qwsz4;
typedef int16_t * __mem QWSM;
QWSM qwsm1, qwsm2, qwsm3, qwsm4;
typedef int16_t * const QWSC;
QWSC qwsc1, qwsc2, qwsc3, qwsc4;
typedef uint32_t * __zp QDUZ;
QDUZ qwuz1, qwuz2, qwuz3, qwuz4;
typedef uint32_t * __mem QDUM;
QDUM qwum1, qwum2, qwum3, qwum4;
typedef uint32_t * const QDUC;
QDUC qwuc1, qwuc2, qwuc3, qwuc4;
typedef int32_t * __zp QDSZ;
QDSZ qwsz1, qwsz2, qwsz3, qwsz4;
typedef int32_t * __mem QDSM;
QDSM qwsm1, qwsm2, qwsm3, qwsm4;
typedef int32_t * const QDSC;
QDSC qwsc1, qwsc2, qwsc3, qwsc4;
typedef void * __zp QVOZ;
QVOZ qvoz1, qvoz2, qvoz3, qvoz4;
typedef void * __mem QVOM;
QVOM qvom1, qvom2, qvom3, qvom4;
typedef void * const QVOC;
QVOC qvoc1, qvoc2, qvoc3, qvoc4;

//vbo   - boolean byte.
//ppr   - pointer to procedure?
//pss   - pointer to struct 
//0/1/2/... - constant known number.


// Rewrite rules for creating fragment signature names from expressions
// C-expr   => Signature
// A=B      => A=B
// (A)      => (A)
// *A       => _deref_A
// A[B]     => A_derefidx_B
// A+B      => A_plus_B
// A-B      => A_minus_B
// -A       => _neg_A
// A-1      => _dec_A
// A+1      => _inc_A
// A|B      => A_bor_B
// A&B      => A_band_B
// A^B      => A_bxor_B
// ~A       => _bnot_A
// A<<B     => A_rol_B
// A>>B     => A_ror_B
// A||B     => A_or_B
// A&&B     => A_and_B
// A<B      => A_lt_B
// A>B      => A_gt_B
// A<=B     => A_le_B
// A>=B     => A_ge_B
// A==B     => A_eq_B
// A!=B     => A_neq_B
// &A       => _ptr_A

// _then_
// isr_
// call_
// _setbyte0_, _setbyte1_, ...
// _setword0_, _setword1_, ...
// _byte0_, _byte1_, ...
// _word0_, _word1_
// _word_ / _sbyte_ /  _byte_
// _stackpull
// _stackpush
// _stackidx
// casting?

// pbuz1=pbuz1+pbuc1[vbuxx] => pbuz1=pbuz1_plus_pbuc1_derefidx_vbuxx

