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
	addi $sp, $sp, -16
	sw   $s0, 0($sp)
	sw   $s1, 4($sp)
	sw   $s2, 8($sp)
	sw   $ra, 12($sp)

	# Prompt user to input day
	la   $a0, prompt1
	addi $v0, $zero, 4
	syscall

	# Input day
	la   $a0, day
	addi $a1, $zero, 3
	addi $v0, $zero, 8
	syscall

	# Prompt user to input month
	la   $a0, prompt2
	addi $v0, $zero, 4
	syscall

	# Input month
	la   $a0, month
	addi $a1, $zero, 3
	addi $v0, $zero, 8
	syscall

	# Prompt user to input year
	la   $a0, prompt3
	addi $v0, $zero, 4
	syscall

	# Input year
	la   $a0, year
	addi $a1, $zero, 5
	addi $v0, $zero, 8
	syscall

InputDate_while:
	# Find the length of inputted 'year' string
	la   $a0, year
	addi $a1, $zero, 5
	jal  StringLength
	add  $s0, $v0, $zero

	# Check if the inputted 'year' is a number
	la   $a0, year
	add  $a1, $s0, $zero
	jal  CheckInput
	beq  $v0, $zero, InputDate_error

	# Convert 'year' from string to int
	la   $a0, year
	add  $a1, $s0, $zero
	jal  StrToInt
	add  $s0, $v0, $zero



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



	lw   $s0, 0($sp)
	lw   $s1, 4($sp)
	lw   $s2, 8($sp)
	lw   $ra, 12($sp)
	addi $sp, $sp, 16
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
# $a0: string's address
# $a1: string's length
	.data
	.text
CheckInput:
	addi $v0, $zero, 1     # Return value
	add  $t0, $zero, $zero # $t0 = Variable i
CheckInput_while:
	# If i is not less than string's length, return
	slt  $t1, $t0, $a1
	beq  $t1, $zero, CheckInput_return

	# Get and store string[i] in $t1
	add  $t1, $t0, $zero
	add  $t1, $t1, $a0
	lb   $t1, 0($t1)

	# If string[i] is less than the decimal value of char '0', return false
	addi $t2, $zero, 48
	slt  $t3, $t1, $t2
	bne  $t3, $zero, CheckInput_setFalse

	# If string[i] is greater than the decimal value of char '9', return false
	addi $t2, $zero, 57
	slt  $t3, $t2, $t1
	bne  $t3, $zero, CheckInput_setFalse

	# Increase variable i by 1
	addi $t0, $t0, 1

	j    CheckInput_while
CheckInput_setFalse:
	add  $v0, $zero, $zero
CheckInput_return:
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
	# If i is not less than string's capacity, return
	slt  $t1, $t0, $a1
	beq  $t1, $zero, StringLength_return

	# Get and store string[i] in $t1
	add  $t1, $t0, $zero
	add  $t1, $t1, $a0
	lb   $t1, 0($t1)

	beq  $t1, $zero, StringLength_return # If string[i] == '\0', return
	addi $t2, $zero, 10                  # $t2 = decimal value of char '\n'
	beq  $t1, $t2, StringLength_return   # If string[i] == '\n', return

	# Increase string's length count and variable i by 1
	addi $v0, $v0, 1
	addi $t0, $t0, 1

	j    StringLength_while
StringLength_return:
	jr   $ra

########################################
	.data
	.text
StrToInt:
	jr   $ra
