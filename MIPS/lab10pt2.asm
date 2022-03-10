#int main()
#{
#   // Note: I should be able to change
#   // the values of A, B, and C when testing
#   // your code, and get correct output each time!
#   // (i.e. don't just hardwire your output)
#   int A=10;
#   int B=15;
#   int C=6;
#   int Z=0;
#   if(A > B || C < 5)
#      Z = 1;
#   else if((A > B) && ((C+1) == 7))
#      Z = 2;
#   else
#      Z = 3;
#   switch(Z)
#    {
#      case 1:
#         Z = -1;
#         break;
#      case 2:
#         Z =-2;
#         break;
#      default:
#         Z = 0;
#       break;
#    }
#}


.globl main 
.text 		
#register map
#s0=A
#s1=B
#s2=C
#s3=Z

main:
	li $s0, 10		#$s0=A=10
	li $s1, 15		#$s1=B=15
	li $s2, 6		#$s2=C=6
	li $s3, 0		#$s3=Z=0
	
	ble $s0, $s1, if	#if A<=B, go to if
	li $s3, 1		#Z=1
	j switch		#jump to switch
if:
	li $t0, 5		#$t0=5
	bge $s2, $t0, elseIf	#if C>=5, go to elseIf
	li $s3, 1		#Z=1
	j switch		#jump to switch
	
elseIf:
	ble $s0, $s1, else	#if A<=B, go to else
	addi, $s2, $zero, 1	#$s2=C+1
	li $t0, 7		#$t0=7
	bne $s2, $t0, else	#if (C+1)!=7, go to else
	li $s3, 2		#Z=2
	j switch		#jump to switch

else:
	li $s3, 3		#Z=3
	j switch		#jump to switch
switch:	
	li $t0, 1		#$t0=1
	li $t1, 2		#$t1=2
	li $t2, 3		#$t2=3
	beq $s3, $t0, case1	#if Z==1, go to case1
	beq $s3, $t1, case2	#if Z==2, go to case2
	beq $s3, $t2, case3	#if Z==3, go to case3
case1:
	li $s3, -1		#Z=-1
	j end			#jump to end
case2:	
	li $s4, -2		#Z=-2
	j end			#jump to end
case3:	
	li $s3, 0		#Z=0
	j end			#jump to end
end:
	sw $s3, Z		#store $s3 to Z
	li $v0, 10 # Sets $v0 to "10" to select exit syscall
	syscall # Exit
	
.data
Z:	.word 0
