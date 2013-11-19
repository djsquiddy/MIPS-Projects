#Name: Dylan Jones
#Program: Arrays and Loops
#Date: 9/29/2012

	.data
	.align 2
array:  .space 40
enter_array_prompt: .asciiz "Enter in a number that you would like to be added to the array: "
output_sorted_array: .asciiz "The numbers sorted are:\n"
end_line: .asciiz "\n"

	.globl main
	.text
main:
	addi $sp, $sp, -8
	sw $ra, 0($sp)
	sw $s4, 4($sp)
	
	la $s4, array
	li $t0, 0
	li $t1, 10
number_prompt_loop_begin:
	beq $t0, $t1, number_prompt_loop_end
	la $a0, enter_array_prompt
	li $v0, 4
	syscall
	
	li $v0, 5
	syscall

	sw $v0, 0($s4)
	addi $s4, $s4, 4 
	
	addi $t0, $t0, 1	
	j number_prompt_loop_begin

number_prompt_loop_end:
	la $a0, array
	li $a1, 10
	
	jal bubble_sort

	la $a0, output_sorted_array
	li $v0, 4
	syscall
	
	la $s4, array
	li $t0, 0
	li $t1, 10
print_sorted_array_loop_begin:
	beq $t0, $t1, print_sorted_array_loop_end
	
	lw $a0, 0($s4)
	li $v0, 1
	syscall
	
	la $a0, end_line
	li $v0, 4
	syscall
	
	addi $s4, $s4, 4
	addi $t0, $t0, 1
	j print_sorted_array_loop_begin
	
print_sorted_array_loop_end:
	lw $s4, 4($sp)
	lw $ra, 0($sp)
	addi $sp, $sp, 8
	jr $ra
	
bubble_sort:
	addi $sp, $sp, -20
	sw $ra, 0($sp)
	sw $s0, 4($sp)	#array
	sw $s1, 8($sp)	#n size of array
	sw $s2, 12($sp)	#i counter
	sw $s3, 16($sp) #j counter
	
	or $s0, $a0, $zero
	or $s1, $a1, $zero
	li $s2, 0
	
begin_i_loop:
	beq $s2, $s1, end_i_loop
	li $s3, 0
	la $s0, array #set current array element offset
		
begin_j_loop:
	addi $t0, $s1, -1	
	beq $s3, $t0, end_j_loop
	
	lw $t0, 0($s0)
	lw $t1, 4($s0)
	
	blt $t0, $t1, no_swap
	la $a0, 0($s0)
	la $a1, 4($s0)
	
	jal swap
	
no_swap:
	addi $s3, $s3, 1
	addi $s0, $s0, 4
	j begin_j_loop
	
end_j_loop:
	addi $s2, $s2, 1
	
	j begin_i_loop

end_i_loop:
	lw $s3, 16($sp)
	lw $s2, 12($sp)
	lw $s1, 8($sp)
	lw $s0, 4($sp)
	lw $ra, 0($sp)
	addi $sp, $sp, 20
	jr $ra

swap:
	addi $sp, $sp, -4
	sw $ra, 0($sp)
	
	lw $t0, 0($a0)
	lw $t1, 0($a1)
	sw $t0, 0($a1)
	sw $t1, 0($a0)
	
	lw $ra, 0($sp)
	addi $sp, $sp, 4
	jr $ra
	