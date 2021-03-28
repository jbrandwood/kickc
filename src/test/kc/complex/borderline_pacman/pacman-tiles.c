// The level represented as 4x4 px tiles. Each byte is the ID of a tile from the tile set.
// The level is 50 tiles * 37 tiles. The first tile line are special half-tiles (where only the last 2 pixel rows are shown).
// The level data is organized as 37 rows of 50 tile IDs.

char LEVEL_TILES_CRUNCHED[] = kickasm(resource "pacman-tiled.png", uses LEVEL_TILES) {{
    .modify B2() {
        .pc = LEVEL_TILES "LEVEL TILE GRAPHICS"
        .var pic_level = LoadPicture("pacman-tiled.png", List().add($000000, $352879, $bfce72, $883932))
        // Maps the tile pixels (a 16 bit number) to the tile ID
        .var TILESET = Hashtable()
        // Maps the tile ID to the pixels (a 16 bit number)
        .var TILESET_BY_ID = Hashtable()
        // Tile ID 0 is empty
        .eval TILESET.put(0, 0)
        .eval TILESET_BY_ID.put(0, 0)

        .align $100
        // TABLE LEVEL_TILES[64*37]
        // The level is 50 tiles * 37 tiles. The first tile line are special half-tiles (where only the last 2 pixel rows are shown).
        // The level data is organized as 37 rows of 64 bytes containing tile IDs. (the last 14 are unused to achieve 64-byte alignment)
        .for(var ytile=0; ytile<37; ytile++) {
            .for(var xtile=0; xtile<50; xtile++) {
                // Find the tile pixels (4x4 px - 16 bits)
                .var pixels = 0;
                .for(var i=0; i<4; i++) {
                    .var pix = pic_level.getMulticolorByte(xtile/2,ytile*4+i)
                    .if((xtile&1)==0) {
                        // left nibble
                        .eval pix = floor(pix / $10)
                    } else {
                        // right nibble
                        .eval pix = pix & $0f
                    }
                    .eval pixels = pixels*$10 + pix                
                }
                .var tile_id = 0
                .if(TILESET.containsKey(pixels)) {
                    .eval tile_id = TILESET.get(pixels)
                } else {
                    .eval tile_id = TILESET.keys().size()
                    .eval TILESET.put(pixels, tile_id)
                    .eval TILESET_BY_ID.put(tile_id, pixels)
//                    .print "tile "+tile_id+" : "+toHexString(pixels,4)
                }
                // Output the tile ID
                .byte tile_id
            }
            .fill 14, 0
        }

        .align $100
        // TABLE char TILES_LEFT[0x80] 
        // The left tile graphics. A tile is 4x4 px. The left tiles contain tile graphics for the 4 left bits of a char. Each tile is 4 bytes.
        .for(var tile_id=0;tile_id<TILESET_BY_ID.keys().size();tile_id++) {
            .var pixels = TILESET_BY_ID.get(tile_id)
            .for(var i=0; i<4; i++) {
                .var pix = (pixels & $f000) >> 12
                .byte pix<<4
                .eval pixels = pixels << 4
            }
        }

        .align $80
        // TABLE char TILES_RIGHT[0x80]
        // The right tile graphics. A tile is 4x4 px. The right tiles contain tile graphics for the 4 right bits of a char. Each tile is 4 bytes.
        .for(var tile_id=0;tile_id<TILESET_BY_ID.keys().size();tile_id++) {
            .var pixels = TILESET_BY_ID.get(tile_id)
            .for(var i=0; i<4; i++) {
                .var pix = (pixels & $f000) >> 12
                .byte pix
                .eval pixels = pixels << 4
            }
        }
        .align $80
        // TABLE char TILES_TYPE[0x20]
        // 0: empty (all black), 1:pill, 2:powerup, 4: wall (contains blue pixels)
        .for(var tile_id=0;tile_id<TILESET_BY_ID.keys().size();tile_id++) {
            .var pixels = TILESET_BY_ID.get(tile_id)
            .var tile_type = 0
            .if(pixels==$0220) .eval tile_type=1 // 1:pill
            .if(pixels==$aaaa) .eval tile_type=2 // 2:powerup
            .for(var i=0; i<4; i++) {
                .var pix = (pixels & $f000) >> 12
                // Detect wall - any blue pixels (%01)
                .if( (pix&%0100)==%0100) .eval tile_type = 4; // 4:wall
                .if( (pix&%0001)==%0001) .eval tile_type = 4; // 4:wall
                .eval pixels = pixels << 4
            }
            .byte tile_type
            //.print "tile "+tile_id+" gfx "+toHexString(TILESET_BY_ID.get(tile_id),4) + " type "+tile_type
        }

    }
}};
