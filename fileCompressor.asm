.data
filename: .ascii "jerzy.bmp"
endMessage: .ascii "\n the program is finished \n"
errorMessage: .ascii "\n error reading file \n"
headerSize: .space 54
imgBuff: .space 129846

.text
loadImage:
	li $v0, 13
	la $a0, filename
	li $a1, 0
	li $a2, 0
	syscall
	
	move $s6, $v0
	bltz $s6, fReadError
	
	move $a0, $s6
	li $v0, 14
	la $a1, imgBuff
	li $a2, 129846
	syscall
	
	move $s7, $v0
	
	li   $v0, 16     
  	move $a0, $s6 
	syscall
	
	li $v0, 1
	la $a0, ($s7)
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
