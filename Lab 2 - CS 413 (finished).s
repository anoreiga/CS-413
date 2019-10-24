@title: CS 413 - Lab 2
@author: Alexandra Noreiga
@date: 9/27/2019

@ as -o test.o test.s
@ gcc -o test test.o 
@ ./test ;echo $?

.global main 

main: 
@declaring welcome message with instructions 
	LDR r0, =welcomeString
	BL printf
	LDR r0, =starLine
	BL printf
	
	LDR r0, =instructionString1
	BL printf
	LDR r0, =instructionString2
	BL printf
	LDR r0, =starLine
	BL printf                                                                                                                                                                 
	
@get number 1 input from user 
	LDR r0, =requestInput1
	BL printf
	LDR r0, =hexPattern
	LDR r1, =hexInput1
	
	BL scanf 
	
	LDR r1, =hexInput1
	LDR r5, [r1]
	MOV r1, r5
	BL hexError

@get number 2 input from user 
	LDR r0, =requestInput2
	BL printf 
	LDR r0, =hexPattern
	LDR r1, =hexInput2
	BL scanf 

	LDR r1, =hexInput2
	LDR r9, [r1] 
	MOV r1, r9 
	BL hexError
	
@get operation 
	LDR r0, =operationSelect
	BL printf
	
	LDR r0, =charPattern
	LDR r1, =charInput
	BL scanf 
	LDR r1, =charInput
	LDR r6, [r1] @store operation 
	BL isOpValid

@ start PUSHing things 
	PUSH {r5, r9}

	BL performOperation
	BL printOperation
	
	BL doAgain

@exit the program if there are no other options	
	LDR r0, =exitProgram
	BL printf
	B exit

		
@ All the Subroutines!
printOperation: 
	POP {r1} 
	LDR r0, =printResult
	PUSH {lr}
	BL printf
	POP {lr}
	MOV pc, lr
	
isOpValid: 
	CMP r6, #'A'
	MOVEQ pc, lr 
	CMP r6, #'O'
	MOVEQ pc, lr 
	CMP r6, #'E'
	MOVEQ pc, lr 
	CMP r6, #'B'
	MOVEQ pc, lr
	CMP r6, #'a'
	MOVEQ pc, lr 
	CMP r6, #'o'
	MOVEQ pc, lr 
	CMP r6, #'e'
	MOVEQ pc, lr 
	CMP r6, #'b'
	MOVEQ pc, lr
	B notValid

@check to see if r1 = 0 to check if input is not valid 
@ if r1 = 0, then branch to the notValid branch for not valid input	
hexError: 
	CMP r1, #0
	BEQ notValid
	MOV pc, lr

performOperation:
	POP {r1, r2} 
	PUSH {r1, r2, lr}
	
	CMP r6, #'A' @if user selects A, then branch to the AND operation
	BLEQ bitwiseAND
	CMP r6, #'O' @if user selects O, then branch to the ORR operation
	BLEQ bitwiseORR
	CMP r6, #'E' @if user selects E, then branch to the EOR operation
	BLEQ bitwiseEOR
	CMP r6, #'B' @if user selects B, then branch to the BIC operation
	BLEQ bitwiseBIC
	
@ just in case any lowercase letters were input, do the same thing up above
	CMP r6, #'a' @if user selects a, then branch to the AND operation
	BLEQ bitwiseAND
	CMP r6, #'o' @if user selects o, then branch to the ORR operation
	BLEQ bitwiseORR
	CMP r6, #'e' @if user selects e, then branch to the EOR operation
	BLEQ bitwiseEOR
	CMP r6, #'b' @if user selects b, then branch to the BIC operation
	BLEQ bitwiseBIC
	
	POP {lr} 
	MOV pc, lr
	
bitwiseAND:
	 POP {r1, r2, lr}
	 AND r1, r1, r2
	 PUSH {r1, lr}
	 MOV pc, lr
	 
bitwiseORR: 
	 POP {r1, r2, lr}
	 ORR r1, r1, r2
	 PUSH {r1, lr}
	 MOV pc, lr
	 
bitwiseEOR:
	 POP {r1, r2, lr}
	 EOR r1, r1, r2
	 PUSH {r1, lr}
	 MOV pc, lr
	 
bitwiseBIC:	
	 POP {r1, r2, lr}
	 BIC r1, r1, r2
	 PUSH {r1, lr}
	 MOV pc, lr

@notValid branch to handle invalid inputs
notValid: 
	LDR r0, =errorMessage0ff
	BL printf

@clear the input buffer
	LDR r0, =inputBufferClear
	BL printf
	
	LDR r0, =charPattern
	SUB SP, SP, #4
	MOV r1, SP
	BL scanf
	ADD SP, SP, #4

	B doAgain @ask user if they want to work with the program again 
	
doAgain: 

	LDR r0, =requestContinue
	PUSH {lr}
	BL printf
	
	POP {lr} 
	LDR r0, =charPattern
	LDR r1, =charInput
	PUSH {lr}
	BL scanf
	
	POP {lr}
	LDR r1, =charInput
	LDR r1, [r1]
	CMP r1, #'Y'	@if user inputs Y, branch back to main
	BEQ main 
	CMP r1, #'y'	@if user inputs y, branch back to main
	BEQ main 
	CMP r1, #'N' 
	BEQ exit 
	CMP r1, #'n'

	LDR r0, =starLine
	PUSH {lr}
	BL printf
	POP {lr}
	MOV pc, lr
	
@Program Exit	
exit: 
	MOV r7, #0x01
	SVC 0

@ ********************************** 

.data 
.balign 4
welcomeString: .asciz "Welcome to the Simple Binary Logic program!\n"
.balign 4
instructionString1: .asciz "Here are some instructions to help you run the program:\n"
.balign 4
instructionString2: .asciz "Your input number MUST be in hexadecimal, and you must select an operation that you want performed on that hex number.\n"
.balign 4
operationSelect: .asciz "Select your operation: (A, O, E, B)\n"

.balign 4 
requestInput1: .asciz "Input your first hex number:\n"
.balign 4
requestInput2: .asciz "Input your second hex number:\n"

.balign 4 
firstNumber: .asciz "First Number:\n"
.balign 4
secondNumber: .asciz "Second Number:\n"

.balign 4
selectedOperation: .asciz "Selected operation:\n"

.balign 4 
requestContinue: .asciz "Would you like to perform another operation? (Y/N)\n"

.balign 4 
exitProgram: .asciz "You've selected Exit. Program terminating...\n"

.balign 4 
inputBufferClear: .asciz "Clearing input buffer...\n"

.balign 4
printResult: .asciz "Result:	%x\n"

@ Error Handling  
errorMessage: .asciz "You've entered an invalid input.\n"

.balign 4 
starLine: .asciz "******************************************************\n"

@ Input Patterns
.balign 4
hexPattern: .asciz "%x"
.balign 4
charPattern: .asciz "%s"
.balign 4
hexInput1: .word 0 
.balign 4 
hexInput2: .word 0
.balign 4
charInput: .word 0 

.global printf
.global scanf
/*
pi@raspberrypi:~/Desktop $ as -o alexandra.o alexandra.s 
pi@raspberrypi:~/Desktop $ gcc -o alexandra alexandra.o
pi@raspberrypi:~/Desktop $ ./alexandra ;echo $?
Welcome to the Simple Binary Logic program!
******************************************************
Here are some instructions to help you run the program:
Your input number MUST be in hexadecimal, and you must select an operation that you want performed on that hex number.
******************************************************
Input your first hex number:
00ffff
Input your second hex number:
00ffaf 
Select your operation: (A, O, E, B)
A
Result:	ffaf
Would you like to perform another operation? (Y/N)
Y
Welcome to the Simple Binary Logic program!
******************************************************
Here are some instructions to help you run the program:
Your input number MUST be in hexadecimal, and you must select an operation that you want performed on that hex number.
******************************************************
Input your first hex number:
00ffff
Input your second hex number:
0aaaff
Select your operation: (A, O, E, B)
O
Result:	affff
Would you like to perform another operation? (Y/N)
Y
Welcome to the Simple Binary Logic program!
******************************************************
Here are some instructions to help you run the program:
Your input number MUST be in hexadecimal, and you must select an operation that you want performed on that hex number.
******************************************************
Input your first hex number:
00aa
Input your second hex number:
00bb
Select your operation: (A, O, E, B)
E
Result:	11
Would you like to perform another operation? (Y/N)
Y
Welcome to the Simple Binary Logic program!
******************************************************
Here are some instructions to help you run the program:
Your input number MUST be in hexadecimal, and you must select an operation that you want performed on that hex number.
******************************************************
Input your first hex number:
d3
Input your second hex number:
80 
Select your operation: (A, O, E, B)
B
Result:	53
Would you like to perform another operation? (Y/N)
Y
Welcome to the Simple Binary Logic program!
******************************************************
Here are some instructions to help you run the program:
Your input number MUST be in hexadecimal, and you must select an operation that you want performed on that hex number.
******************************************************
Input your first hex number:
rtab
Input your second hex number:
Select your operation: (A, O, E, B)
You've entered an invalid input.
Clearing input buffer...

*/