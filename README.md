# KickC - Optimizing C-compiler for 6502  

KickC is a C-compiler for 6502-based platforms creating optimized and readable assembler code.

The language is 95% standard C with a few limitations, and a few extensions to ensure an optimal fit for creating 6502 assembler code.

The KickC-compiler includes all necessary linker and header files to makes it easy to create and test binaries for the following 6502-based platforms out-of-the-box:
- Commodore VIC 20
- Commodore 64
- Commodore Plus/4 (Commodore 16 ,  Commodore 116)
- Atari 2600
- Atari XL/XE 
- Nintendo NES
- MEGA65
- Commander X16

KickC uses the very versatile Kick Assembler (http://theweb.dk/KickAssembler). The KickC Compiler produces assembler code for the MOS Technology 6502 processor family. Specifically the compiler supports 6502, 65C02, 65CE02 and 45GS02 CPUs.

## Resources

* [Download](https://gitlab.com/camelot/kickc/-/releases) the newest Release 

* [Read](https://docs.google.com/document/d/1JE-Lt5apM-g4tZN3LS4TDbPKYgXuBz294enS9Oc4HXM/edit?usp=sharing) the Reference Manual

* [Look](https://gitlab.com/camelot/kickc/tree/master) through the Source Code

* [Follow](https://gitlab.com/camelot/kickc/issues) the features being developed

* [Discuss](https://www.facebook.com/groups/302286200587943/) the compiler and receive news on facebook

* [Contribute](https://gitlab.com/camelot/kickc/blob/master/CONTRIBUTING.md) to the development of KickC 

## BETA

KickC is currently in beta, and at times crash or creates ASM code that does not work properly. 
Feel free to test it and report any problems or errors you encounter, but do not expect it to produce production quality code.
Also, be prepared that breaking changes (to syntax, to semantics, etc.) may be implemented in the next versions.