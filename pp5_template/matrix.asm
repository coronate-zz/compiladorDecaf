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
	  
  Matrix.____Init:
	# BeginFunc 0
	  subu $sp, $sp, 8	# decrement sp to make space to save ra, fp
	  sw $fp, 8($sp)	# save fp
	  sw $ra, 4($sp)	# save ra
	  addiu $fp, $sp, 8	# set up new fp
	# EndFunc
	# (below handles reaching end of fn body with no explicit return)
	  move $sp, $fp		# pop callee frame off stack
	  lw $ra, -4($fp)	# restore saved ra
	  lw $fp, 0($fp)	# restore saved fp
	  jr $ra		# return from function
  Matrix.____Set:
	# BeginFunc 0
	  subu $sp, $sp, 8	# decrement sp to make space to save ra, fp
	  sw $fp, 8($sp)	# save fp
	  sw $ra, 4($sp)	# save ra
	  addiu $fp, $sp, 8	# set up new fp
	# EndFunc
	# (below handles reaching end of fn body with no explicit return)
	  move $sp, $fp		# pop callee frame off stack
	  lw $ra, -4($fp)	# restore saved ra
	  lw $fp, 0($fp)	# restore saved fp
	  jr $ra		# return from function
  Matrix.____Get:
	# BeginFunc 0
	  subu $sp, $sp, 8	# decrement sp to make space to save ra, fp
	  sw $fp, 8($sp)	# save fp
	  sw $ra, 4($sp)	# save ra
	  addiu $fp, $sp, 8	# set up new fp
	# EndFunc
	# (below handles reaching end of fn body with no explicit return)
	  move $sp, $fp		# pop callee frame off stack
	  lw $ra, -4($fp)	# restore saved ra
	  lw $fp, 0($fp)	# restore saved fp
	  jr $ra		# return from function
  Matrix.____PrintMatrix:
	# BeginFunc 92
	  subu $sp, $sp, 8	# decrement sp to make space to save ra, fp
	  sw $fp, 8($sp)	# save fp
	  sw $ra, 4($sp)	# save ra
	  addiu $fp, $sp, 8	# set up new fp
	  subu $sp, $sp, 92	# decrement sp to make space for locals/temps
	# _tmp0 = 0
	  li $t2, 0		# load constant value 0 into $t2
	  sw $t2, -16($fp)	# spill _tmp0 from $t2 to $fp-16
	# i = _tmp0
	  lw $t2, -16($fp)	# fill _tmp0 to $t2 from $fp-16
	  sw $t2, -8($fp)	# spill i from $t2 to $fp-8
  _L0:
	# _tmp1 = 10
	  li $t2, 10		# load constant value 10 into $t2
	  sw $t2, -20($fp)	# spill _tmp1 from $t2 to $fp-20
	# _tmp2 = i < _tmp1
	  lw $t0, -8($fp)	# fill i to $t0 from $fp-8
	  lw $t1, -20($fp)	# fill _tmp1 to $t1 from $fp-20
	  slt $t2, $t0, $t1	
	  sw $t2, -24($fp)	# spill _tmp2 from $t2 to $fp-24
	# IfZ _tmp2 Goto _L1
	  lw $t0, -24($fp)	# fill _tmp2 to $t0 from $fp-24
	  beqz $t0, _L1	# branch if _tmp2 is zero 
	# _tmp3 = 0
	  li $t2, 0		# load constant value 0 into $t2
	  sw $t2, -28($fp)	# spill _tmp3 from $t2 to $fp-28
	# j = _tmp3
	  lw $t2, -28($fp)	# fill _tmp3 to $t2 from $fp-28
	  sw $t2, -12($fp)	# spill j from $t2 to $fp-12
  _L2:
	# _tmp4 = 10
	  li $t2, 10		# load constant value 10 into $t2
	  sw $t2, -32($fp)	# spill _tmp4 from $t2 to $fp-32
	# _tmp5 = j < _tmp4
	  lw $t0, -12($fp)	# fill j to $t0 from $fp-12
	  lw $t1, -32($fp)	# fill _tmp4 to $t1 from $fp-32
	  slt $t2, $t0, $t1	
	  sw $t2, -36($fp)	# spill _tmp5 from $t2 to $fp-36
	# IfZ _tmp5 Goto _L3
	  lw $t0, -36($fp)	# fill _tmp5 to $t0 from $fp-36
	  beqz $t0, _L3	# branch if _tmp5 is zero 
	# PushParam j
	  subu $sp, $sp, 4	# decrement sp to make space for param
	  lw $t0, -12($fp)	# fill j to $t0 from $fp-12
	  sw $t0, 4($sp)	# copy param value to stack
	# PushParam i
	  subu $sp, $sp, 4	# decrement sp to make space for param
	  lw $t0, -8($fp)	# fill i to $t0 from $fp-8
	  sw $t0, 4($sp)	# copy param value to stack
	# PushParam this
	  subu $sp, $sp, 4	# decrement sp to make space for param
	  lw $t0, 4($fp)	# fill this to $t0 from $fp+4
	  sw $t0, 4($sp)	# copy param value to stack
	# _tmp6 = *(this)
	  lw $t0, 4($fp)	# fill this to $t0 from $fp+4
	  lw $t2, 0($t0) 	# load with offset
	  sw $t2, -40($fp)	# spill _tmp6 from $t2 to $fp-40
	# _tmp7 = *(_tmp6 + 8)
	  lw $t0, -40($fp)	# fill _tmp6 to $t0 from $fp-40
	  lw $t2, 8($t0) 	# load with offset
	  sw $t2, -44($fp)	# spill _tmp7 from $t2 to $fp-44
	# _tmp8 = ACall _tmp7
	  lw $t0, -44($fp)	# fill _tmp7 to $t0 from $fp-44
	  jalr $t0            	# jump to function
	  move $t2, $v0		# copy function return value from $v0
	  sw $t2, -48($fp)	# spill _tmp8 from $t2 to $fp-48
	# PopParams 12
	  add $sp, $sp, 12	# pop params off stack
	# PushParam _tmp8
	  subu $sp, $sp, 4	# decrement sp to make space for param
	  lw $t0, -48($fp)	# fill _tmp8 to $t0 from $fp-48
	  sw $t0, 4($sp)	# copy param value to stack
	# LCall _PrintInt
	  jal _PrintInt      	# jump to function
	# PopParams 4
	  add $sp, $sp, 4	# pop params off stack
	# _tmp9 = "\t"
	  .data			# create string constant marked with label
	  _string1: .asciiz "\t"
	  .text
	  la $t2, _string1	# load label
	  sw $t2, -52($fp)	# spill _tmp9 from $t2 to $fp-52
	# PushParam _tmp9
	  subu $sp, $sp, 4	# decrement sp to make space for param
	  lw $t0, -52($fp)	# fill _tmp9 to $t0 from $fp-52
	  sw $t0, 4($sp)	# copy param value to stack
	# LCall _PrintString
	  jal _PrintString   	# jump to function
	# PopParams 4
	  add $sp, $sp, 4	# pop params off stack
	# _tmp10 = 1
	  li $t2, 1		# load constant value 1 into $t2
	  sw $t2, -56($fp)	# spill _tmp10 from $t2 to $fp-56
	# _tmp11 = j + _tmp10
	  lw $t0, -12($fp)	# fill j to $t0 from $fp-12
	  lw $t1, -56($fp)	# fill _tmp10 to $t1 from $fp-56
	  add $t2, $t0, $t1	
	  sw $t2, -60($fp)	# spill _tmp11 from $t2 to $fp-60
	# j = _tmp11
	  lw $t2, -60($fp)	# fill _tmp11 to $t2 from $fp-60
	  sw $t2, -12($fp)	# spill j from $t2 to $fp-12
	# Goto _L2
	  b _L2		# unconditional branch
  _L3:
	# _tmp12 = "\n"
	  .data			# create string constant marked with label
	  _string2: .asciiz "\n"
	  .text
	  la $t2, _string2	# load label
	  sw $t2, -64($fp)	# spill _tmp12 from $t2 to $fp-64
	# PushParam _tmp12
	  subu $sp, $sp, 4	# decrement sp to make space for param
	  lw $t0, -64($fp)	# fill _tmp12 to $t0 from $fp-64
	  sw $t0, 4($sp)	# copy param value to stack
	# LCall _PrintString
	  jal _PrintString   	# jump to function
	# PopParams 4
	  add $sp, $sp, 4	# pop params off stack
	# _tmp13 = 1
	  li $t2, 1		# load constant value 1 into $t2
	  sw $t2, -68($fp)	# spill _tmp13 from $t2 to $fp-68
	# _tmp14 = i + _tmp13
	  lw $t0, -8($fp)	# fill i to $t0 from $fp-8
	  lw $t1, -68($fp)	# fill _tmp13 to $t1 from $fp-68
	  add $t2, $t0, $t1	
	  sw $t2, -72($fp)	# spill _tmp14 from $t2 to $fp-72
	# i = _tmp14
	  lw $t2, -72($fp)	# fill _tmp14 to $t2 from $fp-72
	  sw $t2, -8($fp)	# spill i from $t2 to $fp-8
	# Goto _L0
	  b _L0		# unconditional branch
  _L1:
	# EndFunc
	# (below handles reaching end of fn body with no explicit return)
	  move $sp, $fp		# pop callee frame off stack
	  lw $ra, -4($fp)	# restore saved ra
	  lw $fp, 0($fp)	# restore saved fp
	  jr $ra		# return from function
  Matrix.____SeedMatrix:
	# BeginFunc 212
	  subu $sp, $sp, 8	# decrement sp to make space to save ra, fp
	  sw $fp, 8($sp)	# save fp
	  sw $ra, 4($sp)	# save ra
	  addiu $fp, $sp, 8	# set up new fp
	  subu $sp, $sp, 212	# decrement sp to make space for locals/temps
	# _tmp15 = 0
	  li $t2, 0		# load constant value 0 into $t2
	  sw $t2, -16($fp)	# spill _tmp15 from $t2 to $fp-16
	# i = _tmp15
	  lw $t2, -16($fp)	# fill _tmp15 to $t2 from $fp-16
	  sw $t2, -8($fp)	# spill i from $t2 to $fp-8
  _L4:
	# _tmp16 = 5
	  li $t2, 5		# load constant value 5 into $t2
	  sw $t2, -20($fp)	# spill _tmp16 from $t2 to $fp-20
	# _tmp17 = i < _tmp16
	  lw $t0, -8($fp)	# fill i to $t0 from $fp-8
	  lw $t1, -20($fp)	# fill _tmp16 to $t1 from $fp-20
	  slt $t2, $t0, $t1	
	  sw $t2, -24($fp)	# spill _tmp17 from $t2 to $fp-24
	# IfZ _tmp17 Goto _L5
	  lw $t0, -24($fp)	# fill _tmp17 to $t0 from $fp-24
	  beqz $t0, _L5	# branch if _tmp17 is zero 
	# _tmp18 = 0
	  li $t2, 0		# load constant value 0 into $t2
	  sw $t2, -28($fp)	# spill _tmp18 from $t2 to $fp-28
	# j = _tmp18
	  lw $t2, -28($fp)	# fill _tmp18 to $t2 from $fp-28
	  sw $t2, -12($fp)	# spill j from $t2 to $fp-12
  _L6:
	# _tmp19 = 5
	  li $t2, 5		# load constant value 5 into $t2
	  sw $t2, -32($fp)	# spill _tmp19 from $t2 to $fp-32
	# _tmp20 = j < _tmp19
	  lw $t0, -12($fp)	# fill j to $t0 from $fp-12
	  lw $t1, -32($fp)	# fill _tmp19 to $t1 from $fp-32
	  slt $t2, $t0, $t1	
	  sw $t2, -36($fp)	# spill _tmp20 from $t2 to $fp-36
	# IfZ _tmp20 Goto _L7
	  lw $t0, -36($fp)	# fill _tmp20 to $t0 from $fp-36
	  beqz $t0, _L7	# branch if _tmp20 is zero 
	# _tmp21 = i + j
	  lw $t0, -8($fp)	# fill i to $t0 from $fp-8
	  lw $t1, -12($fp)	# fill j to $t1 from $fp-12
	  add $t2, $t0, $t1	
	  sw $t2, -40($fp)	# spill _tmp21 from $t2 to $fp-40
	# PushParam _tmp21
	  subu $sp, $sp, 4	# decrement sp to make space for param
	  lw $t0, -40($fp)	# fill _tmp21 to $t0 from $fp-40
	  sw $t0, 4($sp)	# copy param value to stack
	# PushParam j
	  subu $sp, $sp, 4	# decrement sp to make space for param
	  lw $t0, -12($fp)	# fill j to $t0 from $fp-12
	  sw $t0, 4($sp)	# copy param value to stack
	# PushParam i
	  subu $sp, $sp, 4	# decrement sp to make space for param
	  lw $t0, -8($fp)	# fill i to $t0 from $fp-8
	  sw $t0, 4($sp)	# copy param value to stack
	# PushParam this
	  subu $sp, $sp, 4	# decrement sp to make space for param
	  lw $t0, 4($fp)	# fill this to $t0 from $fp+4
	  sw $t0, 4($sp)	# copy param value to stack
	# _tmp22 = *(this)
	  lw $t0, 4($fp)	# fill this to $t0 from $fp+4
	  lw $t2, 0($t0) 	# load with offset
	  sw $t2, -44($fp)	# spill _tmp22 from $t2 to $fp-44
	# _tmp23 = *(_tmp22 + 4)
	  lw $t0, -44($fp)	# fill _tmp22 to $t0 from $fp-44
	  lw $t2, 4($t0) 	# load with offset
	  sw $t2, -48($fp)	# spill _tmp23 from $t2 to $fp-48
	# ACall _tmp23
	  lw $t0, -48($fp)	# fill _tmp23 to $t0 from $fp-48
	  jalr $t0            	# jump to function
	# PopParams 16
	  add $sp, $sp, 16	# pop params off stack
	# _tmp24 = 1
	  li $t2, 1		# load constant value 1 into $t2
	  sw $t2, -52($fp)	# spill _tmp24 from $t2 to $fp-52
	# _tmp25 = j + _tmp24
	  lw $t0, -12($fp)	# fill j to $t0 from $fp-12
	  lw $t1, -52($fp)	# fill _tmp24 to $t1 from $fp-52
	  add $t2, $t0, $t1	
	  sw $t2, -56($fp)	# spill _tmp25 from $t2 to $fp-56
	# j = _tmp25
	  lw $t2, -56($fp)	# fill _tmp25 to $t2 from $fp-56
	  sw $t2, -12($fp)	# spill j from $t2 to $fp-12
	# Goto _L6
	  b _L6		# unconditional branch
  _L7:
	# _tmp26 = 1
	  li $t2, 1		# load constant value 1 into $t2
	  sw $t2, -60($fp)	# spill _tmp26 from $t2 to $fp-60
	# _tmp27 = i + _tmp26
	  lw $t0, -8($fp)	# fill i to $t0 from $fp-8
	  lw $t1, -60($fp)	# fill _tmp26 to $t1 from $fp-60
	  add $t2, $t0, $t1	
	  sw $t2, -64($fp)	# spill _tmp27 from $t2 to $fp-64
	# i = _tmp27
	  lw $t2, -64($fp)	# fill _tmp27 to $t2 from $fp-64
	  sw $t2, -8($fp)	# spill i from $t2 to $fp-8
	# Goto _L4
	  b _L4		# unconditional branch
  _L5:
	# _tmp28 = 2
	  li $t2, 2		# load constant value 2 into $t2
	  sw $t2, -68($fp)	# spill _tmp28 from $t2 to $fp-68
	# _tmp29 = 3
	  li $t2, 3		# load constant value 3 into $t2
	  sw $t2, -72($fp)	# spill _tmp29 from $t2 to $fp-72
	# _tmp30 = 4
	  li $t2, 4		# load constant value 4 into $t2
	  sw $t2, -76($fp)	# spill _tmp30 from $t2 to $fp-76
	# PushParam _tmp30
	  subu $sp, $sp, 4	# decrement sp to make space for param
	  lw $t0, -76($fp)	# fill _tmp30 to $t0 from $fp-76
	  sw $t0, 4($sp)	# copy param value to stack
	# PushParam _tmp29
	  subu $sp, $sp, 4	# decrement sp to make space for param
	  lw $t0, -72($fp)	# fill _tmp29 to $t0 from $fp-72
	  sw $t0, 4($sp)	# copy param value to stack
	# PushParam _tmp28
	  subu $sp, $sp, 4	# decrement sp to make space for param
	  lw $t0, -68($fp)	# fill _tmp28 to $t0 from $fp-68
	  sw $t0, 4($sp)	# copy param value to stack
	# PushParam this
	  subu $sp, $sp, 4	# decrement sp to make space for param
	  lw $t0, 4($fp)	# fill this to $t0 from $fp+4
	  sw $t0, 4($sp)	# copy param value to stack
	# _tmp31 = *(this)
	  lw $t0, 4($fp)	# fill this to $t0 from $fp+4
	  lw $t2, 0($t0) 	# load with offset
	  sw $t2, -80($fp)	# spill _tmp31 from $t2 to $fp-80
	# _tmp32 = *(_tmp31 + 4)
	  lw $t0, -80($fp)	# fill _tmp31 to $t0 from $fp-80
	  lw $t2, 4($t0) 	# load with offset
	  sw $t2, -84($fp)	# spill _tmp32 from $t2 to $fp-84
	# ACall _tmp32
	  lw $t0, -84($fp)	# fill _tmp32 to $t0 from $fp-84
	  jalr $t0            	# jump to function
	# PopParams 16
	  add $sp, $sp, 16	# pop params off stack
	# _tmp33 = 4
	  li $t2, 4		# load constant value 4 into $t2
	  sw $t2, -88($fp)	# spill _tmp33 from $t2 to $fp-88
	# _tmp34 = 6
	  li $t2, 6		# load constant value 6 into $t2
	  sw $t2, -92($fp)	# spill _tmp34 from $t2 to $fp-92
	# _tmp35 = 2
	  li $t2, 2		# load constant value 2 into $t2
	  sw $t2, -96($fp)	# spill _tmp35 from $t2 to $fp-96
	# PushParam _tmp35
	  subu $sp, $sp, 4	# decrement sp to make space for param
	  lw $t0, -96($fp)	# fill _tmp35 to $t0 from $fp-96
	  sw $t0, 4($sp)	# copy param value to stack
	# PushParam _tmp34
	  subu $sp, $sp, 4	# decrement sp to make space for param
	  lw $t0, -92($fp)	# fill _tmp34 to $t0 from $fp-92
	  sw $t0, 4($sp)	# copy param value to stack
	# PushParam _tmp33
	  subu $sp, $sp, 4	# decrement sp to make space for param
	  lw $t0, -88($fp)	# fill _tmp33 to $t0 from $fp-88
	  sw $t0, 4($sp)	# copy param value to stack
	# PushParam this
	  subu $sp, $sp, 4	# decrement sp to make space for param
	  lw $t0, 4($fp)	# fill this to $t0 from $fp+4
	  sw $t0, 4($sp)	# copy param value to stack
	# _tmp36 = *(this)
	  lw $t0, 4($fp)	# fill this to $t0 from $fp+4
	  lw $t2, 0($t0) 	# load with offset
	  sw $t2, -100($fp)	# spill _tmp36 from $t2 to $fp-100
	# _tmp37 = *(_tmp36 + 4)
	  lw $t0, -100($fp)	# fill _tmp36 to $t0 from $fp-100
	  lw $t2, 4($t0) 	# load with offset
	  sw $t2, -104($fp)	# spill _tmp37 from $t2 to $fp-104
	# ACall _tmp37
	  lw $t0, -104($fp)	# fill _tmp37 to $t0 from $fp-104
	  jalr $t0            	# jump to function
	# PopParams 16
	  add $sp, $sp, 16	# pop params off stack
	# _tmp38 = 2
	  li $t2, 2		# load constant value 2 into $t2
	  sw $t2, -108($fp)	# spill _tmp38 from $t2 to $fp-108
	# _tmp39 = 3
	  li $t2, 3		# load constant value 3 into $t2
	  sw $t2, -112($fp)	# spill _tmp39 from $t2 to $fp-112
	# _tmp40 = 5
	  li $t2, 5		# load constant value 5 into $t2
	  sw $t2, -116($fp)	# spill _tmp40 from $t2 to $fp-116
	# PushParam _tmp40
	  subu $sp, $sp, 4	# decrement sp to make space for param
	  lw $t0, -116($fp)	# fill _tmp40 to $t0 from $fp-116
	  sw $t0, 4($sp)	# copy param value to stack
	# PushParam _tmp39
	  subu $sp, $sp, 4	# decrement sp to make space for param
	  lw $t0, -112($fp)	# fill _tmp39 to $t0 from $fp-112
	  sw $t0, 4($sp)	# copy param value to stack
	# PushParam _tmp38
	  subu $sp, $sp, 4	# decrement sp to make space for param
	  lw $t0, -108($fp)	# fill _tmp38 to $t0 from $fp-108
	  sw $t0, 4($sp)	# copy param value to stack
	# PushParam this
	  subu $sp, $sp, 4	# decrement sp to make space for param
	  lw $t0, 4($fp)	# fill this to $t0 from $fp+4
	  sw $t0, 4($sp)	# copy param value to stack
	# _tmp41 = *(this)
	  lw $t0, 4($fp)	# fill this to $t0 from $fp+4
	  lw $t2, 0($t0) 	# load with offset
	  sw $t2, -120($fp)	# spill _tmp41 from $t2 to $fp-120
	# _tmp42 = *(_tmp41 + 4)
	  lw $t0, -120($fp)	# fill _tmp41 to $t0 from $fp-120
	  lw $t2, 4($t0) 	# load with offset
	  sw $t2, -124($fp)	# spill _tmp42 from $t2 to $fp-124
	# ACall _tmp42
	  lw $t0, -124($fp)	# fill _tmp42 to $t0 from $fp-124
	  jalr $t0            	# jump to function
	# PopParams 16
	  add $sp, $sp, 16	# pop params off stack
	# _tmp43 = 0
	  li $t2, 0		# load constant value 0 into $t2
	  sw $t2, -128($fp)	# spill _tmp43 from $t2 to $fp-128
	# _tmp44 = 0
	  li $t2, 0		# load constant value 0 into $t2
	  sw $t2, -132($fp)	# spill _tmp44 from $t2 to $fp-132
	# _tmp45 = 1
	  li $t2, 1		# load constant value 1 into $t2
	  sw $t2, -136($fp)	# spill _tmp45 from $t2 to $fp-136
	# PushParam _tmp45
	  subu $sp, $sp, 4	# decrement sp to make space for param
	  lw $t0, -136($fp)	# fill _tmp45 to $t0 from $fp-136
	  sw $t0, 4($sp)	# copy param value to stack
	# PushParam _tmp44
	  subu $sp, $sp, 4	# decrement sp to make space for param
	  lw $t0, -132($fp)	# fill _tmp44 to $t0 from $fp-132
	  sw $t0, 4($sp)	# copy param value to stack
	# PushParam _tmp43
	  subu $sp, $sp, 4	# decrement sp to make space for param
	  lw $t0, -128($fp)	# fill _tmp43 to $t0 from $fp-128
	  sw $t0, 4($sp)	# copy param value to stack
	# PushParam this
	  subu $sp, $sp, 4	# decrement sp to make space for param
	  lw $t0, 4($fp)	# fill this to $t0 from $fp+4
	  sw $t0, 4($sp)	# copy param value to stack
	# _tmp46 = *(this)
	  lw $t0, 4($fp)	# fill this to $t0 from $fp+4
	  lw $t2, 0($t0) 	# load with offset
	  sw $t2, -140($fp)	# spill _tmp46 from $t2 to $fp-140
	# _tmp47 = *(_tmp46 + 4)
	  lw $t0, -140($fp)	# fill _tmp46 to $t0 from $fp-140
	  lw $t2, 4($t0) 	# load with offset
	  sw $t2, -144($fp)	# spill _tmp47 from $t2 to $fp-144
	# ACall _tmp47
	  lw $t0, -144($fp)	# fill _tmp47 to $t0 from $fp-144
	  jalr $t0            	# jump to function
	# PopParams 16
	  add $sp, $sp, 16	# pop params off stack
	# _tmp48 = 1
	  li $t2, 1		# load constant value 1 into $t2
	  sw $t2, -148($fp)	# spill _tmp48 from $t2 to $fp-148
	# _tmp49 = 6
	  li $t2, 6		# load constant value 6 into $t2
	  sw $t2, -152($fp)	# spill _tmp49 from $t2 to $fp-152
	# _tmp50 = 3
	  li $t2, 3		# load constant value 3 into $t2
	  sw $t2, -156($fp)	# spill _tmp50 from $t2 to $fp-156
	# PushParam _tmp50
	  subu $sp, $sp, 4	# decrement sp to make space for param
	  lw $t0, -156($fp)	# fill _tmp50 to $t0 from $fp-156
	  sw $t0, 4($sp)	# copy param value to stack
	# PushParam _tmp49
	  subu $sp, $sp, 4	# decrement sp to make space for param
	  lw $t0, -152($fp)	# fill _tmp49 to $t0 from $fp-152
	  sw $t0, 4($sp)	# copy param value to stack
	# PushParam _tmp48
	  subu $sp, $sp, 4	# decrement sp to make space for param
	  lw $t0, -148($fp)	# fill _tmp48 to $t0 from $fp-148
	  sw $t0, 4($sp)	# copy param value to stack
	# PushParam this
	  subu $sp, $sp, 4	# decrement sp to make space for param
	  lw $t0, 4($fp)	# fill this to $t0 from $fp+4
	  sw $t0, 4($sp)	# copy param value to stack
	# _tmp51 = *(this)
	  lw $t0, 4($fp)	# fill this to $t0 from $fp+4
	  lw $t2, 0($t0) 	# load with offset
	  sw $t2, -160($fp)	# spill _tmp51 from $t2 to $fp-160
	# _tmp52 = *(_tmp51 + 4)
	  lw $t0, -160($fp)	# fill _tmp51 to $t0 from $fp-160
	  lw $t2, 4($t0) 	# load with offset
	  sw $t2, -164($fp)	# spill _tmp52 from $t2 to $fp-164
	# ACall _tmp52
	  lw $t0, -164($fp)	# fill _tmp52 to $t0 from $fp-164
	  jalr $t0            	# jump to function
	# PopParams 16
	  add $sp, $sp, 16	# pop params off stack
	# _tmp53 = 7
	  li $t2, 7		# load constant value 7 into $t2
	  sw $t2, -168($fp)	# spill _tmp53 from $t2 to $fp-168
	# _tmp54 = 7
	  li $t2, 7		# load constant value 7 into $t2
	  sw $t2, -172($fp)	# spill _tmp54 from $t2 to $fp-172
	# _tmp55 = 7
	  li $t2, 7		# load constant value 7 into $t2
	  sw $t2, -176($fp)	# spill _tmp55 from $t2 to $fp-176
	# PushParam _tmp55
	  subu $sp, $sp, 4	# decrement sp to make space for param
	  lw $t0, -176($fp)	# fill _tmp55 to $t0 from $fp-176
	  sw $t0, 4($sp)	# copy param value to stack
	# PushParam _tmp54
	  subu $sp, $sp, 4	# decrement sp to make space for param
	  lw $t0, -172($fp)	# fill _tmp54 to $t0 from $fp-172
	  sw $t0, 4($sp)	# copy param value to stack
	# PushParam _tmp53
	  subu $sp, $sp, 4	# decrement sp to make space for param
	  lw $t0, -168($fp)	# fill _tmp53 to $t0 from $fp-168
	  sw $t0, 4($sp)	# copy param value to stack
	# PushParam this
	  subu $sp, $sp, 4	# decrement sp to make space for param
	  lw $t0, 4($fp)	# fill this to $t0 from $fp+4
	  sw $t0, 4($sp)	# copy param value to stack
	# _tmp56 = *(this)
	  lw $t0, 4($fp)	# fill this to $t0 from $fp+4
	  lw $t2, 0($t0) 	# load with offset
	  sw $t2, -180($fp)	# spill _tmp56 from $t2 to $fp-180
	# _tmp57 = *(_tmp56 + 4)
	  lw $t0, -180($fp)	# fill _tmp56 to $t0 from $fp-180
	  lw $t2, 4($t0) 	# load with offset
	  sw $t2, -184($fp)	# spill _tmp57 from $t2 to $fp-184
	# ACall _tmp57
	  lw $t0, -184($fp)	# fill _tmp57 to $t0 from $fp-184
	  jalr $t0            	# jump to function
	# PopParams 16
	  add $sp, $sp, 16	# pop params off stack
	# EndFunc
	# (below handles reaching end of fn body with no explicit return)
	  move $sp, $fp		# pop callee frame off stack
	  lw $ra, -4($fp)	# restore saved ra
	  lw $fp, 0($fp)	# restore saved fp
	  jr $ra		# return from function
	# VTable for class Matrix
	  .data
	  .align 2
	  Matrix:		# label for class Matrix vtable
	  .word Matrix.____Init
	  .word Matrix.____Set
	  .word Matrix.____Get
	  .word Matrix.____PrintMatrix
	  .word Matrix.____SeedMatrix
	  .text
  DenseMatrix.____Init:
	# BeginFunc 352
	  subu $sp, $sp, 8	# decrement sp to make space to save ra, fp
	  sw $fp, 8($sp)	# save fp
	  sw $ra, 4($sp)	# save ra
	  addiu $fp, $sp, 8	# set up new fp
	  subu $sp, $sp, 352	# decrement sp to make space for locals/temps
	# _tmp58 = 10
	  li $t2, 10		# load constant value 10 into $t2
	  sw $t2, -16($fp)	# spill _tmp58 from $t2 to $fp-16
	# _tmp59 = 4
	  li $t2, 4		# load constant value 4 into $t2
	  sw $t2, -20($fp)	# spill _tmp59 from $t2 to $fp-20
	# _tmp60 = 0
	  li $t2, 0		# load constant value 0 into $t2
	  sw $t2, -24($fp)	# spill _tmp60 from $t2 to $fp-24
	# _tmp61 = _tmp58 < _tmp60
	  lw $t0, -16($fp)	# fill _tmp58 to $t0 from $fp-16
	  lw $t1, -24($fp)	# fill _tmp60 to $t1 from $fp-24
	  slt $t2, $t0, $t1	
	  sw $t2, -28($fp)	# spill _tmp61 from $t2 to $fp-28
	# _tmp62 = _tmp58 == _tmp60
	  lw $t0, -16($fp)	# fill _tmp58 to $t0 from $fp-16
	  lw $t1, -24($fp)	# fill _tmp60 to $t1 from $fp-24
	  seq $t2, $t0, $t1	
	  sw $t2, -32($fp)	# spill _tmp62 from $t2 to $fp-32
	# _tmp63 = _tmp61 || _tmp62
	  lw $t0, -28($fp)	# fill _tmp61 to $t0 from $fp-28
	  lw $t1, -32($fp)	# fill _tmp62 to $t1 from $fp-32
	  or $t2, $t0, $t1	
	  sw $t2, -36($fp)	# spill _tmp63 from $t2 to $fp-36
	# IfZ _tmp63 Goto _L8
	  lw $t0, -36($fp)	# fill _tmp63 to $t0 from $fp-36
	  beqz $t0, _L8	# branch if _tmp63 is zero 
	# _tmp64 = "Decaf runtime error: Array size is <= 0\n"
	  .data			# create string constant marked with label
	  _string3: .asciiz "Decaf runtime error: Array size is <= 0\n"
	  .text
	  la $t2, _string3	# load label
	  sw $t2, -40($fp)	# spill _tmp64 from $t2 to $fp-40
	# PushParam _tmp64
	  subu $sp, $sp, 4	# decrement sp to make space for param
	  lw $t0, -40($fp)	# fill _tmp64 to $t0 from $fp-40
	  sw $t0, 4($sp)	# copy param value to stack
	# LCall _PrintString
	  jal _PrintString   	# jump to function
	# PopParams 4
	  add $sp, $sp, 4	# pop params off stack
	# LCall _Halt
	  jal _Halt          	# jump to function
  _L8:
	# _tmp65 = _tmp58 * _tmp59
	  lw $t0, -16($fp)	# fill _tmp58 to $t0 from $fp-16
	  lw $t1, -20($fp)	# fill _tmp59 to $t1 from $fp-20
	  mul $t2, $t0, $t1	
	  sw $t2, -44($fp)	# spill _tmp65 from $t2 to $fp-44
	# _tmp66 = _tmp59 + _tmp65
	  lw $t0, -20($fp)	# fill _tmp59 to $t0 from $fp-20
	  lw $t1, -44($fp)	# fill _tmp65 to $t1 from $fp-44
	  add $t2, $t0, $t1	
	  sw $t2, -48($fp)	# spill _tmp66 from $t2 to $fp-48
	# PushParam _tmp66
	  subu $sp, $sp, 4	# decrement sp to make space for param
	  lw $t0, -48($fp)	# fill _tmp66 to $t0 from $fp-48
	  sw $t0, 4($sp)	# copy param value to stack
	# _tmp67 = LCall _Alloc
	  jal _Alloc         	# jump to function
	  move $t2, $v0		# copy function return value from $v0
	  sw $t2, -52($fp)	# spill _tmp67 from $t2 to $fp-52
	# PopParams 4
	  add $sp, $sp, 4	# pop params off stack
	# *(_tmp67) = _tmp58
	  lw $t0, -16($fp)	# fill _tmp58 to $t0 from $fp-16
	  lw $t2, -52($fp)	# fill _tmp67 to $t2 from $fp-52
	  sw $t0, 0($t2) 	# store with offset
	# *(this + 4) = _tmp67
	  lw $t0, -52($fp)	# fill _tmp67 to $t0 from $fp-52
	  lw $t2, 4($fp)	# fill this to $t2 from $fp+4
	  sw $t0, 4($t2) 	# store with offset
	# _tmp68 = 0
	  li $t2, 0		# load constant value 0 into $t2
	  sw $t2, -56($fp)	# spill _tmp68 from $t2 to $fp-56
	# i = _tmp68
	  lw $t2, -56($fp)	# fill _tmp68 to $t2 from $fp-56
	  sw $t2, -8($fp)	# spill i from $t2 to $fp-8
  _L9:
	# _tmp69 = 10
	  li $t2, 10		# load constant value 10 into $t2
	  sw $t2, -60($fp)	# spill _tmp69 from $t2 to $fp-60
	# _tmp70 = i < _tmp69
	  lw $t0, -8($fp)	# fill i to $t0 from $fp-8
	  lw $t1, -60($fp)	# fill _tmp69 to $t1 from $fp-60
	  slt $t2, $t0, $t1	
	  sw $t2, -64($fp)	# spill _tmp70 from $t2 to $fp-64
	# IfZ _tmp70 Goto _L10
	  lw $t0, -64($fp)	# fill _tmp70 to $t0 from $fp-64
	  beqz $t0, _L10	# branch if _tmp70 is zero 
	# _tmp71 = 10
	  li $t2, 10		# load constant value 10 into $t2
	  sw $t2, -68($fp)	# spill _tmp71 from $t2 to $fp-68
	# _tmp72 = 4
	  li $t2, 4		# load constant value 4 into $t2
	  sw $t2, -72($fp)	# spill _tmp72 from $t2 to $fp-72
	# _tmp73 = 0
	  li $t2, 0		# load constant value 0 into $t2
	  sw $t2, -76($fp)	# spill _tmp73 from $t2 to $fp-76
	# _tmp74 = _tmp71 < _tmp73
	  lw $t0, -68($fp)	# fill _tmp71 to $t0 from $fp-68
	  lw $t1, -76($fp)	# fill _tmp73 to $t1 from $fp-76
	  slt $t2, $t0, $t1	
	  sw $t2, -80($fp)	# spill _tmp74 from $t2 to $fp-80
	# _tmp75 = _tmp71 == _tmp73
	  lw $t0, -68($fp)	# fill _tmp71 to $t0 from $fp-68
	  lw $t1, -76($fp)	# fill _tmp73 to $t1 from $fp-76
	  seq $t2, $t0, $t1	
	  sw $t2, -84($fp)	# spill _tmp75 from $t2 to $fp-84
	# _tmp76 = _tmp74 || _tmp75
	  lw $t0, -80($fp)	# fill _tmp74 to $t0 from $fp-80
	  lw $t1, -84($fp)	# fill _tmp75 to $t1 from $fp-84
	  or $t2, $t0, $t1	
	  sw $t2, -88($fp)	# spill _tmp76 from $t2 to $fp-88
	# IfZ _tmp76 Goto _L11
	  lw $t0, -88($fp)	# fill _tmp76 to $t0 from $fp-88
	  beqz $t0, _L11	# branch if _tmp76 is zero 
	# _tmp77 = "Decaf runtime error: Array size is <= 0\n"
	  .data			# create string constant marked with label
	  _string4: .asciiz "Decaf runtime error: Array size is <= 0\n"
	  .text
	  la $t2, _string4	# load label
	  sw $t2, -92($fp)	# spill _tmp77 from $t2 to $fp-92
	# PushParam _tmp77
	  subu $sp, $sp, 4	# decrement sp to make space for param
	  lw $t0, -92($fp)	# fill _tmp77 to $t0 from $fp-92
	  sw $t0, 4($sp)	# copy param value to stack
	# LCall _PrintString
	  jal _PrintString   	# jump to function
	# PopParams 4
	  add $sp, $sp, 4	# pop params off stack
	# LCall _Halt
	  jal _Halt          	# jump to function
  _L11:
	# _tmp78 = _tmp71 * _tmp72
	  lw $t0, -68($fp)	# fill _tmp71 to $t0 from $fp-68
	  lw $t1, -72($fp)	# fill _tmp72 to $t1 from $fp-72
	  mul $t2, $t0, $t1	
	  sw $t2, -96($fp)	# spill _tmp78 from $t2 to $fp-96
	# _tmp79 = _tmp72 + _tmp78
	  lw $t0, -72($fp)	# fill _tmp72 to $t0 from $fp-72
	  lw $t1, -96($fp)	# fill _tmp78 to $t1 from $fp-96
	  add $t2, $t0, $t1	
	  sw $t2, -100($fp)	# spill _tmp79 from $t2 to $fp-100
	# PushParam _tmp79
	  subu $sp, $sp, 4	# decrement sp to make space for param
	  lw $t0, -100($fp)	# fill _tmp79 to $t0 from $fp-100
	  sw $t0, 4($sp)	# copy param value to stack
	# _tmp80 = LCall _Alloc
	  jal _Alloc         	# jump to function
	  move $t2, $v0		# copy function return value from $v0
	  sw $t2, -104($fp)	# spill _tmp80 from $t2 to $fp-104
	# PopParams 4
	  add $sp, $sp, 4	# pop params off stack
	# *(_tmp80) = _tmp71
	  lw $t0, -68($fp)	# fill _tmp71 to $t0 from $fp-68
	  lw $t2, -104($fp)	# fill _tmp80 to $t2 from $fp-104
	  sw $t0, 0($t2) 	# store with offset
	# _tmp81 = *(this + 4)
	  lw $t0, 4($fp)	# fill this to $t0 from $fp+4
	  lw $t2, 4($t0) 	# load with offset
	  sw $t2, -108($fp)	# spill _tmp81 from $t2 to $fp-108
	# _tmp82 = 0
	  li $t2, 0		# load constant value 0 into $t2
	  sw $t2, -112($fp)	# spill _tmp82 from $t2 to $fp-112
	# _tmp83 = *(_tmp81)
	  lw $t0, -108($fp)	# fill _tmp81 to $t0 from $fp-108
	  lw $t2, 0($t0) 	# load with offset
	  sw $t2, -116($fp)	# spill _tmp83 from $t2 to $fp-116
	# _tmp84 = i < _tmp82
	  lw $t0, -8($fp)	# fill i to $t0 from $fp-8
	  lw $t1, -112($fp)	# fill _tmp82 to $t1 from $fp-112
	  slt $t2, $t0, $t1	
	  sw $t2, -120($fp)	# spill _tmp84 from $t2 to $fp-120
	# _tmp85 = _tmp83 < i
	  lw $t0, -116($fp)	# fill _tmp83 to $t0 from $fp-116
	  lw $t1, -8($fp)	# fill i to $t1 from $fp-8
	  slt $t2, $t0, $t1	
	  sw $t2, -124($fp)	# spill _tmp85 from $t2 to $fp-124
	# _tmp86 = _tmp83 == i
	  lw $t0, -116($fp)	# fill _tmp83 to $t0 from $fp-116
	  lw $t1, -8($fp)	# fill i to $t1 from $fp-8
	  seq $t2, $t0, $t1	
	  sw $t2, -128($fp)	# spill _tmp86 from $t2 to $fp-128
	# _tmp87 = _tmp85 || _tmp86
	  lw $t0, -124($fp)	# fill _tmp85 to $t0 from $fp-124
	  lw $t1, -128($fp)	# fill _tmp86 to $t1 from $fp-128
	  or $t2, $t0, $t1	
	  sw $t2, -132($fp)	# spill _tmp87 from $t2 to $fp-132
	# _tmp88 = _tmp87 || _tmp84
	  lw $t0, -132($fp)	# fill _tmp87 to $t0 from $fp-132
	  lw $t1, -120($fp)	# fill _tmp84 to $t1 from $fp-120
	  or $t2, $t0, $t1	
	  sw $t2, -136($fp)	# spill _tmp88 from $t2 to $fp-136
	# IfZ _tmp88 Goto _L12
	  lw $t0, -136($fp)	# fill _tmp88 to $t0 from $fp-136
	  beqz $t0, _L12	# branch if _tmp88 is zero 
	# _tmp89 = "Decaf runtime error: Array subscript out of bound..."
	  .data			# create string constant marked with label
	  _string5: .asciiz "Decaf runtime error: Array subscript out of bounds\n"
	  .text
	  la $t2, _string5	# load label
	  sw $t2, -140($fp)	# spill _tmp89 from $t2 to $fp-140
	# PushParam _tmp89
	  subu $sp, $sp, 4	# decrement sp to make space for param
	  lw $t0, -140($fp)	# fill _tmp89 to $t0 from $fp-140
	  sw $t0, 4($sp)	# copy param value to stack
	# LCall _PrintString
	  jal _PrintString   	# jump to function
	# PopParams 4
	  add $sp, $sp, 4	# pop params off stack
	# LCall _Halt
	  jal _Halt          	# jump to function
  _L12:
	# _tmp90 = 4
	  li $t2, 4		# load constant value 4 into $t2
	  sw $t2, -144($fp)	# spill _tmp90 from $t2 to $fp-144
	# _tmp91 = i * _tmp90
	  lw $t0, -8($fp)	# fill i to $t0 from $fp-8
	  lw $t1, -144($fp)	# fill _tmp90 to $t1 from $fp-144
	  mul $t2, $t0, $t1	
	  sw $t2, -148($fp)	# spill _tmp91 from $t2 to $fp-148
	# _tmp92 = _tmp91 + _tmp90
	  lw $t0, -148($fp)	# fill _tmp91 to $t0 from $fp-148
	  lw $t1, -144($fp)	# fill _tmp90 to $t1 from $fp-144
	  add $t2, $t0, $t1	
	  sw $t2, -152($fp)	# spill _tmp92 from $t2 to $fp-152
	# _tmp93 = _tmp81 + _tmp92
	  lw $t0, -108($fp)	# fill _tmp81 to $t0 from $fp-108
	  lw $t1, -152($fp)	# fill _tmp92 to $t1 from $fp-152
	  add $t2, $t0, $t1	
	  sw $t2, -156($fp)	# spill _tmp93 from $t2 to $fp-156
	# *(_tmp93) = _tmp80
	  lw $t0, -104($fp)	# fill _tmp80 to $t0 from $fp-104
	  lw $t2, -156($fp)	# fill _tmp93 to $t2 from $fp-156
	  sw $t0, 0($t2) 	# store with offset
	# _tmp94 = *(_tmp93)
	  lw $t0, -156($fp)	# fill _tmp93 to $t0 from $fp-156
	  lw $t2, 0($t0) 	# load with offset
	  sw $t2, -160($fp)	# spill _tmp94 from $t2 to $fp-160
	# _tmp95 = 1
	  li $t2, 1		# load constant value 1 into $t2
	  sw $t2, -164($fp)	# spill _tmp95 from $t2 to $fp-164
	# _tmp96 = i + _tmp95
	  lw $t0, -8($fp)	# fill i to $t0 from $fp-8
	  lw $t1, -164($fp)	# fill _tmp95 to $t1 from $fp-164
	  add $t2, $t0, $t1	
	  sw $t2, -168($fp)	# spill _tmp96 from $t2 to $fp-168
	# i = _tmp96
	  lw $t2, -168($fp)	# fill _tmp96 to $t2 from $fp-168
	  sw $t2, -8($fp)	# spill i from $t2 to $fp-8
	# Goto _L9
	  b _L9		# unconditional branch
  _L10:
	# _tmp97 = 0
	  li $t2, 0		# load constant value 0 into $t2
	  sw $t2, -172($fp)	# spill _tmp97 from $t2 to $fp-172
	# i = _tmp97
	  lw $t2, -172($fp)	# fill _tmp97 to $t2 from $fp-172
	  sw $t2, -8($fp)	# spill i from $t2 to $fp-8
  _L13:
	# _tmp98 = 10
	  li $t2, 10		# load constant value 10 into $t2
	  sw $t2, -176($fp)	# spill _tmp98 from $t2 to $fp-176
	# _tmp99 = i < _tmp98
	  lw $t0, -8($fp)	# fill i to $t0 from $fp-8
	  lw $t1, -176($fp)	# fill _tmp98 to $t1 from $fp-176
	  slt $t2, $t0, $t1	
	  sw $t2, -180($fp)	# spill _tmp99 from $t2 to $fp-180
	# IfZ _tmp99 Goto _L14
	  lw $t0, -180($fp)	# fill _tmp99 to $t0 from $fp-180
	  beqz $t0, _L14	# branch if _tmp99 is zero 
	# _tmp100 = 0
	  li $t2, 0		# load constant value 0 into $t2
	  sw $t2, -184($fp)	# spill _tmp100 from $t2 to $fp-184
	# j = _tmp100
	  lw $t2, -184($fp)	# fill _tmp100 to $t2 from $fp-184
	  sw $t2, -12($fp)	# spill j from $t2 to $fp-12
  _L15:
	# _tmp101 = 10
	  li $t2, 10		# load constant value 10 into $t2
	  sw $t2, -188($fp)	# spill _tmp101 from $t2 to $fp-188
	# _tmp102 = j < _tmp101
	  lw $t0, -12($fp)	# fill j to $t0 from $fp-12
	  lw $t1, -188($fp)	# fill _tmp101 to $t1 from $fp-188
	  slt $t2, $t0, $t1	
	  sw $t2, -192($fp)	# spill _tmp102 from $t2 to $fp-192
	# IfZ _tmp102 Goto _L16
	  lw $t0, -192($fp)	# fill _tmp102 to $t0 from $fp-192
	  beqz $t0, _L16	# branch if _tmp102 is zero 
	# _tmp103 = 0
	  li $t2, 0		# load constant value 0 into $t2
	  sw $t2, -196($fp)	# spill _tmp103 from $t2 to $fp-196
	# _tmp104 = *(this + 4)
	  lw $t0, 4($fp)	# fill this to $t0 from $fp+4
	  lw $t2, 4($t0) 	# load with offset
	  sw $t2, -200($fp)	# spill _tmp104 from $t2 to $fp-200
	# _tmp105 = 0
	  li $t2, 0		# load constant value 0 into $t2
	  sw $t2, -204($fp)	# spill _tmp105 from $t2 to $fp-204
	# _tmp106 = *(_tmp104)
	  lw $t0, -200($fp)	# fill _tmp104 to $t0 from $fp-200
	  lw $t2, 0($t0) 	# load with offset
	  sw $t2, -208($fp)	# spill _tmp106 from $t2 to $fp-208
	# _tmp107 = i < _tmp105
	  lw $t0, -8($fp)	# fill i to $t0 from $fp-8
	  lw $t1, -204($fp)	# fill _tmp105 to $t1 from $fp-204
	  slt $t2, $t0, $t1	
	  sw $t2, -212($fp)	# spill _tmp107 from $t2 to $fp-212
	# _tmp108 = _tmp106 < i
	  lw $t0, -208($fp)	# fill _tmp106 to $t0 from $fp-208
	  lw $t1, -8($fp)	# fill i to $t1 from $fp-8
	  slt $t2, $t0, $t1	
	  sw $t2, -216($fp)	# spill _tmp108 from $t2 to $fp-216
	# _tmp109 = _tmp106 == i
	  lw $t0, -208($fp)	# fill _tmp106 to $t0 from $fp-208
	  lw $t1, -8($fp)	# fill i to $t1 from $fp-8
	  seq $t2, $t0, $t1	
	  sw $t2, -220($fp)	# spill _tmp109 from $t2 to $fp-220
	# _tmp110 = _tmp108 || _tmp109
	  lw $t0, -216($fp)	# fill _tmp108 to $t0 from $fp-216
	  lw $t1, -220($fp)	# fill _tmp109 to $t1 from $fp-220
	  or $t2, $t0, $t1	
	  sw $t2, -224($fp)	# spill _tmp110 from $t2 to $fp-224
	# _tmp111 = _tmp110 || _tmp107
	  lw $t0, -224($fp)	# fill _tmp110 to $t0 from $fp-224
	  lw $t1, -212($fp)	# fill _tmp107 to $t1 from $fp-212
	  or $t2, $t0, $t1	
	  sw $t2, -228($fp)	# spill _tmp111 from $t2 to $fp-228
	# IfZ _tmp111 Goto _L17
	  lw $t0, -228($fp)	# fill _tmp111 to $t0 from $fp-228
	  beqz $t0, _L17	# branch if _tmp111 is zero 
	# _tmp112 = "Decaf runtime error: Array subscript out of bound..."
	  .data			# create string constant marked with label
	  _string6: .asciiz "Decaf runtime error: Array subscript out of bounds\n"
	  .text
	  la $t2, _string6	# load label
	  sw $t2, -232($fp)	# spill _tmp112 from $t2 to $fp-232
	# PushParam _tmp112
	  subu $sp, $sp, 4	# decrement sp to make space for param
	  lw $t0, -232($fp)	# fill _tmp112 to $t0 from $fp-232
	  sw $t0, 4($sp)	# copy param value to stack
	# LCall _PrintString
	  jal _PrintString   	# jump to function
	# PopParams 4
	  add $sp, $sp, 4	# pop params off stack
	# LCall _Halt
	  jal _Halt          	# jump to function
  _L17:
	# _tmp113 = 4
	  li $t2, 4		# load constant value 4 into $t2
	  sw $t2, -236($fp)	# spill _tmp113 from $t2 to $fp-236
	# _tmp114 = i * _tmp113
	  lw $t0, -8($fp)	# fill i to $t0 from $fp-8
	  lw $t1, -236($fp)	# fill _tmp113 to $t1 from $fp-236
	  mul $t2, $t0, $t1	
	  sw $t2, -240($fp)	# spill _tmp114 from $t2 to $fp-240
	# _tmp115 = _tmp114 + _tmp113
	  lw $t0, -240($fp)	# fill _tmp114 to $t0 from $fp-240
	  lw $t1, -236($fp)	# fill _tmp113 to $t1 from $fp-236
	  add $t2, $t0, $t1	
	  sw $t2, -244($fp)	# spill _tmp115 from $t2 to $fp-244
	# _tmp116 = _tmp104 + _tmp115
	  lw $t0, -200($fp)	# fill _tmp104 to $t0 from $fp-200
	  lw $t1, -244($fp)	# fill _tmp115 to $t1 from $fp-244
	  add $t2, $t0, $t1	
	  sw $t2, -248($fp)	# spill _tmp116 from $t2 to $fp-248
	# _tmp117 = *(_tmp116)
	  lw $t0, -248($fp)	# fill _tmp116 to $t0 from $fp-248
	  lw $t2, 0($t0) 	# load with offset
	  sw $t2, -252($fp)	# spill _tmp117 from $t2 to $fp-252
	# _tmp118 = 0
	  li $t2, 0		# load constant value 0 into $t2
	  sw $t2, -256($fp)	# spill _tmp118 from $t2 to $fp-256
	# _tmp119 = *(_tmp117)
	  lw $t0, -252($fp)	# fill _tmp117 to $t0 from $fp-252
	  lw $t2, 0($t0) 	# load with offset
	  sw $t2, -260($fp)	# spill _tmp119 from $t2 to $fp-260
	# _tmp120 = j < _tmp118
	  lw $t0, -12($fp)	# fill j to $t0 from $fp-12
	  lw $t1, -256($fp)	# fill _tmp118 to $t1 from $fp-256
	  slt $t2, $t0, $t1	
	  sw $t2, -264($fp)	# spill _tmp120 from $t2 to $fp-264
	# _tmp121 = _tmp119 < j
	  lw $t0, -260($fp)	# fill _tmp119 to $t0 from $fp-260
	  lw $t1, -12($fp)	# fill j to $t1 from $fp-12
	  slt $t2, $t0, $t1	
	  sw $t2, -268($fp)	# spill _tmp121 from $t2 to $fp-268
	# _tmp122 = _tmp119 == j
	  lw $t0, -260($fp)	# fill _tmp119 to $t0 from $fp-260
	  lw $t1, -12($fp)	# fill j to $t1 from $fp-12
	  seq $t2, $t0, $t1	
	  sw $t2, -272($fp)	# spill _tmp122 from $t2 to $fp-272
	# _tmp123 = _tmp121 || _tmp122
	  lw $t0, -268($fp)	# fill _tmp121 to $t0 from $fp-268
	  lw $t1, -272($fp)	# fill _tmp122 to $t1 from $fp-272
	  or $t2, $t0, $t1	
	  sw $t2, -276($fp)	# spill _tmp123 from $t2 to $fp-276
	# _tmp124 = _tmp123 || _tmp120
	  lw $t0, -276($fp)	# fill _tmp123 to $t0 from $fp-276
	  lw $t1, -264($fp)	# fill _tmp120 to $t1 from $fp-264
	  or $t2, $t0, $t1	
	  sw $t2, -280($fp)	# spill _tmp124 from $t2 to $fp-280
	# IfZ _tmp124 Goto _L18
	  lw $t0, -280($fp)	# fill _tmp124 to $t0 from $fp-280
	  beqz $t0, _L18	# branch if _tmp124 is zero 
	# _tmp125 = "Decaf runtime error: Array subscript out of bound..."
	  .data			# create string constant marked with label
	  _string7: .asciiz "Decaf runtime error: Array subscript out of bounds\n"
	  .text
	  la $t2, _string7	# load label
	  sw $t2, -284($fp)	# spill _tmp125 from $t2 to $fp-284
	# PushParam _tmp125
	  subu $sp, $sp, 4	# decrement sp to make space for param
	  lw $t0, -284($fp)	# fill _tmp125 to $t0 from $fp-284
	  sw $t0, 4($sp)	# copy param value to stack
	# LCall _PrintString
	  jal _PrintString   	# jump to function
	# PopParams 4
	  add $sp, $sp, 4	# pop params off stack
	# LCall _Halt
	  jal _Halt          	# jump to function
  _L18:
	# _tmp126 = 4
	  li $t2, 4		# load constant value 4 into $t2
	  sw $t2, -288($fp)	# spill _tmp126 from $t2 to $fp-288
	# _tmp127 = j * _tmp126
	  lw $t0, -12($fp)	# fill j to $t0 from $fp-12
	  lw $t1, -288($fp)	# fill _tmp126 to $t1 from $fp-288
	  mul $t2, $t0, $t1	
	  sw $t2, -292($fp)	# spill _tmp127 from $t2 to $fp-292
	# _tmp128 = _tmp127 + _tmp126
	  lw $t0, -292($fp)	# fill _tmp127 to $t0 from $fp-292
	  lw $t1, -288($fp)	# fill _tmp126 to $t1 from $fp-288
	  add $t2, $t0, $t1	
	  sw $t2, -296($fp)	# spill _tmp128 from $t2 to $fp-296
	# _tmp129 = _tmp117 + _tmp128
	  lw $t0, -252($fp)	# fill _tmp117 to $t0 from $fp-252
	  lw $t1, -296($fp)	# fill _tmp128 to $t1 from $fp-296
	  add $t2, $t0, $t1	
	  sw $t2, -300($fp)	# spill _tmp129 from $t2 to $fp-300
	# *(_tmp129) = _tmp103
	  lw $t0, -196($fp)	# fill _tmp103 to $t0 from $fp-196
	  lw $t2, -300($fp)	# fill _tmp129 to $t2 from $fp-300
	  sw $t0, 0($t2) 	# store with offset
	# _tmp130 = *(_tmp129)
	  lw $t0, -300($fp)	# fill _tmp129 to $t0 from $fp-300
	  lw $t2, 0($t0) 	# load with offset
	  sw $t2, -304($fp)	# spill _tmp130 from $t2 to $fp-304
	# _tmp131 = 1
	  li $t2, 1		# load constant value 1 into $t2
	  sw $t2, -308($fp)	# spill _tmp131 from $t2 to $fp-308
	# _tmp132 = j + _tmp131
	  lw $t0, -12($fp)	# fill j to $t0 from $fp-12
	  lw $t1, -308($fp)	# fill _tmp131 to $t1 from $fp-308
	  add $t2, $t0, $t1	
	  sw $t2, -312($fp)	# spill _tmp132 from $t2 to $fp-312
	# j = _tmp132
	  lw $t2, -312($fp)	# fill _tmp132 to $t2 from $fp-312
	  sw $t2, -12($fp)	# spill j from $t2 to $fp-12
	# Goto _L15
	  b _L15		# unconditional branch
  _L16:
	# _tmp133 = 1
	  li $t2, 1		# load constant value 1 into $t2
	  sw $t2, -316($fp)	# spill _tmp133 from $t2 to $fp-316
	# _tmp134 = i + _tmp133
	  lw $t0, -8($fp)	# fill i to $t0 from $fp-8
	  lw $t1, -316($fp)	# fill _tmp133 to $t1 from $fp-316
	  add $t2, $t0, $t1	
	  sw $t2, -320($fp)	# spill _tmp134 from $t2 to $fp-320
	# i = _tmp134
	  lw $t2, -320($fp)	# fill _tmp134 to $t2 from $fp-320
	  sw $t2, -8($fp)	# spill i from $t2 to $fp-8
	# Goto _L13
	  b _L13		# unconditional branch
  _L14:
	# EndFunc
	# (below handles reaching end of fn body with no explicit return)
	  move $sp, $fp		# pop callee frame off stack
	  lw $ra, -4($fp)	# restore saved ra
	  lw $fp, 0($fp)	# restore saved fp
	  jr $ra		# return from function
  DenseMatrix.____Set:
	# BeginFunc 108
	  subu $sp, $sp, 8	# decrement sp to make space to save ra, fp
	  sw $fp, 8($sp)	# save fp
	  sw $ra, 4($sp)	# save ra
	  addiu $fp, $sp, 8	# set up new fp
	  subu $sp, $sp, 108	# decrement sp to make space for locals/temps
	# _tmp135 = *(this + 4)
	  lw $t0, 4($fp)	# fill this to $t0 from $fp+4
	  lw $t2, 4($t0) 	# load with offset
	  sw $t2, -8($fp)	# spill _tmp135 from $t2 to $fp-8
	# _tmp136 = 0
	  li $t2, 0		# load constant value 0 into $t2
	  sw $t2, -12($fp)	# spill _tmp136 from $t2 to $fp-12
	# _tmp137 = *(_tmp135)
	  lw $t0, -8($fp)	# fill _tmp135 to $t0 from $fp-8
	  lw $t2, 0($t0) 	# load with offset
	  sw $t2, -16($fp)	# spill _tmp137 from $t2 to $fp-16
	# _tmp138 = x < _tmp136
	  lw $t0, 8($fp)	# fill x to $t0 from $fp+8
	  lw $t1, -12($fp)	# fill _tmp136 to $t1 from $fp-12
	  slt $t2, $t0, $t1	
	  sw $t2, -20($fp)	# spill _tmp138 from $t2 to $fp-20
	# _tmp139 = _tmp137 < x
	  lw $t0, -16($fp)	# fill _tmp137 to $t0 from $fp-16
	  lw $t1, 8($fp)	# fill x to $t1 from $fp+8
	  slt $t2, $t0, $t1	
	  sw $t2, -24($fp)	# spill _tmp139 from $t2 to $fp-24
	# _tmp140 = _tmp137 == x
	  lw $t0, -16($fp)	# fill _tmp137 to $t0 from $fp-16
	  lw $t1, 8($fp)	# fill x to $t1 from $fp+8
	  seq $t2, $t0, $t1	
	  sw $t2, -28($fp)	# spill _tmp140 from $t2 to $fp-28
	# _tmp141 = _tmp139 || _tmp140
	  lw $t0, -24($fp)	# fill _tmp139 to $t0 from $fp-24
	  lw $t1, -28($fp)	# fill _tmp140 to $t1 from $fp-28
	  or $t2, $t0, $t1	
	  sw $t2, -32($fp)	# spill _tmp141 from $t2 to $fp-32
	# _tmp142 = _tmp141 || _tmp138
	  lw $t0, -32($fp)	# fill _tmp141 to $t0 from $fp-32
	  lw $t1, -20($fp)	# fill _tmp138 to $t1 from $fp-20
	  or $t2, $t0, $t1	
	  sw $t2, -36($fp)	# spill _tmp142 from $t2 to $fp-36
	# IfZ _tmp142 Goto _L19
	  lw $t0, -36($fp)	# fill _tmp142 to $t0 from $fp-36
	  beqz $t0, _L19	# branch if _tmp142 is zero 
	# _tmp143 = "Decaf runtime error: Array subscript out of bound..."
	  .data			# create string constant marked with label
	  _string8: .asciiz "Decaf runtime error: Array subscript out of bounds\n"
	  .text
	  la $t2, _string8	# load label
	  sw $t2, -40($fp)	# spill _tmp143 from $t2 to $fp-40
	# PushParam _tmp143
	  subu $sp, $sp, 4	# decrement sp to make space for param
	  lw $t0, -40($fp)	# fill _tmp143 to $t0 from $fp-40
	  sw $t0, 4($sp)	# copy param value to stack
	# LCall _PrintString
	  jal _PrintString   	# jump to function
	# PopParams 4
	  add $sp, $sp, 4	# pop params off stack
	# LCall _Halt
	  jal _Halt          	# jump to function
  _L19:
	# _tmp144 = 4
	  li $t2, 4		# load constant value 4 into $t2
	  sw $t2, -44($fp)	# spill _tmp144 from $t2 to $fp-44
	# _tmp145 = x * _tmp144
	  lw $t0, 8($fp)	# fill x to $t0 from $fp+8
	  lw $t1, -44($fp)	# fill _tmp144 to $t1 from $fp-44
	  mul $t2, $t0, $t1	
	  sw $t2, -48($fp)	# spill _tmp145 from $t2 to $fp-48
	# _tmp146 = _tmp145 + _tmp144
	  lw $t0, -48($fp)	# fill _tmp145 to $t0 from $fp-48
	  lw $t1, -44($fp)	# fill _tmp144 to $t1 from $fp-44
	  add $t2, $t0, $t1	
	  sw $t2, -52($fp)	# spill _tmp146 from $t2 to $fp-52
	# _tmp147 = _tmp135 + _tmp146
	  lw $t0, -8($fp)	# fill _tmp135 to $t0 from $fp-8
	  lw $t1, -52($fp)	# fill _tmp146 to $t1 from $fp-52
	  add $t2, $t0, $t1	
	  sw $t2, -56($fp)	# spill _tmp147 from $t2 to $fp-56
	# _tmp148 = *(_tmp147)
	  lw $t0, -56($fp)	# fill _tmp147 to $t0 from $fp-56
	  lw $t2, 0($t0) 	# load with offset
	  sw $t2, -60($fp)	# spill _tmp148 from $t2 to $fp-60
	# _tmp149 = 0
	  li $t2, 0		# load constant value 0 into $t2
	  sw $t2, -64($fp)	# spill _tmp149 from $t2 to $fp-64
	# _tmp150 = *(_tmp148)
	  lw $t0, -60($fp)	# fill _tmp148 to $t0 from $fp-60
	  lw $t2, 0($t0) 	# load with offset
	  sw $t2, -68($fp)	# spill _tmp150 from $t2 to $fp-68
	# _tmp151 = y < _tmp149
	  lw $t0, 12($fp)	# fill y to $t0 from $fp+12
	  lw $t1, -64($fp)	# fill _tmp149 to $t1 from $fp-64
	  slt $t2, $t0, $t1	
	  sw $t2, -72($fp)	# spill _tmp151 from $t2 to $fp-72
	# _tmp152 = _tmp150 < y
	  lw $t0, -68($fp)	# fill _tmp150 to $t0 from $fp-68
	  lw $t1, 12($fp)	# fill y to $t1 from $fp+12
	  slt $t2, $t0, $t1	
	  sw $t2, -76($fp)	# spill _tmp152 from $t2 to $fp-76
	# _tmp153 = _tmp150 == y
	  lw $t0, -68($fp)	# fill _tmp150 to $t0 from $fp-68
	  lw $t1, 12($fp)	# fill y to $t1 from $fp+12
	  seq $t2, $t0, $t1	
	  sw $t2, -80($fp)	# spill _tmp153 from $t2 to $fp-80
	# _tmp154 = _tmp152 || _tmp153
	  lw $t0, -76($fp)	# fill _tmp152 to $t0 from $fp-76
	  lw $t1, -80($fp)	# fill _tmp153 to $t1 from $fp-80
	  or $t2, $t0, $t1	
	  sw $t2, -84($fp)	# spill _tmp154 from $t2 to $fp-84
	# _tmp155 = _tmp154 || _tmp151
	  lw $t0, -84($fp)	# fill _tmp154 to $t0 from $fp-84
	  lw $t1, -72($fp)	# fill _tmp151 to $t1 from $fp-72
	  or $t2, $t0, $t1	
	  sw $t2, -88($fp)	# spill _tmp155 from $t2 to $fp-88
	# IfZ _tmp155 Goto _L20
	  lw $t0, -88($fp)	# fill _tmp155 to $t0 from $fp-88
	  beqz $t0, _L20	# branch if _tmp155 is zero 
	# _tmp156 = "Decaf runtime error: Array subscript out of bound..."
	  .data			# create string constant marked with label
	  _string9: .asciiz "Decaf runtime error: Array subscript out of bounds\n"
	  .text
	  la $t2, _string9	# load label
	  sw $t2, -92($fp)	# spill _tmp156 from $t2 to $fp-92
	# PushParam _tmp156
	  subu $sp, $sp, 4	# decrement sp to make space for param
	  lw $t0, -92($fp)	# fill _tmp156 to $t0 from $fp-92
	  sw $t0, 4($sp)	# copy param value to stack
	# LCall _PrintString
	  jal _PrintString   	# jump to function
	# PopParams 4
	  add $sp, $sp, 4	# pop params off stack
	# LCall _Halt
	  jal _Halt          	# jump to function
  _L20:
	# _tmp157 = 4
	  li $t2, 4		# load constant value 4 into $t2
	  sw $t2, -96($fp)	# spill _tmp157 from $t2 to $fp-96
	# _tmp158 = y * _tmp157
	  lw $t0, 12($fp)	# fill y to $t0 from $fp+12
	  lw $t1, -96($fp)	# fill _tmp157 to $t1 from $fp-96
	  mul $t2, $t0, $t1	
	  sw $t2, -100($fp)	# spill _tmp158 from $t2 to $fp-100
	# _tmp159 = _tmp158 + _tmp157
	  lw $t0, -100($fp)	# fill _tmp158 to $t0 from $fp-100
	  lw $t1, -96($fp)	# fill _tmp157 to $t1 from $fp-96
	  add $t2, $t0, $t1	
	  sw $t2, -104($fp)	# spill _tmp159 from $t2 to $fp-104
	# _tmp160 = _tmp148 + _tmp159
	  lw $t0, -60($fp)	# fill _tmp148 to $t0 from $fp-60
	  lw $t1, -104($fp)	# fill _tmp159 to $t1 from $fp-104
	  add $t2, $t0, $t1	
	  sw $t2, -108($fp)	# spill _tmp160 from $t2 to $fp-108
	# *(_tmp160) = value
	  lw $t0, 16($fp)	# fill value to $t0 from $fp+16
	  lw $t2, -108($fp)	# fill _tmp160 to $t2 from $fp-108
	  sw $t0, 0($t2) 	# store with offset
	# _tmp161 = *(_tmp160)
	  lw $t0, -108($fp)	# fill _tmp160 to $t0 from $fp-108
	  lw $t2, 0($t0) 	# load with offset
	  sw $t2, -112($fp)	# spill _tmp161 from $t2 to $fp-112
	# EndFunc
	# (below handles reaching end of fn body with no explicit return)
	  move $sp, $fp		# pop callee frame off stack
	  lw $ra, -4($fp)	# restore saved ra
	  lw $fp, 0($fp)	# restore saved fp
	  jr $ra		# return from function
  DenseMatrix.____Get:
	# BeginFunc 108
	  subu $sp, $sp, 8	# decrement sp to make space to save ra, fp
	  sw $fp, 8($sp)	# save fp
	  sw $ra, 4($sp)	# save ra
	  addiu $fp, $sp, 8	# set up new fp
	  subu $sp, $sp, 108	# decrement sp to make space for locals/temps
	# _tmp162 = *(this + 4)
	  lw $t0, 4($fp)	# fill this to $t0 from $fp+4
	  lw $t2, 4($t0) 	# load with offset
	  sw $t2, -8($fp)	# spill _tmp162 from $t2 to $fp-8
	# _tmp163 = 0
	  li $t2, 0		# load constant value 0 into $t2
	  sw $t2, -12($fp)	# spill _tmp163 from $t2 to $fp-12
	# _tmp164 = *(_tmp162)
	  lw $t0, -8($fp)	# fill _tmp162 to $t0 from $fp-8
	  lw $t2, 0($t0) 	# load with offset
	  sw $t2, -16($fp)	# spill _tmp164 from $t2 to $fp-16
	# _tmp165 = x < _tmp163
	  lw $t0, 8($fp)	# fill x to $t0 from $fp+8
	  lw $t1, -12($fp)	# fill _tmp163 to $t1 from $fp-12
	  slt $t2, $t0, $t1	
	  sw $t2, -20($fp)	# spill _tmp165 from $t2 to $fp-20
	# _tmp166 = _tmp164 < x
	  lw $t0, -16($fp)	# fill _tmp164 to $t0 from $fp-16
	  lw $t1, 8($fp)	# fill x to $t1 from $fp+8
	  slt $t2, $t0, $t1	
	  sw $t2, -24($fp)	# spill _tmp166 from $t2 to $fp-24
	# _tmp167 = _tmp164 == x
	  lw $t0, -16($fp)	# fill _tmp164 to $t0 from $fp-16
	  lw $t1, 8($fp)	# fill x to $t1 from $fp+8
	  seq $t2, $t0, $t1	
	  sw $t2, -28($fp)	# spill _tmp167 from $t2 to $fp-28
	# _tmp168 = _tmp166 || _tmp167
	  lw $t0, -24($fp)	# fill _tmp166 to $t0 from $fp-24
	  lw $t1, -28($fp)	# fill _tmp167 to $t1 from $fp-28
	  or $t2, $t0, $t1	
	  sw $t2, -32($fp)	# spill _tmp168 from $t2 to $fp-32
	# _tmp169 = _tmp168 || _tmp165
	  lw $t0, -32($fp)	# fill _tmp168 to $t0 from $fp-32
	  lw $t1, -20($fp)	# fill _tmp165 to $t1 from $fp-20
	  or $t2, $t0, $t1	
	  sw $t2, -36($fp)	# spill _tmp169 from $t2 to $fp-36
	# IfZ _tmp169 Goto _L21
	  lw $t0, -36($fp)	# fill _tmp169 to $t0 from $fp-36
	  beqz $t0, _L21	# branch if _tmp169 is zero 
	# _tmp170 = "Decaf runtime error: Array subscript out of bound..."
	  .data			# create string constant marked with label
	  _string10: .asciiz "Decaf runtime error: Array subscript out of bounds\n"
	  .text
	  la $t2, _string10	# load label
	  sw $t2, -40($fp)	# spill _tmp170 from $t2 to $fp-40
	# PushParam _tmp170
	  subu $sp, $sp, 4	# decrement sp to make space for param
	  lw $t0, -40($fp)	# fill _tmp170 to $t0 from $fp-40
	  sw $t0, 4($sp)	# copy param value to stack
	# LCall _PrintString
	  jal _PrintString   	# jump to function
	# PopParams 4
	  add $sp, $sp, 4	# pop params off stack
	# LCall _Halt
	  jal _Halt          	# jump to function
  _L21:
	# _tmp171 = 4
	  li $t2, 4		# load constant value 4 into $t2
	  sw $t2, -44($fp)	# spill _tmp171 from $t2 to $fp-44
	# _tmp172 = x * _tmp171
	  lw $t0, 8($fp)	# fill x to $t0 from $fp+8
	  lw $t1, -44($fp)	# fill _tmp171 to $t1 from $fp-44
	  mul $t2, $t0, $t1	
	  sw $t2, -48($fp)	# spill _tmp172 from $t2 to $fp-48
	# _tmp173 = _tmp172 + _tmp171
	  lw $t0, -48($fp)	# fill _tmp172 to $t0 from $fp-48
	  lw $t1, -44($fp)	# fill _tmp171 to $t1 from $fp-44
	  add $t2, $t0, $t1	
	  sw $t2, -52($fp)	# spill _tmp173 from $t2 to $fp-52
	# _tmp174 = _tmp162 + _tmp173
	  lw $t0, -8($fp)	# fill _tmp162 to $t0 from $fp-8
	  lw $t1, -52($fp)	# fill _tmp173 to $t1 from $fp-52
	  add $t2, $t0, $t1	
	  sw $t2, -56($fp)	# spill _tmp174 from $t2 to $fp-56
	# _tmp175 = *(_tmp174)
	  lw $t0, -56($fp)	# fill _tmp174 to $t0 from $fp-56
	  lw $t2, 0($t0) 	# load with offset
	  sw $t2, -60($fp)	# spill _tmp175 from $t2 to $fp-60
	# _tmp176 = 0
	  li $t2, 0		# load constant value 0 into $t2
	  sw $t2, -64($fp)	# spill _tmp176 from $t2 to $fp-64
	# _tmp177 = *(_tmp175)
	  lw $t0, -60($fp)	# fill _tmp175 to $t0 from $fp-60
	  lw $t2, 0($t0) 	# load with offset
	  sw $t2, -68($fp)	# spill _tmp177 from $t2 to $fp-68
	# _tmp178 = y < _tmp176
	  lw $t0, 12($fp)	# fill y to $t0 from $fp+12
	  lw $t1, -64($fp)	# fill _tmp176 to $t1 from $fp-64
	  slt $t2, $t0, $t1	
	  sw $t2, -72($fp)	# spill _tmp178 from $t2 to $fp-72
	# _tmp179 = _tmp177 < y
	  lw $t0, -68($fp)	# fill _tmp177 to $t0 from $fp-68
	  lw $t1, 12($fp)	# fill y to $t1 from $fp+12
	  slt $t2, $t0, $t1	
	  sw $t2, -76($fp)	# spill _tmp179 from $t2 to $fp-76
	# _tmp180 = _tmp177 == y
	  lw $t0, -68($fp)	# fill _tmp177 to $t0 from $fp-68
	  lw $t1, 12($fp)	# fill y to $t1 from $fp+12
	  seq $t2, $t0, $t1	
	  sw $t2, -80($fp)	# spill _tmp180 from $t2 to $fp-80
	# _tmp181 = _tmp179 || _tmp180
	  lw $t0, -76($fp)	# fill _tmp179 to $t0 from $fp-76
	  lw $t1, -80($fp)	# fill _tmp180 to $t1 from $fp-80
	  or $t2, $t0, $t1	
	  sw $t2, -84($fp)	# spill _tmp181 from $t2 to $fp-84
	# _tmp182 = _tmp181 || _tmp178
	  lw $t0, -84($fp)	# fill _tmp181 to $t0 from $fp-84
	  lw $t1, -72($fp)	# fill _tmp178 to $t1 from $fp-72
	  or $t2, $t0, $t1	
	  sw $t2, -88($fp)	# spill _tmp182 from $t2 to $fp-88
	# IfZ _tmp182 Goto _L22
	  lw $t0, -88($fp)	# fill _tmp182 to $t0 from $fp-88
	  beqz $t0, _L22	# branch if _tmp182 is zero 
	# _tmp183 = "Decaf runtime error: Array subscript out of bound..."
	  .data			# create string constant marked with label
	  _string11: .asciiz "Decaf runtime error: Array subscript out of bounds\n"
	  .text
	  la $t2, _string11	# load label
	  sw $t2, -92($fp)	# spill _tmp183 from $t2 to $fp-92
	# PushParam _tmp183
	  subu $sp, $sp, 4	# decrement sp to make space for param
	  lw $t0, -92($fp)	# fill _tmp183 to $t0 from $fp-92
	  sw $t0, 4($sp)	# copy param value to stack
	# LCall _PrintString
	  jal _PrintString   	# jump to function
	# PopParams 4
	  add $sp, $sp, 4	# pop params off stack
	# LCall _Halt
	  jal _Halt          	# jump to function
  _L22:
	# _tmp184 = 4
	  li $t2, 4		# load constant value 4 into $t2
	  sw $t2, -96($fp)	# spill _tmp184 from $t2 to $fp-96
	# _tmp185 = y * _tmp184
	  lw $t0, 12($fp)	# fill y to $t0 from $fp+12
	  lw $t1, -96($fp)	# fill _tmp184 to $t1 from $fp-96
	  mul $t2, $t0, $t1	
	  sw $t2, -100($fp)	# spill _tmp185 from $t2 to $fp-100
	# _tmp186 = _tmp185 + _tmp184
	  lw $t0, -100($fp)	# fill _tmp185 to $t0 from $fp-100
	  lw $t1, -96($fp)	# fill _tmp184 to $t1 from $fp-96
	  add $t2, $t0, $t1	
	  sw $t2, -104($fp)	# spill _tmp186 from $t2 to $fp-104
	# _tmp187 = _tmp175 + _tmp186
	  lw $t0, -60($fp)	# fill _tmp175 to $t0 from $fp-60
	  lw $t1, -104($fp)	# fill _tmp186 to $t1 from $fp-104
	  add $t2, $t0, $t1	
	  sw $t2, -108($fp)	# spill _tmp187 from $t2 to $fp-108
	# _tmp188 = *(_tmp187)
	  lw $t0, -108($fp)	# fill _tmp187 to $t0 from $fp-108
	  lw $t2, 0($t0) 	# load with offset
	  sw $t2, -112($fp)	# spill _tmp188 from $t2 to $fp-112
	# Return _tmp188
	  lw $t2, -112($fp)	# fill _tmp188 to $t2 from $fp-112
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
	# VTable for class DenseMatrix
	  .data
	  .align 2
	  DenseMatrix:		# label for class DenseMatrix vtable
	  .word DenseMatrix.____Init
	  .word DenseMatrix.____Set
	  .word DenseMatrix.____Get
	  .word Matrix.____PrintMatrix
	  .word Matrix.____SeedMatrix
	  .word DenseMatrix.____Init
	  .word DenseMatrix.____Set
	  .word DenseMatrix.____Get
	  .text
  SparseItem.____Init:
	# BeginFunc 0
	  subu $sp, $sp, 8	# decrement sp to make space to save ra, fp
	  sw $fp, 8($sp)	# save fp
	  sw $ra, 4($sp)	# save ra
	  addiu $fp, $sp, 8	# set up new fp
	# *(this + 4) = d
	  lw $t0, 8($fp)	# fill d to $t0 from $fp+8
	  lw $t2, 4($fp)	# fill this to $t2 from $fp+4
	  sw $t0, 4($t2) 	# store with offset
	# *(this + 8) = y
	  lw $t0, 12($fp)	# fill y to $t0 from $fp+12
	  lw $t2, 4($fp)	# fill this to $t2 from $fp+4
	  sw $t0, 8($t2) 	# store with offset
	# *(this + 12) = next
	  lw $t0, 16($fp)	# fill next to $t0 from $fp+16
	  lw $t2, 4($fp)	# fill this to $t2 from $fp+4
	  sw $t0, 12($t2) 	# store with offset
	# EndFunc
	# (below handles reaching end of fn body with no explicit return)
	  move $sp, $fp		# pop callee frame off stack
	  lw $ra, -4($fp)	# restore saved ra
	  lw $fp, 0($fp)	# restore saved fp
	  jr $ra		# return from function
  SparseItem.____GetNext:
	# BeginFunc 4
	  subu $sp, $sp, 8	# decrement sp to make space to save ra, fp
	  sw $fp, 8($sp)	# save fp
	  sw $ra, 4($sp)	# save ra
	  addiu $fp, $sp, 8	# set up new fp
	  subu $sp, $sp, 4	# decrement sp to make space for locals/temps
	# _tmp189 = *(this + 12)
	  lw $t0, 4($fp)	# fill this to $t0 from $fp+4
	  lw $t2, 12($t0) 	# load with offset
	  sw $t2, -8($fp)	# spill _tmp189 from $t2 to $fp-8
	# Return _tmp189
	  lw $t2, -8($fp)	# fill _tmp189 to $t2 from $fp-8
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
  SparseItem.____GetY:
	# BeginFunc 4
	  subu $sp, $sp, 8	# decrement sp to make space to save ra, fp
	  sw $fp, 8($sp)	# save fp
	  sw $ra, 4($sp)	# save ra
	  addiu $fp, $sp, 8	# set up new fp
	  subu $sp, $sp, 4	# decrement sp to make space for locals/temps
	# _tmp190 = *(this + 8)
	  lw $t0, 4($fp)	# fill this to $t0 from $fp+4
	  lw $t2, 8($t0) 	# load with offset
	  sw $t2, -8($fp)	# spill _tmp190 from $t2 to $fp-8
	# Return _tmp190
	  lw $t2, -8($fp)	# fill _tmp190 to $t2 from $fp-8
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
  SparseItem.____GetData:
	# BeginFunc 4
	  subu $sp, $sp, 8	# decrement sp to make space to save ra, fp
	  sw $fp, 8($sp)	# save fp
	  sw $ra, 4($sp)	# save ra
	  addiu $fp, $sp, 8	# set up new fp
	  subu $sp, $sp, 4	# decrement sp to make space for locals/temps
	# _tmp191 = *(this + 4)
	  lw $t0, 4($fp)	# fill this to $t0 from $fp+4
	  lw $t2, 4($t0) 	# load with offset
	  sw $t2, -8($fp)	# spill _tmp191 from $t2 to $fp-8
	# Return _tmp191
	  lw $t2, -8($fp)	# fill _tmp191 to $t2 from $fp-8
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
  SparseItem.____SetData:
	# BeginFunc 0
	  subu $sp, $sp, 8	# decrement sp to make space to save ra, fp
	  sw $fp, 8($sp)	# save fp
	  sw $ra, 4($sp)	# save ra
	  addiu $fp, $sp, 8	# set up new fp
	# *(this + 4) = val
	  lw $t0, 8($fp)	# fill val to $t0 from $fp+8
	  lw $t2, 4($fp)	# fill this to $t2 from $fp+4
	  sw $t0, 4($t2) 	# store with offset
	# EndFunc
	# (below handles reaching end of fn body with no explicit return)
	  move $sp, $fp		# pop callee frame off stack
	  lw $ra, -4($fp)	# restore saved ra
	  lw $fp, 0($fp)	# restore saved fp
	  jr $ra		# return from function
	# VTable for class SparseItem
	  .data
	  .align 2
	  SparseItem:		# label for class SparseItem vtable
	  .word SparseItem.____Init
	  .word SparseItem.____GetNext
	  .word SparseItem.____GetY
	  .word SparseItem.____GetData
	  .word SparseItem.____SetData
	  .text
  SparseMatrix.____Init:
	# BeginFunc 136
	  subu $sp, $sp, 8	# decrement sp to make space to save ra, fp
	  sw $fp, 8($sp)	# save fp
	  sw $ra, 4($sp)	# save ra
	  addiu $fp, $sp, 8	# set up new fp
	  subu $sp, $sp, 136	# decrement sp to make space for locals/temps
	# _tmp192 = 10
	  li $t2, 10		# load constant value 10 into $t2
	  sw $t2, -12($fp)	# spill _tmp192 from $t2 to $fp-12
	# _tmp193 = 4
	  li $t2, 4		# load constant value 4 into $t2
	  sw $t2, -16($fp)	# spill _tmp193 from $t2 to $fp-16
	# _tmp194 = 0
	  li $t2, 0		# load constant value 0 into $t2
	  sw $t2, -20($fp)	# spill _tmp194 from $t2 to $fp-20
	# _tmp195 = _tmp192 < _tmp194
	  lw $t0, -12($fp)	# fill _tmp192 to $t0 from $fp-12
	  lw $t1, -20($fp)	# fill _tmp194 to $t1 from $fp-20
	  slt $t2, $t0, $t1	
	  sw $t2, -24($fp)	# spill _tmp195 from $t2 to $fp-24
	# _tmp196 = _tmp192 == _tmp194
	  lw $t0, -12($fp)	# fill _tmp192 to $t0 from $fp-12
	  lw $t1, -20($fp)	# fill _tmp194 to $t1 from $fp-20
	  seq $t2, $t0, $t1	
	  sw $t2, -28($fp)	# spill _tmp196 from $t2 to $fp-28
	# _tmp197 = _tmp195 || _tmp196
	  lw $t0, -24($fp)	# fill _tmp195 to $t0 from $fp-24
	  lw $t1, -28($fp)	# fill _tmp196 to $t1 from $fp-28
	  or $t2, $t0, $t1	
	  sw $t2, -32($fp)	# spill _tmp197 from $t2 to $fp-32
	# IfZ _tmp197 Goto _L23
	  lw $t0, -32($fp)	# fill _tmp197 to $t0 from $fp-32
	  beqz $t0, _L23	# branch if _tmp197 is zero 
	# _tmp198 = "Decaf runtime error: Array size is <= 0\n"
	  .data			# create string constant marked with label
	  _string12: .asciiz "Decaf runtime error: Array size is <= 0\n"
	  .text
	  la $t2, _string12	# load label
	  sw $t2, -36($fp)	# spill _tmp198 from $t2 to $fp-36
	# PushParam _tmp198
	  subu $sp, $sp, 4	# decrement sp to make space for param
	  lw $t0, -36($fp)	# fill _tmp198 to $t0 from $fp-36
	  sw $t0, 4($sp)	# copy param value to stack
	# LCall _PrintString
	  jal _PrintString   	# jump to function
	# PopParams 4
	  add $sp, $sp, 4	# pop params off stack
	# LCall _Halt
	  jal _Halt          	# jump to function
  _L23:
	# _tmp199 = _tmp192 * _tmp193
	  lw $t0, -12($fp)	# fill _tmp192 to $t0 from $fp-12
	  lw $t1, -16($fp)	# fill _tmp193 to $t1 from $fp-16
	  mul $t2, $t0, $t1	
	  sw $t2, -40($fp)	# spill _tmp199 from $t2 to $fp-40
	# _tmp200 = _tmp193 + _tmp199
	  lw $t0, -16($fp)	# fill _tmp193 to $t0 from $fp-16
	  lw $t1, -40($fp)	# fill _tmp199 to $t1 from $fp-40
	  add $t2, $t0, $t1	
	  sw $t2, -44($fp)	# spill _tmp200 from $t2 to $fp-44
	# PushParam _tmp200
	  subu $sp, $sp, 4	# decrement sp to make space for param
	  lw $t0, -44($fp)	# fill _tmp200 to $t0 from $fp-44
	  sw $t0, 4($sp)	# copy param value to stack
	# _tmp201 = LCall _Alloc
	  jal _Alloc         	# jump to function
	  move $t2, $v0		# copy function return value from $v0
	  sw $t2, -48($fp)	# spill _tmp201 from $t2 to $fp-48
	# PopParams 4
	  add $sp, $sp, 4	# pop params off stack
	# *(_tmp201) = _tmp192
	  lw $t0, -12($fp)	# fill _tmp192 to $t0 from $fp-12
	  lw $t2, -48($fp)	# fill _tmp201 to $t2 from $fp-48
	  sw $t0, 0($t2) 	# store with offset
	# *(this + 4) = _tmp201
	  lw $t0, -48($fp)	# fill _tmp201 to $t0 from $fp-48
	  lw $t2, 4($fp)	# fill this to $t2 from $fp+4
	  sw $t0, 4($t2) 	# store with offset
	# _tmp202 = 0
	  li $t2, 0		# load constant value 0 into $t2
	  sw $t2, -52($fp)	# spill _tmp202 from $t2 to $fp-52
	# i = _tmp202
	  lw $t2, -52($fp)	# fill _tmp202 to $t2 from $fp-52
	  sw $t2, -8($fp)	# spill i from $t2 to $fp-8
  _L24:
	# _tmp203 = 10
	  li $t2, 10		# load constant value 10 into $t2
	  sw $t2, -56($fp)	# spill _tmp203 from $t2 to $fp-56
	# _tmp204 = i < _tmp203
	  lw $t0, -8($fp)	# fill i to $t0 from $fp-8
	  lw $t1, -56($fp)	# fill _tmp203 to $t1 from $fp-56
	  slt $t2, $t0, $t1	
	  sw $t2, -60($fp)	# spill _tmp204 from $t2 to $fp-60
	# IfZ _tmp204 Goto _L25
	  lw $t0, -60($fp)	# fill _tmp204 to $t0 from $fp-60
	  beqz $t0, _L25	# branch if _tmp204 is zero 
	# _tmp205 = 0
	  li $t2, 0		# load constant value 0 into $t2
	  sw $t2, -64($fp)	# spill _tmp205 from $t2 to $fp-64
	# _tmp206 = *(this + 4)
	  lw $t0, 4($fp)	# fill this to $t0 from $fp+4
	  lw $t2, 4($t0) 	# load with offset
	  sw $t2, -68($fp)	# spill _tmp206 from $t2 to $fp-68
	# _tmp207 = 0
	  li $t2, 0		# load constant value 0 into $t2
	  sw $t2, -72($fp)	# spill _tmp207 from $t2 to $fp-72
	# _tmp208 = *(_tmp206)
	  lw $t0, -68($fp)	# fill _tmp206 to $t0 from $fp-68
	  lw $t2, 0($t0) 	# load with offset
	  sw $t2, -76($fp)	# spill _tmp208 from $t2 to $fp-76
	# _tmp209 = i < _tmp207
	  lw $t0, -8($fp)	# fill i to $t0 from $fp-8
	  lw $t1, -72($fp)	# fill _tmp207 to $t1 from $fp-72
	  slt $t2, $t0, $t1	
	  sw $t2, -80($fp)	# spill _tmp209 from $t2 to $fp-80
	# _tmp210 = _tmp208 < i
	  lw $t0, -76($fp)	# fill _tmp208 to $t0 from $fp-76
	  lw $t1, -8($fp)	# fill i to $t1 from $fp-8
	  slt $t2, $t0, $t1	
	  sw $t2, -84($fp)	# spill _tmp210 from $t2 to $fp-84
	# _tmp211 = _tmp208 == i
	  lw $t0, -76($fp)	# fill _tmp208 to $t0 from $fp-76
	  lw $t1, -8($fp)	# fill i to $t1 from $fp-8
	  seq $t2, $t0, $t1	
	  sw $t2, -88($fp)	# spill _tmp211 from $t2 to $fp-88
	# _tmp212 = _tmp210 || _tmp211
	  lw $t0, -84($fp)	# fill _tmp210 to $t0 from $fp-84
	  lw $t1, -88($fp)	# fill _tmp211 to $t1 from $fp-88
	  or $t2, $t0, $t1	
	  sw $t2, -92($fp)	# spill _tmp212 from $t2 to $fp-92
	# _tmp213 = _tmp212 || _tmp209
	  lw $t0, -92($fp)	# fill _tmp212 to $t0 from $fp-92
	  lw $t1, -80($fp)	# fill _tmp209 to $t1 from $fp-80
	  or $t2, $t0, $t1	
	  sw $t2, -96($fp)	# spill _tmp213 from $t2 to $fp-96
	# IfZ _tmp213 Goto _L26
	  lw $t0, -96($fp)	# fill _tmp213 to $t0 from $fp-96
	  beqz $t0, _L26	# branch if _tmp213 is zero 
	# _tmp214 = "Decaf runtime error: Array subscript out of bound..."
	  .data			# create string constant marked with label
	  _string13: .asciiz "Decaf runtime error: Array subscript out of bounds\n"
	  .text
	  la $t2, _string13	# load label
	  sw $t2, -100($fp)	# spill _tmp214 from $t2 to $fp-100
	# PushParam _tmp214
	  subu $sp, $sp, 4	# decrement sp to make space for param
	  lw $t0, -100($fp)	# fill _tmp214 to $t0 from $fp-100
	  sw $t0, 4($sp)	# copy param value to stack
	# LCall _PrintString
	  jal _PrintString   	# jump to function
	# PopParams 4
	  add $sp, $sp, 4	# pop params off stack
	# LCall _Halt
	  jal _Halt          	# jump to function
  _L26:
	# _tmp215 = 4
	  li $t2, 4		# load constant value 4 into $t2
	  sw $t2, -104($fp)	# spill _tmp215 from $t2 to $fp-104
	# _tmp216 = i * _tmp215
	  lw $t0, -8($fp)	# fill i to $t0 from $fp-8
	  lw $t1, -104($fp)	# fill _tmp215 to $t1 from $fp-104
	  mul $t2, $t0, $t1	
	  sw $t2, -108($fp)	# spill _tmp216 from $t2 to $fp-108
	# _tmp217 = _tmp216 + _tmp215
	  lw $t0, -108($fp)	# fill _tmp216 to $t0 from $fp-108
	  lw $t1, -104($fp)	# fill _tmp215 to $t1 from $fp-104
	  add $t2, $t0, $t1	
	  sw $t2, -112($fp)	# spill _tmp217 from $t2 to $fp-112
	# _tmp218 = _tmp206 + _tmp217
	  lw $t0, -68($fp)	# fill _tmp206 to $t0 from $fp-68
	  lw $t1, -112($fp)	# fill _tmp217 to $t1 from $fp-112
	  add $t2, $t0, $t1	
	  sw $t2, -116($fp)	# spill _tmp218 from $t2 to $fp-116
	# *(_tmp218) = _tmp205
	  lw $t0, -64($fp)	# fill _tmp205 to $t0 from $fp-64
	  lw $t2, -116($fp)	# fill _tmp218 to $t2 from $fp-116
	  sw $t0, 0($t2) 	# store with offset
	# _tmp219 = *(_tmp218)
	  lw $t0, -116($fp)	# fill _tmp218 to $t0 from $fp-116
	  lw $t2, 0($t0) 	# load with offset
	  sw $t2, -120($fp)	# spill _tmp219 from $t2 to $fp-120
	# _tmp220 = 1
	  li $t2, 1		# load constant value 1 into $t2
	  sw $t2, -124($fp)	# spill _tmp220 from $t2 to $fp-124
	# _tmp221 = i + _tmp220
	  lw $t0, -8($fp)	# fill i to $t0 from $fp-8
	  lw $t1, -124($fp)	# fill _tmp220 to $t1 from $fp-124
	  add $t2, $t0, $t1	
	  sw $t2, -128($fp)	# spill _tmp221 from $t2 to $fp-128
	# i = _tmp221
	  lw $t2, -128($fp)	# fill _tmp221 to $t2 from $fp-128
	  sw $t2, -8($fp)	# spill i from $t2 to $fp-8
	# Goto _L24
	  b _L24		# unconditional branch
  _L25:
	# EndFunc
	# (below handles reaching end of fn body with no explicit return)
	  move $sp, $fp		# pop callee frame off stack
	  lw $ra, -4($fp)	# restore saved ra
	  lw $fp, 0($fp)	# restore saved fp
	  jr $ra		# return from function
  SparseMatrix.____Find:
	# BeginFunc 128
	  subu $sp, $sp, 8	# decrement sp to make space to save ra, fp
	  sw $fp, 8($sp)	# save fp
	  sw $ra, 4($sp)	# save ra
	  addiu $fp, $sp, 8	# set up new fp
	  subu $sp, $sp, 128	# decrement sp to make space for locals/temps
	# _tmp222 = *(this + 4)
	  lw $t0, 4($fp)	# fill this to $t0 from $fp+4
	  lw $t2, 4($t0) 	# load with offset
	  sw $t2, -12($fp)	# spill _tmp222 from $t2 to $fp-12
	# _tmp223 = 0
	  li $t2, 0		# load constant value 0 into $t2
	  sw $t2, -16($fp)	# spill _tmp223 from $t2 to $fp-16
	# _tmp224 = *(_tmp222)
	  lw $t0, -12($fp)	# fill _tmp222 to $t0 from $fp-12
	  lw $t2, 0($t0) 	# load with offset
	  sw $t2, -20($fp)	# spill _tmp224 from $t2 to $fp-20
	# _tmp225 = x < _tmp223
	  lw $t0, 8($fp)	# fill x to $t0 from $fp+8
	  lw $t1, -16($fp)	# fill _tmp223 to $t1 from $fp-16
	  slt $t2, $t0, $t1	
	  sw $t2, -24($fp)	# spill _tmp225 from $t2 to $fp-24
	# _tmp226 = _tmp224 < x
	  lw $t0, -20($fp)	# fill _tmp224 to $t0 from $fp-20
	  lw $t1, 8($fp)	# fill x to $t1 from $fp+8
	  slt $t2, $t0, $t1	
	  sw $t2, -28($fp)	# spill _tmp226 from $t2 to $fp-28
	# _tmp227 = _tmp224 == x
	  lw $t0, -20($fp)	# fill _tmp224 to $t0 from $fp-20
	  lw $t1, 8($fp)	# fill x to $t1 from $fp+8
	  seq $t2, $t0, $t1	
	  sw $t2, -32($fp)	# spill _tmp227 from $t2 to $fp-32
	# _tmp228 = _tmp226 || _tmp227
	  lw $t0, -28($fp)	# fill _tmp226 to $t0 from $fp-28
	  lw $t1, -32($fp)	# fill _tmp227 to $t1 from $fp-32
	  or $t2, $t0, $t1	
	  sw $t2, -36($fp)	# spill _tmp228 from $t2 to $fp-36
	# _tmp229 = _tmp228 || _tmp225
	  lw $t0, -36($fp)	# fill _tmp228 to $t0 from $fp-36
	  lw $t1, -24($fp)	# fill _tmp225 to $t1 from $fp-24
	  or $t2, $t0, $t1	
	  sw $t2, -40($fp)	# spill _tmp229 from $t2 to $fp-40
	# IfZ _tmp229 Goto _L27
	  lw $t0, -40($fp)	# fill _tmp229 to $t0 from $fp-40
	  beqz $t0, _L27	# branch if _tmp229 is zero 
	# _tmp230 = "Decaf runtime error: Array subscript out of bound..."
	  .data			# create string constant marked with label
	  _string14: .asciiz "Decaf runtime error: Array subscript out of bounds\n"
	  .text
	  la $t2, _string14	# load label
	  sw $t2, -44($fp)	# spill _tmp230 from $t2 to $fp-44
	# PushParam _tmp230
	  subu $sp, $sp, 4	# decrement sp to make space for param
	  lw $t0, -44($fp)	# fill _tmp230 to $t0 from $fp-44
	  sw $t0, 4($sp)	# copy param value to stack
	# LCall _PrintString
	  jal _PrintString   	# jump to function
	# PopParams 4
	  add $sp, $sp, 4	# pop params off stack
	# LCall _Halt
	  jal _Halt          	# jump to function
  _L27:
	# _tmp231 = 4
	  li $t2, 4		# load constant value 4 into $t2
	  sw $t2, -48($fp)	# spill _tmp231 from $t2 to $fp-48
	# _tmp232 = x * _tmp231
	  lw $t0, 8($fp)	# fill x to $t0 from $fp+8
	  lw $t1, -48($fp)	# fill _tmp231 to $t1 from $fp-48
	  mul $t2, $t0, $t1	
	  sw $t2, -52($fp)	# spill _tmp232 from $t2 to $fp-52
	# _tmp233 = _tmp232 + _tmp231
	  lw $t0, -52($fp)	# fill _tmp232 to $t0 from $fp-52
	  lw $t1, -48($fp)	# fill _tmp231 to $t1 from $fp-48
	  add $t2, $t0, $t1	
	  sw $t2, -56($fp)	# spill _tmp233 from $t2 to $fp-56
	# _tmp234 = _tmp222 + _tmp233
	  lw $t0, -12($fp)	# fill _tmp222 to $t0 from $fp-12
	  lw $t1, -56($fp)	# fill _tmp233 to $t1 from $fp-56
	  add $t2, $t0, $t1	
	  sw $t2, -60($fp)	# spill _tmp234 from $t2 to $fp-60
	# _tmp235 = *(_tmp234)
	  lw $t0, -60($fp)	# fill _tmp234 to $t0 from $fp-60
	  lw $t2, 0($t0) 	# load with offset
	  sw $t2, -64($fp)	# spill _tmp235 from $t2 to $fp-64
	# elem = _tmp235
	  lw $t2, -64($fp)	# fill _tmp235 to $t2 from $fp-64
	  sw $t2, -8($fp)	# spill elem from $t2 to $fp-8
  _L28:
	# _tmp237 = 0
	  li $t2, 0		# load constant value 0 into $t2
	  sw $t2, -72($fp)	# spill _tmp237 from $t2 to $fp-72
	# _tmp238 = elem == _tmp237
	  lw $t0, -8($fp)	# fill elem to $t0 from $fp-8
	  lw $t1, -72($fp)	# fill _tmp237 to $t1 from $fp-72
	  seq $t2, $t0, $t1	
	  sw $t2, -76($fp)	# spill _tmp238 from $t2 to $fp-76
	# IfZ _tmp238 Goto _L31
	  lw $t0, -76($fp)	# fill _tmp238 to $t0 from $fp-76
	  beqz $t0, _L31	# branch if _tmp238 is zero 
	# _tmp239 = 0
	  li $t2, 0		# load constant value 0 into $t2
	  sw $t2, -80($fp)	# spill _tmp239 from $t2 to $fp-80
	# _tmp236 = _tmp239
	  lw $t2, -80($fp)	# fill _tmp239 to $t2 from $fp-80
	  sw $t2, -68($fp)	# spill _tmp236 from $t2 to $fp-68
	# Goto _L30
	  b _L30		# unconditional branch
  _L31:
	# _tmp240 = 1
	  li $t2, 1		# load constant value 1 into $t2
	  sw $t2, -84($fp)	# spill _tmp240 from $t2 to $fp-84
	# _tmp236 = _tmp240
	  lw $t2, -84($fp)	# fill _tmp240 to $t2 from $fp-84
	  sw $t2, -68($fp)	# spill _tmp236 from $t2 to $fp-68
  _L30:
	# IfZ _tmp236 Goto _L29
	  lw $t0, -68($fp)	# fill _tmp236 to $t0 from $fp-68
	  beqz $t0, _L29	# branch if _tmp236 is zero 
	# PushParam elem
	  subu $sp, $sp, 4	# decrement sp to make space for param
	  lw $t0, -8($fp)	# fill elem to $t0 from $fp-8
	  sw $t0, 4($sp)	# copy param value to stack
	# _tmp241 = *(elem)
	  lw $t0, -8($fp)	# fill elem to $t0 from $fp-8
	  lw $t2, 0($t0) 	# load with offset
	  sw $t2, -88($fp)	# spill _tmp241 from $t2 to $fp-88
	# _tmp242 = *(_tmp241 + 8)
	  lw $t0, -88($fp)	# fill _tmp241 to $t0 from $fp-88
	  lw $t2, 8($t0) 	# load with offset
	  sw $t2, -92($fp)	# spill _tmp242 from $t2 to $fp-92
	# _tmp243 = ACall _tmp242
	  lw $t0, -92($fp)	# fill _tmp242 to $t0 from $fp-92
	  jalr $t0            	# jump to function
	  move $t2, $v0		# copy function return value from $v0
	  sw $t2, -96($fp)	# spill _tmp243 from $t2 to $fp-96
	# PopParams 4
	  add $sp, $sp, 4	# pop params off stack
	# _tmp244 = _tmp243 == y
	  lw $t0, -96($fp)	# fill _tmp243 to $t0 from $fp-96
	  lw $t1, 12($fp)	# fill y to $t1 from $fp+12
	  seq $t2, $t0, $t1	
	  sw $t2, -100($fp)	# spill _tmp244 from $t2 to $fp-100
	# IfZ _tmp244 Goto _L32
	  lw $t0, -100($fp)	# fill _tmp244 to $t0 from $fp-100
	  beqz $t0, _L32	# branch if _tmp244 is zero 
	# Return elem
	  lw $t2, -8($fp)	# fill elem to $t2 from $fp-8
	  move $v0, $t2		# assign return value into $v0
	  move $sp, $fp		# pop callee frame off stack
	  lw $ra, -4($fp)	# restore saved ra
	  lw $fp, 0($fp)	# restore saved fp
	  jr $ra		# return from function
	# Goto _L33
	  b _L33		# unconditional branch
  _L32:
  _L33:
	# PushParam elem
	  subu $sp, $sp, 4	# decrement sp to make space for param
	  lw $t0, -8($fp)	# fill elem to $t0 from $fp-8
	  sw $t0, 4($sp)	# copy param value to stack
	# _tmp245 = *(elem)
	  lw $t0, -8($fp)	# fill elem to $t0 from $fp-8
	  lw $t2, 0($t0) 	# load with offset
	  sw $t2, -104($fp)	# spill _tmp245 from $t2 to $fp-104
	# _tmp246 = *(_tmp245 + 4)
	  lw $t0, -104($fp)	# fill _tmp245 to $t0 from $fp-104
	  lw $t2, 4($t0) 	# load with offset
	  sw $t2, -108($fp)	# spill _tmp246 from $t2 to $fp-108
	# _tmp247 = ACall _tmp246
	  lw $t0, -108($fp)	# fill _tmp246 to $t0 from $fp-108
	  jalr $t0            	# jump to function
	  move $t2, $v0		# copy function return value from $v0
	  sw $t2, -112($fp)	# spill _tmp247 from $t2 to $fp-112
	# PopParams 4
	  add $sp, $sp, 4	# pop params off stack
	# elem = _tmp247
	  lw $t2, -112($fp)	# fill _tmp247 to $t2 from $fp-112
	  sw $t2, -8($fp)	# spill elem from $t2 to $fp-8
	# Goto _L28
	  b _L28		# unconditional branch
  _L29:
	# _tmp248 = 0
	  li $t2, 0		# load constant value 0 into $t2
	  sw $t2, -116($fp)	# spill _tmp248 from $t2 to $fp-116
	# Return _tmp248
	  lw $t2, -116($fp)	# fill _tmp248 to $t2 from $fp-116
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
  SparseMatrix.____Set:
	# BeginFunc 200
	  subu $sp, $sp, 8	# decrement sp to make space to save ra, fp
	  sw $fp, 8($sp)	# save fp
	  sw $ra, 4($sp)	# save ra
	  addiu $fp, $sp, 8	# set up new fp
	  subu $sp, $sp, 200	# decrement sp to make space for locals/temps
	# PushParam y
	  subu $sp, $sp, 4	# decrement sp to make space for param
	  lw $t0, 12($fp)	# fill y to $t0 from $fp+12
	  sw $t0, 4($sp)	# copy param value to stack
	# PushParam x
	  subu $sp, $sp, 4	# decrement sp to make space for param
	  lw $t0, 8($fp)	# fill x to $t0 from $fp+8
	  sw $t0, 4($sp)	# copy param value to stack
	# PushParam this
	  subu $sp, $sp, 4	# decrement sp to make space for param
	  lw $t0, 4($fp)	# fill this to $t0 from $fp+4
	  sw $t0, 4($sp)	# copy param value to stack
	# _tmp249 = *(this)
	  lw $t0, 4($fp)	# fill this to $t0 from $fp+4
	  lw $t2, 0($t0) 	# load with offset
	  sw $t2, -12($fp)	# spill _tmp249 from $t2 to $fp-12
	# _tmp250 = *(_tmp249 + 24)
	  lw $t0, -12($fp)	# fill _tmp249 to $t0 from $fp-12
	  lw $t2, 24($t0) 	# load with offset
	  sw $t2, -16($fp)	# spill _tmp250 from $t2 to $fp-16
	# _tmp251 = ACall _tmp250
	  lw $t0, -16($fp)	# fill _tmp250 to $t0 from $fp-16
	  jalr $t0            	# jump to function
	  move $t2, $v0		# copy function return value from $v0
	  sw $t2, -20($fp)	# spill _tmp251 from $t2 to $fp-20
	# PopParams 12
	  add $sp, $sp, 12	# pop params off stack
	# elem = _tmp251
	  lw $t2, -20($fp)	# fill _tmp251 to $t2 from $fp-20
	  sw $t2, -8($fp)	# spill elem from $t2 to $fp-8
	# _tmp253 = 0
	  li $t2, 0		# load constant value 0 into $t2
	  sw $t2, -28($fp)	# spill _tmp253 from $t2 to $fp-28
	# _tmp254 = elem == _tmp253
	  lw $t0, -8($fp)	# fill elem to $t0 from $fp-8
	  lw $t1, -28($fp)	# fill _tmp253 to $t1 from $fp-28
	  seq $t2, $t0, $t1	
	  sw $t2, -32($fp)	# spill _tmp254 from $t2 to $fp-32
	# IfZ _tmp254 Goto _L37
	  lw $t0, -32($fp)	# fill _tmp254 to $t0 from $fp-32
	  beqz $t0, _L37	# branch if _tmp254 is zero 
	# _tmp255 = 0
	  li $t2, 0		# load constant value 0 into $t2
	  sw $t2, -36($fp)	# spill _tmp255 from $t2 to $fp-36
	# _tmp252 = _tmp255
	  lw $t2, -36($fp)	# fill _tmp255 to $t2 from $fp-36
	  sw $t2, -24($fp)	# spill _tmp252 from $t2 to $fp-24
	# Goto _L36
	  b _L36		# unconditional branch
  _L37:
	# _tmp256 = 1
	  li $t2, 1		# load constant value 1 into $t2
	  sw $t2, -40($fp)	# spill _tmp256 from $t2 to $fp-40
	# _tmp252 = _tmp256
	  lw $t2, -40($fp)	# fill _tmp256 to $t2 from $fp-40
	  sw $t2, -24($fp)	# spill _tmp252 from $t2 to $fp-24
  _L36:
	# IfZ _tmp252 Goto _L34
	  lw $t0, -24($fp)	# fill _tmp252 to $t0 from $fp-24
	  beqz $t0, _L34	# branch if _tmp252 is zero 
	# PushParam value
	  subu $sp, $sp, 4	# decrement sp to make space for param
	  lw $t0, 16($fp)	# fill value to $t0 from $fp+16
	  sw $t0, 4($sp)	# copy param value to stack
	# PushParam elem
	  subu $sp, $sp, 4	# decrement sp to make space for param
	  lw $t0, -8($fp)	# fill elem to $t0 from $fp-8
	  sw $t0, 4($sp)	# copy param value to stack
	# _tmp257 = *(elem)
	  lw $t0, -8($fp)	# fill elem to $t0 from $fp-8
	  lw $t2, 0($t0) 	# load with offset
	  sw $t2, -44($fp)	# spill _tmp257 from $t2 to $fp-44
	# _tmp258 = *(_tmp257 + 16)
	  lw $t0, -44($fp)	# fill _tmp257 to $t0 from $fp-44
	  lw $t2, 16($t0) 	# load with offset
	  sw $t2, -48($fp)	# spill _tmp258 from $t2 to $fp-48
	# ACall _tmp258
	  lw $t0, -48($fp)	# fill _tmp258 to $t0 from $fp-48
	  jalr $t0            	# jump to function
	# PopParams 8
	  add $sp, $sp, 8	# pop params off stack
	# Goto _L35
	  b _L35		# unconditional branch
  _L34:
	# _tmp259 = 12
	  li $t2, 12		# load constant value 12 into $t2
	  sw $t2, -52($fp)	# spill _tmp259 from $t2 to $fp-52
	# _tmp260 = 4
	  li $t2, 4		# load constant value 4 into $t2
	  sw $t2, -56($fp)	# spill _tmp260 from $t2 to $fp-56
	# _tmp261 = _tmp260 + _tmp259
	  lw $t0, -56($fp)	# fill _tmp260 to $t0 from $fp-56
	  lw $t1, -52($fp)	# fill _tmp259 to $t1 from $fp-52
	  add $t2, $t0, $t1	
	  sw $t2, -60($fp)	# spill _tmp261 from $t2 to $fp-60
	# PushParam _tmp261
	  subu $sp, $sp, 4	# decrement sp to make space for param
	  lw $t0, -60($fp)	# fill _tmp261 to $t0 from $fp-60
	  sw $t0, 4($sp)	# copy param value to stack
	# _tmp262 = LCall _Alloc
	  jal _Alloc         	# jump to function
	  move $t2, $v0		# copy function return value from $v0
	  sw $t2, -64($fp)	# spill _tmp262 from $t2 to $fp-64
	# PopParams 4
	  add $sp, $sp, 4	# pop params off stack
	# _tmp263 = SparseItem
	  la $t2, SparseItem	# load label
	  sw $t2, -68($fp)	# spill _tmp263 from $t2 to $fp-68
	# *(_tmp262) = _tmp263
	  lw $t0, -68($fp)	# fill _tmp263 to $t0 from $fp-68
	  lw $t2, -64($fp)	# fill _tmp262 to $t2 from $fp-64
	  sw $t0, 0($t2) 	# store with offset
	# elem = _tmp262
	  lw $t2, -64($fp)	# fill _tmp262 to $t2 from $fp-64
	  sw $t2, -8($fp)	# spill elem from $t2 to $fp-8
	# _tmp264 = *(this + 4)
	  lw $t0, 4($fp)	# fill this to $t0 from $fp+4
	  lw $t2, 4($t0) 	# load with offset
	  sw $t2, -72($fp)	# spill _tmp264 from $t2 to $fp-72
	# _tmp265 = 0
	  li $t2, 0		# load constant value 0 into $t2
	  sw $t2, -76($fp)	# spill _tmp265 from $t2 to $fp-76
	# _tmp266 = *(_tmp264)
	  lw $t0, -72($fp)	# fill _tmp264 to $t0 from $fp-72
	  lw $t2, 0($t0) 	# load with offset
	  sw $t2, -80($fp)	# spill _tmp266 from $t2 to $fp-80
	# _tmp267 = x < _tmp265
	  lw $t0, 8($fp)	# fill x to $t0 from $fp+8
	  lw $t1, -76($fp)	# fill _tmp265 to $t1 from $fp-76
	  slt $t2, $t0, $t1	
	  sw $t2, -84($fp)	# spill _tmp267 from $t2 to $fp-84
	# _tmp268 = _tmp266 < x
	  lw $t0, -80($fp)	# fill _tmp266 to $t0 from $fp-80
	  lw $t1, 8($fp)	# fill x to $t1 from $fp+8
	  slt $t2, $t0, $t1	
	  sw $t2, -88($fp)	# spill _tmp268 from $t2 to $fp-88
	# _tmp269 = _tmp266 == x
	  lw $t0, -80($fp)	# fill _tmp266 to $t0 from $fp-80
	  lw $t1, 8($fp)	# fill x to $t1 from $fp+8
	  seq $t2, $t0, $t1	
	  sw $t2, -92($fp)	# spill _tmp269 from $t2 to $fp-92
	# _tmp270 = _tmp268 || _tmp269
	  lw $t0, -88($fp)	# fill _tmp268 to $t0 from $fp-88
	  lw $t1, -92($fp)	# fill _tmp269 to $t1 from $fp-92
	  or $t2, $t0, $t1	
	  sw $t2, -96($fp)	# spill _tmp270 from $t2 to $fp-96
	# _tmp271 = _tmp270 || _tmp267
	  lw $t0, -96($fp)	# fill _tmp270 to $t0 from $fp-96
	  lw $t1, -84($fp)	# fill _tmp267 to $t1 from $fp-84
	  or $t2, $t0, $t1	
	  sw $t2, -100($fp)	# spill _tmp271 from $t2 to $fp-100
	# IfZ _tmp271 Goto _L38
	  lw $t0, -100($fp)	# fill _tmp271 to $t0 from $fp-100
	  beqz $t0, _L38	# branch if _tmp271 is zero 
	# _tmp272 = "Decaf runtime error: Array subscript out of bound..."
	  .data			# create string constant marked with label
	  _string15: .asciiz "Decaf runtime error: Array subscript out of bounds\n"
	  .text
	  la $t2, _string15	# load label
	  sw $t2, -104($fp)	# spill _tmp272 from $t2 to $fp-104
	# PushParam _tmp272
	  subu $sp, $sp, 4	# decrement sp to make space for param
	  lw $t0, -104($fp)	# fill _tmp272 to $t0 from $fp-104
	  sw $t0, 4($sp)	# copy param value to stack
	# LCall _PrintString
	  jal _PrintString   	# jump to function
	# PopParams 4
	  add $sp, $sp, 4	# pop params off stack
	# LCall _Halt
	  jal _Halt          	# jump to function
  _L38:
	# _tmp273 = 4
	  li $t2, 4		# load constant value 4 into $t2
	  sw $t2, -108($fp)	# spill _tmp273 from $t2 to $fp-108
	# _tmp274 = x * _tmp273
	  lw $t0, 8($fp)	# fill x to $t0 from $fp+8
	  lw $t1, -108($fp)	# fill _tmp273 to $t1 from $fp-108
	  mul $t2, $t0, $t1	
	  sw $t2, -112($fp)	# spill _tmp274 from $t2 to $fp-112
	# _tmp275 = _tmp274 + _tmp273
	  lw $t0, -112($fp)	# fill _tmp274 to $t0 from $fp-112
	  lw $t1, -108($fp)	# fill _tmp273 to $t1 from $fp-108
	  add $t2, $t0, $t1	
	  sw $t2, -116($fp)	# spill _tmp275 from $t2 to $fp-116
	# _tmp276 = _tmp264 + _tmp275
	  lw $t0, -72($fp)	# fill _tmp264 to $t0 from $fp-72
	  lw $t1, -116($fp)	# fill _tmp275 to $t1 from $fp-116
	  add $t2, $t0, $t1	
	  sw $t2, -120($fp)	# spill _tmp276 from $t2 to $fp-120
	# _tmp277 = *(_tmp276)
	  lw $t0, -120($fp)	# fill _tmp276 to $t0 from $fp-120
	  lw $t2, 0($t0) 	# load with offset
	  sw $t2, -124($fp)	# spill _tmp277 from $t2 to $fp-124
	# PushParam _tmp277
	  subu $sp, $sp, 4	# decrement sp to make space for param
	  lw $t0, -124($fp)	# fill _tmp277 to $t0 from $fp-124
	  sw $t0, 4($sp)	# copy param value to stack
	# PushParam y
	  subu $sp, $sp, 4	# decrement sp to make space for param
	  lw $t0, 12($fp)	# fill y to $t0 from $fp+12
	  sw $t0, 4($sp)	# copy param value to stack
	# PushParam value
	  subu $sp, $sp, 4	# decrement sp to make space for param
	  lw $t0, 16($fp)	# fill value to $t0 from $fp+16
	  sw $t0, 4($sp)	# copy param value to stack
	# PushParam elem
	  subu $sp, $sp, 4	# decrement sp to make space for param
	  lw $t0, -8($fp)	# fill elem to $t0 from $fp-8
	  sw $t0, 4($sp)	# copy param value to stack
	# _tmp278 = *(elem)
	  lw $t0, -8($fp)	# fill elem to $t0 from $fp-8
	  lw $t2, 0($t0) 	# load with offset
	  sw $t2, -128($fp)	# spill _tmp278 from $t2 to $fp-128
	# _tmp279 = *(_tmp278)
	  lw $t0, -128($fp)	# fill _tmp278 to $t0 from $fp-128
	  lw $t2, 0($t0) 	# load with offset
	  sw $t2, -132($fp)	# spill _tmp279 from $t2 to $fp-132
	# ACall _tmp279
	  lw $t0, -132($fp)	# fill _tmp279 to $t0 from $fp-132
	  jalr $t0            	# jump to function
	# PopParams 16
	  add $sp, $sp, 16	# pop params off stack
	# _tmp280 = *(this + 4)
	  lw $t0, 4($fp)	# fill this to $t0 from $fp+4
	  lw $t2, 4($t0) 	# load with offset
	  sw $t2, -136($fp)	# spill _tmp280 from $t2 to $fp-136
	# _tmp281 = 0
	  li $t2, 0		# load constant value 0 into $t2
	  sw $t2, -140($fp)	# spill _tmp281 from $t2 to $fp-140
	# _tmp282 = *(_tmp280)
	  lw $t0, -136($fp)	# fill _tmp280 to $t0 from $fp-136
	  lw $t2, 0($t0) 	# load with offset
	  sw $t2, -144($fp)	# spill _tmp282 from $t2 to $fp-144
	# _tmp283 = x < _tmp281
	  lw $t0, 8($fp)	# fill x to $t0 from $fp+8
	  lw $t1, -140($fp)	# fill _tmp281 to $t1 from $fp-140
	  slt $t2, $t0, $t1	
	  sw $t2, -148($fp)	# spill _tmp283 from $t2 to $fp-148
	# _tmp284 = _tmp282 < x
	  lw $t0, -144($fp)	# fill _tmp282 to $t0 from $fp-144
	  lw $t1, 8($fp)	# fill x to $t1 from $fp+8
	  slt $t2, $t0, $t1	
	  sw $t2, -152($fp)	# spill _tmp284 from $t2 to $fp-152
	# _tmp285 = _tmp282 == x
	  lw $t0, -144($fp)	# fill _tmp282 to $t0 from $fp-144
	  lw $t1, 8($fp)	# fill x to $t1 from $fp+8
	  seq $t2, $t0, $t1	
	  sw $t2, -156($fp)	# spill _tmp285 from $t2 to $fp-156
	# _tmp286 = _tmp284 || _tmp285
	  lw $t0, -152($fp)	# fill _tmp284 to $t0 from $fp-152
	  lw $t1, -156($fp)	# fill _tmp285 to $t1 from $fp-156
	  or $t2, $t0, $t1	
	  sw $t2, -160($fp)	# spill _tmp286 from $t2 to $fp-160
	# _tmp287 = _tmp286 || _tmp283
	  lw $t0, -160($fp)	# fill _tmp286 to $t0 from $fp-160
	  lw $t1, -148($fp)	# fill _tmp283 to $t1 from $fp-148
	  or $t2, $t0, $t1	
	  sw $t2, -164($fp)	# spill _tmp287 from $t2 to $fp-164
	# IfZ _tmp287 Goto _L39
	  lw $t0, -164($fp)	# fill _tmp287 to $t0 from $fp-164
	  beqz $t0, _L39	# branch if _tmp287 is zero 
	# _tmp288 = "Decaf runtime error: Array subscript out of bound..."
	  .data			# create string constant marked with label
	  _string16: .asciiz "Decaf runtime error: Array subscript out of bounds\n"
	  .text
	  la $t2, _string16	# load label
	  sw $t2, -168($fp)	# spill _tmp288 from $t2 to $fp-168
	# PushParam _tmp288
	  subu $sp, $sp, 4	# decrement sp to make space for param
	  lw $t0, -168($fp)	# fill _tmp288 to $t0 from $fp-168
	  sw $t0, 4($sp)	# copy param value to stack
	# LCall _PrintString
	  jal _PrintString   	# jump to function
	# PopParams 4
	  add $sp, $sp, 4	# pop params off stack
	# LCall _Halt
	  jal _Halt          	# jump to function
  _L39:
	# _tmp289 = 4
	  li $t2, 4		# load constant value 4 into $t2
	  sw $t2, -172($fp)	# spill _tmp289 from $t2 to $fp-172
	# _tmp290 = x * _tmp289
	  lw $t0, 8($fp)	# fill x to $t0 from $fp+8
	  lw $t1, -172($fp)	# fill _tmp289 to $t1 from $fp-172
	  mul $t2, $t0, $t1	
	  sw $t2, -176($fp)	# spill _tmp290 from $t2 to $fp-176
	# _tmp291 = _tmp290 + _tmp289
	  lw $t0, -176($fp)	# fill _tmp290 to $t0 from $fp-176
	  lw $t1, -172($fp)	# fill _tmp289 to $t1 from $fp-172
	  add $t2, $t0, $t1	
	  sw $t2, -180($fp)	# spill _tmp291 from $t2 to $fp-180
	# _tmp292 = _tmp280 + _tmp291
	  lw $t0, -136($fp)	# fill _tmp280 to $t0 from $fp-136
	  lw $t1, -180($fp)	# fill _tmp291 to $t1 from $fp-180
	  add $t2, $t0, $t1	
	  sw $t2, -184($fp)	# spill _tmp292 from $t2 to $fp-184
	# *(_tmp292) = elem
	  lw $t0, -8($fp)	# fill elem to $t0 from $fp-8
	  lw $t2, -184($fp)	# fill _tmp292 to $t2 from $fp-184
	  sw $t0, 0($t2) 	# store with offset
	# _tmp293 = *(_tmp292)
	  lw $t0, -184($fp)	# fill _tmp292 to $t0 from $fp-184
	  lw $t2, 0($t0) 	# load with offset
	  sw $t2, -188($fp)	# spill _tmp293 from $t2 to $fp-188
  _L35:
	# EndFunc
	# (below handles reaching end of fn body with no explicit return)
	  move $sp, $fp		# pop callee frame off stack
	  lw $ra, -4($fp)	# restore saved ra
	  lw $fp, 0($fp)	# restore saved fp
	  jr $ra		# return from function
  SparseMatrix.____Get:
	# BeginFunc 60
	  subu $sp, $sp, 8	# decrement sp to make space to save ra, fp
	  sw $fp, 8($sp)	# save fp
	  sw $ra, 4($sp)	# save ra
	  addiu $fp, $sp, 8	# set up new fp
	  subu $sp, $sp, 60	# decrement sp to make space for locals/temps
	# PushParam y
	  subu $sp, $sp, 4	# decrement sp to make space for param
	  lw $t0, 12($fp)	# fill y to $t0 from $fp+12
	  sw $t0, 4($sp)	# copy param value to stack
	# PushParam x
	  subu $sp, $sp, 4	# decrement sp to make space for param
	  lw $t0, 8($fp)	# fill x to $t0 from $fp+8
	  sw $t0, 4($sp)	# copy param value to stack
	# PushParam this
	  subu $sp, $sp, 4	# decrement sp to make space for param
	  lw $t0, 4($fp)	# fill this to $t0 from $fp+4
	  sw $t0, 4($sp)	# copy param value to stack
	# _tmp294 = *(this)
	  lw $t0, 4($fp)	# fill this to $t0 from $fp+4
	  lw $t2, 0($t0) 	# load with offset
	  sw $t2, -12($fp)	# spill _tmp294 from $t2 to $fp-12
	# _tmp295 = *(_tmp294 + 24)
	  lw $t0, -12($fp)	# fill _tmp294 to $t0 from $fp-12
	  lw $t2, 24($t0) 	# load with offset
	  sw $t2, -16($fp)	# spill _tmp295 from $t2 to $fp-16
	# _tmp296 = ACall _tmp295
	  lw $t0, -16($fp)	# fill _tmp295 to $t0 from $fp-16
	  jalr $t0            	# jump to function
	  move $t2, $v0		# copy function return value from $v0
	  sw $t2, -20($fp)	# spill _tmp296 from $t2 to $fp-20
	# PopParams 12
	  add $sp, $sp, 12	# pop params off stack
	# elem = _tmp296
	  lw $t2, -20($fp)	# fill _tmp296 to $t2 from $fp-20
	  sw $t2, -8($fp)	# spill elem from $t2 to $fp-8
	# _tmp298 = 0
	  li $t2, 0		# load constant value 0 into $t2
	  sw $t2, -28($fp)	# spill _tmp298 from $t2 to $fp-28
	# _tmp299 = elem == _tmp298
	  lw $t0, -8($fp)	# fill elem to $t0 from $fp-8
	  lw $t1, -28($fp)	# fill _tmp298 to $t1 from $fp-28
	  seq $t2, $t0, $t1	
	  sw $t2, -32($fp)	# spill _tmp299 from $t2 to $fp-32
	# IfZ _tmp299 Goto _L43
	  lw $t0, -32($fp)	# fill _tmp299 to $t0 from $fp-32
	  beqz $t0, _L43	# branch if _tmp299 is zero 
	# _tmp300 = 0
	  li $t2, 0		# load constant value 0 into $t2
	  sw $t2, -36($fp)	# spill _tmp300 from $t2 to $fp-36
	# _tmp297 = _tmp300
	  lw $t2, -36($fp)	# fill _tmp300 to $t2 from $fp-36
	  sw $t2, -24($fp)	# spill _tmp297 from $t2 to $fp-24
	# Goto _L42
	  b _L42		# unconditional branch
  _L43:
	# _tmp301 = 1
	  li $t2, 1		# load constant value 1 into $t2
	  sw $t2, -40($fp)	# spill _tmp301 from $t2 to $fp-40
	# _tmp297 = _tmp301
	  lw $t2, -40($fp)	# fill _tmp301 to $t2 from $fp-40
	  sw $t2, -24($fp)	# spill _tmp297 from $t2 to $fp-24
  _L42:
	# IfZ _tmp297 Goto _L40
	  lw $t0, -24($fp)	# fill _tmp297 to $t0 from $fp-24
	  beqz $t0, _L40	# branch if _tmp297 is zero 
	# PushParam elem
	  subu $sp, $sp, 4	# decrement sp to make space for param
	  lw $t0, -8($fp)	# fill elem to $t0 from $fp-8
	  sw $t0, 4($sp)	# copy param value to stack
	# _tmp302 = *(elem)
	  lw $t0, -8($fp)	# fill elem to $t0 from $fp-8
	  lw $t2, 0($t0) 	# load with offset
	  sw $t2, -44($fp)	# spill _tmp302 from $t2 to $fp-44
	# _tmp303 = *(_tmp302 + 12)
	  lw $t0, -44($fp)	# fill _tmp302 to $t0 from $fp-44
	  lw $t2, 12($t0) 	# load with offset
	  sw $t2, -48($fp)	# spill _tmp303 from $t2 to $fp-48
	# _tmp304 = ACall _tmp303
	  lw $t0, -48($fp)	# fill _tmp303 to $t0 from $fp-48
	  jalr $t0            	# jump to function
	  move $t2, $v0		# copy function return value from $v0
	  sw $t2, -52($fp)	# spill _tmp304 from $t2 to $fp-52
	# PopParams 4
	  add $sp, $sp, 4	# pop params off stack
	# Return _tmp304
	  lw $t2, -52($fp)	# fill _tmp304 to $t2 from $fp-52
	  move $v0, $t2		# assign return value into $v0
	  move $sp, $fp		# pop callee frame off stack
	  lw $ra, -4($fp)	# restore saved ra
	  lw $fp, 0($fp)	# restore saved fp
	  jr $ra		# return from function
	# Goto _L41
	  b _L41		# unconditional branch
  _L40:
	# _tmp305 = 0
	  li $t2, 0		# load constant value 0 into $t2
	  sw $t2, -56($fp)	# spill _tmp305 from $t2 to $fp-56
	# Return _tmp305
	  lw $t2, -56($fp)	# fill _tmp305 to $t2 from $fp-56
	  move $v0, $t2		# assign return value into $v0
	  move $sp, $fp		# pop callee frame off stack
	  lw $ra, -4($fp)	# restore saved ra
	  lw $fp, 0($fp)	# restore saved fp
	  jr $ra		# return from function
  _L41:
	# EndFunc
	# (below handles reaching end of fn body with no explicit return)
	  move $sp, $fp		# pop callee frame off stack
	  lw $ra, -4($fp)	# restore saved ra
	  lw $fp, 0($fp)	# restore saved fp
	  jr $ra		# return from function
	# VTable for class SparseMatrix
	  .data
	  .align 2
	  SparseMatrix:		# label for class SparseMatrix vtable
	  .word SparseMatrix.____Init
	  .word SparseMatrix.____Set
	  .word SparseMatrix.____Get
	  .word Matrix.____PrintMatrix
	  .word Matrix.____SeedMatrix
	  .word SparseMatrix.____Init
	  .word SparseMatrix.____Find
	  .word SparseMatrix.____Set
	  .word SparseMatrix.____Get
	  .text
  main:
	# BeginFunc 124
	  subu $sp, $sp, 8	# decrement sp to make space to save ra, fp
	  sw $fp, 8($sp)	# save fp
	  sw $ra, 4($sp)	# save ra
	  addiu $fp, $sp, 8	# set up new fp
	  subu $sp, $sp, 124	# decrement sp to make space for locals/temps
	# _tmp306 = "Dense Rep \n"
	  .data			# create string constant marked with label
	  _string17: .asciiz "Dense Rep \n"
	  .text
	  la $t2, _string17	# load label
	  sw $t2, -12($fp)	# spill _tmp306 from $t2 to $fp-12
	# PushParam _tmp306
	  subu $sp, $sp, 4	# decrement sp to make space for param
	  lw $t0, -12($fp)	# fill _tmp306 to $t0 from $fp-12
	  sw $t0, 4($sp)	# copy param value to stack
	# LCall _PrintString
	  jal _PrintString   	# jump to function
	# PopParams 4
	  add $sp, $sp, 4	# pop params off stack
	# _tmp307 = 4
	  li $t2, 4		# load constant value 4 into $t2
	  sw $t2, -16($fp)	# spill _tmp307 from $t2 to $fp-16
	# _tmp308 = 4
	  li $t2, 4		# load constant value 4 into $t2
	  sw $t2, -20($fp)	# spill _tmp308 from $t2 to $fp-20
	# _tmp309 = _tmp308 + _tmp307
	  lw $t0, -20($fp)	# fill _tmp308 to $t0 from $fp-20
	  lw $t1, -16($fp)	# fill _tmp307 to $t1 from $fp-16
	  add $t2, $t0, $t1	
	  sw $t2, -24($fp)	# spill _tmp309 from $t2 to $fp-24
	# PushParam _tmp309
	  subu $sp, $sp, 4	# decrement sp to make space for param
	  lw $t0, -24($fp)	# fill _tmp309 to $t0 from $fp-24
	  sw $t0, 4($sp)	# copy param value to stack
	# _tmp310 = LCall _Alloc
	  jal _Alloc         	# jump to function
	  move $t2, $v0		# copy function return value from $v0
	  sw $t2, -28($fp)	# spill _tmp310 from $t2 to $fp-28
	# PopParams 4
	  add $sp, $sp, 4	# pop params off stack
	# _tmp311 = DenseMatrix
	  la $t2, DenseMatrix	# load label
	  sw $t2, -32($fp)	# spill _tmp311 from $t2 to $fp-32
	# *(_tmp310) = _tmp311
	  lw $t0, -32($fp)	# fill _tmp311 to $t0 from $fp-32
	  lw $t2, -28($fp)	# fill _tmp310 to $t2 from $fp-28
	  sw $t0, 0($t2) 	# store with offset
	# m = _tmp310
	  lw $t2, -28($fp)	# fill _tmp310 to $t2 from $fp-28
	  sw $t2, -8($fp)	# spill m from $t2 to $fp-8
	# PushParam m
	  subu $sp, $sp, 4	# decrement sp to make space for param
	  lw $t0, -8($fp)	# fill m to $t0 from $fp-8
	  sw $t0, 4($sp)	# copy param value to stack
	# _tmp312 = *(m)
	  lw $t0, -8($fp)	# fill m to $t0 from $fp-8
	  lw $t2, 0($t0) 	# load with offset
	  sw $t2, -36($fp)	# spill _tmp312 from $t2 to $fp-36
	# _tmp313 = *(_tmp312)
	  lw $t0, -36($fp)	# fill _tmp312 to $t0 from $fp-36
	  lw $t2, 0($t0) 	# load with offset
	  sw $t2, -40($fp)	# spill _tmp313 from $t2 to $fp-40
	# ACall _tmp313
	  lw $t0, -40($fp)	# fill _tmp313 to $t0 from $fp-40
	  jalr $t0            	# jump to function
	# PopParams 4
	  add $sp, $sp, 4	# pop params off stack
	# PushParam m
	  subu $sp, $sp, 4	# decrement sp to make space for param
	  lw $t0, -8($fp)	# fill m to $t0 from $fp-8
	  sw $t0, 4($sp)	# copy param value to stack
	# _tmp314 = *(m)
	  lw $t0, -8($fp)	# fill m to $t0 from $fp-8
	  lw $t2, 0($t0) 	# load with offset
	  sw $t2, -44($fp)	# spill _tmp314 from $t2 to $fp-44
	# _tmp315 = *(_tmp314 + 16)
	  lw $t0, -44($fp)	# fill _tmp314 to $t0 from $fp-44
	  lw $t2, 16($t0) 	# load with offset
	  sw $t2, -48($fp)	# spill _tmp315 from $t2 to $fp-48
	# ACall _tmp315
	  lw $t0, -48($fp)	# fill _tmp315 to $t0 from $fp-48
	  jalr $t0            	# jump to function
	# PopParams 4
	  add $sp, $sp, 4	# pop params off stack
	# PushParam m
	  subu $sp, $sp, 4	# decrement sp to make space for param
	  lw $t0, -8($fp)	# fill m to $t0 from $fp-8
	  sw $t0, 4($sp)	# copy param value to stack
	# _tmp316 = *(m)
	  lw $t0, -8($fp)	# fill m to $t0 from $fp-8
	  lw $t2, 0($t0) 	# load with offset
	  sw $t2, -52($fp)	# spill _tmp316 from $t2 to $fp-52
	# _tmp317 = *(_tmp316 + 12)
	  lw $t0, -52($fp)	# fill _tmp316 to $t0 from $fp-52
	  lw $t2, 12($t0) 	# load with offset
	  sw $t2, -56($fp)	# spill _tmp317 from $t2 to $fp-56
	# ACall _tmp317
	  lw $t0, -56($fp)	# fill _tmp317 to $t0 from $fp-56
	  jalr $t0            	# jump to function
	# PopParams 4
	  add $sp, $sp, 4	# pop params off stack
	# _tmp318 = "Sparse Rep \n"
	  .data			# create string constant marked with label
	  _string18: .asciiz "Sparse Rep \n"
	  .text
	  la $t2, _string18	# load label
	  sw $t2, -60($fp)	# spill _tmp318 from $t2 to $fp-60
	# PushParam _tmp318
	  subu $sp, $sp, 4	# decrement sp to make space for param
	  lw $t0, -60($fp)	# fill _tmp318 to $t0 from $fp-60
	  sw $t0, 4($sp)	# copy param value to stack
	# LCall _PrintString
	  jal _PrintString   	# jump to function
	# PopParams 4
	  add $sp, $sp, 4	# pop params off stack
	# _tmp319 = 4
	  li $t2, 4		# load constant value 4 into $t2
	  sw $t2, -64($fp)	# spill _tmp319 from $t2 to $fp-64
	# _tmp320 = 4
	  li $t2, 4		# load constant value 4 into $t2
	  sw $t2, -68($fp)	# spill _tmp320 from $t2 to $fp-68
	# _tmp321 = _tmp320 + _tmp319
	  lw $t0, -68($fp)	# fill _tmp320 to $t0 from $fp-68
	  lw $t1, -64($fp)	# fill _tmp319 to $t1 from $fp-64
	  add $t2, $t0, $t1	
	  sw $t2, -72($fp)	# spill _tmp321 from $t2 to $fp-72
	# PushParam _tmp321
	  subu $sp, $sp, 4	# decrement sp to make space for param
	  lw $t0, -72($fp)	# fill _tmp321 to $t0 from $fp-72
	  sw $t0, 4($sp)	# copy param value to stack
	# _tmp322 = LCall _Alloc
	  jal _Alloc         	# jump to function
	  move $t2, $v0		# copy function return value from $v0
	  sw $t2, -76($fp)	# spill _tmp322 from $t2 to $fp-76
	# PopParams 4
	  add $sp, $sp, 4	# pop params off stack
	# _tmp323 = SparseMatrix
	  la $t2, SparseMatrix	# load label
	  sw $t2, -80($fp)	# spill _tmp323 from $t2 to $fp-80
	# *(_tmp322) = _tmp323
	  lw $t0, -80($fp)	# fill _tmp323 to $t0 from $fp-80
	  lw $t2, -76($fp)	# fill _tmp322 to $t2 from $fp-76
	  sw $t0, 0($t2) 	# store with offset
	# m = _tmp322
	  lw $t2, -76($fp)	# fill _tmp322 to $t2 from $fp-76
	  sw $t2, -8($fp)	# spill m from $t2 to $fp-8
	# PushParam m
	  subu $sp, $sp, 4	# decrement sp to make space for param
	  lw $t0, -8($fp)	# fill m to $t0 from $fp-8
	  sw $t0, 4($sp)	# copy param value to stack
	# _tmp324 = *(m)
	  lw $t0, -8($fp)	# fill m to $t0 from $fp-8
	  lw $t2, 0($t0) 	# load with offset
	  sw $t2, -84($fp)	# spill _tmp324 from $t2 to $fp-84
	# _tmp325 = *(_tmp324)
	  lw $t0, -84($fp)	# fill _tmp324 to $t0 from $fp-84
	  lw $t2, 0($t0) 	# load with offset
	  sw $t2, -88($fp)	# spill _tmp325 from $t2 to $fp-88
	# ACall _tmp325
	  lw $t0, -88($fp)	# fill _tmp325 to $t0 from $fp-88
	  jalr $t0            	# jump to function
	# PopParams 4
	  add $sp, $sp, 4	# pop params off stack
	# PushParam m
	  subu $sp, $sp, 4	# decrement sp to make space for param
	  lw $t0, -8($fp)	# fill m to $t0 from $fp-8
	  sw $t0, 4($sp)	# copy param value to stack
	# _tmp326 = *(m)
	  lw $t0, -8($fp)	# fill m to $t0 from $fp-8
	  lw $t2, 0($t0) 	# load with offset
	  sw $t2, -92($fp)	# spill _tmp326 from $t2 to $fp-92
	# _tmp327 = *(_tmp326 + 16)
	  lw $t0, -92($fp)	# fill _tmp326 to $t0 from $fp-92
	  lw $t2, 16($t0) 	# load with offset
	  sw $t2, -96($fp)	# spill _tmp327 from $t2 to $fp-96
	# ACall _tmp327
	  lw $t0, -96($fp)	# fill _tmp327 to $t0 from $fp-96
	  jalr $t0            	# jump to function
	# PopParams 4
	  add $sp, $sp, 4	# pop params off stack
	# PushParam m
	  subu $sp, $sp, 4	# decrement sp to make space for param
	  lw $t0, -8($fp)	# fill m to $t0 from $fp-8
	  sw $t0, 4($sp)	# copy param value to stack
	# _tmp328 = *(m)
	  lw $t0, -8($fp)	# fill m to $t0 from $fp-8
	  lw $t2, 0($t0) 	# load with offset
	  sw $t2, -100($fp)	# spill _tmp328 from $t2 to $fp-100
	# _tmp329 = *(_tmp328 + 12)
	  lw $t0, -100($fp)	# fill _tmp328 to $t0 from $fp-100
	  lw $t2, 12($t0) 	# load with offset
	  sw $t2, -104($fp)	# spill _tmp329 from $t2 to $fp-104
	# ACall _tmp329
	  lw $t0, -104($fp)	# fill _tmp329 to $t0 from $fp-104
	  jalr $t0            	# jump to function
	# PopParams 4
	  add $sp, $sp, 4	# pop params off stack
	# EndFunc
	# (below handles reaching end of fn body with no explicit return)
	  move $sp, $fp		# pop callee frame off stack
	  lw $ra, -4($fp)	# restore saved ra
	  lw $fp, 0($fp)	# restore saved fp
	  jr $ra		# return from function
