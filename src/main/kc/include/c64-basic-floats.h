/// Library wrapping the BASIC floating point functions
/// See https://www.c64-wiki.com/wiki/Floating_point_arithmetic
/// See http://www.pagetable.com/c64rom/c64rom_sc.html

/// Prepare MEM pointers for operations using MEM
inline void prepareMEM(unsigned int mem);

/// FAC = unsigned int
/// Set the FAC (floating point accumulator) to the integer value of a 16bit unsigned int
void setFAC(unsigned int w);

/// unsigned int = FAC
/// Get the value of the FAC (floating point accumulator) as an integer 16bit unsigned int
/// Destroys the value in the FAC in the process
unsigned int getFAC();

/// ARG = FAC
/// Set the ARG (floating point argument) to the value of the FAC (floating point accumulator)
void setARGtoFAC();

/// FAC = ARG
/// Set the FAC (floating point accumulator) to the value of the ARG (floating point argument)
void setFACtoARG();

/// MEM = FAC
/// Stores the value of the FAC to memory
/// Stores 5 chars (means it is necessary to allocate 5 chars to avoid clobbering other data using eg. char[] mem = {0, 0, 0, 0, 0};)
void setMEMtoFAC(char* mem);

/// FAC = MEM
/// Set the FAC to value from MEM (float saved in memory)
/// Reads 5 chars
void setFACtoMEM(char* mem);

/// FAC = PI/2
/// Set the FAC to PI/2
/// Reads 5 chars from the BASIC ROM
void setFACtoPIhalf();

/// FAC = 2*PI
/// Set the FAC to 2*PI
/// Reads 5 chars from the BASIC ROM
void setFACto2PI();

/// ARG = MEM
/// Load the ARG from memory
/// Reads 5 chars
void setARGtoMEM(char* mem);

/// FAC = MEM+FAC
/// Set FAC to MEM (float saved in memory) plus FAC (float accumulator)
/// Reads 5 chars from memory
void addMEMtoFAC(char* mem);

/// FAC = ARG+FAC
/// Add ARG (floating point argument) to FAC (floating point accumulator)
void addARGtoFAC();

/// FAC = MEM-FAC
/// Set FAC to MEM (float saved in memory) minus FAC (float accumulator)
/// Reads 5 chars from memory
void subFACfromMEM(char* mem);

/// FAC = ARG-FAC
/// Set FAC to ARG minus FAC
void subFACfromARG();

/// FAC = MEM/FAC
/// Set FAC to MEM (float saved in memory) divided by FAC (float accumulator)
/// Reads 5 chars from memory
void divMEMbyFAC(char* mem);

/// FAC = MEM*FAC
/// Set FAC to MEM (float saved in memory) multiplied by FAC (float accumulator)
/// Reads 5 chars from memory
void mulFACbyMEM(char* mem);

/// FAC = MEM^FAC
/// Set FAC to MEM (float saved in memory) raised to power of FAC (float accumulator)
/// Reads 5 chars from memory
void pwrMEMbyFAC(char* mem);

/// FAC = int(FAC)
/// Set FAC to integer part of the FAC - int(FAC)
/// The integer part is defined as the next lower integer - like java floor()
void intFAC();

/// FAC = sin(FAC)
/// Set FAC to sine of the FAC - sin(FAC)
/// Sine is calculated on radians (0-2*PI)
void sinFAC();

/// FAC = cos(FAC)
/// Set FAC to cosine of the FAC - cos(FAC)
/// Cosine is calculated on radians (0-2*PI)
void cosFAC();

/// FAC = tan(FAC)
/// Set FAC to the tangens of FAC - tan(FAC)
/// Tangens is calculated on radians (0-2*PI)
void tanFAC();

/// FAC = atn(FAC)
/// Set FAC to the arc tangens of FAC - atn(FAC)
/// Arc Tangens is calculated on radians (0-2*PI)
void atnFAC();

/// FAC = sqr(FAC)
/// Set FAC to the square root of FAC - sqr(FAC)
void sqrFAC();

/// FAC = exp(FAC)
/// Set FAC to the exponential function of FAC - exp(FAC)
/// Exp is based on the natural logarithm e=2.71828183
void expFAC();

/// FAC = log(FAC)
/// Set FAC to the logarithm of FAC - log(FAC)
/// Log is based on the natural logarithm e=2.71828183
void logFAC();

/// FAC = FAC/10
/// Set FAC to FAC divided by 10
void divFACby10();

/// FAC = FAC*10
/// Set FAC to FAC multiplied by 10
void mulFACby10();