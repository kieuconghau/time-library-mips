##### int main()
.data
str:	.asciiz "27/02/2020"
str1:	.asciiz "27/02/2021"
.text
Main:
	la   $a0, str
	la   $a1, str1
	jal  GetTime
	
	add  $a0, $zero, $v0
	addi $v0, $zero, 1
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
	addi $sp, $sp, -8
	sw   $ra, 4($sp)
	sw   $a0, 0($sp)
						# $a0: TIME
	addi $a1, $zero, 2			# $a1: 2
	jal  StrToInt
	
	lw   $a0, 0($sp)
	lw   $ra, 4($sp)
	addi $sp, $sp, 8
	
	jr   $ra
	

##### int Month(char* TIME)
Month:
						# $a0: TIME (char*)
	addi $sp, $sp, -8
	sw   $ra, 4($sp)
	sw   $a0, 0($sp)
	
	addi $a0, $a0, 3			# $a0: TIME + 3
	addi $a1, $zero, 2			# $a1: 2
	jal  StrToInt
	
	lw   $a0, 0($sp)
	lw   $ra, 4($sp)
	addi $sp, $sp, 8
	
	jr   $ra
	

##### int Year(char* TIME)
Year:
						# $a0: TIME (char*)
	addi $sp, $sp, -8
	sw   $ra, 4($sp)
	sw   $a0, 0($sp)
	
	addi $a0, $a0, 6			# $a0: TIME + 6
	addi $a1, $zero, 4			# $a1: 4
	jal  StrToInt
	
	lw   $a0, 0($sp)
	lw   $ra, 4($sp)
	addi $sp, $sp, 8
	
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
	addi $sp, $sp, -8
	sw   $ra, 4($sp)
	sw   $a0, 0($sp)
											
						# $a0: TIME
	jal  Year				# return year (int)
	
	add  $a0, $zero, $v0			# $a0: year (int)
	jal  IsLeap				# return IsLeap(year)
	
	lw   $a0, 0($sp)
	lw   $ra, 4($sp)
	addi $sp, $sp, 8
	
	jr   $ra


##### char* Convert(char* TIME, char type)
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
	add  $s1, $zero, $sp
	
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
	# January
	addi $t0, $zero, 74
	sb   $t0, 0($s1)
	addi $t0, $zero, 97
	sb   $t0, 1($s1)
	addi $t0, $zero, 110
	sb   $t0, 2($s1)
	addi $t0, $zero, 117
	sb   $t0, 3($s1)
	addi $t0, $zero, 97
	sb   $t0, 4($s1)
	addi $t0, $zero, 114
	sb   $t0, 5($s1)
	addi $t0, $zero, 121
	sb   $t0, 6($s1)
	addi $t0, $zero, 0
	sb   $t0, 7($s1)
	j    Convert_switch_end
Convert_switch_case_2:
	addi $t0, $v0, -2			# case 2
	bne  $t0, $zero, Convert_switch_case_3
	# February
	addi $t0, $zero, 70
	sb   $t0, 0($s1)
	addi $t0, $zero, 101
	sb   $t0, 1($s1)
	addi $t0, $zero, 98
	sb   $t0, 2($s1)
	addi $t0, $zero, 114
	sb   $t0, 3($s1)
	addi $t0, $zero, 117
	sb   $t0, 4($s1)
	addi $t0, $zero, 97
	sb   $t0, 5($s1)
	addi $t0, $zero, 114
	sb   $t0, 6($s1)
	addi $t0, $zero, 121
	sb   $t0, 7($s1)
	addi $t0, $zero, 0
	sb   $t0, 8($s1)
	j    Convert_switch_end
Convert_switch_case_3:
	addi $t0, $v0, -3			# case 3
	bne  $t0, $zero, Convert_switch_case_4
	# March
	addi $t0, $zero, 77
	sb   $t0, 0($s1)
	addi $t0, $zero, 97
	sb   $t0, 1($s1)
	addi $t0, $zero, 114
	sb   $t0, 2($s1)
	addi $t0, $zero, 99
	sb   $t0, 3($s1)
	addi $t0, $zero, 104
	sb   $t0, 4($s1)
	addi $t0, $zero, 0
	sb   $t0, 5($s1)
	j    Convert_switch_end
Convert_switch_case_4:
	addi $t0, $v0, -4			# case 4
	bne  $t0, $zero, Convert_switch_case_5
	# April
	addi $t0, $zero, 65
	sb   $t0, 0($s1)
	addi $t0, $zero, 112
	sb   $t0, 1($s1)
	addi $t0, $zero, 114
	sb   $t0, 2($s1)
	addi $t0, $zero, 105
	sb   $t0, 3($s1)
	addi $t0, $zero, 108
	sb   $t0, 4($s1)
	addi $t0, $zero, 0
	sb   $t0, 5($s1)
	j    Convert_switch_end
Convert_switch_case_5:
	addi $t0, $v0, -5			# case 5
	bne  $t0, $zero, Convert_switch_case_6
	# May
	addi $t0, $zero, 77
	sb   $t0, 0($s1)
	addi $t0, $zero, 97
	sb   $t0, 1($s1)
	addi $t0, $zero, 121
	sb   $t0, 2($s1)
	addi $t0, $zero, 0
	sb   $t0, 3($s1)
	j    Convert_switch_end
Convert_switch_case_6:
	addi $t0, $v0, -6			# case 6
	bne  $t0, $zero, Convert_switch_case_7
	# June
	addi $t0, $zero, 74
	sb   $t0, 0($s1)
	addi $t0, $zero, 117
	sb   $t0, 1($s1)
	addi $t0, $zero, 110
	sb   $t0, 2($s1)
	addi $t0, $zero, 101
	sb   $t0, 3($s1)
	addi $t0, $zero, 0
	sb   $t0, 4($s1)
	j    Convert_switch_end
Convert_switch_case_7:
	addi $t0, $v0, -7			# case 7
	bne  $t0, $zero, Convert_switch_case_8
	# July
	addi $t0, $zero, 74
	sb   $t0, 0($s1)
	addi $t0, $zero, 117
	sb   $t0, 1($s1)
	addi $t0, $zero, 108
	sb   $t0, 2($s1)
	addi $t0, $zero, 121
	sb   $t0, 3($s1)
	addi $t0, $zero, 0
	sb   $t0, 4($s1)
	j    Convert_switch_end
Convert_switch_case_8:
	addi $t0, $v0, -8			# case 8
	bne  $t0, $zero, Convert_switch_case_9
	# August
	addi $t0, $zero, 65
	sb   $t0, 0($s1)
	addi $t0, $zero, 117
	sb   $t0, 1($s1)
	addi $t0, $zero, 103
	sb   $t0, 2($s1)
	addi $t0, $zero, 117
	sb   $t0, 3($s1)
	addi $t0, $zero, 115
	sb   $t0, 4($s1)
	addi $t0, $zero, 116
	sb   $t0, 5($s1)
	addi $t0, $zero, 0
	sb   $t0, 6($s1)
	j    Convert_switch_end
Convert_switch_case_9:
	addi $t0, $v0, -9			# case 9
	bne  $t0, $zero, Convert_switch_case_10
	# September
	addi $t0, $zero, 83
	sb   $t0, 0($s1)
	addi $t0, $zero, 101
	sb   $t0, 1($s1)
	addi $t0, $zero, 112
	sb   $t0, 2($s1)
	addi $t0, $zero, 116
	sb   $t0, 3($s1)
	addi $t0, $zero, 101
	sb   $t0, 4($s1)
	addi $t0, $zero, 109
	sb   $t0, 5($s1)
	addi $t0, $zero, 98
	sb   $t0, 6($s1)
	addi $t0, $zero, 101
	sb   $t0, 7($s1)
	addi $t0, $zero, 114
	sb   $t0, 8($s1)
	addi $t0, $zero, 0
	sb   $t0, 9($s1)
	j    Convert_switch_end
Convert_switch_case_10:
	addi $t0, $v0, -10			# case 10
	bne  $t0, $zero, Convert_switch_case_11
	# October
	addi $t0, $zero, 79
	sb   $t0, 0($s1)
	addi $t0, $zero, 99
	sb   $t0, 1($s1)
	addi $t0, $zero, 116
	sb   $t0, 2($s1)
	addi $t0, $zero, 111
	sb   $t0, 3($s1)
	addi $t0, $zero, 98
	sb   $t0, 4($s1)
	addi $t0, $zero, 101
	sb   $t0, 5($s1)
	addi $t0, $zero, 114
	sb   $t0, 6($s1)
	addi $t0, $zero, 0
	sb   $t0, 7($s1)
	j    Convert_switch_end
Convert_switch_case_11:
	addi $t0, $v0, -11			# case 11
	bne  $t0, $zero, Convert_switch_case_12
	# November
	addi $t0, $zero, 78
	sb   $t0, 0($s1)
	addi $t0, $zero, 111
	sb   $t0, 1($s1)
	addi $t0, $zero, 118
	sb   $t0, 2($s1)
	addi $t0, $zero, 101
	sb   $t0, 3($s1)
	addi $t0, $zero, 109
	sb   $t0, 4($s1)
	addi $t0, $zero, 98
	sb   $t0, 5($s1)
	addi $t0, $zero, 101
	sb   $t0, 6($s1)
	addi $t0, $zero, 114
	sb   $t0, 7($s1)
	addi $t0, $zero, 0
	sb   $t0, 8($s1)
	j    Convert_switch_end
Convert_switch_case_12:
	addi $t0, $v0, -12			# case 12
	bne  $t0, $zero, Convert_switch_end
	# December
	addi $t0, $zero, 68
	sb   $t0, 0($s1)
	addi $t0, $zero, 101
	sb   $t0, 1($s1)
	addi $t0, $zero, 99
	sb   $t0, 2($s1)
	addi $t0, $zero, 101
	sb   $t0, 3($s1)
	addi $t0, $zero, 109
	sb   $t0, 4($s1)
	addi $t0, $zero, 98
	sb   $t0, 5($s1)
	addi $t0, $zero, 101
	sb   $t0, 6($s1)
	addi $t0, $zero, 114
	sb   $t0, 7($s1)
	addi $t0, $zero, 0
	sb   $t0, 8($s1)
Convert_switch_end:
	
	# Case B
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
	
	# Case C
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
	addi $sp, $sp, 12

	lw   $s1, 0($sp)
	addi $sp, $sp, 4
	
Convert_return:
	lw   $s0, 12($sp)
	addi $sp, $sp, 16
	add  $v0, $a0, $zero
	jr   $ra
	

##### void printNearLeapYear(char* TIME)
PrintNearLeapYear:
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
	addi $sp, $sp, -4
	addi $t0, $zero, 10
	sb   $t0, 0($sp)
	addi $t0, $zero, 0
	sb   $t0, 1($sp)
	add  $a0, $zero, $sp
	addi $v0, $zero, 4
	syscall
	addi $sp, $sp, 4
	
	sw   $a0, 0($sp)
	addi $sp, $sp, 4
	
PrintNearLeapYear_continue_1:
	j    PrintNearLeapYear_loop_1
	
PrintNearLeapYear_end_1:
	
PrintNearLeapYear_return:
	sw   $s0, 8($sp)
	sw   $s1, 4($sp)
	sw   $s2, 0($sp)
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


##### int GetTime(char* TIME_1, char* TIME2_)
	# initial:
	# 0 = result
	# 4 = day_1, 8 = month_1, 12 = year_1
	# 16 = day_2, 20 = month_2, 24 = year_2
	# 28 = t1, 32 = t2 
	# 36 = leapYear_1, 40 = leapYear_2 
	# 44 = $ra, 48 = $a0, 52 = $a1
GetTime:
	addi $sp, $sp, -56		# initial
	sw   $ra, 44($sp)
	sw   $a0, 48($sp)
	sw   $a1, 52($sp)
	
	jal  Day
	sw   $v0, 4($sp)		# day_1 = Day(TIME_1)
	
	lw   $a0, 48($sp)
	jal  Month
	sw   $v0, 8($sp)		# month_1 = Month(TIME_1)

	lw   $a0, 48($sp)
	jal  Year
	add  $t2, $t2, $v0		# year_1 = Year(TIME_1)
	sw   $v0, 12($sp)
	
	lw   $a0, 52($sp)
	jal  Day			
	sw   $v0, 16($sp)		# day_2 = Day(TIME_2)

	lw   $a0, 52($sp)
	jal  Month			
	sw   $v0, 20($sp)		# month_2 = Month(TIME_2)
	
	lw   $a0, 52($sp)
	jal  Year			
	sw   $v0, 24($sp)		# year_2 = Year(TIME_2)

	
	lw   $t1, 12($sp)		# load year_1
	lw   $t2, 24($sp)		# load year_2
	
	bne  $t1, $t2, cont		# if (year_1 == year_2)
	add  $v0, $0, $0		
	lw   $ra, 44($sp)
	addi $sp, $sp, 56
	jr   $ra			# return 0
	
cont: 	
	lw   $t5, 48($sp)
	lw   $t6, 52($sp)
	sw   $t5, 28($sp)		# t1 = TIME_1
	sw   $t6, 32($sp)		# t2 = TIME_2

	slt  $t3, $t2, $t1		# (year_2 < year_1)
	beq  $t3, $0, cont1		# if (year_2 < year_1)
	sw   $t6, 28($sp)		# t1 = TIME_2
	sw   $t5, 32($sp)		# t2 = TIME_1
	
	lw   $a0, 52($sp)
	jal  Day			
	sw   $v0, 4($sp)		# day_1 = Day(TIME_2)
	
	lw   $a0, 52($sp)
	jal  Month		
	sw   $v0, 8($sp)		# month_1 = Month(TIME_2)

	lw   $a0, 52($sp)
	jal  Year	
	sw   $v0, 12($sp)		# year_1 = Year(TIME_2)
	
	
	lw   $a0, 48($sp)
	jal  Day			
	sw   $v0, 16($sp)		# day_2 = Year(TIME_1)
	
	lw   $a0, 48($sp)
	jal  Month		
	sw   $v0, 20($sp)		# month_2 = Month(TIME_1)
	
	lw   $a0, 48($sp)
	jal  Year		
	sw   $v0, 24($sp)		# year_2 = Year(TIME_1)


cont1:  lw   $t1, 12($sp)		# load year_1
	lw   $t2, 24($sp)		# load year_2
	sub  $t0, $t2, $t1		# result = year_2 - year_1
	addi $t0, $t0, -1		# result -= 1
	sw   $t0, 0($sp)

	lw   $t1, 8($sp)		# load month_1
	lw   $t2, 20($sp)		# load month_2
	slt  $t0, $t1, $t2
	beq  $t0, $0, cont2		# if(month_1 < month_2)
	lw   $t0, 0($sp)		# result += 1
	addi $t0, $t0, 1
	sw   $t0, 0($sp)
	j exit_GetTime
	
cont2:  bne  $t1, $t2, exit_GetTime
	
	lw   $a0, 28($sp)
	jal  LeapYear		
	sw   $v0, 36($sp)		# leapYear_1 = LeapYear(t1)
	
	lw   $a0, 32($sp)
	jal  LeapYear		
	sw   $v0, 40($sp)		# leapYear_2 = LeapYear(t2)
	
	lw   $t1, 36($sp)		# load leapYear_1
	lw   $t2, 40($sp)		# load leapYear_2
	
	lw   $t0, 8($sp)		# load month
	bne  $t0, 2, normal		# if(month == 2)
	beq  $t1, $t2, normal		# if (leapYear_1 != leapYear_2)
	
cont4:	lw   $t1, 4($sp)		# load day_1
	lw   $t2, 16($sp)		# load day_2
	lw   $t3, 36($sp)		# load leapYear_1
	lw   $t4, 40($sp)		# load leapYear_2

	bne  $t3, 1, cont5		# if (leapYear_1 == 1)
	bne  $t1, 29, cont5		# if (day_1 == 29)
	bne  $t2, 28, cont5		# if (day_2 == 28)
	j increase
	
cont5:  bne  $t4, 1, cont6		# if (leapYear_2 == 1)  
	bne  $t2, 29, cont6		# if (day_2 == 29)
	bne  $t1, 28, cont6		# if (day_1 == 28)
	j increase
	
cont6:  bne  $t3, 1, cont7		# if(leapYear_1 == 1)
	bne  $t1, 28, cont7		# if(day_1 == 28)
	bne  $t2, 28, cont7		# if(day_2 == 28)
	j increase			# 28/02/2020 -> 28/2/2021 => 1

cont7:	bne  $t4, 1, normal		# if(leapYear_2 == 1)
	bne  $t1, 28, normal		# if(day_1 == 28)
	bne  $t2, 28, normal		# if(day_2 == 28)
	j exit_GetTime

normal:	lw   $t1, 4($sp)		# load day_1
	lw   $t2, 16($sp)		# load day_2
	slt  $t3, $t2, $t1		# (day_2 < day_1)
	bne  $t3, $0, exit_GetTime	# if(day_2 >= day_1)
	
increase: 
	lw    $t5, 0($sp)		
	addi  $t5, $t5, 1		# result += 1
	sw    $t5, 0($sp)
	
exit_GetTime:
	lw    $v0, 0($sp)
	lw    $ra, 44($sp)
	addi  $sp, $sp, 56
	jr $ra
