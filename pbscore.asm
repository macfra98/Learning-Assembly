	processor 6502

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; Include required files with definitions and macros
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
	include "vcs.h"
	include "macro.h"

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; Start our ROM code
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

	seg
	org $f000

Reset:
	CLEAN_START		; cleans the memory and TIA

	ldx #$80		; load literal value at address $80
	stx COLUBK		; blue background

	lda #%1111		; white playfield
	ldx COLUPF

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; We set the TIA registers for the colors of P0 and P1
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
	lda #$48		; player 0 color light red
	sta COLUP0

	lda #$C6		; player 1 color light green
	sta COLUP1

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; Start a new frame by configuring VBLANK and VSYNC
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
StartFrame:
	lda #2
	sta VBLANK		; turn VBLANK on
	sta VSYNC		; turn VSYNC on
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; LOAD ME THREE
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
	ldx #3			; set value 3 in x register
LoopMeThree:
	sta WSYNC		; three times VSYNC
	dex
	bne LoopMeThree

	lda #0
	sta VSYNC		;; turn VSYNC off

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; Let the TIA output the 37 recommended lines of VBLANK
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
	ldx #37			; set the value of register X to 37
LoopMeThirtySeven:
	sta WSYNC		; render me 37 times
	dex
	bne LoopMeThirtySeven

	lda #0
	sta VBLANK		; turn vBlank off :(

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; Draw the 192 visible scanlines ( playerfield? )
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
	ldx #10
LoopMeTen:
	sta WSYNC		; draw me ten times
	dex
	bne LoopMeTen

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; Displays 10 scanlines for the scoreboard number
;; Pulls data ffrom an array of bytes defined at NumberBitmap
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
	ldy #0
ScoreboardLoop:
	lda NumberBitmap,Y
	sta PF1
	sta WSYNC
	iny
	cpy #10

	lda #0
	sta PF1 		; disable playfield.

	; Draw 50 empty scanlines between scoreboard and player?

	ldx #50
LoopMeFifty:
	sta WSYNC		; draw me 50 times
	dex
	bne LoopMeFifty

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; Display 10 scanlines for the player 0 graphics
;; Pulls data from an array of bytes defined at PlayerBitmap
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
	ldy #0
Player0Loop:
	lda PlayerBitmap,y
	sta GRP0
	sta WSYNC
	iny
	cpy #10
	bne Player0Loop

	lda #0
	sta GRP1		; disable player 1 graphics

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; Draw the remaining 102 scanlines (192.90), since we already
;; Used 10+10+50+10+10=80 scanlines in the current frame.
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
	ldx #102
DrawMeHundredAndTwo:
	sta WSYNC
	dex
	bne DrawMeHundredAndTwo
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; Output 30 more VBLANK overscan lines to complete our frame
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
	ldx #30
DrawMeThirtyAgain:
	sta WSYNC
	dex
	bne DrawMeThirtyAgain

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; Loop to the next frame
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
	jmp StartFrame

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; Defines an array of bytes to draw the scoreboard number.
;, We add these bytes in the last ROM addresses
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
	org $FFE8
PlayerBitmap:
	.byte #%01111110	;   ######
	.byte #%11111111	;  ########
	.byte #%10011001	;  #  ##  #
	.byte #%11111111	;  ########
	.byte #%11111111	;  ########
	.byte #%11111111	;  ########
	.byte #%10111101	;  # #### #
	.byte #%11000011	;  ##    ##
	.byte #%11111111	;  ########
	.byte #%01111110	;   ######

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; Define an array of bytes to draw the scoreboard number.
;; We add these bytes in the final ROM addresses.
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
	org $FFF2
NumberBitmap:
	.byte #%00001110	; ########
	.byte #%00001110	; ########
	.byte #%00000010	;      ###
	.byte #%00000010	;      ###
	.byte #%00001110	; ########
	.byte #%00001110	; ########
	.byte #%00001000	; ###
	.byte #%00001000	; ###
	.byte #%00001110	; ########
	.byte #%00001110	; ########


;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; Complete ROM size
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
	org $FFFC
	.word Reset
	.word Reset
