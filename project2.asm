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


##### char* Convert(char* TIME, char type)
.data
month1:	 .asciiz "January"
month2:  .asciiz "February"
month3:  .asciiz "March"
month4:  .asciiz "April"
month5:  .asciiz "May"
month6:  .asciiz "June"
month7:  .asciiz "July"
month8:  .asciiz "August"
month9:	 .asciiz "September"
month10: .asciiz "October"
month11: .asciiz "November"
month12: .asciiz "December"
.text
Convert:
						# $a0: TIME (char*)
						# $a1: type (char)
	addi $sp, $sp, -16			# 12 bytes for string TIME, 4 bytes for $s0
	sw   $s0, 12($sp)
	add  $s0, $zero, $sp			# $s0: str (char[12])
	addi $t0, $zero, 0			# St0: i = 0
	Convert_loop_1:
	slti $t1, $t0, 11
	beq  $t1, $zero, Convert_end_1
	add  $t1, $s0, $t0			# str + i
	add  $t2, $a0, $t0			# TIME + i
	lb   $t2, 0($t2)			# TIME[i]
	sb   $t2, 0($t1)			# str[i] = TIME[i]
	addi $t0, $t0, 1			# ++i
	Convert_end_1:
	
	addi $t0, $a1, -65
	beq  $t0, $zero, Convert_case_a		# type == 'A' then goto case_a
	addi $t0, $a1, -97
	beq  $t0, $zero, Convert_case_a		# type == 'a' then goto case_a
	j    Convert_condition_1
	Convert_case_a:
	addi $t0, $zero, 0			# i = 0
	Convert_loop_2:
	slti $t1, $t0, 2
	beq  $t1, $zero, Convert_end_2
	addi $t1, $a0, $t0			# TIME + i
	addi $t2, $t0, 3			# i + 3
	add  $t2, $s0, $t2			# str + i + 3
	lb   $t2, 0($t2)			# str[i + 3]
	sb   $t2, 0($t1)			# TIME[i] = str[i + 3]
	addi $t1, $t0, 3			# i + 3
	add  $t1, $a0, $t1			# TIME + i + 3
	add  $t2, $s0, $t0			# str + i
	lb   $t2, 0($t2)			# str[i]
	sb   $t2, 0($t1)			# TIME[i + 3] = str[i]
	addi $t0, $t0, 1			# ++i
	j    Convert_loop_2:
	Convert_end_2:
	
	
	Convert_condition_1:
	addi $t0, $a1, -66
	beq  $t0, $zero, Convert_case_b_c
	addi $t0, $a1, -98
	beq  $t0, $zero, Convert_case_b_c
	addi $t0, $a1, -67
	beq  $t0, $zero, Convert_case_b_c
	addi $t0, $a1, -99
	beq  $t0, $zero, Convert_case_b_c
	j    Convert_return
	Convert_case_b_c:
	
	
	Convert_return:
	lw   $s0, 12($sp)
	add  $v0, $a0, $zero
	jr   $ra
	