#Name : Dylan Jones
#Program : State Machine
###Program Description###
#This program is designed around the statemachine that is attached. 
#That is where the branch names come from.


#Write a MIPS program that accepts a string then determines if that string 
#is in the language c*a*c*b*c* where the number of a's is even, the number of 
#b's is odd and the number of c's is even.  You must do this as a state machine.
#Meaning you can have no variables (other than the input string), and that you 
#may only examine each input character once.


#if string is empty beqz $t0, exit
#a = 97
#b = 98
#c = 99
#\n = 10

	.data
user_prompt:
	.asciiz "Enter in a string containing (a,b,c) to test:\n"
error_state_prompt:
	.asciiz "\nYour string did not pass the test."
end_state_prompt:
	.asciiz "\nYour string passed the test."
users_string:
	.byte 100
	
	.text
	.globl main

main:
	addi $sp, $sp, -4
	sw $ra, 0($sp)
	
	la $a0, user_prompt
	li $v0, 4
	syscall
	
	la $a0, users_string #where the string will be stored
	la $a1, users_string #how much memory does the string have
	li $v0, 8 #get the string from the user
	syscall 
	
	jal start_state_machine
	
	lw $ra, 0($sp)
	addi $sp, $sp, 4
	jr $ra
	
start_state_machine:
	addi $sp, $sp, -8
	sw $ra, 0($sp)
	sw $s0, 4($sp)
	
	la $s0, users_string#loads the users_string into $s0
	ori $t1, $t1, 97 	#used to represent 'a'
	ori $t2, $t2, 98 	#used to represent 'b'
	ori $t3, $t3, 99 	#used to represent 'c'
	ori $t4, $t4, 10 	#used to represent '\n'
	beqz $s0, end_state #check if the string is empty
	
state_A:
	or $t0, $t0, $zero	#reset the value of $t0
	lb $t0, 0($s0) 	 	#load the current char into $to
	addi $s0, $s0, 1	#add one to the memory address of the users_string
	
	beq $t0, $t3, state_B	#if (s0[0] == 'c')
	beq $t0, $t1, state_C 	#else if(s0[0] == 'a')
	beq $t0, $t2, state_H	#else if(s0[0] == 'b')
	beq $t0, $t4, end_state #else if(s0[0] == '\n')
	b state_error 			#else error
	
state_B:
	or $t0, $t0, $zero	#reset the value of $t0
	lb $t0, 0($s0) 	 	#load the current char into $to
	addi $s0, $s0, 1	#add one to the memory address of the users_string
	
	
	beq $t0, $t3, state_A	#if (s0[0] == 'c')
	beq $t0, $t1, state_D	#else if(s0[0] == 'a')
	beq $t0, $t2, state_G	#else if(s0[0] == 'b')
	b state_error			#else error
	
state_C:
	or $t0, $t0, $zero	#reset the value of $t0
	lb $t0, 0($s0) 	 	#load the current char into $to
	addi $s0, $s0, 1	#add one to the memory address of the users_string

	beq $t0, $t1, state_F	#if(s0[0] == 'a')
	b state_error			#else error
	
state_D:
	or $t0, $t0, $zero	#reset the value of $t0
	lb $t0, 0($s0) 	 	#load the current char into $to
	addi $s0, $s0, 1	#add one to the memory address of the users_string
	
	beq $t0, $t1, state_E	#if(s0[0] == 'a')
	b state_error			#else error
	
state_E:
	or $t0, $t0, $zero	#reset the value of $t0
	lb $t0, 0($s0) 	 	#load the current char into $to
	addi $s0, $s0, 1	#add one to the memory address of the users_string
	
	beq $t0, $t3, state_A	#if (s0[0] == 'c')
	beq $t0, $t2, state_G	#else if(s0[0] == 'b')
	beq $t0, $t1, state_D	#else if(s0[0] == 'a')
	b state_error			#else error
	
state_F:
	or $t0, $t0, $zero	#reset the value of $t0
	lb $t0, 0($s0) 	 	#load the current char into $to
	addi $s0, $s0, 1	#add one to the memory address of the users_string
	
	beq $t0, $t3, state_B	#if (s0[0] == 'c')
	beq $t0, $t2, state_H	#else if(s0[0] == 'b')
	beq $t0, $t1, state_C	#else if(s0[0] == 'a')
	beq $t0, $t4, end_state #else if(s0[0] == '\n')
	b state_error			#else error
	
state_G:
	or $t0, $t0, $zero	#reset the value of $t0
	lb $t0, 0($s0) 	 	#load the current char into $to
	addi $s0, $s0, 1	#add one to the memory address of the users_string
	
	beq $t0, $t3, state_A	#if (s0[0] == 'c')
	beq $t0, $t2, state_I	#else if(s0[0] == 'b')
	b state_error			#else error
	
state_H:
	or $t0, $t0, $zero	#reset the value of $t0
	lb $t0, 0($s0) 	 	#load the current char into $to
	addi $s0, $s0, 1	#add one to the memory address of the users_string
	
	beq $t0, $t3, state_B		#if (s0[0] == 'c')
	beq $t0, $t2, state_J		#else if(s0[0] == 'b')
	beq $t0, $t1, state_error	#else if(s0[0] == 'a')
	beq $t0, $t4, end_state 	#else if(s0[0] == '\n')
	
state_I:
	or $t0, $t0, $zero #reset the value of $t0
	lb $t0, 0($s0) #load the current char into $to
	addi $s0, $s0, 1 #add one to the memory address of the users_string
	
	beq $t0, $t2, state_G	#if(s0[0] == 'b')
	b state_error			#else error
	
state_J:
	or $t0, $t0, $zero	#reset the value of $t0
	lb $t0, 0($s0) 	 	#load the current char into $to
	addi $s0, $s0, 1	#add one to the memory address of the users_string
	
	beq $t0, $t2, state_H	#if(s0[0] == 'b')
	b state_error			#else error
	
end_state: #if the program reaches this state then the string has passed the statemachine
	la $a0, end_state_prompt
	li $v0, 4
	syscall
	
	b end_state_machine
	
state_error:#if the program reaches this state then the string has failed the statemachine
	la $a0, error_state_prompt
	li $v0, 4
	syscall
	
end_state_machine:
	lw $s0, 4($sp)
	lw $ra, 0($sp)
	addi $sp, $sp, 8
	jr $ra