// Find atan2(x, y) using the CORDIC method
// See http://bsvi.ru/uploads/CORDIC--_10EBA/cordic.pdf

#include <atan2.h>

// The number of iterations performed during 16-bit CORDIC atan2 calculation
const byte CORDIC_ITERATIONS_16 = 15;

// Angles representing ATAN(0.5), ATAN(0.25), ATAN(0.125), ...
word CORDIC_ATAN2_ANGLES_16[CORDIC_ITERATIONS_16] = kickasm {{
   .for (var i=0; i<CORDIC_ITERATIONS_16; i++)
        .word 256*2*256*atan(1/pow(2,i))/PI/2
}};

// Find the atan2(x, y) - which is the angle of the line from (0,0) to (x,y)
// Finding the angle requires a binary search using CORDIC_ITERATIONS_16
// Returns the angle in hex-degrees (0=0, 0x8000=PI, 0x10000=2*PI)
word atan2_16(signed word x, signed word y) {
    signed word yi = (y>=0)?y:-y;
    signed word xi = (x>=0)?x:-x;
    word angle = 0;
    for( byte i: 0..CORDIC_ITERATIONS_16-1) {
        if(yi==0) {
            // We found the correct angle!
            break;
        }
        // Optimized shift of 2 values: xd=xi>>i; yd=yi>>i
        signed word xd = xi;
        signed word yd = yi;
        byte shift = i;
        while(shift>=2) {
            xd >>= 2;
            yd >>= 2;
            shift -=2;
        }
        if(shift) {
            xd >>= 1;
            yd >>= 1;
        }
        if(yi>=0) {
            xi += yd;
            yi -= xd;
            angle += CORDIC_ATAN2_ANGLES_16[i];
        } else {
            xi -= yd;
            yi += xd;
            angle -= CORDIC_ATAN2_ANGLES_16[i];
        }
    }
    angle /=2;
    if(x<0) angle = 0x8000-angle;
    if(y<0) angle = -angle;
    // Iterations complete - return estimated angle
    return angle;
}

// The number of iterations performed during 8-bit CORDIC atan2 calculation
const byte CORDIC_ITERATIONS_8 = 8;

// Angles representing ATAN(0.5), ATAN(0.25), ATAN(0.125), ...
byte CORDIC_ATAN2_ANGLES_8[CORDIC_ITERATIONS_8] = kickasm {{
  .fill CORDIC_ITERATIONS_8, 2*256*atan(1/pow(2,i))/PI/2
}};

// Find the atan2(x, y) - which is the angle of the line from (0,0) to (x,y)
// Finding the angle requires a binary search using CORDIC_ITERATIONS_8
// Returns the angle in hex-degrees (0=0, 0x80=PI, 0x100=2*PI)
byte atan2_8(signed byte x, signed byte y) {
    signed byte yi = (y>0)?y:-y;
    signed byte xi = (x>0)?x:-x;
    byte angle = 0;
    for( byte i: 0..CORDIC_ITERATIONS_8-1) {
        if(yi==0) {
            // We found the correct angle!
            break;
        }
        signed byte xd = xi>>i;
        signed byte yd = yi>>i;
        if(yi>0) {
            xi += yd;
            yi -= xd;
            angle += CORDIC_ATAN2_ANGLES_8[i];
        } else {
            xi -= yd;
            yi += xd;
            angle -= CORDIC_ATAN2_ANGLES_8[i];
        }
    }
    angle = angle/2;
    if(x<0) angle = 128-angle;
    if(y<0) angle = -angle;
    // Iterations complete - return estimated angle
    return angle;
}