;=========================================================================
; Name & Email must be EXACTLY as in Gradescope roster!
; Name: Harrison Yee
; Email: hyee002@ucr.edu
; 
; Assignment name: Assignment 5
; Lab section: 029
; TA: Robert Colvin
; 
; I hereby certify that I have not received assistance on this assignment,
; or used code, from ANY outside source other than the instruction team
; (apart from what was provided in the starter file).
;
;=========================================================================

.ORIG x3000			; Program begins here
;-------------
;Instructions
;-------------
;-------------------------------
;INSERT CODE STARTING FROM HERE
;--------------------------------
MENU_LOOP
	LD R3, SUB_MENU
	JSRR R3
	
	ADD R1, R1, #-1				
	BRz	CHOICE_ONE					;if zero choice 1
	ADD R1, R1, #-1
	BRz	CHOICE_TWO					;if zero choice 2
	ADD R1, R1, #-1
	BRz	CHOICE_THREE				;if zero choice 3
	ADD R1, R1, #-1
	BRz	CHOICE_FOUR					;if zero choice 4
	ADD R1, R1, #-1
	BRz	CHOICE_FIVE			    	;if zero choice 5
	ADD R1, R1, #-1
	BRz	CHOICE_SIX					;if zero choice 6
	ADD R1, R1, #-1 
	BRz QUIT						;if zero choice 7

CHOICE_ONE
	LD R3, SUB_ALL_BUSY
	JSRR R3							;R2 1 all busy 0 free
	LD R3, convto_3000
	ADD R4, R2, R3
	ADD R4, R4, #-1
	BRz ALL_BUSY
	BRnzp NOT_ALL_BUSY
	
ALL_BUSY
	LEA R0, ALLBUSY
	PUTS
	BRnzp MENU_LOOP

NOT_ALL_BUSY
	LEA R0, ALLNOTBUSY
	PUTS
	BRnzp MENU_LOOP
	
CHOICE_TWO
	LD R3, SUB_ALL_FREE
	JSRR R3							;R2 1 all free 0 busy
	LD R3, convto_3000
	ADD R4, R2, R3
	ADD R4, R4, #-1
	BRz ALL_FREE
	BRnzp NOT_ALL_FREE
	
ALL_FREE
	LEA R0, FREE
	PUTS
	BRnzp MENU_LOOP
	
NOT_ALL_FREE
	LEA R0, NOTFREE
	PUTS
	BRnzp MENU_LOOP

CHOICE_THREE
	LD R3, SUB_NUM_BUSY
	JSRR R3								;R2 num of busy machines
	LEA R0, BUSYMACHINE1
	PUTS
	LD R3, SUB_PRINT
	JSRR R3													
	LEA R0, BUSYMACHINE2
	PUTS
	BRnzp MENU_LOOP
	
CHOICE_FOUR
	LD R3, SUB_NUM_FREE
	JSRR R3								;R2 num of free machines
	LEA R0, FREEMACHINE1
	PUTS
	LD R3, SUB_PRINT
	JSRR R3
	LEA R0, FREEMACHINE2
	PUTS
	BRnzp MENU_LOOP
	
CHOICE_FIVE
	LD R3, SUB_GET_INPUT
	JSRR R3								;R1 value of input
	LD R3, SUB_STATUS					
	JSRR R3								;R2 1 is free 0 is busy
	LEA R0, STATUS1
	PUTS
	ADD R4, R2, #0
	ADD R2, R1, #0
	LD R3, SUB_PRINT
	JSRR R3
	LD R3, convto_3000
	ADD R4, R4, R3
	ADD R4, R4, #-1
	BRz STATUS_FREE
	BRnzp STATUS_BUSY
	
STATUS_FREE
	LEA R0, STATUS3
	PUTS
	BRnzp MENU_LOOP

STATUS_BUSY
	LEA R0, STATUS2
	PUTS
	BRnzp MENU_LOOP

CHOICE_SIX
	LD R3, SUB_ALL_BUSY
	JSRR R3							;R2 1 all busy 0 free
	LD R3, convto_3000
	ADD R3, R2, R3
	ADD R3, R3, #-1
	BRz NO_FREE
	BRnzp SOME_FREE 
	
NO_FREE
	LD R0, firstFree2Ptr
	PUTS
	BRnzp MENU_LOOP
	
SOME_FREE
	LEA R0, FIRSTFREE1
	PUTS
	LD R3, SUB_FIRST_FREE
	JSRR R3
	LD R3, SUB_PRINT
	JSRR R3
	LD R0, newlinePtr
	PUTS
	BRnzp MENU_LOOP
	
QUIT
	LEA R0, Goodbye
	PUTS
HALT
;---------------	
;Data
;---------------
;Add address for subroutines
SUB_MENU			.FILL x3200
SUB_ALL_BUSY		.FILL x3400
SUB_ALL_FREE		.FILL x3600
SUB_NUM_BUSY		.FILL x3800
SUB_NUM_FREE		.FILL x4000
SUB_STATUS			.FILL x4200
SUB_FIRST_FREE		.FILL x4400
SUB_GET_INPUT		.FILL x4600
SUB_PRINT			.FILL x4800
;Other data 
newlinePtr			.FILL x3171
firstFree2Ptr		.FILL x315B
convto_3000			.FILL #-48
;Strings for options
Goodbye         .STRINGZ "Goodbye!\n"
ALLNOTBUSY      .STRINGZ "Not all machines are busy\n"
ALLBUSY         .STRINGZ "All machines are busy\n"
FREE            .STRINGZ "All machines are free\n"
NOTFREE		    .STRINGZ "Not all machines are free\n"
BUSYMACHINE1    .STRINGZ "There are "
BUSYMACHINE2    .STRINGZ " busy machines\n"
FREEMACHINE1    .STRINGZ "There are "
FREEMACHINE2    .STRINGZ " free machines\n"
STATUS1         .STRINGZ "Machine "
STATUS2		    .STRINGZ " is busy\n"
STATUS3		    .STRINGZ " is free\n"
FIRSTFREE1      .STRINGZ "The first available machine is number "
FIRSTFREE2      .STRINGZ "No machines are free\n"
NEWLINE         .FILL '\n'


;-----------------------------------------------------------------------------------------------------------------
; Subroutine: MENU
; Inputs: None
; Postcondition: The subroutine has printed out a menu with numerical options, allowed the
;                          user to select an option, and returned the selected option.
; Return Value (R1): The option selected:  #1, #2, #3, #4, #5, #6 or #7
; no other return value is possible
;-----------------------------------------------------------------------------------------------------------------
;-------------------------------
;INSERT CODE For Subroutine MENU
;--------------------------------
.ORIG x3200
;HINT back up 
ST R7, BACKUP_R7_3200

MENU_3200	
	LD R0, Menu_string_addr			;Output menu
	PUTS	
	GETC
	OUT
	ADD R3, R0, #0					;temp hold for option
	LD R0, newline_3200
	OUT
	LD R4, below_one				;check below one
	ADD R4, R3, R4
	BRn ERROR_3200
	LD R4, above_seven				;check above seven
	ADD R4, R3, R4
	BRp ERROR_3200
	BRnzp END_3200

ERROR_3200
	LEA R0, Error_msg_1
	PUTS
	BRnzp MENU_3200

;HINT Restore
END_3200
	LD R4, convto_3200				;convert to ascii
	ADD R1, R3, R4
	LD R7, BACKUP_R7_3200

ret
;--------------------------------
;Data for subroutine MENU
;--------------------------------
Error_msg_1	      .STRINGZ "INVALID INPUT\n"
Menu_string_addr  .FILL x6000
BACKUP_R7_3200    .BLKW #1
below_one	      .FILL #-49
above_seven		  .FILL #-55
newline_3200	  .STRINGZ "\n"
convto_3200		  .FILL #-48

;-----------------------------------------------------------------------------------------------------------------
; Subroutine: ALL_MACHINES_BUSY
; Inputs: None
; Postcondition: The subroutine has returned a value indicating whether all machines are busy
; Return value (R2): 1 if all machines are busy,    0 otherwise
;-----------------------------------------------------------------------------------------------------------------
;-------------------------------
;INSERT CODE For Subroutine ALL_MACHINES_BUSY
;--------------------------------
.ORIG x3400
;HINT back up
ST R7, BACKUP_R7_3400
ST R1, BACKUP_R1_3400

LD R4, counter_3400
LD R2, one_3400
LD R1, BUSYNESS_ADDR_ALL_MACHINES_BUSY					;xCE00 into R1
LDR R3, R1, #0											;xABCD into R3
ADD R3, R3, #0			
BRn	FREE_3400											;if all 0 then all busy
ADD R4, R4, #-1	
BRnzp LOOP_3400

LOOP_3400
	ADD R3, R3, R3
	BRn FREE_3400
	ADD R4, R4, #-1
	BRz END_3400
	BRnzp LOOP_3400
	
FREE_3400
	ADD R2, R2, #-1										;R2 set to all free, add 1 to be all busy

;HINT Restore
END_3400
	LD R7, BACKUP_R7_3400
	LD R1, BACKUP_R1_3400

ret
;--------------------------------
;Data for subroutine ALL_MACHINES_BUSY
;--------------------------------
BUSYNESS_ADDR_ALL_MACHINES_BUSY .Fill xCE00
BACKUP_R7_3400					.BLKW #1
BACKUP_R1_3400					.BLKW #1
one_3400						.FILL #49
counter_3400					.FILL #16

;-----------------------------------------------------------------------------------------------------------------
; Subroutine: ALL_MACHINES_FREE
; Inputs: None
; Postcondition: The subroutine has returned a value indicating whether all machines are free
; Return value (R2): 1 if all machines are free,    0 otherwise
;-----------------------------------------------------------------------------------------------------------------
;-------------------------------
;INSERT CODE For Subroutine ALL_MACHINES_FREE
;--------------------------------
.ORIG x3600
;HINT back up 
ST R7, BACKUP_R7_3600
ST R1, BACKUP_R1_3600

LD R4, counter_3600
LD R2, one_3600
LD R1, BUSYNESS_ADDR_ALL_MACHINES_FREE					;xCE00 into R1
LDR R3, R1, #0											;xABCD into R3
ADD R3, R3, #0			
BRz	BUSY_3600											;if all 0 then all busy	
ADD R4, R4, #-1
BRnzp LOOP_3600

LOOP_3600
	ADD R3, R3, R3										;left shift
	BRzp BUSY_3600
	ADD R4, R4, #-1
	BRz END_3600
	BRnzp LOOP_3600

BUSY_3600
	ADD R2, R2, #-1										;R2 set to 1 for all free, if busy -1 to get 0

;HINT Restore
END_3600
	LD R7, BACKUP_R7_3600
	LD R1, BACKUP_R7_3600
	
ret
;--------------------------------
;Data for subroutine ALL_MACHINES_FREE
;--------------------------------
BUSYNESS_ADDR_ALL_MACHINES_FREE .Fill xCE00
BACKUP_R7_3600					.BLKW #1
BACKUP_R1_3600					.BLKW #1
one_3600						.FILL #49
counter_3600					.FILL #16

;-----------------------------------------------------------------------------------------------------------------
; Subroutine: NUM_BUSY_MACHINES
; Inputs: None
; Postcondition: The subroutine has returned the number of busy machines.
; Return Value (R2): The number of machines that are busy
;-----------------------------------------------------------------------------------------------------------------
;-------------------------------
;INSERT CODE For Subroutine NUM_BUSY_MACHINES
;--------------------------------
.ORIG x3800
;HINT back up 
ST R7, BACKUP_R7_3800

LD R2, zero_3800
LD R1, BUSYNESS_ADDR_NUM_BUSY_MACHINES
LDR R3, R1, #0
LD R4, counter_3800									;16 for 16 bits
ADD R3, R3, #0
BRn IS_FREE_3800									;1 is negative
ADD R4, R4, #-1

COUNT_FREE_3800
	ADD R3, R3, R3									;left shift
	BRn IS_FREE_3800
	ADD R4, R4, #-1							
	BRz COUNT_BUSY									
	BRnzp COUNT_FREE_3800

IS_FREE_3800
	ADD R2, R2, #1									;increment num of free
	ADD R4, R4, #-1
	BRz COUNT_BUSY
	BRnzp COUNT_FREE_3800

COUNT_BUSY
	NOT R2, R2
	ADD R2, R2, #1			
	LD R4, counter_3800
	ADD R2, R4, R2									; 16 - num free = num busy
	LD R4, convto_3800
	ADD R2, R2, R4						
	
;HINT Restore
END_3800
	LD R7, BACKUP_R7_3800

ret
;--------------------------------
;Data for subroutine NUM_BUSY_MACHINES
;--------------------------------
BUSYNESS_ADDR_NUM_BUSY_MACHINES .Fill xCE00
BACKUP_R7_3800					.BLKW #1
counter_3800					.FILL #16
zero_3800						.FILL #48
convto_3800						.FILL #48
;-----------------------------------------------------------------------------------------------------------------
; Subroutine: NUM_FREE_MACHINES
; Inputs: None
; Postcondition: The subroutine has returned the number of free machines
; Return Value (R2): The number of machines that are free 
;-----------------------------------------------------------------------------------------------------------------
;-------------------------------
;INSERT CODE For Subroutine NUM_FREE_MACHINES
;--------------------------------
.ORIG x4000
;HINT back up 
ST R7, BACKUP_R7_4000

LD R2, zero_4000
LD R1, BUSYNESS_ADDR_NUM_FREE_MACHINES
LDR R3, R1, #0
LD R4, counter_4000									;16 for 16 bits
ADD R3, R3, #0
BRn IS_FREE_4000									;1 is negative
ADD R4, R4, #-1

COUNT_FREE_4000
	ADD R3, R3, R3									;left shift
	BRn IS_FREE_4000
	ADD R4, R4, #-1							
	BRz END_4000									
	BRnzp COUNT_FREE_4000

IS_FREE_4000
	ADD R2, R2, #1									;increment num of free
	ADD R4, R4, #-1
	BRz END_4000
	BRnzp COUNT_FREE_4000

;HINT Restore
END_4000
	LD R4, convto_4000
	ADD R2, R2, R4
	LD R7, BACKUP_R7_4000

ret
;--------------------------------
;Data for subroutine NUM_FREE_MACHINES
;--------------------------------
BUSYNESS_ADDR_NUM_FREE_MACHINES .Fill xCE00
BACKUP_R7_4000					.BLKW #1
zero_4000						.FILL #48
counter_4000					.FILL #16
convto_4000						.FILL #-48

;-----------------------------------------------------------------------------------------------------------------
; Subroutine: MACHINE_STATUS
; Input (R1): Which machine to check
; Postcondition: The subroutine has returned a value indicating whether the machine indicated
;                          by (R1) is busy or not.
; Return Value (R2): 0 if machine (R1) is busy, 1 if it is free
;-----------------------------------------------------------------------------------------------------------------
;-------------------------------
;INSERT CODE For Subroutine MACHINE_STATUS
;--------------------------------
.ORIG x4200
;HINT back up 
ST R7, BACKUP_R7_4200

LD R4, BUSYNESS_ADDR_MACHINE_STATUS
LDR R3, R4, #0
LD R2, zero_4200
NOT R5, R1						;2s complement of R1 to R5
ADD R5, R5, #1
LD R6, fifteen_4200
ADD R5, R6, R5					;15 - machine num to get loop counter
BRz	CHECK_STATUS				;if is 15 go to check

LOOP_4200
	ADD R3, R3, R3				;left shift
	ADD R5, R5, #-1				;decrement counter
	BRz CHECK_STATUS
	BRnzp LOOP_4200
	
CHECK_STATUS
	ADD R3, R3, #0
	BRn IS_FREE_4200			;if bit is 1 is free
	BRnzp END_4200				;0 for busy leave R2 be go to end
	
IS_FREE_4200
	ADD R2, R2, #1
	BRnzp END_4200

;HINT Restore
END_4200
	LD R7, BACKUP_R7_4200
	
ret
;--------------------------------
;Data for subroutine MACHINE_STATUS
;--------------------------------
BUSYNESS_ADDR_MACHINE_STATUS.Fill xCE00
BACKUP_R7_4200				.BLKW #1
zero_4200					.FILL #48
fifteen_4200				.FILL #15

;-----------------------------------------------------------------------------------------------------------------
; Subroutine: FIRST_FREE
; Inputs: None
; Postcondition: 
; The subroutine has returned a value indicating the lowest numbered free machine
; Return Value (R2): the number of the free machine
;-----------------------------------------------------------------------------------------------------------------
;-------------------------------
;INSERT CODE For Subroutine FIRST_FREE
;--------------------------------
.ORIG x4400
;HINT back up 
ST R7, BACKUP_R7_4400

LD R2, zero_4400
LD R1, BUSYNESS_ADDR_FIRST_FREE
LDR R3, R1, #0
LD R4, counter_4400
ADD R3, R3, #0
BRn FREE_4400
ADD R4, R4, #-1

LOOP_4400
	ADD R3, R3, R3
	BRn FREE_4400					;if neg bit 1
	ADD R4, R4, #-1
	BRz END_4400
	BRnzp LOOP_4400

FREE_4400
	ADD R4, R4, #-1
	ADD R2, R4, #0
	ADD R4, R4, #0
	BRz END_4400
	BRnzp LOOP_4400

;HINT Restore
END_4400
	LD R7, BACKUP_R7_4400
	
ret
;--------------------------------
;Data for subroutine FIRST_FREE
;--------------------------------
BUSYNESS_ADDR_FIRST_FREE .Fill xCE00
BACKUP_R7_4400			 .BLKW #1
zero_4400				 .FILL #48
counter_4400			 .FILL #16
convto_4400				 .FILL #48

;-----------------------------------------------------------------------------------------------------------------
; Subroutine: Get input
; Inputs: None
; Postcondition: 
; The subroutine get up to a 5 digit input from the user within the range [-32768,32767]
; Return Value (R1): The value of the contructed input
; NOTE: This subroutine should be the same as the one that you did in assignment 5
;	to get input from the user, except the prompt is different.
;-----------------------------------------------------------------------------------------------------------------
;-------------------------------
;INSERT CODE For Subroutine 
;--------------------------------
.ORIG x4600

ST R7, BACKUP_R7_4600
ST R6, BACKUP_R6_4600
ST R5, BACKUP_R5_4600
ST R4, BACKUP_R4_4600
ST R3, BACKUP_R3_4600
ST R2, BACKUP_R2_4600

RESTART_4600
	LEA R0, prompt
	PUTS
	AND R1, R1, #0
	AND R2, R2, #0
	AND R3, R3, #0
	AND R4, R4, #0
	AND R5, R5, #0
	AND R6, R6, #0
	LD R5, counter_4600
	
	INPUT_LOOP_4600
		GETC
		OUT
		ADD R2, R0, #0
		LD R3, newlineCheck_4600
		ADD R4, R2, R3
		BRz CHECK_NEG_4600
						; is it = '+'? if so, ignore it, go get digits
		LD R3, posCheck_4600
		ADD R4, R2, R3
		BRz FLAG_POS_4600
						; is it = '-'? if so, op error
		LD R3, negCheck_4600
		ADD R4, R2, R3
		BRz OUTPUT_ERROR_4600
						; is it < '0'? if so, it is not a digit	- o/p error message, start over
		LD R3, belowZeroCheck_4600
		ADD R4, R2, R3
		BRn OUTPUT_ERROR_4600
						; is it > '9'? if so, it is not a digit	- o/p error message, start over
		LD R3, aboveNineCheck_4600
		ADD R4, R2, R3
		BRp OUTPUT_ERROR_4600
						; if none of the above, first character is first numeric digit - deal with it!
		ADD R4, R5, #-6
		BRz FIRST_NUMERIC_DIGIT_4600
		BRn BUILD_UP_NUM_4600

		FIRST_NUMERIC_DIGIT_4600
			LD R3, convto_4600
			ADD R1, R2, R3
			ADD R5, R5, #-2
			BRnzp INPUT_LOOP_4600
	; Now get (remaining) digits (max 5) from user and build up number in accumulator
		BUILD_UP_NUM_4600
			ADD R1, R1, R1								;2x
			ADD R7, R1, R1								;4x
			ADD R7, R7, R7								;8x
			ADD R1, R1, R7								;10x
			LD R3, convto_4600
			ADD R4, R0, R3
			ADD R1, R1, R4
			ADD R5, R5, #-1
			BRp INPUT_LOOP_4600
			ADD R5, R5, #0
			BRnz CHECK_NEG_4600

		CHECK_NEG_4600
			ADD R4, R5, #-5
			BRzp OUTPUT_ERROR_4600
			ADD R4, R1, #-15								;check if R1 is more than 15
			BRp OUTPUT_ERROR_4600				
			BRnzp END_4600

		FLAG_POS_4600
			ADD R4, R5, #-6
			BRn OUTPUT_ERROR_4600
			ADD R5, R5, #-1
			BRnzp INPUT_LOOP_4600
		
		OUTPUT_ERROR_4600
			LD R0, newline_4600
			OUT
			LEA R0, Error_msg_2
			PUTS
			BRnzp RESTART_4600


END_4600
	LD R7, BACKUP_R7_4600
	LD R6, BACKUP_R6_4600
	LD R5, BACKUP_R5_4600
	LD R4, BACKUP_R4_4600
	LD R3, BACKUP_R3_4600
	LD R2, BACKUP_R2_4600

ret
;--------------------------------
;Data for subroutine Get input
;--------------------------------
prompt .STRINGZ "Enter which machine you want the status of (0 - 15), followed by ENTER: "
Error_msg_2 .STRINGZ "ERROR INVALID INPUT\n"
BACKUP_R7_4600	.BLKW #1
BACKUP_R6_4600	.BLKW #1
BACKUP_R5_4600  .BLKW #1
BACKUP_R4_4600	.BLKW #1
BACKUP_R3_4600	.BLKW #1
BACKUP_R2_4600	.BLKW #1
counter_4600	.FILL #6
newlineCheck_4600	.FILL #-10
posCheck_4600		.FILL #-43
negCheck_4600		.FILL #-45
belowZeroCheck_4600	.FILL #-48
aboveNineCheck_4600	.FILL #-57
convto_4600			.FILL #-48
newline_4600		.FILL '\n'

	
;-----------------------------------------------------------------------------------------------------------------
; Subroutine: print number
; Inputs: 
; Postcondition: 
; The subroutine has printed the number that is in R1, as a decimal ascii string, 
; WITHOUT leading 0's, a leading sign, or a trailing newline.
; Note: that number is guaranteed to be in the range {#0, #15}, 
; i.e. either a single digit, or '1' followed by a single digit.
; Return Value: None; the value in R1 is unchanged
;-----------------------------------------------------------------------------------------------------------------
;-------------------------------
;INSERT CODE For Subroutine 
;--------------------------------
.ORIG x4800

ST R7, BACKUP_R7_4800
ST R3, BACKUP_R3_4800
ST R4, BACKUP_R4_4800


ADD R1, R2, #0
LD R3, minus_ten_4800
ADD R4, R1, R3
BRz PRINT_TEN_4800
ADD R4, R1, R3
BRn PRINT_ONES_4800
BRnzp PRINT_LEADING_ONE_4800

PRINT_LEADING_ONE_4800
	LD R3, one_4800
	ADD R0, R3, #0
	OUT
	LD R3, minus_ten_4800
	ADD R1, R1, R3
	BRnzp PRINT_ONES_4800
	
PRINT_TEN_4800
	LD R3, one_4800
	ADD R0, R3, #0
	OUT
	LD R3, zero_4800
	ADD R0, R3, #0
	OUT
	BRnzp END_4800
	
PRINT_ONES_4800
	LD R3, convfrom_4800
	ADD R0, R1, R3
	OUT
	BRnzp END_4800

END_4800
	ADD R1, R2, #0
	LD R7, BACKUP_R7_4800
	LD R3, BACKUP_R3_4800
	LD R4, BACKUP_R4_4800

ret
;--------------------------------
;Data for subroutine print number
;--------------------------------
BACKUP_R7_4800	.BLKW #1
BACKUP_R4_4800	.BLKW #1
BACKUP_R3_4800	.BLKW #1
minus_ten_4800	.FILL #-10
zero_4800		.FILL #48
one_4800		.FILL #49
convfrom_4800	.FILL #48

.ORIG x6000
MENUSTRING .STRINGZ "**********************\n* The Busyness Server *\n**********************\n1. Check to see whether all machines are busy\n2. Check to see whether all machines are free\n3. Report the number of busy machines\n4. Report the number of free machines\n5. Report the status of machine n\n6. Report the number of the first available machine\n7. Quit\n"

.ORIG xCE00			; Remote data
BUSYNESS .FILL xABCD		; <----!!!BUSYNESS VECTOR!!! Change this value to test your program.

;---------------	
;END of PROGRAM
;---------------	
.END