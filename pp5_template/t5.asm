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
	  
  ____Wild:
	# BeginFunc 100
	  subu $sp, $sp, 8	# decrement sp to make space to save ra, fp
	  sw $fp, 8($sp)	# save fp
	  sw $ra, 4($sp)	# save ra
	  addiu $fp, $sp, 8	# set up new fp
	  subu $sp, $sp, 100	# decrement sp to make space for locals/temps
	# _tmp0 = 0
	  li $t2, 0		# load constant value 0 into $t2
	  sw $t2, -12($fp)	# spill _tmp0 from $t2 to $fp-12
	# i = _tmp0
	  lw $t2, -12($fp)	# fill _tmp0 to $t2 from $fp-12
	  sw $t2, -8($fp)	# spill i from $t2 to $fp-8
  _L0:
	# _tmp1 = *(names)
	  lw $t0, 4($fp)	# fill names to $t0 from $fp+4
	  lw $t2, 0($t0) 	# load with offset
	  sw $t2, -16($fp)	# spill _tmp1 from $t2 to $fp-16
	# _tmp2 = i < _tmp1
	  lw $t0, -8($fp)	# fill i to $t0 from $fp-8
	  lw $t1, -16($fp)	# fill _tmp1 to $t1 from $fp-16
	  slt $t2, $t0, $t1	
	  sw $t2, -20($fp)	# spill _tmp2 from $t2 to $fp-20
	# IfZ _tmp2 Goto _L1
	  lw $t0, -20($fp)	# fill _tmp2 to $t0 from $fp-20
	  beqz $t0, _L1	# branch if _tmp2 is zero 
	# _tmp3 = 0
	  li $t2, 0		# load constant value 0 into $t2
	  sw $t2, -24($fp)	# spill _tmp3 from $t2 to $fp-24
	# _tmp4 = *(names)
	  lw $t0, 4($fp)	# fill names to $t0 from $fp+4
	  lw $t2, 0($t0) 	# load with offset
	  sw $t2, -28($fp)	# spill _tmp4 from $t2 to $fp-28
	# _tmp5 = i < _tmp3
	  lw $t0, -8($fp)	# fill i to $t0 from $fp-8
	  lw $t1, -24($fp)	# fill _tmp3 to $t1 from $fp-24
	  slt $t2, $t0, $t1	
	  sw $t2, -32($fp)	# spill _tmp5 from $t2 to $fp-32
	# _tmp6 = _tmp4 < i
	  lw $t0, -28($fp)	# fill _tmp4 to $t0 from $fp-28
	  lw $t1, -8($fp)	# fill i to $t1 from $fp-8
	  slt $t2, $t0, $t1	
	  sw $t2, -36($fp)	# spill _tmp6 from $t2 to $fp-36
	# _tmp7 = _tmp4 == i
	  lw $t0, -28($fp)	# fill _tmp4 to $t0 from $fp-28
	  lw $t1, -8($fp)	# fill i to $t1 from $fp-8
	  seq $t2, $t0, $t1	
	  sw $t2, -40($fp)	# spill _tmp7 from $t2 to $fp-40
	# _tmp8 = _tmp6 || _tmp7
	  lw $t0, -36($fp)	# fill _tmp6 to $t0 from $fp-36
	  lw $t1, -40($fp)	# fill _tmp7 to $t1 from $fp-40
	  or $t2, $t0, $t1	
	  sw $t2, -44($fp)	# spill _tmp8 from $t2 to $fp-44
	# _tmp9 = _tmp8 || _tmp5
	  lw $t0, -44($fp)	# fill _tmp8 to $t0 from $fp-44
	  lw $t1, -32($fp)	# fill _tmp5 to $t1 from $fp-32
	  or $t2, $t0, $t1	
	  sw $t2, -48($fp)	# spill _tmp9 from $t2 to $fp-48
	# IfZ _tmp9 Goto _L4
	  lw $t0, -48($fp)	# fill _tmp9 to $t0 from $fp-48
	  beqz $t0, _L4	# branch if _tmp9 is zero 
	# _tmp10 = "Decaf runtime error: Array subscript out of bound..."
	  .data			# create string constant marked with label
	  _string1: .asciiz "Decaf runtime error: Array subscript out of bounds\n"
	  .text
	  la $t2, _string1	# load label
	  sw $t2, -52($fp)	# spill _tmp10 from $t2 to $fp-52
	# PushParam _tmp10
	  subu $sp, $sp, 4	# decrement sp to make space for param
	  lw $t0, -52($fp)	# fill _tmp10 to $t0 from $fp-52
	  sw $t0, 4($sp)	# copy param value to stack
	# LCall _PrintString
	  jal _PrintString   	# jump to function
	# PopParams 4
	  add $sp, $sp, 4	# pop params off stack
	# LCall _Halt
	  jal _Halt          	# jump to function
  _L4:
	# _tmp11 = 4
	  li $t2, 4		# load constant value 4 into $t2
	  sw $t2, -56($fp)	# spill _tmp11 from $t2 to $fp-56
	# _tmp12 = i * _tmp11
	  lw $t0, -8($fp)	# fill i to $t0 from $fp-8
	  lw $t1, -56($fp)	# fill _tmp11 to $t1 from $fp-56
	  mul $t2, $t0, $t1	
	  sw $t2, -60($fp)	# spill _tmp12 from $t2 to $fp-60
	# _tmp13 = _tmp12 + _tmp11
	  lw $t0, -60($fp)	# fill _tmp12 to $t0 from $fp-60
	  lw $t1, -56($fp)	# fill _tmp11 to $t1 from $fp-56
	  add $t2, $t0, $t1	
	  sw $t2, -64($fp)	# spill _tmp13 from $t2 to $fp-64
	# _tmp14 = names + _tmp13
	  lw $t0, 4($fp)	# fill names to $t0 from $fp+4
	  lw $t1, -64($fp)	# fill _tmp13 to $t1 from $fp-64
	  add $t2, $t0, $t1	
	  sw $t2, -68($fp)	# spill _tmp14 from $t2 to $fp-68
	# _tmp15 = *(_tmp14)
	  lw $t0, -68($fp)	# fill _tmp14 to $t0 from $fp-68
	  lw $t2, 0($t0) 	# load with offset
	  sw $t2, -72($fp)	# spill _tmp15 from $t2 to $fp-72
	# _tmp16 = _tmp15 == answer
	  lw $t0, -72($fp)	# fill _tmp15 to $t0 from $fp-72
	  lw $t1, 8($fp)	# fill answer to $t1 from $fp+8
	  seq $t2, $t0, $t1	
	  sw $t2, -76($fp)	# spill _tmp16 from $t2 to $fp-76
	# IfZ _tmp16 Goto _L2
	  lw $t0, -76($fp)	# fill _tmp16 to $t0 from $fp-76
	  beqz $t0, _L2	# branch if _tmp16 is zero 
	# _tmp17 = 1
	  li $t2, 1		# load constant value 1 into $t2
	  sw $t2, -80($fp)	# spill _tmp17 from $t2 to $fp-80
	# Return _tmp17
	  lw $t2, -80($fp)	# fill _tmp17 to $t2 from $fp-80
	  move $v0, $t2		# assign return value into $v0
	  move $sp, $fp		# pop callee frame off stack
	  lw $ra, -4($fp)	# restore saved ra
	  lw $fp, 0($fp)	# restore saved fp
	  jr $ra		# return from function
	# Goto _L3
	  b _L3		# unconditional branch
  _L2:
  _L3:
	# _tmp18 = 1
	  li $t2, 1		# load constant value 1 into $t2
	  sw $t2, -84($fp)	# spill _tmp18 from $t2 to $fp-84
	# _tmp19 = i + _tmp18
	  lw $t0, -8($fp)	# fill i to $t0 from $fp-8
	  lw $t1, -84($fp)	# fill _tmp18 to $t1 from $fp-84
	  add $t2, $t0, $t1	
	  sw $t2, -88($fp)	# spill _tmp19 from $t2 to $fp-88
	# i = _tmp19
	  lw $t2, -88($fp)	# fill _tmp19 to $t2 from $fp-88
	  sw $t2, -8($fp)	# spill i from $t2 to $fp-8
	# Goto _L0
	  b _L0		# unconditional branch
  _L1:
	# _tmp20 = 0
	  li $t2, 0		# load constant value 0 into $t2
	  sw $t2, -92($fp)	# spill _tmp20 from $t2 to $fp-92
	# Return _tmp20
	  lw $t2, -92($fp)	# fill _tmp20 to $t2 from $fp-92
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
  main:
	# BeginFunc 328
	  subu $sp, $sp, 8	# decrement sp to make space to save ra, fp
	  sw $fp, 8($sp)	# save fp
	  sw $ra, 4($sp)	# save ra
	  addiu $fp, $sp, 8	# set up new fp
	  subu $sp, $sp, 328	# decrement sp to make space for locals/temps
	# _tmp21 = 4
	  li $t2, 4		# load constant value 4 into $t2
	  sw $t2, -12($fp)	# spill _tmp21 from $t2 to $fp-12
	# _tmp22 = 4
	  li $t2, 4		# load constant value 4 into $t2
	  sw $t2, -16($fp)	# spill _tmp22 from $t2 to $fp-16
	# _tmp23 = 0
	  li $t2, 0		# load constant value 0 into $t2
	  sw $t2, -20($fp)	# spill _tmp23 from $t2 to $fp-20
	# _tmp24 = _tmp21 < _tmp23
	  lw $t0, -12($fp)	# fill _tmp21 to $t0 from $fp-12
	  lw $t1, -20($fp)	# fill _tmp23 to $t1 from $fp-20
	  slt $t2, $t0, $t1	
	  sw $t2, -24($fp)	# spill _tmp24 from $t2 to $fp-24
	# _tmp25 = _tmp21 == _tmp23
	  lw $t0, -12($fp)	# fill _tmp21 to $t0 from $fp-12
	  lw $t1, -20($fp)	# fill _tmp23 to $t1 from $fp-20
	  seq $t2, $t0, $t1	
	  sw $t2, -28($fp)	# spill _tmp25 from $t2 to $fp-28
	# _tmp26 = _tmp24 || _tmp25
	  lw $t0, -24($fp)	# fill _tmp24 to $t0 from $fp-24
	  lw $t1, -28($fp)	# fill _tmp25 to $t1 from $fp-28
	  or $t2, $t0, $t1	
	  sw $t2, -32($fp)	# spill _tmp26 from $t2 to $fp-32
	# IfZ _tmp26 Goto _L5
	  lw $t0, -32($fp)	# fill _tmp26 to $t0 from $fp-32
	  beqz $t0, _L5	# branch if _tmp26 is zero 
	# _tmp27 = "Decaf runtime error: Array size is <= 0\n"
	  .data			# create string constant marked with label
	  _string2: .asciiz "Decaf runtime error: Array size is <= 0\n"
	  .text
	  la $t2, _string2	# load label
	  sw $t2, -36($fp)	# spill _tmp27 from $t2 to $fp-36
	# PushParam _tmp27
	  subu $sp, $sp, 4	# decrement sp to make space for param
	  lw $t0, -36($fp)	# fill _tmp27 to $t0 from $fp-36
	  sw $t0, 4($sp)	# copy param value to stack
	# LCall _PrintString
	  jal _PrintString   	# jump to function
	# PopParams 4
	  add $sp, $sp, 4	# pop params off stack
	# LCall _Halt
	  jal _Halt          	# jump to function
  _L5:
	# _tmp28 = _tmp21 * _tmp22
	  lw $t0, -12($fp)	# fill _tmp21 to $t0 from $fp-12
	  lw $t1, -16($fp)	# fill _tmp22 to $t1 from $fp-16
	  mul $t2, $t0, $t1	
	  sw $t2, -40($fp)	# spill _tmp28 from $t2 to $fp-40
	# _tmp29 = _tmp22 + _tmp28
	  lw $t0, -16($fp)	# fill _tmp22 to $t0 from $fp-16
	  lw $t1, -40($fp)	# fill _tmp28 to $t1 from $fp-40
	  add $t2, $t0, $t1	
	  sw $t2, -44($fp)	# spill _tmp29 from $t2 to $fp-44
	# PushParam _tmp29
	  subu $sp, $sp, 4	# decrement sp to make space for param
	  lw $t0, -44($fp)	# fill _tmp29 to $t0 from $fp-44
	  sw $t0, 4($sp)	# copy param value to stack
	# _tmp30 = LCall _Alloc
	  jal _Alloc         	# jump to function
	  move $t2, $v0		# copy function return value from $v0
	  sw $t2, -48($fp)	# spill _tmp30 from $t2 to $fp-48
	# PopParams 4
	  add $sp, $sp, 4	# pop params off stack
	# *(_tmp30) = _tmp21
	  lw $t0, -12($fp)	# fill _tmp21 to $t0 from $fp-12
	  lw $t2, -48($fp)	# fill _tmp30 to $t2 from $fp-48
	  sw $t0, 0($t2) 	# store with offset
	# names = _tmp30
	  lw $t2, -48($fp)	# fill _tmp30 to $t2 from $fp-48
	  sw $t2, -8($fp)	# spill names from $t2 to $fp-8
	# _tmp31 = "Brian"
	  .data			# create string constant marked with label
	  _string3: .asciiz "Brian"
	  .text
	  la $t2, _string3	# load label
	  sw $t2, -52($fp)	# spill _tmp31 from $t2 to $fp-52
	# _tmp32 = 0
	  li $t2, 0		# load constant value 0 into $t2
	  sw $t2, -56($fp)	# spill _tmp32 from $t2 to $fp-56
	# _tmp33 = 0
	  li $t2, 0		# load constant value 0 into $t2
	  sw $t2, -60($fp)	# spill _tmp33 from $t2 to $fp-60
	# _tmp34 = *(names)
	  lw $t0, -8($fp)	# fill names to $t0 from $fp-8
	  lw $t2, 0($t0) 	# load with offset
	  sw $t2, -64($fp)	# spill _tmp34 from $t2 to $fp-64
	# _tmp35 = _tmp32 < _tmp33
	  lw $t0, -56($fp)	# fill _tmp32 to $t0 from $fp-56
	  lw $t1, -60($fp)	# fill _tmp33 to $t1 from $fp-60
	  slt $t2, $t0, $t1	
	  sw $t2, -68($fp)	# spill _tmp35 from $t2 to $fp-68
	# _tmp36 = _tmp34 < _tmp32
	  lw $t0, -64($fp)	# fill _tmp34 to $t0 from $fp-64
	  lw $t1, -56($fp)	# fill _tmp32 to $t1 from $fp-56
	  slt $t2, $t0, $t1	
	  sw $t2, -72($fp)	# spill _tmp36 from $t2 to $fp-72
	# _tmp37 = _tmp34 == _tmp32
	  lw $t0, -64($fp)	# fill _tmp34 to $t0 from $fp-64
	  lw $t1, -56($fp)	# fill _tmp32 to $t1 from $fp-56
	  seq $t2, $t0, $t1	
	  sw $t2, -76($fp)	# spill _tmp37 from $t2 to $fp-76
	# _tmp38 = _tmp36 || _tmp37
	  lw $t0, -72($fp)	# fill _tmp36 to $t0 from $fp-72
	  lw $t1, -76($fp)	# fill _tmp37 to $t1 from $fp-76
	  or $t2, $t0, $t1	
	  sw $t2, -80($fp)	# spill _tmp38 from $t2 to $fp-80
	# _tmp39 = _tmp38 || _tmp35
	  lw $t0, -80($fp)	# fill _tmp38 to $t0 from $fp-80
	  lw $t1, -68($fp)	# fill _tmp35 to $t1 from $fp-68
	  or $t2, $t0, $t1	
	  sw $t2, -84($fp)	# spill _tmp39 from $t2 to $fp-84
	# IfZ _tmp39 Goto _L6
	  lw $t0, -84($fp)	# fill _tmp39 to $t0 from $fp-84
	  beqz $t0, _L6	# branch if _tmp39 is zero 
	# _tmp40 = "Decaf runtime error: Array subscript out of bound..."
	  .data			# create string constant marked with label
	  _string4: .asciiz "Decaf runtime error: Array subscript out of bounds\n"
	  .text
	  la $t2, _string4	# load label
	  sw $t2, -88($fp)	# spill _tmp40 from $t2 to $fp-88
	# PushParam _tmp40
	  subu $sp, $sp, 4	# decrement sp to make space for param
	  lw $t0, -88($fp)	# fill _tmp40 to $t0 from $fp-88
	  sw $t0, 4($sp)	# copy param value to stack
	# LCall _PrintString
	  jal _PrintString   	# jump to function
	# PopParams 4
	  add $sp, $sp, 4	# pop params off stack
	# LCall _Halt
	  jal _Halt          	# jump to function
  _L6:
	# _tmp41 = 4
	  li $t2, 4		# load constant value 4 into $t2
	  sw $t2, -92($fp)	# spill _tmp41 from $t2 to $fp-92
	# _tmp42 = _tmp32 * _tmp41
	  lw $t0, -56($fp)	# fill _tmp32 to $t0 from $fp-56
	  lw $t1, -92($fp)	# fill _tmp41 to $t1 from $fp-92
	  mul $t2, $t0, $t1	
	  sw $t2, -96($fp)	# spill _tmp42 from $t2 to $fp-96
	# _tmp43 = _tmp42 + _tmp41
	  lw $t0, -96($fp)	# fill _tmp42 to $t0 from $fp-96
	  lw $t1, -92($fp)	# fill _tmp41 to $t1 from $fp-92
	  add $t2, $t0, $t1	
	  sw $t2, -100($fp)	# spill _tmp43 from $t2 to $fp-100
	# _tmp44 = names + _tmp43
	  lw $t0, -8($fp)	# fill names to $t0 from $fp-8
	  lw $t1, -100($fp)	# fill _tmp43 to $t1 from $fp-100
	  add $t2, $t0, $t1	
	  sw $t2, -104($fp)	# spill _tmp44 from $t2 to $fp-104
	# *(_tmp44) = _tmp31
	  lw $t0, -52($fp)	# fill _tmp31 to $t0 from $fp-52
	  lw $t2, -104($fp)	# fill _tmp44 to $t2 from $fp-104
	  sw $t0, 0($t2) 	# store with offset
	# _tmp45 = *(_tmp44)
	  lw $t0, -104($fp)	# fill _tmp44 to $t0 from $fp-104
	  lw $t2, 0($t0) 	# load with offset
	  sw $t2, -108($fp)	# spill _tmp45 from $t2 to $fp-108
	# _tmp46 = "Cam"
	  .data			# create string constant marked with label
	  _string5: .asciiz "Cam"
	  .text
	  la $t2, _string5	# load label
	  sw $t2, -112($fp)	# spill _tmp46 from $t2 to $fp-112
	# _tmp47 = 1
	  li $t2, 1		# load constant value 1 into $t2
	  sw $t2, -116($fp)	# spill _tmp47 from $t2 to $fp-116
	# _tmp48 = 0
	  li $t2, 0		# load constant value 0 into $t2
	  sw $t2, -120($fp)	# spill _tmp48 from $t2 to $fp-120
	# _tmp49 = *(names)
	  lw $t0, -8($fp)	# fill names to $t0 from $fp-8
	  lw $t2, 0($t0) 	# load with offset
	  sw $t2, -124($fp)	# spill _tmp49 from $t2 to $fp-124
	# _tmp50 = _tmp47 < _tmp48
	  lw $t0, -116($fp)	# fill _tmp47 to $t0 from $fp-116
	  lw $t1, -120($fp)	# fill _tmp48 to $t1 from $fp-120
	  slt $t2, $t0, $t1	
	  sw $t2, -128($fp)	# spill _tmp50 from $t2 to $fp-128
	# _tmp51 = _tmp49 < _tmp47
	  lw $t0, -124($fp)	# fill _tmp49 to $t0 from $fp-124
	  lw $t1, -116($fp)	# fill _tmp47 to $t1 from $fp-116
	  slt $t2, $t0, $t1	
	  sw $t2, -132($fp)	# spill _tmp51 from $t2 to $fp-132
	# _tmp52 = _tmp49 == _tmp47
	  lw $t0, -124($fp)	# fill _tmp49 to $t0 from $fp-124
	  lw $t1, -116($fp)	# fill _tmp47 to $t1 from $fp-116
	  seq $t2, $t0, $t1	
	  sw $t2, -136($fp)	# spill _tmp52 from $t2 to $fp-136
	# _tmp53 = _tmp51 || _tmp52
	  lw $t0, -132($fp)	# fill _tmp51 to $t0 from $fp-132
	  lw $t1, -136($fp)	# fill _tmp52 to $t1 from $fp-136
	  or $t2, $t0, $t1	
	  sw $t2, -140($fp)	# spill _tmp53 from $t2 to $fp-140
	# _tmp54 = _tmp53 || _tmp50
	  lw $t0, -140($fp)	# fill _tmp53 to $t0 from $fp-140
	  lw $t1, -128($fp)	# fill _tmp50 to $t1 from $fp-128
	  or $t2, $t0, $t1	
	  sw $t2, -144($fp)	# spill _tmp54 from $t2 to $fp-144
	# IfZ _tmp54 Goto _L7
	  lw $t0, -144($fp)	# fill _tmp54 to $t0 from $fp-144
	  beqz $t0, _L7	# branch if _tmp54 is zero 
	# _tmp55 = "Decaf runtime error: Array subscript out of bound..."
	  .data			# create string constant marked with label
	  _string6: .asciiz "Decaf runtime error: Array subscript out of bounds\n"
	  .text
	  la $t2, _string6	# load label
	  sw $t2, -148($fp)	# spill _tmp55 from $t2 to $fp-148
	# PushParam _tmp55
	  subu $sp, $sp, 4	# decrement sp to make space for param
	  lw $t0, -148($fp)	# fill _tmp55 to $t0 from $fp-148
	  sw $t0, 4($sp)	# copy param value to stack
	# LCall _PrintString
	  jal _PrintString   	# jump to function
	# PopParams 4
	  add $sp, $sp, 4	# pop params off stack
	# LCall _Halt
	  jal _Halt          	# jump to function
  _L7:
	# _tmp56 = 4
	  li $t2, 4		# load constant value 4 into $t2
	  sw $t2, -152($fp)	# spill _tmp56 from $t2 to $fp-152
	# _tmp57 = _tmp47 * _tmp56
	  lw $t0, -116($fp)	# fill _tmp47 to $t0 from $fp-116
	  lw $t1, -152($fp)	# fill _tmp56 to $t1 from $fp-152
	  mul $t2, $t0, $t1	
	  sw $t2, -156($fp)	# spill _tmp57 from $t2 to $fp-156
	# _tmp58 = _tmp57 + _tmp56
	  lw $t0, -156($fp)	# fill _tmp57 to $t0 from $fp-156
	  lw $t1, -152($fp)	# fill _tmp56 to $t1 from $fp-152
	  add $t2, $t0, $t1	
	  sw $t2, -160($fp)	# spill _tmp58 from $t2 to $fp-160
	# _tmp59 = names + _tmp58
	  lw $t0, -8($fp)	# fill names to $t0 from $fp-8
	  lw $t1, -160($fp)	# fill _tmp58 to $t1 from $fp-160
	  add $t2, $t0, $t1	
	  sw $t2, -164($fp)	# spill _tmp59 from $t2 to $fp-164
	# *(_tmp59) = _tmp46
	  lw $t0, -112($fp)	# fill _tmp46 to $t0 from $fp-112
	  lw $t2, -164($fp)	# fill _tmp59 to $t2 from $fp-164
	  sw $t0, 0($t2) 	# store with offset
	# _tmp60 = *(_tmp59)
	  lw $t0, -164($fp)	# fill _tmp59 to $t0 from $fp-164
	  lw $t2, 0($t0) 	# load with offset
	  sw $t2, -168($fp)	# spill _tmp60 from $t2 to $fp-168
	# _tmp61 = "Gavan"
	  .data			# create string constant marked with label
	  _string7: .asciiz "Gavan"
	  .text
	  la $t2, _string7	# load label
	  sw $t2, -172($fp)	# spill _tmp61 from $t2 to $fp-172
	# _tmp62 = 2
	  li $t2, 2		# load constant value 2 into $t2
	  sw $t2, -176($fp)	# spill _tmp62 from $t2 to $fp-176
	# _tmp63 = 0
	  li $t2, 0		# load constant value 0 into $t2
	  sw $t2, -180($fp)	# spill _tmp63 from $t2 to $fp-180
	# _tmp64 = *(names)
	  lw $t0, -8($fp)	# fill names to $t0 from $fp-8
	  lw $t2, 0($t0) 	# load with offset
	  sw $t2, -184($fp)	# spill _tmp64 from $t2 to $fp-184
	# _tmp65 = _tmp62 < _tmp63
	  lw $t0, -176($fp)	# fill _tmp62 to $t0 from $fp-176
	  lw $t1, -180($fp)	# fill _tmp63 to $t1 from $fp-180
	  slt $t2, $t0, $t1	
	  sw $t2, -188($fp)	# spill _tmp65 from $t2 to $fp-188
	# _tmp66 = _tmp64 < _tmp62
	  lw $t0, -184($fp)	# fill _tmp64 to $t0 from $fp-184
	  lw $t1, -176($fp)	# fill _tmp62 to $t1 from $fp-176
	  slt $t2, $t0, $t1	
	  sw $t2, -192($fp)	# spill _tmp66 from $t2 to $fp-192
	# _tmp67 = _tmp64 == _tmp62
	  lw $t0, -184($fp)	# fill _tmp64 to $t0 from $fp-184
	  lw $t1, -176($fp)	# fill _tmp62 to $t1 from $fp-176
	  seq $t2, $t0, $t1	
	  sw $t2, -196($fp)	# spill _tmp67 from $t2 to $fp-196
	# _tmp68 = _tmp66 || _tmp67
	  lw $t0, -192($fp)	# fill _tmp66 to $t0 from $fp-192
	  lw $t1, -196($fp)	# fill _tmp67 to $t1 from $fp-196
	  or $t2, $t0, $t1	
	  sw $t2, -200($fp)	# spill _tmp68 from $t2 to $fp-200
	# _tmp69 = _tmp68 || _tmp65
	  lw $t0, -200($fp)	# fill _tmp68 to $t0 from $fp-200
	  lw $t1, -188($fp)	# fill _tmp65 to $t1 from $fp-188
	  or $t2, $t0, $t1	
	  sw $t2, -204($fp)	# spill _tmp69 from $t2 to $fp-204
	# IfZ _tmp69 Goto _L8
	  lw $t0, -204($fp)	# fill _tmp69 to $t0 from $fp-204
	  beqz $t0, _L8	# branch if _tmp69 is zero 
	# _tmp70 = "Decaf runtime error: Array subscript out of bound..."
	  .data			# create string constant marked with label
	  _string8: .asciiz "Decaf runtime error: Array subscript out of bounds\n"
	  .text
	  la $t2, _string8	# load label
	  sw $t2, -208($fp)	# spill _tmp70 from $t2 to $fp-208
	# PushParam _tmp70
	  subu $sp, $sp, 4	# decrement sp to make space for param
	  lw $t0, -208($fp)	# fill _tmp70 to $t0 from $fp-208
	  sw $t0, 4($sp)	# copy param value to stack
	# LCall _PrintString
	  jal _PrintString   	# jump to function
	# PopParams 4
	  add $sp, $sp, 4	# pop params off stack
	# LCall _Halt
	  jal _Halt          	# jump to function
  _L8:
	# _tmp71 = 4
	  li $t2, 4		# load constant value 4 into $t2
	  sw $t2, -212($fp)	# spill _tmp71 from $t2 to $fp-212
	# _tmp72 = _tmp62 * _tmp71
	  lw $t0, -176($fp)	# fill _tmp62 to $t0 from $fp-176
	  lw $t1, -212($fp)	# fill _tmp71 to $t1 from $fp-212
	  mul $t2, $t0, $t1	
	  sw $t2, -216($fp)	# spill _tmp72 from $t2 to $fp-216
	# _tmp73 = _tmp72 + _tmp71
	  lw $t0, -216($fp)	# fill _tmp72 to $t0 from $fp-216
	  lw $t1, -212($fp)	# fill _tmp71 to $t1 from $fp-212
	  add $t2, $t0, $t1	
	  sw $t2, -220($fp)	# spill _tmp73 from $t2 to $fp-220
	# _tmp74 = names + _tmp73
	  lw $t0, -8($fp)	# fill names to $t0 from $fp-8
	  lw $t1, -220($fp)	# fill _tmp73 to $t1 from $fp-220
	  add $t2, $t0, $t1	
	  sw $t2, -224($fp)	# spill _tmp74 from $t2 to $fp-224
	# *(_tmp74) = _tmp61
	  lw $t0, -172($fp)	# fill _tmp61 to $t0 from $fp-172
	  lw $t2, -224($fp)	# fill _tmp74 to $t2 from $fp-224
	  sw $t0, 0($t2) 	# store with offset
	# _tmp75 = *(_tmp74)
	  lw $t0, -224($fp)	# fill _tmp74 to $t0 from $fp-224
	  lw $t2, 0($t0) 	# load with offset
	  sw $t2, -228($fp)	# spill _tmp75 from $t2 to $fp-228
	# _tmp76 = "Julie"
	  .data			# create string constant marked with label
	  _string9: .asciiz "Julie"
	  .text
	  la $t2, _string9	# load label
	  sw $t2, -232($fp)	# spill _tmp76 from $t2 to $fp-232
	# _tmp77 = 3
	  li $t2, 3		# load constant value 3 into $t2
	  sw $t2, -236($fp)	# spill _tmp77 from $t2 to $fp-236
	# _tmp78 = 0
	  li $t2, 0		# load constant value 0 into $t2
	  sw $t2, -240($fp)	# spill _tmp78 from $t2 to $fp-240
	# _tmp79 = *(names)
	  lw $t0, -8($fp)	# fill names to $t0 from $fp-8
	  lw $t2, 0($t0) 	# load with offset
	  sw $t2, -244($fp)	# spill _tmp79 from $t2 to $fp-244
	# _tmp80 = _tmp77 < _tmp78
	  lw $t0, -236($fp)	# fill _tmp77 to $t0 from $fp-236
	  lw $t1, -240($fp)	# fill _tmp78 to $t1 from $fp-240
	  slt $t2, $t0, $t1	
	  sw $t2, -248($fp)	# spill _tmp80 from $t2 to $fp-248
	# _tmp81 = _tmp79 < _tmp77
	  lw $t0, -244($fp)	# fill _tmp79 to $t0 from $fp-244
	  lw $t1, -236($fp)	# fill _tmp77 to $t1 from $fp-236
	  slt $t2, $t0, $t1	
	  sw $t2, -252($fp)	# spill _tmp81 from $t2 to $fp-252
	# _tmp82 = _tmp79 == _tmp77
	  lw $t0, -244($fp)	# fill _tmp79 to $t0 from $fp-244
	  lw $t1, -236($fp)	# fill _tmp77 to $t1 from $fp-236
	  seq $t2, $t0, $t1	
	  sw $t2, -256($fp)	# spill _tmp82 from $t2 to $fp-256
	# _tmp83 = _tmp81 || _tmp82
	  lw $t0, -252($fp)	# fill _tmp81 to $t0 from $fp-252
	  lw $t1, -256($fp)	# fill _tmp82 to $t1 from $fp-256
	  or $t2, $t0, $t1	
	  sw $t2, -260($fp)	# spill _tmp83 from $t2 to $fp-260
	# _tmp84 = _tmp83 || _tmp80
	  lw $t0, -260($fp)	# fill _tmp83 to $t0 from $fp-260
	  lw $t1, -248($fp)	# fill _tmp80 to $t1 from $fp-248
	  or $t2, $t0, $t1	
	  sw $t2, -264($fp)	# spill _tmp84 from $t2 to $fp-264
	# IfZ _tmp84 Goto _L9
	  lw $t0, -264($fp)	# fill _tmp84 to $t0 from $fp-264
	  beqz $t0, _L9	# branch if _tmp84 is zero 
	# _tmp85 = "Decaf runtime error: Array subscript out of bound..."
	  .data			# create string constant marked with label
	  _string10: .asciiz "Decaf runtime error: Array subscript out of bounds\n"
	  .text
	  la $t2, _string10	# load label
	  sw $t2, -268($fp)	# spill _tmp85 from $t2 to $fp-268
	# PushParam _tmp85
	  subu $sp, $sp, 4	# decrement sp to make space for param
	  lw $t0, -268($fp)	# fill _tmp85 to $t0 from $fp-268
	  sw $t0, 4($sp)	# copy param value to stack
	# LCall _PrintString
	  jal _PrintString   	# jump to function
	# PopParams 4
	  add $sp, $sp, 4	# pop params off stack
	# LCall _Halt
	  jal _Halt          	# jump to function
  _L9:
	# _tmp86 = 4
	  li $t2, 4		# load constant value 4 into $t2
	  sw $t2, -272($fp)	# spill _tmp86 from $t2 to $fp-272
	# _tmp87 = _tmp77 * _tmp86
	  lw $t0, -236($fp)	# fill _tmp77 to $t0 from $fp-236
	  lw $t1, -272($fp)	# fill _tmp86 to $t1 from $fp-272
	  mul $t2, $t0, $t1	
	  sw $t2, -276($fp)	# spill _tmp87 from $t2 to $fp-276
	# _tmp88 = _tmp87 + _tmp86
	  lw $t0, -276($fp)	# fill _tmp87 to $t0 from $fp-276
	  lw $t1, -272($fp)	# fill _tmp86 to $t1 from $fp-272
	  add $t2, $t0, $t1	
	  sw $t2, -280($fp)	# spill _tmp88 from $t2 to $fp-280
	# _tmp89 = names + _tmp88
	  lw $t0, -8($fp)	# fill names to $t0 from $fp-8
	  lw $t1, -280($fp)	# fill _tmp88 to $t1 from $fp-280
	  add $t2, $t0, $t1	
	  sw $t2, -284($fp)	# spill _tmp89 from $t2 to $fp-284
	# *(_tmp89) = _tmp76
	  lw $t0, -232($fp)	# fill _tmp76 to $t0 from $fp-232
	  lw $t2, -284($fp)	# fill _tmp89 to $t2 from $fp-284
	  sw $t0, 0($t2) 	# store with offset
	# _tmp90 = *(_tmp89)
	  lw $t0, -284($fp)	# fill _tmp89 to $t0 from $fp-284
	  lw $t2, 0($t0) 	# load with offset
	  sw $t2, -288($fp)	# spill _tmp90 from $t2 to $fp-288
  _L10:
	# _tmp91 = 1
	  li $t2, 1		# load constant value 1 into $t2
	  sw $t2, -292($fp)	# spill _tmp91 from $t2 to $fp-292
	# IfZ _tmp91 Goto _L11
	  lw $t0, -292($fp)	# fill _tmp91 to $t0 from $fp-292
	  beqz $t0, _L11	# branch if _tmp91 is zero 
	# _tmp92 = "\nWho is your favorite CS143 staff member? "
	  .data			# create string constant marked with label
	  _string11: .asciiz "\nWho is your favorite CS143 staff member? "
	  .text
	  la $t2, _string11	# load label
	  sw $t2, -296($fp)	# spill _tmp92 from $t2 to $fp-296
	# PushParam _tmp92
	  subu $sp, $sp, 4	# decrement sp to make space for param
	  lw $t0, -296($fp)	# fill _tmp92 to $t0 from $fp-296
	  sw $t0, 4($sp)	# copy param value to stack
	# LCall _PrintString
	  jal _PrintString   	# jump to function
	# PopParams 4
	  add $sp, $sp, 4	# pop params off stack
	# _tmp93 = LCall _ReadLine
	  jal _ReadLine      	# jump to function
	  move $t2, $v0		# copy function return value from $v0
	  sw $t2, -300($fp)	# spill _tmp93 from $t2 to $fp-300
	# PushParam _tmp93
	  subu $sp, $sp, 4	# decrement sp to make space for param
	  lw $t0, -300($fp)	# fill _tmp93 to $t0 from $fp-300
	  sw $t0, 4($sp)	# copy param value to stack
	# PushParam names
	  subu $sp, $sp, 4	# decrement sp to make space for param
	  lw $t0, -8($fp)	# fill names to $t0 from $fp-8
	  sw $t0, 4($sp)	# copy param value to stack
	# _tmp94 = LCall ____Wild
	  jal ____Wild       	# jump to function
	  move $t2, $v0		# copy function return value from $v0
	  sw $t2, -304($fp)	# spill _tmp94 from $t2 to $fp-304
	# PopParams 8
	  add $sp, $sp, 8	# pop params off stack
	# IfZ _tmp94 Goto _L12
	  lw $t0, -304($fp)	# fill _tmp94 to $t0 from $fp-304
	  beqz $t0, _L12	# branch if _tmp94 is zero 
	# _tmp95 = "You just earned 1000 bonus points!\n"
	  .data			# create string constant marked with label
	  _string12: .asciiz "You just earned 1000 bonus points!\n"
	  .text
	  la $t2, _string12	# load label
	  sw $t2, -308($fp)	# spill _tmp95 from $t2 to $fp-308
	# PushParam _tmp95
	  subu $sp, $sp, 4	# decrement sp to make space for param
	  lw $t0, -308($fp)	# fill _tmp95 to $t0 from $fp-308
	  sw $t0, 4($sp)	# copy param value to stack
	# LCall _PrintString
	  jal _PrintString   	# jump to function
	# PopParams 4
	  add $sp, $sp, 4	# pop params off stack
	# Goto _L11
	  b _L11		# unconditional branch
	# Goto _L13
	  b _L13		# unconditional branch
  _L12:
  _L13:
	# _tmp96 = "That's not a good way to make points. Try again!\..."
	  .data			# create string constant marked with label
	  _string13: .asciiz "That's not a good way to make points. Try again!\n"
	  .text
	  la $t2, _string13	# load label
	  sw $t2, -312($fp)	# spill _tmp96 from $t2 to $fp-312
	# PushParam _tmp96
	  subu $sp, $sp, 4	# decrement sp to make space for param
	  lw $t0, -312($fp)	# fill _tmp96 to $t0 from $fp-312
	  sw $t0, 4($sp)	# copy param value to stack
	# LCall _PrintString
	  jal _PrintString   	# jump to function
	# PopParams 4
	  add $sp, $sp, 4	# pop params off stack
	# Goto _L10
	  b _L10		# unconditional branch
  _L11:
	# EndFunc
	# (below handles reaching end of fn body with no explicit return)
	  move $sp, $fp		# pop callee frame off stack
	  lw $ra, -4($fp)	# restore saved ra
	  lw $fp, 0($fp)	# restore saved fp
	  jr $ra		# return from function
