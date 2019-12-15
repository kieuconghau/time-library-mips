# Main routine
	.data
TIME: .space 10
	.text
	.globl Main
Main:
	la   $a0, TIME
	jal  InputDate

	# Exit
	addi $v0, $zero, 10
	syscall

########################################
# Prompt user to input date, check its validity, and store it.
	.data
prompt1: .asciiz "Nhap ngay DAY: "
prompt2: .asciiz "Nhap thang MONTH: "
prompt3: .asciiz "Nhap nam YEAR: "
error:   .asciiz "Error: Invalid input."
day:     .space 3
month:   .space 3
year:    .space 5
	.text
InputDate:
	addi $sp, $sp, -20
	sw   $a0, 0($sp)
	sw   $ra, 4($sp)
	sw   $s0, 8($sp)
	sw   $s1, 12($sp)
	sw   $s2, 16($sp)

InputDate_input:
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


	# Find the length of inputted 'month' string
	la   $a0, month
	addi $a1, $zero, 3
	jal  StringLength
	add  $s1, $v0, $zero

	# Check if the inputted 'month' is a number
	la   $a0, month
	add  $a1, $s1, $zero
	jal  CheckInput
	beq  $v0, $zero, InputDate_error

	# Convert 'month' from string to int
	la   $a0, month
	add  $a1, $s1, $zero
	jal  StrToInt
	add  $s1, $v0, $zero

	# Check if 'month' is a valid month
	add  $a0, $s1, $zero
	jal  CheckMonth
	beq  $v0, $zero, InputDate_error


	# Find the length of inputted 'day' string
	la   $a0, day
	addi $a1, $zero, 3
	jal  StringLength
	add  $s2, $v0, $zero

	# Check if the inputted 'day' is a number
	la   $a0, day
	add  $a1, $s2, $zero
	jal  CheckInput
	beq  $v0, $zero, InputDate_error

	# Convert 'day' from string to int
	la   $a0, day
	add  $a1, $s2, $zero
	jal  StrToInt
	add  $s2, $v0, $zero

	# Check if 'day' is a valid day
	add  $a0, $s2, $zero
	add  $a1, $s1, $zero
	add  $a2, $s0, $zero
	jal  CheckDay
	beq  $v0, $zero, InputDate_error

	j    InputDate_store

InputDate_error:
	# Print error message
	la   $a0, error
	addi $v0, $zero, 4
	syscall

	j    InputDate_input

InputDate_store:
	# Load TIME address from stack
	lw   $a0, 0($sp)
	add  $t0, $a0, $zero

	# Call Date routine
	add  $a0, $s2, $zero
	add  $a1, $s1, $zero
	add  $a2, $s0, $zero
	add  $a3, $t0, $zero
	jal  Date
	add  $v0, $v0, $zero

	# Restore $ra, $s0, $s1, $s2 and $sp
	lw   $ra, 4($sp)
	lw   $s0, 8($sp)
	lw   $s1, 12($sp)
	lw   $s2, 16($sp)
	addi $sp, $sp, 20

	# Return
	jr   $ra

########################################
	.data
	.text
Date:
	jr   $ra

########################################
# Check day validity
# $a0: day in number
# $a1: month in number
# $a2: year in number
	.data
day_in_month: .word 31, 28, 31, 30, 31, 30, 31, 31, 30, 31, 30, 31
	.text
CheckDay:
	addi $sp, $sp, -8
	sw   $a0, 0($sp)
	sw   $ra, 4($sp)

	beq  $a0, $zero, CheckDay_setFalse # If day == 0, return false

	# Check leap year
	add  $a0, $a2, $zero
	jal  IsLeap
	add  $t0, $v0, $zero

	lw   $a0, 0($sp)   # Load day from stack
	addi $v0, $zero, 1 # Initialize return value = true

	beq  $t0, $zero, CheckDay_normalCase # Case year is not leap

	addi $t0, $zero, 2
	bne  $a1, $t0, CheckDay_normalCase # Case month is not February

	# Case year is leap, and month is February
	addi $t0, $zero, 29
	slt  $t1, $t0, $a0
	bne  $t1, $zero, CheckDay_setFalse

	j    CheckDay_return

CheckDay_normalCase:
	la   $t0, day_in_month # $t0 = address of day_in_month array
	addi $t1, $a1, -1      # $t1 = month - 1
	sll  $t1, $t1, 2
	add  $t1, $t1, $t0
	lw   $t1, 0($t1)       # $t1 = day_in_month[month - 1]

	# Check if day > day_in_month[month - 1]
	slt  $t0, $t1, $a0
	beq  $t0, $zero, CheckDay_return

CheckDay_setFalse:
	add  $v0, $zero, $zero

CheckDay_return:
	lw   $ra, 4($sp)
	addi $sp, $sp, 8
	jr   $ra

########################################
# Check month validity
# $a0: month in number
	.data
	.text
CheckMonth:
	add  $v0, $zero, $zero
	addi $t0, $zero, 12
	slt  $t1, $t0, $a0
	beq  $t1, $zero, CheckMonth_return
	addi $v0, $zero, 1
CheckMonth_return:
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

########################################
	.data
	.text
IsLeap:
	jr   $ra
