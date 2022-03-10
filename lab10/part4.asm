.text
.globl main

main:
	addi $s0, $zero, 12	#$s0=C=12
	addi $s1, $zero, 0	#i=0
	la $s1, A		#load A to $s1
	la $s2, B		#load B to $s2
	
	addi $s3, $zero, 0	#$s2=updating i=0
	addi $t0, $zero, 5	#$t0=upperlimit of forloop
for:
	bge $s3, $t0, endfor	#if i>=5, go to endfor
	addi $s4, $zero, 4	#$s4=integer size = 4
	
	#A[i]
	mul $t1, $s3, $s4	#$t1 = i*4
	add $s5, $s1, $t1	#$s4 = (A+i)
		
	#B[i]
	add $s6, $s2, $t1	#$s5 = (B+i)
	lw $t3, 0($s6)		#$t3 = B[i]
	
	#A[i]=B[i]+C
	add $t4, $t3, $s0	#$t4 = B[i]+C
	sw $t4, 0($s5)		#A[i] = result
	
	addi $s3, $s3, 1 	#i++
	j for			#go back to start of for loop
endfor:
	addi $s3, $s3, -1	#i--
	j while		#go to while loop
while:
	addi $t2, $zero, 0	#0
	blt $s3, $t2, endwhile	#if i<0 then go to endwhile
	
	#A[i]
	mul $t1, $s3, $s4	#$t1 = i*4
	add $s7, $s1, $t1	#$s6 = (A+i)
	lw $t5, 0($s7)		#$t5 = A[i]
	
	#A[i]=A[i]*2
	add $t6, $t5, $t5	#$t6 = A[i]*2
	sw $t6, 0($s7)		#A[i] = result
	addi $s3, $s3, -1	#i--
	j while
	
endwhile:
	li $v0, 10 		#Sets $v0 to "10" to select exit syscall
	syscall 		#Exit
	
	.data
A:	.space 20
B:	.word 1 2 3 4 5

