/// @file 
/// @brief Simple functions wrapping 6502 instructions

/// @brief  Set the processor interrupt flag - disabling IRQ's.
///
/// Uses the SEI instruction
inline void SEI();

/// @brief  Clear the processor interrupt flag - enabling IRQ's.
///
/// Uses the CLI instruction
inline void CLI();

/// @brief  Add a KickAssembler breakpoint.
///
/// The breakpoint is compiled be KickAssembler to the output files.
/// If you use VICE or C64Debugger they can automatically load the breakpoints when starting.
inline void BREAK();