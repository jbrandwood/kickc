// Raster-code for displaying 9 sprites on the entire screen - with open side borders
// The uncrunched code will be merged with logic code using code-merger.c
// The unmerged raster-code is identical for both buffers!

char RASTER_CODE_CRUNCHED[] = kickasm(uses VICII_CONTROL2, uses BORDER_COLOR, uses RASTER_CODE_UNMERGED, uses side_sprites_color, uses side_sprites_mc, uses bottom_sprites_color, uses bottom_sprites_mc) {{
    .macro RASTER_CYCLES(cycles) {
        .byte $ff, cycles
    }
    .modify B2() {
        .pc = RASTER_CODE_UNMERGED "RASTER CODE UNMERGED"
        RASTER_CYCLES(29)
        // Line 7 cycle 44
        // Raster Line
        .var raster_line = 7    
        // Line in the sprite
        .var sprite_line = 20
        // Current sprite ypos
        .var sprite_ypos = 7
        // Current sprite screen (graphics bank not important since sprite layout in the banks is identical)
        .var sprite_screen = SCREENS_1
        .var available_cycles = 0;
        .for(var i=0;i<293;i++) {
            // Line cycle count            
            .var line_cycles = 46
            .if(raster_line>=70 && raster_line<238) {
                // Only 2 sprites on these lines - so more cycles available
                .eval line_cycles = 58
            }            
            // Create 9th sprite by moving sprite 0
            .if(mod(raster_line,2)==0) {
                lda #$6f            
                sta $d000           
            } else {
                lda #$e7
                sta $d000
            }
            .eval line_cycles -= 6;
            lda #$8
            // Cycle 50. LSR abs is a 6 cycle RWM instruction.
            lsr VICII_CONTROL2  
            sta VICII_CONTROL2
            .eval line_cycles -= 12;
            .eval raster_line++
            .eval sprite_line++
            .if(sprite_line==21) {
                .eval sprite_line = 0
                .eval sprite_ypos += 21
            }
            // Set sprite single-color mode on splash
            .if(raster_line==53) {
                lda side_sprites_mc
                sta $d01c
                lda side_sprites_color
                sta $d027
                sta $d028
                .eval line_cycles -= 18
            }
            // Set sprite multi-color mode on splash
            .if(raster_line==248) {
                lda bottom_sprites_mc
                sta $d01c
                lda bottom_sprites_color
                sta $d027
                sta $d028
                .eval line_cycles -= 18
                //.print "raster:"+raster_line+" multi-color"
            }
            // Open top border
            .if(raster_line==55) {
                lda #VICII_RSEL|VICII_ECM|VICII_BMM|7
                sta VICII_CONTROL1
                .eval line_cycles -= 6
                //.print "raster:"+raster_line+" top border rsel=1"
            }
            // Open bottom border
            .if(raster_line==250) {
                lda #VICII_ECM|VICII_BMM|7 // DEN=0, RSEL=0
                sta VICII_CONTROL1
                .eval line_cycles -= 6
                //.print "raster:"+raster_line+" bottom border rsel=0"
            }
            // Move sprites down
            .if(sprite_line>=2 && sprite_line<=9) {
                .if(sprite_ypos<300) {
                    .var sprite_id = sprite_line-2
                    .if(sprite_id==0 || sprite_id==1 || sprite_ypos<=55 || sprite_ypos>=(246-21)) {
                        lda #sprite_ypos
                        sta SPRITES_YPOS+2*sprite_id
                        .eval line_cycles -= 6;
                        //.print "raster:"+raster_line+" sprite:"+sprite_id+" ypos:"+sprite_ypos
                    }
                }
            }
            // Change sprite data
            .if(sprite_line==20) {
                .eval sprite_screen += $400
                lda #sprite_screen/$40
                sta VICII_MEMORY
                .eval line_cycles -= 6
                //.print "raster:"+raster_line+" sprite data $"+toHexString(sprite_screen)
            }
            // Spend the rest of the cycles on NOPS
            .if(line_cycles<0 || line_cycles==1) .error "Too many cycles spent on line "+raster_line            
            .if(line_cycles>0) {
                //.print "raster:"+raster_line+"  cycles $"+toHexString(line_cycles)                
                RASTER_CYCLES(line_cycles)
                .eval line_cycles -= line_cycles
                .eval available_cycles += line_cycles
            }
        } 
        //.print "Available cycles: "+available_cycles

        lda #$6f            
        sta $d000   
        lda #$8
        // Cycle 50. LSR abs is a 6 cycle RWM instruction.
        lsr VICII_CONTROL2  
        sta VICII_CONTROL2
        RASTER_CYCLES(00) // End of raster code
    }
}};
