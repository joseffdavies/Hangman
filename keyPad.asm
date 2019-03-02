
#include p18f87k22.inc
	global	pad_read, pad_setup, column
	extern	lcdlp2

acs0    udata_acs   ; named variables in access ram
column  res 1 ;location to store column 
row	res 1 ;location to store row
   
pad	code

table
	banksel 0x200
	movlw	"A"
	movwf	0x11, BANKED
	
	movlw	"B"
	movwf	0x12, BANKED
	
	movlw	"C"
	movwf	0x14, BANKED
	
	movlw	"D"
	movwf	0x18, BANKED
	
	movlw	"E"
	movwf	0x21, BANKED
	
	movlw	"F"
	movwf	0x22, BANKED
	
	movlw	"G"
	movwf	0x24, BANKED
	
	movlw	"H"
	movwf	0x28, BANKED
	
	movlw	"I"
	movwf	0x41, BANKED
	
	movlw	"J"
	movwf	0x42, BANKED
	
	movlw	"K"
	movwf	0x44, BANKED
	
	movlw	"L"
	movwf	0x48, BANKED
	
	movlw	"M"
	movwf	0x81, BANKED
	
	movlw	"N"
	movwf	0x82, BANKED
	
	movlw	"O"
	movwf	0x84, BANKED
	
	movlw	"P"
	movwf	0x88, BANKED
	return
	
	;keep inputting letters and their addresses into table??
	
pad_setup
	banksel .15 ;found this 15 using the data sheet, to find which 'file register' it is in?
	bsf	PADCFG1,REPU,BANKED
	clrf	LATE
	call	table
	return

pad_read
	movlw	0x00
	movwf	column
	
	;FB73
	movlw	0x0F ;sets columns as inputs (0-3)
	movwf	TRISE, ACCESS
	nop
	nop
	;movlw   .1 ;delay
	;call	lcdlp2 ;delay
	movlw	0xFF
	movwf	PORTE

	movlw   .1 ;delay
	call	lcdlp2 ;delay
	
	movff	PORTE, column
	
	movlw	0xF0
	CPFSEQ	column
	goto	readrow
	movlw	0x00
	movwf	column
	return
	
	;CDEF
readrow	
	movlw	0xF0 ;sets rows as inputs
	movwf	TRISE, ACCESS
	nop
	nop
	;movlw   .1 ;delay
	;call	lcdlp2 ;delay
	movlw	0xFF
	movwf	PORTE
	movlw   .1
	call	lcdlp2
	movff	PORTE, row 
	
	movlw	0x0F
	CPFSEQ	row
	goto	andcolrow
	movlw	0x00
	movwf	column
	return
	;movf	column, w
	;andwf	row,w
	;movwf	FSR2L
	;movlw	.2
	;movwf	FSR2H
andcolrow	
	movf	row, w
	ANDWF	column, 1, 0 ;puts in column location
	nop
	movf	column, w
	lfsr	FSR1, 0x200
	movf	PLUSW1, w
	
	
	;have changed every port H to port E
	
	return

    end
