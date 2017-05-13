	# standard Decaf preamble 
	  .data
  TRUE:
	  .asciiz "true"
  FALSE:
	  .asciiz "false"
	  
	  .text
	  .align 2
	  .globl main
	  .globl _PrintInt
	  .globl _PrintString
	  .globl _PrintBool
	  .globl _Alloc
	  .globl _StringEqual
	  .globl _Halt
	  .globl _ReadInteger
	  .globl _ReadLine
	# Fin EmitPreamble
  _PrintInt:
	  subu $sp, $sp, 8  	# decrement so to make space to save ra, fp
	  sw $fp, 8($sp)    	# save fp
	  sw $ra, 4($sp)    	# save ra
	  addiu $fp, $sp, 8 	# set up new fp
	  li $v0, 1         	# system call code for print_int
	  lw $a0, 4($fp)
	  syscall
	  move $sp, $fp
	  lw $ra, -4($fp)
	  lw $fp, 0($fp)
	  jr $ra
	  
  _PrintBool:
	  subu $sp, $sp, 8
	  sw $fp, 8($sp)
	  sw $ra, 4($sp)
	  addiu $fp, $sp, 8
	  lw $t1, 4($fp)
	  blez $t1, fbr
	  li $v0, 4             	# system call for print_str
	  la $a0, TRUE
	  syscall
	  b end
  fbr:
	  li $v0, 4             	# system call for print_str
	  la $a0, FALSE
	  syscall
  end:
	  move $sp, $fp
	  lw $ra, -4($fp)
	  lw $fp, 0($fp)
	  jr $ra
	  
  _PrintString:
	  subu $sp, $sp, 8
	  sw $fp, 8($sp)
	  sw $ra, 4($sp)
	  addiu $fp, $sp, 8
	  li $v0, 4             	# system call for print_str
	  lw $a0, 4($fp)
	  syscall
	  move $sp, $fp
	  lw $ra, -4($fp)
	  lw $fp, 0($fp)
	  jr $ra
	  
  _Alloc:
	  subu $sp, $sp, 8
	  sw $fp, 8($sp)
	  sw $ra, 4($sp)
	  addiu $fp, $sp, 8
	  li $v0, 9             	# system call for sbrk
	  lw $a0, 4($fp)
	  syscall
	  move $sp, $fp
	  lw $ra, -4($fp)
	  lw $fp, 0($fp)
	  jr $ra
	  
  _StringEqual:
	  subu $sp, $sp, 8
	  sw $fp, 8($sp)
	  sw $ra, 4($sp)
	  addiu $fp, $sp, 8
	  subu $sp, $sp, 4	# decrement sp to make space for return value
	  li $v0, 0
	#Determine length string 1
	  lw $t0, 4($fp)
	  li $t3, 0
  bloop1:
	  lb $t5, ($t0)
	  beqz $t5, eloop1
	  addi $t0, 1
	  addi $t3, 1
	  b bloop1
  eloop1:
	#Determine length string 2
	  lw $t1, 8($fp)
	  li $t4, 0
  bloop2:
	  lb $t5, ($t1)
	  beqz $t5, eloop2
	  addi $t1, 1
	  addi $t4, 1
	  b bloop2
  eloop2:
	  bne $t3, $t4, end1	# check if string lengths are the same
	  lw $t0, 4($fp)
	  lw $t1, 8($fp)
	  li $t3, 0
  bloop3:
	  lb $t5, ($t0)
	  lb $t6, ($t1)
	  bne $t5, $t6, end1
	  addi $t3, 1
	  addi $t0, 1
	  addi $t1, 1
	  bne $t3, $t4, bloop3
  eloop3:
	  li $v0, 1
  end1:
	  move $sp, $fp
	  lw $ra, -4($fp)
	  lw $fp, 0($fp)
	  jr $ra
	  
  _Halt:
	  li $v0, 10
	  syscall
	  
  _ReadInteger:
	  subu $sp, $sp, 8
	  sw $fp, 8($sp)
	  sw $ra, 4($sp)
	  addiu $fp, $sp, 8
	  subu $sp, $sp, 4
	  li $v0, 5
	  syscall
	  move $sp, $fp
	  lw $ra, -4($fp)
	  lw $fp, 0($fp)
	  jr $ra
	  
  _ReadLine:
	  subu $sp, $sp, 8
	  sw $fp, 8($sp)
	  sw $ra, 4($sp)
	  addiu $fp, $sp, 8
	  li $t0, 40
	  subu $sp, $sp, 4
	  sw $t0, 4($sp)
	  jal _Alloc
	  move $t0, $v0
	  li $a1, 40
	  move $a0, $t0
	  li $v0, 8
	  syscall
	  move $t1, $t0
  bloop4:
	  lb $t5, ($t1)
	  beqz $t5, eloop4
	  addi $t1, 1
	  b bloop4
  eloop4:
	  addi $t1, -1
	  li $t6, 0
	  sb $t6, ($t1)
	  move $v0, $t0
	  move $sp, $fp
	  lw $ra, -4($fp)
	  lw $fp, 0($fp)
	  jr $ra
	  
  Stack.____Init:
	# BeginFunc 56
	  subu $sp, $sp, 8	# decrement sp to make space to save ra, fp
	  sw $fp, 8($sp)	# save fp
	  sw $ra, 4($sp)	# save ra
	  addiu $fp, $sp, 8	# set up new fp
	  subu $sp, $sp, 56	# decrement sp to make space for locals/temps
	# _tmp0 = 100
	  li $t2, 100		# load constant value 100 into $t2
	  sw $t2, -8($fp)	# spill _tmp0 from $t2 to $fp-8
	# _tmp1 = 4
	  li $t2, 4		# load constant value 4 into $t2
	  sw $t2, -12($fp)	# spill _tmp1 from $t2 to $fp-12
	# _tmp2 = 0
	  li $t2, 0		# load constant value 0 into $t2
	  sw $t2, -16($fp)	# spill _tmp2 from $t2 to $fp-16
	# _tmp3 = _tmp0 < _tmp2
	  lw $t0, -8($fp)	# fill _tmp0 to $t0 from $fp-8
	  lw $t1, -16($fp)	# fill _tmp2 to $t1 from $fp-16
	  slt $t2, $t0, $t1	
	  sw $t2, -20($fp)	# spill _tmp3 from $t2 to $fp-20
	# _tmp4 = _tmp0 == _tmp2
	  lw $t0, -8($fp)	# fill _tmp0 to $t0 from $fp-8
	  lw $t1, -16($fp)	# fill _tmp2 to $t1 from $fp-16
	  seq $t2, $t0, $t1	
	  sw $t2, -24($fp)	# spill _tmp4 from $t2 to $fp-24
	# _tmp5 = _tmp3 || _tmp4
	  lw $t0, -20($fp)	# fill _tmp3 to $t0 from $fp-20
	  lw $t1, -24($fp)	# fill _tmp4 to $t1 from $fp-24
	  or $t2, $t0, $t1	
	  sw $t2, -28($fp)	# spill _tmp5 from $t2 to $fp-28
	# IfZ _tmp5 Goto _L0
	  lw $t0, -28($fp)	# fill _tmp5 to $t0 from $fp-28
	  beqz $t0, _L0	# branch if _tmp5 is zero 
	# _tmp6 = "Decaf runtime error: Array size is <= 0\n"
	  .data			# create string constant marked with label
	  _string1: .asciiz "Decaf runtime error: Array size is <= 0\n"
	  .text
	  la $t2, _string1	# load label
	  sw $t2, -32($fp)	# spill _tmp6 from $t2 to $fp-32
	# PushParam _tmp6
	  subu $sp, $sp, 4	# decrement sp to make space for param
	  lw $t0, -32($fp)	# fill _tmp6 to $t0 from $fp-32
	  sw $t0, 4($sp)	# copy param value to stack
	# LCall _PrintString
	  jal _PrintString   	# jump to function
	# PopParams 4
	  add $sp, $sp, 4	# pop params off stack
	# LCall _Halt
	  jal _Halt          	# jump to function
  _L0:
	# _tmp7 = _tmp0 * _tmp1
	  lw $t0, -8($fp)	# fill _tmp0 to $t0 from $fp-8
	  lw $t1, -12($fp)	# fill _tmp1 to $t1 from $fp-12
	  mul $t2, $t0, $t1	
	  sw $t2, -36($fp)	# spill _tmp7 from $t2 to $fp-36
	# _tmp8 = _tmp1 + _tmp7
	  lw $t0, -12($fp)	# fill _tmp1 to $t0 from $fp-12
	  lw $t1, -36($fp)	# fill _tmp7 to $t1 from $fp-36
	  add $t2, $t0, $t1	
	  sw $t2, -40($fp)	# spill _tmp8 from $t2 to $fp-40
	# PushParam _tmp8
	  subu $sp, $sp, 4	# decrement sp to make space for param
	  lw $t0, -40($fp)	# fill _tmp8 to $t0 from $fp-40
	  sw $t0, 4($sp)	# copy param value to stack
	# _tmp9 = LCall _Alloc
	  jal _Alloc         	# jump to function
	  move $t2, $v0		# copy function return value from $v0
	  sw $t2, -44($fp)	# spill _tmp9 from $t2 to $fp-44
	# PopParams 4
	  add $sp, $sp, 4	# pop params off stack
	# *(_tmp9) = _tmp0
	  lw $t0, -8($fp)	# fill _tmp0 to $t0 from $fp-8
	  lw $t2, -44($fp)	# fill _tmp9 to $t2 from $fp-44
	  sw $t0, 0($t2) 	# store with offset
	# *(this + 8) = _tmp9
	  lw $t0, -44($fp)	# fill _tmp9 to $t0 from $fp-44
	  lw $t2, 4($fp)	# fill this to $t2 from $fp+4
	  sw $t0, 8($t2) 	# store with offset
	# _tmp10 = 0
	  li $t2, 0		# load constant value 0 into $t2
	  sw $t2, -48($fp)	# spill _tmp10 from $t2 to $fp-48
	# *(this + 4) = _tmp10
	  lw $t0, -48($fp)	# fill _tmp10 to $t0 from $fp-48
	  lw $t2, 4($fp)	# fill this to $t2 from $fp+4
	  sw $t0, 4($t2) 	# store with offset
	# _tmp11 = 3
	  li $t2, 3		# load constant value 3 into $t2
	  sw $t2, -52($fp)	# spill _tmp11 from $t2 to $fp-52
	# PushParam _tmp11
	  subu $sp, $sp, 4	# decrement sp to make space for param
	  lw $t0, -52($fp)	# fill _tmp11 to $t0 from $fp-52
	  sw $t0, 4($sp)	# copy param value to stack
	# PushParam this
	  subu $sp, $sp, 4	# decrement sp to make space for param
	  lw $t0, 4($fp)	# fill this to $t0 from $fp+4
	  sw $t0, 4($sp)	# copy param value to stack
	# _tmp12 = *(this)
	  lw $t0, 4($fp)	# fill this to $t0 from $fp+4
	  lw $t2, 0($t0) 	# load with offset
	  sw $t2, -56($fp)	# spill _tmp12 from $t2 to $fp-56
	# _tmp13 = *(_tmp12 + 4)
	  lw $t0, -56($fp)	# fill _tmp12 to $t0 from $fp-56
	  lw $t2, 4($t0) 	# load with offset
	  sw $t2, -60($fp)	# spill _tmp13 from $t2 to $fp-60
	# ACall _tmp13
	  lw $t0, -60($fp)	# fill _tmp13 to $t0 from $fp-60
	  jalr $t0            	# jump to function
	# PopParams 8
	  add $sp, $sp, 8	# pop params off stack
	# EndFunc
	# (below handles reaching end of fn body with no explicit return)
	  move $sp, $fp		# pop callee frame off stack
	  lw $ra, -4($fp)	# restore saved ra
	  lw $fp, 0($fp)	# restore saved fp
	  jr $ra		# return from function
  Stack.____Push:
	# BeginFunc 72
	  subu $sp, $sp, 8	# decrement sp to make space to save ra, fp
	  sw $fp, 8($sp)	# save fp
	  sw $ra, 4($sp)	# save ra
	  addiu $fp, $sp, 8	# set up new fp
	  subu $sp, $sp, 72	# decrement sp to make space for locals/temps
	# _tmp14 = *(this + 8)
	  lw $t0, 4($fp)	# fill this to $t0 from $fp+4
	  lw $t2, 8($t0) 	# load with offset
	  sw $t2, -8($fp)	# spill _tmp14 from $t2 to $fp-8
	# _tmp15 = *(this + 4)
	  lw $t0, 4($fp)	# fill this to $t0 from $fp+4
	  lw $t2, 4($t0) 	# load with offset
	  sw $t2, -12($fp)	# spill _tmp15 from $t2 to $fp-12
	# _tmp16 = 0
	  li $t2, 0		# load constant value 0 into $t2
	  sw $t2, -16($fp)	# spill _tmp16 from $t2 to $fp-16
	# _tmp17 = *(_tmp14)
	  lw $t0, -8($fp)	# fill _tmp14 to $t0 from $fp-8
	  lw $t2, 0($t0) 	# load with offset
	  sw $t2, -20($fp)	# spill _tmp17 from $t2 to $fp-20
	# _tmp18 = _tmp15 < _tmp16
	  lw $t0, -12($fp)	# fill _tmp15 to $t0 from $fp-12
	  lw $t1, -16($fp)	# fill _tmp16 to $t1 from $fp-16
	  slt $t2, $t0, $t1	
	  sw $t2, -24($fp)	# spill _tmp18 from $t2 to $fp-24
	# _tmp19 = _tmp17 < _tmp15
	  lw $t0, -20($fp)	# fill _tmp17 to $t0 from $fp-20
	  lw $t1, -12($fp)	# fill _tmp15 to $t1 from $fp-12
	  slt $t2, $t0, $t1	
	  sw $t2, -28($fp)	# spill _tmp19 from $t2 to $fp-28
	# _tmp20 = _tmp17 == _tmp15
	  lw $t0, -20($fp)	# fill _tmp17 to $t0 from $fp-20
	  lw $t1, -12($fp)	# fill _tmp15 to $t1 from $fp-12
	  seq $t2, $t0, $t1	
	  sw $t2, -32($fp)	# spill _tmp20 from $t2 to $fp-32
	# _tmp21 = _tmp19 || _tmp20
	  lw $t0, -28($fp)	# fill _tmp19 to $t0 from $fp-28
	  lw $t1, -32($fp)	# fill _tmp20 to $t1 from $fp-32
	  or $t2, $t0, $t1	
	  sw $t2, -36($fp)	# spill _tmp21 from $t2 to $fp-36
	# _tmp22 = _tmp21 || _tmp18
	  lw $t0, -36($fp)	# fill _tmp21 to $t0 from $fp-36
	  lw $t1, -24($fp)	# fill _tmp18 to $t1 from $fp-24
	  or $t2, $t0, $t1	
	  sw $t2, -40($fp)	# spill _tmp22 from $t2 to $fp-40
	# IfZ _tmp22 Goto _L1
	  lw $t0, -40($fp)	# fill _tmp22 to $t0 from $fp-40
	  beqz $t0, _L1	# branch if _tmp22 is zero 
	# _tmp23 = "Decaf runtime error: Array subscript out of bound..."
	  .data			# create string constant marked with label
	  _string2: .asciiz "Decaf runtime error: Array subscript out of bounds\n"
	  .text
	  la $t2, _string2	# load label
	  sw $t2, -44($fp)	# spill _tmp23 from $t2 to $fp-44
	# PushParam _tmp23
	  subu $sp, $sp, 4	# decrement sp to make space for param
	  lw $t0, -44($fp)	# fill _tmp23 to $t0 from $fp-44
	  sw $t0, 4($sp)	# copy param value to stack
	# LCall _PrintString
	  jal _PrintString   	# jump to function
	# PopParams 4
	  add $sp, $sp, 4	# pop params off stack
	# LCall _Halt
	  jal _Halt          	# jump to function
  _L1:
	# _tmp24 = 4
	  li $t2, 4		# load constant value 4 into $t2
	  sw $t2, -48($fp)	# spill _tmp24 from $t2 to $fp-48
	# _tmp25 = _tmp15 * _tmp24
	  lw $t0, -12($fp)	# fill _tmp15 to $t0 from $fp-12
	  lw $t1, -48($fp)	# fill _tmp24 to $t1 from $fp-48
	  mul $t2, $t0, $t1	
	  sw $t2, -52($fp)	# spill _tmp25 from $t2 to $fp-52
	# _tmp26 = _tmp25 + _tmp24
	  lw $t0, -52($fp)	# fill _tmp25 to $t0 from $fp-52
	  lw $t1, -48($fp)	# fill _tmp24 to $t1 from $fp-48
	  add $t2, $t0, $t1	
	  sw $t2, -56($fp)	# spill _tmp26 from $t2 to $fp-56
	# _tmp27 = _tmp14 + _tmp26
	  lw $t0, -8($fp)	# fill _tmp14 to $t0 from $fp-8
	  lw $t1, -56($fp)	# fill _tmp26 to $t1 from $fp-56
	  add $t2, $t0, $t1	
	  sw $t2, -60($fp)	# spill _tmp27 from $t2 to $fp-60
	# *(_tmp27) = i
	  lw $t0, 8($fp)	# fill i to $t0 from $fp+8
	  lw $t2, -60($fp)	# fill _tmp27 to $t2 from $fp-60
	  sw $t0, 0($t2) 	# store with offset
	# _tmp28 = *(_tmp27)
	  lw $t0, -60($fp)	# fill _tmp27 to $t0 from $fp-60
	  lw $t2, 0($t0) 	# load with offset
	  sw $t2, -64($fp)	# spill _tmp28 from $t2 to $fp-64
	# _tmp29 = *(this + 4)
	  lw $t0, 4($fp)	# fill this to $t0 from $fp+4
	  lw $t2, 4($t0) 	# load with offset
	  sw $t2, -68($fp)	# spill _tmp29 from $t2 to $fp-68
	# _tmp30 = 1
	  li $t2, 1		# load constant value 1 into $t2
	  sw $t2, -72($fp)	# spill _tmp30 from $t2 to $fp-72
	# _tmp31 = _tmp29 + _tmp30
	  lw $t0, -68($fp)	# fill _tmp29 to $t0 from $fp-68
	  lw $t1, -72($fp)	# fill _tmp30 to $t1 from $fp-72
	  add $t2, $t0, $t1	
	  sw $t2, -76($fp)	# spill _tmp31 from $t2 to $fp-76
	# *(this + 4) = _tmp31
	  lw $t0, -76($fp)	# fill _tmp31 to $t0 from $fp-76
	  lw $t2, 4($fp)	# fill this to $t2 from $fp+4
	  sw $t0, 4($t2) 	# store with offset
	# EndFunc
	# (below handles reaching end of fn body with no explicit return)
	  move $sp, $fp		# pop callee frame off stack
	  lw $ra, -4($fp)	# restore saved ra
	  lw $fp, 0($fp)	# restore saved fp
	  jr $ra		# return from function
  Stack.____Pop:
	# BeginFunc 88
	  subu $sp, $sp, 8	# decrement sp to make space to save ra, fp
	  sw $fp, 8($sp)	# save fp
	  sw $ra, 4($sp)	# save ra
	  addiu $fp, $sp, 8	# set up new fp
	  subu $sp, $sp, 88	# decrement sp to make space for locals/temps
	# _tmp32 = *(this + 8)
	  lw $t0, 4($fp)	# fill this to $t0 from $fp+4
	  lw $t2, 8($t0) 	# load with offset
	  sw $t2, -12($fp)	# spill _tmp32 from $t2 to $fp-12
	# _tmp33 = *(this + 4)
	  lw $t0, 4($fp)	# fill this to $t0 from $fp+4
	  lw $t2, 4($t0) 	# load with offset
	  sw $t2, -16($fp)	# spill _tmp33 from $t2 to $fp-16
	# _tmp34 = 1
	  li $t2, 1		# load constant value 1 into $t2
	  sw $t2, -20($fp)	# spill _tmp34 from $t2 to $fp-20
	# _tmp35 = _tmp33 - _tmp34
	  lw $t0, -16($fp)	# fill _tmp33 to $t0 from $fp-16
	  lw $t1, -20($fp)	# fill _tmp34 to $t1 from $fp-20
	  sub $t2, $t0, $t1	
	  sw $t2, -24($fp)	# spill _tmp35 from $t2 to $fp-24
	# _tmp36 = 0
	  li $t2, 0		# load constant value 0 into $t2
	  sw $t2, -28($fp)	# spill _tmp36 from $t2 to $fp-28
	# _tmp37 = *(_tmp32)
	  lw $t0, -12($fp)	# fill _tmp32 to $t0 from $fp-12
	  lw $t2, 0($t0) 	# load with offset
	  sw $t2, -32($fp)	# spill _tmp37 from $t2 to $fp-32
	# _tmp38 = _tmp35 < _tmp36
	  lw $t0, -24($fp)	# fill _tmp35 to $t0 from $fp-24
	  lw $t1, -28($fp)	# fill _tmp36 to $t1 from $fp-28
	  slt $t2, $t0, $t1	
	  sw $t2, -36($fp)	# spill _tmp38 from $t2 to $fp-36
	# _tmp39 = _tmp37 < _tmp35
	  lw $t0, -32($fp)	# fill _tmp37 to $t0 from $fp-32
	  lw $t1, -24($fp)	# fill _tmp35 to $t1 from $fp-24
	  slt $t2, $t0, $t1	
	  sw $t2, -40($fp)	# spill _tmp39 from $t2 to $fp-40
	# _tmp40 = _tmp37 == _tmp35
	  lw $t0, -32($fp)	# fill _tmp37 to $t0 from $fp-32
	  lw $t1, -24($fp)	# fill _tmp35 to $t1 from $fp-24
	  seq $t2, $t0, $t1	
	  sw $t2, -44($fp)	# spill _tmp40 from $t2 to $fp-44
	# _tmp41 = _tmp39 || _tmp40
	  lw $t0, -40($fp)	# fill _tmp39 to $t0 from $fp-40
	  lw $t1, -44($fp)	# fill _tmp40 to $t1 from $fp-44
	  or $t2, $t0, $t1	
	  sw $t2, -48($fp)	# spill _tmp41 from $t2 to $fp-48
	# _tmp42 = _tmp41 || _tmp38
	  lw $t0, -48($fp)	# fill _tmp41 to $t0 from $fp-48
	  lw $t1, -36($fp)	# fill _tmp38 to $t1 from $fp-36
	  or $t2, $t0, $t1	
	  sw $t2, -52($fp)	# spill _tmp42 from $t2 to $fp-52
	# IfZ _tmp42 Goto _L2
	  lw $t0, -52($fp)	# fill _tmp42 to $t0 from $fp-52
	  beqz $t0, _L2	# branch if _tmp42 is zero 
	# _tmp43 = "Decaf runtime error: Array subscript out of bound..."
	  .data			# create string constant marked with label
	  _string3: .asciiz "Decaf runtime error: Array subscript out of bounds\n"
	  .text
	  la $t2, _string3	# load label
	  sw $t2, -56($fp)	# spill _tmp43 from $t2 to $fp-56
	# PushParam _tmp43
	  subu $sp, $sp, 4	# decrement sp to make space for param
	  lw $t0, -56($fp)	# fill _tmp43 to $t0 from $fp-56
	  sw $t0, 4($sp)	# copy param value to stack
	# LCall _PrintString
	  jal _PrintString   	# jump to function
	# PopParams 4
	  add $sp, $sp, 4	# pop params off stack
	# LCall _Halt
	  jal _Halt          	# jump to function
  _L2:
	# _tmp44 = 4
	  li $t2, 4		# load constant value 4 into $t2
	  sw $t2, -60($fp)	# spill _tmp44 from $t2 to $fp-60
	# _tmp45 = _tmp35 * _tmp44
	  lw $t0, -24($fp)	# fill _tmp35 to $t0 from $fp-24
	  lw $t1, -60($fp)	# fill _tmp44 to $t1 from $fp-60
	  mul $t2, $t0, $t1	
	  sw $t2, -64($fp)	# spill _tmp45 from $t2 to $fp-64
	# _tmp46 = _tmp45 + _tmp44
	  lw $t0, -64($fp)	# fill _tmp45 to $t0 from $fp-64
	  lw $t1, -60($fp)	# fill _tmp44 to $t1 from $fp-60
	  add $t2, $t0, $t1	
	  sw $t2, -68($fp)	# spill _tmp46 from $t2 to $fp-68
	# _tmp47 = _tmp32 + _tmp46
	  lw $t0, -12($fp)	# fill _tmp32 to $t0 from $fp-12
	  lw $t1, -68($fp)	# fill _tmp46 to $t1 from $fp-68
	  add $t2, $t0, $t1	
	  sw $t2, -72($fp)	# spill _tmp47 from $t2 to $fp-72
	# _tmp48 = *(_tmp47)
	  lw $t0, -72($fp)	# fill _tmp47 to $t0 from $fp-72
	  lw $t2, 0($t0) 	# load with offset
	  sw $t2, -76($fp)	# spill _tmp48 from $t2 to $fp-76
	# val = _tmp48
	  lw $t2, -76($fp)	# fill _tmp48 to $t2 from $fp-76
	  sw $t2, -8($fp)	# spill val from $t2 to $fp-8
	# _tmp49 = *(this + 4)
	  lw $t0, 4($fp)	# fill this to $t0 from $fp+4
	  lw $t2, 4($t0) 	# load with offset
	  sw $t2, -80($fp)	# spill _tmp49 from $t2 to $fp-80
	# _tmp50 = 1
	  li $t2, 1		# load constant value 1 into $t2
	  sw $t2, -84($fp)	# spill _tmp50 from $t2 to $fp-84
	# _tmp51 = _tmp49 - _tmp50
	  lw $t0, -80($fp)	# fill _tmp49 to $t0 from $fp-80
	  lw $t1, -84($fp)	# fill _tmp50 to $t1 from $fp-84
	  sub $t2, $t0, $t1	
	  sw $t2, -88($fp)	# spill _tmp51 from $t2 to $fp-88
	# *(this + 4) = _tmp51
	  lw $t0, -88($fp)	# fill _tmp51 to $t0 from $fp-88
	  lw $t2, 4($fp)	# fill this to $t2 from $fp+4
	  sw $t0, 4($t2) 	# store with offset
	# Return val
	  lw $t2, -8($fp)	# fill val to $t2 from $fp-8
	  move $v0, $t2		# assign return value into $v0
	  move $sp, $fp		# pop callee frame off stack
	  lw $ra, -4($fp)	# restore saved ra
	  lw $fp, 0($fp)	# restore saved fp
	  jr $ra		# return from function
	# EndFunc
	# (below handles reaching end of fn body with no explicit return)
	  move $sp, $fp		# pop callee frame off stack
	  lw $ra, -4($fp)	# restore saved ra
	  lw $fp, 0($fp)	# restore saved fp
	  jr $ra		# return from function
  Stack.____NumElems:
	# BeginFunc 4
	  subu $sp, $sp, 8	# decrement sp to make space to save ra, fp
	  sw $fp, 8($sp)	# save fp
	  sw $ra, 4($sp)	# save ra
	  addiu $fp, $sp, 8	# set up new fp
	  subu $sp, $sp, 4	# decrement sp to make space for locals/temps
	# _tmp52 = *(this + 4)
	  lw $t0, 4($fp)	# fill this to $t0 from $fp+4
	  lw $t2, 4($t0) 	# load with offset
	  sw $t2, -8($fp)	# spill _tmp52 from $t2 to $fp-8
	# Return _tmp52
	  lw $t2, -8($fp)	# fill _tmp52 to $t2 from $fp-8
	  move $v0, $t2		# assign return value into $v0
	  move $sp, $fp		# pop callee frame off stack
	  lw $ra, -4($fp)	# restore saved ra
	  lw $fp, 0($fp)	# restore saved fp
	  jr $ra		# return from function
	# EndFunc
	# (below handles reaching end of fn body with no explicit return)
	  move $sp, $fp		# pop callee frame off stack
	  lw $ra, -4($fp)	# restore saved ra
	  lw $fp, 0($fp)	# restore saved fp
	  jr $ra		# return from function
	# VTable for class Stack
	  .data
	  .align 2
	  Stack:		# label for class Stack vtable
	  .word Stack.____Init
	  .word Stack.____Push
	  .word Stack.____Pop
	  .word Stack.____NumElems
	  .text
  main:
	# BeginFunc 180
	  subu $sp, $sp, 8	# decrement sp to make space to save ra, fp
	  sw $fp, 8($sp)	# save fp
	  sw $ra, 4($sp)	# save ra
	  addiu $fp, $sp, 8	# set up new fp
	  subu $sp, $sp, 180	# decrement sp to make space for locals/temps
	# _tmp53 = 8
	  li $t2, 8		# load constant value 8 into $t2
	  sw $t2, -12($fp)	# spill _tmp53 from $t2 to $fp-12
	# _tmp54 = 4
	  li $t2, 4		# load constant value 4 into $t2
	  sw $t2, -16($fp)	# spill _tmp54 from $t2 to $fp-16
	# _tmp55 = _tmp54 + _tmp53
	  lw $t0, -16($fp)	# fill _tmp54 to $t0 from $fp-16
	  lw $t1, -12($fp)	# fill _tmp53 to $t1 from $fp-12
	  add $t2, $t0, $t1	
	  sw $t2, -20($fp)	# spill _tmp55 from $t2 to $fp-20
	# PushParam _tmp55
	  subu $sp, $sp, 4	# decrement sp to make space for param
	  lw $t0, -20($fp)	# fill _tmp55 to $t0 from $fp-20
	  sw $t0, 4($sp)	# copy param value to stack
	# _tmp56 = LCall _Alloc
	  jal _Alloc         	# jump to function
	  move $t2, $v0		# copy function return value from $v0
	  sw $t2, -24($fp)	# spill _tmp56 from $t2 to $fp-24
	# PopParams 4
	  add $sp, $sp, 4	# pop params off stack
	# _tmp57 = Stack
	  la $t2, Stack	# load label
	  sw $t2, -28($fp)	# spill _tmp57 from $t2 to $fp-28
	# *(_tmp56) = _tmp57
	  lw $t0, -28($fp)	# fill _tmp57 to $t0 from $fp-28
	  lw $t2, -24($fp)	# fill _tmp56 to $t2 from $fp-24
	  sw $t0, 0($t2) 	# store with offset
	# s = _tmp56
	  lw $t2, -24($fp)	# fill _tmp56 to $t2 from $fp-24
	  sw $t2, -8($fp)	# spill s from $t2 to $fp-8
	# PushParam s
	  subu $sp, $sp, 4	# decrement sp to make space for param
	  lw $t0, -8($fp)	# fill s to $t0 from $fp-8
	  sw $t0, 4($sp)	# copy param value to stack
	# _tmp58 = *(s)
	  lw $t0, -8($fp)	# fill s to $t0 from $fp-8
	  lw $t2, 0($t0) 	# load with offset
	  sw $t2, -32($fp)	# spill _tmp58 from $t2 to $fp-32
	# _tmp59 = *(_tmp58)
	  lw $t0, -32($fp)	# fill _tmp58 to $t0 from $fp-32
	  lw $t2, 0($t0) 	# load with offset
	  sw $t2, -36($fp)	# spill _tmp59 from $t2 to $fp-36
	# ACall _tmp59
	  lw $t0, -36($fp)	# fill _tmp59 to $t0 from $fp-36
	  jalr $t0            	# jump to function
	# PopParams 4
	  add $sp, $sp, 4	# pop params off stack
	# _tmp60 = 3
	  li $t2, 3		# load constant value 3 into $t2
	  sw $t2, -40($fp)	# spill _tmp60 from $t2 to $fp-40
	# PushParam _tmp60
	  subu $sp, $sp, 4	# decrement sp to make space for param
	  lw $t0, -40($fp)	# fill _tmp60 to $t0 from $fp-40
	  sw $t0, 4($sp)	# copy param value to stack
	# PushParam s
	  subu $sp, $sp, 4	# decrement sp to make space for param
	  lw $t0, -8($fp)	# fill s to $t0 from $fp-8
	  sw $t0, 4($sp)	# copy param value to stack
	# _tmp61 = *(s)
	  lw $t0, -8($fp)	# fill s to $t0 from $fp-8
	  lw $t2, 0($t0) 	# load with offset
	  sw $t2, -44($fp)	# spill _tmp61 from $t2 to $fp-44
	# _tmp62 = *(_tmp61 + 4)
	  lw $t0, -44($fp)	# fill _tmp61 to $t0 from $fp-44
	  lw $t2, 4($t0) 	# load with offset
	  sw $t2, -48($fp)	# spill _tmp62 from $t2 to $fp-48
	# ACall _tmp62
	  lw $t0, -48($fp)	# fill _tmp62 to $t0 from $fp-48
	  jalr $t0            	# jump to function
	# PopParams 8
	  add $sp, $sp, 8	# pop params off stack
	# _tmp63 = 7
	  li $t2, 7		# load constant value 7 into $t2
	  sw $t2, -52($fp)	# spill _tmp63 from $t2 to $fp-52
	# PushParam _tmp63
	  subu $sp, $sp, 4	# decrement sp to make space for param
	  lw $t0, -52($fp)	# fill _tmp63 to $t0 from $fp-52
	  sw $t0, 4($sp)	# copy param value to stack
	# PushParam s
	  subu $sp, $sp, 4	# decrement sp to make space for param
	  lw $t0, -8($fp)	# fill s to $t0 from $fp-8
	  sw $t0, 4($sp)	# copy param value to stack
	# _tmp64 = *(s)
	  lw $t0, -8($fp)	# fill s to $t0 from $fp-8
	  lw $t2, 0($t0) 	# load with offset
	  sw $t2, -56($fp)	# spill _tmp64 from $t2 to $fp-56
	# _tmp65 = *(_tmp64 + 4)
	  lw $t0, -56($fp)	# fill _tmp64 to $t0 from $fp-56
	  lw $t2, 4($t0) 	# load with offset
	  sw $t2, -60($fp)	# spill _tmp65 from $t2 to $fp-60
	# ACall _tmp65
	  lw $t0, -60($fp)	# fill _tmp65 to $t0 from $fp-60
	  jalr $t0            	# jump to function
	# PopParams 8
	  add $sp, $sp, 8	# pop params off stack
	# _tmp66 = 4
	  li $t2, 4		# load constant value 4 into $t2
	  sw $t2, -64($fp)	# spill _tmp66 from $t2 to $fp-64
	# PushParam _tmp66
	  subu $sp, $sp, 4	# decrement sp to make space for param
	  lw $t0, -64($fp)	# fill _tmp66 to $t0 from $fp-64
	  sw $t0, 4($sp)	# copy param value to stack
	# PushParam s
	  subu $sp, $sp, 4	# decrement sp to make space for param
	  lw $t0, -8($fp)	# fill s to $t0 from $fp-8
	  sw $t0, 4($sp)	# copy param value to stack
	# _tmp67 = *(s)
	  lw $t0, -8($fp)	# fill s to $t0 from $fp-8
	  lw $t2, 0($t0) 	# load with offset
	  sw $t2, -68($fp)	# spill _tmp67 from $t2 to $fp-68
	# _tmp68 = *(_tmp67 + 4)
	  lw $t0, -68($fp)	# fill _tmp67 to $t0 from $fp-68
	  lw $t2, 4($t0) 	# load with offset
	  sw $t2, -72($fp)	# spill _tmp68 from $t2 to $fp-72
	# ACall _tmp68
	  lw $t0, -72($fp)	# fill _tmp68 to $t0 from $fp-72
	  jalr $t0            	# jump to function
	# PopParams 8
	  add $sp, $sp, 8	# pop params off stack
	# PushParam s
	  subu $sp, $sp, 4	# decrement sp to make space for param
	  lw $t0, -8($fp)	# fill s to $t0 from $fp-8
	  sw $t0, 4($sp)	# copy param value to stack
	# _tmp69 = *(s)
	  lw $t0, -8($fp)	# fill s to $t0 from $fp-8
	  lw $t2, 0($t0) 	# load with offset
	  sw $t2, -76($fp)	# spill _tmp69 from $t2 to $fp-76
	# _tmp70 = *(_tmp69 + 12)
	  lw $t0, -76($fp)	# fill _tmp69 to $t0 from $fp-76
	  lw $t2, 12($t0) 	# load with offset
	  sw $t2, -80($fp)	# spill _tmp70 from $t2 to $fp-80
	# _tmp71 = ACall _tmp70
	  lw $t0, -80($fp)	# fill _tmp70 to $t0 from $fp-80
	  jalr $t0            	# jump to function
	  move $t2, $v0		# copy function return value from $v0
	  sw $t2, -84($fp)	# spill _tmp71 from $t2 to $fp-84
	# PopParams 4
	  add $sp, $sp, 4	# pop params off stack
	# PushParam _tmp71
	  subu $sp, $sp, 4	# decrement sp to make space for param
	  lw $t0, -84($fp)	# fill _tmp71 to $t0 from $fp-84
	  sw $t0, 4($sp)	# copy param value to stack
	# LCall _PrintInt
	  jal _PrintInt      	# jump to function
	# PopParams 4
	  add $sp, $sp, 4	# pop params off stack
	# _tmp72 = " "
	  .data			# create string constant marked with label
	  _string4: .asciiz " "
	  .text
	  la $t2, _string4	# load label
	  sw $t2, -88($fp)	# spill _tmp72 from $t2 to $fp-88
	# PushParam _tmp72
	  subu $sp, $sp, 4	# decrement sp to make space for param
	  lw $t0, -88($fp)	# fill _tmp72 to $t0 from $fp-88
	  sw $t0, 4($sp)	# copy param value to stack
	# LCall _PrintString
	  jal _PrintString   	# jump to function
	# PopParams 4
	  add $sp, $sp, 4	# pop params off stack
	# PushParam s
	  subu $sp, $sp, 4	# decrement sp to make space for param
	  lw $t0, -8($fp)	# fill s to $t0 from $fp-8
	  sw $t0, 4($sp)	# copy param value to stack
	# _tmp73 = *(s)
	  lw $t0, -8($fp)	# fill s to $t0 from $fp-8
	  lw $t2, 0($t0) 	# load with offset
	  sw $t2, -92($fp)	# spill _tmp73 from $t2 to $fp-92
	# _tmp74 = *(_tmp73 + 8)
	  lw $t0, -92($fp)	# fill _tmp73 to $t0 from $fp-92
	  lw $t2, 8($t0) 	# load with offset
	  sw $t2, -96($fp)	# spill _tmp74 from $t2 to $fp-96
	# _tmp75 = ACall _tmp74
	  lw $t0, -96($fp)	# fill _tmp74 to $t0 from $fp-96
	  jalr $t0            	# jump to function
	  move $t2, $v0		# copy function return value from $v0
	  sw $t2, -100($fp)	# spill _tmp75 from $t2 to $fp-100
	# PopParams 4
	  add $sp, $sp, 4	# pop params off stack
	# PushParam _tmp75
	  subu $sp, $sp, 4	# decrement sp to make space for param
	  lw $t0, -100($fp)	# fill _tmp75 to $t0 from $fp-100
	  sw $t0, 4($sp)	# copy param value to stack
	# LCall _PrintInt
	  jal _PrintInt      	# jump to function
	# PopParams 4
	  add $sp, $sp, 4	# pop params off stack
	# _tmp76 = " "
	  .data			# create string constant marked with label
	  _string5: .asciiz " "
	  .text
	  la $t2, _string5	# load label
	  sw $t2, -104($fp)	# spill _tmp76 from $t2 to $fp-104
	# PushParam _tmp76
	  subu $sp, $sp, 4	# decrement sp to make space for param
	  lw $t0, -104($fp)	# fill _tmp76 to $t0 from $fp-104
	  sw $t0, 4($sp)	# copy param value to stack
	# LCall _PrintString
	  jal _PrintString   	# jump to function
	# PopParams 4
	  add $sp, $sp, 4	# pop params off stack
	# PushParam s
	  subu $sp, $sp, 4	# decrement sp to make space for param
	  lw $t0, -8($fp)	# fill s to $t0 from $fp-8
	  sw $t0, 4($sp)	# copy param value to stack
	# _tmp77 = *(s)
	  lw $t0, -8($fp)	# fill s to $t0 from $fp-8
	  lw $t2, 0($t0) 	# load with offset
	  sw $t2, -108($fp)	# spill _tmp77 from $t2 to $fp-108
	# _tmp78 = *(_tmp77 + 8)
	  lw $t0, -108($fp)	# fill _tmp77 to $t0 from $fp-108
	  lw $t2, 8($t0) 	# load with offset
	  sw $t2, -112($fp)	# spill _tmp78 from $t2 to $fp-112
	# _tmp79 = ACall _tmp78
	  lw $t0, -112($fp)	# fill _tmp78 to $t0 from $fp-112
	  jalr $t0            	# jump to function
	  move $t2, $v0		# copy function return value from $v0
	  sw $t2, -116($fp)	# spill _tmp79 from $t2 to $fp-116
	# PopParams 4
	  add $sp, $sp, 4	# pop params off stack
	# PushParam _tmp79
	  subu $sp, $sp, 4	# decrement sp to make space for param
	  lw $t0, -116($fp)	# fill _tmp79 to $t0 from $fp-116
	  sw $t0, 4($sp)	# copy param value to stack
	# LCall _PrintInt
	  jal _PrintInt      	# jump to function
	# PopParams 4
	  add $sp, $sp, 4	# pop params off stack
	# _tmp80 = " "
	  .data			# create string constant marked with label
	  _string6: .asciiz " "
	  .text
	  la $t2, _string6	# load label
	  sw $t2, -120($fp)	# spill _tmp80 from $t2 to $fp-120
	# PushParam _tmp80
	  subu $sp, $sp, 4	# decrement sp to make space for param
	  lw $t0, -120($fp)	# fill _tmp80 to $t0 from $fp-120
	  sw $t0, 4($sp)	# copy param value to stack
	# LCall _PrintString
	  jal _PrintString   	# jump to function
	# PopParams 4
	  add $sp, $sp, 4	# pop params off stack
	# PushParam s
	  subu $sp, $sp, 4	# decrement sp to make space for param
	  lw $t0, -8($fp)	# fill s to $t0 from $fp-8
	  sw $t0, 4($sp)	# copy param value to stack
	# _tmp81 = *(s)
	  lw $t0, -8($fp)	# fill s to $t0 from $fp-8
	  lw $t2, 0($t0) 	# load with offset
	  sw $t2, -124($fp)	# spill _tmp81 from $t2 to $fp-124
	# _tmp82 = *(_tmp81 + 8)
	  lw $t0, -124($fp)	# fill _tmp81 to $t0 from $fp-124
	  lw $t2, 8($t0) 	# load with offset
	  sw $t2, -128($fp)	# spill _tmp82 from $t2 to $fp-128
	# _tmp83 = ACall _tmp82
	  lw $t0, -128($fp)	# fill _tmp82 to $t0 from $fp-128
	  jalr $t0            	# jump to function
	  move $t2, $v0		# copy function return value from $v0
	  sw $t2, -132($fp)	# spill _tmp83 from $t2 to $fp-132
	# PopParams 4
	  add $sp, $sp, 4	# pop params off stack
	# PushParam _tmp83
	  subu $sp, $sp, 4	# decrement sp to make space for param
	  lw $t0, -132($fp)	# fill _tmp83 to $t0 from $fp-132
	  sw $t0, 4($sp)	# copy param value to stack
	# LCall _PrintInt
	  jal _PrintInt      	# jump to function
	# PopParams 4
	  add $sp, $sp, 4	# pop params off stack
	# _tmp84 = " "
	  .data			# create string constant marked with label
	  _string7: .asciiz " "
	  .text
	  la $t2, _string7	# load label
	  sw $t2, -136($fp)	# spill _tmp84 from $t2 to $fp-136
	# PushParam _tmp84
	  subu $sp, $sp, 4	# decrement sp to make space for param
	  lw $t0, -136($fp)	# fill _tmp84 to $t0 from $fp-136
	  sw $t0, 4($sp)	# copy param value to stack
	# LCall _PrintString
	  jal _PrintString   	# jump to function
	# PopParams 4
	  add $sp, $sp, 4	# pop params off stack
	# PushParam s
	  subu $sp, $sp, 4	# decrement sp to make space for param
	  lw $t0, -8($fp)	# fill s to $t0 from $fp-8
	  sw $t0, 4($sp)	# copy param value to stack
	# _tmp85 = *(s)
	  lw $t0, -8($fp)	# fill s to $t0 from $fp-8
	  lw $t2, 0($t0) 	# load with offset
	  sw $t2, -140($fp)	# spill _tmp85 from $t2 to $fp-140
	# _tmp86 = *(_tmp85 + 12)
	  lw $t0, -140($fp)	# fill _tmp85 to $t0 from $fp-140
	  lw $t2, 12($t0) 	# load with offset
	  sw $t2, -144($fp)	# spill _tmp86 from $t2 to $fp-144
	# _tmp87 = ACall _tmp86
	  lw $t0, -144($fp)	# fill _tmp86 to $t0 from $fp-144
	  jalr $t0            	# jump to function
	  move $t2, $v0		# copy function return value from $v0
	  sw $t2, -148($fp)	# spill _tmp87 from $t2 to $fp-148
	# PopParams 4
	  add $sp, $sp, 4	# pop params off stack
	# PushParam _tmp87
	  subu $sp, $sp, 4	# decrement sp to make space for param
	  lw $t0, -148($fp)	# fill _tmp87 to $t0 from $fp-148
	  sw $t0, 4($sp)	# copy param value to stack
	# LCall _PrintInt
	  jal _PrintInt      	# jump to function
	# PopParams 4
	  add $sp, $sp, 4	# pop params off stack
	# EndFunc
	# (below handles reaching end of fn body with no explicit return)
	  move $sp, $fp		# pop callee frame off stack
	  lw $ra, -4($fp)	# restore saved ra
	  lw $fp, 0($fp)	# restore saved fp
	  jr $ra		# return from function
