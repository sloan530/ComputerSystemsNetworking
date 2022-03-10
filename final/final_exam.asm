.globl main 
.text 		
#register map
#s0=array size
#s1=search
#s2=i
#s3=result
#s4=array's base address
#s5=0

main:
	li $s0, 5		#$s0=array size
	li $s1, 12		#$s1=search
	li $s2, 0		#$s2=i=0
	li $s3, 0		#$s3=result
	la $s4, array		#$s4=array's base address
	
	move $a0, $s4		#argument 1: $s4=base address of array
	addi $t0, $s0, -1	#$t0=arraySize-1
	move $a1, $t0		#argument 2: $t0=array size-1
	move $a2, $s1		#argument 3: $s1=search
	jal arraySearch	#call arraySearch(int * array, int arraySize, int search)
	move $s3, $v0		#save return value at $s3
	
	li $s5, 0		#s5=0
	blt $s3, $s5, notFound	#if result<0, go to notFound
	
	li $v0, 4              #Syscall to print string.
	la $a0, prmpt1		
	syscall
	
	li $v0, 1		#Syscall to print integer.
	move $a0, $s1		#print search
	syscall
	
	li $v0, 4              #Syscall to print string.
	la $a0, prmpt2	
	syscall
	
	li $v0, 1		#Syscall to print integer.
	move $a0, $s3		#print result
	syscall	
	
	li $v0, 4              #Syscall to print string.
	la $a0, nl		
	syscall
	
	j exit
	
notFound:
	li $v0, 4              #Syscall to print string.
	la $a0, prmpt3		
	syscall
	
	j exit

exit:	
	li $v0, 10 # Sets $v0 to "10" to select exit syscall
	syscall # Exit

arraySearch:
	addi $sp, $sp, -4
	sw $s0, 0($sp)
	addi $sp, $sp, -4
	sw $s1, 0($sp)
	addi $sp, $sp, -4	
	sw $s2, 0($sp)
	addi $sp, $sp, -4
	sw $s3, 0($sp)
	addi $sp, $sp, -4
	sw $s4, 0($sp)
	addi $sp, $sp, -4
	sw $ra, 0($sp)
	
	move $s0, $a0		#$s0=array's base address
	move $s1, $a1		#$s1=arraySize-1
	move $s2, $a2		#$s2=search
	
	#array[arraySize]
	li $s3, 4		#$s3=size of integer
	mul $s3, $s3, $s1	#$s3=4*arraySize
	add $s3, $s0, $s3	#$s3=array[arraySize]'s address=base address+4*arraySize
	lw $s4, 0($s3)		#$s4=array[arraySize]
	
	beq $s4, $s2, found	#if array[arraySize]==search, go to found
	li $s3, -1		#$s3=-1
	beq $s1, $s3, notInArray	#if arraySize==-1, got to notInArray
	
	move $a0, $s0		#argument 1: $s4=base address of array
	addi $s1, $s1, -1	#$s1=arraySize-1
	move $a1, $s1		#argument 2: $s1=array size-1
	move $a2, $s2		#argument 3: $s2=search
	
	jal arraySearch	#call arraySearch(array,arraySize-1,search)
	
	j arraySearchEnd	
found:
	move $v0, $s1		#return arraySize
	j arraySearchEnd
notInArray:
	move $v0, $s3		#return -1
	j arraySearchEnd
arraySearchEnd:
	lw $ra, 0($sp)
	addi $sp, $sp, 4
	lw $s4, 0($sp)
	addi $sp, $sp, 4
	lw $s3, 0($sp)
	addi $sp, $sp, 4
	lw $s2, 0($sp)
	addi $sp, $sp, 4
	lw $s1, 0($sp)
	addi $sp, $sp, 4
	lw $s0, 0($sp)
	addi $sp, $sp, 4
	
	jr $ra			#return from function
	
	
.data
array: .word 2 3 5 7 11
prmpt1: .asciiz "Element "
prmpt2: .asciiz " found at array index "
nl:	.asciiz "\n"
prmpt3: .asciiz "Search key not found"
