.text
.globl main

#$s0: n1
#$s1: n2
#$s2: i=0
#$s3: gcd(n1,n2)

#$t0: for loop upper limit = 10
#$t1: 1	
#$t2: 10000

main:
	li $s0, 0		#$s0 = n1
	li $s1, 0		#$s1 = n2
	li $s2, 0		#$s2 = i = 0
	li $t0, 10		#for loop upper limit = 10
FOR_LOOP: 
	bge $s2, $t0, END_FOR	#if i>=10, go to END_FOR
	
	#n1=random_in_range(1,10000);
	li $t1, 1		#low = 1
	li $t2, 10000		#high = 10000
	move $a0, $t1		#argument 1 = 1
	move $a1, $t2		#argument 2 = 10000
	jal random_in_range	#jump to random_in_range
	move $s0, $v0		#return value saved in $v0 to $s0 (n1)
	
	#n2=random_in_range(1,10000);
	move $a0, $t1		#argument 1 = 1
	move $a1, $t2		#argument 2 = 10000
	jal random_in_range	#jump to random_in_range
	move $s1, $v0		#return value saved in $v0 to $s1 (n2)
	
	#printf("\n G.C.D of %u and %u is %u.", n1, n2, gcd(n1,n2));
	li $v0, 4		#Syscall to print string.
	la $a0, nl		#load address of new line
	syscall		#print new line
	
	li $v0, 4              #Syscall to print string.
	la $a0, prmt1		#load address of " G.C.D of "
	syscall		#print
	
	li $v0, 1		#Syscall to print integer.
	move $a0, $s0		#move n1 to argument
	syscall		#print n1
	
	li $v0, 4              #Syscall to print string.
	la $a0, prmt2		#load address of " and "
	syscall		#print
	
	li $v0, 1		#Syscall to print integer.
	move $a0, $s1		#move n2 to argument
	syscall		#print n2
	
	li $v0, 4              #Syscall to print string.
	la $a0, prmt3		#load address of " is "
	syscall		#print
	
	#gcd(n1,n2)
	move $a0, $s0		#argument 1 = n1
	move $a1, $s1		#argument 2 = n2
	jal gcd		#jump to gcd
	move $s3, $v0		#return value saved in $v0 to $s3 (gcd(n1,n2))
	
	li $v0, 1		#Syscall to print integer.
	move $a0, $s3		#move gcd(n1,n2) to argument
	syscall		#print gcd(n1,n2)
	
	li $v0, 4              #Syscall to print string.
	la $a0, prmt4		#load address of "."
	syscall		#print
	
	addi $s2, $s2, 1 	#i++
	j FOR_LOOP
END_FOR:
	li $v0, 10 		#Sets $v0 to "10" to select exit syscall
	syscall 		#Exit

random_in_range:
	#push $s0, $s1, $s2, $ra to stack
	addi $sp, $sp, -4
	sw $s0, 0($sp)
	addi $sp, $sp, -4
	sw $s1, 0($sp)
	addi $sp, $sp, -4
	sw $s2, 0($sp)
	addi $sp, $sp, -4
	sw $ra, 0($sp)
	
	#uint32_t range = high-low+1;
	subu $s0, $a1, $a0	#$s0 = high-low
	addiu $s0, $s0, 1	#$s0 = range = high-low+1
	
	#uint32_t rand_num = get_random();
	jal get_random		#jump to get_random
	move $s1, $v0		#return value saved in $v0 to $s1 == rand_num
	
	#return (rand_num % range) + low;
	divu $s1, $s0		#hi = rand_num % range
	mfhi $s2		#$s2 = hi = rand_num % range
	addu $s2, $s2, $a0	#$s2 = rand_num % range + low
	move $v0, $s2		#save the return value at $v0
	
	#pop $ra, $s2, $s1, $s0 from stack
	lw $ra, 0($sp)
	addi $sp, $sp, 4
	lw $s2, 0($sp)
	addi $sp, $sp, 4
	lw $s1, 0($sp)
	addi $sp, $sp, 4
	lw $s0, 0($sp)
	addi $sp, $sp, 4
	
	jr $ra			#return from function
get_random:
	#push $s0, $s1, $t0, $t1, $ra to stack
	addi $sp, $sp, -4
	sw $s0, 0($sp)
	addi $sp, $sp, -4
	sw $s1, 0($sp)
	addi $sp, $sp, -4
	sw $t0, 0($sp)
	addi $sp, $sp, -4
	sw $t1, 0($sp)
	addi $sp, $sp, -4
	sw $ra, 0($sp)
	
	lw $s0, m_w		#load m_w to $s0
	lw $s1, m_z		#load m_z to $s1
	
	andi $t0, $s1, 65535	#$t0 = m_z & 65535
	li $t1, 36969		#$t1 = 36969
	mul $t1, $t1, $t0	#$t1 = 36969 * (m_z & 65535)
	srl $t0, $s1, 16	#$t0 = m_z >> 16
	addu $s1, $t1, $t0	#$s1 = m_z = 36969 * (m_z & 65535) + (m_z >> 16)
	sw $s1, m_z		#store value of m_z to label m_z
	
	andi $t0, $s0, 65535	#$t0 = m_w & 65535
	li $t1, 18000		#$t1 = 18000
	mul $t1, $t1, $t0	#$t1 = 18000 * (m_w & 65535)
	srl $t0, $s0, 16	#$t0 = m_w >> 16
	addu $s0, $t1, $t0	#$s0 = m_w = 18000 * (m_w & 65536) + (m_w >> 16)
	sw $s0, m_w		#store value of m_w to label m_w
	
	sll $t0, $s1, 16	#$t0 = m_z << 16
	addu $t1, $t0, $s0	#$t1 = result = (m_z << 16) + m_w
	
	move $v0, $t1		#save the return value at $v0
	
	#pop $ra, $t1, $t0, $s1, $s0 from stack
	lw $ra, 0($sp)
	addi $sp, $sp, 4
	lw $t1, 0($sp)
	addi $sp, $sp, 4
	lw $t0, 0($sp)
	addi $sp, $sp, 4
	lw $s1, 0($sp)
	addi $sp, $sp, 4
	lw $s0, 0($sp)
	addi $sp, $sp, 4
	
	jr $ra			#return from function
gcd:
	#push $s0, $s1, $t0, $ra to stack
	addi $sp, $sp, -4
	sw $s0, 0($sp)
	addi $sp, $sp, -4
	sw $s1, 0($sp)
	addi $sp, $sp, -4
	sw $t0, 0($sp)
	addi $sp, $sp, -4
	sw $ra, 0($sp)
	
	#$a0 = n1 
	#$a1 = n2
	move $s0, $a0		#$s0 = n1
	move $s1, $a1		#$s1 = n2
	li $t0, 0		#$t0 = 0
	beq $s1, $t0, else	#if n2 == 0 go to else
	
	#return gcd(n2, n1%n2);
	move $a0, $s1		#argument 1 = n2
	div $s0, $s1		#hi = n1 % n2
	mfhi $t0		#$t0 = hi = n1 % n2
	move $a1, $t0		#argument 2 = n1 % n2
	jal gcd		#jump to gcd
	move $t0, $v0		#return value saved in $v0 to $t0 (gcd(n2, n1%n2))
	move $v0, $t0		#save the return value at $v0
	
	#pop $ra, $t0, $s1, $s0 from stack
	lw $ra, 0($sp)
	addi $sp, $sp, 4
	lw $t0, 0($sp)
	addi $sp, $sp, 4
	lw $s1, 0($sp)
	addi $sp, $sp, 4
	lw $s0, 0($sp)
	addi $sp, $sp, 4
	
	jr $ra			#return from function

else:	
	move $v0, $s0		#save the return value at $v0
	
	#pop $ra, $t0, $s1, $s0 from stack
	lw $ra, 0($sp)
	addi $sp, $sp, 4
	lw $t0, 0($sp)
	addi $sp, $sp, 4
	lw $s1, 0($sp)
	addi $sp, $sp, 4
	lw $s0, 0($sp)
	addi $sp, $sp, 4
	
	jr $ra			#return from function
	
.data

m_w:	.word 50000
m_z:	.word 60000
nl:	.asciiz "\n"
prmt1:	.asciiz " G.C.D of "
prmt2:	.asciiz " and "
prmt3:	.asciiz " is "
prmt4:	.asciiz "."
