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
	  
  Random.____Init:
	# BeginFunc 0
	  subu $sp, $sp, 8	# decrement sp to make space to save ra, fp
	  sw $fp, 8($sp)	# save fp
	  sw $ra, 4($sp)	# save ra
	  addiu $fp, $sp, 8	# set up new fp
	# *(this + 4) = seedVal
	  lw $t0, 8($fp)	# fill seedVal to $t0 from $fp+8
	  lw $t2, 4($fp)	# fill this to $t2 from $fp+4
	  sw $t0, 4($t2) 	# store with offset
	# EndFunc
	# (below handles reaching end of fn body with no explicit return)
	  move $sp, $fp		# pop callee frame off stack
	  lw $ra, -4($fp)	# restore saved ra
	  lw $fp, 0($fp)	# restore saved fp
	  jr $ra		# return from function
  Random.____GenRandom:
	# BeginFunc 40
	  subu $sp, $sp, 8	# decrement sp to make space to save ra, fp
	  sw $fp, 8($sp)	# save fp
	  sw $ra, 4($sp)	# save ra
	  addiu $fp, $sp, 8	# set up new fp
	  subu $sp, $sp, 40	# decrement sp to make space for locals/temps
	# _tmp0 = 15625
	  li $t2, 15625		# load constant value 15625 into $t2
	  sw $t2, -8($fp)	# spill _tmp0 from $t2 to $fp-8
	# _tmp1 = *(this + 4)
	  lw $t0, 4($fp)	# fill this to $t0 from $fp+4
	  lw $t2, 4($t0) 	# load with offset
	  sw $t2, -12($fp)	# spill _tmp1 from $t2 to $fp-12
	# _tmp2 = 10000
	  li $t2, 10000		# load constant value 10000 into $t2
	  sw $t2, -16($fp)	# spill _tmp2 from $t2 to $fp-16
	# _tmp3 = _tmp1 % _tmp2
	  lw $t0, -12($fp)	# fill _tmp1 to $t0 from $fp-12
	  lw $t1, -16($fp)	# fill _tmp2 to $t1 from $fp-16
	  rem $t2, $t0, $t1	
	  sw $t2, -20($fp)	# spill _tmp3 from $t2 to $fp-20
	# _tmp4 = _tmp0 * _tmp3
	  lw $t0, -8($fp)	# fill _tmp0 to $t0 from $fp-8
	  lw $t1, -20($fp)	# fill _tmp3 to $t1 from $fp-20
	  mul $t2, $t0, $t1	
	  sw $t2, -24($fp)	# spill _tmp4 from $t2 to $fp-24
	# _tmp5 = 22221
	  li $t2, 22221		# load constant value 22221 into $t2
	  sw $t2, -28($fp)	# spill _tmp5 from $t2 to $fp-28
	# _tmp6 = _tmp4 + _tmp5
	  lw $t0, -24($fp)	# fill _tmp4 to $t0 from $fp-24
	  lw $t1, -28($fp)	# fill _tmp5 to $t1 from $fp-28
	  add $t2, $t0, $t1	
	  sw $t2, -32($fp)	# spill _tmp6 from $t2 to $fp-32
	# _tmp7 = 65536
	  li $t2, 65536		# load constant value 65536 into $t2
	  sw $t2, -36($fp)	# spill _tmp7 from $t2 to $fp-36
	# _tmp8 = _tmp6 % _tmp7
	  lw $t0, -32($fp)	# fill _tmp6 to $t0 from $fp-32
	  lw $t1, -36($fp)	# fill _tmp7 to $t1 from $fp-36
	  rem $t2, $t0, $t1	
	  sw $t2, -40($fp)	# spill _tmp8 from $t2 to $fp-40
	# *(this + 4) = _tmp8
	  lw $t0, -40($fp)	# fill _tmp8 to $t0 from $fp-40
	  lw $t2, 4($fp)	# fill this to $t2 from $fp+4
	  sw $t0, 4($t2) 	# store with offset
	# _tmp9 = *(this + 4)
	  lw $t0, 4($fp)	# fill this to $t0 from $fp+4
	  lw $t2, 4($t0) 	# load with offset
	  sw $t2, -44($fp)	# spill _tmp9 from $t2 to $fp-44
	# Return _tmp9
	  lw $t2, -44($fp)	# fill _tmp9 to $t2 from $fp-44
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
  Random.____RndInt:
	# BeginFunc 16
	  subu $sp, $sp, 8	# decrement sp to make space to save ra, fp
	  sw $fp, 8($sp)	# save fp
	  sw $ra, 4($sp)	# save ra
	  addiu $fp, $sp, 8	# set up new fp
	  subu $sp, $sp, 16	# decrement sp to make space for locals/temps
	# PushParam this
	  subu $sp, $sp, 4	# decrement sp to make space for param
	  lw $t0, 4($fp)	# fill this to $t0 from $fp+4
	  sw $t0, 4($sp)	# copy param value to stack
	# _tmp10 = *(this)
	  lw $t0, 4($fp)	# fill this to $t0 from $fp+4
	  lw $t2, 0($t0) 	# load with offset
	  sw $t2, -8($fp)	# spill _tmp10 from $t2 to $fp-8
	# _tmp11 = *(_tmp10 + 4)
	  lw $t0, -8($fp)	# fill _tmp10 to $t0 from $fp-8
	  lw $t2, 4($t0) 	# load with offset
	  sw $t2, -12($fp)	# spill _tmp11 from $t2 to $fp-12
	# _tmp12 = ACall _tmp11
	  lw $t0, -12($fp)	# fill _tmp11 to $t0 from $fp-12
	  jalr $t0            	# jump to function
	  move $t2, $v0		# copy function return value from $v0
	  sw $t2, -16($fp)	# spill _tmp12 from $t2 to $fp-16
	# PopParams 4
	  add $sp, $sp, 4	# pop params off stack
	# _tmp13 = _tmp12 % max
	  lw $t0, -16($fp)	# fill _tmp12 to $t0 from $fp-16
	  lw $t1, 8($fp)	# fill max to $t1 from $fp+8
	  rem $t2, $t0, $t1	
	  sw $t2, -20($fp)	# spill _tmp13 from $t2 to $fp-20
	# Return _tmp13
	  lw $t2, -20($fp)	# fill _tmp13 to $t2 from $fp-20
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
	# VTable for class Random
	  .data
	  .align 2
	  Random:		# label for class Random vtable
	  .word Random.____Init
	  .word Random.____GenRandom
	  .word Random.____RndInt
	  .text
  Deck.____Init:
	# BeginFunc 40
	  subu $sp, $sp, 8	# decrement sp to make space to save ra, fp
	  sw $fp, 8($sp)	# save fp
	  sw $ra, 4($sp)	# save ra
	  addiu $fp, $sp, 8	# set up new fp
	  subu $sp, $sp, 40	# decrement sp to make space for locals/temps
	# _tmp14 = 52
	  li $t2, 52		# load constant value 52 into $t2
	  sw $t2, -8($fp)	# spill _tmp14 from $t2 to $fp-8
	# _tmp15 = 4
	  li $t2, 4		# load constant value 4 into $t2
	  sw $t2, -12($fp)	# spill _tmp15 from $t2 to $fp-12
	# _tmp16 = 0
	  li $t2, 0		# load constant value 0 into $t2
	  sw $t2, -16($fp)	# spill _tmp16 from $t2 to $fp-16
	# _tmp17 = _tmp14 < _tmp16
	  lw $t0, -8($fp)	# fill _tmp14 to $t0 from $fp-8
	  lw $t1, -16($fp)	# fill _tmp16 to $t1 from $fp-16
	  slt $t2, $t0, $t1	
	  sw $t2, -20($fp)	# spill _tmp17 from $t2 to $fp-20
	# _tmp18 = _tmp14 == _tmp16
	  lw $t0, -8($fp)	# fill _tmp14 to $t0 from $fp-8
	  lw $t1, -16($fp)	# fill _tmp16 to $t1 from $fp-16
	  seq $t2, $t0, $t1	
	  sw $t2, -24($fp)	# spill _tmp18 from $t2 to $fp-24
	# _tmp19 = _tmp17 || _tmp18
	  lw $t0, -20($fp)	# fill _tmp17 to $t0 from $fp-20
	  lw $t1, -24($fp)	# fill _tmp18 to $t1 from $fp-24
	  or $t2, $t0, $t1	
	  sw $t2, -28($fp)	# spill _tmp19 from $t2 to $fp-28
	# IfZ _tmp19 Goto _L0
	  lw $t0, -28($fp)	# fill _tmp19 to $t0 from $fp-28
	  beqz $t0, _L0	# branch if _tmp19 is zero 
	# _tmp20 = "Decaf runtime error: Array size is <= 0\n"
	  .data			# create string constant marked with label
	  _string1: .asciiz "Decaf runtime error: Array size is <= 0\n"
	  .text
	  la $t2, _string1	# load label
	  sw $t2, -32($fp)	# spill _tmp20 from $t2 to $fp-32
	# PushParam _tmp20
	  subu $sp, $sp, 4	# decrement sp to make space for param
	  lw $t0, -32($fp)	# fill _tmp20 to $t0 from $fp-32
	  sw $t0, 4($sp)	# copy param value to stack
	# LCall _PrintString
	  jal _PrintString   	# jump to function
	# PopParams 4
	  add $sp, $sp, 4	# pop params off stack
	# LCall _Halt
	  jal _Halt          	# jump to function
  _L0:
	# _tmp21 = _tmp14 * _tmp15
	  lw $t0, -8($fp)	# fill _tmp14 to $t0 from $fp-8
	  lw $t1, -12($fp)	# fill _tmp15 to $t1 from $fp-12
	  mul $t2, $t0, $t1	
	  sw $t2, -36($fp)	# spill _tmp21 from $t2 to $fp-36
	# _tmp22 = _tmp15 + _tmp21
	  lw $t0, -12($fp)	# fill _tmp15 to $t0 from $fp-12
	  lw $t1, -36($fp)	# fill _tmp21 to $t1 from $fp-36
	  add $t2, $t0, $t1	
	  sw $t2, -40($fp)	# spill _tmp22 from $t2 to $fp-40
	# PushParam _tmp22
	  subu $sp, $sp, 4	# decrement sp to make space for param
	  lw $t0, -40($fp)	# fill _tmp22 to $t0 from $fp-40
	  sw $t0, 4($sp)	# copy param value to stack
	# _tmp23 = LCall _Alloc
	  jal _Alloc         	# jump to function
	  move $t2, $v0		# copy function return value from $v0
	  sw $t2, -44($fp)	# spill _tmp23 from $t2 to $fp-44
	# PopParams 4
	  add $sp, $sp, 4	# pop params off stack
	# *(_tmp23) = _tmp14
	  lw $t0, -8($fp)	# fill _tmp14 to $t0 from $fp-8
	  lw $t2, -44($fp)	# fill _tmp23 to $t2 from $fp-44
	  sw $t0, 0($t2) 	# store with offset
	# *(this + 8) = _tmp23
	  lw $t0, -44($fp)	# fill _tmp23 to $t0 from $fp-44
	  lw $t2, 4($fp)	# fill this to $t2 from $fp+4
	  sw $t0, 8($t2) 	# store with offset
	# EndFunc
	# (below handles reaching end of fn body with no explicit return)
	  move $sp, $fp		# pop callee frame off stack
	  lw $ra, -4($fp)	# restore saved ra
	  lw $fp, 0($fp)	# restore saved fp
	  jr $ra		# return from function
  Deck.____Shuffle:
	# BeginFunc 400
	  subu $sp, $sp, 8	# decrement sp to make space to save ra, fp
	  sw $fp, 8($sp)	# save fp
	  sw $ra, 4($sp)	# save ra
	  addiu $fp, $sp, 8	# set up new fp
	  subu $sp, $sp, 400	# decrement sp to make space for locals/temps
	# _tmp24 = 0
	  li $t2, 0		# load constant value 0 into $t2
	  sw $t2, -8($fp)	# spill _tmp24 from $t2 to $fp-8
	# *(this + 4) = _tmp24
	  lw $t0, -8($fp)	# fill _tmp24 to $t0 from $fp-8
	  lw $t2, 4($fp)	# fill this to $t2 from $fp+4
	  sw $t0, 4($t2) 	# store with offset
  _L1:
	# _tmp25 = *(this + 4)
	  lw $t0, 4($fp)	# fill this to $t0 from $fp+4
	  lw $t2, 4($t0) 	# load with offset
	  sw $t2, -12($fp)	# spill _tmp25 from $t2 to $fp-12
	# _tmp26 = 52
	  li $t2, 52		# load constant value 52 into $t2
	  sw $t2, -16($fp)	# spill _tmp26 from $t2 to $fp-16
	# _tmp27 = _tmp25 < _tmp26
	  lw $t0, -12($fp)	# fill _tmp25 to $t0 from $fp-12
	  lw $t1, -16($fp)	# fill _tmp26 to $t1 from $fp-16
	  slt $t2, $t0, $t1	
	  sw $t2, -20($fp)	# spill _tmp27 from $t2 to $fp-20
	# IfZ _tmp27 Goto _L2
	  lw $t0, -20($fp)	# fill _tmp27 to $t0 from $fp-20
	  beqz $t0, _L2	# branch if _tmp27 is zero 
	# _tmp28 = *(this + 4)
	  lw $t0, 4($fp)	# fill this to $t0 from $fp+4
	  lw $t2, 4($t0) 	# load with offset
	  sw $t2, -24($fp)	# spill _tmp28 from $t2 to $fp-24
	# _tmp29 = 1
	  li $t2, 1		# load constant value 1 into $t2
	  sw $t2, -28($fp)	# spill _tmp29 from $t2 to $fp-28
	# _tmp30 = _tmp28 + _tmp29
	  lw $t0, -24($fp)	# fill _tmp28 to $t0 from $fp-24
	  lw $t1, -28($fp)	# fill _tmp29 to $t1 from $fp-28
	  add $t2, $t0, $t1	
	  sw $t2, -32($fp)	# spill _tmp30 from $t2 to $fp-32
	# _tmp31 = 13
	  li $t2, 13		# load constant value 13 into $t2
	  sw $t2, -36($fp)	# spill _tmp31 from $t2 to $fp-36
	# _tmp32 = _tmp30 % _tmp31
	  lw $t0, -32($fp)	# fill _tmp30 to $t0 from $fp-32
	  lw $t1, -36($fp)	# fill _tmp31 to $t1 from $fp-36
	  rem $t2, $t0, $t1	
	  sw $t2, -40($fp)	# spill _tmp32 from $t2 to $fp-40
	# _tmp33 = *(this + 8)
	  lw $t0, 4($fp)	# fill this to $t0 from $fp+4
	  lw $t2, 8($t0) 	# load with offset
	  sw $t2, -44($fp)	# spill _tmp33 from $t2 to $fp-44
	# _tmp34 = *(this + 4)
	  lw $t0, 4($fp)	# fill this to $t0 from $fp+4
	  lw $t2, 4($t0) 	# load with offset
	  sw $t2, -48($fp)	# spill _tmp34 from $t2 to $fp-48
	# _tmp35 = 0
	  li $t2, 0		# load constant value 0 into $t2
	  sw $t2, -52($fp)	# spill _tmp35 from $t2 to $fp-52
	# _tmp36 = *(_tmp33)
	  lw $t0, -44($fp)	# fill _tmp33 to $t0 from $fp-44
	  lw $t2, 0($t0) 	# load with offset
	  sw $t2, -56($fp)	# spill _tmp36 from $t2 to $fp-56
	# _tmp37 = _tmp34 < _tmp35
	  lw $t0, -48($fp)	# fill _tmp34 to $t0 from $fp-48
	  lw $t1, -52($fp)	# fill _tmp35 to $t1 from $fp-52
	  slt $t2, $t0, $t1	
	  sw $t2, -60($fp)	# spill _tmp37 from $t2 to $fp-60
	# _tmp38 = _tmp36 < _tmp34
	  lw $t0, -56($fp)	# fill _tmp36 to $t0 from $fp-56
	  lw $t1, -48($fp)	# fill _tmp34 to $t1 from $fp-48
	  slt $t2, $t0, $t1	
	  sw $t2, -64($fp)	# spill _tmp38 from $t2 to $fp-64
	# _tmp39 = _tmp36 == _tmp34
	  lw $t0, -56($fp)	# fill _tmp36 to $t0 from $fp-56
	  lw $t1, -48($fp)	# fill _tmp34 to $t1 from $fp-48
	  seq $t2, $t0, $t1	
	  sw $t2, -68($fp)	# spill _tmp39 from $t2 to $fp-68
	# _tmp40 = _tmp38 || _tmp39
	  lw $t0, -64($fp)	# fill _tmp38 to $t0 from $fp-64
	  lw $t1, -68($fp)	# fill _tmp39 to $t1 from $fp-68
	  or $t2, $t0, $t1	
	  sw $t2, -72($fp)	# spill _tmp40 from $t2 to $fp-72
	# _tmp41 = _tmp40 || _tmp37
	  lw $t0, -72($fp)	# fill _tmp40 to $t0 from $fp-72
	  lw $t1, -60($fp)	# fill _tmp37 to $t1 from $fp-60
	  or $t2, $t0, $t1	
	  sw $t2, -76($fp)	# spill _tmp41 from $t2 to $fp-76
	# IfZ _tmp41 Goto _L3
	  lw $t0, -76($fp)	# fill _tmp41 to $t0 from $fp-76
	  beqz $t0, _L3	# branch if _tmp41 is zero 
	# _tmp42 = "Decaf runtime error: Array subscript out of bound..."
	  .data			# create string constant marked with label
	  _string2: .asciiz "Decaf runtime error: Array subscript out of bounds\n"
	  .text
	  la $t2, _string2	# load label
	  sw $t2, -80($fp)	# spill _tmp42 from $t2 to $fp-80
	# PushParam _tmp42
	  subu $sp, $sp, 4	# decrement sp to make space for param
	  lw $t0, -80($fp)	# fill _tmp42 to $t0 from $fp-80
	  sw $t0, 4($sp)	# copy param value to stack
	# LCall _PrintString
	  jal _PrintString   	# jump to function
	# PopParams 4
	  add $sp, $sp, 4	# pop params off stack
	# LCall _Halt
	  jal _Halt          	# jump to function
  _L3:
	# _tmp43 = 4
	  li $t2, 4		# load constant value 4 into $t2
	  sw $t2, -84($fp)	# spill _tmp43 from $t2 to $fp-84
	# _tmp44 = _tmp34 * _tmp43
	  lw $t0, -48($fp)	# fill _tmp34 to $t0 from $fp-48
	  lw $t1, -84($fp)	# fill _tmp43 to $t1 from $fp-84
	  mul $t2, $t0, $t1	
	  sw $t2, -88($fp)	# spill _tmp44 from $t2 to $fp-88
	# _tmp45 = _tmp44 + _tmp43
	  lw $t0, -88($fp)	# fill _tmp44 to $t0 from $fp-88
	  lw $t1, -84($fp)	# fill _tmp43 to $t1 from $fp-84
	  add $t2, $t0, $t1	
	  sw $t2, -92($fp)	# spill _tmp45 from $t2 to $fp-92
	# _tmp46 = _tmp33 + _tmp45
	  lw $t0, -44($fp)	# fill _tmp33 to $t0 from $fp-44
	  lw $t1, -92($fp)	# fill _tmp45 to $t1 from $fp-92
	  add $t2, $t0, $t1	
	  sw $t2, -96($fp)	# spill _tmp46 from $t2 to $fp-96
	# *(_tmp46) = _tmp32
	  lw $t0, -40($fp)	# fill _tmp32 to $t0 from $fp-40
	  lw $t2, -96($fp)	# fill _tmp46 to $t2 from $fp-96
	  sw $t0, 0($t2) 	# store with offset
	# _tmp47 = *(_tmp46)
	  lw $t0, -96($fp)	# fill _tmp46 to $t0 from $fp-96
	  lw $t2, 0($t0) 	# load with offset
	  sw $t2, -100($fp)	# spill _tmp47 from $t2 to $fp-100
	# _tmp48 = *(this + 4)
	  lw $t0, 4($fp)	# fill this to $t0 from $fp+4
	  lw $t2, 4($t0) 	# load with offset
	  sw $t2, -104($fp)	# spill _tmp48 from $t2 to $fp-104
	# _tmp49 = 1
	  li $t2, 1		# load constant value 1 into $t2
	  sw $t2, -108($fp)	# spill _tmp49 from $t2 to $fp-108
	# _tmp50 = _tmp48 + _tmp49
	  lw $t0, -104($fp)	# fill _tmp48 to $t0 from $fp-104
	  lw $t1, -108($fp)	# fill _tmp49 to $t1 from $fp-108
	  add $t2, $t0, $t1	
	  sw $t2, -112($fp)	# spill _tmp50 from $t2 to $fp-112
	# *(this + 4) = _tmp50
	  lw $t0, -112($fp)	# fill _tmp50 to $t0 from $fp-112
	  lw $t2, 4($fp)	# fill this to $t2 from $fp+4
	  sw $t0, 4($t2) 	# store with offset
	# Goto _L1
	  b _L1		# unconditional branch
  _L2:
  _L4:
	# _tmp51 = 0
	  li $t2, 0		# load constant value 0 into $t2
	  sw $t2, -116($fp)	# spill _tmp51 from $t2 to $fp-116
	# _tmp52 = *(this + 4)
	  lw $t0, 4($fp)	# fill this to $t0 from $fp+4
	  lw $t2, 4($t0) 	# load with offset
	  sw $t2, -120($fp)	# spill _tmp52 from $t2 to $fp-120
	# _tmp53 = _tmp51 < _tmp52
	  lw $t0, -116($fp)	# fill _tmp51 to $t0 from $fp-116
	  lw $t1, -120($fp)	# fill _tmp52 to $t1 from $fp-120
	  slt $t2, $t0, $t1	
	  sw $t2, -124($fp)	# spill _tmp53 from $t2 to $fp-124
	# IfZ _tmp53 Goto _L5
	  lw $t0, -124($fp)	# fill _tmp53 to $t0 from $fp-124
	  beqz $t0, _L5	# branch if _tmp53 is zero 
	# _tmp54 = *(this + 4)
	  lw $t0, 4($fp)	# fill this to $t0 from $fp+4
	  lw $t2, 4($t0) 	# load with offset
	  sw $t2, -136($fp)	# spill _tmp54 from $t2 to $fp-136
	# PushParam _tmp54
	  subu $sp, $sp, 4	# decrement sp to make space for param
	  lw $t0, -136($fp)	# fill _tmp54 to $t0 from $fp-136
	  sw $t0, 4($sp)	# copy param value to stack
	# PushParam gRnd
	  subu $sp, $sp, 4	# decrement sp to make space for param
	  lw $t0, 0($gp)	# fill gRnd to $t0 from $gp+0
	  sw $t0, 4($sp)	# copy param value to stack
	# _tmp55 = *(gRnd)
	  lw $t0, 0($gp)	# fill gRnd to $t0 from $gp+0
	  lw $t2, 0($t0) 	# load with offset
	  sw $t2, -140($fp)	# spill _tmp55 from $t2 to $fp-140
	# _tmp56 = *(_tmp55 + 8)
	  lw $t0, -140($fp)	# fill _tmp55 to $t0 from $fp-140
	  lw $t2, 8($t0) 	# load with offset
	  sw $t2, -144($fp)	# spill _tmp56 from $t2 to $fp-144
	# _tmp57 = ACall _tmp56
	  lw $t0, -144($fp)	# fill _tmp56 to $t0 from $fp-144
	  jalr $t0            	# jump to function
	  move $t2, $v0		# copy function return value from $v0
	  sw $t2, -148($fp)	# spill _tmp57 from $t2 to $fp-148
	# PopParams 8
	  add $sp, $sp, 8	# pop params off stack
	# r = _tmp57
	  lw $t2, -148($fp)	# fill _tmp57 to $t2 from $fp-148
	  sw $t2, -128($fp)	# spill r from $t2 to $fp-128
	# _tmp58 = *(this + 4)
	  lw $t0, 4($fp)	# fill this to $t0 from $fp+4
	  lw $t2, 4($t0) 	# load with offset
	  sw $t2, -152($fp)	# spill _tmp58 from $t2 to $fp-152
	# _tmp59 = 1
	  li $t2, 1		# load constant value 1 into $t2
	  sw $t2, -156($fp)	# spill _tmp59 from $t2 to $fp-156
	# _tmp60 = _tmp58 - _tmp59
	  lw $t0, -152($fp)	# fill _tmp58 to $t0 from $fp-152
	  lw $t1, -156($fp)	# fill _tmp59 to $t1 from $fp-156
	  sub $t2, $t0, $t1	
	  sw $t2, -160($fp)	# spill _tmp60 from $t2 to $fp-160
	# *(this + 4) = _tmp60
	  lw $t0, -160($fp)	# fill _tmp60 to $t0 from $fp-160
	  lw $t2, 4($fp)	# fill this to $t2 from $fp+4
	  sw $t0, 4($t2) 	# store with offset
	# _tmp61 = *(this + 8)
	  lw $t0, 4($fp)	# fill this to $t0 from $fp+4
	  lw $t2, 8($t0) 	# load with offset
	  sw $t2, -164($fp)	# spill _tmp61 from $t2 to $fp-164
	# _tmp62 = *(this + 4)
	  lw $t0, 4($fp)	# fill this to $t0 from $fp+4
	  lw $t2, 4($t0) 	# load with offset
	  sw $t2, -168($fp)	# spill _tmp62 from $t2 to $fp-168
	# _tmp63 = 0
	  li $t2, 0		# load constant value 0 into $t2
	  sw $t2, -172($fp)	# spill _tmp63 from $t2 to $fp-172
	# _tmp64 = *(_tmp61)
	  lw $t0, -164($fp)	# fill _tmp61 to $t0 from $fp-164
	  lw $t2, 0($t0) 	# load with offset
	  sw $t2, -176($fp)	# spill _tmp64 from $t2 to $fp-176
	# _tmp65 = _tmp62 < _tmp63
	  lw $t0, -168($fp)	# fill _tmp62 to $t0 from $fp-168
	  lw $t1, -172($fp)	# fill _tmp63 to $t1 from $fp-172
	  slt $t2, $t0, $t1	
	  sw $t2, -180($fp)	# spill _tmp65 from $t2 to $fp-180
	# _tmp66 = _tmp64 < _tmp62
	  lw $t0, -176($fp)	# fill _tmp64 to $t0 from $fp-176
	  lw $t1, -168($fp)	# fill _tmp62 to $t1 from $fp-168
	  slt $t2, $t0, $t1	
	  sw $t2, -184($fp)	# spill _tmp66 from $t2 to $fp-184
	# _tmp67 = _tmp64 == _tmp62
	  lw $t0, -176($fp)	# fill _tmp64 to $t0 from $fp-176
	  lw $t1, -168($fp)	# fill _tmp62 to $t1 from $fp-168
	  seq $t2, $t0, $t1	
	  sw $t2, -188($fp)	# spill _tmp67 from $t2 to $fp-188
	# _tmp68 = _tmp66 || _tmp67
	  lw $t0, -184($fp)	# fill _tmp66 to $t0 from $fp-184
	  lw $t1, -188($fp)	# fill _tmp67 to $t1 from $fp-188
	  or $t2, $t0, $t1	
	  sw $t2, -192($fp)	# spill _tmp68 from $t2 to $fp-192
	# _tmp69 = _tmp68 || _tmp65
	  lw $t0, -192($fp)	# fill _tmp68 to $t0 from $fp-192
	  lw $t1, -180($fp)	# fill _tmp65 to $t1 from $fp-180
	  or $t2, $t0, $t1	
	  sw $t2, -196($fp)	# spill _tmp69 from $t2 to $fp-196
	# IfZ _tmp69 Goto _L6
	  lw $t0, -196($fp)	# fill _tmp69 to $t0 from $fp-196
	  beqz $t0, _L6	# branch if _tmp69 is zero 
	# _tmp70 = "Decaf runtime error: Array subscript out of bound..."
	  .data			# create string constant marked with label
	  _string3: .asciiz "Decaf runtime error: Array subscript out of bounds\n"
	  .text
	  la $t2, _string3	# load label
	  sw $t2, -200($fp)	# spill _tmp70 from $t2 to $fp-200
	# PushParam _tmp70
	  subu $sp, $sp, 4	# decrement sp to make space for param
	  lw $t0, -200($fp)	# fill _tmp70 to $t0 from $fp-200
	  sw $t0, 4($sp)	# copy param value to stack
	# LCall _PrintString
	  jal _PrintString   	# jump to function
	# PopParams 4
	  add $sp, $sp, 4	# pop params off stack
	# LCall _Halt
	  jal _Halt          	# jump to function
  _L6:
	# _tmp71 = 4
	  li $t2, 4		# load constant value 4 into $t2
	  sw $t2, -204($fp)	# spill _tmp71 from $t2 to $fp-204
	# _tmp72 = _tmp62 * _tmp71
	  lw $t0, -168($fp)	# fill _tmp62 to $t0 from $fp-168
	  lw $t1, -204($fp)	# fill _tmp71 to $t1 from $fp-204
	  mul $t2, $t0, $t1	
	  sw $t2, -208($fp)	# spill _tmp72 from $t2 to $fp-208
	# _tmp73 = _tmp72 + _tmp71
	  lw $t0, -208($fp)	# fill _tmp72 to $t0 from $fp-208
	  lw $t1, -204($fp)	# fill _tmp71 to $t1 from $fp-204
	  add $t2, $t0, $t1	
	  sw $t2, -212($fp)	# spill _tmp73 from $t2 to $fp-212
	# _tmp74 = _tmp61 + _tmp73
	  lw $t0, -164($fp)	# fill _tmp61 to $t0 from $fp-164
	  lw $t1, -212($fp)	# fill _tmp73 to $t1 from $fp-212
	  add $t2, $t0, $t1	
	  sw $t2, -216($fp)	# spill _tmp74 from $t2 to $fp-216
	# _tmp75 = *(_tmp74)
	  lw $t0, -216($fp)	# fill _tmp74 to $t0 from $fp-216
	  lw $t2, 0($t0) 	# load with offset
	  sw $t2, -220($fp)	# spill _tmp75 from $t2 to $fp-220
	# temp = _tmp75
	  lw $t2, -220($fp)	# fill _tmp75 to $t2 from $fp-220
	  sw $t2, -132($fp)	# spill temp from $t2 to $fp-132
	# _tmp76 = *(this + 8)
	  lw $t0, 4($fp)	# fill this to $t0 from $fp+4
	  lw $t2, 8($t0) 	# load with offset
	  sw $t2, -224($fp)	# spill _tmp76 from $t2 to $fp-224
	# _tmp77 = 0
	  li $t2, 0		# load constant value 0 into $t2
	  sw $t2, -228($fp)	# spill _tmp77 from $t2 to $fp-228
	# _tmp78 = *(_tmp76)
	  lw $t0, -224($fp)	# fill _tmp76 to $t0 from $fp-224
	  lw $t2, 0($t0) 	# load with offset
	  sw $t2, -232($fp)	# spill _tmp78 from $t2 to $fp-232
	# _tmp79 = r < _tmp77
	  lw $t0, -128($fp)	# fill r to $t0 from $fp-128
	  lw $t1, -228($fp)	# fill _tmp77 to $t1 from $fp-228
	  slt $t2, $t0, $t1	
	  sw $t2, -236($fp)	# spill _tmp79 from $t2 to $fp-236
	# _tmp80 = _tmp78 < r
	  lw $t0, -232($fp)	# fill _tmp78 to $t0 from $fp-232
	  lw $t1, -128($fp)	# fill r to $t1 from $fp-128
	  slt $t2, $t0, $t1	
	  sw $t2, -240($fp)	# spill _tmp80 from $t2 to $fp-240
	# _tmp81 = _tmp78 == r
	  lw $t0, -232($fp)	# fill _tmp78 to $t0 from $fp-232
	  lw $t1, -128($fp)	# fill r to $t1 from $fp-128
	  seq $t2, $t0, $t1	
	  sw $t2, -244($fp)	# spill _tmp81 from $t2 to $fp-244
	# _tmp82 = _tmp80 || _tmp81
	  lw $t0, -240($fp)	# fill _tmp80 to $t0 from $fp-240
	  lw $t1, -244($fp)	# fill _tmp81 to $t1 from $fp-244
	  or $t2, $t0, $t1	
	  sw $t2, -248($fp)	# spill _tmp82 from $t2 to $fp-248
	# _tmp83 = _tmp82 || _tmp79
	  lw $t0, -248($fp)	# fill _tmp82 to $t0 from $fp-248
	  lw $t1, -236($fp)	# fill _tmp79 to $t1 from $fp-236
	  or $t2, $t0, $t1	
	  sw $t2, -252($fp)	# spill _tmp83 from $t2 to $fp-252
	# IfZ _tmp83 Goto _L7
	  lw $t0, -252($fp)	# fill _tmp83 to $t0 from $fp-252
	  beqz $t0, _L7	# branch if _tmp83 is zero 
	# _tmp84 = "Decaf runtime error: Array subscript out of bound..."
	  .data			# create string constant marked with label
	  _string4: .asciiz "Decaf runtime error: Array subscript out of bounds\n"
	  .text
	  la $t2, _string4	# load label
	  sw $t2, -256($fp)	# spill _tmp84 from $t2 to $fp-256
	# PushParam _tmp84
	  subu $sp, $sp, 4	# decrement sp to make space for param
	  lw $t0, -256($fp)	# fill _tmp84 to $t0 from $fp-256
	  sw $t0, 4($sp)	# copy param value to stack
	# LCall _PrintString
	  jal _PrintString   	# jump to function
	# PopParams 4
	  add $sp, $sp, 4	# pop params off stack
	# LCall _Halt
	  jal _Halt          	# jump to function
  _L7:
	# _tmp85 = 4
	  li $t2, 4		# load constant value 4 into $t2
	  sw $t2, -260($fp)	# spill _tmp85 from $t2 to $fp-260
	# _tmp86 = r * _tmp85
	  lw $t0, -128($fp)	# fill r to $t0 from $fp-128
	  lw $t1, -260($fp)	# fill _tmp85 to $t1 from $fp-260
	  mul $t2, $t0, $t1	
	  sw $t2, -264($fp)	# spill _tmp86 from $t2 to $fp-264
	# _tmp87 = _tmp86 + _tmp85
	  lw $t0, -264($fp)	# fill _tmp86 to $t0 from $fp-264
	  lw $t1, -260($fp)	# fill _tmp85 to $t1 from $fp-260
	  add $t2, $t0, $t1	
	  sw $t2, -268($fp)	# spill _tmp87 from $t2 to $fp-268
	# _tmp88 = _tmp76 + _tmp87
	  lw $t0, -224($fp)	# fill _tmp76 to $t0 from $fp-224
	  lw $t1, -268($fp)	# fill _tmp87 to $t1 from $fp-268
	  add $t2, $t0, $t1	
	  sw $t2, -272($fp)	# spill _tmp88 from $t2 to $fp-272
	# _tmp89 = *(_tmp88)
	  lw $t0, -272($fp)	# fill _tmp88 to $t0 from $fp-272
	  lw $t2, 0($t0) 	# load with offset
	  sw $t2, -276($fp)	# spill _tmp89 from $t2 to $fp-276
	# _tmp90 = *(this + 8)
	  lw $t0, 4($fp)	# fill this to $t0 from $fp+4
	  lw $t2, 8($t0) 	# load with offset
	  sw $t2, -280($fp)	# spill _tmp90 from $t2 to $fp-280
	# _tmp91 = *(this + 4)
	  lw $t0, 4($fp)	# fill this to $t0 from $fp+4
	  lw $t2, 4($t0) 	# load with offset
	  sw $t2, -284($fp)	# spill _tmp91 from $t2 to $fp-284
	# _tmp92 = 0
	  li $t2, 0		# load constant value 0 into $t2
	  sw $t2, -288($fp)	# spill _tmp92 from $t2 to $fp-288
	# _tmp93 = *(_tmp90)
	  lw $t0, -280($fp)	# fill _tmp90 to $t0 from $fp-280
	  lw $t2, 0($t0) 	# load with offset
	  sw $t2, -292($fp)	# spill _tmp93 from $t2 to $fp-292
	# _tmp94 = _tmp91 < _tmp92
	  lw $t0, -284($fp)	# fill _tmp91 to $t0 from $fp-284
	  lw $t1, -288($fp)	# fill _tmp92 to $t1 from $fp-288
	  slt $t2, $t0, $t1	
	  sw $t2, -296($fp)	# spill _tmp94 from $t2 to $fp-296
	# _tmp95 = _tmp93 < _tmp91
	  lw $t0, -292($fp)	# fill _tmp93 to $t0 from $fp-292
	  lw $t1, -284($fp)	# fill _tmp91 to $t1 from $fp-284
	  slt $t2, $t0, $t1	
	  sw $t2, -300($fp)	# spill _tmp95 from $t2 to $fp-300
	# _tmp96 = _tmp93 == _tmp91
	  lw $t0, -292($fp)	# fill _tmp93 to $t0 from $fp-292
	  lw $t1, -284($fp)	# fill _tmp91 to $t1 from $fp-284
	  seq $t2, $t0, $t1	
	  sw $t2, -304($fp)	# spill _tmp96 from $t2 to $fp-304
	# _tmp97 = _tmp95 || _tmp96
	  lw $t0, -300($fp)	# fill _tmp95 to $t0 from $fp-300
	  lw $t1, -304($fp)	# fill _tmp96 to $t1 from $fp-304
	  or $t2, $t0, $t1	
	  sw $t2, -308($fp)	# spill _tmp97 from $t2 to $fp-308
	# _tmp98 = _tmp97 || _tmp94
	  lw $t0, -308($fp)	# fill _tmp97 to $t0 from $fp-308
	  lw $t1, -296($fp)	# fill _tmp94 to $t1 from $fp-296
	  or $t2, $t0, $t1	
	  sw $t2, -312($fp)	# spill _tmp98 from $t2 to $fp-312
	# IfZ _tmp98 Goto _L8
	  lw $t0, -312($fp)	# fill _tmp98 to $t0 from $fp-312
	  beqz $t0, _L8	# branch if _tmp98 is zero 
	# _tmp99 = "Decaf runtime error: Array subscript out of bound..."
	  .data			# create string constant marked with label
	  _string5: .asciiz "Decaf runtime error: Array subscript out of bounds\n"
	  .text
	  la $t2, _string5	# load label
	  sw $t2, -316($fp)	# spill _tmp99 from $t2 to $fp-316
	# PushParam _tmp99
	  subu $sp, $sp, 4	# decrement sp to make space for param
	  lw $t0, -316($fp)	# fill _tmp99 to $t0 from $fp-316
	  sw $t0, 4($sp)	# copy param value to stack
	# LCall _PrintString
	  jal _PrintString   	# jump to function
	# PopParams 4
	  add $sp, $sp, 4	# pop params off stack
	# LCall _Halt
	  jal _Halt          	# jump to function
  _L8:
	# _tmp100 = 4
	  li $t2, 4		# load constant value 4 into $t2
	  sw $t2, -320($fp)	# spill _tmp100 from $t2 to $fp-320
	# _tmp101 = _tmp91 * _tmp100
	  lw $t0, -284($fp)	# fill _tmp91 to $t0 from $fp-284
	  lw $t1, -320($fp)	# fill _tmp100 to $t1 from $fp-320
	  mul $t2, $t0, $t1	
	  sw $t2, -324($fp)	# spill _tmp101 from $t2 to $fp-324
	# _tmp102 = _tmp101 + _tmp100
	  lw $t0, -324($fp)	# fill _tmp101 to $t0 from $fp-324
	  lw $t1, -320($fp)	# fill _tmp100 to $t1 from $fp-320
	  add $t2, $t0, $t1	
	  sw $t2, -328($fp)	# spill _tmp102 from $t2 to $fp-328
	# _tmp103 = _tmp90 + _tmp102
	  lw $t0, -280($fp)	# fill _tmp90 to $t0 from $fp-280
	  lw $t1, -328($fp)	# fill _tmp102 to $t1 from $fp-328
	  add $t2, $t0, $t1	
	  sw $t2, -332($fp)	# spill _tmp103 from $t2 to $fp-332
	# *(_tmp103) = _tmp89
	  lw $t0, -276($fp)	# fill _tmp89 to $t0 from $fp-276
	  lw $t2, -332($fp)	# fill _tmp103 to $t2 from $fp-332
	  sw $t0, 0($t2) 	# store with offset
	# _tmp104 = *(_tmp103)
	  lw $t0, -332($fp)	# fill _tmp103 to $t0 from $fp-332
	  lw $t2, 0($t0) 	# load with offset
	  sw $t2, -336($fp)	# spill _tmp104 from $t2 to $fp-336
	# _tmp105 = *(this + 8)
	  lw $t0, 4($fp)	# fill this to $t0 from $fp+4
	  lw $t2, 8($t0) 	# load with offset
	  sw $t2, -340($fp)	# spill _tmp105 from $t2 to $fp-340
	# _tmp106 = 0
	  li $t2, 0		# load constant value 0 into $t2
	  sw $t2, -344($fp)	# spill _tmp106 from $t2 to $fp-344
	# _tmp107 = *(_tmp105)
	  lw $t0, -340($fp)	# fill _tmp105 to $t0 from $fp-340
	  lw $t2, 0($t0) 	# load with offset
	  sw $t2, -348($fp)	# spill _tmp107 from $t2 to $fp-348
	# _tmp108 = r < _tmp106
	  lw $t0, -128($fp)	# fill r to $t0 from $fp-128
	  lw $t1, -344($fp)	# fill _tmp106 to $t1 from $fp-344
	  slt $t2, $t0, $t1	
	  sw $t2, -352($fp)	# spill _tmp108 from $t2 to $fp-352
	# _tmp109 = _tmp107 < r
	  lw $t0, -348($fp)	# fill _tmp107 to $t0 from $fp-348
	  lw $t1, -128($fp)	# fill r to $t1 from $fp-128
	  slt $t2, $t0, $t1	
	  sw $t2, -356($fp)	# spill _tmp109 from $t2 to $fp-356
	# _tmp110 = _tmp107 == r
	  lw $t0, -348($fp)	# fill _tmp107 to $t0 from $fp-348
	  lw $t1, -128($fp)	# fill r to $t1 from $fp-128
	  seq $t2, $t0, $t1	
	  sw $t2, -360($fp)	# spill _tmp110 from $t2 to $fp-360
	# _tmp111 = _tmp109 || _tmp110
	  lw $t0, -356($fp)	# fill _tmp109 to $t0 from $fp-356
	  lw $t1, -360($fp)	# fill _tmp110 to $t1 from $fp-360
	  or $t2, $t0, $t1	
	  sw $t2, -364($fp)	# spill _tmp111 from $t2 to $fp-364
	# _tmp112 = _tmp111 || _tmp108
	  lw $t0, -364($fp)	# fill _tmp111 to $t0 from $fp-364
	  lw $t1, -352($fp)	# fill _tmp108 to $t1 from $fp-352
	  or $t2, $t0, $t1	
	  sw $t2, -368($fp)	# spill _tmp112 from $t2 to $fp-368
	# IfZ _tmp112 Goto _L9
	  lw $t0, -368($fp)	# fill _tmp112 to $t0 from $fp-368
	  beqz $t0, _L9	# branch if _tmp112 is zero 
	# _tmp113 = "Decaf runtime error: Array subscript out of bound..."
	  .data			# create string constant marked with label
	  _string6: .asciiz "Decaf runtime error: Array subscript out of bounds\n"
	  .text
	  la $t2, _string6	# load label
	  sw $t2, -372($fp)	# spill _tmp113 from $t2 to $fp-372
	# PushParam _tmp113
	  subu $sp, $sp, 4	# decrement sp to make space for param
	  lw $t0, -372($fp)	# fill _tmp113 to $t0 from $fp-372
	  sw $t0, 4($sp)	# copy param value to stack
	# LCall _PrintString
	  jal _PrintString   	# jump to function
	# PopParams 4
	  add $sp, $sp, 4	# pop params off stack
	# LCall _Halt
	  jal _Halt          	# jump to function
  _L9:
	# _tmp114 = 4
	  li $t2, 4		# load constant value 4 into $t2
	  sw $t2, -376($fp)	# spill _tmp114 from $t2 to $fp-376
	# _tmp115 = r * _tmp114
	  lw $t0, -128($fp)	# fill r to $t0 from $fp-128
	  lw $t1, -376($fp)	# fill _tmp114 to $t1 from $fp-376
	  mul $t2, $t0, $t1	
	  sw $t2, -380($fp)	# spill _tmp115 from $t2 to $fp-380
	# _tmp116 = _tmp115 + _tmp114
	  lw $t0, -380($fp)	# fill _tmp115 to $t0 from $fp-380
	  lw $t1, -376($fp)	# fill _tmp114 to $t1 from $fp-376
	  add $t2, $t0, $t1	
	  sw $t2, -384($fp)	# spill _tmp116 from $t2 to $fp-384
	# _tmp117 = _tmp105 + _tmp116
	  lw $t0, -340($fp)	# fill _tmp105 to $t0 from $fp-340
	  lw $t1, -384($fp)	# fill _tmp116 to $t1 from $fp-384
	  add $t2, $t0, $t1	
	  sw $t2, -388($fp)	# spill _tmp117 from $t2 to $fp-388
	# *(_tmp117) = temp
	  lw $t0, -132($fp)	# fill temp to $t0 from $fp-132
	  lw $t2, -388($fp)	# fill _tmp117 to $t2 from $fp-388
	  sw $t0, 0($t2) 	# store with offset
	# _tmp118 = *(_tmp117)
	  lw $t0, -388($fp)	# fill _tmp117 to $t0 from $fp-388
	  lw $t2, 0($t0) 	# load with offset
	  sw $t2, -392($fp)	# spill _tmp118 from $t2 to $fp-392
	# Goto _L4
	  b _L4		# unconditional branch
  _L5:
	# EndFunc
	# (below handles reaching end of fn body with no explicit return)
	  move $sp, $fp		# pop callee frame off stack
	  lw $ra, -4($fp)	# restore saved ra
	  lw $fp, 0($fp)	# restore saved fp
	  jr $ra		# return from function
  Deck.____GetCard:
	# BeginFunc 104
	  subu $sp, $sp, 8	# decrement sp to make space to save ra, fp
	  sw $fp, 8($sp)	# save fp
	  sw $ra, 4($sp)	# save ra
	  addiu $fp, $sp, 8	# set up new fp
	  subu $sp, $sp, 104	# decrement sp to make space for locals/temps
	# _tmp119 = 52
	  li $t2, 52		# load constant value 52 into $t2
	  sw $t2, -12($fp)	# spill _tmp119 from $t2 to $fp-12
	# _tmp120 = *(this + 4)
	  lw $t0, 4($fp)	# fill this to $t0 from $fp+4
	  lw $t2, 4($t0) 	# load with offset
	  sw $t2, -16($fp)	# spill _tmp120 from $t2 to $fp-16
	# _tmp121 = _tmp119 < _tmp120
	  lw $t0, -12($fp)	# fill _tmp119 to $t0 from $fp-12
	  lw $t1, -16($fp)	# fill _tmp120 to $t1 from $fp-16
	  slt $t2, $t0, $t1	
	  sw $t2, -20($fp)	# spill _tmp121 from $t2 to $fp-20
	# _tmp122 = _tmp119 == _tmp120
	  lw $t0, -12($fp)	# fill _tmp119 to $t0 from $fp-12
	  lw $t1, -16($fp)	# fill _tmp120 to $t1 from $fp-16
	  seq $t2, $t0, $t1	
	  sw $t2, -24($fp)	# spill _tmp122 from $t2 to $fp-24
	# _tmp123 = _tmp121 || _tmp122
	  lw $t0, -20($fp)	# fill _tmp121 to $t0 from $fp-20
	  lw $t1, -24($fp)	# fill _tmp122 to $t1 from $fp-24
	  or $t2, $t0, $t1	
	  sw $t2, -28($fp)	# spill _tmp123 from $t2 to $fp-28
	# IfZ _tmp123 Goto _L10
	  lw $t0, -28($fp)	# fill _tmp123 to $t0 from $fp-28
	  beqz $t0, _L10	# branch if _tmp123 is zero 
	# _tmp124 = 0
	  li $t2, 0		# load constant value 0 into $t2
	  sw $t2, -32($fp)	# spill _tmp124 from $t2 to $fp-32
	# Return _tmp124
	  lw $t2, -32($fp)	# fill _tmp124 to $t2 from $fp-32
	  move $v0, $t2		# assign return value into $v0
	  move $sp, $fp		# pop callee frame off stack
	  lw $ra, -4($fp)	# restore saved ra
	  lw $fp, 0($fp)	# restore saved fp
	  jr $ra		# return from function
	# Goto _L11
	  b _L11		# unconditional branch
  _L10:
  _L11:
	# _tmp125 = *(this + 8)
	  lw $t0, 4($fp)	# fill this to $t0 from $fp+4
	  lw $t2, 8($t0) 	# load with offset
	  sw $t2, -36($fp)	# spill _tmp125 from $t2 to $fp-36
	# _tmp126 = *(this + 4)
	  lw $t0, 4($fp)	# fill this to $t0 from $fp+4
	  lw $t2, 4($t0) 	# load with offset
	  sw $t2, -40($fp)	# spill _tmp126 from $t2 to $fp-40
	# _tmp127 = 0
	  li $t2, 0		# load constant value 0 into $t2
	  sw $t2, -44($fp)	# spill _tmp127 from $t2 to $fp-44
	# _tmp128 = *(_tmp125)
	  lw $t0, -36($fp)	# fill _tmp125 to $t0 from $fp-36
	  lw $t2, 0($t0) 	# load with offset
	  sw $t2, -48($fp)	# spill _tmp128 from $t2 to $fp-48
	# _tmp129 = _tmp126 < _tmp127
	  lw $t0, -40($fp)	# fill _tmp126 to $t0 from $fp-40
	  lw $t1, -44($fp)	# fill _tmp127 to $t1 from $fp-44
	  slt $t2, $t0, $t1	
	  sw $t2, -52($fp)	# spill _tmp129 from $t2 to $fp-52
	# _tmp130 = _tmp128 < _tmp126
	  lw $t0, -48($fp)	# fill _tmp128 to $t0 from $fp-48
	  lw $t1, -40($fp)	# fill _tmp126 to $t1 from $fp-40
	  slt $t2, $t0, $t1	
	  sw $t2, -56($fp)	# spill _tmp130 from $t2 to $fp-56
	# _tmp131 = _tmp128 == _tmp126
	  lw $t0, -48($fp)	# fill _tmp128 to $t0 from $fp-48
	  lw $t1, -40($fp)	# fill _tmp126 to $t1 from $fp-40
	  seq $t2, $t0, $t1	
	  sw $t2, -60($fp)	# spill _tmp131 from $t2 to $fp-60
	# _tmp132 = _tmp130 || _tmp131
	  lw $t0, -56($fp)	# fill _tmp130 to $t0 from $fp-56
	  lw $t1, -60($fp)	# fill _tmp131 to $t1 from $fp-60
	  or $t2, $t0, $t1	
	  sw $t2, -64($fp)	# spill _tmp132 from $t2 to $fp-64
	# _tmp133 = _tmp132 || _tmp129
	  lw $t0, -64($fp)	# fill _tmp132 to $t0 from $fp-64
	  lw $t1, -52($fp)	# fill _tmp129 to $t1 from $fp-52
	  or $t2, $t0, $t1	
	  sw $t2, -68($fp)	# spill _tmp133 from $t2 to $fp-68
	# IfZ _tmp133 Goto _L12
	  lw $t0, -68($fp)	# fill _tmp133 to $t0 from $fp-68
	  beqz $t0, _L12	# branch if _tmp133 is zero 
	# _tmp134 = "Decaf runtime error: Array subscript out of bound..."
	  .data			# create string constant marked with label
	  _string7: .asciiz "Decaf runtime error: Array subscript out of bounds\n"
	  .text
	  la $t2, _string7	# load label
	  sw $t2, -72($fp)	# spill _tmp134 from $t2 to $fp-72
	# PushParam _tmp134
	  subu $sp, $sp, 4	# decrement sp to make space for param
	  lw $t0, -72($fp)	# fill _tmp134 to $t0 from $fp-72
	  sw $t0, 4($sp)	# copy param value to stack
	# LCall _PrintString
	  jal _PrintString   	# jump to function
	# PopParams 4
	  add $sp, $sp, 4	# pop params off stack
	# LCall _Halt
	  jal _Halt          	# jump to function
  _L12:
	# _tmp135 = 4
	  li $t2, 4		# load constant value 4 into $t2
	  sw $t2, -76($fp)	# spill _tmp135 from $t2 to $fp-76
	# _tmp136 = _tmp126 * _tmp135
	  lw $t0, -40($fp)	# fill _tmp126 to $t0 from $fp-40
	  lw $t1, -76($fp)	# fill _tmp135 to $t1 from $fp-76
	  mul $t2, $t0, $t1	
	  sw $t2, -80($fp)	# spill _tmp136 from $t2 to $fp-80
	# _tmp137 = _tmp136 + _tmp135
	  lw $t0, -80($fp)	# fill _tmp136 to $t0 from $fp-80
	  lw $t1, -76($fp)	# fill _tmp135 to $t1 from $fp-76
	  add $t2, $t0, $t1	
	  sw $t2, -84($fp)	# spill _tmp137 from $t2 to $fp-84
	# _tmp138 = _tmp125 + _tmp137
	  lw $t0, -36($fp)	# fill _tmp125 to $t0 from $fp-36
	  lw $t1, -84($fp)	# fill _tmp137 to $t1 from $fp-84
	  add $t2, $t0, $t1	
	  sw $t2, -88($fp)	# spill _tmp138 from $t2 to $fp-88
	# _tmp139 = *(_tmp138)
	  lw $t0, -88($fp)	# fill _tmp138 to $t0 from $fp-88
	  lw $t2, 0($t0) 	# load with offset
	  sw $t2, -92($fp)	# spill _tmp139 from $t2 to $fp-92
	# result = _tmp139
	  lw $t2, -92($fp)	# fill _tmp139 to $t2 from $fp-92
	  sw $t2, -8($fp)	# spill result from $t2 to $fp-8
	# _tmp140 = *(this + 4)
	  lw $t0, 4($fp)	# fill this to $t0 from $fp+4
	  lw $t2, 4($t0) 	# load with offset
	  sw $t2, -96($fp)	# spill _tmp140 from $t2 to $fp-96
	# _tmp141 = 1
	  li $t2, 1		# load constant value 1 into $t2
	  sw $t2, -100($fp)	# spill _tmp141 from $t2 to $fp-100
	# _tmp142 = _tmp140 + _tmp141
	  lw $t0, -96($fp)	# fill _tmp140 to $t0 from $fp-96
	  lw $t1, -100($fp)	# fill _tmp141 to $t1 from $fp-100
	  add $t2, $t0, $t1	
	  sw $t2, -104($fp)	# spill _tmp142 from $t2 to $fp-104
	# *(this + 4) = _tmp142
	  lw $t0, -104($fp)	# fill _tmp142 to $t0 from $fp-104
	  lw $t2, 4($fp)	# fill this to $t2 from $fp+4
	  sw $t0, 4($t2) 	# store with offset
	# Return result
	  lw $t2, -8($fp)	# fill result to $t2 from $fp-8
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
	# VTable for class Deck
	  .data
	  .align 2
	  Deck:		# label for class Deck vtable
	  .word Deck.____Init
	  .word Deck.____Shuffle
	  .word Deck.____GetCard
	  .text
  BJDeck.____Init:
	# BeginFunc 220
	  subu $sp, $sp, 8	# decrement sp to make space to save ra, fp
	  sw $fp, 8($sp)	# save fp
	  sw $ra, 4($sp)	# save ra
	  addiu $fp, $sp, 8	# set up new fp
	  subu $sp, $sp, 220	# decrement sp to make space for locals/temps
	# _tmp143 = 8
	  li $t2, 8		# load constant value 8 into $t2
	  sw $t2, -12($fp)	# spill _tmp143 from $t2 to $fp-12
	# _tmp144 = 4
	  li $t2, 4		# load constant value 4 into $t2
	  sw $t2, -16($fp)	# spill _tmp144 from $t2 to $fp-16
	# _tmp145 = 0
	  li $t2, 0		# load constant value 0 into $t2
	  sw $t2, -20($fp)	# spill _tmp145 from $t2 to $fp-20
	# _tmp146 = _tmp143 < _tmp145
	  lw $t0, -12($fp)	# fill _tmp143 to $t0 from $fp-12
	  lw $t1, -20($fp)	# fill _tmp145 to $t1 from $fp-20
	  slt $t2, $t0, $t1	
	  sw $t2, -24($fp)	# spill _tmp146 from $t2 to $fp-24
	# _tmp147 = _tmp143 == _tmp145
	  lw $t0, -12($fp)	# fill _tmp143 to $t0 from $fp-12
	  lw $t1, -20($fp)	# fill _tmp145 to $t1 from $fp-20
	  seq $t2, $t0, $t1	
	  sw $t2, -28($fp)	# spill _tmp147 from $t2 to $fp-28
	# _tmp148 = _tmp146 || _tmp147
	  lw $t0, -24($fp)	# fill _tmp146 to $t0 from $fp-24
	  lw $t1, -28($fp)	# fill _tmp147 to $t1 from $fp-28
	  or $t2, $t0, $t1	
	  sw $t2, -32($fp)	# spill _tmp148 from $t2 to $fp-32
	# IfZ _tmp148 Goto _L13
	  lw $t0, -32($fp)	# fill _tmp148 to $t0 from $fp-32
	  beqz $t0, _L13	# branch if _tmp148 is zero 
	# _tmp149 = "Decaf runtime error: Array size is <= 0\n"
	  .data			# create string constant marked with label
	  _string8: .asciiz "Decaf runtime error: Array size is <= 0\n"
	  .text
	  la $t2, _string8	# load label
	  sw $t2, -36($fp)	# spill _tmp149 from $t2 to $fp-36
	# PushParam _tmp149
	  subu $sp, $sp, 4	# decrement sp to make space for param
	  lw $t0, -36($fp)	# fill _tmp149 to $t0 from $fp-36
	  sw $t0, 4($sp)	# copy param value to stack
	# LCall _PrintString
	  jal _PrintString   	# jump to function
	# PopParams 4
	  add $sp, $sp, 4	# pop params off stack
	# LCall _Halt
	  jal _Halt          	# jump to function
  _L13:
	# _tmp150 = _tmp143 * _tmp144
	  lw $t0, -12($fp)	# fill _tmp143 to $t0 from $fp-12
	  lw $t1, -16($fp)	# fill _tmp144 to $t1 from $fp-16
	  mul $t2, $t0, $t1	
	  sw $t2, -40($fp)	# spill _tmp150 from $t2 to $fp-40
	# _tmp151 = _tmp144 + _tmp150
	  lw $t0, -16($fp)	# fill _tmp144 to $t0 from $fp-16
	  lw $t1, -40($fp)	# fill _tmp150 to $t1 from $fp-40
	  add $t2, $t0, $t1	
	  sw $t2, -44($fp)	# spill _tmp151 from $t2 to $fp-44
	# PushParam _tmp151
	  subu $sp, $sp, 4	# decrement sp to make space for param
	  lw $t0, -44($fp)	# fill _tmp151 to $t0 from $fp-44
	  sw $t0, 4($sp)	# copy param value to stack
	# _tmp152 = LCall _Alloc
	  jal _Alloc         	# jump to function
	  move $t2, $v0		# copy function return value from $v0
	  sw $t2, -48($fp)	# spill _tmp152 from $t2 to $fp-48
	# PopParams 4
	  add $sp, $sp, 4	# pop params off stack
	# *(_tmp152) = _tmp143
	  lw $t0, -12($fp)	# fill _tmp143 to $t0 from $fp-12
	  lw $t2, -48($fp)	# fill _tmp152 to $t2 from $fp-48
	  sw $t0, 0($t2) 	# store with offset
	# *(this + 4) = _tmp152
	  lw $t0, -48($fp)	# fill _tmp152 to $t0 from $fp-48
	  lw $t2, 4($fp)	# fill this to $t2 from $fp+4
	  sw $t0, 4($t2) 	# store with offset
	# _tmp153 = 0
	  li $t2, 0		# load constant value 0 into $t2
	  sw $t2, -52($fp)	# spill _tmp153 from $t2 to $fp-52
	# i = _tmp153
	  lw $t2, -52($fp)	# fill _tmp153 to $t2 from $fp-52
	  sw $t2, -8($fp)	# spill i from $t2 to $fp-8
  _L14:
	# _tmp154 = 8
	  li $t2, 8		# load constant value 8 into $t2
	  sw $t2, -56($fp)	# spill _tmp154 from $t2 to $fp-56
	# _tmp155 = i < _tmp154
	  lw $t0, -8($fp)	# fill i to $t0 from $fp-8
	  lw $t1, -56($fp)	# fill _tmp154 to $t1 from $fp-56
	  slt $t2, $t0, $t1	
	  sw $t2, -60($fp)	# spill _tmp155 from $t2 to $fp-60
	# IfZ _tmp155 Goto _L15
	  lw $t0, -60($fp)	# fill _tmp155 to $t0 from $fp-60
	  beqz $t0, _L15	# branch if _tmp155 is zero 
	# _tmp156 = 8
	  li $t2, 8		# load constant value 8 into $t2
	  sw $t2, -64($fp)	# spill _tmp156 from $t2 to $fp-64
	# _tmp157 = 4
	  li $t2, 4		# load constant value 4 into $t2
	  sw $t2, -68($fp)	# spill _tmp157 from $t2 to $fp-68
	# _tmp158 = _tmp157 + _tmp156
	  lw $t0, -68($fp)	# fill _tmp157 to $t0 from $fp-68
	  lw $t1, -64($fp)	# fill _tmp156 to $t1 from $fp-64
	  add $t2, $t0, $t1	
	  sw $t2, -72($fp)	# spill _tmp158 from $t2 to $fp-72
	# PushParam _tmp158
	  subu $sp, $sp, 4	# decrement sp to make space for param
	  lw $t0, -72($fp)	# fill _tmp158 to $t0 from $fp-72
	  sw $t0, 4($sp)	# copy param value to stack
	# _tmp159 = LCall _Alloc
	  jal _Alloc         	# jump to function
	  move $t2, $v0		# copy function return value from $v0
	  sw $t2, -76($fp)	# spill _tmp159 from $t2 to $fp-76
	# PopParams 4
	  add $sp, $sp, 4	# pop params off stack
	# _tmp160 = Deck
	  la $t2, Deck	# load label
	  sw $t2, -80($fp)	# spill _tmp160 from $t2 to $fp-80
	# *(_tmp159) = _tmp160
	  lw $t0, -80($fp)	# fill _tmp160 to $t0 from $fp-80
	  lw $t2, -76($fp)	# fill _tmp159 to $t2 from $fp-76
	  sw $t0, 0($t2) 	# store with offset
	# _tmp161 = *(this + 4)
	  lw $t0, 4($fp)	# fill this to $t0 from $fp+4
	  lw $t2, 4($t0) 	# load with offset
	  sw $t2, -84($fp)	# spill _tmp161 from $t2 to $fp-84
	# _tmp162 = 0
	  li $t2, 0		# load constant value 0 into $t2
	  sw $t2, -88($fp)	# spill _tmp162 from $t2 to $fp-88
	# _tmp163 = *(_tmp161)
	  lw $t0, -84($fp)	# fill _tmp161 to $t0 from $fp-84
	  lw $t2, 0($t0) 	# load with offset
	  sw $t2, -92($fp)	# spill _tmp163 from $t2 to $fp-92
	# _tmp164 = i < _tmp162
	  lw $t0, -8($fp)	# fill i to $t0 from $fp-8
	  lw $t1, -88($fp)	# fill _tmp162 to $t1 from $fp-88
	  slt $t2, $t0, $t1	
	  sw $t2, -96($fp)	# spill _tmp164 from $t2 to $fp-96
	# _tmp165 = _tmp163 < i
	  lw $t0, -92($fp)	# fill _tmp163 to $t0 from $fp-92
	  lw $t1, -8($fp)	# fill i to $t1 from $fp-8
	  slt $t2, $t0, $t1	
	  sw $t2, -100($fp)	# spill _tmp165 from $t2 to $fp-100
	# _tmp166 = _tmp163 == i
	  lw $t0, -92($fp)	# fill _tmp163 to $t0 from $fp-92
	  lw $t1, -8($fp)	# fill i to $t1 from $fp-8
	  seq $t2, $t0, $t1	
	  sw $t2, -104($fp)	# spill _tmp166 from $t2 to $fp-104
	# _tmp167 = _tmp165 || _tmp166
	  lw $t0, -100($fp)	# fill _tmp165 to $t0 from $fp-100
	  lw $t1, -104($fp)	# fill _tmp166 to $t1 from $fp-104
	  or $t2, $t0, $t1	
	  sw $t2, -108($fp)	# spill _tmp167 from $t2 to $fp-108
	# _tmp168 = _tmp167 || _tmp164
	  lw $t0, -108($fp)	# fill _tmp167 to $t0 from $fp-108
	  lw $t1, -96($fp)	# fill _tmp164 to $t1 from $fp-96
	  or $t2, $t0, $t1	
	  sw $t2, -112($fp)	# spill _tmp168 from $t2 to $fp-112
	# IfZ _tmp168 Goto _L16
	  lw $t0, -112($fp)	# fill _tmp168 to $t0 from $fp-112
	  beqz $t0, _L16	# branch if _tmp168 is zero 
	# _tmp169 = "Decaf runtime error: Array subscript out of bound..."
	  .data			# create string constant marked with label
	  _string9: .asciiz "Decaf runtime error: Array subscript out of bounds\n"
	  .text
	  la $t2, _string9	# load label
	  sw $t2, -116($fp)	# spill _tmp169 from $t2 to $fp-116
	# PushParam _tmp169
	  subu $sp, $sp, 4	# decrement sp to make space for param
	  lw $t0, -116($fp)	# fill _tmp169 to $t0 from $fp-116
	  sw $t0, 4($sp)	# copy param value to stack
	# LCall _PrintString
	  jal _PrintString   	# jump to function
	# PopParams 4
	  add $sp, $sp, 4	# pop params off stack
	# LCall _Halt
	  jal _Halt          	# jump to function
  _L16:
	# _tmp170 = 4
	  li $t2, 4		# load constant value 4 into $t2
	  sw $t2, -120($fp)	# spill _tmp170 from $t2 to $fp-120
	# _tmp171 = i * _tmp170
	  lw $t0, -8($fp)	# fill i to $t0 from $fp-8
	  lw $t1, -120($fp)	# fill _tmp170 to $t1 from $fp-120
	  mul $t2, $t0, $t1	
	  sw $t2, -124($fp)	# spill _tmp171 from $t2 to $fp-124
	# _tmp172 = _tmp171 + _tmp170
	  lw $t0, -124($fp)	# fill _tmp171 to $t0 from $fp-124
	  lw $t1, -120($fp)	# fill _tmp170 to $t1 from $fp-120
	  add $t2, $t0, $t1	
	  sw $t2, -128($fp)	# spill _tmp172 from $t2 to $fp-128
	# _tmp173 = _tmp161 + _tmp172
	  lw $t0, -84($fp)	# fill _tmp161 to $t0 from $fp-84
	  lw $t1, -128($fp)	# fill _tmp172 to $t1 from $fp-128
	  add $t2, $t0, $t1	
	  sw $t2, -132($fp)	# spill _tmp173 from $t2 to $fp-132
	# *(_tmp173) = _tmp159
	  lw $t0, -76($fp)	# fill _tmp159 to $t0 from $fp-76
	  lw $t2, -132($fp)	# fill _tmp173 to $t2 from $fp-132
	  sw $t0, 0($t2) 	# store with offset
	# _tmp174 = *(_tmp173)
	  lw $t0, -132($fp)	# fill _tmp173 to $t0 from $fp-132
	  lw $t2, 0($t0) 	# load with offset
	  sw $t2, -136($fp)	# spill _tmp174 from $t2 to $fp-136
	# _tmp175 = *(this + 4)
	  lw $t0, 4($fp)	# fill this to $t0 from $fp+4
	  lw $t2, 4($t0) 	# load with offset
	  sw $t2, -140($fp)	# spill _tmp175 from $t2 to $fp-140
	# _tmp176 = 0
	  li $t2, 0		# load constant value 0 into $t2
	  sw $t2, -144($fp)	# spill _tmp176 from $t2 to $fp-144
	# _tmp177 = *(_tmp175)
	  lw $t0, -140($fp)	# fill _tmp175 to $t0 from $fp-140
	  lw $t2, 0($t0) 	# load with offset
	  sw $t2, -148($fp)	# spill _tmp177 from $t2 to $fp-148
	# _tmp178 = i < _tmp176
	  lw $t0, -8($fp)	# fill i to $t0 from $fp-8
	  lw $t1, -144($fp)	# fill _tmp176 to $t1 from $fp-144
	  slt $t2, $t0, $t1	
	  sw $t2, -152($fp)	# spill _tmp178 from $t2 to $fp-152
	# _tmp179 = _tmp177 < i
	  lw $t0, -148($fp)	# fill _tmp177 to $t0 from $fp-148
	  lw $t1, -8($fp)	# fill i to $t1 from $fp-8
	  slt $t2, $t0, $t1	
	  sw $t2, -156($fp)	# spill _tmp179 from $t2 to $fp-156
	# _tmp180 = _tmp177 == i
	  lw $t0, -148($fp)	# fill _tmp177 to $t0 from $fp-148
	  lw $t1, -8($fp)	# fill i to $t1 from $fp-8
	  seq $t2, $t0, $t1	
	  sw $t2, -160($fp)	# spill _tmp180 from $t2 to $fp-160
	# _tmp181 = _tmp179 || _tmp180
	  lw $t0, -156($fp)	# fill _tmp179 to $t0 from $fp-156
	  lw $t1, -160($fp)	# fill _tmp180 to $t1 from $fp-160
	  or $t2, $t0, $t1	
	  sw $t2, -164($fp)	# spill _tmp181 from $t2 to $fp-164
	# _tmp182 = _tmp181 || _tmp178
	  lw $t0, -164($fp)	# fill _tmp181 to $t0 from $fp-164
	  lw $t1, -152($fp)	# fill _tmp178 to $t1 from $fp-152
	  or $t2, $t0, $t1	
	  sw $t2, -168($fp)	# spill _tmp182 from $t2 to $fp-168
	# IfZ _tmp182 Goto _L17
	  lw $t0, -168($fp)	# fill _tmp182 to $t0 from $fp-168
	  beqz $t0, _L17	# branch if _tmp182 is zero 
	# _tmp183 = "Decaf runtime error: Array subscript out of bound..."
	  .data			# create string constant marked with label
	  _string10: .asciiz "Decaf runtime error: Array subscript out of bounds\n"
	  .text
	  la $t2, _string10	# load label
	  sw $t2, -172($fp)	# spill _tmp183 from $t2 to $fp-172
	# PushParam _tmp183
	  subu $sp, $sp, 4	# decrement sp to make space for param
	  lw $t0, -172($fp)	# fill _tmp183 to $t0 from $fp-172
	  sw $t0, 4($sp)	# copy param value to stack
	# LCall _PrintString
	  jal _PrintString   	# jump to function
	# PopParams 4
	  add $sp, $sp, 4	# pop params off stack
	# LCall _Halt
	  jal _Halt          	# jump to function
  _L17:
	# _tmp184 = 4
	  li $t2, 4		# load constant value 4 into $t2
	  sw $t2, -176($fp)	# spill _tmp184 from $t2 to $fp-176
	# _tmp185 = i * _tmp184
	  lw $t0, -8($fp)	# fill i to $t0 from $fp-8
	  lw $t1, -176($fp)	# fill _tmp184 to $t1 from $fp-176
	  mul $t2, $t0, $t1	
	  sw $t2, -180($fp)	# spill _tmp185 from $t2 to $fp-180
	# _tmp186 = _tmp185 + _tmp184
	  lw $t0, -180($fp)	# fill _tmp185 to $t0 from $fp-180
	  lw $t1, -176($fp)	# fill _tmp184 to $t1 from $fp-176
	  add $t2, $t0, $t1	
	  sw $t2, -184($fp)	# spill _tmp186 from $t2 to $fp-184
	# _tmp187 = _tmp175 + _tmp186
	  lw $t0, -140($fp)	# fill _tmp175 to $t0 from $fp-140
	  lw $t1, -184($fp)	# fill _tmp186 to $t1 from $fp-184
	  add $t2, $t0, $t1	
	  sw $t2, -188($fp)	# spill _tmp187 from $t2 to $fp-188
	# _tmp188 = *(_tmp187)
	  lw $t0, -188($fp)	# fill _tmp187 to $t0 from $fp-188
	  lw $t2, 0($t0) 	# load with offset
	  sw $t2, -192($fp)	# spill _tmp188 from $t2 to $fp-192
	# PushParam _tmp188
	  subu $sp, $sp, 4	# decrement sp to make space for param
	  lw $t0, -192($fp)	# fill _tmp188 to $t0 from $fp-192
	  sw $t0, 4($sp)	# copy param value to stack
	# _tmp189 = *(_tmp188)
	  lw $t0, -192($fp)	# fill _tmp188 to $t0 from $fp-192
	  lw $t2, 0($t0) 	# load with offset
	  sw $t2, -196($fp)	# spill _tmp189 from $t2 to $fp-196
	# _tmp190 = *(_tmp189)
	  lw $t0, -196($fp)	# fill _tmp189 to $t0 from $fp-196
	  lw $t2, 0($t0) 	# load with offset
	  sw $t2, -200($fp)	# spill _tmp190 from $t2 to $fp-200
	# ACall _tmp190
	  lw $t0, -200($fp)	# fill _tmp190 to $t0 from $fp-200
	  jalr $t0            	# jump to function
	# PopParams 4
	  add $sp, $sp, 4	# pop params off stack
	# _tmp191 = 1
	  li $t2, 1		# load constant value 1 into $t2
	  sw $t2, -204($fp)	# spill _tmp191 from $t2 to $fp-204
	# _tmp192 = i + _tmp191
	  lw $t0, -8($fp)	# fill i to $t0 from $fp-8
	  lw $t1, -204($fp)	# fill _tmp191 to $t1 from $fp-204
	  add $t2, $t0, $t1	
	  sw $t2, -208($fp)	# spill _tmp192 from $t2 to $fp-208
	# i = _tmp192
	  lw $t2, -208($fp)	# fill _tmp192 to $t2 from $fp-208
	  sw $t2, -8($fp)	# spill i from $t2 to $fp-8
	# Goto _L14
	  b _L14		# unconditional branch
  _L15:
	# EndFunc
	# (below handles reaching end of fn body with no explicit return)
	  move $sp, $fp		# pop callee frame off stack
	  lw $ra, -4($fp)	# restore saved ra
	  lw $fp, 0($fp)	# restore saved fp
	  jr $ra		# return from function
  BJDeck.____DealCard:
	# BeginFunc 192
	  subu $sp, $sp, 8	# decrement sp to make space to save ra, fp
	  sw $fp, 8($sp)	# save fp
	  sw $ra, 4($sp)	# save ra
	  addiu $fp, $sp, 8	# set up new fp
	  subu $sp, $sp, 192	# decrement sp to make space for locals/temps
	# _tmp193 = 0
	  li $t2, 0		# load constant value 0 into $t2
	  sw $t2, -12($fp)	# spill _tmp193 from $t2 to $fp-12
	# c = _tmp193
	  lw $t2, -12($fp)	# fill _tmp193 to $t2 from $fp-12
	  sw $t2, -8($fp)	# spill c from $t2 to $fp-8
	# _tmp194 = 8
	  li $t2, 8		# load constant value 8 into $t2
	  sw $t2, -16($fp)	# spill _tmp194 from $t2 to $fp-16
	# _tmp195 = 52
	  li $t2, 52		# load constant value 52 into $t2
	  sw $t2, -20($fp)	# spill _tmp195 from $t2 to $fp-20
	# _tmp196 = _tmp194 * _tmp195
	  lw $t0, -16($fp)	# fill _tmp194 to $t0 from $fp-16
	  lw $t1, -20($fp)	# fill _tmp195 to $t1 from $fp-20
	  mul $t2, $t0, $t1	
	  sw $t2, -24($fp)	# spill _tmp196 from $t2 to $fp-24
	# _tmp197 = *(this + 8)
	  lw $t0, 4($fp)	# fill this to $t0 from $fp+4
	  lw $t2, 8($t0) 	# load with offset
	  sw $t2, -28($fp)	# spill _tmp197 from $t2 to $fp-28
	# _tmp198 = _tmp196 < _tmp197
	  lw $t0, -24($fp)	# fill _tmp196 to $t0 from $fp-24
	  lw $t1, -28($fp)	# fill _tmp197 to $t1 from $fp-28
	  slt $t2, $t0, $t1	
	  sw $t2, -32($fp)	# spill _tmp198 from $t2 to $fp-32
	# _tmp199 = _tmp196 == _tmp197
	  lw $t0, -24($fp)	# fill _tmp196 to $t0 from $fp-24
	  lw $t1, -28($fp)	# fill _tmp197 to $t1 from $fp-28
	  seq $t2, $t0, $t1	
	  sw $t2, -36($fp)	# spill _tmp199 from $t2 to $fp-36
	# _tmp200 = _tmp198 || _tmp199
	  lw $t0, -32($fp)	# fill _tmp198 to $t0 from $fp-32
	  lw $t1, -36($fp)	# fill _tmp199 to $t1 from $fp-36
	  or $t2, $t0, $t1	
	  sw $t2, -40($fp)	# spill _tmp200 from $t2 to $fp-40
	# IfZ _tmp200 Goto _L18
	  lw $t0, -40($fp)	# fill _tmp200 to $t0 from $fp-40
	  beqz $t0, _L18	# branch if _tmp200 is zero 
	# _tmp201 = 11
	  li $t2, 11		# load constant value 11 into $t2
	  sw $t2, -44($fp)	# spill _tmp201 from $t2 to $fp-44
	# Return _tmp201
	  lw $t2, -44($fp)	# fill _tmp201 to $t2 from $fp-44
	  move $v0, $t2		# assign return value into $v0
	  move $sp, $fp		# pop callee frame off stack
	  lw $ra, -4($fp)	# restore saved ra
	  lw $fp, 0($fp)	# restore saved fp
	  jr $ra		# return from function
	# Goto _L19
	  b _L19		# unconditional branch
  _L18:
  _L19:
  _L20:
	# _tmp202 = 0
	  li $t2, 0		# load constant value 0 into $t2
	  sw $t2, -48($fp)	# spill _tmp202 from $t2 to $fp-48
	# _tmp203 = c == _tmp202
	  lw $t0, -8($fp)	# fill c to $t0 from $fp-8
	  lw $t1, -48($fp)	# fill _tmp202 to $t1 from $fp-48
	  seq $t2, $t0, $t1	
	  sw $t2, -52($fp)	# spill _tmp203 from $t2 to $fp-52
	# IfZ _tmp203 Goto _L21
	  lw $t0, -52($fp)	# fill _tmp203 to $t0 from $fp-52
	  beqz $t0, _L21	# branch if _tmp203 is zero 
	# _tmp204 = 8
	  li $t2, 8		# load constant value 8 into $t2
	  sw $t2, -60($fp)	# spill _tmp204 from $t2 to $fp-60
	# PushParam _tmp204
	  subu $sp, $sp, 4	# decrement sp to make space for param
	  lw $t0, -60($fp)	# fill _tmp204 to $t0 from $fp-60
	  sw $t0, 4($sp)	# copy param value to stack
	# PushParam gRnd
	  subu $sp, $sp, 4	# decrement sp to make space for param
	  lw $t0, 0($gp)	# fill gRnd to $t0 from $gp+0
	  sw $t0, 4($sp)	# copy param value to stack
	# _tmp205 = *(gRnd)
	  lw $t0, 0($gp)	# fill gRnd to $t0 from $gp+0
	  lw $t2, 0($t0) 	# load with offset
	  sw $t2, -64($fp)	# spill _tmp205 from $t2 to $fp-64
	# _tmp206 = *(_tmp205 + 8)
	  lw $t0, -64($fp)	# fill _tmp205 to $t0 from $fp-64
	  lw $t2, 8($t0) 	# load with offset
	  sw $t2, -68($fp)	# spill _tmp206 from $t2 to $fp-68
	# _tmp207 = ACall _tmp206
	  lw $t0, -68($fp)	# fill _tmp206 to $t0 from $fp-68
	  jalr $t0            	# jump to function
	  move $t2, $v0		# copy function return value from $v0
	  sw $t2, -72($fp)	# spill _tmp207 from $t2 to $fp-72
	# PopParams 8
	  add $sp, $sp, 8	# pop params off stack
	# d = _tmp207
	  lw $t2, -72($fp)	# fill _tmp207 to $t2 from $fp-72
	  sw $t2, -56($fp)	# spill d from $t2 to $fp-56
	# _tmp208 = *(this + 4)
	  lw $t0, 4($fp)	# fill this to $t0 from $fp+4
	  lw $t2, 4($t0) 	# load with offset
	  sw $t2, -76($fp)	# spill _tmp208 from $t2 to $fp-76
	# _tmp209 = 0
	  li $t2, 0		# load constant value 0 into $t2
	  sw $t2, -80($fp)	# spill _tmp209 from $t2 to $fp-80
	# _tmp210 = *(_tmp208)
	  lw $t0, -76($fp)	# fill _tmp208 to $t0 from $fp-76
	  lw $t2, 0($t0) 	# load with offset
	  sw $t2, -84($fp)	# spill _tmp210 from $t2 to $fp-84
	# _tmp211 = d < _tmp209
	  lw $t0, -56($fp)	# fill d to $t0 from $fp-56
	  lw $t1, -80($fp)	# fill _tmp209 to $t1 from $fp-80
	  slt $t2, $t0, $t1	
	  sw $t2, -88($fp)	# spill _tmp211 from $t2 to $fp-88
	# _tmp212 = _tmp210 < d
	  lw $t0, -84($fp)	# fill _tmp210 to $t0 from $fp-84
	  lw $t1, -56($fp)	# fill d to $t1 from $fp-56
	  slt $t2, $t0, $t1	
	  sw $t2, -92($fp)	# spill _tmp212 from $t2 to $fp-92
	# _tmp213 = _tmp210 == d
	  lw $t0, -84($fp)	# fill _tmp210 to $t0 from $fp-84
	  lw $t1, -56($fp)	# fill d to $t1 from $fp-56
	  seq $t2, $t0, $t1	
	  sw $t2, -96($fp)	# spill _tmp213 from $t2 to $fp-96
	# _tmp214 = _tmp212 || _tmp213
	  lw $t0, -92($fp)	# fill _tmp212 to $t0 from $fp-92
	  lw $t1, -96($fp)	# fill _tmp213 to $t1 from $fp-96
	  or $t2, $t0, $t1	
	  sw $t2, -100($fp)	# spill _tmp214 from $t2 to $fp-100
	# _tmp215 = _tmp214 || _tmp211
	  lw $t0, -100($fp)	# fill _tmp214 to $t0 from $fp-100
	  lw $t1, -88($fp)	# fill _tmp211 to $t1 from $fp-88
	  or $t2, $t0, $t1	
	  sw $t2, -104($fp)	# spill _tmp215 from $t2 to $fp-104
	# IfZ _tmp215 Goto _L22
	  lw $t0, -104($fp)	# fill _tmp215 to $t0 from $fp-104
	  beqz $t0, _L22	# branch if _tmp215 is zero 
	# _tmp216 = "Decaf runtime error: Array subscript out of bound..."
	  .data			# create string constant marked with label
	  _string11: .asciiz "Decaf runtime error: Array subscript out of bounds\n"
	  .text
	  la $t2, _string11	# load label
	  sw $t2, -108($fp)	# spill _tmp216 from $t2 to $fp-108
	# PushParam _tmp216
	  subu $sp, $sp, 4	# decrement sp to make space for param
	  lw $t0, -108($fp)	# fill _tmp216 to $t0 from $fp-108
	  sw $t0, 4($sp)	# copy param value to stack
	# LCall _PrintString
	  jal _PrintString   	# jump to function
	# PopParams 4
	  add $sp, $sp, 4	# pop params off stack
	# LCall _Halt
	  jal _Halt          	# jump to function
  _L22:
	# _tmp217 = 4
	  li $t2, 4		# load constant value 4 into $t2
	  sw $t2, -112($fp)	# spill _tmp217 from $t2 to $fp-112
	# _tmp218 = d * _tmp217
	  lw $t0, -56($fp)	# fill d to $t0 from $fp-56
	  lw $t1, -112($fp)	# fill _tmp217 to $t1 from $fp-112
	  mul $t2, $t0, $t1	
	  sw $t2, -116($fp)	# spill _tmp218 from $t2 to $fp-116
	# _tmp219 = _tmp218 + _tmp217
	  lw $t0, -116($fp)	# fill _tmp218 to $t0 from $fp-116
	  lw $t1, -112($fp)	# fill _tmp217 to $t1 from $fp-112
	  add $t2, $t0, $t1	
	  sw $t2, -120($fp)	# spill _tmp219 from $t2 to $fp-120
	# _tmp220 = _tmp208 + _tmp219
	  lw $t0, -76($fp)	# fill _tmp208 to $t0 from $fp-76
	  lw $t1, -120($fp)	# fill _tmp219 to $t1 from $fp-120
	  add $t2, $t0, $t1	
	  sw $t2, -124($fp)	# spill _tmp220 from $t2 to $fp-124
	# _tmp221 = *(_tmp220)
	  lw $t0, -124($fp)	# fill _tmp220 to $t0 from $fp-124
	  lw $t2, 0($t0) 	# load with offset
	  sw $t2, -128($fp)	# spill _tmp221 from $t2 to $fp-128
	# PushParam _tmp221
	  subu $sp, $sp, 4	# decrement sp to make space for param
	  lw $t0, -128($fp)	# fill _tmp221 to $t0 from $fp-128
	  sw $t0, 4($sp)	# copy param value to stack
	# _tmp222 = *(_tmp221)
	  lw $t0, -128($fp)	# fill _tmp221 to $t0 from $fp-128
	  lw $t2, 0($t0) 	# load with offset
	  sw $t2, -132($fp)	# spill _tmp222 from $t2 to $fp-132
	# _tmp223 = *(_tmp222 + 8)
	  lw $t0, -132($fp)	# fill _tmp222 to $t0 from $fp-132
	  lw $t2, 8($t0) 	# load with offset
	  sw $t2, -136($fp)	# spill _tmp223 from $t2 to $fp-136
	# _tmp224 = ACall _tmp223
	  lw $t0, -136($fp)	# fill _tmp223 to $t0 from $fp-136
	  jalr $t0            	# jump to function
	  move $t2, $v0		# copy function return value from $v0
	  sw $t2, -140($fp)	# spill _tmp224 from $t2 to $fp-140
	# PopParams 4
	  add $sp, $sp, 4	# pop params off stack
	# c = _tmp224
	  lw $t2, -140($fp)	# fill _tmp224 to $t2 from $fp-140
	  sw $t2, -8($fp)	# spill c from $t2 to $fp-8
	# Goto _L20
	  b _L20		# unconditional branch
  _L21:
	# _tmp225 = 10
	  li $t2, 10		# load constant value 10 into $t2
	  sw $t2, -144($fp)	# spill _tmp225 from $t2 to $fp-144
	# _tmp226 = _tmp225 < c
	  lw $t0, -144($fp)	# fill _tmp225 to $t0 from $fp-144
	  lw $t1, -8($fp)	# fill c to $t1 from $fp-8
	  slt $t2, $t0, $t1	
	  sw $t2, -148($fp)	# spill _tmp226 from $t2 to $fp-148
	# IfZ _tmp226 Goto _L23
	  lw $t0, -148($fp)	# fill _tmp226 to $t0 from $fp-148
	  beqz $t0, _L23	# branch if _tmp226 is zero 
	# _tmp227 = 10
	  li $t2, 10		# load constant value 10 into $t2
	  sw $t2, -152($fp)	# spill _tmp227 from $t2 to $fp-152
	# c = _tmp227
	  lw $t2, -152($fp)	# fill _tmp227 to $t2 from $fp-152
	  sw $t2, -8($fp)	# spill c from $t2 to $fp-8
	# Goto _L24
	  b _L24		# unconditional branch
  _L23:
	# _tmp228 = 1
	  li $t2, 1		# load constant value 1 into $t2
	  sw $t2, -156($fp)	# spill _tmp228 from $t2 to $fp-156
	# _tmp229 = c == _tmp228
	  lw $t0, -8($fp)	# fill c to $t0 from $fp-8
	  lw $t1, -156($fp)	# fill _tmp228 to $t1 from $fp-156
	  seq $t2, $t0, $t1	
	  sw $t2, -160($fp)	# spill _tmp229 from $t2 to $fp-160
	# IfZ _tmp229 Goto _L25
	  lw $t0, -160($fp)	# fill _tmp229 to $t0 from $fp-160
	  beqz $t0, _L25	# branch if _tmp229 is zero 
	# _tmp230 = 11
	  li $t2, 11		# load constant value 11 into $t2
	  sw $t2, -164($fp)	# spill _tmp230 from $t2 to $fp-164
	# c = _tmp230
	  lw $t2, -164($fp)	# fill _tmp230 to $t2 from $fp-164
	  sw $t2, -8($fp)	# spill c from $t2 to $fp-8
	# Goto _L26
	  b _L26		# unconditional branch
  _L25:
  _L26:
  _L24:
	# _tmp231 = *(this + 8)
	  lw $t0, 4($fp)	# fill this to $t0 from $fp+4
	  lw $t2, 8($t0) 	# load with offset
	  sw $t2, -168($fp)	# spill _tmp231 from $t2 to $fp-168
	# _tmp232 = 1
	  li $t2, 1		# load constant value 1 into $t2
	  sw $t2, -172($fp)	# spill _tmp232 from $t2 to $fp-172
	# _tmp233 = _tmp231 + _tmp232
	  lw $t0, -168($fp)	# fill _tmp231 to $t0 from $fp-168
	  lw $t1, -172($fp)	# fill _tmp232 to $t1 from $fp-172
	  add $t2, $t0, $t1	
	  sw $t2, -176($fp)	# spill _tmp233 from $t2 to $fp-176
	# *(this + 8) = _tmp233
	  lw $t0, -176($fp)	# fill _tmp233 to $t0 from $fp-176
	  lw $t2, 4($fp)	# fill this to $t2 from $fp+4
	  sw $t0, 8($t2) 	# store with offset
	# Return c
	  lw $t2, -8($fp)	# fill c to $t2 from $fp-8
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
  BJDeck.____Shuffle:
	# BeginFunc 112
	  subu $sp, $sp, 8	# decrement sp to make space to save ra, fp
	  sw $fp, 8($sp)	# save fp
	  sw $ra, 4($sp)	# save ra
	  addiu $fp, $sp, 8	# set up new fp
	  subu $sp, $sp, 112	# decrement sp to make space for locals/temps
	# _tmp234 = "Shuffling..."
	  .data			# create string constant marked with label
	  _string12: .asciiz "Shuffling..."
	  .text
	  la $t2, _string12	# load label
	  sw $t2, -12($fp)	# spill _tmp234 from $t2 to $fp-12
	# PushParam _tmp234
	  subu $sp, $sp, 4	# decrement sp to make space for param
	  lw $t0, -12($fp)	# fill _tmp234 to $t0 from $fp-12
	  sw $t0, 4($sp)	# copy param value to stack
	# LCall _PrintString
	  jal _PrintString   	# jump to function
	# PopParams 4
	  add $sp, $sp, 4	# pop params off stack
	# _tmp235 = 0
	  li $t2, 0		# load constant value 0 into $t2
	  sw $t2, -16($fp)	# spill _tmp235 from $t2 to $fp-16
	# i = _tmp235
	  lw $t2, -16($fp)	# fill _tmp235 to $t2 from $fp-16
	  sw $t2, -8($fp)	# spill i from $t2 to $fp-8
  _L27:
	# _tmp236 = 8
	  li $t2, 8		# load constant value 8 into $t2
	  sw $t2, -20($fp)	# spill _tmp236 from $t2 to $fp-20
	# _tmp237 = i < _tmp236
	  lw $t0, -8($fp)	# fill i to $t0 from $fp-8
	  lw $t1, -20($fp)	# fill _tmp236 to $t1 from $fp-20
	  slt $t2, $t0, $t1	
	  sw $t2, -24($fp)	# spill _tmp237 from $t2 to $fp-24
	# IfZ _tmp237 Goto _L28
	  lw $t0, -24($fp)	# fill _tmp237 to $t0 from $fp-24
	  beqz $t0, _L28	# branch if _tmp237 is zero 
	# _tmp238 = *(this + 4)
	  lw $t0, 4($fp)	# fill this to $t0 from $fp+4
	  lw $t2, 4($t0) 	# load with offset
	  sw $t2, -28($fp)	# spill _tmp238 from $t2 to $fp-28
	# _tmp239 = 0
	  li $t2, 0		# load constant value 0 into $t2
	  sw $t2, -32($fp)	# spill _tmp239 from $t2 to $fp-32
	# _tmp240 = *(_tmp238)
	  lw $t0, -28($fp)	# fill _tmp238 to $t0 from $fp-28
	  lw $t2, 0($t0) 	# load with offset
	  sw $t2, -36($fp)	# spill _tmp240 from $t2 to $fp-36
	# _tmp241 = i < _tmp239
	  lw $t0, -8($fp)	# fill i to $t0 from $fp-8
	  lw $t1, -32($fp)	# fill _tmp239 to $t1 from $fp-32
	  slt $t2, $t0, $t1	
	  sw $t2, -40($fp)	# spill _tmp241 from $t2 to $fp-40
	# _tmp242 = _tmp240 < i
	  lw $t0, -36($fp)	# fill _tmp240 to $t0 from $fp-36
	  lw $t1, -8($fp)	# fill i to $t1 from $fp-8
	  slt $t2, $t0, $t1	
	  sw $t2, -44($fp)	# spill _tmp242 from $t2 to $fp-44
	# _tmp243 = _tmp240 == i
	  lw $t0, -36($fp)	# fill _tmp240 to $t0 from $fp-36
	  lw $t1, -8($fp)	# fill i to $t1 from $fp-8
	  seq $t2, $t0, $t1	
	  sw $t2, -48($fp)	# spill _tmp243 from $t2 to $fp-48
	# _tmp244 = _tmp242 || _tmp243
	  lw $t0, -44($fp)	# fill _tmp242 to $t0 from $fp-44
	  lw $t1, -48($fp)	# fill _tmp243 to $t1 from $fp-48
	  or $t2, $t0, $t1	
	  sw $t2, -52($fp)	# spill _tmp244 from $t2 to $fp-52
	# _tmp245 = _tmp244 || _tmp241
	  lw $t0, -52($fp)	# fill _tmp244 to $t0 from $fp-52
	  lw $t1, -40($fp)	# fill _tmp241 to $t1 from $fp-40
	  or $t2, $t0, $t1	
	  sw $t2, -56($fp)	# spill _tmp245 from $t2 to $fp-56
	# IfZ _tmp245 Goto _L29
	  lw $t0, -56($fp)	# fill _tmp245 to $t0 from $fp-56
	  beqz $t0, _L29	# branch if _tmp245 is zero 
	# _tmp246 = "Decaf runtime error: Array subscript out of bound..."
	  .data			# create string constant marked with label
	  _string13: .asciiz "Decaf runtime error: Array subscript out of bounds\n"
	  .text
	  la $t2, _string13	# load label
	  sw $t2, -60($fp)	# spill _tmp246 from $t2 to $fp-60
	# PushParam _tmp246
	  subu $sp, $sp, 4	# decrement sp to make space for param
	  lw $t0, -60($fp)	# fill _tmp246 to $t0 from $fp-60
	  sw $t0, 4($sp)	# copy param value to stack
	# LCall _PrintString
	  jal _PrintString   	# jump to function
	# PopParams 4
	  add $sp, $sp, 4	# pop params off stack
	# LCall _Halt
	  jal _Halt          	# jump to function
  _L29:
	# _tmp247 = 4
	  li $t2, 4		# load constant value 4 into $t2
	  sw $t2, -64($fp)	# spill _tmp247 from $t2 to $fp-64
	# _tmp248 = i * _tmp247
	  lw $t0, -8($fp)	# fill i to $t0 from $fp-8
	  lw $t1, -64($fp)	# fill _tmp247 to $t1 from $fp-64
	  mul $t2, $t0, $t1	
	  sw $t2, -68($fp)	# spill _tmp248 from $t2 to $fp-68
	# _tmp249 = _tmp248 + _tmp247
	  lw $t0, -68($fp)	# fill _tmp248 to $t0 from $fp-68
	  lw $t1, -64($fp)	# fill _tmp247 to $t1 from $fp-64
	  add $t2, $t0, $t1	
	  sw $t2, -72($fp)	# spill _tmp249 from $t2 to $fp-72
	# _tmp250 = _tmp238 + _tmp249
	  lw $t0, -28($fp)	# fill _tmp238 to $t0 from $fp-28
	  lw $t1, -72($fp)	# fill _tmp249 to $t1 from $fp-72
	  add $t2, $t0, $t1	
	  sw $t2, -76($fp)	# spill _tmp250 from $t2 to $fp-76
	# _tmp251 = *(_tmp250)
	  lw $t0, -76($fp)	# fill _tmp250 to $t0 from $fp-76
	  lw $t2, 0($t0) 	# load with offset
	  sw $t2, -80($fp)	# spill _tmp251 from $t2 to $fp-80
	# PushParam _tmp251
	  subu $sp, $sp, 4	# decrement sp to make space for param
	  lw $t0, -80($fp)	# fill _tmp251 to $t0 from $fp-80
	  sw $t0, 4($sp)	# copy param value to stack
	# _tmp252 = *(_tmp251)
	  lw $t0, -80($fp)	# fill _tmp251 to $t0 from $fp-80
	  lw $t2, 0($t0) 	# load with offset
	  sw $t2, -84($fp)	# spill _tmp252 from $t2 to $fp-84
	# _tmp253 = *(_tmp252 + 4)
	  lw $t0, -84($fp)	# fill _tmp252 to $t0 from $fp-84
	  lw $t2, 4($t0) 	# load with offset
	  sw $t2, -88($fp)	# spill _tmp253 from $t2 to $fp-88
	# ACall _tmp253
	  lw $t0, -88($fp)	# fill _tmp253 to $t0 from $fp-88
	  jalr $t0            	# jump to function
	# PopParams 4
	  add $sp, $sp, 4	# pop params off stack
	# _tmp254 = 1
	  li $t2, 1		# load constant value 1 into $t2
	  sw $t2, -92($fp)	# spill _tmp254 from $t2 to $fp-92
	# _tmp255 = i + _tmp254
	  lw $t0, -8($fp)	# fill i to $t0 from $fp-8
	  lw $t1, -92($fp)	# fill _tmp254 to $t1 from $fp-92
	  add $t2, $t0, $t1	
	  sw $t2, -96($fp)	# spill _tmp255 from $t2 to $fp-96
	# i = _tmp255
	  lw $t2, -96($fp)	# fill _tmp255 to $t2 from $fp-96
	  sw $t2, -8($fp)	# spill i from $t2 to $fp-8
	# Goto _L27
	  b _L27		# unconditional branch
  _L28:
	# _tmp256 = 0
	  li $t2, 0		# load constant value 0 into $t2
	  sw $t2, -100($fp)	# spill _tmp256 from $t2 to $fp-100
	# *(this + 8) = _tmp256
	  lw $t0, -100($fp)	# fill _tmp256 to $t0 from $fp-100
	  lw $t2, 4($fp)	# fill this to $t2 from $fp+4
	  sw $t0, 8($t2) 	# store with offset
	# _tmp257 = "done.\n"
	  .data			# create string constant marked with label
	  _string14: .asciiz "done.\n"
	  .text
	  la $t2, _string14	# load label
	  sw $t2, -104($fp)	# spill _tmp257 from $t2 to $fp-104
	# PushParam _tmp257
	  subu $sp, $sp, 4	# decrement sp to make space for param
	  lw $t0, -104($fp)	# fill _tmp257 to $t0 from $fp-104
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
  BJDeck.____NumCardsRemaining:
	# BeginFunc 20
	  subu $sp, $sp, 8	# decrement sp to make space to save ra, fp
	  sw $fp, 8($sp)	# save fp
	  sw $ra, 4($sp)	# save ra
	  addiu $fp, $sp, 8	# set up new fp
	  subu $sp, $sp, 20	# decrement sp to make space for locals/temps
	# _tmp258 = 8
	  li $t2, 8		# load constant value 8 into $t2
	  sw $t2, -8($fp)	# spill _tmp258 from $t2 to $fp-8
	# _tmp259 = 52
	  li $t2, 52		# load constant value 52 into $t2
	  sw $t2, -12($fp)	# spill _tmp259 from $t2 to $fp-12
	# _tmp260 = _tmp258 * _tmp259
	  lw $t0, -8($fp)	# fill _tmp258 to $t0 from $fp-8
	  lw $t1, -12($fp)	# fill _tmp259 to $t1 from $fp-12
	  mul $t2, $t0, $t1	
	  sw $t2, -16($fp)	# spill _tmp260 from $t2 to $fp-16
	# _tmp261 = *(this + 8)
	  lw $t0, 4($fp)	# fill this to $t0 from $fp+4
	  lw $t2, 8($t0) 	# load with offset
	  sw $t2, -20($fp)	# spill _tmp261 from $t2 to $fp-20
	# _tmp262 = _tmp260 - _tmp261
	  lw $t0, -16($fp)	# fill _tmp260 to $t0 from $fp-16
	  lw $t1, -20($fp)	# fill _tmp261 to $t1 from $fp-20
	  sub $t2, $t0, $t1	
	  sw $t2, -24($fp)	# spill _tmp262 from $t2 to $fp-24
	# Return _tmp262
	  lw $t2, -24($fp)	# fill _tmp262 to $t2 from $fp-24
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
	# VTable for class BJDeck
	  .data
	  .align 2
	  BJDeck:		# label for class BJDeck vtable
	  .word BJDeck.____Init
	  .word BJDeck.____DealCard
	  .word BJDeck.____Shuffle
	  .word BJDeck.____NumCardsRemaining
	  .text
  Player.____Init:
	# BeginFunc 16
	  subu $sp, $sp, 8	# decrement sp to make space to save ra, fp
	  sw $fp, 8($sp)	# save fp
	  sw $ra, 4($sp)	# save ra
	  addiu $fp, $sp, 8	# set up new fp
	  subu $sp, $sp, 16	# decrement sp to make space for locals/temps
	# _tmp263 = 1000
	  li $t2, 1000		# load constant value 1000 into $t2
	  sw $t2, -8($fp)	# spill _tmp263 from $t2 to $fp-8
	# *(this + 20) = _tmp263
	  lw $t0, -8($fp)	# fill _tmp263 to $t0 from $fp-8
	  lw $t2, 4($fp)	# fill this to $t2 from $fp+4
	  sw $t0, 20($t2) 	# store with offset
	# _tmp264 = "What is the name of player #"
	  .data			# create string constant marked with label
	  _string15: .asciiz "What is the name of player #"
	  .text
	  la $t2, _string15	# load label
	  sw $t2, -12($fp)	# spill _tmp264 from $t2 to $fp-12
	# PushParam _tmp264
	  subu $sp, $sp, 4	# decrement sp to make space for param
	  lw $t0, -12($fp)	# fill _tmp264 to $t0 from $fp-12
	  sw $t0, 4($sp)	# copy param value to stack
	# LCall _PrintString
	  jal _PrintString   	# jump to function
	# PopParams 4
	  add $sp, $sp, 4	# pop params off stack
	# PushParam num
	  subu $sp, $sp, 4	# decrement sp to make space for param
	  lw $t0, 8($fp)	# fill num to $t0 from $fp+8
	  sw $t0, 4($sp)	# copy param value to stack
	# LCall _PrintInt
	  jal _PrintInt      	# jump to function
	# PopParams 4
	  add $sp, $sp, 4	# pop params off stack
	# _tmp265 = "? "
	  .data			# create string constant marked with label
	  _string16: .asciiz "? "
	  .text
	  la $t2, _string16	# load label
	  sw $t2, -16($fp)	# spill _tmp265 from $t2 to $fp-16
	# PushParam _tmp265
	  subu $sp, $sp, 4	# decrement sp to make space for param
	  lw $t0, -16($fp)	# fill _tmp265 to $t0 from $fp-16
	  sw $t0, 4($sp)	# copy param value to stack
	# LCall _PrintString
	  jal _PrintString   	# jump to function
	# PopParams 4
	  add $sp, $sp, 4	# pop params off stack
	# _tmp266 = LCall _ReadLine
	  jal _ReadLine      	# jump to function
	  move $t2, $v0		# copy function return value from $v0
	  sw $t2, -20($fp)	# spill _tmp266 from $t2 to $fp-20
	# *(this + 24) = _tmp266
	  lw $t0, -20($fp)	# fill _tmp266 to $t0 from $fp-20
	  lw $t2, 4($fp)	# fill this to $t2 from $fp+4
	  sw $t0, 24($t2) 	# store with offset
	# EndFunc
	# (below handles reaching end of fn body with no explicit return)
	  move $sp, $fp		# pop callee frame off stack
	  lw $ra, -4($fp)	# restore saved ra
	  lw $fp, 0($fp)	# restore saved fp
	  jr $ra		# return from function
  Player.____Hit:
	# BeginFunc 132
	  subu $sp, $sp, 8	# decrement sp to make space to save ra, fp
	  sw $fp, 8($sp)	# save fp
	  sw $ra, 4($sp)	# save ra
	  addiu $fp, $sp, 8	# set up new fp
	  subu $sp, $sp, 132	# decrement sp to make space for locals/temps
	# PushParam deck
	  subu $sp, $sp, 4	# decrement sp to make space for param
	  lw $t0, 8($fp)	# fill deck to $t0 from $fp+8
	  sw $t0, 4($sp)	# copy param value to stack
	# _tmp267 = *(deck)
	  lw $t0, 8($fp)	# fill deck to $t0 from $fp+8
	  lw $t2, 0($t0) 	# load with offset
	  sw $t2, -12($fp)	# spill _tmp267 from $t2 to $fp-12
	# _tmp268 = *(_tmp267 + 4)
	  lw $t0, -12($fp)	# fill _tmp267 to $t0 from $fp-12
	  lw $t2, 4($t0) 	# load with offset
	  sw $t2, -16($fp)	# spill _tmp268 from $t2 to $fp-16
	# _tmp269 = ACall _tmp268
	  lw $t0, -16($fp)	# fill _tmp268 to $t0 from $fp-16
	  jalr $t0            	# jump to function
	  move $t2, $v0		# copy function return value from $v0
	  sw $t2, -20($fp)	# spill _tmp269 from $t2 to $fp-20
	# PopParams 4
	  add $sp, $sp, 4	# pop params off stack
	# card = _tmp269
	  lw $t2, -20($fp)	# fill _tmp269 to $t2 from $fp-20
	  sw $t2, -8($fp)	# spill card from $t2 to $fp-8
	# _tmp270 = *(this + 24)
	  lw $t0, 4($fp)	# fill this to $t0 from $fp+4
	  lw $t2, 24($t0) 	# load with offset
	  sw $t2, -24($fp)	# spill _tmp270 from $t2 to $fp-24
	# PushParam _tmp270
	  subu $sp, $sp, 4	# decrement sp to make space for param
	  lw $t0, -24($fp)	# fill _tmp270 to $t0 from $fp-24
	  sw $t0, 4($sp)	# copy param value to stack
	# LCall _PrintString
	  jal _PrintString   	# jump to function
	# PopParams 4
	  add $sp, $sp, 4	# pop params off stack
	# _tmp271 = " was dealt a "
	  .data			# create string constant marked with label
	  _string17: .asciiz " was dealt a "
	  .text
	  la $t2, _string17	# load label
	  sw $t2, -28($fp)	# spill _tmp271 from $t2 to $fp-28
	# PushParam _tmp271
	  subu $sp, $sp, 4	# decrement sp to make space for param
	  lw $t0, -28($fp)	# fill _tmp271 to $t0 from $fp-28
	  sw $t0, 4($sp)	# copy param value to stack
	# LCall _PrintString
	  jal _PrintString   	# jump to function
	# PopParams 4
	  add $sp, $sp, 4	# pop params off stack
	# PushParam card
	  subu $sp, $sp, 4	# decrement sp to make space for param
	  lw $t0, -8($fp)	# fill card to $t0 from $fp-8
	  sw $t0, 4($sp)	# copy param value to stack
	# LCall _PrintInt
	  jal _PrintInt      	# jump to function
	# PopParams 4
	  add $sp, $sp, 4	# pop params off stack
	# _tmp272 = ".\n"
	  .data			# create string constant marked with label
	  _string18: .asciiz ".\n"
	  .text
	  la $t2, _string18	# load label
	  sw $t2, -32($fp)	# spill _tmp272 from $t2 to $fp-32
	# PushParam _tmp272
	  subu $sp, $sp, 4	# decrement sp to make space for param
	  lw $t0, -32($fp)	# fill _tmp272 to $t0 from $fp-32
	  sw $t0, 4($sp)	# copy param value to stack
	# LCall _PrintString
	  jal _PrintString   	# jump to function
	# PopParams 4
	  add $sp, $sp, 4	# pop params off stack
	# _tmp273 = *(this + 4)
	  lw $t0, 4($fp)	# fill this to $t0 from $fp+4
	  lw $t2, 4($t0) 	# load with offset
	  sw $t2, -36($fp)	# spill _tmp273 from $t2 to $fp-36
	# _tmp274 = _tmp273 + card
	  lw $t0, -36($fp)	# fill _tmp273 to $t0 from $fp-36
	  lw $t1, -8($fp)	# fill card to $t1 from $fp-8
	  add $t2, $t0, $t1	
	  sw $t2, -40($fp)	# spill _tmp274 from $t2 to $fp-40
	# *(this + 4) = _tmp274
	  lw $t0, -40($fp)	# fill _tmp274 to $t0 from $fp-40
	  lw $t2, 4($fp)	# fill this to $t2 from $fp+4
	  sw $t0, 4($t2) 	# store with offset
	# _tmp275 = *(this + 12)
	  lw $t0, 4($fp)	# fill this to $t0 from $fp+4
	  lw $t2, 12($t0) 	# load with offset
	  sw $t2, -44($fp)	# spill _tmp275 from $t2 to $fp-44
	# _tmp276 = 1
	  li $t2, 1		# load constant value 1 into $t2
	  sw $t2, -48($fp)	# spill _tmp276 from $t2 to $fp-48
	# _tmp277 = _tmp275 + _tmp276
	  lw $t0, -44($fp)	# fill _tmp275 to $t0 from $fp-44
	  lw $t1, -48($fp)	# fill _tmp276 to $t1 from $fp-48
	  add $t2, $t0, $t1	
	  sw $t2, -52($fp)	# spill _tmp277 from $t2 to $fp-52
	# *(this + 12) = _tmp277
	  lw $t0, -52($fp)	# fill _tmp277 to $t0 from $fp-52
	  lw $t2, 4($fp)	# fill this to $t2 from $fp+4
	  sw $t0, 12($t2) 	# store with offset
	# _tmp278 = 11
	  li $t2, 11		# load constant value 11 into $t2
	  sw $t2, -56($fp)	# spill _tmp278 from $t2 to $fp-56
	# _tmp279 = card == _tmp278
	  lw $t0, -8($fp)	# fill card to $t0 from $fp-8
	  lw $t1, -56($fp)	# fill _tmp278 to $t1 from $fp-56
	  seq $t2, $t0, $t1	
	  sw $t2, -60($fp)	# spill _tmp279 from $t2 to $fp-60
	# IfZ _tmp279 Goto _L30
	  lw $t0, -60($fp)	# fill _tmp279 to $t0 from $fp-60
	  beqz $t0, _L30	# branch if _tmp279 is zero 
	# _tmp280 = *(this + 8)
	  lw $t0, 4($fp)	# fill this to $t0 from $fp+4
	  lw $t2, 8($t0) 	# load with offset
	  sw $t2, -64($fp)	# spill _tmp280 from $t2 to $fp-64
	# _tmp281 = 1
	  li $t2, 1		# load constant value 1 into $t2
	  sw $t2, -68($fp)	# spill _tmp281 from $t2 to $fp-68
	# _tmp282 = _tmp280 + _tmp281
	  lw $t0, -64($fp)	# fill _tmp280 to $t0 from $fp-64
	  lw $t1, -68($fp)	# fill _tmp281 to $t1 from $fp-68
	  add $t2, $t0, $t1	
	  sw $t2, -72($fp)	# spill _tmp282 from $t2 to $fp-72
	# *(this + 8) = _tmp282
	  lw $t0, -72($fp)	# fill _tmp282 to $t0 from $fp-72
	  lw $t2, 4($fp)	# fill this to $t2 from $fp+4
	  sw $t0, 8($t2) 	# store with offset
	# Goto _L31
	  b _L31		# unconditional branch
  _L30:
  _L31:
  _L32:
	# _tmp283 = 21
	  li $t2, 21		# load constant value 21 into $t2
	  sw $t2, -76($fp)	# spill _tmp283 from $t2 to $fp-76
	# _tmp284 = *(this + 4)
	  lw $t0, 4($fp)	# fill this to $t0 from $fp+4
	  lw $t2, 4($t0) 	# load with offset
	  sw $t2, -80($fp)	# spill _tmp284 from $t2 to $fp-80
	# _tmp285 = _tmp283 < _tmp284
	  lw $t0, -76($fp)	# fill _tmp283 to $t0 from $fp-76
	  lw $t1, -80($fp)	# fill _tmp284 to $t1 from $fp-80
	  slt $t2, $t0, $t1	
	  sw $t2, -84($fp)	# spill _tmp285 from $t2 to $fp-84
	# _tmp286 = 0
	  li $t2, 0		# load constant value 0 into $t2
	  sw $t2, -88($fp)	# spill _tmp286 from $t2 to $fp-88
	# _tmp287 = *(this + 8)
	  lw $t0, 4($fp)	# fill this to $t0 from $fp+4
	  lw $t2, 8($t0) 	# load with offset
	  sw $t2, -92($fp)	# spill _tmp287 from $t2 to $fp-92
	# _tmp288 = _tmp286 < _tmp287
	  lw $t0, -88($fp)	# fill _tmp286 to $t0 from $fp-88
	  lw $t1, -92($fp)	# fill _tmp287 to $t1 from $fp-92
	  slt $t2, $t0, $t1	
	  sw $t2, -96($fp)	# spill _tmp288 from $t2 to $fp-96
	# _tmp289 = _tmp285 && _tmp288
	  lw $t0, -84($fp)	# fill _tmp285 to $t0 from $fp-84
	  lw $t1, -96($fp)	# fill _tmp288 to $t1 from $fp-96
	  and $t2, $t0, $t1	
	  sw $t2, -100($fp)	# spill _tmp289 from $t2 to $fp-100
	# IfZ _tmp289 Goto _L33
	  lw $t0, -100($fp)	# fill _tmp289 to $t0 from $fp-100
	  beqz $t0, _L33	# branch if _tmp289 is zero 
	# _tmp290 = *(this + 4)
	  lw $t0, 4($fp)	# fill this to $t0 from $fp+4
	  lw $t2, 4($t0) 	# load with offset
	  sw $t2, -104($fp)	# spill _tmp290 from $t2 to $fp-104
	# _tmp291 = 10
	  li $t2, 10		# load constant value 10 into $t2
	  sw $t2, -108($fp)	# spill _tmp291 from $t2 to $fp-108
	# _tmp292 = _tmp290 - _tmp291
	  lw $t0, -104($fp)	# fill _tmp290 to $t0 from $fp-104
	  lw $t1, -108($fp)	# fill _tmp291 to $t1 from $fp-108
	  sub $t2, $t0, $t1	
	  sw $t2, -112($fp)	# spill _tmp292 from $t2 to $fp-112
	# *(this + 4) = _tmp292
	  lw $t0, -112($fp)	# fill _tmp292 to $t0 from $fp-112
	  lw $t2, 4($fp)	# fill this to $t2 from $fp+4
	  sw $t0, 4($t2) 	# store with offset
	# _tmp293 = *(this + 8)
	  lw $t0, 4($fp)	# fill this to $t0 from $fp+4
	  lw $t2, 8($t0) 	# load with offset
	  sw $t2, -116($fp)	# spill _tmp293 from $t2 to $fp-116
	# _tmp294 = 1
	  li $t2, 1		# load constant value 1 into $t2
	  sw $t2, -120($fp)	# spill _tmp294 from $t2 to $fp-120
	# _tmp295 = _tmp293 - _tmp294
	  lw $t0, -116($fp)	# fill _tmp293 to $t0 from $fp-116
	  lw $t1, -120($fp)	# fill _tmp294 to $t1 from $fp-120
	  sub $t2, $t0, $t1	
	  sw $t2, -124($fp)	# spill _tmp295 from $t2 to $fp-124
	# *(this + 8) = _tmp295
	  lw $t0, -124($fp)	# fill _tmp295 to $t0 from $fp-124
	  lw $t2, 4($fp)	# fill this to $t2 from $fp+4
	  sw $t0, 8($t2) 	# store with offset
	# Goto _L32
	  b _L32		# unconditional branch
  _L33:
	# EndFunc
	# (below handles reaching end of fn body with no explicit return)
	  move $sp, $fp		# pop callee frame off stack
	  lw $ra, -4($fp)	# restore saved ra
	  lw $fp, 0($fp)	# restore saved fp
	  jr $ra		# return from function
  Player.____DoubleDown:
	# BeginFunc 112
	  subu $sp, $sp, 8	# decrement sp to make space to save ra, fp
	  sw $fp, 8($sp)	# save fp
	  sw $ra, 4($sp)	# save ra
	  addiu $fp, $sp, 8	# set up new fp
	  subu $sp, $sp, 112	# decrement sp to make space for locals/temps
	# _tmp297 = *(this + 4)
	  lw $t0, 4($fp)	# fill this to $t0 from $fp+4
	  lw $t2, 4($t0) 	# load with offset
	  sw $t2, -16($fp)	# spill _tmp297 from $t2 to $fp-16
	# _tmp298 = 10
	  li $t2, 10		# load constant value 10 into $t2
	  sw $t2, -20($fp)	# spill _tmp298 from $t2 to $fp-20
	# _tmp299 = _tmp297 == _tmp298
	  lw $t0, -16($fp)	# fill _tmp297 to $t0 from $fp-16
	  lw $t1, -20($fp)	# fill _tmp298 to $t1 from $fp-20
	  seq $t2, $t0, $t1	
	  sw $t2, -24($fp)	# spill _tmp299 from $t2 to $fp-24
	# IfZ _tmp299 Goto _L37
	  lw $t0, -24($fp)	# fill _tmp299 to $t0 from $fp-24
	  beqz $t0, _L37	# branch if _tmp299 is zero 
	# _tmp300 = 0
	  li $t2, 0		# load constant value 0 into $t2
	  sw $t2, -28($fp)	# spill _tmp300 from $t2 to $fp-28
	# _tmp296 = _tmp300
	  lw $t2, -28($fp)	# fill _tmp300 to $t2 from $fp-28
	  sw $t2, -12($fp)	# spill _tmp296 from $t2 to $fp-12
	# Goto _L36
	  b _L36		# unconditional branch
  _L37:
	# _tmp301 = 1
	  li $t2, 1		# load constant value 1 into $t2
	  sw $t2, -32($fp)	# spill _tmp301 from $t2 to $fp-32
	# _tmp296 = _tmp301
	  lw $t2, -32($fp)	# fill _tmp301 to $t2 from $fp-32
	  sw $t2, -12($fp)	# spill _tmp296 from $t2 to $fp-12
  _L36:
	# _tmp303 = *(this + 4)
	  lw $t0, 4($fp)	# fill this to $t0 from $fp+4
	  lw $t2, 4($t0) 	# load with offset
	  sw $t2, -40($fp)	# spill _tmp303 from $t2 to $fp-40
	# _tmp304 = 11
	  li $t2, 11		# load constant value 11 into $t2
	  sw $t2, -44($fp)	# spill _tmp304 from $t2 to $fp-44
	# _tmp305 = _tmp303 == _tmp304
	  lw $t0, -40($fp)	# fill _tmp303 to $t0 from $fp-40
	  lw $t1, -44($fp)	# fill _tmp304 to $t1 from $fp-44
	  seq $t2, $t0, $t1	
	  sw $t2, -48($fp)	# spill _tmp305 from $t2 to $fp-48
	# IfZ _tmp305 Goto _L39
	  lw $t0, -48($fp)	# fill _tmp305 to $t0 from $fp-48
	  beqz $t0, _L39	# branch if _tmp305 is zero 
	# _tmp306 = 0
	  li $t2, 0		# load constant value 0 into $t2
	  sw $t2, -52($fp)	# spill _tmp306 from $t2 to $fp-52
	# _tmp302 = _tmp306
	  lw $t2, -52($fp)	# fill _tmp306 to $t2 from $fp-52
	  sw $t2, -36($fp)	# spill _tmp302 from $t2 to $fp-36
	# Goto _L38
	  b _L38		# unconditional branch
  _L39:
	# _tmp307 = 1
	  li $t2, 1		# load constant value 1 into $t2
	  sw $t2, -56($fp)	# spill _tmp307 from $t2 to $fp-56
	# _tmp302 = _tmp307
	  lw $t2, -56($fp)	# fill _tmp307 to $t2 from $fp-56
	  sw $t2, -36($fp)	# spill _tmp302 from $t2 to $fp-36
  _L38:
	# _tmp308 = _tmp296 && _tmp302
	  lw $t0, -12($fp)	# fill _tmp296 to $t0 from $fp-12
	  lw $t1, -36($fp)	# fill _tmp302 to $t1 from $fp-36
	  and $t2, $t0, $t1	
	  sw $t2, -60($fp)	# spill _tmp308 from $t2 to $fp-60
	# IfZ _tmp308 Goto _L34
	  lw $t0, -60($fp)	# fill _tmp308 to $t0 from $fp-60
	  beqz $t0, _L34	# branch if _tmp308 is zero 
	# _tmp309 = 0
	  li $t2, 0		# load constant value 0 into $t2
	  sw $t2, -64($fp)	# spill _tmp309 from $t2 to $fp-64
	# Return _tmp309
	  lw $t2, -64($fp)	# fill _tmp309 to $t2 from $fp-64
	  move $v0, $t2		# assign return value into $v0
	  move $sp, $fp		# pop callee frame off stack
	  lw $ra, -4($fp)	# restore saved ra
	  lw $fp, 0($fp)	# restore saved fp
	  jr $ra		# return from function
	# Goto _L35
	  b _L35		# unconditional branch
  _L34:
  _L35:
	# _tmp310 = "Would you like to double down?"
	  .data			# create string constant marked with label
	  _string19: .asciiz "Would you like to double down?"
	  .text
	  la $t2, _string19	# load label
	  sw $t2, -68($fp)	# spill _tmp310 from $t2 to $fp-68
	# PushParam _tmp310
	  subu $sp, $sp, 4	# decrement sp to make space for param
	  lw $t0, -68($fp)	# fill _tmp310 to $t0 from $fp-68
	  sw $t0, 4($sp)	# copy param value to stack
	# _tmp311 = LCall ____GetYesOrNo
	  jal ____GetYesOrNo 	# jump to function
	  move $t2, $v0		# copy function return value from $v0
	  sw $t2, -72($fp)	# spill _tmp311 from $t2 to $fp-72
	# PopParams 4
	  add $sp, $sp, 4	# pop params off stack
	# IfZ _tmp311 Goto _L40
	  lw $t0, -72($fp)	# fill _tmp311 to $t0 from $fp-72
	  beqz $t0, _L40	# branch if _tmp311 is zero 
	# _tmp312 = *(this + 16)
	  lw $t0, 4($fp)	# fill this to $t0 from $fp+4
	  lw $t2, 16($t0) 	# load with offset
	  sw $t2, -76($fp)	# spill _tmp312 from $t2 to $fp-76
	# _tmp313 = 2
	  li $t2, 2		# load constant value 2 into $t2
	  sw $t2, -80($fp)	# spill _tmp313 from $t2 to $fp-80
	# _tmp314 = _tmp312 * _tmp313
	  lw $t0, -76($fp)	# fill _tmp312 to $t0 from $fp-76
	  lw $t1, -80($fp)	# fill _tmp313 to $t1 from $fp-80
	  mul $t2, $t0, $t1	
	  sw $t2, -84($fp)	# spill _tmp314 from $t2 to $fp-84
	# *(this + 16) = _tmp314
	  lw $t0, -84($fp)	# fill _tmp314 to $t0 from $fp-84
	  lw $t2, 4($fp)	# fill this to $t2 from $fp+4
	  sw $t0, 16($t2) 	# store with offset
	# PushParam deck
	  subu $sp, $sp, 4	# decrement sp to make space for param
	  lw $t0, 8($fp)	# fill deck to $t0 from $fp+8
	  sw $t0, 4($sp)	# copy param value to stack
	# PushParam this
	  subu $sp, $sp, 4	# decrement sp to make space for param
	  lw $t0, 4($fp)	# fill this to $t0 from $fp+4
	  sw $t0, 4($sp)	# copy param value to stack
	# _tmp315 = *(this)
	  lw $t0, 4($fp)	# fill this to $t0 from $fp+4
	  lw $t2, 0($t0) 	# load with offset
	  sw $t2, -88($fp)	# spill _tmp315 from $t2 to $fp-88
	# _tmp316 = *(_tmp315 + 4)
	  lw $t0, -88($fp)	# fill _tmp315 to $t0 from $fp-88
	  lw $t2, 4($t0) 	# load with offset
	  sw $t2, -92($fp)	# spill _tmp316 from $t2 to $fp-92
	# ACall _tmp316
	  lw $t0, -92($fp)	# fill _tmp316 to $t0 from $fp-92
	  jalr $t0            	# jump to function
	# PopParams 8
	  add $sp, $sp, 8	# pop params off stack
	# _tmp317 = *(this + 24)
	  lw $t0, 4($fp)	# fill this to $t0 from $fp+4
	  lw $t2, 24($t0) 	# load with offset
	  sw $t2, -96($fp)	# spill _tmp317 from $t2 to $fp-96
	# PushParam _tmp317
	  subu $sp, $sp, 4	# decrement sp to make space for param
	  lw $t0, -96($fp)	# fill _tmp317 to $t0 from $fp-96
	  sw $t0, 4($sp)	# copy param value to stack
	# LCall _PrintString
	  jal _PrintString   	# jump to function
	# PopParams 4
	  add $sp, $sp, 4	# pop params off stack
	# _tmp318 = ", your total is "
	  .data			# create string constant marked with label
	  _string20: .asciiz ", your total is "
	  .text
	  la $t2, _string20	# load label
	  sw $t2, -100($fp)	# spill _tmp318 from $t2 to $fp-100
	# PushParam _tmp318
	  subu $sp, $sp, 4	# decrement sp to make space for param
	  lw $t0, -100($fp)	# fill _tmp318 to $t0 from $fp-100
	  sw $t0, 4($sp)	# copy param value to stack
	# LCall _PrintString
	  jal _PrintString   	# jump to function
	# PopParams 4
	  add $sp, $sp, 4	# pop params off stack
	# _tmp319 = *(this + 4)
	  lw $t0, 4($fp)	# fill this to $t0 from $fp+4
	  lw $t2, 4($t0) 	# load with offset
	  sw $t2, -104($fp)	# spill _tmp319 from $t2 to $fp-104
	# PushParam _tmp319
	  subu $sp, $sp, 4	# decrement sp to make space for param
	  lw $t0, -104($fp)	# fill _tmp319 to $t0 from $fp-104
	  sw $t0, 4($sp)	# copy param value to stack
	# LCall _PrintInt
	  jal _PrintInt      	# jump to function
	# PopParams 4
	  add $sp, $sp, 4	# pop params off stack
	# _tmp320 = ".\n"
	  .data			# create string constant marked with label
	  _string21: .asciiz ".\n"
	  .text
	  la $t2, _string21	# load label
	  sw $t2, -108($fp)	# spill _tmp320 from $t2 to $fp-108
	# PushParam _tmp320
	  subu $sp, $sp, 4	# decrement sp to make space for param
	  lw $t0, -108($fp)	# fill _tmp320 to $t0 from $fp-108
	  sw $t0, 4($sp)	# copy param value to stack
	# LCall _PrintString
	  jal _PrintString   	# jump to function
	# PopParams 4
	  add $sp, $sp, 4	# pop params off stack
	# _tmp321 = 1
	  li $t2, 1		# load constant value 1 into $t2
	  sw $t2, -112($fp)	# spill _tmp321 from $t2 to $fp-112
	# Return _tmp321
	  lw $t2, -112($fp)	# fill _tmp321 to $t2 from $fp-112
	  move $v0, $t2		# assign return value into $v0
	  move $sp, $fp		# pop callee frame off stack
	  lw $ra, -4($fp)	# restore saved ra
	  lw $fp, 0($fp)	# restore saved fp
	  jr $ra		# return from function
	# Goto _L41
	  b _L41		# unconditional branch
  _L40:
  _L41:
	# _tmp322 = 0
	  li $t2, 0		# load constant value 0 into $t2
	  sw $t2, -116($fp)	# spill _tmp322 from $t2 to $fp-116
	# Return _tmp322
	  lw $t2, -116($fp)	# fill _tmp322 to $t2 from $fp-116
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
  Player.____TakeTurn:
	# BeginFunc 180
	  subu $sp, $sp, 8	# decrement sp to make space to save ra, fp
	  sw $fp, 8($sp)	# save fp
	  sw $ra, 4($sp)	# save ra
	  addiu $fp, $sp, 8	# set up new fp
	  subu $sp, $sp, 180	# decrement sp to make space for locals/temps
	# _tmp323 = "\n"
	  .data			# create string constant marked with label
	  _string22: .asciiz "\n"
	  .text
	  la $t2, _string22	# load label
	  sw $t2, -12($fp)	# spill _tmp323 from $t2 to $fp-12
	# PushParam _tmp323
	  subu $sp, $sp, 4	# decrement sp to make space for param
	  lw $t0, -12($fp)	# fill _tmp323 to $t0 from $fp-12
	  sw $t0, 4($sp)	# copy param value to stack
	# LCall _PrintString
	  jal _PrintString   	# jump to function
	# PopParams 4
	  add $sp, $sp, 4	# pop params off stack
	# _tmp324 = *(this + 24)
	  lw $t0, 4($fp)	# fill this to $t0 from $fp+4
	  lw $t2, 24($t0) 	# load with offset
	  sw $t2, -16($fp)	# spill _tmp324 from $t2 to $fp-16
	# PushParam _tmp324
	  subu $sp, $sp, 4	# decrement sp to make space for param
	  lw $t0, -16($fp)	# fill _tmp324 to $t0 from $fp-16
	  sw $t0, 4($sp)	# copy param value to stack
	# LCall _PrintString
	  jal _PrintString   	# jump to function
	# PopParams 4
	  add $sp, $sp, 4	# pop params off stack
	# _tmp325 = "'s turn.\n"
	  .data			# create string constant marked with label
	  _string23: .asciiz "'s turn.\n"
	  .text
	  la $t2, _string23	# load label
	  sw $t2, -20($fp)	# spill _tmp325 from $t2 to $fp-20
	# PushParam _tmp325
	  subu $sp, $sp, 4	# decrement sp to make space for param
	  lw $t0, -20($fp)	# fill _tmp325 to $t0 from $fp-20
	  sw $t0, 4($sp)	# copy param value to stack
	# LCall _PrintString
	  jal _PrintString   	# jump to function
	# PopParams 4
	  add $sp, $sp, 4	# pop params off stack
	# _tmp326 = 0
	  li $t2, 0		# load constant value 0 into $t2
	  sw $t2, -24($fp)	# spill _tmp326 from $t2 to $fp-24
	# *(this + 4) = _tmp326
	  lw $t0, -24($fp)	# fill _tmp326 to $t0 from $fp-24
	  lw $t2, 4($fp)	# fill this to $t2 from $fp+4
	  sw $t0, 4($t2) 	# store with offset
	# _tmp327 = 0
	  li $t2, 0		# load constant value 0 into $t2
	  sw $t2, -28($fp)	# spill _tmp327 from $t2 to $fp-28
	# *(this + 8) = _tmp327
	  lw $t0, -28($fp)	# fill _tmp327 to $t0 from $fp-28
	  lw $t2, 4($fp)	# fill this to $t2 from $fp+4
	  sw $t0, 8($t2) 	# store with offset
	# _tmp328 = 0
	  li $t2, 0		# load constant value 0 into $t2
	  sw $t2, -32($fp)	# spill _tmp328 from $t2 to $fp-32
	# *(this + 12) = _tmp328
	  lw $t0, -32($fp)	# fill _tmp328 to $t0 from $fp-32
	  lw $t2, 4($fp)	# fill this to $t2 from $fp+4
	  sw $t0, 12($t2) 	# store with offset
	# PushParam deck
	  subu $sp, $sp, 4	# decrement sp to make space for param
	  lw $t0, 8($fp)	# fill deck to $t0 from $fp+8
	  sw $t0, 4($sp)	# copy param value to stack
	# PushParam this
	  subu $sp, $sp, 4	# decrement sp to make space for param
	  lw $t0, 4($fp)	# fill this to $t0 from $fp+4
	  sw $t0, 4($sp)	# copy param value to stack
	# _tmp329 = *(this)
	  lw $t0, 4($fp)	# fill this to $t0 from $fp+4
	  lw $t2, 0($t0) 	# load with offset
	  sw $t2, -36($fp)	# spill _tmp329 from $t2 to $fp-36
	# _tmp330 = *(_tmp329 + 4)
	  lw $t0, -36($fp)	# fill _tmp329 to $t0 from $fp-36
	  lw $t2, 4($t0) 	# load with offset
	  sw $t2, -40($fp)	# spill _tmp330 from $t2 to $fp-40
	# ACall _tmp330
	  lw $t0, -40($fp)	# fill _tmp330 to $t0 from $fp-40
	  jalr $t0            	# jump to function
	# PopParams 8
	  add $sp, $sp, 8	# pop params off stack
	# PushParam deck
	  subu $sp, $sp, 4	# decrement sp to make space for param
	  lw $t0, 8($fp)	# fill deck to $t0 from $fp+8
	  sw $t0, 4($sp)	# copy param value to stack
	# PushParam this
	  subu $sp, $sp, 4	# decrement sp to make space for param
	  lw $t0, 4($fp)	# fill this to $t0 from $fp+4
	  sw $t0, 4($sp)	# copy param value to stack
	# _tmp331 = *(this)
	  lw $t0, 4($fp)	# fill this to $t0 from $fp+4
	  lw $t2, 0($t0) 	# load with offset
	  sw $t2, -44($fp)	# spill _tmp331 from $t2 to $fp-44
	# _tmp332 = *(_tmp331 + 4)
	  lw $t0, -44($fp)	# fill _tmp331 to $t0 from $fp-44
	  lw $t2, 4($t0) 	# load with offset
	  sw $t2, -48($fp)	# spill _tmp332 from $t2 to $fp-48
	# ACall _tmp332
	  lw $t0, -48($fp)	# fill _tmp332 to $t0 from $fp-48
	  jalr $t0            	# jump to function
	# PopParams 8
	  add $sp, $sp, 8	# pop params off stack
	# PushParam deck
	  subu $sp, $sp, 4	# decrement sp to make space for param
	  lw $t0, 8($fp)	# fill deck to $t0 from $fp+8
	  sw $t0, 4($sp)	# copy param value to stack
	# PushParam this
	  subu $sp, $sp, 4	# decrement sp to make space for param
	  lw $t0, 4($fp)	# fill this to $t0 from $fp+4
	  sw $t0, 4($sp)	# copy param value to stack
	# _tmp334 = *(this)
	  lw $t0, 4($fp)	# fill this to $t0 from $fp+4
	  lw $t2, 0($t0) 	# load with offset
	  sw $t2, -56($fp)	# spill _tmp334 from $t2 to $fp-56
	# _tmp335 = *(_tmp334 + 8)
	  lw $t0, -56($fp)	# fill _tmp334 to $t0 from $fp-56
	  lw $t2, 8($t0) 	# load with offset
	  sw $t2, -60($fp)	# spill _tmp335 from $t2 to $fp-60
	# _tmp336 = ACall _tmp335
	  lw $t0, -60($fp)	# fill _tmp335 to $t0 from $fp-60
	  jalr $t0            	# jump to function
	  move $t2, $v0		# copy function return value from $v0
	  sw $t2, -64($fp)	# spill _tmp336 from $t2 to $fp-64
	# PopParams 8
	  add $sp, $sp, 8	# pop params off stack
	# IfZ _tmp336 Goto _L45
	  lw $t0, -64($fp)	# fill _tmp336 to $t0 from $fp-64
	  beqz $t0, _L45	# branch if _tmp336 is zero 
	# _tmp337 = 0
	  li $t2, 0		# load constant value 0 into $t2
	  sw $t2, -68($fp)	# spill _tmp337 from $t2 to $fp-68
	# _tmp333 = _tmp337
	  lw $t2, -68($fp)	# fill _tmp337 to $t2 from $fp-68
	  sw $t2, -52($fp)	# spill _tmp333 from $t2 to $fp-52
	# Goto _L44
	  b _L44		# unconditional branch
  _L45:
	# _tmp338 = 1
	  li $t2, 1		# load constant value 1 into $t2
	  sw $t2, -72($fp)	# spill _tmp338 from $t2 to $fp-72
	# _tmp333 = _tmp338
	  lw $t2, -72($fp)	# fill _tmp338 to $t2 from $fp-72
	  sw $t2, -52($fp)	# spill _tmp333 from $t2 to $fp-52
  _L44:
	# IfZ _tmp333 Goto _L42
	  lw $t0, -52($fp)	# fill _tmp333 to $t0 from $fp-52
	  beqz $t0, _L42	# branch if _tmp333 is zero 
	# _tmp339 = 1
	  li $t2, 1		# load constant value 1 into $t2
	  sw $t2, -76($fp)	# spill _tmp339 from $t2 to $fp-76
	# stillGoing = _tmp339
	  lw $t2, -76($fp)	# fill _tmp339 to $t2 from $fp-76
	  sw $t2, -8($fp)	# spill stillGoing from $t2 to $fp-8
  _L46:
	# _tmp340 = *(this + 4)
	  lw $t0, 4($fp)	# fill this to $t0 from $fp+4
	  lw $t2, 4($t0) 	# load with offset
	  sw $t2, -80($fp)	# spill _tmp340 from $t2 to $fp-80
	# _tmp341 = 21
	  li $t2, 21		# load constant value 21 into $t2
	  sw $t2, -84($fp)	# spill _tmp341 from $t2 to $fp-84
	# _tmp342 = _tmp340 < _tmp341
	  lw $t0, -80($fp)	# fill _tmp340 to $t0 from $fp-80
	  lw $t1, -84($fp)	# fill _tmp341 to $t1 from $fp-84
	  slt $t2, $t0, $t1	
	  sw $t2, -88($fp)	# spill _tmp342 from $t2 to $fp-88
	# _tmp343 = _tmp340 == _tmp341
	  lw $t0, -80($fp)	# fill _tmp340 to $t0 from $fp-80
	  lw $t1, -84($fp)	# fill _tmp341 to $t1 from $fp-84
	  seq $t2, $t0, $t1	
	  sw $t2, -92($fp)	# spill _tmp343 from $t2 to $fp-92
	# _tmp344 = _tmp342 || _tmp343
	  lw $t0, -88($fp)	# fill _tmp342 to $t0 from $fp-88
	  lw $t1, -92($fp)	# fill _tmp343 to $t1 from $fp-92
	  or $t2, $t0, $t1	
	  sw $t2, -96($fp)	# spill _tmp344 from $t2 to $fp-96
	# _tmp345 = _tmp344 && stillGoing
	  lw $t0, -96($fp)	# fill _tmp344 to $t0 from $fp-96
	  lw $t1, -8($fp)	# fill stillGoing to $t1 from $fp-8
	  and $t2, $t0, $t1	
	  sw $t2, -100($fp)	# spill _tmp345 from $t2 to $fp-100
	# IfZ _tmp345 Goto _L47
	  lw $t0, -100($fp)	# fill _tmp345 to $t0 from $fp-100
	  beqz $t0, _L47	# branch if _tmp345 is zero 
	# _tmp346 = *(this + 24)
	  lw $t0, 4($fp)	# fill this to $t0 from $fp+4
	  lw $t2, 24($t0) 	# load with offset
	  sw $t2, -104($fp)	# spill _tmp346 from $t2 to $fp-104
	# PushParam _tmp346
	  subu $sp, $sp, 4	# decrement sp to make space for param
	  lw $t0, -104($fp)	# fill _tmp346 to $t0 from $fp-104
	  sw $t0, 4($sp)	# copy param value to stack
	# LCall _PrintString
	  jal _PrintString   	# jump to function
	# PopParams 4
	  add $sp, $sp, 4	# pop params off stack
	# _tmp347 = ", your total is "
	  .data			# create string constant marked with label
	  _string24: .asciiz ", your total is "
	  .text
	  la $t2, _string24	# load label
	  sw $t2, -108($fp)	# spill _tmp347 from $t2 to $fp-108
	# PushParam _tmp347
	  subu $sp, $sp, 4	# decrement sp to make space for param
	  lw $t0, -108($fp)	# fill _tmp347 to $t0 from $fp-108
	  sw $t0, 4($sp)	# copy param value to stack
	# LCall _PrintString
	  jal _PrintString   	# jump to function
	# PopParams 4
	  add $sp, $sp, 4	# pop params off stack
	# _tmp348 = *(this + 4)
	  lw $t0, 4($fp)	# fill this to $t0 from $fp+4
	  lw $t2, 4($t0) 	# load with offset
	  sw $t2, -112($fp)	# spill _tmp348 from $t2 to $fp-112
	# PushParam _tmp348
	  subu $sp, $sp, 4	# decrement sp to make space for param
	  lw $t0, -112($fp)	# fill _tmp348 to $t0 from $fp-112
	  sw $t0, 4($sp)	# copy param value to stack
	# LCall _PrintInt
	  jal _PrintInt      	# jump to function
	# PopParams 4
	  add $sp, $sp, 4	# pop params off stack
	# _tmp349 = ".\n"
	  .data			# create string constant marked with label
	  _string25: .asciiz ".\n"
	  .text
	  la $t2, _string25	# load label
	  sw $t2, -116($fp)	# spill _tmp349 from $t2 to $fp-116
	# PushParam _tmp349
	  subu $sp, $sp, 4	# decrement sp to make space for param
	  lw $t0, -116($fp)	# fill _tmp349 to $t0 from $fp-116
	  sw $t0, 4($sp)	# copy param value to stack
	# LCall _PrintString
	  jal _PrintString   	# jump to function
	# PopParams 4
	  add $sp, $sp, 4	# pop params off stack
	# _tmp350 = "Would you like a hit?"
	  .data			# create string constant marked with label
	  _string26: .asciiz "Would you like a hit?"
	  .text
	  la $t2, _string26	# load label
	  sw $t2, -120($fp)	# spill _tmp350 from $t2 to $fp-120
	# PushParam _tmp350
	  subu $sp, $sp, 4	# decrement sp to make space for param
	  lw $t0, -120($fp)	# fill _tmp350 to $t0 from $fp-120
	  sw $t0, 4($sp)	# copy param value to stack
	# _tmp351 = LCall ____GetYesOrNo
	  jal ____GetYesOrNo 	# jump to function
	  move $t2, $v0		# copy function return value from $v0
	  sw $t2, -124($fp)	# spill _tmp351 from $t2 to $fp-124
	# PopParams 4
	  add $sp, $sp, 4	# pop params off stack
	# stillGoing = _tmp351
	  lw $t2, -124($fp)	# fill _tmp351 to $t2 from $fp-124
	  sw $t2, -8($fp)	# spill stillGoing from $t2 to $fp-8
	# IfZ stillGoing Goto _L48
	  lw $t0, -8($fp)	# fill stillGoing to $t0 from $fp-8
	  beqz $t0, _L48	# branch if stillGoing is zero 
	# PushParam deck
	  subu $sp, $sp, 4	# decrement sp to make space for param
	  lw $t0, 8($fp)	# fill deck to $t0 from $fp+8
	  sw $t0, 4($sp)	# copy param value to stack
	# PushParam this
	  subu $sp, $sp, 4	# decrement sp to make space for param
	  lw $t0, 4($fp)	# fill this to $t0 from $fp+4
	  sw $t0, 4($sp)	# copy param value to stack
	# _tmp352 = *(this)
	  lw $t0, 4($fp)	# fill this to $t0 from $fp+4
	  lw $t2, 0($t0) 	# load with offset
	  sw $t2, -128($fp)	# spill _tmp352 from $t2 to $fp-128
	# _tmp353 = *(_tmp352 + 4)
	  lw $t0, -128($fp)	# fill _tmp352 to $t0 from $fp-128
	  lw $t2, 4($t0) 	# load with offset
	  sw $t2, -132($fp)	# spill _tmp353 from $t2 to $fp-132
	# ACall _tmp353
	  lw $t0, -132($fp)	# fill _tmp353 to $t0 from $fp-132
	  jalr $t0            	# jump to function
	# PopParams 8
	  add $sp, $sp, 8	# pop params off stack
	# Goto _L49
	  b _L49		# unconditional branch
  _L48:
  _L49:
	# Goto _L46
	  b _L46		# unconditional branch
  _L47:
	# Goto _L43
	  b _L43		# unconditional branch
  _L42:
  _L43:
	# _tmp354 = 21
	  li $t2, 21		# load constant value 21 into $t2
	  sw $t2, -136($fp)	# spill _tmp354 from $t2 to $fp-136
	# _tmp355 = *(this + 4)
	  lw $t0, 4($fp)	# fill this to $t0 from $fp+4
	  lw $t2, 4($t0) 	# load with offset
	  sw $t2, -140($fp)	# spill _tmp355 from $t2 to $fp-140
	# _tmp356 = _tmp354 < _tmp355
	  lw $t0, -136($fp)	# fill _tmp354 to $t0 from $fp-136
	  lw $t1, -140($fp)	# fill _tmp355 to $t1 from $fp-140
	  slt $t2, $t0, $t1	
	  sw $t2, -144($fp)	# spill _tmp356 from $t2 to $fp-144
	# IfZ _tmp356 Goto _L50
	  lw $t0, -144($fp)	# fill _tmp356 to $t0 from $fp-144
	  beqz $t0, _L50	# branch if _tmp356 is zero 
	# _tmp357 = *(this + 24)
	  lw $t0, 4($fp)	# fill this to $t0 from $fp+4
	  lw $t2, 24($t0) 	# load with offset
	  sw $t2, -148($fp)	# spill _tmp357 from $t2 to $fp-148
	# PushParam _tmp357
	  subu $sp, $sp, 4	# decrement sp to make space for param
	  lw $t0, -148($fp)	# fill _tmp357 to $t0 from $fp-148
	  sw $t0, 4($sp)	# copy param value to stack
	# LCall _PrintString
	  jal _PrintString   	# jump to function
	# PopParams 4
	  add $sp, $sp, 4	# pop params off stack
	# _tmp358 = " busts with the big "
	  .data			# create string constant marked with label
	  _string27: .asciiz " busts with the big "
	  .text
	  la $t2, _string27	# load label
	  sw $t2, -152($fp)	# spill _tmp358 from $t2 to $fp-152
	# PushParam _tmp358
	  subu $sp, $sp, 4	# decrement sp to make space for param
	  lw $t0, -152($fp)	# fill _tmp358 to $t0 from $fp-152
	  sw $t0, 4($sp)	# copy param value to stack
	# LCall _PrintString
	  jal _PrintString   	# jump to function
	# PopParams 4
	  add $sp, $sp, 4	# pop params off stack
	# _tmp359 = *(this + 4)
	  lw $t0, 4($fp)	# fill this to $t0 from $fp+4
	  lw $t2, 4($t0) 	# load with offset
	  sw $t2, -156($fp)	# spill _tmp359 from $t2 to $fp-156
	# PushParam _tmp359
	  subu $sp, $sp, 4	# decrement sp to make space for param
	  lw $t0, -156($fp)	# fill _tmp359 to $t0 from $fp-156
	  sw $t0, 4($sp)	# copy param value to stack
	# LCall _PrintInt
	  jal _PrintInt      	# jump to function
	# PopParams 4
	  add $sp, $sp, 4	# pop params off stack
	# _tmp360 = "!\n"
	  .data			# create string constant marked with label
	  _string28: .asciiz "!\n"
	  .text
	  la $t2, _string28	# load label
	  sw $t2, -160($fp)	# spill _tmp360 from $t2 to $fp-160
	# PushParam _tmp360
	  subu $sp, $sp, 4	# decrement sp to make space for param
	  lw $t0, -160($fp)	# fill _tmp360 to $t0 from $fp-160
	  sw $t0, 4($sp)	# copy param value to stack
	# LCall _PrintString
	  jal _PrintString   	# jump to function
	# PopParams 4
	  add $sp, $sp, 4	# pop params off stack
	# Goto _L51
	  b _L51		# unconditional branch
  _L50:
	# _tmp361 = *(this + 24)
	  lw $t0, 4($fp)	# fill this to $t0 from $fp+4
	  lw $t2, 24($t0) 	# load with offset
	  sw $t2, -164($fp)	# spill _tmp361 from $t2 to $fp-164
	# PushParam _tmp361
	  subu $sp, $sp, 4	# decrement sp to make space for param
	  lw $t0, -164($fp)	# fill _tmp361 to $t0 from $fp-164
	  sw $t0, 4($sp)	# copy param value to stack
	# LCall _PrintString
	  jal _PrintString   	# jump to function
	# PopParams 4
	  add $sp, $sp, 4	# pop params off stack
	# _tmp362 = " stays at "
	  .data			# create string constant marked with label
	  _string29: .asciiz " stays at "
	  .text
	  la $t2, _string29	# load label
	  sw $t2, -168($fp)	# spill _tmp362 from $t2 to $fp-168
	# PushParam _tmp362
	  subu $sp, $sp, 4	# decrement sp to make space for param
	  lw $t0, -168($fp)	# fill _tmp362 to $t0 from $fp-168
	  sw $t0, 4($sp)	# copy param value to stack
	# LCall _PrintString
	  jal _PrintString   	# jump to function
	# PopParams 4
	  add $sp, $sp, 4	# pop params off stack
	# _tmp363 = *(this + 4)
	  lw $t0, 4($fp)	# fill this to $t0 from $fp+4
	  lw $t2, 4($t0) 	# load with offset
	  sw $t2, -172($fp)	# spill _tmp363 from $t2 to $fp-172
	# PushParam _tmp363
	  subu $sp, $sp, 4	# decrement sp to make space for param
	  lw $t0, -172($fp)	# fill _tmp363 to $t0 from $fp-172
	  sw $t0, 4($sp)	# copy param value to stack
	# LCall _PrintInt
	  jal _PrintInt      	# jump to function
	# PopParams 4
	  add $sp, $sp, 4	# pop params off stack
	# _tmp364 = ".\n"
	  .data			# create string constant marked with label
	  _string30: .asciiz ".\n"
	  .text
	  la $t2, _string30	# load label
	  sw $t2, -176($fp)	# spill _tmp364 from $t2 to $fp-176
	# PushParam _tmp364
	  subu $sp, $sp, 4	# decrement sp to make space for param
	  lw $t0, -176($fp)	# fill _tmp364 to $t0 from $fp-176
	  sw $t0, 4($sp)	# copy param value to stack
	# LCall _PrintString
	  jal _PrintString   	# jump to function
	# PopParams 4
	  add $sp, $sp, 4	# pop params off stack
  _L51:
	# EndFunc
	# (below handles reaching end of fn body with no explicit return)
	  move $sp, $fp		# pop callee frame off stack
	  lw $ra, -4($fp)	# restore saved ra
	  lw $fp, 0($fp)	# restore saved fp
	  jr $ra		# return from function
  Player.____HasMoney:
	# BeginFunc 12
	  subu $sp, $sp, 8	# decrement sp to make space to save ra, fp
	  sw $fp, 8($sp)	# save fp
	  sw $ra, 4($sp)	# save ra
	  addiu $fp, $sp, 8	# set up new fp
	  subu $sp, $sp, 12	# decrement sp to make space for locals/temps
	# _tmp365 = 0
	  li $t2, 0		# load constant value 0 into $t2
	  sw $t2, -8($fp)	# spill _tmp365 from $t2 to $fp-8
	# _tmp366 = *(this + 20)
	  lw $t0, 4($fp)	# fill this to $t0 from $fp+4
	  lw $t2, 20($t0) 	# load with offset
	  sw $t2, -12($fp)	# spill _tmp366 from $t2 to $fp-12
	# _tmp367 = _tmp365 < _tmp366
	  lw $t0, -8($fp)	# fill _tmp365 to $t0 from $fp-8
	  lw $t1, -12($fp)	# fill _tmp366 to $t1 from $fp-12
	  slt $t2, $t0, $t1	
	  sw $t2, -16($fp)	# spill _tmp367 from $t2 to $fp-16
	# Return _tmp367
	  lw $t2, -16($fp)	# fill _tmp367 to $t2 from $fp-16
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
  Player.____PrintMoney:
	# BeginFunc 16
	  subu $sp, $sp, 8	# decrement sp to make space to save ra, fp
	  sw $fp, 8($sp)	# save fp
	  sw $ra, 4($sp)	# save ra
	  addiu $fp, $sp, 8	# set up new fp
	  subu $sp, $sp, 16	# decrement sp to make space for locals/temps
	# _tmp368 = *(this + 24)
	  lw $t0, 4($fp)	# fill this to $t0 from $fp+4
	  lw $t2, 24($t0) 	# load with offset
	  sw $t2, -8($fp)	# spill _tmp368 from $t2 to $fp-8
	# PushParam _tmp368
	  subu $sp, $sp, 4	# decrement sp to make space for param
	  lw $t0, -8($fp)	# fill _tmp368 to $t0 from $fp-8
	  sw $t0, 4($sp)	# copy param value to stack
	# LCall _PrintString
	  jal _PrintString   	# jump to function
	# PopParams 4
	  add $sp, $sp, 4	# pop params off stack
	# _tmp369 = ", you have $"
	  .data			# create string constant marked with label
	  _string31: .asciiz ", you have $"
	  .text
	  la $t2, _string31	# load label
	  sw $t2, -12($fp)	# spill _tmp369 from $t2 to $fp-12
	# PushParam _tmp369
	  subu $sp, $sp, 4	# decrement sp to make space for param
	  lw $t0, -12($fp)	# fill _tmp369 to $t0 from $fp-12
	  sw $t0, 4($sp)	# copy param value to stack
	# LCall _PrintString
	  jal _PrintString   	# jump to function
	# PopParams 4
	  add $sp, $sp, 4	# pop params off stack
	# _tmp370 = *(this + 20)
	  lw $t0, 4($fp)	# fill this to $t0 from $fp+4
	  lw $t2, 20($t0) 	# load with offset
	  sw $t2, -16($fp)	# spill _tmp370 from $t2 to $fp-16
	# PushParam _tmp370
	  subu $sp, $sp, 4	# decrement sp to make space for param
	  lw $t0, -16($fp)	# fill _tmp370 to $t0 from $fp-16
	  sw $t0, 4($sp)	# copy param value to stack
	# LCall _PrintInt
	  jal _PrintInt      	# jump to function
	# PopParams 4
	  add $sp, $sp, 4	# pop params off stack
	# _tmp371 = ".\n"
	  .data			# create string constant marked with label
	  _string32: .asciiz ".\n"
	  .text
	  la $t2, _string32	# load label
	  sw $t2, -20($fp)	# spill _tmp371 from $t2 to $fp-20
	# PushParam _tmp371
	  subu $sp, $sp, 4	# decrement sp to make space for param
	  lw $t0, -20($fp)	# fill _tmp371 to $t0 from $fp-20
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
  Player.____PlaceBet:
	# BeginFunc 56
	  subu $sp, $sp, 8	# decrement sp to make space to save ra, fp
	  sw $fp, 8($sp)	# save fp
	  sw $ra, 4($sp)	# save ra
	  addiu $fp, $sp, 8	# set up new fp
	  subu $sp, $sp, 56	# decrement sp to make space for locals/temps
	# _tmp372 = 0
	  li $t2, 0		# load constant value 0 into $t2
	  sw $t2, -8($fp)	# spill _tmp372 from $t2 to $fp-8
	# *(this + 16) = _tmp372
	  lw $t0, -8($fp)	# fill _tmp372 to $t0 from $fp-8
	  lw $t2, 4($fp)	# fill this to $t2 from $fp+4
	  sw $t0, 16($t2) 	# store with offset
	# PushParam this
	  subu $sp, $sp, 4	# decrement sp to make space for param
	  lw $t0, 4($fp)	# fill this to $t0 from $fp+4
	  sw $t0, 4($sp)	# copy param value to stack
	# _tmp373 = *(this)
	  lw $t0, 4($fp)	# fill this to $t0 from $fp+4
	  lw $t2, 0($t0) 	# load with offset
	  sw $t2, -12($fp)	# spill _tmp373 from $t2 to $fp-12
	# _tmp374 = *(_tmp373 + 20)
	  lw $t0, -12($fp)	# fill _tmp373 to $t0 from $fp-12
	  lw $t2, 20($t0) 	# load with offset
	  sw $t2, -16($fp)	# spill _tmp374 from $t2 to $fp-16
	# ACall _tmp374
	  lw $t0, -16($fp)	# fill _tmp374 to $t0 from $fp-16
	  jalr $t0            	# jump to function
	# PopParams 4
	  add $sp, $sp, 4	# pop params off stack
  _L52:
	# _tmp375 = *(this + 16)
	  lw $t0, 4($fp)	# fill this to $t0 from $fp+4
	  lw $t2, 16($t0) 	# load with offset
	  sw $t2, -20($fp)	# spill _tmp375 from $t2 to $fp-20
	# _tmp376 = 0
	  li $t2, 0		# load constant value 0 into $t2
	  sw $t2, -24($fp)	# spill _tmp376 from $t2 to $fp-24
	# _tmp377 = _tmp375 < _tmp376
	  lw $t0, -20($fp)	# fill _tmp375 to $t0 from $fp-20
	  lw $t1, -24($fp)	# fill _tmp376 to $t1 from $fp-24
	  slt $t2, $t0, $t1	
	  sw $t2, -28($fp)	# spill _tmp377 from $t2 to $fp-28
	# _tmp378 = _tmp375 == _tmp376
	  lw $t0, -20($fp)	# fill _tmp375 to $t0 from $fp-20
	  lw $t1, -24($fp)	# fill _tmp376 to $t1 from $fp-24
	  seq $t2, $t0, $t1	
	  sw $t2, -32($fp)	# spill _tmp378 from $t2 to $fp-32
	# _tmp379 = _tmp377 || _tmp378
	  lw $t0, -28($fp)	# fill _tmp377 to $t0 from $fp-28
	  lw $t1, -32($fp)	# fill _tmp378 to $t1 from $fp-32
	  or $t2, $t0, $t1	
	  sw $t2, -36($fp)	# spill _tmp379 from $t2 to $fp-36
	# _tmp380 = *(this + 20)
	  lw $t0, 4($fp)	# fill this to $t0 from $fp+4
	  lw $t2, 20($t0) 	# load with offset
	  sw $t2, -40($fp)	# spill _tmp380 from $t2 to $fp-40
	# _tmp381 = *(this + 16)
	  lw $t0, 4($fp)	# fill this to $t0 from $fp+4
	  lw $t2, 16($t0) 	# load with offset
	  sw $t2, -44($fp)	# spill _tmp381 from $t2 to $fp-44
	# _tmp382 = _tmp380 < _tmp381
	  lw $t0, -40($fp)	# fill _tmp380 to $t0 from $fp-40
	  lw $t1, -44($fp)	# fill _tmp381 to $t1 from $fp-44
	  slt $t2, $t0, $t1	
	  sw $t2, -48($fp)	# spill _tmp382 from $t2 to $fp-48
	# _tmp383 = _tmp379 || _tmp382
	  lw $t0, -36($fp)	# fill _tmp379 to $t0 from $fp-36
	  lw $t1, -48($fp)	# fill _tmp382 to $t1 from $fp-48
	  or $t2, $t0, $t1	
	  sw $t2, -52($fp)	# spill _tmp383 from $t2 to $fp-52
	# IfZ _tmp383 Goto _L53
	  lw $t0, -52($fp)	# fill _tmp383 to $t0 from $fp-52
	  beqz $t0, _L53	# branch if _tmp383 is zero 
	# _tmp384 = "How much would you like to bet? "
	  .data			# create string constant marked with label
	  _string33: .asciiz "How much would you like to bet? "
	  .text
	  la $t2, _string33	# load label
	  sw $t2, -56($fp)	# spill _tmp384 from $t2 to $fp-56
	# PushParam _tmp384
	  subu $sp, $sp, 4	# decrement sp to make space for param
	  lw $t0, -56($fp)	# fill _tmp384 to $t0 from $fp-56
	  sw $t0, 4($sp)	# copy param value to stack
	# LCall _PrintString
	  jal _PrintString   	# jump to function
	# PopParams 4
	  add $sp, $sp, 4	# pop params off stack
	# _tmp385 = LCall _ReadInteger
	  jal _ReadInteger   	# jump to function
	  move $t2, $v0		# copy function return value from $v0
	  sw $t2, -60($fp)	# spill _tmp385 from $t2 to $fp-60
	# *(this + 16) = _tmp385
	  lw $t0, -60($fp)	# fill _tmp385 to $t0 from $fp-60
	  lw $t2, 4($fp)	# fill this to $t2 from $fp+4
	  sw $t0, 16($t2) 	# store with offset
	# Goto _L52
	  b _L52		# unconditional branch
  _L53:
	# EndFunc
	# (below handles reaching end of fn body with no explicit return)
	  move $sp, $fp		# pop callee frame off stack
	  lw $ra, -4($fp)	# restore saved ra
	  lw $fp, 0($fp)	# restore saved fp
	  jr $ra		# return from function
  Player.____GetTotal:
	# BeginFunc 4
	  subu $sp, $sp, 8	# decrement sp to make space to save ra, fp
	  sw $fp, 8($sp)	# save fp
	  sw $ra, 4($sp)	# save ra
	  addiu $fp, $sp, 8	# set up new fp
	  subu $sp, $sp, 4	# decrement sp to make space for locals/temps
	# _tmp386 = *(this + 4)
	  lw $t0, 4($fp)	# fill this to $t0 from $fp+4
	  lw $t2, 4($t0) 	# load with offset
	  sw $t2, -8($fp)	# spill _tmp386 from $t2 to $fp-8
	# Return _tmp386
	  lw $t2, -8($fp)	# fill _tmp386 to $t2 from $fp-8
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
  Player.____Resolve:
	# BeginFunc 224
	  subu $sp, $sp, 8	# decrement sp to make space to save ra, fp
	  sw $fp, 8($sp)	# save fp
	  sw $ra, 4($sp)	# save ra
	  addiu $fp, $sp, 8	# set up new fp
	  subu $sp, $sp, 224	# decrement sp to make space for locals/temps
	# _tmp387 = 0
	  li $t2, 0		# load constant value 0 into $t2
	  sw $t2, -16($fp)	# spill _tmp387 from $t2 to $fp-16
	# win = _tmp387
	  lw $t2, -16($fp)	# fill _tmp387 to $t2 from $fp-16
	  sw $t2, -8($fp)	# spill win from $t2 to $fp-8
	# _tmp388 = 0
	  li $t2, 0		# load constant value 0 into $t2
	  sw $t2, -20($fp)	# spill _tmp388 from $t2 to $fp-20
	# lose = _tmp388
	  lw $t2, -20($fp)	# fill _tmp388 to $t2 from $fp-20
	  sw $t2, -12($fp)	# spill lose from $t2 to $fp-12
	# _tmp389 = *(this + 4)
	  lw $t0, 4($fp)	# fill this to $t0 from $fp+4
	  lw $t2, 4($t0) 	# load with offset
	  sw $t2, -24($fp)	# spill _tmp389 from $t2 to $fp-24
	# _tmp390 = 21
	  li $t2, 21		# load constant value 21 into $t2
	  sw $t2, -28($fp)	# spill _tmp390 from $t2 to $fp-28
	# _tmp391 = _tmp389 == _tmp390
	  lw $t0, -24($fp)	# fill _tmp389 to $t0 from $fp-24
	  lw $t1, -28($fp)	# fill _tmp390 to $t1 from $fp-28
	  seq $t2, $t0, $t1	
	  sw $t2, -32($fp)	# spill _tmp391 from $t2 to $fp-32
	# _tmp392 = *(this + 12)
	  lw $t0, 4($fp)	# fill this to $t0 from $fp+4
	  lw $t2, 12($t0) 	# load with offset
	  sw $t2, -36($fp)	# spill _tmp392 from $t2 to $fp-36
	# _tmp393 = 2
	  li $t2, 2		# load constant value 2 into $t2
	  sw $t2, -40($fp)	# spill _tmp393 from $t2 to $fp-40
	# _tmp394 = _tmp392 == _tmp393
	  lw $t0, -36($fp)	# fill _tmp392 to $t0 from $fp-36
	  lw $t1, -40($fp)	# fill _tmp393 to $t1 from $fp-40
	  seq $t2, $t0, $t1	
	  sw $t2, -44($fp)	# spill _tmp394 from $t2 to $fp-44
	# _tmp395 = _tmp391 && _tmp394
	  lw $t0, -32($fp)	# fill _tmp391 to $t0 from $fp-32
	  lw $t1, -44($fp)	# fill _tmp394 to $t1 from $fp-44
	  and $t2, $t0, $t1	
	  sw $t2, -48($fp)	# spill _tmp395 from $t2 to $fp-48
	# IfZ _tmp395 Goto _L54
	  lw $t0, -48($fp)	# fill _tmp395 to $t0 from $fp-48
	  beqz $t0, _L54	# branch if _tmp395 is zero 
	# _tmp396 = 2
	  li $t2, 2		# load constant value 2 into $t2
	  sw $t2, -52($fp)	# spill _tmp396 from $t2 to $fp-52
	# win = _tmp396
	  lw $t2, -52($fp)	# fill _tmp396 to $t2 from $fp-52
	  sw $t2, -8($fp)	# spill win from $t2 to $fp-8
	# Goto _L55
	  b _L55		# unconditional branch
  _L54:
	# _tmp397 = 21
	  li $t2, 21		# load constant value 21 into $t2
	  sw $t2, -56($fp)	# spill _tmp397 from $t2 to $fp-56
	# _tmp398 = *(this + 4)
	  lw $t0, 4($fp)	# fill this to $t0 from $fp+4
	  lw $t2, 4($t0) 	# load with offset
	  sw $t2, -60($fp)	# spill _tmp398 from $t2 to $fp-60
	# _tmp399 = _tmp397 < _tmp398
	  lw $t0, -56($fp)	# fill _tmp397 to $t0 from $fp-56
	  lw $t1, -60($fp)	# fill _tmp398 to $t1 from $fp-60
	  slt $t2, $t0, $t1	
	  sw $t2, -64($fp)	# spill _tmp399 from $t2 to $fp-64
	# IfZ _tmp399 Goto _L56
	  lw $t0, -64($fp)	# fill _tmp399 to $t0 from $fp-64
	  beqz $t0, _L56	# branch if _tmp399 is zero 
	# _tmp400 = 1
	  li $t2, 1		# load constant value 1 into $t2
	  sw $t2, -68($fp)	# spill _tmp400 from $t2 to $fp-68
	# lose = _tmp400
	  lw $t2, -68($fp)	# fill _tmp400 to $t2 from $fp-68
	  sw $t2, -12($fp)	# spill lose from $t2 to $fp-12
	# Goto _L57
	  b _L57		# unconditional branch
  _L56:
	# _tmp401 = 21
	  li $t2, 21		# load constant value 21 into $t2
	  sw $t2, -72($fp)	# spill _tmp401 from $t2 to $fp-72
	# _tmp402 = _tmp401 < dealer
	  lw $t0, -72($fp)	# fill _tmp401 to $t0 from $fp-72
	  lw $t1, 8($fp)	# fill dealer to $t1 from $fp+8
	  slt $t2, $t0, $t1	
	  sw $t2, -76($fp)	# spill _tmp402 from $t2 to $fp-76
	# IfZ _tmp402 Goto _L58
	  lw $t0, -76($fp)	# fill _tmp402 to $t0 from $fp-76
	  beqz $t0, _L58	# branch if _tmp402 is zero 
	# _tmp403 = 1
	  li $t2, 1		# load constant value 1 into $t2
	  sw $t2, -80($fp)	# spill _tmp403 from $t2 to $fp-80
	# win = _tmp403
	  lw $t2, -80($fp)	# fill _tmp403 to $t2 from $fp-80
	  sw $t2, -8($fp)	# spill win from $t2 to $fp-8
	# Goto _L59
	  b _L59		# unconditional branch
  _L58:
	# _tmp404 = *(this + 4)
	  lw $t0, 4($fp)	# fill this to $t0 from $fp+4
	  lw $t2, 4($t0) 	# load with offset
	  sw $t2, -84($fp)	# spill _tmp404 from $t2 to $fp-84
	# _tmp405 = dealer < _tmp404
	  lw $t0, 8($fp)	# fill dealer to $t0 from $fp+8
	  lw $t1, -84($fp)	# fill _tmp404 to $t1 from $fp-84
	  slt $t2, $t0, $t1	
	  sw $t2, -88($fp)	# spill _tmp405 from $t2 to $fp-88
	# IfZ _tmp405 Goto _L60
	  lw $t0, -88($fp)	# fill _tmp405 to $t0 from $fp-88
	  beqz $t0, _L60	# branch if _tmp405 is zero 
	# _tmp406 = 1
	  li $t2, 1		# load constant value 1 into $t2
	  sw $t2, -92($fp)	# spill _tmp406 from $t2 to $fp-92
	# win = _tmp406
	  lw $t2, -92($fp)	# fill _tmp406 to $t2 from $fp-92
	  sw $t2, -8($fp)	# spill win from $t2 to $fp-8
	# Goto _L61
	  b _L61		# unconditional branch
  _L60:
	# _tmp407 = *(this + 4)
	  lw $t0, 4($fp)	# fill this to $t0 from $fp+4
	  lw $t2, 4($t0) 	# load with offset
	  sw $t2, -96($fp)	# spill _tmp407 from $t2 to $fp-96
	# _tmp408 = _tmp407 < dealer
	  lw $t0, -96($fp)	# fill _tmp407 to $t0 from $fp-96
	  lw $t1, 8($fp)	# fill dealer to $t1 from $fp+8
	  slt $t2, $t0, $t1	
	  sw $t2, -100($fp)	# spill _tmp408 from $t2 to $fp-100
	# IfZ _tmp408 Goto _L62
	  lw $t0, -100($fp)	# fill _tmp408 to $t0 from $fp-100
	  beqz $t0, _L62	# branch if _tmp408 is zero 
	# _tmp409 = 1
	  li $t2, 1		# load constant value 1 into $t2
	  sw $t2, -104($fp)	# spill _tmp409 from $t2 to $fp-104
	# lose = _tmp409
	  lw $t2, -104($fp)	# fill _tmp409 to $t2 from $fp-104
	  sw $t2, -12($fp)	# spill lose from $t2 to $fp-12
	# Goto _L63
	  b _L63		# unconditional branch
  _L62:
  _L63:
  _L61:
  _L59:
  _L57:
  _L55:
	# _tmp410 = 1
	  li $t2, 1		# load constant value 1 into $t2
	  sw $t2, -108($fp)	# spill _tmp410 from $t2 to $fp-108
	# _tmp411 = _tmp410 < win
	  lw $t0, -108($fp)	# fill _tmp410 to $t0 from $fp-108
	  lw $t1, -8($fp)	# fill win to $t1 from $fp-8
	  slt $t2, $t0, $t1	
	  sw $t2, -112($fp)	# spill _tmp411 from $t2 to $fp-112
	# _tmp412 = _tmp410 == win
	  lw $t0, -108($fp)	# fill _tmp410 to $t0 from $fp-108
	  lw $t1, -8($fp)	# fill win to $t1 from $fp-8
	  seq $t2, $t0, $t1	
	  sw $t2, -116($fp)	# spill _tmp412 from $t2 to $fp-116
	# _tmp413 = _tmp411 || _tmp412
	  lw $t0, -112($fp)	# fill _tmp411 to $t0 from $fp-112
	  lw $t1, -116($fp)	# fill _tmp412 to $t1 from $fp-116
	  or $t2, $t0, $t1	
	  sw $t2, -120($fp)	# spill _tmp413 from $t2 to $fp-120
	# IfZ _tmp413 Goto _L64
	  lw $t0, -120($fp)	# fill _tmp413 to $t0 from $fp-120
	  beqz $t0, _L64	# branch if _tmp413 is zero 
	# _tmp414 = *(this + 24)
	  lw $t0, 4($fp)	# fill this to $t0 from $fp+4
	  lw $t2, 24($t0) 	# load with offset
	  sw $t2, -124($fp)	# spill _tmp414 from $t2 to $fp-124
	# PushParam _tmp414
	  subu $sp, $sp, 4	# decrement sp to make space for param
	  lw $t0, -124($fp)	# fill _tmp414 to $t0 from $fp-124
	  sw $t0, 4($sp)	# copy param value to stack
	# LCall _PrintString
	  jal _PrintString   	# jump to function
	# PopParams 4
	  add $sp, $sp, 4	# pop params off stack
	# _tmp415 = ", you won $"
	  .data			# create string constant marked with label
	  _string34: .asciiz ", you won $"
	  .text
	  la $t2, _string34	# load label
	  sw $t2, -128($fp)	# spill _tmp415 from $t2 to $fp-128
	# PushParam _tmp415
	  subu $sp, $sp, 4	# decrement sp to make space for param
	  lw $t0, -128($fp)	# fill _tmp415 to $t0 from $fp-128
	  sw $t0, 4($sp)	# copy param value to stack
	# LCall _PrintString
	  jal _PrintString   	# jump to function
	# PopParams 4
	  add $sp, $sp, 4	# pop params off stack
	# _tmp416 = *(this + 16)
	  lw $t0, 4($fp)	# fill this to $t0 from $fp+4
	  lw $t2, 16($t0) 	# load with offset
	  sw $t2, -132($fp)	# spill _tmp416 from $t2 to $fp-132
	# PushParam _tmp416
	  subu $sp, $sp, 4	# decrement sp to make space for param
	  lw $t0, -132($fp)	# fill _tmp416 to $t0 from $fp-132
	  sw $t0, 4($sp)	# copy param value to stack
	# LCall _PrintInt
	  jal _PrintInt      	# jump to function
	# PopParams 4
	  add $sp, $sp, 4	# pop params off stack
	# _tmp417 = ".\n"
	  .data			# create string constant marked with label
	  _string35: .asciiz ".\n"
	  .text
	  la $t2, _string35	# load label
	  sw $t2, -136($fp)	# spill _tmp417 from $t2 to $fp-136
	# PushParam _tmp417
	  subu $sp, $sp, 4	# decrement sp to make space for param
	  lw $t0, -136($fp)	# fill _tmp417 to $t0 from $fp-136
	  sw $t0, 4($sp)	# copy param value to stack
	# LCall _PrintString
	  jal _PrintString   	# jump to function
	# PopParams 4
	  add $sp, $sp, 4	# pop params off stack
	# Goto _L65
	  b _L65		# unconditional branch
  _L64:
	# _tmp418 = 1
	  li $t2, 1		# load constant value 1 into $t2
	  sw $t2, -140($fp)	# spill _tmp418 from $t2 to $fp-140
	# _tmp419 = _tmp418 < lose
	  lw $t0, -140($fp)	# fill _tmp418 to $t0 from $fp-140
	  lw $t1, -12($fp)	# fill lose to $t1 from $fp-12
	  slt $t2, $t0, $t1	
	  sw $t2, -144($fp)	# spill _tmp419 from $t2 to $fp-144
	# _tmp420 = _tmp418 == lose
	  lw $t0, -140($fp)	# fill _tmp418 to $t0 from $fp-140
	  lw $t1, -12($fp)	# fill lose to $t1 from $fp-12
	  seq $t2, $t0, $t1	
	  sw $t2, -148($fp)	# spill _tmp420 from $t2 to $fp-148
	# _tmp421 = _tmp419 || _tmp420
	  lw $t0, -144($fp)	# fill _tmp419 to $t0 from $fp-144
	  lw $t1, -148($fp)	# fill _tmp420 to $t1 from $fp-148
	  or $t2, $t0, $t1	
	  sw $t2, -152($fp)	# spill _tmp421 from $t2 to $fp-152
	# IfZ _tmp421 Goto _L66
	  lw $t0, -152($fp)	# fill _tmp421 to $t0 from $fp-152
	  beqz $t0, _L66	# branch if _tmp421 is zero 
	# _tmp422 = *(this + 24)
	  lw $t0, 4($fp)	# fill this to $t0 from $fp+4
	  lw $t2, 24($t0) 	# load with offset
	  sw $t2, -156($fp)	# spill _tmp422 from $t2 to $fp-156
	# PushParam _tmp422
	  subu $sp, $sp, 4	# decrement sp to make space for param
	  lw $t0, -156($fp)	# fill _tmp422 to $t0 from $fp-156
	  sw $t0, 4($sp)	# copy param value to stack
	# LCall _PrintString
	  jal _PrintString   	# jump to function
	# PopParams 4
	  add $sp, $sp, 4	# pop params off stack
	# _tmp423 = ", you lost $"
	  .data			# create string constant marked with label
	  _string36: .asciiz ", you lost $"
	  .text
	  la $t2, _string36	# load label
	  sw $t2, -160($fp)	# spill _tmp423 from $t2 to $fp-160
	# PushParam _tmp423
	  subu $sp, $sp, 4	# decrement sp to make space for param
	  lw $t0, -160($fp)	# fill _tmp423 to $t0 from $fp-160
	  sw $t0, 4($sp)	# copy param value to stack
	# LCall _PrintString
	  jal _PrintString   	# jump to function
	# PopParams 4
	  add $sp, $sp, 4	# pop params off stack
	# _tmp424 = *(this + 16)
	  lw $t0, 4($fp)	# fill this to $t0 from $fp+4
	  lw $t2, 16($t0) 	# load with offset
	  sw $t2, -164($fp)	# spill _tmp424 from $t2 to $fp-164
	# PushParam _tmp424
	  subu $sp, $sp, 4	# decrement sp to make space for param
	  lw $t0, -164($fp)	# fill _tmp424 to $t0 from $fp-164
	  sw $t0, 4($sp)	# copy param value to stack
	# LCall _PrintInt
	  jal _PrintInt      	# jump to function
	# PopParams 4
	  add $sp, $sp, 4	# pop params off stack
	# _tmp425 = ".\n"
	  .data			# create string constant marked with label
	  _string37: .asciiz ".\n"
	  .text
	  la $t2, _string37	# load label
	  sw $t2, -168($fp)	# spill _tmp425 from $t2 to $fp-168
	# PushParam _tmp425
	  subu $sp, $sp, 4	# decrement sp to make space for param
	  lw $t0, -168($fp)	# fill _tmp425 to $t0 from $fp-168
	  sw $t0, 4($sp)	# copy param value to stack
	# LCall _PrintString
	  jal _PrintString   	# jump to function
	# PopParams 4
	  add $sp, $sp, 4	# pop params off stack
	# Goto _L67
	  b _L67		# unconditional branch
  _L66:
	# _tmp426 = *(this + 24)
	  lw $t0, 4($fp)	# fill this to $t0 from $fp+4
	  lw $t2, 24($t0) 	# load with offset
	  sw $t2, -172($fp)	# spill _tmp426 from $t2 to $fp-172
	# PushParam _tmp426
	  subu $sp, $sp, 4	# decrement sp to make space for param
	  lw $t0, -172($fp)	# fill _tmp426 to $t0 from $fp-172
	  sw $t0, 4($sp)	# copy param value to stack
	# LCall _PrintString
	  jal _PrintString   	# jump to function
	# PopParams 4
	  add $sp, $sp, 4	# pop params off stack
	# _tmp427 = ", you push!\n"
	  .data			# create string constant marked with label
	  _string38: .asciiz ", you push!\n"
	  .text
	  la $t2, _string38	# load label
	  sw $t2, -176($fp)	# spill _tmp427 from $t2 to $fp-176
	# PushParam _tmp427
	  subu $sp, $sp, 4	# decrement sp to make space for param
	  lw $t0, -176($fp)	# fill _tmp427 to $t0 from $fp-176
	  sw $t0, 4($sp)	# copy param value to stack
	# LCall _PrintString
	  jal _PrintString   	# jump to function
	# PopParams 4
	  add $sp, $sp, 4	# pop params off stack
  _L67:
  _L65:
	# _tmp428 = *(this + 16)
	  lw $t0, 4($fp)	# fill this to $t0 from $fp+4
	  lw $t2, 16($t0) 	# load with offset
	  sw $t2, -180($fp)	# spill _tmp428 from $t2 to $fp-180
	# _tmp429 = win * _tmp428
	  lw $t0, -8($fp)	# fill win to $t0 from $fp-8
	  lw $t1, -180($fp)	# fill _tmp428 to $t1 from $fp-180
	  mul $t2, $t0, $t1	
	  sw $t2, -184($fp)	# spill _tmp429 from $t2 to $fp-184
	# win = _tmp429
	  lw $t2, -184($fp)	# fill _tmp429 to $t2 from $fp-184
	  sw $t2, -8($fp)	# spill win from $t2 to $fp-8
	# _tmp430 = *(this + 16)
	  lw $t0, 4($fp)	# fill this to $t0 from $fp+4
	  lw $t2, 16($t0) 	# load with offset
	  sw $t2, -188($fp)	# spill _tmp430 from $t2 to $fp-188
	# _tmp431 = lose * _tmp430
	  lw $t0, -12($fp)	# fill lose to $t0 from $fp-12
	  lw $t1, -188($fp)	# fill _tmp430 to $t1 from $fp-188
	  mul $t2, $t0, $t1	
	  sw $t2, -192($fp)	# spill _tmp431 from $t2 to $fp-192
	# lose = _tmp431
	  lw $t2, -192($fp)	# fill _tmp431 to $t2 from $fp-192
	  sw $t2, -12($fp)	# spill lose from $t2 to $fp-12
	# _tmp432 = *(this + 20)
	  lw $t0, 4($fp)	# fill this to $t0 from $fp+4
	  lw $t2, 20($t0) 	# load with offset
	  sw $t2, -196($fp)	# spill _tmp432 from $t2 to $fp-196
	# _tmp433 = _tmp432 + win
	  lw $t0, -196($fp)	# fill _tmp432 to $t0 from $fp-196
	  lw $t1, -8($fp)	# fill win to $t1 from $fp-8
	  add $t2, $t0, $t1	
	  sw $t2, -200($fp)	# spill _tmp433 from $t2 to $fp-200
	# _tmp434 = _tmp433 - lose
	  lw $t0, -200($fp)	# fill _tmp433 to $t0 from $fp-200
	  lw $t1, -12($fp)	# fill lose to $t1 from $fp-12
	  sub $t2, $t0, $t1	
	  sw $t2, -204($fp)	# spill _tmp434 from $t2 to $fp-204
	# *(this + 20) = _tmp434
	  lw $t0, -204($fp)	# fill _tmp434 to $t0 from $fp-204
	  lw $t2, 4($fp)	# fill this to $t2 from $fp+4
	  sw $t0, 20($t2) 	# store with offset
	# EndFunc
	# (below handles reaching end of fn body with no explicit return)
	  move $sp, $fp		# pop callee frame off stack
	  lw $ra, -4($fp)	# restore saved ra
	  lw $fp, 0($fp)	# restore saved fp
	  jr $ra		# return from function
	# VTable for class Player
	  .data
	  .align 2
	  Player:		# label for class Player vtable
	  .word Player.____Init
	  .word Player.____Hit
	  .word Player.____DoubleDown
	  .word Player.____TakeTurn
	  .word Player.____HasMoney
	  .word Player.____PrintMoney
	  .word Player.____PlaceBet
	  .word Player.____GetTotal
	  .word Player.____Resolve
	  .text
  Dealer.____Init:
	# BeginFunc 16
	  subu $sp, $sp, 8	# decrement sp to make space to save ra, fp
	  sw $fp, 8($sp)	# save fp
	  sw $ra, 4($sp)	# save ra
	  addiu $fp, $sp, 8	# set up new fp
	  subu $sp, $sp, 16	# decrement sp to make space for locals/temps
	# _tmp435 = 0
	  li $t2, 0		# load constant value 0 into $t2
	  sw $t2, -8($fp)	# spill _tmp435 from $t2 to $fp-8
	# *(this + 4) = _tmp435
	  lw $t0, -8($fp)	# fill _tmp435 to $t0 from $fp-8
	  lw $t2, 4($fp)	# fill this to $t2 from $fp+4
	  sw $t0, 4($t2) 	# store with offset
	# _tmp436 = 0
	  li $t2, 0		# load constant value 0 into $t2
	  sw $t2, -12($fp)	# spill _tmp436 from $t2 to $fp-12
	# *(this + 8) = _tmp436
	  lw $t0, -12($fp)	# fill _tmp436 to $t0 from $fp-12
	  lw $t2, 4($fp)	# fill this to $t2 from $fp+4
	  sw $t0, 8($t2) 	# store with offset
	# _tmp437 = 0
	  li $t2, 0		# load constant value 0 into $t2
	  sw $t2, -16($fp)	# spill _tmp437 from $t2 to $fp-16
	# *(this + 12) = _tmp437
	  lw $t0, -16($fp)	# fill _tmp437 to $t0 from $fp-16
	  lw $t2, 4($fp)	# fill this to $t2 from $fp+4
	  sw $t0, 12($t2) 	# store with offset
	# _tmp438 = "Dealer"
	  .data			# create string constant marked with label
	  _string39: .asciiz "Dealer"
	  .text
	  la $t2, _string39	# load label
	  sw $t2, -20($fp)	# spill _tmp438 from $t2 to $fp-20
	# *(this + 24) = _tmp438
	  lw $t0, -20($fp)	# fill _tmp438 to $t0 from $fp-20
	  lw $t2, 4($fp)	# fill this to $t2 from $fp+4
	  sw $t0, 24($t2) 	# store with offset
	# EndFunc
	# (below handles reaching end of fn body with no explicit return)
	  move $sp, $fp		# pop callee frame off stack
	  lw $ra, -4($fp)	# restore saved ra
	  lw $fp, 0($fp)	# restore saved fp
	  jr $ra		# return from function
  Dealer.____TakeTurn:
	# BeginFunc 84
	  subu $sp, $sp, 8	# decrement sp to make space to save ra, fp
	  sw $fp, 8($sp)	# save fp
	  sw $ra, 4($sp)	# save ra
	  addiu $fp, $sp, 8	# set up new fp
	  subu $sp, $sp, 84	# decrement sp to make space for locals/temps
	# _tmp439 = "\n"
	  .data			# create string constant marked with label
	  _string40: .asciiz "\n"
	  .text
	  la $t2, _string40	# load label
	  sw $t2, -8($fp)	# spill _tmp439 from $t2 to $fp-8
	# PushParam _tmp439
	  subu $sp, $sp, 4	# decrement sp to make space for param
	  lw $t0, -8($fp)	# fill _tmp439 to $t0 from $fp-8
	  sw $t0, 4($sp)	# copy param value to stack
	# LCall _PrintString
	  jal _PrintString   	# jump to function
	# PopParams 4
	  add $sp, $sp, 4	# pop params off stack
	# _tmp440 = *(this + 24)
	  lw $t0, 4($fp)	# fill this to $t0 from $fp+4
	  lw $t2, 24($t0) 	# load with offset
	  sw $t2, -12($fp)	# spill _tmp440 from $t2 to $fp-12
	# PushParam _tmp440
	  subu $sp, $sp, 4	# decrement sp to make space for param
	  lw $t0, -12($fp)	# fill _tmp440 to $t0 from $fp-12
	  sw $t0, 4($sp)	# copy param value to stack
	# LCall _PrintString
	  jal _PrintString   	# jump to function
	# PopParams 4
	  add $sp, $sp, 4	# pop params off stack
	# _tmp441 = "'s turn.\n"
	  .data			# create string constant marked with label
	  _string41: .asciiz "'s turn.\n"
	  .text
	  la $t2, _string41	# load label
	  sw $t2, -16($fp)	# spill _tmp441 from $t2 to $fp-16
	# PushParam _tmp441
	  subu $sp, $sp, 4	# decrement sp to make space for param
	  lw $t0, -16($fp)	# fill _tmp441 to $t0 from $fp-16
	  sw $t0, 4($sp)	# copy param value to stack
	# LCall _PrintString
	  jal _PrintString   	# jump to function
	# PopParams 4
	  add $sp, $sp, 4	# pop params off stack
  _L68:
	# _tmp442 = *(this + 4)
	  lw $t0, 4($fp)	# fill this to $t0 from $fp+4
	  lw $t2, 4($t0) 	# load with offset
	  sw $t2, -20($fp)	# spill _tmp442 from $t2 to $fp-20
	# _tmp443 = 16
	  li $t2, 16		# load constant value 16 into $t2
	  sw $t2, -24($fp)	# spill _tmp443 from $t2 to $fp-24
	# _tmp444 = _tmp442 < _tmp443
	  lw $t0, -20($fp)	# fill _tmp442 to $t0 from $fp-20
	  lw $t1, -24($fp)	# fill _tmp443 to $t1 from $fp-24
	  slt $t2, $t0, $t1	
	  sw $t2, -28($fp)	# spill _tmp444 from $t2 to $fp-28
	# _tmp445 = _tmp442 == _tmp443
	  lw $t0, -20($fp)	# fill _tmp442 to $t0 from $fp-20
	  lw $t1, -24($fp)	# fill _tmp443 to $t1 from $fp-24
	  seq $t2, $t0, $t1	
	  sw $t2, -32($fp)	# spill _tmp445 from $t2 to $fp-32
	# _tmp446 = _tmp444 || _tmp445
	  lw $t0, -28($fp)	# fill _tmp444 to $t0 from $fp-28
	  lw $t1, -32($fp)	# fill _tmp445 to $t1 from $fp-32
	  or $t2, $t0, $t1	
	  sw $t2, -36($fp)	# spill _tmp446 from $t2 to $fp-36
	# IfZ _tmp446 Goto _L69
	  lw $t0, -36($fp)	# fill _tmp446 to $t0 from $fp-36
	  beqz $t0, _L69	# branch if _tmp446 is zero 
	# PushParam deck
	  subu $sp, $sp, 4	# decrement sp to make space for param
	  lw $t0, 8($fp)	# fill deck to $t0 from $fp+8
	  sw $t0, 4($sp)	# copy param value to stack
	# PushParam this
	  subu $sp, $sp, 4	# decrement sp to make space for param
	  lw $t0, 4($fp)	# fill this to $t0 from $fp+4
	  sw $t0, 4($sp)	# copy param value to stack
	# _tmp447 = *(this)
	  lw $t0, 4($fp)	# fill this to $t0 from $fp+4
	  lw $t2, 0($t0) 	# load with offset
	  sw $t2, -40($fp)	# spill _tmp447 from $t2 to $fp-40
	# _tmp448 = *(_tmp447 + 4)
	  lw $t0, -40($fp)	# fill _tmp447 to $t0 from $fp-40
	  lw $t2, 4($t0) 	# load with offset
	  sw $t2, -44($fp)	# spill _tmp448 from $t2 to $fp-44
	# ACall _tmp448
	  lw $t0, -44($fp)	# fill _tmp448 to $t0 from $fp-44
	  jalr $t0            	# jump to function
	# PopParams 8
	  add $sp, $sp, 8	# pop params off stack
	# Goto _L68
	  b _L68		# unconditional branch
  _L69:
	# _tmp449 = 21
	  li $t2, 21		# load constant value 21 into $t2
	  sw $t2, -48($fp)	# spill _tmp449 from $t2 to $fp-48
	# _tmp450 = *(this + 4)
	  lw $t0, 4($fp)	# fill this to $t0 from $fp+4
	  lw $t2, 4($t0) 	# load with offset
	  sw $t2, -52($fp)	# spill _tmp450 from $t2 to $fp-52
	# _tmp451 = _tmp449 < _tmp450
	  lw $t0, -48($fp)	# fill _tmp449 to $t0 from $fp-48
	  lw $t1, -52($fp)	# fill _tmp450 to $t1 from $fp-52
	  slt $t2, $t0, $t1	
	  sw $t2, -56($fp)	# spill _tmp451 from $t2 to $fp-56
	# IfZ _tmp451 Goto _L70
	  lw $t0, -56($fp)	# fill _tmp451 to $t0 from $fp-56
	  beqz $t0, _L70	# branch if _tmp451 is zero 
	# _tmp452 = *(this + 24)
	  lw $t0, 4($fp)	# fill this to $t0 from $fp+4
	  lw $t2, 24($t0) 	# load with offset
	  sw $t2, -60($fp)	# spill _tmp452 from $t2 to $fp-60
	# PushParam _tmp452
	  subu $sp, $sp, 4	# decrement sp to make space for param
	  lw $t0, -60($fp)	# fill _tmp452 to $t0 from $fp-60
	  sw $t0, 4($sp)	# copy param value to stack
	# LCall _PrintString
	  jal _PrintString   	# jump to function
	# PopParams 4
	  add $sp, $sp, 4	# pop params off stack
	# _tmp453 = " busts with the big "
	  .data			# create string constant marked with label
	  _string42: .asciiz " busts with the big "
	  .text
	  la $t2, _string42	# load label
	  sw $t2, -64($fp)	# spill _tmp453 from $t2 to $fp-64
	# PushParam _tmp453
	  subu $sp, $sp, 4	# decrement sp to make space for param
	  lw $t0, -64($fp)	# fill _tmp453 to $t0 from $fp-64
	  sw $t0, 4($sp)	# copy param value to stack
	# LCall _PrintString
	  jal _PrintString   	# jump to function
	# PopParams 4
	  add $sp, $sp, 4	# pop params off stack
	# _tmp454 = *(this + 4)
	  lw $t0, 4($fp)	# fill this to $t0 from $fp+4
	  lw $t2, 4($t0) 	# load with offset
	  sw $t2, -68($fp)	# spill _tmp454 from $t2 to $fp-68
	# PushParam _tmp454
	  subu $sp, $sp, 4	# decrement sp to make space for param
	  lw $t0, -68($fp)	# fill _tmp454 to $t0 from $fp-68
	  sw $t0, 4($sp)	# copy param value to stack
	# LCall _PrintInt
	  jal _PrintInt      	# jump to function
	# PopParams 4
	  add $sp, $sp, 4	# pop params off stack
	# _tmp455 = "!\n"
	  .data			# create string constant marked with label
	  _string43: .asciiz "!\n"
	  .text
	  la $t2, _string43	# load label
	  sw $t2, -72($fp)	# spill _tmp455 from $t2 to $fp-72
	# PushParam _tmp455
	  subu $sp, $sp, 4	# decrement sp to make space for param
	  lw $t0, -72($fp)	# fill _tmp455 to $t0 from $fp-72
	  sw $t0, 4($sp)	# copy param value to stack
	# LCall _PrintString
	  jal _PrintString   	# jump to function
	# PopParams 4
	  add $sp, $sp, 4	# pop params off stack
	# Goto _L71
	  b _L71		# unconditional branch
  _L70:
	# _tmp456 = *(this + 24)
	  lw $t0, 4($fp)	# fill this to $t0 from $fp+4
	  lw $t2, 24($t0) 	# load with offset
	  sw $t2, -76($fp)	# spill _tmp456 from $t2 to $fp-76
	# PushParam _tmp456
	  subu $sp, $sp, 4	# decrement sp to make space for param
	  lw $t0, -76($fp)	# fill _tmp456 to $t0 from $fp-76
	  sw $t0, 4($sp)	# copy param value to stack
	# LCall _PrintString
	  jal _PrintString   	# jump to function
	# PopParams 4
	  add $sp, $sp, 4	# pop params off stack
	# _tmp457 = " stays at "
	  .data			# create string constant marked with label
	  _string44: .asciiz " stays at "
	  .text
	  la $t2, _string44	# load label
	  sw $t2, -80($fp)	# spill _tmp457 from $t2 to $fp-80
	# PushParam _tmp457
	  subu $sp, $sp, 4	# decrement sp to make space for param
	  lw $t0, -80($fp)	# fill _tmp457 to $t0 from $fp-80
	  sw $t0, 4($sp)	# copy param value to stack
	# LCall _PrintString
	  jal _PrintString   	# jump to function
	# PopParams 4
	  add $sp, $sp, 4	# pop params off stack
	# _tmp458 = *(this + 4)
	  lw $t0, 4($fp)	# fill this to $t0 from $fp+4
	  lw $t2, 4($t0) 	# load with offset
	  sw $t2, -84($fp)	# spill _tmp458 from $t2 to $fp-84
	# PushParam _tmp458
	  subu $sp, $sp, 4	# decrement sp to make space for param
	  lw $t0, -84($fp)	# fill _tmp458 to $t0 from $fp-84
	  sw $t0, 4($sp)	# copy param value to stack
	# LCall _PrintInt
	  jal _PrintInt      	# jump to function
	# PopParams 4
	  add $sp, $sp, 4	# pop params off stack
	# _tmp459 = ".\n"
	  .data			# create string constant marked with label
	  _string45: .asciiz ".\n"
	  .text
	  la $t2, _string45	# load label
	  sw $t2, -88($fp)	# spill _tmp459 from $t2 to $fp-88
	# PushParam _tmp459
	  subu $sp, $sp, 4	# decrement sp to make space for param
	  lw $t0, -88($fp)	# fill _tmp459 to $t0 from $fp-88
	  sw $t0, 4($sp)	# copy param value to stack
	# LCall _PrintString
	  jal _PrintString   	# jump to function
	# PopParams 4
	  add $sp, $sp, 4	# pop params off stack
  _L71:
	# EndFunc
	# (below handles reaching end of fn body with no explicit return)
	  move $sp, $fp		# pop callee frame off stack
	  lw $ra, -4($fp)	# restore saved ra
	  lw $fp, 0($fp)	# restore saved fp
	  jr $ra		# return from function
	# VTable for class Dealer
	  .data
	  .align 2
	  Dealer:		# label for class Dealer vtable
	  .word Dealer.____Init
	  .word Player.____Hit
	  .word Player.____DoubleDown
	  .word Dealer.____TakeTurn
	  .word Player.____HasMoney
	  .word Player.____PrintMoney
	  .word Player.____PlaceBet
	  .word Player.____GetTotal
	  .word Player.____Resolve
	  .word Dealer.____Init
	  .word Dealer.____TakeTurn
	  .text
  House.____SetupGame:
	# BeginFunc 108
	  subu $sp, $sp, 8	# decrement sp to make space to save ra, fp
	  sw $fp, 8($sp)	# save fp
	  sw $ra, 4($sp)	# save ra
	  addiu $fp, $sp, 8	# set up new fp
	  subu $sp, $sp, 108	# decrement sp to make space for locals/temps
	# _tmp460 = "\nWelcome to CS143 BlackJack!\n"
	  .data			# create string constant marked with label
	  _string46: .asciiz "\nWelcome to CS143 BlackJack!\n"
	  .text
	  la $t2, _string46	# load label
	  sw $t2, -8($fp)	# spill _tmp460 from $t2 to $fp-8
	# PushParam _tmp460
	  subu $sp, $sp, 4	# decrement sp to make space for param
	  lw $t0, -8($fp)	# fill _tmp460 to $t0 from $fp-8
	  sw $t0, 4($sp)	# copy param value to stack
	# LCall _PrintString
	  jal _PrintString   	# jump to function
	# PopParams 4
	  add $sp, $sp, 4	# pop params off stack
	# _tmp461 = "---------------------------\n"
	  .data			# create string constant marked with label
	  _string47: .asciiz "---------------------------\n"
	  .text
	  la $t2, _string47	# load label
	  sw $t2, -12($fp)	# spill _tmp461 from $t2 to $fp-12
	# PushParam _tmp461
	  subu $sp, $sp, 4	# decrement sp to make space for param
	  lw $t0, -12($fp)	# fill _tmp461 to $t0 from $fp-12
	  sw $t0, 4($sp)	# copy param value to stack
	# LCall _PrintString
	  jal _PrintString   	# jump to function
	# PopParams 4
	  add $sp, $sp, 4	# pop params off stack
	# _tmp462 = 4
	  li $t2, 4		# load constant value 4 into $t2
	  sw $t2, -16($fp)	# spill _tmp462 from $t2 to $fp-16
	# _tmp463 = 4
	  li $t2, 4		# load constant value 4 into $t2
	  sw $t2, -20($fp)	# spill _tmp463 from $t2 to $fp-20
	# _tmp464 = _tmp463 + _tmp462
	  lw $t0, -20($fp)	# fill _tmp463 to $t0 from $fp-20
	  lw $t1, -16($fp)	# fill _tmp462 to $t1 from $fp-16
	  add $t2, $t0, $t1	
	  sw $t2, -24($fp)	# spill _tmp464 from $t2 to $fp-24
	# PushParam _tmp464
	  subu $sp, $sp, 4	# decrement sp to make space for param
	  lw $t0, -24($fp)	# fill _tmp464 to $t0 from $fp-24
	  sw $t0, 4($sp)	# copy param value to stack
	# _tmp465 = LCall _Alloc
	  jal _Alloc         	# jump to function
	  move $t2, $v0		# copy function return value from $v0
	  sw $t2, -28($fp)	# spill _tmp465 from $t2 to $fp-28
	# PopParams 4
	  add $sp, $sp, 4	# pop params off stack
	# _tmp466 = Random
	  la $t2, Random	# load label
	  sw $t2, -32($fp)	# spill _tmp466 from $t2 to $fp-32
	# *(_tmp465) = _tmp466
	  lw $t0, -32($fp)	# fill _tmp466 to $t0 from $fp-32
	  lw $t2, -28($fp)	# fill _tmp465 to $t2 from $fp-28
	  sw $t0, 0($t2) 	# store with offset
	# gRnd = _tmp465
	  lw $t2, -28($fp)	# fill _tmp465 to $t2 from $fp-28
	  sw $t2, 0($gp)	# spill gRnd from $t2 to $gp+0
	# _tmp467 = "Please enter a random number seed: "
	  .data			# create string constant marked with label
	  _string48: .asciiz "Please enter a random number seed: "
	  .text
	  la $t2, _string48	# load label
	  sw $t2, -36($fp)	# spill _tmp467 from $t2 to $fp-36
	# PushParam _tmp467
	  subu $sp, $sp, 4	# decrement sp to make space for param
	  lw $t0, -36($fp)	# fill _tmp467 to $t0 from $fp-36
	  sw $t0, 4($sp)	# copy param value to stack
	# LCall _PrintString
	  jal _PrintString   	# jump to function
	# PopParams 4
	  add $sp, $sp, 4	# pop params off stack
	# _tmp468 = LCall _ReadInteger
	  jal _ReadInteger   	# jump to function
	  move $t2, $v0		# copy function return value from $v0
	  sw $t2, -40($fp)	# spill _tmp468 from $t2 to $fp-40
	# PushParam _tmp468
	  subu $sp, $sp, 4	# decrement sp to make space for param
	  lw $t0, -40($fp)	# fill _tmp468 to $t0 from $fp-40
	  sw $t0, 4($sp)	# copy param value to stack
	# PushParam gRnd
	  subu $sp, $sp, 4	# decrement sp to make space for param
	  lw $t0, 0($gp)	# fill gRnd to $t0 from $gp+0
	  sw $t0, 4($sp)	# copy param value to stack
	# _tmp469 = *(gRnd)
	  lw $t0, 0($gp)	# fill gRnd to $t0 from $gp+0
	  lw $t2, 0($t0) 	# load with offset
	  sw $t2, -44($fp)	# spill _tmp469 from $t2 to $fp-44
	# _tmp470 = *(_tmp469)
	  lw $t0, -44($fp)	# fill _tmp469 to $t0 from $fp-44
	  lw $t2, 0($t0) 	# load with offset
	  sw $t2, -48($fp)	# spill _tmp470 from $t2 to $fp-48
	# ACall _tmp470
	  lw $t0, -48($fp)	# fill _tmp470 to $t0 from $fp-48
	  jalr $t0            	# jump to function
	# PopParams 8
	  add $sp, $sp, 8	# pop params off stack
	# _tmp471 = 8
	  li $t2, 8		# load constant value 8 into $t2
	  sw $t2, -52($fp)	# spill _tmp471 from $t2 to $fp-52
	# _tmp472 = 4
	  li $t2, 4		# load constant value 4 into $t2
	  sw $t2, -56($fp)	# spill _tmp472 from $t2 to $fp-56
	# _tmp473 = _tmp472 + _tmp471
	  lw $t0, -56($fp)	# fill _tmp472 to $t0 from $fp-56
	  lw $t1, -52($fp)	# fill _tmp471 to $t1 from $fp-52
	  add $t2, $t0, $t1	
	  sw $t2, -60($fp)	# spill _tmp473 from $t2 to $fp-60
	# PushParam _tmp473
	  subu $sp, $sp, 4	# decrement sp to make space for param
	  lw $t0, -60($fp)	# fill _tmp473 to $t0 from $fp-60
	  sw $t0, 4($sp)	# copy param value to stack
	# _tmp474 = LCall _Alloc
	  jal _Alloc         	# jump to function
	  move $t2, $v0		# copy function return value from $v0
	  sw $t2, -64($fp)	# spill _tmp474 from $t2 to $fp-64
	# PopParams 4
	  add $sp, $sp, 4	# pop params off stack
	# _tmp475 = BJDeck
	  la $t2, BJDeck	# load label
	  sw $t2, -68($fp)	# spill _tmp475 from $t2 to $fp-68
	# *(_tmp474) = _tmp475
	  lw $t0, -68($fp)	# fill _tmp475 to $t0 from $fp-68
	  lw $t2, -64($fp)	# fill _tmp474 to $t2 from $fp-64
	  sw $t0, 0($t2) 	# store with offset
	# *(this + 12) = _tmp474
	  lw $t0, -64($fp)	# fill _tmp474 to $t0 from $fp-64
	  lw $t2, 4($fp)	# fill this to $t2 from $fp+4
	  sw $t0, 12($t2) 	# store with offset
	# _tmp476 = 24
	  li $t2, 24		# load constant value 24 into $t2
	  sw $t2, -72($fp)	# spill _tmp476 from $t2 to $fp-72
	# _tmp477 = 4
	  li $t2, 4		# load constant value 4 into $t2
	  sw $t2, -76($fp)	# spill _tmp477 from $t2 to $fp-76
	# _tmp478 = _tmp477 + _tmp476
	  lw $t0, -76($fp)	# fill _tmp477 to $t0 from $fp-76
	  lw $t1, -72($fp)	# fill _tmp476 to $t1 from $fp-72
	  add $t2, $t0, $t1	
	  sw $t2, -80($fp)	# spill _tmp478 from $t2 to $fp-80
	# PushParam _tmp478
	  subu $sp, $sp, 4	# decrement sp to make space for param
	  lw $t0, -80($fp)	# fill _tmp478 to $t0 from $fp-80
	  sw $t0, 4($sp)	# copy param value to stack
	# _tmp479 = LCall _Alloc
	  jal _Alloc         	# jump to function
	  move $t2, $v0		# copy function return value from $v0
	  sw $t2, -84($fp)	# spill _tmp479 from $t2 to $fp-84
	# PopParams 4
	  add $sp, $sp, 4	# pop params off stack
	# _tmp480 = Dealer
	  la $t2, Dealer	# load label
	  sw $t2, -88($fp)	# spill _tmp480 from $t2 to $fp-88
	# *(_tmp479) = _tmp480
	  lw $t0, -88($fp)	# fill _tmp480 to $t0 from $fp-88
	  lw $t2, -84($fp)	# fill _tmp479 to $t2 from $fp-84
	  sw $t0, 0($t2) 	# store with offset
	# *(this + 8) = _tmp479
	  lw $t0, -84($fp)	# fill _tmp479 to $t0 from $fp-84
	  lw $t2, 4($fp)	# fill this to $t2 from $fp+4
	  sw $t0, 8($t2) 	# store with offset
	# _tmp481 = *(this + 12)
	  lw $t0, 4($fp)	# fill this to $t0 from $fp+4
	  lw $t2, 12($t0) 	# load with offset
	  sw $t2, -92($fp)	# spill _tmp481 from $t2 to $fp-92
	# PushParam _tmp481
	  subu $sp, $sp, 4	# decrement sp to make space for param
	  lw $t0, -92($fp)	# fill _tmp481 to $t0 from $fp-92
	  sw $t0, 4($sp)	# copy param value to stack
	# _tmp482 = *(_tmp481)
	  lw $t0, -92($fp)	# fill _tmp481 to $t0 from $fp-92
	  lw $t2, 0($t0) 	# load with offset
	  sw $t2, -96($fp)	# spill _tmp482 from $t2 to $fp-96
	# _tmp483 = *(_tmp482)
	  lw $t0, -96($fp)	# fill _tmp482 to $t0 from $fp-96
	  lw $t2, 0($t0) 	# load with offset
	  sw $t2, -100($fp)	# spill _tmp483 from $t2 to $fp-100
	# ACall _tmp483
	  lw $t0, -100($fp)	# fill _tmp483 to $t0 from $fp-100
	  jalr $t0            	# jump to function
	# PopParams 4
	  add $sp, $sp, 4	# pop params off stack
	# _tmp484 = *(this + 12)
	  lw $t0, 4($fp)	# fill this to $t0 from $fp+4
	  lw $t2, 12($t0) 	# load with offset
	  sw $t2, -104($fp)	# spill _tmp484 from $t2 to $fp-104
	# PushParam _tmp484
	  subu $sp, $sp, 4	# decrement sp to make space for param
	  lw $t0, -104($fp)	# fill _tmp484 to $t0 from $fp-104
	  sw $t0, 4($sp)	# copy param value to stack
	# _tmp485 = *(_tmp484)
	  lw $t0, -104($fp)	# fill _tmp484 to $t0 from $fp-104
	  lw $t2, 0($t0) 	# load with offset
	  sw $t2, -108($fp)	# spill _tmp485 from $t2 to $fp-108
	# _tmp486 = *(_tmp485 + 8)
	  lw $t0, -108($fp)	# fill _tmp485 to $t0 from $fp-108
	  lw $t2, 8($t0) 	# load with offset
	  sw $t2, -112($fp)	# spill _tmp486 from $t2 to $fp-112
	# ACall _tmp486
	  lw $t0, -112($fp)	# fill _tmp486 to $t0 from $fp-112
	  jalr $t0            	# jump to function
	# PopParams 4
	  add $sp, $sp, 4	# pop params off stack
	# EndFunc
	# (below handles reaching end of fn body with no explicit return)
	  move $sp, $fp		# pop callee frame off stack
	  lw $ra, -4($fp)	# restore saved ra
	  lw $fp, 0($fp)	# restore saved fp
	  jr $ra		# return from function
  House.____SetupPlayers:
	# BeginFunc 248
	  subu $sp, $sp, 8	# decrement sp to make space to save ra, fp
	  sw $fp, 8($sp)	# save fp
	  sw $ra, 4($sp)	# save ra
	  addiu $fp, $sp, 8	# set up new fp
	  subu $sp, $sp, 248	# decrement sp to make space for locals/temps
	# _tmp487 = "How many players do we have today? "
	  .data			# create string constant marked with label
	  _string49: .asciiz "How many players do we have today? "
	  .text
	  la $t2, _string49	# load label
	  sw $t2, -16($fp)	# spill _tmp487 from $t2 to $fp-16
	# PushParam _tmp487
	  subu $sp, $sp, 4	# decrement sp to make space for param
	  lw $t0, -16($fp)	# fill _tmp487 to $t0 from $fp-16
	  sw $t0, 4($sp)	# copy param value to stack
	# LCall _PrintString
	  jal _PrintString   	# jump to function
	# PopParams 4
	  add $sp, $sp, 4	# pop params off stack
	# _tmp488 = LCall _ReadInteger
	  jal _ReadInteger   	# jump to function
	  move $t2, $v0		# copy function return value from $v0
	  sw $t2, -20($fp)	# spill _tmp488 from $t2 to $fp-20
	# numPlayers = _tmp488
	  lw $t2, -20($fp)	# fill _tmp488 to $t2 from $fp-20
	  sw $t2, -12($fp)	# spill numPlayers from $t2 to $fp-12
	# _tmp489 = 4
	  li $t2, 4		# load constant value 4 into $t2
	  sw $t2, -24($fp)	# spill _tmp489 from $t2 to $fp-24
	# _tmp490 = 0
	  li $t2, 0		# load constant value 0 into $t2
	  sw $t2, -28($fp)	# spill _tmp490 from $t2 to $fp-28
	# _tmp491 = numPlayers < _tmp490
	  lw $t0, -12($fp)	# fill numPlayers to $t0 from $fp-12
	  lw $t1, -28($fp)	# fill _tmp490 to $t1 from $fp-28
	  slt $t2, $t0, $t1	
	  sw $t2, -32($fp)	# spill _tmp491 from $t2 to $fp-32
	# _tmp492 = numPlayers == _tmp490
	  lw $t0, -12($fp)	# fill numPlayers to $t0 from $fp-12
	  lw $t1, -28($fp)	# fill _tmp490 to $t1 from $fp-28
	  seq $t2, $t0, $t1	
	  sw $t2, -36($fp)	# spill _tmp492 from $t2 to $fp-36
	# _tmp493 = _tmp491 || _tmp492
	  lw $t0, -32($fp)	# fill _tmp491 to $t0 from $fp-32
	  lw $t1, -36($fp)	# fill _tmp492 to $t1 from $fp-36
	  or $t2, $t0, $t1	
	  sw $t2, -40($fp)	# spill _tmp493 from $t2 to $fp-40
	# IfZ _tmp493 Goto _L72
	  lw $t0, -40($fp)	# fill _tmp493 to $t0 from $fp-40
	  beqz $t0, _L72	# branch if _tmp493 is zero 
	# _tmp494 = "Decaf runtime error: Array size is <= 0\n"
	  .data			# create string constant marked with label
	  _string50: .asciiz "Decaf runtime error: Array size is <= 0\n"
	  .text
	  la $t2, _string50	# load label
	  sw $t2, -44($fp)	# spill _tmp494 from $t2 to $fp-44
	# PushParam _tmp494
	  subu $sp, $sp, 4	# decrement sp to make space for param
	  lw $t0, -44($fp)	# fill _tmp494 to $t0 from $fp-44
	  sw $t0, 4($sp)	# copy param value to stack
	# LCall _PrintString
	  jal _PrintString   	# jump to function
	# PopParams 4
	  add $sp, $sp, 4	# pop params off stack
	# LCall _Halt
	  jal _Halt          	# jump to function
  _L72:
	# _tmp495 = numPlayers * _tmp489
	  lw $t0, -12($fp)	# fill numPlayers to $t0 from $fp-12
	  lw $t1, -24($fp)	# fill _tmp489 to $t1 from $fp-24
	  mul $t2, $t0, $t1	
	  sw $t2, -48($fp)	# spill _tmp495 from $t2 to $fp-48
	# _tmp496 = _tmp489 + _tmp495
	  lw $t0, -24($fp)	# fill _tmp489 to $t0 from $fp-24
	  lw $t1, -48($fp)	# fill _tmp495 to $t1 from $fp-48
	  add $t2, $t0, $t1	
	  sw $t2, -52($fp)	# spill _tmp496 from $t2 to $fp-52
	# PushParam _tmp496
	  subu $sp, $sp, 4	# decrement sp to make space for param
	  lw $t0, -52($fp)	# fill _tmp496 to $t0 from $fp-52
	  sw $t0, 4($sp)	# copy param value to stack
	# _tmp497 = LCall _Alloc
	  jal _Alloc         	# jump to function
	  move $t2, $v0		# copy function return value from $v0
	  sw $t2, -56($fp)	# spill _tmp497 from $t2 to $fp-56
	# PopParams 4
	  add $sp, $sp, 4	# pop params off stack
	# *(_tmp497) = numPlayers
	  lw $t0, -12($fp)	# fill numPlayers to $t0 from $fp-12
	  lw $t2, -56($fp)	# fill _tmp497 to $t2 from $fp-56
	  sw $t0, 0($t2) 	# store with offset
	# *(this + 4) = _tmp497
	  lw $t0, -56($fp)	# fill _tmp497 to $t0 from $fp-56
	  lw $t2, 4($fp)	# fill this to $t2 from $fp+4
	  sw $t0, 4($t2) 	# store with offset
	# _tmp498 = 0
	  li $t2, 0		# load constant value 0 into $t2
	  sw $t2, -60($fp)	# spill _tmp498 from $t2 to $fp-60
	# i = _tmp498
	  lw $t2, -60($fp)	# fill _tmp498 to $t2 from $fp-60
	  sw $t2, -8($fp)	# spill i from $t2 to $fp-8
  _L73:
	# _tmp499 = *(this + 4)
	  lw $t0, 4($fp)	# fill this to $t0 from $fp+4
	  lw $t2, 4($t0) 	# load with offset
	  sw $t2, -64($fp)	# spill _tmp499 from $t2 to $fp-64
	# _tmp500 = *(_tmp499)
	  lw $t0, -64($fp)	# fill _tmp499 to $t0 from $fp-64
	  lw $t2, 0($t0) 	# load with offset
	  sw $t2, -68($fp)	# spill _tmp500 from $t2 to $fp-68
	# _tmp501 = i < _tmp500
	  lw $t0, -8($fp)	# fill i to $t0 from $fp-8
	  lw $t1, -68($fp)	# fill _tmp500 to $t1 from $fp-68
	  slt $t2, $t0, $t1	
	  sw $t2, -72($fp)	# spill _tmp501 from $t2 to $fp-72
	# IfZ _tmp501 Goto _L74
	  lw $t0, -72($fp)	# fill _tmp501 to $t0 from $fp-72
	  beqz $t0, _L74	# branch if _tmp501 is zero 
	# _tmp502 = 24
	  li $t2, 24		# load constant value 24 into $t2
	  sw $t2, -76($fp)	# spill _tmp502 from $t2 to $fp-76
	# _tmp503 = 4
	  li $t2, 4		# load constant value 4 into $t2
	  sw $t2, -80($fp)	# spill _tmp503 from $t2 to $fp-80
	# _tmp504 = _tmp503 + _tmp502
	  lw $t0, -80($fp)	# fill _tmp503 to $t0 from $fp-80
	  lw $t1, -76($fp)	# fill _tmp502 to $t1 from $fp-76
	  add $t2, $t0, $t1	
	  sw $t2, -84($fp)	# spill _tmp504 from $t2 to $fp-84
	# PushParam _tmp504
	  subu $sp, $sp, 4	# decrement sp to make space for param
	  lw $t0, -84($fp)	# fill _tmp504 to $t0 from $fp-84
	  sw $t0, 4($sp)	# copy param value to stack
	# _tmp505 = LCall _Alloc
	  jal _Alloc         	# jump to function
	  move $t2, $v0		# copy function return value from $v0
	  sw $t2, -88($fp)	# spill _tmp505 from $t2 to $fp-88
	# PopParams 4
	  add $sp, $sp, 4	# pop params off stack
	# _tmp506 = Player
	  la $t2, Player	# load label
	  sw $t2, -92($fp)	# spill _tmp506 from $t2 to $fp-92
	# *(_tmp505) = _tmp506
	  lw $t0, -92($fp)	# fill _tmp506 to $t0 from $fp-92
	  lw $t2, -88($fp)	# fill _tmp505 to $t2 from $fp-88
	  sw $t0, 0($t2) 	# store with offset
	# _tmp507 = *(this + 4)
	  lw $t0, 4($fp)	# fill this to $t0 from $fp+4
	  lw $t2, 4($t0) 	# load with offset
	  sw $t2, -96($fp)	# spill _tmp507 from $t2 to $fp-96
	# _tmp508 = 0
	  li $t2, 0		# load constant value 0 into $t2
	  sw $t2, -100($fp)	# spill _tmp508 from $t2 to $fp-100
	# _tmp509 = *(_tmp507)
	  lw $t0, -96($fp)	# fill _tmp507 to $t0 from $fp-96
	  lw $t2, 0($t0) 	# load with offset
	  sw $t2, -104($fp)	# spill _tmp509 from $t2 to $fp-104
	# _tmp510 = i < _tmp508
	  lw $t0, -8($fp)	# fill i to $t0 from $fp-8
	  lw $t1, -100($fp)	# fill _tmp508 to $t1 from $fp-100
	  slt $t2, $t0, $t1	
	  sw $t2, -108($fp)	# spill _tmp510 from $t2 to $fp-108
	# _tmp511 = _tmp509 < i
	  lw $t0, -104($fp)	# fill _tmp509 to $t0 from $fp-104
	  lw $t1, -8($fp)	# fill i to $t1 from $fp-8
	  slt $t2, $t0, $t1	
	  sw $t2, -112($fp)	# spill _tmp511 from $t2 to $fp-112
	# _tmp512 = _tmp509 == i
	  lw $t0, -104($fp)	# fill _tmp509 to $t0 from $fp-104
	  lw $t1, -8($fp)	# fill i to $t1 from $fp-8
	  seq $t2, $t0, $t1	
	  sw $t2, -116($fp)	# spill _tmp512 from $t2 to $fp-116
	# _tmp513 = _tmp511 || _tmp512
	  lw $t0, -112($fp)	# fill _tmp511 to $t0 from $fp-112
	  lw $t1, -116($fp)	# fill _tmp512 to $t1 from $fp-116
	  or $t2, $t0, $t1	
	  sw $t2, -120($fp)	# spill _tmp513 from $t2 to $fp-120
	# _tmp514 = _tmp513 || _tmp510
	  lw $t0, -120($fp)	# fill _tmp513 to $t0 from $fp-120
	  lw $t1, -108($fp)	# fill _tmp510 to $t1 from $fp-108
	  or $t2, $t0, $t1	
	  sw $t2, -124($fp)	# spill _tmp514 from $t2 to $fp-124
	# IfZ _tmp514 Goto _L75
	  lw $t0, -124($fp)	# fill _tmp514 to $t0 from $fp-124
	  beqz $t0, _L75	# branch if _tmp514 is zero 
	# _tmp515 = "Decaf runtime error: Array subscript out of bound..."
	  .data			# create string constant marked with label
	  _string51: .asciiz "Decaf runtime error: Array subscript out of bounds\n"
	  .text
	  la $t2, _string51	# load label
	  sw $t2, -128($fp)	# spill _tmp515 from $t2 to $fp-128
	# PushParam _tmp515
	  subu $sp, $sp, 4	# decrement sp to make space for param
	  lw $t0, -128($fp)	# fill _tmp515 to $t0 from $fp-128
	  sw $t0, 4($sp)	# copy param value to stack
	# LCall _PrintString
	  jal _PrintString   	# jump to function
	# PopParams 4
	  add $sp, $sp, 4	# pop params off stack
	# LCall _Halt
	  jal _Halt          	# jump to function
  _L75:
	# _tmp516 = 4
	  li $t2, 4		# load constant value 4 into $t2
	  sw $t2, -132($fp)	# spill _tmp516 from $t2 to $fp-132
	# _tmp517 = i * _tmp516
	  lw $t0, -8($fp)	# fill i to $t0 from $fp-8
	  lw $t1, -132($fp)	# fill _tmp516 to $t1 from $fp-132
	  mul $t2, $t0, $t1	
	  sw $t2, -136($fp)	# spill _tmp517 from $t2 to $fp-136
	# _tmp518 = _tmp517 + _tmp516
	  lw $t0, -136($fp)	# fill _tmp517 to $t0 from $fp-136
	  lw $t1, -132($fp)	# fill _tmp516 to $t1 from $fp-132
	  add $t2, $t0, $t1	
	  sw $t2, -140($fp)	# spill _tmp518 from $t2 to $fp-140
	# _tmp519 = _tmp507 + _tmp518
	  lw $t0, -96($fp)	# fill _tmp507 to $t0 from $fp-96
	  lw $t1, -140($fp)	# fill _tmp518 to $t1 from $fp-140
	  add $t2, $t0, $t1	
	  sw $t2, -144($fp)	# spill _tmp519 from $t2 to $fp-144
	# *(_tmp519) = _tmp505
	  lw $t0, -88($fp)	# fill _tmp505 to $t0 from $fp-88
	  lw $t2, -144($fp)	# fill _tmp519 to $t2 from $fp-144
	  sw $t0, 0($t2) 	# store with offset
	# _tmp520 = *(_tmp519)
	  lw $t0, -144($fp)	# fill _tmp519 to $t0 from $fp-144
	  lw $t2, 0($t0) 	# load with offset
	  sw $t2, -148($fp)	# spill _tmp520 from $t2 to $fp-148
	# _tmp521 = 1
	  li $t2, 1		# load constant value 1 into $t2
	  sw $t2, -152($fp)	# spill _tmp521 from $t2 to $fp-152
	# _tmp522 = i + _tmp521
	  lw $t0, -8($fp)	# fill i to $t0 from $fp-8
	  lw $t1, -152($fp)	# fill _tmp521 to $t1 from $fp-152
	  add $t2, $t0, $t1	
	  sw $t2, -156($fp)	# spill _tmp522 from $t2 to $fp-156
	# PushParam _tmp522
	  subu $sp, $sp, 4	# decrement sp to make space for param
	  lw $t0, -156($fp)	# fill _tmp522 to $t0 from $fp-156
	  sw $t0, 4($sp)	# copy param value to stack
	# _tmp523 = *(this + 4)
	  lw $t0, 4($fp)	# fill this to $t0 from $fp+4
	  lw $t2, 4($t0) 	# load with offset
	  sw $t2, -160($fp)	# spill _tmp523 from $t2 to $fp-160
	# _tmp524 = 0
	  li $t2, 0		# load constant value 0 into $t2
	  sw $t2, -164($fp)	# spill _tmp524 from $t2 to $fp-164
	# _tmp525 = *(_tmp523)
	  lw $t0, -160($fp)	# fill _tmp523 to $t0 from $fp-160
	  lw $t2, 0($t0) 	# load with offset
	  sw $t2, -168($fp)	# spill _tmp525 from $t2 to $fp-168
	# _tmp526 = i < _tmp524
	  lw $t0, -8($fp)	# fill i to $t0 from $fp-8
	  lw $t1, -164($fp)	# fill _tmp524 to $t1 from $fp-164
	  slt $t2, $t0, $t1	
	  sw $t2, -172($fp)	# spill _tmp526 from $t2 to $fp-172
	# _tmp527 = _tmp525 < i
	  lw $t0, -168($fp)	# fill _tmp525 to $t0 from $fp-168
	  lw $t1, -8($fp)	# fill i to $t1 from $fp-8
	  slt $t2, $t0, $t1	
	  sw $t2, -176($fp)	# spill _tmp527 from $t2 to $fp-176
	# _tmp528 = _tmp525 == i
	  lw $t0, -168($fp)	# fill _tmp525 to $t0 from $fp-168
	  lw $t1, -8($fp)	# fill i to $t1 from $fp-8
	  seq $t2, $t0, $t1	
	  sw $t2, -180($fp)	# spill _tmp528 from $t2 to $fp-180
	# _tmp529 = _tmp527 || _tmp528
	  lw $t0, -176($fp)	# fill _tmp527 to $t0 from $fp-176
	  lw $t1, -180($fp)	# fill _tmp528 to $t1 from $fp-180
	  or $t2, $t0, $t1	
	  sw $t2, -184($fp)	# spill _tmp529 from $t2 to $fp-184
	# _tmp530 = _tmp529 || _tmp526
	  lw $t0, -184($fp)	# fill _tmp529 to $t0 from $fp-184
	  lw $t1, -172($fp)	# fill _tmp526 to $t1 from $fp-172
	  or $t2, $t0, $t1	
	  sw $t2, -188($fp)	# spill _tmp530 from $t2 to $fp-188
	# IfZ _tmp530 Goto _L76
	  lw $t0, -188($fp)	# fill _tmp530 to $t0 from $fp-188
	  beqz $t0, _L76	# branch if _tmp530 is zero 
	# _tmp531 = "Decaf runtime error: Array subscript out of bound..."
	  .data			# create string constant marked with label
	  _string52: .asciiz "Decaf runtime error: Array subscript out of bounds\n"
	  .text
	  la $t2, _string52	# load label
	  sw $t2, -192($fp)	# spill _tmp531 from $t2 to $fp-192
	# PushParam _tmp531
	  subu $sp, $sp, 4	# decrement sp to make space for param
	  lw $t0, -192($fp)	# fill _tmp531 to $t0 from $fp-192
	  sw $t0, 4($sp)	# copy param value to stack
	# LCall _PrintString
	  jal _PrintString   	# jump to function
	# PopParams 4
	  add $sp, $sp, 4	# pop params off stack
	# LCall _Halt
	  jal _Halt          	# jump to function
  _L76:
	# _tmp532 = 4
	  li $t2, 4		# load constant value 4 into $t2
	  sw $t2, -196($fp)	# spill _tmp532 from $t2 to $fp-196
	# _tmp533 = i * _tmp532
	  lw $t0, -8($fp)	# fill i to $t0 from $fp-8
	  lw $t1, -196($fp)	# fill _tmp532 to $t1 from $fp-196
	  mul $t2, $t0, $t1	
	  sw $t2, -200($fp)	# spill _tmp533 from $t2 to $fp-200
	# _tmp534 = _tmp533 + _tmp532
	  lw $t0, -200($fp)	# fill _tmp533 to $t0 from $fp-200
	  lw $t1, -196($fp)	# fill _tmp532 to $t1 from $fp-196
	  add $t2, $t0, $t1	
	  sw $t2, -204($fp)	# spill _tmp534 from $t2 to $fp-204
	# _tmp535 = _tmp523 + _tmp534
	  lw $t0, -160($fp)	# fill _tmp523 to $t0 from $fp-160
	  lw $t1, -204($fp)	# fill _tmp534 to $t1 from $fp-204
	  add $t2, $t0, $t1	
	  sw $t2, -208($fp)	# spill _tmp535 from $t2 to $fp-208
	# _tmp536 = *(_tmp535)
	  lw $t0, -208($fp)	# fill _tmp535 to $t0 from $fp-208
	  lw $t2, 0($t0) 	# load with offset
	  sw $t2, -212($fp)	# spill _tmp536 from $t2 to $fp-212
	# PushParam _tmp536
	  subu $sp, $sp, 4	# decrement sp to make space for param
	  lw $t0, -212($fp)	# fill _tmp536 to $t0 from $fp-212
	  sw $t0, 4($sp)	# copy param value to stack
	# _tmp537 = *(_tmp536)
	  lw $t0, -212($fp)	# fill _tmp536 to $t0 from $fp-212
	  lw $t2, 0($t0) 	# load with offset
	  sw $t2, -216($fp)	# spill _tmp537 from $t2 to $fp-216
	# _tmp538 = *(_tmp537)
	  lw $t0, -216($fp)	# fill _tmp537 to $t0 from $fp-216
	  lw $t2, 0($t0) 	# load with offset
	  sw $t2, -220($fp)	# spill _tmp538 from $t2 to $fp-220
	# ACall _tmp538
	  lw $t0, -220($fp)	# fill _tmp538 to $t0 from $fp-220
	  jalr $t0            	# jump to function
	# PopParams 8
	  add $sp, $sp, 8	# pop params off stack
	# _tmp539 = 1
	  li $t2, 1		# load constant value 1 into $t2
	  sw $t2, -224($fp)	# spill _tmp539 from $t2 to $fp-224
	# _tmp540 = i + _tmp539
	  lw $t0, -8($fp)	# fill i to $t0 from $fp-8
	  lw $t1, -224($fp)	# fill _tmp539 to $t1 from $fp-224
	  add $t2, $t0, $t1	
	  sw $t2, -228($fp)	# spill _tmp540 from $t2 to $fp-228
	# i = _tmp540
	  lw $t2, -228($fp)	# fill _tmp540 to $t2 from $fp-228
	  sw $t2, -8($fp)	# spill i from $t2 to $fp-8
	# Goto _L73
	  b _L73		# unconditional branch
  _L74:
	# EndFunc
	# (below handles reaching end of fn body with no explicit return)
	  move $sp, $fp		# pop callee frame off stack
	  lw $ra, -4($fp)	# restore saved ra
	  lw $fp, 0($fp)	# restore saved fp
	  jr $ra		# return from function
  House.____TakeAllBets:
	# BeginFunc 180
	  subu $sp, $sp, 8	# decrement sp to make space to save ra, fp
	  sw $fp, 8($sp)	# save fp
	  sw $ra, 4($sp)	# save ra
	  addiu $fp, $sp, 8	# set up new fp
	  subu $sp, $sp, 180	# decrement sp to make space for locals/temps
	# _tmp541 = "\nFirst, let's take bets.\n"
	  .data			# create string constant marked with label
	  _string53: .asciiz "\nFirst, let's take bets.\n"
	  .text
	  la $t2, _string53	# load label
	  sw $t2, -12($fp)	# spill _tmp541 from $t2 to $fp-12
	# PushParam _tmp541
	  subu $sp, $sp, 4	# decrement sp to make space for param
	  lw $t0, -12($fp)	# fill _tmp541 to $t0 from $fp-12
	  sw $t0, 4($sp)	# copy param value to stack
	# LCall _PrintString
	  jal _PrintString   	# jump to function
	# PopParams 4
	  add $sp, $sp, 4	# pop params off stack
	# _tmp542 = 0
	  li $t2, 0		# load constant value 0 into $t2
	  sw $t2, -16($fp)	# spill _tmp542 from $t2 to $fp-16
	# i = _tmp542
	  lw $t2, -16($fp)	# fill _tmp542 to $t2 from $fp-16
	  sw $t2, -8($fp)	# spill i from $t2 to $fp-8
  _L77:
	# _tmp543 = *(this + 4)
	  lw $t0, 4($fp)	# fill this to $t0 from $fp+4
	  lw $t2, 4($t0) 	# load with offset
	  sw $t2, -20($fp)	# spill _tmp543 from $t2 to $fp-20
	# _tmp544 = *(_tmp543)
	  lw $t0, -20($fp)	# fill _tmp543 to $t0 from $fp-20
	  lw $t2, 0($t0) 	# load with offset
	  sw $t2, -24($fp)	# spill _tmp544 from $t2 to $fp-24
	# _tmp545 = i < _tmp544
	  lw $t0, -8($fp)	# fill i to $t0 from $fp-8
	  lw $t1, -24($fp)	# fill _tmp544 to $t1 from $fp-24
	  slt $t2, $t0, $t1	
	  sw $t2, -28($fp)	# spill _tmp545 from $t2 to $fp-28
	# IfZ _tmp545 Goto _L78
	  lw $t0, -28($fp)	# fill _tmp545 to $t0 from $fp-28
	  beqz $t0, _L78	# branch if _tmp545 is zero 
	# _tmp546 = *(this + 4)
	  lw $t0, 4($fp)	# fill this to $t0 from $fp+4
	  lw $t2, 4($t0) 	# load with offset
	  sw $t2, -32($fp)	# spill _tmp546 from $t2 to $fp-32
	# _tmp547 = 0
	  li $t2, 0		# load constant value 0 into $t2
	  sw $t2, -36($fp)	# spill _tmp547 from $t2 to $fp-36
	# _tmp548 = *(_tmp546)
	  lw $t0, -32($fp)	# fill _tmp546 to $t0 from $fp-32
	  lw $t2, 0($t0) 	# load with offset
	  sw $t2, -40($fp)	# spill _tmp548 from $t2 to $fp-40
	# _tmp549 = i < _tmp547
	  lw $t0, -8($fp)	# fill i to $t0 from $fp-8
	  lw $t1, -36($fp)	# fill _tmp547 to $t1 from $fp-36
	  slt $t2, $t0, $t1	
	  sw $t2, -44($fp)	# spill _tmp549 from $t2 to $fp-44
	# _tmp550 = _tmp548 < i
	  lw $t0, -40($fp)	# fill _tmp548 to $t0 from $fp-40
	  lw $t1, -8($fp)	# fill i to $t1 from $fp-8
	  slt $t2, $t0, $t1	
	  sw $t2, -48($fp)	# spill _tmp550 from $t2 to $fp-48
	# _tmp551 = _tmp548 == i
	  lw $t0, -40($fp)	# fill _tmp548 to $t0 from $fp-40
	  lw $t1, -8($fp)	# fill i to $t1 from $fp-8
	  seq $t2, $t0, $t1	
	  sw $t2, -52($fp)	# spill _tmp551 from $t2 to $fp-52
	# _tmp552 = _tmp550 || _tmp551
	  lw $t0, -48($fp)	# fill _tmp550 to $t0 from $fp-48
	  lw $t1, -52($fp)	# fill _tmp551 to $t1 from $fp-52
	  or $t2, $t0, $t1	
	  sw $t2, -56($fp)	# spill _tmp552 from $t2 to $fp-56
	# _tmp553 = _tmp552 || _tmp549
	  lw $t0, -56($fp)	# fill _tmp552 to $t0 from $fp-56
	  lw $t1, -44($fp)	# fill _tmp549 to $t1 from $fp-44
	  or $t2, $t0, $t1	
	  sw $t2, -60($fp)	# spill _tmp553 from $t2 to $fp-60
	# IfZ _tmp553 Goto _L81
	  lw $t0, -60($fp)	# fill _tmp553 to $t0 from $fp-60
	  beqz $t0, _L81	# branch if _tmp553 is zero 
	# _tmp554 = "Decaf runtime error: Array subscript out of bound..."
	  .data			# create string constant marked with label
	  _string54: .asciiz "Decaf runtime error: Array subscript out of bounds\n"
	  .text
	  la $t2, _string54	# load label
	  sw $t2, -64($fp)	# spill _tmp554 from $t2 to $fp-64
	# PushParam _tmp554
	  subu $sp, $sp, 4	# decrement sp to make space for param
	  lw $t0, -64($fp)	# fill _tmp554 to $t0 from $fp-64
	  sw $t0, 4($sp)	# copy param value to stack
	# LCall _PrintString
	  jal _PrintString   	# jump to function
	# PopParams 4
	  add $sp, $sp, 4	# pop params off stack
	# LCall _Halt
	  jal _Halt          	# jump to function
  _L81:
	# _tmp555 = 4
	  li $t2, 4		# load constant value 4 into $t2
	  sw $t2, -68($fp)	# spill _tmp555 from $t2 to $fp-68
	# _tmp556 = i * _tmp555
	  lw $t0, -8($fp)	# fill i to $t0 from $fp-8
	  lw $t1, -68($fp)	# fill _tmp555 to $t1 from $fp-68
	  mul $t2, $t0, $t1	
	  sw $t2, -72($fp)	# spill _tmp556 from $t2 to $fp-72
	# _tmp557 = _tmp556 + _tmp555
	  lw $t0, -72($fp)	# fill _tmp556 to $t0 from $fp-72
	  lw $t1, -68($fp)	# fill _tmp555 to $t1 from $fp-68
	  add $t2, $t0, $t1	
	  sw $t2, -76($fp)	# spill _tmp557 from $t2 to $fp-76
	# _tmp558 = _tmp546 + _tmp557
	  lw $t0, -32($fp)	# fill _tmp546 to $t0 from $fp-32
	  lw $t1, -76($fp)	# fill _tmp557 to $t1 from $fp-76
	  add $t2, $t0, $t1	
	  sw $t2, -80($fp)	# spill _tmp558 from $t2 to $fp-80
	# _tmp559 = *(_tmp558)
	  lw $t0, -80($fp)	# fill _tmp558 to $t0 from $fp-80
	  lw $t2, 0($t0) 	# load with offset
	  sw $t2, -84($fp)	# spill _tmp559 from $t2 to $fp-84
	# PushParam _tmp559
	  subu $sp, $sp, 4	# decrement sp to make space for param
	  lw $t0, -84($fp)	# fill _tmp559 to $t0 from $fp-84
	  sw $t0, 4($sp)	# copy param value to stack
	# _tmp560 = *(_tmp559)
	  lw $t0, -84($fp)	# fill _tmp559 to $t0 from $fp-84
	  lw $t2, 0($t0) 	# load with offset
	  sw $t2, -88($fp)	# spill _tmp560 from $t2 to $fp-88
	# _tmp561 = *(_tmp560 + 16)
	  lw $t0, -88($fp)	# fill _tmp560 to $t0 from $fp-88
	  lw $t2, 16($t0) 	# load with offset
	  sw $t2, -92($fp)	# spill _tmp561 from $t2 to $fp-92
	# _tmp562 = ACall _tmp561
	  lw $t0, -92($fp)	# fill _tmp561 to $t0 from $fp-92
	  jalr $t0            	# jump to function
	  move $t2, $v0		# copy function return value from $v0
	  sw $t2, -96($fp)	# spill _tmp562 from $t2 to $fp-96
	# PopParams 4
	  add $sp, $sp, 4	# pop params off stack
	# IfZ _tmp562 Goto _L79
	  lw $t0, -96($fp)	# fill _tmp562 to $t0 from $fp-96
	  beqz $t0, _L79	# branch if _tmp562 is zero 
	# _tmp563 = *(this + 4)
	  lw $t0, 4($fp)	# fill this to $t0 from $fp+4
	  lw $t2, 4($t0) 	# load with offset
	  sw $t2, -100($fp)	# spill _tmp563 from $t2 to $fp-100
	# _tmp564 = 0
	  li $t2, 0		# load constant value 0 into $t2
	  sw $t2, -104($fp)	# spill _tmp564 from $t2 to $fp-104
	# _tmp565 = *(_tmp563)
	  lw $t0, -100($fp)	# fill _tmp563 to $t0 from $fp-100
	  lw $t2, 0($t0) 	# load with offset
	  sw $t2, -108($fp)	# spill _tmp565 from $t2 to $fp-108
	# _tmp566 = i < _tmp564
	  lw $t0, -8($fp)	# fill i to $t0 from $fp-8
	  lw $t1, -104($fp)	# fill _tmp564 to $t1 from $fp-104
	  slt $t2, $t0, $t1	
	  sw $t2, -112($fp)	# spill _tmp566 from $t2 to $fp-112
	# _tmp567 = _tmp565 < i
	  lw $t0, -108($fp)	# fill _tmp565 to $t0 from $fp-108
	  lw $t1, -8($fp)	# fill i to $t1 from $fp-8
	  slt $t2, $t0, $t1	
	  sw $t2, -116($fp)	# spill _tmp567 from $t2 to $fp-116
	# _tmp568 = _tmp565 == i
	  lw $t0, -108($fp)	# fill _tmp565 to $t0 from $fp-108
	  lw $t1, -8($fp)	# fill i to $t1 from $fp-8
	  seq $t2, $t0, $t1	
	  sw $t2, -120($fp)	# spill _tmp568 from $t2 to $fp-120
	# _tmp569 = _tmp567 || _tmp568
	  lw $t0, -116($fp)	# fill _tmp567 to $t0 from $fp-116
	  lw $t1, -120($fp)	# fill _tmp568 to $t1 from $fp-120
	  or $t2, $t0, $t1	
	  sw $t2, -124($fp)	# spill _tmp569 from $t2 to $fp-124
	# _tmp570 = _tmp569 || _tmp566
	  lw $t0, -124($fp)	# fill _tmp569 to $t0 from $fp-124
	  lw $t1, -112($fp)	# fill _tmp566 to $t1 from $fp-112
	  or $t2, $t0, $t1	
	  sw $t2, -128($fp)	# spill _tmp570 from $t2 to $fp-128
	# IfZ _tmp570 Goto _L82
	  lw $t0, -128($fp)	# fill _tmp570 to $t0 from $fp-128
	  beqz $t0, _L82	# branch if _tmp570 is zero 
	# _tmp571 = "Decaf runtime error: Array subscript out of bound..."
	  .data			# create string constant marked with label
	  _string55: .asciiz "Decaf runtime error: Array subscript out of bounds\n"
	  .text
	  la $t2, _string55	# load label
	  sw $t2, -132($fp)	# spill _tmp571 from $t2 to $fp-132
	# PushParam _tmp571
	  subu $sp, $sp, 4	# decrement sp to make space for param
	  lw $t0, -132($fp)	# fill _tmp571 to $t0 from $fp-132
	  sw $t0, 4($sp)	# copy param value to stack
	# LCall _PrintString
	  jal _PrintString   	# jump to function
	# PopParams 4
	  add $sp, $sp, 4	# pop params off stack
	# LCall _Halt
	  jal _Halt          	# jump to function
  _L82:
	# _tmp572 = 4
	  li $t2, 4		# load constant value 4 into $t2
	  sw $t2, -136($fp)	# spill _tmp572 from $t2 to $fp-136
	# _tmp573 = i * _tmp572
	  lw $t0, -8($fp)	# fill i to $t0 from $fp-8
	  lw $t1, -136($fp)	# fill _tmp572 to $t1 from $fp-136
	  mul $t2, $t0, $t1	
	  sw $t2, -140($fp)	# spill _tmp573 from $t2 to $fp-140
	# _tmp574 = _tmp573 + _tmp572
	  lw $t0, -140($fp)	# fill _tmp573 to $t0 from $fp-140
	  lw $t1, -136($fp)	# fill _tmp572 to $t1 from $fp-136
	  add $t2, $t0, $t1	
	  sw $t2, -144($fp)	# spill _tmp574 from $t2 to $fp-144
	# _tmp575 = _tmp563 + _tmp574
	  lw $t0, -100($fp)	# fill _tmp563 to $t0 from $fp-100
	  lw $t1, -144($fp)	# fill _tmp574 to $t1 from $fp-144
	  add $t2, $t0, $t1	
	  sw $t2, -148($fp)	# spill _tmp575 from $t2 to $fp-148
	# _tmp576 = *(_tmp575)
	  lw $t0, -148($fp)	# fill _tmp575 to $t0 from $fp-148
	  lw $t2, 0($t0) 	# load with offset
	  sw $t2, -152($fp)	# spill _tmp576 from $t2 to $fp-152
	# PushParam _tmp576
	  subu $sp, $sp, 4	# decrement sp to make space for param
	  lw $t0, -152($fp)	# fill _tmp576 to $t0 from $fp-152
	  sw $t0, 4($sp)	# copy param value to stack
	# _tmp577 = *(_tmp576)
	  lw $t0, -152($fp)	# fill _tmp576 to $t0 from $fp-152
	  lw $t2, 0($t0) 	# load with offset
	  sw $t2, -156($fp)	# spill _tmp577 from $t2 to $fp-156
	# _tmp578 = *(_tmp577 + 24)
	  lw $t0, -156($fp)	# fill _tmp577 to $t0 from $fp-156
	  lw $t2, 24($t0) 	# load with offset
	  sw $t2, -160($fp)	# spill _tmp578 from $t2 to $fp-160
	# ACall _tmp578
	  lw $t0, -160($fp)	# fill _tmp578 to $t0 from $fp-160
	  jalr $t0            	# jump to function
	# PopParams 4
	  add $sp, $sp, 4	# pop params off stack
	# Goto _L80
	  b _L80		# unconditional branch
  _L79:
  _L80:
	# _tmp579 = 1
	  li $t2, 1		# load constant value 1 into $t2
	  sw $t2, -164($fp)	# spill _tmp579 from $t2 to $fp-164
	# _tmp580 = i + _tmp579
	  lw $t0, -8($fp)	# fill i to $t0 from $fp-8
	  lw $t1, -164($fp)	# fill _tmp579 to $t1 from $fp-164
	  add $t2, $t0, $t1	
	  sw $t2, -168($fp)	# spill _tmp580 from $t2 to $fp-168
	# i = _tmp580
	  lw $t2, -168($fp)	# fill _tmp580 to $t2 from $fp-168
	  sw $t2, -8($fp)	# spill i from $t2 to $fp-8
	# Goto _L77
	  b _L77		# unconditional branch
  _L78:
	# EndFunc
	# (below handles reaching end of fn body with no explicit return)
	  move $sp, $fp		# pop callee frame off stack
	  lw $ra, -4($fp)	# restore saved ra
	  lw $fp, 0($fp)	# restore saved fp
	  jr $ra		# return from function
  House.____TakeAllTurns:
	# BeginFunc 180
	  subu $sp, $sp, 8	# decrement sp to make space to save ra, fp
	  sw $fp, 8($sp)	# save fp
	  sw $ra, 4($sp)	# save ra
	  addiu $fp, $sp, 8	# set up new fp
	  subu $sp, $sp, 180	# decrement sp to make space for locals/temps
	# _tmp581 = 0
	  li $t2, 0		# load constant value 0 into $t2
	  sw $t2, -12($fp)	# spill _tmp581 from $t2 to $fp-12
	# i = _tmp581
	  lw $t2, -12($fp)	# fill _tmp581 to $t2 from $fp-12
	  sw $t2, -8($fp)	# spill i from $t2 to $fp-8
  _L83:
	# _tmp582 = *(this + 4)
	  lw $t0, 4($fp)	# fill this to $t0 from $fp+4
	  lw $t2, 4($t0) 	# load with offset
	  sw $t2, -16($fp)	# spill _tmp582 from $t2 to $fp-16
	# _tmp583 = *(_tmp582)
	  lw $t0, -16($fp)	# fill _tmp582 to $t0 from $fp-16
	  lw $t2, 0($t0) 	# load with offset
	  sw $t2, -20($fp)	# spill _tmp583 from $t2 to $fp-20
	# _tmp584 = i < _tmp583
	  lw $t0, -8($fp)	# fill i to $t0 from $fp-8
	  lw $t1, -20($fp)	# fill _tmp583 to $t1 from $fp-20
	  slt $t2, $t0, $t1	
	  sw $t2, -24($fp)	# spill _tmp584 from $t2 to $fp-24
	# IfZ _tmp584 Goto _L84
	  lw $t0, -24($fp)	# fill _tmp584 to $t0 from $fp-24
	  beqz $t0, _L84	# branch if _tmp584 is zero 
	# _tmp585 = *(this + 4)
	  lw $t0, 4($fp)	# fill this to $t0 from $fp+4
	  lw $t2, 4($t0) 	# load with offset
	  sw $t2, -28($fp)	# spill _tmp585 from $t2 to $fp-28
	# _tmp586 = 0
	  li $t2, 0		# load constant value 0 into $t2
	  sw $t2, -32($fp)	# spill _tmp586 from $t2 to $fp-32
	# _tmp587 = *(_tmp585)
	  lw $t0, -28($fp)	# fill _tmp585 to $t0 from $fp-28
	  lw $t2, 0($t0) 	# load with offset
	  sw $t2, -36($fp)	# spill _tmp587 from $t2 to $fp-36
	# _tmp588 = i < _tmp586
	  lw $t0, -8($fp)	# fill i to $t0 from $fp-8
	  lw $t1, -32($fp)	# fill _tmp586 to $t1 from $fp-32
	  slt $t2, $t0, $t1	
	  sw $t2, -40($fp)	# spill _tmp588 from $t2 to $fp-40
	# _tmp589 = _tmp587 < i
	  lw $t0, -36($fp)	# fill _tmp587 to $t0 from $fp-36
	  lw $t1, -8($fp)	# fill i to $t1 from $fp-8
	  slt $t2, $t0, $t1	
	  sw $t2, -44($fp)	# spill _tmp589 from $t2 to $fp-44
	# _tmp590 = _tmp587 == i
	  lw $t0, -36($fp)	# fill _tmp587 to $t0 from $fp-36
	  lw $t1, -8($fp)	# fill i to $t1 from $fp-8
	  seq $t2, $t0, $t1	
	  sw $t2, -48($fp)	# spill _tmp590 from $t2 to $fp-48
	# _tmp591 = _tmp589 || _tmp590
	  lw $t0, -44($fp)	# fill _tmp589 to $t0 from $fp-44
	  lw $t1, -48($fp)	# fill _tmp590 to $t1 from $fp-48
	  or $t2, $t0, $t1	
	  sw $t2, -52($fp)	# spill _tmp591 from $t2 to $fp-52
	# _tmp592 = _tmp591 || _tmp588
	  lw $t0, -52($fp)	# fill _tmp591 to $t0 from $fp-52
	  lw $t1, -40($fp)	# fill _tmp588 to $t1 from $fp-40
	  or $t2, $t0, $t1	
	  sw $t2, -56($fp)	# spill _tmp592 from $t2 to $fp-56
	# IfZ _tmp592 Goto _L87
	  lw $t0, -56($fp)	# fill _tmp592 to $t0 from $fp-56
	  beqz $t0, _L87	# branch if _tmp592 is zero 
	# _tmp593 = "Decaf runtime error: Array subscript out of bound..."
	  .data			# create string constant marked with label
	  _string56: .asciiz "Decaf runtime error: Array subscript out of bounds\n"
	  .text
	  la $t2, _string56	# load label
	  sw $t2, -60($fp)	# spill _tmp593 from $t2 to $fp-60
	# PushParam _tmp593
	  subu $sp, $sp, 4	# decrement sp to make space for param
	  lw $t0, -60($fp)	# fill _tmp593 to $t0 from $fp-60
	  sw $t0, 4($sp)	# copy param value to stack
	# LCall _PrintString
	  jal _PrintString   	# jump to function
	# PopParams 4
	  add $sp, $sp, 4	# pop params off stack
	# LCall _Halt
	  jal _Halt          	# jump to function
  _L87:
	# _tmp594 = 4
	  li $t2, 4		# load constant value 4 into $t2
	  sw $t2, -64($fp)	# spill _tmp594 from $t2 to $fp-64
	# _tmp595 = i * _tmp594
	  lw $t0, -8($fp)	# fill i to $t0 from $fp-8
	  lw $t1, -64($fp)	# fill _tmp594 to $t1 from $fp-64
	  mul $t2, $t0, $t1	
	  sw $t2, -68($fp)	# spill _tmp595 from $t2 to $fp-68
	# _tmp596 = _tmp595 + _tmp594
	  lw $t0, -68($fp)	# fill _tmp595 to $t0 from $fp-68
	  lw $t1, -64($fp)	# fill _tmp594 to $t1 from $fp-64
	  add $t2, $t0, $t1	
	  sw $t2, -72($fp)	# spill _tmp596 from $t2 to $fp-72
	# _tmp597 = _tmp585 + _tmp596
	  lw $t0, -28($fp)	# fill _tmp585 to $t0 from $fp-28
	  lw $t1, -72($fp)	# fill _tmp596 to $t1 from $fp-72
	  add $t2, $t0, $t1	
	  sw $t2, -76($fp)	# spill _tmp597 from $t2 to $fp-76
	# _tmp598 = *(_tmp597)
	  lw $t0, -76($fp)	# fill _tmp597 to $t0 from $fp-76
	  lw $t2, 0($t0) 	# load with offset
	  sw $t2, -80($fp)	# spill _tmp598 from $t2 to $fp-80
	# PushParam _tmp598
	  subu $sp, $sp, 4	# decrement sp to make space for param
	  lw $t0, -80($fp)	# fill _tmp598 to $t0 from $fp-80
	  sw $t0, 4($sp)	# copy param value to stack
	# _tmp599 = *(_tmp598)
	  lw $t0, -80($fp)	# fill _tmp598 to $t0 from $fp-80
	  lw $t2, 0($t0) 	# load with offset
	  sw $t2, -84($fp)	# spill _tmp599 from $t2 to $fp-84
	# _tmp600 = *(_tmp599 + 16)
	  lw $t0, -84($fp)	# fill _tmp599 to $t0 from $fp-84
	  lw $t2, 16($t0) 	# load with offset
	  sw $t2, -88($fp)	# spill _tmp600 from $t2 to $fp-88
	# _tmp601 = ACall _tmp600
	  lw $t0, -88($fp)	# fill _tmp600 to $t0 from $fp-88
	  jalr $t0            	# jump to function
	  move $t2, $v0		# copy function return value from $v0
	  sw $t2, -92($fp)	# spill _tmp601 from $t2 to $fp-92
	# PopParams 4
	  add $sp, $sp, 4	# pop params off stack
	# IfZ _tmp601 Goto _L85
	  lw $t0, -92($fp)	# fill _tmp601 to $t0 from $fp-92
	  beqz $t0, _L85	# branch if _tmp601 is zero 
	# _tmp602 = *(this + 12)
	  lw $t0, 4($fp)	# fill this to $t0 from $fp+4
	  lw $t2, 12($t0) 	# load with offset
	  sw $t2, -96($fp)	# spill _tmp602 from $t2 to $fp-96
	# PushParam _tmp602
	  subu $sp, $sp, 4	# decrement sp to make space for param
	  lw $t0, -96($fp)	# fill _tmp602 to $t0 from $fp-96
	  sw $t0, 4($sp)	# copy param value to stack
	# _tmp603 = *(this + 4)
	  lw $t0, 4($fp)	# fill this to $t0 from $fp+4
	  lw $t2, 4($t0) 	# load with offset
	  sw $t2, -100($fp)	# spill _tmp603 from $t2 to $fp-100
	# _tmp604 = 0
	  li $t2, 0		# load constant value 0 into $t2
	  sw $t2, -104($fp)	# spill _tmp604 from $t2 to $fp-104
	# _tmp605 = *(_tmp603)
	  lw $t0, -100($fp)	# fill _tmp603 to $t0 from $fp-100
	  lw $t2, 0($t0) 	# load with offset
	  sw $t2, -108($fp)	# spill _tmp605 from $t2 to $fp-108
	# _tmp606 = i < _tmp604
	  lw $t0, -8($fp)	# fill i to $t0 from $fp-8
	  lw $t1, -104($fp)	# fill _tmp604 to $t1 from $fp-104
	  slt $t2, $t0, $t1	
	  sw $t2, -112($fp)	# spill _tmp606 from $t2 to $fp-112
	# _tmp607 = _tmp605 < i
	  lw $t0, -108($fp)	# fill _tmp605 to $t0 from $fp-108
	  lw $t1, -8($fp)	# fill i to $t1 from $fp-8
	  slt $t2, $t0, $t1	
	  sw $t2, -116($fp)	# spill _tmp607 from $t2 to $fp-116
	# _tmp608 = _tmp605 == i
	  lw $t0, -108($fp)	# fill _tmp605 to $t0 from $fp-108
	  lw $t1, -8($fp)	# fill i to $t1 from $fp-8
	  seq $t2, $t0, $t1	
	  sw $t2, -120($fp)	# spill _tmp608 from $t2 to $fp-120
	# _tmp609 = _tmp607 || _tmp608
	  lw $t0, -116($fp)	# fill _tmp607 to $t0 from $fp-116
	  lw $t1, -120($fp)	# fill _tmp608 to $t1 from $fp-120
	  or $t2, $t0, $t1	
	  sw $t2, -124($fp)	# spill _tmp609 from $t2 to $fp-124
	# _tmp610 = _tmp609 || _tmp606
	  lw $t0, -124($fp)	# fill _tmp609 to $t0 from $fp-124
	  lw $t1, -112($fp)	# fill _tmp606 to $t1 from $fp-112
	  or $t2, $t0, $t1	
	  sw $t2, -128($fp)	# spill _tmp610 from $t2 to $fp-128
	# IfZ _tmp610 Goto _L88
	  lw $t0, -128($fp)	# fill _tmp610 to $t0 from $fp-128
	  beqz $t0, _L88	# branch if _tmp610 is zero 
	# _tmp611 = "Decaf runtime error: Array subscript out of bound..."
	  .data			# create string constant marked with label
	  _string57: .asciiz "Decaf runtime error: Array subscript out of bounds\n"
	  .text
	  la $t2, _string57	# load label
	  sw $t2, -132($fp)	# spill _tmp611 from $t2 to $fp-132
	# PushParam _tmp611
	  subu $sp, $sp, 4	# decrement sp to make space for param
	  lw $t0, -132($fp)	# fill _tmp611 to $t0 from $fp-132
	  sw $t0, 4($sp)	# copy param value to stack
	# LCall _PrintString
	  jal _PrintString   	# jump to function
	# PopParams 4
	  add $sp, $sp, 4	# pop params off stack
	# LCall _Halt
	  jal _Halt          	# jump to function
  _L88:
	# _tmp612 = 4
	  li $t2, 4		# load constant value 4 into $t2
	  sw $t2, -136($fp)	# spill _tmp612 from $t2 to $fp-136
	# _tmp613 = i * _tmp612
	  lw $t0, -8($fp)	# fill i to $t0 from $fp-8
	  lw $t1, -136($fp)	# fill _tmp612 to $t1 from $fp-136
	  mul $t2, $t0, $t1	
	  sw $t2, -140($fp)	# spill _tmp613 from $t2 to $fp-140
	# _tmp614 = _tmp613 + _tmp612
	  lw $t0, -140($fp)	# fill _tmp613 to $t0 from $fp-140
	  lw $t1, -136($fp)	# fill _tmp612 to $t1 from $fp-136
	  add $t2, $t0, $t1	
	  sw $t2, -144($fp)	# spill _tmp614 from $t2 to $fp-144
	# _tmp615 = _tmp603 + _tmp614
	  lw $t0, -100($fp)	# fill _tmp603 to $t0 from $fp-100
	  lw $t1, -144($fp)	# fill _tmp614 to $t1 from $fp-144
	  add $t2, $t0, $t1	
	  sw $t2, -148($fp)	# spill _tmp615 from $t2 to $fp-148
	# _tmp616 = *(_tmp615)
	  lw $t0, -148($fp)	# fill _tmp615 to $t0 from $fp-148
	  lw $t2, 0($t0) 	# load with offset
	  sw $t2, -152($fp)	# spill _tmp616 from $t2 to $fp-152
	# PushParam _tmp616
	  subu $sp, $sp, 4	# decrement sp to make space for param
	  lw $t0, -152($fp)	# fill _tmp616 to $t0 from $fp-152
	  sw $t0, 4($sp)	# copy param value to stack
	# _tmp617 = *(_tmp616)
	  lw $t0, -152($fp)	# fill _tmp616 to $t0 from $fp-152
	  lw $t2, 0($t0) 	# load with offset
	  sw $t2, -156($fp)	# spill _tmp617 from $t2 to $fp-156
	# _tmp618 = *(_tmp617 + 12)
	  lw $t0, -156($fp)	# fill _tmp617 to $t0 from $fp-156
	  lw $t2, 12($t0) 	# load with offset
	  sw $t2, -160($fp)	# spill _tmp618 from $t2 to $fp-160
	# ACall _tmp618
	  lw $t0, -160($fp)	# fill _tmp618 to $t0 from $fp-160
	  jalr $t0            	# jump to function
	# PopParams 8
	  add $sp, $sp, 8	# pop params off stack
	# Goto _L86
	  b _L86		# unconditional branch
  _L85:
  _L86:
	# _tmp619 = 1
	  li $t2, 1		# load constant value 1 into $t2
	  sw $t2, -164($fp)	# spill _tmp619 from $t2 to $fp-164
	# _tmp620 = i + _tmp619
	  lw $t0, -8($fp)	# fill i to $t0 from $fp-8
	  lw $t1, -164($fp)	# fill _tmp619 to $t1 from $fp-164
	  add $t2, $t0, $t1	
	  sw $t2, -168($fp)	# spill _tmp620 from $t2 to $fp-168
	# i = _tmp620
	  lw $t2, -168($fp)	# fill _tmp620 to $t2 from $fp-168
	  sw $t2, -8($fp)	# spill i from $t2 to $fp-8
	# Goto _L83
	  b _L83		# unconditional branch
  _L84:
	# EndFunc
	# (below handles reaching end of fn body with no explicit return)
	  move $sp, $fp		# pop callee frame off stack
	  lw $ra, -4($fp)	# restore saved ra
	  lw $fp, 0($fp)	# restore saved fp
	  jr $ra		# return from function
  House.____ResolveAllPlayers:
	# BeginFunc 196
	  subu $sp, $sp, 8	# decrement sp to make space to save ra, fp
	  sw $fp, 8($sp)	# save fp
	  sw $ra, 4($sp)	# save ra
	  addiu $fp, $sp, 8	# set up new fp
	  subu $sp, $sp, 196	# decrement sp to make space for locals/temps
	# _tmp621 = "\nTime to resolve bets.\n"
	  .data			# create string constant marked with label
	  _string58: .asciiz "\nTime to resolve bets.\n"
	  .text
	  la $t2, _string58	# load label
	  sw $t2, -12($fp)	# spill _tmp621 from $t2 to $fp-12
	# PushParam _tmp621
	  subu $sp, $sp, 4	# decrement sp to make space for param
	  lw $t0, -12($fp)	# fill _tmp621 to $t0 from $fp-12
	  sw $t0, 4($sp)	# copy param value to stack
	# LCall _PrintString
	  jal _PrintString   	# jump to function
	# PopParams 4
	  add $sp, $sp, 4	# pop params off stack
	# _tmp622 = 0
	  li $t2, 0		# load constant value 0 into $t2
	  sw $t2, -16($fp)	# spill _tmp622 from $t2 to $fp-16
	# i = _tmp622
	  lw $t2, -16($fp)	# fill _tmp622 to $t2 from $fp-16
	  sw $t2, -8($fp)	# spill i from $t2 to $fp-8
  _L89:
	# _tmp623 = *(this + 4)
	  lw $t0, 4($fp)	# fill this to $t0 from $fp+4
	  lw $t2, 4($t0) 	# load with offset
	  sw $t2, -20($fp)	# spill _tmp623 from $t2 to $fp-20
	# _tmp624 = *(_tmp623)
	  lw $t0, -20($fp)	# fill _tmp623 to $t0 from $fp-20
	  lw $t2, 0($t0) 	# load with offset
	  sw $t2, -24($fp)	# spill _tmp624 from $t2 to $fp-24
	# _tmp625 = i < _tmp624
	  lw $t0, -8($fp)	# fill i to $t0 from $fp-8
	  lw $t1, -24($fp)	# fill _tmp624 to $t1 from $fp-24
	  slt $t2, $t0, $t1	
	  sw $t2, -28($fp)	# spill _tmp625 from $t2 to $fp-28
	# IfZ _tmp625 Goto _L90
	  lw $t0, -28($fp)	# fill _tmp625 to $t0 from $fp-28
	  beqz $t0, _L90	# branch if _tmp625 is zero 
	# _tmp626 = *(this + 4)
	  lw $t0, 4($fp)	# fill this to $t0 from $fp+4
	  lw $t2, 4($t0) 	# load with offset
	  sw $t2, -32($fp)	# spill _tmp626 from $t2 to $fp-32
	# _tmp627 = 0
	  li $t2, 0		# load constant value 0 into $t2
	  sw $t2, -36($fp)	# spill _tmp627 from $t2 to $fp-36
	# _tmp628 = *(_tmp626)
	  lw $t0, -32($fp)	# fill _tmp626 to $t0 from $fp-32
	  lw $t2, 0($t0) 	# load with offset
	  sw $t2, -40($fp)	# spill _tmp628 from $t2 to $fp-40
	# _tmp629 = i < _tmp627
	  lw $t0, -8($fp)	# fill i to $t0 from $fp-8
	  lw $t1, -36($fp)	# fill _tmp627 to $t1 from $fp-36
	  slt $t2, $t0, $t1	
	  sw $t2, -44($fp)	# spill _tmp629 from $t2 to $fp-44
	# _tmp630 = _tmp628 < i
	  lw $t0, -40($fp)	# fill _tmp628 to $t0 from $fp-40
	  lw $t1, -8($fp)	# fill i to $t1 from $fp-8
	  slt $t2, $t0, $t1	
	  sw $t2, -48($fp)	# spill _tmp630 from $t2 to $fp-48
	# _tmp631 = _tmp628 == i
	  lw $t0, -40($fp)	# fill _tmp628 to $t0 from $fp-40
	  lw $t1, -8($fp)	# fill i to $t1 from $fp-8
	  seq $t2, $t0, $t1	
	  sw $t2, -52($fp)	# spill _tmp631 from $t2 to $fp-52
	# _tmp632 = _tmp630 || _tmp631
	  lw $t0, -48($fp)	# fill _tmp630 to $t0 from $fp-48
	  lw $t1, -52($fp)	# fill _tmp631 to $t1 from $fp-52
	  or $t2, $t0, $t1	
	  sw $t2, -56($fp)	# spill _tmp632 from $t2 to $fp-56
	# _tmp633 = _tmp632 || _tmp629
	  lw $t0, -56($fp)	# fill _tmp632 to $t0 from $fp-56
	  lw $t1, -44($fp)	# fill _tmp629 to $t1 from $fp-44
	  or $t2, $t0, $t1	
	  sw $t2, -60($fp)	# spill _tmp633 from $t2 to $fp-60
	# IfZ _tmp633 Goto _L93
	  lw $t0, -60($fp)	# fill _tmp633 to $t0 from $fp-60
	  beqz $t0, _L93	# branch if _tmp633 is zero 
	# _tmp634 = "Decaf runtime error: Array subscript out of bound..."
	  .data			# create string constant marked with label
	  _string59: .asciiz "Decaf runtime error: Array subscript out of bounds\n"
	  .text
	  la $t2, _string59	# load label
	  sw $t2, -64($fp)	# spill _tmp634 from $t2 to $fp-64
	# PushParam _tmp634
	  subu $sp, $sp, 4	# decrement sp to make space for param
	  lw $t0, -64($fp)	# fill _tmp634 to $t0 from $fp-64
	  sw $t0, 4($sp)	# copy param value to stack
	# LCall _PrintString
	  jal _PrintString   	# jump to function
	# PopParams 4
	  add $sp, $sp, 4	# pop params off stack
	# LCall _Halt
	  jal _Halt          	# jump to function
  _L93:
	# _tmp635 = 4
	  li $t2, 4		# load constant value 4 into $t2
	  sw $t2, -68($fp)	# spill _tmp635 from $t2 to $fp-68
	# _tmp636 = i * _tmp635
	  lw $t0, -8($fp)	# fill i to $t0 from $fp-8
	  lw $t1, -68($fp)	# fill _tmp635 to $t1 from $fp-68
	  mul $t2, $t0, $t1	
	  sw $t2, -72($fp)	# spill _tmp636 from $t2 to $fp-72
	# _tmp637 = _tmp636 + _tmp635
	  lw $t0, -72($fp)	# fill _tmp636 to $t0 from $fp-72
	  lw $t1, -68($fp)	# fill _tmp635 to $t1 from $fp-68
	  add $t2, $t0, $t1	
	  sw $t2, -76($fp)	# spill _tmp637 from $t2 to $fp-76
	# _tmp638 = _tmp626 + _tmp637
	  lw $t0, -32($fp)	# fill _tmp626 to $t0 from $fp-32
	  lw $t1, -76($fp)	# fill _tmp637 to $t1 from $fp-76
	  add $t2, $t0, $t1	
	  sw $t2, -80($fp)	# spill _tmp638 from $t2 to $fp-80
	# _tmp639 = *(_tmp638)
	  lw $t0, -80($fp)	# fill _tmp638 to $t0 from $fp-80
	  lw $t2, 0($t0) 	# load with offset
	  sw $t2, -84($fp)	# spill _tmp639 from $t2 to $fp-84
	# PushParam _tmp639
	  subu $sp, $sp, 4	# decrement sp to make space for param
	  lw $t0, -84($fp)	# fill _tmp639 to $t0 from $fp-84
	  sw $t0, 4($sp)	# copy param value to stack
	# _tmp640 = *(_tmp639)
	  lw $t0, -84($fp)	# fill _tmp639 to $t0 from $fp-84
	  lw $t2, 0($t0) 	# load with offset
	  sw $t2, -88($fp)	# spill _tmp640 from $t2 to $fp-88
	# _tmp641 = *(_tmp640 + 16)
	  lw $t0, -88($fp)	# fill _tmp640 to $t0 from $fp-88
	  lw $t2, 16($t0) 	# load with offset
	  sw $t2, -92($fp)	# spill _tmp641 from $t2 to $fp-92
	# _tmp642 = ACall _tmp641
	  lw $t0, -92($fp)	# fill _tmp641 to $t0 from $fp-92
	  jalr $t0            	# jump to function
	  move $t2, $v0		# copy function return value from $v0
	  sw $t2, -96($fp)	# spill _tmp642 from $t2 to $fp-96
	# PopParams 4
	  add $sp, $sp, 4	# pop params off stack
	# IfZ _tmp642 Goto _L91
	  lw $t0, -96($fp)	# fill _tmp642 to $t0 from $fp-96
	  beqz $t0, _L91	# branch if _tmp642 is zero 
	# _tmp643 = *(this + 8)
	  lw $t0, 4($fp)	# fill this to $t0 from $fp+4
	  lw $t2, 8($t0) 	# load with offset
	  sw $t2, -100($fp)	# spill _tmp643 from $t2 to $fp-100
	# PushParam _tmp643
	  subu $sp, $sp, 4	# decrement sp to make space for param
	  lw $t0, -100($fp)	# fill _tmp643 to $t0 from $fp-100
	  sw $t0, 4($sp)	# copy param value to stack
	# _tmp644 = *(_tmp643)
	  lw $t0, -100($fp)	# fill _tmp643 to $t0 from $fp-100
	  lw $t2, 0($t0) 	# load with offset
	  sw $t2, -104($fp)	# spill _tmp644 from $t2 to $fp-104
	# _tmp645 = *(_tmp644 + 28)
	  lw $t0, -104($fp)	# fill _tmp644 to $t0 from $fp-104
	  lw $t2, 28($t0) 	# load with offset
	  sw $t2, -108($fp)	# spill _tmp645 from $t2 to $fp-108
	# _tmp646 = ACall _tmp645
	  lw $t0, -108($fp)	# fill _tmp645 to $t0 from $fp-108
	  jalr $t0            	# jump to function
	  move $t2, $v0		# copy function return value from $v0
	  sw $t2, -112($fp)	# spill _tmp646 from $t2 to $fp-112
	# PopParams 4
	  add $sp, $sp, 4	# pop params off stack
	# PushParam _tmp646
	  subu $sp, $sp, 4	# decrement sp to make space for param
	  lw $t0, -112($fp)	# fill _tmp646 to $t0 from $fp-112
	  sw $t0, 4($sp)	# copy param value to stack
	# _tmp647 = *(this + 4)
	  lw $t0, 4($fp)	# fill this to $t0 from $fp+4
	  lw $t2, 4($t0) 	# load with offset
	  sw $t2, -116($fp)	# spill _tmp647 from $t2 to $fp-116
	# _tmp648 = 0
	  li $t2, 0		# load constant value 0 into $t2
	  sw $t2, -120($fp)	# spill _tmp648 from $t2 to $fp-120
	# _tmp649 = *(_tmp647)
	  lw $t0, -116($fp)	# fill _tmp647 to $t0 from $fp-116
	  lw $t2, 0($t0) 	# load with offset
	  sw $t2, -124($fp)	# spill _tmp649 from $t2 to $fp-124
	# _tmp650 = i < _tmp648
	  lw $t0, -8($fp)	# fill i to $t0 from $fp-8
	  lw $t1, -120($fp)	# fill _tmp648 to $t1 from $fp-120
	  slt $t2, $t0, $t1	
	  sw $t2, -128($fp)	# spill _tmp650 from $t2 to $fp-128
	# _tmp651 = _tmp649 < i
	  lw $t0, -124($fp)	# fill _tmp649 to $t0 from $fp-124
	  lw $t1, -8($fp)	# fill i to $t1 from $fp-8
	  slt $t2, $t0, $t1	
	  sw $t2, -132($fp)	# spill _tmp651 from $t2 to $fp-132
	# _tmp652 = _tmp649 == i
	  lw $t0, -124($fp)	# fill _tmp649 to $t0 from $fp-124
	  lw $t1, -8($fp)	# fill i to $t1 from $fp-8
	  seq $t2, $t0, $t1	
	  sw $t2, -136($fp)	# spill _tmp652 from $t2 to $fp-136
	# _tmp653 = _tmp651 || _tmp652
	  lw $t0, -132($fp)	# fill _tmp651 to $t0 from $fp-132
	  lw $t1, -136($fp)	# fill _tmp652 to $t1 from $fp-136
	  or $t2, $t0, $t1	
	  sw $t2, -140($fp)	# spill _tmp653 from $t2 to $fp-140
	# _tmp654 = _tmp653 || _tmp650
	  lw $t0, -140($fp)	# fill _tmp653 to $t0 from $fp-140
	  lw $t1, -128($fp)	# fill _tmp650 to $t1 from $fp-128
	  or $t2, $t0, $t1	
	  sw $t2, -144($fp)	# spill _tmp654 from $t2 to $fp-144
	# IfZ _tmp654 Goto _L94
	  lw $t0, -144($fp)	# fill _tmp654 to $t0 from $fp-144
	  beqz $t0, _L94	# branch if _tmp654 is zero 
	# _tmp655 = "Decaf runtime error: Array subscript out of bound..."
	  .data			# create string constant marked with label
	  _string60: .asciiz "Decaf runtime error: Array subscript out of bounds\n"
	  .text
	  la $t2, _string60	# load label
	  sw $t2, -148($fp)	# spill _tmp655 from $t2 to $fp-148
	# PushParam _tmp655
	  subu $sp, $sp, 4	# decrement sp to make space for param
	  lw $t0, -148($fp)	# fill _tmp655 to $t0 from $fp-148
	  sw $t0, 4($sp)	# copy param value to stack
	# LCall _PrintString
	  jal _PrintString   	# jump to function
	# PopParams 4
	  add $sp, $sp, 4	# pop params off stack
	# LCall _Halt
	  jal _Halt          	# jump to function
  _L94:
	# _tmp656 = 4
	  li $t2, 4		# load constant value 4 into $t2
	  sw $t2, -152($fp)	# spill _tmp656 from $t2 to $fp-152
	# _tmp657 = i * _tmp656
	  lw $t0, -8($fp)	# fill i to $t0 from $fp-8
	  lw $t1, -152($fp)	# fill _tmp656 to $t1 from $fp-152
	  mul $t2, $t0, $t1	
	  sw $t2, -156($fp)	# spill _tmp657 from $t2 to $fp-156
	# _tmp658 = _tmp657 + _tmp656
	  lw $t0, -156($fp)	# fill _tmp657 to $t0 from $fp-156
	  lw $t1, -152($fp)	# fill _tmp656 to $t1 from $fp-152
	  add $t2, $t0, $t1	
	  sw $t2, -160($fp)	# spill _tmp658 from $t2 to $fp-160
	# _tmp659 = _tmp647 + _tmp658
	  lw $t0, -116($fp)	# fill _tmp647 to $t0 from $fp-116
	  lw $t1, -160($fp)	# fill _tmp658 to $t1 from $fp-160
	  add $t2, $t0, $t1	
	  sw $t2, -164($fp)	# spill _tmp659 from $t2 to $fp-164
	# _tmp660 = *(_tmp659)
	  lw $t0, -164($fp)	# fill _tmp659 to $t0 from $fp-164
	  lw $t2, 0($t0) 	# load with offset
	  sw $t2, -168($fp)	# spill _tmp660 from $t2 to $fp-168
	# PushParam _tmp660
	  subu $sp, $sp, 4	# decrement sp to make space for param
	  lw $t0, -168($fp)	# fill _tmp660 to $t0 from $fp-168
	  sw $t0, 4($sp)	# copy param value to stack
	# _tmp661 = *(_tmp660)
	  lw $t0, -168($fp)	# fill _tmp660 to $t0 from $fp-168
	  lw $t2, 0($t0) 	# load with offset
	  sw $t2, -172($fp)	# spill _tmp661 from $t2 to $fp-172
	# _tmp662 = *(_tmp661 + 32)
	  lw $t0, -172($fp)	# fill _tmp661 to $t0 from $fp-172
	  lw $t2, 32($t0) 	# load with offset
	  sw $t2, -176($fp)	# spill _tmp662 from $t2 to $fp-176
	# ACall _tmp662
	  lw $t0, -176($fp)	# fill _tmp662 to $t0 from $fp-176
	  jalr $t0            	# jump to function
	# PopParams 8
	  add $sp, $sp, 8	# pop params off stack
	# Goto _L92
	  b _L92		# unconditional branch
  _L91:
  _L92:
	# _tmp663 = 1
	  li $t2, 1		# load constant value 1 into $t2
	  sw $t2, -180($fp)	# spill _tmp663 from $t2 to $fp-180
	# _tmp664 = i + _tmp663
	  lw $t0, -8($fp)	# fill i to $t0 from $fp-8
	  lw $t1, -180($fp)	# fill _tmp663 to $t1 from $fp-180
	  add $t2, $t0, $t1	
	  sw $t2, -184($fp)	# spill _tmp664 from $t2 to $fp-184
	# i = _tmp664
	  lw $t2, -184($fp)	# fill _tmp664 to $t2 from $fp-184
	  sw $t2, -8($fp)	# spill i from $t2 to $fp-8
	# Goto _L89
	  b _L89		# unconditional branch
  _L90:
	# EndFunc
	# (below handles reaching end of fn body with no explicit return)
	  move $sp, $fp		# pop callee frame off stack
	  lw $ra, -4($fp)	# restore saved ra
	  lw $fp, 0($fp)	# restore saved fp
	  jr $ra		# return from function
  House.____PrintAllMoney:
	# BeginFunc 104
	  subu $sp, $sp, 8	# decrement sp to make space to save ra, fp
	  sw $fp, 8($sp)	# save fp
	  sw $ra, 4($sp)	# save ra
	  addiu $fp, $sp, 8	# set up new fp
	  subu $sp, $sp, 104	# decrement sp to make space for locals/temps
	# _tmp665 = 0
	  li $t2, 0		# load constant value 0 into $t2
	  sw $t2, -12($fp)	# spill _tmp665 from $t2 to $fp-12
	# i = _tmp665
	  lw $t2, -12($fp)	# fill _tmp665 to $t2 from $fp-12
	  sw $t2, -8($fp)	# spill i from $t2 to $fp-8
  _L95:
	# _tmp666 = *(this + 4)
	  lw $t0, 4($fp)	# fill this to $t0 from $fp+4
	  lw $t2, 4($t0) 	# load with offset
	  sw $t2, -16($fp)	# spill _tmp666 from $t2 to $fp-16
	# _tmp667 = *(_tmp666)
	  lw $t0, -16($fp)	# fill _tmp666 to $t0 from $fp-16
	  lw $t2, 0($t0) 	# load with offset
	  sw $t2, -20($fp)	# spill _tmp667 from $t2 to $fp-20
	# _tmp668 = i < _tmp667
	  lw $t0, -8($fp)	# fill i to $t0 from $fp-8
	  lw $t1, -20($fp)	# fill _tmp667 to $t1 from $fp-20
	  slt $t2, $t0, $t1	
	  sw $t2, -24($fp)	# spill _tmp668 from $t2 to $fp-24
	# IfZ _tmp668 Goto _L96
	  lw $t0, -24($fp)	# fill _tmp668 to $t0 from $fp-24
	  beqz $t0, _L96	# branch if _tmp668 is zero 
	# _tmp669 = *(this + 4)
	  lw $t0, 4($fp)	# fill this to $t0 from $fp+4
	  lw $t2, 4($t0) 	# load with offset
	  sw $t2, -28($fp)	# spill _tmp669 from $t2 to $fp-28
	# _tmp670 = 0
	  li $t2, 0		# load constant value 0 into $t2
	  sw $t2, -32($fp)	# spill _tmp670 from $t2 to $fp-32
	# _tmp671 = *(_tmp669)
	  lw $t0, -28($fp)	# fill _tmp669 to $t0 from $fp-28
	  lw $t2, 0($t0) 	# load with offset
	  sw $t2, -36($fp)	# spill _tmp671 from $t2 to $fp-36
	# _tmp672 = i < _tmp670
	  lw $t0, -8($fp)	# fill i to $t0 from $fp-8
	  lw $t1, -32($fp)	# fill _tmp670 to $t1 from $fp-32
	  slt $t2, $t0, $t1	
	  sw $t2, -40($fp)	# spill _tmp672 from $t2 to $fp-40
	# _tmp673 = _tmp671 < i
	  lw $t0, -36($fp)	# fill _tmp671 to $t0 from $fp-36
	  lw $t1, -8($fp)	# fill i to $t1 from $fp-8
	  slt $t2, $t0, $t1	
	  sw $t2, -44($fp)	# spill _tmp673 from $t2 to $fp-44
	# _tmp674 = _tmp671 == i
	  lw $t0, -36($fp)	# fill _tmp671 to $t0 from $fp-36
	  lw $t1, -8($fp)	# fill i to $t1 from $fp-8
	  seq $t2, $t0, $t1	
	  sw $t2, -48($fp)	# spill _tmp674 from $t2 to $fp-48
	# _tmp675 = _tmp673 || _tmp674
	  lw $t0, -44($fp)	# fill _tmp673 to $t0 from $fp-44
	  lw $t1, -48($fp)	# fill _tmp674 to $t1 from $fp-48
	  or $t2, $t0, $t1	
	  sw $t2, -52($fp)	# spill _tmp675 from $t2 to $fp-52
	# _tmp676 = _tmp675 || _tmp672
	  lw $t0, -52($fp)	# fill _tmp675 to $t0 from $fp-52
	  lw $t1, -40($fp)	# fill _tmp672 to $t1 from $fp-40
	  or $t2, $t0, $t1	
	  sw $t2, -56($fp)	# spill _tmp676 from $t2 to $fp-56
	# IfZ _tmp676 Goto _L97
	  lw $t0, -56($fp)	# fill _tmp676 to $t0 from $fp-56
	  beqz $t0, _L97	# branch if _tmp676 is zero 
	# _tmp677 = "Decaf runtime error: Array subscript out of bound..."
	  .data			# create string constant marked with label
	  _string61: .asciiz "Decaf runtime error: Array subscript out of bounds\n"
	  .text
	  la $t2, _string61	# load label
	  sw $t2, -60($fp)	# spill _tmp677 from $t2 to $fp-60
	# PushParam _tmp677
	  subu $sp, $sp, 4	# decrement sp to make space for param
	  lw $t0, -60($fp)	# fill _tmp677 to $t0 from $fp-60
	  sw $t0, 4($sp)	# copy param value to stack
	# LCall _PrintString
	  jal _PrintString   	# jump to function
	# PopParams 4
	  add $sp, $sp, 4	# pop params off stack
	# LCall _Halt
	  jal _Halt          	# jump to function
  _L97:
	# _tmp678 = 4
	  li $t2, 4		# load constant value 4 into $t2
	  sw $t2, -64($fp)	# spill _tmp678 from $t2 to $fp-64
	# _tmp679 = i * _tmp678
	  lw $t0, -8($fp)	# fill i to $t0 from $fp-8
	  lw $t1, -64($fp)	# fill _tmp678 to $t1 from $fp-64
	  mul $t2, $t0, $t1	
	  sw $t2, -68($fp)	# spill _tmp679 from $t2 to $fp-68
	# _tmp680 = _tmp679 + _tmp678
	  lw $t0, -68($fp)	# fill _tmp679 to $t0 from $fp-68
	  lw $t1, -64($fp)	# fill _tmp678 to $t1 from $fp-64
	  add $t2, $t0, $t1	
	  sw $t2, -72($fp)	# spill _tmp680 from $t2 to $fp-72
	# _tmp681 = _tmp669 + _tmp680
	  lw $t0, -28($fp)	# fill _tmp669 to $t0 from $fp-28
	  lw $t1, -72($fp)	# fill _tmp680 to $t1 from $fp-72
	  add $t2, $t0, $t1	
	  sw $t2, -76($fp)	# spill _tmp681 from $t2 to $fp-76
	# _tmp682 = *(_tmp681)
	  lw $t0, -76($fp)	# fill _tmp681 to $t0 from $fp-76
	  lw $t2, 0($t0) 	# load with offset
	  sw $t2, -80($fp)	# spill _tmp682 from $t2 to $fp-80
	# PushParam _tmp682
	  subu $sp, $sp, 4	# decrement sp to make space for param
	  lw $t0, -80($fp)	# fill _tmp682 to $t0 from $fp-80
	  sw $t0, 4($sp)	# copy param value to stack
	# _tmp683 = *(_tmp682)
	  lw $t0, -80($fp)	# fill _tmp682 to $t0 from $fp-80
	  lw $t2, 0($t0) 	# load with offset
	  sw $t2, -84($fp)	# spill _tmp683 from $t2 to $fp-84
	# _tmp684 = *(_tmp683 + 20)
	  lw $t0, -84($fp)	# fill _tmp683 to $t0 from $fp-84
	  lw $t2, 20($t0) 	# load with offset
	  sw $t2, -88($fp)	# spill _tmp684 from $t2 to $fp-88
	# ACall _tmp684
	  lw $t0, -88($fp)	# fill _tmp684 to $t0 from $fp-88
	  jalr $t0            	# jump to function
	# PopParams 4
	  add $sp, $sp, 4	# pop params off stack
	# _tmp685 = 1
	  li $t2, 1		# load constant value 1 into $t2
	  sw $t2, -92($fp)	# spill _tmp685 from $t2 to $fp-92
	# _tmp686 = i + _tmp685
	  lw $t0, -8($fp)	# fill i to $t0 from $fp-8
	  lw $t1, -92($fp)	# fill _tmp685 to $t1 from $fp-92
	  add $t2, $t0, $t1	
	  sw $t2, -96($fp)	# spill _tmp686 from $t2 to $fp-96
	# i = _tmp686
	  lw $t2, -96($fp)	# fill _tmp686 to $t2 from $fp-96
	  sw $t2, -8($fp)	# spill i from $t2 to $fp-8
	# Goto _L95
	  b _L95		# unconditional branch
  _L96:
	# EndFunc
	# (below handles reaching end of fn body with no explicit return)
	  move $sp, $fp		# pop callee frame off stack
	  lw $ra, -4($fp)	# restore saved ra
	  lw $fp, 0($fp)	# restore saved fp
	  jr $ra		# return from function
  House.____PlayOneGame:
	# BeginFunc 112
	  subu $sp, $sp, 8	# decrement sp to make space to save ra, fp
	  sw $fp, 8($sp)	# save fp
	  sw $ra, 4($sp)	# save ra
	  addiu $fp, $sp, 8	# set up new fp
	  subu $sp, $sp, 112	# decrement sp to make space for locals/temps
	# _tmp687 = *(this + 12)
	  lw $t0, 4($fp)	# fill this to $t0 from $fp+4
	  lw $t2, 12($t0) 	# load with offset
	  sw $t2, -8($fp)	# spill _tmp687 from $t2 to $fp-8
	# PushParam _tmp687
	  subu $sp, $sp, 4	# decrement sp to make space for param
	  lw $t0, -8($fp)	# fill _tmp687 to $t0 from $fp-8
	  sw $t0, 4($sp)	# copy param value to stack
	# _tmp688 = *(_tmp687)
	  lw $t0, -8($fp)	# fill _tmp687 to $t0 from $fp-8
	  lw $t2, 0($t0) 	# load with offset
	  sw $t2, -12($fp)	# spill _tmp688 from $t2 to $fp-12
	# _tmp689 = *(_tmp688 + 12)
	  lw $t0, -12($fp)	# fill _tmp688 to $t0 from $fp-12
	  lw $t2, 12($t0) 	# load with offset
	  sw $t2, -16($fp)	# spill _tmp689 from $t2 to $fp-16
	# _tmp690 = ACall _tmp689
	  lw $t0, -16($fp)	# fill _tmp689 to $t0 from $fp-16
	  jalr $t0            	# jump to function
	  move $t2, $v0		# copy function return value from $v0
	  sw $t2, -20($fp)	# spill _tmp690 from $t2 to $fp-20
	# PopParams 4
	  add $sp, $sp, 4	# pop params off stack
	# _tmp691 = 26
	  li $t2, 26		# load constant value 26 into $t2
	  sw $t2, -24($fp)	# spill _tmp691 from $t2 to $fp-24
	# _tmp692 = _tmp690 < _tmp691
	  lw $t0, -20($fp)	# fill _tmp690 to $t0 from $fp-20
	  lw $t1, -24($fp)	# fill _tmp691 to $t1 from $fp-24
	  slt $t2, $t0, $t1	
	  sw $t2, -28($fp)	# spill _tmp692 from $t2 to $fp-28
	# IfZ _tmp692 Goto _L98
	  lw $t0, -28($fp)	# fill _tmp692 to $t0 from $fp-28
	  beqz $t0, _L98	# branch if _tmp692 is zero 
	# _tmp693 = *(this + 12)
	  lw $t0, 4($fp)	# fill this to $t0 from $fp+4
	  lw $t2, 12($t0) 	# load with offset
	  sw $t2, -32($fp)	# spill _tmp693 from $t2 to $fp-32
	# PushParam _tmp693
	  subu $sp, $sp, 4	# decrement sp to make space for param
	  lw $t0, -32($fp)	# fill _tmp693 to $t0 from $fp-32
	  sw $t0, 4($sp)	# copy param value to stack
	# _tmp694 = *(_tmp693)
	  lw $t0, -32($fp)	# fill _tmp693 to $t0 from $fp-32
	  lw $t2, 0($t0) 	# load with offset
	  sw $t2, -36($fp)	# spill _tmp694 from $t2 to $fp-36
	# _tmp695 = *(_tmp694 + 8)
	  lw $t0, -36($fp)	# fill _tmp694 to $t0 from $fp-36
	  lw $t2, 8($t0) 	# load with offset
	  sw $t2, -40($fp)	# spill _tmp695 from $t2 to $fp-40
	# ACall _tmp695
	  lw $t0, -40($fp)	# fill _tmp695 to $t0 from $fp-40
	  jalr $t0            	# jump to function
	# PopParams 4
	  add $sp, $sp, 4	# pop params off stack
	# Goto _L99
	  b _L99		# unconditional branch
  _L98:
  _L99:
	# PushParam this
	  subu $sp, $sp, 4	# decrement sp to make space for param
	  lw $t0, 4($fp)	# fill this to $t0 from $fp+4
	  sw $t0, 4($sp)	# copy param value to stack
	# _tmp696 = *(this)
	  lw $t0, 4($fp)	# fill this to $t0 from $fp+4
	  lw $t2, 0($t0) 	# load with offset
	  sw $t2, -44($fp)	# spill _tmp696 from $t2 to $fp-44
	# _tmp697 = *(_tmp696 + 8)
	  lw $t0, -44($fp)	# fill _tmp696 to $t0 from $fp-44
	  lw $t2, 8($t0) 	# load with offset
	  sw $t2, -48($fp)	# spill _tmp697 from $t2 to $fp-48
	# ACall _tmp697
	  lw $t0, -48($fp)	# fill _tmp697 to $t0 from $fp-48
	  jalr $t0            	# jump to function
	# PopParams 4
	  add $sp, $sp, 4	# pop params off stack
	# _tmp698 = "\nDealer starts. "
	  .data			# create string constant marked with label
	  _string62: .asciiz "\nDealer starts. "
	  .text
	  la $t2, _string62	# load label
	  sw $t2, -52($fp)	# spill _tmp698 from $t2 to $fp-52
	# PushParam _tmp698
	  subu $sp, $sp, 4	# decrement sp to make space for param
	  lw $t0, -52($fp)	# fill _tmp698 to $t0 from $fp-52
	  sw $t0, 4($sp)	# copy param value to stack
	# LCall _PrintString
	  jal _PrintString   	# jump to function
	# PopParams 4
	  add $sp, $sp, 4	# pop params off stack
	# _tmp699 = 0
	  li $t2, 0		# load constant value 0 into $t2
	  sw $t2, -56($fp)	# spill _tmp699 from $t2 to $fp-56
	# PushParam _tmp699
	  subu $sp, $sp, 4	# decrement sp to make space for param
	  lw $t0, -56($fp)	# fill _tmp699 to $t0 from $fp-56
	  sw $t0, 4($sp)	# copy param value to stack
	# _tmp700 = *(this + 8)
	  lw $t0, 4($fp)	# fill this to $t0 from $fp+4
	  lw $t2, 8($t0) 	# load with offset
	  sw $t2, -60($fp)	# spill _tmp700 from $t2 to $fp-60
	# PushParam _tmp700
	  subu $sp, $sp, 4	# decrement sp to make space for param
	  lw $t0, -60($fp)	# fill _tmp700 to $t0 from $fp-60
	  sw $t0, 4($sp)	# copy param value to stack
	# _tmp701 = *(_tmp700)
	  lw $t0, -60($fp)	# fill _tmp700 to $t0 from $fp-60
	  lw $t2, 0($t0) 	# load with offset
	  sw $t2, -64($fp)	# spill _tmp701 from $t2 to $fp-64
	# _tmp702 = *(_tmp701 + 36)
	  lw $t0, -64($fp)	# fill _tmp701 to $t0 from $fp-64
	  lw $t2, 36($t0) 	# load with offset
	  sw $t2, -68($fp)	# spill _tmp702 from $t2 to $fp-68
	# ACall _tmp702
	  lw $t0, -68($fp)	# fill _tmp702 to $t0 from $fp-68
	  jalr $t0            	# jump to function
	# PopParams 8
	  add $sp, $sp, 8	# pop params off stack
	# _tmp703 = *(this + 12)
	  lw $t0, 4($fp)	# fill this to $t0 from $fp+4
	  lw $t2, 12($t0) 	# load with offset
	  sw $t2, -72($fp)	# spill _tmp703 from $t2 to $fp-72
	# PushParam _tmp703
	  subu $sp, $sp, 4	# decrement sp to make space for param
	  lw $t0, -72($fp)	# fill _tmp703 to $t0 from $fp-72
	  sw $t0, 4($sp)	# copy param value to stack
	# _tmp704 = *(this + 8)
	  lw $t0, 4($fp)	# fill this to $t0 from $fp+4
	  lw $t2, 8($t0) 	# load with offset
	  sw $t2, -76($fp)	# spill _tmp704 from $t2 to $fp-76
	# PushParam _tmp704
	  subu $sp, $sp, 4	# decrement sp to make space for param
	  lw $t0, -76($fp)	# fill _tmp704 to $t0 from $fp-76
	  sw $t0, 4($sp)	# copy param value to stack
	# _tmp705 = *(_tmp704)
	  lw $t0, -76($fp)	# fill _tmp704 to $t0 from $fp-76
	  lw $t2, 0($t0) 	# load with offset
	  sw $t2, -80($fp)	# spill _tmp705 from $t2 to $fp-80
	# _tmp706 = *(_tmp705 + 4)
	  lw $t0, -80($fp)	# fill _tmp705 to $t0 from $fp-80
	  lw $t2, 4($t0) 	# load with offset
	  sw $t2, -84($fp)	# spill _tmp706 from $t2 to $fp-84
	# ACall _tmp706
	  lw $t0, -84($fp)	# fill _tmp706 to $t0 from $fp-84
	  jalr $t0            	# jump to function
	# PopParams 8
	  add $sp, $sp, 8	# pop params off stack
	# PushParam this
	  subu $sp, $sp, 4	# decrement sp to make space for param
	  lw $t0, 4($fp)	# fill this to $t0 from $fp+4
	  sw $t0, 4($sp)	# copy param value to stack
	# _tmp707 = *(this)
	  lw $t0, 4($fp)	# fill this to $t0 from $fp+4
	  lw $t2, 0($t0) 	# load with offset
	  sw $t2, -88($fp)	# spill _tmp707 from $t2 to $fp-88
	# _tmp708 = *(_tmp707 + 12)
	  lw $t0, -88($fp)	# fill _tmp707 to $t0 from $fp-88
	  lw $t2, 12($t0) 	# load with offset
	  sw $t2, -92($fp)	# spill _tmp708 from $t2 to $fp-92
	# ACall _tmp708
	  lw $t0, -92($fp)	# fill _tmp708 to $t0 from $fp-92
	  jalr $t0            	# jump to function
	# PopParams 4
	  add $sp, $sp, 4	# pop params off stack
	# _tmp709 = *(this + 12)
	  lw $t0, 4($fp)	# fill this to $t0 from $fp+4
	  lw $t2, 12($t0) 	# load with offset
	  sw $t2, -96($fp)	# spill _tmp709 from $t2 to $fp-96
	# PushParam _tmp709
	  subu $sp, $sp, 4	# decrement sp to make space for param
	  lw $t0, -96($fp)	# fill _tmp709 to $t0 from $fp-96
	  sw $t0, 4($sp)	# copy param value to stack
	# _tmp710 = *(this + 8)
	  lw $t0, 4($fp)	# fill this to $t0 from $fp+4
	  lw $t2, 8($t0) 	# load with offset
	  sw $t2, -100($fp)	# spill _tmp710 from $t2 to $fp-100
	# PushParam _tmp710
	  subu $sp, $sp, 4	# decrement sp to make space for param
	  lw $t0, -100($fp)	# fill _tmp710 to $t0 from $fp-100
	  sw $t0, 4($sp)	# copy param value to stack
	# _tmp711 = *(_tmp710)
	  lw $t0, -100($fp)	# fill _tmp710 to $t0 from $fp-100
	  lw $t2, 0($t0) 	# load with offset
	  sw $t2, -104($fp)	# spill _tmp711 from $t2 to $fp-104
	# _tmp712 = *(_tmp711 + 40)
	  lw $t0, -104($fp)	# fill _tmp711 to $t0 from $fp-104
	  lw $t2, 40($t0) 	# load with offset
	  sw $t2, -108($fp)	# spill _tmp712 from $t2 to $fp-108
	# ACall _tmp712
	  lw $t0, -108($fp)	# fill _tmp712 to $t0 from $fp-108
	  jalr $t0            	# jump to function
	# PopParams 8
	  add $sp, $sp, 8	# pop params off stack
	# PushParam this
	  subu $sp, $sp, 4	# decrement sp to make space for param
	  lw $t0, 4($fp)	# fill this to $t0 from $fp+4
	  sw $t0, 4($sp)	# copy param value to stack
	# _tmp713 = *(this)
	  lw $t0, 4($fp)	# fill this to $t0 from $fp+4
	  lw $t2, 0($t0) 	# load with offset
	  sw $t2, -112($fp)	# spill _tmp713 from $t2 to $fp-112
	# _tmp714 = *(_tmp713 + 16)
	  lw $t0, -112($fp)	# fill _tmp713 to $t0 from $fp-112
	  lw $t2, 16($t0) 	# load with offset
	  sw $t2, -116($fp)	# spill _tmp714 from $t2 to $fp-116
	# ACall _tmp714
	  lw $t0, -116($fp)	# fill _tmp714 to $t0 from $fp-116
	  jalr $t0            	# jump to function
	# PopParams 4
	  add $sp, $sp, 4	# pop params off stack
	# EndFunc
	# (below handles reaching end of fn body with no explicit return)
	  move $sp, $fp		# pop callee frame off stack
	  lw $ra, -4($fp)	# restore saved ra
	  lw $fp, 0($fp)	# restore saved fp
	  jr $ra		# return from function
	# VTable for class House
	  .data
	  .align 2
	  House:		# label for class House vtable
	  .word House.____SetupGame
	  .word House.____SetupPlayers
	  .word House.____TakeAllBets
	  .word House.____TakeAllTurns
	  .word House.____ResolveAllPlayers
	  .word House.____PrintAllMoney
	  .word House.____PlayOneGame
	  .text
  ____GetYesOrNo:
	# BeginFunc 40
	  subu $sp, $sp, 8	# decrement sp to make space to save ra, fp
	  sw $fp, 8($sp)	# save fp
	  sw $ra, 4($sp)	# save ra
	  addiu $fp, $sp, 8	# set up new fp
	  subu $sp, $sp, 40	# decrement sp to make space for locals/temps
	# PushParam prompt
	  subu $sp, $sp, 4	# decrement sp to make space for param
	  lw $t0, 4($fp)	# fill prompt to $t0 from $fp+4
	  sw $t0, 4($sp)	# copy param value to stack
	# LCall _PrintString
	  jal _PrintString   	# jump to function
	# PopParams 4
	  add $sp, $sp, 4	# pop params off stack
	# _tmp715 = " (y/n) "
	  .data			# create string constant marked with label
	  _string63: .asciiz " (y/n) "
	  .text
	  la $t2, _string63	# load label
	  sw $t2, -12($fp)	# spill _tmp715 from $t2 to $fp-12
	# PushParam _tmp715
	  subu $sp, $sp, 4	# decrement sp to make space for param
	  lw $t0, -12($fp)	# fill _tmp715 to $t0 from $fp-12
	  sw $t0, 4($sp)	# copy param value to stack
	# LCall _PrintString
	  jal _PrintString   	# jump to function
	# PopParams 4
	  add $sp, $sp, 4	# pop params off stack
	# _tmp716 = LCall _ReadLine
	  jal _ReadLine      	# jump to function
	  move $t2, $v0		# copy function return value from $v0
	  sw $t2, -16($fp)	# spill _tmp716 from $t2 to $fp-16
	# answer = _tmp716
	  lw $t2, -16($fp)	# fill _tmp716 to $t2 from $fp-16
	  sw $t2, -8($fp)	# spill answer from $t2 to $fp-8
	# _tmp717 = "y"
	  .data			# create string constant marked with label
	  _string64: .asciiz "y"
	  .text
	  la $t2, _string64	# load label
	  sw $t2, -20($fp)	# spill _tmp717 from $t2 to $fp-20
	# PushParam _tmp717
	  subu $sp, $sp, 4	# decrement sp to make space for param
	  lw $t0, -20($fp)	# fill _tmp717 to $t0 from $fp-20
	  sw $t0, 4($sp)	# copy param value to stack
	# PushParam answer
	  subu $sp, $sp, 4	# decrement sp to make space for param
	  lw $t0, -8($fp)	# fill answer to $t0 from $fp-8
	  sw $t0, 4($sp)	# copy param value to stack
	# _tmp718 = LCall _StringEqual
	  jal _StringEqual   	# jump to function
	  move $t2, $v0		# copy function return value from $v0
	  sw $t2, -24($fp)	# spill _tmp718 from $t2 to $fp-24
	# PopParams 8
	  add $sp, $sp, 8	# pop params off stack
	# _tmp719 = "Y"
	  .data			# create string constant marked with label
	  _string65: .asciiz "Y"
	  .text
	  la $t2, _string65	# load label
	  sw $t2, -28($fp)	# spill _tmp719 from $t2 to $fp-28
	# PushParam _tmp719
	  subu $sp, $sp, 4	# decrement sp to make space for param
	  lw $t0, -28($fp)	# fill _tmp719 to $t0 from $fp-28
	  sw $t0, 4($sp)	# copy param value to stack
	# PushParam answer
	  subu $sp, $sp, 4	# decrement sp to make space for param
	  lw $t0, -8($fp)	# fill answer to $t0 from $fp-8
	  sw $t0, 4($sp)	# copy param value to stack
	# _tmp720 = LCall _StringEqual
	  jal _StringEqual   	# jump to function
	  move $t2, $v0		# copy function return value from $v0
	  sw $t2, -32($fp)	# spill _tmp720 from $t2 to $fp-32
	# PopParams 8
	  add $sp, $sp, 8	# pop params off stack
	# _tmp721 = _tmp718 || _tmp720
	  lw $t0, -24($fp)	# fill _tmp718 to $t0 from $fp-24
	  lw $t1, -32($fp)	# fill _tmp720 to $t1 from $fp-32
	  or $t2, $t0, $t1	
	  sw $t2, -36($fp)	# spill _tmp721 from $t2 to $fp-36
	# Return _tmp721
	  lw $t2, -36($fp)	# fill _tmp721 to $t2 from $fp-36
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
	# BeginFunc 104
	  subu $sp, $sp, 8	# decrement sp to make space to save ra, fp
	  sw $fp, 8($sp)	# save fp
	  sw $ra, 4($sp)	# save ra
	  addiu $fp, $sp, 8	# set up new fp
	  subu $sp, $sp, 104	# decrement sp to make space for locals/temps
	# _tmp722 = 1
	  li $t2, 1		# load constant value 1 into $t2
	  sw $t2, -16($fp)	# spill _tmp722 from $t2 to $fp-16
	# keepPlaying = _tmp722
	  lw $t2, -16($fp)	# fill _tmp722 to $t2 from $fp-16
	  sw $t2, -8($fp)	# spill keepPlaying from $t2 to $fp-8
	# _tmp723 = 12
	  li $t2, 12		# load constant value 12 into $t2
	  sw $t2, -20($fp)	# spill _tmp723 from $t2 to $fp-20
	# _tmp724 = 4
	  li $t2, 4		# load constant value 4 into $t2
	  sw $t2, -24($fp)	# spill _tmp724 from $t2 to $fp-24
	# _tmp725 = _tmp724 + _tmp723
	  lw $t0, -24($fp)	# fill _tmp724 to $t0 from $fp-24
	  lw $t1, -20($fp)	# fill _tmp723 to $t1 from $fp-20
	  add $t2, $t0, $t1	
	  sw $t2, -28($fp)	# spill _tmp725 from $t2 to $fp-28
	# PushParam _tmp725
	  subu $sp, $sp, 4	# decrement sp to make space for param
	  lw $t0, -28($fp)	# fill _tmp725 to $t0 from $fp-28
	  sw $t0, 4($sp)	# copy param value to stack
	# _tmp726 = LCall _Alloc
	  jal _Alloc         	# jump to function
	  move $t2, $v0		# copy function return value from $v0
	  sw $t2, -32($fp)	# spill _tmp726 from $t2 to $fp-32
	# PopParams 4
	  add $sp, $sp, 4	# pop params off stack
	# _tmp727 = House
	  la $t2, House	# load label
	  sw $t2, -36($fp)	# spill _tmp727 from $t2 to $fp-36
	# *(_tmp726) = _tmp727
	  lw $t0, -36($fp)	# fill _tmp727 to $t0 from $fp-36
	  lw $t2, -32($fp)	# fill _tmp726 to $t2 from $fp-32
	  sw $t0, 0($t2) 	# store with offset
	# house = _tmp726
	  lw $t2, -32($fp)	# fill _tmp726 to $t2 from $fp-32
	  sw $t2, -12($fp)	# spill house from $t2 to $fp-12
	# PushParam house
	  subu $sp, $sp, 4	# decrement sp to make space for param
	  lw $t0, -12($fp)	# fill house to $t0 from $fp-12
	  sw $t0, 4($sp)	# copy param value to stack
	# _tmp728 = *(house)
	  lw $t0, -12($fp)	# fill house to $t0 from $fp-12
	  lw $t2, 0($t0) 	# load with offset
	  sw $t2, -40($fp)	# spill _tmp728 from $t2 to $fp-40
	# _tmp729 = *(_tmp728)
	  lw $t0, -40($fp)	# fill _tmp728 to $t0 from $fp-40
	  lw $t2, 0($t0) 	# load with offset
	  sw $t2, -44($fp)	# spill _tmp729 from $t2 to $fp-44
	# ACall _tmp729
	  lw $t0, -44($fp)	# fill _tmp729 to $t0 from $fp-44
	  jalr $t0            	# jump to function
	# PopParams 4
	  add $sp, $sp, 4	# pop params off stack
	# PushParam house
	  subu $sp, $sp, 4	# decrement sp to make space for param
	  lw $t0, -12($fp)	# fill house to $t0 from $fp-12
	  sw $t0, 4($sp)	# copy param value to stack
	# _tmp730 = *(house)
	  lw $t0, -12($fp)	# fill house to $t0 from $fp-12
	  lw $t2, 0($t0) 	# load with offset
	  sw $t2, -48($fp)	# spill _tmp730 from $t2 to $fp-48
	# _tmp731 = *(_tmp730 + 4)
	  lw $t0, -48($fp)	# fill _tmp730 to $t0 from $fp-48
	  lw $t2, 4($t0) 	# load with offset
	  sw $t2, -52($fp)	# spill _tmp731 from $t2 to $fp-52
	# ACall _tmp731
	  lw $t0, -52($fp)	# fill _tmp731 to $t0 from $fp-52
	  jalr $t0            	# jump to function
	# PopParams 4
	  add $sp, $sp, 4	# pop params off stack
  _L100:
	# IfZ keepPlaying Goto _L101
	  lw $t0, -8($fp)	# fill keepPlaying to $t0 from $fp-8
	  beqz $t0, _L101	# branch if keepPlaying is zero 
	# PushParam house
	  subu $sp, $sp, 4	# decrement sp to make space for param
	  lw $t0, -12($fp)	# fill house to $t0 from $fp-12
	  sw $t0, 4($sp)	# copy param value to stack
	# _tmp732 = *(house)
	  lw $t0, -12($fp)	# fill house to $t0 from $fp-12
	  lw $t2, 0($t0) 	# load with offset
	  sw $t2, -56($fp)	# spill _tmp732 from $t2 to $fp-56
	# _tmp733 = *(_tmp732 + 24)
	  lw $t0, -56($fp)	# fill _tmp732 to $t0 from $fp-56
	  lw $t2, 24($t0) 	# load with offset
	  sw $t2, -60($fp)	# spill _tmp733 from $t2 to $fp-60
	# ACall _tmp733
	  lw $t0, -60($fp)	# fill _tmp733 to $t0 from $fp-60
	  jalr $t0            	# jump to function
	# PopParams 4
	  add $sp, $sp, 4	# pop params off stack
	# _tmp734 = "\nDo you want to play another hand?"
	  .data			# create string constant marked with label
	  _string66: .asciiz "\nDo you want to play another hand?"
	  .text
	  la $t2, _string66	# load label
	  sw $t2, -64($fp)	# spill _tmp734 from $t2 to $fp-64
	# PushParam _tmp734
	  subu $sp, $sp, 4	# decrement sp to make space for param
	  lw $t0, -64($fp)	# fill _tmp734 to $t0 from $fp-64
	  sw $t0, 4($sp)	# copy param value to stack
	# _tmp735 = LCall ____GetYesOrNo
	  jal ____GetYesOrNo 	# jump to function
	  move $t2, $v0		# copy function return value from $v0
	  sw $t2, -68($fp)	# spill _tmp735 from $t2 to $fp-68
	# PopParams 4
	  add $sp, $sp, 4	# pop params off stack
	# keepPlaying = _tmp735
	  lw $t2, -68($fp)	# fill _tmp735 to $t2 from $fp-68
	  sw $t2, -8($fp)	# spill keepPlaying from $t2 to $fp-8
	# Goto _L100
	  b _L100		# unconditional branch
  _L101:
	# PushParam house
	  subu $sp, $sp, 4	# decrement sp to make space for param
	  lw $t0, -12($fp)	# fill house to $t0 from $fp-12
	  sw $t0, 4($sp)	# copy param value to stack
	# _tmp736 = *(house)
	  lw $t0, -12($fp)	# fill house to $t0 from $fp-12
	  lw $t2, 0($t0) 	# load with offset
	  sw $t2, -72($fp)	# spill _tmp736 from $t2 to $fp-72
	# _tmp737 = *(_tmp736 + 20)
	  lw $t0, -72($fp)	# fill _tmp736 to $t0 from $fp-72
	  lw $t2, 20($t0) 	# load with offset
	  sw $t2, -76($fp)	# spill _tmp737 from $t2 to $fp-76
	# ACall _tmp737
	  lw $t0, -76($fp)	# fill _tmp737 to $t0 from $fp-76
	  jalr $t0            	# jump to function
	# PopParams 4
	  add $sp, $sp, 4	# pop params off stack
	# _tmp738 = "Thank you for playing...come again soon.\n"
	  .data			# create string constant marked with label
	  _string67: .asciiz "Thank you for playing...come again soon.\n"
	  .text
	  la $t2, _string67	# load label
	  sw $t2, -80($fp)	# spill _tmp738 from $t2 to $fp-80
	# PushParam _tmp738
	  subu $sp, $sp, 4	# decrement sp to make space for param
	  lw $t0, -80($fp)	# fill _tmp738 to $t0 from $fp-80
	  sw $t0, 4($sp)	# copy param value to stack
	# LCall _PrintString
	  jal _PrintString   	# jump to function
	# PopParams 4
	  add $sp, $sp, 4	# pop params off stack
	# _tmp739 = "\nCS143 BlackJack Copyright (c) 1999 by Peter Mor..."
	  .data			# create string constant marked with label
	  _string68: .asciiz "\nCS143 BlackJack Copyright (c) 1999 by Peter Mork.\n"
	  .text
	  la $t2, _string68	# load label
	  sw $t2, -84($fp)	# spill _tmp739 from $t2 to $fp-84
	# PushParam _tmp739
	  subu $sp, $sp, 4	# decrement sp to make space for param
	  lw $t0, -84($fp)	# fill _tmp739 to $t0 from $fp-84
	  sw $t0, 4($sp)	# copy param value to stack
	# LCall _PrintString
	  jal _PrintString   	# jump to function
	# PopParams 4
	  add $sp, $sp, 4	# pop params off stack
	# _tmp740 = "(2001 mods by jdz)\n"
	  .data			# create string constant marked with label
	  _string69: .asciiz "(2001 mods by jdz)\n"
	  .text
	  la $t2, _string69	# load label
	  sw $t2, -88($fp)	# spill _tmp740 from $t2 to $fp-88
	# PushParam _tmp740
	  subu $sp, $sp, 4	# decrement sp to make space for param
	  lw $t0, -88($fp)	# fill _tmp740 to $t0 from $fp-88
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
