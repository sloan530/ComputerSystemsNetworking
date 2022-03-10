.text
.globl main

#$s0: i=0, i++
#$s1: label string's address
#$s2: string's address + i == string[i]'s address
#$s3: label result's address = string[i]'s address
#$s4: string[i]

#$t0: null
#$t1: 8-bit byte string[i]
#$t2: 'e'

main:
	li $s0, 0		#i=0
	li $t0, 0		#load null char into $t0
	li $t2, 'e'		#load e into $t2
	
	li $v0, 8 		#take in input
	la $a0, string		#load byte space into address
	li $a1, 256 		#allot the byte space for string
	syscall
	
	move $s1, $a0 		#save string's address to s1
while:
	#string[i]
	add $s2, $s1, $s0	#$s2=(string+i)
	lb $t1, 0($s2)		#$t1=string[i]
	
	beq $t1, $t0, endwhile	#if string[i]=="\0" then go to endwhile
	beq $t1, $t2, if	#if string[i]=="e" then go to if
	addi $s0, $s0, 1	#i++
	j while		#go back to start of while loop
if:	
	la $s3, result		#load label result's address to $s3
	sw $s2, 0($s3)		#result=&string[i]
	j endwhile		#exit from while loop early
endwhile:
	#result
	lw $s4, 0($s3)		#load string[i]'s address to $s4
	
	beq $s4, $t0, else	#if result==NULL then go to else
	
	li $v0, 4              #Syscall to print string.
	la $a0, prmpt1		#print "First match at address "
	syscall
	
	li $v0, 1		#Syscall to print integer.
	move $a0, $s4		#print result
	syscall
	
	li $v0, 4		#Syscall to print string.
	la $a0, nl		#print new line
	syscall
	
	li $v0, 4              #Syscall to print string.
	la $a0, prmpt2		#print "The matching character is "
	syscall
	
	li $v0, 11             #Syscall to print character.
	lb $a0, 0($s4)		#load byte charater from string[i]'s address
	syscall		#print *result
				
	li $v0, 4		#Syscall to print string.
	la $a0, nl		#print new line
	syscall
	
	j exit
else:
	li $v0, 4		#Syscall to print string.
	la $a0, prmpt3		#print "No match found\n"
	syscall
	j exit
exit:	
	li $v0, 10 		#Sets $v0 to "10" to select exit syscall
	syscall 		#Exit
	
.data

string: .space 256		#char string[256]
nl:	.ascii "\n"
result: .word 0
prmpt1: .asciiz "First match at address "
prmpt2: .asciiz "The matching character is "
prmpt3: .asciiz "No match found\n"
