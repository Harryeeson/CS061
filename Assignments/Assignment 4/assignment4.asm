;=========================================================================
; Name & Email must be EXACTLY as in Gradescope roster!
; Name: Harrison Yee
; Email: hyee002@ucr.edu
; 
; Assignment name: Assignment 4
; Lab section: 029
; TA: Robert Colvin
; 
; I hereby certify that I have not received assistance on this assignment,
; or used code, from ANY outside source other than the instruction team
; (apart from what was provided in the starter file).
;
;=================================================================================
;THE BINARY REPRESENTATION OF THE USER-ENTERED DECIMAL NUMBER MUST BE STORED IN R5
;=================================================================================

					.ORIG x3000		
;-------------
;Instructions
;-------------
RESTART

; output intro prompt
	LD R0, introPromptPtr
	PUTS						
; Set up flags, counters, accumulators as needed
	AND R1, R1, #0
	AND R2, R2, #0
	AND R3, R3, #0
	AND R4, R4, #0
	AND R5, R5, #0
	AND R6, R6, #0
	LD R1, counter
; Get first character, test for '\n', '+', '-', digit/non-digit 	
	INPUT_LOOP					
					; is very first character = '\n'? if so, just quit (no message)!
	GETC
	OUT
	ADD R2, R0, #0
	LD R3, newlineCheck
	ADD R4, R2, R3
	BRz CHECK_NEG
					; is it = '+'? if so, ignore it, go get digits
	LD R3, posCheck
	ADD R4, R2, R3
	BRz FLAG_POS
					; is it = '-'? if so, set neg flag, go get digits
	LD R3, negCheck
	ADD R4, R2, R3
	BRz FLAG_NEG
					; is it < '0'? if so, it is not a digit	- o/p error message, start over
	LD R3, belowZeroCheck
	ADD R4, R2, R3
	BRn OUTPUT_ERROR
					; is it > '9'? if so, it is not a digit	- o/p error message, start over
	LD R3, aboveNineCheck
	ADD R4, R2, R3
	BRp OUTPUT_ERROR
					; if none of the above, first character is first numeric digit - deal with it!
	ADD R4, R1, #-6
	BRz FIRST_NUMERIC_DIGIT
	BRn BUILD_UP_NUM

	FIRST_NUMERIC_DIGIT
		LD R3, convert
		ADD R5, R2, R3
		ADD R1, R1, #-2
		BRnzp INPUT_LOOP
; Now get (remaining) digits (max 5) from user and build up number in accumulator
	BUILD_UP_NUM
		ADD R5, R5, R5
		ADD R7, R5, R5
		ADD R7, R7, R7
		ADD R5, R5, R7
		LD R3, convert
		ADD R4, R0, R3
		ADD R5, R5, R4
		ADD R1, R1, #-1
		BRp INPUT_LOOP
		ADD R1, R1, #0
		BRnz CHECK_NEG

	CHECK_NEG
		ADD R4, R1, #-5
		BRz OUTPUT_ERROR
		ADD R6, R6, #-1
		BRz TWOS_COMPLEMENT
		BRnzp END_PROGRAM

	TWOS_COMPLEMENT
		NOT R5, R5
		ADD R5, R5, #1
		BRnzp END_PROGRAM

	FLAG_POS
		ADD R4, R1, #-6
		BRn OUTPUT_ERROR
		ADD R1, R1, #-1
		BRnzp INPUT_LOOP
	
	FLAG_NEG
		ADD R4, R1, #-6
		BRn OUTPUT_ERROR
		ADD R6, R6, #1
		ADD R1, R1, #-1
		BRnzp INPUT_LOOP
	
	OUTPUT_ERROR
		LD R0, newline
		OUT
		LD R0, errorMessagePtr
		PUTS
		BRnzp RESTART
		
					; remember to end with a newline!
	END_PROGRAM
		LD R0, newline
		OUT
					HALT

;---------------	
; Program Data
;---------------

introPromptPtr		.FILL x3A00
errorMessagePtr		.FILL x3B00
counter				.FILL #6
newlineCheck		.FILL #-10
posCheck			.FILL #-43
negCheck			.FILL #-45
belowZeroCheck		.FILL #-48
aboveNineCheck		.FILL #-57
convert				.FILL #-48
newline				.FILL '\n'

;------------
; Remote data
;------------
					.ORIG x3A00			; intro prompt
     				.STRINGZ	"Input a positive or negative decimal number (max 5 digits), followed by ENTER\n"
					
					
					.ORIG x3B00			; error message
					.STRINGZ	"ERROR: invalid input\n"

;---------------
; END of PROGRAM
;---------------
					.END

;-------------------
; PURPOSE of PROGRAM
;-------------------
; Convert a sequence of up to 5 user-entered ascii numeric digits into a 16-bit two's complement binary representation of the number.
; if the input sequence is less than 5 digits, it will be user-terminated with a newline (ENTER).
; Otherwise, the program will emit its own newline after 5 input digits.
; The program must also output a final newline.
; Input validation is performed on the individual characters as they are input, but not on the magnitude of the number.