;=========================================================================
; Name & Email must be EXACTLY as in Gradescope roster!
; Name: Harrison Yee
; Email: hyee002@ucr.edu
; 
; Assignment name: Assignment 2
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

;----------------------------------------------
;output prompt
;----------------------------------------------	
LEA R0, intro			; get starting address of prompt string
PUTS			    	; Invokes BIOS routine to output string

;-------------------------------
;INSERT YOUR CODE here
;--------------------------------
GETC			
OUT
ADD R1, R0, #0		
LD R0, newline		
OUT		
GETC				
OUT
ADD R2, R0, #0
LD R0, newline
OUT
ADD R0, R1, #0			
OUT
LD R0, space
OUT
LD R0, subtract
OUT
LD R0, space
OUT
ADD R0, R2, #0
OUT
LD R0, space
OUT
LD R0, equals
OUT
LD R0, space
OUT

LD R3, convert			
ADD R1, R1, R3
ADD R2, R2, R3
NOT R2, R2		
ADD R2, R2, #1
ADD R4, R1, R2
BRn neg
BRzp pos

neg
  NOT R4, R4
  ADD R4, R4, #1
  LD R0, subtract
  OUT
  ADD R4, R4, R3
  ADD R0, R4, #0
  OUT
  LD R0, newline
  OUT
  BRnzp end

pos
  ADD R4, R4, R3
  ADD R0, R4, #0
  OUT
  LD R0, newline
  OUT

end 
    HALT				; Stop execution of program
;------	
;Data
;------
; String to prompt user. Note: already includes terminating newline!
intro 	.STRINGZ	"ENTER two numbers (i.e '0'....'9')\n" 		; prompt string - use with LEA, followed by PUTS.
newline .FILL '\n'	; newline character - use with LD followed by OUT
space .FILL ' '
subtract .FILL '-'		
equals .FILL '='
convert .FILL x30

;---------------	
;END of PROGRAM
;---------------	
.END
