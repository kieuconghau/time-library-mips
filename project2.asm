##### int main()
.data
str:	.asciiz "28/02/1800"
.text
Main:
	la   $a0, str
	jal  Weekday
	
	add  $a0, $zero, $v0
	li   $v0, 4
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
	add  $s0, $sp, $zero			# $s0: str (char[12])
	addi $t0, $zero, 0			# St0: i = 0
Convert_loop_1:
	slti $t1, $t0, 11
	beq  $t1, $zero, Convert_end_1
	add  $t1, $s0, $t0			# str + i
	add  $t2, $a0, $t0			# TIME + i
	lb   $t2, 0($t2)			# TIME[i]
	sb   $t2, 0($t1)			# str[i] = TIME[i]
	addi $t0, $t0, 1			# ++i
	j    Convert_loop_1
Convert_end_1:
	
	addi $t0, $a1, -65
	beq  $t0, $zero, Convert_case_a		# type == 'A' then goto case_a
	addi $t0, $a1, -97
	beq  $t0, $zero, Convert_case_a		# type == 'a' then goto case_a
	j    Convert_case_b_c_criteria
	
Convert_case_a:
	addi $t0, $zero, 0			# i = 0
Convert_case_a_loop_1:
	slti $t1, $t0, 2
	beq  $t1, $zero, Convert_case_a_end_1
	add $t1, $a0, $t0			# TIME + i
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
	j    Convert_case_a_loop_1
Convert_case_a_end_1:
	j    Convert_return
	
Convert_case_b_c_criteria:
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
	addi $sp, $sp, -4
	sw   $s1, 0($sp)			# $s1: month (char*)
	
	addi $sp, $sp, -12
	sw   $ra, 8($sp)
	sw   $a0, 4($sp)
	sw   $a1, 0($sp)
	jal  Month				# $a0: TIME
	lw   $ra, 8($sp)
	lw   $a0, 4($sp)
	lw   $a1, 0($sp)
	addi $sp, $sp, 12
	
	addi $t0, $v0, -1			# case 1
	bne  $t0, $zero, Convert_switch_case_2
	la   $s1, month1			# month = month1
	j    Convert_switch_end
Convert_switch_case_2:
	addi $t0, $v0, -2			# case 2
	bne  $t0, $zero, Convert_switch_case_3
	la   $s1, month2			# month = month2
	j    Convert_switch_end
Convert_switch_case_3:
	addi $t0, $v0, -3			# case 3
	bne  $t0, $zero, Convert_switch_case_4
	la   $s1, month3			# month = month3
	j    Convert_switch_end
Convert_switch_case_4:
	addi $t0, $v0, -4			# case 4
	bne  $t0, $zero, Convert_switch_case_5
	la   $s1, month4			# month = month4
	j    Convert_switch_end
Convert_switch_case_5:
	addi $t0, $v0, -5			# case 5
	bne  $t0, $zero, Convert_switch_case_6
	la   $s1, month5			# month = month5
	j    Convert_switch_end
Convert_switch_case_6:
	addi $t0, $v0, -6			# case 6
	bne  $t0, $zero, Convert_switch_case_7
	la   $s1, month6			# month = month6
	j    Convert_switch_end
Convert_switch_case_7:
	addi $t0, $v0, -7			# case 7
	bne  $t0, $zero, Convert_switch_case_8
	la   $s1, month7			# month = month7
	j    Convert_switch_end
Convert_switch_case_8:
	addi $t0, $v0, -8			# case 8
	bne  $t0, $zero, Convert_switch_case_9
	la   $s1, month8			# month = month8
	j    Convert_switch_end
Convert_switch_case_9:
	addi $t0, $v0, -9			# case 9
	bne  $t0, $zero, Convert_switch_case_10
	la   $s1, month9			# month = month9
	j    Convert_switch_end
Convert_switch_case_10:
	addi $t0, $v0, -10			# case 10
	bne  $t0, $zero, Convert_switch_case_11
	la   $s1, month10			# month = month10
	j    Convert_switch_end
Convert_switch_case_11:
	addi $t0, $v0, -11			# case 11
	bne  $t0, $zero, Convert_switch_case_12
	la   $s1, month11			# month = month11
	j    Convert_switch_end
Convert_switch_case_12:
	addi $t0, $v0, -12			# case 12
	bne  $t0, $zero, Convert_switch_end
	la   $s1, month12			# month = month12
Convert_switch_end:
	
	
	addi $t0, $a1, -66
	beq  $t0, $zero, Convert_case_b
	addi $t0, $a1, -98
	beq  $t0, $zero, Convert_case_b
	j    Convert_case_c
	
Convert_case_b:
	# Month
	addi $t0, $zero, 0			# St0: i = 0
Convert_case_b_loop_1:
	add  $t1, $s1, $t0			# month + i
	lb   $t1, 0($t1)			# month[i]
	beq  $t1, $zero, Convert_case_b_end_1	# if month[i] == '/0' then exit loop
	add  $t2, $a0, $t0			# TIME + i
	sb   $t1, 0($t2)			# TIME[i] = month[i]
	addi $t0, $t0, 1			# ++i
	j    Convert_case_b_loop_1
Convert_case_b_end_1:
	
	# Month_
	add  $t1, $a0, $t0			# TIME + i
	addi $t2, $zero, 32			# 32: ' '
	sb   $t2, 0($t1)			# TIME[i] = 32
	addi $t0, $t0, 1			# ++i
	
	# Month_DD
	addi $t1, $zero, 0			# $t1: j = 0
Convert_case_b_loop_2:
	slti $t2, $t1, 2
	beq  $t2, $zero, Convert_case_b_end_2
	add  $t2, $a0, $t0			# TIME + i
	add  $t3, $s0, $t1			# str + j
	lb   $t3, 0($t3)			# str[j]
	sb   $t3, 0($t2)			# TIME[i] = str[j]
	addi $t0, $t0, 1			# ++i
	addi $t1, $t1, 1			# ++j
	j    Convert_case_b_loop_2
Convert_case_b_end_2:
	
	# Month_DD,
	add  $t1, $a0, $t0			# TIME + i
	addi $t2, $zero, 44			# 44: ','
	sb   $t2, 0($t1)			# TIME[i] = 44
	addi $t0, $t0, 1			# ++i
	
	# Month_DD,_
	add  $t1, $a0, $t0			# TIME + i
	addi $t2, $zero, 32			# 32: ' '
	sb   $t2, 0($t1)			# TIME[i] = 32
	addi $t0, $t0, 1			# ++i
	
	# Month_DD,_YYYY + '/0'
	addi $t1, $zero, 6			# $t1: j = 6
Convert_case_b_loop_3:
	slti $t2, $t1, 11
	beq  $t2, $zero, Convert_case_b_end_3
	add  $t2, $a0, $t0			# TIME + i
	add  $t3, $s0, $t1			# str + j
	lb   $t3, 0($t3)			# str[j]
	sb   $t3, 0($t2)			# TIME[i] = str[j]
	addi $t0, $t0, 1			# ++i
	addi $t1, $t1, 1			# ++j
	j    Convert_case_b_loop_3
Convert_case_b_end_3:
	j    Convert_case_b_c_end
	
Convert_case_c:
	addi $t0, $zero, 0			# St0: i = 0
	addi $t1, $zero, 0			# St1: j = 0
	
	## DD
Convert_case_c_loop_1:
	slti $t2, $t1, 2
	beq  $t2, $zero, Convert_case_c_end_1
	add  $t2, $a0, $t0			# TIME + i
	add  $t3, $s0, $t1			# str + j
	lb   $t3, 0($t3)			# str[j]
	sb   $t3, 0($t2)			# TIME[i] = str[j]
	addi $t0, $t0, 1			# ++i
	addi $t1, $t1, 1			# ++j
	j    Convert_case_c_loop_1
Convert_case_c_end_1:
	
	## DD_
	add  $t1, $a0, $t0			# TIME + i
	addi $t2, $zero, 32			# 32: ' '
	sb   $t2, 0($t1)			# TIME[i] = 32
	addi $t0, $t0, 1			# ++i
	
	# DD_Month
	addi $t1, $zero, 0			# $t1: j = 0
Convert_case_c_loop_2:
	add  $t2, $s1, $t1			# month + j
	lb   $t2, 0($t2)			# month[j]
	beq  $t2, $zero, Convert_case_c_end_2	# if month[j] == '/0' then exit loop
	add  $t3, $a0, $t0			# TIME + i
	sb   $t2, 0($t3)			# TIME[i] = month[j]
	addi $t0, $t0, 1			# ++i
	addi $t1, $t1, 1			# ++j
	j    Convert_case_c_loop_2
Convert_case_c_end_2:
	
	# DD_Month,
	add  $t1, $a0, $t0			# TIME + i
	addi $t2, $zero, 44			# 44: ','
	sb   $t2, 0($t1)			# TIME[i] = 44
	addi $t0, $t0, 1			# ++i
	
	# DD_Month,_
	add  $t1, $a0, $t0			# TIME + i
	addi $t2, $zero, 32			# 32: ' '
	sb   $t2, 0($t1)			# TIME[i] = 32
	addi $t0, $t0, 1			# ++i
	
	# DD_Month,_YYYY + '/0'
	addi $t1, $zero, 6			# $t1: j = 6
Convert_case_c_loop_3:
	slti $t2, $t1, 11
	beq  $t2, $zero, Convert_case_c_end_3
	add  $t2, $a0, $t0			# TIME + i
	add  $t3, $s0, $t1			# str + j
	lb   $t3, 0($t3)			# str[j]
	sb   $t3, 0($t2)			# TIME[i] = str[j]
	addi $t0, $t0, 1			# ++i
	addi $t1, $t1, 1			# ++j
	j    Convert_case_c_loop_3
Convert_case_c_end_3:
	
Convert_case_b_c_end:
	lw   $s1, 0($sp)
	addi $sp, $sp, 4
	
Convert_return:
	lw   $s0, 12($sp)
	addi $sp, $sp, 16
	add  $v0, $a0, $zero
	jr   $ra
	

##### void printNearLeapYear(char* TIME)
PrintNearLeapYear:
.data
endl:	.asciiz "\n"
.text
						# $a0: TIME (char*)
	addi $sp, $sp, -12
	sw   $s0, 8($sp)
	sw   $s1, 4($sp)
	sw   $s2, 0($sp)
											# $a0: TIME
	addi $sp, $sp, -8
	sw   $ra, 4($sp)
	sw   $a0, 0($sp)
	jal  Year				# $a0: TIME (char*)
	lw   $ra, 4($sp)
	lw   $a0, 0($sp)
	addi $sp, $sp, 8
	
	add  $s0, $zero, $v0			# $s0: year (int)
	addi $s1, $zero, 0			# $s1: i = 0
	addi $s2, $zero, 1			# $s2: d = 1
	
	addi $sp, $sp, -8
	sw   $ra, 4($sp)
	sw   $a0, 0($sp)
	jal  LeapYear				# $a0: TIME (char*)
	lw   $ra, 4($sp)
	lw   $a0, 0($sp)
	addi $sp, $sp, 8
	
	beq  $v0, $zero, PrintNearLeapYear_loop_1
	addi $s2, $zero, 4			# d = 4
	
PrintNearLeapYear_loop_1:
	slti $t0, $s1, 2
	beq  $t0, $zero, PrintNearLeapYear_end_1
	add  $s0, $s0, $s2			# year += d
	
	addi $sp, $sp, -8
	sw   $ra, 4($sp)
	sw   $a0, 0($sp)
	add  $a0, $zero, $s0			
	jal  IsLeap				# $a0: year (int)
	lw   $ra, 4($sp)
	lw   $a0, 0($sp)
	addi $sp, $sp, 8
	
	beq  $v0, $zero, PrintNearLeapYear_continue_1
	addi $s1, $s1, 1			# ++i
	
	addi $sp, $sp, -4
	sw   $a0, 0($sp)
	
	# cout << year;
	add  $a0, $zero, $s0
	addi $v0, $zero, 1
	syscall
	
	# cout << endl;
	la   $a0, endl
	addi $v0, $zero, 4
	syscall
	
	sw   $a0, 0($sp)
	addi $sp, $sp, 4
	
PrintNearLeapYear_continue_1:
	j    PrintNearLeapYear_loop_1
	
PrintNearLeapYear_end_1:
	
PrintNearLeapYear_return:
	lw   $s2, 0($sp)
	lw   $s1, 4($sp)
	lw   $s0, 8($sp)
	addi $sp, $sp, 12

	jr   $ra


##### char* Weekday(char* TIME)
.data
weekday0: .asciiz "Sun"
weekday1: .asciiz "Mon"
weekday2: .asciiz "Tues"
weekday3: .asciiz "Wed"
weekday4: .asciiz "Thurs"
weekday5: .asciiz "Fri"
weekday6: .asciiz "Sat"
.text
Weekday:
	addi $sp, $sp, -20
	sw   $s0, 16($sp)			# t
	sw   $s1, 12($sp)			# d
	sw   $s2, 8($sp)			# m
	sw   $s3, 4($sp)			# y
	sw   $s4, 0($sp)			# s
	
	addi $sp, $sp, -48
	add  $s0, $zero, $sp
	addi $t0, $zero, 0
	sw   $t0, 0($s0)
	addi $t0, $zero, 3
	sw   $t0, 4($s0)
	addi $t0, $zero, 2
	sw   $t0, 8($s0)
	addi $t0, $zero, 5
	sw   $t0, 12($s0)
	addi $t0, $zero, 0
	sw   $t0, 16($s0)
	addi $t0, $zero, 3
	sw   $t0, 20($s0)
	addi $t0, $zero, 5
	sw   $t0, 24($s0)
	addi $t0, $zero, 1
	sw   $t0, 28($s0)
	addi $t0, $zero, 4
	sw   $t0, 32($s0)
	addi $t0, $zero, 6
	sw   $t0, 36($s0)
	addi $t0, $zero, 2
	sw   $t0, 40($s0)
	addi $t0, $zero, 4
	sw   $t0, 44($s0)
	
	addi $sp, $sp, -8
	sw   $ra, 4($sp)
	sw   $a0, 0($sp)
	jal  Day				# $a0: TIME
	lw   $a0, 0($sp)
	lw   $ra, 4($sp)
	addi $sp, $sp, 8
	add  $s1, $zero, $v0			# $s1: d = Day(TIME)
	
	addi $sp, $sp, -8
	sw   $ra, 4($sp)
	sw   $a0, 0($sp)
	jal  Month				# $a0: TIME
	lw   $a0, 0($sp)
	lw   $ra, 4($sp)
	addi $sp, $sp, 8
	add  $s2, $zero, $v0			# $s2: m = Month(TIME)
	
	addi $sp, $sp, -8
	sw   $ra, 4($sp)
	sw   $a0, 0($sp)
	jal  Year				# $a0: TIME
	lw   $a0, 0($sp)
	lw   $ra, 4($sp)
	addi $sp, $sp, 8
	add  $s3, $zero, $v0			# $s3: y = Year(TIME)

	slti $t0, $s2, 3
	beq  $t0, $zero, Weekday_skip
	addi $s3, $s3, -1			# if (m < 3) --y
	
Weekday_skip:
	add  $s4, $zero, $s3			# $s4: s = y
	
	addi $t0, $zero, 4
	div  $s3, $t0				# y / 4
	mflo $t0
	add  $s4, $s4, $t0			# s += y / 4
	
	addi $t0, $zero, 100
	div  $s3, $t0				# y / 100
	mflo $t0
	sub  $s4, $s4, $t0			# s -= y / 100
	
	addi $t0, $zero, 400
	div  $s3, $t0				# y / 400
	mflo $t0
	add  $s4, $s4, $t0			# s += y / 400

	addi $t0, $s2, -1			# m - 1
	sll  $t0, $t0, 2			# 4*(m - 1)
	add  $t0, $s0, $t0			# t + 4*(m - 1)
	lw   $t0, 0($t0)			# t[m - i]
	add  $s4, $s4, $t0			# s += t[m - 1]
	
	add  $s4, $s4, $s1			# s += d
	
	addi $t0, $zero, 7
	div  $s4, $t0				# s % 7
	mfhi $s4				# s %= 7
	
	# Switch(s)
	bne  $s4, $zero, Weekday_switch_case_1
	la   $v0, weekday0
	j    Weekday_return
Weekday_switch_case_1:
	addi $t0, $s4, -1
	bne  $t0, $zero, Weekday_switch_case_2
	la   $v0, weekday1
	j    Weekday_return
Weekday_switch_case_2:
	addi $t0, $s4, -2
	bne  $t0, $zero, Weekday_switch_case_3
	la   $v0, weekday2
	j    Weekday_return
Weekday_switch_case_3:
	addi $t0, $s4, -3
	bne  $t0, $zero, Weekday_switch_case_4
	la   $v0, weekday3
	j    Weekday_return
Weekday_switch_case_4:
	addi $t0, $s4, -4
	bne  $t0, $zero, Weekday_switch_case_5
	la   $v0, weekday4
	j    Weekday_return
Weekday_switch_case_5:
	addi $t0, $s4, -5
	bne  $t0, $zero, Weekday_switch_case_6
	la   $v0, weekday5
	j    Weekday_return
Weekday_switch_case_6:
	la   $v0, weekday6

Weekday_return:
	addi $sp, $sp, 48

	sw   $s0, 16($sp)
	sw   $s1, 12($sp)
	sw   $s2, 8($sp)
	sw   $s3, 4($sp)
	sw   $s4, 0($sp)	
	addi $sp, $sp, 20
	
	jr   $ra
