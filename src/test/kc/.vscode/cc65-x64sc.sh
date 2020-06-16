#!/bin/bash
export C_FILE=$1
export ASM_FILE=${C_FILE%.*}.s
export O_FILE=${C_FILE%.*}.o
export PRG_FILE=${C_FILE%.*}.prg
cc65 -t c64 -O -o $ASM_FILE $C_FILE
ca65 -t c64 -o $O_FILE $ASM_FILE
ld65 -t c64 -o $PRG_FILE $O_FILE c64.lib
x64sc $PRG_FILE