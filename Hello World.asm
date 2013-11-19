# Name		: Dylan Jones
# Program	: Hello World
# Date		: 8/29/2012

	.text
main:
	b load_string #loads the hello_world string and prints it to the screen
	
	b exit_program #branch to the exit_program label
	
	.data
hello_world:
	.byte 0x48 #Represents 'H'
	.byte 0x65 #Represents 'e'
	.byte 0x6C #Represents 'l'
	.byte 0x6C #Represents 'l'
	.byte 0x6F #Represents 'o'
	.byte 0x20 #Represents ' '
	.byte 0x57 #Represents 'W'
	.byte 0x6F #Represents 'o'
	.byte 0x72 #Represents 'r'
	.byte 0x6C #Represents 'l'
	.byte 0x64 #Represents 'd'
	.byte 0x21 #Represents '!'
	.byte 0xA #Represents '\n'
	.byte 0x0 #Represents 0
	
	.text
load_string:
	la $a0, hello_world
	li $v0, 4 
	syscall
	
exit_program:
	li $v0, 10
	syscall
