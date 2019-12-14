##### int main()
.data
str:	.asciiz "18/12/2000"
.text
Main:
	la  $a0, str
	jal LeapYear
	
	move $a0, $v0
	li   $v0, 1
	syscall
	
	# Exit
	li   $v0, 10
      	syscall
      	
      	
##### int StrToInt(char* str_input, int n)
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
	
	
##### int Day(char* TIME)
Day:
						# $a0: TIME (char*)
	addi $sp, $sp, -4
	sw   $ra, 0($sp)
	
						# $a0: TIME
	addi $a1, $zero, 2			# $a1: 2
	jal  StrToInt
	
	lw   $ra, 0($sp)
	addi $sp, $sp, 4
	jr   $ra
	


##### int Month(char* TIME)
Month:
						# $a0: TIME (char*)
	addi $sp, $sp, -4
	sw   $ra, 0($sp)
	
	addi $a0, $a0, 3			# $a0: TIME + 3
	addi $a1, $zero, 2			# $a1: 2
	jal  StrToInt
	
	lw   $ra, 0($sp)
	addi $sp, $sp, 4
	jr   $ra
	

##### int Year(char* TIME)
Year:
						# $a0: TIME (char*)
	addi $sp, $sp, -4
	sw   $ra, 0($sp)
	
	addi $a0, $a0, 6			# $a0: TIME + 6
	addi $a1, $zero, 4			# $a1: 4
	jal  StrToInt
	
	lw   $ra, 0($sp)
	addi $sp, $sp, 4
	jr   $ra


##### int IsLeap(int year)
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


##### int LeapYear(char* TIME)
LeapYear:
						# $a0: TIME (char*)
	addi $sp, $sp, -4
	sw   $ra, 0($sp)
						
						# $a0: TIME
	jal  Year				# return year (int)
	
	add  $a0, $zero, $v0			# $a0: year (int)
	jal  IsLeap				# return IsLeap(year)
	
	lw   $ra, 0($sp)
	addi $sp, $sp, 4
	jr   $ra



