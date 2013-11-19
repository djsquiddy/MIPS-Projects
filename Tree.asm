#Name : Dylan Jones
#Program : Tree

	.data
	.align 4 
headptr: .word 0 #address of the headptr pointer
enter_list_prompt: .asciiz "Enter in a number that you would like to be added to the tree: "
output_preorder_tree: .asciiz "The numbers in preorder:\n"
output_inorder_tree: .asciiz "The numbers in inorder:\n"
output_postorder_tree: .asciiz "The numbers in postorder:\n"
end_user_prompt: .asciiz "Enter 0 to stop input.\n"
end_line_prompt: .asciiz "\n"

	.text
	.globl main
main:
	addi $sp, $sp, -4
	sw $ra, 0($sp)
	
	jal user_input
	
	# exit the program
	lw $ra, 0($sp)
	addi $sp, $sp, 4
	jr $ra
	
user_input:
	addi $sp, $sp, -4
	sw $ra, 0($sp)
	
	jal get_input_from_user
	
	li.d $f2, 0.0
	c.eq.d $f0, $f2
	bc1t end_loop_user_input
	
	mov.d $f12, $f0
	jal create_new_tree
	
loop_user_input:
	jal get_input_from_user
	
	li.d $f2, 0.0
	c.eq.d $f0, $f2
	bc1t end_loop_user_input
	
	mov.d $f12, $f0
	jal insert_new_node
	
	j loop_user_input
	
end_loop_user_input:
	# if(tree_is_empty)
	lw $t0, headptr # get a pointer to the first node
	beqz $t0, end_user_input # if(rootNode != null)
	jal print_tree_traversals

end_user_input:
	lw $ra, 0($sp)
	addi $sp, $sp, 4
	jr $ra 
	
get_input_from_user:
	addi $sp, $sp, -4
	sw $ra, 0($sp)
	
	la $a0, enter_list_prompt
	li $v0, 4
	syscall
	
	li $v0, 7
	syscall
	
	lw $ra, 0($sp)
	addi $sp, $sp, 4
	jr $ra 
	
create_new_tree:
	addi $sp, $sp, -4
	sw $ra, 0($sp)
	
	jal allocate_memory_for_node
	
    sw $v0, headptr # copy the pointer to first
	
	sdc1 $f12, 0($v0)
	
	# initalize the current node left and right nodes to null
	sw $zero, 8($v0)
	sw $zero, 12($v0)
	
	lw $ra, 0($sp)
	addi $sp, $sp, 4
	jr $ra
	
insert_new_node:
	# $f12 = value for the new node
	addi $sp, $sp, -4
	sw $ra, 0($sp)
	
	lw $t0, headptr # get a pointer to the first node
	or $t1, $zero, $zero
	
loop_to_find_correct_spot:
	beqz $t0, if_current_node_equals_null	
	l.d $f0, 0($t0)
	
	c.eq.d $f12, $f0
	bc1t end_insert
	c.lt.d $f12, $f0
	bc1t transverse_left_for_insert
	bc1f transverse_right_for_insert

transverse_left_for_insert:
	# get the left node of the current node
	or $t1, $t0, $zero
	lw $t0, 8($t0)
	j loop_to_find_correct_spot

transverse_right_for_insert:
	# get the right node of the current node
	or $t1, $t0, $zero
	lw $t0, 12($t0)
	j loop_to_find_correct_spot
	
if_current_node_equals_null:
	# allocate memory for the new node, $v0 is the new node memory address
    jal allocate_memory_for_node
	
	# link this node to the previous, $v0 = &(previous node) 
	# copy address of the new node into the previous node
	l.d $f0, 0($t1)
	c.lt.d $f12, $f0
	bc1t attach_node_left
	bc1f attach_node_right
	
attach_node_left:
    sw $v0, 8($t1)
	j end_attach_if_else
	
attach_node_right:
    sw $v0, 12($t1)
	
end_attach_if_else:
	# initalize the current node value to the passed in argument on the $f12 register
	sdc1 $f12, 0($v0)
	
	# initalize the current node next value to null
	sw $zero, 8($v0)
	sw $zero, 12($v0)
	
end_insert:
	lw $ra, 0($sp)
	addi $sp, $sp, 4
	jr $ra	

allocate_memory_for_node:
	addi $sp, $sp, -4
	sw $ra, 0($sp)
	
	# allocate 16 bytes in memory for the new node
    ori $v0, $zero, 9
	ori $a0, $zero, 16
    syscall
	
	#$v0 = address of current node
	
    lw $ra, 0($sp)
	addi $sp, $sp, 4
	jr $ra
	
print_tree_traversals:
	addi $sp, $sp, -4
	sw $ra, 0($sp)
	
	# print preorder tree traversal
	la $a0, output_preorder_tree
	li $v0, 4
	syscall
	lw $a0, headptr # get a pointer to the head node
	jal print_preorder	
	
	la $a0, end_line_prompt
	ori $v0, $zero, 4
	syscall
	
	# print inorder tree traversal
	la $a0, output_inorder_tree
	li $v0, 4
	syscall
	
	lw $a0, headptr # get a pointer to the head node
	jal print_inorder
	
	la $a0, end_line_prompt
	ori $v0, $zero, 4
	syscall
	
	# print postorder tree traversal
	la $a0, output_postorder_tree
	li $v0, 4
	syscall
	
	lw $a0, headptr # get a pointer to the head node
	jal print_postorder
	
	lw $ra, 0($sp)
	addi $sp, $sp, 4
	jr $ra
	
print_preorder:
	addi $sp, $sp, -8
	sw $ra, 0($sp)
	sw $s0, 4($sp)
	
	beqz $a0, end_print_preorder # if(node != null)
	
	or $s0, $a0, $zero
	jal print_current_node_value
	
	lw $a0, 8($s0)
	jal print_preorder
	
	lw $a0, 12($s0)
	jal print_preorder
	
end_print_preorder:
	lw $s0, 4($sp)
	lw $ra, 0($sp)
	addi $sp, $sp, 8
	jr $ra
	
print_inorder:
	addi $sp, $sp, -8
	sw $ra, 0($sp)
	sw $s0, 4($sp)
	
	beqz $a0, end_print_inorder # if(node != null)
	or $s0, $a0, $zero
	
	lw $a0, 8($s0)
	jal print_inorder
	
	or $a0, $s0, $zero
	jal print_current_node_value	
	
	lw $a0, 12($s0)
	jal print_inorder
	
end_print_inorder:
	lw $s0, 4($sp)
	lw $ra, 0($sp)
	addi $sp, $sp, 8
	jr $ra

print_postorder:
	addi $sp, $sp, -8
	sw $ra, 0($sp)
	sw $s0, 4($sp)
	
	beqz $a0, end_print_postorder # if(node != null)
	or $s0, $a0, $zero
	
	lw $a0, 8($s0)
	jal print_postorder
	lw $a0, 12($s0)
	jal print_postorder
	
	or $a0, $s0, $zero
	jal print_current_node_value	
	
end_print_postorder:	
	lw $s0, 4($sp)
	lw $ra, 0($sp)
	addi $sp, $sp, 8
	jr $ra
	
print_current_node_value:
	addi $sp, $sp, -4
	sw $ra, 0($sp)
	
	# print out current item
	l.d $f12, 0($a0)	
	ori $v0, $zero, 3
    syscall
	
	la $a0, end_line_prompt
	ori $v0, $zero, 4
	syscall
	
	lw $ra, 0($sp)
	addi $sp, $sp, 4
	jr $ra