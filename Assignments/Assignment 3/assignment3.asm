;=========================================================================
; Name & Email must be EXACTLY as in Gradescope roster!
; Name: Harrison Yee
; Email: hyee002@ucr.edu
; 
; Assignment name: Assignment 3
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
LD R6, Value_addr		; R6 <-- pointer to value to be displayed as binary
LDR R1, R6, #0			; R1 <-- value to be displayed as binary 
;-------------------------------
;INSERT CODE STARTING FROM HERE
;--------------------------------

LD R2, counter
LD R3, space_counter
LD R4, endl_counter

loop
  ADD R1, R1, #0
  BRn out_one
  BRzp out_zero

out_one
  LD R0, one
  OUT
  ADD R1, R1, R1
  ADD R3, R3, #-1
  BRz out_space
  ADD R2, R2, #-1
  BRp loop

out_zero
  LD R0, zero
  OUT
  ADD R1, R1, R1
  ADD R3, R3, #-1
  BRz out_space
  ADD R2, R2, #-1
  BRp loop

out_space
  ADD R4, R4, #-1
  BRz out_endl
  LD R0, space
  OUT
  LD R3, space_counter
  ADD R2, R2, #-1
  BRp loop

out_endl
  LD R0, endl
  OUT

HALT
;---------------	
;Data
;---------------
Value_addr	.FILL xAB00	; The address where value to be displayed is stored
counter		.FILL	#16
space_counter	.FILL	#4
endl_counter .FILL	#4	
zero		.FILL	#48
one			.FILL	#49
space		.FILL	' '
endl		.FILL	'\n'

.ORIG xAB00					; Remote data
Value .FILL xABCD			; <----!!!NUMBER TO BE DISPLAYED AS BINARY!!! Note: label is redundant.
;---------------	
;END of PROGRAM
;---------------	
.END