# Main routine
	.data
request:   .asciiz "----------Choose one of the following functions-----------------\n"
func_1:    .asciiz "\t1. Print string TIME with format DD/MM/YYYY\n"
func_2:    .asciiz "\t2. Convert string TIME into one of the following formats:\n"
func_2A:   .asciiz "\t\tA. MM/DD/YYYY\n"
func_2B:   .asciiz "\t\tB. Month DD, YYYY\n"
func_2C:   .asciiz "\t\tC. DD Month, YYYY\n"
func_3:    .asciiz "\t3. Show the date of the week for the inputted date\n"
func_4:    .asciiz "\t4. Check if the year in string TIME is a leap year\n"
func_5:    .asciiz "\t5. Input another date called TIME_2 and show the time interval (in years) between TIME and TIME_2\n"
func_6:    .asciiz "\t6. Show the two nearest leap years of the year in string TIME\n"
separator: .asciiz "----------------------------------------------------------------\n"
choice:    .asciiz "Choice: "
result:    .asciiz "Result: "
invalid_choice: .asciiz "Invalid choice.\nRe-enter choice: "
	.text
	.globl Main
Main:
	# Allocate 20 bytes for string TIME, and 4 bytes for string of user choice
	addi $sp, $sp, -24

	# Input date
	addi $a0, $sp, 0
	jal  InputDate

	# Print the instructions
	la   $a0, request
	addi $v0, $zero, 4
	syscall

	la   $a0, func_1
	addi $v0, $zero, 4
	syscall

	la   $a0, func_2
	addi $v0, $zero, 4
	syscall

	la   $a0, func_2A
	addi $v0, $zero, 4
	syscall

	la   $a0, func_2B
	addi $v0, $zero, 4
	syscall

	la   $a0, func_2C
	addi $v0, $zero, 4
	syscall

	la   $a0, func_3
	addi $v0, $zero, 4
	syscall

	la   $a0, func_4
	addi $v0, $zero, 4
	syscall

	la   $a0, func_5
	addi $v0, $zero, 4
	syscall

	la   $a0, func_6
	addi $v0, $zero, 4
	syscall

	la   $a0, separator
	addi $v0, $zero, 4
	syscall

	la   $a0, choice
	addi $v0, $zero, 4
	syscall

Main_enterChoice:
	# Prompt user to enter a choice
	addi $a0, $sp, 20
	addi $a1, $zero, 4
	addi $v0, $zero, 8
	syscall

	la   $a0, result
	addi $v0, $zero, 4
	syscall

	lb   $s0, 20($sp) # $s0: 1st char of the inputted choice
	lb   $s1, 21($sp) # $s1: 2nd char of the inputted choice

	# Switch statement for $s0
	addi $t0, $s0, -49
	bne  $t0, $zero, Main_case2 # Branch if $s0 != '1'
	addi $t0, $s1, -10
	bne  $t0, $zero, Main_defaultCase



	j    Main_return
Main_case2:
	addi $t0, $s0, -50
	bne  $t0, $zero, Main_case3 # Branch if $s0 != '2'



	j    Main_return
Main_case3:
	addi $t0, $s0, -51
	bne  $t0, $zero, Main_case4 # Branch if $s0 != '3'
	addi $t0, $s1, -10
	bne  $t0, $zero, Main_defaultCase



	j    Main_return
Main_case4:
	addi $t0, $s0, -52
	bne  $t0, $zero, Main_case5 # Branch if $s0 != '4'
	addi $t0, $s1, -10
	bne  $t0, $zero, Main_defaultCase



	j    Main_return
Main_case5:
	addi $t0, $s0, -53
	bne  $t0, $zero, Main_case6 # Branch if $s0 != '5'
	addi $t0, $s1, -10
	bne  $t0, $zero, Main_defaultCase



	j    Main_return
Main_case6:
	addi $t0, $s0, -54
	bne  $t0, $zero, Main_defaultCase # Branch if $s0 != '6'
	addi $t0, $s1, -10
	bne  $t0, $zero, Main_defaultCase



	j    Main_return
Main_defaultCase:
	la   $a0, invalid_choice
	addi $v0, $zero, 4
	syscall
	j    Main_enterChoice
Main_return:
	addi $sp, $sp, 24

	# Exit
	addi $v0, $zero, 10
	syscall

########################################
# Prompt user to input date, check its validity, and store it.
	.data
prompt_day:   .asciiz "Enter a DAY: "
prompt_month: .asciiz "Enter a MONTH: "
prompt_year:  .asciiz "Enter a YEAR: "
invalid_date: .asciiz "Invalid inputs. Please re-enter the inputs:\n"
	.text
InputDate:
	addi $sp, $sp, -36
	# Reserve 16 bytes for the inputs:
	# First 4 bytes for day input,
	# next 4 bytes for month input and
	# last 8 bytes for year input
	sw   $a0, 16($sp)
	sw   $ra, 20($sp)
	sw   $s0, 24($sp)
	sw   $s1, 28($sp)
	sw   $s2, 32($sp)

InputDate_input:
	# Prompt user to input day
	la   $a0, prompt_day
	addi $v0, $zero, 4
	syscall

	# Input day
	addi $a0, $sp, 0
	addi $a1, $zero, 4
	addi $v0, $zero, 8
	syscall

	# Prompt user to input month
	la   $a0, prompt_month
	addi $v0, $zero, 4
	syscall

	# Input month
	addi $a0, $sp, 4
	addi $a1, $zero, 4
	addi $v0, $zero, 8
	syscall

	# Prompt user to input year
	la   $a0, prompt_year
	addi $v0, $zero, 4
	syscall

	# Input year
	addi $a0, $sp, 8
	addi $a1, $zero, 8
	addi $v0, $zero, 8
	syscall


	# Find the length of inputted 'year' string
	addi $a0, $sp, 8
	addi $a1, $zero, 8
	jal  StringLength
	add  $s0, $v0, $zero

	# Check if the inputted 'year' is a number
	addi $a0, $sp, 8
	add  $a1, $s0, $zero
	jal  CheckInput
	beq  $v0, $zero, InputDate_error

	# Convert 'year' from string to int
	addi $a0, $sp, 8
	add  $a1, $s0, $zero
	jal  StrToInt
	add  $s0, $v0, $zero

	# Check if 'year' is a valid year
	add  $a0, $s0, $zero
	jal  CheckYear
	beq  $v0, $zero, InputDate_error


	# Find the length of inputted 'month' string
	addi $a0, $sp, 4
	addi $a1, $zero, 4
	jal  StringLength
	add  $s1, $v0, $zero

	# Check if the inputted 'month' is a number
	addi $a0, $sp, 4
	add  $a1, $s1, $zero
	jal  CheckInput
	beq  $v0, $zero, InputDate_error

	# Convert 'month' from string to int
	addi $a0, $sp, 4
	add  $a1, $s1, $zero
	jal  StrToInt
	add  $s1, $v0, $zero

	# Check if 'month' is a valid month
	add  $a0, $s1, $zero
	jal  CheckMonth
	beq  $v0, $zero, InputDate_error


	# Find the length of inputted 'day' string
	addi $a0, $sp, 0
	addi $a1, $zero, 4
	jal  StringLength
	add  $s2, $v0, $zero

	# Check if the inputted 'day' is a number
	addi $a0, $sp, 0
	add  $a1, $s2, $zero
	jal  CheckInput
	beq  $v0, $zero, InputDate_error

	# Convert 'day' from string to int
	addi $a0, $sp, 0
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
	la   $a0, invalid_date
	addi $v0, $zero, 4
	syscall

	j    InputDate_input

InputDate_store:
	# Load TIME address from stack
	lw   $a0, 16($sp)
	add  $t0, $a0, $zero

	# Call Date routine
	add  $a0, $s2, $zero
	add  $a1, $s1, $zero
	add  $a2, $s0, $zero
	add  $a3, $t0, $zero
	jal  Date
	add  $v0, $v0, $zero

	# Restore $ra, $s0, $s1, $s2 and $sp
	lw   $ra, 20($sp)
	lw   $s0, 24($sp)
	lw   $s1, 28($sp)
	lw   $s2, 32($sp)
	addi $sp, $sp, 36

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
	addi $t3, $zero, 48
	sb   $t3, 0($t2)
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
	addi $t3, $zero, 48
	sb   $t3, 0($t2)
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
	addi $t4, $zero, 48
	sb   $t4, 0($t3)
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
	.text
CheckDay:
	addi $sp, $sp, -56
	# Reserve 48 bytes to store an array of integers
	# containing the number of days in each month.
	sw   $a0, 48($sp)
	sw   $ra, 52($sp)

	# Load Jan, Mar, May, Jul, Aug, Oct, Dec with 31
	addi $t0, $zero, 31
	sw   $t0, 0($sp)    # Jan
	sw   $t0, 8($sp)    # Mar
	sw   $t0, 16($sp)   # May
	sw   $t0, 24($sp)   # Jul
	sw   $t0, 28($sp)   # Aug
	sw   $t0, 36($sp)   # Oct
	sw   $t0, 44($sp)   # Dec

	# Load Apr, Jun, Sep, Nov with 30
	addi $t0, $zero, 30
	sw   $t0, 12($sp)   # Apr
	sw   $t0, 20($sp)   # Jun
	sw   $t0, 32($sp)   # Sep
	sw   $t0, 40($sp)   # Nov

	# Load Feb with 28
	addi $t0, $zero, 28
	sw   $t0, 4($sp)

	beq  $a0, $zero, CheckDay_setFalse # If day == 0, return false

	# Check leap year
	add  $a0, $a2, $zero
	jal  IsLeap
	add  $t0, $v0, $zero

	lw   $a0, 48($sp)   # Load day from stack
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
	addi $t0, $sp, 0       # $t0 = address of array containing num of days in each month
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
	lw   $ra, 52($sp)
	addi $sp, $sp, 56
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
# $a0: year in number
	.data
	.text
CheckYear:
	addi $v0, $zero, 1

	beq  $a0, $zero, CheckYear_setFalse

	addi $t0, $zero, 9999
	slt  $t1, $t0, $a0
	bne  $t1, $zero, CheckYear_setFalse

	j    CheckYear_return

CheckYear_setFalse:
	add  $v0, $zero, $zero

CheckYear_return:
	jr   $ra

########################################
# Check input number validity
# $a0: string's address
# $a1: string's length
	.data
	.text
CheckInput:
	addi $v0, $zero, 1     # Return value

	# If string is empty, return false
	beq  $a1, $zero, CheckInput_setFalse

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
	# Store existed data in $s and $ra registers to stack
	addi $sp, $sp, -24
	sw   $s0, 0($sp)
	sw   $s1, 4($sp)
	sw   $s2, 8($sp)
	sw   $s3, 12($sp)
	sw   $s4, 16($sp)
	sw   $ra, 20($sp)

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

	add  $v0, $s1, $zero # Return the address of output string

	lw   $t0, 0($sp)   # Load the number of bytes allocated for temp string from stack
	addi $sp, $sp, 4
	add  $sp, $sp, $t0 # Deallocate memory of temp string

	# Restore $s and $ra registers to original state
	lw   $s0, 0($sp)
	lw   $s1, 4($sp)
	lw   $s2, 8($sp)
	lw   $s3, 12($sp)
	lw   $s4, 16($sp)
	lw   $ra, 20($sp)
	addi $sp, $sp, 24

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
