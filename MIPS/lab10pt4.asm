#int main()
#{
#   int A[5]; // Empty memory region for 5 elements
#   int B[5] = {1,2,3,4,5};
#   int C=12;
#   int i;
#   for(i=0; i<5; i++)
#   {
#      A[i] = B[i] + C;
#   } 
#   i--;
#   while(i >= 0)
#   {
#      A[i]=A[i]*2;
#      i--;
#   } 
#}

.globl main 
.text 		
#register map
#s0=C
#s1=i
#s2=A's base address
#s3=B's base address
#s4=4
main:
	li $s0, 12		#$s0=C=12
	li $s1, 0		#$s1=i=0
	la $s2, A		#$s2=base address of A
	la $s3, B		#$s3=base address of B
	li $s4, 4		#$s4=4, size of int
	li $t0, 5		#$t0=5
for:
	bge $s1, $t0, endFor	#if i>=5, go to endFor
	
	mul $t1, $s4, $s1	#$t1=4*i
	#A[i]
	add $t2, $s2, $t1	#$t2=A[i]'s address=base address+4*i
	
	#B[i]
	add $t4, $s3, $t1	#$t4=B[i]'s address=base address+4*i 
	lw $t5, 0($t4)		#$t5=B[i]
	
	#B[i]+C
	add $t5, $t5, $s0	#$t5=B[i]+C
	sw $t5, 0($t2)		#store B[i]+C in A[i]
	
	addi $s1, $s1, 1	#i++
	j for			#go back to start of loop
	
endFor:
	addi $s1, $s1, -1	#i--
	li $t0, 0		#$t0=0
while:
	blt $s1, $t0, endWhile	#if i<0, go to endWhile
	mul $t1, $s4, $s1	#$t1=4*i
	#A[i]
	add $t2, $s2, $t1	#$t2=A[i]'s address=base address+4*i
	lw $t3, 0($t2)		#$t3=A[i]
	li $t4, 2		#$t4=2
	mul $t3, $t3, $t4	#$t3=A[i]*2
	sw $t3, 0($t2)		#store A[i]*2 in A[i]
	addi $s1, $s1, -1	#i--
	j while		#go back to start of loop
	
endWhile:
	li $v0, 10 # Sets $v0 to "10" to select exit syscall
	syscall # Exit
	
.data
A:	.space 20
B:	.word 1 2 3 4 5
