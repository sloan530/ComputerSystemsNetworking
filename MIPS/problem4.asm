#problme4:
#	sum=0;
#	for (i=0; i<10; i++){
#		j=i;
#		while(j<2*i){
#			sum=sum+j;
#			j++;
#		}
#	}

#answer:

.globl main
.text

main:	
	addi $s0, $zero, 0	#sum=0
	addi $s1, $zero, 0	#i=0
	addi $t0, $zero, 10	#upper limit=10
	addi $s2, $zero, 0	#j=0
	addi $t1, $zero, 2	#2
	
FOR_LOOP: 
	bge $s1, $t0, END_FOR	#if i>=10, go to END_FOR
	addi $s2, $s1, 0	#j=i
	mul $t2, $s1, $t1	#$t2=i*2
WHILE:	
	bge $s2, $t2, END_WHILE#if j>=i*2, go to END_WHILE
	add $s0, $s0, $s2	#sum=sum+j
	sw $s0, SUM
	addi $s2, $s2, 1	#j++
	j WHILE		#jump back to the top of while loop again
END_WHILE:
	addi $s1, $s1, 1	#i++
	j FOR_LOOP		#jump back to the top of for loop again
END_FOR:
	li $v0, 10 		#Sets $v0 to "10" to select exit syscall
	syscall		#exit

.data

SUM:	.word 0

