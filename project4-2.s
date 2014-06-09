	.data
str1:	.asciiz "Enter a positive hexadecimal integer(leave blank to exit):\n"
str2:	.asciiz "The corresponding octal number is:\n"
strerr:	.asciiz "Error.\n"
n1:	.asciiz "\n"

buffer:	.byte 0:50
buff1:	.byte 0:50

	.text
main:	addiu $t0, $zero, 10	#loads newline character into $t0

for1:	addi $v0, $zero, 4	#print prompt
	la $a0, str1
	syscall
	
	addi $v0, $zero,8	#read in string
	la $a0, buffer
	addi $a1, $zero, 50
	syscall
	la $s0, buffer

	lbu $t1, 0($s0)		#checks for empty string
	beq $t1, $t0, exit

for2:	lbu $t1, 0($s0)
	beq $t1, $t0, end1
	
	sltiu $t2, $t1, 48
	bne $t2, $zero, error
	sltiu $t2, $t1, 58
	bne $t2, $zero, incr
	sltiu $t2, $t1, 97
	bne $t2, $zero, error
	sltiu $t2, $t1, 103
	beq $t2, $zero, error
incr:	addi $s0, $s0, 1
	j for2
	
	
end1:	add $s1, $zero, $zero
	addi $s2, $zero, 16
	la $s0, buffer
for3:	lbu $t1, 0($s0)
	beq $t1, $t0, end2
	sltiu $t2, $t1, 58
	bne $t2, $zero, num1
	addiu $t3, $t1, -87
	mult $s1, $s2
	mflo $s1
	add $s1, $s1, $t3
	j incr2
num1:	addiu $t3, $t1, -48
	mult $s1, $s2
	mflo $s1
	add $s1, $s1, $t3
incr2:	addi $s0, $s0, 1
	j for3	

end2:	add $t1, $zero, $s1
	addi $s7, $zero, -1
	addi $s2, $zero, 8
	la $s0, buffer
for4:	beq $t1, $zero, end3
	div $t1, $s2
	mfhi $t2
	mflo $t1
	addi $t3, $t2, 48
	sb $t3, 0($s0)
	addi $s7, $s7, 1
	addi $s0, $s0, 1
	j for4

end3:	la $s0, buffer
	la $s1, buff1
	addi $t7, $s0, -1
	add $s0, $s0, $s7
rever:	beq $s0, $t7, finish
	lbu $t5, 0($s0)
	sb $t5, 0($s1)
	addi $s1, $s1, 1
	addi $s0, $s0, -1
	j rever	
	
finish:	addi $v0, $zero, 4
	la $a0, buff1
	syscall

	addi $v0, $zero, 4
	la $a0, n1
	syscall
	
	j for1

error:	addi $v0, $zero, 4
	la $a0, strerr
	syscall

	j for1

exit:	addi $v0, $zero, 10
	syscall
