#!/bin/bash
export C_FILE=$1
export BASE_FILE=$(basename $1)
export OUT_FILE=~/c64/tmp/$BASE_FILE
export ASM_FILE=${OUT_FILE%.*}.s
export O_FILE=${OUT_FILE%.*}.o
export PRG_FILE=${OUT_FILE%.*}.prg
cc65 -t c64 -O -o $ASM_FILE $C_FILE
ca65 -t c64 -o $O_FILE $ASM_FILE
ld65 -t c64 -o $PRG_FILE $O_FILE c64.lib
x64sc $PRG_FILE