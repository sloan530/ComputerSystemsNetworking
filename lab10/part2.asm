
.globl main 
.text 		

# The label 'main' represents the starting point
main:
	addi $s0, $zero, 10	#A=10
	addi $s1, $zero, 15	#B=15
	addi $s2, $zero, 6	#C=6
	addi $s3, $zero, 0	#Z=0
	
	bgt $s0, $s1, label1	#if A>B then go to label1
	addi $t0, $zero, 5	#5
	blt $s2, $t0, label1	#if C<5 then go to label1
	bgt $s0, $s1, label2	#if A>B then go to label2
	addi $s3, $s3, 3	#Z=3
	
	j switch		#jump to switch
label1:
	add $s3, $s3, 1	#Z=1
	j switch		#jump to switch
label2:
	addi $t0, $zero, 7	#7
	addi $t2, $s2, 1	#c+1
	beq $t1, $t2, label3	#if C+1==7 then go to label3
label3:
	addi $s3, $s3, 2	#Z=2
	j switch
switch:
	addi $t0, $zero, 1	#1
	beq $s3, $t0, case1	#if z==1 then go to case1
	addi $t0, $zero, 2	#2
	beq $s3, $t0, case2	#if z==2 then go to case2
	addi $s3, $zero, 0	#else z=0
	j exit			#jump to exit
case1:
	addi $s3, $zero, -1	#z=-1
	j exit			#jump to exit
case2:
	addi $s3, $zero, -2	#z=-2
	j exit			#jump to exit

exit:	
	sw $s3, Z		#store value of z to Z
	li $v0, 10 		#Sets $v0 to "10" to select exit syscall
	syscall 		#Exit
	
.data
Z: 	.word 0
