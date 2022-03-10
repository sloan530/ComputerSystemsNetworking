.text
.globl main

#$s0: constant row = 6
#$s1: constant col = 9
#$s2: i=0
#$s3: j=0
#$s4: number 1 - later col
#$s5: number 2 - later comCol
#$s6: constant 0 - false
#$s7: constant 1 - true

#$t0: constant base address of myArray
#$t1: HorC
#$t2: address of myArray[i][j]
#$t3: constant '-'
#$t4: constant 'C'
#$t5: constant 'H'
#$t6: i+1
#$t7: valCol return value

main:	
	li $s0, 6		#6 rows
	li $s1, 9		#9 columns

	li $t3, '-'		#$t3 = '-'
	li $t4, 'C'		#$t4 = 'C'
	li $t5, 'H'		#$t5 = 'H'
	
	la $t0, myArray	#load base address of myArray
	li $s2, 0		#i=0

for1:	
	li $s3, 0		#j=0
	bge $s2, $s0, endfor1	#if i>=row, go to endfor1
	
for2:
	bge $s3, $s1, endfor2	#if j>=col, go to endfor2
	
	#address of myArray[i][j] = type size X (row X i + j)
	
	mul $t2, $s1, $s2	#$t2 = 9*i
	add $t2, $t2, $s3	#$t2 = 9*i+j
	add $t2, $t0, $t2	#$t2 = base address + 9*i + j = address of myArray[i][j]
	#gives error when j=1 unaligned address why?
	#I put .align 0
	#I use sb instead of sw because char is 1 byte = 8 bit, lb sb are for 8 bits
	#now it works!
	sb $t3, 0($t2)		#put '-' at myArray[i][j]
	
	addi $s3, $s3, 1	#j++
	j for2			#jump back to start of for2
	
endfor2:
	addi $s2, $s2, 1	#i++
	j for1			#jump back to start of for1
	
endfor1:
	li $s2, 0		#reset i to 0
	j for3			#jump to for3

for3:
	bge $s2, $s0, endfor3	#if i>=row, go to endfor3
	
	mul $t2, $s1, $s2	#$t2 = 9*i
	add $t2, $t0, $t2	#$t2 = base address + 9*i = address of myArray[i][0]
	
	sb $t4, 0($t2)		#put 'C' at myArray[i][0]
	
	mul $t2, $s1, $s2	#$t2 = 9*i
	addi $t2, $t2, 8	#$t2 = 9*i+8
	add $t2, $t0, $t2	#$t2 = base address + 9*i + 8 = address of myArray[i][8]	
	sb $t4, 0($t2)		#put 'C' at myArray[i][8]
	
	addi $t6, $s2, 1	#$t6 = i+1
	mul $t2, $s1, $t6	#$t2 = 9*(i+1)
	add $t2, $t0, $t2	#$t2 = base address + 9*(i+1) = address of myArray[i][0]
	
	sb $t5, 0($t2)		#put 'H' at myArray[i+1][0]
	
	mul $t2, $s1, $t6	#$t2 = 9*(i+1)
	addi $t2, $t2, 8	#$t2 = 9*(i+1)+8
	add $t2, $t0, $t2	#$t2 = base address + 9*i + 8 = address of myArray[i+1][8]
	sb $t5, 0($t2)		#put 'H' at myArray[i+1][8]
	
	addi $s2, $s2, 2	#i+=2
	j for3			#jump back to start of for3
	
endfor3:
	li $v0, 4		#Syscall to print string.
	la $a0, prmt1		#load address of prmt1
	syscall		#print Welcome to Connect Four, Five-in-a-Row variant!	
	
	li $v0, 4		#Syscall to print string.
	la $a0, prmt2		#load address of prmt2
	syscall		#print Enter two positive numbers to initialize the random number generator.
	
	li $v0, 4		#Syscall to print string.
	la $a0, prmt3		#load address of prmt3
	syscall		#print Number 1:
	
	li $v0, 5 		#take in input number1
	syscall
	move $s4, $v0		#save number1 in $s4
	
	li $v0, 4		#Syscall to print string.
	la $a0, prmt4		#load address of prmt4
	syscall		#print Number 2:
	
	li $v0, 5 		#take in input number1
	syscall
	move $s5, $v0		#save number2 in $s5
	
	sw $s4, m_w		#save number1 to m_w
	sw $s5, m_z		#save number2 to m_z
	
	li $a0, 0		#argument 1 = 0
	li $a1, 2		#argument 2 = 1
	jal random_in_range	#jump to function
	move $t1, $v0		#return value saved in $v0 to $t1 (HorC)
	
	li $v0, 4		#Syscall to print string.
	la $a0, prmt5		#load address of prmt5
	syscall		#print \nHuman player (H) or Computer player (C)\nCoin toss...
	
	li $s6, 0		#$s6=0
	bne $t1, $s6, endif1	#if HorC !=0, go to endif1
	li $v0, 4		#Syscall to print string.
	la $a0, prmt6		#load address of prmt6
	syscall		#print HUMAN goes first\n
	
	j back_main		#jump to back_main
	
endif1:
	li $v0, 4		#Syscall to print string.
	la $a0, prmt7		#load address of prmt7
	syscall		#print COMPUTER goes first\n
	
	j back_main		#jump to back_main

back_main:
	jal print_board	#print the board
	
while1:
	li $s4, 1		#$s4 = 1
	li $s7, 1		#$s7 = 1
	bne $s4, $s7, endwhile1	#if 1!=1 go to endwhile
	
	li $a0, 1		#argument 1: 1
	li $a1, 7		#argument 2: 7
	jal random_in_range	#jump to random_in_range
	move $s5, $v0		#return random_in_range(1,7) saved in $s5 comCol
	
while2: 
	move $a0, $s5		#argument 1: comCol
	jal valCol		#call function valCol
	move $t7 , $v0		#return value (valCol(comCol)) saves at 
	beq $t7, $s7, endwhile2	#if valCol(comCol)==1, go to endwhile2
	
	li $a0, 1		#argument 1: 1
	li $a1, 7		#argument 2: 7
	jal random_in_range	#jump to random_in_range
	move $s5, $v0		#return value saved in $s5 comCol
	
	j while2		#jump to start of while2


endwhile2:
	bne $t1, $s6, comFirst	#if HorC != 0, go to comFirst

#when player goes first
	jal user_input
	move $s4, $v0		#$s4 = col = user_input()
	
	li $a0, 'H'		#argument 1: 'H'
	move $a1, $s4		#argument 2: col
	jal putToken		#call putToken
	move $s2, $v0		#$s2 = i = putToken('H', col)
	
	move $a0, $s2		#argument 1: i
	move $a1, $s4		#argument 2: col
	jal checkWin		#call checkWin
	move $t6, $v0 		#save checkWin(i,col) at $t6
	
	beq $t6, $s7, endwhile1	#if checkWin(i,col) == 1, go to endwhile1
	
	li $a0, 'C'		#argument 1: 'C'
	move $a1, $s5		#argument 2: comCol
	jal putToken		#call putToken
	move $s2, $v0		#$s2 = i = putToken('C', comCol)
	
	li $v0, 4		#Syscall to print string.
	la $a0, prmt10		#load address of prmt10
	syscall		#print "Computer player selected column "
	
	li $v0, 1		#Syscall to print integer
	move $a0, $s5		#load comCol to $a0
	syscall		#print comCol
	
	li $v0, 4		#Syscall to print string.
	la $a0, nl		#load address of newline
	syscall		#print newline
	
	move $a0, $s2		#argument 1: i
	move $a1, $s5		#argument 2: comCol
	jal checkWin		#call checkWin
	move $t6, $v0 		#save checkWin(i,comCol) at $t6
	
	beq $t6, $s7, endwhile1	#if checkWin(i,comCol) == 1, go to endwhile1
	
	jal print_board	#print the board
	j while1		#jump back to start of while1

#when computer goes first	
comFirst:
	li $a0, 'C'		#argument 1: 'C'
	move $a1, $s5		#argument 2: comCol
	jal putToken		#call putToken
	move $s2, $v0		#$s2 = i = putToken('C', comCol)
	
	li $v0, 4		#Syscall to print string.
	la $a0, prmt10		#load address of prmt10
	syscall		#print "Computer player selected column "
	
	li $v0, 1		#Syscall to print integer
	move $a0, $s5		#load comCol to $a0
	syscall		#print comCol
	
	li $v0, 4		#Syscall to print string.
	la $a0, nl		#load address of newline
	syscall		#print newline
	
	move $a0, $s2		#argument 1: i
	move $a1, $s5		#argument 2: comCol
	jal checkWin		#call checkWin
	move $t6, $v0 		#save checkWin(i,comCol) at $t6
	
	beq $t6, $s7, endwhile1	#if checkWin(i,comCol) == 1, go to endwhile1
	
	jal user_input		#get user_input
	move $s4, $v0		#$s4 = col = user_input()
	
	li $a0, 'H'		#argument 1: 'H'
	move $a1, $s4		#argument 2: col
	jal putToken		#call putToken
	move $s2, $v0		#$s2 = i = putToken('H', col)
	
	move $a0, $s2		#argument 1: i
	move $a1, $s4		#argument 2: col
	jal checkWin		#call checkWin
	move $t6, $v0 		#save checkWin(i,col) at $t6
	
	beq $t6, $s7, endwhile1	#if checkWin(i,col) == 1, go to endwhile1
	
	jal print_board	#print the board
	j while1		#jump back to start of while1
	
endwhile1:
	jal print_board	#print the board
	
	lb $t1, winner		#$t1 = winner
	li $t4, 'C'		#$t4 = 'C'
	li $t5, 'H'		#$t5 = 'H'
	beq $t1, $t5, playerWin	#if winner == 'H', go to playerWin
	beq $t1, $t4, computerWin	#if winner == 'C', go to computerWin
	
	li $v0, 4		#Syscall to print string.
	la $a0, prmt13		#load address of prmt13
	syscall		#print "Tie!\n"
	
	li $v0, 10 		#Sets $v0 to "10" to select exit syscall
	syscall 		#Exit
	

playerWin:
	li $v0, 4		#Syscall to print string.
	la $a0, prmt11		#load address of prmt11
	syscall		#print "Congratulations, You Won!\n"
	
	li $v0, 10 		#Sets $v0 to "10" to select exit syscall
	syscall 		#Exit
	
computerWin:
	li $v0, 4		#Syscall to print string.
	la $a0, prmt12		#load address of prmt12
	syscall		#print "Booooo, You Lost!\n"
	
	li $v0, 10 		#Sets $v0 to "10" to select exit syscall
	syscall 		#Exit

checkWin:
	#push $s0, $s2, $s3, $t2, $t3, $ra to stack
	addi $sp, $sp, -4
	sw $s0, 0($sp)
	addi $sp, $sp, -4
	sw $s2, 0($sp)
	addi $sp, $sp, -4
	sw $s3, 0($sp)
	addi $sp, $sp, -4
	sw $t2, 0($sp)
	addi $sp, $sp, -4
	sw $t3, 0($sp)
	addi $sp, $sp, -4
	sw $ra, 0($sp)
	
	move $s0, $a0		#$s0 = row
	move $s2, $a1		#$s2 = col
	la $t0, myArray	#load base address of myArray
	mul $t2, $s1, $s0	#$t2 = 9*(row)
	add $t2, $t2, $s2	#$t2 = 9*(row)+col
	add $t2, $t0, $t2	#$t2 = base address + 9*row + col = address of myArray[row][col]
	lb $s3, 0($t2)		#$s3 = myArray[row][col]
	
	move $a0, $s0		#argument 1: row
	move $a1, $s2		#argument 2: col
	li $a2, 1		#argument 3: 1
	li $a3, 0		#argument 4: 0
	jal count		#call count
	move $t3, $v0		#save count(row,col,1,0) at $t3
	
	beq $t3, $s7, win	#if count(row,col,1,0) == 1, go to win
	
	move $a0, $s0		#argument 1: row
	move $a1, $s2		#argument 2: col
	li $a2, -1		#argument 3: -1
	li $a3, -1		#argument 4: -1
	jal count		#call count
	move $t3, $v0		#save count(row,col,-1,-1) at $t3
	
	beq $t3, $s7, win	#if count(row,col,-1,-1) == 1, go to win
	
	move $a0, $s0		#argument 1: row
	move $a1, $s2		#argument 2: col
	li $a2, 1		#argument 3: 1
	li $a3, -1		#argument 4: -1
	jal count		#call count
	move $t3, $v0		#save count(row,col,1,-1) at $t3
	
	beq $t3, $s7, win	#if count(row,col,1,-1) == 1, go to win
	
	move $a0, $s0		#argument 1: row
	move $a1, $s2		#argument 2: col
	li $a2, 0		#argument 3: 0
	li $a3, -1		#argument 4: -1
	jal count		#call count
	move $t3, $v0		#save count(row,col,0,-1) at $t3
	
	beq $t3, $s7, win	#if count(row,col,0,-1) == 1, go to win
	
	move $v0, $s6		#return 0
	
	#pop $ra, $t3, $t2, $s3, $s2, $s0 from stack
	lw $ra, 0($sp)
	addi $sp, $sp, 4
	lw $t3, 0($sp)
	addi $sp, $sp, 4
	lw $t2, 0($sp)
	addi $sp, $sp, 4
	lw $s3, 0($sp)
	addi $sp, $sp, 4
	lw $s2, 0($sp)
	addi $sp, $sp, 4
	lw $s0, 0($sp)
	addi $sp, $sp, 4
	
	jr $ra			#return from function
	
win:
	sw $s3, winner		#save player char in winner
	move $v0, $s7		#return 1
	
	#pop $ra, $t3, $t2, $s3, $s2, $s0 from stack
	lw $ra, 0($sp)
	addi $sp, $sp, 4
	lw $t3, 0($sp)
	addi $sp, $sp, 4
	lw $t2, 0($sp)
	addi $sp, $sp, 4
	lw $s3, 0($sp)
	addi $sp, $sp, 4
	lw $s2, 0($sp)
	addi $sp, $sp, 4
	lw $s0, 0($sp)
	addi $sp, $sp, 4
	
	jr $ra			#return from function
count:
	#push $s0, $s1, $s2, $s3, $s4, $t2, $t3, $t4, $t5, $t6, $ra to stack
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
	sw $t2, 0($sp)
	addi $sp, $sp, -4
	sw $t3, 0($sp)
	addi $sp, $sp, -4
	sw $t4, 0($sp)
	addi $sp, $sp, -4
	sw $t5, 0($sp)
	addi $sp, $sp, -4
	sw $t6, 0($sp)
	addi $sp, $sp, -4
	sw $ra, 0($sp)
	
	li $s0, 0		#$s0 = count = 0
	add $s1, $a0, $a2	#$s1 = x = i+di
	add $s2, $a1, $a3	#$s2 = y = j+dj
	
	la $t0, myArray	#load base address of myArray
	li $t2, 9		#$t2 = 9
	mul $t2, $t2, $a0	#$t2 = 9*(i)
	add $t2, $t2, $a1	#$t2 = 9*(i)+j
	add $t2, $t0, $t2	#$t2 = base address + 9*i + j = address of myArray[i][j]
	lb $s3, 0($t2)		#$s3 = char player = myArray[row][col]
	
	li $t4, -1		#$t4 = -1
	li $t5, 6		#$t5 = 6
	li $t6, 9		#$t6 = 9
	
firstWhile:
	ble $s1, $t4, reset	#if i+di<=-1, go to reset
	ble $s2, $t4, reset	#if j+dj<=-1, go to reset
	bge $s1, $t5, reset	#if i+di>=6, go to reset
	bge $s2, $t6, reset	#if j+dj>=9, go to reset
	
	la $t0, myArray	#load base address of myArray
	li $t3, 9		#$t3 = 9
	mul $t3, $t3, $s1	#$t3 = 9*(i+di)
	add $t3, $t3, $s2	#$t3 = 9*(i+di)+j+dj
	add $t3, $t0, $t3	#$t3 = base address + 9*(i+di) + (j+dj) = address of myArray[i+di][j+dj]
	lb $s4, 0($t3)		#$s4 = myArray[i+di][j+dj]

	bne $s4, $s3, secondWhile	#if myArray[i+di][j+dj] != player, go to reset
	addi $s0, $s0, 1	#count ++
	add $s1, $s1, $a2	#x+=di
	add $s2, $s2, $a3	#y+=dj
	
	j firstWhile		#go back to start of firstWhile

reset:
	sub $s1, $a0, $a2	#x=i-di
	sub $s2, $a1, $a3	#y=j-dj
	
secondWhile:
	ble $s1, $t4, endCount	#if i+di<=-1, go to endCount
	ble $s2, $t4, endCount	#if j+dj<=-1, go to endCount
	bge $s1, $t5, endCount	#if i+di>=6, go to endCount
	bge $s2, $t6, endCount	#if j+dj>=9, go to endCount
	
	la $t0, myArray	#load base address of myArray
	li $t3, 9		#$t3 = 9
	mul $t3, $t3, $s1	#$t3 = 9*(i-di)
	add $t3, $t3, $s2	#$t3 = 9*(i-di)+j-dj
	add $t3, $t0, $t3	#$t3 = base address + 9*(i-di) + (j-dj) = address of myArray[i-di][j-dj]
	lb $s4, 0($t3)		#$s4 = myArray[i-di][j-dj]
	
	bne $s4, $s3, endCount	#if myArray[i-di][j-dj] != player, go to endCount
	addi $s0, $s0, 1	#count ++
	sub $s1, $s1, $a2	#x-=di
	sub $s2, $s2, $a3	#y-=dj
	
	j secondWhile		#go back to start of firstWhile

endCount:
	li $s1, 3		#$s1 = 3
	bgt $s0, $s1, true	#if count > 3, go to true
	li $s6, 0		#$s6 = 0
	move $v0, $s6
	
	#pop $ra, $t6, $t5, $t4, $t3, $t2, $s4, $s3, $s2, $s1, $s0 from stack
	lw $ra, 0($sp)
	addi $sp, $sp, 4
	lw $t6, 0($sp)
	addi $sp, $sp, 4
	lw $t5, 0($sp)
	addi $sp, $sp, 4
	lw $t4, 0($sp)
	addi $sp, $sp, 4
	lw $t3, 0($sp)
	addi $sp, $sp, 4
	lw $t2, 0($sp)
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

true:
	li $s7, 1		#$s7 = 1
	move $v0, $s7
	
	#pop $ra, $t6, $t5, $t4, $t3, $t2, $s4, $s3, $s2, $s1, $s0 from stack
	lw $ra, 0($sp)
	addi $sp, $sp, 4
	lw $t6, 0($sp)
	addi $sp, $sp, 4
	lw $t5, 0($sp)
	addi $sp, $sp, 4
	lw $t4, 0($sp)
	addi $sp, $sp, 4
	lw $t3, 0($sp)
	addi $sp, $sp, 4
	lw $t2, 0($sp)
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
	

putToken:
	#push $s0, $s2, $s3, $t2, $t3, $t4, $ra to stack
	addi $sp, $sp, -4
	sw $s0, 0($sp)
	addi $sp, $sp, -4
	sw $s2, 0($sp)
	addi $sp, $sp, -4
	sw $s3, 0($sp)
	addi $sp, $sp, -4
	sw $t2, 0($sp)
	addi $sp, $sp, -4
	sw $t3, 0($sp)
	addi $sp, $sp, -4
	sw $t4, 0($sp)
	addi $sp, $sp, -4
	sw $ra, 0($sp)
	
	li $s0, 5		#i=5
	move $s2, $a0		#$s2 = char player
	move $s3, $a1		#$s3 = col
	li $s6, 0		#$s6 = 0
	li $s1, 9		#$s1 = 9
	
for6:
	blt $s0, $s6, endfor6	#if i<0, go to endfor6
	la $t0, myArray	#load base address of myArray
	mul $t2, $s1, $s0	#$t2 = 9*i
	add $t2, $t2, $s3	#$t2 = 9*i+col
	add $t2, $t0, $t2	#$t2 = base address + 9*i + col = address of myArray[i][col]
	lb $t3, 0($t2)		#$t3 = myArray[i][col]
	
	li $t4, '-'		#$t4 = '-'
	bne $t3, $t4, endif3	#if myArray[i][col] !='-', go to endif3
	sb $s2, 0($t2)		#put player char at myArray[i][col]
	j endfor6
endif3: 
	addi $s0, $s0, -1	#i--
	j for6			#jump back to start of for6
	
endfor6:
	move $v0, $s0		#return i
	
	#pop $ra, $t4, $t3, $t2, $s3, $s2, $s0 from stack
	lw $ra, 0($sp)
	addi $sp, $sp, 4
	lw $t4, 0($sp)
	addi $sp, $sp, 4
	lw $t3, 0($sp)
	addi $sp, $sp, 4
	lw $t2, 0($sp)
	addi $sp, $sp, 4
	lw $s3, 0($sp)
	addi $sp, $sp, 4
	lw $s2, 0($sp)
	addi $sp, $sp, 4
	lw $s0, 0($sp)
	addi $sp, $sp, 4
	
	jr $ra			#return from function
	
user_input:
	#push $s0, $s1, $s2, $t5, $ra to stack
	addi $sp, $sp, -4
	sw $s0, 0($sp)
	addi $sp, $sp, -4
	sw $s1, 0($sp)
	addi $sp, $sp, -4
	sw $s2, 0($sp)
	addi $sp, $sp, -4
	sw $t5, 0($sp)
	addi $sp, $sp, -4
	sw $ra, 0($sp)
	
	move $s0, $s6		#$s0 = valid = 0
	li $s7, 1		#$s7 = 1
while3:
	beq $s0, $s7, endwhile3	#if valid == 1, go to endwhile3
	
	li $v0, 4		#Syscall to print string.
	la $a0, prmt8		#load address of prmt8
	syscall		#printf("What column would you like to drop token into? Enter 1-7: ");
	
	li $v0, 5 		#take input integer
	syscall
	
	move $s2, $v0		#move the input integer to $s2
	blt $s2, $s7, wrongInput	#if input < 1, go to wrongInput
	li $t5, 7		#$t5=7
	bgt $s2, $t5, wrongInput	#if input > 7, go to wrongInput
	
	move $a0, $s2		#argument 1: input
	jal valCol		#call function valCol
	move $t5, $v0		#return value (valCol(col)) saves at $t5
	beq $t5, $s6, wrongInput	#if valCol(col)==0, go to wrongInput
	move $s0, $s7		#valid = 1
	
	j while3		#jump back to start of while3
	
wrongInput:
	li $v0, 4		#Syscall to print string.
	la $a0, prmt9		#load address of prmt9
	syscall		#printf("Wrong Input. Try Again.\n")
	
	j while3		#jump back to start of while3

endwhile3:	
	move $v0, $s2		#return col
	
	#pop $ra, $t5, $s2, $s1, $s0 from stack
	lw $ra, 0($sp)
	addi $sp, $sp, 4
	lw $t5, 0($sp)
	addi $sp, $sp, 4
	lw $s2, 0($sp)
	addi $sp, $sp, 4
	lw $s1, 0($sp)
	addi $sp, $sp, 4
	lw $s0, 0($sp)
	addi $sp, $sp, 4
	
	jr $ra			#return from function

valCol:
	#push $s0, $s1, $s2, $ra to stack
	addi $sp, $sp, -4
	sw $s0, 0($sp)
	addi $sp, $sp, -4
	sw $s1, 0($sp)
	addi $sp, $sp, -4
	sw $s2, 0($sp)
	addi $sp, $sp, -4
	sw $ra, 0($sp)
	
	move $s0, $a0		#$s0 = col 
	li $s1, '-'		#$s1 = '-'
	la $t0, myArray	#load base address of myArray
	add $s0, $t0, $s0	#$s0 = base address + col = address of myArray[0][col]
	lb $s2, 0($s0)		#$s2 = myArray[0][col]
	
	beq $s2, $s1, endif2	#if myArray[0][col] == '-' go to endif2
	
	move $v0, $s6		#return 0
	
	#pop $ra, $s2, $s1, $s0 from stack
	lw $ra, 0($sp)
	addi $sp, $sp, 4
	lw $s2, 0($sp)
	addi $sp, $sp, 4
	lw $s1, 0($sp)
	addi $sp, $sp, 4
	lw $s0, 0($sp)
	addi $sp, $sp, 4
	
	jr $ra			#return from function

endif2:
	move $v0, $s7		#return 1
	
	#pop $ra, $s2, $s1, $s0 from stack
	lw $ra, 0($sp)
	addi $sp, $sp, 4
	lw $s2, 0($sp)
	addi $sp, $sp, 4
	lw $s1, 0($sp)
	addi $sp, $sp, 4
	lw $s0, 0($sp)
	addi $sp, $sp, 4
	
	jr $ra			#return from function
		
print_board:
	#push $s2, $s3, $t2, $ra to stack
	addi $sp, $sp, -4
	sw $s2, 0($sp)
	addi $sp, $sp, -4
	sw $s3, 0($sp)
	addi $sp, $sp, -4
	sw $t2, 0($sp)
	addi $sp, $sp, -4
	sw $ra, 0($sp)
	
	li $v0, 4		#Syscall to print string.
	la $a0, board1		#load address of board1
	syscall		#print
	
	li $v0, 4		#Syscall to print string.
	la $a0, board2		#load address of prmt5
	syscall		#print
	li $s2, 0		#i=0
	
for4:	
	bge $s2, $s0, endfor4	#if i>=row, go to endfor4
	
	li $v0, 4		#Syscall to print string.
	la $a0, board4		#load address of board4
	syscall		#print
	
	li $s3, 0		#j=0
	
for5:	
	bge $s3, $s1, endfor5	#if j>=col, go to endfor5
	la $t0, myArray	#load base address of myArray
	mul $t2, $s1, $s2	#$t2 = 9*i
	add $t2, $t2, $s3	#$t2 = 9*i+j
	add $t2, $t0, $t2	#$t2 = base address + 9*i + j = address of myArray[i][j]
	
	li $v0, 11		#Syscall to print string
	lb $a0, 0($t2)		#load address of myArray[i][j] because char is 8 bit use lb
	syscall		#print myArray[i][j]
	
	li $v0, 11		#Syscall to print char
	li $a0, 32		#load address of space
	syscall		#print space
	
	addi $s3, $s3, 1	#j++
	j for5			#jump back to start of for5
	
endfor5:
	addi $s2, $s2, 1	#i++
	
	li $v0, 4		#Syscall to print string.
	la $a0, nl		#load address of new line
	syscall		#print new line
	
	j for4			#jump back to start of for4
	
endfor4:
	li $v0, 4		#Syscall to print string.
	la $a0, board3		#load address of board3
	syscall		#print "   -----------------\n\n"
	
	#pop $ra, $t2, $s3, $s2 from stack
	lw $ra, 0($sp)
	addi $sp, $sp, 4
	lw $t2, 0($sp)
	addi $sp, $sp, 4
	lw $s3, 0($sp)
	addi $sp, $sp, 4
	lw $s2, 0($sp)
	addi $sp, $sp, 4
	
	jr $ra			#return from function

random_in_range:
	#push $s0, $s1, $s2, $ra to stack
	addi $sp, $sp, -4
	sw $s0, 0($sp)
	addi $sp, $sp, -4
	sw $s1, 0($sp)
	addi $sp, $sp, -4
	sw $s2, 0($sp)
	addi $sp, $sp, -4
	sw $ra, 0($sp)
	
	#uint32_t range = high-low+1;
	subu $s0, $a1, $a0	#$s0 = high-low
	addiu $s0, $s0, 1	#$s0 = range = high-low+1
	
	#uint32_t rand_num = get_random();
	jal get_random		#jump to get_random
	move $s1, $v0		#return value saved in $v0 to $s1 == rand_num
	
	#return (rand_num % range) + low;
	divu $s1, $s0		#hi = rand_num % range
	mfhi $s2		#$s2 = hi = rand_num % range
	addu $s2, $s2, $a0	#$s2 = rand_num % range + low
	move $v0, $s2		#save the return value at $v0
	
	#pop $ra, $s2, $s1, $s0 from stack
	lw $ra, 0($sp)
	addi $sp, $sp, 4
	lw $s2, 0($sp)
	addi $sp, $sp, 4
	lw $s1, 0($sp)
	addi $sp, $sp, 4
	lw $s0, 0($sp)
	addi $sp, $sp, 4
	
	jr $ra			#return from function

get_random:
	#push $s0, $s1, $t0, $t1, $ra to stack
	addi $sp, $sp, -4
	sw $s0, 0($sp)
	addi $sp, $sp, -4
	sw $s1, 0($sp)
	addi $sp, $sp, -4
	sw $t0, 0($sp)
	addi $sp, $sp, -4
	sw $t1, 0($sp)
	addi $sp, $sp, -4
	sw $ra, 0($sp)
	
	lw $s0, m_w		#load m_w to $s0
	lw $s1, m_z		#load m_z to $s1
	
	andi $t0, $s1, 65535	#$t0 = m_z & 65535
	li $t1, 36969		#$t1 = 36969
	mul $t1, $t1, $t0	#$t1 = 36969 * (m_z & 65535)
	srl $t0, $s1, 16	#$t0 = m_z >> 16
	addu $s1, $t1, $t0	#$s1 = m_z = 36969 * (m_z & 65535) + (m_z >> 16)
	sw $s1, m_z		#store value of m_z to label m_z
	
	andi $t0, $s0, 65535	#$t0 = m_w & 65535
	li $t1, 18000		#$t1 = 18000
	mul $t1, $t1, $t0	#$t1 = 18000 * (m_w & 65535)
	srl $t0, $s0, 16	#$t0 = m_w >> 16
	addu $s0, $t1, $t0	#$s0 = m_w = 18000 * (m_w & 65536) + (m_w >> 16)
	sw $s0, m_w		#store value of m_w to label m_w
	
	sll $t0, $s1, 16	#$t0 = m_z << 16
	addu $t1, $t0, $s0	#$t1 = result = (m_z << 16) + m_w
	
	move $v0, $t1		#save the return value at $v0
	
	#pop $ra, $t1, $t0, $s1, $s0 from stack
	lw $ra, 0($sp)
	addi $sp, $sp, 4
	lw $t1, 0($sp)
	addi $sp, $sp, 4
	lw $t0, 0($sp)
	addi $sp, $sp, 4
	lw $s1, 0($sp)
	addi $sp, $sp, 4
	lw $s0, 0($sp)
	addi $sp, $sp, 4
	
	jr $ra			#return from function

.data
myArray: .space 54
m_w:	.word 50000
m_z:	.word 60000
winner:	.word 'n'
nl:	.asciiz "\n"
prmt1:	.asciiz "Welcome to Connect Four, Five-in-a-Row variant!\n"
prmt2:	.asciiz "\nEnter two positive numbers to initialize the random number generator.\n"
prmt3:	.asciiz "Number 1: "
prmt4:	.asciiz "Number 2: "
prmt5:	.asciiz "\nHuman player (H) or Computer player (C)\nCoin toss... "
prmt6:	.asciiz "HUMAN goes first\n"
prmt7:	.asciiz "COMPUTER goes first\n"
prmt8:	.asciiz "What column would you like to drop token into? Enter 1-7: "
prmt9:	.asciiz "Wrong Input. Try Again.\n"
prmt10:	.asciiz "Computer player selected column "
prmt11:	.asciiz "Congratulations, You Won!\n"
prmt12:	.asciiz "Booooo, You Lost!\n"
prmt13:	.asciiz "Tie!\n"
board1:	.asciiz "\n     1 2 3 4 5 6 7  \n"
board2:	.asciiz "   -----------------\n"
board3:	.asciiz "   -----------------\n\n"
board4:	.asciiz "   "

