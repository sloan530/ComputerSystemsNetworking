#int main()
#{
#   int Z=2;
#   int i;
#   i=0;
#   while(1){
#     if(i>20)
#       break;
#    Z++;
#    i+=2;
#   }
#   do {
#      Z++;
#   } while (Z<100);  
#   while(i > 0) {
#      Z--;
#      i--;
#   }
#return 0;
#}


.globl main 
.text 		
#register map
#s0=Z
#s1=i

main:
	li $s0, 2		#$s0=Z=2
	li $s1, 0		#$s1=i=0
	li $t0, 20		#$t0=20
	li $t1, 100		#$t1=100
	li $t2, 0		#$t2=0
while1: 
	bgt $s1, $t0, while2	#if i>20, go to while2
	addi $s0, $s0, 1	#Z++
	addi $s1, $s1, 2	#i+=2
	j while1		#go back to start of loop
	
while2:
	bge $s0, $t1, while3	#if Z>=100, go to while3
	addi $s0, $s0, 1	#Z++
	j while2		#go back to start of loop

while3:
	ble $s1, $t2, end	#if i<=0, go to end
	addi $s0, $s0, -1	#Z--
	addi $s1, $s1, -1	#i--
	j while3		#go back to start of loop

end:
	sw $s0, Z
	sw $s1, i
	li $v0, 10 # Sets $v0 to "10" to select exit syscall
	syscall # Exit
	
.data
Z:	.word 0
i:	.word 0
