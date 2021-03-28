
// Renders the BOBs at the given positions
// The bob logic code will be merged with raster code using code-merger.c
// First restores the canvas from previously rendered bobs, and then renders the bobs at the given positions.
// BOBs are 16px*6px graphics  (2 x-columns * 6px) with masks and pixels
// Uses the bobs_xcol, bobs_yfine, bobs_bob_id and bob_restore for data about the bobs
// Implemented in inline kick assembler

char LOGIC_CODE_CRUNCHED[] = kickasm(uses bobs_xcol, uses bobs_yfine, uses bobs_bob_id, uses bobs_restore, uses RENDER_INDEX, uses RENDER_OFFSET_CANVAS_LO, uses RENDER_OFFSET_CANVAS_HI, uses RENDER_OFFSET_YPOS_INC, uses SIZE_BOB_RESTORE, uses BOB_ROW_SIZE, uses NUM_BOBS, uses left_render_index_xcol, uses left_canvas, uses left_ypos_inc_offset, uses rigt_render_index_xcol, uses rigt_canvas, uses rigt_ypos_inc_offset, uses BOB_MASK_LEFT, uses BOB_PIXEL_LEFT, uses BOB_MASK_RIGT, uses BOB_PIXEL_RIGT, uses canvas_base_hi, uses bobs_restore_base, uses RENDER_YPOS_INC, uses logic_tile_ptr, uses logic_tile_xcol, uses logic_tile_yfine, uses logic_tile_left_idx, uses logic_tile_right_idx ) {{
    .macro LOGIC_BEGIN(cycles) {
        .byte cycles
    }
    .macro LOGIC_END() {
        .byte $ff
    }
    .modify B2() {
        .pc = LOGIC_CODE_UNMERGED "LOGIC CODE UNMERGED"
        LOGIC_BEGIN(2)
        clc
        LOGIC_END()

        // ******************************************
        // Restores the canvas under the rendered bobs
        // ******************************************

        .for(var bob=NUM_BOBS-1;bob>=0; bob--) {
            //LOGIC_BEGIN(6)
            //inc $d021
            //LOGIC_END()

            LOGIC_BEGIN(3)
            ldx bobs_restore_base
            LOGIC_END()
            // char * volatile left_canvas = *((char**)&bob_restore[0]);
            LOGIC_BEGIN(7)
            lda bobs_restore+SIZE_BOB_RESTORE*bob+0,x
            sta.z left_canvas
            LOGIC_END()
            LOGIC_BEGIN(7)
            lda bobs_restore+SIZE_BOB_RESTORE*bob+1,x
            sta.z left_canvas+1            
            LOGIC_END()
            // char left_ypos_inc_offset = bob_restore[2];
            LOGIC_BEGIN(7)
            lda bobs_restore+SIZE_BOB_RESTORE*bob+2,x
            sta.z left_ypos_inc_offset            
            LOGIC_END()
            // char * volatile rigt_canvas = *((char**)&bob_restore[3]);
            LOGIC_BEGIN(7)
            lda bobs_restore+SIZE_BOB_RESTORE*bob+3,x
            sta.z rigt_canvas
            LOGIC_END()
            LOGIC_BEGIN(7)
            lda bobs_restore+SIZE_BOB_RESTORE*bob+4,x
            sta.z rigt_canvas+1
            LOGIC_END()
            // char rigt_ypos_inc_offset = bob_restore[5];
            LOGIC_BEGIN(7)
            lda bobs_restore+SIZE_BOB_RESTORE*bob+5,x
            sta.z rigt_ypos_inc_offset 
            LOGIC_END()

            // Restore Bob Rows 
            LOGIC_BEGIN(2)
            ldy #0
            LOGIC_END()
            .for(var row=0;row<6;row++) {
                //left_canvas += RENDER_YPOS_INC[left_ypos_inc_offset++];
                LOGIC_BEGIN(3)
                ldx.z left_ypos_inc_offset
                LOGIC_END()
                LOGIC_BEGIN(5)
                inc.z left_ypos_inc_offset
                LOGIC_END()
                LOGIC_BEGIN(18)
                lda RENDER_YPOS_INC,x
                adc.z left_canvas
                sta.z left_canvas
                lda.z left_canvas+1
                adc #0
                sta.z left_canvas+1
                LOGIC_END()
                //rigt_canvas += RENDER_YPOS_INC[rigt_ypos_inc_offset++];
                LOGIC_BEGIN(3)
                ldx.z rigt_ypos_inc_offset
                LOGIC_END()
                LOGIC_BEGIN(5)
                inc.z rigt_ypos_inc_offset
                LOGIC_END()
                LOGIC_BEGIN(18)
                lda RENDER_YPOS_INC,x
                adc.z rigt_canvas
                sta.z rigt_canvas
                lda.z rigt_canvas+1
                adc #0
                sta.z rigt_canvas+1
                LOGIC_END()

                LOGIC_BEGIN(3)
                ldx bobs_restore_base
                LOGIC_END()            
                // *left_canvas = bob_restore[6] ;
                LOGIC_BEGIN(10)
                lda bobs_restore+SIZE_BOB_RESTORE*bob+6+row,x
                sta (left_canvas),y 
                LOGIC_END()
                // *rigt_canvas = bob_restore[7];
                LOGIC_BEGIN(10)
                lda bobs_restore+SIZE_BOB_RESTORE*bob+12+row,x
                sta (rigt_canvas),y
                LOGIC_END()
            }
        }

        // ******************************************
        // Render two tiles on the canvas
        // ******************************************

        // y==0 from bob restore
        LOGIC_BEGIN(12)
        // char tile_left_idx = 4 * logic_tile_ptr[0];
        lda (logic_tile_ptr),y
        asl
        asl
        sta logic_tile_left_idx
        LOGIC_END()
        // char logic_tile_right_idx = 4 * logic_tile_ptr[1];
        LOGIC_BEGIN(2)
        iny
        LOGIC_END()
        LOGIC_BEGIN(12)
        lda (logic_tile_ptr),y
        asl
        asl
        sta logic_tile_right_idx
        LOGIC_END()    
        // char * render_index_xcol = (char*){ (>RENDER_INDEX) + xcol, ytile*2 };
        LOGIC_BEGIN(8)
        lda #>RENDER_INDEX
        adc logic_tile_xcol
        sta.z left_render_index_xcol+1
        LOGIC_END()
        LOGIC_BEGIN(6)
        lda logic_tile_yfine
        sta.z left_render_index_xcol
        LOGIC_END()

        // unsigned int canvas_offset = {render_index_xcol[RENDER_OFFSET_CANVAS_HI], render_index_xcol[RENDER_OFFSET_CANVAS_LO] };
        // char * left_canvas = canvas_base_hi*$100 + canvas_offset;
        LOGIC_BEGIN(2)
        ldy #RENDER_OFFSET_CANVAS_LO
        LOGIC_END()
        LOGIC_BEGIN(8)
        lda (left_render_index_xcol),y
        sta.z left_canvas
        LOGIC_END()
        LOGIC_BEGIN(2)
        ldy #RENDER_OFFSET_CANVAS_HI
        LOGIC_END()
        LOGIC_BEGIN(11)
        lda (left_render_index_xcol),y
        adc canvas_base_hi
        sta.z left_canvas+1
        LOGIC_END()
        // char left_ypos_inc_offset = render_index_xcol[RENDER_OFFSET_YPOS_INC];
        LOGIC_BEGIN(2)
        ldy #RENDER_OFFSET_YPOS_INC
        LOGIC_END()
        LOGIC_BEGIN(8)
        lda (left_render_index_xcol),y
        sta.z left_ypos_inc_offset            
        LOGIC_END()

        // Render Tile Rows 
        LOGIC_BEGIN(2)
        ldy #0                
        LOGIC_END()  
        .for(var row=0;row<4;row++) {

            //   *left_canvas = tile_left_pixels[y] | tile_right_pixels[y];
            LOGIC_BEGIN(3)
            ldx logic_tile_left_idx
            LOGIC_END()
            LOGIC_BEGIN(17)
            lda TILES_LEFT+row,x
            ldx logic_tile_right_idx
            ora TILES_RIGHT+row,x            
            sta (left_canvas),y
            LOGIC_END()

            //left_canvas += RENDER_YPOS_INC[left_ypos_inc_offset++];
            LOGIC_BEGIN(3)
            ldx.z left_ypos_inc_offset
            LOGIC_END()
            LOGIC_BEGIN(18)
            lda RENDER_YPOS_INC,x
            adc.z left_canvas
            sta.z left_canvas
            lda.z left_canvas+1
            adc #0
            sta.z left_canvas+1
            LOGIC_END()
            LOGIC_BEGIN(5)
            inc.z left_ypos_inc_offset
            LOGIC_END()
        }

        // ******************************************
        // Renders the BOBs at the given positions
        // ******************************************

        .for(var bob=0;bob<NUM_BOBS; bob++) {
            // char * left_render_index_xcol = (char*){ (>RENDER_INDEX) + xcol, yfine };
            // char * rigt_render_index_xcol = (char*){ (>RENDER_INDEX) + xcol+1, yfine };

            //LOGIC_BEGIN(6)
            //inc $d021
            //LOGIC_END()

            LOGIC_BEGIN(14)
            lda #>RENDER_INDEX
            adc bobs_xcol+bob
            sta.z left_render_index_xcol+1
            adc #1
            sta.z rigt_render_index_xcol+1
            LOGIC_END()

            LOGIC_BEGIN(10)
            lda bobs_yfine+bob
            sta.z left_render_index_xcol
            sta.z rigt_render_index_xcol
            LOGIC_END()

            // char * left_canvas = (char*){ left_render_index_xcol[85], left_render_index_xcol[0] };
            // bob_restore[0] = <left_canvas; bob_restore[1] = >left_canvas;
            // char * rigt_canvas = (char*){ rigt_render_index_xcol[85], rigt_render_index_xcol[0] };
            // bob_restore[3] = <rigt_canvas; bob_restore[4] = >rigt_canvas;
            LOGIC_BEGIN(3)
            ldx bobs_restore_base
            LOGIC_END()            
            LOGIC_BEGIN(2)
            ldy #RENDER_OFFSET_CANVAS_LO
            LOGIC_END()
            LOGIC_BEGIN(13)
            lda (left_render_index_xcol),y
            sta.z left_canvas
            sta bobs_restore+SIZE_BOB_RESTORE*bob+0,x
            LOGIC_END()
            LOGIC_BEGIN(13)
            lda (rigt_render_index_xcol),y
            sta.z rigt_canvas
            sta bobs_restore+SIZE_BOB_RESTORE*bob+3,x
            LOGIC_END()
            LOGIC_BEGIN(2)
            ldy #RENDER_OFFSET_CANVAS_HI
            LOGIC_END()
            LOGIC_BEGIN(16)
            lda (left_render_index_xcol),y
            adc canvas_base_hi
            sta.z left_canvas+1
            sta bobs_restore+SIZE_BOB_RESTORE*bob+1,x
            LOGIC_END()
            LOGIC_BEGIN(16)
            lda (rigt_render_index_xcol),y
            adc canvas_base_hi
            sta.z rigt_canvas+1
            sta bobs_restore+SIZE_BOB_RESTORE*bob+4,x
            LOGIC_END()

            // char left_ypos_inc_offset = left_render_index_xcol[170];
            // bob_restore[2] = left_ypos_inc_offset;
            // char rigt_ypos_inc_offset = rigt_render_index_xcol[170];
            // bob_restore[5] = rigt_ypos_inc_offset;            

            LOGIC_BEGIN(2)
            ldy #RENDER_OFFSET_YPOS_INC
            LOGIC_END()
            LOGIC_BEGIN(13)
            lda (left_render_index_xcol),y
            sta.z left_ypos_inc_offset            
            sta bobs_restore+SIZE_BOB_RESTORE*bob+2,x
            LOGIC_END()
            LOGIC_BEGIN(13)
            lda (rigt_render_index_xcol),y
            sta.z rigt_ypos_inc_offset            
            sta bobs_restore+SIZE_BOB_RESTORE*bob+5,x
            LOGIC_END()

            // Render Bob Rows 
            LOGIC_BEGIN(2)
            ldy #0                
            LOGIC_END()  
            .for(var row=0;row<6;row++) {

                //left_canvas += RENDER_YPOS_INC[left_ypos_inc_offset++];
                LOGIC_BEGIN(3)
                ldx.z left_ypos_inc_offset
                LOGIC_END()
                LOGIC_BEGIN(18)
                lda RENDER_YPOS_INC,x
                adc.z left_canvas
                sta.z left_canvas
                lda.z left_canvas+1
                adc #0
                sta.z left_canvas+1
                LOGIC_END()
                LOGIC_BEGIN(5)
                inc.z left_ypos_inc_offset
                LOGIC_END()
                //rigt_canvas += RENDER_YPOS_INC[rigt_ypos_inc_offset++];
                LOGIC_BEGIN(3)
                ldx.z rigt_ypos_inc_offset
                LOGIC_END()
                LOGIC_BEGIN(18)
                lda RENDER_YPOS_INC,x
                adc.z rigt_canvas
                sta.z rigt_canvas
                lda.z rigt_canvas+1
                adc #0
                sta.z rigt_canvas+1
                LOGIC_END()
                LOGIC_BEGIN(5)
                inc.z rigt_ypos_inc_offset
                LOGIC_END()

                // bob_restore[6] = *left_canvas;
                // *left_canvas = *left_canvas & BOB_MASK_LEFT_0[bob_id] | BOB_PIXEL_LEFT_0[bob_id];
                LOGIC_BEGIN(3)
                ldx bobs_restore_base
                LOGIC_END()            
                LOGIC_BEGIN(10)
                lda (left_canvas),y
                sta bobs_restore+SIZE_BOB_RESTORE*bob+6+row,x
                LOGIC_END()
                LOGIC_BEGIN(10)
                lda (rigt_canvas),y
                sta bobs_restore+SIZE_BOB_RESTORE*bob+12+row,x
                LOGIC_END()

                LOGIC_BEGIN(4)
                ldx bobs_bob_id+bob
                LOGIC_END()
                LOGIC_BEGIN(19)
                lda (left_canvas),y
                and BOB_MASK_LEFT+row*BOB_ROW_SIZE,x
                ora BOB_PIXEL_LEFT+row*BOB_ROW_SIZE,x
                sta (left_canvas),y
                LOGIC_END()
                // bob_restore[7] = *rigt_canvas;
                // *rigt_canvas = *rigt_canvas & BOB_MASK_RIGT_0[bob_id] | BOB_PIXEL_RIGT_0[bob_id];
                LOGIC_BEGIN(19)
                lda (rigt_canvas),y
                and BOB_MASK_RIGT+row*BOB_ROW_SIZE,x
                ora BOB_PIXEL_RIGT+row*BOB_ROW_SIZE,x
                sta (rigt_canvas),y
                LOGIC_END()
            }
        }
        //LOGIC_BEGIN(6)
        //lda #0
        //sta $d021
        //LOGIC_END()

        LOGIC_BEGIN(0) // end of logic code
    }
}};

