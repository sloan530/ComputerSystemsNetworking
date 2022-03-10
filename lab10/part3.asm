.text
.globl main

main:
	addi $s0, $zero, 2	#Z=2
	addi $s1, $zero, 0	#i=0
	addi $t0, $zero, 20	#$t0 = 20
	addi $t1, $zero, 100	#$t1 = 100
	addi $t2, $zero, 0	#$t2 = 0
while1: 
	bgt $s1, $t0, endwhile1#if i>20 then go to endwhile1
	addi $s0, $s0, 1	#Z++
	addi $s1, $s1, 2	#i+=2
	j while1		#go back to start of while1
endwhile1:
	j while2		#go to while2
while2:
	bge $s0, $t1, endwhile2#if Z>=100 then go to endwhile2
	addi $s0, $s0, 1	#Z++
	j while2		#go to start of while2
endwhile2:
	j while3		#go to while3
while3:
	ble $s1, $t2, endwhile3#if i<=0 then go to endwhile3
	addi $s0, $s0, -1	#Z--
	addi $s1, $s1, -1	#i--
	j while3		#go to start of while3
endwhile3:
	sw $s0, Z		#save the value of z at Z
	li $v0, 10 		#Sets $v0 to "10" to select exit syscall
	syscall 		#Exit
.data
Z:	.word 0
