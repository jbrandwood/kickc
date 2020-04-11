// Tests a sub-optimal fragment synthesis
// vbuaa=vbuxx_band_pbuz1_derefidx_vbuc1 < vbuaa=pbuz1_derefidx_vbuc1_band_vbuxx < vbuaa=pbuz1_derefidx_vbuaa_band_vbuxx < vbuaa=pbuz1_derefidx_vbuyy_band_vbuxx < vbuaa=pbuz1_derefidx_vbuyy_band_vbuaa < vbuaa=vbuaa_band_pbuz1_derefidx_vbuyy - clobber:A Y  cycles:11.5


void main() {
    byte* screen = $400;
    byte* z = $450;
    z[2] = $f0;
    z[3] = $0f;
    byte x = $aa;
    byte a1 = fct(x, z);
    screen[0] = a1;
    z++;
    x = $55;
    byte a2 = fct(x, z);
    screen[1] = a2;
}

byte fct(byte register(X) x, byte* z) {
    byte register(A) a = x & z[2];
    return a;
}
