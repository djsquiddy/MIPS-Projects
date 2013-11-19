#Name: Dylan Jones
#Program: Linked Lists
#Write a program that accepts a set of floating point numbers from the user. 
#This set is arbitrary in size, and you may not ask the user how large 
#it is (instead you must allocate memory as needed).  
#When the user indicates that they are done output the list in order.  
#You are expected to store this list as a linked list.

	.data
	.align 3
head: .word 0 #address of the head pointer
enter_list_prompt: .asciiz "Enter in a number that you would like to be added to the list: "
output_sorted_list: .asciiz "The numbers sorted are:\n"
end_user_prompt: .asciiz "Enter 0 to stop input.\n"
end_line_prompt: .asciiz "\n"

	.text
	.globl main
main:
	addi $sp, $sp, -4
	sw $ra, 0($sp)

	jal create_new_list
	
	la $a0, end_user_prompt
	li $v0, 4
	syscall

loop_get_user_input:
	la $a0, enter_list_prompt
	li $v0, 4
	syscall
	
	li $v0, 6
	syscall
	
	li.s $f1, 0.0
	c.eq.s $f0, $f1
	bc1t end_loop_get_user_input
	
	mov.s $f12, $f0
	jal insert_new_node
	
	j loop_get_user_input
	
end_loop_get_user_input:	
	jal print_linked_list
	
	lw $ra, 0($sp)
	addi $sp, $sp, 4
	
	# exit the program
	li $v0, 10
	syscall 

create_new_list:
	addi $sp, $sp, -4
	sw $ra, 0($sp)
	
	jal allocate_memory_for_node
	# copy the pointer to first
    sw $v0, head
	
	# initalize the current node next value to null
	sw $zero, 4($v0)
	
	lw $ra, 0($sp)
	addi $sp, $sp, 4
	jr $ra
	
insert_new_node:
	# $f12 = value for the new node
	addi $sp, $sp, -4
	sw $ra, 0($sp)
	
	# allocate memory for the new node, $v0 is the new node memory address
    jal allocate_memory_for_node
	
	lw $t0, head # get a pointer to the first node
	or $t1, $zero, $zero
	
	#beqz $t0, is_first_node_in_list
	
loop_to_find_correct_spot:
	beqz $t0, if_current_node_next_equals_null	
	l.s $f0, 0($t0)
	c.lt.s $f12, $f0
	bc1t if_current_node_does_not_equal_null
	
	or $t1, $t0, $zero
	lw $t0, 4($t0)
	
	j loop_to_find_correct_spot
	
if_current_node_next_equals_null:
	# link this node to the previous, $v0 = &(previous node) 
	# copy address of the new node into the previous node
    sw $v0, 4($t1)
	
	# initalize the current node value to the passed in argument on the $f12 register
	swc1 $f12, 0($v0)
	
	# initalize the current node next value to null
	sw $zero, 4($v0)
	
	j end_insert_if_else
	
if_current_node_does_not_equal_null:
	# initalize the current node value to the passed in argument on the $f12 register
	swc1 $f12, 0($v0)
	
	sw $v0, 4($t1)
	sw $t0, 4($v0)

	j end_insert_if_else
	
end_insert_if_else:
	lw $ra, 0($sp)
	addi $sp, $sp, 4
	jr $ra
	
allocate_memory_for_node:
	addi $sp, $sp, -4
	sw $ra, 0($sp)
	
	# allocate 12 bytes in memory for the new node
    li $v0, 9
    li $a0, 8
    syscall
	
	#$v0 = address of current node
	
    lw $ra, 0($sp)
	addi $sp, $sp, 4
	jr $ra
	
print_linked_list:
	addi $sp, $sp, -4
	sw $ra, 0($sp)
	
	la $a0, output_sorted_list
	li $v0, 4
	syscall
	
	la $a0, end_line_prompt
	li $v0, 4
	syscall
	
    lw $s0, head # get a pointer to the head node
	lw $s0, 4($s0)
	
begin_loop_print_linked_list: 
	# while (next != null)
	beqz $s0, end_loop_print_linked_list 
	
    # get the value for the current node
	l.s $f12, 0($s0)
	
	# print out current item
	li $v0, 2
    syscall
	
	la $a0, end_line_prompt
	li $v0, 4
	syscall
	
	# get the pointer to the next node
    lw $s0, 4($s0)
	b begin_loop_print_linked_list
	
end_loop_print_linked_list:   
    lw $ra, 0($sp)
	addi $sp, $sp, 4
	jr $ra