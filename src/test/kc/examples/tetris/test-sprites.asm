

.label PLAYFIELD_SPRITES = $3000

.pc = PLAYFIELD_SPRITES "PLayfield Sprites"
.var charset = LoadPicture("nes-playfield.png", List().add($010101, $000000))
.for(var sy=0;sy<10;sy++) {
	.for(var sx=0;sx<3;sx++) {
    	.for (var y=0;y<21; y++) {
	    	.for (var c=0; c<3; c++) {	    			
            	.byte charset.getSinglecolorByte(sx*3+c,sy*21+y)
            }
        }
    	.byte 0
  	}
}
