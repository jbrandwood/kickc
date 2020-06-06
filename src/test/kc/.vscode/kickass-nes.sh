#!/bin/bash
export ASM_FILE=$1
export NES_FILE=${ASM_FILE%.*}.nes
java -jar /Applications/KickAssembler/KickAss.jar $1 -showmem -vicesymbols
nestopia $NES_FILE