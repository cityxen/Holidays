//////////////////////////////////////////////////////////////////////////
// Vegetable Soup
//
// Version: 1
// Author: Deadline
//
// CityXen 2020

*=$0801 "BASIC UPSTART"
    BasicUpstart($080d)
*=$080d "Program"

    lda #$93
    jsr $ffd2 // Clear Screen

    ldx #$00
start:
    lda vegsoupmessage,x
    beq exitloop
    sta $0400,x
    inx
    jmp start
exitloop:
    jmp exitloop

vegsoupmessage:
.text "deadline's soup is the best!"
.byte 0
