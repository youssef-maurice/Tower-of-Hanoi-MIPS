
.data
ask_user: 	.asciiz "Enter number of disks "
step:		.asciiz "Step "
move_disk: 	.asciiz ": move disk "
from: 		.asciiz " from "
to: 		.asciiz " to "
A:		.asciiz "A"
B:		.asciiz "B"
C:		.asciiz "C"
new_line:	.asciiz "\n"

.text
main:	la $a0, ask_user
	jal printStr #ask user for number of disks
	jal readInt #get from user number of disks
	move $a0, $v0 #store n in a0 -> number of disks
	lb $a1, A #store A in a1 -> source
	lb $a2, C #store C in a2 -> target
	lb $a3, B #store B in a3 -> auxiliary
	addi $t0, $zero, 0 #initialize counter for number of steps
	jal hanoi #jump to hanoi
	li $v0, 10 #terminate program
	syscall
	
hanoi:	addi $sp, $sp, -20 #make room in stack
	#store registers on stack
	sw $ra, 0($sp)
	sw $s0, 4($sp)
	sw $s1, 8($sp)
	sw $s2, 12($sp)
	sw $s3, 16($sp)
	la $s0, ($a0) #store a0 in s0 (number of disks)
	la $s1, ($a1) #store a1 in s1
	la $s2, ($a2) #store a2 in s2
	la $s3, ($a3) #store a3 in s3
	beqz $a0, EXIT #if there are no more disks go to EXIT
#MOVE(n - 1, source, auxiliary, target)		
	subi $a0, $a0, 1 #decrease number of disks
	#store contents of a3 in a2 and vice-versa because we want to switch the parameteres for the recursion
	la $a2, ($a3)
	la $a3, ($s2)
	jal hanoi #call hanoi recursively
#Print "move disk n from source to target"	
	addi $t0, $t0, 1 #increase steps counter
	la $a0, step 
	jal printStr #print "Step "
	addi $a0, $t0, 0 
	jal printInt #print steps counter
	la $a0, move_disk
	jal printStr #print ": move disk "
	la $a0, ($s0)
	jal printInt #print disk number
	la $a0, from 
	jal printStr #print " from "
	la $a0, ($s1)
	jal printChar #print starting point
	la $a0, to
	jal printStr #print "to "
	la $a0, ($s2)
	jal printChar #print destination
	la $a0, new_line
	jal printStr #go to a new line 
#MOVE(n - 1, auxiliary, target, source)	
	subi $a0, $s0, 1 #decrease number of disks
	#store contents of a3 in a1 and vice-versa because we want to switch the parameteres for the recursion
	la $a1, ($s3)
	la $a2, ($s2)
	la $a3, ($s1)
	jal hanoi #call hanoi recursively

EXIT:	lw $ra, 0($sp)
	lw $s0, 4($sp)
	lw $s1, 8($sp)
	lw $s2, 12($sp)
	lw $s3, 16($sp)
	addi $sp, $sp, 20 #restore stack
	jr $ra #return to main 
		
########### Helper functions for IO ###########

# read an integer
# int readInt()
readInt:
	li $v0, 5
	syscall
	jr $ra
	
# print an integer
# printInt(int n)
printInt:
	li $v0, 1
	syscall
	jr $ra

# print a character
# printChar(char c)
printChar:
	li $v0, 11
	syscall
	jr $ra
	
# print a null-ended string
# printStr(char *s)
printStr:
	li $v0, 4
	syscall
	jr $ra
