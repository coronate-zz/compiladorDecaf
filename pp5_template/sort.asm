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
	  
  ____ReadArray:
	# BeginFunc 172
	  subu $sp, $sp, 8	# decrement sp to make space to save ra, fp
	  sw $fp, 8($sp)	# save fp
	  sw $ra, 4($sp)	# save ra
	  addiu $fp, $sp, 8	# set up new fp
	  subu $sp, $sp, 172	# decrement sp to make space for locals/temps
	# _tmp0 = "How many scores? "
	  .data			# create string constant marked with label
	  _string1: .asciiz "How many scores? "
	  .text
	  la $t2, _string1	# load label
	  sw $t2, -24($fp)	# spill _tmp0 from $t2 to $fp-24
	# PushParam _tmp0
	  subu $sp, $sp, 4	# decrement sp to make space for param
	  lw $t0, -24($fp)	# fill _tmp0 to $t0 from $fp-24
	  sw $t0, 4($sp)	# copy param value to stack
	# LCall _PrintString
	  jal _PrintString   	# jump to function
	# PopParams 4
	  add $sp, $sp, 4	# pop params off stack
	# _tmp1 = LCall _ReadInteger
	  jal _ReadInteger   	# jump to function
	  move $t2, $v0		# copy function return value from $v0
	  sw $t2, -28($fp)	# spill _tmp1 from $t2 to $fp-28
	# numScores = _tmp1
	  lw $t2, -28($fp)	# fill _tmp1 to $t2 from $fp-28
	  sw $t2, -20($fp)	# spill numScores from $t2 to $fp-20
	# _tmp2 = 4
	  li $t2, 4		# load constant value 4 into $t2
	  sw $t2, -32($fp)	# spill _tmp2 from $t2 to $fp-32
	# _tmp3 = 0
	  li $t2, 0		# load constant value 0 into $t2
	  sw $t2, -36($fp)	# spill _tmp3 from $t2 to $fp-36
	# _tmp4 = numScores < _tmp3
	  lw $t0, -20($fp)	# fill numScores to $t0 from $fp-20
	  lw $t1, -36($fp)	# fill _tmp3 to $t1 from $fp-36
	  slt $t2, $t0, $t1	
	  sw $t2, -40($fp)	# spill _tmp4 from $t2 to $fp-40
	# _tmp5 = numScores == _tmp3
	  lw $t0, -20($fp)	# fill numScores to $t0 from $fp-20
	  lw $t1, -36($fp)	# fill _tmp3 to $t1 from $fp-36
	  seq $t2, $t0, $t1	
	  sw $t2, -44($fp)	# spill _tmp5 from $t2 to $fp-44
	# _tmp6 = _tmp4 || _tmp5
	  lw $t0, -40($fp)	# fill _tmp4 to $t0 from $fp-40
	  lw $t1, -44($fp)	# fill _tmp5 to $t1 from $fp-44
	  or $t2, $t0, $t1	
	  sw $t2, -48($fp)	# spill _tmp6 from $t2 to $fp-48
	# IfZ _tmp6 Goto _L0
	  lw $t0, -48($fp)	# fill _tmp6 to $t0 from $fp-48
	  beqz $t0, _L0	# branch if _tmp6 is zero 
	# _tmp7 = "Decaf runtime error: Array size is <= 0\n"
	  .data			# create string constant marked with label
	  _string2: .asciiz "Decaf runtime error: Array size is <= 0\n"
	  .text
	  la $t2, _string2	# load label
	  sw $t2, -52($fp)	# spill _tmp7 from $t2 to $fp-52
	# PushParam _tmp7
	  subu $sp, $sp, 4	# decrement sp to make space for param
	  lw $t0, -52($fp)	# fill _tmp7 to $t0 from $fp-52
	  sw $t0, 4($sp)	# copy param value to stack
	# LCall _PrintString
	  jal _PrintString   	# jump to function
	# PopParams 4
	  add $sp, $sp, 4	# pop params off stack
	# LCall _Halt
	  jal _Halt          	# jump to function
  _L0:
	# _tmp8 = numScores * _tmp2
	  lw $t0, -20($fp)	# fill numScores to $t0 from $fp-20
	  lw $t1, -32($fp)	# fill _tmp2 to $t1 from $fp-32
	  mul $t2, $t0, $t1	
	  sw $t2, -56($fp)	# spill _tmp8 from $t2 to $fp-56
	# _tmp9 = _tmp2 + _tmp8
	  lw $t0, -32($fp)	# fill _tmp2 to $t0 from $fp-32
	  lw $t1, -56($fp)	# fill _tmp8 to $t1 from $fp-56
	  add $t2, $t0, $t1	
	  sw $t2, -60($fp)	# spill _tmp9 from $t2 to $fp-60
	# PushParam _tmp9
	  subu $sp, $sp, 4	# decrement sp to make space for param
	  lw $t0, -60($fp)	# fill _tmp9 to $t0 from $fp-60
	  sw $t0, 4($sp)	# copy param value to stack
	# _tmp10 = LCall _Alloc
	  jal _Alloc         	# jump to function
	  move $t2, $v0		# copy function return value from $v0
	  sw $t2, -64($fp)	# spill _tmp10 from $t2 to $fp-64
	# PopParams 4
	  add $sp, $sp, 4	# pop params off stack
	# *(_tmp10) = numScores
	  lw $t0, -20($fp)	# fill numScores to $t0 from $fp-20
	  lw $t2, -64($fp)	# fill _tmp10 to $t2 from $fp-64
	  sw $t0, 0($t2) 	# store with offset
	# arr = _tmp10
	  lw $t2, -64($fp)	# fill _tmp10 to $t2 from $fp-64
	  sw $t2, -16($fp)	# spill arr from $t2 to $fp-16
	# _tmp11 = 0
	  li $t2, 0		# load constant value 0 into $t2
	  sw $t2, -68($fp)	# spill _tmp11 from $t2 to $fp-68
	# i = _tmp11
	  lw $t2, -68($fp)	# fill _tmp11 to $t2 from $fp-68
	  sw $t2, -8($fp)	# spill i from $t2 to $fp-8
  _L1:
	# _tmp12 = *(arr)
	  lw $t0, -16($fp)	# fill arr to $t0 from $fp-16
	  lw $t2, 0($t0) 	# load with offset
	  sw $t2, -72($fp)	# spill _tmp12 from $t2 to $fp-72
	# _tmp13 = i < _tmp12
	  lw $t0, -8($fp)	# fill i to $t0 from $fp-8
	  lw $t1, -72($fp)	# fill _tmp12 to $t1 from $fp-72
	  slt $t2, $t0, $t1	
	  sw $t2, -76($fp)	# spill _tmp13 from $t2 to $fp-76
	# IfZ _tmp13 Goto _L2
	  lw $t0, -76($fp)	# fill _tmp13 to $t0 from $fp-76
	  beqz $t0, _L2	# branch if _tmp13 is zero 
	# _tmp14 = "Enter next number: "
	  .data			# create string constant marked with label
	  _string3: .asciiz "Enter next number: "
	  .text
	  la $t2, _string3	# load label
	  sw $t2, -80($fp)	# spill _tmp14 from $t2 to $fp-80
	# PushParam _tmp14
	  subu $sp, $sp, 4	# decrement sp to make space for param
	  lw $t0, -80($fp)	# fill _tmp14 to $t0 from $fp-80
	  sw $t0, 4($sp)	# copy param value to stack
	# LCall _PrintString
	  jal _PrintString   	# jump to function
	# PopParams 4
	  add $sp, $sp, 4	# pop params off stack
	# _tmp15 = LCall _ReadInteger
	  jal _ReadInteger   	# jump to function
	  move $t2, $v0		# copy function return value from $v0
	  sw $t2, -84($fp)	# spill _tmp15 from $t2 to $fp-84
	# num = _tmp15
	  lw $t2, -84($fp)	# fill _tmp15 to $t2 from $fp-84
	  sw $t2, -12($fp)	# spill num from $t2 to $fp-12
	# _tmp16 = 0
	  li $t2, 0		# load constant value 0 into $t2
	  sw $t2, -88($fp)	# spill _tmp16 from $t2 to $fp-88
	# _tmp17 = *(arr)
	  lw $t0, -16($fp)	# fill arr to $t0 from $fp-16
	  lw $t2, 0($t0) 	# load with offset
	  sw $t2, -92($fp)	# spill _tmp17 from $t2 to $fp-92
	# _tmp18 = i < _tmp16
	  lw $t0, -8($fp)	# fill i to $t0 from $fp-8
	  lw $t1, -88($fp)	# fill _tmp16 to $t1 from $fp-88
	  slt $t2, $t0, $t1	
	  sw $t2, -96($fp)	# spill _tmp18 from $t2 to $fp-96
	# _tmp19 = _tmp17 < i
	  lw $t0, -92($fp)	# fill _tmp17 to $t0 from $fp-92
	  lw $t1, -8($fp)	# fill i to $t1 from $fp-8
	  slt $t2, $t0, $t1	
	  sw $t2, -100($fp)	# spill _tmp19 from $t2 to $fp-100
	# _tmp20 = _tmp17 == i
	  lw $t0, -92($fp)	# fill _tmp17 to $t0 from $fp-92
	  lw $t1, -8($fp)	# fill i to $t1 from $fp-8
	  seq $t2, $t0, $t1	
	  sw $t2, -104($fp)	# spill _tmp20 from $t2 to $fp-104
	# _tmp21 = _tmp19 || _tmp20
	  lw $t0, -100($fp)	# fill _tmp19 to $t0 from $fp-100
	  lw $t1, -104($fp)	# fill _tmp20 to $t1 from $fp-104
	  or $t2, $t0, $t1	
	  sw $t2, -108($fp)	# spill _tmp21 from $t2 to $fp-108
	# _tmp22 = _tmp21 || _tmp18
	  lw $t0, -108($fp)	# fill _tmp21 to $t0 from $fp-108
	  lw $t1, -96($fp)	# fill _tmp18 to $t1 from $fp-96
	  or $t2, $t0, $t1	
	  sw $t2, -112($fp)	# spill _tmp22 from $t2 to $fp-112
	# IfZ _tmp22 Goto _L3
	  lw $t0, -112($fp)	# fill _tmp22 to $t0 from $fp-112
	  beqz $t0, _L3	# branch if _tmp22 is zero 
	# _tmp23 = "Decaf runtime error: Array subscript out of bound..."
	  .data			# create string constant marked with label
	  _string4: .asciiz "Decaf runtime error: Array subscript out of bounds\n"
	  .text
	  la $t2, _string4	# load label
	  sw $t2, -116($fp)	# spill _tmp23 from $t2 to $fp-116
	# PushParam _tmp23
	  subu $sp, $sp, 4	# decrement sp to make space for param
	  lw $t0, -116($fp)	# fill _tmp23 to $t0 from $fp-116
	  sw $t0, 4($sp)	# copy param value to stack
	# LCall _PrintString
	  jal _PrintString   	# jump to function
	# PopParams 4
	  add $sp, $sp, 4	# pop params off stack
	# LCall _Halt
	  jal _Halt          	# jump to function
  _L3:
	# _tmp24 = 4
	  li $t2, 4		# load constant value 4 into $t2
	  sw $t2, -120($fp)	# spill _tmp24 from $t2 to $fp-120
	# _tmp25 = i * _tmp24
	  lw $t0, -8($fp)	# fill i to $t0 from $fp-8
	  lw $t1, -120($fp)	# fill _tmp24 to $t1 from $fp-120
	  mul $t2, $t0, $t1	
	  sw $t2, -124($fp)	# spill _tmp25 from $t2 to $fp-124
	# _tmp26 = _tmp25 + _tmp24
	  lw $t0, -124($fp)	# fill _tmp25 to $t0 from $fp-124
	  lw $t1, -120($fp)	# fill _tmp24 to $t1 from $fp-120
	  add $t2, $t0, $t1	
	  sw $t2, -128($fp)	# spill _tmp26 from $t2 to $fp-128
	# _tmp27 = arr + _tmp26
	  lw $t0, -16($fp)	# fill arr to $t0 from $fp-16
	  lw $t1, -128($fp)	# fill _tmp26 to $t1 from $fp-128
	  add $t2, $t0, $t1	
	  sw $t2, -132($fp)	# spill _tmp27 from $t2 to $fp-132
	# *(_tmp27) = num
	  lw $t0, -12($fp)	# fill num to $t0 from $fp-12
	  lw $t2, -132($fp)	# fill _tmp27 to $t2 from $fp-132
	  sw $t0, 0($t2) 	# store with offset
	# _tmp28 = *(_tmp27)
	  lw $t0, -132($fp)	# fill _tmp27 to $t0 from $fp-132
	  lw $t2, 0($t0) 	# load with offset
	  sw $t2, -136($fp)	# spill _tmp28 from $t2 to $fp-136
	# _tmp29 = 1
	  li $t2, 1		# load constant value 1 into $t2
	  sw $t2, -140($fp)	# spill _tmp29 from $t2 to $fp-140
	# _tmp30 = i + _tmp29
	  lw $t0, -8($fp)	# fill i to $t0 from $fp-8
	  lw $t1, -140($fp)	# fill _tmp29 to $t1 from $fp-140
	  add $t2, $t0, $t1	
	  sw $t2, -144($fp)	# spill _tmp30 from $t2 to $fp-144
	# i = _tmp30
	  lw $t2, -144($fp)	# fill _tmp30 to $t2 from $fp-144
	  sw $t2, -8($fp)	# spill i from $t2 to $fp-8
	# Goto _L1
	  b _L1		# unconditional branch
  _L2:
	# Return arr
	  lw $t2, -16($fp)	# fill arr to $t2 from $fp-16
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
  ____Sort:
	# BeginFunc 400
	  subu $sp, $sp, 8	# decrement sp to make space to save ra, fp
	  sw $fp, 8($sp)	# save fp
	  sw $ra, 4($sp)	# save ra
	  addiu $fp, $sp, 8	# set up new fp
	  subu $sp, $sp, 400	# decrement sp to make space for locals/temps
	# _tmp31 = 1
	  li $t2, 1		# load constant value 1 into $t2
	  sw $t2, -20($fp)	# spill _tmp31 from $t2 to $fp-20
	# i = _tmp31
	  lw $t2, -20($fp)	# fill _tmp31 to $t2 from $fp-20
	  sw $t2, -8($fp)	# spill i from $t2 to $fp-8
  _L4:
	# _tmp32 = *(arr)
	  lw $t0, 4($fp)	# fill arr to $t0 from $fp+4
	  lw $t2, 0($t0) 	# load with offset
	  sw $t2, -24($fp)	# spill _tmp32 from $t2 to $fp-24
	# _tmp33 = i < _tmp32
	  lw $t0, -8($fp)	# fill i to $t0 from $fp-8
	  lw $t1, -24($fp)	# fill _tmp32 to $t1 from $fp-24
	  slt $t2, $t0, $t1	
	  sw $t2, -28($fp)	# spill _tmp33 from $t2 to $fp-28
	# IfZ _tmp33 Goto _L5
	  lw $t0, -28($fp)	# fill _tmp33 to $t0 from $fp-28
	  beqz $t0, _L5	# branch if _tmp33 is zero 
	# _tmp34 = 1
	  li $t2, 1		# load constant value 1 into $t2
	  sw $t2, -32($fp)	# spill _tmp34 from $t2 to $fp-32
	# _tmp35 = i - _tmp34
	  lw $t0, -8($fp)	# fill i to $t0 from $fp-8
	  lw $t1, -32($fp)	# fill _tmp34 to $t1 from $fp-32
	  sub $t2, $t0, $t1	
	  sw $t2, -36($fp)	# spill _tmp35 from $t2 to $fp-36
	# j = _tmp35
	  lw $t2, -36($fp)	# fill _tmp35 to $t2 from $fp-36
	  sw $t2, -12($fp)	# spill j from $t2 to $fp-12
	# _tmp36 = 0
	  li $t2, 0		# load constant value 0 into $t2
	  sw $t2, -40($fp)	# spill _tmp36 from $t2 to $fp-40
	# _tmp37 = *(arr)
	  lw $t0, 4($fp)	# fill arr to $t0 from $fp+4
	  lw $t2, 0($t0) 	# load with offset
	  sw $t2, -44($fp)	# spill _tmp37 from $t2 to $fp-44
	# _tmp38 = i < _tmp36
	  lw $t0, -8($fp)	# fill i to $t0 from $fp-8
	  lw $t1, -40($fp)	# fill _tmp36 to $t1 from $fp-40
	  slt $t2, $t0, $t1	
	  sw $t2, -48($fp)	# spill _tmp38 from $t2 to $fp-48
	# _tmp39 = _tmp37 < i
	  lw $t0, -44($fp)	# fill _tmp37 to $t0 from $fp-44
	  lw $t1, -8($fp)	# fill i to $t1 from $fp-8
	  slt $t2, $t0, $t1	
	  sw $t2, -52($fp)	# spill _tmp39 from $t2 to $fp-52
	# _tmp40 = _tmp37 == i
	  lw $t0, -44($fp)	# fill _tmp37 to $t0 from $fp-44
	  lw $t1, -8($fp)	# fill i to $t1 from $fp-8
	  seq $t2, $t0, $t1	
	  sw $t2, -56($fp)	# spill _tmp40 from $t2 to $fp-56
	# _tmp41 = _tmp39 || _tmp40
	  lw $t0, -52($fp)	# fill _tmp39 to $t0 from $fp-52
	  lw $t1, -56($fp)	# fill _tmp40 to $t1 from $fp-56
	  or $t2, $t0, $t1	
	  sw $t2, -60($fp)	# spill _tmp41 from $t2 to $fp-60
	# _tmp42 = _tmp41 || _tmp38
	  lw $t0, -60($fp)	# fill _tmp41 to $t0 from $fp-60
	  lw $t1, -48($fp)	# fill _tmp38 to $t1 from $fp-48
	  or $t2, $t0, $t1	
	  sw $t2, -64($fp)	# spill _tmp42 from $t2 to $fp-64
	# IfZ _tmp42 Goto _L6
	  lw $t0, -64($fp)	# fill _tmp42 to $t0 from $fp-64
	  beqz $t0, _L6	# branch if _tmp42 is zero 
	# _tmp43 = "Decaf runtime error: Array subscript out of bound..."
	  .data			# create string constant marked with label
	  _string5: .asciiz "Decaf runtime error: Array subscript out of bounds\n"
	  .text
	  la $t2, _string5	# load label
	  sw $t2, -68($fp)	# spill _tmp43 from $t2 to $fp-68
	# PushParam _tmp43
	  subu $sp, $sp, 4	# decrement sp to make space for param
	  lw $t0, -68($fp)	# fill _tmp43 to $t0 from $fp-68
	  sw $t0, 4($sp)	# copy param value to stack
	# LCall _PrintString
	  jal _PrintString   	# jump to function
	# PopParams 4
	  add $sp, $sp, 4	# pop params off stack
	# LCall _Halt
	  jal _Halt          	# jump to function
  _L6:
	# _tmp44 = 4
	  li $t2, 4		# load constant value 4 into $t2
	  sw $t2, -72($fp)	# spill _tmp44 from $t2 to $fp-72
	# _tmp45 = i * _tmp44
	  lw $t0, -8($fp)	# fill i to $t0 from $fp-8
	  lw $t1, -72($fp)	# fill _tmp44 to $t1 from $fp-72
	  mul $t2, $t0, $t1	
	  sw $t2, -76($fp)	# spill _tmp45 from $t2 to $fp-76
	# _tmp46 = _tmp45 + _tmp44
	  lw $t0, -76($fp)	# fill _tmp45 to $t0 from $fp-76
	  lw $t1, -72($fp)	# fill _tmp44 to $t1 from $fp-72
	  add $t2, $t0, $t1	
	  sw $t2, -80($fp)	# spill _tmp46 from $t2 to $fp-80
	# _tmp47 = arr + _tmp46
	  lw $t0, 4($fp)	# fill arr to $t0 from $fp+4
	  lw $t1, -80($fp)	# fill _tmp46 to $t1 from $fp-80
	  add $t2, $t0, $t1	
	  sw $t2, -84($fp)	# spill _tmp47 from $t2 to $fp-84
	# _tmp48 = *(_tmp47)
	  lw $t0, -84($fp)	# fill _tmp47 to $t0 from $fp-84
	  lw $t2, 0($t0) 	# load with offset
	  sw $t2, -88($fp)	# spill _tmp48 from $t2 to $fp-88
	# val = _tmp48
	  lw $t2, -88($fp)	# fill _tmp48 to $t2 from $fp-88
	  sw $t2, -16($fp)	# spill val from $t2 to $fp-16
  _L7:
	# _tmp49 = 0
	  li $t2, 0		# load constant value 0 into $t2
	  sw $t2, -92($fp)	# spill _tmp49 from $t2 to $fp-92
	# _tmp50 = _tmp49 < j
	  lw $t0, -92($fp)	# fill _tmp49 to $t0 from $fp-92
	  lw $t1, -12($fp)	# fill j to $t1 from $fp-12
	  slt $t2, $t0, $t1	
	  sw $t2, -96($fp)	# spill _tmp50 from $t2 to $fp-96
	# _tmp51 = _tmp49 == j
	  lw $t0, -92($fp)	# fill _tmp49 to $t0 from $fp-92
	  lw $t1, -12($fp)	# fill j to $t1 from $fp-12
	  seq $t2, $t0, $t1	
	  sw $t2, -100($fp)	# spill _tmp51 from $t2 to $fp-100
	# _tmp52 = _tmp50 || _tmp51
	  lw $t0, -96($fp)	# fill _tmp50 to $t0 from $fp-96
	  lw $t1, -100($fp)	# fill _tmp51 to $t1 from $fp-100
	  or $t2, $t0, $t1	
	  sw $t2, -104($fp)	# spill _tmp52 from $t2 to $fp-104
	# IfZ _tmp52 Goto _L8
	  lw $t0, -104($fp)	# fill _tmp52 to $t0 from $fp-104
	  beqz $t0, _L8	# branch if _tmp52 is zero 
	# _tmp53 = 0
	  li $t2, 0		# load constant value 0 into $t2
	  sw $t2, -108($fp)	# spill _tmp53 from $t2 to $fp-108
	# _tmp54 = *(arr)
	  lw $t0, 4($fp)	# fill arr to $t0 from $fp+4
	  lw $t2, 0($t0) 	# load with offset
	  sw $t2, -112($fp)	# spill _tmp54 from $t2 to $fp-112
	# _tmp55 = j < _tmp53
	  lw $t0, -12($fp)	# fill j to $t0 from $fp-12
	  lw $t1, -108($fp)	# fill _tmp53 to $t1 from $fp-108
	  slt $t2, $t0, $t1	
	  sw $t2, -116($fp)	# spill _tmp55 from $t2 to $fp-116
	# _tmp56 = _tmp54 < j
	  lw $t0, -112($fp)	# fill _tmp54 to $t0 from $fp-112
	  lw $t1, -12($fp)	# fill j to $t1 from $fp-12
	  slt $t2, $t0, $t1	
	  sw $t2, -120($fp)	# spill _tmp56 from $t2 to $fp-120
	# _tmp57 = _tmp54 == j
	  lw $t0, -112($fp)	# fill _tmp54 to $t0 from $fp-112
	  lw $t1, -12($fp)	# fill j to $t1 from $fp-12
	  seq $t2, $t0, $t1	
	  sw $t2, -124($fp)	# spill _tmp57 from $t2 to $fp-124
	# _tmp58 = _tmp56 || _tmp57
	  lw $t0, -120($fp)	# fill _tmp56 to $t0 from $fp-120
	  lw $t1, -124($fp)	# fill _tmp57 to $t1 from $fp-124
	  or $t2, $t0, $t1	
	  sw $t2, -128($fp)	# spill _tmp58 from $t2 to $fp-128
	# _tmp59 = _tmp58 || _tmp55
	  lw $t0, -128($fp)	# fill _tmp58 to $t0 from $fp-128
	  lw $t1, -116($fp)	# fill _tmp55 to $t1 from $fp-116
	  or $t2, $t0, $t1	
	  sw $t2, -132($fp)	# spill _tmp59 from $t2 to $fp-132
	# IfZ _tmp59 Goto _L11
	  lw $t0, -132($fp)	# fill _tmp59 to $t0 from $fp-132
	  beqz $t0, _L11	# branch if _tmp59 is zero 
	# _tmp60 = "Decaf runtime error: Array subscript out of bound..."
	  .data			# create string constant marked with label
	  _string6: .asciiz "Decaf runtime error: Array subscript out of bounds\n"
	  .text
	  la $t2, _string6	# load label
	  sw $t2, -136($fp)	# spill _tmp60 from $t2 to $fp-136
	# PushParam _tmp60
	  subu $sp, $sp, 4	# decrement sp to make space for param
	  lw $t0, -136($fp)	# fill _tmp60 to $t0 from $fp-136
	  sw $t0, 4($sp)	# copy param value to stack
	# LCall _PrintString
	  jal _PrintString   	# jump to function
	# PopParams 4
	  add $sp, $sp, 4	# pop params off stack
	# LCall _Halt
	  jal _Halt          	# jump to function
  _L11:
	# _tmp61 = 4
	  li $t2, 4		# load constant value 4 into $t2
	  sw $t2, -140($fp)	# spill _tmp61 from $t2 to $fp-140
	# _tmp62 = j * _tmp61
	  lw $t0, -12($fp)	# fill j to $t0 from $fp-12
	  lw $t1, -140($fp)	# fill _tmp61 to $t1 from $fp-140
	  mul $t2, $t0, $t1	
	  sw $t2, -144($fp)	# spill _tmp62 from $t2 to $fp-144
	# _tmp63 = _tmp62 + _tmp61
	  lw $t0, -144($fp)	# fill _tmp62 to $t0 from $fp-144
	  lw $t1, -140($fp)	# fill _tmp61 to $t1 from $fp-140
	  add $t2, $t0, $t1	
	  sw $t2, -148($fp)	# spill _tmp63 from $t2 to $fp-148
	# _tmp64 = arr + _tmp63
	  lw $t0, 4($fp)	# fill arr to $t0 from $fp+4
	  lw $t1, -148($fp)	# fill _tmp63 to $t1 from $fp-148
	  add $t2, $t0, $t1	
	  sw $t2, -152($fp)	# spill _tmp64 from $t2 to $fp-152
	# _tmp65 = *(_tmp64)
	  lw $t0, -152($fp)	# fill _tmp64 to $t0 from $fp-152
	  lw $t2, 0($t0) 	# load with offset
	  sw $t2, -156($fp)	# spill _tmp65 from $t2 to $fp-156
	# _tmp66 = _tmp65 < val
	  lw $t0, -156($fp)	# fill _tmp65 to $t0 from $fp-156
	  lw $t1, -16($fp)	# fill val to $t1 from $fp-16
	  slt $t2, $t0, $t1	
	  sw $t2, -160($fp)	# spill _tmp66 from $t2 to $fp-160
	# _tmp67 = _tmp65 == val
	  lw $t0, -156($fp)	# fill _tmp65 to $t0 from $fp-156
	  lw $t1, -16($fp)	# fill val to $t1 from $fp-16
	  seq $t2, $t0, $t1	
	  sw $t2, -164($fp)	# spill _tmp67 from $t2 to $fp-164
	# _tmp68 = _tmp66 || _tmp67
	  lw $t0, -160($fp)	# fill _tmp66 to $t0 from $fp-160
	  lw $t1, -164($fp)	# fill _tmp67 to $t1 from $fp-164
	  or $t2, $t0, $t1	
	  sw $t2, -168($fp)	# spill _tmp68 from $t2 to $fp-168
	# IfZ _tmp68 Goto _L9
	  lw $t0, -168($fp)	# fill _tmp68 to $t0 from $fp-168
	  beqz $t0, _L9	# branch if _tmp68 is zero 
	# Goto _L8
	  b _L8		# unconditional branch
	# Goto _L10
	  b _L10		# unconditional branch
  _L9:
  _L10:
	# _tmp69 = 0
	  li $t2, 0		# load constant value 0 into $t2
	  sw $t2, -172($fp)	# spill _tmp69 from $t2 to $fp-172
	# _tmp70 = *(arr)
	  lw $t0, 4($fp)	# fill arr to $t0 from $fp+4
	  lw $t2, 0($t0) 	# load with offset
	  sw $t2, -176($fp)	# spill _tmp70 from $t2 to $fp-176
	# _tmp71 = j < _tmp69
	  lw $t0, -12($fp)	# fill j to $t0 from $fp-12
	  lw $t1, -172($fp)	# fill _tmp69 to $t1 from $fp-172
	  slt $t2, $t0, $t1	
	  sw $t2, -180($fp)	# spill _tmp71 from $t2 to $fp-180
	# _tmp72 = _tmp70 < j
	  lw $t0, -176($fp)	# fill _tmp70 to $t0 from $fp-176
	  lw $t1, -12($fp)	# fill j to $t1 from $fp-12
	  slt $t2, $t0, $t1	
	  sw $t2, -184($fp)	# spill _tmp72 from $t2 to $fp-184
	# _tmp73 = _tmp70 == j
	  lw $t0, -176($fp)	# fill _tmp70 to $t0 from $fp-176
	  lw $t1, -12($fp)	# fill j to $t1 from $fp-12
	  seq $t2, $t0, $t1	
	  sw $t2, -188($fp)	# spill _tmp73 from $t2 to $fp-188
	# _tmp74 = _tmp72 || _tmp73
	  lw $t0, -184($fp)	# fill _tmp72 to $t0 from $fp-184
	  lw $t1, -188($fp)	# fill _tmp73 to $t1 from $fp-188
	  or $t2, $t0, $t1	
	  sw $t2, -192($fp)	# spill _tmp74 from $t2 to $fp-192
	# _tmp75 = _tmp74 || _tmp71
	  lw $t0, -192($fp)	# fill _tmp74 to $t0 from $fp-192
	  lw $t1, -180($fp)	# fill _tmp71 to $t1 from $fp-180
	  or $t2, $t0, $t1	
	  sw $t2, -196($fp)	# spill _tmp75 from $t2 to $fp-196
	# IfZ _tmp75 Goto _L12
	  lw $t0, -196($fp)	# fill _tmp75 to $t0 from $fp-196
	  beqz $t0, _L12	# branch if _tmp75 is zero 
	# _tmp76 = "Decaf runtime error: Array subscript out of bound..."
	  .data			# create string constant marked with label
	  _string7: .asciiz "Decaf runtime error: Array subscript out of bounds\n"
	  .text
	  la $t2, _string7	# load label
	  sw $t2, -200($fp)	# spill _tmp76 from $t2 to $fp-200
	# PushParam _tmp76
	  subu $sp, $sp, 4	# decrement sp to make space for param
	  lw $t0, -200($fp)	# fill _tmp76 to $t0 from $fp-200
	  sw $t0, 4($sp)	# copy param value to stack
	# LCall _PrintString
	  jal _PrintString   	# jump to function
	# PopParams 4
	  add $sp, $sp, 4	# pop params off stack
	# LCall _Halt
	  jal _Halt          	# jump to function
  _L12:
	# _tmp77 = 4
	  li $t2, 4		# load constant value 4 into $t2
	  sw $t2, -204($fp)	# spill _tmp77 from $t2 to $fp-204
	# _tmp78 = j * _tmp77
	  lw $t0, -12($fp)	# fill j to $t0 from $fp-12
	  lw $t1, -204($fp)	# fill _tmp77 to $t1 from $fp-204
	  mul $t2, $t0, $t1	
	  sw $t2, -208($fp)	# spill _tmp78 from $t2 to $fp-208
	# _tmp79 = _tmp78 + _tmp77
	  lw $t0, -208($fp)	# fill _tmp78 to $t0 from $fp-208
	  lw $t1, -204($fp)	# fill _tmp77 to $t1 from $fp-204
	  add $t2, $t0, $t1	
	  sw $t2, -212($fp)	# spill _tmp79 from $t2 to $fp-212
	# _tmp80 = arr + _tmp79
	  lw $t0, 4($fp)	# fill arr to $t0 from $fp+4
	  lw $t1, -212($fp)	# fill _tmp79 to $t1 from $fp-212
	  add $t2, $t0, $t1	
	  sw $t2, -216($fp)	# spill _tmp80 from $t2 to $fp-216
	# _tmp81 = *(_tmp80)
	  lw $t0, -216($fp)	# fill _tmp80 to $t0 from $fp-216
	  lw $t2, 0($t0) 	# load with offset
	  sw $t2, -220($fp)	# spill _tmp81 from $t2 to $fp-220
	# _tmp82 = 1
	  li $t2, 1		# load constant value 1 into $t2
	  sw $t2, -224($fp)	# spill _tmp82 from $t2 to $fp-224
	# _tmp83 = j + _tmp82
	  lw $t0, -12($fp)	# fill j to $t0 from $fp-12
	  lw $t1, -224($fp)	# fill _tmp82 to $t1 from $fp-224
	  add $t2, $t0, $t1	
	  sw $t2, -228($fp)	# spill _tmp83 from $t2 to $fp-228
	# _tmp84 = 0
	  li $t2, 0		# load constant value 0 into $t2
	  sw $t2, -232($fp)	# spill _tmp84 from $t2 to $fp-232
	# _tmp85 = *(arr)
	  lw $t0, 4($fp)	# fill arr to $t0 from $fp+4
	  lw $t2, 0($t0) 	# load with offset
	  sw $t2, -236($fp)	# spill _tmp85 from $t2 to $fp-236
	# _tmp86 = _tmp83 < _tmp84
	  lw $t0, -228($fp)	# fill _tmp83 to $t0 from $fp-228
	  lw $t1, -232($fp)	# fill _tmp84 to $t1 from $fp-232
	  slt $t2, $t0, $t1	
	  sw $t2, -240($fp)	# spill _tmp86 from $t2 to $fp-240
	# _tmp87 = _tmp85 < _tmp83
	  lw $t0, -236($fp)	# fill _tmp85 to $t0 from $fp-236
	  lw $t1, -228($fp)	# fill _tmp83 to $t1 from $fp-228
	  slt $t2, $t0, $t1	
	  sw $t2, -244($fp)	# spill _tmp87 from $t2 to $fp-244
	# _tmp88 = _tmp85 == _tmp83
	  lw $t0, -236($fp)	# fill _tmp85 to $t0 from $fp-236
	  lw $t1, -228($fp)	# fill _tmp83 to $t1 from $fp-228
	  seq $t2, $t0, $t1	
	  sw $t2, -248($fp)	# spill _tmp88 from $t2 to $fp-248
	# _tmp89 = _tmp87 || _tmp88
	  lw $t0, -244($fp)	# fill _tmp87 to $t0 from $fp-244
	  lw $t1, -248($fp)	# fill _tmp88 to $t1 from $fp-248
	  or $t2, $t0, $t1	
	  sw $t2, -252($fp)	# spill _tmp89 from $t2 to $fp-252
	# _tmp90 = _tmp89 || _tmp86
	  lw $t0, -252($fp)	# fill _tmp89 to $t0 from $fp-252
	  lw $t1, -240($fp)	# fill _tmp86 to $t1 from $fp-240
	  or $t2, $t0, $t1	
	  sw $t2, -256($fp)	# spill _tmp90 from $t2 to $fp-256
	# IfZ _tmp90 Goto _L13
	  lw $t0, -256($fp)	# fill _tmp90 to $t0 from $fp-256
	  beqz $t0, _L13	# branch if _tmp90 is zero 
	# _tmp91 = "Decaf runtime error: Array subscript out of bound..."
	  .data			# create string constant marked with label
	  _string8: .asciiz "Decaf runtime error: Array subscript out of bounds\n"
	  .text
	  la $t2, _string8	# load label
	  sw $t2, -260($fp)	# spill _tmp91 from $t2 to $fp-260
	# PushParam _tmp91
	  subu $sp, $sp, 4	# decrement sp to make space for param
	  lw $t0, -260($fp)	# fill _tmp91 to $t0 from $fp-260
	  sw $t0, 4($sp)	# copy param value to stack
	# LCall _PrintString
	  jal _PrintString   	# jump to function
	# PopParams 4
	  add $sp, $sp, 4	# pop params off stack
	# LCall _Halt
	  jal _Halt          	# jump to function
  _L13:
	# _tmp92 = 4
	  li $t2, 4		# load constant value 4 into $t2
	  sw $t2, -264($fp)	# spill _tmp92 from $t2 to $fp-264
	# _tmp93 = _tmp83 * _tmp92
	  lw $t0, -228($fp)	# fill _tmp83 to $t0 from $fp-228
	  lw $t1, -264($fp)	# fill _tmp92 to $t1 from $fp-264
	  mul $t2, $t0, $t1	
	  sw $t2, -268($fp)	# spill _tmp93 from $t2 to $fp-268
	# _tmp94 = _tmp93 + _tmp92
	  lw $t0, -268($fp)	# fill _tmp93 to $t0 from $fp-268
	  lw $t1, -264($fp)	# fill _tmp92 to $t1 from $fp-264
	  add $t2, $t0, $t1	
	  sw $t2, -272($fp)	# spill _tmp94 from $t2 to $fp-272
	# _tmp95 = arr + _tmp94
	  lw $t0, 4($fp)	# fill arr to $t0 from $fp+4
	  lw $t1, -272($fp)	# fill _tmp94 to $t1 from $fp-272
	  add $t2, $t0, $t1	
	  sw $t2, -276($fp)	# spill _tmp95 from $t2 to $fp-276
	# *(_tmp95) = _tmp81
	  lw $t0, -220($fp)	# fill _tmp81 to $t0 from $fp-220
	  lw $t2, -276($fp)	# fill _tmp95 to $t2 from $fp-276
	  sw $t0, 0($t2) 	# store with offset
	# _tmp96 = *(_tmp95)
	  lw $t0, -276($fp)	# fill _tmp95 to $t0 from $fp-276
	  lw $t2, 0($t0) 	# load with offset
	  sw $t2, -280($fp)	# spill _tmp96 from $t2 to $fp-280
	# _tmp97 = 1
	  li $t2, 1		# load constant value 1 into $t2
	  sw $t2, -284($fp)	# spill _tmp97 from $t2 to $fp-284
	# _tmp98 = j - _tmp97
	  lw $t0, -12($fp)	# fill j to $t0 from $fp-12
	  lw $t1, -284($fp)	# fill _tmp97 to $t1 from $fp-284
	  sub $t2, $t0, $t1	
	  sw $t2, -288($fp)	# spill _tmp98 from $t2 to $fp-288
	# j = _tmp98
	  lw $t2, -288($fp)	# fill _tmp98 to $t2 from $fp-288
	  sw $t2, -12($fp)	# spill j from $t2 to $fp-12
	# Goto _L7
	  b _L7		# unconditional branch
  _L8:
	# _tmp99 = 1
	  li $t2, 1		# load constant value 1 into $t2
	  sw $t2, -292($fp)	# spill _tmp99 from $t2 to $fp-292
	# _tmp100 = j + _tmp99
	  lw $t0, -12($fp)	# fill j to $t0 from $fp-12
	  lw $t1, -292($fp)	# fill _tmp99 to $t1 from $fp-292
	  add $t2, $t0, $t1	
	  sw $t2, -296($fp)	# spill _tmp100 from $t2 to $fp-296
	# _tmp101 = 0
	  li $t2, 0		# load constant value 0 into $t2
	  sw $t2, -300($fp)	# spill _tmp101 from $t2 to $fp-300
	# _tmp102 = *(arr)
	  lw $t0, 4($fp)	# fill arr to $t0 from $fp+4
	  lw $t2, 0($t0) 	# load with offset
	  sw $t2, -304($fp)	# spill _tmp102 from $t2 to $fp-304
	# _tmp103 = _tmp100 < _tmp101
	  lw $t0, -296($fp)	# fill _tmp100 to $t0 from $fp-296
	  lw $t1, -300($fp)	# fill _tmp101 to $t1 from $fp-300
	  slt $t2, $t0, $t1	
	  sw $t2, -308($fp)	# spill _tmp103 from $t2 to $fp-308
	# _tmp104 = _tmp102 < _tmp100
	  lw $t0, -304($fp)	# fill _tmp102 to $t0 from $fp-304
	  lw $t1, -296($fp)	# fill _tmp100 to $t1 from $fp-296
	  slt $t2, $t0, $t1	
	  sw $t2, -312($fp)	# spill _tmp104 from $t2 to $fp-312
	# _tmp105 = _tmp102 == _tmp100
	  lw $t0, -304($fp)	# fill _tmp102 to $t0 from $fp-304
	  lw $t1, -296($fp)	# fill _tmp100 to $t1 from $fp-296
	  seq $t2, $t0, $t1	
	  sw $t2, -316($fp)	# spill _tmp105 from $t2 to $fp-316
	# _tmp106 = _tmp104 || _tmp105
	  lw $t0, -312($fp)	# fill _tmp104 to $t0 from $fp-312
	  lw $t1, -316($fp)	# fill _tmp105 to $t1 from $fp-316
	  or $t2, $t0, $t1	
	  sw $t2, -320($fp)	# spill _tmp106 from $t2 to $fp-320
	# _tmp107 = _tmp106 || _tmp103
	  lw $t0, -320($fp)	# fill _tmp106 to $t0 from $fp-320
	  lw $t1, -308($fp)	# fill _tmp103 to $t1 from $fp-308
	  or $t2, $t0, $t1	
	  sw $t2, -324($fp)	# spill _tmp107 from $t2 to $fp-324
	# IfZ _tmp107 Goto _L14
	  lw $t0, -324($fp)	# fill _tmp107 to $t0 from $fp-324
	  beqz $t0, _L14	# branch if _tmp107 is zero 
	# _tmp108 = "Decaf runtime error: Array subscript out of bound..."
	  .data			# create string constant marked with label
	  _string9: .asciiz "Decaf runtime error: Array subscript out of bounds\n"
	  .text
	  la $t2, _string9	# load label
	  sw $t2, -328($fp)	# spill _tmp108 from $t2 to $fp-328
	# PushParam _tmp108
	  subu $sp, $sp, 4	# decrement sp to make space for param
	  lw $t0, -328($fp)	# fill _tmp108 to $t0 from $fp-328
	  sw $t0, 4($sp)	# copy param value to stack
	# LCall _PrintString
	  jal _PrintString   	# jump to function
	# PopParams 4
	  add $sp, $sp, 4	# pop params off stack
	# LCall _Halt
	  jal _Halt          	# jump to function
  _L14:
	# _tmp109 = 4
	  li $t2, 4		# load constant value 4 into $t2
	  sw $t2, -332($fp)	# spill _tmp109 from $t2 to $fp-332
	# _tmp110 = _tmp100 * _tmp109
	  lw $t0, -296($fp)	# fill _tmp100 to $t0 from $fp-296
	  lw $t1, -332($fp)	# fill _tmp109 to $t1 from $fp-332
	  mul $t2, $t0, $t1	
	  sw $t2, -336($fp)	# spill _tmp110 from $t2 to $fp-336
	# _tmp111 = _tmp110 + _tmp109
	  lw $t0, -336($fp)	# fill _tmp110 to $t0 from $fp-336
	  lw $t1, -332($fp)	# fill _tmp109 to $t1 from $fp-332
	  add $t2, $t0, $t1	
	  sw $t2, -340($fp)	# spill _tmp111 from $t2 to $fp-340
	# _tmp112 = arr + _tmp111
	  lw $t0, 4($fp)	# fill arr to $t0 from $fp+4
	  lw $t1, -340($fp)	# fill _tmp111 to $t1 from $fp-340
	  add $t2, $t0, $t1	
	  sw $t2, -344($fp)	# spill _tmp112 from $t2 to $fp-344
	# *(_tmp112) = val
	  lw $t0, -16($fp)	# fill val to $t0 from $fp-16
	  lw $t2, -344($fp)	# fill _tmp112 to $t2 from $fp-344
	  sw $t0, 0($t2) 	# store with offset
	# _tmp113 = *(_tmp112)
	  lw $t0, -344($fp)	# fill _tmp112 to $t0 from $fp-344
	  lw $t2, 0($t0) 	# load with offset
	  sw $t2, -348($fp)	# spill _tmp113 from $t2 to $fp-348
	# _tmp114 = 1
	  li $t2, 1		# load constant value 1 into $t2
	  sw $t2, -352($fp)	# spill _tmp114 from $t2 to $fp-352
	# _tmp115 = i + _tmp114
	  lw $t0, -8($fp)	# fill i to $t0 from $fp-8
	  lw $t1, -352($fp)	# fill _tmp114 to $t1 from $fp-352
	  add $t2, $t0, $t1	
	  sw $t2, -356($fp)	# spill _tmp115 from $t2 to $fp-356
	# i = _tmp115
	  lw $t2, -356($fp)	# fill _tmp115 to $t2 from $fp-356
	  sw $t2, -8($fp)	# spill i from $t2 to $fp-8
	# Goto _L4
	  b _L4		# unconditional branch
  _L5:
	# EndFunc
	# (below handles reaching end of fn body with no explicit return)
	  move $sp, $fp		# pop callee frame off stack
	  lw $ra, -4($fp)	# restore saved ra
	  lw $fp, 0($fp)	# restore saved fp
	  jr $ra		# return from function
  ____PrintArray:
	# BeginFunc 100
	  subu $sp, $sp, 8	# decrement sp to make space to save ra, fp
	  sw $fp, 8($sp)	# save fp
	  sw $ra, 4($sp)	# save ra
	  addiu $fp, $sp, 8	# set up new fp
	  subu $sp, $sp, 100	# decrement sp to make space for locals/temps
	# _tmp116 = 0
	  li $t2, 0		# load constant value 0 into $t2
	  sw $t2, -12($fp)	# spill _tmp116 from $t2 to $fp-12
	# i = _tmp116
	  lw $t2, -12($fp)	# fill _tmp116 to $t2 from $fp-12
	  sw $t2, -8($fp)	# spill i from $t2 to $fp-8
	# _tmp117 = "Sorted results: "
	  .data			# create string constant marked with label
	  _string10: .asciiz "Sorted results: "
	  .text
	  la $t2, _string10	# load label
	  sw $t2, -16($fp)	# spill _tmp117 from $t2 to $fp-16
	# PushParam _tmp117
	  subu $sp, $sp, 4	# decrement sp to make space for param
	  lw $t0, -16($fp)	# fill _tmp117 to $t0 from $fp-16
	  sw $t0, 4($sp)	# copy param value to stack
	# LCall _PrintString
	  jal _PrintString   	# jump to function
	# PopParams 4
	  add $sp, $sp, 4	# pop params off stack
  _L15:
	# _tmp118 = *(arr)
	  lw $t0, 4($fp)	# fill arr to $t0 from $fp+4
	  lw $t2, 0($t0) 	# load with offset
	  sw $t2, -20($fp)	# spill _tmp118 from $t2 to $fp-20
	# _tmp119 = i < _tmp118
	  lw $t0, -8($fp)	# fill i to $t0 from $fp-8
	  lw $t1, -20($fp)	# fill _tmp118 to $t1 from $fp-20
	  slt $t2, $t0, $t1	
	  sw $t2, -24($fp)	# spill _tmp119 from $t2 to $fp-24
	# IfZ _tmp119 Goto _L16
	  lw $t0, -24($fp)	# fill _tmp119 to $t0 from $fp-24
	  beqz $t0, _L16	# branch if _tmp119 is zero 
	# _tmp120 = 0
	  li $t2, 0		# load constant value 0 into $t2
	  sw $t2, -28($fp)	# spill _tmp120 from $t2 to $fp-28
	# _tmp121 = *(arr)
	  lw $t0, 4($fp)	# fill arr to $t0 from $fp+4
	  lw $t2, 0($t0) 	# load with offset
	  sw $t2, -32($fp)	# spill _tmp121 from $t2 to $fp-32
	# _tmp122 = i < _tmp120
	  lw $t0, -8($fp)	# fill i to $t0 from $fp-8
	  lw $t1, -28($fp)	# fill _tmp120 to $t1 from $fp-28
	  slt $t2, $t0, $t1	
	  sw $t2, -36($fp)	# spill _tmp122 from $t2 to $fp-36
	# _tmp123 = _tmp121 < i
	  lw $t0, -32($fp)	# fill _tmp121 to $t0 from $fp-32
	  lw $t1, -8($fp)	# fill i to $t1 from $fp-8
	  slt $t2, $t0, $t1	
	  sw $t2, -40($fp)	# spill _tmp123 from $t2 to $fp-40
	# _tmp124 = _tmp121 == i
	  lw $t0, -32($fp)	# fill _tmp121 to $t0 from $fp-32
	  lw $t1, -8($fp)	# fill i to $t1 from $fp-8
	  seq $t2, $t0, $t1	
	  sw $t2, -44($fp)	# spill _tmp124 from $t2 to $fp-44
	# _tmp125 = _tmp123 || _tmp124
	  lw $t0, -40($fp)	# fill _tmp123 to $t0 from $fp-40
	  lw $t1, -44($fp)	# fill _tmp124 to $t1 from $fp-44
	  or $t2, $t0, $t1	
	  sw $t2, -48($fp)	# spill _tmp125 from $t2 to $fp-48
	# _tmp126 = _tmp125 || _tmp122
	  lw $t0, -48($fp)	# fill _tmp125 to $t0 from $fp-48
	  lw $t1, -36($fp)	# fill _tmp122 to $t1 from $fp-36
	  or $t2, $t0, $t1	
	  sw $t2, -52($fp)	# spill _tmp126 from $t2 to $fp-52
	# IfZ _tmp126 Goto _L17
	  lw $t0, -52($fp)	# fill _tmp126 to $t0 from $fp-52
	  beqz $t0, _L17	# branch if _tmp126 is zero 
	# _tmp127 = "Decaf runtime error: Array subscript out of bound..."
	  .data			# create string constant marked with label
	  _string11: .asciiz "Decaf runtime error: Array subscript out of bounds\n"
	  .text
	  la $t2, _string11	# load label
	  sw $t2, -56($fp)	# spill _tmp127 from $t2 to $fp-56
	# PushParam _tmp127
	  subu $sp, $sp, 4	# decrement sp to make space for param
	  lw $t0, -56($fp)	# fill _tmp127 to $t0 from $fp-56
	  sw $t0, 4($sp)	# copy param value to stack
	# LCall _PrintString
	  jal _PrintString   	# jump to function
	# PopParams 4
	  add $sp, $sp, 4	# pop params off stack
	# LCall _Halt
	  jal _Halt          	# jump to function
  _L17:
	# _tmp128 = 4
	  li $t2, 4		# load constant value 4 into $t2
	  sw $t2, -60($fp)	# spill _tmp128 from $t2 to $fp-60
	# _tmp129 = i * _tmp128
	  lw $t0, -8($fp)	# fill i to $t0 from $fp-8
	  lw $t1, -60($fp)	# fill _tmp128 to $t1 from $fp-60
	  mul $t2, $t0, $t1	
	  sw $t2, -64($fp)	# spill _tmp129 from $t2 to $fp-64
	# _tmp130 = _tmp129 + _tmp128
	  lw $t0, -64($fp)	# fill _tmp129 to $t0 from $fp-64
	  lw $t1, -60($fp)	# fill _tmp128 to $t1 from $fp-60
	  add $t2, $t0, $t1	
	  sw $t2, -68($fp)	# spill _tmp130 from $t2 to $fp-68
	# _tmp131 = arr + _tmp130
	  lw $t0, 4($fp)	# fill arr to $t0 from $fp+4
	  lw $t1, -68($fp)	# fill _tmp130 to $t1 from $fp-68
	  add $t2, $t0, $t1	
	  sw $t2, -72($fp)	# spill _tmp131 from $t2 to $fp-72
	# _tmp132 = *(_tmp131)
	  lw $t0, -72($fp)	# fill _tmp131 to $t0 from $fp-72
	  lw $t2, 0($t0) 	# load with offset
	  sw $t2, -76($fp)	# spill _tmp132 from $t2 to $fp-76
	# PushParam _tmp132
	  subu $sp, $sp, 4	# decrement sp to make space for param
	  lw $t0, -76($fp)	# fill _tmp132 to $t0 from $fp-76
	  sw $t0, 4($sp)	# copy param value to stack
	# LCall _PrintInt
	  jal _PrintInt      	# jump to function
	# PopParams 4
	  add $sp, $sp, 4	# pop params off stack
	# _tmp133 = " "
	  .data			# create string constant marked with label
	  _string12: .asciiz " "
	  .text
	  la $t2, _string12	# load label
	  sw $t2, -80($fp)	# spill _tmp133 from $t2 to $fp-80
	# PushParam _tmp133
	  subu $sp, $sp, 4	# decrement sp to make space for param
	  lw $t0, -80($fp)	# fill _tmp133 to $t0 from $fp-80
	  sw $t0, 4($sp)	# copy param value to stack
	# LCall _PrintString
	  jal _PrintString   	# jump to function
	# PopParams 4
	  add $sp, $sp, 4	# pop params off stack
	# _tmp134 = 1
	  li $t2, 1		# load constant value 1 into $t2
	  sw $t2, -84($fp)	# spill _tmp134 from $t2 to $fp-84
	# _tmp135 = i + _tmp134
	  lw $t0, -8($fp)	# fill i to $t0 from $fp-8
	  lw $t1, -84($fp)	# fill _tmp134 to $t1 from $fp-84
	  add $t2, $t0, $t1	
	  sw $t2, -88($fp)	# spill _tmp135 from $t2 to $fp-88
	# i = _tmp135
	  lw $t2, -88($fp)	# fill _tmp135 to $t2 from $fp-88
	  sw $t2, -8($fp)	# spill i from $t2 to $fp-8
	# Goto _L15
	  b _L15		# unconditional branch
  _L16:
	# _tmp136 = "\n"
	  .data			# create string constant marked with label
	  _string13: .asciiz "\n"
	  .text
	  la $t2, _string13	# load label
	  sw $t2, -92($fp)	# spill _tmp136 from $t2 to $fp-92
	# PushParam _tmp136
	  subu $sp, $sp, 4	# decrement sp to make space for param
	  lw $t0, -92($fp)	# fill _tmp136 to $t0 from $fp-92
	  sw $t0, 4($sp)	# copy param value to stack
	# LCall _PrintString
	  jal _PrintString   	# jump to function
	# PopParams 4
	  add $sp, $sp, 4	# pop params off stack
	# EndFunc
	# (below handles reaching end of fn body with no explicit return)
	  move $sp, $fp		# pop callee frame off stack
	  lw $ra, -4($fp)	# restore saved ra
	  lw $fp, 0($fp)	# restore saved fp
	  jr $ra		# return from function
  main:
	# BeginFunc 24
	  subu $sp, $sp, 8	# decrement sp to make space to save ra, fp
	  sw $fp, 8($sp)	# save fp
	  sw $ra, 4($sp)	# save ra
	  addiu $fp, $sp, 8	# set up new fp
	  subu $sp, $sp, 24	# decrement sp to make space for locals/temps
	# _tmp137 = "\nThis program will read in a bunch of numbers an..."
	  .data			# create string constant marked with label
	  _string14: .asciiz "\nThis program will read in a bunch of numbers and print them\n"
	  .text
	  la $t2, _string14	# load label
	  sw $t2, -12($fp)	# spill _tmp137 from $t2 to $fp-12
	# PushParam _tmp137
	  subu $sp, $sp, 4	# decrement sp to make space for param
	  lw $t0, -12($fp)	# fill _tmp137 to $t0 from $fp-12
	  sw $t0, 4($sp)	# copy param value to stack
	# LCall _PrintString
	  jal _PrintString   	# jump to function
	# PopParams 4
	  add $sp, $sp, 4	# pop params off stack
	# _tmp138 = "back out in sorted order.\n\n"
	  .data			# create string constant marked with label
	  _string15: .asciiz "back out in sorted order.\n\n"
	  .text
	  la $t2, _string15	# load label
	  sw $t2, -16($fp)	# spill _tmp138 from $t2 to $fp-16
	# PushParam _tmp138
	  subu $sp, $sp, 4	# decrement sp to make space for param
	  lw $t0, -16($fp)	# fill _tmp138 to $t0 from $fp-16
	  sw $t0, 4($sp)	# copy param value to stack
	# LCall _PrintString
	  jal _PrintString   	# jump to function
	# PopParams 4
	  add $sp, $sp, 4	# pop params off stack
	# _tmp139 = LCall ____ReadArray
	  jal ____ReadArray  	# jump to function
	  move $t2, $v0		# copy function return value from $v0
	  sw $t2, -20($fp)	# spill _tmp139 from $t2 to $fp-20
	# arr = _tmp139
	  lw $t2, -20($fp)	# fill _tmp139 to $t2 from $fp-20
	  sw $t2, -8($fp)	# spill arr from $t2 to $fp-8
	# PushParam arr
	  subu $sp, $sp, 4	# decrement sp to make space for param
	  lw $t0, -8($fp)	# fill arr to $t0 from $fp-8
	  sw $t0, 4($sp)	# copy param value to stack
	# LCall ____Sort
	  jal ____Sort       	# jump to function
	# PopParams 4
	  add $sp, $sp, 4	# pop params off stack
	# PushParam arr
	  subu $sp, $sp, 4	# decrement sp to make space for param
	  lw $t0, -8($fp)	# fill arr to $t0 from $fp-8
	  sw $t0, 4($sp)	# copy param value to stack
	# LCall ____PrintArray
	  jal ____PrintArray 	# jump to function
	# PopParams 4
	  add $sp, $sp, 4	# pop params off stack
	# EndFunc
	# (below handles reaching end of fn body with no explicit return)
	  move $sp, $fp		# pop callee frame off stack
	  lw $ra, -4($fp)	# restore saved ra
	  lw $fp, 0($fp)	# restore saved fp
	  jr $ra		# return from function
