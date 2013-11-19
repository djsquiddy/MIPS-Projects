#Name: Dylan Jones
#Program: Fibonacci Numbers
#Write a MIPS program that prompts for a number (n) and then prints out the 
#nth number of the fibonacci sequence.  F(0) = 0, F(1) = 1, F(n) = F(n - 1) + F(n - 2).
#int fib(int n)
#{
#	if(n < 2)
#		return n;
#	else
#		return fib(n-1)+fib(n-2);
#}

	.data
enter_number_prompt:
	.asciiz "Enter n for fibonacci(n): "
nth_fibonacci_number_prompt_part_one:
	.asciiz "The n = "
nth_fibonacci_number_prompt_part_two:
	.asciiz " term of the fibonacci sequence is: "

	.text
	.globl main
main:
	addi $sp, $sp, -8
	sw $ra, 0($sp)
	sw $s0, 4($sp)
	
	la $a0, enter_number_prompt
	li $v0, 4
	syscall
	
	li $v0, 5
	syscall
	or $s0, $v0, $zero
	
	or $a0, $s0, $zero
	
	jal fibonacci
	
	or $t0, $v0, $zero
	
	la $a0, nth_fibonacci_number_prompt_part_one
	li $v0, 4
	syscall
	
	or $a0, $s0, $zero
	li $v0, 1
	syscall
	
	la $a0, nth_fibonacci_number_prompt_part_two
	li $v0, 4
	syscall
	
	or $a0, $t0, $zero
	li $v0, 1
	syscall
	
	lw $s0, 4($sp)
	lw $ra, 0($sp)
	addi $sp, $sp, 8
	jr $ra
	
fibonacci:
	# $a0 = n
	# $v0 = return value
	addi $sp, $sp, -4
	sw $ra, 0($sp)
	
	ori $t0, $zero, 1
	
	bgt $a0, $t0, n_greater_than_1
	or $v0, $a0, $zero
	j end_if_statement
	
n_greater_than_1:
	addi $sp, $sp, -12
	sw $s0, 0($sp) # $s0 = n
	sw $s1, 4($sp) # $s1 = n - 1
	sw $s2, 8($sp) # $s2 = n - 2

	
	or $s0, $a0, $zero
	
	addi $a0, $s0, -1
	jal fibonacci # fib(n - 1)
	or $s1, $v0, $zero
	
	addi $a0, $s0, -2
	jal fibonacci # fib(n - 2)
	or $s2, $v0, $zero
	
	add $v0, $s1, $s2
	
	lw $s2, 8($sp)
	lw $s1, 4($sp)
	lw $s0, 0($sp)
	addi $sp, $sp, 12
	
end_if_statement:	
	lw $ra, 0($sp)
	addi $sp, $sp, 4
	jr $ra