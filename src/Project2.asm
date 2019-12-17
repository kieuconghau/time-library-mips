# Main routine
	.data
TIME: .space 20
	.text
	.globl Main
Main:
	la   $a0, TIME
	jal  InputDate

	add  $a0, $v0, $zero
	addi $v0, $zero, 4
	syscall

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
# Store day, month and year in string TIME
# $a0: day in number
# $a1: month in number
# $a2: year in number
# $a3: address of string TIME
	.data
	.text
Date:
	addi $sp, $sp, -24 # Leave 8 bytes for the converted string
	sw   $a0, 8($sp)
	sw   $a1, 12($sp)
	sw   $ra, 16($sp)
	sw   $s0, 20($sp)

	add  $s0, $zero, $zero # $s0: Next position to be inserted in TIME

# Insert day
	# Convert day from int to string form
	lw   $a0, 8($sp)
	addi $a1, $sp, 0
	jal  IntToStr
	add  $t0, $v0, $zero

	add  $t1, $zero, $zero # $t1: Position of next char to be retrieved from day string

	# Check if day < 10 (i.e. day has 1 digit)
	lw   $t2, 8($sp)
	slti $t3, $t2, 10
	beq  $t3, $zero, Date_insertDay

	# If it's true, insert a 0 at the beginning.
	add  $t2, $a3, $s0
	sb   $zero, 0($t2)
	addi $s0, $s0, 1

Date_insertDay:
	# Read the next unread char in day string
	add  $t2, $t0, $t1
	lb   $t2, 0($t2)

	# If it's null char (i.e. the end of day string is reached), break.
	beq  $t2, $zero, Date_endInsertDay

	# Else, copy the char into TIME string
	add  $t3, $a3, $s0
	sb   $t2, 0($t3)

	# Move to next position of TIME and day strings
	addi $s0, $s0, 1
	addi $t1, $t1, 1
	j    Date_insertDay

Date_endInsertDay:
	# Insert char '/'
	add  $t0, $a3, $s0
	addi $t1, $zero, 47
	sb   $t1, 0($t0)
	addi $s0, $s0, 1

# Insert month
	# Convert month from int to string form
	lw   $a0, 12($sp)
	addi $a1, $sp, 0
	jal  IntToStr
	add  $t0, $v0, $zero

	add  $t1, $zero, $zero # $t1: Position of next char to be retrieved from month string

	# Check if month < 10 (i.e. month has 1 digit)
	lw   $t2, 12($sp)
	slti $t3, $t2, 10
	beq  $t3, $zero, Date_insertMonth

	# If it's true, insert a 0 at the beginning.
	add  $t2, $a3, $s0
	sb   $zero, 0($t2)
	addi $s0, $s0, 1

Date_insertMonth:
	# Read the next unread char in month string
	add  $t2, $t0, $t1
	lb   $t2, 0($t2)

	# If it's null char (i.e. the end of month string is reached), break.
	beq  $t2, $zero, Date_endInsertMonth

	# Else, copy the char into TIME string
	add  $t3, $a3, $s0
	sb   $t2, 0($t3)

	# Move to next position of TIME and month strings
	addi $s0, $s0, 1
	addi $t1, $t1, 1
	j    Date_insertMonth

Date_endInsertMonth:
	# Insert char '/'
	add  $t0, $a3, $s0
	addi $t1, $zero, 47
	sb   $t1, 0($t0)
	addi $s0, $s0, 1

# Insert year
	# Convert year from int to string form
	add  $a0, $a2, $zero
	addi $a1, $sp, 0
	jal  IntToStr
	add  $t0, $v0, $zero

	add  $t1, $zero, $zero # $t1: Position of next char to be retrieved from year string

	addi $t2, $zero, 1000
Date_fillZeroBeforeYear:
	# Check if year < $t2 (i.e. year has less than (log($t2) + 1) digit)
	slt  $t3, $a2, $t2
	beq  $t3, $zero, Date_insertYear

	# If it's true, insert a 0 at the beginning.
	add  $t3, $a3, $s0
	sb   $zero, 0($t3)
	addi $s0, $s0, 1

	addi $t3, $zero, 10
	div  $t2, $t3
	mflo $t2
	j    Date_fillZeroBeforeYear

Date_insertYear:
	# Read the next unread char in year string
	add  $t2, $t0, $t1
	lb   $t2, 0($t2)

	# If it's null char (i.e. the end of year string is reached), break.
	beq  $t2, $zero, Date_endInsertYear

	# Else, copy the char into TIME string
	add  $t3, $a3, $s0
	sb   $t2, 0($t3)

	# Move to next position of TIME and year strings
	addi $s0, $s0, 1
	addi $t1, $t1, 1
	j    Date_insertYear

Date_endInsertYear:
	# Insert null char
	add  $t0, $a3, $s0
	sb   $zero, 0($t0)

# Return
	add  $v0, $a3, $zero

	lw   $ra, 16($sp)
	lw   $s0, 20($sp)
	addi $sp, $sp, 24
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
	addi $v0, $zero, 1

	beq  $a0, $zero, CheckMonth_setFalse

	addi $t0, $zero, 12
	slt  $t1, $t0, $a0
	bne  $t1, $zero, CheckMonth_setFalse

	j    CheckMonth_return

CheckMonth_setFalse:
	add  $v0, $zero, $zero

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
# Convert non-negative integer to string
# $a0: non-negative integer
# $a1: address of output string
	.data
	.text
# Method:
# Step 1:
# Get each digit of the integer from right to left,
# and store them in a temporary string from left to right.
# Step 2:
# Get each character in the temp string from right to left,
# and store them in the output string from left to right.
IntToStr:
	# Store existed data in saved registers to stack
	addi $sp, $sp, -20
	sw   $s0, 0($sp)
	sw   $s1, 4($sp)
	sw   $s2, 8($sp)
	sw   $s3, 12($sp)
	sw   $s4, 16($sp)

	add  $s0, $a0, $zero # $s0: the input integer
	add  $s1, $a1, $zero # $s1: address of output string

	# Count the number of digits of the integer
	add  $a0, $s0, $zero
	jal  CountDigit

	# Find the number of bytes needed to allocate for the temp string.
	# It must be the lowest multiple of 4 which is greater than
	# the number of digits of the integer.
	# Method: Divide the number of digits by 4, get its ceiling,
	# and multiply the ceiling by 4.
	addi $t0, $zero, 4
	div  $v0, $t0
	mflo $t0
	mfhi $t1
	beq  $t1, $zero, IntToStr_jump
	addi $t0, $t0, 1
IntToStr_jump:
	addi $t1, $zero, 4
	mul  $t0, $t0, $t1
	# $t0 now stores the number of bytes needed for allocation

	# Allocate memory for temp string
	sub  $sp, $sp, $t0
	add  $s3, $sp, $zero # $s3: address of temp string

	# Store the number of allocated bytes in stack
	addi $sp, $sp, -4
	sw   $t0, 0($sp)

# Perform Step 1.
	add  $s4, $zero, $zero # $s4: next position to be inserted in temp string
IntToStr_convert:
	add  $t0, $s3, $s4     # $t0: Address of next pos to be inserted

	addi $t1, $zero, 10
	div  $s0, $t1          # Divide integer by 10
	mflo $s0               # Store the quotient back to integer
	mfhi $t1               # Store the remainder to $t1
	                       # $t1 now stores the lowest digit in the current integer.

	addi $t1, $t1, 48      # Increase the digit by 48
	                       # to convert it to a character
	sb   $t1, 0($t0)       # Insert the character into the temp string

	addi $s4, $s4, 1       # Move to next pos to be inserted in temp string

	bne  $s0, $zero, IntToStr_convert # If integer is still greater than 0, repeat.

# Perform Step 2.
	add  $s2, $zero, $zero # $s2: next position to be inserted in output string
IntToStr_revert:
	beq  $s4, $zero, IntToStr_endRevert # If all char in temp string are read, break

	addi $s4, $s4, -1      # Move to position of the char to be read in temp string
	add  $t0, $s3, $s4     # $t0: Address of the position of the char to be read
	lb   $t0, 0($t0)       # Read character and store it in $t0

	add  $t1, $s1, $s2     # $t1: Address of next pos to be inserted in output string
	sb   $t0, 0($t1)       # Insert the read character into output string

	addi $s2, $s2, 1       # Move to next pos to be inserted in output string

	j    IntToStr_revert

IntToStr_endRevert:
	# Insert null char
	add  $t1, $s1, $s2
	sb   $zero, 0($t1)

	lw   $t0, 0($sp)   # Load the number of bytes allocated for temp string from stack
	addi $sp, $sp, 4
	add  $sp, $sp, $t0 # Deallocate memory of temp string

	# Restore saved registers to original state
	lw   $s0, 0($sp)
	lw   $s1, 4($sp)
	lw   $s2, 8($sp)
	lw   $s3, 12($sp)
	lw   $s4, 16($sp)
	addi $sp, $sp, 20

	add  $v0, $s1, $zero # Return the address of output string
	jr   $ra

########################################
# Count the number of digits of a non-negative number
# $a0: non-negative number
	.data
	.text
CountDigit:
	addi $v0, $zero, 1
	addi $t0, $zero, 10

CountDigit_while:
	slt  $t1, $a0, $t0
	bne  $t1, $zero, CountDigit_return

	addi $t1, $zero, 10
	mul  $t0, $t0, $t1

	addi $v0, $v0, 1

	j    CountDigit_while

CountDigit_return:
	jr   $ra

##### int StrToInt(char* str_input, int n)
# Written by KCH
StrToInt:
						# $a0: str_input (char*)
						# $a1: n (int)
	addi $v0, $zero, 0			# $v0: result = 0
	addi $t0, $zero, 0			# $t0: i = 0
	
	StrToInt_loop:
	slt  $t1, $t0, $a1
	beq  $t1, $zero, StrToInt_end		# if i >= n then exit loop
	
	add  $t1, $a0, $t0			# str_input + i
	lb   $t1, 0($t1)			# $t1: str_input[i]
	
	addi $t2, $zero, 10
	mul  $v0, $v0, $t2			# result *= 10
	addi $t1, $t1, -48			# str_input[i] -= '0'
	add  $v0, $v0, $t1			# result += str_input[i]
	
	addi $t0, $t0, 1			# ++i
	j    StrToInt_loop
	
	StrToInt_end:
	jr   $ra

##### int IsLeap(int year)
# Written by KCH
IsLeap:
						# $a0: year (int)
	addi $t0, $zero, 400			# $t0: temp0 = 400
	div  $a0, $t0
	mfhi $t0				# $t0: temp0 = year % 400
	beq  $t0, $zero, IsLeap_return_1	# if temp0 == 0 then return 1
	
	addi $t0, $zero, 100			# $t0: temp0 = 100
	div  $a0, $t0				
	mfhi $t0				# $t0: temp0 = year % 100
	beq  $t0, $zero, IsLeap_return_0	# if temp0 == 0 then return 0
	
	addi $t0, $zero, 4			# $t0: temp0 = 4
	div  $a0, $t0
	mfhi $t0				# $t0: temp0 = year % 4
	beq  $t0, $zero, IsLeap_return_1	# if temp0 == 0 then return 1
	
	IsLeap_return_0:			# return 0
	addi $v0, $zero, 0
	jr   $ra
	
	IsLeap_return_1:			# return 1
	addi $v0, $zero, 1
	jr   $ra
