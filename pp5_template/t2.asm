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
	  
  ____tester:
	# BeginFunc 236
	  subu $sp, $sp, 8	# decrement sp to make space to save ra, fp
	  sw $fp, 8($sp)	# save fp
	  sw $ra, 4($sp)	# save ra
	  addiu $fp, $sp, 8	# set up new fp
	  subu $sp, $sp, 236	# decrement sp to make space for locals/temps
	# _tmp0 = 1
	  li $t2, 1		# load constant value 1 into $t2
	  sw $t2, -16($fp)	# spill _tmp0 from $t2 to $fp-16
	# _tmp1 = 4
	  li $t2, 4		# load constant value 4 into $t2
	  sw $t2, -20($fp)	# spill _tmp1 from $t2 to $fp-20
	# _tmp2 = 0
	  li $t2, 0		# load constant value 0 into $t2
	  sw $t2, -24($fp)	# spill _tmp2 from $t2 to $fp-24
	# _tmp3 = _tmp0 < _tmp2
	  lw $t0, -16($fp)	# fill _tmp0 to $t0 from $fp-16
	  lw $t1, -24($fp)	# fill _tmp2 to $t1 from $fp-24
	  slt $t2, $t0, $t1	
	  sw $t2, -28($fp)	# spill _tmp3 from $t2 to $fp-28
	# _tmp4 = _tmp0 == _tmp2
	  lw $t0, -16($fp)	# fill _tmp0 to $t0 from $fp-16
	  lw $t1, -24($fp)	# fill _tmp2 to $t1 from $fp-24
	  seq $t2, $t0, $t1	
	  sw $t2, -32($fp)	# spill _tmp4 from $t2 to $fp-32
	# _tmp5 = _tmp3 || _tmp4
	  lw $t0, -28($fp)	# fill _tmp3 to $t0 from $fp-28
	  lw $t1, -32($fp)	# fill _tmp4 to $t1 from $fp-32
	  or $t2, $t0, $t1	
	  sw $t2, -36($fp)	# spill _tmp5 from $t2 to $fp-36
	# IfZ _tmp5 Goto _L0
	  lw $t0, -36($fp)	# fill _tmp5 to $t0 from $fp-36
	  beqz $t0, _L0	# branch if _tmp5 is zero 
	# _tmp6 = "Decaf runtime error: Array size is <= 0\n"
	  .data			# create string constant marked with label
	  _string1: .asciiz "Decaf runtime error: Array size is <= 0\n"
	  .text
	  la $t2, _string1	# load label
	  sw $t2, -40($fp)	# spill _tmp6 from $t2 to $fp-40
	# PushParam _tmp6
	  subu $sp, $sp, 4	# decrement sp to make space for param
	  lw $t0, -40($fp)	# fill _tmp6 to $t0 from $fp-40
	  sw $t0, 4($sp)	# copy param value to stack
	# LCall _PrintString
	  jal _PrintString   	# jump to function
	# PopParams 4
	  add $sp, $sp, 4	# pop params off stack
	# LCall _Halt
	  jal _Halt          	# jump to function
  _L0:
	# _tmp7 = _tmp0 * _tmp1
	  lw $t0, -16($fp)	# fill _tmp0 to $t0 from $fp-16
	  lw $t1, -20($fp)	# fill _tmp1 to $t1 from $fp-20
	  mul $t2, $t0, $t1	
	  sw $t2, -44($fp)	# spill _tmp7 from $t2 to $fp-44
	# _tmp8 = _tmp1 + _tmp7
	  lw $t0, -20($fp)	# fill _tmp1 to $t0 from $fp-20
	  lw $t1, -44($fp)	# fill _tmp7 to $t1 from $fp-44
	  add $t2, $t0, $t1	
	  sw $t2, -48($fp)	# spill _tmp8 from $t2 to $fp-48
	# PushParam _tmp8
	  subu $sp, $sp, 4	# decrement sp to make space for param
	  lw $t0, -48($fp)	# fill _tmp8 to $t0 from $fp-48
	  sw $t0, 4($sp)	# copy param value to stack
	# _tmp9 = LCall _Alloc
	  jal _Alloc         	# jump to function
	  move $t2, $v0		# copy function return value from $v0
	  sw $t2, -52($fp)	# spill _tmp9 from $t2 to $fp-52
	# PopParams 4
	  add $sp, $sp, 4	# pop params off stack
	# *(_tmp9) = _tmp0
	  lw $t0, -16($fp)	# fill _tmp0 to $t0 from $fp-16
	  lw $t2, -52($fp)	# fill _tmp9 to $t2 from $fp-52
	  sw $t0, 0($t2) 	# store with offset
	# b = _tmp9
	  lw $t2, -52($fp)	# fill _tmp9 to $t2 from $fp-52
	  sw $t2, 4($gp)	# spill b from $t2 to $gp+4
	# _tmp10 = 4
	  li $t2, 4		# load constant value 4 into $t2
	  sw $t2, -56($fp)	# spill _tmp10 from $t2 to $fp-56
	# _tmp11 = 0
	  li $t2, 0		# load constant value 0 into $t2
	  sw $t2, -60($fp)	# spill _tmp11 from $t2 to $fp-60
	# _tmp12 = sz < _tmp11
	  lw $t0, 4($fp)	# fill sz to $t0 from $fp+4
	  lw $t1, -60($fp)	# fill _tmp11 to $t1 from $fp-60
	  slt $t2, $t0, $t1	
	  sw $t2, -64($fp)	# spill _tmp12 from $t2 to $fp-64
	# _tmp13 = sz == _tmp11
	  lw $t0, 4($fp)	# fill sz to $t0 from $fp+4
	  lw $t1, -60($fp)	# fill _tmp11 to $t1 from $fp-60
	  seq $t2, $t0, $t1	
	  sw $t2, -68($fp)	# spill _tmp13 from $t2 to $fp-68
	# _tmp14 = _tmp12 || _tmp13
	  lw $t0, -64($fp)	# fill _tmp12 to $t0 from $fp-64
	  lw $t1, -68($fp)	# fill _tmp13 to $t1 from $fp-68
	  or $t2, $t0, $t1	
	  sw $t2, -72($fp)	# spill _tmp14 from $t2 to $fp-72
	# IfZ _tmp14 Goto _L1
	  lw $t0, -72($fp)	# fill _tmp14 to $t0 from $fp-72
	  beqz $t0, _L1	# branch if _tmp14 is zero 
	# _tmp15 = "Decaf runtime error: Array size is <= 0\n"
	  .data			# create string constant marked with label
	  _string2: .asciiz "Decaf runtime error: Array size is <= 0\n"
	  .text
	  la $t2, _string2	# load label
	  sw $t2, -76($fp)	# spill _tmp15 from $t2 to $fp-76
	# PushParam _tmp15
	  subu $sp, $sp, 4	# decrement sp to make space for param
	  lw $t0, -76($fp)	# fill _tmp15 to $t0 from $fp-76
	  sw $t0, 4($sp)	# copy param value to stack
	# LCall _PrintString
	  jal _PrintString   	# jump to function
	# PopParams 4
	  add $sp, $sp, 4	# pop params off stack
	# LCall _Halt
	  jal _Halt          	# jump to function
  _L1:
	# _tmp16 = sz * _tmp10
	  lw $t0, 4($fp)	# fill sz to $t0 from $fp+4
	  lw $t1, -56($fp)	# fill _tmp10 to $t1 from $fp-56
	  mul $t2, $t0, $t1	
	  sw $t2, -80($fp)	# spill _tmp16 from $t2 to $fp-80
	# _tmp17 = _tmp10 + _tmp16
	  lw $t0, -56($fp)	# fill _tmp10 to $t0 from $fp-56
	  lw $t1, -80($fp)	# fill _tmp16 to $t1 from $fp-80
	  add $t2, $t0, $t1	
	  sw $t2, -84($fp)	# spill _tmp17 from $t2 to $fp-84
	# PushParam _tmp17
	  subu $sp, $sp, 4	# decrement sp to make space for param
	  lw $t0, -84($fp)	# fill _tmp17 to $t0 from $fp-84
	  sw $t0, 4($sp)	# copy param value to stack
	# _tmp18 = LCall _Alloc
	  jal _Alloc         	# jump to function
	  move $t2, $v0		# copy function return value from $v0
	  sw $t2, -88($fp)	# spill _tmp18 from $t2 to $fp-88
	# PopParams 4
	  add $sp, $sp, 4	# pop params off stack
	# *(_tmp18) = sz
	  lw $t0, 4($fp)	# fill sz to $t0 from $fp+4
	  lw $t2, -88($fp)	# fill _tmp18 to $t2 from $fp-88
	  sw $t0, 0($t2) 	# store with offset
	# result = _tmp18
	  lw $t2, -88($fp)	# fill _tmp18 to $t2 from $fp-88
	  sw $t2, -12($fp)	# spill result from $t2 to $fp-12
	# _tmp19 = 0
	  li $t2, 0		# load constant value 0 into $t2
	  sw $t2, -92($fp)	# spill _tmp19 from $t2 to $fp-92
	# i = _tmp19
	  lw $t2, -92($fp)	# fill _tmp19 to $t2 from $fp-92
	  sw $t2, -8($fp)	# spill i from $t2 to $fp-8
  _L2:
	# _tmp20 = i < sz
	  lw $t0, -8($fp)	# fill i to $t0 from $fp-8
	  lw $t1, 4($fp)	# fill sz to $t1 from $fp+4
	  slt $t2, $t0, $t1	
	  sw $t2, -96($fp)	# spill _tmp20 from $t2 to $fp-96
	# IfZ _tmp20 Goto _L3
	  lw $t0, -96($fp)	# fill _tmp20 to $t0 from $fp-96
	  beqz $t0, _L3	# branch if _tmp20 is zero 
	# _tmp21 = 0
	  li $t2, 0		# load constant value 0 into $t2
	  sw $t2, -100($fp)	# spill _tmp21 from $t2 to $fp-100
	# _tmp22 = *(result)
	  lw $t0, -12($fp)	# fill result to $t0 from $fp-12
	  lw $t2, 0($t0) 	# load with offset
	  sw $t2, -104($fp)	# spill _tmp22 from $t2 to $fp-104
	# _tmp23 = i < _tmp21
	  lw $t0, -8($fp)	# fill i to $t0 from $fp-8
	  lw $t1, -100($fp)	# fill _tmp21 to $t1 from $fp-100
	  slt $t2, $t0, $t1	
	  sw $t2, -108($fp)	# spill _tmp23 from $t2 to $fp-108
	# _tmp24 = _tmp22 < i
	  lw $t0, -104($fp)	# fill _tmp22 to $t0 from $fp-104
	  lw $t1, -8($fp)	# fill i to $t1 from $fp-8
	  slt $t2, $t0, $t1	
	  sw $t2, -112($fp)	# spill _tmp24 from $t2 to $fp-112
	# _tmp25 = _tmp22 == i
	  lw $t0, -104($fp)	# fill _tmp22 to $t0 from $fp-104
	  lw $t1, -8($fp)	# fill i to $t1 from $fp-8
	  seq $t2, $t0, $t1	
	  sw $t2, -116($fp)	# spill _tmp25 from $t2 to $fp-116
	# _tmp26 = _tmp24 || _tmp25
	  lw $t0, -112($fp)	# fill _tmp24 to $t0 from $fp-112
	  lw $t1, -116($fp)	# fill _tmp25 to $t1 from $fp-116
	  or $t2, $t0, $t1	
	  sw $t2, -120($fp)	# spill _tmp26 from $t2 to $fp-120
	# _tmp27 = _tmp26 || _tmp23
	  lw $t0, -120($fp)	# fill _tmp26 to $t0 from $fp-120
	  lw $t1, -108($fp)	# fill _tmp23 to $t1 from $fp-108
	  or $t2, $t0, $t1	
	  sw $t2, -124($fp)	# spill _tmp27 from $t2 to $fp-124
	# IfZ _tmp27 Goto _L4
	  lw $t0, -124($fp)	# fill _tmp27 to $t0 from $fp-124
	  beqz $t0, _L4	# branch if _tmp27 is zero 
	# _tmp28 = "Decaf runtime error: Array subscript out of bound..."
	  .data			# create string constant marked with label
	  _string3: .asciiz "Decaf runtime error: Array subscript out of bounds\n"
	  .text
	  la $t2, _string3	# load label
	  sw $t2, -128($fp)	# spill _tmp28 from $t2 to $fp-128
	# PushParam _tmp28
	  subu $sp, $sp, 4	# decrement sp to make space for param
	  lw $t0, -128($fp)	# fill _tmp28 to $t0 from $fp-128
	  sw $t0, 4($sp)	# copy param value to stack
	# LCall _PrintString
	  jal _PrintString   	# jump to function
	# PopParams 4
	  add $sp, $sp, 4	# pop params off stack
	# LCall _Halt
	  jal _Halt          	# jump to function
  _L4:
	# _tmp29 = 4
	  li $t2, 4		# load constant value 4 into $t2
	  sw $t2, -132($fp)	# spill _tmp29 from $t2 to $fp-132
	# _tmp30 = i * _tmp29
	  lw $t0, -8($fp)	# fill i to $t0 from $fp-8
	  lw $t1, -132($fp)	# fill _tmp29 to $t1 from $fp-132
	  mul $t2, $t0, $t1	
	  sw $t2, -136($fp)	# spill _tmp30 from $t2 to $fp-136
	# _tmp31 = _tmp30 + _tmp29
	  lw $t0, -136($fp)	# fill _tmp30 to $t0 from $fp-136
	  lw $t1, -132($fp)	# fill _tmp29 to $t1 from $fp-132
	  add $t2, $t0, $t1	
	  sw $t2, -140($fp)	# spill _tmp31 from $t2 to $fp-140
	# _tmp32 = result + _tmp31
	  lw $t0, -12($fp)	# fill result to $t0 from $fp-12
	  lw $t1, -140($fp)	# fill _tmp31 to $t1 from $fp-140
	  add $t2, $t0, $t1	
	  sw $t2, -144($fp)	# spill _tmp32 from $t2 to $fp-144
	# *(_tmp32) = i
	  lw $t0, -8($fp)	# fill i to $t0 from $fp-8
	  lw $t2, -144($fp)	# fill _tmp32 to $t2 from $fp-144
	  sw $t0, 0($t2) 	# store with offset
	# _tmp33 = *(_tmp32)
	  lw $t0, -144($fp)	# fill _tmp32 to $t0 from $fp-144
	  lw $t2, 0($t0) 	# load with offset
	  sw $t2, -148($fp)	# spill _tmp33 from $t2 to $fp-148
	# _tmp34 = 1
	  li $t2, 1		# load constant value 1 into $t2
	  sw $t2, -152($fp)	# spill _tmp34 from $t2 to $fp-152
	# _tmp35 = i + _tmp34
	  lw $t0, -8($fp)	# fill i to $t0 from $fp-8
	  lw $t1, -152($fp)	# fill _tmp34 to $t1 from $fp-152
	  add $t2, $t0, $t1	
	  sw $t2, -156($fp)	# spill _tmp35 from $t2 to $fp-156
	# i = _tmp35
	  lw $t2, -156($fp)	# fill _tmp35 to $t2 from $fp-156
	  sw $t2, -8($fp)	# spill i from $t2 to $fp-8
	# Goto _L2
	  b _L2		# unconditional branch
  _L3:
	# _tmp36 = "Done"
	  .data			# create string constant marked with label
	  _string4: .asciiz "Done"
	  .text
	  la $t2, _string4	# load label
	  sw $t2, -160($fp)	# spill _tmp36 from $t2 to $fp-160
	# _tmp37 = 0
	  li $t2, 0		# load constant value 0 into $t2
	  sw $t2, -164($fp)	# spill _tmp37 from $t2 to $fp-164
	# _tmp38 = 0
	  li $t2, 0		# load constant value 0 into $t2
	  sw $t2, -168($fp)	# spill _tmp38 from $t2 to $fp-168
	# _tmp39 = *(b)
	  lw $t0, 4($gp)	# fill b to $t0 from $gp+4
	  lw $t2, 0($t0) 	# load with offset
	  sw $t2, -172($fp)	# spill _tmp39 from $t2 to $fp-172
	# _tmp40 = _tmp37 < _tmp38
	  lw $t0, -164($fp)	# fill _tmp37 to $t0 from $fp-164
	  lw $t1, -168($fp)	# fill _tmp38 to $t1 from $fp-168
	  slt $t2, $t0, $t1	
	  sw $t2, -176($fp)	# spill _tmp40 from $t2 to $fp-176
	# _tmp41 = _tmp39 < _tmp37
	  lw $t0, -172($fp)	# fill _tmp39 to $t0 from $fp-172
	  lw $t1, -164($fp)	# fill _tmp37 to $t1 from $fp-164
	  slt $t2, $t0, $t1	
	  sw $t2, -180($fp)	# spill _tmp41 from $t2 to $fp-180
	# _tmp42 = _tmp39 == _tmp37
	  lw $t0, -172($fp)	# fill _tmp39 to $t0 from $fp-172
	  lw $t1, -164($fp)	# fill _tmp37 to $t1 from $fp-164
	  seq $t2, $t0, $t1	
	  sw $t2, -184($fp)	# spill _tmp42 from $t2 to $fp-184
	# _tmp43 = _tmp41 || _tmp42
	  lw $t0, -180($fp)	# fill _tmp41 to $t0 from $fp-180
	  lw $t1, -184($fp)	# fill _tmp42 to $t1 from $fp-184
	  or $t2, $t0, $t1	
	  sw $t2, -188($fp)	# spill _tmp43 from $t2 to $fp-188
	# _tmp44 = _tmp43 || _tmp40
	  lw $t0, -188($fp)	# fill _tmp43 to $t0 from $fp-188
	  lw $t1, -176($fp)	# fill _tmp40 to $t1 from $fp-176
	  or $t2, $t0, $t1	
	  sw $t2, -192($fp)	# spill _tmp44 from $t2 to $fp-192
	# IfZ _tmp44 Goto _L5
	  lw $t0, -192($fp)	# fill _tmp44 to $t0 from $fp-192
	  beqz $t0, _L5	# branch if _tmp44 is zero 
	# _tmp45 = "Decaf runtime error: Array subscript out of bound..."
	  .data			# create string constant marked with label
	  _string5: .asciiz "Decaf runtime error: Array subscript out of bounds\n"
	  .text
	  la $t2, _string5	# load label
	  sw $t2, -196($fp)	# spill _tmp45 from $t2 to $fp-196
	# PushParam _tmp45
	  subu $sp, $sp, 4	# decrement sp to make space for param
	  lw $t0, -196($fp)	# fill _tmp45 to $t0 from $fp-196
	  sw $t0, 4($sp)	# copy param value to stack
	# LCall _PrintString
	  jal _PrintString   	# jump to function
	# PopParams 4
	  add $sp, $sp, 4	# pop params off stack
	# LCall _Halt
	  jal _Halt          	# jump to function
  _L5:
	# _tmp46 = 4
	  li $t2, 4		# load constant value 4 into $t2
	  sw $t2, -200($fp)	# spill _tmp46 from $t2 to $fp-200
	# _tmp47 = _tmp37 * _tmp46
	  lw $t0, -164($fp)	# fill _tmp37 to $t0 from $fp-164
	  lw $t1, -200($fp)	# fill _tmp46 to $t1 from $fp-200
	  mul $t2, $t0, $t1	
	  sw $t2, -204($fp)	# spill _tmp47 from $t2 to $fp-204
	# _tmp48 = _tmp47 + _tmp46
	  lw $t0, -204($fp)	# fill _tmp47 to $t0 from $fp-204
	  lw $t1, -200($fp)	# fill _tmp46 to $t1 from $fp-200
	  add $t2, $t0, $t1	
	  sw $t2, -208($fp)	# spill _tmp48 from $t2 to $fp-208
	# _tmp49 = b + _tmp48
	  lw $t0, 4($gp)	# fill b to $t0 from $gp+4
	  lw $t1, -208($fp)	# fill _tmp48 to $t1 from $fp-208
	  add $t2, $t0, $t1	
	  sw $t2, -212($fp)	# spill _tmp49 from $t2 to $fp-212
	# *(_tmp49) = _tmp36
	  lw $t0, -160($fp)	# fill _tmp36 to $t0 from $fp-160
	  lw $t2, -212($fp)	# fill _tmp49 to $t2 from $fp-212
	  sw $t0, 0($t2) 	# store with offset
	# _tmp50 = *(_tmp49)
	  lw $t0, -212($fp)	# fill _tmp49 to $t0 from $fp-212
	  lw $t2, 0($t0) 	# load with offset
	  sw $t2, -216($fp)	# spill _tmp50 from $t2 to $fp-216
	# Return result
	  lw $t2, -12($fp)	# fill result to $t2 from $fp-12
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
	# BeginFunc 204
	  subu $sp, $sp, 8	# decrement sp to make space to save ra, fp
	  sw $fp, 8($sp)	# save fp
	  sw $ra, 4($sp)	# save ra
	  addiu $fp, $sp, 8	# set up new fp
	  subu $sp, $sp, 204	# decrement sp to make space for locals/temps
	# _tmp51 = 8
	  li $t2, 8		# load constant value 8 into $t2
	  sw $t2, -12($fp)	# spill _tmp51 from $t2 to $fp-12
	# PushParam _tmp51
	  subu $sp, $sp, 4	# decrement sp to make space for param
	  lw $t0, -12($fp)	# fill _tmp51 to $t0 from $fp-12
	  sw $t0, 4($sp)	# copy param value to stack
	# _tmp52 = LCall ____tester
	  jal ____tester     	# jump to function
	  move $t2, $v0		# copy function return value from $v0
	  sw $t2, -16($fp)	# spill _tmp52 from $t2 to $fp-16
	# PopParams 4
	  add $sp, $sp, 4	# pop params off stack
	# d = _tmp52
	  lw $t2, -16($fp)	# fill _tmp52 to $t2 from $fp-16
	  sw $t2, -8($fp)	# spill d from $t2 to $fp-8
	# _tmp53 = 1
	  li $t2, 1		# load constant value 1 into $t2
	  sw $t2, -20($fp)	# spill _tmp53 from $t2 to $fp-20
	# _tmp54 = 0
	  li $t2, 0		# load constant value 0 into $t2
	  sw $t2, -24($fp)	# spill _tmp54 from $t2 to $fp-24
	# _tmp55 = *(d)
	  lw $t0, -8($fp)	# fill d to $t0 from $fp-8
	  lw $t2, 0($t0) 	# load with offset
	  sw $t2, -28($fp)	# spill _tmp55 from $t2 to $fp-28
	# _tmp56 = _tmp53 < _tmp54
	  lw $t0, -20($fp)	# fill _tmp53 to $t0 from $fp-20
	  lw $t1, -24($fp)	# fill _tmp54 to $t1 from $fp-24
	  slt $t2, $t0, $t1	
	  sw $t2, -32($fp)	# spill _tmp56 from $t2 to $fp-32
	# _tmp57 = _tmp55 < _tmp53
	  lw $t0, -28($fp)	# fill _tmp55 to $t0 from $fp-28
	  lw $t1, -20($fp)	# fill _tmp53 to $t1 from $fp-20
	  slt $t2, $t0, $t1	
	  sw $t2, -36($fp)	# spill _tmp57 from $t2 to $fp-36
	# _tmp58 = _tmp55 == _tmp53
	  lw $t0, -28($fp)	# fill _tmp55 to $t0 from $fp-28
	  lw $t1, -20($fp)	# fill _tmp53 to $t1 from $fp-20
	  seq $t2, $t0, $t1	
	  sw $t2, -40($fp)	# spill _tmp58 from $t2 to $fp-40
	# _tmp59 = _tmp57 || _tmp58
	  lw $t0, -36($fp)	# fill _tmp57 to $t0 from $fp-36
	  lw $t1, -40($fp)	# fill _tmp58 to $t1 from $fp-40
	  or $t2, $t0, $t1	
	  sw $t2, -44($fp)	# spill _tmp59 from $t2 to $fp-44
	# _tmp60 = _tmp59 || _tmp56
	  lw $t0, -44($fp)	# fill _tmp59 to $t0 from $fp-44
	  lw $t1, -32($fp)	# fill _tmp56 to $t1 from $fp-32
	  or $t2, $t0, $t1	
	  sw $t2, -48($fp)	# spill _tmp60 from $t2 to $fp-48
	# IfZ _tmp60 Goto _L6
	  lw $t0, -48($fp)	# fill _tmp60 to $t0 from $fp-48
	  beqz $t0, _L6	# branch if _tmp60 is zero 
	# _tmp61 = "Decaf runtime error: Array subscript out of bound..."
	  .data			# create string constant marked with label
	  _string6: .asciiz "Decaf runtime error: Array subscript out of bounds\n"
	  .text
	  la $t2, _string6	# load label
	  sw $t2, -52($fp)	# spill _tmp61 from $t2 to $fp-52
	# PushParam _tmp61
	  subu $sp, $sp, 4	# decrement sp to make space for param
	  lw $t0, -52($fp)	# fill _tmp61 to $t0 from $fp-52
	  sw $t0, 4($sp)	# copy param value to stack
	# LCall _PrintString
	  jal _PrintString   	# jump to function
	# PopParams 4
	  add $sp, $sp, 4	# pop params off stack
	# LCall _Halt
	  jal _Halt          	# jump to function
  _L6:
	# _tmp62 = 4
	  li $t2, 4		# load constant value 4 into $t2
	  sw $t2, -56($fp)	# spill _tmp62 from $t2 to $fp-56
	# _tmp63 = _tmp53 * _tmp62
	  lw $t0, -20($fp)	# fill _tmp53 to $t0 from $fp-20
	  lw $t1, -56($fp)	# fill _tmp62 to $t1 from $fp-56
	  mul $t2, $t0, $t1	
	  sw $t2, -60($fp)	# spill _tmp63 from $t2 to $fp-60
	# _tmp64 = _tmp63 + _tmp62
	  lw $t0, -60($fp)	# fill _tmp63 to $t0 from $fp-60
	  lw $t1, -56($fp)	# fill _tmp62 to $t1 from $fp-56
	  add $t2, $t0, $t1	
	  sw $t2, -64($fp)	# spill _tmp64 from $t2 to $fp-64
	# _tmp65 = d + _tmp64
	  lw $t0, -8($fp)	# fill d to $t0 from $fp-8
	  lw $t1, -64($fp)	# fill _tmp64 to $t1 from $fp-64
	  add $t2, $t0, $t1	
	  sw $t2, -68($fp)	# spill _tmp65 from $t2 to $fp-68
	# _tmp66 = *(_tmp65)
	  lw $t0, -68($fp)	# fill _tmp65 to $t0 from $fp-68
	  lw $t2, 0($t0) 	# load with offset
	  sw $t2, -72($fp)	# spill _tmp66 from $t2 to $fp-72
	# _tmp67 = 0
	  li $t2, 0		# load constant value 0 into $t2
	  sw $t2, -76($fp)	# spill _tmp67 from $t2 to $fp-76
	# _tmp68 = *(d)
	  lw $t0, -8($fp)	# fill d to $t0 from $fp-8
	  lw $t2, 0($t0) 	# load with offset
	  sw $t2, -80($fp)	# spill _tmp68 from $t2 to $fp-80
	# _tmp69 = _tmp66 < _tmp67
	  lw $t0, -72($fp)	# fill _tmp66 to $t0 from $fp-72
	  lw $t1, -76($fp)	# fill _tmp67 to $t1 from $fp-76
	  slt $t2, $t0, $t1	
	  sw $t2, -84($fp)	# spill _tmp69 from $t2 to $fp-84
	# _tmp70 = _tmp68 < _tmp66
	  lw $t0, -80($fp)	# fill _tmp68 to $t0 from $fp-80
	  lw $t1, -72($fp)	# fill _tmp66 to $t1 from $fp-72
	  slt $t2, $t0, $t1	
	  sw $t2, -88($fp)	# spill _tmp70 from $t2 to $fp-88
	# _tmp71 = _tmp68 == _tmp66
	  lw $t0, -80($fp)	# fill _tmp68 to $t0 from $fp-80
	  lw $t1, -72($fp)	# fill _tmp66 to $t1 from $fp-72
	  seq $t2, $t0, $t1	
	  sw $t2, -92($fp)	# spill _tmp71 from $t2 to $fp-92
	# _tmp72 = _tmp70 || _tmp71
	  lw $t0, -88($fp)	# fill _tmp70 to $t0 from $fp-88
	  lw $t1, -92($fp)	# fill _tmp71 to $t1 from $fp-92
	  or $t2, $t0, $t1	
	  sw $t2, -96($fp)	# spill _tmp72 from $t2 to $fp-96
	# _tmp73 = _tmp72 || _tmp69
	  lw $t0, -96($fp)	# fill _tmp72 to $t0 from $fp-96
	  lw $t1, -84($fp)	# fill _tmp69 to $t1 from $fp-84
	  or $t2, $t0, $t1	
	  sw $t2, -100($fp)	# spill _tmp73 from $t2 to $fp-100
	# IfZ _tmp73 Goto _L7
	  lw $t0, -100($fp)	# fill _tmp73 to $t0 from $fp-100
	  beqz $t0, _L7	# branch if _tmp73 is zero 
	# _tmp74 = "Decaf runtime error: Array subscript out of bound..."
	  .data			# create string constant marked with label
	  _string7: .asciiz "Decaf runtime error: Array subscript out of bounds\n"
	  .text
	  la $t2, _string7	# load label
	  sw $t2, -104($fp)	# spill _tmp74 from $t2 to $fp-104
	# PushParam _tmp74
	  subu $sp, $sp, 4	# decrement sp to make space for param
	  lw $t0, -104($fp)	# fill _tmp74 to $t0 from $fp-104
	  sw $t0, 4($sp)	# copy param value to stack
	# LCall _PrintString
	  jal _PrintString   	# jump to function
	# PopParams 4
	  add $sp, $sp, 4	# pop params off stack
	# LCall _Halt
	  jal _Halt          	# jump to function
  _L7:
	# _tmp75 = 4
	  li $t2, 4		# load constant value 4 into $t2
	  sw $t2, -108($fp)	# spill _tmp75 from $t2 to $fp-108
	# _tmp76 = _tmp66 * _tmp75
	  lw $t0, -72($fp)	# fill _tmp66 to $t0 from $fp-72
	  lw $t1, -108($fp)	# fill _tmp75 to $t1 from $fp-108
	  mul $t2, $t0, $t1	
	  sw $t2, -112($fp)	# spill _tmp76 from $t2 to $fp-112
	# _tmp77 = _tmp76 + _tmp75
	  lw $t0, -112($fp)	# fill _tmp76 to $t0 from $fp-112
	  lw $t1, -108($fp)	# fill _tmp75 to $t1 from $fp-108
	  add $t2, $t0, $t1	
	  sw $t2, -116($fp)	# spill _tmp77 from $t2 to $fp-116
	# _tmp78 = d + _tmp77
	  lw $t0, -8($fp)	# fill d to $t0 from $fp-8
	  lw $t1, -116($fp)	# fill _tmp77 to $t1 from $fp-116
	  add $t2, $t0, $t1	
	  sw $t2, -120($fp)	# spill _tmp78 from $t2 to $fp-120
	# _tmp79 = *(_tmp78)
	  lw $t0, -120($fp)	# fill _tmp78 to $t0 from $fp-120
	  lw $t2, 0($t0) 	# load with offset
	  sw $t2, -124($fp)	# spill _tmp79 from $t2 to $fp-124
	# PushParam _tmp79
	  subu $sp, $sp, 4	# decrement sp to make space for param
	  lw $t0, -124($fp)	# fill _tmp79 to $t0 from $fp-124
	  sw $t0, 4($sp)	# copy param value to stack
	# LCall _PrintInt
	  jal _PrintInt      	# jump to function
	# PopParams 4
	  add $sp, $sp, 4	# pop params off stack
	# _tmp80 = "\n"
	  .data			# create string constant marked with label
	  _string8: .asciiz "\n"
	  .text
	  la $t2, _string8	# load label
	  sw $t2, -128($fp)	# spill _tmp80 from $t2 to $fp-128
	# PushParam _tmp80
	  subu $sp, $sp, 4	# decrement sp to make space for param
	  lw $t0, -128($fp)	# fill _tmp80 to $t0 from $fp-128
	  sw $t0, 4($sp)	# copy param value to stack
	# LCall _PrintString
	  jal _PrintString   	# jump to function
	# PopParams 4
	  add $sp, $sp, 4	# pop params off stack
	# _tmp81 = *(d)
	  lw $t0, -8($fp)	# fill d to $t0 from $fp-8
	  lw $t2, 0($t0) 	# load with offset
	  sw $t2, -132($fp)	# spill _tmp81 from $t2 to $fp-132
	# PushParam _tmp81
	  subu $sp, $sp, 4	# decrement sp to make space for param
	  lw $t0, -132($fp)	# fill _tmp81 to $t0 from $fp-132
	  sw $t0, 4($sp)	# copy param value to stack
	# LCall _PrintInt
	  jal _PrintInt      	# jump to function
	# PopParams 4
	  add $sp, $sp, 4	# pop params off stack
	# _tmp82 = "\n"
	  .data			# create string constant marked with label
	  _string9: .asciiz "\n"
	  .text
	  la $t2, _string9	# load label
	  sw $t2, -136($fp)	# spill _tmp82 from $t2 to $fp-136
	# PushParam _tmp82
	  subu $sp, $sp, 4	# decrement sp to make space for param
	  lw $t0, -136($fp)	# fill _tmp82 to $t0 from $fp-136
	  sw $t0, 4($sp)	# copy param value to stack
	# LCall _PrintString
	  jal _PrintString   	# jump to function
	# PopParams 4
	  add $sp, $sp, 4	# pop params off stack
	# _tmp83 = 0
	  li $t2, 0		# load constant value 0 into $t2
	  sw $t2, -140($fp)	# spill _tmp83 from $t2 to $fp-140
	# _tmp84 = 0
	  li $t2, 0		# load constant value 0 into $t2
	  sw $t2, -144($fp)	# spill _tmp84 from $t2 to $fp-144
	# _tmp85 = *(b)
	  lw $t0, 4($gp)	# fill b to $t0 from $gp+4
	  lw $t2, 0($t0) 	# load with offset
	  sw $t2, -148($fp)	# spill _tmp85 from $t2 to $fp-148
	# _tmp86 = _tmp83 < _tmp84
	  lw $t0, -140($fp)	# fill _tmp83 to $t0 from $fp-140
	  lw $t1, -144($fp)	# fill _tmp84 to $t1 from $fp-144
	  slt $t2, $t0, $t1	
	  sw $t2, -152($fp)	# spill _tmp86 from $t2 to $fp-152
	# _tmp87 = _tmp85 < _tmp83
	  lw $t0, -148($fp)	# fill _tmp85 to $t0 from $fp-148
	  lw $t1, -140($fp)	# fill _tmp83 to $t1 from $fp-140
	  slt $t2, $t0, $t1	
	  sw $t2, -156($fp)	# spill _tmp87 from $t2 to $fp-156
	# _tmp88 = _tmp85 == _tmp83
	  lw $t0, -148($fp)	# fill _tmp85 to $t0 from $fp-148
	  lw $t1, -140($fp)	# fill _tmp83 to $t1 from $fp-140
	  seq $t2, $t0, $t1	
	  sw $t2, -160($fp)	# spill _tmp88 from $t2 to $fp-160
	# _tmp89 = _tmp87 || _tmp88
	  lw $t0, -156($fp)	# fill _tmp87 to $t0 from $fp-156
	  lw $t1, -160($fp)	# fill _tmp88 to $t1 from $fp-160
	  or $t2, $t0, $t1	
	  sw $t2, -164($fp)	# spill _tmp89 from $t2 to $fp-164
	# _tmp90 = _tmp89 || _tmp86
	  lw $t0, -164($fp)	# fill _tmp89 to $t0 from $fp-164
	  lw $t1, -152($fp)	# fill _tmp86 to $t1 from $fp-152
	  or $t2, $t0, $t1	
	  sw $t2, -168($fp)	# spill _tmp90 from $t2 to $fp-168
	# IfZ _tmp90 Goto _L8
	  lw $t0, -168($fp)	# fill _tmp90 to $t0 from $fp-168
	  beqz $t0, _L8	# branch if _tmp90 is zero 
	# _tmp91 = "Decaf runtime error: Array subscript out of bound..."
	  .data			# create string constant marked with label
	  _string10: .asciiz "Decaf runtime error: Array subscript out of bounds\n"
	  .text
	  la $t2, _string10	# load label
	  sw $t2, -172($fp)	# spill _tmp91 from $t2 to $fp-172
	# PushParam _tmp91
	  subu $sp, $sp, 4	# decrement sp to make space for param
	  lw $t0, -172($fp)	# fill _tmp91 to $t0 from $fp-172
	  sw $t0, 4($sp)	# copy param value to stack
	# LCall _PrintString
	  jal _PrintString   	# jump to function
	# PopParams 4
	  add $sp, $sp, 4	# pop params off stack
	# LCall _Halt
	  jal _Halt          	# jump to function
  _L8:
	# _tmp92 = 4
	  li $t2, 4		# load constant value 4 into $t2
	  sw $t2, -176($fp)	# spill _tmp92 from $t2 to $fp-176
	# _tmp93 = _tmp83 * _tmp92
	  lw $t0, -140($fp)	# fill _tmp83 to $t0 from $fp-140
	  lw $t1, -176($fp)	# fill _tmp92 to $t1 from $fp-176
	  mul $t2, $t0, $t1	
	  sw $t2, -180($fp)	# spill _tmp93 from $t2 to $fp-180
	# _tmp94 = _tmp93 + _tmp92
	  lw $t0, -180($fp)	# fill _tmp93 to $t0 from $fp-180
	  lw $t1, -176($fp)	# fill _tmp92 to $t1 from $fp-176
	  add $t2, $t0, $t1	
	  sw $t2, -184($fp)	# spill _tmp94 from $t2 to $fp-184
	# _tmp95 = b + _tmp94
	  lw $t0, 4($gp)	# fill b to $t0 from $gp+4
	  lw $t1, -184($fp)	# fill _tmp94 to $t1 from $fp-184
	  add $t2, $t0, $t1	
	  sw $t2, -188($fp)	# spill _tmp95 from $t2 to $fp-188
	# _tmp96 = *(_tmp95)
	  lw $t0, -188($fp)	# fill _tmp95 to $t0 from $fp-188
	  lw $t2, 0($t0) 	# load with offset
	  sw $t2, -192($fp)	# spill _tmp96 from $t2 to $fp-192
	# PushParam _tmp96
	  subu $sp, $sp, 4	# decrement sp to make space for param
	  lw $t0, -192($fp)	# fill _tmp96 to $t0 from $fp-192
	  sw $t0, 4($sp)	# copy param value to stack
	# LCall _PrintString
	  jal _PrintString   	# jump to function
	# PopParams 4
	  add $sp, $sp, 4	# pop params off stack
	# _tmp97 = "\n"
	  .data			# create string constant marked with label
	  _string11: .asciiz "\n"
	  .text
	  la $t2, _string11	# load label
	  sw $t2, -196($fp)	# spill _tmp97 from $t2 to $fp-196
	# PushParam _tmp97
	  subu $sp, $sp, 4	# decrement sp to make space for param
	  lw $t0, -196($fp)	# fill _tmp97 to $t0 from $fp-196
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
