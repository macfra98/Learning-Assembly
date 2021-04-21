	processor 6502 	; target will be the processer 6502

	seg code 	; tells the program we are going to start a segment of code here
	org $F000 	; $F000 is the start of our code origin.
	
Start:			; this is a label. Labels will be alias to memory addresses. Start: is the same as ($F000). So we could jump back to Start which is $F000 in memory.
	sei		; Disable interrupts
	cld		; Disable the binary code decimal math mode
	ldx #$FF	; Loading the x register with literal value of #$FF
	txs		; Transfer the x register to the (s)tack pointer.
	
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; Clear the Page Zero region ($00 to $FF)
; Meaning the entire RAM and also the entire TIA registers
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

	lda #0		; A = 0
	ldx #$FF	; X = #$FF
MemLoop:
	sta $0,X	; $0 + whatever is inside X (store the value of A inside memory address $0 + X
	dex		; X-- (decrements)
	bne MemLoop	; if branch (x) is not equal to 0, then go back to loop and continue decrementing.
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; Fill the ROM size to exactly 4KB
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
	org $FFFC
	.word Start	; Reset vector at $FFFC (where the program starts) {2bytes}
	.word Start	; Interrupt vector at $FFFE (unused in the VCS) {2bytes}
