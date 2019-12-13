# Main routine
	.data
	.text
	.globl main
main:
	jal InputDate
	
	# Exit
	addi $v0, $zero, 10
	syscall

########################################
# Prompt user to input date, check its validity, and store it.
	.data
prompt1:   .asciiz "Nhap ngay DAY: "
prompt2:   .asciiz "Nhap thang MONTH: "
prompt3:   .asciiz "Nhap nam YEAR: "
str_input: .space 5
	.text
InputDate:
	la   $a0, prompt1
	addi $v0, $zero, 4
	syscall
	
	la   $a0, str_input
	la   $a1, 3
	addi $v0, $zero, 8
	syscall
	
	
	
########################################
# Check number validity
	.data
	.text
CheckInput:
	
	
	jr $ra
