#int main()
#{
#   int A=15;
#   int B=10;
#   int C=7;
#   int D=2;
#   int E=18;
#   int F=-3;
#   int Z=0;
#   Z = (A+B) + (C-D) + (E+F) - (A-C);
#}


.globl main 
.text 		
#register map
#s0=A
#s1=B
#s2=C
#s3=D
#s4=E
#s5=F
#s6=Z

main:
	li $s0, 15		#$s0=A=15
	li $s1, 10		#$s1=B=10
	li $s2, 7		#$s2=C=7
	li $s3, 2		#$s3=D=2
	li $s4, 18		#$s4=E=18
	li $s5, -3		#$s5=F=-5
	add $t0, $s0, $s1	#$t0=A+B
	sub $t1, $s2, $s3	#$t1=C-D
	add $t2, $s4, $s5	#$t2=E+F
	sub $t3, $s0, $s2	#$t3=A-C
	add $t0, $t0, $t1	#$t0=(A+B)+(C-D)
	sub $t1, $t2, $t3	#$t1=(E+F)-(A-C)
	add $s6, $t0, $t1	#$s6=(A+B)+(C-D)+(E+F)-(A-C)
	sw $s6, Z
	
	li $v0, 10 # Sets $v0 to "10" to select exit syscall
	syscall # Exit
	
.data
Z:	.word 0
