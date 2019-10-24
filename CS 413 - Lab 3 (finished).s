@ File Name: Lab 3 - CS 413
@ Author:   Alexandra Noreiga 
@ Email Address: abn0007@uah.edu 
@ CS413-02 Fall 2019
@ Purpose:  to complete the 3rd ARM lab for CS 413
@
@ Use these commands to assemble, link and run this program
@    as -o student_inputA.o student_inputA.s
@    gcc -o student_inputA student_inputA.o
@    ./student_inputA ;echo $?

@ NOT SO SECRET SECRET CODE: Enter 'T' to be taken to the secret branch
@ it can be entered during both the drink and money stages


.text
.global main @ just in case

main:
	mov r2, #0
	mov r3, #0
	mov r4, #0 @ watch register for money total
	mov r5, #5 @ coke init 
	mov r6, #5 @ diet init 
	mov r7, #5 @ mellow yellow init   
	mov r8, #5 @ sprite init  
	mov r9, #5 @ dr. pepper init 
	mov r10, #0
	
.equ nickel, 5
.equ dime, 10 
.equ quarter, 25
.equ dollar, 100

@print welcome message 

	ldr r0, =welcomeMessage 
	bl printf

moneyLoop: @prompt user for money inputs
	
	ldr r0, =drinkInstructions
	bl printf	
	b moneyBranch

	
moneyBranch: @determine what coin was entered
	mov r1, r4
	ldr r0, =currentTotal
	bl printf 

	cmp r4, #55
	bge drinkBranch
	
	ldr r0, =moneyInstructions
	bl printf
	ldr r0, =charInput
	ldr r1, =char
	bl scanf 
	ldr r2, =char 
	ldr r3, [r2] 
	
	cmp r3, #'N'
	beq insertNickel 
	
	cmp r3, #'D'
	beq insertDime 
	
	cmp r3, #'Q'
	beq insertQuarter 
	
	cmp r3, #'B'
	beq insertDollar 
	
	cmp r3, #'T'
	beq secretCode 
	
	b invalidCoin
	
insertNickel: 
	add r4, r4, #nickel
	cmp r4, #55
	blt moneyLoop
	bge drinkLoop

insertDime: 
	add r4, r4, #dime 
	cmp r4, #55
	blt moneyLoop
	bge drinkLoop
	
insertQuarter: 
	add r4, r4, #quarter 
	cmp r4, #55 
	blt moneyLoop
	bge drinkLoop
	
insertDollar: 
	add r4, r4, #dollar
	cmp r4, #55
	blt moneyLoop
	bge drinkLoop
	
invalidCoin: 
	ldr r0, =invalidCoinMessage 
	bl printf 
	b moneyLoop
	
drinkLoop: 
	mov r1, r4
	ldr r0, =currentTotal
	bl printf 
	
	ldr r0, =selectDrink
	bl printf 
	ldr r0, =charInput
	ldr r1, =char
	bl scanf 
	ldr r2, =char 
	ldr r3, [r2] 
	b drinkBranch 
	 
drinkBranch: 
	cmp r3, #'C'
	beq confirmCoke 
	
	cmp r3, #'D'
	beq confirmDiet
	
	cmp r3, #'S'
	beq confirmSprite 
	
	cmp r3, #'P'
	beq confirmPepper 
	
	cmp r3, #'M'
	beq confirmMellow 
	
	cmp r3, #'X' 
	beq cancelDrink
	
	cmp r3, #'T' 
	beq secretCode
	
	b invalidDrink
		
confirmCoke: 
	ldr r0, =confirmCokeMessage 
	bl printf
	ldr r0, =charInput
	ldr r1, =char 
	bl scanf 
	ldr r2, =char
	ldr r3, [r2]
	cmp r3, #'Y' 
	beq dispenseCoke 
	cmp r3, #'N'
	b drinkLoop 
	
confirmDiet: 
	ldr r0, =confirmDietMessage
	bl printf 
	ldr r0, =charInput
	ldr r1, =char 
	bl scanf 
	ldr r2, =char 
	ldr r3, [r2] 
	cmp r3, #'Y'
	beq dispenseDiet 
	cmp r3, #'N'
	b drinkLoop 
	
confirmSprite: 
	ldr r0, =confirmSpriteMessage
	bl printf 
	ldr r0, =charInput
	ldr r1, =char
	bl scanf 
	ldr r2, =char 
	ldr r3, [r2] 
	cmp r3, #'Y'
	beq dispenseSprite 
	cmp r3, #'N'
	b drinkLoop
	
confirmPepper: 
	ldr r0, =confirmPepperMessage
	bl printf 
	ldr r0, =charInput
	ldr r1, =char 
	bl scanf 
	ldr r2, =char 
	ldr r3, [r2] 
	cmp r3, #'Y'
	beq dispensePepper
	cmp r3, #'N'
	b drinkLoop
	
confirmMellow: 
	ldr r0, =confirmMellowMessage
	bl printf 
	ldr r0, =charInput
	ldr r1, =char 
	bl scanf 
	ldr r2, =char 
	ldr r3, [r2] 
	cmp r3, #'Y'
	beq dispenseMellow
	cmp r3, #'N'
	b drinkLoop

@dispense the drinks 

dispenseCoke: 
	cmp r5, #0 
	beq soldOut
	sub r5, r5, #1 
	sub r4, r4, #55
	ldr r0, =dispenseCokeMessage
	mov r1, r4 
	bl printf 
	mov r4, #0
	b checkExit
	
dispenseDiet: 
	cmp r5, #0 
	beq soldOut
	sub r6, r6, #1 
	sub r4, r4, #55
	ldr r0, =dispenseDietMessage
	mov r1, r4
	bl printf 
	mov r4, #0
	b checkExit
	
dispenseMellow: 
	cmp r5, #0 
	beq soldOut
	sub r7, r7, #1 
	sub r4, r4, #55
	ldr r0, =dispenseMellowMessage
	mov r1, r4 
	bl printf 
	mov r4, #0
	b checkExit
	
dispensePepper: 
	cmp r5, #0
	beq soldOut
	sub r8, r8, #1
	sub r4, r4, #55
	ldr r0, =dispensePepperMessage 
	mov r1, r4
	bl printf 
	mov r4, #0 
	b checkExit
	
dispenseSprite: 
	cmp r5, #0 
	beq soldOut
	sub r9, r9, #1 
	sub r4, r4, #55
	ldr r0, =dispenseSpriteMessage 
	mov r1, r4 
	bl printf 
	mov r4, #0 
	b checkExit
	
cancelDrink: 
	ldr r0, =refundChange
	mov r1, r4 
	bl printf 
	@b drinkLoop where is it supposed to go?
	b endProgram
	
secretCode: 
	ldr r0, =cokeRemaining 
	mov r1, r5 
	bl printf 
	
	ldr r0, =dietRemaining 
	mov r1, r6
	bl printf 
	
	ldr r0, =mellowRemaining 
	mov r1, r7 
	bl printf 
	
	ldr r0, =pepperRemaining 
	mov r1, r8 
	bl printf 
	
	ldr r0, =spriteRemaining 
	mov r1, r9 
	bl printf
	b drinkLoop
	
soldOut: 
	ldr r0, =soldOutMessage 
	bl printf 
	b checkExit
	
invalidDrink: 
	ldr r0, =invalidDrinkMessage 
	bl printf 
	b drinkLoop	

checkExit: 
	cmp r5, #0 
	bgt moneyBranch
	
	cmp r6, #0 
	bgt moneyBranch
	
	cmp r7, #0 
	bgt moneyBranch
	
	cmp r8, #0 
	bgt moneyBranch
	
	cmp r9, #0 
	bgt moneyBranch
	
	ldr r0, =outDrinks
	bl printf 
	b endProgram
	
endProgram:
   mov r7, #0x01 @SVC call to exit
   svc 0         @Make the system call.

.data @init data 

char: 
	.word 0 
	
charInput: .asciz "%s"
@************

.balign 4 
welcomeMessage: .asciz "Welcome to Zippy's soft drink vending machine!\n"

.balign 4 
drinkInstructions: .asciz "Cost of Coke, Sprite, Dr. Pepper, Diet Coke, and Mellow Yellow is 55 cents.\n"

.balign 4
moneyInstructions: .asciz "Enter money nickel (N), dime (D), quarter (Q), and one dollar bill (B)\n"

.balign 4
selectDrink: .asciz "(C) Coke, (S) Sprite, (P) Dr. Pepper, (D) Diet Coke, or (M) Mellow Yellow (X) to cancel and return all money.\n"

.balign 4 
currentTotal: .asciz "Current total: %d\n\n"

.balign 4 
invalidCoinMessage: .asciz "You've inserted an invalid coin. Please revise your input.\n\n"

.balign 4
confirmCokeMessage: .asciz "Are you sure you want a Coke? (Y/N) \n"

.balign 4
confirmDietMessage: .asciz "Are you sure you want a Diet Coke? (Y/N) \n"

.balign 4
confirmSpriteMessage: .asciz "Are you sure you want a Sprite? (Y/N) \n"

.balign 4
confirmPepperMessage: .asciz "Are you sure you want a Dr. Pepper? (Y/N) \n"

.balign 4
confirmMellowMessage: .asciz "Are you sure you want a Mellow Yellow? (Y/N) \n"

.balign 4
dispenseCokeMessage: .asciz "Coke dispensed. %d dispensed as change.\n"

.balign 4
dispenseDietMessage: .asciz "Diet Coke dispensed. %d dispensed as change.\n"

.balign 4
dispenseSpriteMessage: .asciz "Sprite dispensed. %d dispensed as change.\n"

.balign 4
dispensePepperMessage: .asciz "Dr. Pepper dispensed. %d dispensed as change.\n"

.balign 4
dispenseMellowMessage: .asciz "Mellow Yellow dispensed. %d dispensed as change.\n"

.balign 4
cokeRemaining: .asciz "%d Cokes remaining\n"

.balign 4
dietRemaining: .asciz "%d Diet Cokes remaining\n"

.balign 4
spriteRemaining: .asciz "%d Sprites remaining\n"

.balign 4
pepperRemaining: .asciz "%d Dr. Peppers remaining\n"

.balign 4
mellowRemaining: .asciz "%d Mellow Yellows remaining\n"

.balign 4 
refundChange: .asciz "Transaction cancelled. Change refunded...\n\n"

.balign 4 
soldOutMessage: .asciz "The drink you have selected is sold out. Please select another.\n\n"

.balign 4 
outDrinks: .asciz "All drinks are sold out. Termining program...\n\n"

.balign 4 
invalidDrinkMessage: .asciz "Invalid drink selection. Please revise input.\n\n"

@end of file 
