;
; Lights.asm
;
; Created: 3/28/2019 1:41:45 PM
; Author : Roman Fedunyshyn
;


.macro outi
	ldi _temp3, @1
	.if @0 < 0x40
		out @0, _temp3
	.else
		sts @0, _temp3
	.endif
.endm


.def	_temp1		=r16
.def	_temp2		=r17
.def	_temp3		=r18

.def	_logic		=r0	
.def	_counter	=r20
.def	_counter2	=r22
.equ	const1 = 	125	
.equ	const2 =	0x7D		
		.CSEG 
		.org	0x000
		rjmp	reset
		.org 0x009
		rjmp TIMER1_COMPA
		reti
TIMER1_COMPA:
		sbrs	_logic, 0 
		rjmp	algo2_check
		cpi _counter, 0
		brne COUNTER_1
COUNTER_1:
		inc		_counter
		cpi		_counter, 1
		brne LED1_0
		ldi _temp2, (1<<7)
		out		PORTB, _temp2
LED1_0:
		cpi		_counter, 2
		brne LED2_0
		ldi _temp2, (1<<0)
		out		PORTB, _temp2
LED2_0:
		cpi		_counter, 3
		brne LED3_0
		ldi _temp2, (1<<6)
		out		PORTB, _temp2
LED3_0:
		cpi		_counter, 4
		brne LED4_0
		ldi _temp2, (1<<1)
		out		PORTB, _temp2
LED4_0:
		cpi		_counter, 5
		brne LED5_0
		ldi _temp2, (1<<5)
		out		PORTB, _temp2
LED5_0:
		cpi		_counter, 6
		brne LED6_0
		ldi _temp2, (1<<2)
		out		PORTB, _temp2
LED6_0:
		cpi		_counter, 7
		brne LED7_0
		ldi _temp2, (1<<4)
		out		PORTB, _temp2
LED7_0:
		cpi		_counter, 8
		brne END_ALGO1
		ldi _temp2, (1<<3)
		out		PORTB, _temp2
END_ALGO1:
		cpi		_counter, 9
		brne	algo2_check
		ldi _temp2, 0
		out		PORTB, _temp2
		clr		_counter
		clt 
		bld		_logic, 0
algo2_check:
		sbrs	_logic, 1
		rjmp	end_timer1
		inc		_counter2
		cpi		_counter2, 1
		brne LED1_1
		ldi _temp2, (1<<7)
		out		PORTD, _temp2
LED1_1:
		cpi		_counter2, 2
		brne LED2_1
		ldi _temp2, (1<<6)
		out		PORTD, _temp2
LED2_1:
		cpi		_counter2, 3
		brne LED3_1
		ldi _temp2, (1<<5)
		out		PORTD, _temp2
LED3_1:
		cpi		_counter2, 4
		brne LED4_1
		ldi _temp2, (1<<4)
		out		PORTD, _temp2
LED4_1:
		cpi		_counter2, 5
		brne LED5_1
		ldi _temp2, (1<<3)
		out		PORTD, _temp2
LED5_1:
		cpi		_counter2, 6
		brne LED6_1
		ldi _temp2, (1<<2)
		out		PORTD, _temp2
LED6_1:
		cpi		_counter2, 7
		brne LED7_1
		ldi _temp2, (1<<1)
		out		PORTD, _temp2
LED7_1:
		cpi		_counter2, 8
		brne END_ALGO2
		ldi _temp2, (1<<0)
		out		PORTD, _temp2
END_ALGO2:
		cpi		_counter2, 9
		brne	end_timer1
		ldi _temp2, 0
		out		PORTD, _temp2
		clr		_counter2
		clt
		bld		_logic, 1
end_timer1:
		reti
		
reset:		
		ldi		_temp1, Low(RAMEND)
		out		SPL, _temp1
		ldi		_temp1, High(RAMEND)
		out		SPH, _temp1

		ldi		r16, 0b10000000
		out		ACSR, r16

		ldi		_temp1, 0x00
		ldi		_temp2, 0xFF

		out		DDRA, _temp1
		out		PORTA, _temp2

		
		out		DDRB, _temp2
		out		PORTB, _temp1

		out		DDRD, _temp2
		out		PORTD, _temp1

		outi	TCCR1A, 0x00
		outi	TCCR1B, (1 << WGM12) | (1 << CS12) | (1 << CS10)
		outi	TIMSK1, (1 << OCIE1A)
		outi	OCR1AH, 0x15
		outi	OCR1AL, 0xF8
		
		sei 
main:		
		in r21, PINA
		sbrc r21, 0
		rjmp	elsePB0
		clr		_counter
		set
		bld		_logic, 0
		clt
		rjmp endPB
elsePB0:
		in r21, PINA
		sbrc r21, 1
		rjmp	endPB
		clr		_counter2
		set
		bld		_logic, 1
		clt
endPB:


		rjmp main

		.ESEG


