.data
inFileName: .asciiz "jerzy.bmp"
outFileName: .asciiz "out.bmp"
tempFileName: .asciiz "temp.bmp"
endMessage: .ascii "\n the program is finished \n"
errorMessage: .ascii "\n error reading file \n"
srcHeaderBuff: .space 54
outHeaderBuff: .space 54
.text
#s2 = srcHeadBuff
#s4 = srcImgBuff
#t7 = wSrc
#t8 = hSrc
#t9 = sSrc

#s3 = outHeadBuff
#s5 = outImgBuff
#t4 = wOut
#t5 = hOut
#t6 = sOut

main:
#open src header
	la $a0, inFileName
	la $a3, srcHeaderBuff
	jal openHeader
	move $t7, $t1
	move $t8, $t2
	move $t9, $t3
	
	move $s2, $s1
	
#open out header
	la $a0, outFileName
	la $a3, outHeaderBuff
	jal openHeader
	move $t4, $t1
	move $t5, $t2
	move $t6, $t3
	
	move $s3, $s1
#allocate mem src
	
	li $v0, 9
	move, $a0, $t9
	addiu $a0, $a0, 54
	syscall
	
	move $s4, $v0
#allocate mem out
	li $v0, 9
	move $a0, $t6
	syscall
	
	move $s5, $v0
	
#open src for reading
	li $v0, 13
	la $a0, inFileName
	li $a1, 0
	li $a2, 0
	syscall
	
	la $s6, ($v0)
	bltz $s6, fReadError
	
	#loadWholeSRCImage

	move $a0, $s6
	li $v0, 14
	la $a1, ($s4)
	move $a2, $t6
	addiu $a2, $a2, 54
	syscall
	
#s0 width coefficient
#s1 height coefficient

	divu $s0, $t7, $t4
	divu $s1, $t8, $t5

#s4 height pointer
#s2 width pointer

#a1 width in bytes
 	addiu $s4, $s4, 54
 	
	move $a1, $t7
	mulu $a1, $a1, 3
	li $a2, 8191
	move $k0, $s5
	addiu $k0, $k0, 54
loopOuter:
	beqz $a2, saveFile
	subiu $a2, $a2, 1
	loopInner:
		move $a0, $s4
		jal loadPixel
		addu $t9, $v0, $0
	
		move $a0, $s4
		addiu $a0, $a0, 3
		jal loadPixel
		add $t9, $t9, $v0
	
		move $a0, $s4
		addu $a0, $a0, $a1
		jal loadPixel 
		add $t9, $t9, $v0
	
		move $a0, $s4
		addiu $a0, $a0, 3
		jal loadPixel
		add $t9, $t9, $v0
	
		divu $t9 $t9, 4
		sw $t9, ($k0)
		addiu $k0, $k0, 3
		j loopOuter
saveFile:
	la $a0, outFileName
	li $a1, 1
	li $a2, 0 
	li $v0 13
	syscall
	
	move $a0, $v0
	move $a1, $s5
	move $a2, $t6
	addiu $a2, $a2, 54
	li $v0, 15 
	syscall
	
	li $v0, 16
	syscall
	
	j end
openHeader:
#open
	li $v0, 13
	li $a1, 0
	li $a2, 0
	syscall
	
	la $s6, ($v0)
	bltz $s6, fReadError
	
	#loadheader

	move $a0, $s6
	li $v0, 14
	la $a1, ($a3)
	li $a2, 54
	syscall
	
	la $s1, ($a3) 
	
	#width
	lbu $t1, 18($s1)
	lbu $a1, 19($s1)
	sll $a1, $a1, 8
	add $t1, $t1, $a1
	lbu $a1, 20($s1)
	sll $a1, $a1, 16
	add $t1, $t1, $a1
	lbu $a1, 21($s1)
	sll $a1, $a1, 24
	add $t1, $t1, $a1
	
	#height
	lbu $t2, 22($s1)
	lbu $a1, 23($s1)
	sll $a1, $a1, 8
	add $t2, $t2, $a1
	lbu $a1, 24($s1)
	sll $a1, $a1, 16
	add $t2, $t2, $a1
	lbu $a1, 25($s1)
	sll $a1, $a1, 24
	add $t2, $t2, $a1
	
	#size
	lbu $t3, 34($s1)
	lbu $a1, 35($s1)
	sll $a1, $a1, 8
	add $t3, $t3, $a1
	lbu $a1, 36($s1)
	sll $a1, $a1, 16
	add $t3, $t3, $a1
	lbu $a1, 37($s1)
	sll $a1, $a1, 24
	add $t3, $t3, $a1
	
	li   $v0, 16     
  	move $a0, $s6 
	syscall
	
	jr $ra
	
fReadError:
	li $v0, 4
	la $a0, errorMessage
	syscall
	
	li $v0, 10
	syscall

end:	
	li $v0, 4
	la $a0, endMessage
	syscall
	
	li $v0, 10
	syscall

loadPixel:
	lbu $v0, ($a0)
	sll $v0, $v0, 8
	lbu $a3, 8($a0)
	add $v0, $v0, $a3
	sll $v0, $v0, 8
	lbu $a3, 16($a0)
	add $v0, $v0, $a3
	jr $ra
	