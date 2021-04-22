	Processor 6502

	include "vcs.h"
	include "macro.h"

	seg code
	org $F000	; defines the origin of the ROM at $F000

START: 			; acts as a start label, whereas our code starts.
	//CLEAN_START	; this is an macfro from macro.h which safely clears the memory registers for us.
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; Set background luminosity color to yellow
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

	lda #$82	; Load color palette into register A ($82 is DARK-BLUE)
	sta COLUBK	; After loading we'll have to store the value. ( store a to backgroundcolor Address $09)
	jmp START	; Repeat fraom START
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; Fill ROM size to exactly 4kb
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
	org $FFFC	; Defines origin to $FFFC
	.word START	; Reset vector at $FFFC ( where the program starts )
	.word START	; Interrupt vector at $FFFE (unused)
