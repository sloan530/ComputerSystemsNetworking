.text
.globl main
main:
	addi $s0, $zero, 0	#i=0
	la $s0, array		#load array to $s0
	addi $t0, $zero, 5	#5
	sw $t0, 0($s0)		#array[0]=5
	
	addi $t1, $zero, 7	#upper limit = 7
	addi $s1, $zero, 1	#i=1
FOR_LOOP: 
	bge $s1, $t1, END_FOR	#1 to if i>=7, go to END_FOR
	addi $s2, $zero, 4	#$s2 = 4 interger size
	
	#array[i]
	mul $t2, $s2, $s1	#$t2 = 4*i
	add $s3, $s0, $t2	#$s3 = (array+i) is base address+offset*4 also new base address
	lw $t3, 0($s3)		#$t3 =array[i]
	
	#array[i-1]
	addi $t4, $s1, -1 	#$t4 = i-1
	mul $t4, $s2, $t4	#$t4 = 4*(i-1)
	add $s4, $s0, $t4 	#$s4 = (array+i-1) 
	lw $t5, 0($s4)    	#$t5 = array[i-1]
	
	add $t6, $t3, $t5 	#$t6 = array[i]+array[i-1]
	
	sw $t6, 0($s3)		#array[i] = result
	addi $s1, $s1, 1 	#i++
	j FOR_LOOP

END_FOR:
	li $v0, 10
	syscall

.data
array: .space 28
