# Main routine
	.data
	.text
	.globl Main
Main:
	jal InputDate
	
	# Exit
	addi $v0, $zero, 10
	syscall

########################################
# Prompt user to input date, check its validity, and store it.
	.data
prompt1: .asciiz "Nhap ngay DAY: "
prompt2: .asciiz "Nhap thang MONTH: "
prompt3: .asciiz "Nhap nam YEAR: "
day:     .space 3
month:   .space 3
year:    .space 5
	.text
InputDate:
	# Input day
	la   $a0, prompt1
	addi $v0, $zero, 4
	syscall

	la   $a0, day
	addi $a1, $zero, 3
	addi $v0, $zero, 8
	syscall

	# Input month
	la   $a0, prompt2
	addi $v0, $zero, 4
	syscall

	la   $a0, month
	addi $a1, $zero, 3
	addi $v0, $zero, 8
	syscall

	# Input year
	la   $a0, prompt3
	addi $v0, $zero, 4
	syscall

	la   $a0, year
	addi $a1, $zero, 5
	addi $v0, $zero, 8
	syscall

InputDate_while1:

#	la   $a0, year
#	addi $a1, $zero, 4
#	jal  CheckYear
#	beq  $v0, $zero, InputDate_error

#	la   $a0, year
#	addi $a1, $zero, 4
#	jal  CheckYear
#	beq  $v0, $zero, InputDate_error

#	la   $a0, year
#	addi $a1, $zero, 4
#	jal  CheckYear
#	beq  $v0, $zero, InputDate_error

InputDate_error:

	jr   $ra

########################################
# Check day validity
	.data
	.text
CheckDay:
	
	
	jr   $ra

########################################
# Check month validity
	.data
	.text
CheckMonth:
	
	
	jr   $ra

########################################
# Check year validity
	.data
	.text
CheckYear:
	
	
	jr   $ra

########################################
# Check input number validity
	.data
	.text
CheckInput:
	
	
	jr   $ra

########################################
# Find string's actual length
# $a0: string's address
# $a1: string's capacity
	.data
	.text
StringLength:
	add  $v0, $zero, $zero # String's length count
	add  $t0, $zero, $zero # $t0 = Variable i
StringLength_while:
	# If i is not less than string's capacity, returns
	slt  $t1, $t0, $a1
	beq  $t1, $zero, StringLength_return

	# If string[i] == '\0', returns
	sll  $t1, $t0, 2
	add  $t1, $t1, $a0
	lw   $t1, 0($t1)
	beq  $t1, $zero, StringLength_return

	# Increase string's length count and variable i by 1
	addi $v0, $v0, 1
	addi $t0, $t0, 1

	j    StringLength_while
StringLength_return:
	jr   $ra
