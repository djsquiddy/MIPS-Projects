#Name	: Dylan Jones
#Program: Recursive

	.data
how_many_disks_prompt:
	.asciiz "Enter how many disk you would like to use for the tower of hanoi: "
move_prompt:
	.asciiz "Move from "
to_prompt:
	.asciiz " to "
end_line_promt:
	.asciiz "\n"
	
	.text
	.globl main
main:
	addi $sp, $sp, -4
	sw $ra, 0($sp)
	
	la $a0, how_many_disks_prompt
	li $v0, 4
	syscall
	
	li $v0, 5
	syscall
	
	or $a0, $v0, $zero
	li $a1, 1
	li $a2, 3
	jal hanoi
	
	lw $ra, 0($sp)
	addi $sp, $sp, 4
	jr $ra

#hanoi(diskNum, from, endPos)
hanoi:
	# a0 = number of disks
	# a1 = start
	# a2 = end
	addi $sp, $sp, -20
	sw $ra, 0($sp)
	sw $s0, 4($sp)	# s0 = number of disks
	sw $s1, 8($sp)	# s1 = start
	sw $s2, 12($sp)	# s2 = endPos
	sw $s3, 16($sp) # s3 = helper
	
	or $s0, $a0, $zero
	or $s1, $a1, $zero
	or $s2, $a2, $zero
	
	# number of disks > 1
	ori $t0, $zero, 1
	bgt $s0, $t0, disks_greater_than_one 
	
	or $a0, $s1, $zero
	or $a1, $s2, $zero
	jal move_disk
	
	j end_hanoi
	
disks_greater_than_one:
	addi $s0, $s0, -1
	ori $t0, $zero, 6
	sub $t0, $t0, $s1
	sub $s3, $t0, $s2
	
	or $a0, $s0, $zero
	or $a1, $s1, $zero
	or $a2, $s3, $zero
	jal hanoi
	
	or $a0, $s1, $zero
	or $a1, $s2, $zero
	jal move_disk
	
	or $a0, $s0, $zero
	or $a1, $s3, $zero
	or $a2, $s2, $zero
	jal hanoi
	
end_hanoi:
	lw $s3, 16($sp)
	lw $s2, 12($sp)
	lw $s1, 8($sp)
	lw $s0, 4($sp)
	lw $ra, 0($sp)
	addi $sp, $sp, 20
	jr $ra
	
#move_disk(from, endPos)
move_disk:
	addi $sp, $sp, -4
	sw $ra, 0($sp)
	
	or $t0, $a0, $zero # from variable
	or $t1, $a1, $zero # endPos variable
	
	la $a0, move_prompt
	li $v0, 4
	syscall
	
	or $a0, $t0, $zero
	li $v0, 1
	syscall
	
	la $a0, to_prompt
	li $v0, 4
	syscall
	
	or $a0, $t1, $zero
	li $v0, 1
	syscall
	
	la $a0, end_line_promt
	li $v0, 4
	syscall
	
	lw $ra, 0($sp)
	addi $sp, $sp, 4
	jr $ra