.data
inFileName: .asciiz "jerzy.bmp"
endMessage: .ascii "\n the program is finished \n"
errorMessage: .ascii "\n error reading file \n"
headerBuff: .space 54


.text

main:

openHeader:
#open
	li $v0, 13
	la $a0, inFileName
	li $a1, 0
	li $a2, 0
	syscall
	
	la $s6, ($v0)
	bltz $s6, fReadError
	
	#load
	move $a0, $s6
	li $v0, 14
	la $a1, headerBuff
	li $a2, 54
	syscall
	
#read img size 
	la $s1, headerBuff 
	la $s2, ($s1)

	li $v0, 1
	lw $a1, ($s2)
	syscall

	li   $v0, 16     
  	move $a0, $s6 
	syscall
end:
	li $v0, 4
	la $a0, endMessage
	syscall
	
	li $v0, 10
	syscall

fReadError:
	li   $v0, 16     
  	move $a0, $s6 
	syscall
	
	li $v0, 4
	la $a0, errorMessage
	syscall
	
	li $v0, 10
	syscall
