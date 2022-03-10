#int sum(int n);
#int main()
#{
#     int num;
#     printf(“\n Enter a positive integer:”);
#     scanf(“%d”,&num);
#     printf(“\n Sum = %d”,sum(num));
#     return 0;
#}
#int sum(int n)
#{
#     if(n!=0)
#         return (n + sum(n-1));
#     else
#         return n;
#}

.globl main 
.text 		
#register map
#s0=num
#s1=sum(num)

main:
	li $v0, 4              #Syscall to print string.
	la $a0, prmt1		
	syscall
	
	li $v0, 5 		#Syscall to take in input integer
	syscall
	move $s0, $v0		#move the input integer to $s0
	
	move $a0, $s0		#argument: $s0 = num
	jal sum		#call sum(num)
	move $s1, $v0		#$s1 = sum(num)
	
	li $v0, 4              #Syscall to print string.
	la $a0, prmt2		
	syscall	
	
	li $v0, 1		#Syscall to print integer.
	move $a0, $s1		#print $s1=sum(num)
	syscall
	
	li $v0, 10 # Sets $v0 to "10" to select exit syscall
	syscall # Exit
	
sum:
#push $s0, $s1, $s2, $ra to stack
	addi $sp, $sp, -4
	sw $s0, 0($sp)
	addi $sp, $sp, -4
	sw $s1, 0($sp)
	addi $sp, $sp, -4	
	sw $s2, 0($sp)
	addi $sp, $sp, -4
	sw $ra, 0($sp)
	
	move $s0, $a0		#$s0=argument 
	li $s1, 0		#$s1=0
	
	bne $s0, $s1, notEqual	#if n!=0, go to notEqual
	move $v0, $s0		#return $s0=n
	j exitSum	
notEqual:
	addi $s2, $s0, -1	#$s2=n-1
	move $a0, $s2		#argument: $s2=n-1
	jal sum		#call sum(n-1)
	move $s2, $v0		#$s2=sum(n-1)
	add $s2, $s0, $s2	#$s2=n+sum(n-1)
	move $v0, $s2		#return $s2=n+sum(n-1)
	j exitSum
exitSum:
	lw $ra, 0($sp)
	addi $sp, $sp, 4
	lw $s2, 0($sp)
	addi $sp, $sp, 4
	lw $s1, 0($sp)
	addi $sp, $sp, 4
	lw $s0, 0($sp)
	addi $sp, $sp, 4
	
	jr $ra
	
.data
prmt1: .asciiz "\n Enter a positive integer:"
prmt2: .asciiz "\n Sum = "
