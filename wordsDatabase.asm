#include p18f87k22.inc
	
    global	random, fit
    extern	wordsList
    extern	counter2, counter	

;int_hi	code	0x0008 ; high vector, no low vector ;joe
;    btfss   INTCON,RBIE ; check that this is RBIF interrupt
;    retfie  FAST ; if not then return
;    ;incf    LATD ; increment PORTD
;    ;add code here to add one to counter and double it
;    bcf	    INTCON,RBIF ; clear interrupt flag
;    retfie  FAST ; fast return from interrupt
   
wdata	code
words	data	"FAMENOPEBEANFILEDEALCAKEMALE"
	constant words_l = .28

cwords	code

fit	;-- writes words to wordList
	lfsr	FSR0, wordsList	; Load FSR0 with address in RAM	
	movlw	upper(words)	; address of data in PM
	movwf	TBLPTRU		; load upper bits to TBLPTRU
	movlw	high(words)	; address of data in PM
	movwf	TBLPTRH		; load high byte to TBLPTRH
	movlw	low(words)	; address of data in PM
	movwf	TBLPTRL		; load low byte to TBLPTRL
	movlw	words_l	; bytes to read
	movwf 	counter		; our counter register
loop2 	tblrd*+			; one byte from PM to TABLAT, increment TBLPRT
	movff	TABLAT, POSTINC0; move data from TABLAT to (FSR0), inc FSR0	
	decfsz	counter		; count down to zero
	bra	loop2		; keep going until finished
	return
	;--
random
	bsf TRISB,TRISB5 ;sets RB5 as TRIS
	movf PORTB, W 
	nop
	bcf INTCON,RBIF ; clear RBIF 
	movlw	.7 ; intialises counter2 to number of words minus 1
	movwf	counter2
randomloop
	btfsc	INTCON, RBIF ; if RB5 pressed then runs next line, if not skips
	return
	DECFSZ	counter2, 1 ;decreases counter by 1 and skips next instruction if zero
	goto randomloop	
	
setcounter ;sets counter2 to 7
	movlw	.7
	movwf	counter2
 	goto	randomloop
	
	
	end	
	
	

	
