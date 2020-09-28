#!/bin/sh

rm out.raw
rm out.prg

#cl65 -Oris -Cl -C c64o.cfg -t c64 bubbles64.c lazyply-ca65.s c64irq-ca65.s c64sprcore-ca65.s -o out.raw || exit

vc +c64 -+ -Dmain=__main -O3 bubbles64.c -llazyply -o out.raw || exit
exomizer sfx sys out.raw sprites.spr@0xD000 -q -p 1 -m 1 -o out.prg || exit

#x64 -pal out.prg
