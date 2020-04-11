 // Quadratic Spline Library
 // Implements an iterative algorithm using only addition for calculating quadratic splines
 //
 // A quadratic spline is a curve defined by 3 points: P0, P1 and P2.
 // The curve connects P0 to P2 through a smooth curve that moves towards P1, but does usually not touch it.
 //
 // The general formula for the quadratic spline is as follows:
 // A = P2 - 2*P1 + P0
 // B = 2*P1 - 2*P0
 // C = P0
 // P(t) = A*t*t + B*t + C
 // for 0 <= t <= 1
 //
 // This library implements a iterative algorithm using multiplications in the initialization and only additions for calculating each point on the spline.
 // The iterative algorithm is based on the following:
 // P(t+Dt) = P(t) + A*Dt*Dt + 2*A*t*Dt + B*Dt
 //
 // init:
 //   N = 16 (number of plots)
 //   Dt = 1/N
 //   P = C
 //   I = A*Dt*Dt + B*Dt
 //   J = 2*A*Dt*Dt
 // loop(N times):
 //   plot(P)
 //   P = P + I
 //   I = I + J
 // When N=16 then Dt[0.16] = $0.1000 Dt^2[0.16] = $0.0100
 // When N=8 then Dt[0.16] = $0.2000 Dt^2[0.16] = $0.0400

// Vector with 16-coordinates that is part of a spline
struct SplineVector16 {
    // x-position s[16.0]
    signed int x;
    // y-position s[16.0]
    signed int y;
};

// Vector with 32-bit coordinates that is part of a spline
struct SplineVector32 {
    // x-position s[16.16]
    signed long x;
    // y-position s[16.16]
    signed long y;
};

// Array filled with spline segment points by splinePlot_16()
struct SplineVector16 SPLINE_16SEG[17];

// Generate a 16-segment quadratic spline using 32-bit fixed point 1/$10000-format math 16 decimal bits).
// This function can handle all signed int values in the points.
// The resulting spline segment points are returned in SPLINE_16SEG[]
// A quadratic spline is a curve defined by 3 points: P0, P1 and P2.
// The curve connects P0 to P2 through a smooth curve that moves towards P1, but does usually not touch it.
void spline_16seg(struct SplineVector16 p0, struct SplineVector16 p1, struct SplineVector16 p2) {
   // A = P2 - 2*P1 + P0
    struct SplineVector16 a = { p2.x - p1.x*2 + p0.x, p2.y - p1.y*2 + p0.y};
    // B = 2*P1 - 2*P0
    struct SplineVector16 b = { (p1.x - p0.x)*2, (p1.y - p0.y)*2 };
    // I = A*Dt*Dt + B*Dt - Fixed point s[16.16]
    // Dt = 1/16 and Dt*Dt=1/256 - we can multiply using only bitshifts
    struct SplineVector32 i = { (signed long)a.x*0x100 + (signed long)b.x*0x100*0x10, (signed long)a.y*0x100 + (signed long)b.y*0x100*0x10 };
    // J = 2*A*Dt*Dt - Fixed point s[16.16]
    // Dt = 1/16 and Dt*Dt=1/256 - we can multiply using only bitshifts
     struct SplineVector32 j = { (signed long)a.x*0x100*2, (signed long)a.y*0x100*2 };
    // P = P0 - Fixed point s[16.16]
    struct SplineVector32 p = { (signed long)p0.x*0x10000, (signed long)p0.y*0x10000 };
    for( char n: 0..15) {
        SPLINE_16SEG[n] = { (signed word)>(p.x+0x8000), (signed word)>(p.y+0x8000) };
        // P = P + I;
        p = { p.x+i.x, p.y+i.y };
        // I = I + J;
        i = { i.x+j.x, i.y+j.y };
    }
    SPLINE_16SEG[16] = { (signed word)>(p.x+0x8000), (signed word)>(p.y+0x8000) };
}

// Array filled with spline segment points by splinePlot_8()
struct SplineVector16 SPLINE_8SEG[9];

// Generate a 8-segment quadratic spline using 32-bit fixed point 1/$10000-format math 16 decimal bits).
// The resulting spline segment points are returned in SPLINE_8SEG[]
// This function can handle all signed int values in the points.
// A quadratic spline is a curve defined by 3 points: P0, P1 and P2.
// The curve connects P0 to P2 through a smooth curve that moves towards P1, but does usually not touch it.
void spline_8seg(struct SplineVector16 p0, struct SplineVector16 p1, struct SplineVector16 p2) {
   // A = P2 - 2*P1 + P0
    struct SplineVector16 a = { p2.x - p1.x*2 + p0.x, p2.y - p1.y*2 + p0.y};
    // B = 2*P1 - 2*P0
    struct SplineVector16 b = { (p1.x - p0.x)*2, (p1.y - p0.y)*2 };
    // I = A*Dt*Dt + B*Dt - Fixed point s[16.16]
    // Dt = 1/8 and Dt*Dt=1/64 - we can multiply using only bitshifts
    struct SplineVector32 i = { (signed long)a.x*0x100*0x4 + (signed long)b.x*0x100*0x20, (signed long)a.y*0x100*0x4 + (signed long)b.y*0x100*0x20 };
    // J = 2*A*Dt*Dt  - Fixed point s[16.16]
    // Dt = 1/8 and Dt*Dt=1/64 - we can multiply using only bitshifts
    struct SplineVector32 j = { (signed long)a.x*0x100*0x8, (signed long)a.y*0x100*0x8 };
    // P = P0  - Fixed point s[16.16]
    struct SplineVector32 p = { (signed long)p0.x*0x10000, (signed long)p0.y*0x10000 };
    for( char n: 0..7) {
        SPLINE_8SEG[n] = { (signed word)>(p.x+0x8000), (signed word)>(p.y+0x8000) };
        // P = P + I;
        p = { p.x+i.x, p.y+i.y };
        // I = I + J;
        i = { i.x+j.x, i.y+j.y };
    }
    SPLINE_8SEG[8] = { (signed word)>(p.x+0x8000), (signed word)>(p.y+0x8000) };
}

// Generate a 8-segment quadratic spline using 16-bit fixed point 1/64-format math (6 decimal bits).
// The resulting spline segment points are returned in SPLINE_8SEG[]
// Point values must be within [-200 ; 1ff] for the calculation to not overflow.
// A quadratic spline is a curve defined by 3 points: P0, P1 and P2.
// The curve connects P0 to P2 through a smooth curve that moves towards P1, but does usually not touch it.
void spline_8segB(struct SplineVector16 p0, struct SplineVector16 p1, struct SplineVector16 p2) {
   // A = P2 - 2*P1 + P0
    struct SplineVector16 a = { p2.x - p1.x*2 + p0.x, p2.y - p1.y*2 + p0.y};
    // B = 2*P1 - 2*P0
    struct SplineVector16 b = { (p1.x - p0.x)*2, (p1.y - p0.y)*2 };
    // I = A*Dt*Dt + B*Dt - I is in fixed point 1/64-format (6 decimal bits) [-200 ; 1ff]
    // Dt = 1/8 and Dt*Dt=1/64 - we can multiply using only bitshifts. Dt*Dt is exactly==1 in the fixed point format.
    struct SplineVector16 i = { a.x + b.x*8, a.y + b.y*8};
    // J = 2*A*Dt*Dt - J is in fixed point 1/64-format (6 decimal bits) [-200 ; 1ff]
    // Dt = 1/8 and Dt*Dt=1/64 - we can multiply using only bitshifts. Dt*Dt is exactly==1 in the fixed point format.
    struct SplineVector16 j = { a.x*2, a.y*2 };
    // P = P0 - P is in fixed point 1/64-format (6 decimal bits) [-200 ; 1ff]
    struct SplineVector16 p = { p0.x*0x40, p0.y*0x40 };
    for( char n: 0..7) {
        // Get the rounded result
        SPLINE_8SEG[n] = { (p.x+0x20)/0x40, (p.y+0x20)/0x40 };
        // P = P + I;
        p = { p.x+i.x, p.y+i.y };
        // I = I + J;
        i = { i.x+j.x, i.y+j.y };
    }
    SPLINE_8SEG[8] = { (p.x+0x20)/0x40, (p.y+0x20)/0x40 };
}
