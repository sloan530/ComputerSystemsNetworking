#int main()
#{
#  char string[256];
#  int i=0;
#  char *result = NULL;  // NULL pointer is binary zero
#  // Obtain string from user, e.g. "Constantinople"
#  scanf("%255s", string); 
#  // Search string for letter 'e'.
#  // Result is pointer to first e (if it exists)
#  // or NULL pointer if it does not exist
#  while(string[i] != '\0') {
#    if(string[i] == 'e') {
#      result = &string[i]; 
#      break; // exit from while loop early
#    }
#    i++;
#  }
#  if(result != NULL) {
#    printf("First match at address %d\n", result);
#    printf("The matching character is %c\n", *result);
#  }
#  else
#    printf("No match found\n");
#}


.globl main 
.text 		
#register map
#s0=i
#s1=string's base address
#s2='e'
#s3= null
#s4= result
main:
	li $s0, 0		#$s0=i=0
	la $s1, string		#$s1=string's base address
	li $s2, 'e'		#$s2='e'
	li $s3, 0		#$s3=null
	li $s4, 0		#$s4=null
	
	li $v0, 8 		#take in input
	la $a0, string		#load byte space into address
	li $a1, 256 		#allot the byte space for string
	syscall
	
	li $t0, 0		#$t0=i=0
while:
	add $t1, $s1, $t0	#$t1=string[i]'s address
	lb $t2, 0($t1)		#$t2=string[i]
	beq $t2, $s3, endWhile	#if string[i]==null char, go to endWhile
	beq $t2, $s2, found	#if string[i]=='e', go to found
	addi $t0, $t0, 1	#i++
	j while		#go back to start of loop

found:
	move $s4, $t1		#$s4=result = &string[i]
	sw $s4, result
	j endWhile

endWhile:
	beq $s4, $s3, notFound	#if result==null, go to not found
	
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
notFound:
	li $v0, 4		#Syscall to print string.
	la $a0, prmpt3		#print "No match found\n"
	syscall
	j exit
exit:	
	li $v0, 10 # Sets $v0 to "10" to select exit syscall
	syscall # Exit
	
.data
string:	.space 256
result:	.word 0
prmpt1:	.asciiz "First match at address "
prmpt2:	.asciiz "The matching character is "
prmpt3:	.asciiz "No match found \n"
nl:		.asciiz "\n"

