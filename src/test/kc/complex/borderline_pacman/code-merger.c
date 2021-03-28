// Cycle-based code merger
// Usable for merging unrolled cycle-exact logic code into an unrolled cycle-exact raster code.


// Merge unrolled cycle-exact logic code into an unrolled cycle-exact raster code. 
// The logic-code is merged into the raster code ensuring cycle-exact execution. If a logic-code block does not fit within the remaining cycle-budget of a raster-slot then NOPs/BIT $EA are used to reach the cycle-budget.
// If the logic-code runs out before the raster-code ends then the remaining raster-slots are filled with NOP/BIT$EA.
// If the raster-code runs out before the logic-code then the rest of the logic-code is added at the end.
// An RTS is added at the very end.
//
// Parameters:
// - dest_code: Address where the merged code is placed
// - raster_code: The unrolled raster code blocks with information about cycles to be filled. Format is decribed below.
// - logic_code: The unrolled logic code with information about cycles spent. Format is decribed below.
//
// Format of unrolled raster code. 
// A number of blocks that have the following structure: 
// <nn>* 0xff <cc> 
// <nn>* : some bytes of code. any number of bytes are allowed.
// 0xff  : signals the end of a block.
// <cc>  : If <cc> is 00 then this is the last block of the unrolled raster code. 
//         If <cc> is non-zero it means that <cc> cycles must be spent here (the cycle budget of the slot). The merger merges logic code into the slot and fills with NOP's to match the number of cycles needed.
//
// Format of unrolled logic code.
// A number of blocks that has the following structure: 
// <cc> <nn>* 0xff
// <cc>  : If <cc> is 00 then this is the last block of the unrolled logic code. No more bytes are used.
//         If <cc> is non-zero it holds the number of cycles used by the block of code.
// <nn>* : some bytes of code. any number of bytes are allowed. This code uses exactly the number of cycles specified by <cc>
// 0xff  : signals the end of a block.
void merge_code(char* dest_code, char* raster_code, char * logic_code) {

    // Cycle-count signalling the last block of the logic-code
    const char LOGIC_EXIT = 0x00;
    // Value signalling the end of a block of the logic-code
    const char LOGIC_END = 0xff;
    // Cycle-count signalling the last block of the raster-code
    const char RASTER_EXIT = 0x00;
    // Value signalling the end of a block of the raster-code
    const char RASTER_END = 0xff;

    for(;;) {
        // Output raster code until meeting RASTER_END signalling the end of a block
        while(*raster_code!=RASTER_END) *dest_code++ = *raster_code++;
        // move past the end marker (RASTER_END)
        raster_code++;
        // Find the number of cycles
        char cycle_budget = *raster_code++;
        if(cycle_budget==RASTER_EXIT)
            // This is the end of the raster code.
            break;
        // Fit the cycle budget with logic-code
        while(cycle_budget>0) {
            // Find the number of logic code cycles
            char logic_cycles = *logic_code;
            // Check if logic code exists and fits the cycle-budget (ensure that it does not leave a single cycle in the budget)
            if(logic_cycles!=LOGIC_EXIT && (logic_cycles < cycle_budget-1 || logic_cycles==cycle_budget)) {
                // Skip the cycle count
                logic_code++;
                // Fill in the logic-code
                while(*logic_code!=LOGIC_END) *dest_code++ = *logic_code++;
                // move past the end marker (LOGIC_END)
                logic_code++;
                // Reduce the cycle budget
                cycle_budget -= logic_cycles;
                // Move to the next logic block
                continue;
            }
            // No more logic-code or not enough room in the budget 
            break;
        }
        // Fit the cycle budget with NOPs
        while(cycle_budget>0) {
            if(cycle_budget==3) {
                *dest_code++ = 0x24; // BIT $EA
                *dest_code++ = 0xEA;
                cycle_budget -= 3;
            } else {
                *dest_code++ = 0xEA; // NOP
                cycle_budget -= 2;
            }
        }
    }
    // No more raster code - fill in the rest of the logic code
    while(*logic_code!=LOGIC_EXIT) {
        // Skip the cycle count
        logic_code++;
        // Fill in the logic-code
        while(*logic_code!=LOGIC_END) *dest_code++ = *logic_code++;
        // move past the end marker (LOGIC_END)
        logic_code++;
    }
    // And add an RTS
    *dest_code++ = 0x60; // RTS
}
