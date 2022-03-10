	# Declare main as a global function
	.globl main 

	# All program code is placed after the
	# .text assembler directive
	#indicates that following items are stored in the user text segment, typically instructions 
	.text 		

# The label 'main' represents the starting point
main:
	#$s0=A
	#$s1=B
	#$s2=C
	#$s3=D
	#$s4=E
	#$s5=F
	#$s6=Z

	addi $s0, $zero, 15	# A=15
	addi $s1, $zero, 10	# B=10
	addi $s2, $zero, 7	# C=7
	addi $s3, $zero, 2	# D=2
	addi $s4, $zero, 18	# E=18
	addi $s5, $zero, -3	# F=-3
	addi $s6, $zero, 0	# Z=0

	add $t0, $s0, $s1	# $t0=A+B
	sub $t1, $s2, $s3	# $t1=C-D
	add $t2, $s4, $s5	# $t2=E+F
	sub $t3, $s0, $s2	# $t3=A-C

	add $t0, $t0, $t1	# $t0=$t0+$t1=(A+B)+(C-D)
	sub $t2, $t2, $t3	# $t2=$t2-$t3=(E+F)-(A-C)
	add $s6, $t0, $t2	# Z=(A+B)+(C-D)+(E+F)-(A-C)
	sw $s6, Z		# store the value of z in Z

	# Exit the program by means of a syscall.
	# There are many syscalls - pick the desired one
	# by placing its code in $v0. The code for exit is "10"
	li $v0, 10 # Sets $v0 to "10" to select exit syscall
	syscall # Exit

	# All memory structures are placed after the
	# .data assembler directive
	#indicates that following data items are stored in the data segment
	.data

	# The .word assembler directive reserves space
	# in memory for a single 4-byte word (or multiple 4-byte words)
	# and assigns that memory location an initial value
	# (or a comma separated list of initial values)
Z:	.word 0



