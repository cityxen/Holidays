
.var music = LoadSid("Hail_to_the_Chief.sid");

*=music.location "Music"
.fill music.size, music.getData(i)

.print ""
.print "SID Data"
.print "--------"
.print "location=$"+toHexString(music.location)
.print "init=$"+toHexString(music.init)
.print "play=$"+toHexString(music.play)
.print "songs="+music.songs
.print "startSong="+music.startSong
.print "size=$"+toHexString(music.size)
.print "name="+music.name
.print "author="+music.author
.print "copyright="+music.copyright
.print ""
.print "Additional tech data"
.print "--------------------"
.print "header="+music.header
.print "header version="+music.version
.print "flags="+toBinaryString(music.flags)
.print "speed="+toBinaryString(music.speed)
.print "startpage="+music.startpage
.print "pagelength="+music.pagelength

.const SCREEN_BOTTOM_LEFT  = $7C0
.const SCREEN_BOTTOM_RIGHT = $7E7
.const COLORS_BOTTOM_LEFT  = $DBC0

//////////////////////////////////////////////////////////
// START OF PROGRAM
*=$0801 "BASIC"
    BasicUpstart2($0810)
*=$0810 "Program"

start:

    lda #$00
    sta $d020
    sta $d021
    ldx #0
    ldy #0
    lda #00
    jsr music.init
    sei
    lda #<irq1
    sta $0314
    lda #>irq1
    sta $0315
    asl $d019
    lda #$7b
    sta $dc0d
    lda #$81
    sta $d01a
    lda #$1b
    sta $d011
    lda #$80
    sta $d012
    cli
    
wut:
    jmp wut


irq1:
    asl $d019
    jsr music.play
    pla
    tay
    pla
    tax
    pla
    rti    