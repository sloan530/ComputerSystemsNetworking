#function problems
#	#include <stdio.h>

#	int function(int a);

#	int main(){
#		int x=5;
#		int y;
	
#		y=function(x);
	
#		printf("y=%i\n", y);
	
#		return 0;

#	}

#	int function(int a) {
#		return 3*a+5;
#	}

#answer:

.text
.globl main

#s0 = x
#s1 = y

main:
	#initialize registers
	lw $s0, x	#$s0 = x
	lw $s1, y	#$s1 = y

	
	#call function
	move $a0, $s0	#argument 1 = x
	jal function	#jump to function
	move $s1, $v0	#return value saved in $v0
	
	#print msg1
	li $v0, 4
	la $a0, msg1
	syscall
	
	#print result
	li $v0, 1
	move $a0, $s1
	syscall
	
	#print newline
	li $v0, 4
	la $a0, lf
	syscall
	
	#exit
	li $v0, 10
	syscall
	
function:
	#push $s0, $s1, $ra to stack
	addi $sp, $sp, -4
	sw $s0, 0($sp)
	addi $sp, $sp, -4
	sw $s1, 0($sp)
	addi $sp, $sp, -4
	sw $ra, 0($sp)
	
	li $s0, 3
	mul $s1, $s0, $a0	#$s1 = 3*$a0
	addi $s1, $s1, 5	#$s1 = 3*$a0+5
	
	#save the return value in $v0
	move $v0, $s1
	
	#pop $ra, $s1, $s0 from stack
	lw $ra, 0($sp)
	addi $sp, $sp, 4
	lw $s1, 0($sp)
	addi $sp, $sp, 4
	lw $s0, 0($sp)
	addi $sp, $sp, 4
	
	#return from function
	jr $ra

.data

x: .word 5
y: .word 0
msg1: .asciiz "y="
lf: .asciiz "\n"




