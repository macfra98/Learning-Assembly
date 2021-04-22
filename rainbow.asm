	processor 6502
	
	include "vcs.h"
	include "macro.h"

	seg code
	org $F000

Start:
	CLEAN_START	; macro to safely clean the TIA registers
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; start a new frame by turning on vblank and vsync
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
NextFrame:
	lda #2		; same as the binary value %00000010
	sta VBLANK
	sta VSYNC
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; generate the three lines of the sync
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
	sta WSYNC	; first scanline
	sta WSYNC	; second scanline
	sta WSYNC	; third scanline

	lda #0		; literal value of 0
	sta VSYNC	; turns off VSYNC
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; generate the 37 lines of the sync in a loop and output it!
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
	ldx #37		; loads the literal value of 37 into register X
LoopVBLANK:
	sta WSYNC	; scanline which will wait for syncronization to complete
	dex		; decrement(x) will drecrement register X (x--)
	bne LoopVBLANK	; unless the value of register X is equal to 00, keep looping.

	lda #0		; loads the literal value of 0 into register A
	sta VBLANK	; turns of the VBLANK
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; Draw 192 visible scanlines ( kernel )
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
	ldx #192	; loads the literal value of 192 into register X ( our counter )
LoopHBLANK:
	stx COLUBK	; set the background color
	sta WSYNC	; wait for the next scanline
	dex		; decrements the X-- ( register X )
	bne LoopHBLANK	; loops while X is not equal to 00

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; Output 30 more VBLANK lines ( overscan ) to complete our frame
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
	lda #2		; load the literal value of 2 into register A
	sta VBLANK 	; start VBLANK
	
	ldx #30		; load the literal value of 30 for 30 scanlines
LoopOScan:
	sta WSYNC	; wait for the next scanline
	dex		; decrement the value of x (x --)
	bne LoopOScan	; if x is not equal to 00, continue looping.

	jmp NextFrame;	; Jumps back to label NextFrame.
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; Complete my ROM size to 4kb
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
	org $FFFC
	.word Start
	.word Start 
