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
	  
  main:
	# BeginFunc 160
	  subu $sp, $sp, 8	# decrement sp to make space to save ra, fp
	  sw $fp, 8($sp)	# save fp
	  sw $ra, 4($sp)	# save ra
	  addiu $fp, $sp, 8	# set up new fp
	  subu $sp, $sp, 160	# decrement sp to make space for locals/temps
	# _tmp0 = 10
	  li $t2, 10		# load constant value 10 into $t2
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
	# arr = _tmp9
	  lw $t2, -52($fp)	# fill _tmp9 to $t2 from $fp-52
	  sw $t2, -8($fp)	# spill arr from $t2 to $fp-8
	# _tmp10 = 0
	  li $t2, 0		# load constant value 0 into $t2
	  sw $t2, -56($fp)	# spill _tmp10 from $t2 to $fp-56
	# i = _tmp10
	  lw $t2, -56($fp)	# fill _tmp10 to $t2 from $fp-56
	  sw $t2, -12($fp)	# spill i from $t2 to $fp-12
  _L1:
	# _tmp11 = 10
	  li $t2, 10		# load constant value 10 into $t2
	  sw $t2, -60($fp)	# spill _tmp11 from $t2 to $fp-60
	# _tmp12 = i < _tmp11
	  lw $t0, -12($fp)	# fill i to $t0 from $fp-12
	  lw $t1, -60($fp)	# fill _tmp11 to $t1 from $fp-60
	  slt $t2, $t0, $t1	
	  sw $t2, -64($fp)	# spill _tmp12 from $t2 to $fp-64
	# _tmp13 = i == _tmp11
	  lw $t0, -12($fp)	# fill i to $t0 from $fp-12
	  lw $t1, -60($fp)	# fill _tmp11 to $t1 from $fp-60
	  seq $t2, $t0, $t1	
	  sw $t2, -68($fp)	# spill _tmp13 from $t2 to $fp-68
	# _tmp14 = _tmp12 || _tmp13
	  lw $t0, -64($fp)	# fill _tmp12 to $t0 from $fp-64
	  lw $t1, -68($fp)	# fill _tmp13 to $t1 from $fp-68
	  or $t2, $t0, $t1	
	  sw $t2, -72($fp)	# spill _tmp14 from $t2 to $fp-72
	# IfZ _tmp14 Goto _L2
	  lw $t0, -72($fp)	# fill _tmp14 to $t0 from $fp-72
	  beqz $t0, _L2	# branch if _tmp14 is zero 
	# _tmp15 = 0
	  li $t2, 0		# load constant value 0 into $t2
	  sw $t2, -76($fp)	# spill _tmp15 from $t2 to $fp-76
	# _tmp16 = *(arr)
	  lw $t0, -8($fp)	# fill arr to $t0 from $fp-8
	  lw $t2, 0($t0) 	# load with offset
	  sw $t2, -80($fp)	# spill _tmp16 from $t2 to $fp-80
	# _tmp17 = i < _tmp15
	  lw $t0, -12($fp)	# fill i to $t0 from $fp-12
	  lw $t1, -76($fp)	# fill _tmp15 to $t1 from $fp-76
	  slt $t2, $t0, $t1	
	  sw $t2, -84($fp)	# spill _tmp17 from $t2 to $fp-84
	# _tmp18 = _tmp16 < i
	  lw $t0, -80($fp)	# fill _tmp16 to $t0 from $fp-80
	  lw $t1, -12($fp)	# fill i to $t1 from $fp-12
	  slt $t2, $t0, $t1	
	  sw $t2, -88($fp)	# spill _tmp18 from $t2 to $fp-88
	# _tmp19 = _tmp16 == i
	  lw $t0, -80($fp)	# fill _tmp16 to $t0 from $fp-80
	  lw $t1, -12($fp)	# fill i to $t1 from $fp-12
	  seq $t2, $t0, $t1	
	  sw $t2, -92($fp)	# spill _tmp19 from $t2 to $fp-92
	# _tmp20 = _tmp18 || _tmp19
	  lw $t0, -88($fp)	# fill _tmp18 to $t0 from $fp-88
	  lw $t1, -92($fp)	# fill _tmp19 to $t1 from $fp-92
	  or $t2, $t0, $t1	
	  sw $t2, -96($fp)	# spill _tmp20 from $t2 to $fp-96
	# _tmp21 = _tmp20 || _tmp17
	  lw $t0, -96($fp)	# fill _tmp20 to $t0 from $fp-96
	  lw $t1, -84($fp)	# fill _tmp17 to $t1 from $fp-84
	  or $t2, $t0, $t1	
	  sw $t2, -100($fp)	# spill _tmp21 from $t2 to $fp-100
	# IfZ _tmp21 Goto _L3
	  lw $t0, -100($fp)	# fill _tmp21 to $t0 from $fp-100
	  beqz $t0, _L3	# branch if _tmp21 is zero 
	# _tmp22 = "Decaf runtime error: Array subscript out of bound..."
	  .data			# create string constant marked with label
	  _string2: .asciiz "Decaf runtime error: Array subscript out of bounds\n"
	  .text
	  la $t2, _string2	# load label
	  sw $t2, -104($fp)	# spill _tmp22 from $t2 to $fp-104
	# PushParam _tmp22
	  subu $sp, $sp, 4	# decrement sp to make space for param
	  lw $t0, -104($fp)	# fill _tmp22 to $t0 from $fp-104
	  sw $t0, 4($sp)	# copy param value to stack
	# LCall _PrintString
	  jal _PrintString   	# jump to function
	# PopParams 4
	  add $sp, $sp, 4	# pop params off stack
	# LCall _Halt
	  jal _Halt          	# jump to function
  _L3:
	# _tmp23 = 4
	  li $t2, 4		# load constant value 4 into $t2
	  sw $t2, -108($fp)	# spill _tmp23 from $t2 to $fp-108
	# _tmp24 = i * _tmp23
	  lw $t0, -12($fp)	# fill i to $t0 from $fp-12
	  lw $t1, -108($fp)	# fill _tmp23 to $t1 from $fp-108
	  mul $t2, $t0, $t1	
	  sw $t2, -112($fp)	# spill _tmp24 from $t2 to $fp-112
	# _tmp25 = _tmp24 + _tmp23
	  lw $t0, -112($fp)	# fill _tmp24 to $t0 from $fp-112
	  lw $t1, -108($fp)	# fill _tmp23 to $t1 from $fp-108
	  add $t2, $t0, $t1	
	  sw $t2, -116($fp)	# spill _tmp25 from $t2 to $fp-116
	# _tmp26 = arr + _tmp25
	  lw $t0, -8($fp)	# fill arr to $t0 from $fp-8
	  lw $t1, -116($fp)	# fill _tmp25 to $t1 from $fp-116
	  add $t2, $t0, $t1	
	  sw $t2, -120($fp)	# spill _tmp26 from $t2 to $fp-120
	# *(_tmp26) = i
	  lw $t0, -12($fp)	# fill i to $t0 from $fp-12
	  lw $t2, -120($fp)	# fill _tmp26 to $t2 from $fp-120
	  sw $t0, 0($t2) 	# store with offset
	# _tmp27 = *(_tmp26)
	  lw $t0, -120($fp)	# fill _tmp26 to $t0 from $fp-120
	  lw $t2, 0($t0) 	# load with offset
	  sw $t2, -124($fp)	# spill _tmp27 from $t2 to $fp-124
	# PushParam i
	  subu $sp, $sp, 4	# decrement sp to make space for param
	  lw $t0, -12($fp)	# fill i to $t0 from $fp-12
	  sw $t0, 4($sp)	# copy param value to stack
	# LCall _PrintInt
	  jal _PrintInt      	# jump to function
	# PopParams 4
	  add $sp, $sp, 4	# pop params off stack
	# _tmp28 = "\n"
	  .data			# create string constant marked with label
	  _string3: .asciiz "\n"
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
	# _tmp29 = 1
	  li $t2, 1		# load constant value 1 into $t2
	  sw $t2, -132($fp)	# spill _tmp29 from $t2 to $fp-132
	# _tmp30 = i + _tmp29
	  lw $t0, -12($fp)	# fill i to $t0 from $fp-12
	  lw $t1, -132($fp)	# fill _tmp29 to $t1 from $fp-132
	  add $t2, $t0, $t1	
	  sw $t2, -136($fp)	# spill _tmp30 from $t2 to $fp-136
	# i = _tmp30
	  lw $t2, -136($fp)	# fill _tmp30 to $t2 from $fp-136
	  sw $t2, -12($fp)	# spill i from $t2 to $fp-12
	# Goto _L1
	  b _L1		# unconditional branch
  _L2:
	# _tmp31 = "Done\n"
	  .data			# create string constant marked with label
	  _string4: .asciiz "Done\n"
	  .text
	  la $t2, _string4	# load label
	  sw $t2, -140($fp)	# spill _tmp31 from $t2 to $fp-140
	# PushParam _tmp31
	  subu $sp, $sp, 4	# decrement sp to make space for param
	  lw $t0, -140($fp)	# fill _tmp31 to $t0 from $fp-140
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
