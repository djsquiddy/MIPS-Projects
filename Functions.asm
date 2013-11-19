# Name: Dylan Jones
# Project: Function Calls
# Date: 9/9/2012

# Strings for the prompts to the user
	.data
firstNumberPrompt: .asciiz "Enter the first number: "
secondNumberPrompt:	.asciiz "Enter the Second number: "
invalidInput: .asciiz "Sorry that is an invalid input\n"
resultPrompt: .asciiz "Result: "
additionPrompt: .asciiz "You have chosen Addition\n"
subtractionPrompt: .asciiz "You have chosen Subtraction\n"
newLine: .asciiz "\n"
menuPrompt:
	.ascii "Main Menu\n"
	.ascii "-------------\n"
	.ascii "1. Addition\n"
	.ascii "2. Subtraction\n"
	.ascii "3. Exit\n"
	.ascii "Selection: "
	.byte 0
	
	.globl main
	.text
main:
	addi $sp, $sp, -8
	sw $ra, 0($sp)
	sw $s0, 4($sp)
	
mainLoop:
	# Reset s0 to 0
	li $s0, 0
	
	# Print out the menu for the user
	la $a0, menuPrompt
	li $v0, 4
	syscall
	
	# Get the choice from the menu from the user
	li $v0, 5
	syscall
	move $s0, $v0

	# If the input equals 1 or 2
	beq $s0, 1, numberPrompt #if $s0 == 1
	beq $s0, 2, numberPrompt #if $s0 == 2
	beq $s0, 3, exitLoop #if $s0 == 3

	# Check to see if the input doesnt equal a valid option
	bgt $s0, 3, invalidInputLoop #if $s0 > 3
	bltz $s0, invalidInputLoop	#if $s0 < 0

exitLoop: #Exits the program and the main loop
	lw $s0, 4($sp)
	lw $ra, 0($sp)
	addi $sp, $sp, 8
	jr $ra

invalidInputLoop: #If the menu input is invalid
	la $a0, invalidInput
	li $v0, 4
	syscall
	
	# Starts the main loop over again
	j mainLoop
	
numberPrompt:
	addi $sp, $sp, -4
	sw 	$s1, 0($sp)
	
	beq $s0, 1, doesEqualOne
	beq $s0, 2, doesEqualTwo	
doesEqualOne:
	jal printAdditionLabel
	j endIfStatement
doesEqualTwo:
	jal printSubtractionLabel
	j endIfStatement
endIfStatement:
	j mainLoop
	
printAdditionLabel: #Prints out the additionPrompt to the user
	addi $sp, $sp, -4
	sw $ra, 0($sp)
	
	la $a0, additionPrompt
	jal inputNumber
	
	lw $ra, 0($sp)
	addi $sp, $sp, 4
	jr $ra
	
printSubtractionLabel: #Prints out the subtractionPrompt to the user
	addi $sp, $sp, -4
	sw $ra, 0($sp)
	
	la $a0, subtractionPrompt
	jal inputNumber
	
	lw $ra, 0($sp)
	addi $sp, $sp, 4
	jr $ra
	
inputNumber: # Gets the two numbers from the user then decides if they wanted addition or subtraction
	addi $sp, $sp, -4
	sw $ra, 0($sp)
	
	li $v0, 4
	syscall 

	#Get the first number from the user
	la $a0, firstNumberPrompt
	li $v0, 4
	syscall
	li $v0, 5
	syscall
	move $t0, $v0
	
	#Get the second number from the user
	la $a0, secondNumberPrompt
	li $v0, 4
	syscall
	li $v0, 5
	syscall
	move $t1, $v0
	
	
	move $a0, $t0
	move $a1, $t1
	beq $s0, 1, addition
	beq $s0, 2, subtraction
	
	lw $ra, 0($sp)
	addi $sp, $sp, 4
	jr $ra
addition:
	addi $sp, $sp, -4
	sw $ra, 0($sp)
	add $a0, $a0, $a1	# result is sum of args
	jal result
	lw $ra, 0($sp)
	addi $sp, $sp, 4
	jr $ra
	
subtraction:	
	addi $sp, $sp, -4
	sw $ra, 0($sp)
	sub $a0, $a0, $a1	# result is sum of args
	jal result
	lw $ra, 0($sp)
	addi $sp, $sp, 4
	jr $ra
	
result:
	addi $sp, $sp, -4
	sw $ra, 0($sp)
	
	move $t0, $a0
	
	#Print out the result
	la $a0, resultPrompt
	li $v0, 4
	syscall
	move $a0, $t0
	li $v0, 1
	syscall	
	
	la $a0, newLine
	li $v0, 4
	syscall
	
	lw $s1, 4($sp)
	lw $ra, 0($sp)
	addi $sp, $sp, 8
	jr $ra