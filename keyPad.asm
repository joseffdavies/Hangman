
#include p18f87k22.inc
	global	pad_read, pad_setup, column
	extern	lcdlp2

acs0    udata_acs   ; named variables in access ram
column  res 1 ;location to store column 
row	res 1 ;location to store row
   
pad	code

table ; puts letters in bank 2 in the locations which correspond to the hex value produced by button press
	banksel 0x200 ;bank 2
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
	
pad_setup 
	banksel .15
	bsf	PADCFG1,REPU,BANKED
	clrf	LATE
	call	table
	return

pad_read
	;-- intilaises column and row
	movlw	0x00
	movwf	column
	movwf	row
	;--
	
	;--finds which column has been pressed
	movlw	0x0F ;sets columns as inputs (0-3)
	movwf	TRISE, ACCESS
	nop
	nop
	movlw	0xFF ;turns all pins on 
	movwf	PORTE
	movlw   .1 ;delay
	call	lcdlp2 ;delay
	movff	PORTE, column ;reads from keypad and moves to column
	;--
	;checks is column is 0xF0 i.e. no button press has been read, if this is the case make column 0x00 (so that will loop around pad again) otherwise read row
	movlw	0xF0
	CPFSEQ	column
	goto	readrow
	movlw	0x00
	movwf	column
	return
	
	;equivalent for row:
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
andcolrow ; column AND row and puts in column -> column now corresponds to the bank 2 locations	
	movf	row, w
	ANDWF	column, 1, 0 ;puts in column location
	nop
	movf	column, w
	lfsr	FSR1, 0x200
	movf	PLUSW1, w
	return

    end
