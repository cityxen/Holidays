//////////////////////////////////////////////////////////////////////////
// 1776 (Machine Language Version)
//
// Version: 1
// Author: Deadline
//
// 2019 CityXen
//
// As seen on our youtube channel:
// https://www.youtube.com/CityXen
//
// Assembly files are for use with KickAssembler
// http://theweb.dk/KickAssembler
//
// Notes: If you're going to attempt to compile this, you'll
// need the Macros and Constants from this repo:
// https://github.com/cityxen/Commodore64_Programming
//
// How To setup KickAssembler in Windows 10:
// https://www.youtube.com/watch?v=R9VE2U_p060
//
//////////////////////////////////////////////////////////////////////////

.segment Code []
.file [name="1776-ml.prg",segments="Code"]
.disk [filename="1776-ml.d64", name="1776-ML", id="CXN19" ] { [name="1776-ML", type="prg",  segments="Code"] }

*=$2ff0 "constants"
#import "../Commodore64_Programming/include/Constants.asm"
#import "../Commodore64_Programming/include/Macros.asm"

*=$3800 "screendata"
.import binary "usflag-2.prg"
.const screen_001 = $3802
.var status = $1000

//////////////////////////////////////////////////////////
// START OF PROGRAM
*=$0801 "BASIC"
    BasicUpstart($080d)
*=$080d "Program"

    lda #$ff    // Set all DATA Direction
    sta USER_PORT_DATA_DIR // on user port
    lda #$00    // Set all DATA Off
    eor #$ff              // Relay block is actually inverse of what is shown on screen
    sta USER_PORT_DATA    // Set Actual USER Port relays
    
    jsr draw_screen

    ldx #$00
    ldy #$00
st_text_0:
    lda status_table,x
    sta SCREEN_RAM,y
    lda #$01
    sta COLOR_RAM,y
    inx
    iny
    cpy #$05
    bne st_text_0

mainloop:
    jsr sub_read_joystick_2_fire
    cmp #$00
    beq mainloop

    lda status
    cmp #$00
    beq ml_turn_on
    ldx #$00
    lda #$00
    sta status
    eor #$ff              // Relay block is actually inverse of what is shown on screen
    sta USER_PORT_DATA    // Set Actual USER Port relays
    jmp ml_j_end
ml_turn_on:
    ldx #$05
    lda #$01
    sta status
    lda #$80
    eor #$ff              // Relay block is actually inverse of what is shown on screen
    sta USER_PORT_DATA    // Set Actual USER Port relays
ml_j_end:

    ldy #$00
st_text_1:
    lda status_table,x
    sta SCREEN_RAM,y
    lda #$01
    sta COLOR_RAM,y
    inx
    iny
    cpy #$05
    bne st_text_1 

    ldx #$00
counter_1:
    lda VIC_RASTER_COUNTER
    cmp #$f0
    bne counter_1
    inx
    cpx #$ff
    bne counter_1

    jmp mainloop
    rts

status_table:
.text "armed"
.text "fire!"

draw_screen:
    ////////////////////////////////////////////////
    // Draw the Petmate Screen... START
    lda screen_001
    sta BORDER_COLOR
    lda screen_001+1
    sta BACKGROUND_COLOR
    ldx #$00 // Draw the screen from memory location
dpms_loop:
    lda screen_001+2,x // Petmate screen (+2 is to skip over background/border color)
    sta 1024,x
    lda screen_001+2+256,x
    sta 1024+256,x
    lda screen_001+2+512,x
    sta 1024+512,x
    lda screen_001+2+512+256,x
    sta 1024+512+256,x
    lda screen_001+1000+2,x
    sta COLOR_RAM,x // And the colors
    lda screen_001+1000+2+256,x
    sta COLOR_RAM+256,x
    lda screen_001+1000+2+512,x
    sta COLOR_RAM+512,x
    lda screen_001+1000+2+512+256,x
    sta COLOR_RAM+512+256,x
    inx
    bne dpms_loop
    // Draw the Petmate Screen... END
    ////////////////////////////////////////////////
    rts

sub_read_joystick_2_fire:
	lda JOYSTICK_PORT_2
	lsr
	lsr
	lsr
	lsr
	lsr
	bcc read_joystick_2_fire
	lda #$00
	rts
read_joystick_2_fire:
	lda #$01
	rts