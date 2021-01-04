// Demo Flow Engine

// Start the demo IRQ. Can be called multiple times!
// Setting IRQ to the "demo" IRQ running outside the parts and 
// Setting memory to IO + RAM (no kernal/basic)
void demo_start();

// Work to be performed every frame while the demo runs
// Assumes that I/O is enabled
void demo_work();

// Counts total demo frames
extern volatile unsigned int demo_frame_count;
