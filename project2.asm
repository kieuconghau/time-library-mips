##### int main()
.data
str:	.asciiz "13579"
.text
Main:
	la  $a0, str
	li  $a1, 5
	jal StrToInt
	
	move $a0, $v0
	li   $v0, 1
	syscall
	
	# Exit
	li   $v0, 10
      	syscall
      	
      	
##### int StrToInt(char* str_input, int n)
StrToInt:
						# $a0: str_input
						# $a1: n
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
						# $a0: TIME
	addi $a1, $zero, 2			# $a1: 2
	jal  StrToInt
	jr   $ra


