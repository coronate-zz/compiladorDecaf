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
	  
  Squash.____Grow:
	# BeginFunc 16
	  subu $sp, $sp, 8	# decrement sp to make space to save ra, fp
	  sw $fp, 8($sp)	# save fp
	  sw $ra, 4($sp)	# save ra
	  addiu $fp, $sp, 8	# set up new fp
	  subu $sp, $sp, 16	# decrement sp to make space for locals/temps
	# _tmp0 = "But I don't like squash\n"
	  .data			# create string constant marked with label
	  _string1: .asciiz "But I don't like squash\n"
	  .text
	  la $t2, _string1	# load label
	  sw $t2, -8($fp)	# spill _tmp0 from $t2 to $fp-8
	# PushParam _tmp0
	  subu $sp, $sp, 4	# decrement sp to make space for param
	  lw $t0, -8($fp)	# fill _tmp0 to $t0 from $fp-8
	  sw $t0, 4($sp)	# copy param value to stack
	# LCall _PrintString
	  jal _PrintString   	# jump to function
	# PopParams 4
	  add $sp, $sp, 4	# pop params off stack
	# _tmp1 = 10
	  li $t2, 10		# load constant value 10 into $t2
	  sw $t2, -12($fp)	# spill _tmp1 from $t2 to $fp-12
	# _tmp2 = 5
	  li $t2, 5		# load constant value 5 into $t2
	  sw $t2, -16($fp)	# spill _tmp2 from $t2 to $fp-16
	# _tmp3 = _tmp1 * _tmp2
	  lw $t0, -12($fp)	# fill _tmp1 to $t0 from $fp-12
	  lw $t1, -16($fp)	# fill _tmp2 to $t1 from $fp-16
	  mul $t2, $t0, $t1	
	  sw $t2, -20($fp)	# spill _tmp3 from $t2 to $fp-20
	# PushParam _tmp3
	  subu $sp, $sp, 4	# decrement sp to make space for param
	  lw $t0, -20($fp)	# fill _tmp3 to $t0 from $fp-20
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
	# VTable for class Squash
	  .data
	  .align 2
	  Squash:		# label for class Squash vtable
	  .word Vegetable.____Eat
	  .word Squash.____Grow
	  .word Squash.____Grow
	  .text
  Vegetable.____Eat:
	# BeginFunc 48
	  subu $sp, $sp, 8	# decrement sp to make space to save ra, fp
	  sw $fp, 8($sp)	# save fp
	  sw $ra, 4($sp)	# save ra
	  addiu $fp, $sp, 8	# set up new fp
	  subu $sp, $sp, 48	# decrement sp to make space for locals/temps
	# _tmp4 = 5
	  li $t2, 5		# load constant value 5 into $t2
	  sw $t2, -16($fp)	# spill _tmp4 from $t2 to $fp-16
	# _tmp5 = 2
	  li $t2, 2		# load constant value 2 into $t2
	  sw $t2, -20($fp)	# spill _tmp5 from $t2 to $fp-20
	# _tmp6 = _tmp4 % _tmp5
	  lw $t0, -16($fp)	# fill _tmp4 to $t0 from $fp-16
	  lw $t1, -20($fp)	# fill _tmp5 to $t1 from $fp-20
	  rem $t2, $t0, $t1	
	  sw $t2, -24($fp)	# spill _tmp6 from $t2 to $fp-24
	# *(this + 8) = _tmp6
	  lw $t0, -24($fp)	# fill _tmp6 to $t0 from $fp-24
	  lw $t2, 4($fp)	# fill this to $t2 from $fp+4
	  sw $t0, 8($t2) 	# store with offset
	# _tmp7 = "Yum! "
	  .data			# create string constant marked with label
	  _string2: .asciiz "Yum! "
	  .text
	  la $t2, _string2	# load label
	  sw $t2, -28($fp)	# spill _tmp7 from $t2 to $fp-28
	# PushParam _tmp7
	  subu $sp, $sp, 4	# decrement sp to make space for param
	  lw $t0, -28($fp)	# fill _tmp7 to $t0 from $fp-28
	  sw $t0, 4($sp)	# copy param value to stack
	# LCall _PrintString
	  jal _PrintString   	# jump to function
	# PopParams 4
	  add $sp, $sp, 4	# pop params off stack
	# _tmp8 = *(this + 8)
	  lw $t0, 4($fp)	# fill this to $t0 from $fp+4
	  lw $t2, 8($t0) 	# load with offset
	  sw $t2, -32($fp)	# spill _tmp8 from $t2 to $fp-32
	# PushParam _tmp8
	  subu $sp, $sp, 4	# decrement sp to make space for param
	  lw $t0, -32($fp)	# fill _tmp8 to $t0 from $fp-32
	  sw $t0, 4($sp)	# copy param value to stack
	# LCall _PrintInt
	  jal _PrintInt      	# jump to function
	# PopParams 4
	  add $sp, $sp, 4	# pop params off stack
	# _tmp9 = "\n"
	  .data			# create string constant marked with label
	  _string3: .asciiz "\n"
	  .text
	  la $t2, _string3	# load label
	  sw $t2, -36($fp)	# spill _tmp9 from $t2 to $fp-36
	# PushParam _tmp9
	  subu $sp, $sp, 4	# decrement sp to make space for param
	  lw $t0, -36($fp)	# fill _tmp9 to $t0 from $fp-36
	  sw $t0, 4($sp)	# copy param value to stack
	# LCall _PrintString
	  jal _PrintString   	# jump to function
	# PopParams 4
	  add $sp, $sp, 4	# pop params off stack
	# PushParam w
	  subu $sp, $sp, 4	# decrement sp to make space for param
	  lw $t0, -12($fp)	# fill w to $t0 from $fp-12
	  sw $t0, 4($sp)	# copy param value to stack
	# PushParam s
	  subu $sp, $sp, 4	# decrement sp to make space for param
	  lw $t0, -8($fp)	# fill s to $t0 from $fp-8
	  sw $t0, 4($sp)	# copy param value to stack
	# PushParam veg
	  subu $sp, $sp, 4	# decrement sp to make space for param
	  lw $t0, 8($fp)	# fill veg to $t0 from $fp+8
	  sw $t0, 4($sp)	# copy param value to stack
	# _tmp10 = *(veg)
	  lw $t0, 8($fp)	# fill veg to $t0 from $fp+8
	  lw $t2, 0($t0) 	# load with offset
	  sw $t2, -40($fp)	# spill _tmp10 from $t2 to $fp-40
	# _tmp11 = *(_tmp10 + 4)
	  lw $t0, -40($fp)	# fill _tmp10 to $t0 from $fp-40
	  lw $t2, 4($t0) 	# load with offset
	  sw $t2, -44($fp)	# spill _tmp11 from $t2 to $fp-44
	# ACall _tmp11
	  lw $t0, -44($fp)	# fill _tmp11 to $t0 from $fp-44
	  jalr $t0            	# jump to function
	# PopParams 12
	  add $sp, $sp, 12	# pop params off stack
	# Return 
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
  Vegetable.____Grow:
	# BeginFunc 12
	  subu $sp, $sp, 8	# decrement sp to make space to save ra, fp
	  sw $fp, 8($sp)	# save fp
	  sw $ra, 4($sp)	# save ra
	  addiu $fp, $sp, 8	# set up new fp
	  subu $sp, $sp, 12	# decrement sp to make space for locals/temps
	# _tmp12 = "Grow, little vegetables, grow!\n"
	  .data			# create string constant marked with label
	  _string4: .asciiz "Grow, little vegetables, grow!\n"
	  .text
	  la $t2, _string4	# load label
	  sw $t2, -8($fp)	# spill _tmp12 from $t2 to $fp-8
	# PushParam _tmp12
	  subu $sp, $sp, 4	# decrement sp to make space for param
	  lw $t0, -8($fp)	# fill _tmp12 to $t0 from $fp-8
	  sw $t0, 4($sp)	# copy param value to stack
	# LCall _PrintString
	  jal _PrintString   	# jump to function
	# PopParams 4
	  add $sp, $sp, 4	# pop params off stack
	# PushParam this
	  subu $sp, $sp, 4	# decrement sp to make space for param
	  lw $t0, 4($fp)	# fill this to $t0 from $fp+4
	  sw $t0, 4($sp)	# copy param value to stack
	# PushParam this
	  subu $sp, $sp, 4	# decrement sp to make space for param
	  lw $t0, 4($fp)	# fill this to $t0 from $fp+4
	  sw $t0, 4($sp)	# copy param value to stack
	# _tmp13 = *(this)
	  lw $t0, 4($fp)	# fill this to $t0 from $fp+4
	  lw $t2, 0($t0) 	# load with offset
	  sw $t2, -12($fp)	# spill _tmp13 from $t2 to $fp-12
	# _tmp14 = *(_tmp13)
	  lw $t0, -12($fp)	# fill _tmp13 to $t0 from $fp-12
	  lw $t2, 0($t0) 	# load with offset
	  sw $t2, -16($fp)	# spill _tmp14 from $t2 to $fp-16
	# ACall _tmp14
	  lw $t0, -16($fp)	# fill _tmp14 to $t0 from $fp-16
	  jalr $t0            	# jump to function
	# PopParams 8
	  add $sp, $sp, 8	# pop params off stack
	# EndFunc
	# (below handles reaching end of fn body with no explicit return)
	  move $sp, $fp		# pop callee frame off stack
	  lw $ra, -4($fp)	# restore saved ra
	  lw $fp, 0($fp)	# restore saved fp
	  jr $ra		# return from function
	# VTable for class Vegetable
	  .data
	  .align 2
	  Vegetable:		# label for class Vegetable vtable
	  .word Vegetable.____Eat
	  .word Vegetable.____Grow
	  .text
  ____Grow:
	# BeginFunc 4
	  subu $sp, $sp, 8	# decrement sp to make space to save ra, fp
	  sw $fp, 8($sp)	# save fp
	  sw $ra, 4($sp)	# save ra
	  addiu $fp, $sp, 8	# set up new fp
	  subu $sp, $sp, 4	# decrement sp to make space for locals/temps
	# _tmp15 = "mmm... veggies!\n"
	  .data			# create string constant marked with label
	  _string5: .asciiz "mmm... veggies!\n"
	  .text
	  la $t2, _string5	# load label
	  sw $t2, -8($fp)	# spill _tmp15 from $t2 to $fp-8
	# PushParam _tmp15
	  subu $sp, $sp, 4	# decrement sp to make space for param
	  lw $t0, -8($fp)	# fill _tmp15 to $t0 from $fp-8
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
	# VTable for class Seeds
	  .data
	  .align 2
	  Seeds:		# label for class Seeds vtable
	  .text
  main:
	# BeginFunc 336
	  subu $sp, $sp, 8	# decrement sp to make space to save ra, fp
	  sw $fp, 8($sp)	# save fp
	  sw $ra, 4($sp)	# save ra
	  addiu $fp, $sp, 8	# set up new fp
	  subu $sp, $sp, 336	# decrement sp to make space for locals/temps
	# _tmp16 = 2
	  li $t2, 2		# load constant value 2 into $t2
	  sw $t2, -12($fp)	# spill _tmp16 from $t2 to $fp-12
	# _tmp17 = 4
	  li $t2, 4		# load constant value 4 into $t2
	  sw $t2, -16($fp)	# spill _tmp17 from $t2 to $fp-16
	# _tmp18 = 0
	  li $t2, 0		# load constant value 0 into $t2
	  sw $t2, -20($fp)	# spill _tmp18 from $t2 to $fp-20
	# _tmp19 = _tmp16 < _tmp18
	  lw $t0, -12($fp)	# fill _tmp16 to $t0 from $fp-12
	  lw $t1, -20($fp)	# fill _tmp18 to $t1 from $fp-20
	  slt $t2, $t0, $t1	
	  sw $t2, -24($fp)	# spill _tmp19 from $t2 to $fp-24
	# _tmp20 = _tmp16 == _tmp18
	  lw $t0, -12($fp)	# fill _tmp16 to $t0 from $fp-12
	  lw $t1, -20($fp)	# fill _tmp18 to $t1 from $fp-20
	  seq $t2, $t0, $t1	
	  sw $t2, -28($fp)	# spill _tmp20 from $t2 to $fp-28
	# _tmp21 = _tmp19 || _tmp20
	  lw $t0, -24($fp)	# fill _tmp19 to $t0 from $fp-24
	  lw $t1, -28($fp)	# fill _tmp20 to $t1 from $fp-28
	  or $t2, $t0, $t1	
	  sw $t2, -32($fp)	# spill _tmp21 from $t2 to $fp-32
	# IfZ _tmp21 Goto _L0
	  lw $t0, -32($fp)	# fill _tmp21 to $t0 from $fp-32
	  beqz $t0, _L0	# branch if _tmp21 is zero 
	# _tmp22 = "Decaf runtime error: Array size is <= 0\n"
	  .data			# create string constant marked with label
	  _string6: .asciiz "Decaf runtime error: Array size is <= 0\n"
	  .text
	  la $t2, _string6	# load label
	  sw $t2, -36($fp)	# spill _tmp22 from $t2 to $fp-36
	# PushParam _tmp22
	  subu $sp, $sp, 4	# decrement sp to make space for param
	  lw $t0, -36($fp)	# fill _tmp22 to $t0 from $fp-36
	  sw $t0, 4($sp)	# copy param value to stack
	# LCall _PrintString
	  jal _PrintString   	# jump to function
	# PopParams 4
	  add $sp, $sp, 4	# pop params off stack
	# LCall _Halt
	  jal _Halt          	# jump to function
  _L0:
	# _tmp23 = _tmp16 * _tmp17
	  lw $t0, -12($fp)	# fill _tmp16 to $t0 from $fp-12
	  lw $t1, -16($fp)	# fill _tmp17 to $t1 from $fp-16
	  mul $t2, $t0, $t1	
	  sw $t2, -40($fp)	# spill _tmp23 from $t2 to $fp-40
	# _tmp24 = _tmp17 + _tmp23
	  lw $t0, -16($fp)	# fill _tmp17 to $t0 from $fp-16
	  lw $t1, -40($fp)	# fill _tmp23 to $t1 from $fp-40
	  add $t2, $t0, $t1	
	  sw $t2, -44($fp)	# spill _tmp24 from $t2 to $fp-44
	# PushParam _tmp24
	  subu $sp, $sp, 4	# decrement sp to make space for param
	  lw $t0, -44($fp)	# fill _tmp24 to $t0 from $fp-44
	  sw $t0, 4($sp)	# copy param value to stack
	# _tmp25 = LCall _Alloc
	  jal _Alloc         	# jump to function
	  move $t2, $v0		# copy function return value from $v0
	  sw $t2, -48($fp)	# spill _tmp25 from $t2 to $fp-48
	# PopParams 4
	  add $sp, $sp, 4	# pop params off stack
	# *(_tmp25) = _tmp16
	  lw $t0, -12($fp)	# fill _tmp16 to $t0 from $fp-12
	  lw $t2, -48($fp)	# fill _tmp25 to $t2 from $fp-48
	  sw $t0, 0($t2) 	# store with offset
	# veggies = _tmp25
	  lw $t2, -48($fp)	# fill _tmp25 to $t2 from $fp-48
	  sw $t2, -8($fp)	# spill veggies from $t2 to $fp-8
	# _tmp26 = 8
	  li $t2, 8		# load constant value 8 into $t2
	  sw $t2, -52($fp)	# spill _tmp26 from $t2 to $fp-52
	# _tmp27 = 4
	  li $t2, 4		# load constant value 4 into $t2
	  sw $t2, -56($fp)	# spill _tmp27 from $t2 to $fp-56
	# _tmp28 = _tmp27 + _tmp26
	  lw $t0, -56($fp)	# fill _tmp27 to $t0 from $fp-56
	  lw $t1, -52($fp)	# fill _tmp26 to $t1 from $fp-52
	  add $t2, $t0, $t1	
	  sw $t2, -60($fp)	# spill _tmp28 from $t2 to $fp-60
	# PushParam _tmp28
	  subu $sp, $sp, 4	# decrement sp to make space for param
	  lw $t0, -60($fp)	# fill _tmp28 to $t0 from $fp-60
	  sw $t0, 4($sp)	# copy param value to stack
	# _tmp29 = LCall _Alloc
	  jal _Alloc         	# jump to function
	  move $t2, $v0		# copy function return value from $v0
	  sw $t2, -64($fp)	# spill _tmp29 from $t2 to $fp-64
	# PopParams 4
	  add $sp, $sp, 4	# pop params off stack
	# _tmp30 = Squash
	  la $t2, Squash	# load label
	  sw $t2, -68($fp)	# spill _tmp30 from $t2 to $fp-68
	# *(_tmp29) = _tmp30
	  lw $t0, -68($fp)	# fill _tmp30 to $t0 from $fp-68
	  lw $t2, -64($fp)	# fill _tmp29 to $t2 from $fp-64
	  sw $t0, 0($t2) 	# store with offset
	# _tmp31 = 0
	  li $t2, 0		# load constant value 0 into $t2
	  sw $t2, -72($fp)	# spill _tmp31 from $t2 to $fp-72
	# _tmp32 = 0
	  li $t2, 0		# load constant value 0 into $t2
	  sw $t2, -76($fp)	# spill _tmp32 from $t2 to $fp-76
	# _tmp33 = *(veggies)
	  lw $t0, -8($fp)	# fill veggies to $t0 from $fp-8
	  lw $t2, 0($t0) 	# load with offset
	  sw $t2, -80($fp)	# spill _tmp33 from $t2 to $fp-80
	# _tmp34 = _tmp31 < _tmp32
	  lw $t0, -72($fp)	# fill _tmp31 to $t0 from $fp-72
	  lw $t1, -76($fp)	# fill _tmp32 to $t1 from $fp-76
	  slt $t2, $t0, $t1	
	  sw $t2, -84($fp)	# spill _tmp34 from $t2 to $fp-84
	# _tmp35 = _tmp33 < _tmp31
	  lw $t0, -80($fp)	# fill _tmp33 to $t0 from $fp-80
	  lw $t1, -72($fp)	# fill _tmp31 to $t1 from $fp-72
	  slt $t2, $t0, $t1	
	  sw $t2, -88($fp)	# spill _tmp35 from $t2 to $fp-88
	# _tmp36 = _tmp33 == _tmp31
	  lw $t0, -80($fp)	# fill _tmp33 to $t0 from $fp-80
	  lw $t1, -72($fp)	# fill _tmp31 to $t1 from $fp-72
	  seq $t2, $t0, $t1	
	  sw $t2, -92($fp)	# spill _tmp36 from $t2 to $fp-92
	# _tmp37 = _tmp35 || _tmp36
	  lw $t0, -88($fp)	# fill _tmp35 to $t0 from $fp-88
	  lw $t1, -92($fp)	# fill _tmp36 to $t1 from $fp-92
	  or $t2, $t0, $t1	
	  sw $t2, -96($fp)	# spill _tmp37 from $t2 to $fp-96
	# _tmp38 = _tmp37 || _tmp34
	  lw $t0, -96($fp)	# fill _tmp37 to $t0 from $fp-96
	  lw $t1, -84($fp)	# fill _tmp34 to $t1 from $fp-84
	  or $t2, $t0, $t1	
	  sw $t2, -100($fp)	# spill _tmp38 from $t2 to $fp-100
	# IfZ _tmp38 Goto _L1
	  lw $t0, -100($fp)	# fill _tmp38 to $t0 from $fp-100
	  beqz $t0, _L1	# branch if _tmp38 is zero 
	# _tmp39 = "Decaf runtime error: Array subscript out of bound..."
	  .data			# create string constant marked with label
	  _string7: .asciiz "Decaf runtime error: Array subscript out of bounds\n"
	  .text
	  la $t2, _string7	# load label
	  sw $t2, -104($fp)	# spill _tmp39 from $t2 to $fp-104
	# PushParam _tmp39
	  subu $sp, $sp, 4	# decrement sp to make space for param
	  lw $t0, -104($fp)	# fill _tmp39 to $t0 from $fp-104
	  sw $t0, 4($sp)	# copy param value to stack
	# LCall _PrintString
	  jal _PrintString   	# jump to function
	# PopParams 4
	  add $sp, $sp, 4	# pop params off stack
	# LCall _Halt
	  jal _Halt          	# jump to function
  _L1:
	# _tmp40 = 4
	  li $t2, 4		# load constant value 4 into $t2
	  sw $t2, -108($fp)	# spill _tmp40 from $t2 to $fp-108
	# _tmp41 = _tmp31 * _tmp40
	  lw $t0, -72($fp)	# fill _tmp31 to $t0 from $fp-72
	  lw $t1, -108($fp)	# fill _tmp40 to $t1 from $fp-108
	  mul $t2, $t0, $t1	
	  sw $t2, -112($fp)	# spill _tmp41 from $t2 to $fp-112
	# _tmp42 = _tmp41 + _tmp40
	  lw $t0, -112($fp)	# fill _tmp41 to $t0 from $fp-112
	  lw $t1, -108($fp)	# fill _tmp40 to $t1 from $fp-108
	  add $t2, $t0, $t1	
	  sw $t2, -116($fp)	# spill _tmp42 from $t2 to $fp-116
	# _tmp43 = veggies + _tmp42
	  lw $t0, -8($fp)	# fill veggies to $t0 from $fp-8
	  lw $t1, -116($fp)	# fill _tmp42 to $t1 from $fp-116
	  add $t2, $t0, $t1	
	  sw $t2, -120($fp)	# spill _tmp43 from $t2 to $fp-120
	# *(_tmp43) = _tmp29
	  lw $t0, -64($fp)	# fill _tmp29 to $t0 from $fp-64
	  lw $t2, -120($fp)	# fill _tmp43 to $t2 from $fp-120
	  sw $t0, 0($t2) 	# store with offset
	# _tmp44 = *(_tmp43)
	  lw $t0, -120($fp)	# fill _tmp43 to $t0 from $fp-120
	  lw $t2, 0($t0) 	# load with offset
	  sw $t2, -124($fp)	# spill _tmp44 from $t2 to $fp-124
	# _tmp45 = 8
	  li $t2, 8		# load constant value 8 into $t2
	  sw $t2, -128($fp)	# spill _tmp45 from $t2 to $fp-128
	# _tmp46 = 4
	  li $t2, 4		# load constant value 4 into $t2
	  sw $t2, -132($fp)	# spill _tmp46 from $t2 to $fp-132
	# _tmp47 = _tmp46 + _tmp45
	  lw $t0, -132($fp)	# fill _tmp46 to $t0 from $fp-132
	  lw $t1, -128($fp)	# fill _tmp45 to $t1 from $fp-128
	  add $t2, $t0, $t1	
	  sw $t2, -136($fp)	# spill _tmp47 from $t2 to $fp-136
	# PushParam _tmp47
	  subu $sp, $sp, 4	# decrement sp to make space for param
	  lw $t0, -136($fp)	# fill _tmp47 to $t0 from $fp-136
	  sw $t0, 4($sp)	# copy param value to stack
	# _tmp48 = LCall _Alloc
	  jal _Alloc         	# jump to function
	  move $t2, $v0		# copy function return value from $v0
	  sw $t2, -140($fp)	# spill _tmp48 from $t2 to $fp-140
	# PopParams 4
	  add $sp, $sp, 4	# pop params off stack
	# _tmp49 = Vegetable
	  la $t2, Vegetable	# load label
	  sw $t2, -144($fp)	# spill _tmp49 from $t2 to $fp-144
	# *(_tmp48) = _tmp49
	  lw $t0, -144($fp)	# fill _tmp49 to $t0 from $fp-144
	  lw $t2, -140($fp)	# fill _tmp48 to $t2 from $fp-140
	  sw $t0, 0($t2) 	# store with offset
	# _tmp50 = 1
	  li $t2, 1		# load constant value 1 into $t2
	  sw $t2, -148($fp)	# spill _tmp50 from $t2 to $fp-148
	# _tmp51 = 0
	  li $t2, 0		# load constant value 0 into $t2
	  sw $t2, -152($fp)	# spill _tmp51 from $t2 to $fp-152
	# _tmp52 = *(veggies)
	  lw $t0, -8($fp)	# fill veggies to $t0 from $fp-8
	  lw $t2, 0($t0) 	# load with offset
	  sw $t2, -156($fp)	# spill _tmp52 from $t2 to $fp-156
	# _tmp53 = _tmp50 < _tmp51
	  lw $t0, -148($fp)	# fill _tmp50 to $t0 from $fp-148
	  lw $t1, -152($fp)	# fill _tmp51 to $t1 from $fp-152
	  slt $t2, $t0, $t1	
	  sw $t2, -160($fp)	# spill _tmp53 from $t2 to $fp-160
	# _tmp54 = _tmp52 < _tmp50
	  lw $t0, -156($fp)	# fill _tmp52 to $t0 from $fp-156
	  lw $t1, -148($fp)	# fill _tmp50 to $t1 from $fp-148
	  slt $t2, $t0, $t1	
	  sw $t2, -164($fp)	# spill _tmp54 from $t2 to $fp-164
	# _tmp55 = _tmp52 == _tmp50
	  lw $t0, -156($fp)	# fill _tmp52 to $t0 from $fp-156
	  lw $t1, -148($fp)	# fill _tmp50 to $t1 from $fp-148
	  seq $t2, $t0, $t1	
	  sw $t2, -168($fp)	# spill _tmp55 from $t2 to $fp-168
	# _tmp56 = _tmp54 || _tmp55
	  lw $t0, -164($fp)	# fill _tmp54 to $t0 from $fp-164
	  lw $t1, -168($fp)	# fill _tmp55 to $t1 from $fp-168
	  or $t2, $t0, $t1	
	  sw $t2, -172($fp)	# spill _tmp56 from $t2 to $fp-172
	# _tmp57 = _tmp56 || _tmp53
	  lw $t0, -172($fp)	# fill _tmp56 to $t0 from $fp-172
	  lw $t1, -160($fp)	# fill _tmp53 to $t1 from $fp-160
	  or $t2, $t0, $t1	
	  sw $t2, -176($fp)	# spill _tmp57 from $t2 to $fp-176
	# IfZ _tmp57 Goto _L2
	  lw $t0, -176($fp)	# fill _tmp57 to $t0 from $fp-176
	  beqz $t0, _L2	# branch if _tmp57 is zero 
	# _tmp58 = "Decaf runtime error: Array subscript out of bound..."
	  .data			# create string constant marked with label
	  _string8: .asciiz "Decaf runtime error: Array subscript out of bounds\n"
	  .text
	  la $t2, _string8	# load label
	  sw $t2, -180($fp)	# spill _tmp58 from $t2 to $fp-180
	# PushParam _tmp58
	  subu $sp, $sp, 4	# decrement sp to make space for param
	  lw $t0, -180($fp)	# fill _tmp58 to $t0 from $fp-180
	  sw $t0, 4($sp)	# copy param value to stack
	# LCall _PrintString
	  jal _PrintString   	# jump to function
	# PopParams 4
	  add $sp, $sp, 4	# pop params off stack
	# LCall _Halt
	  jal _Halt          	# jump to function
  _L2:
	# _tmp59 = 4
	  li $t2, 4		# load constant value 4 into $t2
	  sw $t2, -184($fp)	# spill _tmp59 from $t2 to $fp-184
	# _tmp60 = _tmp50 * _tmp59
	  lw $t0, -148($fp)	# fill _tmp50 to $t0 from $fp-148
	  lw $t1, -184($fp)	# fill _tmp59 to $t1 from $fp-184
	  mul $t2, $t0, $t1	
	  sw $t2, -188($fp)	# spill _tmp60 from $t2 to $fp-188
	# _tmp61 = _tmp60 + _tmp59
	  lw $t0, -188($fp)	# fill _tmp60 to $t0 from $fp-188
	  lw $t1, -184($fp)	# fill _tmp59 to $t1 from $fp-184
	  add $t2, $t0, $t1	
	  sw $t2, -192($fp)	# spill _tmp61 from $t2 to $fp-192
	# _tmp62 = veggies + _tmp61
	  lw $t0, -8($fp)	# fill veggies to $t0 from $fp-8
	  lw $t1, -192($fp)	# fill _tmp61 to $t1 from $fp-192
	  add $t2, $t0, $t1	
	  sw $t2, -196($fp)	# spill _tmp62 from $t2 to $fp-196
	# *(_tmp62) = _tmp48
	  lw $t0, -140($fp)	# fill _tmp48 to $t0 from $fp-140
	  lw $t2, -196($fp)	# fill _tmp62 to $t2 from $fp-196
	  sw $t0, 0($t2) 	# store with offset
	# _tmp63 = *(_tmp62)
	  lw $t0, -196($fp)	# fill _tmp62 to $t0 from $fp-196
	  lw $t2, 0($t0) 	# load with offset
	  sw $t2, -200($fp)	# spill _tmp63 from $t2 to $fp-200
	# _tmp64 = 10
	  li $t2, 10		# load constant value 10 into $t2
	  sw $t2, -204($fp)	# spill _tmp64 from $t2 to $fp-204
	# PushParam _tmp64
	  subu $sp, $sp, 4	# decrement sp to make space for param
	  lw $t0, -204($fp)	# fill _tmp64 to $t0 from $fp-204
	  sw $t0, 4($sp)	# copy param value to stack
	# LCall ____Grow
	  jal ____Grow       	# jump to function
	# PopParams 4
	  add $sp, $sp, 4	# pop params off stack
	# _tmp65 = 0
	  li $t2, 0		# load constant value 0 into $t2
	  sw $t2, -208($fp)	# spill _tmp65 from $t2 to $fp-208
	# _tmp66 = 0
	  li $t2, 0		# load constant value 0 into $t2
	  sw $t2, -212($fp)	# spill _tmp66 from $t2 to $fp-212
	# _tmp67 = *(veggies)
	  lw $t0, -8($fp)	# fill veggies to $t0 from $fp-8
	  lw $t2, 0($t0) 	# load with offset
	  sw $t2, -216($fp)	# spill _tmp67 from $t2 to $fp-216
	# _tmp68 = _tmp65 < _tmp66
	  lw $t0, -208($fp)	# fill _tmp65 to $t0 from $fp-208
	  lw $t1, -212($fp)	# fill _tmp66 to $t1 from $fp-212
	  slt $t2, $t0, $t1	
	  sw $t2, -220($fp)	# spill _tmp68 from $t2 to $fp-220
	# _tmp69 = _tmp67 < _tmp65
	  lw $t0, -216($fp)	# fill _tmp67 to $t0 from $fp-216
	  lw $t1, -208($fp)	# fill _tmp65 to $t1 from $fp-208
	  slt $t2, $t0, $t1	
	  sw $t2, -224($fp)	# spill _tmp69 from $t2 to $fp-224
	# _tmp70 = _tmp67 == _tmp65
	  lw $t0, -216($fp)	# fill _tmp67 to $t0 from $fp-216
	  lw $t1, -208($fp)	# fill _tmp65 to $t1 from $fp-208
	  seq $t2, $t0, $t1	
	  sw $t2, -228($fp)	# spill _tmp70 from $t2 to $fp-228
	# _tmp71 = _tmp69 || _tmp70
	  lw $t0, -224($fp)	# fill _tmp69 to $t0 from $fp-224
	  lw $t1, -228($fp)	# fill _tmp70 to $t1 from $fp-228
	  or $t2, $t0, $t1	
	  sw $t2, -232($fp)	# spill _tmp71 from $t2 to $fp-232
	# _tmp72 = _tmp71 || _tmp68
	  lw $t0, -232($fp)	# fill _tmp71 to $t0 from $fp-232
	  lw $t1, -220($fp)	# fill _tmp68 to $t1 from $fp-220
	  or $t2, $t0, $t1	
	  sw $t2, -236($fp)	# spill _tmp72 from $t2 to $fp-236
	# IfZ _tmp72 Goto _L3
	  lw $t0, -236($fp)	# fill _tmp72 to $t0 from $fp-236
	  beqz $t0, _L3	# branch if _tmp72 is zero 
	# _tmp73 = "Decaf runtime error: Array subscript out of bound..."
	  .data			# create string constant marked with label
	  _string9: .asciiz "Decaf runtime error: Array subscript out of bounds\n"
	  .text
	  la $t2, _string9	# load label
	  sw $t2, -240($fp)	# spill _tmp73 from $t2 to $fp-240
	# PushParam _tmp73
	  subu $sp, $sp, 4	# decrement sp to make space for param
	  lw $t0, -240($fp)	# fill _tmp73 to $t0 from $fp-240
	  sw $t0, 4($sp)	# copy param value to stack
	# LCall _PrintString
	  jal _PrintString   	# jump to function
	# PopParams 4
	  add $sp, $sp, 4	# pop params off stack
	# LCall _Halt
	  jal _Halt          	# jump to function
  _L3:
	# _tmp74 = 4
	  li $t2, 4		# load constant value 4 into $t2
	  sw $t2, -244($fp)	# spill _tmp74 from $t2 to $fp-244
	# _tmp75 = _tmp65 * _tmp74
	  lw $t0, -208($fp)	# fill _tmp65 to $t0 from $fp-208
	  lw $t1, -244($fp)	# fill _tmp74 to $t1 from $fp-244
	  mul $t2, $t0, $t1	
	  sw $t2, -248($fp)	# spill _tmp75 from $t2 to $fp-248
	# _tmp76 = _tmp75 + _tmp74
	  lw $t0, -248($fp)	# fill _tmp75 to $t0 from $fp-248
	  lw $t1, -244($fp)	# fill _tmp74 to $t1 from $fp-244
	  add $t2, $t0, $t1	
	  sw $t2, -252($fp)	# spill _tmp76 from $t2 to $fp-252
	# _tmp77 = veggies + _tmp76
	  lw $t0, -8($fp)	# fill veggies to $t0 from $fp-8
	  lw $t1, -252($fp)	# fill _tmp76 to $t1 from $fp-252
	  add $t2, $t0, $t1	
	  sw $t2, -256($fp)	# spill _tmp77 from $t2 to $fp-256
	# _tmp78 = *(_tmp77)
	  lw $t0, -256($fp)	# fill _tmp77 to $t0 from $fp-256
	  lw $t2, 0($t0) 	# load with offset
	  sw $t2, -260($fp)	# spill _tmp78 from $t2 to $fp-260
	# PushParam _tmp78
	  subu $sp, $sp, 4	# decrement sp to make space for param
	  lw $t0, -260($fp)	# fill _tmp78 to $t0 from $fp-260
	  sw $t0, 4($sp)	# copy param value to stack
	# _tmp79 = 1
	  li $t2, 1		# load constant value 1 into $t2
	  sw $t2, -264($fp)	# spill _tmp79 from $t2 to $fp-264
	# _tmp80 = 0
	  li $t2, 0		# load constant value 0 into $t2
	  sw $t2, -268($fp)	# spill _tmp80 from $t2 to $fp-268
	# _tmp81 = *(veggies)
	  lw $t0, -8($fp)	# fill veggies to $t0 from $fp-8
	  lw $t2, 0($t0) 	# load with offset
	  sw $t2, -272($fp)	# spill _tmp81 from $t2 to $fp-272
	# _tmp82 = _tmp79 < _tmp80
	  lw $t0, -264($fp)	# fill _tmp79 to $t0 from $fp-264
	  lw $t1, -268($fp)	# fill _tmp80 to $t1 from $fp-268
	  slt $t2, $t0, $t1	
	  sw $t2, -276($fp)	# spill _tmp82 from $t2 to $fp-276
	# _tmp83 = _tmp81 < _tmp79
	  lw $t0, -272($fp)	# fill _tmp81 to $t0 from $fp-272
	  lw $t1, -264($fp)	# fill _tmp79 to $t1 from $fp-264
	  slt $t2, $t0, $t1	
	  sw $t2, -280($fp)	# spill _tmp83 from $t2 to $fp-280
	# _tmp84 = _tmp81 == _tmp79
	  lw $t0, -272($fp)	# fill _tmp81 to $t0 from $fp-272
	  lw $t1, -264($fp)	# fill _tmp79 to $t1 from $fp-264
	  seq $t2, $t0, $t1	
	  sw $t2, -284($fp)	# spill _tmp84 from $t2 to $fp-284
	# _tmp85 = _tmp83 || _tmp84
	  lw $t0, -280($fp)	# fill _tmp83 to $t0 from $fp-280
	  lw $t1, -284($fp)	# fill _tmp84 to $t1 from $fp-284
	  or $t2, $t0, $t1	
	  sw $t2, -288($fp)	# spill _tmp85 from $t2 to $fp-288
	# _tmp86 = _tmp85 || _tmp82
	  lw $t0, -288($fp)	# fill _tmp85 to $t0 from $fp-288
	  lw $t1, -276($fp)	# fill _tmp82 to $t1 from $fp-276
	  or $t2, $t0, $t1	
	  sw $t2, -292($fp)	# spill _tmp86 from $t2 to $fp-292
	# IfZ _tmp86 Goto _L4
	  lw $t0, -292($fp)	# fill _tmp86 to $t0 from $fp-292
	  beqz $t0, _L4	# branch if _tmp86 is zero 
	# _tmp87 = "Decaf runtime error: Array subscript out of bound..."
	  .data			# create string constant marked with label
	  _string10: .asciiz "Decaf runtime error: Array subscript out of bounds\n"
	  .text
	  la $t2, _string10	# load label
	  sw $t2, -296($fp)	# spill _tmp87 from $t2 to $fp-296
	# PushParam _tmp87
	  subu $sp, $sp, 4	# decrement sp to make space for param
	  lw $t0, -296($fp)	# fill _tmp87 to $t0 from $fp-296
	  sw $t0, 4($sp)	# copy param value to stack
	# LCall _PrintString
	  jal _PrintString   	# jump to function
	# PopParams 4
	  add $sp, $sp, 4	# pop params off stack
	# LCall _Halt
	  jal _Halt          	# jump to function
  _L4:
	# _tmp88 = 4
	  li $t2, 4		# load constant value 4 into $t2
	  sw $t2, -300($fp)	# spill _tmp88 from $t2 to $fp-300
	# _tmp89 = _tmp79 * _tmp88
	  lw $t0, -264($fp)	# fill _tmp79 to $t0 from $fp-264
	  lw $t1, -300($fp)	# fill _tmp88 to $t1 from $fp-300
	  mul $t2, $t0, $t1	
	  sw $t2, -304($fp)	# spill _tmp89 from $t2 to $fp-304
	# _tmp90 = _tmp89 + _tmp88
	  lw $t0, -304($fp)	# fill _tmp89 to $t0 from $fp-304
	  lw $t1, -300($fp)	# fill _tmp88 to $t1 from $fp-300
	  add $t2, $t0, $t1	
	  sw $t2, -308($fp)	# spill _tmp90 from $t2 to $fp-308
	# _tmp91 = veggies + _tmp90
	  lw $t0, -8($fp)	# fill veggies to $t0 from $fp-8
	  lw $t1, -308($fp)	# fill _tmp90 to $t1 from $fp-308
	  add $t2, $t0, $t1	
	  sw $t2, -312($fp)	# spill _tmp91 from $t2 to $fp-312
	# _tmp92 = *(_tmp91)
	  lw $t0, -312($fp)	# fill _tmp91 to $t0 from $fp-312
	  lw $t2, 0($t0) 	# load with offset
	  sw $t2, -316($fp)	# spill _tmp92 from $t2 to $fp-316
	# PushParam _tmp92
	  subu $sp, $sp, 4	# decrement sp to make space for param
	  lw $t0, -316($fp)	# fill _tmp92 to $t0 from $fp-316
	  sw $t0, 4($sp)	# copy param value to stack
	# _tmp93 = *(_tmp92)
	  lw $t0, -316($fp)	# fill _tmp92 to $t0 from $fp-316
	  lw $t2, 0($t0) 	# load with offset
	  sw $t2, -320($fp)	# spill _tmp93 from $t2 to $fp-320
	# _tmp94 = *(_tmp93)
	  lw $t0, -320($fp)	# fill _tmp93 to $t0 from $fp-320
	  lw $t2, 0($t0) 	# load with offset
	  sw $t2, -324($fp)	# spill _tmp94 from $t2 to $fp-324
	# ACall _tmp94
	  lw $t0, -324($fp)	# fill _tmp94 to $t0 from $fp-324
	  jalr $t0            	# jump to function
	# PopParams 8
	  add $sp, $sp, 8	# pop params off stack
	# EndFunc
	# (below handles reaching end of fn body with no explicit return)
	  move $sp, $fp		# pop callee frame off stack
	  lw $ra, -4($fp)	# restore saved ra
	  lw $fp, 0($fp)	# restore saved fp
	  jr $ra		# return from function
