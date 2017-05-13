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
	  
  rndModule.____Init:
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
  rndModule.____Random:
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
  rndModule.____RndInt:
	# BeginFunc 40
	  subu $sp, $sp, 8	# decrement sp to make space to save ra, fp
	  sw $fp, 8($sp)	# save fp
	  sw $ra, 4($sp)	# save ra
	  addiu $fp, $sp, 8	# set up new fp
	  subu $sp, $sp, 40	# decrement sp to make space for locals/temps
	# PushParam this
	  subu $sp, $sp, 4	# decrement sp to make space for param
	  lw $t0, 4($fp)	# fill this to $t0 from $fp+4
	  sw $t0, 4($sp)	# copy param value to stack
	# _tmp10 = *(this)
	  lw $t0, 4($fp)	# fill this to $t0 from $fp+4
	  lw $t2, 0($t0) 	# load with offset
	  sw $t2, -12($fp)	# spill _tmp10 from $t2 to $fp-12
	# _tmp11 = *(_tmp10 + 4)
	  lw $t0, -12($fp)	# fill _tmp10 to $t0 from $fp-12
	  lw $t2, 4($t0) 	# load with offset
	  sw $t2, -16($fp)	# spill _tmp11 from $t2 to $fp-16
	# _tmp12 = ACall _tmp11
	  lw $t0, -16($fp)	# fill _tmp11 to $t0 from $fp-16
	  jalr $t0            	# jump to function
	  move $t2, $v0		# copy function return value from $v0
	  sw $t2, -20($fp)	# spill _tmp12 from $t2 to $fp-20
	# PopParams 4
	  add $sp, $sp, 4	# pop params off stack
	# randomNum = _tmp12
	  lw $t2, -20($fp)	# fill _tmp12 to $t2 from $fp-20
	  sw $t2, -8($fp)	# spill randomNum from $t2 to $fp-8
	# _tmp13 = max - min
	  lw $t0, 12($fp)	# fill max to $t0 from $fp+12
	  lw $t1, 8($fp)	# fill min to $t1 from $fp+8
	  sub $t2, $t0, $t1	
	  sw $t2, -24($fp)	# spill _tmp13 from $t2 to $fp-24
	# _tmp14 = 1
	  li $t2, 1		# load constant value 1 into $t2
	  sw $t2, -28($fp)	# spill _tmp14 from $t2 to $fp-28
	# _tmp15 = _tmp13 + _tmp14
	  lw $t0, -24($fp)	# fill _tmp13 to $t0 from $fp-24
	  lw $t1, -28($fp)	# fill _tmp14 to $t1 from $fp-28
	  add $t2, $t0, $t1	
	  sw $t2, -32($fp)	# spill _tmp15 from $t2 to $fp-32
	# _tmp16 = randomNum % _tmp15
	  lw $t0, -8($fp)	# fill randomNum to $t0 from $fp-8
	  lw $t1, -32($fp)	# fill _tmp15 to $t1 from $fp-32
	  rem $t2, $t0, $t1	
	  sw $t2, -36($fp)	# spill _tmp16 from $t2 to $fp-36
	# _tmp17 = _tmp16 + min
	  lw $t0, -36($fp)	# fill _tmp16 to $t0 from $fp-36
	  lw $t1, 8($fp)	# fill min to $t1 from $fp+8
	  add $t2, $t0, $t1	
	  sw $t2, -40($fp)	# spill _tmp17 from $t2 to $fp-40
	# Return _tmp17
	  lw $t2, -40($fp)	# fill _tmp17 to $t2 from $fp-40
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
	# VTable for class rndModule
	  .data
	  .align 2
	  rndModule:		# label for class rndModule vtable
	  .word rndModule.____Init
	  .word rndModule.____Random
	  .word rndModule.____RndInt
	  .text
  Square.____Init:
	# BeginFunc 4
	  subu $sp, $sp, 8	# decrement sp to make space to save ra, fp
	  sw $fp, 8($sp)	# save fp
	  sw $ra, 4($sp)	# save ra
	  addiu $fp, $sp, 8	# set up new fp
	  subu $sp, $sp, 4	# decrement sp to make space for locals/temps
	# _tmp18 = 1
	  li $t2, 1		# load constant value 1 into $t2
	  sw $t2, -8($fp)	# spill _tmp18 from $t2 to $fp-8
	# *(this + 4) = _tmp18
	  lw $t0, -8($fp)	# fill _tmp18 to $t0 from $fp-8
	  lw $t2, 4($fp)	# fill this to $t2 from $fp+4
	  sw $t0, 4($t2) 	# store with offset
	# EndFunc
	# (below handles reaching end of fn body with no explicit return)
	  move $sp, $fp		# pop callee frame off stack
	  lw $ra, -4($fp)	# restore saved ra
	  lw $fp, 0($fp)	# restore saved fp
	  jr $ra		# return from function
  Square.____PrintSquare:
	# BeginFunc 28
	  subu $sp, $sp, 8	# decrement sp to make space to save ra, fp
	  sw $fp, 8($sp)	# save fp
	  sw $ra, 4($sp)	# save ra
	  addiu $fp, $sp, 8	# set up new fp
	  subu $sp, $sp, 28	# decrement sp to make space for locals/temps
	# _tmp19 = *(this + 4)
	  lw $t0, 4($fp)	# fill this to $t0 from $fp+4
	  lw $t2, 4($t0) 	# load with offset
	  sw $t2, -8($fp)	# spill _tmp19 from $t2 to $fp-8
	# _tmp20 = 0
	  li $t2, 0		# load constant value 0 into $t2
	  sw $t2, -12($fp)	# spill _tmp20 from $t2 to $fp-12
	# _tmp21 = _tmp19 == _tmp20
	  lw $t0, -8($fp)	# fill _tmp19 to $t0 from $fp-8
	  lw $t1, -12($fp)	# fill _tmp20 to $t1 from $fp-12
	  seq $t2, $t0, $t1	
	  sw $t2, -16($fp)	# spill _tmp21 from $t2 to $fp-16
	# IfZ _tmp21 Goto _L0
	  lw $t0, -16($fp)	# fill _tmp21 to $t0 from $fp-16
	  beqz $t0, _L0	# branch if _tmp21 is zero 
	# _tmp22 = " "
	  .data			# create string constant marked with label
	  _string1: .asciiz " "
	  .text
	  la $t2, _string1	# load label
	  sw $t2, -20($fp)	# spill _tmp22 from $t2 to $fp-20
	# PushParam _tmp22
	  subu $sp, $sp, 4	# decrement sp to make space for param
	  lw $t0, -20($fp)	# fill _tmp22 to $t0 from $fp-20
	  sw $t0, 4($sp)	# copy param value to stack
	# LCall _PrintString
	  jal _PrintString   	# jump to function
	# PopParams 4
	  add $sp, $sp, 4	# pop params off stack
	# _tmp23 = *(this + 8)
	  lw $t0, 4($fp)	# fill this to $t0 from $fp+4
	  lw $t2, 8($t0) 	# load with offset
	  sw $t2, -24($fp)	# spill _tmp23 from $t2 to $fp-24
	# PushParam _tmp23
	  subu $sp, $sp, 4	# decrement sp to make space for param
	  lw $t0, -24($fp)	# fill _tmp23 to $t0 from $fp-24
	  sw $t0, 4($sp)	# copy param value to stack
	# LCall _PrintString
	  jal _PrintString   	# jump to function
	# PopParams 4
	  add $sp, $sp, 4	# pop params off stack
	# _tmp24 = " "
	  .data			# create string constant marked with label
	  _string2: .asciiz " "
	  .text
	  la $t2, _string2	# load label
	  sw $t2, -28($fp)	# spill _tmp24 from $t2 to $fp-28
	# PushParam _tmp24
	  subu $sp, $sp, 4	# decrement sp to make space for param
	  lw $t0, -28($fp)	# fill _tmp24 to $t0 from $fp-28
	  sw $t0, 4($sp)	# copy param value to stack
	# LCall _PrintString
	  jal _PrintString   	# jump to function
	# PopParams 4
	  add $sp, $sp, 4	# pop params off stack
	# Goto _L1
	  b _L1		# unconditional branch
  _L0:
	# _tmp25 = "   "
	  .data			# create string constant marked with label
	  _string3: .asciiz "   "
	  .text
	  la $t2, _string3	# load label
	  sw $t2, -32($fp)	# spill _tmp25 from $t2 to $fp-32
	# PushParam _tmp25
	  subu $sp, $sp, 4	# decrement sp to make space for param
	  lw $t0, -32($fp)	# fill _tmp25 to $t0 from $fp-32
	  sw $t0, 4($sp)	# copy param value to stack
	# LCall _PrintString
	  jal _PrintString   	# jump to function
	# PopParams 4
	  add $sp, $sp, 4	# pop params off stack
  _L1:
	# EndFunc
	# (below handles reaching end of fn body with no explicit return)
	  move $sp, $fp		# pop callee frame off stack
	  lw $ra, -4($fp)	# restore saved ra
	  lw $fp, 0($fp)	# restore saved fp
	  jr $ra		# return from function
  Square.____SetIsEmpty:
	# BeginFunc 0
	  subu $sp, $sp, 8	# decrement sp to make space to save ra, fp
	  sw $fp, 8($sp)	# save fp
	  sw $ra, 4($sp)	# save ra
	  addiu $fp, $sp, 8	# set up new fp
	# *(this + 4) = isEmpty
	  lw $t0, 8($fp)	# fill isEmpty to $t0 from $fp+8
	  lw $t2, 4($fp)	# fill this to $t2 from $fp+4
	  sw $t0, 4($t2) 	# store with offset
	# EndFunc
	# (below handles reaching end of fn body with no explicit return)
	  move $sp, $fp		# pop callee frame off stack
	  lw $ra, -4($fp)	# restore saved ra
	  lw $fp, 0($fp)	# restore saved fp
	  jr $ra		# return from function
  Square.____GetIsEmpty:
	# BeginFunc 4
	  subu $sp, $sp, 8	# decrement sp to make space to save ra, fp
	  sw $fp, 8($sp)	# save fp
	  sw $ra, 4($sp)	# save ra
	  addiu $fp, $sp, 8	# set up new fp
	  subu $sp, $sp, 4	# decrement sp to make space for locals/temps
	# _tmp26 = *(this + 4)
	  lw $t0, 4($fp)	# fill this to $t0 from $fp+4
	  lw $t2, 4($t0) 	# load with offset
	  sw $t2, -8($fp)	# spill _tmp26 from $t2 to $fp-8
	# Return _tmp26
	  lw $t2, -8($fp)	# fill _tmp26 to $t2 from $fp-8
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
  Square.____SetMark:
	# BeginFunc 0
	  subu $sp, $sp, 8	# decrement sp to make space to save ra, fp
	  sw $fp, 8($sp)	# save fp
	  sw $ra, 4($sp)	# save ra
	  addiu $fp, $sp, 8	# set up new fp
	# *(this + 8) = mark
	  lw $t0, 8($fp)	# fill mark to $t0 from $fp+8
	  lw $t2, 4($fp)	# fill this to $t2 from $fp+4
	  sw $t0, 8($t2) 	# store with offset
	# EndFunc
	# (below handles reaching end of fn body with no explicit return)
	  move $sp, $fp		# pop callee frame off stack
	  lw $ra, -4($fp)	# restore saved ra
	  lw $fp, 0($fp)	# restore saved fp
	  jr $ra		# return from function
  Square.____IsMarked:
	# BeginFunc 16
	  subu $sp, $sp, 8	# decrement sp to make space to save ra, fp
	  sw $fp, 8($sp)	# save fp
	  sw $ra, 4($sp)	# save ra
	  addiu $fp, $sp, 8	# set up new fp
	  subu $sp, $sp, 16	# decrement sp to make space for locals/temps
	# _tmp27 = *(this + 4)
	  lw $t0, 4($fp)	# fill this to $t0 from $fp+4
	  lw $t2, 4($t0) 	# load with offset
	  sw $t2, -8($fp)	# spill _tmp27 from $t2 to $fp-8
	# IfZ _tmp27 Goto _L2
	  lw $t0, -8($fp)	# fill _tmp27 to $t0 from $fp-8
	  beqz $t0, _L2	# branch if _tmp27 is zero 
	# _tmp28 = 0
	  li $t2, 0		# load constant value 0 into $t2
	  sw $t2, -12($fp)	# spill _tmp28 from $t2 to $fp-12
	# Return _tmp28
	  lw $t2, -12($fp)	# fill _tmp28 to $t2 from $fp-12
	  move $v0, $t2		# assign return value into $v0
	  move $sp, $fp		# pop callee frame off stack
	  lw $ra, -4($fp)	# restore saved ra
	  lw $fp, 0($fp)	# restore saved fp
	  jr $ra		# return from function
	# Goto _L3
	  b _L3		# unconditional branch
  _L2:
	# _tmp29 = *(this + 8)
	  lw $t0, 4($fp)	# fill this to $t0 from $fp+4
	  lw $t2, 8($t0) 	# load with offset
	  sw $t2, -16($fp)	# spill _tmp29 from $t2 to $fp-16
	# PushParam mark
	  subu $sp, $sp, 4	# decrement sp to make space for param
	  lw $t0, 8($fp)	# fill mark to $t0 from $fp+8
	  sw $t0, 4($sp)	# copy param value to stack
	# PushParam _tmp29
	  subu $sp, $sp, 4	# decrement sp to make space for param
	  lw $t0, -16($fp)	# fill _tmp29 to $t0 from $fp-16
	  sw $t0, 4($sp)	# copy param value to stack
	# _tmp30 = LCall _StringEqual
	  jal _StringEqual   	# jump to function
	  move $t2, $v0		# copy function return value from $v0
	  sw $t2, -20($fp)	# spill _tmp30 from $t2 to $fp-20
	# PopParams 8
	  add $sp, $sp, 8	# pop params off stack
	# Return _tmp30
	  lw $t2, -20($fp)	# fill _tmp30 to $t2 from $fp-20
	  move $v0, $t2		# assign return value into $v0
	  move $sp, $fp		# pop callee frame off stack
	  lw $ra, -4($fp)	# restore saved ra
	  lw $fp, 0($fp)	# restore saved fp
	  jr $ra		# return from function
  _L3:
	# EndFunc
	# (below handles reaching end of fn body with no explicit return)
	  move $sp, $fp		# pop callee frame off stack
	  lw $ra, -4($fp)	# restore saved ra
	  lw $fp, 0($fp)	# restore saved fp
	  jr $ra		# return from function
	# VTable for class Square
	  .data
	  .align 2
	  Square:		# label for class Square vtable
	  .word Square.____Init
	  .word Square.____PrintSquare
	  .word Square.____SetIsEmpty
	  .word Square.____GetIsEmpty
	  .word Square.____SetMark
	  .word Square.____IsMarked
	  .text
  Player.____GetMark:
	# BeginFunc 4
	  subu $sp, $sp, 8	# decrement sp to make space to save ra, fp
	  sw $fp, 8($sp)	# save fp
	  sw $ra, 4($sp)	# save ra
	  addiu $fp, $sp, 8	# set up new fp
	  subu $sp, $sp, 4	# decrement sp to make space for locals/temps
	# _tmp31 = *(this + 4)
	  lw $t0, 4($fp)	# fill this to $t0 from $fp+4
	  lw $t2, 4($t0) 	# load with offset
	  sw $t2, -8($fp)	# spill _tmp31 from $t2 to $fp-8
	# Return _tmp31
	  lw $t2, -8($fp)	# fill _tmp31 to $t2 from $fp-8
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
  Player.____GetName:
	# BeginFunc 4
	  subu $sp, $sp, 8	# decrement sp to make space to save ra, fp
	  sw $fp, 8($sp)	# save fp
	  sw $ra, 4($sp)	# save ra
	  addiu $fp, $sp, 8	# set up new fp
	  subu $sp, $sp, 4	# decrement sp to make space for locals/temps
	# _tmp32 = *(this + 8)
	  lw $t0, 4($fp)	# fill this to $t0 from $fp+4
	  lw $t2, 8($t0) 	# load with offset
	  sw $t2, -8($fp)	# spill _tmp32 from $t2 to $fp-8
	# Return _tmp32
	  lw $t2, -8($fp)	# fill _tmp32 to $t2 from $fp-8
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
	# VTable for class Player
	  .data
	  .align 2
	  Player:		# label for class Player vtable
	  .word Player.____GetMark
	  .word Player.____GetName
	  .text
  Human.____Init:
	# BeginFunc 12
	  subu $sp, $sp, 8	# decrement sp to make space to save ra, fp
	  sw $fp, 8($sp)	# save fp
	  sw $ra, 4($sp)	# save ra
	  addiu $fp, $sp, 8	# set up new fp
	  subu $sp, $sp, 12	# decrement sp to make space for locals/temps
	# _tmp33 = "X"
	  .data			# create string constant marked with label
	  _string4: .asciiz "X"
	  .text
	  la $t2, _string4	# load label
	  sw $t2, -8($fp)	# spill _tmp33 from $t2 to $fp-8
	# *(this + 4) = _tmp33
	  lw $t0, -8($fp)	# fill _tmp33 to $t0 from $fp-8
	  lw $t2, 4($fp)	# fill this to $t2 from $fp+4
	  sw $t0, 4($t2) 	# store with offset
	# _tmp34 = "\nYou're playing against the computer.\nEnter you..."
	  .data			# create string constant marked with label
	  _string5: .asciiz "\nYou're playing against the computer.\nEnter your name: "
	  .text
	  la $t2, _string5	# load label
	  sw $t2, -12($fp)	# spill _tmp34 from $t2 to $fp-12
	# PushParam _tmp34
	  subu $sp, $sp, 4	# decrement sp to make space for param
	  lw $t0, -12($fp)	# fill _tmp34 to $t0 from $fp-12
	  sw $t0, 4($sp)	# copy param value to stack
	# LCall _PrintString
	  jal _PrintString   	# jump to function
	# PopParams 4
	  add $sp, $sp, 4	# pop params off stack
	# _tmp35 = LCall _ReadLine
	  jal _ReadLine      	# jump to function
	  move $t2, $v0		# copy function return value from $v0
	  sw $t2, -16($fp)	# spill _tmp35 from $t2 to $fp-16
	# *(this + 8) = _tmp35
	  lw $t0, -16($fp)	# fill _tmp35 to $t0 from $fp-16
	  lw $t2, 4($fp)	# fill this to $t2 from $fp+4
	  sw $t0, 8($t2) 	# store with offset
	# EndFunc
	# (below handles reaching end of fn body with no explicit return)
	  move $sp, $fp		# pop callee frame off stack
	  lw $ra, -4($fp)	# restore saved ra
	  lw $fp, 0($fp)	# restore saved fp
	  jr $ra		# return from function
  Human.____GetRow:
	# BeginFunc 104
	  subu $sp, $sp, 8	# decrement sp to make space to save ra, fp
	  sw $fp, 8($sp)	# save fp
	  sw $ra, 4($sp)	# save ra
	  addiu $fp, $sp, 8	# set up new fp
	  subu $sp, $sp, 104	# decrement sp to make space for locals/temps
	# _tmp36 = 1
	  li $t2, 1		# load constant value 1 into $t2
	  sw $t2, -12($fp)	# spill _tmp36 from $t2 to $fp-12
	# _tmp37 = 0
	  li $t2, 0		# load constant value 0 into $t2
	  sw $t2, -16($fp)	# spill _tmp37 from $t2 to $fp-16
	# _tmp38 = _tmp37 - _tmp36
	  lw $t0, -16($fp)	# fill _tmp37 to $t0 from $fp-16
	  lw $t1, -12($fp)	# fill _tmp36 to $t1 from $fp-12
	  sub $t2, $t0, $t1	
	  sw $t2, -20($fp)	# spill _tmp38 from $t2 to $fp-20
	# row = _tmp38
	  lw $t2, -20($fp)	# fill _tmp38 to $t2 from $fp-20
	  sw $t2, -8($fp)	# spill row from $t2 to $fp-8
  _L4:
	# _tmp39 = 3
	  li $t2, 3		# load constant value 3 into $t2
	  sw $t2, -24($fp)	# spill _tmp39 from $t2 to $fp-24
	# _tmp40 = _tmp39 < row
	  lw $t0, -24($fp)	# fill _tmp39 to $t0 from $fp-24
	  lw $t1, -8($fp)	# fill row to $t1 from $fp-8
	  slt $t2, $t0, $t1	
	  sw $t2, -28($fp)	# spill _tmp40 from $t2 to $fp-28
	# _tmp41 = 1
	  li $t2, 1		# load constant value 1 into $t2
	  sw $t2, -32($fp)	# spill _tmp41 from $t2 to $fp-32
	# _tmp42 = row < _tmp41
	  lw $t0, -8($fp)	# fill row to $t0 from $fp-8
	  lw $t1, -32($fp)	# fill _tmp41 to $t1 from $fp-32
	  slt $t2, $t0, $t1	
	  sw $t2, -36($fp)	# spill _tmp42 from $t2 to $fp-36
	# _tmp43 = _tmp40 || _tmp42
	  lw $t0, -28($fp)	# fill _tmp40 to $t0 from $fp-28
	  lw $t1, -36($fp)	# fill _tmp42 to $t1 from $fp-36
	  or $t2, $t0, $t1	
	  sw $t2, -40($fp)	# spill _tmp43 from $t2 to $fp-40
	# IfZ _tmp43 Goto _L5
	  lw $t0, -40($fp)	# fill _tmp43 to $t0 from $fp-40
	  beqz $t0, _L5	# branch if _tmp43 is zero 
	# _tmp44 = *(this + 8)
	  lw $t0, 4($fp)	# fill this to $t0 from $fp+4
	  lw $t2, 8($t0) 	# load with offset
	  sw $t2, -44($fp)	# spill _tmp44 from $t2 to $fp-44
	# PushParam _tmp44
	  subu $sp, $sp, 4	# decrement sp to make space for param
	  lw $t0, -44($fp)	# fill _tmp44 to $t0 from $fp-44
	  sw $t0, 4($sp)	# copy param value to stack
	# LCall _PrintString
	  jal _PrintString   	# jump to function
	# PopParams 4
	  add $sp, $sp, 4	# pop params off stack
	# _tmp45 = " enter a row between 1 and 3: "
	  .data			# create string constant marked with label
	  _string6: .asciiz " enter a row between 1 and 3: "
	  .text
	  la $t2, _string6	# load label
	  sw $t2, -48($fp)	# spill _tmp45 from $t2 to $fp-48
	# PushParam _tmp45
	  subu $sp, $sp, 4	# decrement sp to make space for param
	  lw $t0, -48($fp)	# fill _tmp45 to $t0 from $fp-48
	  sw $t0, 4($sp)	# copy param value to stack
	# LCall _PrintString
	  jal _PrintString   	# jump to function
	# PopParams 4
	  add $sp, $sp, 4	# pop params off stack
	# _tmp46 = LCall _ReadInteger
	  jal _ReadInteger   	# jump to function
	  move $t2, $v0		# copy function return value from $v0
	  sw $t2, -52($fp)	# spill _tmp46 from $t2 to $fp-52
	# row = _tmp46
	  lw $t2, -52($fp)	# fill _tmp46 to $t2 from $fp-52
	  sw $t2, -8($fp)	# spill row from $t2 to $fp-8
	# _tmp47 = 3
	  li $t2, 3		# load constant value 3 into $t2
	  sw $t2, -56($fp)	# spill _tmp47 from $t2 to $fp-56
	# _tmp48 = _tmp47 < row
	  lw $t0, -56($fp)	# fill _tmp47 to $t0 from $fp-56
	  lw $t1, -8($fp)	# fill row to $t1 from $fp-8
	  slt $t2, $t0, $t1	
	  sw $t2, -60($fp)	# spill _tmp48 from $t2 to $fp-60
	# _tmp49 = 1
	  li $t2, 1		# load constant value 1 into $t2
	  sw $t2, -64($fp)	# spill _tmp49 from $t2 to $fp-64
	# _tmp50 = row < _tmp49
	  lw $t0, -8($fp)	# fill row to $t0 from $fp-8
	  lw $t1, -64($fp)	# fill _tmp49 to $t1 from $fp-64
	  slt $t2, $t0, $t1	
	  sw $t2, -68($fp)	# spill _tmp50 from $t2 to $fp-68
	# _tmp51 = _tmp48 || _tmp50
	  lw $t0, -60($fp)	# fill _tmp48 to $t0 from $fp-60
	  lw $t1, -68($fp)	# fill _tmp50 to $t1 from $fp-68
	  or $t2, $t0, $t1	
	  sw $t2, -72($fp)	# spill _tmp51 from $t2 to $fp-72
	# IfZ _tmp51 Goto _L6
	  lw $t0, -72($fp)	# fill _tmp51 to $t0 from $fp-72
	  beqz $t0, _L6	# branch if _tmp51 is zero 
	# _tmp52 = "Error: Pick a row between 1 and 3\n"
	  .data			# create string constant marked with label
	  _string7: .asciiz "Error: Pick a row between 1 and 3\n"
	  .text
	  la $t2, _string7	# load label
	  sw $t2, -76($fp)	# spill _tmp52 from $t2 to $fp-76
	# PushParam _tmp52
	  subu $sp, $sp, 4	# decrement sp to make space for param
	  lw $t0, -76($fp)	# fill _tmp52 to $t0 from $fp-76
	  sw $t0, 4($sp)	# copy param value to stack
	# LCall _PrintString
	  jal _PrintString   	# jump to function
	# PopParams 4
	  add $sp, $sp, 4	# pop params off stack
	# Goto _L7
	  b _L7		# unconditional branch
  _L6:
  _L7:
	# Goto _L4
	  b _L4		# unconditional branch
  _L5:
	# _tmp53 = 1
	  li $t2, 1		# load constant value 1 into $t2
	  sw $t2, -80($fp)	# spill _tmp53 from $t2 to $fp-80
	# _tmp54 = row - _tmp53
	  lw $t0, -8($fp)	# fill row to $t0 from $fp-8
	  lw $t1, -80($fp)	# fill _tmp53 to $t1 from $fp-80
	  sub $t2, $t0, $t1	
	  sw $t2, -84($fp)	# spill _tmp54 from $t2 to $fp-84
	# row = _tmp54
	  lw $t2, -84($fp)	# fill _tmp54 to $t2 from $fp-84
	  sw $t2, -8($fp)	# spill row from $t2 to $fp-8
	# Return row
	  lw $t2, -8($fp)	# fill row to $t2 from $fp-8
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
  Human.____GetColumn:
	# BeginFunc 104
	  subu $sp, $sp, 8	# decrement sp to make space to save ra, fp
	  sw $fp, 8($sp)	# save fp
	  sw $ra, 4($sp)	# save ra
	  addiu $fp, $sp, 8	# set up new fp
	  subu $sp, $sp, 104	# decrement sp to make space for locals/temps
	# _tmp55 = 1
	  li $t2, 1		# load constant value 1 into $t2
	  sw $t2, -12($fp)	# spill _tmp55 from $t2 to $fp-12
	# _tmp56 = 0
	  li $t2, 0		# load constant value 0 into $t2
	  sw $t2, -16($fp)	# spill _tmp56 from $t2 to $fp-16
	# _tmp57 = _tmp56 - _tmp55
	  lw $t0, -16($fp)	# fill _tmp56 to $t0 from $fp-16
	  lw $t1, -12($fp)	# fill _tmp55 to $t1 from $fp-12
	  sub $t2, $t0, $t1	
	  sw $t2, -20($fp)	# spill _tmp57 from $t2 to $fp-20
	# column = _tmp57
	  lw $t2, -20($fp)	# fill _tmp57 to $t2 from $fp-20
	  sw $t2, -8($fp)	# spill column from $t2 to $fp-8
  _L8:
	# _tmp58 = 3
	  li $t2, 3		# load constant value 3 into $t2
	  sw $t2, -24($fp)	# spill _tmp58 from $t2 to $fp-24
	# _tmp59 = _tmp58 < column
	  lw $t0, -24($fp)	# fill _tmp58 to $t0 from $fp-24
	  lw $t1, -8($fp)	# fill column to $t1 from $fp-8
	  slt $t2, $t0, $t1	
	  sw $t2, -28($fp)	# spill _tmp59 from $t2 to $fp-28
	# _tmp60 = 1
	  li $t2, 1		# load constant value 1 into $t2
	  sw $t2, -32($fp)	# spill _tmp60 from $t2 to $fp-32
	# _tmp61 = column < _tmp60
	  lw $t0, -8($fp)	# fill column to $t0 from $fp-8
	  lw $t1, -32($fp)	# fill _tmp60 to $t1 from $fp-32
	  slt $t2, $t0, $t1	
	  sw $t2, -36($fp)	# spill _tmp61 from $t2 to $fp-36
	# _tmp62 = _tmp59 || _tmp61
	  lw $t0, -28($fp)	# fill _tmp59 to $t0 from $fp-28
	  lw $t1, -36($fp)	# fill _tmp61 to $t1 from $fp-36
	  or $t2, $t0, $t1	
	  sw $t2, -40($fp)	# spill _tmp62 from $t2 to $fp-40
	# IfZ _tmp62 Goto _L9
	  lw $t0, -40($fp)	# fill _tmp62 to $t0 from $fp-40
	  beqz $t0, _L9	# branch if _tmp62 is zero 
	# _tmp63 = *(this + 8)
	  lw $t0, 4($fp)	# fill this to $t0 from $fp+4
	  lw $t2, 8($t0) 	# load with offset
	  sw $t2, -44($fp)	# spill _tmp63 from $t2 to $fp-44
	# PushParam _tmp63
	  subu $sp, $sp, 4	# decrement sp to make space for param
	  lw $t0, -44($fp)	# fill _tmp63 to $t0 from $fp-44
	  sw $t0, 4($sp)	# copy param value to stack
	# LCall _PrintString
	  jal _PrintString   	# jump to function
	# PopParams 4
	  add $sp, $sp, 4	# pop params off stack
	# _tmp64 = " enter a column between 1 and 3: "
	  .data			# create string constant marked with label
	  _string8: .asciiz " enter a column between 1 and 3: "
	  .text
	  la $t2, _string8	# load label
	  sw $t2, -48($fp)	# spill _tmp64 from $t2 to $fp-48
	# PushParam _tmp64
	  subu $sp, $sp, 4	# decrement sp to make space for param
	  lw $t0, -48($fp)	# fill _tmp64 to $t0 from $fp-48
	  sw $t0, 4($sp)	# copy param value to stack
	# LCall _PrintString
	  jal _PrintString   	# jump to function
	# PopParams 4
	  add $sp, $sp, 4	# pop params off stack
	# _tmp65 = LCall _ReadInteger
	  jal _ReadInteger   	# jump to function
	  move $t2, $v0		# copy function return value from $v0
	  sw $t2, -52($fp)	# spill _tmp65 from $t2 to $fp-52
	# column = _tmp65
	  lw $t2, -52($fp)	# fill _tmp65 to $t2 from $fp-52
	  sw $t2, -8($fp)	# spill column from $t2 to $fp-8
	# _tmp66 = 3
	  li $t2, 3		# load constant value 3 into $t2
	  sw $t2, -56($fp)	# spill _tmp66 from $t2 to $fp-56
	# _tmp67 = _tmp66 < column
	  lw $t0, -56($fp)	# fill _tmp66 to $t0 from $fp-56
	  lw $t1, -8($fp)	# fill column to $t1 from $fp-8
	  slt $t2, $t0, $t1	
	  sw $t2, -60($fp)	# spill _tmp67 from $t2 to $fp-60
	# _tmp68 = 1
	  li $t2, 1		# load constant value 1 into $t2
	  sw $t2, -64($fp)	# spill _tmp68 from $t2 to $fp-64
	# _tmp69 = column < _tmp68
	  lw $t0, -8($fp)	# fill column to $t0 from $fp-8
	  lw $t1, -64($fp)	# fill _tmp68 to $t1 from $fp-64
	  slt $t2, $t0, $t1	
	  sw $t2, -68($fp)	# spill _tmp69 from $t2 to $fp-68
	# _tmp70 = _tmp67 || _tmp69
	  lw $t0, -60($fp)	# fill _tmp67 to $t0 from $fp-60
	  lw $t1, -68($fp)	# fill _tmp69 to $t1 from $fp-68
	  or $t2, $t0, $t1	
	  sw $t2, -72($fp)	# spill _tmp70 from $t2 to $fp-72
	# IfZ _tmp70 Goto _L10
	  lw $t0, -72($fp)	# fill _tmp70 to $t0 from $fp-72
	  beqz $t0, _L10	# branch if _tmp70 is zero 
	# _tmp71 = "Error: Pick a column between 1 and 3\n"
	  .data			# create string constant marked with label
	  _string9: .asciiz "Error: Pick a column between 1 and 3\n"
	  .text
	  la $t2, _string9	# load label
	  sw $t2, -76($fp)	# spill _tmp71 from $t2 to $fp-76
	# PushParam _tmp71
	  subu $sp, $sp, 4	# decrement sp to make space for param
	  lw $t0, -76($fp)	# fill _tmp71 to $t0 from $fp-76
	  sw $t0, 4($sp)	# copy param value to stack
	# LCall _PrintString
	  jal _PrintString   	# jump to function
	# PopParams 4
	  add $sp, $sp, 4	# pop params off stack
	# Goto _L11
	  b _L11		# unconditional branch
  _L10:
  _L11:
	# Goto _L8
	  b _L8		# unconditional branch
  _L9:
	# _tmp72 = 1
	  li $t2, 1		# load constant value 1 into $t2
	  sw $t2, -80($fp)	# spill _tmp72 from $t2 to $fp-80
	# _tmp73 = column - _tmp72
	  lw $t0, -8($fp)	# fill column to $t0 from $fp-8
	  lw $t1, -80($fp)	# fill _tmp72 to $t1 from $fp-80
	  sub $t2, $t0, $t1	
	  sw $t2, -84($fp)	# spill _tmp73 from $t2 to $fp-84
	# column = _tmp73
	  lw $t2, -84($fp)	# fill _tmp73 to $t2 from $fp-84
	  sw $t2, -8($fp)	# spill column from $t2 to $fp-8
	# Return column
	  lw $t2, -8($fp)	# fill column to $t2 from $fp-8
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
	# VTable for class Human
	  .data
	  .align 2
	  Human:		# label for class Human vtable
	  .word Player.____GetMark
	  .word Player.____GetName
	  .word Human.____Init
	  .word Human.____GetRow
	  .word Human.____GetColumn
	  .text
  Grid.____Init:
	# BeginFunc 492
	  subu $sp, $sp, 8	# decrement sp to make space to save ra, fp
	  sw $fp, 8($sp)	# save fp
	  sw $ra, 4($sp)	# save ra
	  addiu $fp, $sp, 8	# set up new fp
	  subu $sp, $sp, 492	# decrement sp to make space for locals/temps
	# _tmp74 = 0
	  li $t2, 0		# load constant value 0 into $t2
	  sw $t2, -16($fp)	# spill _tmp74 from $t2 to $fp-16
	# i = _tmp74
	  lw $t2, -16($fp)	# fill _tmp74 to $t2 from $fp-16
	  sw $t2, -8($fp)	# spill i from $t2 to $fp-8
	# _tmp75 = 3
	  li $t2, 3		# load constant value 3 into $t2
	  sw $t2, -20($fp)	# spill _tmp75 from $t2 to $fp-20
	# _tmp76 = 4
	  li $t2, 4		# load constant value 4 into $t2
	  sw $t2, -24($fp)	# spill _tmp76 from $t2 to $fp-24
	# _tmp77 = 0
	  li $t2, 0		# load constant value 0 into $t2
	  sw $t2, -28($fp)	# spill _tmp77 from $t2 to $fp-28
	# _tmp78 = _tmp75 < _tmp77
	  lw $t0, -20($fp)	# fill _tmp75 to $t0 from $fp-20
	  lw $t1, -28($fp)	# fill _tmp77 to $t1 from $fp-28
	  slt $t2, $t0, $t1	
	  sw $t2, -32($fp)	# spill _tmp78 from $t2 to $fp-32
	# _tmp79 = _tmp75 == _tmp77
	  lw $t0, -20($fp)	# fill _tmp75 to $t0 from $fp-20
	  lw $t1, -28($fp)	# fill _tmp77 to $t1 from $fp-28
	  seq $t2, $t0, $t1	
	  sw $t2, -36($fp)	# spill _tmp79 from $t2 to $fp-36
	# _tmp80 = _tmp78 || _tmp79
	  lw $t0, -32($fp)	# fill _tmp78 to $t0 from $fp-32
	  lw $t1, -36($fp)	# fill _tmp79 to $t1 from $fp-36
	  or $t2, $t0, $t1	
	  sw $t2, -40($fp)	# spill _tmp80 from $t2 to $fp-40
	# IfZ _tmp80 Goto _L12
	  lw $t0, -40($fp)	# fill _tmp80 to $t0 from $fp-40
	  beqz $t0, _L12	# branch if _tmp80 is zero 
	# _tmp81 = "Decaf runtime error: Array size is <= 0\n"
	  .data			# create string constant marked with label
	  _string10: .asciiz "Decaf runtime error: Array size is <= 0\n"
	  .text
	  la $t2, _string10	# load label
	  sw $t2, -44($fp)	# spill _tmp81 from $t2 to $fp-44
	# PushParam _tmp81
	  subu $sp, $sp, 4	# decrement sp to make space for param
	  lw $t0, -44($fp)	# fill _tmp81 to $t0 from $fp-44
	  sw $t0, 4($sp)	# copy param value to stack
	# LCall _PrintString
	  jal _PrintString   	# jump to function
	# PopParams 4
	  add $sp, $sp, 4	# pop params off stack
	# LCall _Halt
	  jal _Halt          	# jump to function
  _L12:
	# _tmp82 = _tmp75 * _tmp76
	  lw $t0, -20($fp)	# fill _tmp75 to $t0 from $fp-20
	  lw $t1, -24($fp)	# fill _tmp76 to $t1 from $fp-24
	  mul $t2, $t0, $t1	
	  sw $t2, -48($fp)	# spill _tmp82 from $t2 to $fp-48
	# _tmp83 = _tmp76 + _tmp82
	  lw $t0, -24($fp)	# fill _tmp76 to $t0 from $fp-24
	  lw $t1, -48($fp)	# fill _tmp82 to $t1 from $fp-48
	  add $t2, $t0, $t1	
	  sw $t2, -52($fp)	# spill _tmp83 from $t2 to $fp-52
	# PushParam _tmp83
	  subu $sp, $sp, 4	# decrement sp to make space for param
	  lw $t0, -52($fp)	# fill _tmp83 to $t0 from $fp-52
	  sw $t0, 4($sp)	# copy param value to stack
	# _tmp84 = LCall _Alloc
	  jal _Alloc         	# jump to function
	  move $t2, $v0		# copy function return value from $v0
	  sw $t2, -56($fp)	# spill _tmp84 from $t2 to $fp-56
	# PopParams 4
	  add $sp, $sp, 4	# pop params off stack
	# *(_tmp84) = _tmp75
	  lw $t0, -20($fp)	# fill _tmp75 to $t0 from $fp-20
	  lw $t2, -56($fp)	# fill _tmp84 to $t2 from $fp-56
	  sw $t0, 0($t2) 	# store with offset
	# *(this + 4) = _tmp84
	  lw $t0, -56($fp)	# fill _tmp84 to $t0 from $fp-56
	  lw $t2, 4($fp)	# fill this to $t2 from $fp+4
	  sw $t0, 4($t2) 	# store with offset
  _L13:
	# _tmp85 = 3
	  li $t2, 3		# load constant value 3 into $t2
	  sw $t2, -60($fp)	# spill _tmp85 from $t2 to $fp-60
	# _tmp86 = i < _tmp85
	  lw $t0, -8($fp)	# fill i to $t0 from $fp-8
	  lw $t1, -60($fp)	# fill _tmp85 to $t1 from $fp-60
	  slt $t2, $t0, $t1	
	  sw $t2, -64($fp)	# spill _tmp86 from $t2 to $fp-64
	# IfZ _tmp86 Goto _L14
	  lw $t0, -64($fp)	# fill _tmp86 to $t0 from $fp-64
	  beqz $t0, _L14	# branch if _tmp86 is zero 
	# _tmp87 = 3
	  li $t2, 3		# load constant value 3 into $t2
	  sw $t2, -68($fp)	# spill _tmp87 from $t2 to $fp-68
	# _tmp88 = 4
	  li $t2, 4		# load constant value 4 into $t2
	  sw $t2, -72($fp)	# spill _tmp88 from $t2 to $fp-72
	# _tmp89 = 0
	  li $t2, 0		# load constant value 0 into $t2
	  sw $t2, -76($fp)	# spill _tmp89 from $t2 to $fp-76
	# _tmp90 = _tmp87 < _tmp89
	  lw $t0, -68($fp)	# fill _tmp87 to $t0 from $fp-68
	  lw $t1, -76($fp)	# fill _tmp89 to $t1 from $fp-76
	  slt $t2, $t0, $t1	
	  sw $t2, -80($fp)	# spill _tmp90 from $t2 to $fp-80
	# _tmp91 = _tmp87 == _tmp89
	  lw $t0, -68($fp)	# fill _tmp87 to $t0 from $fp-68
	  lw $t1, -76($fp)	# fill _tmp89 to $t1 from $fp-76
	  seq $t2, $t0, $t1	
	  sw $t2, -84($fp)	# spill _tmp91 from $t2 to $fp-84
	# _tmp92 = _tmp90 || _tmp91
	  lw $t0, -80($fp)	# fill _tmp90 to $t0 from $fp-80
	  lw $t1, -84($fp)	# fill _tmp91 to $t1 from $fp-84
	  or $t2, $t0, $t1	
	  sw $t2, -88($fp)	# spill _tmp92 from $t2 to $fp-88
	# IfZ _tmp92 Goto _L15
	  lw $t0, -88($fp)	# fill _tmp92 to $t0 from $fp-88
	  beqz $t0, _L15	# branch if _tmp92 is zero 
	# _tmp93 = "Decaf runtime error: Array size is <= 0\n"
	  .data			# create string constant marked with label
	  _string11: .asciiz "Decaf runtime error: Array size is <= 0\n"
	  .text
	  la $t2, _string11	# load label
	  sw $t2, -92($fp)	# spill _tmp93 from $t2 to $fp-92
	# PushParam _tmp93
	  subu $sp, $sp, 4	# decrement sp to make space for param
	  lw $t0, -92($fp)	# fill _tmp93 to $t0 from $fp-92
	  sw $t0, 4($sp)	# copy param value to stack
	# LCall _PrintString
	  jal _PrintString   	# jump to function
	# PopParams 4
	  add $sp, $sp, 4	# pop params off stack
	# LCall _Halt
	  jal _Halt          	# jump to function
  _L15:
	# _tmp94 = _tmp87 * _tmp88
	  lw $t0, -68($fp)	# fill _tmp87 to $t0 from $fp-68
	  lw $t1, -72($fp)	# fill _tmp88 to $t1 from $fp-72
	  mul $t2, $t0, $t1	
	  sw $t2, -96($fp)	# spill _tmp94 from $t2 to $fp-96
	# _tmp95 = _tmp88 + _tmp94
	  lw $t0, -72($fp)	# fill _tmp88 to $t0 from $fp-72
	  lw $t1, -96($fp)	# fill _tmp94 to $t1 from $fp-96
	  add $t2, $t0, $t1	
	  sw $t2, -100($fp)	# spill _tmp95 from $t2 to $fp-100
	# PushParam _tmp95
	  subu $sp, $sp, 4	# decrement sp to make space for param
	  lw $t0, -100($fp)	# fill _tmp95 to $t0 from $fp-100
	  sw $t0, 4($sp)	# copy param value to stack
	# _tmp96 = LCall _Alloc
	  jal _Alloc         	# jump to function
	  move $t2, $v0		# copy function return value from $v0
	  sw $t2, -104($fp)	# spill _tmp96 from $t2 to $fp-104
	# PopParams 4
	  add $sp, $sp, 4	# pop params off stack
	# *(_tmp96) = _tmp87
	  lw $t0, -68($fp)	# fill _tmp87 to $t0 from $fp-68
	  lw $t2, -104($fp)	# fill _tmp96 to $t2 from $fp-104
	  sw $t0, 0($t2) 	# store with offset
	# _tmp97 = *(this + 4)
	  lw $t0, 4($fp)	# fill this to $t0 from $fp+4
	  lw $t2, 4($t0) 	# load with offset
	  sw $t2, -108($fp)	# spill _tmp97 from $t2 to $fp-108
	# _tmp98 = 0
	  li $t2, 0		# load constant value 0 into $t2
	  sw $t2, -112($fp)	# spill _tmp98 from $t2 to $fp-112
	# _tmp99 = *(_tmp97)
	  lw $t0, -108($fp)	# fill _tmp97 to $t0 from $fp-108
	  lw $t2, 0($t0) 	# load with offset
	  sw $t2, -116($fp)	# spill _tmp99 from $t2 to $fp-116
	# _tmp100 = i < _tmp98
	  lw $t0, -8($fp)	# fill i to $t0 from $fp-8
	  lw $t1, -112($fp)	# fill _tmp98 to $t1 from $fp-112
	  slt $t2, $t0, $t1	
	  sw $t2, -120($fp)	# spill _tmp100 from $t2 to $fp-120
	# _tmp101 = _tmp99 < i
	  lw $t0, -116($fp)	# fill _tmp99 to $t0 from $fp-116
	  lw $t1, -8($fp)	# fill i to $t1 from $fp-8
	  slt $t2, $t0, $t1	
	  sw $t2, -124($fp)	# spill _tmp101 from $t2 to $fp-124
	# _tmp102 = _tmp99 == i
	  lw $t0, -116($fp)	# fill _tmp99 to $t0 from $fp-116
	  lw $t1, -8($fp)	# fill i to $t1 from $fp-8
	  seq $t2, $t0, $t1	
	  sw $t2, -128($fp)	# spill _tmp102 from $t2 to $fp-128
	# _tmp103 = _tmp101 || _tmp102
	  lw $t0, -124($fp)	# fill _tmp101 to $t0 from $fp-124
	  lw $t1, -128($fp)	# fill _tmp102 to $t1 from $fp-128
	  or $t2, $t0, $t1	
	  sw $t2, -132($fp)	# spill _tmp103 from $t2 to $fp-132
	# _tmp104 = _tmp103 || _tmp100
	  lw $t0, -132($fp)	# fill _tmp103 to $t0 from $fp-132
	  lw $t1, -120($fp)	# fill _tmp100 to $t1 from $fp-120
	  or $t2, $t0, $t1	
	  sw $t2, -136($fp)	# spill _tmp104 from $t2 to $fp-136
	# IfZ _tmp104 Goto _L16
	  lw $t0, -136($fp)	# fill _tmp104 to $t0 from $fp-136
	  beqz $t0, _L16	# branch if _tmp104 is zero 
	# _tmp105 = "Decaf runtime error: Array subscript out of bound..."
	  .data			# create string constant marked with label
	  _string12: .asciiz "Decaf runtime error: Array subscript out of bounds\n"
	  .text
	  la $t2, _string12	# load label
	  sw $t2, -140($fp)	# spill _tmp105 from $t2 to $fp-140
	# PushParam _tmp105
	  subu $sp, $sp, 4	# decrement sp to make space for param
	  lw $t0, -140($fp)	# fill _tmp105 to $t0 from $fp-140
	  sw $t0, 4($sp)	# copy param value to stack
	# LCall _PrintString
	  jal _PrintString   	# jump to function
	# PopParams 4
	  add $sp, $sp, 4	# pop params off stack
	# LCall _Halt
	  jal _Halt          	# jump to function
  _L16:
	# _tmp106 = 4
	  li $t2, 4		# load constant value 4 into $t2
	  sw $t2, -144($fp)	# spill _tmp106 from $t2 to $fp-144
	# _tmp107 = i * _tmp106
	  lw $t0, -8($fp)	# fill i to $t0 from $fp-8
	  lw $t1, -144($fp)	# fill _tmp106 to $t1 from $fp-144
	  mul $t2, $t0, $t1	
	  sw $t2, -148($fp)	# spill _tmp107 from $t2 to $fp-148
	# _tmp108 = _tmp107 + _tmp106
	  lw $t0, -148($fp)	# fill _tmp107 to $t0 from $fp-148
	  lw $t1, -144($fp)	# fill _tmp106 to $t1 from $fp-144
	  add $t2, $t0, $t1	
	  sw $t2, -152($fp)	# spill _tmp108 from $t2 to $fp-152
	# _tmp109 = _tmp97 + _tmp108
	  lw $t0, -108($fp)	# fill _tmp97 to $t0 from $fp-108
	  lw $t1, -152($fp)	# fill _tmp108 to $t1 from $fp-152
	  add $t2, $t0, $t1	
	  sw $t2, -156($fp)	# spill _tmp109 from $t2 to $fp-156
	# *(_tmp109) = _tmp96
	  lw $t0, -104($fp)	# fill _tmp96 to $t0 from $fp-104
	  lw $t2, -156($fp)	# fill _tmp109 to $t2 from $fp-156
	  sw $t0, 0($t2) 	# store with offset
	# _tmp110 = *(_tmp109)
	  lw $t0, -156($fp)	# fill _tmp109 to $t0 from $fp-156
	  lw $t2, 0($t0) 	# load with offset
	  sw $t2, -160($fp)	# spill _tmp110 from $t2 to $fp-160
	# _tmp111 = 1
	  li $t2, 1		# load constant value 1 into $t2
	  sw $t2, -164($fp)	# spill _tmp111 from $t2 to $fp-164
	# _tmp112 = i + _tmp111
	  lw $t0, -8($fp)	# fill i to $t0 from $fp-8
	  lw $t1, -164($fp)	# fill _tmp111 to $t1 from $fp-164
	  add $t2, $t0, $t1	
	  sw $t2, -168($fp)	# spill _tmp112 from $t2 to $fp-168
	# i = _tmp112
	  lw $t2, -168($fp)	# fill _tmp112 to $t2 from $fp-168
	  sw $t2, -8($fp)	# spill i from $t2 to $fp-8
	# Goto _L13
	  b _L13		# unconditional branch
  _L14:
	# _tmp113 = 0
	  li $t2, 0		# load constant value 0 into $t2
	  sw $t2, -172($fp)	# spill _tmp113 from $t2 to $fp-172
	# i = _tmp113
	  lw $t2, -172($fp)	# fill _tmp113 to $t2 from $fp-172
	  sw $t2, -8($fp)	# spill i from $t2 to $fp-8
  _L17:
	# _tmp114 = 3
	  li $t2, 3		# load constant value 3 into $t2
	  sw $t2, -176($fp)	# spill _tmp114 from $t2 to $fp-176
	# _tmp115 = i < _tmp114
	  lw $t0, -8($fp)	# fill i to $t0 from $fp-8
	  lw $t1, -176($fp)	# fill _tmp114 to $t1 from $fp-176
	  slt $t2, $t0, $t1	
	  sw $t2, -180($fp)	# spill _tmp115 from $t2 to $fp-180
	# IfZ _tmp115 Goto _L18
	  lw $t0, -180($fp)	# fill _tmp115 to $t0 from $fp-180
	  beqz $t0, _L18	# branch if _tmp115 is zero 
	# _tmp116 = 0
	  li $t2, 0		# load constant value 0 into $t2
	  sw $t2, -184($fp)	# spill _tmp116 from $t2 to $fp-184
	# j = _tmp116
	  lw $t2, -184($fp)	# fill _tmp116 to $t2 from $fp-184
	  sw $t2, -12($fp)	# spill j from $t2 to $fp-12
  _L19:
	# _tmp117 = 3
	  li $t2, 3		# load constant value 3 into $t2
	  sw $t2, -188($fp)	# spill _tmp117 from $t2 to $fp-188
	# _tmp118 = j < _tmp117
	  lw $t0, -12($fp)	# fill j to $t0 from $fp-12
	  lw $t1, -188($fp)	# fill _tmp117 to $t1 from $fp-188
	  slt $t2, $t0, $t1	
	  sw $t2, -192($fp)	# spill _tmp118 from $t2 to $fp-192
	# IfZ _tmp118 Goto _L20
	  lw $t0, -192($fp)	# fill _tmp118 to $t0 from $fp-192
	  beqz $t0, _L20	# branch if _tmp118 is zero 
	# _tmp119 = 8
	  li $t2, 8		# load constant value 8 into $t2
	  sw $t2, -196($fp)	# spill _tmp119 from $t2 to $fp-196
	# _tmp120 = 4
	  li $t2, 4		# load constant value 4 into $t2
	  sw $t2, -200($fp)	# spill _tmp120 from $t2 to $fp-200
	# _tmp121 = _tmp120 + _tmp119
	  lw $t0, -200($fp)	# fill _tmp120 to $t0 from $fp-200
	  lw $t1, -196($fp)	# fill _tmp119 to $t1 from $fp-196
	  add $t2, $t0, $t1	
	  sw $t2, -204($fp)	# spill _tmp121 from $t2 to $fp-204
	# PushParam _tmp121
	  subu $sp, $sp, 4	# decrement sp to make space for param
	  lw $t0, -204($fp)	# fill _tmp121 to $t0 from $fp-204
	  sw $t0, 4($sp)	# copy param value to stack
	# _tmp122 = LCall _Alloc
	  jal _Alloc         	# jump to function
	  move $t2, $v0		# copy function return value from $v0
	  sw $t2, -208($fp)	# spill _tmp122 from $t2 to $fp-208
	# PopParams 4
	  add $sp, $sp, 4	# pop params off stack
	# _tmp123 = Square
	  la $t2, Square	# load label
	  sw $t2, -212($fp)	# spill _tmp123 from $t2 to $fp-212
	# *(_tmp122) = _tmp123
	  lw $t0, -212($fp)	# fill _tmp123 to $t0 from $fp-212
	  lw $t2, -208($fp)	# fill _tmp122 to $t2 from $fp-208
	  sw $t0, 0($t2) 	# store with offset
	# _tmp124 = *(this + 4)
	  lw $t0, 4($fp)	# fill this to $t0 from $fp+4
	  lw $t2, 4($t0) 	# load with offset
	  sw $t2, -216($fp)	# spill _tmp124 from $t2 to $fp-216
	# _tmp125 = 0
	  li $t2, 0		# load constant value 0 into $t2
	  sw $t2, -220($fp)	# spill _tmp125 from $t2 to $fp-220
	# _tmp126 = *(_tmp124)
	  lw $t0, -216($fp)	# fill _tmp124 to $t0 from $fp-216
	  lw $t2, 0($t0) 	# load with offset
	  sw $t2, -224($fp)	# spill _tmp126 from $t2 to $fp-224
	# _tmp127 = i < _tmp125
	  lw $t0, -8($fp)	# fill i to $t0 from $fp-8
	  lw $t1, -220($fp)	# fill _tmp125 to $t1 from $fp-220
	  slt $t2, $t0, $t1	
	  sw $t2, -228($fp)	# spill _tmp127 from $t2 to $fp-228
	# _tmp128 = _tmp126 < i
	  lw $t0, -224($fp)	# fill _tmp126 to $t0 from $fp-224
	  lw $t1, -8($fp)	# fill i to $t1 from $fp-8
	  slt $t2, $t0, $t1	
	  sw $t2, -232($fp)	# spill _tmp128 from $t2 to $fp-232
	# _tmp129 = _tmp126 == i
	  lw $t0, -224($fp)	# fill _tmp126 to $t0 from $fp-224
	  lw $t1, -8($fp)	# fill i to $t1 from $fp-8
	  seq $t2, $t0, $t1	
	  sw $t2, -236($fp)	# spill _tmp129 from $t2 to $fp-236
	# _tmp130 = _tmp128 || _tmp129
	  lw $t0, -232($fp)	# fill _tmp128 to $t0 from $fp-232
	  lw $t1, -236($fp)	# fill _tmp129 to $t1 from $fp-236
	  or $t2, $t0, $t1	
	  sw $t2, -240($fp)	# spill _tmp130 from $t2 to $fp-240
	# _tmp131 = _tmp130 || _tmp127
	  lw $t0, -240($fp)	# fill _tmp130 to $t0 from $fp-240
	  lw $t1, -228($fp)	# fill _tmp127 to $t1 from $fp-228
	  or $t2, $t0, $t1	
	  sw $t2, -244($fp)	# spill _tmp131 from $t2 to $fp-244
	# IfZ _tmp131 Goto _L21
	  lw $t0, -244($fp)	# fill _tmp131 to $t0 from $fp-244
	  beqz $t0, _L21	# branch if _tmp131 is zero 
	# _tmp132 = "Decaf runtime error: Array subscript out of bound..."
	  .data			# create string constant marked with label
	  _string13: .asciiz "Decaf runtime error: Array subscript out of bounds\n"
	  .text
	  la $t2, _string13	# load label
	  sw $t2, -248($fp)	# spill _tmp132 from $t2 to $fp-248
	# PushParam _tmp132
	  subu $sp, $sp, 4	# decrement sp to make space for param
	  lw $t0, -248($fp)	# fill _tmp132 to $t0 from $fp-248
	  sw $t0, 4($sp)	# copy param value to stack
	# LCall _PrintString
	  jal _PrintString   	# jump to function
	# PopParams 4
	  add $sp, $sp, 4	# pop params off stack
	# LCall _Halt
	  jal _Halt          	# jump to function
  _L21:
	# _tmp133 = 4
	  li $t2, 4		# load constant value 4 into $t2
	  sw $t2, -252($fp)	# spill _tmp133 from $t2 to $fp-252
	# _tmp134 = i * _tmp133
	  lw $t0, -8($fp)	# fill i to $t0 from $fp-8
	  lw $t1, -252($fp)	# fill _tmp133 to $t1 from $fp-252
	  mul $t2, $t0, $t1	
	  sw $t2, -256($fp)	# spill _tmp134 from $t2 to $fp-256
	# _tmp135 = _tmp134 + _tmp133
	  lw $t0, -256($fp)	# fill _tmp134 to $t0 from $fp-256
	  lw $t1, -252($fp)	# fill _tmp133 to $t1 from $fp-252
	  add $t2, $t0, $t1	
	  sw $t2, -260($fp)	# spill _tmp135 from $t2 to $fp-260
	# _tmp136 = _tmp124 + _tmp135
	  lw $t0, -216($fp)	# fill _tmp124 to $t0 from $fp-216
	  lw $t1, -260($fp)	# fill _tmp135 to $t1 from $fp-260
	  add $t2, $t0, $t1	
	  sw $t2, -264($fp)	# spill _tmp136 from $t2 to $fp-264
	# _tmp137 = *(_tmp136)
	  lw $t0, -264($fp)	# fill _tmp136 to $t0 from $fp-264
	  lw $t2, 0($t0) 	# load with offset
	  sw $t2, -268($fp)	# spill _tmp137 from $t2 to $fp-268
	# _tmp138 = 0
	  li $t2, 0		# load constant value 0 into $t2
	  sw $t2, -272($fp)	# spill _tmp138 from $t2 to $fp-272
	# _tmp139 = *(_tmp137)
	  lw $t0, -268($fp)	# fill _tmp137 to $t0 from $fp-268
	  lw $t2, 0($t0) 	# load with offset
	  sw $t2, -276($fp)	# spill _tmp139 from $t2 to $fp-276
	# _tmp140 = j < _tmp138
	  lw $t0, -12($fp)	# fill j to $t0 from $fp-12
	  lw $t1, -272($fp)	# fill _tmp138 to $t1 from $fp-272
	  slt $t2, $t0, $t1	
	  sw $t2, -280($fp)	# spill _tmp140 from $t2 to $fp-280
	# _tmp141 = _tmp139 < j
	  lw $t0, -276($fp)	# fill _tmp139 to $t0 from $fp-276
	  lw $t1, -12($fp)	# fill j to $t1 from $fp-12
	  slt $t2, $t0, $t1	
	  sw $t2, -284($fp)	# spill _tmp141 from $t2 to $fp-284
	# _tmp142 = _tmp139 == j
	  lw $t0, -276($fp)	# fill _tmp139 to $t0 from $fp-276
	  lw $t1, -12($fp)	# fill j to $t1 from $fp-12
	  seq $t2, $t0, $t1	
	  sw $t2, -288($fp)	# spill _tmp142 from $t2 to $fp-288
	# _tmp143 = _tmp141 || _tmp142
	  lw $t0, -284($fp)	# fill _tmp141 to $t0 from $fp-284
	  lw $t1, -288($fp)	# fill _tmp142 to $t1 from $fp-288
	  or $t2, $t0, $t1	
	  sw $t2, -292($fp)	# spill _tmp143 from $t2 to $fp-292
	# _tmp144 = _tmp143 || _tmp140
	  lw $t0, -292($fp)	# fill _tmp143 to $t0 from $fp-292
	  lw $t1, -280($fp)	# fill _tmp140 to $t1 from $fp-280
	  or $t2, $t0, $t1	
	  sw $t2, -296($fp)	# spill _tmp144 from $t2 to $fp-296
	# IfZ _tmp144 Goto _L22
	  lw $t0, -296($fp)	# fill _tmp144 to $t0 from $fp-296
	  beqz $t0, _L22	# branch if _tmp144 is zero 
	# _tmp145 = "Decaf runtime error: Array subscript out of bound..."
	  .data			# create string constant marked with label
	  _string14: .asciiz "Decaf runtime error: Array subscript out of bounds\n"
	  .text
	  la $t2, _string14	# load label
	  sw $t2, -300($fp)	# spill _tmp145 from $t2 to $fp-300
	# PushParam _tmp145
	  subu $sp, $sp, 4	# decrement sp to make space for param
	  lw $t0, -300($fp)	# fill _tmp145 to $t0 from $fp-300
	  sw $t0, 4($sp)	# copy param value to stack
	# LCall _PrintString
	  jal _PrintString   	# jump to function
	# PopParams 4
	  add $sp, $sp, 4	# pop params off stack
	# LCall _Halt
	  jal _Halt          	# jump to function
  _L22:
	# _tmp146 = 4
	  li $t2, 4		# load constant value 4 into $t2
	  sw $t2, -304($fp)	# spill _tmp146 from $t2 to $fp-304
	# _tmp147 = j * _tmp146
	  lw $t0, -12($fp)	# fill j to $t0 from $fp-12
	  lw $t1, -304($fp)	# fill _tmp146 to $t1 from $fp-304
	  mul $t2, $t0, $t1	
	  sw $t2, -308($fp)	# spill _tmp147 from $t2 to $fp-308
	# _tmp148 = _tmp147 + _tmp146
	  lw $t0, -308($fp)	# fill _tmp147 to $t0 from $fp-308
	  lw $t1, -304($fp)	# fill _tmp146 to $t1 from $fp-304
	  add $t2, $t0, $t1	
	  sw $t2, -312($fp)	# spill _tmp148 from $t2 to $fp-312
	# _tmp149 = _tmp137 + _tmp148
	  lw $t0, -268($fp)	# fill _tmp137 to $t0 from $fp-268
	  lw $t1, -312($fp)	# fill _tmp148 to $t1 from $fp-312
	  add $t2, $t0, $t1	
	  sw $t2, -316($fp)	# spill _tmp149 from $t2 to $fp-316
	# *(_tmp149) = _tmp122
	  lw $t0, -208($fp)	# fill _tmp122 to $t0 from $fp-208
	  lw $t2, -316($fp)	# fill _tmp149 to $t2 from $fp-316
	  sw $t0, 0($t2) 	# store with offset
	# _tmp150 = *(_tmp149)
	  lw $t0, -316($fp)	# fill _tmp149 to $t0 from $fp-316
	  lw $t2, 0($t0) 	# load with offset
	  sw $t2, -320($fp)	# spill _tmp150 from $t2 to $fp-320
	# _tmp151 = *(this + 4)
	  lw $t0, 4($fp)	# fill this to $t0 from $fp+4
	  lw $t2, 4($t0) 	# load with offset
	  sw $t2, -324($fp)	# spill _tmp151 from $t2 to $fp-324
	# _tmp152 = 0
	  li $t2, 0		# load constant value 0 into $t2
	  sw $t2, -328($fp)	# spill _tmp152 from $t2 to $fp-328
	# _tmp153 = *(_tmp151)
	  lw $t0, -324($fp)	# fill _tmp151 to $t0 from $fp-324
	  lw $t2, 0($t0) 	# load with offset
	  sw $t2, -332($fp)	# spill _tmp153 from $t2 to $fp-332
	# _tmp154 = i < _tmp152
	  lw $t0, -8($fp)	# fill i to $t0 from $fp-8
	  lw $t1, -328($fp)	# fill _tmp152 to $t1 from $fp-328
	  slt $t2, $t0, $t1	
	  sw $t2, -336($fp)	# spill _tmp154 from $t2 to $fp-336
	# _tmp155 = _tmp153 < i
	  lw $t0, -332($fp)	# fill _tmp153 to $t0 from $fp-332
	  lw $t1, -8($fp)	# fill i to $t1 from $fp-8
	  slt $t2, $t0, $t1	
	  sw $t2, -340($fp)	# spill _tmp155 from $t2 to $fp-340
	# _tmp156 = _tmp153 == i
	  lw $t0, -332($fp)	# fill _tmp153 to $t0 from $fp-332
	  lw $t1, -8($fp)	# fill i to $t1 from $fp-8
	  seq $t2, $t0, $t1	
	  sw $t2, -344($fp)	# spill _tmp156 from $t2 to $fp-344
	# _tmp157 = _tmp155 || _tmp156
	  lw $t0, -340($fp)	# fill _tmp155 to $t0 from $fp-340
	  lw $t1, -344($fp)	# fill _tmp156 to $t1 from $fp-344
	  or $t2, $t0, $t1	
	  sw $t2, -348($fp)	# spill _tmp157 from $t2 to $fp-348
	# _tmp158 = _tmp157 || _tmp154
	  lw $t0, -348($fp)	# fill _tmp157 to $t0 from $fp-348
	  lw $t1, -336($fp)	# fill _tmp154 to $t1 from $fp-336
	  or $t2, $t0, $t1	
	  sw $t2, -352($fp)	# spill _tmp158 from $t2 to $fp-352
	# IfZ _tmp158 Goto _L23
	  lw $t0, -352($fp)	# fill _tmp158 to $t0 from $fp-352
	  beqz $t0, _L23	# branch if _tmp158 is zero 
	# _tmp159 = "Decaf runtime error: Array subscript out of bound..."
	  .data			# create string constant marked with label
	  _string15: .asciiz "Decaf runtime error: Array subscript out of bounds\n"
	  .text
	  la $t2, _string15	# load label
	  sw $t2, -356($fp)	# spill _tmp159 from $t2 to $fp-356
	# PushParam _tmp159
	  subu $sp, $sp, 4	# decrement sp to make space for param
	  lw $t0, -356($fp)	# fill _tmp159 to $t0 from $fp-356
	  sw $t0, 4($sp)	# copy param value to stack
	# LCall _PrintString
	  jal _PrintString   	# jump to function
	# PopParams 4
	  add $sp, $sp, 4	# pop params off stack
	# LCall _Halt
	  jal _Halt          	# jump to function
  _L23:
	# _tmp160 = 4
	  li $t2, 4		# load constant value 4 into $t2
	  sw $t2, -360($fp)	# spill _tmp160 from $t2 to $fp-360
	# _tmp161 = i * _tmp160
	  lw $t0, -8($fp)	# fill i to $t0 from $fp-8
	  lw $t1, -360($fp)	# fill _tmp160 to $t1 from $fp-360
	  mul $t2, $t0, $t1	
	  sw $t2, -364($fp)	# spill _tmp161 from $t2 to $fp-364
	# _tmp162 = _tmp161 + _tmp160
	  lw $t0, -364($fp)	# fill _tmp161 to $t0 from $fp-364
	  lw $t1, -360($fp)	# fill _tmp160 to $t1 from $fp-360
	  add $t2, $t0, $t1	
	  sw $t2, -368($fp)	# spill _tmp162 from $t2 to $fp-368
	# _tmp163 = _tmp151 + _tmp162
	  lw $t0, -324($fp)	# fill _tmp151 to $t0 from $fp-324
	  lw $t1, -368($fp)	# fill _tmp162 to $t1 from $fp-368
	  add $t2, $t0, $t1	
	  sw $t2, -372($fp)	# spill _tmp163 from $t2 to $fp-372
	# _tmp164 = *(_tmp163)
	  lw $t0, -372($fp)	# fill _tmp163 to $t0 from $fp-372
	  lw $t2, 0($t0) 	# load with offset
	  sw $t2, -376($fp)	# spill _tmp164 from $t2 to $fp-376
	# _tmp165 = 0
	  li $t2, 0		# load constant value 0 into $t2
	  sw $t2, -380($fp)	# spill _tmp165 from $t2 to $fp-380
	# _tmp166 = *(_tmp164)
	  lw $t0, -376($fp)	# fill _tmp164 to $t0 from $fp-376
	  lw $t2, 0($t0) 	# load with offset
	  sw $t2, -384($fp)	# spill _tmp166 from $t2 to $fp-384
	# _tmp167 = j < _tmp165
	  lw $t0, -12($fp)	# fill j to $t0 from $fp-12
	  lw $t1, -380($fp)	# fill _tmp165 to $t1 from $fp-380
	  slt $t2, $t0, $t1	
	  sw $t2, -388($fp)	# spill _tmp167 from $t2 to $fp-388
	# _tmp168 = _tmp166 < j
	  lw $t0, -384($fp)	# fill _tmp166 to $t0 from $fp-384
	  lw $t1, -12($fp)	# fill j to $t1 from $fp-12
	  slt $t2, $t0, $t1	
	  sw $t2, -392($fp)	# spill _tmp168 from $t2 to $fp-392
	# _tmp169 = _tmp166 == j
	  lw $t0, -384($fp)	# fill _tmp166 to $t0 from $fp-384
	  lw $t1, -12($fp)	# fill j to $t1 from $fp-12
	  seq $t2, $t0, $t1	
	  sw $t2, -396($fp)	# spill _tmp169 from $t2 to $fp-396
	# _tmp170 = _tmp168 || _tmp169
	  lw $t0, -392($fp)	# fill _tmp168 to $t0 from $fp-392
	  lw $t1, -396($fp)	# fill _tmp169 to $t1 from $fp-396
	  or $t2, $t0, $t1	
	  sw $t2, -400($fp)	# spill _tmp170 from $t2 to $fp-400
	# _tmp171 = _tmp170 || _tmp167
	  lw $t0, -400($fp)	# fill _tmp170 to $t0 from $fp-400
	  lw $t1, -388($fp)	# fill _tmp167 to $t1 from $fp-388
	  or $t2, $t0, $t1	
	  sw $t2, -404($fp)	# spill _tmp171 from $t2 to $fp-404
	# IfZ _tmp171 Goto _L24
	  lw $t0, -404($fp)	# fill _tmp171 to $t0 from $fp-404
	  beqz $t0, _L24	# branch if _tmp171 is zero 
	# _tmp172 = "Decaf runtime error: Array subscript out of bound..."
	  .data			# create string constant marked with label
	  _string16: .asciiz "Decaf runtime error: Array subscript out of bounds\n"
	  .text
	  la $t2, _string16	# load label
	  sw $t2, -408($fp)	# spill _tmp172 from $t2 to $fp-408
	# PushParam _tmp172
	  subu $sp, $sp, 4	# decrement sp to make space for param
	  lw $t0, -408($fp)	# fill _tmp172 to $t0 from $fp-408
	  sw $t0, 4($sp)	# copy param value to stack
	# LCall _PrintString
	  jal _PrintString   	# jump to function
	# PopParams 4
	  add $sp, $sp, 4	# pop params off stack
	# LCall _Halt
	  jal _Halt          	# jump to function
  _L24:
	# _tmp173 = 4
	  li $t2, 4		# load constant value 4 into $t2
	  sw $t2, -412($fp)	# spill _tmp173 from $t2 to $fp-412
	# _tmp174 = j * _tmp173
	  lw $t0, -12($fp)	# fill j to $t0 from $fp-12
	  lw $t1, -412($fp)	# fill _tmp173 to $t1 from $fp-412
	  mul $t2, $t0, $t1	
	  sw $t2, -416($fp)	# spill _tmp174 from $t2 to $fp-416
	# _tmp175 = _tmp174 + _tmp173
	  lw $t0, -416($fp)	# fill _tmp174 to $t0 from $fp-416
	  lw $t1, -412($fp)	# fill _tmp173 to $t1 from $fp-412
	  add $t2, $t0, $t1	
	  sw $t2, -420($fp)	# spill _tmp175 from $t2 to $fp-420
	# _tmp176 = _tmp164 + _tmp175
	  lw $t0, -376($fp)	# fill _tmp164 to $t0 from $fp-376
	  lw $t1, -420($fp)	# fill _tmp175 to $t1 from $fp-420
	  add $t2, $t0, $t1	
	  sw $t2, -424($fp)	# spill _tmp176 from $t2 to $fp-424
	# _tmp177 = *(_tmp176)
	  lw $t0, -424($fp)	# fill _tmp176 to $t0 from $fp-424
	  lw $t2, 0($t0) 	# load with offset
	  sw $t2, -428($fp)	# spill _tmp177 from $t2 to $fp-428
	# PushParam _tmp177
	  subu $sp, $sp, 4	# decrement sp to make space for param
	  lw $t0, -428($fp)	# fill _tmp177 to $t0 from $fp-428
	  sw $t0, 4($sp)	# copy param value to stack
	# _tmp178 = *(_tmp177)
	  lw $t0, -428($fp)	# fill _tmp177 to $t0 from $fp-428
	  lw $t2, 0($t0) 	# load with offset
	  sw $t2, -432($fp)	# spill _tmp178 from $t2 to $fp-432
	# _tmp179 = *(_tmp178)
	  lw $t0, -432($fp)	# fill _tmp178 to $t0 from $fp-432
	  lw $t2, 0($t0) 	# load with offset
	  sw $t2, -436($fp)	# spill _tmp179 from $t2 to $fp-436
	# ACall _tmp179
	  lw $t0, -436($fp)	# fill _tmp179 to $t0 from $fp-436
	  jalr $t0            	# jump to function
	# PopParams 4
	  add $sp, $sp, 4	# pop params off stack
	# _tmp180 = 1
	  li $t2, 1		# load constant value 1 into $t2
	  sw $t2, -440($fp)	# spill _tmp180 from $t2 to $fp-440
	# _tmp181 = j + _tmp180
	  lw $t0, -12($fp)	# fill j to $t0 from $fp-12
	  lw $t1, -440($fp)	# fill _tmp180 to $t1 from $fp-440
	  add $t2, $t0, $t1	
	  sw $t2, -444($fp)	# spill _tmp181 from $t2 to $fp-444
	# j = _tmp181
	  lw $t2, -444($fp)	# fill _tmp181 to $t2 from $fp-444
	  sw $t2, -12($fp)	# spill j from $t2 to $fp-12
	# Goto _L19
	  b _L19		# unconditional branch
  _L20:
	# _tmp182 = 1
	  li $t2, 1		# load constant value 1 into $t2
	  sw $t2, -448($fp)	# spill _tmp182 from $t2 to $fp-448
	# _tmp183 = i + _tmp182
	  lw $t0, -8($fp)	# fill i to $t0 from $fp-8
	  lw $t1, -448($fp)	# fill _tmp182 to $t1 from $fp-448
	  add $t2, $t0, $t1	
	  sw $t2, -452($fp)	# spill _tmp183 from $t2 to $fp-452
	# i = _tmp183
	  lw $t2, -452($fp)	# fill _tmp183 to $t2 from $fp-452
	  sw $t2, -8($fp)	# spill i from $t2 to $fp-8
	# Goto _L17
	  b _L17		# unconditional branch
  _L18:
	# EndFunc
	# (below handles reaching end of fn body with no explicit return)
	  move $sp, $fp		# pop callee frame off stack
	  lw $ra, -4($fp)	# restore saved ra
	  lw $fp, 0($fp)	# restore saved fp
	  jr $ra		# return from function
  Grid.____Full:
	# BeginFunc 208
	  subu $sp, $sp, 8	# decrement sp to make space to save ra, fp
	  sw $fp, 8($sp)	# save fp
	  sw $ra, 4($sp)	# save ra
	  addiu $fp, $sp, 8	# set up new fp
	  subu $sp, $sp, 208	# decrement sp to make space for locals/temps
	# _tmp184 = 1
	  li $t2, 1		# load constant value 1 into $t2
	  sw $t2, -20($fp)	# spill _tmp184 from $t2 to $fp-20
	# full = _tmp184
	  lw $t2, -20($fp)	# fill _tmp184 to $t2 from $fp-20
	  sw $t2, -16($fp)	# spill full from $t2 to $fp-16
	# _tmp185 = 0
	  li $t2, 0		# load constant value 0 into $t2
	  sw $t2, -24($fp)	# spill _tmp185 from $t2 to $fp-24
	# i = _tmp185
	  lw $t2, -24($fp)	# fill _tmp185 to $t2 from $fp-24
	  sw $t2, -8($fp)	# spill i from $t2 to $fp-8
  _L25:
	# _tmp186 = 3
	  li $t2, 3		# load constant value 3 into $t2
	  sw $t2, -28($fp)	# spill _tmp186 from $t2 to $fp-28
	# _tmp187 = i < _tmp186
	  lw $t0, -8($fp)	# fill i to $t0 from $fp-8
	  lw $t1, -28($fp)	# fill _tmp186 to $t1 from $fp-28
	  slt $t2, $t0, $t1	
	  sw $t2, -32($fp)	# spill _tmp187 from $t2 to $fp-32
	# IfZ _tmp187 Goto _L26
	  lw $t0, -32($fp)	# fill _tmp187 to $t0 from $fp-32
	  beqz $t0, _L26	# branch if _tmp187 is zero 
	# _tmp188 = 0
	  li $t2, 0		# load constant value 0 into $t2
	  sw $t2, -36($fp)	# spill _tmp188 from $t2 to $fp-36
	# j = _tmp188
	  lw $t2, -36($fp)	# fill _tmp188 to $t2 from $fp-36
	  sw $t2, -12($fp)	# spill j from $t2 to $fp-12
  _L27:
	# _tmp189 = 3
	  li $t2, 3		# load constant value 3 into $t2
	  sw $t2, -40($fp)	# spill _tmp189 from $t2 to $fp-40
	# _tmp190 = j < _tmp189
	  lw $t0, -12($fp)	# fill j to $t0 from $fp-12
	  lw $t1, -40($fp)	# fill _tmp189 to $t1 from $fp-40
	  slt $t2, $t0, $t1	
	  sw $t2, -44($fp)	# spill _tmp190 from $t2 to $fp-44
	# IfZ _tmp190 Goto _L28
	  lw $t0, -44($fp)	# fill _tmp190 to $t0 from $fp-44
	  beqz $t0, _L28	# branch if _tmp190 is zero 
	# _tmp191 = *(this + 4)
	  lw $t0, 4($fp)	# fill this to $t0 from $fp+4
	  lw $t2, 4($t0) 	# load with offset
	  sw $t2, -48($fp)	# spill _tmp191 from $t2 to $fp-48
	# _tmp192 = 0
	  li $t2, 0		# load constant value 0 into $t2
	  sw $t2, -52($fp)	# spill _tmp192 from $t2 to $fp-52
	# _tmp193 = *(_tmp191)
	  lw $t0, -48($fp)	# fill _tmp191 to $t0 from $fp-48
	  lw $t2, 0($t0) 	# load with offset
	  sw $t2, -56($fp)	# spill _tmp193 from $t2 to $fp-56
	# _tmp194 = i < _tmp192
	  lw $t0, -8($fp)	# fill i to $t0 from $fp-8
	  lw $t1, -52($fp)	# fill _tmp192 to $t1 from $fp-52
	  slt $t2, $t0, $t1	
	  sw $t2, -60($fp)	# spill _tmp194 from $t2 to $fp-60
	# _tmp195 = _tmp193 < i
	  lw $t0, -56($fp)	# fill _tmp193 to $t0 from $fp-56
	  lw $t1, -8($fp)	# fill i to $t1 from $fp-8
	  slt $t2, $t0, $t1	
	  sw $t2, -64($fp)	# spill _tmp195 from $t2 to $fp-64
	# _tmp196 = _tmp193 == i
	  lw $t0, -56($fp)	# fill _tmp193 to $t0 from $fp-56
	  lw $t1, -8($fp)	# fill i to $t1 from $fp-8
	  seq $t2, $t0, $t1	
	  sw $t2, -68($fp)	# spill _tmp196 from $t2 to $fp-68
	# _tmp197 = _tmp195 || _tmp196
	  lw $t0, -64($fp)	# fill _tmp195 to $t0 from $fp-64
	  lw $t1, -68($fp)	# fill _tmp196 to $t1 from $fp-68
	  or $t2, $t0, $t1	
	  sw $t2, -72($fp)	# spill _tmp197 from $t2 to $fp-72
	# _tmp198 = _tmp197 || _tmp194
	  lw $t0, -72($fp)	# fill _tmp197 to $t0 from $fp-72
	  lw $t1, -60($fp)	# fill _tmp194 to $t1 from $fp-60
	  or $t2, $t0, $t1	
	  sw $t2, -76($fp)	# spill _tmp198 from $t2 to $fp-76
	# IfZ _tmp198 Goto _L31
	  lw $t0, -76($fp)	# fill _tmp198 to $t0 from $fp-76
	  beqz $t0, _L31	# branch if _tmp198 is zero 
	# _tmp199 = "Decaf runtime error: Array subscript out of bound..."
	  .data			# create string constant marked with label
	  _string17: .asciiz "Decaf runtime error: Array subscript out of bounds\n"
	  .text
	  la $t2, _string17	# load label
	  sw $t2, -80($fp)	# spill _tmp199 from $t2 to $fp-80
	# PushParam _tmp199
	  subu $sp, $sp, 4	# decrement sp to make space for param
	  lw $t0, -80($fp)	# fill _tmp199 to $t0 from $fp-80
	  sw $t0, 4($sp)	# copy param value to stack
	# LCall _PrintString
	  jal _PrintString   	# jump to function
	# PopParams 4
	  add $sp, $sp, 4	# pop params off stack
	# LCall _Halt
	  jal _Halt          	# jump to function
  _L31:
	# _tmp200 = 4
	  li $t2, 4		# load constant value 4 into $t2
	  sw $t2, -84($fp)	# spill _tmp200 from $t2 to $fp-84
	# _tmp201 = i * _tmp200
	  lw $t0, -8($fp)	# fill i to $t0 from $fp-8
	  lw $t1, -84($fp)	# fill _tmp200 to $t1 from $fp-84
	  mul $t2, $t0, $t1	
	  sw $t2, -88($fp)	# spill _tmp201 from $t2 to $fp-88
	# _tmp202 = _tmp201 + _tmp200
	  lw $t0, -88($fp)	# fill _tmp201 to $t0 from $fp-88
	  lw $t1, -84($fp)	# fill _tmp200 to $t1 from $fp-84
	  add $t2, $t0, $t1	
	  sw $t2, -92($fp)	# spill _tmp202 from $t2 to $fp-92
	# _tmp203 = _tmp191 + _tmp202
	  lw $t0, -48($fp)	# fill _tmp191 to $t0 from $fp-48
	  lw $t1, -92($fp)	# fill _tmp202 to $t1 from $fp-92
	  add $t2, $t0, $t1	
	  sw $t2, -96($fp)	# spill _tmp203 from $t2 to $fp-96
	# _tmp204 = *(_tmp203)
	  lw $t0, -96($fp)	# fill _tmp203 to $t0 from $fp-96
	  lw $t2, 0($t0) 	# load with offset
	  sw $t2, -100($fp)	# spill _tmp204 from $t2 to $fp-100
	# _tmp205 = 0
	  li $t2, 0		# load constant value 0 into $t2
	  sw $t2, -104($fp)	# spill _tmp205 from $t2 to $fp-104
	# _tmp206 = *(_tmp204)
	  lw $t0, -100($fp)	# fill _tmp204 to $t0 from $fp-100
	  lw $t2, 0($t0) 	# load with offset
	  sw $t2, -108($fp)	# spill _tmp206 from $t2 to $fp-108
	# _tmp207 = j < _tmp205
	  lw $t0, -12($fp)	# fill j to $t0 from $fp-12
	  lw $t1, -104($fp)	# fill _tmp205 to $t1 from $fp-104
	  slt $t2, $t0, $t1	
	  sw $t2, -112($fp)	# spill _tmp207 from $t2 to $fp-112
	# _tmp208 = _tmp206 < j
	  lw $t0, -108($fp)	# fill _tmp206 to $t0 from $fp-108
	  lw $t1, -12($fp)	# fill j to $t1 from $fp-12
	  slt $t2, $t0, $t1	
	  sw $t2, -116($fp)	# spill _tmp208 from $t2 to $fp-116
	# _tmp209 = _tmp206 == j
	  lw $t0, -108($fp)	# fill _tmp206 to $t0 from $fp-108
	  lw $t1, -12($fp)	# fill j to $t1 from $fp-12
	  seq $t2, $t0, $t1	
	  sw $t2, -120($fp)	# spill _tmp209 from $t2 to $fp-120
	# _tmp210 = _tmp208 || _tmp209
	  lw $t0, -116($fp)	# fill _tmp208 to $t0 from $fp-116
	  lw $t1, -120($fp)	# fill _tmp209 to $t1 from $fp-120
	  or $t2, $t0, $t1	
	  sw $t2, -124($fp)	# spill _tmp210 from $t2 to $fp-124
	# _tmp211 = _tmp210 || _tmp207
	  lw $t0, -124($fp)	# fill _tmp210 to $t0 from $fp-124
	  lw $t1, -112($fp)	# fill _tmp207 to $t1 from $fp-112
	  or $t2, $t0, $t1	
	  sw $t2, -128($fp)	# spill _tmp211 from $t2 to $fp-128
	# IfZ _tmp211 Goto _L32
	  lw $t0, -128($fp)	# fill _tmp211 to $t0 from $fp-128
	  beqz $t0, _L32	# branch if _tmp211 is zero 
	# _tmp212 = "Decaf runtime error: Array subscript out of bound..."
	  .data			# create string constant marked with label
	  _string18: .asciiz "Decaf runtime error: Array subscript out of bounds\n"
	  .text
	  la $t2, _string18	# load label
	  sw $t2, -132($fp)	# spill _tmp212 from $t2 to $fp-132
	# PushParam _tmp212
	  subu $sp, $sp, 4	# decrement sp to make space for param
	  lw $t0, -132($fp)	# fill _tmp212 to $t0 from $fp-132
	  sw $t0, 4($sp)	# copy param value to stack
	# LCall _PrintString
	  jal _PrintString   	# jump to function
	# PopParams 4
	  add $sp, $sp, 4	# pop params off stack
	# LCall _Halt
	  jal _Halt          	# jump to function
  _L32:
	# _tmp213 = 4
	  li $t2, 4		# load constant value 4 into $t2
	  sw $t2, -136($fp)	# spill _tmp213 from $t2 to $fp-136
	# _tmp214 = j * _tmp213
	  lw $t0, -12($fp)	# fill j to $t0 from $fp-12
	  lw $t1, -136($fp)	# fill _tmp213 to $t1 from $fp-136
	  mul $t2, $t0, $t1	
	  sw $t2, -140($fp)	# spill _tmp214 from $t2 to $fp-140
	# _tmp215 = _tmp214 + _tmp213
	  lw $t0, -140($fp)	# fill _tmp214 to $t0 from $fp-140
	  lw $t1, -136($fp)	# fill _tmp213 to $t1 from $fp-136
	  add $t2, $t0, $t1	
	  sw $t2, -144($fp)	# spill _tmp215 from $t2 to $fp-144
	# _tmp216 = _tmp204 + _tmp215
	  lw $t0, -100($fp)	# fill _tmp204 to $t0 from $fp-100
	  lw $t1, -144($fp)	# fill _tmp215 to $t1 from $fp-144
	  add $t2, $t0, $t1	
	  sw $t2, -148($fp)	# spill _tmp216 from $t2 to $fp-148
	# _tmp217 = *(_tmp216)
	  lw $t0, -148($fp)	# fill _tmp216 to $t0 from $fp-148
	  lw $t2, 0($t0) 	# load with offset
	  sw $t2, -152($fp)	# spill _tmp217 from $t2 to $fp-152
	# PushParam _tmp217
	  subu $sp, $sp, 4	# decrement sp to make space for param
	  lw $t0, -152($fp)	# fill _tmp217 to $t0 from $fp-152
	  sw $t0, 4($sp)	# copy param value to stack
	# _tmp218 = *(_tmp217)
	  lw $t0, -152($fp)	# fill _tmp217 to $t0 from $fp-152
	  lw $t2, 0($t0) 	# load with offset
	  sw $t2, -156($fp)	# spill _tmp218 from $t2 to $fp-156
	# _tmp219 = *(_tmp218 + 12)
	  lw $t0, -156($fp)	# fill _tmp218 to $t0 from $fp-156
	  lw $t2, 12($t0) 	# load with offset
	  sw $t2, -160($fp)	# spill _tmp219 from $t2 to $fp-160
	# _tmp220 = ACall _tmp219
	  lw $t0, -160($fp)	# fill _tmp219 to $t0 from $fp-160
	  jalr $t0            	# jump to function
	  move $t2, $v0		# copy function return value from $v0
	  sw $t2, -164($fp)	# spill _tmp220 from $t2 to $fp-164
	# PopParams 4
	  add $sp, $sp, 4	# pop params off stack
	# IfZ _tmp220 Goto _L29
	  lw $t0, -164($fp)	# fill _tmp220 to $t0 from $fp-164
	  beqz $t0, _L29	# branch if _tmp220 is zero 
	# _tmp221 = 0
	  li $t2, 0		# load constant value 0 into $t2
	  sw $t2, -168($fp)	# spill _tmp221 from $t2 to $fp-168
	# full = _tmp221
	  lw $t2, -168($fp)	# fill _tmp221 to $t2 from $fp-168
	  sw $t2, -16($fp)	# spill full from $t2 to $fp-16
	# Goto _L30
	  b _L30		# unconditional branch
  _L29:
  _L30:
	# _tmp222 = 1
	  li $t2, 1		# load constant value 1 into $t2
	  sw $t2, -172($fp)	# spill _tmp222 from $t2 to $fp-172
	# _tmp223 = j + _tmp222
	  lw $t0, -12($fp)	# fill j to $t0 from $fp-12
	  lw $t1, -172($fp)	# fill _tmp222 to $t1 from $fp-172
	  add $t2, $t0, $t1	
	  sw $t2, -176($fp)	# spill _tmp223 from $t2 to $fp-176
	# j = _tmp223
	  lw $t2, -176($fp)	# fill _tmp223 to $t2 from $fp-176
	  sw $t2, -12($fp)	# spill j from $t2 to $fp-12
	# Goto _L27
	  b _L27		# unconditional branch
  _L28:
	# _tmp224 = 1
	  li $t2, 1		# load constant value 1 into $t2
	  sw $t2, -180($fp)	# spill _tmp224 from $t2 to $fp-180
	# _tmp225 = i + _tmp224
	  lw $t0, -8($fp)	# fill i to $t0 from $fp-8
	  lw $t1, -180($fp)	# fill _tmp224 to $t1 from $fp-180
	  add $t2, $t0, $t1	
	  sw $t2, -184($fp)	# spill _tmp225 from $t2 to $fp-184
	# i = _tmp225
	  lw $t2, -184($fp)	# fill _tmp225 to $t2 from $fp-184
	  sw $t2, -8($fp)	# spill i from $t2 to $fp-8
	# Goto _L25
	  b _L25		# unconditional branch
  _L26:
	# Return full
	  lw $t2, -16($fp)	# fill full to $t2 from $fp-16
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
  Grid.____Draw:
	# BeginFunc 248
	  subu $sp, $sp, 8	# decrement sp to make space to save ra, fp
	  sw $fp, 8($sp)	# save fp
	  sw $ra, 4($sp)	# save ra
	  addiu $fp, $sp, 8	# set up new fp
	  subu $sp, $sp, 248	# decrement sp to make space for locals/temps
	# _tmp226 = 0
	  li $t2, 0		# load constant value 0 into $t2
	  sw $t2, -20($fp)	# spill _tmp226 from $t2 to $fp-20
	# i = _tmp226
	  lw $t2, -20($fp)	# fill _tmp226 to $t2 from $fp-20
	  sw $t2, -8($fp)	# spill i from $t2 to $fp-8
	# _tmp227 = "  1   2   3\n"
	  .data			# create string constant marked with label
	  _string19: .asciiz "  1   2   3\n"
	  .text
	  la $t2, _string19	# load label
	  sw $t2, -24($fp)	# spill _tmp227 from $t2 to $fp-24
	# PushParam _tmp227
	  subu $sp, $sp, 4	# decrement sp to make space for param
	  lw $t0, -24($fp)	# fill _tmp227 to $t0 from $fp-24
	  sw $t0, 4($sp)	# copy param value to stack
	# LCall _PrintString
	  jal _PrintString   	# jump to function
	# PopParams 4
	  add $sp, $sp, 4	# pop params off stack
  _L33:
	# _tmp228 = 3
	  li $t2, 3		# load constant value 3 into $t2
	  sw $t2, -28($fp)	# spill _tmp228 from $t2 to $fp-28
	# _tmp229 = i < _tmp228
	  lw $t0, -8($fp)	# fill i to $t0 from $fp-8
	  lw $t1, -28($fp)	# fill _tmp228 to $t1 from $fp-28
	  slt $t2, $t0, $t1	
	  sw $t2, -32($fp)	# spill _tmp229 from $t2 to $fp-32
	# IfZ _tmp229 Goto _L34
	  lw $t0, -32($fp)	# fill _tmp229 to $t0 from $fp-32
	  beqz $t0, _L34	# branch if _tmp229 is zero 
	# _tmp230 = 1
	  li $t2, 1		# load constant value 1 into $t2
	  sw $t2, -36($fp)	# spill _tmp230 from $t2 to $fp-36
	# _tmp231 = i + _tmp230
	  lw $t0, -8($fp)	# fill i to $t0 from $fp-8
	  lw $t1, -36($fp)	# fill _tmp230 to $t1 from $fp-36
	  add $t2, $t0, $t1	
	  sw $t2, -40($fp)	# spill _tmp231 from $t2 to $fp-40
	# rowToPrint = _tmp231
	  lw $t2, -40($fp)	# fill _tmp231 to $t2 from $fp-40
	  sw $t2, -16($fp)	# spill rowToPrint from $t2 to $fp-16
	# PushParam rowToPrint
	  subu $sp, $sp, 4	# decrement sp to make space for param
	  lw $t0, -16($fp)	# fill rowToPrint to $t0 from $fp-16
	  sw $t0, 4($sp)	# copy param value to stack
	# LCall _PrintInt
	  jal _PrintInt      	# jump to function
	# PopParams 4
	  add $sp, $sp, 4	# pop params off stack
	# _tmp232 = 0
	  li $t2, 0		# load constant value 0 into $t2
	  sw $t2, -44($fp)	# spill _tmp232 from $t2 to $fp-44
	# j = _tmp232
	  lw $t2, -44($fp)	# fill _tmp232 to $t2 from $fp-44
	  sw $t2, -12($fp)	# spill j from $t2 to $fp-12
  _L35:
	# _tmp233 = 3
	  li $t2, 3		# load constant value 3 into $t2
	  sw $t2, -48($fp)	# spill _tmp233 from $t2 to $fp-48
	# _tmp234 = j < _tmp233
	  lw $t0, -12($fp)	# fill j to $t0 from $fp-12
	  lw $t1, -48($fp)	# fill _tmp233 to $t1 from $fp-48
	  slt $t2, $t0, $t1	
	  sw $t2, -52($fp)	# spill _tmp234 from $t2 to $fp-52
	# IfZ _tmp234 Goto _L36
	  lw $t0, -52($fp)	# fill _tmp234 to $t0 from $fp-52
	  beqz $t0, _L36	# branch if _tmp234 is zero 
	# _tmp235 = *(this + 4)
	  lw $t0, 4($fp)	# fill this to $t0 from $fp+4
	  lw $t2, 4($t0) 	# load with offset
	  sw $t2, -56($fp)	# spill _tmp235 from $t2 to $fp-56
	# _tmp236 = 0
	  li $t2, 0		# load constant value 0 into $t2
	  sw $t2, -60($fp)	# spill _tmp236 from $t2 to $fp-60
	# _tmp237 = *(_tmp235)
	  lw $t0, -56($fp)	# fill _tmp235 to $t0 from $fp-56
	  lw $t2, 0($t0) 	# load with offset
	  sw $t2, -64($fp)	# spill _tmp237 from $t2 to $fp-64
	# _tmp238 = i < _tmp236
	  lw $t0, -8($fp)	# fill i to $t0 from $fp-8
	  lw $t1, -60($fp)	# fill _tmp236 to $t1 from $fp-60
	  slt $t2, $t0, $t1	
	  sw $t2, -68($fp)	# spill _tmp238 from $t2 to $fp-68
	# _tmp239 = _tmp237 < i
	  lw $t0, -64($fp)	# fill _tmp237 to $t0 from $fp-64
	  lw $t1, -8($fp)	# fill i to $t1 from $fp-8
	  slt $t2, $t0, $t1	
	  sw $t2, -72($fp)	# spill _tmp239 from $t2 to $fp-72
	# _tmp240 = _tmp237 == i
	  lw $t0, -64($fp)	# fill _tmp237 to $t0 from $fp-64
	  lw $t1, -8($fp)	# fill i to $t1 from $fp-8
	  seq $t2, $t0, $t1	
	  sw $t2, -76($fp)	# spill _tmp240 from $t2 to $fp-76
	# _tmp241 = _tmp239 || _tmp240
	  lw $t0, -72($fp)	# fill _tmp239 to $t0 from $fp-72
	  lw $t1, -76($fp)	# fill _tmp240 to $t1 from $fp-76
	  or $t2, $t0, $t1	
	  sw $t2, -80($fp)	# spill _tmp241 from $t2 to $fp-80
	# _tmp242 = _tmp241 || _tmp238
	  lw $t0, -80($fp)	# fill _tmp241 to $t0 from $fp-80
	  lw $t1, -68($fp)	# fill _tmp238 to $t1 from $fp-68
	  or $t2, $t0, $t1	
	  sw $t2, -84($fp)	# spill _tmp242 from $t2 to $fp-84
	# IfZ _tmp242 Goto _L37
	  lw $t0, -84($fp)	# fill _tmp242 to $t0 from $fp-84
	  beqz $t0, _L37	# branch if _tmp242 is zero 
	# _tmp243 = "Decaf runtime error: Array subscript out of bound..."
	  .data			# create string constant marked with label
	  _string20: .asciiz "Decaf runtime error: Array subscript out of bounds\n"
	  .text
	  la $t2, _string20	# load label
	  sw $t2, -88($fp)	# spill _tmp243 from $t2 to $fp-88
	# PushParam _tmp243
	  subu $sp, $sp, 4	# decrement sp to make space for param
	  lw $t0, -88($fp)	# fill _tmp243 to $t0 from $fp-88
	  sw $t0, 4($sp)	# copy param value to stack
	# LCall _PrintString
	  jal _PrintString   	# jump to function
	# PopParams 4
	  add $sp, $sp, 4	# pop params off stack
	# LCall _Halt
	  jal _Halt          	# jump to function
  _L37:
	# _tmp244 = 4
	  li $t2, 4		# load constant value 4 into $t2
	  sw $t2, -92($fp)	# spill _tmp244 from $t2 to $fp-92
	# _tmp245 = i * _tmp244
	  lw $t0, -8($fp)	# fill i to $t0 from $fp-8
	  lw $t1, -92($fp)	# fill _tmp244 to $t1 from $fp-92
	  mul $t2, $t0, $t1	
	  sw $t2, -96($fp)	# spill _tmp245 from $t2 to $fp-96
	# _tmp246 = _tmp245 + _tmp244
	  lw $t0, -96($fp)	# fill _tmp245 to $t0 from $fp-96
	  lw $t1, -92($fp)	# fill _tmp244 to $t1 from $fp-92
	  add $t2, $t0, $t1	
	  sw $t2, -100($fp)	# spill _tmp246 from $t2 to $fp-100
	# _tmp247 = _tmp235 + _tmp246
	  lw $t0, -56($fp)	# fill _tmp235 to $t0 from $fp-56
	  lw $t1, -100($fp)	# fill _tmp246 to $t1 from $fp-100
	  add $t2, $t0, $t1	
	  sw $t2, -104($fp)	# spill _tmp247 from $t2 to $fp-104
	# _tmp248 = *(_tmp247)
	  lw $t0, -104($fp)	# fill _tmp247 to $t0 from $fp-104
	  lw $t2, 0($t0) 	# load with offset
	  sw $t2, -108($fp)	# spill _tmp248 from $t2 to $fp-108
	# _tmp249 = 0
	  li $t2, 0		# load constant value 0 into $t2
	  sw $t2, -112($fp)	# spill _tmp249 from $t2 to $fp-112
	# _tmp250 = *(_tmp248)
	  lw $t0, -108($fp)	# fill _tmp248 to $t0 from $fp-108
	  lw $t2, 0($t0) 	# load with offset
	  sw $t2, -116($fp)	# spill _tmp250 from $t2 to $fp-116
	# _tmp251 = j < _tmp249
	  lw $t0, -12($fp)	# fill j to $t0 from $fp-12
	  lw $t1, -112($fp)	# fill _tmp249 to $t1 from $fp-112
	  slt $t2, $t0, $t1	
	  sw $t2, -120($fp)	# spill _tmp251 from $t2 to $fp-120
	# _tmp252 = _tmp250 < j
	  lw $t0, -116($fp)	# fill _tmp250 to $t0 from $fp-116
	  lw $t1, -12($fp)	# fill j to $t1 from $fp-12
	  slt $t2, $t0, $t1	
	  sw $t2, -124($fp)	# spill _tmp252 from $t2 to $fp-124
	# _tmp253 = _tmp250 == j
	  lw $t0, -116($fp)	# fill _tmp250 to $t0 from $fp-116
	  lw $t1, -12($fp)	# fill j to $t1 from $fp-12
	  seq $t2, $t0, $t1	
	  sw $t2, -128($fp)	# spill _tmp253 from $t2 to $fp-128
	# _tmp254 = _tmp252 || _tmp253
	  lw $t0, -124($fp)	# fill _tmp252 to $t0 from $fp-124
	  lw $t1, -128($fp)	# fill _tmp253 to $t1 from $fp-128
	  or $t2, $t0, $t1	
	  sw $t2, -132($fp)	# spill _tmp254 from $t2 to $fp-132
	# _tmp255 = _tmp254 || _tmp251
	  lw $t0, -132($fp)	# fill _tmp254 to $t0 from $fp-132
	  lw $t1, -120($fp)	# fill _tmp251 to $t1 from $fp-120
	  or $t2, $t0, $t1	
	  sw $t2, -136($fp)	# spill _tmp255 from $t2 to $fp-136
	# IfZ _tmp255 Goto _L38
	  lw $t0, -136($fp)	# fill _tmp255 to $t0 from $fp-136
	  beqz $t0, _L38	# branch if _tmp255 is zero 
	# _tmp256 = "Decaf runtime error: Array subscript out of bound..."
	  .data			# create string constant marked with label
	  _string21: .asciiz "Decaf runtime error: Array subscript out of bounds\n"
	  .text
	  la $t2, _string21	# load label
	  sw $t2, -140($fp)	# spill _tmp256 from $t2 to $fp-140
	# PushParam _tmp256
	  subu $sp, $sp, 4	# decrement sp to make space for param
	  lw $t0, -140($fp)	# fill _tmp256 to $t0 from $fp-140
	  sw $t0, 4($sp)	# copy param value to stack
	# LCall _PrintString
	  jal _PrintString   	# jump to function
	# PopParams 4
	  add $sp, $sp, 4	# pop params off stack
	# LCall _Halt
	  jal _Halt          	# jump to function
  _L38:
	# _tmp257 = 4
	  li $t2, 4		# load constant value 4 into $t2
	  sw $t2, -144($fp)	# spill _tmp257 from $t2 to $fp-144
	# _tmp258 = j * _tmp257
	  lw $t0, -12($fp)	# fill j to $t0 from $fp-12
	  lw $t1, -144($fp)	# fill _tmp257 to $t1 from $fp-144
	  mul $t2, $t0, $t1	
	  sw $t2, -148($fp)	# spill _tmp258 from $t2 to $fp-148
	# _tmp259 = _tmp258 + _tmp257
	  lw $t0, -148($fp)	# fill _tmp258 to $t0 from $fp-148
	  lw $t1, -144($fp)	# fill _tmp257 to $t1 from $fp-144
	  add $t2, $t0, $t1	
	  sw $t2, -152($fp)	# spill _tmp259 from $t2 to $fp-152
	# _tmp260 = _tmp248 + _tmp259
	  lw $t0, -108($fp)	# fill _tmp248 to $t0 from $fp-108
	  lw $t1, -152($fp)	# fill _tmp259 to $t1 from $fp-152
	  add $t2, $t0, $t1	
	  sw $t2, -156($fp)	# spill _tmp260 from $t2 to $fp-156
	# _tmp261 = *(_tmp260)
	  lw $t0, -156($fp)	# fill _tmp260 to $t0 from $fp-156
	  lw $t2, 0($t0) 	# load with offset
	  sw $t2, -160($fp)	# spill _tmp261 from $t2 to $fp-160
	# PushParam _tmp261
	  subu $sp, $sp, 4	# decrement sp to make space for param
	  lw $t0, -160($fp)	# fill _tmp261 to $t0 from $fp-160
	  sw $t0, 4($sp)	# copy param value to stack
	# _tmp262 = *(_tmp261)
	  lw $t0, -160($fp)	# fill _tmp261 to $t0 from $fp-160
	  lw $t2, 0($t0) 	# load with offset
	  sw $t2, -164($fp)	# spill _tmp262 from $t2 to $fp-164
	# _tmp263 = *(_tmp262 + 4)
	  lw $t0, -164($fp)	# fill _tmp262 to $t0 from $fp-164
	  lw $t2, 4($t0) 	# load with offset
	  sw $t2, -168($fp)	# spill _tmp263 from $t2 to $fp-168
	# ACall _tmp263
	  lw $t0, -168($fp)	# fill _tmp263 to $t0 from $fp-168
	  jalr $t0            	# jump to function
	# PopParams 4
	  add $sp, $sp, 4	# pop params off stack
	# _tmp264 = 1
	  li $t2, 1		# load constant value 1 into $t2
	  sw $t2, -172($fp)	# spill _tmp264 from $t2 to $fp-172
	# _tmp265 = j + _tmp264
	  lw $t0, -12($fp)	# fill j to $t0 from $fp-12
	  lw $t1, -172($fp)	# fill _tmp264 to $t1 from $fp-172
	  add $t2, $t0, $t1	
	  sw $t2, -176($fp)	# spill _tmp265 from $t2 to $fp-176
	# j = _tmp265
	  lw $t2, -176($fp)	# fill _tmp265 to $t2 from $fp-176
	  sw $t2, -12($fp)	# spill j from $t2 to $fp-12
	# _tmp266 = 3
	  li $t2, 3		# load constant value 3 into $t2
	  sw $t2, -180($fp)	# spill _tmp266 from $t2 to $fp-180
	# _tmp267 = j < _tmp266
	  lw $t0, -12($fp)	# fill j to $t0 from $fp-12
	  lw $t1, -180($fp)	# fill _tmp266 to $t1 from $fp-180
	  slt $t2, $t0, $t1	
	  sw $t2, -184($fp)	# spill _tmp267 from $t2 to $fp-184
	# IfZ _tmp267 Goto _L39
	  lw $t0, -184($fp)	# fill _tmp267 to $t0 from $fp-184
	  beqz $t0, _L39	# branch if _tmp267 is zero 
	# _tmp268 = "|"
	  .data			# create string constant marked with label
	  _string22: .asciiz "|"
	  .text
	  la $t2, _string22	# load label
	  sw $t2, -188($fp)	# spill _tmp268 from $t2 to $fp-188
	# PushParam _tmp268
	  subu $sp, $sp, 4	# decrement sp to make space for param
	  lw $t0, -188($fp)	# fill _tmp268 to $t0 from $fp-188
	  sw $t0, 4($sp)	# copy param value to stack
	# LCall _PrintString
	  jal _PrintString   	# jump to function
	# PopParams 4
	  add $sp, $sp, 4	# pop params off stack
	# Goto _L40
	  b _L40		# unconditional branch
  _L39:
  _L40:
	# Goto _L35
	  b _L35		# unconditional branch
  _L36:
	# _tmp269 = 1
	  li $t2, 1		# load constant value 1 into $t2
	  sw $t2, -192($fp)	# spill _tmp269 from $t2 to $fp-192
	# _tmp270 = i + _tmp269
	  lw $t0, -8($fp)	# fill i to $t0 from $fp-8
	  lw $t1, -192($fp)	# fill _tmp269 to $t1 from $fp-192
	  add $t2, $t0, $t1	
	  sw $t2, -196($fp)	# spill _tmp270 from $t2 to $fp-196
	# i = _tmp270
	  lw $t2, -196($fp)	# fill _tmp270 to $t2 from $fp-196
	  sw $t2, -8($fp)	# spill i from $t2 to $fp-8
	# _tmp271 = "\n"
	  .data			# create string constant marked with label
	  _string23: .asciiz "\n"
	  .text
	  la $t2, _string23	# load label
	  sw $t2, -200($fp)	# spill _tmp271 from $t2 to $fp-200
	# PushParam _tmp271
	  subu $sp, $sp, 4	# decrement sp to make space for param
	  lw $t0, -200($fp)	# fill _tmp271 to $t0 from $fp-200
	  sw $t0, 4($sp)	# copy param value to stack
	# LCall _PrintString
	  jal _PrintString   	# jump to function
	# PopParams 4
	  add $sp, $sp, 4	# pop params off stack
	# _tmp272 = 3
	  li $t2, 3		# load constant value 3 into $t2
	  sw $t2, -204($fp)	# spill _tmp272 from $t2 to $fp-204
	# _tmp273 = i < _tmp272
	  lw $t0, -8($fp)	# fill i to $t0 from $fp-8
	  lw $t1, -204($fp)	# fill _tmp272 to $t1 from $fp-204
	  slt $t2, $t0, $t1	
	  sw $t2, -208($fp)	# spill _tmp273 from $t2 to $fp-208
	# IfZ _tmp273 Goto _L41
	  lw $t0, -208($fp)	# fill _tmp273 to $t0 from $fp-208
	  beqz $t0, _L41	# branch if _tmp273 is zero 
	# _tmp274 = " ---+---+---\n"
	  .data			# create string constant marked with label
	  _string24: .asciiz " ---+---+---\n"
	  .text
	  la $t2, _string24	# load label
	  sw $t2, -212($fp)	# spill _tmp274 from $t2 to $fp-212
	# PushParam _tmp274
	  subu $sp, $sp, 4	# decrement sp to make space for param
	  lw $t0, -212($fp)	# fill _tmp274 to $t0 from $fp-212
	  sw $t0, 4($sp)	# copy param value to stack
	# LCall _PrintString
	  jal _PrintString   	# jump to function
	# PopParams 4
	  add $sp, $sp, 4	# pop params off stack
	# Goto _L42
	  b _L42		# unconditional branch
  _L41:
  _L42:
	# Goto _L33
	  b _L33		# unconditional branch
  _L34:
	# EndFunc
	# (below handles reaching end of fn body with no explicit return)
	  move $sp, $fp		# pop callee frame off stack
	  lw $ra, -4($fp)	# restore saved ra
	  lw $fp, 0($fp)	# restore saved fp
	  jr $ra		# return from function
  Grid.____Update:
	# BeginFunc 244
	  subu $sp, $sp, 8	# decrement sp to make space to save ra, fp
	  sw $fp, 8($sp)	# save fp
	  sw $ra, 4($sp)	# save ra
	  addiu $fp, $sp, 8	# set up new fp
	  subu $sp, $sp, 244	# decrement sp to make space for locals/temps
	# _tmp275 = 0
	  li $t2, 0		# load constant value 0 into $t2
	  sw $t2, -8($fp)	# spill _tmp275 from $t2 to $fp-8
	# PushParam _tmp275
	  subu $sp, $sp, 4	# decrement sp to make space for param
	  lw $t0, -8($fp)	# fill _tmp275 to $t0 from $fp-8
	  sw $t0, 4($sp)	# copy param value to stack
	# _tmp276 = *(this + 4)
	  lw $t0, 4($fp)	# fill this to $t0 from $fp+4
	  lw $t2, 4($t0) 	# load with offset
	  sw $t2, -12($fp)	# spill _tmp276 from $t2 to $fp-12
	# _tmp277 = 0
	  li $t2, 0		# load constant value 0 into $t2
	  sw $t2, -16($fp)	# spill _tmp277 from $t2 to $fp-16
	# _tmp278 = *(_tmp276)
	  lw $t0, -12($fp)	# fill _tmp276 to $t0 from $fp-12
	  lw $t2, 0($t0) 	# load with offset
	  sw $t2, -20($fp)	# spill _tmp278 from $t2 to $fp-20
	# _tmp279 = row < _tmp277
	  lw $t0, 8($fp)	# fill row to $t0 from $fp+8
	  lw $t1, -16($fp)	# fill _tmp277 to $t1 from $fp-16
	  slt $t2, $t0, $t1	
	  sw $t2, -24($fp)	# spill _tmp279 from $t2 to $fp-24
	# _tmp280 = _tmp278 < row
	  lw $t0, -20($fp)	# fill _tmp278 to $t0 from $fp-20
	  lw $t1, 8($fp)	# fill row to $t1 from $fp+8
	  slt $t2, $t0, $t1	
	  sw $t2, -28($fp)	# spill _tmp280 from $t2 to $fp-28
	# _tmp281 = _tmp278 == row
	  lw $t0, -20($fp)	# fill _tmp278 to $t0 from $fp-20
	  lw $t1, 8($fp)	# fill row to $t1 from $fp+8
	  seq $t2, $t0, $t1	
	  sw $t2, -32($fp)	# spill _tmp281 from $t2 to $fp-32
	# _tmp282 = _tmp280 || _tmp281
	  lw $t0, -28($fp)	# fill _tmp280 to $t0 from $fp-28
	  lw $t1, -32($fp)	# fill _tmp281 to $t1 from $fp-32
	  or $t2, $t0, $t1	
	  sw $t2, -36($fp)	# spill _tmp282 from $t2 to $fp-36
	# _tmp283 = _tmp282 || _tmp279
	  lw $t0, -36($fp)	# fill _tmp282 to $t0 from $fp-36
	  lw $t1, -24($fp)	# fill _tmp279 to $t1 from $fp-24
	  or $t2, $t0, $t1	
	  sw $t2, -40($fp)	# spill _tmp283 from $t2 to $fp-40
	# IfZ _tmp283 Goto _L43
	  lw $t0, -40($fp)	# fill _tmp283 to $t0 from $fp-40
	  beqz $t0, _L43	# branch if _tmp283 is zero 
	# _tmp284 = "Decaf runtime error: Array subscript out of bound..."
	  .data			# create string constant marked with label
	  _string25: .asciiz "Decaf runtime error: Array subscript out of bounds\n"
	  .text
	  la $t2, _string25	# load label
	  sw $t2, -44($fp)	# spill _tmp284 from $t2 to $fp-44
	# PushParam _tmp284
	  subu $sp, $sp, 4	# decrement sp to make space for param
	  lw $t0, -44($fp)	# fill _tmp284 to $t0 from $fp-44
	  sw $t0, 4($sp)	# copy param value to stack
	# LCall _PrintString
	  jal _PrintString   	# jump to function
	# PopParams 4
	  add $sp, $sp, 4	# pop params off stack
	# LCall _Halt
	  jal _Halt          	# jump to function
  _L43:
	# _tmp285 = 4
	  li $t2, 4		# load constant value 4 into $t2
	  sw $t2, -48($fp)	# spill _tmp285 from $t2 to $fp-48
	# _tmp286 = row * _tmp285
	  lw $t0, 8($fp)	# fill row to $t0 from $fp+8
	  lw $t1, -48($fp)	# fill _tmp285 to $t1 from $fp-48
	  mul $t2, $t0, $t1	
	  sw $t2, -52($fp)	# spill _tmp286 from $t2 to $fp-52
	# _tmp287 = _tmp286 + _tmp285
	  lw $t0, -52($fp)	# fill _tmp286 to $t0 from $fp-52
	  lw $t1, -48($fp)	# fill _tmp285 to $t1 from $fp-48
	  add $t2, $t0, $t1	
	  sw $t2, -56($fp)	# spill _tmp287 from $t2 to $fp-56
	# _tmp288 = _tmp276 + _tmp287
	  lw $t0, -12($fp)	# fill _tmp276 to $t0 from $fp-12
	  lw $t1, -56($fp)	# fill _tmp287 to $t1 from $fp-56
	  add $t2, $t0, $t1	
	  sw $t2, -60($fp)	# spill _tmp288 from $t2 to $fp-60
	# _tmp289 = *(_tmp288)
	  lw $t0, -60($fp)	# fill _tmp288 to $t0 from $fp-60
	  lw $t2, 0($t0) 	# load with offset
	  sw $t2, -64($fp)	# spill _tmp289 from $t2 to $fp-64
	# _tmp290 = 0
	  li $t2, 0		# load constant value 0 into $t2
	  sw $t2, -68($fp)	# spill _tmp290 from $t2 to $fp-68
	# _tmp291 = *(_tmp289)
	  lw $t0, -64($fp)	# fill _tmp289 to $t0 from $fp-64
	  lw $t2, 0($t0) 	# load with offset
	  sw $t2, -72($fp)	# spill _tmp291 from $t2 to $fp-72
	# _tmp292 = column < _tmp290
	  lw $t0, 12($fp)	# fill column to $t0 from $fp+12
	  lw $t1, -68($fp)	# fill _tmp290 to $t1 from $fp-68
	  slt $t2, $t0, $t1	
	  sw $t2, -76($fp)	# spill _tmp292 from $t2 to $fp-76
	# _tmp293 = _tmp291 < column
	  lw $t0, -72($fp)	# fill _tmp291 to $t0 from $fp-72
	  lw $t1, 12($fp)	# fill column to $t1 from $fp+12
	  slt $t2, $t0, $t1	
	  sw $t2, -80($fp)	# spill _tmp293 from $t2 to $fp-80
	# _tmp294 = _tmp291 == column
	  lw $t0, -72($fp)	# fill _tmp291 to $t0 from $fp-72
	  lw $t1, 12($fp)	# fill column to $t1 from $fp+12
	  seq $t2, $t0, $t1	
	  sw $t2, -84($fp)	# spill _tmp294 from $t2 to $fp-84
	# _tmp295 = _tmp293 || _tmp294
	  lw $t0, -80($fp)	# fill _tmp293 to $t0 from $fp-80
	  lw $t1, -84($fp)	# fill _tmp294 to $t1 from $fp-84
	  or $t2, $t0, $t1	
	  sw $t2, -88($fp)	# spill _tmp295 from $t2 to $fp-88
	# _tmp296 = _tmp295 || _tmp292
	  lw $t0, -88($fp)	# fill _tmp295 to $t0 from $fp-88
	  lw $t1, -76($fp)	# fill _tmp292 to $t1 from $fp-76
	  or $t2, $t0, $t1	
	  sw $t2, -92($fp)	# spill _tmp296 from $t2 to $fp-92
	# IfZ _tmp296 Goto _L44
	  lw $t0, -92($fp)	# fill _tmp296 to $t0 from $fp-92
	  beqz $t0, _L44	# branch if _tmp296 is zero 
	# _tmp297 = "Decaf runtime error: Array subscript out of bound..."
	  .data			# create string constant marked with label
	  _string26: .asciiz "Decaf runtime error: Array subscript out of bounds\n"
	  .text
	  la $t2, _string26	# load label
	  sw $t2, -96($fp)	# spill _tmp297 from $t2 to $fp-96
	# PushParam _tmp297
	  subu $sp, $sp, 4	# decrement sp to make space for param
	  lw $t0, -96($fp)	# fill _tmp297 to $t0 from $fp-96
	  sw $t0, 4($sp)	# copy param value to stack
	# LCall _PrintString
	  jal _PrintString   	# jump to function
	# PopParams 4
	  add $sp, $sp, 4	# pop params off stack
	# LCall _Halt
	  jal _Halt          	# jump to function
  _L44:
	# _tmp298 = 4
	  li $t2, 4		# load constant value 4 into $t2
	  sw $t2, -100($fp)	# spill _tmp298 from $t2 to $fp-100
	# _tmp299 = column * _tmp298
	  lw $t0, 12($fp)	# fill column to $t0 from $fp+12
	  lw $t1, -100($fp)	# fill _tmp298 to $t1 from $fp-100
	  mul $t2, $t0, $t1	
	  sw $t2, -104($fp)	# spill _tmp299 from $t2 to $fp-104
	# _tmp300 = _tmp299 + _tmp298
	  lw $t0, -104($fp)	# fill _tmp299 to $t0 from $fp-104
	  lw $t1, -100($fp)	# fill _tmp298 to $t1 from $fp-100
	  add $t2, $t0, $t1	
	  sw $t2, -108($fp)	# spill _tmp300 from $t2 to $fp-108
	# _tmp301 = _tmp289 + _tmp300
	  lw $t0, -64($fp)	# fill _tmp289 to $t0 from $fp-64
	  lw $t1, -108($fp)	# fill _tmp300 to $t1 from $fp-108
	  add $t2, $t0, $t1	
	  sw $t2, -112($fp)	# spill _tmp301 from $t2 to $fp-112
	# _tmp302 = *(_tmp301)
	  lw $t0, -112($fp)	# fill _tmp301 to $t0 from $fp-112
	  lw $t2, 0($t0) 	# load with offset
	  sw $t2, -116($fp)	# spill _tmp302 from $t2 to $fp-116
	# PushParam _tmp302
	  subu $sp, $sp, 4	# decrement sp to make space for param
	  lw $t0, -116($fp)	# fill _tmp302 to $t0 from $fp-116
	  sw $t0, 4($sp)	# copy param value to stack
	# _tmp303 = *(_tmp302)
	  lw $t0, -116($fp)	# fill _tmp302 to $t0 from $fp-116
	  lw $t2, 0($t0) 	# load with offset
	  sw $t2, -120($fp)	# spill _tmp303 from $t2 to $fp-120
	# _tmp304 = *(_tmp303 + 8)
	  lw $t0, -120($fp)	# fill _tmp303 to $t0 from $fp-120
	  lw $t2, 8($t0) 	# load with offset
	  sw $t2, -124($fp)	# spill _tmp304 from $t2 to $fp-124
	# ACall _tmp304
	  lw $t0, -124($fp)	# fill _tmp304 to $t0 from $fp-124
	  jalr $t0            	# jump to function
	# PopParams 8
	  add $sp, $sp, 8	# pop params off stack
	# PushParam mark
	  subu $sp, $sp, 4	# decrement sp to make space for param
	  lw $t0, 16($fp)	# fill mark to $t0 from $fp+16
	  sw $t0, 4($sp)	# copy param value to stack
	# _tmp305 = *(this + 4)
	  lw $t0, 4($fp)	# fill this to $t0 from $fp+4
	  lw $t2, 4($t0) 	# load with offset
	  sw $t2, -128($fp)	# spill _tmp305 from $t2 to $fp-128
	# _tmp306 = 0
	  li $t2, 0		# load constant value 0 into $t2
	  sw $t2, -132($fp)	# spill _tmp306 from $t2 to $fp-132
	# _tmp307 = *(_tmp305)
	  lw $t0, -128($fp)	# fill _tmp305 to $t0 from $fp-128
	  lw $t2, 0($t0) 	# load with offset
	  sw $t2, -136($fp)	# spill _tmp307 from $t2 to $fp-136
	# _tmp308 = row < _tmp306
	  lw $t0, 8($fp)	# fill row to $t0 from $fp+8
	  lw $t1, -132($fp)	# fill _tmp306 to $t1 from $fp-132
	  slt $t2, $t0, $t1	
	  sw $t2, -140($fp)	# spill _tmp308 from $t2 to $fp-140
	# _tmp309 = _tmp307 < row
	  lw $t0, -136($fp)	# fill _tmp307 to $t0 from $fp-136
	  lw $t1, 8($fp)	# fill row to $t1 from $fp+8
	  slt $t2, $t0, $t1	
	  sw $t2, -144($fp)	# spill _tmp309 from $t2 to $fp-144
	# _tmp310 = _tmp307 == row
	  lw $t0, -136($fp)	# fill _tmp307 to $t0 from $fp-136
	  lw $t1, 8($fp)	# fill row to $t1 from $fp+8
	  seq $t2, $t0, $t1	
	  sw $t2, -148($fp)	# spill _tmp310 from $t2 to $fp-148
	# _tmp311 = _tmp309 || _tmp310
	  lw $t0, -144($fp)	# fill _tmp309 to $t0 from $fp-144
	  lw $t1, -148($fp)	# fill _tmp310 to $t1 from $fp-148
	  or $t2, $t0, $t1	
	  sw $t2, -152($fp)	# spill _tmp311 from $t2 to $fp-152
	# _tmp312 = _tmp311 || _tmp308
	  lw $t0, -152($fp)	# fill _tmp311 to $t0 from $fp-152
	  lw $t1, -140($fp)	# fill _tmp308 to $t1 from $fp-140
	  or $t2, $t0, $t1	
	  sw $t2, -156($fp)	# spill _tmp312 from $t2 to $fp-156
	# IfZ _tmp312 Goto _L45
	  lw $t0, -156($fp)	# fill _tmp312 to $t0 from $fp-156
	  beqz $t0, _L45	# branch if _tmp312 is zero 
	# _tmp313 = "Decaf runtime error: Array subscript out of bound..."
	  .data			# create string constant marked with label
	  _string27: .asciiz "Decaf runtime error: Array subscript out of bounds\n"
	  .text
	  la $t2, _string27	# load label
	  sw $t2, -160($fp)	# spill _tmp313 from $t2 to $fp-160
	# PushParam _tmp313
	  subu $sp, $sp, 4	# decrement sp to make space for param
	  lw $t0, -160($fp)	# fill _tmp313 to $t0 from $fp-160
	  sw $t0, 4($sp)	# copy param value to stack
	# LCall _PrintString
	  jal _PrintString   	# jump to function
	# PopParams 4
	  add $sp, $sp, 4	# pop params off stack
	# LCall _Halt
	  jal _Halt          	# jump to function
  _L45:
	# _tmp314 = 4
	  li $t2, 4		# load constant value 4 into $t2
	  sw $t2, -164($fp)	# spill _tmp314 from $t2 to $fp-164
	# _tmp315 = row * _tmp314
	  lw $t0, 8($fp)	# fill row to $t0 from $fp+8
	  lw $t1, -164($fp)	# fill _tmp314 to $t1 from $fp-164
	  mul $t2, $t0, $t1	
	  sw $t2, -168($fp)	# spill _tmp315 from $t2 to $fp-168
	# _tmp316 = _tmp315 + _tmp314
	  lw $t0, -168($fp)	# fill _tmp315 to $t0 from $fp-168
	  lw $t1, -164($fp)	# fill _tmp314 to $t1 from $fp-164
	  add $t2, $t0, $t1	
	  sw $t2, -172($fp)	# spill _tmp316 from $t2 to $fp-172
	# _tmp317 = _tmp305 + _tmp316
	  lw $t0, -128($fp)	# fill _tmp305 to $t0 from $fp-128
	  lw $t1, -172($fp)	# fill _tmp316 to $t1 from $fp-172
	  add $t2, $t0, $t1	
	  sw $t2, -176($fp)	# spill _tmp317 from $t2 to $fp-176
	# _tmp318 = *(_tmp317)
	  lw $t0, -176($fp)	# fill _tmp317 to $t0 from $fp-176
	  lw $t2, 0($t0) 	# load with offset
	  sw $t2, -180($fp)	# spill _tmp318 from $t2 to $fp-180
	# _tmp319 = 0
	  li $t2, 0		# load constant value 0 into $t2
	  sw $t2, -184($fp)	# spill _tmp319 from $t2 to $fp-184
	# _tmp320 = *(_tmp318)
	  lw $t0, -180($fp)	# fill _tmp318 to $t0 from $fp-180
	  lw $t2, 0($t0) 	# load with offset
	  sw $t2, -188($fp)	# spill _tmp320 from $t2 to $fp-188
	# _tmp321 = column < _tmp319
	  lw $t0, 12($fp)	# fill column to $t0 from $fp+12
	  lw $t1, -184($fp)	# fill _tmp319 to $t1 from $fp-184
	  slt $t2, $t0, $t1	
	  sw $t2, -192($fp)	# spill _tmp321 from $t2 to $fp-192
	# _tmp322 = _tmp320 < column
	  lw $t0, -188($fp)	# fill _tmp320 to $t0 from $fp-188
	  lw $t1, 12($fp)	# fill column to $t1 from $fp+12
	  slt $t2, $t0, $t1	
	  sw $t2, -196($fp)	# spill _tmp322 from $t2 to $fp-196
	# _tmp323 = _tmp320 == column
	  lw $t0, -188($fp)	# fill _tmp320 to $t0 from $fp-188
	  lw $t1, 12($fp)	# fill column to $t1 from $fp+12
	  seq $t2, $t0, $t1	
	  sw $t2, -200($fp)	# spill _tmp323 from $t2 to $fp-200
	# _tmp324 = _tmp322 || _tmp323
	  lw $t0, -196($fp)	# fill _tmp322 to $t0 from $fp-196
	  lw $t1, -200($fp)	# fill _tmp323 to $t1 from $fp-200
	  or $t2, $t0, $t1	
	  sw $t2, -204($fp)	# spill _tmp324 from $t2 to $fp-204
	# _tmp325 = _tmp324 || _tmp321
	  lw $t0, -204($fp)	# fill _tmp324 to $t0 from $fp-204
	  lw $t1, -192($fp)	# fill _tmp321 to $t1 from $fp-192
	  or $t2, $t0, $t1	
	  sw $t2, -208($fp)	# spill _tmp325 from $t2 to $fp-208
	# IfZ _tmp325 Goto _L46
	  lw $t0, -208($fp)	# fill _tmp325 to $t0 from $fp-208
	  beqz $t0, _L46	# branch if _tmp325 is zero 
	# _tmp326 = "Decaf runtime error: Array subscript out of bound..."
	  .data			# create string constant marked with label
	  _string28: .asciiz "Decaf runtime error: Array subscript out of bounds\n"
	  .text
	  la $t2, _string28	# load label
	  sw $t2, -212($fp)	# spill _tmp326 from $t2 to $fp-212
	# PushParam _tmp326
	  subu $sp, $sp, 4	# decrement sp to make space for param
	  lw $t0, -212($fp)	# fill _tmp326 to $t0 from $fp-212
	  sw $t0, 4($sp)	# copy param value to stack
	# LCall _PrintString
	  jal _PrintString   	# jump to function
	# PopParams 4
	  add $sp, $sp, 4	# pop params off stack
	# LCall _Halt
	  jal _Halt          	# jump to function
  _L46:
	# _tmp327 = 4
	  li $t2, 4		# load constant value 4 into $t2
	  sw $t2, -216($fp)	# spill _tmp327 from $t2 to $fp-216
	# _tmp328 = column * _tmp327
	  lw $t0, 12($fp)	# fill column to $t0 from $fp+12
	  lw $t1, -216($fp)	# fill _tmp327 to $t1 from $fp-216
	  mul $t2, $t0, $t1	
	  sw $t2, -220($fp)	# spill _tmp328 from $t2 to $fp-220
	# _tmp329 = _tmp328 + _tmp327
	  lw $t0, -220($fp)	# fill _tmp328 to $t0 from $fp-220
	  lw $t1, -216($fp)	# fill _tmp327 to $t1 from $fp-216
	  add $t2, $t0, $t1	
	  sw $t2, -224($fp)	# spill _tmp329 from $t2 to $fp-224
	# _tmp330 = _tmp318 + _tmp329
	  lw $t0, -180($fp)	# fill _tmp318 to $t0 from $fp-180
	  lw $t1, -224($fp)	# fill _tmp329 to $t1 from $fp-224
	  add $t2, $t0, $t1	
	  sw $t2, -228($fp)	# spill _tmp330 from $t2 to $fp-228
	# _tmp331 = *(_tmp330)
	  lw $t0, -228($fp)	# fill _tmp330 to $t0 from $fp-228
	  lw $t2, 0($t0) 	# load with offset
	  sw $t2, -232($fp)	# spill _tmp331 from $t2 to $fp-232
	# PushParam _tmp331
	  subu $sp, $sp, 4	# decrement sp to make space for param
	  lw $t0, -232($fp)	# fill _tmp331 to $t0 from $fp-232
	  sw $t0, 4($sp)	# copy param value to stack
	# _tmp332 = *(_tmp331)
	  lw $t0, -232($fp)	# fill _tmp331 to $t0 from $fp-232
	  lw $t2, 0($t0) 	# load with offset
	  sw $t2, -236($fp)	# spill _tmp332 from $t2 to $fp-236
	# _tmp333 = *(_tmp332 + 16)
	  lw $t0, -236($fp)	# fill _tmp332 to $t0 from $fp-236
	  lw $t2, 16($t0) 	# load with offset
	  sw $t2, -240($fp)	# spill _tmp333 from $t2 to $fp-240
	# ACall _tmp333
	  lw $t0, -240($fp)	# fill _tmp333 to $t0 from $fp-240
	  jalr $t0            	# jump to function
	# PopParams 8
	  add $sp, $sp, 8	# pop params off stack
	# PushParam this
	  subu $sp, $sp, 4	# decrement sp to make space for param
	  lw $t0, 4($fp)	# fill this to $t0 from $fp+4
	  sw $t0, 4($sp)	# copy param value to stack
	# _tmp334 = *(this)
	  lw $t0, 4($fp)	# fill this to $t0 from $fp+4
	  lw $t2, 0($t0) 	# load with offset
	  sw $t2, -244($fp)	# spill _tmp334 from $t2 to $fp-244
	# _tmp335 = *(_tmp334 + 8)
	  lw $t0, -244($fp)	# fill _tmp334 to $t0 from $fp-244
	  lw $t2, 8($t0) 	# load with offset
	  sw $t2, -248($fp)	# spill _tmp335 from $t2 to $fp-248
	# ACall _tmp335
	  lw $t0, -248($fp)	# fill _tmp335 to $t0 from $fp-248
	  jalr $t0            	# jump to function
	# PopParams 4
	  add $sp, $sp, 4	# pop params off stack
	# EndFunc
	# (below handles reaching end of fn body with no explicit return)
	  move $sp, $fp		# pop callee frame off stack
	  lw $ra, -4($fp)	# restore saved ra
	  lw $fp, 0($fp)	# restore saved fp
	  jr $ra		# return from function
  Grid.____IsMoveLegal:
	# BeginFunc 120
	  subu $sp, $sp, 8	# decrement sp to make space to save ra, fp
	  sw $fp, 8($sp)	# save fp
	  sw $ra, 4($sp)	# save ra
	  addiu $fp, $sp, 8	# set up new fp
	  subu $sp, $sp, 120	# decrement sp to make space for locals/temps
	# _tmp336 = *(this + 4)
	  lw $t0, 4($fp)	# fill this to $t0 from $fp+4
	  lw $t2, 4($t0) 	# load with offset
	  sw $t2, -8($fp)	# spill _tmp336 from $t2 to $fp-8
	# _tmp337 = 0
	  li $t2, 0		# load constant value 0 into $t2
	  sw $t2, -12($fp)	# spill _tmp337 from $t2 to $fp-12
	# _tmp338 = *(_tmp336)
	  lw $t0, -8($fp)	# fill _tmp336 to $t0 from $fp-8
	  lw $t2, 0($t0) 	# load with offset
	  sw $t2, -16($fp)	# spill _tmp338 from $t2 to $fp-16
	# _tmp339 = row < _tmp337
	  lw $t0, 8($fp)	# fill row to $t0 from $fp+8
	  lw $t1, -12($fp)	# fill _tmp337 to $t1 from $fp-12
	  slt $t2, $t0, $t1	
	  sw $t2, -20($fp)	# spill _tmp339 from $t2 to $fp-20
	# _tmp340 = _tmp338 < row
	  lw $t0, -16($fp)	# fill _tmp338 to $t0 from $fp-16
	  lw $t1, 8($fp)	# fill row to $t1 from $fp+8
	  slt $t2, $t0, $t1	
	  sw $t2, -24($fp)	# spill _tmp340 from $t2 to $fp-24
	# _tmp341 = _tmp338 == row
	  lw $t0, -16($fp)	# fill _tmp338 to $t0 from $fp-16
	  lw $t1, 8($fp)	# fill row to $t1 from $fp+8
	  seq $t2, $t0, $t1	
	  sw $t2, -28($fp)	# spill _tmp341 from $t2 to $fp-28
	# _tmp342 = _tmp340 || _tmp341
	  lw $t0, -24($fp)	# fill _tmp340 to $t0 from $fp-24
	  lw $t1, -28($fp)	# fill _tmp341 to $t1 from $fp-28
	  or $t2, $t0, $t1	
	  sw $t2, -32($fp)	# spill _tmp342 from $t2 to $fp-32
	# _tmp343 = _tmp342 || _tmp339
	  lw $t0, -32($fp)	# fill _tmp342 to $t0 from $fp-32
	  lw $t1, -20($fp)	# fill _tmp339 to $t1 from $fp-20
	  or $t2, $t0, $t1	
	  sw $t2, -36($fp)	# spill _tmp343 from $t2 to $fp-36
	# IfZ _tmp343 Goto _L47
	  lw $t0, -36($fp)	# fill _tmp343 to $t0 from $fp-36
	  beqz $t0, _L47	# branch if _tmp343 is zero 
	# _tmp344 = "Decaf runtime error: Array subscript out of bound..."
	  .data			# create string constant marked with label
	  _string29: .asciiz "Decaf runtime error: Array subscript out of bounds\n"
	  .text
	  la $t2, _string29	# load label
	  sw $t2, -40($fp)	# spill _tmp344 from $t2 to $fp-40
	# PushParam _tmp344
	  subu $sp, $sp, 4	# decrement sp to make space for param
	  lw $t0, -40($fp)	# fill _tmp344 to $t0 from $fp-40
	  sw $t0, 4($sp)	# copy param value to stack
	# LCall _PrintString
	  jal _PrintString   	# jump to function
	# PopParams 4
	  add $sp, $sp, 4	# pop params off stack
	# LCall _Halt
	  jal _Halt          	# jump to function
  _L47:
	# _tmp345 = 4
	  li $t2, 4		# load constant value 4 into $t2
	  sw $t2, -44($fp)	# spill _tmp345 from $t2 to $fp-44
	# _tmp346 = row * _tmp345
	  lw $t0, 8($fp)	# fill row to $t0 from $fp+8
	  lw $t1, -44($fp)	# fill _tmp345 to $t1 from $fp-44
	  mul $t2, $t0, $t1	
	  sw $t2, -48($fp)	# spill _tmp346 from $t2 to $fp-48
	# _tmp347 = _tmp346 + _tmp345
	  lw $t0, -48($fp)	# fill _tmp346 to $t0 from $fp-48
	  lw $t1, -44($fp)	# fill _tmp345 to $t1 from $fp-44
	  add $t2, $t0, $t1	
	  sw $t2, -52($fp)	# spill _tmp347 from $t2 to $fp-52
	# _tmp348 = _tmp336 + _tmp347
	  lw $t0, -8($fp)	# fill _tmp336 to $t0 from $fp-8
	  lw $t1, -52($fp)	# fill _tmp347 to $t1 from $fp-52
	  add $t2, $t0, $t1	
	  sw $t2, -56($fp)	# spill _tmp348 from $t2 to $fp-56
	# _tmp349 = *(_tmp348)
	  lw $t0, -56($fp)	# fill _tmp348 to $t0 from $fp-56
	  lw $t2, 0($t0) 	# load with offset
	  sw $t2, -60($fp)	# spill _tmp349 from $t2 to $fp-60
	# _tmp350 = 0
	  li $t2, 0		# load constant value 0 into $t2
	  sw $t2, -64($fp)	# spill _tmp350 from $t2 to $fp-64
	# _tmp351 = *(_tmp349)
	  lw $t0, -60($fp)	# fill _tmp349 to $t0 from $fp-60
	  lw $t2, 0($t0) 	# load with offset
	  sw $t2, -68($fp)	# spill _tmp351 from $t2 to $fp-68
	# _tmp352 = column < _tmp350
	  lw $t0, 12($fp)	# fill column to $t0 from $fp+12
	  lw $t1, -64($fp)	# fill _tmp350 to $t1 from $fp-64
	  slt $t2, $t0, $t1	
	  sw $t2, -72($fp)	# spill _tmp352 from $t2 to $fp-72
	# _tmp353 = _tmp351 < column
	  lw $t0, -68($fp)	# fill _tmp351 to $t0 from $fp-68
	  lw $t1, 12($fp)	# fill column to $t1 from $fp+12
	  slt $t2, $t0, $t1	
	  sw $t2, -76($fp)	# spill _tmp353 from $t2 to $fp-76
	# _tmp354 = _tmp351 == column
	  lw $t0, -68($fp)	# fill _tmp351 to $t0 from $fp-68
	  lw $t1, 12($fp)	# fill column to $t1 from $fp+12
	  seq $t2, $t0, $t1	
	  sw $t2, -80($fp)	# spill _tmp354 from $t2 to $fp-80
	# _tmp355 = _tmp353 || _tmp354
	  lw $t0, -76($fp)	# fill _tmp353 to $t0 from $fp-76
	  lw $t1, -80($fp)	# fill _tmp354 to $t1 from $fp-80
	  or $t2, $t0, $t1	
	  sw $t2, -84($fp)	# spill _tmp355 from $t2 to $fp-84
	# _tmp356 = _tmp355 || _tmp352
	  lw $t0, -84($fp)	# fill _tmp355 to $t0 from $fp-84
	  lw $t1, -72($fp)	# fill _tmp352 to $t1 from $fp-72
	  or $t2, $t0, $t1	
	  sw $t2, -88($fp)	# spill _tmp356 from $t2 to $fp-88
	# IfZ _tmp356 Goto _L48
	  lw $t0, -88($fp)	# fill _tmp356 to $t0 from $fp-88
	  beqz $t0, _L48	# branch if _tmp356 is zero 
	# _tmp357 = "Decaf runtime error: Array subscript out of bound..."
	  .data			# create string constant marked with label
	  _string30: .asciiz "Decaf runtime error: Array subscript out of bounds\n"
	  .text
	  la $t2, _string30	# load label
	  sw $t2, -92($fp)	# spill _tmp357 from $t2 to $fp-92
	# PushParam _tmp357
	  subu $sp, $sp, 4	# decrement sp to make space for param
	  lw $t0, -92($fp)	# fill _tmp357 to $t0 from $fp-92
	  sw $t0, 4($sp)	# copy param value to stack
	# LCall _PrintString
	  jal _PrintString   	# jump to function
	# PopParams 4
	  add $sp, $sp, 4	# pop params off stack
	# LCall _Halt
	  jal _Halt          	# jump to function
  _L48:
	# _tmp358 = 4
	  li $t2, 4		# load constant value 4 into $t2
	  sw $t2, -96($fp)	# spill _tmp358 from $t2 to $fp-96
	# _tmp359 = column * _tmp358
	  lw $t0, 12($fp)	# fill column to $t0 from $fp+12
	  lw $t1, -96($fp)	# fill _tmp358 to $t1 from $fp-96
	  mul $t2, $t0, $t1	
	  sw $t2, -100($fp)	# spill _tmp359 from $t2 to $fp-100
	# _tmp360 = _tmp359 + _tmp358
	  lw $t0, -100($fp)	# fill _tmp359 to $t0 from $fp-100
	  lw $t1, -96($fp)	# fill _tmp358 to $t1 from $fp-96
	  add $t2, $t0, $t1	
	  sw $t2, -104($fp)	# spill _tmp360 from $t2 to $fp-104
	# _tmp361 = _tmp349 + _tmp360
	  lw $t0, -60($fp)	# fill _tmp349 to $t0 from $fp-60
	  lw $t1, -104($fp)	# fill _tmp360 to $t1 from $fp-104
	  add $t2, $t0, $t1	
	  sw $t2, -108($fp)	# spill _tmp361 from $t2 to $fp-108
	# _tmp362 = *(_tmp361)
	  lw $t0, -108($fp)	# fill _tmp361 to $t0 from $fp-108
	  lw $t2, 0($t0) 	# load with offset
	  sw $t2, -112($fp)	# spill _tmp362 from $t2 to $fp-112
	# PushParam _tmp362
	  subu $sp, $sp, 4	# decrement sp to make space for param
	  lw $t0, -112($fp)	# fill _tmp362 to $t0 from $fp-112
	  sw $t0, 4($sp)	# copy param value to stack
	# _tmp363 = *(_tmp362)
	  lw $t0, -112($fp)	# fill _tmp362 to $t0 from $fp-112
	  lw $t2, 0($t0) 	# load with offset
	  sw $t2, -116($fp)	# spill _tmp363 from $t2 to $fp-116
	# _tmp364 = *(_tmp363 + 12)
	  lw $t0, -116($fp)	# fill _tmp363 to $t0 from $fp-116
	  lw $t2, 12($t0) 	# load with offset
	  sw $t2, -120($fp)	# spill _tmp364 from $t2 to $fp-120
	# _tmp365 = ACall _tmp364
	  lw $t0, -120($fp)	# fill _tmp364 to $t0 from $fp-120
	  jalr $t0            	# jump to function
	  move $t2, $v0		# copy function return value from $v0
	  sw $t2, -124($fp)	# spill _tmp365 from $t2 to $fp-124
	# PopParams 4
	  add $sp, $sp, 4	# pop params off stack
	# Return _tmp365
	  lw $t2, -124($fp)	# fill _tmp365 to $t2 from $fp-124
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
  Grid.____GameNotWon:
	# BeginFunc 3284
	  subu $sp, $sp, 8	# decrement sp to make space to save ra, fp
	  sw $fp, 8($sp)	# save fp
	  sw $ra, 4($sp)	# save ra
	  addiu $fp, $sp, 8	# set up new fp
	  subu $sp, $sp, 3284	# decrement sp to make space for locals/temps
	# PushParam p
	  subu $sp, $sp, 4	# decrement sp to make space for param
	  lw $t0, 8($fp)	# fill p to $t0 from $fp+8
	  sw $t0, 4($sp)	# copy param value to stack
	# _tmp366 = *(p)
	  lw $t0, 8($fp)	# fill p to $t0 from $fp+8
	  lw $t2, 0($t0) 	# load with offset
	  sw $t2, -12($fp)	# spill _tmp366 from $t2 to $fp-12
	# _tmp367 = *(_tmp366)
	  lw $t0, -12($fp)	# fill _tmp366 to $t0 from $fp-12
	  lw $t2, 0($t0) 	# load with offset
	  sw $t2, -16($fp)	# spill _tmp367 from $t2 to $fp-16
	# _tmp368 = ACall _tmp367
	  lw $t0, -16($fp)	# fill _tmp367 to $t0 from $fp-16
	  jalr $t0            	# jump to function
	  move $t2, $v0		# copy function return value from $v0
	  sw $t2, -20($fp)	# spill _tmp368 from $t2 to $fp-20
	# PopParams 4
	  add $sp, $sp, 4	# pop params off stack
	# mark = _tmp368
	  lw $t2, -20($fp)	# fill _tmp368 to $t2 from $fp-20
	  sw $t2, -8($fp)	# spill mark from $t2 to $fp-8
	# PushParam mark
	  subu $sp, $sp, 4	# decrement sp to make space for param
	  lw $t0, -8($fp)	# fill mark to $t0 from $fp-8
	  sw $t0, 4($sp)	# copy param value to stack
	# _tmp369 = *(this + 4)
	  lw $t0, 4($fp)	# fill this to $t0 from $fp+4
	  lw $t2, 4($t0) 	# load with offset
	  sw $t2, -24($fp)	# spill _tmp369 from $t2 to $fp-24
	# _tmp370 = 0
	  li $t2, 0		# load constant value 0 into $t2
	  sw $t2, -28($fp)	# spill _tmp370 from $t2 to $fp-28
	# _tmp371 = 0
	  li $t2, 0		# load constant value 0 into $t2
	  sw $t2, -32($fp)	# spill _tmp371 from $t2 to $fp-32
	# _tmp372 = *(_tmp369)
	  lw $t0, -24($fp)	# fill _tmp369 to $t0 from $fp-24
	  lw $t2, 0($t0) 	# load with offset
	  sw $t2, -36($fp)	# spill _tmp372 from $t2 to $fp-36
	# _tmp373 = _tmp370 < _tmp371
	  lw $t0, -28($fp)	# fill _tmp370 to $t0 from $fp-28
	  lw $t1, -32($fp)	# fill _tmp371 to $t1 from $fp-32
	  slt $t2, $t0, $t1	
	  sw $t2, -40($fp)	# spill _tmp373 from $t2 to $fp-40
	# _tmp374 = _tmp372 < _tmp370
	  lw $t0, -36($fp)	# fill _tmp372 to $t0 from $fp-36
	  lw $t1, -28($fp)	# fill _tmp370 to $t1 from $fp-28
	  slt $t2, $t0, $t1	
	  sw $t2, -44($fp)	# spill _tmp374 from $t2 to $fp-44
	# _tmp375 = _tmp372 == _tmp370
	  lw $t0, -36($fp)	# fill _tmp372 to $t0 from $fp-36
	  lw $t1, -28($fp)	# fill _tmp370 to $t1 from $fp-28
	  seq $t2, $t0, $t1	
	  sw $t2, -48($fp)	# spill _tmp375 from $t2 to $fp-48
	# _tmp376 = _tmp374 || _tmp375
	  lw $t0, -44($fp)	# fill _tmp374 to $t0 from $fp-44
	  lw $t1, -48($fp)	# fill _tmp375 to $t1 from $fp-48
	  or $t2, $t0, $t1	
	  sw $t2, -52($fp)	# spill _tmp376 from $t2 to $fp-52
	# _tmp377 = _tmp376 || _tmp373
	  lw $t0, -52($fp)	# fill _tmp376 to $t0 from $fp-52
	  lw $t1, -40($fp)	# fill _tmp373 to $t1 from $fp-40
	  or $t2, $t0, $t1	
	  sw $t2, -56($fp)	# spill _tmp377 from $t2 to $fp-56
	# IfZ _tmp377 Goto _L51
	  lw $t0, -56($fp)	# fill _tmp377 to $t0 from $fp-56
	  beqz $t0, _L51	# branch if _tmp377 is zero 
	# _tmp378 = "Decaf runtime error: Array subscript out of bound..."
	  .data			# create string constant marked with label
	  _string31: .asciiz "Decaf runtime error: Array subscript out of bounds\n"
	  .text
	  la $t2, _string31	# load label
	  sw $t2, -60($fp)	# spill _tmp378 from $t2 to $fp-60
	# PushParam _tmp378
	  subu $sp, $sp, 4	# decrement sp to make space for param
	  lw $t0, -60($fp)	# fill _tmp378 to $t0 from $fp-60
	  sw $t0, 4($sp)	# copy param value to stack
	# LCall _PrintString
	  jal _PrintString   	# jump to function
	# PopParams 4
	  add $sp, $sp, 4	# pop params off stack
	# LCall _Halt
	  jal _Halt          	# jump to function
  _L51:
	# _tmp379 = 4
	  li $t2, 4		# load constant value 4 into $t2
	  sw $t2, -64($fp)	# spill _tmp379 from $t2 to $fp-64
	# _tmp380 = _tmp370 * _tmp379
	  lw $t0, -28($fp)	# fill _tmp370 to $t0 from $fp-28
	  lw $t1, -64($fp)	# fill _tmp379 to $t1 from $fp-64
	  mul $t2, $t0, $t1	
	  sw $t2, -68($fp)	# spill _tmp380 from $t2 to $fp-68
	# _tmp381 = _tmp380 + _tmp379
	  lw $t0, -68($fp)	# fill _tmp380 to $t0 from $fp-68
	  lw $t1, -64($fp)	# fill _tmp379 to $t1 from $fp-64
	  add $t2, $t0, $t1	
	  sw $t2, -72($fp)	# spill _tmp381 from $t2 to $fp-72
	# _tmp382 = _tmp369 + _tmp381
	  lw $t0, -24($fp)	# fill _tmp369 to $t0 from $fp-24
	  lw $t1, -72($fp)	# fill _tmp381 to $t1 from $fp-72
	  add $t2, $t0, $t1	
	  sw $t2, -76($fp)	# spill _tmp382 from $t2 to $fp-76
	# _tmp383 = *(_tmp382)
	  lw $t0, -76($fp)	# fill _tmp382 to $t0 from $fp-76
	  lw $t2, 0($t0) 	# load with offset
	  sw $t2, -80($fp)	# spill _tmp383 from $t2 to $fp-80
	# _tmp384 = 0
	  li $t2, 0		# load constant value 0 into $t2
	  sw $t2, -84($fp)	# spill _tmp384 from $t2 to $fp-84
	# _tmp385 = 0
	  li $t2, 0		# load constant value 0 into $t2
	  sw $t2, -88($fp)	# spill _tmp385 from $t2 to $fp-88
	# _tmp386 = *(_tmp383)
	  lw $t0, -80($fp)	# fill _tmp383 to $t0 from $fp-80
	  lw $t2, 0($t0) 	# load with offset
	  sw $t2, -92($fp)	# spill _tmp386 from $t2 to $fp-92
	# _tmp387 = _tmp384 < _tmp385
	  lw $t0, -84($fp)	# fill _tmp384 to $t0 from $fp-84
	  lw $t1, -88($fp)	# fill _tmp385 to $t1 from $fp-88
	  slt $t2, $t0, $t1	
	  sw $t2, -96($fp)	# spill _tmp387 from $t2 to $fp-96
	# _tmp388 = _tmp386 < _tmp384
	  lw $t0, -92($fp)	# fill _tmp386 to $t0 from $fp-92
	  lw $t1, -84($fp)	# fill _tmp384 to $t1 from $fp-84
	  slt $t2, $t0, $t1	
	  sw $t2, -100($fp)	# spill _tmp388 from $t2 to $fp-100
	# _tmp389 = _tmp386 == _tmp384
	  lw $t0, -92($fp)	# fill _tmp386 to $t0 from $fp-92
	  lw $t1, -84($fp)	# fill _tmp384 to $t1 from $fp-84
	  seq $t2, $t0, $t1	
	  sw $t2, -104($fp)	# spill _tmp389 from $t2 to $fp-104
	# _tmp390 = _tmp388 || _tmp389
	  lw $t0, -100($fp)	# fill _tmp388 to $t0 from $fp-100
	  lw $t1, -104($fp)	# fill _tmp389 to $t1 from $fp-104
	  or $t2, $t0, $t1	
	  sw $t2, -108($fp)	# spill _tmp390 from $t2 to $fp-108
	# _tmp391 = _tmp390 || _tmp387
	  lw $t0, -108($fp)	# fill _tmp390 to $t0 from $fp-108
	  lw $t1, -96($fp)	# fill _tmp387 to $t1 from $fp-96
	  or $t2, $t0, $t1	
	  sw $t2, -112($fp)	# spill _tmp391 from $t2 to $fp-112
	# IfZ _tmp391 Goto _L52
	  lw $t0, -112($fp)	# fill _tmp391 to $t0 from $fp-112
	  beqz $t0, _L52	# branch if _tmp391 is zero 
	# _tmp392 = "Decaf runtime error: Array subscript out of bound..."
	  .data			# create string constant marked with label
	  _string32: .asciiz "Decaf runtime error: Array subscript out of bounds\n"
	  .text
	  la $t2, _string32	# load label
	  sw $t2, -116($fp)	# spill _tmp392 from $t2 to $fp-116
	# PushParam _tmp392
	  subu $sp, $sp, 4	# decrement sp to make space for param
	  lw $t0, -116($fp)	# fill _tmp392 to $t0 from $fp-116
	  sw $t0, 4($sp)	# copy param value to stack
	# LCall _PrintString
	  jal _PrintString   	# jump to function
	# PopParams 4
	  add $sp, $sp, 4	# pop params off stack
	# LCall _Halt
	  jal _Halt          	# jump to function
  _L52:
	# _tmp393 = 4
	  li $t2, 4		# load constant value 4 into $t2
	  sw $t2, -120($fp)	# spill _tmp393 from $t2 to $fp-120
	# _tmp394 = _tmp384 * _tmp393
	  lw $t0, -84($fp)	# fill _tmp384 to $t0 from $fp-84
	  lw $t1, -120($fp)	# fill _tmp393 to $t1 from $fp-120
	  mul $t2, $t0, $t1	
	  sw $t2, -124($fp)	# spill _tmp394 from $t2 to $fp-124
	# _tmp395 = _tmp394 + _tmp393
	  lw $t0, -124($fp)	# fill _tmp394 to $t0 from $fp-124
	  lw $t1, -120($fp)	# fill _tmp393 to $t1 from $fp-120
	  add $t2, $t0, $t1	
	  sw $t2, -128($fp)	# spill _tmp395 from $t2 to $fp-128
	# _tmp396 = _tmp383 + _tmp395
	  lw $t0, -80($fp)	# fill _tmp383 to $t0 from $fp-80
	  lw $t1, -128($fp)	# fill _tmp395 to $t1 from $fp-128
	  add $t2, $t0, $t1	
	  sw $t2, -132($fp)	# spill _tmp396 from $t2 to $fp-132
	# _tmp397 = *(_tmp396)
	  lw $t0, -132($fp)	# fill _tmp396 to $t0 from $fp-132
	  lw $t2, 0($t0) 	# load with offset
	  sw $t2, -136($fp)	# spill _tmp397 from $t2 to $fp-136
	# PushParam _tmp397
	  subu $sp, $sp, 4	# decrement sp to make space for param
	  lw $t0, -136($fp)	# fill _tmp397 to $t0 from $fp-136
	  sw $t0, 4($sp)	# copy param value to stack
	# _tmp398 = *(_tmp397)
	  lw $t0, -136($fp)	# fill _tmp397 to $t0 from $fp-136
	  lw $t2, 0($t0) 	# load with offset
	  sw $t2, -140($fp)	# spill _tmp398 from $t2 to $fp-140
	# _tmp399 = *(_tmp398 + 20)
	  lw $t0, -140($fp)	# fill _tmp398 to $t0 from $fp-140
	  lw $t2, 20($t0) 	# load with offset
	  sw $t2, -144($fp)	# spill _tmp399 from $t2 to $fp-144
	# _tmp400 = ACall _tmp399
	  lw $t0, -144($fp)	# fill _tmp399 to $t0 from $fp-144
	  jalr $t0            	# jump to function
	  move $t2, $v0		# copy function return value from $v0
	  sw $t2, -148($fp)	# spill _tmp400 from $t2 to $fp-148
	# PopParams 8
	  add $sp, $sp, 8	# pop params off stack
	# PushParam mark
	  subu $sp, $sp, 4	# decrement sp to make space for param
	  lw $t0, -8($fp)	# fill mark to $t0 from $fp-8
	  sw $t0, 4($sp)	# copy param value to stack
	# _tmp401 = *(this + 4)
	  lw $t0, 4($fp)	# fill this to $t0 from $fp+4
	  lw $t2, 4($t0) 	# load with offset
	  sw $t2, -152($fp)	# spill _tmp401 from $t2 to $fp-152
	# _tmp402 = 0
	  li $t2, 0		# load constant value 0 into $t2
	  sw $t2, -156($fp)	# spill _tmp402 from $t2 to $fp-156
	# _tmp403 = 0
	  li $t2, 0		# load constant value 0 into $t2
	  sw $t2, -160($fp)	# spill _tmp403 from $t2 to $fp-160
	# _tmp404 = *(_tmp401)
	  lw $t0, -152($fp)	# fill _tmp401 to $t0 from $fp-152
	  lw $t2, 0($t0) 	# load with offset
	  sw $t2, -164($fp)	# spill _tmp404 from $t2 to $fp-164
	# _tmp405 = _tmp402 < _tmp403
	  lw $t0, -156($fp)	# fill _tmp402 to $t0 from $fp-156
	  lw $t1, -160($fp)	# fill _tmp403 to $t1 from $fp-160
	  slt $t2, $t0, $t1	
	  sw $t2, -168($fp)	# spill _tmp405 from $t2 to $fp-168
	# _tmp406 = _tmp404 < _tmp402
	  lw $t0, -164($fp)	# fill _tmp404 to $t0 from $fp-164
	  lw $t1, -156($fp)	# fill _tmp402 to $t1 from $fp-156
	  slt $t2, $t0, $t1	
	  sw $t2, -172($fp)	# spill _tmp406 from $t2 to $fp-172
	# _tmp407 = _tmp404 == _tmp402
	  lw $t0, -164($fp)	# fill _tmp404 to $t0 from $fp-164
	  lw $t1, -156($fp)	# fill _tmp402 to $t1 from $fp-156
	  seq $t2, $t0, $t1	
	  sw $t2, -176($fp)	# spill _tmp407 from $t2 to $fp-176
	# _tmp408 = _tmp406 || _tmp407
	  lw $t0, -172($fp)	# fill _tmp406 to $t0 from $fp-172
	  lw $t1, -176($fp)	# fill _tmp407 to $t1 from $fp-176
	  or $t2, $t0, $t1	
	  sw $t2, -180($fp)	# spill _tmp408 from $t2 to $fp-180
	# _tmp409 = _tmp408 || _tmp405
	  lw $t0, -180($fp)	# fill _tmp408 to $t0 from $fp-180
	  lw $t1, -168($fp)	# fill _tmp405 to $t1 from $fp-168
	  or $t2, $t0, $t1	
	  sw $t2, -184($fp)	# spill _tmp409 from $t2 to $fp-184
	# IfZ _tmp409 Goto _L53
	  lw $t0, -184($fp)	# fill _tmp409 to $t0 from $fp-184
	  beqz $t0, _L53	# branch if _tmp409 is zero 
	# _tmp410 = "Decaf runtime error: Array subscript out of bound..."
	  .data			# create string constant marked with label
	  _string33: .asciiz "Decaf runtime error: Array subscript out of bounds\n"
	  .text
	  la $t2, _string33	# load label
	  sw $t2, -188($fp)	# spill _tmp410 from $t2 to $fp-188
	# PushParam _tmp410
	  subu $sp, $sp, 4	# decrement sp to make space for param
	  lw $t0, -188($fp)	# fill _tmp410 to $t0 from $fp-188
	  sw $t0, 4($sp)	# copy param value to stack
	# LCall _PrintString
	  jal _PrintString   	# jump to function
	# PopParams 4
	  add $sp, $sp, 4	# pop params off stack
	# LCall _Halt
	  jal _Halt          	# jump to function
  _L53:
	# _tmp411 = 4
	  li $t2, 4		# load constant value 4 into $t2
	  sw $t2, -192($fp)	# spill _tmp411 from $t2 to $fp-192
	# _tmp412 = _tmp402 * _tmp411
	  lw $t0, -156($fp)	# fill _tmp402 to $t0 from $fp-156
	  lw $t1, -192($fp)	# fill _tmp411 to $t1 from $fp-192
	  mul $t2, $t0, $t1	
	  sw $t2, -196($fp)	# spill _tmp412 from $t2 to $fp-196
	# _tmp413 = _tmp412 + _tmp411
	  lw $t0, -196($fp)	# fill _tmp412 to $t0 from $fp-196
	  lw $t1, -192($fp)	# fill _tmp411 to $t1 from $fp-192
	  add $t2, $t0, $t1	
	  sw $t2, -200($fp)	# spill _tmp413 from $t2 to $fp-200
	# _tmp414 = _tmp401 + _tmp413
	  lw $t0, -152($fp)	# fill _tmp401 to $t0 from $fp-152
	  lw $t1, -200($fp)	# fill _tmp413 to $t1 from $fp-200
	  add $t2, $t0, $t1	
	  sw $t2, -204($fp)	# spill _tmp414 from $t2 to $fp-204
	# _tmp415 = *(_tmp414)
	  lw $t0, -204($fp)	# fill _tmp414 to $t0 from $fp-204
	  lw $t2, 0($t0) 	# load with offset
	  sw $t2, -208($fp)	# spill _tmp415 from $t2 to $fp-208
	# _tmp416 = 1
	  li $t2, 1		# load constant value 1 into $t2
	  sw $t2, -212($fp)	# spill _tmp416 from $t2 to $fp-212
	# _tmp417 = 0
	  li $t2, 0		# load constant value 0 into $t2
	  sw $t2, -216($fp)	# spill _tmp417 from $t2 to $fp-216
	# _tmp418 = *(_tmp415)
	  lw $t0, -208($fp)	# fill _tmp415 to $t0 from $fp-208
	  lw $t2, 0($t0) 	# load with offset
	  sw $t2, -220($fp)	# spill _tmp418 from $t2 to $fp-220
	# _tmp419 = _tmp416 < _tmp417
	  lw $t0, -212($fp)	# fill _tmp416 to $t0 from $fp-212
	  lw $t1, -216($fp)	# fill _tmp417 to $t1 from $fp-216
	  slt $t2, $t0, $t1	
	  sw $t2, -224($fp)	# spill _tmp419 from $t2 to $fp-224
	# _tmp420 = _tmp418 < _tmp416
	  lw $t0, -220($fp)	# fill _tmp418 to $t0 from $fp-220
	  lw $t1, -212($fp)	# fill _tmp416 to $t1 from $fp-212
	  slt $t2, $t0, $t1	
	  sw $t2, -228($fp)	# spill _tmp420 from $t2 to $fp-228
	# _tmp421 = _tmp418 == _tmp416
	  lw $t0, -220($fp)	# fill _tmp418 to $t0 from $fp-220
	  lw $t1, -212($fp)	# fill _tmp416 to $t1 from $fp-212
	  seq $t2, $t0, $t1	
	  sw $t2, -232($fp)	# spill _tmp421 from $t2 to $fp-232
	# _tmp422 = _tmp420 || _tmp421
	  lw $t0, -228($fp)	# fill _tmp420 to $t0 from $fp-228
	  lw $t1, -232($fp)	# fill _tmp421 to $t1 from $fp-232
	  or $t2, $t0, $t1	
	  sw $t2, -236($fp)	# spill _tmp422 from $t2 to $fp-236
	# _tmp423 = _tmp422 || _tmp419
	  lw $t0, -236($fp)	# fill _tmp422 to $t0 from $fp-236
	  lw $t1, -224($fp)	# fill _tmp419 to $t1 from $fp-224
	  or $t2, $t0, $t1	
	  sw $t2, -240($fp)	# spill _tmp423 from $t2 to $fp-240
	# IfZ _tmp423 Goto _L54
	  lw $t0, -240($fp)	# fill _tmp423 to $t0 from $fp-240
	  beqz $t0, _L54	# branch if _tmp423 is zero 
	# _tmp424 = "Decaf runtime error: Array subscript out of bound..."
	  .data			# create string constant marked with label
	  _string34: .asciiz "Decaf runtime error: Array subscript out of bounds\n"
	  .text
	  la $t2, _string34	# load label
	  sw $t2, -244($fp)	# spill _tmp424 from $t2 to $fp-244
	# PushParam _tmp424
	  subu $sp, $sp, 4	# decrement sp to make space for param
	  lw $t0, -244($fp)	# fill _tmp424 to $t0 from $fp-244
	  sw $t0, 4($sp)	# copy param value to stack
	# LCall _PrintString
	  jal _PrintString   	# jump to function
	# PopParams 4
	  add $sp, $sp, 4	# pop params off stack
	# LCall _Halt
	  jal _Halt          	# jump to function
  _L54:
	# _tmp425 = 4
	  li $t2, 4		# load constant value 4 into $t2
	  sw $t2, -248($fp)	# spill _tmp425 from $t2 to $fp-248
	# _tmp426 = _tmp416 * _tmp425
	  lw $t0, -212($fp)	# fill _tmp416 to $t0 from $fp-212
	  lw $t1, -248($fp)	# fill _tmp425 to $t1 from $fp-248
	  mul $t2, $t0, $t1	
	  sw $t2, -252($fp)	# spill _tmp426 from $t2 to $fp-252
	# _tmp427 = _tmp426 + _tmp425
	  lw $t0, -252($fp)	# fill _tmp426 to $t0 from $fp-252
	  lw $t1, -248($fp)	# fill _tmp425 to $t1 from $fp-248
	  add $t2, $t0, $t1	
	  sw $t2, -256($fp)	# spill _tmp427 from $t2 to $fp-256
	# _tmp428 = _tmp415 + _tmp427
	  lw $t0, -208($fp)	# fill _tmp415 to $t0 from $fp-208
	  lw $t1, -256($fp)	# fill _tmp427 to $t1 from $fp-256
	  add $t2, $t0, $t1	
	  sw $t2, -260($fp)	# spill _tmp428 from $t2 to $fp-260
	# _tmp429 = *(_tmp428)
	  lw $t0, -260($fp)	# fill _tmp428 to $t0 from $fp-260
	  lw $t2, 0($t0) 	# load with offset
	  sw $t2, -264($fp)	# spill _tmp429 from $t2 to $fp-264
	# PushParam _tmp429
	  subu $sp, $sp, 4	# decrement sp to make space for param
	  lw $t0, -264($fp)	# fill _tmp429 to $t0 from $fp-264
	  sw $t0, 4($sp)	# copy param value to stack
	# _tmp430 = *(_tmp429)
	  lw $t0, -264($fp)	# fill _tmp429 to $t0 from $fp-264
	  lw $t2, 0($t0) 	# load with offset
	  sw $t2, -268($fp)	# spill _tmp430 from $t2 to $fp-268
	# _tmp431 = *(_tmp430 + 20)
	  lw $t0, -268($fp)	# fill _tmp430 to $t0 from $fp-268
	  lw $t2, 20($t0) 	# load with offset
	  sw $t2, -272($fp)	# spill _tmp431 from $t2 to $fp-272
	# _tmp432 = ACall _tmp431
	  lw $t0, -272($fp)	# fill _tmp431 to $t0 from $fp-272
	  jalr $t0            	# jump to function
	  move $t2, $v0		# copy function return value from $v0
	  sw $t2, -276($fp)	# spill _tmp432 from $t2 to $fp-276
	# PopParams 8
	  add $sp, $sp, 8	# pop params off stack
	# _tmp433 = _tmp400 && _tmp432
	  lw $t0, -148($fp)	# fill _tmp400 to $t0 from $fp-148
	  lw $t1, -276($fp)	# fill _tmp432 to $t1 from $fp-276
	  and $t2, $t0, $t1	
	  sw $t2, -280($fp)	# spill _tmp433 from $t2 to $fp-280
	# PushParam mark
	  subu $sp, $sp, 4	# decrement sp to make space for param
	  lw $t0, -8($fp)	# fill mark to $t0 from $fp-8
	  sw $t0, 4($sp)	# copy param value to stack
	# _tmp434 = *(this + 4)
	  lw $t0, 4($fp)	# fill this to $t0 from $fp+4
	  lw $t2, 4($t0) 	# load with offset
	  sw $t2, -284($fp)	# spill _tmp434 from $t2 to $fp-284
	# _tmp435 = 0
	  li $t2, 0		# load constant value 0 into $t2
	  sw $t2, -288($fp)	# spill _tmp435 from $t2 to $fp-288
	# _tmp436 = 0
	  li $t2, 0		# load constant value 0 into $t2
	  sw $t2, -292($fp)	# spill _tmp436 from $t2 to $fp-292
	# _tmp437 = *(_tmp434)
	  lw $t0, -284($fp)	# fill _tmp434 to $t0 from $fp-284
	  lw $t2, 0($t0) 	# load with offset
	  sw $t2, -296($fp)	# spill _tmp437 from $t2 to $fp-296
	# _tmp438 = _tmp435 < _tmp436
	  lw $t0, -288($fp)	# fill _tmp435 to $t0 from $fp-288
	  lw $t1, -292($fp)	# fill _tmp436 to $t1 from $fp-292
	  slt $t2, $t0, $t1	
	  sw $t2, -300($fp)	# spill _tmp438 from $t2 to $fp-300
	# _tmp439 = _tmp437 < _tmp435
	  lw $t0, -296($fp)	# fill _tmp437 to $t0 from $fp-296
	  lw $t1, -288($fp)	# fill _tmp435 to $t1 from $fp-288
	  slt $t2, $t0, $t1	
	  sw $t2, -304($fp)	# spill _tmp439 from $t2 to $fp-304
	# _tmp440 = _tmp437 == _tmp435
	  lw $t0, -296($fp)	# fill _tmp437 to $t0 from $fp-296
	  lw $t1, -288($fp)	# fill _tmp435 to $t1 from $fp-288
	  seq $t2, $t0, $t1	
	  sw $t2, -308($fp)	# spill _tmp440 from $t2 to $fp-308
	# _tmp441 = _tmp439 || _tmp440
	  lw $t0, -304($fp)	# fill _tmp439 to $t0 from $fp-304
	  lw $t1, -308($fp)	# fill _tmp440 to $t1 from $fp-308
	  or $t2, $t0, $t1	
	  sw $t2, -312($fp)	# spill _tmp441 from $t2 to $fp-312
	# _tmp442 = _tmp441 || _tmp438
	  lw $t0, -312($fp)	# fill _tmp441 to $t0 from $fp-312
	  lw $t1, -300($fp)	# fill _tmp438 to $t1 from $fp-300
	  or $t2, $t0, $t1	
	  sw $t2, -316($fp)	# spill _tmp442 from $t2 to $fp-316
	# IfZ _tmp442 Goto _L55
	  lw $t0, -316($fp)	# fill _tmp442 to $t0 from $fp-316
	  beqz $t0, _L55	# branch if _tmp442 is zero 
	# _tmp443 = "Decaf runtime error: Array subscript out of bound..."
	  .data			# create string constant marked with label
	  _string35: .asciiz "Decaf runtime error: Array subscript out of bounds\n"
	  .text
	  la $t2, _string35	# load label
	  sw $t2, -320($fp)	# spill _tmp443 from $t2 to $fp-320
	# PushParam _tmp443
	  subu $sp, $sp, 4	# decrement sp to make space for param
	  lw $t0, -320($fp)	# fill _tmp443 to $t0 from $fp-320
	  sw $t0, 4($sp)	# copy param value to stack
	# LCall _PrintString
	  jal _PrintString   	# jump to function
	# PopParams 4
	  add $sp, $sp, 4	# pop params off stack
	# LCall _Halt
	  jal _Halt          	# jump to function
  _L55:
	# _tmp444 = 4
	  li $t2, 4		# load constant value 4 into $t2
	  sw $t2, -324($fp)	# spill _tmp444 from $t2 to $fp-324
	# _tmp445 = _tmp435 * _tmp444
	  lw $t0, -288($fp)	# fill _tmp435 to $t0 from $fp-288
	  lw $t1, -324($fp)	# fill _tmp444 to $t1 from $fp-324
	  mul $t2, $t0, $t1	
	  sw $t2, -328($fp)	# spill _tmp445 from $t2 to $fp-328
	# _tmp446 = _tmp445 + _tmp444
	  lw $t0, -328($fp)	# fill _tmp445 to $t0 from $fp-328
	  lw $t1, -324($fp)	# fill _tmp444 to $t1 from $fp-324
	  add $t2, $t0, $t1	
	  sw $t2, -332($fp)	# spill _tmp446 from $t2 to $fp-332
	# _tmp447 = _tmp434 + _tmp446
	  lw $t0, -284($fp)	# fill _tmp434 to $t0 from $fp-284
	  lw $t1, -332($fp)	# fill _tmp446 to $t1 from $fp-332
	  add $t2, $t0, $t1	
	  sw $t2, -336($fp)	# spill _tmp447 from $t2 to $fp-336
	# _tmp448 = *(_tmp447)
	  lw $t0, -336($fp)	# fill _tmp447 to $t0 from $fp-336
	  lw $t2, 0($t0) 	# load with offset
	  sw $t2, -340($fp)	# spill _tmp448 from $t2 to $fp-340
	# _tmp449 = 2
	  li $t2, 2		# load constant value 2 into $t2
	  sw $t2, -344($fp)	# spill _tmp449 from $t2 to $fp-344
	# _tmp450 = 0
	  li $t2, 0		# load constant value 0 into $t2
	  sw $t2, -348($fp)	# spill _tmp450 from $t2 to $fp-348
	# _tmp451 = *(_tmp448)
	  lw $t0, -340($fp)	# fill _tmp448 to $t0 from $fp-340
	  lw $t2, 0($t0) 	# load with offset
	  sw $t2, -352($fp)	# spill _tmp451 from $t2 to $fp-352
	# _tmp452 = _tmp449 < _tmp450
	  lw $t0, -344($fp)	# fill _tmp449 to $t0 from $fp-344
	  lw $t1, -348($fp)	# fill _tmp450 to $t1 from $fp-348
	  slt $t2, $t0, $t1	
	  sw $t2, -356($fp)	# spill _tmp452 from $t2 to $fp-356
	# _tmp453 = _tmp451 < _tmp449
	  lw $t0, -352($fp)	# fill _tmp451 to $t0 from $fp-352
	  lw $t1, -344($fp)	# fill _tmp449 to $t1 from $fp-344
	  slt $t2, $t0, $t1	
	  sw $t2, -360($fp)	# spill _tmp453 from $t2 to $fp-360
	# _tmp454 = _tmp451 == _tmp449
	  lw $t0, -352($fp)	# fill _tmp451 to $t0 from $fp-352
	  lw $t1, -344($fp)	# fill _tmp449 to $t1 from $fp-344
	  seq $t2, $t0, $t1	
	  sw $t2, -364($fp)	# spill _tmp454 from $t2 to $fp-364
	# _tmp455 = _tmp453 || _tmp454
	  lw $t0, -360($fp)	# fill _tmp453 to $t0 from $fp-360
	  lw $t1, -364($fp)	# fill _tmp454 to $t1 from $fp-364
	  or $t2, $t0, $t1	
	  sw $t2, -368($fp)	# spill _tmp455 from $t2 to $fp-368
	# _tmp456 = _tmp455 || _tmp452
	  lw $t0, -368($fp)	# fill _tmp455 to $t0 from $fp-368
	  lw $t1, -356($fp)	# fill _tmp452 to $t1 from $fp-356
	  or $t2, $t0, $t1	
	  sw $t2, -372($fp)	# spill _tmp456 from $t2 to $fp-372
	# IfZ _tmp456 Goto _L56
	  lw $t0, -372($fp)	# fill _tmp456 to $t0 from $fp-372
	  beqz $t0, _L56	# branch if _tmp456 is zero 
	# _tmp457 = "Decaf runtime error: Array subscript out of bound..."
	  .data			# create string constant marked with label
	  _string36: .asciiz "Decaf runtime error: Array subscript out of bounds\n"
	  .text
	  la $t2, _string36	# load label
	  sw $t2, -376($fp)	# spill _tmp457 from $t2 to $fp-376
	# PushParam _tmp457
	  subu $sp, $sp, 4	# decrement sp to make space for param
	  lw $t0, -376($fp)	# fill _tmp457 to $t0 from $fp-376
	  sw $t0, 4($sp)	# copy param value to stack
	# LCall _PrintString
	  jal _PrintString   	# jump to function
	# PopParams 4
	  add $sp, $sp, 4	# pop params off stack
	# LCall _Halt
	  jal _Halt          	# jump to function
  _L56:
	# _tmp458 = 4
	  li $t2, 4		# load constant value 4 into $t2
	  sw $t2, -380($fp)	# spill _tmp458 from $t2 to $fp-380
	# _tmp459 = _tmp449 * _tmp458
	  lw $t0, -344($fp)	# fill _tmp449 to $t0 from $fp-344
	  lw $t1, -380($fp)	# fill _tmp458 to $t1 from $fp-380
	  mul $t2, $t0, $t1	
	  sw $t2, -384($fp)	# spill _tmp459 from $t2 to $fp-384
	# _tmp460 = _tmp459 + _tmp458
	  lw $t0, -384($fp)	# fill _tmp459 to $t0 from $fp-384
	  lw $t1, -380($fp)	# fill _tmp458 to $t1 from $fp-380
	  add $t2, $t0, $t1	
	  sw $t2, -388($fp)	# spill _tmp460 from $t2 to $fp-388
	# _tmp461 = _tmp448 + _tmp460
	  lw $t0, -340($fp)	# fill _tmp448 to $t0 from $fp-340
	  lw $t1, -388($fp)	# fill _tmp460 to $t1 from $fp-388
	  add $t2, $t0, $t1	
	  sw $t2, -392($fp)	# spill _tmp461 from $t2 to $fp-392
	# _tmp462 = *(_tmp461)
	  lw $t0, -392($fp)	# fill _tmp461 to $t0 from $fp-392
	  lw $t2, 0($t0) 	# load with offset
	  sw $t2, -396($fp)	# spill _tmp462 from $t2 to $fp-396
	# PushParam _tmp462
	  subu $sp, $sp, 4	# decrement sp to make space for param
	  lw $t0, -396($fp)	# fill _tmp462 to $t0 from $fp-396
	  sw $t0, 4($sp)	# copy param value to stack
	# _tmp463 = *(_tmp462)
	  lw $t0, -396($fp)	# fill _tmp462 to $t0 from $fp-396
	  lw $t2, 0($t0) 	# load with offset
	  sw $t2, -400($fp)	# spill _tmp463 from $t2 to $fp-400
	# _tmp464 = *(_tmp463 + 20)
	  lw $t0, -400($fp)	# fill _tmp463 to $t0 from $fp-400
	  lw $t2, 20($t0) 	# load with offset
	  sw $t2, -404($fp)	# spill _tmp464 from $t2 to $fp-404
	# _tmp465 = ACall _tmp464
	  lw $t0, -404($fp)	# fill _tmp464 to $t0 from $fp-404
	  jalr $t0            	# jump to function
	  move $t2, $v0		# copy function return value from $v0
	  sw $t2, -408($fp)	# spill _tmp465 from $t2 to $fp-408
	# PopParams 8
	  add $sp, $sp, 8	# pop params off stack
	# _tmp466 = _tmp433 && _tmp465
	  lw $t0, -280($fp)	# fill _tmp433 to $t0 from $fp-280
	  lw $t1, -408($fp)	# fill _tmp465 to $t1 from $fp-408
	  and $t2, $t0, $t1	
	  sw $t2, -412($fp)	# spill _tmp466 from $t2 to $fp-412
	# IfZ _tmp466 Goto _L49
	  lw $t0, -412($fp)	# fill _tmp466 to $t0 from $fp-412
	  beqz $t0, _L49	# branch if _tmp466 is zero 
	# _tmp467 = 0
	  li $t2, 0		# load constant value 0 into $t2
	  sw $t2, -416($fp)	# spill _tmp467 from $t2 to $fp-416
	# Return _tmp467
	  lw $t2, -416($fp)	# fill _tmp467 to $t2 from $fp-416
	  move $v0, $t2		# assign return value into $v0
	  move $sp, $fp		# pop callee frame off stack
	  lw $ra, -4($fp)	# restore saved ra
	  lw $fp, 0($fp)	# restore saved fp
	  jr $ra		# return from function
	# Goto _L50
	  b _L50		# unconditional branch
  _L49:
	# PushParam mark
	  subu $sp, $sp, 4	# decrement sp to make space for param
	  lw $t0, -8($fp)	# fill mark to $t0 from $fp-8
	  sw $t0, 4($sp)	# copy param value to stack
	# _tmp468 = *(this + 4)
	  lw $t0, 4($fp)	# fill this to $t0 from $fp+4
	  lw $t2, 4($t0) 	# load with offset
	  sw $t2, -420($fp)	# spill _tmp468 from $t2 to $fp-420
	# _tmp469 = 1
	  li $t2, 1		# load constant value 1 into $t2
	  sw $t2, -424($fp)	# spill _tmp469 from $t2 to $fp-424
	# _tmp470 = 0
	  li $t2, 0		# load constant value 0 into $t2
	  sw $t2, -428($fp)	# spill _tmp470 from $t2 to $fp-428
	# _tmp471 = *(_tmp468)
	  lw $t0, -420($fp)	# fill _tmp468 to $t0 from $fp-420
	  lw $t2, 0($t0) 	# load with offset
	  sw $t2, -432($fp)	# spill _tmp471 from $t2 to $fp-432
	# _tmp472 = _tmp469 < _tmp470
	  lw $t0, -424($fp)	# fill _tmp469 to $t0 from $fp-424
	  lw $t1, -428($fp)	# fill _tmp470 to $t1 from $fp-428
	  slt $t2, $t0, $t1	
	  sw $t2, -436($fp)	# spill _tmp472 from $t2 to $fp-436
	# _tmp473 = _tmp471 < _tmp469
	  lw $t0, -432($fp)	# fill _tmp471 to $t0 from $fp-432
	  lw $t1, -424($fp)	# fill _tmp469 to $t1 from $fp-424
	  slt $t2, $t0, $t1	
	  sw $t2, -440($fp)	# spill _tmp473 from $t2 to $fp-440
	# _tmp474 = _tmp471 == _tmp469
	  lw $t0, -432($fp)	# fill _tmp471 to $t0 from $fp-432
	  lw $t1, -424($fp)	# fill _tmp469 to $t1 from $fp-424
	  seq $t2, $t0, $t1	
	  sw $t2, -444($fp)	# spill _tmp474 from $t2 to $fp-444
	# _tmp475 = _tmp473 || _tmp474
	  lw $t0, -440($fp)	# fill _tmp473 to $t0 from $fp-440
	  lw $t1, -444($fp)	# fill _tmp474 to $t1 from $fp-444
	  or $t2, $t0, $t1	
	  sw $t2, -448($fp)	# spill _tmp475 from $t2 to $fp-448
	# _tmp476 = _tmp475 || _tmp472
	  lw $t0, -448($fp)	# fill _tmp475 to $t0 from $fp-448
	  lw $t1, -436($fp)	# fill _tmp472 to $t1 from $fp-436
	  or $t2, $t0, $t1	
	  sw $t2, -452($fp)	# spill _tmp476 from $t2 to $fp-452
	# IfZ _tmp476 Goto _L59
	  lw $t0, -452($fp)	# fill _tmp476 to $t0 from $fp-452
	  beqz $t0, _L59	# branch if _tmp476 is zero 
	# _tmp477 = "Decaf runtime error: Array subscript out of bound..."
	  .data			# create string constant marked with label
	  _string37: .asciiz "Decaf runtime error: Array subscript out of bounds\n"
	  .text
	  la $t2, _string37	# load label
	  sw $t2, -456($fp)	# spill _tmp477 from $t2 to $fp-456
	# PushParam _tmp477
	  subu $sp, $sp, 4	# decrement sp to make space for param
	  lw $t0, -456($fp)	# fill _tmp477 to $t0 from $fp-456
	  sw $t0, 4($sp)	# copy param value to stack
	# LCall _PrintString
	  jal _PrintString   	# jump to function
	# PopParams 4
	  add $sp, $sp, 4	# pop params off stack
	# LCall _Halt
	  jal _Halt          	# jump to function
  _L59:
	# _tmp478 = 4
	  li $t2, 4		# load constant value 4 into $t2
	  sw $t2, -460($fp)	# spill _tmp478 from $t2 to $fp-460
	# _tmp479 = _tmp469 * _tmp478
	  lw $t0, -424($fp)	# fill _tmp469 to $t0 from $fp-424
	  lw $t1, -460($fp)	# fill _tmp478 to $t1 from $fp-460
	  mul $t2, $t0, $t1	
	  sw $t2, -464($fp)	# spill _tmp479 from $t2 to $fp-464
	# _tmp480 = _tmp479 + _tmp478
	  lw $t0, -464($fp)	# fill _tmp479 to $t0 from $fp-464
	  lw $t1, -460($fp)	# fill _tmp478 to $t1 from $fp-460
	  add $t2, $t0, $t1	
	  sw $t2, -468($fp)	# spill _tmp480 from $t2 to $fp-468
	# _tmp481 = _tmp468 + _tmp480
	  lw $t0, -420($fp)	# fill _tmp468 to $t0 from $fp-420
	  lw $t1, -468($fp)	# fill _tmp480 to $t1 from $fp-468
	  add $t2, $t0, $t1	
	  sw $t2, -472($fp)	# spill _tmp481 from $t2 to $fp-472
	# _tmp482 = *(_tmp481)
	  lw $t0, -472($fp)	# fill _tmp481 to $t0 from $fp-472
	  lw $t2, 0($t0) 	# load with offset
	  sw $t2, -476($fp)	# spill _tmp482 from $t2 to $fp-476
	# _tmp483 = 0
	  li $t2, 0		# load constant value 0 into $t2
	  sw $t2, -480($fp)	# spill _tmp483 from $t2 to $fp-480
	# _tmp484 = 0
	  li $t2, 0		# load constant value 0 into $t2
	  sw $t2, -484($fp)	# spill _tmp484 from $t2 to $fp-484
	# _tmp485 = *(_tmp482)
	  lw $t0, -476($fp)	# fill _tmp482 to $t0 from $fp-476
	  lw $t2, 0($t0) 	# load with offset
	  sw $t2, -488($fp)	# spill _tmp485 from $t2 to $fp-488
	# _tmp486 = _tmp483 < _tmp484
	  lw $t0, -480($fp)	# fill _tmp483 to $t0 from $fp-480
	  lw $t1, -484($fp)	# fill _tmp484 to $t1 from $fp-484
	  slt $t2, $t0, $t1	
	  sw $t2, -492($fp)	# spill _tmp486 from $t2 to $fp-492
	# _tmp487 = _tmp485 < _tmp483
	  lw $t0, -488($fp)	# fill _tmp485 to $t0 from $fp-488
	  lw $t1, -480($fp)	# fill _tmp483 to $t1 from $fp-480
	  slt $t2, $t0, $t1	
	  sw $t2, -496($fp)	# spill _tmp487 from $t2 to $fp-496
	# _tmp488 = _tmp485 == _tmp483
	  lw $t0, -488($fp)	# fill _tmp485 to $t0 from $fp-488
	  lw $t1, -480($fp)	# fill _tmp483 to $t1 from $fp-480
	  seq $t2, $t0, $t1	
	  sw $t2, -500($fp)	# spill _tmp488 from $t2 to $fp-500
	# _tmp489 = _tmp487 || _tmp488
	  lw $t0, -496($fp)	# fill _tmp487 to $t0 from $fp-496
	  lw $t1, -500($fp)	# fill _tmp488 to $t1 from $fp-500
	  or $t2, $t0, $t1	
	  sw $t2, -504($fp)	# spill _tmp489 from $t2 to $fp-504
	# _tmp490 = _tmp489 || _tmp486
	  lw $t0, -504($fp)	# fill _tmp489 to $t0 from $fp-504
	  lw $t1, -492($fp)	# fill _tmp486 to $t1 from $fp-492
	  or $t2, $t0, $t1	
	  sw $t2, -508($fp)	# spill _tmp490 from $t2 to $fp-508
	# IfZ _tmp490 Goto _L60
	  lw $t0, -508($fp)	# fill _tmp490 to $t0 from $fp-508
	  beqz $t0, _L60	# branch if _tmp490 is zero 
	# _tmp491 = "Decaf runtime error: Array subscript out of bound..."
	  .data			# create string constant marked with label
	  _string38: .asciiz "Decaf runtime error: Array subscript out of bounds\n"
	  .text
	  la $t2, _string38	# load label
	  sw $t2, -512($fp)	# spill _tmp491 from $t2 to $fp-512
	# PushParam _tmp491
	  subu $sp, $sp, 4	# decrement sp to make space for param
	  lw $t0, -512($fp)	# fill _tmp491 to $t0 from $fp-512
	  sw $t0, 4($sp)	# copy param value to stack
	# LCall _PrintString
	  jal _PrintString   	# jump to function
	# PopParams 4
	  add $sp, $sp, 4	# pop params off stack
	# LCall _Halt
	  jal _Halt          	# jump to function
  _L60:
	# _tmp492 = 4
	  li $t2, 4		# load constant value 4 into $t2
	  sw $t2, -516($fp)	# spill _tmp492 from $t2 to $fp-516
	# _tmp493 = _tmp483 * _tmp492
	  lw $t0, -480($fp)	# fill _tmp483 to $t0 from $fp-480
	  lw $t1, -516($fp)	# fill _tmp492 to $t1 from $fp-516
	  mul $t2, $t0, $t1	
	  sw $t2, -520($fp)	# spill _tmp493 from $t2 to $fp-520
	# _tmp494 = _tmp493 + _tmp492
	  lw $t0, -520($fp)	# fill _tmp493 to $t0 from $fp-520
	  lw $t1, -516($fp)	# fill _tmp492 to $t1 from $fp-516
	  add $t2, $t0, $t1	
	  sw $t2, -524($fp)	# spill _tmp494 from $t2 to $fp-524
	# _tmp495 = _tmp482 + _tmp494
	  lw $t0, -476($fp)	# fill _tmp482 to $t0 from $fp-476
	  lw $t1, -524($fp)	# fill _tmp494 to $t1 from $fp-524
	  add $t2, $t0, $t1	
	  sw $t2, -528($fp)	# spill _tmp495 from $t2 to $fp-528
	# _tmp496 = *(_tmp495)
	  lw $t0, -528($fp)	# fill _tmp495 to $t0 from $fp-528
	  lw $t2, 0($t0) 	# load with offset
	  sw $t2, -532($fp)	# spill _tmp496 from $t2 to $fp-532
	# PushParam _tmp496
	  subu $sp, $sp, 4	# decrement sp to make space for param
	  lw $t0, -532($fp)	# fill _tmp496 to $t0 from $fp-532
	  sw $t0, 4($sp)	# copy param value to stack
	# _tmp497 = *(_tmp496)
	  lw $t0, -532($fp)	# fill _tmp496 to $t0 from $fp-532
	  lw $t2, 0($t0) 	# load with offset
	  sw $t2, -536($fp)	# spill _tmp497 from $t2 to $fp-536
	# _tmp498 = *(_tmp497 + 20)
	  lw $t0, -536($fp)	# fill _tmp497 to $t0 from $fp-536
	  lw $t2, 20($t0) 	# load with offset
	  sw $t2, -540($fp)	# spill _tmp498 from $t2 to $fp-540
	# _tmp499 = ACall _tmp498
	  lw $t0, -540($fp)	# fill _tmp498 to $t0 from $fp-540
	  jalr $t0            	# jump to function
	  move $t2, $v0		# copy function return value from $v0
	  sw $t2, -544($fp)	# spill _tmp499 from $t2 to $fp-544
	# PopParams 8
	  add $sp, $sp, 8	# pop params off stack
	# PushParam mark
	  subu $sp, $sp, 4	# decrement sp to make space for param
	  lw $t0, -8($fp)	# fill mark to $t0 from $fp-8
	  sw $t0, 4($sp)	# copy param value to stack
	# _tmp500 = *(this + 4)
	  lw $t0, 4($fp)	# fill this to $t0 from $fp+4
	  lw $t2, 4($t0) 	# load with offset
	  sw $t2, -548($fp)	# spill _tmp500 from $t2 to $fp-548
	# _tmp501 = 1
	  li $t2, 1		# load constant value 1 into $t2
	  sw $t2, -552($fp)	# spill _tmp501 from $t2 to $fp-552
	# _tmp502 = 0
	  li $t2, 0		# load constant value 0 into $t2
	  sw $t2, -556($fp)	# spill _tmp502 from $t2 to $fp-556
	# _tmp503 = *(_tmp500)
	  lw $t0, -548($fp)	# fill _tmp500 to $t0 from $fp-548
	  lw $t2, 0($t0) 	# load with offset
	  sw $t2, -560($fp)	# spill _tmp503 from $t2 to $fp-560
	# _tmp504 = _tmp501 < _tmp502
	  lw $t0, -552($fp)	# fill _tmp501 to $t0 from $fp-552
	  lw $t1, -556($fp)	# fill _tmp502 to $t1 from $fp-556
	  slt $t2, $t0, $t1	
	  sw $t2, -564($fp)	# spill _tmp504 from $t2 to $fp-564
	# _tmp505 = _tmp503 < _tmp501
	  lw $t0, -560($fp)	# fill _tmp503 to $t0 from $fp-560
	  lw $t1, -552($fp)	# fill _tmp501 to $t1 from $fp-552
	  slt $t2, $t0, $t1	
	  sw $t2, -568($fp)	# spill _tmp505 from $t2 to $fp-568
	# _tmp506 = _tmp503 == _tmp501
	  lw $t0, -560($fp)	# fill _tmp503 to $t0 from $fp-560
	  lw $t1, -552($fp)	# fill _tmp501 to $t1 from $fp-552
	  seq $t2, $t0, $t1	
	  sw $t2, -572($fp)	# spill _tmp506 from $t2 to $fp-572
	# _tmp507 = _tmp505 || _tmp506
	  lw $t0, -568($fp)	# fill _tmp505 to $t0 from $fp-568
	  lw $t1, -572($fp)	# fill _tmp506 to $t1 from $fp-572
	  or $t2, $t0, $t1	
	  sw $t2, -576($fp)	# spill _tmp507 from $t2 to $fp-576
	# _tmp508 = _tmp507 || _tmp504
	  lw $t0, -576($fp)	# fill _tmp507 to $t0 from $fp-576
	  lw $t1, -564($fp)	# fill _tmp504 to $t1 from $fp-564
	  or $t2, $t0, $t1	
	  sw $t2, -580($fp)	# spill _tmp508 from $t2 to $fp-580
	# IfZ _tmp508 Goto _L61
	  lw $t0, -580($fp)	# fill _tmp508 to $t0 from $fp-580
	  beqz $t0, _L61	# branch if _tmp508 is zero 
	# _tmp509 = "Decaf runtime error: Array subscript out of bound..."
	  .data			# create string constant marked with label
	  _string39: .asciiz "Decaf runtime error: Array subscript out of bounds\n"
	  .text
	  la $t2, _string39	# load label
	  sw $t2, -584($fp)	# spill _tmp509 from $t2 to $fp-584
	# PushParam _tmp509
	  subu $sp, $sp, 4	# decrement sp to make space for param
	  lw $t0, -584($fp)	# fill _tmp509 to $t0 from $fp-584
	  sw $t0, 4($sp)	# copy param value to stack
	# LCall _PrintString
	  jal _PrintString   	# jump to function
	# PopParams 4
	  add $sp, $sp, 4	# pop params off stack
	# LCall _Halt
	  jal _Halt          	# jump to function
  _L61:
	# _tmp510 = 4
	  li $t2, 4		# load constant value 4 into $t2
	  sw $t2, -588($fp)	# spill _tmp510 from $t2 to $fp-588
	# _tmp511 = _tmp501 * _tmp510
	  lw $t0, -552($fp)	# fill _tmp501 to $t0 from $fp-552
	  lw $t1, -588($fp)	# fill _tmp510 to $t1 from $fp-588
	  mul $t2, $t0, $t1	
	  sw $t2, -592($fp)	# spill _tmp511 from $t2 to $fp-592
	# _tmp512 = _tmp511 + _tmp510
	  lw $t0, -592($fp)	# fill _tmp511 to $t0 from $fp-592
	  lw $t1, -588($fp)	# fill _tmp510 to $t1 from $fp-588
	  add $t2, $t0, $t1	
	  sw $t2, -596($fp)	# spill _tmp512 from $t2 to $fp-596
	# _tmp513 = _tmp500 + _tmp512
	  lw $t0, -548($fp)	# fill _tmp500 to $t0 from $fp-548
	  lw $t1, -596($fp)	# fill _tmp512 to $t1 from $fp-596
	  add $t2, $t0, $t1	
	  sw $t2, -600($fp)	# spill _tmp513 from $t2 to $fp-600
	# _tmp514 = *(_tmp513)
	  lw $t0, -600($fp)	# fill _tmp513 to $t0 from $fp-600
	  lw $t2, 0($t0) 	# load with offset
	  sw $t2, -604($fp)	# spill _tmp514 from $t2 to $fp-604
	# _tmp515 = 1
	  li $t2, 1		# load constant value 1 into $t2
	  sw $t2, -608($fp)	# spill _tmp515 from $t2 to $fp-608
	# _tmp516 = 0
	  li $t2, 0		# load constant value 0 into $t2
	  sw $t2, -612($fp)	# spill _tmp516 from $t2 to $fp-612
	# _tmp517 = *(_tmp514)
	  lw $t0, -604($fp)	# fill _tmp514 to $t0 from $fp-604
	  lw $t2, 0($t0) 	# load with offset
	  sw $t2, -616($fp)	# spill _tmp517 from $t2 to $fp-616
	# _tmp518 = _tmp515 < _tmp516
	  lw $t0, -608($fp)	# fill _tmp515 to $t0 from $fp-608
	  lw $t1, -612($fp)	# fill _tmp516 to $t1 from $fp-612
	  slt $t2, $t0, $t1	
	  sw $t2, -620($fp)	# spill _tmp518 from $t2 to $fp-620
	# _tmp519 = _tmp517 < _tmp515
	  lw $t0, -616($fp)	# fill _tmp517 to $t0 from $fp-616
	  lw $t1, -608($fp)	# fill _tmp515 to $t1 from $fp-608
	  slt $t2, $t0, $t1	
	  sw $t2, -624($fp)	# spill _tmp519 from $t2 to $fp-624
	# _tmp520 = _tmp517 == _tmp515
	  lw $t0, -616($fp)	# fill _tmp517 to $t0 from $fp-616
	  lw $t1, -608($fp)	# fill _tmp515 to $t1 from $fp-608
	  seq $t2, $t0, $t1	
	  sw $t2, -628($fp)	# spill _tmp520 from $t2 to $fp-628
	# _tmp521 = _tmp519 || _tmp520
	  lw $t0, -624($fp)	# fill _tmp519 to $t0 from $fp-624
	  lw $t1, -628($fp)	# fill _tmp520 to $t1 from $fp-628
	  or $t2, $t0, $t1	
	  sw $t2, -632($fp)	# spill _tmp521 from $t2 to $fp-632
	# _tmp522 = _tmp521 || _tmp518
	  lw $t0, -632($fp)	# fill _tmp521 to $t0 from $fp-632
	  lw $t1, -620($fp)	# fill _tmp518 to $t1 from $fp-620
	  or $t2, $t0, $t1	
	  sw $t2, -636($fp)	# spill _tmp522 from $t2 to $fp-636
	# IfZ _tmp522 Goto _L62
	  lw $t0, -636($fp)	# fill _tmp522 to $t0 from $fp-636
	  beqz $t0, _L62	# branch if _tmp522 is zero 
	# _tmp523 = "Decaf runtime error: Array subscript out of bound..."
	  .data			# create string constant marked with label
	  _string40: .asciiz "Decaf runtime error: Array subscript out of bounds\n"
	  .text
	  la $t2, _string40	# load label
	  sw $t2, -640($fp)	# spill _tmp523 from $t2 to $fp-640
	# PushParam _tmp523
	  subu $sp, $sp, 4	# decrement sp to make space for param
	  lw $t0, -640($fp)	# fill _tmp523 to $t0 from $fp-640
	  sw $t0, 4($sp)	# copy param value to stack
	# LCall _PrintString
	  jal _PrintString   	# jump to function
	# PopParams 4
	  add $sp, $sp, 4	# pop params off stack
	# LCall _Halt
	  jal _Halt          	# jump to function
  _L62:
	# _tmp524 = 4
	  li $t2, 4		# load constant value 4 into $t2
	  sw $t2, -644($fp)	# spill _tmp524 from $t2 to $fp-644
	# _tmp525 = _tmp515 * _tmp524
	  lw $t0, -608($fp)	# fill _tmp515 to $t0 from $fp-608
	  lw $t1, -644($fp)	# fill _tmp524 to $t1 from $fp-644
	  mul $t2, $t0, $t1	
	  sw $t2, -648($fp)	# spill _tmp525 from $t2 to $fp-648
	# _tmp526 = _tmp525 + _tmp524
	  lw $t0, -648($fp)	# fill _tmp525 to $t0 from $fp-648
	  lw $t1, -644($fp)	# fill _tmp524 to $t1 from $fp-644
	  add $t2, $t0, $t1	
	  sw $t2, -652($fp)	# spill _tmp526 from $t2 to $fp-652
	# _tmp527 = _tmp514 + _tmp526
	  lw $t0, -604($fp)	# fill _tmp514 to $t0 from $fp-604
	  lw $t1, -652($fp)	# fill _tmp526 to $t1 from $fp-652
	  add $t2, $t0, $t1	
	  sw $t2, -656($fp)	# spill _tmp527 from $t2 to $fp-656
	# _tmp528 = *(_tmp527)
	  lw $t0, -656($fp)	# fill _tmp527 to $t0 from $fp-656
	  lw $t2, 0($t0) 	# load with offset
	  sw $t2, -660($fp)	# spill _tmp528 from $t2 to $fp-660
	# PushParam _tmp528
	  subu $sp, $sp, 4	# decrement sp to make space for param
	  lw $t0, -660($fp)	# fill _tmp528 to $t0 from $fp-660
	  sw $t0, 4($sp)	# copy param value to stack
	# _tmp529 = *(_tmp528)
	  lw $t0, -660($fp)	# fill _tmp528 to $t0 from $fp-660
	  lw $t2, 0($t0) 	# load with offset
	  sw $t2, -664($fp)	# spill _tmp529 from $t2 to $fp-664
	# _tmp530 = *(_tmp529 + 20)
	  lw $t0, -664($fp)	# fill _tmp529 to $t0 from $fp-664
	  lw $t2, 20($t0) 	# load with offset
	  sw $t2, -668($fp)	# spill _tmp530 from $t2 to $fp-668
	# _tmp531 = ACall _tmp530
	  lw $t0, -668($fp)	# fill _tmp530 to $t0 from $fp-668
	  jalr $t0            	# jump to function
	  move $t2, $v0		# copy function return value from $v0
	  sw $t2, -672($fp)	# spill _tmp531 from $t2 to $fp-672
	# PopParams 8
	  add $sp, $sp, 8	# pop params off stack
	# _tmp532 = _tmp499 && _tmp531
	  lw $t0, -544($fp)	# fill _tmp499 to $t0 from $fp-544
	  lw $t1, -672($fp)	# fill _tmp531 to $t1 from $fp-672
	  and $t2, $t0, $t1	
	  sw $t2, -676($fp)	# spill _tmp532 from $t2 to $fp-676
	# PushParam mark
	  subu $sp, $sp, 4	# decrement sp to make space for param
	  lw $t0, -8($fp)	# fill mark to $t0 from $fp-8
	  sw $t0, 4($sp)	# copy param value to stack
	# _tmp533 = *(this + 4)
	  lw $t0, 4($fp)	# fill this to $t0 from $fp+4
	  lw $t2, 4($t0) 	# load with offset
	  sw $t2, -680($fp)	# spill _tmp533 from $t2 to $fp-680
	# _tmp534 = 1
	  li $t2, 1		# load constant value 1 into $t2
	  sw $t2, -684($fp)	# spill _tmp534 from $t2 to $fp-684
	# _tmp535 = 0
	  li $t2, 0		# load constant value 0 into $t2
	  sw $t2, -688($fp)	# spill _tmp535 from $t2 to $fp-688
	# _tmp536 = *(_tmp533)
	  lw $t0, -680($fp)	# fill _tmp533 to $t0 from $fp-680
	  lw $t2, 0($t0) 	# load with offset
	  sw $t2, -692($fp)	# spill _tmp536 from $t2 to $fp-692
	# _tmp537 = _tmp534 < _tmp535
	  lw $t0, -684($fp)	# fill _tmp534 to $t0 from $fp-684
	  lw $t1, -688($fp)	# fill _tmp535 to $t1 from $fp-688
	  slt $t2, $t0, $t1	
	  sw $t2, -696($fp)	# spill _tmp537 from $t2 to $fp-696
	# _tmp538 = _tmp536 < _tmp534
	  lw $t0, -692($fp)	# fill _tmp536 to $t0 from $fp-692
	  lw $t1, -684($fp)	# fill _tmp534 to $t1 from $fp-684
	  slt $t2, $t0, $t1	
	  sw $t2, -700($fp)	# spill _tmp538 from $t2 to $fp-700
	# _tmp539 = _tmp536 == _tmp534
	  lw $t0, -692($fp)	# fill _tmp536 to $t0 from $fp-692
	  lw $t1, -684($fp)	# fill _tmp534 to $t1 from $fp-684
	  seq $t2, $t0, $t1	
	  sw $t2, -704($fp)	# spill _tmp539 from $t2 to $fp-704
	# _tmp540 = _tmp538 || _tmp539
	  lw $t0, -700($fp)	# fill _tmp538 to $t0 from $fp-700
	  lw $t1, -704($fp)	# fill _tmp539 to $t1 from $fp-704
	  or $t2, $t0, $t1	
	  sw $t2, -708($fp)	# spill _tmp540 from $t2 to $fp-708
	# _tmp541 = _tmp540 || _tmp537
	  lw $t0, -708($fp)	# fill _tmp540 to $t0 from $fp-708
	  lw $t1, -696($fp)	# fill _tmp537 to $t1 from $fp-696
	  or $t2, $t0, $t1	
	  sw $t2, -712($fp)	# spill _tmp541 from $t2 to $fp-712
	# IfZ _tmp541 Goto _L63
	  lw $t0, -712($fp)	# fill _tmp541 to $t0 from $fp-712
	  beqz $t0, _L63	# branch if _tmp541 is zero 
	# _tmp542 = "Decaf runtime error: Array subscript out of bound..."
	  .data			# create string constant marked with label
	  _string41: .asciiz "Decaf runtime error: Array subscript out of bounds\n"
	  .text
	  la $t2, _string41	# load label
	  sw $t2, -716($fp)	# spill _tmp542 from $t2 to $fp-716
	# PushParam _tmp542
	  subu $sp, $sp, 4	# decrement sp to make space for param
	  lw $t0, -716($fp)	# fill _tmp542 to $t0 from $fp-716
	  sw $t0, 4($sp)	# copy param value to stack
	# LCall _PrintString
	  jal _PrintString   	# jump to function
	# PopParams 4
	  add $sp, $sp, 4	# pop params off stack
	# LCall _Halt
	  jal _Halt          	# jump to function
  _L63:
	# _tmp543 = 4
	  li $t2, 4		# load constant value 4 into $t2
	  sw $t2, -720($fp)	# spill _tmp543 from $t2 to $fp-720
	# _tmp544 = _tmp534 * _tmp543
	  lw $t0, -684($fp)	# fill _tmp534 to $t0 from $fp-684
	  lw $t1, -720($fp)	# fill _tmp543 to $t1 from $fp-720
	  mul $t2, $t0, $t1	
	  sw $t2, -724($fp)	# spill _tmp544 from $t2 to $fp-724
	# _tmp545 = _tmp544 + _tmp543
	  lw $t0, -724($fp)	# fill _tmp544 to $t0 from $fp-724
	  lw $t1, -720($fp)	# fill _tmp543 to $t1 from $fp-720
	  add $t2, $t0, $t1	
	  sw $t2, -728($fp)	# spill _tmp545 from $t2 to $fp-728
	# _tmp546 = _tmp533 + _tmp545
	  lw $t0, -680($fp)	# fill _tmp533 to $t0 from $fp-680
	  lw $t1, -728($fp)	# fill _tmp545 to $t1 from $fp-728
	  add $t2, $t0, $t1	
	  sw $t2, -732($fp)	# spill _tmp546 from $t2 to $fp-732
	# _tmp547 = *(_tmp546)
	  lw $t0, -732($fp)	# fill _tmp546 to $t0 from $fp-732
	  lw $t2, 0($t0) 	# load with offset
	  sw $t2, -736($fp)	# spill _tmp547 from $t2 to $fp-736
	# _tmp548 = 2
	  li $t2, 2		# load constant value 2 into $t2
	  sw $t2, -740($fp)	# spill _tmp548 from $t2 to $fp-740
	# _tmp549 = 0
	  li $t2, 0		# load constant value 0 into $t2
	  sw $t2, -744($fp)	# spill _tmp549 from $t2 to $fp-744
	# _tmp550 = *(_tmp547)
	  lw $t0, -736($fp)	# fill _tmp547 to $t0 from $fp-736
	  lw $t2, 0($t0) 	# load with offset
	  sw $t2, -748($fp)	# spill _tmp550 from $t2 to $fp-748
	# _tmp551 = _tmp548 < _tmp549
	  lw $t0, -740($fp)	# fill _tmp548 to $t0 from $fp-740
	  lw $t1, -744($fp)	# fill _tmp549 to $t1 from $fp-744
	  slt $t2, $t0, $t1	
	  sw $t2, -752($fp)	# spill _tmp551 from $t2 to $fp-752
	# _tmp552 = _tmp550 < _tmp548
	  lw $t0, -748($fp)	# fill _tmp550 to $t0 from $fp-748
	  lw $t1, -740($fp)	# fill _tmp548 to $t1 from $fp-740
	  slt $t2, $t0, $t1	
	  sw $t2, -756($fp)	# spill _tmp552 from $t2 to $fp-756
	# _tmp553 = _tmp550 == _tmp548
	  lw $t0, -748($fp)	# fill _tmp550 to $t0 from $fp-748
	  lw $t1, -740($fp)	# fill _tmp548 to $t1 from $fp-740
	  seq $t2, $t0, $t1	
	  sw $t2, -760($fp)	# spill _tmp553 from $t2 to $fp-760
	# _tmp554 = _tmp552 || _tmp553
	  lw $t0, -756($fp)	# fill _tmp552 to $t0 from $fp-756
	  lw $t1, -760($fp)	# fill _tmp553 to $t1 from $fp-760
	  or $t2, $t0, $t1	
	  sw $t2, -764($fp)	# spill _tmp554 from $t2 to $fp-764
	# _tmp555 = _tmp554 || _tmp551
	  lw $t0, -764($fp)	# fill _tmp554 to $t0 from $fp-764
	  lw $t1, -752($fp)	# fill _tmp551 to $t1 from $fp-752
	  or $t2, $t0, $t1	
	  sw $t2, -768($fp)	# spill _tmp555 from $t2 to $fp-768
	# IfZ _tmp555 Goto _L64
	  lw $t0, -768($fp)	# fill _tmp555 to $t0 from $fp-768
	  beqz $t0, _L64	# branch if _tmp555 is zero 
	# _tmp556 = "Decaf runtime error: Array subscript out of bound..."
	  .data			# create string constant marked with label
	  _string42: .asciiz "Decaf runtime error: Array subscript out of bounds\n"
	  .text
	  la $t2, _string42	# load label
	  sw $t2, -772($fp)	# spill _tmp556 from $t2 to $fp-772
	# PushParam _tmp556
	  subu $sp, $sp, 4	# decrement sp to make space for param
	  lw $t0, -772($fp)	# fill _tmp556 to $t0 from $fp-772
	  sw $t0, 4($sp)	# copy param value to stack
	# LCall _PrintString
	  jal _PrintString   	# jump to function
	# PopParams 4
	  add $sp, $sp, 4	# pop params off stack
	# LCall _Halt
	  jal _Halt          	# jump to function
  _L64:
	# _tmp557 = 4
	  li $t2, 4		# load constant value 4 into $t2
	  sw $t2, -776($fp)	# spill _tmp557 from $t2 to $fp-776
	# _tmp558 = _tmp548 * _tmp557
	  lw $t0, -740($fp)	# fill _tmp548 to $t0 from $fp-740
	  lw $t1, -776($fp)	# fill _tmp557 to $t1 from $fp-776
	  mul $t2, $t0, $t1	
	  sw $t2, -780($fp)	# spill _tmp558 from $t2 to $fp-780
	# _tmp559 = _tmp558 + _tmp557
	  lw $t0, -780($fp)	# fill _tmp558 to $t0 from $fp-780
	  lw $t1, -776($fp)	# fill _tmp557 to $t1 from $fp-776
	  add $t2, $t0, $t1	
	  sw $t2, -784($fp)	# spill _tmp559 from $t2 to $fp-784
	# _tmp560 = _tmp547 + _tmp559
	  lw $t0, -736($fp)	# fill _tmp547 to $t0 from $fp-736
	  lw $t1, -784($fp)	# fill _tmp559 to $t1 from $fp-784
	  add $t2, $t0, $t1	
	  sw $t2, -788($fp)	# spill _tmp560 from $t2 to $fp-788
	# _tmp561 = *(_tmp560)
	  lw $t0, -788($fp)	# fill _tmp560 to $t0 from $fp-788
	  lw $t2, 0($t0) 	# load with offset
	  sw $t2, -792($fp)	# spill _tmp561 from $t2 to $fp-792
	# PushParam _tmp561
	  subu $sp, $sp, 4	# decrement sp to make space for param
	  lw $t0, -792($fp)	# fill _tmp561 to $t0 from $fp-792
	  sw $t0, 4($sp)	# copy param value to stack
	# _tmp562 = *(_tmp561)
	  lw $t0, -792($fp)	# fill _tmp561 to $t0 from $fp-792
	  lw $t2, 0($t0) 	# load with offset
	  sw $t2, -796($fp)	# spill _tmp562 from $t2 to $fp-796
	# _tmp563 = *(_tmp562 + 20)
	  lw $t0, -796($fp)	# fill _tmp562 to $t0 from $fp-796
	  lw $t2, 20($t0) 	# load with offset
	  sw $t2, -800($fp)	# spill _tmp563 from $t2 to $fp-800
	# _tmp564 = ACall _tmp563
	  lw $t0, -800($fp)	# fill _tmp563 to $t0 from $fp-800
	  jalr $t0            	# jump to function
	  move $t2, $v0		# copy function return value from $v0
	  sw $t2, -804($fp)	# spill _tmp564 from $t2 to $fp-804
	# PopParams 8
	  add $sp, $sp, 8	# pop params off stack
	# _tmp565 = _tmp532 && _tmp564
	  lw $t0, -676($fp)	# fill _tmp532 to $t0 from $fp-676
	  lw $t1, -804($fp)	# fill _tmp564 to $t1 from $fp-804
	  and $t2, $t0, $t1	
	  sw $t2, -808($fp)	# spill _tmp565 from $t2 to $fp-808
	# IfZ _tmp565 Goto _L57
	  lw $t0, -808($fp)	# fill _tmp565 to $t0 from $fp-808
	  beqz $t0, _L57	# branch if _tmp565 is zero 
	# _tmp566 = 0
	  li $t2, 0		# load constant value 0 into $t2
	  sw $t2, -812($fp)	# spill _tmp566 from $t2 to $fp-812
	# Return _tmp566
	  lw $t2, -812($fp)	# fill _tmp566 to $t2 from $fp-812
	  move $v0, $t2		# assign return value into $v0
	  move $sp, $fp		# pop callee frame off stack
	  lw $ra, -4($fp)	# restore saved ra
	  lw $fp, 0($fp)	# restore saved fp
	  jr $ra		# return from function
	# Goto _L58
	  b _L58		# unconditional branch
  _L57:
	# PushParam mark
	  subu $sp, $sp, 4	# decrement sp to make space for param
	  lw $t0, -8($fp)	# fill mark to $t0 from $fp-8
	  sw $t0, 4($sp)	# copy param value to stack
	# _tmp567 = *(this + 4)
	  lw $t0, 4($fp)	# fill this to $t0 from $fp+4
	  lw $t2, 4($t0) 	# load with offset
	  sw $t2, -816($fp)	# spill _tmp567 from $t2 to $fp-816
	# _tmp568 = 2
	  li $t2, 2		# load constant value 2 into $t2
	  sw $t2, -820($fp)	# spill _tmp568 from $t2 to $fp-820
	# _tmp569 = 0
	  li $t2, 0		# load constant value 0 into $t2
	  sw $t2, -824($fp)	# spill _tmp569 from $t2 to $fp-824
	# _tmp570 = *(_tmp567)
	  lw $t0, -816($fp)	# fill _tmp567 to $t0 from $fp-816
	  lw $t2, 0($t0) 	# load with offset
	  sw $t2, -828($fp)	# spill _tmp570 from $t2 to $fp-828
	# _tmp571 = _tmp568 < _tmp569
	  lw $t0, -820($fp)	# fill _tmp568 to $t0 from $fp-820
	  lw $t1, -824($fp)	# fill _tmp569 to $t1 from $fp-824
	  slt $t2, $t0, $t1	
	  sw $t2, -832($fp)	# spill _tmp571 from $t2 to $fp-832
	# _tmp572 = _tmp570 < _tmp568
	  lw $t0, -828($fp)	# fill _tmp570 to $t0 from $fp-828
	  lw $t1, -820($fp)	# fill _tmp568 to $t1 from $fp-820
	  slt $t2, $t0, $t1	
	  sw $t2, -836($fp)	# spill _tmp572 from $t2 to $fp-836
	# _tmp573 = _tmp570 == _tmp568
	  lw $t0, -828($fp)	# fill _tmp570 to $t0 from $fp-828
	  lw $t1, -820($fp)	# fill _tmp568 to $t1 from $fp-820
	  seq $t2, $t0, $t1	
	  sw $t2, -840($fp)	# spill _tmp573 from $t2 to $fp-840
	# _tmp574 = _tmp572 || _tmp573
	  lw $t0, -836($fp)	# fill _tmp572 to $t0 from $fp-836
	  lw $t1, -840($fp)	# fill _tmp573 to $t1 from $fp-840
	  or $t2, $t0, $t1	
	  sw $t2, -844($fp)	# spill _tmp574 from $t2 to $fp-844
	# _tmp575 = _tmp574 || _tmp571
	  lw $t0, -844($fp)	# fill _tmp574 to $t0 from $fp-844
	  lw $t1, -832($fp)	# fill _tmp571 to $t1 from $fp-832
	  or $t2, $t0, $t1	
	  sw $t2, -848($fp)	# spill _tmp575 from $t2 to $fp-848
	# IfZ _tmp575 Goto _L67
	  lw $t0, -848($fp)	# fill _tmp575 to $t0 from $fp-848
	  beqz $t0, _L67	# branch if _tmp575 is zero 
	# _tmp576 = "Decaf runtime error: Array subscript out of bound..."
	  .data			# create string constant marked with label
	  _string43: .asciiz "Decaf runtime error: Array subscript out of bounds\n"
	  .text
	  la $t2, _string43	# load label
	  sw $t2, -852($fp)	# spill _tmp576 from $t2 to $fp-852
	# PushParam _tmp576
	  subu $sp, $sp, 4	# decrement sp to make space for param
	  lw $t0, -852($fp)	# fill _tmp576 to $t0 from $fp-852
	  sw $t0, 4($sp)	# copy param value to stack
	# LCall _PrintString
	  jal _PrintString   	# jump to function
	# PopParams 4
	  add $sp, $sp, 4	# pop params off stack
	# LCall _Halt
	  jal _Halt          	# jump to function
  _L67:
	# _tmp577 = 4
	  li $t2, 4		# load constant value 4 into $t2
	  sw $t2, -856($fp)	# spill _tmp577 from $t2 to $fp-856
	# _tmp578 = _tmp568 * _tmp577
	  lw $t0, -820($fp)	# fill _tmp568 to $t0 from $fp-820
	  lw $t1, -856($fp)	# fill _tmp577 to $t1 from $fp-856
	  mul $t2, $t0, $t1	
	  sw $t2, -860($fp)	# spill _tmp578 from $t2 to $fp-860
	# _tmp579 = _tmp578 + _tmp577
	  lw $t0, -860($fp)	# fill _tmp578 to $t0 from $fp-860
	  lw $t1, -856($fp)	# fill _tmp577 to $t1 from $fp-856
	  add $t2, $t0, $t1	
	  sw $t2, -864($fp)	# spill _tmp579 from $t2 to $fp-864
	# _tmp580 = _tmp567 + _tmp579
	  lw $t0, -816($fp)	# fill _tmp567 to $t0 from $fp-816
	  lw $t1, -864($fp)	# fill _tmp579 to $t1 from $fp-864
	  add $t2, $t0, $t1	
	  sw $t2, -868($fp)	# spill _tmp580 from $t2 to $fp-868
	# _tmp581 = *(_tmp580)
	  lw $t0, -868($fp)	# fill _tmp580 to $t0 from $fp-868
	  lw $t2, 0($t0) 	# load with offset
	  sw $t2, -872($fp)	# spill _tmp581 from $t2 to $fp-872
	# _tmp582 = 0
	  li $t2, 0		# load constant value 0 into $t2
	  sw $t2, -876($fp)	# spill _tmp582 from $t2 to $fp-876
	# _tmp583 = 0
	  li $t2, 0		# load constant value 0 into $t2
	  sw $t2, -880($fp)	# spill _tmp583 from $t2 to $fp-880
	# _tmp584 = *(_tmp581)
	  lw $t0, -872($fp)	# fill _tmp581 to $t0 from $fp-872
	  lw $t2, 0($t0) 	# load with offset
	  sw $t2, -884($fp)	# spill _tmp584 from $t2 to $fp-884
	# _tmp585 = _tmp582 < _tmp583
	  lw $t0, -876($fp)	# fill _tmp582 to $t0 from $fp-876
	  lw $t1, -880($fp)	# fill _tmp583 to $t1 from $fp-880
	  slt $t2, $t0, $t1	
	  sw $t2, -888($fp)	# spill _tmp585 from $t2 to $fp-888
	# _tmp586 = _tmp584 < _tmp582
	  lw $t0, -884($fp)	# fill _tmp584 to $t0 from $fp-884
	  lw $t1, -876($fp)	# fill _tmp582 to $t1 from $fp-876
	  slt $t2, $t0, $t1	
	  sw $t2, -892($fp)	# spill _tmp586 from $t2 to $fp-892
	# _tmp587 = _tmp584 == _tmp582
	  lw $t0, -884($fp)	# fill _tmp584 to $t0 from $fp-884
	  lw $t1, -876($fp)	# fill _tmp582 to $t1 from $fp-876
	  seq $t2, $t0, $t1	
	  sw $t2, -896($fp)	# spill _tmp587 from $t2 to $fp-896
	# _tmp588 = _tmp586 || _tmp587
	  lw $t0, -892($fp)	# fill _tmp586 to $t0 from $fp-892
	  lw $t1, -896($fp)	# fill _tmp587 to $t1 from $fp-896
	  or $t2, $t0, $t1	
	  sw $t2, -900($fp)	# spill _tmp588 from $t2 to $fp-900
	# _tmp589 = _tmp588 || _tmp585
	  lw $t0, -900($fp)	# fill _tmp588 to $t0 from $fp-900
	  lw $t1, -888($fp)	# fill _tmp585 to $t1 from $fp-888
	  or $t2, $t0, $t1	
	  sw $t2, -904($fp)	# spill _tmp589 from $t2 to $fp-904
	# IfZ _tmp589 Goto _L68
	  lw $t0, -904($fp)	# fill _tmp589 to $t0 from $fp-904
	  beqz $t0, _L68	# branch if _tmp589 is zero 
	# _tmp590 = "Decaf runtime error: Array subscript out of bound..."
	  .data			# create string constant marked with label
	  _string44: .asciiz "Decaf runtime error: Array subscript out of bounds\n"
	  .text
	  la $t2, _string44	# load label
	  sw $t2, -908($fp)	# spill _tmp590 from $t2 to $fp-908
	# PushParam _tmp590
	  subu $sp, $sp, 4	# decrement sp to make space for param
	  lw $t0, -908($fp)	# fill _tmp590 to $t0 from $fp-908
	  sw $t0, 4($sp)	# copy param value to stack
	# LCall _PrintString
	  jal _PrintString   	# jump to function
	# PopParams 4
	  add $sp, $sp, 4	# pop params off stack
	# LCall _Halt
	  jal _Halt          	# jump to function
  _L68:
	# _tmp591 = 4
	  li $t2, 4		# load constant value 4 into $t2
	  sw $t2, -912($fp)	# spill _tmp591 from $t2 to $fp-912
	# _tmp592 = _tmp582 * _tmp591
	  lw $t0, -876($fp)	# fill _tmp582 to $t0 from $fp-876
	  lw $t1, -912($fp)	# fill _tmp591 to $t1 from $fp-912
	  mul $t2, $t0, $t1	
	  sw $t2, -916($fp)	# spill _tmp592 from $t2 to $fp-916
	# _tmp593 = _tmp592 + _tmp591
	  lw $t0, -916($fp)	# fill _tmp592 to $t0 from $fp-916
	  lw $t1, -912($fp)	# fill _tmp591 to $t1 from $fp-912
	  add $t2, $t0, $t1	
	  sw $t2, -920($fp)	# spill _tmp593 from $t2 to $fp-920
	# _tmp594 = _tmp581 + _tmp593
	  lw $t0, -872($fp)	# fill _tmp581 to $t0 from $fp-872
	  lw $t1, -920($fp)	# fill _tmp593 to $t1 from $fp-920
	  add $t2, $t0, $t1	
	  sw $t2, -924($fp)	# spill _tmp594 from $t2 to $fp-924
	# _tmp595 = *(_tmp594)
	  lw $t0, -924($fp)	# fill _tmp594 to $t0 from $fp-924
	  lw $t2, 0($t0) 	# load with offset
	  sw $t2, -928($fp)	# spill _tmp595 from $t2 to $fp-928
	# PushParam _tmp595
	  subu $sp, $sp, 4	# decrement sp to make space for param
	  lw $t0, -928($fp)	# fill _tmp595 to $t0 from $fp-928
	  sw $t0, 4($sp)	# copy param value to stack
	# _tmp596 = *(_tmp595)
	  lw $t0, -928($fp)	# fill _tmp595 to $t0 from $fp-928
	  lw $t2, 0($t0) 	# load with offset
	  sw $t2, -932($fp)	# spill _tmp596 from $t2 to $fp-932
	# _tmp597 = *(_tmp596 + 20)
	  lw $t0, -932($fp)	# fill _tmp596 to $t0 from $fp-932
	  lw $t2, 20($t0) 	# load with offset
	  sw $t2, -936($fp)	# spill _tmp597 from $t2 to $fp-936
	# _tmp598 = ACall _tmp597
	  lw $t0, -936($fp)	# fill _tmp597 to $t0 from $fp-936
	  jalr $t0            	# jump to function
	  move $t2, $v0		# copy function return value from $v0
	  sw $t2, -940($fp)	# spill _tmp598 from $t2 to $fp-940
	# PopParams 8
	  add $sp, $sp, 8	# pop params off stack
	# PushParam mark
	  subu $sp, $sp, 4	# decrement sp to make space for param
	  lw $t0, -8($fp)	# fill mark to $t0 from $fp-8
	  sw $t0, 4($sp)	# copy param value to stack
	# _tmp599 = *(this + 4)
	  lw $t0, 4($fp)	# fill this to $t0 from $fp+4
	  lw $t2, 4($t0) 	# load with offset
	  sw $t2, -944($fp)	# spill _tmp599 from $t2 to $fp-944
	# _tmp600 = 2
	  li $t2, 2		# load constant value 2 into $t2
	  sw $t2, -948($fp)	# spill _tmp600 from $t2 to $fp-948
	# _tmp601 = 0
	  li $t2, 0		# load constant value 0 into $t2
	  sw $t2, -952($fp)	# spill _tmp601 from $t2 to $fp-952
	# _tmp602 = *(_tmp599)
	  lw $t0, -944($fp)	# fill _tmp599 to $t0 from $fp-944
	  lw $t2, 0($t0) 	# load with offset
	  sw $t2, -956($fp)	# spill _tmp602 from $t2 to $fp-956
	# _tmp603 = _tmp600 < _tmp601
	  lw $t0, -948($fp)	# fill _tmp600 to $t0 from $fp-948
	  lw $t1, -952($fp)	# fill _tmp601 to $t1 from $fp-952
	  slt $t2, $t0, $t1	
	  sw $t2, -960($fp)	# spill _tmp603 from $t2 to $fp-960
	# _tmp604 = _tmp602 < _tmp600
	  lw $t0, -956($fp)	# fill _tmp602 to $t0 from $fp-956
	  lw $t1, -948($fp)	# fill _tmp600 to $t1 from $fp-948
	  slt $t2, $t0, $t1	
	  sw $t2, -964($fp)	# spill _tmp604 from $t2 to $fp-964
	# _tmp605 = _tmp602 == _tmp600
	  lw $t0, -956($fp)	# fill _tmp602 to $t0 from $fp-956
	  lw $t1, -948($fp)	# fill _tmp600 to $t1 from $fp-948
	  seq $t2, $t0, $t1	
	  sw $t2, -968($fp)	# spill _tmp605 from $t2 to $fp-968
	# _tmp606 = _tmp604 || _tmp605
	  lw $t0, -964($fp)	# fill _tmp604 to $t0 from $fp-964
	  lw $t1, -968($fp)	# fill _tmp605 to $t1 from $fp-968
	  or $t2, $t0, $t1	
	  sw $t2, -972($fp)	# spill _tmp606 from $t2 to $fp-972
	# _tmp607 = _tmp606 || _tmp603
	  lw $t0, -972($fp)	# fill _tmp606 to $t0 from $fp-972
	  lw $t1, -960($fp)	# fill _tmp603 to $t1 from $fp-960
	  or $t2, $t0, $t1	
	  sw $t2, -976($fp)	# spill _tmp607 from $t2 to $fp-976
	# IfZ _tmp607 Goto _L69
	  lw $t0, -976($fp)	# fill _tmp607 to $t0 from $fp-976
	  beqz $t0, _L69	# branch if _tmp607 is zero 
	# _tmp608 = "Decaf runtime error: Array subscript out of bound..."
	  .data			# create string constant marked with label
	  _string45: .asciiz "Decaf runtime error: Array subscript out of bounds\n"
	  .text
	  la $t2, _string45	# load label
	  sw $t2, -980($fp)	# spill _tmp608 from $t2 to $fp-980
	# PushParam _tmp608
	  subu $sp, $sp, 4	# decrement sp to make space for param
	  lw $t0, -980($fp)	# fill _tmp608 to $t0 from $fp-980
	  sw $t0, 4($sp)	# copy param value to stack
	# LCall _PrintString
	  jal _PrintString   	# jump to function
	# PopParams 4
	  add $sp, $sp, 4	# pop params off stack
	# LCall _Halt
	  jal _Halt          	# jump to function
  _L69:
	# _tmp609 = 4
	  li $t2, 4		# load constant value 4 into $t2
	  sw $t2, -984($fp)	# spill _tmp609 from $t2 to $fp-984
	# _tmp610 = _tmp600 * _tmp609
	  lw $t0, -948($fp)	# fill _tmp600 to $t0 from $fp-948
	  lw $t1, -984($fp)	# fill _tmp609 to $t1 from $fp-984
	  mul $t2, $t0, $t1	
	  sw $t2, -988($fp)	# spill _tmp610 from $t2 to $fp-988
	# _tmp611 = _tmp610 + _tmp609
	  lw $t0, -988($fp)	# fill _tmp610 to $t0 from $fp-988
	  lw $t1, -984($fp)	# fill _tmp609 to $t1 from $fp-984
	  add $t2, $t0, $t1	
	  sw $t2, -992($fp)	# spill _tmp611 from $t2 to $fp-992
	# _tmp612 = _tmp599 + _tmp611
	  lw $t0, -944($fp)	# fill _tmp599 to $t0 from $fp-944
	  lw $t1, -992($fp)	# fill _tmp611 to $t1 from $fp-992
	  add $t2, $t0, $t1	
	  sw $t2, -996($fp)	# spill _tmp612 from $t2 to $fp-996
	# _tmp613 = *(_tmp612)
	  lw $t0, -996($fp)	# fill _tmp612 to $t0 from $fp-996
	  lw $t2, 0($t0) 	# load with offset
	  sw $t2, -1000($fp)	# spill _tmp613 from $t2 to $fp-1000
	# _tmp614 = 1
	  li $t2, 1		# load constant value 1 into $t2
	  sw $t2, -1004($fp)	# spill _tmp614 from $t2 to $fp-1004
	# _tmp615 = 0
	  li $t2, 0		# load constant value 0 into $t2
	  sw $t2, -1008($fp)	# spill _tmp615 from $t2 to $fp-1008
	# _tmp616 = *(_tmp613)
	  lw $t0, -1000($fp)	# fill _tmp613 to $t0 from $fp-1000
	  lw $t2, 0($t0) 	# load with offset
	  sw $t2, -1012($fp)	# spill _tmp616 from $t2 to $fp-1012
	# _tmp617 = _tmp614 < _tmp615
	  lw $t0, -1004($fp)	# fill _tmp614 to $t0 from $fp-1004
	  lw $t1, -1008($fp)	# fill _tmp615 to $t1 from $fp-1008
	  slt $t2, $t0, $t1	
	  sw $t2, -1016($fp)	# spill _tmp617 from $t2 to $fp-1016
	# _tmp618 = _tmp616 < _tmp614
	  lw $t0, -1012($fp)	# fill _tmp616 to $t0 from $fp-1012
	  lw $t1, -1004($fp)	# fill _tmp614 to $t1 from $fp-1004
	  slt $t2, $t0, $t1	
	  sw $t2, -1020($fp)	# spill _tmp618 from $t2 to $fp-1020
	# _tmp619 = _tmp616 == _tmp614
	  lw $t0, -1012($fp)	# fill _tmp616 to $t0 from $fp-1012
	  lw $t1, -1004($fp)	# fill _tmp614 to $t1 from $fp-1004
	  seq $t2, $t0, $t1	
	  sw $t2, -1024($fp)	# spill _tmp619 from $t2 to $fp-1024
	# _tmp620 = _tmp618 || _tmp619
	  lw $t0, -1020($fp)	# fill _tmp618 to $t0 from $fp-1020
	  lw $t1, -1024($fp)	# fill _tmp619 to $t1 from $fp-1024
	  or $t2, $t0, $t1	
	  sw $t2, -1028($fp)	# spill _tmp620 from $t2 to $fp-1028
	# _tmp621 = _tmp620 || _tmp617
	  lw $t0, -1028($fp)	# fill _tmp620 to $t0 from $fp-1028
	  lw $t1, -1016($fp)	# fill _tmp617 to $t1 from $fp-1016
	  or $t2, $t0, $t1	
	  sw $t2, -1032($fp)	# spill _tmp621 from $t2 to $fp-1032
	# IfZ _tmp621 Goto _L70
	  lw $t0, -1032($fp)	# fill _tmp621 to $t0 from $fp-1032
	  beqz $t0, _L70	# branch if _tmp621 is zero 
	# _tmp622 = "Decaf runtime error: Array subscript out of bound..."
	  .data			# create string constant marked with label
	  _string46: .asciiz "Decaf runtime error: Array subscript out of bounds\n"
	  .text
	  la $t2, _string46	# load label
	  sw $t2, -1036($fp)	# spill _tmp622 from $t2 to $fp-1036
	# PushParam _tmp622
	  subu $sp, $sp, 4	# decrement sp to make space for param
	  lw $t0, -1036($fp)	# fill _tmp622 to $t0 from $fp-1036
	  sw $t0, 4($sp)	# copy param value to stack
	# LCall _PrintString
	  jal _PrintString   	# jump to function
	# PopParams 4
	  add $sp, $sp, 4	# pop params off stack
	# LCall _Halt
	  jal _Halt          	# jump to function
  _L70:
	# _tmp623 = 4
	  li $t2, 4		# load constant value 4 into $t2
	  sw $t2, -1040($fp)	# spill _tmp623 from $t2 to $fp-1040
	# _tmp624 = _tmp614 * _tmp623
	  lw $t0, -1004($fp)	# fill _tmp614 to $t0 from $fp-1004
	  lw $t1, -1040($fp)	# fill _tmp623 to $t1 from $fp-1040
	  mul $t2, $t0, $t1	
	  sw $t2, -1044($fp)	# spill _tmp624 from $t2 to $fp-1044
	# _tmp625 = _tmp624 + _tmp623
	  lw $t0, -1044($fp)	# fill _tmp624 to $t0 from $fp-1044
	  lw $t1, -1040($fp)	# fill _tmp623 to $t1 from $fp-1040
	  add $t2, $t0, $t1	
	  sw $t2, -1048($fp)	# spill _tmp625 from $t2 to $fp-1048
	# _tmp626 = _tmp613 + _tmp625
	  lw $t0, -1000($fp)	# fill _tmp613 to $t0 from $fp-1000
	  lw $t1, -1048($fp)	# fill _tmp625 to $t1 from $fp-1048
	  add $t2, $t0, $t1	
	  sw $t2, -1052($fp)	# spill _tmp626 from $t2 to $fp-1052
	# _tmp627 = *(_tmp626)
	  lw $t0, -1052($fp)	# fill _tmp626 to $t0 from $fp-1052
	  lw $t2, 0($t0) 	# load with offset
	  sw $t2, -1056($fp)	# spill _tmp627 from $t2 to $fp-1056
	# PushParam _tmp627
	  subu $sp, $sp, 4	# decrement sp to make space for param
	  lw $t0, -1056($fp)	# fill _tmp627 to $t0 from $fp-1056
	  sw $t0, 4($sp)	# copy param value to stack
	# _tmp628 = *(_tmp627)
	  lw $t0, -1056($fp)	# fill _tmp627 to $t0 from $fp-1056
	  lw $t2, 0($t0) 	# load with offset
	  sw $t2, -1060($fp)	# spill _tmp628 from $t2 to $fp-1060
	# _tmp629 = *(_tmp628 + 20)
	  lw $t0, -1060($fp)	# fill _tmp628 to $t0 from $fp-1060
	  lw $t2, 20($t0) 	# load with offset
	  sw $t2, -1064($fp)	# spill _tmp629 from $t2 to $fp-1064
	# _tmp630 = ACall _tmp629
	  lw $t0, -1064($fp)	# fill _tmp629 to $t0 from $fp-1064
	  jalr $t0            	# jump to function
	  move $t2, $v0		# copy function return value from $v0
	  sw $t2, -1068($fp)	# spill _tmp630 from $t2 to $fp-1068
	# PopParams 8
	  add $sp, $sp, 8	# pop params off stack
	# _tmp631 = _tmp598 && _tmp630
	  lw $t0, -940($fp)	# fill _tmp598 to $t0 from $fp-940
	  lw $t1, -1068($fp)	# fill _tmp630 to $t1 from $fp-1068
	  and $t2, $t0, $t1	
	  sw $t2, -1072($fp)	# spill _tmp631 from $t2 to $fp-1072
	# PushParam mark
	  subu $sp, $sp, 4	# decrement sp to make space for param
	  lw $t0, -8($fp)	# fill mark to $t0 from $fp-8
	  sw $t0, 4($sp)	# copy param value to stack
	# _tmp632 = *(this + 4)
	  lw $t0, 4($fp)	# fill this to $t0 from $fp+4
	  lw $t2, 4($t0) 	# load with offset
	  sw $t2, -1076($fp)	# spill _tmp632 from $t2 to $fp-1076
	# _tmp633 = 2
	  li $t2, 2		# load constant value 2 into $t2
	  sw $t2, -1080($fp)	# spill _tmp633 from $t2 to $fp-1080
	# _tmp634 = 0
	  li $t2, 0		# load constant value 0 into $t2
	  sw $t2, -1084($fp)	# spill _tmp634 from $t2 to $fp-1084
	# _tmp635 = *(_tmp632)
	  lw $t0, -1076($fp)	# fill _tmp632 to $t0 from $fp-1076
	  lw $t2, 0($t0) 	# load with offset
	  sw $t2, -1088($fp)	# spill _tmp635 from $t2 to $fp-1088
	# _tmp636 = _tmp633 < _tmp634
	  lw $t0, -1080($fp)	# fill _tmp633 to $t0 from $fp-1080
	  lw $t1, -1084($fp)	# fill _tmp634 to $t1 from $fp-1084
	  slt $t2, $t0, $t1	
	  sw $t2, -1092($fp)	# spill _tmp636 from $t2 to $fp-1092
	# _tmp637 = _tmp635 < _tmp633
	  lw $t0, -1088($fp)	# fill _tmp635 to $t0 from $fp-1088
	  lw $t1, -1080($fp)	# fill _tmp633 to $t1 from $fp-1080
	  slt $t2, $t0, $t1	
	  sw $t2, -1096($fp)	# spill _tmp637 from $t2 to $fp-1096
	# _tmp638 = _tmp635 == _tmp633
	  lw $t0, -1088($fp)	# fill _tmp635 to $t0 from $fp-1088
	  lw $t1, -1080($fp)	# fill _tmp633 to $t1 from $fp-1080
	  seq $t2, $t0, $t1	
	  sw $t2, -1100($fp)	# spill _tmp638 from $t2 to $fp-1100
	# _tmp639 = _tmp637 || _tmp638
	  lw $t0, -1096($fp)	# fill _tmp637 to $t0 from $fp-1096
	  lw $t1, -1100($fp)	# fill _tmp638 to $t1 from $fp-1100
	  or $t2, $t0, $t1	
	  sw $t2, -1104($fp)	# spill _tmp639 from $t2 to $fp-1104
	# _tmp640 = _tmp639 || _tmp636
	  lw $t0, -1104($fp)	# fill _tmp639 to $t0 from $fp-1104
	  lw $t1, -1092($fp)	# fill _tmp636 to $t1 from $fp-1092
	  or $t2, $t0, $t1	
	  sw $t2, -1108($fp)	# spill _tmp640 from $t2 to $fp-1108
	# IfZ _tmp640 Goto _L71
	  lw $t0, -1108($fp)	# fill _tmp640 to $t0 from $fp-1108
	  beqz $t0, _L71	# branch if _tmp640 is zero 
	# _tmp641 = "Decaf runtime error: Array subscript out of bound..."
	  .data			# create string constant marked with label
	  _string47: .asciiz "Decaf runtime error: Array subscript out of bounds\n"
	  .text
	  la $t2, _string47	# load label
	  sw $t2, -1112($fp)	# spill _tmp641 from $t2 to $fp-1112
	# PushParam _tmp641
	  subu $sp, $sp, 4	# decrement sp to make space for param
	  lw $t0, -1112($fp)	# fill _tmp641 to $t0 from $fp-1112
	  sw $t0, 4($sp)	# copy param value to stack
	# LCall _PrintString
	  jal _PrintString   	# jump to function
	# PopParams 4
	  add $sp, $sp, 4	# pop params off stack
	# LCall _Halt
	  jal _Halt          	# jump to function
  _L71:
	# _tmp642 = 4
	  li $t2, 4		# load constant value 4 into $t2
	  sw $t2, -1116($fp)	# spill _tmp642 from $t2 to $fp-1116
	# _tmp643 = _tmp633 * _tmp642
	  lw $t0, -1080($fp)	# fill _tmp633 to $t0 from $fp-1080
	  lw $t1, -1116($fp)	# fill _tmp642 to $t1 from $fp-1116
	  mul $t2, $t0, $t1	
	  sw $t2, -1120($fp)	# spill _tmp643 from $t2 to $fp-1120
	# _tmp644 = _tmp643 + _tmp642
	  lw $t0, -1120($fp)	# fill _tmp643 to $t0 from $fp-1120
	  lw $t1, -1116($fp)	# fill _tmp642 to $t1 from $fp-1116
	  add $t2, $t0, $t1	
	  sw $t2, -1124($fp)	# spill _tmp644 from $t2 to $fp-1124
	# _tmp645 = _tmp632 + _tmp644
	  lw $t0, -1076($fp)	# fill _tmp632 to $t0 from $fp-1076
	  lw $t1, -1124($fp)	# fill _tmp644 to $t1 from $fp-1124
	  add $t2, $t0, $t1	
	  sw $t2, -1128($fp)	# spill _tmp645 from $t2 to $fp-1128
	# _tmp646 = *(_tmp645)
	  lw $t0, -1128($fp)	# fill _tmp645 to $t0 from $fp-1128
	  lw $t2, 0($t0) 	# load with offset
	  sw $t2, -1132($fp)	# spill _tmp646 from $t2 to $fp-1132
	# _tmp647 = 2
	  li $t2, 2		# load constant value 2 into $t2
	  sw $t2, -1136($fp)	# spill _tmp647 from $t2 to $fp-1136
	# _tmp648 = 0
	  li $t2, 0		# load constant value 0 into $t2
	  sw $t2, -1140($fp)	# spill _tmp648 from $t2 to $fp-1140
	# _tmp649 = *(_tmp646)
	  lw $t0, -1132($fp)	# fill _tmp646 to $t0 from $fp-1132
	  lw $t2, 0($t0) 	# load with offset
	  sw $t2, -1144($fp)	# spill _tmp649 from $t2 to $fp-1144
	# _tmp650 = _tmp647 < _tmp648
	  lw $t0, -1136($fp)	# fill _tmp647 to $t0 from $fp-1136
	  lw $t1, -1140($fp)	# fill _tmp648 to $t1 from $fp-1140
	  slt $t2, $t0, $t1	
	  sw $t2, -1148($fp)	# spill _tmp650 from $t2 to $fp-1148
	# _tmp651 = _tmp649 < _tmp647
	  lw $t0, -1144($fp)	# fill _tmp649 to $t0 from $fp-1144
	  lw $t1, -1136($fp)	# fill _tmp647 to $t1 from $fp-1136
	  slt $t2, $t0, $t1	
	  sw $t2, -1152($fp)	# spill _tmp651 from $t2 to $fp-1152
	# _tmp652 = _tmp649 == _tmp647
	  lw $t0, -1144($fp)	# fill _tmp649 to $t0 from $fp-1144
	  lw $t1, -1136($fp)	# fill _tmp647 to $t1 from $fp-1136
	  seq $t2, $t0, $t1	
	  sw $t2, -1156($fp)	# spill _tmp652 from $t2 to $fp-1156
	# _tmp653 = _tmp651 || _tmp652
	  lw $t0, -1152($fp)	# fill _tmp651 to $t0 from $fp-1152
	  lw $t1, -1156($fp)	# fill _tmp652 to $t1 from $fp-1156
	  or $t2, $t0, $t1	
	  sw $t2, -1160($fp)	# spill _tmp653 from $t2 to $fp-1160
	# _tmp654 = _tmp653 || _tmp650
	  lw $t0, -1160($fp)	# fill _tmp653 to $t0 from $fp-1160
	  lw $t1, -1148($fp)	# fill _tmp650 to $t1 from $fp-1148
	  or $t2, $t0, $t1	
	  sw $t2, -1164($fp)	# spill _tmp654 from $t2 to $fp-1164
	# IfZ _tmp654 Goto _L72
	  lw $t0, -1164($fp)	# fill _tmp654 to $t0 from $fp-1164
	  beqz $t0, _L72	# branch if _tmp654 is zero 
	# _tmp655 = "Decaf runtime error: Array subscript out of bound..."
	  .data			# create string constant marked with label
	  _string48: .asciiz "Decaf runtime error: Array subscript out of bounds\n"
	  .text
	  la $t2, _string48	# load label
	  sw $t2, -1168($fp)	# spill _tmp655 from $t2 to $fp-1168
	# PushParam _tmp655
	  subu $sp, $sp, 4	# decrement sp to make space for param
	  lw $t0, -1168($fp)	# fill _tmp655 to $t0 from $fp-1168
	  sw $t0, 4($sp)	# copy param value to stack
	# LCall _PrintString
	  jal _PrintString   	# jump to function
	# PopParams 4
	  add $sp, $sp, 4	# pop params off stack
	# LCall _Halt
	  jal _Halt          	# jump to function
  _L72:
	# _tmp656 = 4
	  li $t2, 4		# load constant value 4 into $t2
	  sw $t2, -1172($fp)	# spill _tmp656 from $t2 to $fp-1172
	# _tmp657 = _tmp647 * _tmp656
	  lw $t0, -1136($fp)	# fill _tmp647 to $t0 from $fp-1136
	  lw $t1, -1172($fp)	# fill _tmp656 to $t1 from $fp-1172
	  mul $t2, $t0, $t1	
	  sw $t2, -1176($fp)	# spill _tmp657 from $t2 to $fp-1176
	# _tmp658 = _tmp657 + _tmp656
	  lw $t0, -1176($fp)	# fill _tmp657 to $t0 from $fp-1176
	  lw $t1, -1172($fp)	# fill _tmp656 to $t1 from $fp-1172
	  add $t2, $t0, $t1	
	  sw $t2, -1180($fp)	# spill _tmp658 from $t2 to $fp-1180
	# _tmp659 = _tmp646 + _tmp658
	  lw $t0, -1132($fp)	# fill _tmp646 to $t0 from $fp-1132
	  lw $t1, -1180($fp)	# fill _tmp658 to $t1 from $fp-1180
	  add $t2, $t0, $t1	
	  sw $t2, -1184($fp)	# spill _tmp659 from $t2 to $fp-1184
	# _tmp660 = *(_tmp659)
	  lw $t0, -1184($fp)	# fill _tmp659 to $t0 from $fp-1184
	  lw $t2, 0($t0) 	# load with offset
	  sw $t2, -1188($fp)	# spill _tmp660 from $t2 to $fp-1188
	# PushParam _tmp660
	  subu $sp, $sp, 4	# decrement sp to make space for param
	  lw $t0, -1188($fp)	# fill _tmp660 to $t0 from $fp-1188
	  sw $t0, 4($sp)	# copy param value to stack
	# _tmp661 = *(_tmp660)
	  lw $t0, -1188($fp)	# fill _tmp660 to $t0 from $fp-1188
	  lw $t2, 0($t0) 	# load with offset
	  sw $t2, -1192($fp)	# spill _tmp661 from $t2 to $fp-1192
	# _tmp662 = *(_tmp661 + 20)
	  lw $t0, -1192($fp)	# fill _tmp661 to $t0 from $fp-1192
	  lw $t2, 20($t0) 	# load with offset
	  sw $t2, -1196($fp)	# spill _tmp662 from $t2 to $fp-1196
	# _tmp663 = ACall _tmp662
	  lw $t0, -1196($fp)	# fill _tmp662 to $t0 from $fp-1196
	  jalr $t0            	# jump to function
	  move $t2, $v0		# copy function return value from $v0
	  sw $t2, -1200($fp)	# spill _tmp663 from $t2 to $fp-1200
	# PopParams 8
	  add $sp, $sp, 8	# pop params off stack
	# _tmp664 = _tmp631 && _tmp663
	  lw $t0, -1072($fp)	# fill _tmp631 to $t0 from $fp-1072
	  lw $t1, -1200($fp)	# fill _tmp663 to $t1 from $fp-1200
	  and $t2, $t0, $t1	
	  sw $t2, -1204($fp)	# spill _tmp664 from $t2 to $fp-1204
	# IfZ _tmp664 Goto _L65
	  lw $t0, -1204($fp)	# fill _tmp664 to $t0 from $fp-1204
	  beqz $t0, _L65	# branch if _tmp664 is zero 
	# _tmp665 = 0
	  li $t2, 0		# load constant value 0 into $t2
	  sw $t2, -1208($fp)	# spill _tmp665 from $t2 to $fp-1208
	# Return _tmp665
	  lw $t2, -1208($fp)	# fill _tmp665 to $t2 from $fp-1208
	  move $v0, $t2		# assign return value into $v0
	  move $sp, $fp		# pop callee frame off stack
	  lw $ra, -4($fp)	# restore saved ra
	  lw $fp, 0($fp)	# restore saved fp
	  jr $ra		# return from function
	# Goto _L66
	  b _L66		# unconditional branch
  _L65:
	# PushParam mark
	  subu $sp, $sp, 4	# decrement sp to make space for param
	  lw $t0, -8($fp)	# fill mark to $t0 from $fp-8
	  sw $t0, 4($sp)	# copy param value to stack
	# _tmp666 = *(this + 4)
	  lw $t0, 4($fp)	# fill this to $t0 from $fp+4
	  lw $t2, 4($t0) 	# load with offset
	  sw $t2, -1212($fp)	# spill _tmp666 from $t2 to $fp-1212
	# _tmp667 = 0
	  li $t2, 0		# load constant value 0 into $t2
	  sw $t2, -1216($fp)	# spill _tmp667 from $t2 to $fp-1216
	# _tmp668 = 0
	  li $t2, 0		# load constant value 0 into $t2
	  sw $t2, -1220($fp)	# spill _tmp668 from $t2 to $fp-1220
	# _tmp669 = *(_tmp666)
	  lw $t0, -1212($fp)	# fill _tmp666 to $t0 from $fp-1212
	  lw $t2, 0($t0) 	# load with offset
	  sw $t2, -1224($fp)	# spill _tmp669 from $t2 to $fp-1224
	# _tmp670 = _tmp667 < _tmp668
	  lw $t0, -1216($fp)	# fill _tmp667 to $t0 from $fp-1216
	  lw $t1, -1220($fp)	# fill _tmp668 to $t1 from $fp-1220
	  slt $t2, $t0, $t1	
	  sw $t2, -1228($fp)	# spill _tmp670 from $t2 to $fp-1228
	# _tmp671 = _tmp669 < _tmp667
	  lw $t0, -1224($fp)	# fill _tmp669 to $t0 from $fp-1224
	  lw $t1, -1216($fp)	# fill _tmp667 to $t1 from $fp-1216
	  slt $t2, $t0, $t1	
	  sw $t2, -1232($fp)	# spill _tmp671 from $t2 to $fp-1232
	# _tmp672 = _tmp669 == _tmp667
	  lw $t0, -1224($fp)	# fill _tmp669 to $t0 from $fp-1224
	  lw $t1, -1216($fp)	# fill _tmp667 to $t1 from $fp-1216
	  seq $t2, $t0, $t1	
	  sw $t2, -1236($fp)	# spill _tmp672 from $t2 to $fp-1236
	# _tmp673 = _tmp671 || _tmp672
	  lw $t0, -1232($fp)	# fill _tmp671 to $t0 from $fp-1232
	  lw $t1, -1236($fp)	# fill _tmp672 to $t1 from $fp-1236
	  or $t2, $t0, $t1	
	  sw $t2, -1240($fp)	# spill _tmp673 from $t2 to $fp-1240
	# _tmp674 = _tmp673 || _tmp670
	  lw $t0, -1240($fp)	# fill _tmp673 to $t0 from $fp-1240
	  lw $t1, -1228($fp)	# fill _tmp670 to $t1 from $fp-1228
	  or $t2, $t0, $t1	
	  sw $t2, -1244($fp)	# spill _tmp674 from $t2 to $fp-1244
	# IfZ _tmp674 Goto _L75
	  lw $t0, -1244($fp)	# fill _tmp674 to $t0 from $fp-1244
	  beqz $t0, _L75	# branch if _tmp674 is zero 
	# _tmp675 = "Decaf runtime error: Array subscript out of bound..."
	  .data			# create string constant marked with label
	  _string49: .asciiz "Decaf runtime error: Array subscript out of bounds\n"
	  .text
	  la $t2, _string49	# load label
	  sw $t2, -1248($fp)	# spill _tmp675 from $t2 to $fp-1248
	# PushParam _tmp675
	  subu $sp, $sp, 4	# decrement sp to make space for param
	  lw $t0, -1248($fp)	# fill _tmp675 to $t0 from $fp-1248
	  sw $t0, 4($sp)	# copy param value to stack
	# LCall _PrintString
	  jal _PrintString   	# jump to function
	# PopParams 4
	  add $sp, $sp, 4	# pop params off stack
	# LCall _Halt
	  jal _Halt          	# jump to function
  _L75:
	# _tmp676 = 4
	  li $t2, 4		# load constant value 4 into $t2
	  sw $t2, -1252($fp)	# spill _tmp676 from $t2 to $fp-1252
	# _tmp677 = _tmp667 * _tmp676
	  lw $t0, -1216($fp)	# fill _tmp667 to $t0 from $fp-1216
	  lw $t1, -1252($fp)	# fill _tmp676 to $t1 from $fp-1252
	  mul $t2, $t0, $t1	
	  sw $t2, -1256($fp)	# spill _tmp677 from $t2 to $fp-1256
	# _tmp678 = _tmp677 + _tmp676
	  lw $t0, -1256($fp)	# fill _tmp677 to $t0 from $fp-1256
	  lw $t1, -1252($fp)	# fill _tmp676 to $t1 from $fp-1252
	  add $t2, $t0, $t1	
	  sw $t2, -1260($fp)	# spill _tmp678 from $t2 to $fp-1260
	# _tmp679 = _tmp666 + _tmp678
	  lw $t0, -1212($fp)	# fill _tmp666 to $t0 from $fp-1212
	  lw $t1, -1260($fp)	# fill _tmp678 to $t1 from $fp-1260
	  add $t2, $t0, $t1	
	  sw $t2, -1264($fp)	# spill _tmp679 from $t2 to $fp-1264
	# _tmp680 = *(_tmp679)
	  lw $t0, -1264($fp)	# fill _tmp679 to $t0 from $fp-1264
	  lw $t2, 0($t0) 	# load with offset
	  sw $t2, -1268($fp)	# spill _tmp680 from $t2 to $fp-1268
	# _tmp681 = 0
	  li $t2, 0		# load constant value 0 into $t2
	  sw $t2, -1272($fp)	# spill _tmp681 from $t2 to $fp-1272
	# _tmp682 = 0
	  li $t2, 0		# load constant value 0 into $t2
	  sw $t2, -1276($fp)	# spill _tmp682 from $t2 to $fp-1276
	# _tmp683 = *(_tmp680)
	  lw $t0, -1268($fp)	# fill _tmp680 to $t0 from $fp-1268
	  lw $t2, 0($t0) 	# load with offset
	  sw $t2, -1280($fp)	# spill _tmp683 from $t2 to $fp-1280
	# _tmp684 = _tmp681 < _tmp682
	  lw $t0, -1272($fp)	# fill _tmp681 to $t0 from $fp-1272
	  lw $t1, -1276($fp)	# fill _tmp682 to $t1 from $fp-1276
	  slt $t2, $t0, $t1	
	  sw $t2, -1284($fp)	# spill _tmp684 from $t2 to $fp-1284
	# _tmp685 = _tmp683 < _tmp681
	  lw $t0, -1280($fp)	# fill _tmp683 to $t0 from $fp-1280
	  lw $t1, -1272($fp)	# fill _tmp681 to $t1 from $fp-1272
	  slt $t2, $t0, $t1	
	  sw $t2, -1288($fp)	# spill _tmp685 from $t2 to $fp-1288
	# _tmp686 = _tmp683 == _tmp681
	  lw $t0, -1280($fp)	# fill _tmp683 to $t0 from $fp-1280
	  lw $t1, -1272($fp)	# fill _tmp681 to $t1 from $fp-1272
	  seq $t2, $t0, $t1	
	  sw $t2, -1292($fp)	# spill _tmp686 from $t2 to $fp-1292
	# _tmp687 = _tmp685 || _tmp686
	  lw $t0, -1288($fp)	# fill _tmp685 to $t0 from $fp-1288
	  lw $t1, -1292($fp)	# fill _tmp686 to $t1 from $fp-1292
	  or $t2, $t0, $t1	
	  sw $t2, -1296($fp)	# spill _tmp687 from $t2 to $fp-1296
	# _tmp688 = _tmp687 || _tmp684
	  lw $t0, -1296($fp)	# fill _tmp687 to $t0 from $fp-1296
	  lw $t1, -1284($fp)	# fill _tmp684 to $t1 from $fp-1284
	  or $t2, $t0, $t1	
	  sw $t2, -1300($fp)	# spill _tmp688 from $t2 to $fp-1300
	# IfZ _tmp688 Goto _L76
	  lw $t0, -1300($fp)	# fill _tmp688 to $t0 from $fp-1300
	  beqz $t0, _L76	# branch if _tmp688 is zero 
	# _tmp689 = "Decaf runtime error: Array subscript out of bound..."
	  .data			# create string constant marked with label
	  _string50: .asciiz "Decaf runtime error: Array subscript out of bounds\n"
	  .text
	  la $t2, _string50	# load label
	  sw $t2, -1304($fp)	# spill _tmp689 from $t2 to $fp-1304
	# PushParam _tmp689
	  subu $sp, $sp, 4	# decrement sp to make space for param
	  lw $t0, -1304($fp)	# fill _tmp689 to $t0 from $fp-1304
	  sw $t0, 4($sp)	# copy param value to stack
	# LCall _PrintString
	  jal _PrintString   	# jump to function
	# PopParams 4
	  add $sp, $sp, 4	# pop params off stack
	# LCall _Halt
	  jal _Halt          	# jump to function
  _L76:
	# _tmp690 = 4
	  li $t2, 4		# load constant value 4 into $t2
	  sw $t2, -1308($fp)	# spill _tmp690 from $t2 to $fp-1308
	# _tmp691 = _tmp681 * _tmp690
	  lw $t0, -1272($fp)	# fill _tmp681 to $t0 from $fp-1272
	  lw $t1, -1308($fp)	# fill _tmp690 to $t1 from $fp-1308
	  mul $t2, $t0, $t1	
	  sw $t2, -1312($fp)	# spill _tmp691 from $t2 to $fp-1312
	# _tmp692 = _tmp691 + _tmp690
	  lw $t0, -1312($fp)	# fill _tmp691 to $t0 from $fp-1312
	  lw $t1, -1308($fp)	# fill _tmp690 to $t1 from $fp-1308
	  add $t2, $t0, $t1	
	  sw $t2, -1316($fp)	# spill _tmp692 from $t2 to $fp-1316
	# _tmp693 = _tmp680 + _tmp692
	  lw $t0, -1268($fp)	# fill _tmp680 to $t0 from $fp-1268
	  lw $t1, -1316($fp)	# fill _tmp692 to $t1 from $fp-1316
	  add $t2, $t0, $t1	
	  sw $t2, -1320($fp)	# spill _tmp693 from $t2 to $fp-1320
	# _tmp694 = *(_tmp693)
	  lw $t0, -1320($fp)	# fill _tmp693 to $t0 from $fp-1320
	  lw $t2, 0($t0) 	# load with offset
	  sw $t2, -1324($fp)	# spill _tmp694 from $t2 to $fp-1324
	# PushParam _tmp694
	  subu $sp, $sp, 4	# decrement sp to make space for param
	  lw $t0, -1324($fp)	# fill _tmp694 to $t0 from $fp-1324
	  sw $t0, 4($sp)	# copy param value to stack
	# _tmp695 = *(_tmp694)
	  lw $t0, -1324($fp)	# fill _tmp694 to $t0 from $fp-1324
	  lw $t2, 0($t0) 	# load with offset
	  sw $t2, -1328($fp)	# spill _tmp695 from $t2 to $fp-1328
	# _tmp696 = *(_tmp695 + 20)
	  lw $t0, -1328($fp)	# fill _tmp695 to $t0 from $fp-1328
	  lw $t2, 20($t0) 	# load with offset
	  sw $t2, -1332($fp)	# spill _tmp696 from $t2 to $fp-1332
	# _tmp697 = ACall _tmp696
	  lw $t0, -1332($fp)	# fill _tmp696 to $t0 from $fp-1332
	  jalr $t0            	# jump to function
	  move $t2, $v0		# copy function return value from $v0
	  sw $t2, -1336($fp)	# spill _tmp697 from $t2 to $fp-1336
	# PopParams 8
	  add $sp, $sp, 8	# pop params off stack
	# PushParam mark
	  subu $sp, $sp, 4	# decrement sp to make space for param
	  lw $t0, -8($fp)	# fill mark to $t0 from $fp-8
	  sw $t0, 4($sp)	# copy param value to stack
	# _tmp698 = *(this + 4)
	  lw $t0, 4($fp)	# fill this to $t0 from $fp+4
	  lw $t2, 4($t0) 	# load with offset
	  sw $t2, -1340($fp)	# spill _tmp698 from $t2 to $fp-1340
	# _tmp699 = 1
	  li $t2, 1		# load constant value 1 into $t2
	  sw $t2, -1344($fp)	# spill _tmp699 from $t2 to $fp-1344
	# _tmp700 = 0
	  li $t2, 0		# load constant value 0 into $t2
	  sw $t2, -1348($fp)	# spill _tmp700 from $t2 to $fp-1348
	# _tmp701 = *(_tmp698)
	  lw $t0, -1340($fp)	# fill _tmp698 to $t0 from $fp-1340
	  lw $t2, 0($t0) 	# load with offset
	  sw $t2, -1352($fp)	# spill _tmp701 from $t2 to $fp-1352
	# _tmp702 = _tmp699 < _tmp700
	  lw $t0, -1344($fp)	# fill _tmp699 to $t0 from $fp-1344
	  lw $t1, -1348($fp)	# fill _tmp700 to $t1 from $fp-1348
	  slt $t2, $t0, $t1	
	  sw $t2, -1356($fp)	# spill _tmp702 from $t2 to $fp-1356
	# _tmp703 = _tmp701 < _tmp699
	  lw $t0, -1352($fp)	# fill _tmp701 to $t0 from $fp-1352
	  lw $t1, -1344($fp)	# fill _tmp699 to $t1 from $fp-1344
	  slt $t2, $t0, $t1	
	  sw $t2, -1360($fp)	# spill _tmp703 from $t2 to $fp-1360
	# _tmp704 = _tmp701 == _tmp699
	  lw $t0, -1352($fp)	# fill _tmp701 to $t0 from $fp-1352
	  lw $t1, -1344($fp)	# fill _tmp699 to $t1 from $fp-1344
	  seq $t2, $t0, $t1	
	  sw $t2, -1364($fp)	# spill _tmp704 from $t2 to $fp-1364
	# _tmp705 = _tmp703 || _tmp704
	  lw $t0, -1360($fp)	# fill _tmp703 to $t0 from $fp-1360
	  lw $t1, -1364($fp)	# fill _tmp704 to $t1 from $fp-1364
	  or $t2, $t0, $t1	
	  sw $t2, -1368($fp)	# spill _tmp705 from $t2 to $fp-1368
	# _tmp706 = _tmp705 || _tmp702
	  lw $t0, -1368($fp)	# fill _tmp705 to $t0 from $fp-1368
	  lw $t1, -1356($fp)	# fill _tmp702 to $t1 from $fp-1356
	  or $t2, $t0, $t1	
	  sw $t2, -1372($fp)	# spill _tmp706 from $t2 to $fp-1372
	# IfZ _tmp706 Goto _L77
	  lw $t0, -1372($fp)	# fill _tmp706 to $t0 from $fp-1372
	  beqz $t0, _L77	# branch if _tmp706 is zero 
	# _tmp707 = "Decaf runtime error: Array subscript out of bound..."
	  .data			# create string constant marked with label
	  _string51: .asciiz "Decaf runtime error: Array subscript out of bounds\n"
	  .text
	  la $t2, _string51	# load label
	  sw $t2, -1376($fp)	# spill _tmp707 from $t2 to $fp-1376
	# PushParam _tmp707
	  subu $sp, $sp, 4	# decrement sp to make space for param
	  lw $t0, -1376($fp)	# fill _tmp707 to $t0 from $fp-1376
	  sw $t0, 4($sp)	# copy param value to stack
	# LCall _PrintString
	  jal _PrintString   	# jump to function
	# PopParams 4
	  add $sp, $sp, 4	# pop params off stack
	# LCall _Halt
	  jal _Halt          	# jump to function
  _L77:
	# _tmp708 = 4
	  li $t2, 4		# load constant value 4 into $t2
	  sw $t2, -1380($fp)	# spill _tmp708 from $t2 to $fp-1380
	# _tmp709 = _tmp699 * _tmp708
	  lw $t0, -1344($fp)	# fill _tmp699 to $t0 from $fp-1344
	  lw $t1, -1380($fp)	# fill _tmp708 to $t1 from $fp-1380
	  mul $t2, $t0, $t1	
	  sw $t2, -1384($fp)	# spill _tmp709 from $t2 to $fp-1384
	# _tmp710 = _tmp709 + _tmp708
	  lw $t0, -1384($fp)	# fill _tmp709 to $t0 from $fp-1384
	  lw $t1, -1380($fp)	# fill _tmp708 to $t1 from $fp-1380
	  add $t2, $t0, $t1	
	  sw $t2, -1388($fp)	# spill _tmp710 from $t2 to $fp-1388
	# _tmp711 = _tmp698 + _tmp710
	  lw $t0, -1340($fp)	# fill _tmp698 to $t0 from $fp-1340
	  lw $t1, -1388($fp)	# fill _tmp710 to $t1 from $fp-1388
	  add $t2, $t0, $t1	
	  sw $t2, -1392($fp)	# spill _tmp711 from $t2 to $fp-1392
	# _tmp712 = *(_tmp711)
	  lw $t0, -1392($fp)	# fill _tmp711 to $t0 from $fp-1392
	  lw $t2, 0($t0) 	# load with offset
	  sw $t2, -1396($fp)	# spill _tmp712 from $t2 to $fp-1396
	# _tmp713 = 0
	  li $t2, 0		# load constant value 0 into $t2
	  sw $t2, -1400($fp)	# spill _tmp713 from $t2 to $fp-1400
	# _tmp714 = 0
	  li $t2, 0		# load constant value 0 into $t2
	  sw $t2, -1404($fp)	# spill _tmp714 from $t2 to $fp-1404
	# _tmp715 = *(_tmp712)
	  lw $t0, -1396($fp)	# fill _tmp712 to $t0 from $fp-1396
	  lw $t2, 0($t0) 	# load with offset
	  sw $t2, -1408($fp)	# spill _tmp715 from $t2 to $fp-1408
	# _tmp716 = _tmp713 < _tmp714
	  lw $t0, -1400($fp)	# fill _tmp713 to $t0 from $fp-1400
	  lw $t1, -1404($fp)	# fill _tmp714 to $t1 from $fp-1404
	  slt $t2, $t0, $t1	
	  sw $t2, -1412($fp)	# spill _tmp716 from $t2 to $fp-1412
	# _tmp717 = _tmp715 < _tmp713
	  lw $t0, -1408($fp)	# fill _tmp715 to $t0 from $fp-1408
	  lw $t1, -1400($fp)	# fill _tmp713 to $t1 from $fp-1400
	  slt $t2, $t0, $t1	
	  sw $t2, -1416($fp)	# spill _tmp717 from $t2 to $fp-1416
	# _tmp718 = _tmp715 == _tmp713
	  lw $t0, -1408($fp)	# fill _tmp715 to $t0 from $fp-1408
	  lw $t1, -1400($fp)	# fill _tmp713 to $t1 from $fp-1400
	  seq $t2, $t0, $t1	
	  sw $t2, -1420($fp)	# spill _tmp718 from $t2 to $fp-1420
	# _tmp719 = _tmp717 || _tmp718
	  lw $t0, -1416($fp)	# fill _tmp717 to $t0 from $fp-1416
	  lw $t1, -1420($fp)	# fill _tmp718 to $t1 from $fp-1420
	  or $t2, $t0, $t1	
	  sw $t2, -1424($fp)	# spill _tmp719 from $t2 to $fp-1424
	# _tmp720 = _tmp719 || _tmp716
	  lw $t0, -1424($fp)	# fill _tmp719 to $t0 from $fp-1424
	  lw $t1, -1412($fp)	# fill _tmp716 to $t1 from $fp-1412
	  or $t2, $t0, $t1	
	  sw $t2, -1428($fp)	# spill _tmp720 from $t2 to $fp-1428
	# IfZ _tmp720 Goto _L78
	  lw $t0, -1428($fp)	# fill _tmp720 to $t0 from $fp-1428
	  beqz $t0, _L78	# branch if _tmp720 is zero 
	# _tmp721 = "Decaf runtime error: Array subscript out of bound..."
	  .data			# create string constant marked with label
	  _string52: .asciiz "Decaf runtime error: Array subscript out of bounds\n"
	  .text
	  la $t2, _string52	# load label
	  sw $t2, -1432($fp)	# spill _tmp721 from $t2 to $fp-1432
	# PushParam _tmp721
	  subu $sp, $sp, 4	# decrement sp to make space for param
	  lw $t0, -1432($fp)	# fill _tmp721 to $t0 from $fp-1432
	  sw $t0, 4($sp)	# copy param value to stack
	# LCall _PrintString
	  jal _PrintString   	# jump to function
	# PopParams 4
	  add $sp, $sp, 4	# pop params off stack
	# LCall _Halt
	  jal _Halt          	# jump to function
  _L78:
	# _tmp722 = 4
	  li $t2, 4		# load constant value 4 into $t2
	  sw $t2, -1436($fp)	# spill _tmp722 from $t2 to $fp-1436
	# _tmp723 = _tmp713 * _tmp722
	  lw $t0, -1400($fp)	# fill _tmp713 to $t0 from $fp-1400
	  lw $t1, -1436($fp)	# fill _tmp722 to $t1 from $fp-1436
	  mul $t2, $t0, $t1	
	  sw $t2, -1440($fp)	# spill _tmp723 from $t2 to $fp-1440
	# _tmp724 = _tmp723 + _tmp722
	  lw $t0, -1440($fp)	# fill _tmp723 to $t0 from $fp-1440
	  lw $t1, -1436($fp)	# fill _tmp722 to $t1 from $fp-1436
	  add $t2, $t0, $t1	
	  sw $t2, -1444($fp)	# spill _tmp724 from $t2 to $fp-1444
	# _tmp725 = _tmp712 + _tmp724
	  lw $t0, -1396($fp)	# fill _tmp712 to $t0 from $fp-1396
	  lw $t1, -1444($fp)	# fill _tmp724 to $t1 from $fp-1444
	  add $t2, $t0, $t1	
	  sw $t2, -1448($fp)	# spill _tmp725 from $t2 to $fp-1448
	# _tmp726 = *(_tmp725)
	  lw $t0, -1448($fp)	# fill _tmp725 to $t0 from $fp-1448
	  lw $t2, 0($t0) 	# load with offset
	  sw $t2, -1452($fp)	# spill _tmp726 from $t2 to $fp-1452
	# PushParam _tmp726
	  subu $sp, $sp, 4	# decrement sp to make space for param
	  lw $t0, -1452($fp)	# fill _tmp726 to $t0 from $fp-1452
	  sw $t0, 4($sp)	# copy param value to stack
	# _tmp727 = *(_tmp726)
	  lw $t0, -1452($fp)	# fill _tmp726 to $t0 from $fp-1452
	  lw $t2, 0($t0) 	# load with offset
	  sw $t2, -1456($fp)	# spill _tmp727 from $t2 to $fp-1456
	# _tmp728 = *(_tmp727 + 20)
	  lw $t0, -1456($fp)	# fill _tmp727 to $t0 from $fp-1456
	  lw $t2, 20($t0) 	# load with offset
	  sw $t2, -1460($fp)	# spill _tmp728 from $t2 to $fp-1460
	# _tmp729 = ACall _tmp728
	  lw $t0, -1460($fp)	# fill _tmp728 to $t0 from $fp-1460
	  jalr $t0            	# jump to function
	  move $t2, $v0		# copy function return value from $v0
	  sw $t2, -1464($fp)	# spill _tmp729 from $t2 to $fp-1464
	# PopParams 8
	  add $sp, $sp, 8	# pop params off stack
	# _tmp730 = _tmp697 && _tmp729
	  lw $t0, -1336($fp)	# fill _tmp697 to $t0 from $fp-1336
	  lw $t1, -1464($fp)	# fill _tmp729 to $t1 from $fp-1464
	  and $t2, $t0, $t1	
	  sw $t2, -1468($fp)	# spill _tmp730 from $t2 to $fp-1468
	# PushParam mark
	  subu $sp, $sp, 4	# decrement sp to make space for param
	  lw $t0, -8($fp)	# fill mark to $t0 from $fp-8
	  sw $t0, 4($sp)	# copy param value to stack
	# _tmp731 = *(this + 4)
	  lw $t0, 4($fp)	# fill this to $t0 from $fp+4
	  lw $t2, 4($t0) 	# load with offset
	  sw $t2, -1472($fp)	# spill _tmp731 from $t2 to $fp-1472
	# _tmp732 = 2
	  li $t2, 2		# load constant value 2 into $t2
	  sw $t2, -1476($fp)	# spill _tmp732 from $t2 to $fp-1476
	# _tmp733 = 0
	  li $t2, 0		# load constant value 0 into $t2
	  sw $t2, -1480($fp)	# spill _tmp733 from $t2 to $fp-1480
	# _tmp734 = *(_tmp731)
	  lw $t0, -1472($fp)	# fill _tmp731 to $t0 from $fp-1472
	  lw $t2, 0($t0) 	# load with offset
	  sw $t2, -1484($fp)	# spill _tmp734 from $t2 to $fp-1484
	# _tmp735 = _tmp732 < _tmp733
	  lw $t0, -1476($fp)	# fill _tmp732 to $t0 from $fp-1476
	  lw $t1, -1480($fp)	# fill _tmp733 to $t1 from $fp-1480
	  slt $t2, $t0, $t1	
	  sw $t2, -1488($fp)	# spill _tmp735 from $t2 to $fp-1488
	# _tmp736 = _tmp734 < _tmp732
	  lw $t0, -1484($fp)	# fill _tmp734 to $t0 from $fp-1484
	  lw $t1, -1476($fp)	# fill _tmp732 to $t1 from $fp-1476
	  slt $t2, $t0, $t1	
	  sw $t2, -1492($fp)	# spill _tmp736 from $t2 to $fp-1492
	# _tmp737 = _tmp734 == _tmp732
	  lw $t0, -1484($fp)	# fill _tmp734 to $t0 from $fp-1484
	  lw $t1, -1476($fp)	# fill _tmp732 to $t1 from $fp-1476
	  seq $t2, $t0, $t1	
	  sw $t2, -1496($fp)	# spill _tmp737 from $t2 to $fp-1496
	# _tmp738 = _tmp736 || _tmp737
	  lw $t0, -1492($fp)	# fill _tmp736 to $t0 from $fp-1492
	  lw $t1, -1496($fp)	# fill _tmp737 to $t1 from $fp-1496
	  or $t2, $t0, $t1	
	  sw $t2, -1500($fp)	# spill _tmp738 from $t2 to $fp-1500
	# _tmp739 = _tmp738 || _tmp735
	  lw $t0, -1500($fp)	# fill _tmp738 to $t0 from $fp-1500
	  lw $t1, -1488($fp)	# fill _tmp735 to $t1 from $fp-1488
	  or $t2, $t0, $t1	
	  sw $t2, -1504($fp)	# spill _tmp739 from $t2 to $fp-1504
	# IfZ _tmp739 Goto _L79
	  lw $t0, -1504($fp)	# fill _tmp739 to $t0 from $fp-1504
	  beqz $t0, _L79	# branch if _tmp739 is zero 
	# _tmp740 = "Decaf runtime error: Array subscript out of bound..."
	  .data			# create string constant marked with label
	  _string53: .asciiz "Decaf runtime error: Array subscript out of bounds\n"
	  .text
	  la $t2, _string53	# load label
	  sw $t2, -1508($fp)	# spill _tmp740 from $t2 to $fp-1508
	# PushParam _tmp740
	  subu $sp, $sp, 4	# decrement sp to make space for param
	  lw $t0, -1508($fp)	# fill _tmp740 to $t0 from $fp-1508
	  sw $t0, 4($sp)	# copy param value to stack
	# LCall _PrintString
	  jal _PrintString   	# jump to function
	# PopParams 4
	  add $sp, $sp, 4	# pop params off stack
	# LCall _Halt
	  jal _Halt          	# jump to function
  _L79:
	# _tmp741 = 4
	  li $t2, 4		# load constant value 4 into $t2
	  sw $t2, -1512($fp)	# spill _tmp741 from $t2 to $fp-1512
	# _tmp742 = _tmp732 * _tmp741
	  lw $t0, -1476($fp)	# fill _tmp732 to $t0 from $fp-1476
	  lw $t1, -1512($fp)	# fill _tmp741 to $t1 from $fp-1512
	  mul $t2, $t0, $t1	
	  sw $t2, -1516($fp)	# spill _tmp742 from $t2 to $fp-1516
	# _tmp743 = _tmp742 + _tmp741
	  lw $t0, -1516($fp)	# fill _tmp742 to $t0 from $fp-1516
	  lw $t1, -1512($fp)	# fill _tmp741 to $t1 from $fp-1512
	  add $t2, $t0, $t1	
	  sw $t2, -1520($fp)	# spill _tmp743 from $t2 to $fp-1520
	# _tmp744 = _tmp731 + _tmp743
	  lw $t0, -1472($fp)	# fill _tmp731 to $t0 from $fp-1472
	  lw $t1, -1520($fp)	# fill _tmp743 to $t1 from $fp-1520
	  add $t2, $t0, $t1	
	  sw $t2, -1524($fp)	# spill _tmp744 from $t2 to $fp-1524
	# _tmp745 = *(_tmp744)
	  lw $t0, -1524($fp)	# fill _tmp744 to $t0 from $fp-1524
	  lw $t2, 0($t0) 	# load with offset
	  sw $t2, -1528($fp)	# spill _tmp745 from $t2 to $fp-1528
	# _tmp746 = 0
	  li $t2, 0		# load constant value 0 into $t2
	  sw $t2, -1532($fp)	# spill _tmp746 from $t2 to $fp-1532
	# _tmp747 = 0
	  li $t2, 0		# load constant value 0 into $t2
	  sw $t2, -1536($fp)	# spill _tmp747 from $t2 to $fp-1536
	# _tmp748 = *(_tmp745)
	  lw $t0, -1528($fp)	# fill _tmp745 to $t0 from $fp-1528
	  lw $t2, 0($t0) 	# load with offset
	  sw $t2, -1540($fp)	# spill _tmp748 from $t2 to $fp-1540
	# _tmp749 = _tmp746 < _tmp747
	  lw $t0, -1532($fp)	# fill _tmp746 to $t0 from $fp-1532
	  lw $t1, -1536($fp)	# fill _tmp747 to $t1 from $fp-1536
	  slt $t2, $t0, $t1	
	  sw $t2, -1544($fp)	# spill _tmp749 from $t2 to $fp-1544
	# _tmp750 = _tmp748 < _tmp746
	  lw $t0, -1540($fp)	# fill _tmp748 to $t0 from $fp-1540
	  lw $t1, -1532($fp)	# fill _tmp746 to $t1 from $fp-1532
	  slt $t2, $t0, $t1	
	  sw $t2, -1548($fp)	# spill _tmp750 from $t2 to $fp-1548
	# _tmp751 = _tmp748 == _tmp746
	  lw $t0, -1540($fp)	# fill _tmp748 to $t0 from $fp-1540
	  lw $t1, -1532($fp)	# fill _tmp746 to $t1 from $fp-1532
	  seq $t2, $t0, $t1	
	  sw $t2, -1552($fp)	# spill _tmp751 from $t2 to $fp-1552
	# _tmp752 = _tmp750 || _tmp751
	  lw $t0, -1548($fp)	# fill _tmp750 to $t0 from $fp-1548
	  lw $t1, -1552($fp)	# fill _tmp751 to $t1 from $fp-1552
	  or $t2, $t0, $t1	
	  sw $t2, -1556($fp)	# spill _tmp752 from $t2 to $fp-1556
	# _tmp753 = _tmp752 || _tmp749
	  lw $t0, -1556($fp)	# fill _tmp752 to $t0 from $fp-1556
	  lw $t1, -1544($fp)	# fill _tmp749 to $t1 from $fp-1544
	  or $t2, $t0, $t1	
	  sw $t2, -1560($fp)	# spill _tmp753 from $t2 to $fp-1560
	# IfZ _tmp753 Goto _L80
	  lw $t0, -1560($fp)	# fill _tmp753 to $t0 from $fp-1560
	  beqz $t0, _L80	# branch if _tmp753 is zero 
	# _tmp754 = "Decaf runtime error: Array subscript out of bound..."
	  .data			# create string constant marked with label
	  _string54: .asciiz "Decaf runtime error: Array subscript out of bounds\n"
	  .text
	  la $t2, _string54	# load label
	  sw $t2, -1564($fp)	# spill _tmp754 from $t2 to $fp-1564
	# PushParam _tmp754
	  subu $sp, $sp, 4	# decrement sp to make space for param
	  lw $t0, -1564($fp)	# fill _tmp754 to $t0 from $fp-1564
	  sw $t0, 4($sp)	# copy param value to stack
	# LCall _PrintString
	  jal _PrintString   	# jump to function
	# PopParams 4
	  add $sp, $sp, 4	# pop params off stack
	# LCall _Halt
	  jal _Halt          	# jump to function
  _L80:
	# _tmp755 = 4
	  li $t2, 4		# load constant value 4 into $t2
	  sw $t2, -1568($fp)	# spill _tmp755 from $t2 to $fp-1568
	# _tmp756 = _tmp746 * _tmp755
	  lw $t0, -1532($fp)	# fill _tmp746 to $t0 from $fp-1532
	  lw $t1, -1568($fp)	# fill _tmp755 to $t1 from $fp-1568
	  mul $t2, $t0, $t1	
	  sw $t2, -1572($fp)	# spill _tmp756 from $t2 to $fp-1572
	# _tmp757 = _tmp756 + _tmp755
	  lw $t0, -1572($fp)	# fill _tmp756 to $t0 from $fp-1572
	  lw $t1, -1568($fp)	# fill _tmp755 to $t1 from $fp-1568
	  add $t2, $t0, $t1	
	  sw $t2, -1576($fp)	# spill _tmp757 from $t2 to $fp-1576
	# _tmp758 = _tmp745 + _tmp757
	  lw $t0, -1528($fp)	# fill _tmp745 to $t0 from $fp-1528
	  lw $t1, -1576($fp)	# fill _tmp757 to $t1 from $fp-1576
	  add $t2, $t0, $t1	
	  sw $t2, -1580($fp)	# spill _tmp758 from $t2 to $fp-1580
	# _tmp759 = *(_tmp758)
	  lw $t0, -1580($fp)	# fill _tmp758 to $t0 from $fp-1580
	  lw $t2, 0($t0) 	# load with offset
	  sw $t2, -1584($fp)	# spill _tmp759 from $t2 to $fp-1584
	# PushParam _tmp759
	  subu $sp, $sp, 4	# decrement sp to make space for param
	  lw $t0, -1584($fp)	# fill _tmp759 to $t0 from $fp-1584
	  sw $t0, 4($sp)	# copy param value to stack
	# _tmp760 = *(_tmp759)
	  lw $t0, -1584($fp)	# fill _tmp759 to $t0 from $fp-1584
	  lw $t2, 0($t0) 	# load with offset
	  sw $t2, -1588($fp)	# spill _tmp760 from $t2 to $fp-1588
	# _tmp761 = *(_tmp760 + 20)
	  lw $t0, -1588($fp)	# fill _tmp760 to $t0 from $fp-1588
	  lw $t2, 20($t0) 	# load with offset
	  sw $t2, -1592($fp)	# spill _tmp761 from $t2 to $fp-1592
	# _tmp762 = ACall _tmp761
	  lw $t0, -1592($fp)	# fill _tmp761 to $t0 from $fp-1592
	  jalr $t0            	# jump to function
	  move $t2, $v0		# copy function return value from $v0
	  sw $t2, -1596($fp)	# spill _tmp762 from $t2 to $fp-1596
	# PopParams 8
	  add $sp, $sp, 8	# pop params off stack
	# _tmp763 = _tmp730 && _tmp762
	  lw $t0, -1468($fp)	# fill _tmp730 to $t0 from $fp-1468
	  lw $t1, -1596($fp)	# fill _tmp762 to $t1 from $fp-1596
	  and $t2, $t0, $t1	
	  sw $t2, -1600($fp)	# spill _tmp763 from $t2 to $fp-1600
	# IfZ _tmp763 Goto _L73
	  lw $t0, -1600($fp)	# fill _tmp763 to $t0 from $fp-1600
	  beqz $t0, _L73	# branch if _tmp763 is zero 
	# _tmp764 = 0
	  li $t2, 0		# load constant value 0 into $t2
	  sw $t2, -1604($fp)	# spill _tmp764 from $t2 to $fp-1604
	# Return _tmp764
	  lw $t2, -1604($fp)	# fill _tmp764 to $t2 from $fp-1604
	  move $v0, $t2		# assign return value into $v0
	  move $sp, $fp		# pop callee frame off stack
	  lw $ra, -4($fp)	# restore saved ra
	  lw $fp, 0($fp)	# restore saved fp
	  jr $ra		# return from function
	# Goto _L74
	  b _L74		# unconditional branch
  _L73:
  _L74:
  _L66:
  _L58:
  _L50:
	# PushParam mark
	  subu $sp, $sp, 4	# decrement sp to make space for param
	  lw $t0, -8($fp)	# fill mark to $t0 from $fp-8
	  sw $t0, 4($sp)	# copy param value to stack
	# _tmp765 = *(this + 4)
	  lw $t0, 4($fp)	# fill this to $t0 from $fp+4
	  lw $t2, 4($t0) 	# load with offset
	  sw $t2, -1608($fp)	# spill _tmp765 from $t2 to $fp-1608
	# _tmp766 = 0
	  li $t2, 0		# load constant value 0 into $t2
	  sw $t2, -1612($fp)	# spill _tmp766 from $t2 to $fp-1612
	# _tmp767 = 0
	  li $t2, 0		# load constant value 0 into $t2
	  sw $t2, -1616($fp)	# spill _tmp767 from $t2 to $fp-1616
	# _tmp768 = *(_tmp765)
	  lw $t0, -1608($fp)	# fill _tmp765 to $t0 from $fp-1608
	  lw $t2, 0($t0) 	# load with offset
	  sw $t2, -1620($fp)	# spill _tmp768 from $t2 to $fp-1620
	# _tmp769 = _tmp766 < _tmp767
	  lw $t0, -1612($fp)	# fill _tmp766 to $t0 from $fp-1612
	  lw $t1, -1616($fp)	# fill _tmp767 to $t1 from $fp-1616
	  slt $t2, $t0, $t1	
	  sw $t2, -1624($fp)	# spill _tmp769 from $t2 to $fp-1624
	# _tmp770 = _tmp768 < _tmp766
	  lw $t0, -1620($fp)	# fill _tmp768 to $t0 from $fp-1620
	  lw $t1, -1612($fp)	# fill _tmp766 to $t1 from $fp-1612
	  slt $t2, $t0, $t1	
	  sw $t2, -1628($fp)	# spill _tmp770 from $t2 to $fp-1628
	# _tmp771 = _tmp768 == _tmp766
	  lw $t0, -1620($fp)	# fill _tmp768 to $t0 from $fp-1620
	  lw $t1, -1612($fp)	# fill _tmp766 to $t1 from $fp-1612
	  seq $t2, $t0, $t1	
	  sw $t2, -1632($fp)	# spill _tmp771 from $t2 to $fp-1632
	# _tmp772 = _tmp770 || _tmp771
	  lw $t0, -1628($fp)	# fill _tmp770 to $t0 from $fp-1628
	  lw $t1, -1632($fp)	# fill _tmp771 to $t1 from $fp-1632
	  or $t2, $t0, $t1	
	  sw $t2, -1636($fp)	# spill _tmp772 from $t2 to $fp-1636
	# _tmp773 = _tmp772 || _tmp769
	  lw $t0, -1636($fp)	# fill _tmp772 to $t0 from $fp-1636
	  lw $t1, -1624($fp)	# fill _tmp769 to $t1 from $fp-1624
	  or $t2, $t0, $t1	
	  sw $t2, -1640($fp)	# spill _tmp773 from $t2 to $fp-1640
	# IfZ _tmp773 Goto _L83
	  lw $t0, -1640($fp)	# fill _tmp773 to $t0 from $fp-1640
	  beqz $t0, _L83	# branch if _tmp773 is zero 
	# _tmp774 = "Decaf runtime error: Array subscript out of bound..."
	  .data			# create string constant marked with label
	  _string55: .asciiz "Decaf runtime error: Array subscript out of bounds\n"
	  .text
	  la $t2, _string55	# load label
	  sw $t2, -1644($fp)	# spill _tmp774 from $t2 to $fp-1644
	# PushParam _tmp774
	  subu $sp, $sp, 4	# decrement sp to make space for param
	  lw $t0, -1644($fp)	# fill _tmp774 to $t0 from $fp-1644
	  sw $t0, 4($sp)	# copy param value to stack
	# LCall _PrintString
	  jal _PrintString   	# jump to function
	# PopParams 4
	  add $sp, $sp, 4	# pop params off stack
	# LCall _Halt
	  jal _Halt          	# jump to function
  _L83:
	# _tmp775 = 4
	  li $t2, 4		# load constant value 4 into $t2
	  sw $t2, -1648($fp)	# spill _tmp775 from $t2 to $fp-1648
	# _tmp776 = _tmp766 * _tmp775
	  lw $t0, -1612($fp)	# fill _tmp766 to $t0 from $fp-1612
	  lw $t1, -1648($fp)	# fill _tmp775 to $t1 from $fp-1648
	  mul $t2, $t0, $t1	
	  sw $t2, -1652($fp)	# spill _tmp776 from $t2 to $fp-1652
	# _tmp777 = _tmp776 + _tmp775
	  lw $t0, -1652($fp)	# fill _tmp776 to $t0 from $fp-1652
	  lw $t1, -1648($fp)	# fill _tmp775 to $t1 from $fp-1648
	  add $t2, $t0, $t1	
	  sw $t2, -1656($fp)	# spill _tmp777 from $t2 to $fp-1656
	# _tmp778 = _tmp765 + _tmp777
	  lw $t0, -1608($fp)	# fill _tmp765 to $t0 from $fp-1608
	  lw $t1, -1656($fp)	# fill _tmp777 to $t1 from $fp-1656
	  add $t2, $t0, $t1	
	  sw $t2, -1660($fp)	# spill _tmp778 from $t2 to $fp-1660
	# _tmp779 = *(_tmp778)
	  lw $t0, -1660($fp)	# fill _tmp778 to $t0 from $fp-1660
	  lw $t2, 0($t0) 	# load with offset
	  sw $t2, -1664($fp)	# spill _tmp779 from $t2 to $fp-1664
	# _tmp780 = 1
	  li $t2, 1		# load constant value 1 into $t2
	  sw $t2, -1668($fp)	# spill _tmp780 from $t2 to $fp-1668
	# _tmp781 = 0
	  li $t2, 0		# load constant value 0 into $t2
	  sw $t2, -1672($fp)	# spill _tmp781 from $t2 to $fp-1672
	# _tmp782 = *(_tmp779)
	  lw $t0, -1664($fp)	# fill _tmp779 to $t0 from $fp-1664
	  lw $t2, 0($t0) 	# load with offset
	  sw $t2, -1676($fp)	# spill _tmp782 from $t2 to $fp-1676
	# _tmp783 = _tmp780 < _tmp781
	  lw $t0, -1668($fp)	# fill _tmp780 to $t0 from $fp-1668
	  lw $t1, -1672($fp)	# fill _tmp781 to $t1 from $fp-1672
	  slt $t2, $t0, $t1	
	  sw $t2, -1680($fp)	# spill _tmp783 from $t2 to $fp-1680
	# _tmp784 = _tmp782 < _tmp780
	  lw $t0, -1676($fp)	# fill _tmp782 to $t0 from $fp-1676
	  lw $t1, -1668($fp)	# fill _tmp780 to $t1 from $fp-1668
	  slt $t2, $t0, $t1	
	  sw $t2, -1684($fp)	# spill _tmp784 from $t2 to $fp-1684
	# _tmp785 = _tmp782 == _tmp780
	  lw $t0, -1676($fp)	# fill _tmp782 to $t0 from $fp-1676
	  lw $t1, -1668($fp)	# fill _tmp780 to $t1 from $fp-1668
	  seq $t2, $t0, $t1	
	  sw $t2, -1688($fp)	# spill _tmp785 from $t2 to $fp-1688
	# _tmp786 = _tmp784 || _tmp785
	  lw $t0, -1684($fp)	# fill _tmp784 to $t0 from $fp-1684
	  lw $t1, -1688($fp)	# fill _tmp785 to $t1 from $fp-1688
	  or $t2, $t0, $t1	
	  sw $t2, -1692($fp)	# spill _tmp786 from $t2 to $fp-1692
	# _tmp787 = _tmp786 || _tmp783
	  lw $t0, -1692($fp)	# fill _tmp786 to $t0 from $fp-1692
	  lw $t1, -1680($fp)	# fill _tmp783 to $t1 from $fp-1680
	  or $t2, $t0, $t1	
	  sw $t2, -1696($fp)	# spill _tmp787 from $t2 to $fp-1696
	# IfZ _tmp787 Goto _L84
	  lw $t0, -1696($fp)	# fill _tmp787 to $t0 from $fp-1696
	  beqz $t0, _L84	# branch if _tmp787 is zero 
	# _tmp788 = "Decaf runtime error: Array subscript out of bound..."
	  .data			# create string constant marked with label
	  _string56: .asciiz "Decaf runtime error: Array subscript out of bounds\n"
	  .text
	  la $t2, _string56	# load label
	  sw $t2, -1700($fp)	# spill _tmp788 from $t2 to $fp-1700
	# PushParam _tmp788
	  subu $sp, $sp, 4	# decrement sp to make space for param
	  lw $t0, -1700($fp)	# fill _tmp788 to $t0 from $fp-1700
	  sw $t0, 4($sp)	# copy param value to stack
	# LCall _PrintString
	  jal _PrintString   	# jump to function
	# PopParams 4
	  add $sp, $sp, 4	# pop params off stack
	# LCall _Halt
	  jal _Halt          	# jump to function
  _L84:
	# _tmp789 = 4
	  li $t2, 4		# load constant value 4 into $t2
	  sw $t2, -1704($fp)	# spill _tmp789 from $t2 to $fp-1704
	# _tmp790 = _tmp780 * _tmp789
	  lw $t0, -1668($fp)	# fill _tmp780 to $t0 from $fp-1668
	  lw $t1, -1704($fp)	# fill _tmp789 to $t1 from $fp-1704
	  mul $t2, $t0, $t1	
	  sw $t2, -1708($fp)	# spill _tmp790 from $t2 to $fp-1708
	# _tmp791 = _tmp790 + _tmp789
	  lw $t0, -1708($fp)	# fill _tmp790 to $t0 from $fp-1708
	  lw $t1, -1704($fp)	# fill _tmp789 to $t1 from $fp-1704
	  add $t2, $t0, $t1	
	  sw $t2, -1712($fp)	# spill _tmp791 from $t2 to $fp-1712
	# _tmp792 = _tmp779 + _tmp791
	  lw $t0, -1664($fp)	# fill _tmp779 to $t0 from $fp-1664
	  lw $t1, -1712($fp)	# fill _tmp791 to $t1 from $fp-1712
	  add $t2, $t0, $t1	
	  sw $t2, -1716($fp)	# spill _tmp792 from $t2 to $fp-1716
	# _tmp793 = *(_tmp792)
	  lw $t0, -1716($fp)	# fill _tmp792 to $t0 from $fp-1716
	  lw $t2, 0($t0) 	# load with offset
	  sw $t2, -1720($fp)	# spill _tmp793 from $t2 to $fp-1720
	# PushParam _tmp793
	  subu $sp, $sp, 4	# decrement sp to make space for param
	  lw $t0, -1720($fp)	# fill _tmp793 to $t0 from $fp-1720
	  sw $t0, 4($sp)	# copy param value to stack
	# _tmp794 = *(_tmp793)
	  lw $t0, -1720($fp)	# fill _tmp793 to $t0 from $fp-1720
	  lw $t2, 0($t0) 	# load with offset
	  sw $t2, -1724($fp)	# spill _tmp794 from $t2 to $fp-1724
	# _tmp795 = *(_tmp794 + 20)
	  lw $t0, -1724($fp)	# fill _tmp794 to $t0 from $fp-1724
	  lw $t2, 20($t0) 	# load with offset
	  sw $t2, -1728($fp)	# spill _tmp795 from $t2 to $fp-1728
	# _tmp796 = ACall _tmp795
	  lw $t0, -1728($fp)	# fill _tmp795 to $t0 from $fp-1728
	  jalr $t0            	# jump to function
	  move $t2, $v0		# copy function return value from $v0
	  sw $t2, -1732($fp)	# spill _tmp796 from $t2 to $fp-1732
	# PopParams 8
	  add $sp, $sp, 8	# pop params off stack
	# PushParam mark
	  subu $sp, $sp, 4	# decrement sp to make space for param
	  lw $t0, -8($fp)	# fill mark to $t0 from $fp-8
	  sw $t0, 4($sp)	# copy param value to stack
	# _tmp797 = *(this + 4)
	  lw $t0, 4($fp)	# fill this to $t0 from $fp+4
	  lw $t2, 4($t0) 	# load with offset
	  sw $t2, -1736($fp)	# spill _tmp797 from $t2 to $fp-1736
	# _tmp798 = 1
	  li $t2, 1		# load constant value 1 into $t2
	  sw $t2, -1740($fp)	# spill _tmp798 from $t2 to $fp-1740
	# _tmp799 = 0
	  li $t2, 0		# load constant value 0 into $t2
	  sw $t2, -1744($fp)	# spill _tmp799 from $t2 to $fp-1744
	# _tmp800 = *(_tmp797)
	  lw $t0, -1736($fp)	# fill _tmp797 to $t0 from $fp-1736
	  lw $t2, 0($t0) 	# load with offset
	  sw $t2, -1748($fp)	# spill _tmp800 from $t2 to $fp-1748
	# _tmp801 = _tmp798 < _tmp799
	  lw $t0, -1740($fp)	# fill _tmp798 to $t0 from $fp-1740
	  lw $t1, -1744($fp)	# fill _tmp799 to $t1 from $fp-1744
	  slt $t2, $t0, $t1	
	  sw $t2, -1752($fp)	# spill _tmp801 from $t2 to $fp-1752
	# _tmp802 = _tmp800 < _tmp798
	  lw $t0, -1748($fp)	# fill _tmp800 to $t0 from $fp-1748
	  lw $t1, -1740($fp)	# fill _tmp798 to $t1 from $fp-1740
	  slt $t2, $t0, $t1	
	  sw $t2, -1756($fp)	# spill _tmp802 from $t2 to $fp-1756
	# _tmp803 = _tmp800 == _tmp798
	  lw $t0, -1748($fp)	# fill _tmp800 to $t0 from $fp-1748
	  lw $t1, -1740($fp)	# fill _tmp798 to $t1 from $fp-1740
	  seq $t2, $t0, $t1	
	  sw $t2, -1760($fp)	# spill _tmp803 from $t2 to $fp-1760
	# _tmp804 = _tmp802 || _tmp803
	  lw $t0, -1756($fp)	# fill _tmp802 to $t0 from $fp-1756
	  lw $t1, -1760($fp)	# fill _tmp803 to $t1 from $fp-1760
	  or $t2, $t0, $t1	
	  sw $t2, -1764($fp)	# spill _tmp804 from $t2 to $fp-1764
	# _tmp805 = _tmp804 || _tmp801
	  lw $t0, -1764($fp)	# fill _tmp804 to $t0 from $fp-1764
	  lw $t1, -1752($fp)	# fill _tmp801 to $t1 from $fp-1752
	  or $t2, $t0, $t1	
	  sw $t2, -1768($fp)	# spill _tmp805 from $t2 to $fp-1768
	# IfZ _tmp805 Goto _L85
	  lw $t0, -1768($fp)	# fill _tmp805 to $t0 from $fp-1768
	  beqz $t0, _L85	# branch if _tmp805 is zero 
	# _tmp806 = "Decaf runtime error: Array subscript out of bound..."
	  .data			# create string constant marked with label
	  _string57: .asciiz "Decaf runtime error: Array subscript out of bounds\n"
	  .text
	  la $t2, _string57	# load label
	  sw $t2, -1772($fp)	# spill _tmp806 from $t2 to $fp-1772
	# PushParam _tmp806
	  subu $sp, $sp, 4	# decrement sp to make space for param
	  lw $t0, -1772($fp)	# fill _tmp806 to $t0 from $fp-1772
	  sw $t0, 4($sp)	# copy param value to stack
	# LCall _PrintString
	  jal _PrintString   	# jump to function
	# PopParams 4
	  add $sp, $sp, 4	# pop params off stack
	# LCall _Halt
	  jal _Halt          	# jump to function
  _L85:
	# _tmp807 = 4
	  li $t2, 4		# load constant value 4 into $t2
	  sw $t2, -1776($fp)	# spill _tmp807 from $t2 to $fp-1776
	# _tmp808 = _tmp798 * _tmp807
	  lw $t0, -1740($fp)	# fill _tmp798 to $t0 from $fp-1740
	  lw $t1, -1776($fp)	# fill _tmp807 to $t1 from $fp-1776
	  mul $t2, $t0, $t1	
	  sw $t2, -1780($fp)	# spill _tmp808 from $t2 to $fp-1780
	# _tmp809 = _tmp808 + _tmp807
	  lw $t0, -1780($fp)	# fill _tmp808 to $t0 from $fp-1780
	  lw $t1, -1776($fp)	# fill _tmp807 to $t1 from $fp-1776
	  add $t2, $t0, $t1	
	  sw $t2, -1784($fp)	# spill _tmp809 from $t2 to $fp-1784
	# _tmp810 = _tmp797 + _tmp809
	  lw $t0, -1736($fp)	# fill _tmp797 to $t0 from $fp-1736
	  lw $t1, -1784($fp)	# fill _tmp809 to $t1 from $fp-1784
	  add $t2, $t0, $t1	
	  sw $t2, -1788($fp)	# spill _tmp810 from $t2 to $fp-1788
	# _tmp811 = *(_tmp810)
	  lw $t0, -1788($fp)	# fill _tmp810 to $t0 from $fp-1788
	  lw $t2, 0($t0) 	# load with offset
	  sw $t2, -1792($fp)	# spill _tmp811 from $t2 to $fp-1792
	# _tmp812 = 1
	  li $t2, 1		# load constant value 1 into $t2
	  sw $t2, -1796($fp)	# spill _tmp812 from $t2 to $fp-1796
	# _tmp813 = 0
	  li $t2, 0		# load constant value 0 into $t2
	  sw $t2, -1800($fp)	# spill _tmp813 from $t2 to $fp-1800
	# _tmp814 = *(_tmp811)
	  lw $t0, -1792($fp)	# fill _tmp811 to $t0 from $fp-1792
	  lw $t2, 0($t0) 	# load with offset
	  sw $t2, -1804($fp)	# spill _tmp814 from $t2 to $fp-1804
	# _tmp815 = _tmp812 < _tmp813
	  lw $t0, -1796($fp)	# fill _tmp812 to $t0 from $fp-1796
	  lw $t1, -1800($fp)	# fill _tmp813 to $t1 from $fp-1800
	  slt $t2, $t0, $t1	
	  sw $t2, -1808($fp)	# spill _tmp815 from $t2 to $fp-1808
	# _tmp816 = _tmp814 < _tmp812
	  lw $t0, -1804($fp)	# fill _tmp814 to $t0 from $fp-1804
	  lw $t1, -1796($fp)	# fill _tmp812 to $t1 from $fp-1796
	  slt $t2, $t0, $t1	
	  sw $t2, -1812($fp)	# spill _tmp816 from $t2 to $fp-1812
	# _tmp817 = _tmp814 == _tmp812
	  lw $t0, -1804($fp)	# fill _tmp814 to $t0 from $fp-1804
	  lw $t1, -1796($fp)	# fill _tmp812 to $t1 from $fp-1796
	  seq $t2, $t0, $t1	
	  sw $t2, -1816($fp)	# spill _tmp817 from $t2 to $fp-1816
	# _tmp818 = _tmp816 || _tmp817
	  lw $t0, -1812($fp)	# fill _tmp816 to $t0 from $fp-1812
	  lw $t1, -1816($fp)	# fill _tmp817 to $t1 from $fp-1816
	  or $t2, $t0, $t1	
	  sw $t2, -1820($fp)	# spill _tmp818 from $t2 to $fp-1820
	# _tmp819 = _tmp818 || _tmp815
	  lw $t0, -1820($fp)	# fill _tmp818 to $t0 from $fp-1820
	  lw $t1, -1808($fp)	# fill _tmp815 to $t1 from $fp-1808
	  or $t2, $t0, $t1	
	  sw $t2, -1824($fp)	# spill _tmp819 from $t2 to $fp-1824
	# IfZ _tmp819 Goto _L86
	  lw $t0, -1824($fp)	# fill _tmp819 to $t0 from $fp-1824
	  beqz $t0, _L86	# branch if _tmp819 is zero 
	# _tmp820 = "Decaf runtime error: Array subscript out of bound..."
	  .data			# create string constant marked with label
	  _string58: .asciiz "Decaf runtime error: Array subscript out of bounds\n"
	  .text
	  la $t2, _string58	# load label
	  sw $t2, -1828($fp)	# spill _tmp820 from $t2 to $fp-1828
	# PushParam _tmp820
	  subu $sp, $sp, 4	# decrement sp to make space for param
	  lw $t0, -1828($fp)	# fill _tmp820 to $t0 from $fp-1828
	  sw $t0, 4($sp)	# copy param value to stack
	# LCall _PrintString
	  jal _PrintString   	# jump to function
	# PopParams 4
	  add $sp, $sp, 4	# pop params off stack
	# LCall _Halt
	  jal _Halt          	# jump to function
  _L86:
	# _tmp821 = 4
	  li $t2, 4		# load constant value 4 into $t2
	  sw $t2, -1832($fp)	# spill _tmp821 from $t2 to $fp-1832
	# _tmp822 = _tmp812 * _tmp821
	  lw $t0, -1796($fp)	# fill _tmp812 to $t0 from $fp-1796
	  lw $t1, -1832($fp)	# fill _tmp821 to $t1 from $fp-1832
	  mul $t2, $t0, $t1	
	  sw $t2, -1836($fp)	# spill _tmp822 from $t2 to $fp-1836
	# _tmp823 = _tmp822 + _tmp821
	  lw $t0, -1836($fp)	# fill _tmp822 to $t0 from $fp-1836
	  lw $t1, -1832($fp)	# fill _tmp821 to $t1 from $fp-1832
	  add $t2, $t0, $t1	
	  sw $t2, -1840($fp)	# spill _tmp823 from $t2 to $fp-1840
	# _tmp824 = _tmp811 + _tmp823
	  lw $t0, -1792($fp)	# fill _tmp811 to $t0 from $fp-1792
	  lw $t1, -1840($fp)	# fill _tmp823 to $t1 from $fp-1840
	  add $t2, $t0, $t1	
	  sw $t2, -1844($fp)	# spill _tmp824 from $t2 to $fp-1844
	# _tmp825 = *(_tmp824)
	  lw $t0, -1844($fp)	# fill _tmp824 to $t0 from $fp-1844
	  lw $t2, 0($t0) 	# load with offset
	  sw $t2, -1848($fp)	# spill _tmp825 from $t2 to $fp-1848
	# PushParam _tmp825
	  subu $sp, $sp, 4	# decrement sp to make space for param
	  lw $t0, -1848($fp)	# fill _tmp825 to $t0 from $fp-1848
	  sw $t0, 4($sp)	# copy param value to stack
	# _tmp826 = *(_tmp825)
	  lw $t0, -1848($fp)	# fill _tmp825 to $t0 from $fp-1848
	  lw $t2, 0($t0) 	# load with offset
	  sw $t2, -1852($fp)	# spill _tmp826 from $t2 to $fp-1852
	# _tmp827 = *(_tmp826 + 20)
	  lw $t0, -1852($fp)	# fill _tmp826 to $t0 from $fp-1852
	  lw $t2, 20($t0) 	# load with offset
	  sw $t2, -1856($fp)	# spill _tmp827 from $t2 to $fp-1856
	# _tmp828 = ACall _tmp827
	  lw $t0, -1856($fp)	# fill _tmp827 to $t0 from $fp-1856
	  jalr $t0            	# jump to function
	  move $t2, $v0		# copy function return value from $v0
	  sw $t2, -1860($fp)	# spill _tmp828 from $t2 to $fp-1860
	# PopParams 8
	  add $sp, $sp, 8	# pop params off stack
	# _tmp829 = _tmp796 && _tmp828
	  lw $t0, -1732($fp)	# fill _tmp796 to $t0 from $fp-1732
	  lw $t1, -1860($fp)	# fill _tmp828 to $t1 from $fp-1860
	  and $t2, $t0, $t1	
	  sw $t2, -1864($fp)	# spill _tmp829 from $t2 to $fp-1864
	# PushParam mark
	  subu $sp, $sp, 4	# decrement sp to make space for param
	  lw $t0, -8($fp)	# fill mark to $t0 from $fp-8
	  sw $t0, 4($sp)	# copy param value to stack
	# _tmp830 = *(this + 4)
	  lw $t0, 4($fp)	# fill this to $t0 from $fp+4
	  lw $t2, 4($t0) 	# load with offset
	  sw $t2, -1868($fp)	# spill _tmp830 from $t2 to $fp-1868
	# _tmp831 = 2
	  li $t2, 2		# load constant value 2 into $t2
	  sw $t2, -1872($fp)	# spill _tmp831 from $t2 to $fp-1872
	# _tmp832 = 0
	  li $t2, 0		# load constant value 0 into $t2
	  sw $t2, -1876($fp)	# spill _tmp832 from $t2 to $fp-1876
	# _tmp833 = *(_tmp830)
	  lw $t0, -1868($fp)	# fill _tmp830 to $t0 from $fp-1868
	  lw $t2, 0($t0) 	# load with offset
	  sw $t2, -1880($fp)	# spill _tmp833 from $t2 to $fp-1880
	# _tmp834 = _tmp831 < _tmp832
	  lw $t0, -1872($fp)	# fill _tmp831 to $t0 from $fp-1872
	  lw $t1, -1876($fp)	# fill _tmp832 to $t1 from $fp-1876
	  slt $t2, $t0, $t1	
	  sw $t2, -1884($fp)	# spill _tmp834 from $t2 to $fp-1884
	# _tmp835 = _tmp833 < _tmp831
	  lw $t0, -1880($fp)	# fill _tmp833 to $t0 from $fp-1880
	  lw $t1, -1872($fp)	# fill _tmp831 to $t1 from $fp-1872
	  slt $t2, $t0, $t1	
	  sw $t2, -1888($fp)	# spill _tmp835 from $t2 to $fp-1888
	# _tmp836 = _tmp833 == _tmp831
	  lw $t0, -1880($fp)	# fill _tmp833 to $t0 from $fp-1880
	  lw $t1, -1872($fp)	# fill _tmp831 to $t1 from $fp-1872
	  seq $t2, $t0, $t1	
	  sw $t2, -1892($fp)	# spill _tmp836 from $t2 to $fp-1892
	# _tmp837 = _tmp835 || _tmp836
	  lw $t0, -1888($fp)	# fill _tmp835 to $t0 from $fp-1888
	  lw $t1, -1892($fp)	# fill _tmp836 to $t1 from $fp-1892
	  or $t2, $t0, $t1	
	  sw $t2, -1896($fp)	# spill _tmp837 from $t2 to $fp-1896
	# _tmp838 = _tmp837 || _tmp834
	  lw $t0, -1896($fp)	# fill _tmp837 to $t0 from $fp-1896
	  lw $t1, -1884($fp)	# fill _tmp834 to $t1 from $fp-1884
	  or $t2, $t0, $t1	
	  sw $t2, -1900($fp)	# spill _tmp838 from $t2 to $fp-1900
	# IfZ _tmp838 Goto _L87
	  lw $t0, -1900($fp)	# fill _tmp838 to $t0 from $fp-1900
	  beqz $t0, _L87	# branch if _tmp838 is zero 
	# _tmp839 = "Decaf runtime error: Array subscript out of bound..."
	  .data			# create string constant marked with label
	  _string59: .asciiz "Decaf runtime error: Array subscript out of bounds\n"
	  .text
	  la $t2, _string59	# load label
	  sw $t2, -1904($fp)	# spill _tmp839 from $t2 to $fp-1904
	# PushParam _tmp839
	  subu $sp, $sp, 4	# decrement sp to make space for param
	  lw $t0, -1904($fp)	# fill _tmp839 to $t0 from $fp-1904
	  sw $t0, 4($sp)	# copy param value to stack
	# LCall _PrintString
	  jal _PrintString   	# jump to function
	# PopParams 4
	  add $sp, $sp, 4	# pop params off stack
	# LCall _Halt
	  jal _Halt          	# jump to function
  _L87:
	# _tmp840 = 4
	  li $t2, 4		# load constant value 4 into $t2
	  sw $t2, -1908($fp)	# spill _tmp840 from $t2 to $fp-1908
	# _tmp841 = _tmp831 * _tmp840
	  lw $t0, -1872($fp)	# fill _tmp831 to $t0 from $fp-1872
	  lw $t1, -1908($fp)	# fill _tmp840 to $t1 from $fp-1908
	  mul $t2, $t0, $t1	
	  sw $t2, -1912($fp)	# spill _tmp841 from $t2 to $fp-1912
	# _tmp842 = _tmp841 + _tmp840
	  lw $t0, -1912($fp)	# fill _tmp841 to $t0 from $fp-1912
	  lw $t1, -1908($fp)	# fill _tmp840 to $t1 from $fp-1908
	  add $t2, $t0, $t1	
	  sw $t2, -1916($fp)	# spill _tmp842 from $t2 to $fp-1916
	# _tmp843 = _tmp830 + _tmp842
	  lw $t0, -1868($fp)	# fill _tmp830 to $t0 from $fp-1868
	  lw $t1, -1916($fp)	# fill _tmp842 to $t1 from $fp-1916
	  add $t2, $t0, $t1	
	  sw $t2, -1920($fp)	# spill _tmp843 from $t2 to $fp-1920
	# _tmp844 = *(_tmp843)
	  lw $t0, -1920($fp)	# fill _tmp843 to $t0 from $fp-1920
	  lw $t2, 0($t0) 	# load with offset
	  sw $t2, -1924($fp)	# spill _tmp844 from $t2 to $fp-1924
	# _tmp845 = 1
	  li $t2, 1		# load constant value 1 into $t2
	  sw $t2, -1928($fp)	# spill _tmp845 from $t2 to $fp-1928
	# _tmp846 = 0
	  li $t2, 0		# load constant value 0 into $t2
	  sw $t2, -1932($fp)	# spill _tmp846 from $t2 to $fp-1932
	# _tmp847 = *(_tmp844)
	  lw $t0, -1924($fp)	# fill _tmp844 to $t0 from $fp-1924
	  lw $t2, 0($t0) 	# load with offset
	  sw $t2, -1936($fp)	# spill _tmp847 from $t2 to $fp-1936
	# _tmp848 = _tmp845 < _tmp846
	  lw $t0, -1928($fp)	# fill _tmp845 to $t0 from $fp-1928
	  lw $t1, -1932($fp)	# fill _tmp846 to $t1 from $fp-1932
	  slt $t2, $t0, $t1	
	  sw $t2, -1940($fp)	# spill _tmp848 from $t2 to $fp-1940
	# _tmp849 = _tmp847 < _tmp845
	  lw $t0, -1936($fp)	# fill _tmp847 to $t0 from $fp-1936
	  lw $t1, -1928($fp)	# fill _tmp845 to $t1 from $fp-1928
	  slt $t2, $t0, $t1	
	  sw $t2, -1944($fp)	# spill _tmp849 from $t2 to $fp-1944
	# _tmp850 = _tmp847 == _tmp845
	  lw $t0, -1936($fp)	# fill _tmp847 to $t0 from $fp-1936
	  lw $t1, -1928($fp)	# fill _tmp845 to $t1 from $fp-1928
	  seq $t2, $t0, $t1	
	  sw $t2, -1948($fp)	# spill _tmp850 from $t2 to $fp-1948
	# _tmp851 = _tmp849 || _tmp850
	  lw $t0, -1944($fp)	# fill _tmp849 to $t0 from $fp-1944
	  lw $t1, -1948($fp)	# fill _tmp850 to $t1 from $fp-1948
	  or $t2, $t0, $t1	
	  sw $t2, -1952($fp)	# spill _tmp851 from $t2 to $fp-1952
	# _tmp852 = _tmp851 || _tmp848
	  lw $t0, -1952($fp)	# fill _tmp851 to $t0 from $fp-1952
	  lw $t1, -1940($fp)	# fill _tmp848 to $t1 from $fp-1940
	  or $t2, $t0, $t1	
	  sw $t2, -1956($fp)	# spill _tmp852 from $t2 to $fp-1956
	# IfZ _tmp852 Goto _L88
	  lw $t0, -1956($fp)	# fill _tmp852 to $t0 from $fp-1956
	  beqz $t0, _L88	# branch if _tmp852 is zero 
	# _tmp853 = "Decaf runtime error: Array subscript out of bound..."
	  .data			# create string constant marked with label
	  _string60: .asciiz "Decaf runtime error: Array subscript out of bounds\n"
	  .text
	  la $t2, _string60	# load label
	  sw $t2, -1960($fp)	# spill _tmp853 from $t2 to $fp-1960
	# PushParam _tmp853
	  subu $sp, $sp, 4	# decrement sp to make space for param
	  lw $t0, -1960($fp)	# fill _tmp853 to $t0 from $fp-1960
	  sw $t0, 4($sp)	# copy param value to stack
	# LCall _PrintString
	  jal _PrintString   	# jump to function
	# PopParams 4
	  add $sp, $sp, 4	# pop params off stack
	# LCall _Halt
	  jal _Halt          	# jump to function
  _L88:
	# _tmp854 = 4
	  li $t2, 4		# load constant value 4 into $t2
	  sw $t2, -1964($fp)	# spill _tmp854 from $t2 to $fp-1964
	# _tmp855 = _tmp845 * _tmp854
	  lw $t0, -1928($fp)	# fill _tmp845 to $t0 from $fp-1928
	  lw $t1, -1964($fp)	# fill _tmp854 to $t1 from $fp-1964
	  mul $t2, $t0, $t1	
	  sw $t2, -1968($fp)	# spill _tmp855 from $t2 to $fp-1968
	# _tmp856 = _tmp855 + _tmp854
	  lw $t0, -1968($fp)	# fill _tmp855 to $t0 from $fp-1968
	  lw $t1, -1964($fp)	# fill _tmp854 to $t1 from $fp-1964
	  add $t2, $t0, $t1	
	  sw $t2, -1972($fp)	# spill _tmp856 from $t2 to $fp-1972
	# _tmp857 = _tmp844 + _tmp856
	  lw $t0, -1924($fp)	# fill _tmp844 to $t0 from $fp-1924
	  lw $t1, -1972($fp)	# fill _tmp856 to $t1 from $fp-1972
	  add $t2, $t0, $t1	
	  sw $t2, -1976($fp)	# spill _tmp857 from $t2 to $fp-1976
	# _tmp858 = *(_tmp857)
	  lw $t0, -1976($fp)	# fill _tmp857 to $t0 from $fp-1976
	  lw $t2, 0($t0) 	# load with offset
	  sw $t2, -1980($fp)	# spill _tmp858 from $t2 to $fp-1980
	# PushParam _tmp858
	  subu $sp, $sp, 4	# decrement sp to make space for param
	  lw $t0, -1980($fp)	# fill _tmp858 to $t0 from $fp-1980
	  sw $t0, 4($sp)	# copy param value to stack
	# _tmp859 = *(_tmp858)
	  lw $t0, -1980($fp)	# fill _tmp858 to $t0 from $fp-1980
	  lw $t2, 0($t0) 	# load with offset
	  sw $t2, -1984($fp)	# spill _tmp859 from $t2 to $fp-1984
	# _tmp860 = *(_tmp859 + 20)
	  lw $t0, -1984($fp)	# fill _tmp859 to $t0 from $fp-1984
	  lw $t2, 20($t0) 	# load with offset
	  sw $t2, -1988($fp)	# spill _tmp860 from $t2 to $fp-1988
	# _tmp861 = ACall _tmp860
	  lw $t0, -1988($fp)	# fill _tmp860 to $t0 from $fp-1988
	  jalr $t0            	# jump to function
	  move $t2, $v0		# copy function return value from $v0
	  sw $t2, -1992($fp)	# spill _tmp861 from $t2 to $fp-1992
	# PopParams 8
	  add $sp, $sp, 8	# pop params off stack
	# _tmp862 = _tmp829 && _tmp861
	  lw $t0, -1864($fp)	# fill _tmp829 to $t0 from $fp-1864
	  lw $t1, -1992($fp)	# fill _tmp861 to $t1 from $fp-1992
	  and $t2, $t0, $t1	
	  sw $t2, -1996($fp)	# spill _tmp862 from $t2 to $fp-1996
	# IfZ _tmp862 Goto _L81
	  lw $t0, -1996($fp)	# fill _tmp862 to $t0 from $fp-1996
	  beqz $t0, _L81	# branch if _tmp862 is zero 
	# _tmp863 = 0
	  li $t2, 0		# load constant value 0 into $t2
	  sw $t2, -2000($fp)	# spill _tmp863 from $t2 to $fp-2000
	# Return _tmp863
	  lw $t2, -2000($fp)	# fill _tmp863 to $t2 from $fp-2000
	  move $v0, $t2		# assign return value into $v0
	  move $sp, $fp		# pop callee frame off stack
	  lw $ra, -4($fp)	# restore saved ra
	  lw $fp, 0($fp)	# restore saved fp
	  jr $ra		# return from function
	# Goto _L82
	  b _L82		# unconditional branch
  _L81:
  _L82:
	# PushParam mark
	  subu $sp, $sp, 4	# decrement sp to make space for param
	  lw $t0, -8($fp)	# fill mark to $t0 from $fp-8
	  sw $t0, 4($sp)	# copy param value to stack
	# _tmp864 = *(this + 4)
	  lw $t0, 4($fp)	# fill this to $t0 from $fp+4
	  lw $t2, 4($t0) 	# load with offset
	  sw $t2, -2004($fp)	# spill _tmp864 from $t2 to $fp-2004
	# _tmp865 = 0
	  li $t2, 0		# load constant value 0 into $t2
	  sw $t2, -2008($fp)	# spill _tmp865 from $t2 to $fp-2008
	# _tmp866 = 0
	  li $t2, 0		# load constant value 0 into $t2
	  sw $t2, -2012($fp)	# spill _tmp866 from $t2 to $fp-2012
	# _tmp867 = *(_tmp864)
	  lw $t0, -2004($fp)	# fill _tmp864 to $t0 from $fp-2004
	  lw $t2, 0($t0) 	# load with offset
	  sw $t2, -2016($fp)	# spill _tmp867 from $t2 to $fp-2016
	# _tmp868 = _tmp865 < _tmp866
	  lw $t0, -2008($fp)	# fill _tmp865 to $t0 from $fp-2008
	  lw $t1, -2012($fp)	# fill _tmp866 to $t1 from $fp-2012
	  slt $t2, $t0, $t1	
	  sw $t2, -2020($fp)	# spill _tmp868 from $t2 to $fp-2020
	# _tmp869 = _tmp867 < _tmp865
	  lw $t0, -2016($fp)	# fill _tmp867 to $t0 from $fp-2016
	  lw $t1, -2008($fp)	# fill _tmp865 to $t1 from $fp-2008
	  slt $t2, $t0, $t1	
	  sw $t2, -2024($fp)	# spill _tmp869 from $t2 to $fp-2024
	# _tmp870 = _tmp867 == _tmp865
	  lw $t0, -2016($fp)	# fill _tmp867 to $t0 from $fp-2016
	  lw $t1, -2008($fp)	# fill _tmp865 to $t1 from $fp-2008
	  seq $t2, $t0, $t1	
	  sw $t2, -2028($fp)	# spill _tmp870 from $t2 to $fp-2028
	# _tmp871 = _tmp869 || _tmp870
	  lw $t0, -2024($fp)	# fill _tmp869 to $t0 from $fp-2024
	  lw $t1, -2028($fp)	# fill _tmp870 to $t1 from $fp-2028
	  or $t2, $t0, $t1	
	  sw $t2, -2032($fp)	# spill _tmp871 from $t2 to $fp-2032
	# _tmp872 = _tmp871 || _tmp868
	  lw $t0, -2032($fp)	# fill _tmp871 to $t0 from $fp-2032
	  lw $t1, -2020($fp)	# fill _tmp868 to $t1 from $fp-2020
	  or $t2, $t0, $t1	
	  sw $t2, -2036($fp)	# spill _tmp872 from $t2 to $fp-2036
	# IfZ _tmp872 Goto _L91
	  lw $t0, -2036($fp)	# fill _tmp872 to $t0 from $fp-2036
	  beqz $t0, _L91	# branch if _tmp872 is zero 
	# _tmp873 = "Decaf runtime error: Array subscript out of bound..."
	  .data			# create string constant marked with label
	  _string61: .asciiz "Decaf runtime error: Array subscript out of bounds\n"
	  .text
	  la $t2, _string61	# load label
	  sw $t2, -2040($fp)	# spill _tmp873 from $t2 to $fp-2040
	# PushParam _tmp873
	  subu $sp, $sp, 4	# decrement sp to make space for param
	  lw $t0, -2040($fp)	# fill _tmp873 to $t0 from $fp-2040
	  sw $t0, 4($sp)	# copy param value to stack
	# LCall _PrintString
	  jal _PrintString   	# jump to function
	# PopParams 4
	  add $sp, $sp, 4	# pop params off stack
	# LCall _Halt
	  jal _Halt          	# jump to function
  _L91:
	# _tmp874 = 4
	  li $t2, 4		# load constant value 4 into $t2
	  sw $t2, -2044($fp)	# spill _tmp874 from $t2 to $fp-2044
	# _tmp875 = _tmp865 * _tmp874
	  lw $t0, -2008($fp)	# fill _tmp865 to $t0 from $fp-2008
	  lw $t1, -2044($fp)	# fill _tmp874 to $t1 from $fp-2044
	  mul $t2, $t0, $t1	
	  sw $t2, -2048($fp)	# spill _tmp875 from $t2 to $fp-2048
	# _tmp876 = _tmp875 + _tmp874
	  lw $t0, -2048($fp)	# fill _tmp875 to $t0 from $fp-2048
	  lw $t1, -2044($fp)	# fill _tmp874 to $t1 from $fp-2044
	  add $t2, $t0, $t1	
	  sw $t2, -2052($fp)	# spill _tmp876 from $t2 to $fp-2052
	# _tmp877 = _tmp864 + _tmp876
	  lw $t0, -2004($fp)	# fill _tmp864 to $t0 from $fp-2004
	  lw $t1, -2052($fp)	# fill _tmp876 to $t1 from $fp-2052
	  add $t2, $t0, $t1	
	  sw $t2, -2056($fp)	# spill _tmp877 from $t2 to $fp-2056
	# _tmp878 = *(_tmp877)
	  lw $t0, -2056($fp)	# fill _tmp877 to $t0 from $fp-2056
	  lw $t2, 0($t0) 	# load with offset
	  sw $t2, -2060($fp)	# spill _tmp878 from $t2 to $fp-2060
	# _tmp879 = 2
	  li $t2, 2		# load constant value 2 into $t2
	  sw $t2, -2064($fp)	# spill _tmp879 from $t2 to $fp-2064
	# _tmp880 = 0
	  li $t2, 0		# load constant value 0 into $t2
	  sw $t2, -2068($fp)	# spill _tmp880 from $t2 to $fp-2068
	# _tmp881 = *(_tmp878)
	  lw $t0, -2060($fp)	# fill _tmp878 to $t0 from $fp-2060
	  lw $t2, 0($t0) 	# load with offset
	  sw $t2, -2072($fp)	# spill _tmp881 from $t2 to $fp-2072
	# _tmp882 = _tmp879 < _tmp880
	  lw $t0, -2064($fp)	# fill _tmp879 to $t0 from $fp-2064
	  lw $t1, -2068($fp)	# fill _tmp880 to $t1 from $fp-2068
	  slt $t2, $t0, $t1	
	  sw $t2, -2076($fp)	# spill _tmp882 from $t2 to $fp-2076
	# _tmp883 = _tmp881 < _tmp879
	  lw $t0, -2072($fp)	# fill _tmp881 to $t0 from $fp-2072
	  lw $t1, -2064($fp)	# fill _tmp879 to $t1 from $fp-2064
	  slt $t2, $t0, $t1	
	  sw $t2, -2080($fp)	# spill _tmp883 from $t2 to $fp-2080
	# _tmp884 = _tmp881 == _tmp879
	  lw $t0, -2072($fp)	# fill _tmp881 to $t0 from $fp-2072
	  lw $t1, -2064($fp)	# fill _tmp879 to $t1 from $fp-2064
	  seq $t2, $t0, $t1	
	  sw $t2, -2084($fp)	# spill _tmp884 from $t2 to $fp-2084
	# _tmp885 = _tmp883 || _tmp884
	  lw $t0, -2080($fp)	# fill _tmp883 to $t0 from $fp-2080
	  lw $t1, -2084($fp)	# fill _tmp884 to $t1 from $fp-2084
	  or $t2, $t0, $t1	
	  sw $t2, -2088($fp)	# spill _tmp885 from $t2 to $fp-2088
	# _tmp886 = _tmp885 || _tmp882
	  lw $t0, -2088($fp)	# fill _tmp885 to $t0 from $fp-2088
	  lw $t1, -2076($fp)	# fill _tmp882 to $t1 from $fp-2076
	  or $t2, $t0, $t1	
	  sw $t2, -2092($fp)	# spill _tmp886 from $t2 to $fp-2092
	# IfZ _tmp886 Goto _L92
	  lw $t0, -2092($fp)	# fill _tmp886 to $t0 from $fp-2092
	  beqz $t0, _L92	# branch if _tmp886 is zero 
	# _tmp887 = "Decaf runtime error: Array subscript out of bound..."
	  .data			# create string constant marked with label
	  _string62: .asciiz "Decaf runtime error: Array subscript out of bounds\n"
	  .text
	  la $t2, _string62	# load label
	  sw $t2, -2096($fp)	# spill _tmp887 from $t2 to $fp-2096
	# PushParam _tmp887
	  subu $sp, $sp, 4	# decrement sp to make space for param
	  lw $t0, -2096($fp)	# fill _tmp887 to $t0 from $fp-2096
	  sw $t0, 4($sp)	# copy param value to stack
	# LCall _PrintString
	  jal _PrintString   	# jump to function
	# PopParams 4
	  add $sp, $sp, 4	# pop params off stack
	# LCall _Halt
	  jal _Halt          	# jump to function
  _L92:
	# _tmp888 = 4
	  li $t2, 4		# load constant value 4 into $t2
	  sw $t2, -2100($fp)	# spill _tmp888 from $t2 to $fp-2100
	# _tmp889 = _tmp879 * _tmp888
	  lw $t0, -2064($fp)	# fill _tmp879 to $t0 from $fp-2064
	  lw $t1, -2100($fp)	# fill _tmp888 to $t1 from $fp-2100
	  mul $t2, $t0, $t1	
	  sw $t2, -2104($fp)	# spill _tmp889 from $t2 to $fp-2104
	# _tmp890 = _tmp889 + _tmp888
	  lw $t0, -2104($fp)	# fill _tmp889 to $t0 from $fp-2104
	  lw $t1, -2100($fp)	# fill _tmp888 to $t1 from $fp-2100
	  add $t2, $t0, $t1	
	  sw $t2, -2108($fp)	# spill _tmp890 from $t2 to $fp-2108
	# _tmp891 = _tmp878 + _tmp890
	  lw $t0, -2060($fp)	# fill _tmp878 to $t0 from $fp-2060
	  lw $t1, -2108($fp)	# fill _tmp890 to $t1 from $fp-2108
	  add $t2, $t0, $t1	
	  sw $t2, -2112($fp)	# spill _tmp891 from $t2 to $fp-2112
	# _tmp892 = *(_tmp891)
	  lw $t0, -2112($fp)	# fill _tmp891 to $t0 from $fp-2112
	  lw $t2, 0($t0) 	# load with offset
	  sw $t2, -2116($fp)	# spill _tmp892 from $t2 to $fp-2116
	# PushParam _tmp892
	  subu $sp, $sp, 4	# decrement sp to make space for param
	  lw $t0, -2116($fp)	# fill _tmp892 to $t0 from $fp-2116
	  sw $t0, 4($sp)	# copy param value to stack
	# _tmp893 = *(_tmp892)
	  lw $t0, -2116($fp)	# fill _tmp892 to $t0 from $fp-2116
	  lw $t2, 0($t0) 	# load with offset
	  sw $t2, -2120($fp)	# spill _tmp893 from $t2 to $fp-2120
	# _tmp894 = *(_tmp893 + 20)
	  lw $t0, -2120($fp)	# fill _tmp893 to $t0 from $fp-2120
	  lw $t2, 20($t0) 	# load with offset
	  sw $t2, -2124($fp)	# spill _tmp894 from $t2 to $fp-2124
	# _tmp895 = ACall _tmp894
	  lw $t0, -2124($fp)	# fill _tmp894 to $t0 from $fp-2124
	  jalr $t0            	# jump to function
	  move $t2, $v0		# copy function return value from $v0
	  sw $t2, -2128($fp)	# spill _tmp895 from $t2 to $fp-2128
	# PopParams 8
	  add $sp, $sp, 8	# pop params off stack
	# PushParam mark
	  subu $sp, $sp, 4	# decrement sp to make space for param
	  lw $t0, -8($fp)	# fill mark to $t0 from $fp-8
	  sw $t0, 4($sp)	# copy param value to stack
	# _tmp896 = *(this + 4)
	  lw $t0, 4($fp)	# fill this to $t0 from $fp+4
	  lw $t2, 4($t0) 	# load with offset
	  sw $t2, -2132($fp)	# spill _tmp896 from $t2 to $fp-2132
	# _tmp897 = 1
	  li $t2, 1		# load constant value 1 into $t2
	  sw $t2, -2136($fp)	# spill _tmp897 from $t2 to $fp-2136
	# _tmp898 = 0
	  li $t2, 0		# load constant value 0 into $t2
	  sw $t2, -2140($fp)	# spill _tmp898 from $t2 to $fp-2140
	# _tmp899 = *(_tmp896)
	  lw $t0, -2132($fp)	# fill _tmp896 to $t0 from $fp-2132
	  lw $t2, 0($t0) 	# load with offset
	  sw $t2, -2144($fp)	# spill _tmp899 from $t2 to $fp-2144
	# _tmp900 = _tmp897 < _tmp898
	  lw $t0, -2136($fp)	# fill _tmp897 to $t0 from $fp-2136
	  lw $t1, -2140($fp)	# fill _tmp898 to $t1 from $fp-2140
	  slt $t2, $t0, $t1	
	  sw $t2, -2148($fp)	# spill _tmp900 from $t2 to $fp-2148
	# _tmp901 = _tmp899 < _tmp897
	  lw $t0, -2144($fp)	# fill _tmp899 to $t0 from $fp-2144
	  lw $t1, -2136($fp)	# fill _tmp897 to $t1 from $fp-2136
	  slt $t2, $t0, $t1	
	  sw $t2, -2152($fp)	# spill _tmp901 from $t2 to $fp-2152
	# _tmp902 = _tmp899 == _tmp897
	  lw $t0, -2144($fp)	# fill _tmp899 to $t0 from $fp-2144
	  lw $t1, -2136($fp)	# fill _tmp897 to $t1 from $fp-2136
	  seq $t2, $t0, $t1	
	  sw $t2, -2156($fp)	# spill _tmp902 from $t2 to $fp-2156
	# _tmp903 = _tmp901 || _tmp902
	  lw $t0, -2152($fp)	# fill _tmp901 to $t0 from $fp-2152
	  lw $t1, -2156($fp)	# fill _tmp902 to $t1 from $fp-2156
	  or $t2, $t0, $t1	
	  sw $t2, -2160($fp)	# spill _tmp903 from $t2 to $fp-2160
	# _tmp904 = _tmp903 || _tmp900
	  lw $t0, -2160($fp)	# fill _tmp903 to $t0 from $fp-2160
	  lw $t1, -2148($fp)	# fill _tmp900 to $t1 from $fp-2148
	  or $t2, $t0, $t1	
	  sw $t2, -2164($fp)	# spill _tmp904 from $t2 to $fp-2164
	# IfZ _tmp904 Goto _L93
	  lw $t0, -2164($fp)	# fill _tmp904 to $t0 from $fp-2164
	  beqz $t0, _L93	# branch if _tmp904 is zero 
	# _tmp905 = "Decaf runtime error: Array subscript out of bound..."
	  .data			# create string constant marked with label
	  _string63: .asciiz "Decaf runtime error: Array subscript out of bounds\n"
	  .text
	  la $t2, _string63	# load label
	  sw $t2, -2168($fp)	# spill _tmp905 from $t2 to $fp-2168
	# PushParam _tmp905
	  subu $sp, $sp, 4	# decrement sp to make space for param
	  lw $t0, -2168($fp)	# fill _tmp905 to $t0 from $fp-2168
	  sw $t0, 4($sp)	# copy param value to stack
	# LCall _PrintString
	  jal _PrintString   	# jump to function
	# PopParams 4
	  add $sp, $sp, 4	# pop params off stack
	# LCall _Halt
	  jal _Halt          	# jump to function
  _L93:
	# _tmp906 = 4
	  li $t2, 4		# load constant value 4 into $t2
	  sw $t2, -2172($fp)	# spill _tmp906 from $t2 to $fp-2172
	# _tmp907 = _tmp897 * _tmp906
	  lw $t0, -2136($fp)	# fill _tmp897 to $t0 from $fp-2136
	  lw $t1, -2172($fp)	# fill _tmp906 to $t1 from $fp-2172
	  mul $t2, $t0, $t1	
	  sw $t2, -2176($fp)	# spill _tmp907 from $t2 to $fp-2176
	# _tmp908 = _tmp907 + _tmp906
	  lw $t0, -2176($fp)	# fill _tmp907 to $t0 from $fp-2176
	  lw $t1, -2172($fp)	# fill _tmp906 to $t1 from $fp-2172
	  add $t2, $t0, $t1	
	  sw $t2, -2180($fp)	# spill _tmp908 from $t2 to $fp-2180
	# _tmp909 = _tmp896 + _tmp908
	  lw $t0, -2132($fp)	# fill _tmp896 to $t0 from $fp-2132
	  lw $t1, -2180($fp)	# fill _tmp908 to $t1 from $fp-2180
	  add $t2, $t0, $t1	
	  sw $t2, -2184($fp)	# spill _tmp909 from $t2 to $fp-2184
	# _tmp910 = *(_tmp909)
	  lw $t0, -2184($fp)	# fill _tmp909 to $t0 from $fp-2184
	  lw $t2, 0($t0) 	# load with offset
	  sw $t2, -2188($fp)	# spill _tmp910 from $t2 to $fp-2188
	# _tmp911 = 2
	  li $t2, 2		# load constant value 2 into $t2
	  sw $t2, -2192($fp)	# spill _tmp911 from $t2 to $fp-2192
	# _tmp912 = 0
	  li $t2, 0		# load constant value 0 into $t2
	  sw $t2, -2196($fp)	# spill _tmp912 from $t2 to $fp-2196
	# _tmp913 = *(_tmp910)
	  lw $t0, -2188($fp)	# fill _tmp910 to $t0 from $fp-2188
	  lw $t2, 0($t0) 	# load with offset
	  sw $t2, -2200($fp)	# spill _tmp913 from $t2 to $fp-2200
	# _tmp914 = _tmp911 < _tmp912
	  lw $t0, -2192($fp)	# fill _tmp911 to $t0 from $fp-2192
	  lw $t1, -2196($fp)	# fill _tmp912 to $t1 from $fp-2196
	  slt $t2, $t0, $t1	
	  sw $t2, -2204($fp)	# spill _tmp914 from $t2 to $fp-2204
	# _tmp915 = _tmp913 < _tmp911
	  lw $t0, -2200($fp)	# fill _tmp913 to $t0 from $fp-2200
	  lw $t1, -2192($fp)	# fill _tmp911 to $t1 from $fp-2192
	  slt $t2, $t0, $t1	
	  sw $t2, -2208($fp)	# spill _tmp915 from $t2 to $fp-2208
	# _tmp916 = _tmp913 == _tmp911
	  lw $t0, -2200($fp)	# fill _tmp913 to $t0 from $fp-2200
	  lw $t1, -2192($fp)	# fill _tmp911 to $t1 from $fp-2192
	  seq $t2, $t0, $t1	
	  sw $t2, -2212($fp)	# spill _tmp916 from $t2 to $fp-2212
	# _tmp917 = _tmp915 || _tmp916
	  lw $t0, -2208($fp)	# fill _tmp915 to $t0 from $fp-2208
	  lw $t1, -2212($fp)	# fill _tmp916 to $t1 from $fp-2212
	  or $t2, $t0, $t1	
	  sw $t2, -2216($fp)	# spill _tmp917 from $t2 to $fp-2216
	# _tmp918 = _tmp917 || _tmp914
	  lw $t0, -2216($fp)	# fill _tmp917 to $t0 from $fp-2216
	  lw $t1, -2204($fp)	# fill _tmp914 to $t1 from $fp-2204
	  or $t2, $t0, $t1	
	  sw $t2, -2220($fp)	# spill _tmp918 from $t2 to $fp-2220
	# IfZ _tmp918 Goto _L94
	  lw $t0, -2220($fp)	# fill _tmp918 to $t0 from $fp-2220
	  beqz $t0, _L94	# branch if _tmp918 is zero 
	# _tmp919 = "Decaf runtime error: Array subscript out of bound..."
	  .data			# create string constant marked with label
	  _string64: .asciiz "Decaf runtime error: Array subscript out of bounds\n"
	  .text
	  la $t2, _string64	# load label
	  sw $t2, -2224($fp)	# spill _tmp919 from $t2 to $fp-2224
	# PushParam _tmp919
	  subu $sp, $sp, 4	# decrement sp to make space for param
	  lw $t0, -2224($fp)	# fill _tmp919 to $t0 from $fp-2224
	  sw $t0, 4($sp)	# copy param value to stack
	# LCall _PrintString
	  jal _PrintString   	# jump to function
	# PopParams 4
	  add $sp, $sp, 4	# pop params off stack
	# LCall _Halt
	  jal _Halt          	# jump to function
  _L94:
	# _tmp920 = 4
	  li $t2, 4		# load constant value 4 into $t2
	  sw $t2, -2228($fp)	# spill _tmp920 from $t2 to $fp-2228
	# _tmp921 = _tmp911 * _tmp920
	  lw $t0, -2192($fp)	# fill _tmp911 to $t0 from $fp-2192
	  lw $t1, -2228($fp)	# fill _tmp920 to $t1 from $fp-2228
	  mul $t2, $t0, $t1	
	  sw $t2, -2232($fp)	# spill _tmp921 from $t2 to $fp-2232
	# _tmp922 = _tmp921 + _tmp920
	  lw $t0, -2232($fp)	# fill _tmp921 to $t0 from $fp-2232
	  lw $t1, -2228($fp)	# fill _tmp920 to $t1 from $fp-2228
	  add $t2, $t0, $t1	
	  sw $t2, -2236($fp)	# spill _tmp922 from $t2 to $fp-2236
	# _tmp923 = _tmp910 + _tmp922
	  lw $t0, -2188($fp)	# fill _tmp910 to $t0 from $fp-2188
	  lw $t1, -2236($fp)	# fill _tmp922 to $t1 from $fp-2236
	  add $t2, $t0, $t1	
	  sw $t2, -2240($fp)	# spill _tmp923 from $t2 to $fp-2240
	# _tmp924 = *(_tmp923)
	  lw $t0, -2240($fp)	# fill _tmp923 to $t0 from $fp-2240
	  lw $t2, 0($t0) 	# load with offset
	  sw $t2, -2244($fp)	# spill _tmp924 from $t2 to $fp-2244
	# PushParam _tmp924
	  subu $sp, $sp, 4	# decrement sp to make space for param
	  lw $t0, -2244($fp)	# fill _tmp924 to $t0 from $fp-2244
	  sw $t0, 4($sp)	# copy param value to stack
	# _tmp925 = *(_tmp924)
	  lw $t0, -2244($fp)	# fill _tmp924 to $t0 from $fp-2244
	  lw $t2, 0($t0) 	# load with offset
	  sw $t2, -2248($fp)	# spill _tmp925 from $t2 to $fp-2248
	# _tmp926 = *(_tmp925 + 20)
	  lw $t0, -2248($fp)	# fill _tmp925 to $t0 from $fp-2248
	  lw $t2, 20($t0) 	# load with offset
	  sw $t2, -2252($fp)	# spill _tmp926 from $t2 to $fp-2252
	# _tmp927 = ACall _tmp926
	  lw $t0, -2252($fp)	# fill _tmp926 to $t0 from $fp-2252
	  jalr $t0            	# jump to function
	  move $t2, $v0		# copy function return value from $v0
	  sw $t2, -2256($fp)	# spill _tmp927 from $t2 to $fp-2256
	# PopParams 8
	  add $sp, $sp, 8	# pop params off stack
	# _tmp928 = _tmp895 && _tmp927
	  lw $t0, -2128($fp)	# fill _tmp895 to $t0 from $fp-2128
	  lw $t1, -2256($fp)	# fill _tmp927 to $t1 from $fp-2256
	  and $t2, $t0, $t1	
	  sw $t2, -2260($fp)	# spill _tmp928 from $t2 to $fp-2260
	# PushParam mark
	  subu $sp, $sp, 4	# decrement sp to make space for param
	  lw $t0, -8($fp)	# fill mark to $t0 from $fp-8
	  sw $t0, 4($sp)	# copy param value to stack
	# _tmp929 = *(this + 4)
	  lw $t0, 4($fp)	# fill this to $t0 from $fp+4
	  lw $t2, 4($t0) 	# load with offset
	  sw $t2, -2264($fp)	# spill _tmp929 from $t2 to $fp-2264
	# _tmp930 = 2
	  li $t2, 2		# load constant value 2 into $t2
	  sw $t2, -2268($fp)	# spill _tmp930 from $t2 to $fp-2268
	# _tmp931 = 0
	  li $t2, 0		# load constant value 0 into $t2
	  sw $t2, -2272($fp)	# spill _tmp931 from $t2 to $fp-2272
	# _tmp932 = *(_tmp929)
	  lw $t0, -2264($fp)	# fill _tmp929 to $t0 from $fp-2264
	  lw $t2, 0($t0) 	# load with offset
	  sw $t2, -2276($fp)	# spill _tmp932 from $t2 to $fp-2276
	# _tmp933 = _tmp930 < _tmp931
	  lw $t0, -2268($fp)	# fill _tmp930 to $t0 from $fp-2268
	  lw $t1, -2272($fp)	# fill _tmp931 to $t1 from $fp-2272
	  slt $t2, $t0, $t1	
	  sw $t2, -2280($fp)	# spill _tmp933 from $t2 to $fp-2280
	# _tmp934 = _tmp932 < _tmp930
	  lw $t0, -2276($fp)	# fill _tmp932 to $t0 from $fp-2276
	  lw $t1, -2268($fp)	# fill _tmp930 to $t1 from $fp-2268
	  slt $t2, $t0, $t1	
	  sw $t2, -2284($fp)	# spill _tmp934 from $t2 to $fp-2284
	# _tmp935 = _tmp932 == _tmp930
	  lw $t0, -2276($fp)	# fill _tmp932 to $t0 from $fp-2276
	  lw $t1, -2268($fp)	# fill _tmp930 to $t1 from $fp-2268
	  seq $t2, $t0, $t1	
	  sw $t2, -2288($fp)	# spill _tmp935 from $t2 to $fp-2288
	# _tmp936 = _tmp934 || _tmp935
	  lw $t0, -2284($fp)	# fill _tmp934 to $t0 from $fp-2284
	  lw $t1, -2288($fp)	# fill _tmp935 to $t1 from $fp-2288
	  or $t2, $t0, $t1	
	  sw $t2, -2292($fp)	# spill _tmp936 from $t2 to $fp-2292
	# _tmp937 = _tmp936 || _tmp933
	  lw $t0, -2292($fp)	# fill _tmp936 to $t0 from $fp-2292
	  lw $t1, -2280($fp)	# fill _tmp933 to $t1 from $fp-2280
	  or $t2, $t0, $t1	
	  sw $t2, -2296($fp)	# spill _tmp937 from $t2 to $fp-2296
	# IfZ _tmp937 Goto _L95
	  lw $t0, -2296($fp)	# fill _tmp937 to $t0 from $fp-2296
	  beqz $t0, _L95	# branch if _tmp937 is zero 
	# _tmp938 = "Decaf runtime error: Array subscript out of bound..."
	  .data			# create string constant marked with label
	  _string65: .asciiz "Decaf runtime error: Array subscript out of bounds\n"
	  .text
	  la $t2, _string65	# load label
	  sw $t2, -2300($fp)	# spill _tmp938 from $t2 to $fp-2300
	# PushParam _tmp938
	  subu $sp, $sp, 4	# decrement sp to make space for param
	  lw $t0, -2300($fp)	# fill _tmp938 to $t0 from $fp-2300
	  sw $t0, 4($sp)	# copy param value to stack
	# LCall _PrintString
	  jal _PrintString   	# jump to function
	# PopParams 4
	  add $sp, $sp, 4	# pop params off stack
	# LCall _Halt
	  jal _Halt          	# jump to function
  _L95:
	# _tmp939 = 4
	  li $t2, 4		# load constant value 4 into $t2
	  sw $t2, -2304($fp)	# spill _tmp939 from $t2 to $fp-2304
	# _tmp940 = _tmp930 * _tmp939
	  lw $t0, -2268($fp)	# fill _tmp930 to $t0 from $fp-2268
	  lw $t1, -2304($fp)	# fill _tmp939 to $t1 from $fp-2304
	  mul $t2, $t0, $t1	
	  sw $t2, -2308($fp)	# spill _tmp940 from $t2 to $fp-2308
	# _tmp941 = _tmp940 + _tmp939
	  lw $t0, -2308($fp)	# fill _tmp940 to $t0 from $fp-2308
	  lw $t1, -2304($fp)	# fill _tmp939 to $t1 from $fp-2304
	  add $t2, $t0, $t1	
	  sw $t2, -2312($fp)	# spill _tmp941 from $t2 to $fp-2312
	# _tmp942 = _tmp929 + _tmp941
	  lw $t0, -2264($fp)	# fill _tmp929 to $t0 from $fp-2264
	  lw $t1, -2312($fp)	# fill _tmp941 to $t1 from $fp-2312
	  add $t2, $t0, $t1	
	  sw $t2, -2316($fp)	# spill _tmp942 from $t2 to $fp-2316
	# _tmp943 = *(_tmp942)
	  lw $t0, -2316($fp)	# fill _tmp942 to $t0 from $fp-2316
	  lw $t2, 0($t0) 	# load with offset
	  sw $t2, -2320($fp)	# spill _tmp943 from $t2 to $fp-2320
	# _tmp944 = 2
	  li $t2, 2		# load constant value 2 into $t2
	  sw $t2, -2324($fp)	# spill _tmp944 from $t2 to $fp-2324
	# _tmp945 = 0
	  li $t2, 0		# load constant value 0 into $t2
	  sw $t2, -2328($fp)	# spill _tmp945 from $t2 to $fp-2328
	# _tmp946 = *(_tmp943)
	  lw $t0, -2320($fp)	# fill _tmp943 to $t0 from $fp-2320
	  lw $t2, 0($t0) 	# load with offset
	  sw $t2, -2332($fp)	# spill _tmp946 from $t2 to $fp-2332
	# _tmp947 = _tmp944 < _tmp945
	  lw $t0, -2324($fp)	# fill _tmp944 to $t0 from $fp-2324
	  lw $t1, -2328($fp)	# fill _tmp945 to $t1 from $fp-2328
	  slt $t2, $t0, $t1	
	  sw $t2, -2336($fp)	# spill _tmp947 from $t2 to $fp-2336
	# _tmp948 = _tmp946 < _tmp944
	  lw $t0, -2332($fp)	# fill _tmp946 to $t0 from $fp-2332
	  lw $t1, -2324($fp)	# fill _tmp944 to $t1 from $fp-2324
	  slt $t2, $t0, $t1	
	  sw $t2, -2340($fp)	# spill _tmp948 from $t2 to $fp-2340
	# _tmp949 = _tmp946 == _tmp944
	  lw $t0, -2332($fp)	# fill _tmp946 to $t0 from $fp-2332
	  lw $t1, -2324($fp)	# fill _tmp944 to $t1 from $fp-2324
	  seq $t2, $t0, $t1	
	  sw $t2, -2344($fp)	# spill _tmp949 from $t2 to $fp-2344
	# _tmp950 = _tmp948 || _tmp949
	  lw $t0, -2340($fp)	# fill _tmp948 to $t0 from $fp-2340
	  lw $t1, -2344($fp)	# fill _tmp949 to $t1 from $fp-2344
	  or $t2, $t0, $t1	
	  sw $t2, -2348($fp)	# spill _tmp950 from $t2 to $fp-2348
	# _tmp951 = _tmp950 || _tmp947
	  lw $t0, -2348($fp)	# fill _tmp950 to $t0 from $fp-2348
	  lw $t1, -2336($fp)	# fill _tmp947 to $t1 from $fp-2336
	  or $t2, $t0, $t1	
	  sw $t2, -2352($fp)	# spill _tmp951 from $t2 to $fp-2352
	# IfZ _tmp951 Goto _L96
	  lw $t0, -2352($fp)	# fill _tmp951 to $t0 from $fp-2352
	  beqz $t0, _L96	# branch if _tmp951 is zero 
	# _tmp952 = "Decaf runtime error: Array subscript out of bound..."
	  .data			# create string constant marked with label
	  _string66: .asciiz "Decaf runtime error: Array subscript out of bounds\n"
	  .text
	  la $t2, _string66	# load label
	  sw $t2, -2356($fp)	# spill _tmp952 from $t2 to $fp-2356
	# PushParam _tmp952
	  subu $sp, $sp, 4	# decrement sp to make space for param
	  lw $t0, -2356($fp)	# fill _tmp952 to $t0 from $fp-2356
	  sw $t0, 4($sp)	# copy param value to stack
	# LCall _PrintString
	  jal _PrintString   	# jump to function
	# PopParams 4
	  add $sp, $sp, 4	# pop params off stack
	# LCall _Halt
	  jal _Halt          	# jump to function
  _L96:
	# _tmp953 = 4
	  li $t2, 4		# load constant value 4 into $t2
	  sw $t2, -2360($fp)	# spill _tmp953 from $t2 to $fp-2360
	# _tmp954 = _tmp944 * _tmp953
	  lw $t0, -2324($fp)	# fill _tmp944 to $t0 from $fp-2324
	  lw $t1, -2360($fp)	# fill _tmp953 to $t1 from $fp-2360
	  mul $t2, $t0, $t1	
	  sw $t2, -2364($fp)	# spill _tmp954 from $t2 to $fp-2364
	# _tmp955 = _tmp954 + _tmp953
	  lw $t0, -2364($fp)	# fill _tmp954 to $t0 from $fp-2364
	  lw $t1, -2360($fp)	# fill _tmp953 to $t1 from $fp-2360
	  add $t2, $t0, $t1	
	  sw $t2, -2368($fp)	# spill _tmp955 from $t2 to $fp-2368
	# _tmp956 = _tmp943 + _tmp955
	  lw $t0, -2320($fp)	# fill _tmp943 to $t0 from $fp-2320
	  lw $t1, -2368($fp)	# fill _tmp955 to $t1 from $fp-2368
	  add $t2, $t0, $t1	
	  sw $t2, -2372($fp)	# spill _tmp956 from $t2 to $fp-2372
	# _tmp957 = *(_tmp956)
	  lw $t0, -2372($fp)	# fill _tmp956 to $t0 from $fp-2372
	  lw $t2, 0($t0) 	# load with offset
	  sw $t2, -2376($fp)	# spill _tmp957 from $t2 to $fp-2376
	# PushParam _tmp957
	  subu $sp, $sp, 4	# decrement sp to make space for param
	  lw $t0, -2376($fp)	# fill _tmp957 to $t0 from $fp-2376
	  sw $t0, 4($sp)	# copy param value to stack
	# _tmp958 = *(_tmp957)
	  lw $t0, -2376($fp)	# fill _tmp957 to $t0 from $fp-2376
	  lw $t2, 0($t0) 	# load with offset
	  sw $t2, -2380($fp)	# spill _tmp958 from $t2 to $fp-2380
	# _tmp959 = *(_tmp958 + 20)
	  lw $t0, -2380($fp)	# fill _tmp958 to $t0 from $fp-2380
	  lw $t2, 20($t0) 	# load with offset
	  sw $t2, -2384($fp)	# spill _tmp959 from $t2 to $fp-2384
	# _tmp960 = ACall _tmp959
	  lw $t0, -2384($fp)	# fill _tmp959 to $t0 from $fp-2384
	  jalr $t0            	# jump to function
	  move $t2, $v0		# copy function return value from $v0
	  sw $t2, -2388($fp)	# spill _tmp960 from $t2 to $fp-2388
	# PopParams 8
	  add $sp, $sp, 8	# pop params off stack
	# _tmp961 = _tmp928 && _tmp960
	  lw $t0, -2260($fp)	# fill _tmp928 to $t0 from $fp-2260
	  lw $t1, -2388($fp)	# fill _tmp960 to $t1 from $fp-2388
	  and $t2, $t0, $t1	
	  sw $t2, -2392($fp)	# spill _tmp961 from $t2 to $fp-2392
	# IfZ _tmp961 Goto _L89
	  lw $t0, -2392($fp)	# fill _tmp961 to $t0 from $fp-2392
	  beqz $t0, _L89	# branch if _tmp961 is zero 
	# _tmp962 = 0
	  li $t2, 0		# load constant value 0 into $t2
	  sw $t2, -2396($fp)	# spill _tmp962 from $t2 to $fp-2396
	# Return _tmp962
	  lw $t2, -2396($fp)	# fill _tmp962 to $t2 from $fp-2396
	  move $v0, $t2		# assign return value into $v0
	  move $sp, $fp		# pop callee frame off stack
	  lw $ra, -4($fp)	# restore saved ra
	  lw $fp, 0($fp)	# restore saved fp
	  jr $ra		# return from function
	# Goto _L90
	  b _L90		# unconditional branch
  _L89:
  _L90:
	# PushParam mark
	  subu $sp, $sp, 4	# decrement sp to make space for param
	  lw $t0, -8($fp)	# fill mark to $t0 from $fp-8
	  sw $t0, 4($sp)	# copy param value to stack
	# _tmp963 = *(this + 4)
	  lw $t0, 4($fp)	# fill this to $t0 from $fp+4
	  lw $t2, 4($t0) 	# load with offset
	  sw $t2, -2400($fp)	# spill _tmp963 from $t2 to $fp-2400
	# _tmp964 = 0
	  li $t2, 0		# load constant value 0 into $t2
	  sw $t2, -2404($fp)	# spill _tmp964 from $t2 to $fp-2404
	# _tmp965 = 0
	  li $t2, 0		# load constant value 0 into $t2
	  sw $t2, -2408($fp)	# spill _tmp965 from $t2 to $fp-2408
	# _tmp966 = *(_tmp963)
	  lw $t0, -2400($fp)	# fill _tmp963 to $t0 from $fp-2400
	  lw $t2, 0($t0) 	# load with offset
	  sw $t2, -2412($fp)	# spill _tmp966 from $t2 to $fp-2412
	# _tmp967 = _tmp964 < _tmp965
	  lw $t0, -2404($fp)	# fill _tmp964 to $t0 from $fp-2404
	  lw $t1, -2408($fp)	# fill _tmp965 to $t1 from $fp-2408
	  slt $t2, $t0, $t1	
	  sw $t2, -2416($fp)	# spill _tmp967 from $t2 to $fp-2416
	# _tmp968 = _tmp966 < _tmp964
	  lw $t0, -2412($fp)	# fill _tmp966 to $t0 from $fp-2412
	  lw $t1, -2404($fp)	# fill _tmp964 to $t1 from $fp-2404
	  slt $t2, $t0, $t1	
	  sw $t2, -2420($fp)	# spill _tmp968 from $t2 to $fp-2420
	# _tmp969 = _tmp966 == _tmp964
	  lw $t0, -2412($fp)	# fill _tmp966 to $t0 from $fp-2412
	  lw $t1, -2404($fp)	# fill _tmp964 to $t1 from $fp-2404
	  seq $t2, $t0, $t1	
	  sw $t2, -2424($fp)	# spill _tmp969 from $t2 to $fp-2424
	# _tmp970 = _tmp968 || _tmp969
	  lw $t0, -2420($fp)	# fill _tmp968 to $t0 from $fp-2420
	  lw $t1, -2424($fp)	# fill _tmp969 to $t1 from $fp-2424
	  or $t2, $t0, $t1	
	  sw $t2, -2428($fp)	# spill _tmp970 from $t2 to $fp-2428
	# _tmp971 = _tmp970 || _tmp967
	  lw $t0, -2428($fp)	# fill _tmp970 to $t0 from $fp-2428
	  lw $t1, -2416($fp)	# fill _tmp967 to $t1 from $fp-2416
	  or $t2, $t0, $t1	
	  sw $t2, -2432($fp)	# spill _tmp971 from $t2 to $fp-2432
	# IfZ _tmp971 Goto _L99
	  lw $t0, -2432($fp)	# fill _tmp971 to $t0 from $fp-2432
	  beqz $t0, _L99	# branch if _tmp971 is zero 
	# _tmp972 = "Decaf runtime error: Array subscript out of bound..."
	  .data			# create string constant marked with label
	  _string67: .asciiz "Decaf runtime error: Array subscript out of bounds\n"
	  .text
	  la $t2, _string67	# load label
	  sw $t2, -2436($fp)	# spill _tmp972 from $t2 to $fp-2436
	# PushParam _tmp972
	  subu $sp, $sp, 4	# decrement sp to make space for param
	  lw $t0, -2436($fp)	# fill _tmp972 to $t0 from $fp-2436
	  sw $t0, 4($sp)	# copy param value to stack
	# LCall _PrintString
	  jal _PrintString   	# jump to function
	# PopParams 4
	  add $sp, $sp, 4	# pop params off stack
	# LCall _Halt
	  jal _Halt          	# jump to function
  _L99:
	# _tmp973 = 4
	  li $t2, 4		# load constant value 4 into $t2
	  sw $t2, -2440($fp)	# spill _tmp973 from $t2 to $fp-2440
	# _tmp974 = _tmp964 * _tmp973
	  lw $t0, -2404($fp)	# fill _tmp964 to $t0 from $fp-2404
	  lw $t1, -2440($fp)	# fill _tmp973 to $t1 from $fp-2440
	  mul $t2, $t0, $t1	
	  sw $t2, -2444($fp)	# spill _tmp974 from $t2 to $fp-2444
	# _tmp975 = _tmp974 + _tmp973
	  lw $t0, -2444($fp)	# fill _tmp974 to $t0 from $fp-2444
	  lw $t1, -2440($fp)	# fill _tmp973 to $t1 from $fp-2440
	  add $t2, $t0, $t1	
	  sw $t2, -2448($fp)	# spill _tmp975 from $t2 to $fp-2448
	# _tmp976 = _tmp963 + _tmp975
	  lw $t0, -2400($fp)	# fill _tmp963 to $t0 from $fp-2400
	  lw $t1, -2448($fp)	# fill _tmp975 to $t1 from $fp-2448
	  add $t2, $t0, $t1	
	  sw $t2, -2452($fp)	# spill _tmp976 from $t2 to $fp-2452
	# _tmp977 = *(_tmp976)
	  lw $t0, -2452($fp)	# fill _tmp976 to $t0 from $fp-2452
	  lw $t2, 0($t0) 	# load with offset
	  sw $t2, -2456($fp)	# spill _tmp977 from $t2 to $fp-2456
	# _tmp978 = 0
	  li $t2, 0		# load constant value 0 into $t2
	  sw $t2, -2460($fp)	# spill _tmp978 from $t2 to $fp-2460
	# _tmp979 = 0
	  li $t2, 0		# load constant value 0 into $t2
	  sw $t2, -2464($fp)	# spill _tmp979 from $t2 to $fp-2464
	# _tmp980 = *(_tmp977)
	  lw $t0, -2456($fp)	# fill _tmp977 to $t0 from $fp-2456
	  lw $t2, 0($t0) 	# load with offset
	  sw $t2, -2468($fp)	# spill _tmp980 from $t2 to $fp-2468
	# _tmp981 = _tmp978 < _tmp979
	  lw $t0, -2460($fp)	# fill _tmp978 to $t0 from $fp-2460
	  lw $t1, -2464($fp)	# fill _tmp979 to $t1 from $fp-2464
	  slt $t2, $t0, $t1	
	  sw $t2, -2472($fp)	# spill _tmp981 from $t2 to $fp-2472
	# _tmp982 = _tmp980 < _tmp978
	  lw $t0, -2468($fp)	# fill _tmp980 to $t0 from $fp-2468
	  lw $t1, -2460($fp)	# fill _tmp978 to $t1 from $fp-2460
	  slt $t2, $t0, $t1	
	  sw $t2, -2476($fp)	# spill _tmp982 from $t2 to $fp-2476
	# _tmp983 = _tmp980 == _tmp978
	  lw $t0, -2468($fp)	# fill _tmp980 to $t0 from $fp-2468
	  lw $t1, -2460($fp)	# fill _tmp978 to $t1 from $fp-2460
	  seq $t2, $t0, $t1	
	  sw $t2, -2480($fp)	# spill _tmp983 from $t2 to $fp-2480
	# _tmp984 = _tmp982 || _tmp983
	  lw $t0, -2476($fp)	# fill _tmp982 to $t0 from $fp-2476
	  lw $t1, -2480($fp)	# fill _tmp983 to $t1 from $fp-2480
	  or $t2, $t0, $t1	
	  sw $t2, -2484($fp)	# spill _tmp984 from $t2 to $fp-2484
	# _tmp985 = _tmp984 || _tmp981
	  lw $t0, -2484($fp)	# fill _tmp984 to $t0 from $fp-2484
	  lw $t1, -2472($fp)	# fill _tmp981 to $t1 from $fp-2472
	  or $t2, $t0, $t1	
	  sw $t2, -2488($fp)	# spill _tmp985 from $t2 to $fp-2488
	# IfZ _tmp985 Goto _L100
	  lw $t0, -2488($fp)	# fill _tmp985 to $t0 from $fp-2488
	  beqz $t0, _L100	# branch if _tmp985 is zero 
	# _tmp986 = "Decaf runtime error: Array subscript out of bound..."
	  .data			# create string constant marked with label
	  _string68: .asciiz "Decaf runtime error: Array subscript out of bounds\n"
	  .text
	  la $t2, _string68	# load label
	  sw $t2, -2492($fp)	# spill _tmp986 from $t2 to $fp-2492
	# PushParam _tmp986
	  subu $sp, $sp, 4	# decrement sp to make space for param
	  lw $t0, -2492($fp)	# fill _tmp986 to $t0 from $fp-2492
	  sw $t0, 4($sp)	# copy param value to stack
	# LCall _PrintString
	  jal _PrintString   	# jump to function
	# PopParams 4
	  add $sp, $sp, 4	# pop params off stack
	# LCall _Halt
	  jal _Halt          	# jump to function
  _L100:
	# _tmp987 = 4
	  li $t2, 4		# load constant value 4 into $t2
	  sw $t2, -2496($fp)	# spill _tmp987 from $t2 to $fp-2496
	# _tmp988 = _tmp978 * _tmp987
	  lw $t0, -2460($fp)	# fill _tmp978 to $t0 from $fp-2460
	  lw $t1, -2496($fp)	# fill _tmp987 to $t1 from $fp-2496
	  mul $t2, $t0, $t1	
	  sw $t2, -2500($fp)	# spill _tmp988 from $t2 to $fp-2500
	# _tmp989 = _tmp988 + _tmp987
	  lw $t0, -2500($fp)	# fill _tmp988 to $t0 from $fp-2500
	  lw $t1, -2496($fp)	# fill _tmp987 to $t1 from $fp-2496
	  add $t2, $t0, $t1	
	  sw $t2, -2504($fp)	# spill _tmp989 from $t2 to $fp-2504
	# _tmp990 = _tmp977 + _tmp989
	  lw $t0, -2456($fp)	# fill _tmp977 to $t0 from $fp-2456
	  lw $t1, -2504($fp)	# fill _tmp989 to $t1 from $fp-2504
	  add $t2, $t0, $t1	
	  sw $t2, -2508($fp)	# spill _tmp990 from $t2 to $fp-2508
	# _tmp991 = *(_tmp990)
	  lw $t0, -2508($fp)	# fill _tmp990 to $t0 from $fp-2508
	  lw $t2, 0($t0) 	# load with offset
	  sw $t2, -2512($fp)	# spill _tmp991 from $t2 to $fp-2512
	# PushParam _tmp991
	  subu $sp, $sp, 4	# decrement sp to make space for param
	  lw $t0, -2512($fp)	# fill _tmp991 to $t0 from $fp-2512
	  sw $t0, 4($sp)	# copy param value to stack
	# _tmp992 = *(_tmp991)
	  lw $t0, -2512($fp)	# fill _tmp991 to $t0 from $fp-2512
	  lw $t2, 0($t0) 	# load with offset
	  sw $t2, -2516($fp)	# spill _tmp992 from $t2 to $fp-2516
	# _tmp993 = *(_tmp992 + 20)
	  lw $t0, -2516($fp)	# fill _tmp992 to $t0 from $fp-2516
	  lw $t2, 20($t0) 	# load with offset
	  sw $t2, -2520($fp)	# spill _tmp993 from $t2 to $fp-2520
	# _tmp994 = ACall _tmp993
	  lw $t0, -2520($fp)	# fill _tmp993 to $t0 from $fp-2520
	  jalr $t0            	# jump to function
	  move $t2, $v0		# copy function return value from $v0
	  sw $t2, -2524($fp)	# spill _tmp994 from $t2 to $fp-2524
	# PopParams 8
	  add $sp, $sp, 8	# pop params off stack
	# PushParam mark
	  subu $sp, $sp, 4	# decrement sp to make space for param
	  lw $t0, -8($fp)	# fill mark to $t0 from $fp-8
	  sw $t0, 4($sp)	# copy param value to stack
	# _tmp995 = *(this + 4)
	  lw $t0, 4($fp)	# fill this to $t0 from $fp+4
	  lw $t2, 4($t0) 	# load with offset
	  sw $t2, -2528($fp)	# spill _tmp995 from $t2 to $fp-2528
	# _tmp996 = 1
	  li $t2, 1		# load constant value 1 into $t2
	  sw $t2, -2532($fp)	# spill _tmp996 from $t2 to $fp-2532
	# _tmp997 = 0
	  li $t2, 0		# load constant value 0 into $t2
	  sw $t2, -2536($fp)	# spill _tmp997 from $t2 to $fp-2536
	# _tmp998 = *(_tmp995)
	  lw $t0, -2528($fp)	# fill _tmp995 to $t0 from $fp-2528
	  lw $t2, 0($t0) 	# load with offset
	  sw $t2, -2540($fp)	# spill _tmp998 from $t2 to $fp-2540
	# _tmp999 = _tmp996 < _tmp997
	  lw $t0, -2532($fp)	# fill _tmp996 to $t0 from $fp-2532
	  lw $t1, -2536($fp)	# fill _tmp997 to $t1 from $fp-2536
	  slt $t2, $t0, $t1	
	  sw $t2, -2544($fp)	# spill _tmp999 from $t2 to $fp-2544
	# _tmp1000 = _tmp998 < _tmp996
	  lw $t0, -2540($fp)	# fill _tmp998 to $t0 from $fp-2540
	  lw $t1, -2532($fp)	# fill _tmp996 to $t1 from $fp-2532
	  slt $t2, $t0, $t1	
	  sw $t2, -2548($fp)	# spill _tmp1000 from $t2 to $fp-2548
	# _tmp1001 = _tmp998 == _tmp996
	  lw $t0, -2540($fp)	# fill _tmp998 to $t0 from $fp-2540
	  lw $t1, -2532($fp)	# fill _tmp996 to $t1 from $fp-2532
	  seq $t2, $t0, $t1	
	  sw $t2, -2552($fp)	# spill _tmp1001 from $t2 to $fp-2552
	# _tmp1002 = _tmp1000 || _tmp1001
	  lw $t0, -2548($fp)	# fill _tmp1000 to $t0 from $fp-2548
	  lw $t1, -2552($fp)	# fill _tmp1001 to $t1 from $fp-2552
	  or $t2, $t0, $t1	
	  sw $t2, -2556($fp)	# spill _tmp1002 from $t2 to $fp-2556
	# _tmp1003 = _tmp1002 || _tmp999
	  lw $t0, -2556($fp)	# fill _tmp1002 to $t0 from $fp-2556
	  lw $t1, -2544($fp)	# fill _tmp999 to $t1 from $fp-2544
	  or $t2, $t0, $t1	
	  sw $t2, -2560($fp)	# spill _tmp1003 from $t2 to $fp-2560
	# IfZ _tmp1003 Goto _L101
	  lw $t0, -2560($fp)	# fill _tmp1003 to $t0 from $fp-2560
	  beqz $t0, _L101	# branch if _tmp1003 is zero 
	# _tmp1004 = "Decaf runtime error: Array subscript out of bound..."
	  .data			# create string constant marked with label
	  _string69: .asciiz "Decaf runtime error: Array subscript out of bounds\n"
	  .text
	  la $t2, _string69	# load label
	  sw $t2, -2564($fp)	# spill _tmp1004 from $t2 to $fp-2564
	# PushParam _tmp1004
	  subu $sp, $sp, 4	# decrement sp to make space for param
	  lw $t0, -2564($fp)	# fill _tmp1004 to $t0 from $fp-2564
	  sw $t0, 4($sp)	# copy param value to stack
	# LCall _PrintString
	  jal _PrintString   	# jump to function
	# PopParams 4
	  add $sp, $sp, 4	# pop params off stack
	# LCall _Halt
	  jal _Halt          	# jump to function
  _L101:
	# _tmp1005 = 4
	  li $t2, 4		# load constant value 4 into $t2
	  sw $t2, -2568($fp)	# spill _tmp1005 from $t2 to $fp-2568
	# _tmp1006 = _tmp996 * _tmp1005
	  lw $t0, -2532($fp)	# fill _tmp996 to $t0 from $fp-2532
	  lw $t1, -2568($fp)	# fill _tmp1005 to $t1 from $fp-2568
	  mul $t2, $t0, $t1	
	  sw $t2, -2572($fp)	# spill _tmp1006 from $t2 to $fp-2572
	# _tmp1007 = _tmp1006 + _tmp1005
	  lw $t0, -2572($fp)	# fill _tmp1006 to $t0 from $fp-2572
	  lw $t1, -2568($fp)	# fill _tmp1005 to $t1 from $fp-2568
	  add $t2, $t0, $t1	
	  sw $t2, -2576($fp)	# spill _tmp1007 from $t2 to $fp-2576
	# _tmp1008 = _tmp995 + _tmp1007
	  lw $t0, -2528($fp)	# fill _tmp995 to $t0 from $fp-2528
	  lw $t1, -2576($fp)	# fill _tmp1007 to $t1 from $fp-2576
	  add $t2, $t0, $t1	
	  sw $t2, -2580($fp)	# spill _tmp1008 from $t2 to $fp-2580
	# _tmp1009 = *(_tmp1008)
	  lw $t0, -2580($fp)	# fill _tmp1008 to $t0 from $fp-2580
	  lw $t2, 0($t0) 	# load with offset
	  sw $t2, -2584($fp)	# spill _tmp1009 from $t2 to $fp-2584
	# _tmp1010 = 1
	  li $t2, 1		# load constant value 1 into $t2
	  sw $t2, -2588($fp)	# spill _tmp1010 from $t2 to $fp-2588
	# _tmp1011 = 0
	  li $t2, 0		# load constant value 0 into $t2
	  sw $t2, -2592($fp)	# spill _tmp1011 from $t2 to $fp-2592
	# _tmp1012 = *(_tmp1009)
	  lw $t0, -2584($fp)	# fill _tmp1009 to $t0 from $fp-2584
	  lw $t2, 0($t0) 	# load with offset
	  sw $t2, -2596($fp)	# spill _tmp1012 from $t2 to $fp-2596
	# _tmp1013 = _tmp1010 < _tmp1011
	  lw $t0, -2588($fp)	# fill _tmp1010 to $t0 from $fp-2588
	  lw $t1, -2592($fp)	# fill _tmp1011 to $t1 from $fp-2592
	  slt $t2, $t0, $t1	
	  sw $t2, -2600($fp)	# spill _tmp1013 from $t2 to $fp-2600
	# _tmp1014 = _tmp1012 < _tmp1010
	  lw $t0, -2596($fp)	# fill _tmp1012 to $t0 from $fp-2596
	  lw $t1, -2588($fp)	# fill _tmp1010 to $t1 from $fp-2588
	  slt $t2, $t0, $t1	
	  sw $t2, -2604($fp)	# spill _tmp1014 from $t2 to $fp-2604
	# _tmp1015 = _tmp1012 == _tmp1010
	  lw $t0, -2596($fp)	# fill _tmp1012 to $t0 from $fp-2596
	  lw $t1, -2588($fp)	# fill _tmp1010 to $t1 from $fp-2588
	  seq $t2, $t0, $t1	
	  sw $t2, -2608($fp)	# spill _tmp1015 from $t2 to $fp-2608
	# _tmp1016 = _tmp1014 || _tmp1015
	  lw $t0, -2604($fp)	# fill _tmp1014 to $t0 from $fp-2604
	  lw $t1, -2608($fp)	# fill _tmp1015 to $t1 from $fp-2608
	  or $t2, $t0, $t1	
	  sw $t2, -2612($fp)	# spill _tmp1016 from $t2 to $fp-2612
	# _tmp1017 = _tmp1016 || _tmp1013
	  lw $t0, -2612($fp)	# fill _tmp1016 to $t0 from $fp-2612
	  lw $t1, -2600($fp)	# fill _tmp1013 to $t1 from $fp-2600
	  or $t2, $t0, $t1	
	  sw $t2, -2616($fp)	# spill _tmp1017 from $t2 to $fp-2616
	# IfZ _tmp1017 Goto _L102
	  lw $t0, -2616($fp)	# fill _tmp1017 to $t0 from $fp-2616
	  beqz $t0, _L102	# branch if _tmp1017 is zero 
	# _tmp1018 = "Decaf runtime error: Array subscript out of bound..."
	  .data			# create string constant marked with label
	  _string70: .asciiz "Decaf runtime error: Array subscript out of bounds\n"
	  .text
	  la $t2, _string70	# load label
	  sw $t2, -2620($fp)	# spill _tmp1018 from $t2 to $fp-2620
	# PushParam _tmp1018
	  subu $sp, $sp, 4	# decrement sp to make space for param
	  lw $t0, -2620($fp)	# fill _tmp1018 to $t0 from $fp-2620
	  sw $t0, 4($sp)	# copy param value to stack
	# LCall _PrintString
	  jal _PrintString   	# jump to function
	# PopParams 4
	  add $sp, $sp, 4	# pop params off stack
	# LCall _Halt
	  jal _Halt          	# jump to function
  _L102:
	# _tmp1019 = 4
	  li $t2, 4		# load constant value 4 into $t2
	  sw $t2, -2624($fp)	# spill _tmp1019 from $t2 to $fp-2624
	# _tmp1020 = _tmp1010 * _tmp1019
	  lw $t0, -2588($fp)	# fill _tmp1010 to $t0 from $fp-2588
	  lw $t1, -2624($fp)	# fill _tmp1019 to $t1 from $fp-2624
	  mul $t2, $t0, $t1	
	  sw $t2, -2628($fp)	# spill _tmp1020 from $t2 to $fp-2628
	# _tmp1021 = _tmp1020 + _tmp1019
	  lw $t0, -2628($fp)	# fill _tmp1020 to $t0 from $fp-2628
	  lw $t1, -2624($fp)	# fill _tmp1019 to $t1 from $fp-2624
	  add $t2, $t0, $t1	
	  sw $t2, -2632($fp)	# spill _tmp1021 from $t2 to $fp-2632
	# _tmp1022 = _tmp1009 + _tmp1021
	  lw $t0, -2584($fp)	# fill _tmp1009 to $t0 from $fp-2584
	  lw $t1, -2632($fp)	# fill _tmp1021 to $t1 from $fp-2632
	  add $t2, $t0, $t1	
	  sw $t2, -2636($fp)	# spill _tmp1022 from $t2 to $fp-2636
	# _tmp1023 = *(_tmp1022)
	  lw $t0, -2636($fp)	# fill _tmp1022 to $t0 from $fp-2636
	  lw $t2, 0($t0) 	# load with offset
	  sw $t2, -2640($fp)	# spill _tmp1023 from $t2 to $fp-2640
	# PushParam _tmp1023
	  subu $sp, $sp, 4	# decrement sp to make space for param
	  lw $t0, -2640($fp)	# fill _tmp1023 to $t0 from $fp-2640
	  sw $t0, 4($sp)	# copy param value to stack
	# _tmp1024 = *(_tmp1023)
	  lw $t0, -2640($fp)	# fill _tmp1023 to $t0 from $fp-2640
	  lw $t2, 0($t0) 	# load with offset
	  sw $t2, -2644($fp)	# spill _tmp1024 from $t2 to $fp-2644
	# _tmp1025 = *(_tmp1024 + 20)
	  lw $t0, -2644($fp)	# fill _tmp1024 to $t0 from $fp-2644
	  lw $t2, 20($t0) 	# load with offset
	  sw $t2, -2648($fp)	# spill _tmp1025 from $t2 to $fp-2648
	# _tmp1026 = ACall _tmp1025
	  lw $t0, -2648($fp)	# fill _tmp1025 to $t0 from $fp-2648
	  jalr $t0            	# jump to function
	  move $t2, $v0		# copy function return value from $v0
	  sw $t2, -2652($fp)	# spill _tmp1026 from $t2 to $fp-2652
	# PopParams 8
	  add $sp, $sp, 8	# pop params off stack
	# _tmp1027 = _tmp994 && _tmp1026
	  lw $t0, -2524($fp)	# fill _tmp994 to $t0 from $fp-2524
	  lw $t1, -2652($fp)	# fill _tmp1026 to $t1 from $fp-2652
	  and $t2, $t0, $t1	
	  sw $t2, -2656($fp)	# spill _tmp1027 from $t2 to $fp-2656
	# PushParam mark
	  subu $sp, $sp, 4	# decrement sp to make space for param
	  lw $t0, -8($fp)	# fill mark to $t0 from $fp-8
	  sw $t0, 4($sp)	# copy param value to stack
	# _tmp1028 = *(this + 4)
	  lw $t0, 4($fp)	# fill this to $t0 from $fp+4
	  lw $t2, 4($t0) 	# load with offset
	  sw $t2, -2660($fp)	# spill _tmp1028 from $t2 to $fp-2660
	# _tmp1029 = 2
	  li $t2, 2		# load constant value 2 into $t2
	  sw $t2, -2664($fp)	# spill _tmp1029 from $t2 to $fp-2664
	# _tmp1030 = 0
	  li $t2, 0		# load constant value 0 into $t2
	  sw $t2, -2668($fp)	# spill _tmp1030 from $t2 to $fp-2668
	# _tmp1031 = *(_tmp1028)
	  lw $t0, -2660($fp)	# fill _tmp1028 to $t0 from $fp-2660
	  lw $t2, 0($t0) 	# load with offset
	  sw $t2, -2672($fp)	# spill _tmp1031 from $t2 to $fp-2672
	# _tmp1032 = _tmp1029 < _tmp1030
	  lw $t0, -2664($fp)	# fill _tmp1029 to $t0 from $fp-2664
	  lw $t1, -2668($fp)	# fill _tmp1030 to $t1 from $fp-2668
	  slt $t2, $t0, $t1	
	  sw $t2, -2676($fp)	# spill _tmp1032 from $t2 to $fp-2676
	# _tmp1033 = _tmp1031 < _tmp1029
	  lw $t0, -2672($fp)	# fill _tmp1031 to $t0 from $fp-2672
	  lw $t1, -2664($fp)	# fill _tmp1029 to $t1 from $fp-2664
	  slt $t2, $t0, $t1	
	  sw $t2, -2680($fp)	# spill _tmp1033 from $t2 to $fp-2680
	# _tmp1034 = _tmp1031 == _tmp1029
	  lw $t0, -2672($fp)	# fill _tmp1031 to $t0 from $fp-2672
	  lw $t1, -2664($fp)	# fill _tmp1029 to $t1 from $fp-2664
	  seq $t2, $t0, $t1	
	  sw $t2, -2684($fp)	# spill _tmp1034 from $t2 to $fp-2684
	# _tmp1035 = _tmp1033 || _tmp1034
	  lw $t0, -2680($fp)	# fill _tmp1033 to $t0 from $fp-2680
	  lw $t1, -2684($fp)	# fill _tmp1034 to $t1 from $fp-2684
	  or $t2, $t0, $t1	
	  sw $t2, -2688($fp)	# spill _tmp1035 from $t2 to $fp-2688
	# _tmp1036 = _tmp1035 || _tmp1032
	  lw $t0, -2688($fp)	# fill _tmp1035 to $t0 from $fp-2688
	  lw $t1, -2676($fp)	# fill _tmp1032 to $t1 from $fp-2676
	  or $t2, $t0, $t1	
	  sw $t2, -2692($fp)	# spill _tmp1036 from $t2 to $fp-2692
	# IfZ _tmp1036 Goto _L103
	  lw $t0, -2692($fp)	# fill _tmp1036 to $t0 from $fp-2692
	  beqz $t0, _L103	# branch if _tmp1036 is zero 
	# _tmp1037 = "Decaf runtime error: Array subscript out of bound..."
	  .data			# create string constant marked with label
	  _string71: .asciiz "Decaf runtime error: Array subscript out of bounds\n"
	  .text
	  la $t2, _string71	# load label
	  sw $t2, -2696($fp)	# spill _tmp1037 from $t2 to $fp-2696
	# PushParam _tmp1037
	  subu $sp, $sp, 4	# decrement sp to make space for param
	  lw $t0, -2696($fp)	# fill _tmp1037 to $t0 from $fp-2696
	  sw $t0, 4($sp)	# copy param value to stack
	# LCall _PrintString
	  jal _PrintString   	# jump to function
	# PopParams 4
	  add $sp, $sp, 4	# pop params off stack
	# LCall _Halt
	  jal _Halt          	# jump to function
  _L103:
	# _tmp1038 = 4
	  li $t2, 4		# load constant value 4 into $t2
	  sw $t2, -2700($fp)	# spill _tmp1038 from $t2 to $fp-2700
	# _tmp1039 = _tmp1029 * _tmp1038
	  lw $t0, -2664($fp)	# fill _tmp1029 to $t0 from $fp-2664
	  lw $t1, -2700($fp)	# fill _tmp1038 to $t1 from $fp-2700
	  mul $t2, $t0, $t1	
	  sw $t2, -2704($fp)	# spill _tmp1039 from $t2 to $fp-2704
	# _tmp1040 = _tmp1039 + _tmp1038
	  lw $t0, -2704($fp)	# fill _tmp1039 to $t0 from $fp-2704
	  lw $t1, -2700($fp)	# fill _tmp1038 to $t1 from $fp-2700
	  add $t2, $t0, $t1	
	  sw $t2, -2708($fp)	# spill _tmp1040 from $t2 to $fp-2708
	# _tmp1041 = _tmp1028 + _tmp1040
	  lw $t0, -2660($fp)	# fill _tmp1028 to $t0 from $fp-2660
	  lw $t1, -2708($fp)	# fill _tmp1040 to $t1 from $fp-2708
	  add $t2, $t0, $t1	
	  sw $t2, -2712($fp)	# spill _tmp1041 from $t2 to $fp-2712
	# _tmp1042 = *(_tmp1041)
	  lw $t0, -2712($fp)	# fill _tmp1041 to $t0 from $fp-2712
	  lw $t2, 0($t0) 	# load with offset
	  sw $t2, -2716($fp)	# spill _tmp1042 from $t2 to $fp-2716
	# _tmp1043 = 2
	  li $t2, 2		# load constant value 2 into $t2
	  sw $t2, -2720($fp)	# spill _tmp1043 from $t2 to $fp-2720
	# _tmp1044 = 0
	  li $t2, 0		# load constant value 0 into $t2
	  sw $t2, -2724($fp)	# spill _tmp1044 from $t2 to $fp-2724
	# _tmp1045 = *(_tmp1042)
	  lw $t0, -2716($fp)	# fill _tmp1042 to $t0 from $fp-2716
	  lw $t2, 0($t0) 	# load with offset
	  sw $t2, -2728($fp)	# spill _tmp1045 from $t2 to $fp-2728
	# _tmp1046 = _tmp1043 < _tmp1044
	  lw $t0, -2720($fp)	# fill _tmp1043 to $t0 from $fp-2720
	  lw $t1, -2724($fp)	# fill _tmp1044 to $t1 from $fp-2724
	  slt $t2, $t0, $t1	
	  sw $t2, -2732($fp)	# spill _tmp1046 from $t2 to $fp-2732
	# _tmp1047 = _tmp1045 < _tmp1043
	  lw $t0, -2728($fp)	# fill _tmp1045 to $t0 from $fp-2728
	  lw $t1, -2720($fp)	# fill _tmp1043 to $t1 from $fp-2720
	  slt $t2, $t0, $t1	
	  sw $t2, -2736($fp)	# spill _tmp1047 from $t2 to $fp-2736
	# _tmp1048 = _tmp1045 == _tmp1043
	  lw $t0, -2728($fp)	# fill _tmp1045 to $t0 from $fp-2728
	  lw $t1, -2720($fp)	# fill _tmp1043 to $t1 from $fp-2720
	  seq $t2, $t0, $t1	
	  sw $t2, -2740($fp)	# spill _tmp1048 from $t2 to $fp-2740
	# _tmp1049 = _tmp1047 || _tmp1048
	  lw $t0, -2736($fp)	# fill _tmp1047 to $t0 from $fp-2736
	  lw $t1, -2740($fp)	# fill _tmp1048 to $t1 from $fp-2740
	  or $t2, $t0, $t1	
	  sw $t2, -2744($fp)	# spill _tmp1049 from $t2 to $fp-2744
	# _tmp1050 = _tmp1049 || _tmp1046
	  lw $t0, -2744($fp)	# fill _tmp1049 to $t0 from $fp-2744
	  lw $t1, -2732($fp)	# fill _tmp1046 to $t1 from $fp-2732
	  or $t2, $t0, $t1	
	  sw $t2, -2748($fp)	# spill _tmp1050 from $t2 to $fp-2748
	# IfZ _tmp1050 Goto _L104
	  lw $t0, -2748($fp)	# fill _tmp1050 to $t0 from $fp-2748
	  beqz $t0, _L104	# branch if _tmp1050 is zero 
	# _tmp1051 = "Decaf runtime error: Array subscript out of bound..."
	  .data			# create string constant marked with label
	  _string72: .asciiz "Decaf runtime error: Array subscript out of bounds\n"
	  .text
	  la $t2, _string72	# load label
	  sw $t2, -2752($fp)	# spill _tmp1051 from $t2 to $fp-2752
	# PushParam _tmp1051
	  subu $sp, $sp, 4	# decrement sp to make space for param
	  lw $t0, -2752($fp)	# fill _tmp1051 to $t0 from $fp-2752
	  sw $t0, 4($sp)	# copy param value to stack
	# LCall _PrintString
	  jal _PrintString   	# jump to function
	# PopParams 4
	  add $sp, $sp, 4	# pop params off stack
	# LCall _Halt
	  jal _Halt          	# jump to function
  _L104:
	# _tmp1052 = 4
	  li $t2, 4		# load constant value 4 into $t2
	  sw $t2, -2756($fp)	# spill _tmp1052 from $t2 to $fp-2756
	# _tmp1053 = _tmp1043 * _tmp1052
	  lw $t0, -2720($fp)	# fill _tmp1043 to $t0 from $fp-2720
	  lw $t1, -2756($fp)	# fill _tmp1052 to $t1 from $fp-2756
	  mul $t2, $t0, $t1	
	  sw $t2, -2760($fp)	# spill _tmp1053 from $t2 to $fp-2760
	# _tmp1054 = _tmp1053 + _tmp1052
	  lw $t0, -2760($fp)	# fill _tmp1053 to $t0 from $fp-2760
	  lw $t1, -2756($fp)	# fill _tmp1052 to $t1 from $fp-2756
	  add $t2, $t0, $t1	
	  sw $t2, -2764($fp)	# spill _tmp1054 from $t2 to $fp-2764
	# _tmp1055 = _tmp1042 + _tmp1054
	  lw $t0, -2716($fp)	# fill _tmp1042 to $t0 from $fp-2716
	  lw $t1, -2764($fp)	# fill _tmp1054 to $t1 from $fp-2764
	  add $t2, $t0, $t1	
	  sw $t2, -2768($fp)	# spill _tmp1055 from $t2 to $fp-2768
	# _tmp1056 = *(_tmp1055)
	  lw $t0, -2768($fp)	# fill _tmp1055 to $t0 from $fp-2768
	  lw $t2, 0($t0) 	# load with offset
	  sw $t2, -2772($fp)	# spill _tmp1056 from $t2 to $fp-2772
	# PushParam _tmp1056
	  subu $sp, $sp, 4	# decrement sp to make space for param
	  lw $t0, -2772($fp)	# fill _tmp1056 to $t0 from $fp-2772
	  sw $t0, 4($sp)	# copy param value to stack
	# _tmp1057 = *(_tmp1056)
	  lw $t0, -2772($fp)	# fill _tmp1056 to $t0 from $fp-2772
	  lw $t2, 0($t0) 	# load with offset
	  sw $t2, -2776($fp)	# spill _tmp1057 from $t2 to $fp-2776
	# _tmp1058 = *(_tmp1057 + 20)
	  lw $t0, -2776($fp)	# fill _tmp1057 to $t0 from $fp-2776
	  lw $t2, 20($t0) 	# load with offset
	  sw $t2, -2780($fp)	# spill _tmp1058 from $t2 to $fp-2780
	# _tmp1059 = ACall _tmp1058
	  lw $t0, -2780($fp)	# fill _tmp1058 to $t0 from $fp-2780
	  jalr $t0            	# jump to function
	  move $t2, $v0		# copy function return value from $v0
	  sw $t2, -2784($fp)	# spill _tmp1059 from $t2 to $fp-2784
	# PopParams 8
	  add $sp, $sp, 8	# pop params off stack
	# _tmp1060 = _tmp1027 && _tmp1059
	  lw $t0, -2656($fp)	# fill _tmp1027 to $t0 from $fp-2656
	  lw $t1, -2784($fp)	# fill _tmp1059 to $t1 from $fp-2784
	  and $t2, $t0, $t1	
	  sw $t2, -2788($fp)	# spill _tmp1060 from $t2 to $fp-2788
	# IfZ _tmp1060 Goto _L97
	  lw $t0, -2788($fp)	# fill _tmp1060 to $t0 from $fp-2788
	  beqz $t0, _L97	# branch if _tmp1060 is zero 
	# _tmp1061 = 0
	  li $t2, 0		# load constant value 0 into $t2
	  sw $t2, -2792($fp)	# spill _tmp1061 from $t2 to $fp-2792
	# Return _tmp1061
	  lw $t2, -2792($fp)	# fill _tmp1061 to $t2 from $fp-2792
	  move $v0, $t2		# assign return value into $v0
	  move $sp, $fp		# pop callee frame off stack
	  lw $ra, -4($fp)	# restore saved ra
	  lw $fp, 0($fp)	# restore saved fp
	  jr $ra		# return from function
	# Goto _L98
	  b _L98		# unconditional branch
  _L97:
  _L98:
	# PushParam mark
	  subu $sp, $sp, 4	# decrement sp to make space for param
	  lw $t0, -8($fp)	# fill mark to $t0 from $fp-8
	  sw $t0, 4($sp)	# copy param value to stack
	# _tmp1062 = *(this + 4)
	  lw $t0, 4($fp)	# fill this to $t0 from $fp+4
	  lw $t2, 4($t0) 	# load with offset
	  sw $t2, -2796($fp)	# spill _tmp1062 from $t2 to $fp-2796
	# _tmp1063 = 0
	  li $t2, 0		# load constant value 0 into $t2
	  sw $t2, -2800($fp)	# spill _tmp1063 from $t2 to $fp-2800
	# _tmp1064 = 0
	  li $t2, 0		# load constant value 0 into $t2
	  sw $t2, -2804($fp)	# spill _tmp1064 from $t2 to $fp-2804
	# _tmp1065 = *(_tmp1062)
	  lw $t0, -2796($fp)	# fill _tmp1062 to $t0 from $fp-2796
	  lw $t2, 0($t0) 	# load with offset
	  sw $t2, -2808($fp)	# spill _tmp1065 from $t2 to $fp-2808
	# _tmp1066 = _tmp1063 < _tmp1064
	  lw $t0, -2800($fp)	# fill _tmp1063 to $t0 from $fp-2800
	  lw $t1, -2804($fp)	# fill _tmp1064 to $t1 from $fp-2804
	  slt $t2, $t0, $t1	
	  sw $t2, -2812($fp)	# spill _tmp1066 from $t2 to $fp-2812
	# _tmp1067 = _tmp1065 < _tmp1063
	  lw $t0, -2808($fp)	# fill _tmp1065 to $t0 from $fp-2808
	  lw $t1, -2800($fp)	# fill _tmp1063 to $t1 from $fp-2800
	  slt $t2, $t0, $t1	
	  sw $t2, -2816($fp)	# spill _tmp1067 from $t2 to $fp-2816
	# _tmp1068 = _tmp1065 == _tmp1063
	  lw $t0, -2808($fp)	# fill _tmp1065 to $t0 from $fp-2808
	  lw $t1, -2800($fp)	# fill _tmp1063 to $t1 from $fp-2800
	  seq $t2, $t0, $t1	
	  sw $t2, -2820($fp)	# spill _tmp1068 from $t2 to $fp-2820
	# _tmp1069 = _tmp1067 || _tmp1068
	  lw $t0, -2816($fp)	# fill _tmp1067 to $t0 from $fp-2816
	  lw $t1, -2820($fp)	# fill _tmp1068 to $t1 from $fp-2820
	  or $t2, $t0, $t1	
	  sw $t2, -2824($fp)	# spill _tmp1069 from $t2 to $fp-2824
	# _tmp1070 = _tmp1069 || _tmp1066
	  lw $t0, -2824($fp)	# fill _tmp1069 to $t0 from $fp-2824
	  lw $t1, -2812($fp)	# fill _tmp1066 to $t1 from $fp-2812
	  or $t2, $t0, $t1	
	  sw $t2, -2828($fp)	# spill _tmp1070 from $t2 to $fp-2828
	# IfZ _tmp1070 Goto _L107
	  lw $t0, -2828($fp)	# fill _tmp1070 to $t0 from $fp-2828
	  beqz $t0, _L107	# branch if _tmp1070 is zero 
	# _tmp1071 = "Decaf runtime error: Array subscript out of bound..."
	  .data			# create string constant marked with label
	  _string73: .asciiz "Decaf runtime error: Array subscript out of bounds\n"
	  .text
	  la $t2, _string73	# load label
	  sw $t2, -2832($fp)	# spill _tmp1071 from $t2 to $fp-2832
	# PushParam _tmp1071
	  subu $sp, $sp, 4	# decrement sp to make space for param
	  lw $t0, -2832($fp)	# fill _tmp1071 to $t0 from $fp-2832
	  sw $t0, 4($sp)	# copy param value to stack
	# LCall _PrintString
	  jal _PrintString   	# jump to function
	# PopParams 4
	  add $sp, $sp, 4	# pop params off stack
	# LCall _Halt
	  jal _Halt          	# jump to function
  _L107:
	# _tmp1072 = 4
	  li $t2, 4		# load constant value 4 into $t2
	  sw $t2, -2836($fp)	# spill _tmp1072 from $t2 to $fp-2836
	# _tmp1073 = _tmp1063 * _tmp1072
	  lw $t0, -2800($fp)	# fill _tmp1063 to $t0 from $fp-2800
	  lw $t1, -2836($fp)	# fill _tmp1072 to $t1 from $fp-2836
	  mul $t2, $t0, $t1	
	  sw $t2, -2840($fp)	# spill _tmp1073 from $t2 to $fp-2840
	# _tmp1074 = _tmp1073 + _tmp1072
	  lw $t0, -2840($fp)	# fill _tmp1073 to $t0 from $fp-2840
	  lw $t1, -2836($fp)	# fill _tmp1072 to $t1 from $fp-2836
	  add $t2, $t0, $t1	
	  sw $t2, -2844($fp)	# spill _tmp1074 from $t2 to $fp-2844
	# _tmp1075 = _tmp1062 + _tmp1074
	  lw $t0, -2796($fp)	# fill _tmp1062 to $t0 from $fp-2796
	  lw $t1, -2844($fp)	# fill _tmp1074 to $t1 from $fp-2844
	  add $t2, $t0, $t1	
	  sw $t2, -2848($fp)	# spill _tmp1075 from $t2 to $fp-2848
	# _tmp1076 = *(_tmp1075)
	  lw $t0, -2848($fp)	# fill _tmp1075 to $t0 from $fp-2848
	  lw $t2, 0($t0) 	# load with offset
	  sw $t2, -2852($fp)	# spill _tmp1076 from $t2 to $fp-2852
	# _tmp1077 = 2
	  li $t2, 2		# load constant value 2 into $t2
	  sw $t2, -2856($fp)	# spill _tmp1077 from $t2 to $fp-2856
	# _tmp1078 = 0
	  li $t2, 0		# load constant value 0 into $t2
	  sw $t2, -2860($fp)	# spill _tmp1078 from $t2 to $fp-2860
	# _tmp1079 = *(_tmp1076)
	  lw $t0, -2852($fp)	# fill _tmp1076 to $t0 from $fp-2852
	  lw $t2, 0($t0) 	# load with offset
	  sw $t2, -2864($fp)	# spill _tmp1079 from $t2 to $fp-2864
	# _tmp1080 = _tmp1077 < _tmp1078
	  lw $t0, -2856($fp)	# fill _tmp1077 to $t0 from $fp-2856
	  lw $t1, -2860($fp)	# fill _tmp1078 to $t1 from $fp-2860
	  slt $t2, $t0, $t1	
	  sw $t2, -2868($fp)	# spill _tmp1080 from $t2 to $fp-2868
	# _tmp1081 = _tmp1079 < _tmp1077
	  lw $t0, -2864($fp)	# fill _tmp1079 to $t0 from $fp-2864
	  lw $t1, -2856($fp)	# fill _tmp1077 to $t1 from $fp-2856
	  slt $t2, $t0, $t1	
	  sw $t2, -2872($fp)	# spill _tmp1081 from $t2 to $fp-2872
	# _tmp1082 = _tmp1079 == _tmp1077
	  lw $t0, -2864($fp)	# fill _tmp1079 to $t0 from $fp-2864
	  lw $t1, -2856($fp)	# fill _tmp1077 to $t1 from $fp-2856
	  seq $t2, $t0, $t1	
	  sw $t2, -2876($fp)	# spill _tmp1082 from $t2 to $fp-2876
	# _tmp1083 = _tmp1081 || _tmp1082
	  lw $t0, -2872($fp)	# fill _tmp1081 to $t0 from $fp-2872
	  lw $t1, -2876($fp)	# fill _tmp1082 to $t1 from $fp-2876
	  or $t2, $t0, $t1	
	  sw $t2, -2880($fp)	# spill _tmp1083 from $t2 to $fp-2880
	# _tmp1084 = _tmp1083 || _tmp1080
	  lw $t0, -2880($fp)	# fill _tmp1083 to $t0 from $fp-2880
	  lw $t1, -2868($fp)	# fill _tmp1080 to $t1 from $fp-2868
	  or $t2, $t0, $t1	
	  sw $t2, -2884($fp)	# spill _tmp1084 from $t2 to $fp-2884
	# IfZ _tmp1084 Goto _L108
	  lw $t0, -2884($fp)	# fill _tmp1084 to $t0 from $fp-2884
	  beqz $t0, _L108	# branch if _tmp1084 is zero 
	# _tmp1085 = "Decaf runtime error: Array subscript out of bound..."
	  .data			# create string constant marked with label
	  _string74: .asciiz "Decaf runtime error: Array subscript out of bounds\n"
	  .text
	  la $t2, _string74	# load label
	  sw $t2, -2888($fp)	# spill _tmp1085 from $t2 to $fp-2888
	# PushParam _tmp1085
	  subu $sp, $sp, 4	# decrement sp to make space for param
	  lw $t0, -2888($fp)	# fill _tmp1085 to $t0 from $fp-2888
	  sw $t0, 4($sp)	# copy param value to stack
	# LCall _PrintString
	  jal _PrintString   	# jump to function
	# PopParams 4
	  add $sp, $sp, 4	# pop params off stack
	# LCall _Halt
	  jal _Halt          	# jump to function
  _L108:
	# _tmp1086 = 4
	  li $t2, 4		# load constant value 4 into $t2
	  sw $t2, -2892($fp)	# spill _tmp1086 from $t2 to $fp-2892
	# _tmp1087 = _tmp1077 * _tmp1086
	  lw $t0, -2856($fp)	# fill _tmp1077 to $t0 from $fp-2856
	  lw $t1, -2892($fp)	# fill _tmp1086 to $t1 from $fp-2892
	  mul $t2, $t0, $t1	
	  sw $t2, -2896($fp)	# spill _tmp1087 from $t2 to $fp-2896
	# _tmp1088 = _tmp1087 + _tmp1086
	  lw $t0, -2896($fp)	# fill _tmp1087 to $t0 from $fp-2896
	  lw $t1, -2892($fp)	# fill _tmp1086 to $t1 from $fp-2892
	  add $t2, $t0, $t1	
	  sw $t2, -2900($fp)	# spill _tmp1088 from $t2 to $fp-2900
	# _tmp1089 = _tmp1076 + _tmp1088
	  lw $t0, -2852($fp)	# fill _tmp1076 to $t0 from $fp-2852
	  lw $t1, -2900($fp)	# fill _tmp1088 to $t1 from $fp-2900
	  add $t2, $t0, $t1	
	  sw $t2, -2904($fp)	# spill _tmp1089 from $t2 to $fp-2904
	# _tmp1090 = *(_tmp1089)
	  lw $t0, -2904($fp)	# fill _tmp1089 to $t0 from $fp-2904
	  lw $t2, 0($t0) 	# load with offset
	  sw $t2, -2908($fp)	# spill _tmp1090 from $t2 to $fp-2908
	# PushParam _tmp1090
	  subu $sp, $sp, 4	# decrement sp to make space for param
	  lw $t0, -2908($fp)	# fill _tmp1090 to $t0 from $fp-2908
	  sw $t0, 4($sp)	# copy param value to stack
	# _tmp1091 = *(_tmp1090)
	  lw $t0, -2908($fp)	# fill _tmp1090 to $t0 from $fp-2908
	  lw $t2, 0($t0) 	# load with offset
	  sw $t2, -2912($fp)	# spill _tmp1091 from $t2 to $fp-2912
	# _tmp1092 = *(_tmp1091 + 20)
	  lw $t0, -2912($fp)	# fill _tmp1091 to $t0 from $fp-2912
	  lw $t2, 20($t0) 	# load with offset
	  sw $t2, -2916($fp)	# spill _tmp1092 from $t2 to $fp-2916
	# _tmp1093 = ACall _tmp1092
	  lw $t0, -2916($fp)	# fill _tmp1092 to $t0 from $fp-2916
	  jalr $t0            	# jump to function
	  move $t2, $v0		# copy function return value from $v0
	  sw $t2, -2920($fp)	# spill _tmp1093 from $t2 to $fp-2920
	# PopParams 8
	  add $sp, $sp, 8	# pop params off stack
	# PushParam mark
	  subu $sp, $sp, 4	# decrement sp to make space for param
	  lw $t0, -8($fp)	# fill mark to $t0 from $fp-8
	  sw $t0, 4($sp)	# copy param value to stack
	# _tmp1094 = *(this + 4)
	  lw $t0, 4($fp)	# fill this to $t0 from $fp+4
	  lw $t2, 4($t0) 	# load with offset
	  sw $t2, -2924($fp)	# spill _tmp1094 from $t2 to $fp-2924
	# _tmp1095 = 1
	  li $t2, 1		# load constant value 1 into $t2
	  sw $t2, -2928($fp)	# spill _tmp1095 from $t2 to $fp-2928
	# _tmp1096 = 0
	  li $t2, 0		# load constant value 0 into $t2
	  sw $t2, -2932($fp)	# spill _tmp1096 from $t2 to $fp-2932
	# _tmp1097 = *(_tmp1094)
	  lw $t0, -2924($fp)	# fill _tmp1094 to $t0 from $fp-2924
	  lw $t2, 0($t0) 	# load with offset
	  sw $t2, -2936($fp)	# spill _tmp1097 from $t2 to $fp-2936
	# _tmp1098 = _tmp1095 < _tmp1096
	  lw $t0, -2928($fp)	# fill _tmp1095 to $t0 from $fp-2928
	  lw $t1, -2932($fp)	# fill _tmp1096 to $t1 from $fp-2932
	  slt $t2, $t0, $t1	
	  sw $t2, -2940($fp)	# spill _tmp1098 from $t2 to $fp-2940
	# _tmp1099 = _tmp1097 < _tmp1095
	  lw $t0, -2936($fp)	# fill _tmp1097 to $t0 from $fp-2936
	  lw $t1, -2928($fp)	# fill _tmp1095 to $t1 from $fp-2928
	  slt $t2, $t0, $t1	
	  sw $t2, -2944($fp)	# spill _tmp1099 from $t2 to $fp-2944
	# _tmp1100 = _tmp1097 == _tmp1095
	  lw $t0, -2936($fp)	# fill _tmp1097 to $t0 from $fp-2936
	  lw $t1, -2928($fp)	# fill _tmp1095 to $t1 from $fp-2928
	  seq $t2, $t0, $t1	
	  sw $t2, -2948($fp)	# spill _tmp1100 from $t2 to $fp-2948
	# _tmp1101 = _tmp1099 || _tmp1100
	  lw $t0, -2944($fp)	# fill _tmp1099 to $t0 from $fp-2944
	  lw $t1, -2948($fp)	# fill _tmp1100 to $t1 from $fp-2948
	  or $t2, $t0, $t1	
	  sw $t2, -2952($fp)	# spill _tmp1101 from $t2 to $fp-2952
	# _tmp1102 = _tmp1101 || _tmp1098
	  lw $t0, -2952($fp)	# fill _tmp1101 to $t0 from $fp-2952
	  lw $t1, -2940($fp)	# fill _tmp1098 to $t1 from $fp-2940
	  or $t2, $t0, $t1	
	  sw $t2, -2956($fp)	# spill _tmp1102 from $t2 to $fp-2956
	# IfZ _tmp1102 Goto _L109
	  lw $t0, -2956($fp)	# fill _tmp1102 to $t0 from $fp-2956
	  beqz $t0, _L109	# branch if _tmp1102 is zero 
	# _tmp1103 = "Decaf runtime error: Array subscript out of bound..."
	  .data			# create string constant marked with label
	  _string75: .asciiz "Decaf runtime error: Array subscript out of bounds\n"
	  .text
	  la $t2, _string75	# load label
	  sw $t2, -2960($fp)	# spill _tmp1103 from $t2 to $fp-2960
	# PushParam _tmp1103
	  subu $sp, $sp, 4	# decrement sp to make space for param
	  lw $t0, -2960($fp)	# fill _tmp1103 to $t0 from $fp-2960
	  sw $t0, 4($sp)	# copy param value to stack
	# LCall _PrintString
	  jal _PrintString   	# jump to function
	# PopParams 4
	  add $sp, $sp, 4	# pop params off stack
	# LCall _Halt
	  jal _Halt          	# jump to function
  _L109:
	# _tmp1104 = 4
	  li $t2, 4		# load constant value 4 into $t2
	  sw $t2, -2964($fp)	# spill _tmp1104 from $t2 to $fp-2964
	# _tmp1105 = _tmp1095 * _tmp1104
	  lw $t0, -2928($fp)	# fill _tmp1095 to $t0 from $fp-2928
	  lw $t1, -2964($fp)	# fill _tmp1104 to $t1 from $fp-2964
	  mul $t2, $t0, $t1	
	  sw $t2, -2968($fp)	# spill _tmp1105 from $t2 to $fp-2968
	# _tmp1106 = _tmp1105 + _tmp1104
	  lw $t0, -2968($fp)	# fill _tmp1105 to $t0 from $fp-2968
	  lw $t1, -2964($fp)	# fill _tmp1104 to $t1 from $fp-2964
	  add $t2, $t0, $t1	
	  sw $t2, -2972($fp)	# spill _tmp1106 from $t2 to $fp-2972
	# _tmp1107 = _tmp1094 + _tmp1106
	  lw $t0, -2924($fp)	# fill _tmp1094 to $t0 from $fp-2924
	  lw $t1, -2972($fp)	# fill _tmp1106 to $t1 from $fp-2972
	  add $t2, $t0, $t1	
	  sw $t2, -2976($fp)	# spill _tmp1107 from $t2 to $fp-2976
	# _tmp1108 = *(_tmp1107)
	  lw $t0, -2976($fp)	# fill _tmp1107 to $t0 from $fp-2976
	  lw $t2, 0($t0) 	# load with offset
	  sw $t2, -2980($fp)	# spill _tmp1108 from $t2 to $fp-2980
	# _tmp1109 = 1
	  li $t2, 1		# load constant value 1 into $t2
	  sw $t2, -2984($fp)	# spill _tmp1109 from $t2 to $fp-2984
	# _tmp1110 = 0
	  li $t2, 0		# load constant value 0 into $t2
	  sw $t2, -2988($fp)	# spill _tmp1110 from $t2 to $fp-2988
	# _tmp1111 = *(_tmp1108)
	  lw $t0, -2980($fp)	# fill _tmp1108 to $t0 from $fp-2980
	  lw $t2, 0($t0) 	# load with offset
	  sw $t2, -2992($fp)	# spill _tmp1111 from $t2 to $fp-2992
	# _tmp1112 = _tmp1109 < _tmp1110
	  lw $t0, -2984($fp)	# fill _tmp1109 to $t0 from $fp-2984
	  lw $t1, -2988($fp)	# fill _tmp1110 to $t1 from $fp-2988
	  slt $t2, $t0, $t1	
	  sw $t2, -2996($fp)	# spill _tmp1112 from $t2 to $fp-2996
	# _tmp1113 = _tmp1111 < _tmp1109
	  lw $t0, -2992($fp)	# fill _tmp1111 to $t0 from $fp-2992
	  lw $t1, -2984($fp)	# fill _tmp1109 to $t1 from $fp-2984
	  slt $t2, $t0, $t1	
	  sw $t2, -3000($fp)	# spill _tmp1113 from $t2 to $fp-3000
	# _tmp1114 = _tmp1111 == _tmp1109
	  lw $t0, -2992($fp)	# fill _tmp1111 to $t0 from $fp-2992
	  lw $t1, -2984($fp)	# fill _tmp1109 to $t1 from $fp-2984
	  seq $t2, $t0, $t1	
	  sw $t2, -3004($fp)	# spill _tmp1114 from $t2 to $fp-3004
	# _tmp1115 = _tmp1113 || _tmp1114
	  lw $t0, -3000($fp)	# fill _tmp1113 to $t0 from $fp-3000
	  lw $t1, -3004($fp)	# fill _tmp1114 to $t1 from $fp-3004
	  or $t2, $t0, $t1	
	  sw $t2, -3008($fp)	# spill _tmp1115 from $t2 to $fp-3008
	# _tmp1116 = _tmp1115 || _tmp1112
	  lw $t0, -3008($fp)	# fill _tmp1115 to $t0 from $fp-3008
	  lw $t1, -2996($fp)	# fill _tmp1112 to $t1 from $fp-2996
	  or $t2, $t0, $t1	
	  sw $t2, -3012($fp)	# spill _tmp1116 from $t2 to $fp-3012
	# IfZ _tmp1116 Goto _L110
	  lw $t0, -3012($fp)	# fill _tmp1116 to $t0 from $fp-3012
	  beqz $t0, _L110	# branch if _tmp1116 is zero 
	# _tmp1117 = "Decaf runtime error: Array subscript out of bound..."
	  .data			# create string constant marked with label
	  _string76: .asciiz "Decaf runtime error: Array subscript out of bounds\n"
	  .text
	  la $t2, _string76	# load label
	  sw $t2, -3016($fp)	# spill _tmp1117 from $t2 to $fp-3016
	# PushParam _tmp1117
	  subu $sp, $sp, 4	# decrement sp to make space for param
	  lw $t0, -3016($fp)	# fill _tmp1117 to $t0 from $fp-3016
	  sw $t0, 4($sp)	# copy param value to stack
	# LCall _PrintString
	  jal _PrintString   	# jump to function
	# PopParams 4
	  add $sp, $sp, 4	# pop params off stack
	# LCall _Halt
	  jal _Halt          	# jump to function
  _L110:
	# _tmp1118 = 4
	  li $t2, 4		# load constant value 4 into $t2
	  sw $t2, -3020($fp)	# spill _tmp1118 from $t2 to $fp-3020
	# _tmp1119 = _tmp1109 * _tmp1118
	  lw $t0, -2984($fp)	# fill _tmp1109 to $t0 from $fp-2984
	  lw $t1, -3020($fp)	# fill _tmp1118 to $t1 from $fp-3020
	  mul $t2, $t0, $t1	
	  sw $t2, -3024($fp)	# spill _tmp1119 from $t2 to $fp-3024
	# _tmp1120 = _tmp1119 + _tmp1118
	  lw $t0, -3024($fp)	# fill _tmp1119 to $t0 from $fp-3024
	  lw $t1, -3020($fp)	# fill _tmp1118 to $t1 from $fp-3020
	  add $t2, $t0, $t1	
	  sw $t2, -3028($fp)	# spill _tmp1120 from $t2 to $fp-3028
	# _tmp1121 = _tmp1108 + _tmp1120
	  lw $t0, -2980($fp)	# fill _tmp1108 to $t0 from $fp-2980
	  lw $t1, -3028($fp)	# fill _tmp1120 to $t1 from $fp-3028
	  add $t2, $t0, $t1	
	  sw $t2, -3032($fp)	# spill _tmp1121 from $t2 to $fp-3032
	# _tmp1122 = *(_tmp1121)
	  lw $t0, -3032($fp)	# fill _tmp1121 to $t0 from $fp-3032
	  lw $t2, 0($t0) 	# load with offset
	  sw $t2, -3036($fp)	# spill _tmp1122 from $t2 to $fp-3036
	# PushParam _tmp1122
	  subu $sp, $sp, 4	# decrement sp to make space for param
	  lw $t0, -3036($fp)	# fill _tmp1122 to $t0 from $fp-3036
	  sw $t0, 4($sp)	# copy param value to stack
	# _tmp1123 = *(_tmp1122)
	  lw $t0, -3036($fp)	# fill _tmp1122 to $t0 from $fp-3036
	  lw $t2, 0($t0) 	# load with offset
	  sw $t2, -3040($fp)	# spill _tmp1123 from $t2 to $fp-3040
	# _tmp1124 = *(_tmp1123 + 20)
	  lw $t0, -3040($fp)	# fill _tmp1123 to $t0 from $fp-3040
	  lw $t2, 20($t0) 	# load with offset
	  sw $t2, -3044($fp)	# spill _tmp1124 from $t2 to $fp-3044
	# _tmp1125 = ACall _tmp1124
	  lw $t0, -3044($fp)	# fill _tmp1124 to $t0 from $fp-3044
	  jalr $t0            	# jump to function
	  move $t2, $v0		# copy function return value from $v0
	  sw $t2, -3048($fp)	# spill _tmp1125 from $t2 to $fp-3048
	# PopParams 8
	  add $sp, $sp, 8	# pop params off stack
	# _tmp1126 = _tmp1093 && _tmp1125
	  lw $t0, -2920($fp)	# fill _tmp1093 to $t0 from $fp-2920
	  lw $t1, -3048($fp)	# fill _tmp1125 to $t1 from $fp-3048
	  and $t2, $t0, $t1	
	  sw $t2, -3052($fp)	# spill _tmp1126 from $t2 to $fp-3052
	# PushParam mark
	  subu $sp, $sp, 4	# decrement sp to make space for param
	  lw $t0, -8($fp)	# fill mark to $t0 from $fp-8
	  sw $t0, 4($sp)	# copy param value to stack
	# _tmp1127 = *(this + 4)
	  lw $t0, 4($fp)	# fill this to $t0 from $fp+4
	  lw $t2, 4($t0) 	# load with offset
	  sw $t2, -3056($fp)	# spill _tmp1127 from $t2 to $fp-3056
	# _tmp1128 = 2
	  li $t2, 2		# load constant value 2 into $t2
	  sw $t2, -3060($fp)	# spill _tmp1128 from $t2 to $fp-3060
	# _tmp1129 = 0
	  li $t2, 0		# load constant value 0 into $t2
	  sw $t2, -3064($fp)	# spill _tmp1129 from $t2 to $fp-3064
	# _tmp1130 = *(_tmp1127)
	  lw $t0, -3056($fp)	# fill _tmp1127 to $t0 from $fp-3056
	  lw $t2, 0($t0) 	# load with offset
	  sw $t2, -3068($fp)	# spill _tmp1130 from $t2 to $fp-3068
	# _tmp1131 = _tmp1128 < _tmp1129
	  lw $t0, -3060($fp)	# fill _tmp1128 to $t0 from $fp-3060
	  lw $t1, -3064($fp)	# fill _tmp1129 to $t1 from $fp-3064
	  slt $t2, $t0, $t1	
	  sw $t2, -3072($fp)	# spill _tmp1131 from $t2 to $fp-3072
	# _tmp1132 = _tmp1130 < _tmp1128
	  lw $t0, -3068($fp)	# fill _tmp1130 to $t0 from $fp-3068
	  lw $t1, -3060($fp)	# fill _tmp1128 to $t1 from $fp-3060
	  slt $t2, $t0, $t1	
	  sw $t2, -3076($fp)	# spill _tmp1132 from $t2 to $fp-3076
	# _tmp1133 = _tmp1130 == _tmp1128
	  lw $t0, -3068($fp)	# fill _tmp1130 to $t0 from $fp-3068
	  lw $t1, -3060($fp)	# fill _tmp1128 to $t1 from $fp-3060
	  seq $t2, $t0, $t1	
	  sw $t2, -3080($fp)	# spill _tmp1133 from $t2 to $fp-3080
	# _tmp1134 = _tmp1132 || _tmp1133
	  lw $t0, -3076($fp)	# fill _tmp1132 to $t0 from $fp-3076
	  lw $t1, -3080($fp)	# fill _tmp1133 to $t1 from $fp-3080
	  or $t2, $t0, $t1	
	  sw $t2, -3084($fp)	# spill _tmp1134 from $t2 to $fp-3084
	# _tmp1135 = _tmp1134 || _tmp1131
	  lw $t0, -3084($fp)	# fill _tmp1134 to $t0 from $fp-3084
	  lw $t1, -3072($fp)	# fill _tmp1131 to $t1 from $fp-3072
	  or $t2, $t0, $t1	
	  sw $t2, -3088($fp)	# spill _tmp1135 from $t2 to $fp-3088
	# IfZ _tmp1135 Goto _L111
	  lw $t0, -3088($fp)	# fill _tmp1135 to $t0 from $fp-3088
	  beqz $t0, _L111	# branch if _tmp1135 is zero 
	# _tmp1136 = "Decaf runtime error: Array subscript out of bound..."
	  .data			# create string constant marked with label
	  _string77: .asciiz "Decaf runtime error: Array subscript out of bounds\n"
	  .text
	  la $t2, _string77	# load label
	  sw $t2, -3092($fp)	# spill _tmp1136 from $t2 to $fp-3092
	# PushParam _tmp1136
	  subu $sp, $sp, 4	# decrement sp to make space for param
	  lw $t0, -3092($fp)	# fill _tmp1136 to $t0 from $fp-3092
	  sw $t0, 4($sp)	# copy param value to stack
	# LCall _PrintString
	  jal _PrintString   	# jump to function
	# PopParams 4
	  add $sp, $sp, 4	# pop params off stack
	# LCall _Halt
	  jal _Halt          	# jump to function
  _L111:
	# _tmp1137 = 4
	  li $t2, 4		# load constant value 4 into $t2
	  sw $t2, -3096($fp)	# spill _tmp1137 from $t2 to $fp-3096
	# _tmp1138 = _tmp1128 * _tmp1137
	  lw $t0, -3060($fp)	# fill _tmp1128 to $t0 from $fp-3060
	  lw $t1, -3096($fp)	# fill _tmp1137 to $t1 from $fp-3096
	  mul $t2, $t0, $t1	
	  sw $t2, -3100($fp)	# spill _tmp1138 from $t2 to $fp-3100
	# _tmp1139 = _tmp1138 + _tmp1137
	  lw $t0, -3100($fp)	# fill _tmp1138 to $t0 from $fp-3100
	  lw $t1, -3096($fp)	# fill _tmp1137 to $t1 from $fp-3096
	  add $t2, $t0, $t1	
	  sw $t2, -3104($fp)	# spill _tmp1139 from $t2 to $fp-3104
	# _tmp1140 = _tmp1127 + _tmp1139
	  lw $t0, -3056($fp)	# fill _tmp1127 to $t0 from $fp-3056
	  lw $t1, -3104($fp)	# fill _tmp1139 to $t1 from $fp-3104
	  add $t2, $t0, $t1	
	  sw $t2, -3108($fp)	# spill _tmp1140 from $t2 to $fp-3108
	# _tmp1141 = *(_tmp1140)
	  lw $t0, -3108($fp)	# fill _tmp1140 to $t0 from $fp-3108
	  lw $t2, 0($t0) 	# load with offset
	  sw $t2, -3112($fp)	# spill _tmp1141 from $t2 to $fp-3112
	# _tmp1142 = 0
	  li $t2, 0		# load constant value 0 into $t2
	  sw $t2, -3116($fp)	# spill _tmp1142 from $t2 to $fp-3116
	# _tmp1143 = 0
	  li $t2, 0		# load constant value 0 into $t2
	  sw $t2, -3120($fp)	# spill _tmp1143 from $t2 to $fp-3120
	# _tmp1144 = *(_tmp1141)
	  lw $t0, -3112($fp)	# fill _tmp1141 to $t0 from $fp-3112
	  lw $t2, 0($t0) 	# load with offset
	  sw $t2, -3124($fp)	# spill _tmp1144 from $t2 to $fp-3124
	# _tmp1145 = _tmp1142 < _tmp1143
	  lw $t0, -3116($fp)	# fill _tmp1142 to $t0 from $fp-3116
	  lw $t1, -3120($fp)	# fill _tmp1143 to $t1 from $fp-3120
	  slt $t2, $t0, $t1	
	  sw $t2, -3128($fp)	# spill _tmp1145 from $t2 to $fp-3128
	# _tmp1146 = _tmp1144 < _tmp1142
	  lw $t0, -3124($fp)	# fill _tmp1144 to $t0 from $fp-3124
	  lw $t1, -3116($fp)	# fill _tmp1142 to $t1 from $fp-3116
	  slt $t2, $t0, $t1	
	  sw $t2, -3132($fp)	# spill _tmp1146 from $t2 to $fp-3132
	# _tmp1147 = _tmp1144 == _tmp1142
	  lw $t0, -3124($fp)	# fill _tmp1144 to $t0 from $fp-3124
	  lw $t1, -3116($fp)	# fill _tmp1142 to $t1 from $fp-3116
	  seq $t2, $t0, $t1	
	  sw $t2, -3136($fp)	# spill _tmp1147 from $t2 to $fp-3136
	# _tmp1148 = _tmp1146 || _tmp1147
	  lw $t0, -3132($fp)	# fill _tmp1146 to $t0 from $fp-3132
	  lw $t1, -3136($fp)	# fill _tmp1147 to $t1 from $fp-3136
	  or $t2, $t0, $t1	
	  sw $t2, -3140($fp)	# spill _tmp1148 from $t2 to $fp-3140
	# _tmp1149 = _tmp1148 || _tmp1145
	  lw $t0, -3140($fp)	# fill _tmp1148 to $t0 from $fp-3140
	  lw $t1, -3128($fp)	# fill _tmp1145 to $t1 from $fp-3128
	  or $t2, $t0, $t1	
	  sw $t2, -3144($fp)	# spill _tmp1149 from $t2 to $fp-3144
	# IfZ _tmp1149 Goto _L112
	  lw $t0, -3144($fp)	# fill _tmp1149 to $t0 from $fp-3144
	  beqz $t0, _L112	# branch if _tmp1149 is zero 
	# _tmp1150 = "Decaf runtime error: Array subscript out of bound..."
	  .data			# create string constant marked with label
	  _string78: .asciiz "Decaf runtime error: Array subscript out of bounds\n"
	  .text
	  la $t2, _string78	# load label
	  sw $t2, -3148($fp)	# spill _tmp1150 from $t2 to $fp-3148
	# PushParam _tmp1150
	  subu $sp, $sp, 4	# decrement sp to make space for param
	  lw $t0, -3148($fp)	# fill _tmp1150 to $t0 from $fp-3148
	  sw $t0, 4($sp)	# copy param value to stack
	# LCall _PrintString
	  jal _PrintString   	# jump to function
	# PopParams 4
	  add $sp, $sp, 4	# pop params off stack
	# LCall _Halt
	  jal _Halt          	# jump to function
  _L112:
	# _tmp1151 = 4
	  li $t2, 4		# load constant value 4 into $t2
	  sw $t2, -3152($fp)	# spill _tmp1151 from $t2 to $fp-3152
	# _tmp1152 = _tmp1142 * _tmp1151
	  lw $t0, -3116($fp)	# fill _tmp1142 to $t0 from $fp-3116
	  lw $t1, -3152($fp)	# fill _tmp1151 to $t1 from $fp-3152
	  mul $t2, $t0, $t1	
	  sw $t2, -3156($fp)	# spill _tmp1152 from $t2 to $fp-3156
	# _tmp1153 = _tmp1152 + _tmp1151
	  lw $t0, -3156($fp)	# fill _tmp1152 to $t0 from $fp-3156
	  lw $t1, -3152($fp)	# fill _tmp1151 to $t1 from $fp-3152
	  add $t2, $t0, $t1	
	  sw $t2, -3160($fp)	# spill _tmp1153 from $t2 to $fp-3160
	# _tmp1154 = _tmp1141 + _tmp1153
	  lw $t0, -3112($fp)	# fill _tmp1141 to $t0 from $fp-3112
	  lw $t1, -3160($fp)	# fill _tmp1153 to $t1 from $fp-3160
	  add $t2, $t0, $t1	
	  sw $t2, -3164($fp)	# spill _tmp1154 from $t2 to $fp-3164
	# _tmp1155 = *(_tmp1154)
	  lw $t0, -3164($fp)	# fill _tmp1154 to $t0 from $fp-3164
	  lw $t2, 0($t0) 	# load with offset
	  sw $t2, -3168($fp)	# spill _tmp1155 from $t2 to $fp-3168
	# PushParam _tmp1155
	  subu $sp, $sp, 4	# decrement sp to make space for param
	  lw $t0, -3168($fp)	# fill _tmp1155 to $t0 from $fp-3168
	  sw $t0, 4($sp)	# copy param value to stack
	# _tmp1156 = *(_tmp1155)
	  lw $t0, -3168($fp)	# fill _tmp1155 to $t0 from $fp-3168
	  lw $t2, 0($t0) 	# load with offset
	  sw $t2, -3172($fp)	# spill _tmp1156 from $t2 to $fp-3172
	# _tmp1157 = *(_tmp1156 + 20)
	  lw $t0, -3172($fp)	# fill _tmp1156 to $t0 from $fp-3172
	  lw $t2, 20($t0) 	# load with offset
	  sw $t2, -3176($fp)	# spill _tmp1157 from $t2 to $fp-3176
	# _tmp1158 = ACall _tmp1157
	  lw $t0, -3176($fp)	# fill _tmp1157 to $t0 from $fp-3176
	  jalr $t0            	# jump to function
	  move $t2, $v0		# copy function return value from $v0
	  sw $t2, -3180($fp)	# spill _tmp1158 from $t2 to $fp-3180
	# PopParams 8
	  add $sp, $sp, 8	# pop params off stack
	# _tmp1159 = _tmp1126 && _tmp1158
	  lw $t0, -3052($fp)	# fill _tmp1126 to $t0 from $fp-3052
	  lw $t1, -3180($fp)	# fill _tmp1158 to $t1 from $fp-3180
	  and $t2, $t0, $t1	
	  sw $t2, -3184($fp)	# spill _tmp1159 from $t2 to $fp-3184
	# IfZ _tmp1159 Goto _L105
	  lw $t0, -3184($fp)	# fill _tmp1159 to $t0 from $fp-3184
	  beqz $t0, _L105	# branch if _tmp1159 is zero 
	# _tmp1160 = 0
	  li $t2, 0		# load constant value 0 into $t2
	  sw $t2, -3188($fp)	# spill _tmp1160 from $t2 to $fp-3188
	# Return _tmp1160
	  lw $t2, -3188($fp)	# fill _tmp1160 to $t2 from $fp-3188
	  move $v0, $t2		# assign return value into $v0
	  move $sp, $fp		# pop callee frame off stack
	  lw $ra, -4($fp)	# restore saved ra
	  lw $fp, 0($fp)	# restore saved fp
	  jr $ra		# return from function
	# Goto _L106
	  b _L106		# unconditional branch
  _L105:
	# _tmp1161 = 1
	  li $t2, 1		# load constant value 1 into $t2
	  sw $t2, -3192($fp)	# spill _tmp1161 from $t2 to $fp-3192
	# Return _tmp1161
	  lw $t2, -3192($fp)	# fill _tmp1161 to $t2 from $fp-3192
	  move $v0, $t2		# assign return value into $v0
	  move $sp, $fp		# pop callee frame off stack
	  lw $ra, -4($fp)	# restore saved ra
	  lw $fp, 0($fp)	# restore saved fp
	  jr $ra		# return from function
  _L106:
	# EndFunc
	# (below handles reaching end of fn body with no explicit return)
	  move $sp, $fp		# pop callee frame off stack
	  lw $ra, -4($fp)	# restore saved ra
	  lw $fp, 0($fp)	# restore saved fp
	  jr $ra		# return from function
  Grid.____BlockedPlay:
	# BeginFunc 6680
	  subu $sp, $sp, 8	# decrement sp to make space to save ra, fp
	  sw $fp, 8($sp)	# save fp
	  sw $ra, 4($sp)	# save ra
	  addiu $fp, $sp, 8	# set up new fp
	  subu $sp, $sp, 6680	# decrement sp to make space for locals/temps
	# _tmp1162 = 1
	  li $t2, 1		# load constant value 1 into $t2
	  sw $t2, -16($fp)	# spill _tmp1162 from $t2 to $fp-16
	# _tmp1163 = 0
	  li $t2, 0		# load constant value 0 into $t2
	  sw $t2, -20($fp)	# spill _tmp1163 from $t2 to $fp-20
	# _tmp1164 = _tmp1163 - _tmp1162
	  lw $t0, -20($fp)	# fill _tmp1163 to $t0 from $fp-20
	  lw $t1, -16($fp)	# fill _tmp1162 to $t1 from $fp-16
	  sub $t2, $t0, $t1	
	  sw $t2, -24($fp)	# spill _tmp1164 from $t2 to $fp-24
	# row = _tmp1164
	  lw $t2, -24($fp)	# fill _tmp1164 to $t2 from $fp-24
	  sw $t2, -8($fp)	# spill row from $t2 to $fp-8
	# _tmp1165 = 1
	  li $t2, 1		# load constant value 1 into $t2
	  sw $t2, -28($fp)	# spill _tmp1165 from $t2 to $fp-28
	# _tmp1166 = 0
	  li $t2, 0		# load constant value 0 into $t2
	  sw $t2, -32($fp)	# spill _tmp1166 from $t2 to $fp-32
	# _tmp1167 = _tmp1166 - _tmp1165
	  lw $t0, -32($fp)	# fill _tmp1166 to $t0 from $fp-32
	  lw $t1, -28($fp)	# fill _tmp1165 to $t1 from $fp-28
	  sub $t2, $t0, $t1	
	  sw $t2, -36($fp)	# spill _tmp1167 from $t2 to $fp-36
	# column = _tmp1167
	  lw $t2, -36($fp)	# fill _tmp1167 to $t2 from $fp-36
	  sw $t2, -12($fp)	# spill column from $t2 to $fp-12
	# PushParam enemyMark
	  subu $sp, $sp, 4	# decrement sp to make space for param
	  lw $t0, 8($fp)	# fill enemyMark to $t0 from $fp+8
	  sw $t0, 4($sp)	# copy param value to stack
	# _tmp1168 = *(this + 4)
	  lw $t0, 4($fp)	# fill this to $t0 from $fp+4
	  lw $t2, 4($t0) 	# load with offset
	  sw $t2, -40($fp)	# spill _tmp1168 from $t2 to $fp-40
	# _tmp1169 = 0
	  li $t2, 0		# load constant value 0 into $t2
	  sw $t2, -44($fp)	# spill _tmp1169 from $t2 to $fp-44
	# _tmp1170 = 0
	  li $t2, 0		# load constant value 0 into $t2
	  sw $t2, -48($fp)	# spill _tmp1170 from $t2 to $fp-48
	# _tmp1171 = *(_tmp1168)
	  lw $t0, -40($fp)	# fill _tmp1168 to $t0 from $fp-40
	  lw $t2, 0($t0) 	# load with offset
	  sw $t2, -52($fp)	# spill _tmp1171 from $t2 to $fp-52
	# _tmp1172 = _tmp1169 < _tmp1170
	  lw $t0, -44($fp)	# fill _tmp1169 to $t0 from $fp-44
	  lw $t1, -48($fp)	# fill _tmp1170 to $t1 from $fp-48
	  slt $t2, $t0, $t1	
	  sw $t2, -56($fp)	# spill _tmp1172 from $t2 to $fp-56
	# _tmp1173 = _tmp1171 < _tmp1169
	  lw $t0, -52($fp)	# fill _tmp1171 to $t0 from $fp-52
	  lw $t1, -44($fp)	# fill _tmp1169 to $t1 from $fp-44
	  slt $t2, $t0, $t1	
	  sw $t2, -60($fp)	# spill _tmp1173 from $t2 to $fp-60
	# _tmp1174 = _tmp1171 == _tmp1169
	  lw $t0, -52($fp)	# fill _tmp1171 to $t0 from $fp-52
	  lw $t1, -44($fp)	# fill _tmp1169 to $t1 from $fp-44
	  seq $t2, $t0, $t1	
	  sw $t2, -64($fp)	# spill _tmp1174 from $t2 to $fp-64
	# _tmp1175 = _tmp1173 || _tmp1174
	  lw $t0, -60($fp)	# fill _tmp1173 to $t0 from $fp-60
	  lw $t1, -64($fp)	# fill _tmp1174 to $t1 from $fp-64
	  or $t2, $t0, $t1	
	  sw $t2, -68($fp)	# spill _tmp1175 from $t2 to $fp-68
	# _tmp1176 = _tmp1175 || _tmp1172
	  lw $t0, -68($fp)	# fill _tmp1175 to $t0 from $fp-68
	  lw $t1, -56($fp)	# fill _tmp1172 to $t1 from $fp-56
	  or $t2, $t0, $t1	
	  sw $t2, -72($fp)	# spill _tmp1176 from $t2 to $fp-72
	# IfZ _tmp1176 Goto _L115
	  lw $t0, -72($fp)	# fill _tmp1176 to $t0 from $fp-72
	  beqz $t0, _L115	# branch if _tmp1176 is zero 
	# _tmp1177 = "Decaf runtime error: Array subscript out of bound..."
	  .data			# create string constant marked with label
	  _string79: .asciiz "Decaf runtime error: Array subscript out of bounds\n"
	  .text
	  la $t2, _string79	# load label
	  sw $t2, -76($fp)	# spill _tmp1177 from $t2 to $fp-76
	# PushParam _tmp1177
	  subu $sp, $sp, 4	# decrement sp to make space for param
	  lw $t0, -76($fp)	# fill _tmp1177 to $t0 from $fp-76
	  sw $t0, 4($sp)	# copy param value to stack
	# LCall _PrintString
	  jal _PrintString   	# jump to function
	# PopParams 4
	  add $sp, $sp, 4	# pop params off stack
	# LCall _Halt
	  jal _Halt          	# jump to function
  _L115:
	# _tmp1178 = 4
	  li $t2, 4		# load constant value 4 into $t2
	  sw $t2, -80($fp)	# spill _tmp1178 from $t2 to $fp-80
	# _tmp1179 = _tmp1169 * _tmp1178
	  lw $t0, -44($fp)	# fill _tmp1169 to $t0 from $fp-44
	  lw $t1, -80($fp)	# fill _tmp1178 to $t1 from $fp-80
	  mul $t2, $t0, $t1	
	  sw $t2, -84($fp)	# spill _tmp1179 from $t2 to $fp-84
	# _tmp1180 = _tmp1179 + _tmp1178
	  lw $t0, -84($fp)	# fill _tmp1179 to $t0 from $fp-84
	  lw $t1, -80($fp)	# fill _tmp1178 to $t1 from $fp-80
	  add $t2, $t0, $t1	
	  sw $t2, -88($fp)	# spill _tmp1180 from $t2 to $fp-88
	# _tmp1181 = _tmp1168 + _tmp1180
	  lw $t0, -40($fp)	# fill _tmp1168 to $t0 from $fp-40
	  lw $t1, -88($fp)	# fill _tmp1180 to $t1 from $fp-88
	  add $t2, $t0, $t1	
	  sw $t2, -92($fp)	# spill _tmp1181 from $t2 to $fp-92
	# _tmp1182 = *(_tmp1181)
	  lw $t0, -92($fp)	# fill _tmp1181 to $t0 from $fp-92
	  lw $t2, 0($t0) 	# load with offset
	  sw $t2, -96($fp)	# spill _tmp1182 from $t2 to $fp-96
	# _tmp1183 = 0
	  li $t2, 0		# load constant value 0 into $t2
	  sw $t2, -100($fp)	# spill _tmp1183 from $t2 to $fp-100
	# _tmp1184 = 0
	  li $t2, 0		# load constant value 0 into $t2
	  sw $t2, -104($fp)	# spill _tmp1184 from $t2 to $fp-104
	# _tmp1185 = *(_tmp1182)
	  lw $t0, -96($fp)	# fill _tmp1182 to $t0 from $fp-96
	  lw $t2, 0($t0) 	# load with offset
	  sw $t2, -108($fp)	# spill _tmp1185 from $t2 to $fp-108
	# _tmp1186 = _tmp1183 < _tmp1184
	  lw $t0, -100($fp)	# fill _tmp1183 to $t0 from $fp-100
	  lw $t1, -104($fp)	# fill _tmp1184 to $t1 from $fp-104
	  slt $t2, $t0, $t1	
	  sw $t2, -112($fp)	# spill _tmp1186 from $t2 to $fp-112
	# _tmp1187 = _tmp1185 < _tmp1183
	  lw $t0, -108($fp)	# fill _tmp1185 to $t0 from $fp-108
	  lw $t1, -100($fp)	# fill _tmp1183 to $t1 from $fp-100
	  slt $t2, $t0, $t1	
	  sw $t2, -116($fp)	# spill _tmp1187 from $t2 to $fp-116
	# _tmp1188 = _tmp1185 == _tmp1183
	  lw $t0, -108($fp)	# fill _tmp1185 to $t0 from $fp-108
	  lw $t1, -100($fp)	# fill _tmp1183 to $t1 from $fp-100
	  seq $t2, $t0, $t1	
	  sw $t2, -120($fp)	# spill _tmp1188 from $t2 to $fp-120
	# _tmp1189 = _tmp1187 || _tmp1188
	  lw $t0, -116($fp)	# fill _tmp1187 to $t0 from $fp-116
	  lw $t1, -120($fp)	# fill _tmp1188 to $t1 from $fp-120
	  or $t2, $t0, $t1	
	  sw $t2, -124($fp)	# spill _tmp1189 from $t2 to $fp-124
	# _tmp1190 = _tmp1189 || _tmp1186
	  lw $t0, -124($fp)	# fill _tmp1189 to $t0 from $fp-124
	  lw $t1, -112($fp)	# fill _tmp1186 to $t1 from $fp-112
	  or $t2, $t0, $t1	
	  sw $t2, -128($fp)	# spill _tmp1190 from $t2 to $fp-128
	# IfZ _tmp1190 Goto _L116
	  lw $t0, -128($fp)	# fill _tmp1190 to $t0 from $fp-128
	  beqz $t0, _L116	# branch if _tmp1190 is zero 
	# _tmp1191 = "Decaf runtime error: Array subscript out of bound..."
	  .data			# create string constant marked with label
	  _string80: .asciiz "Decaf runtime error: Array subscript out of bounds\n"
	  .text
	  la $t2, _string80	# load label
	  sw $t2, -132($fp)	# spill _tmp1191 from $t2 to $fp-132
	# PushParam _tmp1191
	  subu $sp, $sp, 4	# decrement sp to make space for param
	  lw $t0, -132($fp)	# fill _tmp1191 to $t0 from $fp-132
	  sw $t0, 4($sp)	# copy param value to stack
	# LCall _PrintString
	  jal _PrintString   	# jump to function
	# PopParams 4
	  add $sp, $sp, 4	# pop params off stack
	# LCall _Halt
	  jal _Halt          	# jump to function
  _L116:
	# _tmp1192 = 4
	  li $t2, 4		# load constant value 4 into $t2
	  sw $t2, -136($fp)	# spill _tmp1192 from $t2 to $fp-136
	# _tmp1193 = _tmp1183 * _tmp1192
	  lw $t0, -100($fp)	# fill _tmp1183 to $t0 from $fp-100
	  lw $t1, -136($fp)	# fill _tmp1192 to $t1 from $fp-136
	  mul $t2, $t0, $t1	
	  sw $t2, -140($fp)	# spill _tmp1193 from $t2 to $fp-140
	# _tmp1194 = _tmp1193 + _tmp1192
	  lw $t0, -140($fp)	# fill _tmp1193 to $t0 from $fp-140
	  lw $t1, -136($fp)	# fill _tmp1192 to $t1 from $fp-136
	  add $t2, $t0, $t1	
	  sw $t2, -144($fp)	# spill _tmp1194 from $t2 to $fp-144
	# _tmp1195 = _tmp1182 + _tmp1194
	  lw $t0, -96($fp)	# fill _tmp1182 to $t0 from $fp-96
	  lw $t1, -144($fp)	# fill _tmp1194 to $t1 from $fp-144
	  add $t2, $t0, $t1	
	  sw $t2, -148($fp)	# spill _tmp1195 from $t2 to $fp-148
	# _tmp1196 = *(_tmp1195)
	  lw $t0, -148($fp)	# fill _tmp1195 to $t0 from $fp-148
	  lw $t2, 0($t0) 	# load with offset
	  sw $t2, -152($fp)	# spill _tmp1196 from $t2 to $fp-152
	# PushParam _tmp1196
	  subu $sp, $sp, 4	# decrement sp to make space for param
	  lw $t0, -152($fp)	# fill _tmp1196 to $t0 from $fp-152
	  sw $t0, 4($sp)	# copy param value to stack
	# _tmp1197 = *(_tmp1196)
	  lw $t0, -152($fp)	# fill _tmp1196 to $t0 from $fp-152
	  lw $t2, 0($t0) 	# load with offset
	  sw $t2, -156($fp)	# spill _tmp1197 from $t2 to $fp-156
	# _tmp1198 = *(_tmp1197 + 20)
	  lw $t0, -156($fp)	# fill _tmp1197 to $t0 from $fp-156
	  lw $t2, 20($t0) 	# load with offset
	  sw $t2, -160($fp)	# spill _tmp1198 from $t2 to $fp-160
	# _tmp1199 = ACall _tmp1198
	  lw $t0, -160($fp)	# fill _tmp1198 to $t0 from $fp-160
	  jalr $t0            	# jump to function
	  move $t2, $v0		# copy function return value from $v0
	  sw $t2, -164($fp)	# spill _tmp1199 from $t2 to $fp-164
	# PopParams 8
	  add $sp, $sp, 8	# pop params off stack
	# PushParam enemyMark
	  subu $sp, $sp, 4	# decrement sp to make space for param
	  lw $t0, 8($fp)	# fill enemyMark to $t0 from $fp+8
	  sw $t0, 4($sp)	# copy param value to stack
	# _tmp1200 = *(this + 4)
	  lw $t0, 4($fp)	# fill this to $t0 from $fp+4
	  lw $t2, 4($t0) 	# load with offset
	  sw $t2, -168($fp)	# spill _tmp1200 from $t2 to $fp-168
	# _tmp1201 = 0
	  li $t2, 0		# load constant value 0 into $t2
	  sw $t2, -172($fp)	# spill _tmp1201 from $t2 to $fp-172
	# _tmp1202 = 0
	  li $t2, 0		# load constant value 0 into $t2
	  sw $t2, -176($fp)	# spill _tmp1202 from $t2 to $fp-176
	# _tmp1203 = *(_tmp1200)
	  lw $t0, -168($fp)	# fill _tmp1200 to $t0 from $fp-168
	  lw $t2, 0($t0) 	# load with offset
	  sw $t2, -180($fp)	# spill _tmp1203 from $t2 to $fp-180
	# _tmp1204 = _tmp1201 < _tmp1202
	  lw $t0, -172($fp)	# fill _tmp1201 to $t0 from $fp-172
	  lw $t1, -176($fp)	# fill _tmp1202 to $t1 from $fp-176
	  slt $t2, $t0, $t1	
	  sw $t2, -184($fp)	# spill _tmp1204 from $t2 to $fp-184
	# _tmp1205 = _tmp1203 < _tmp1201
	  lw $t0, -180($fp)	# fill _tmp1203 to $t0 from $fp-180
	  lw $t1, -172($fp)	# fill _tmp1201 to $t1 from $fp-172
	  slt $t2, $t0, $t1	
	  sw $t2, -188($fp)	# spill _tmp1205 from $t2 to $fp-188
	# _tmp1206 = _tmp1203 == _tmp1201
	  lw $t0, -180($fp)	# fill _tmp1203 to $t0 from $fp-180
	  lw $t1, -172($fp)	# fill _tmp1201 to $t1 from $fp-172
	  seq $t2, $t0, $t1	
	  sw $t2, -192($fp)	# spill _tmp1206 from $t2 to $fp-192
	# _tmp1207 = _tmp1205 || _tmp1206
	  lw $t0, -188($fp)	# fill _tmp1205 to $t0 from $fp-188
	  lw $t1, -192($fp)	# fill _tmp1206 to $t1 from $fp-192
	  or $t2, $t0, $t1	
	  sw $t2, -196($fp)	# spill _tmp1207 from $t2 to $fp-196
	# _tmp1208 = _tmp1207 || _tmp1204
	  lw $t0, -196($fp)	# fill _tmp1207 to $t0 from $fp-196
	  lw $t1, -184($fp)	# fill _tmp1204 to $t1 from $fp-184
	  or $t2, $t0, $t1	
	  sw $t2, -200($fp)	# spill _tmp1208 from $t2 to $fp-200
	# IfZ _tmp1208 Goto _L117
	  lw $t0, -200($fp)	# fill _tmp1208 to $t0 from $fp-200
	  beqz $t0, _L117	# branch if _tmp1208 is zero 
	# _tmp1209 = "Decaf runtime error: Array subscript out of bound..."
	  .data			# create string constant marked with label
	  _string81: .asciiz "Decaf runtime error: Array subscript out of bounds\n"
	  .text
	  la $t2, _string81	# load label
	  sw $t2, -204($fp)	# spill _tmp1209 from $t2 to $fp-204
	# PushParam _tmp1209
	  subu $sp, $sp, 4	# decrement sp to make space for param
	  lw $t0, -204($fp)	# fill _tmp1209 to $t0 from $fp-204
	  sw $t0, 4($sp)	# copy param value to stack
	# LCall _PrintString
	  jal _PrintString   	# jump to function
	# PopParams 4
	  add $sp, $sp, 4	# pop params off stack
	# LCall _Halt
	  jal _Halt          	# jump to function
  _L117:
	# _tmp1210 = 4
	  li $t2, 4		# load constant value 4 into $t2
	  sw $t2, -208($fp)	# spill _tmp1210 from $t2 to $fp-208
	# _tmp1211 = _tmp1201 * _tmp1210
	  lw $t0, -172($fp)	# fill _tmp1201 to $t0 from $fp-172
	  lw $t1, -208($fp)	# fill _tmp1210 to $t1 from $fp-208
	  mul $t2, $t0, $t1	
	  sw $t2, -212($fp)	# spill _tmp1211 from $t2 to $fp-212
	# _tmp1212 = _tmp1211 + _tmp1210
	  lw $t0, -212($fp)	# fill _tmp1211 to $t0 from $fp-212
	  lw $t1, -208($fp)	# fill _tmp1210 to $t1 from $fp-208
	  add $t2, $t0, $t1	
	  sw $t2, -216($fp)	# spill _tmp1212 from $t2 to $fp-216
	# _tmp1213 = _tmp1200 + _tmp1212
	  lw $t0, -168($fp)	# fill _tmp1200 to $t0 from $fp-168
	  lw $t1, -216($fp)	# fill _tmp1212 to $t1 from $fp-216
	  add $t2, $t0, $t1	
	  sw $t2, -220($fp)	# spill _tmp1213 from $t2 to $fp-220
	# _tmp1214 = *(_tmp1213)
	  lw $t0, -220($fp)	# fill _tmp1213 to $t0 from $fp-220
	  lw $t2, 0($t0) 	# load with offset
	  sw $t2, -224($fp)	# spill _tmp1214 from $t2 to $fp-224
	# _tmp1215 = 1
	  li $t2, 1		# load constant value 1 into $t2
	  sw $t2, -228($fp)	# spill _tmp1215 from $t2 to $fp-228
	# _tmp1216 = 0
	  li $t2, 0		# load constant value 0 into $t2
	  sw $t2, -232($fp)	# spill _tmp1216 from $t2 to $fp-232
	# _tmp1217 = *(_tmp1214)
	  lw $t0, -224($fp)	# fill _tmp1214 to $t0 from $fp-224
	  lw $t2, 0($t0) 	# load with offset
	  sw $t2, -236($fp)	# spill _tmp1217 from $t2 to $fp-236
	# _tmp1218 = _tmp1215 < _tmp1216
	  lw $t0, -228($fp)	# fill _tmp1215 to $t0 from $fp-228
	  lw $t1, -232($fp)	# fill _tmp1216 to $t1 from $fp-232
	  slt $t2, $t0, $t1	
	  sw $t2, -240($fp)	# spill _tmp1218 from $t2 to $fp-240
	# _tmp1219 = _tmp1217 < _tmp1215
	  lw $t0, -236($fp)	# fill _tmp1217 to $t0 from $fp-236
	  lw $t1, -228($fp)	# fill _tmp1215 to $t1 from $fp-228
	  slt $t2, $t0, $t1	
	  sw $t2, -244($fp)	# spill _tmp1219 from $t2 to $fp-244
	# _tmp1220 = _tmp1217 == _tmp1215
	  lw $t0, -236($fp)	# fill _tmp1217 to $t0 from $fp-236
	  lw $t1, -228($fp)	# fill _tmp1215 to $t1 from $fp-228
	  seq $t2, $t0, $t1	
	  sw $t2, -248($fp)	# spill _tmp1220 from $t2 to $fp-248
	# _tmp1221 = _tmp1219 || _tmp1220
	  lw $t0, -244($fp)	# fill _tmp1219 to $t0 from $fp-244
	  lw $t1, -248($fp)	# fill _tmp1220 to $t1 from $fp-248
	  or $t2, $t0, $t1	
	  sw $t2, -252($fp)	# spill _tmp1221 from $t2 to $fp-252
	# _tmp1222 = _tmp1221 || _tmp1218
	  lw $t0, -252($fp)	# fill _tmp1221 to $t0 from $fp-252
	  lw $t1, -240($fp)	# fill _tmp1218 to $t1 from $fp-240
	  or $t2, $t0, $t1	
	  sw $t2, -256($fp)	# spill _tmp1222 from $t2 to $fp-256
	# IfZ _tmp1222 Goto _L118
	  lw $t0, -256($fp)	# fill _tmp1222 to $t0 from $fp-256
	  beqz $t0, _L118	# branch if _tmp1222 is zero 
	# _tmp1223 = "Decaf runtime error: Array subscript out of bound..."
	  .data			# create string constant marked with label
	  _string82: .asciiz "Decaf runtime error: Array subscript out of bounds\n"
	  .text
	  la $t2, _string82	# load label
	  sw $t2, -260($fp)	# spill _tmp1223 from $t2 to $fp-260
	# PushParam _tmp1223
	  subu $sp, $sp, 4	# decrement sp to make space for param
	  lw $t0, -260($fp)	# fill _tmp1223 to $t0 from $fp-260
	  sw $t0, 4($sp)	# copy param value to stack
	# LCall _PrintString
	  jal _PrintString   	# jump to function
	# PopParams 4
	  add $sp, $sp, 4	# pop params off stack
	# LCall _Halt
	  jal _Halt          	# jump to function
  _L118:
	# _tmp1224 = 4
	  li $t2, 4		# load constant value 4 into $t2
	  sw $t2, -264($fp)	# spill _tmp1224 from $t2 to $fp-264
	# _tmp1225 = _tmp1215 * _tmp1224
	  lw $t0, -228($fp)	# fill _tmp1215 to $t0 from $fp-228
	  lw $t1, -264($fp)	# fill _tmp1224 to $t1 from $fp-264
	  mul $t2, $t0, $t1	
	  sw $t2, -268($fp)	# spill _tmp1225 from $t2 to $fp-268
	# _tmp1226 = _tmp1225 + _tmp1224
	  lw $t0, -268($fp)	# fill _tmp1225 to $t0 from $fp-268
	  lw $t1, -264($fp)	# fill _tmp1224 to $t1 from $fp-264
	  add $t2, $t0, $t1	
	  sw $t2, -272($fp)	# spill _tmp1226 from $t2 to $fp-272
	# _tmp1227 = _tmp1214 + _tmp1226
	  lw $t0, -224($fp)	# fill _tmp1214 to $t0 from $fp-224
	  lw $t1, -272($fp)	# fill _tmp1226 to $t1 from $fp-272
	  add $t2, $t0, $t1	
	  sw $t2, -276($fp)	# spill _tmp1227 from $t2 to $fp-276
	# _tmp1228 = *(_tmp1227)
	  lw $t0, -276($fp)	# fill _tmp1227 to $t0 from $fp-276
	  lw $t2, 0($t0) 	# load with offset
	  sw $t2, -280($fp)	# spill _tmp1228 from $t2 to $fp-280
	# PushParam _tmp1228
	  subu $sp, $sp, 4	# decrement sp to make space for param
	  lw $t0, -280($fp)	# fill _tmp1228 to $t0 from $fp-280
	  sw $t0, 4($sp)	# copy param value to stack
	# _tmp1229 = *(_tmp1228)
	  lw $t0, -280($fp)	# fill _tmp1228 to $t0 from $fp-280
	  lw $t2, 0($t0) 	# load with offset
	  sw $t2, -284($fp)	# spill _tmp1229 from $t2 to $fp-284
	# _tmp1230 = *(_tmp1229 + 20)
	  lw $t0, -284($fp)	# fill _tmp1229 to $t0 from $fp-284
	  lw $t2, 20($t0) 	# load with offset
	  sw $t2, -288($fp)	# spill _tmp1230 from $t2 to $fp-288
	# _tmp1231 = ACall _tmp1230
	  lw $t0, -288($fp)	# fill _tmp1230 to $t0 from $fp-288
	  jalr $t0            	# jump to function
	  move $t2, $v0		# copy function return value from $v0
	  sw $t2, -292($fp)	# spill _tmp1231 from $t2 to $fp-292
	# PopParams 8
	  add $sp, $sp, 8	# pop params off stack
	# _tmp1232 = _tmp1199 && _tmp1231
	  lw $t0, -164($fp)	# fill _tmp1199 to $t0 from $fp-164
	  lw $t1, -292($fp)	# fill _tmp1231 to $t1 from $fp-292
	  and $t2, $t0, $t1	
	  sw $t2, -296($fp)	# spill _tmp1232 from $t2 to $fp-296
	# PushParam playerMark
	  subu $sp, $sp, 4	# decrement sp to make space for param
	  lw $t0, 12($fp)	# fill playerMark to $t0 from $fp+12
	  sw $t0, 4($sp)	# copy param value to stack
	# _tmp1234 = *(this + 4)
	  lw $t0, 4($fp)	# fill this to $t0 from $fp+4
	  lw $t2, 4($t0) 	# load with offset
	  sw $t2, -304($fp)	# spill _tmp1234 from $t2 to $fp-304
	# _tmp1235 = 0
	  li $t2, 0		# load constant value 0 into $t2
	  sw $t2, -308($fp)	# spill _tmp1235 from $t2 to $fp-308
	# _tmp1236 = 0
	  li $t2, 0		# load constant value 0 into $t2
	  sw $t2, -312($fp)	# spill _tmp1236 from $t2 to $fp-312
	# _tmp1237 = *(_tmp1234)
	  lw $t0, -304($fp)	# fill _tmp1234 to $t0 from $fp-304
	  lw $t2, 0($t0) 	# load with offset
	  sw $t2, -316($fp)	# spill _tmp1237 from $t2 to $fp-316
	# _tmp1238 = _tmp1235 < _tmp1236
	  lw $t0, -308($fp)	# fill _tmp1235 to $t0 from $fp-308
	  lw $t1, -312($fp)	# fill _tmp1236 to $t1 from $fp-312
	  slt $t2, $t0, $t1	
	  sw $t2, -320($fp)	# spill _tmp1238 from $t2 to $fp-320
	# _tmp1239 = _tmp1237 < _tmp1235
	  lw $t0, -316($fp)	# fill _tmp1237 to $t0 from $fp-316
	  lw $t1, -308($fp)	# fill _tmp1235 to $t1 from $fp-308
	  slt $t2, $t0, $t1	
	  sw $t2, -324($fp)	# spill _tmp1239 from $t2 to $fp-324
	# _tmp1240 = _tmp1237 == _tmp1235
	  lw $t0, -316($fp)	# fill _tmp1237 to $t0 from $fp-316
	  lw $t1, -308($fp)	# fill _tmp1235 to $t1 from $fp-308
	  seq $t2, $t0, $t1	
	  sw $t2, -328($fp)	# spill _tmp1240 from $t2 to $fp-328
	# _tmp1241 = _tmp1239 || _tmp1240
	  lw $t0, -324($fp)	# fill _tmp1239 to $t0 from $fp-324
	  lw $t1, -328($fp)	# fill _tmp1240 to $t1 from $fp-328
	  or $t2, $t0, $t1	
	  sw $t2, -332($fp)	# spill _tmp1241 from $t2 to $fp-332
	# _tmp1242 = _tmp1241 || _tmp1238
	  lw $t0, -332($fp)	# fill _tmp1241 to $t0 from $fp-332
	  lw $t1, -320($fp)	# fill _tmp1238 to $t1 from $fp-320
	  or $t2, $t0, $t1	
	  sw $t2, -336($fp)	# spill _tmp1242 from $t2 to $fp-336
	# IfZ _tmp1242 Goto _L121
	  lw $t0, -336($fp)	# fill _tmp1242 to $t0 from $fp-336
	  beqz $t0, _L121	# branch if _tmp1242 is zero 
	# _tmp1243 = "Decaf runtime error: Array subscript out of bound..."
	  .data			# create string constant marked with label
	  _string83: .asciiz "Decaf runtime error: Array subscript out of bounds\n"
	  .text
	  la $t2, _string83	# load label
	  sw $t2, -340($fp)	# spill _tmp1243 from $t2 to $fp-340
	# PushParam _tmp1243
	  subu $sp, $sp, 4	# decrement sp to make space for param
	  lw $t0, -340($fp)	# fill _tmp1243 to $t0 from $fp-340
	  sw $t0, 4($sp)	# copy param value to stack
	# LCall _PrintString
	  jal _PrintString   	# jump to function
	# PopParams 4
	  add $sp, $sp, 4	# pop params off stack
	# LCall _Halt
	  jal _Halt          	# jump to function
  _L121:
	# _tmp1244 = 4
	  li $t2, 4		# load constant value 4 into $t2
	  sw $t2, -344($fp)	# spill _tmp1244 from $t2 to $fp-344
	# _tmp1245 = _tmp1235 * _tmp1244
	  lw $t0, -308($fp)	# fill _tmp1235 to $t0 from $fp-308
	  lw $t1, -344($fp)	# fill _tmp1244 to $t1 from $fp-344
	  mul $t2, $t0, $t1	
	  sw $t2, -348($fp)	# spill _tmp1245 from $t2 to $fp-348
	# _tmp1246 = _tmp1245 + _tmp1244
	  lw $t0, -348($fp)	# fill _tmp1245 to $t0 from $fp-348
	  lw $t1, -344($fp)	# fill _tmp1244 to $t1 from $fp-344
	  add $t2, $t0, $t1	
	  sw $t2, -352($fp)	# spill _tmp1246 from $t2 to $fp-352
	# _tmp1247 = _tmp1234 + _tmp1246
	  lw $t0, -304($fp)	# fill _tmp1234 to $t0 from $fp-304
	  lw $t1, -352($fp)	# fill _tmp1246 to $t1 from $fp-352
	  add $t2, $t0, $t1	
	  sw $t2, -356($fp)	# spill _tmp1247 from $t2 to $fp-356
	# _tmp1248 = *(_tmp1247)
	  lw $t0, -356($fp)	# fill _tmp1247 to $t0 from $fp-356
	  lw $t2, 0($t0) 	# load with offset
	  sw $t2, -360($fp)	# spill _tmp1248 from $t2 to $fp-360
	# _tmp1249 = 2
	  li $t2, 2		# load constant value 2 into $t2
	  sw $t2, -364($fp)	# spill _tmp1249 from $t2 to $fp-364
	# _tmp1250 = 0
	  li $t2, 0		# load constant value 0 into $t2
	  sw $t2, -368($fp)	# spill _tmp1250 from $t2 to $fp-368
	# _tmp1251 = *(_tmp1248)
	  lw $t0, -360($fp)	# fill _tmp1248 to $t0 from $fp-360
	  lw $t2, 0($t0) 	# load with offset
	  sw $t2, -372($fp)	# spill _tmp1251 from $t2 to $fp-372
	# _tmp1252 = _tmp1249 < _tmp1250
	  lw $t0, -364($fp)	# fill _tmp1249 to $t0 from $fp-364
	  lw $t1, -368($fp)	# fill _tmp1250 to $t1 from $fp-368
	  slt $t2, $t0, $t1	
	  sw $t2, -376($fp)	# spill _tmp1252 from $t2 to $fp-376
	# _tmp1253 = _tmp1251 < _tmp1249
	  lw $t0, -372($fp)	# fill _tmp1251 to $t0 from $fp-372
	  lw $t1, -364($fp)	# fill _tmp1249 to $t1 from $fp-364
	  slt $t2, $t0, $t1	
	  sw $t2, -380($fp)	# spill _tmp1253 from $t2 to $fp-380
	# _tmp1254 = _tmp1251 == _tmp1249
	  lw $t0, -372($fp)	# fill _tmp1251 to $t0 from $fp-372
	  lw $t1, -364($fp)	# fill _tmp1249 to $t1 from $fp-364
	  seq $t2, $t0, $t1	
	  sw $t2, -384($fp)	# spill _tmp1254 from $t2 to $fp-384
	# _tmp1255 = _tmp1253 || _tmp1254
	  lw $t0, -380($fp)	# fill _tmp1253 to $t0 from $fp-380
	  lw $t1, -384($fp)	# fill _tmp1254 to $t1 from $fp-384
	  or $t2, $t0, $t1	
	  sw $t2, -388($fp)	# spill _tmp1255 from $t2 to $fp-388
	# _tmp1256 = _tmp1255 || _tmp1252
	  lw $t0, -388($fp)	# fill _tmp1255 to $t0 from $fp-388
	  lw $t1, -376($fp)	# fill _tmp1252 to $t1 from $fp-376
	  or $t2, $t0, $t1	
	  sw $t2, -392($fp)	# spill _tmp1256 from $t2 to $fp-392
	# IfZ _tmp1256 Goto _L122
	  lw $t0, -392($fp)	# fill _tmp1256 to $t0 from $fp-392
	  beqz $t0, _L122	# branch if _tmp1256 is zero 
	# _tmp1257 = "Decaf runtime error: Array subscript out of bound..."
	  .data			# create string constant marked with label
	  _string84: .asciiz "Decaf runtime error: Array subscript out of bounds\n"
	  .text
	  la $t2, _string84	# load label
	  sw $t2, -396($fp)	# spill _tmp1257 from $t2 to $fp-396
	# PushParam _tmp1257
	  subu $sp, $sp, 4	# decrement sp to make space for param
	  lw $t0, -396($fp)	# fill _tmp1257 to $t0 from $fp-396
	  sw $t0, 4($sp)	# copy param value to stack
	# LCall _PrintString
	  jal _PrintString   	# jump to function
	# PopParams 4
	  add $sp, $sp, 4	# pop params off stack
	# LCall _Halt
	  jal _Halt          	# jump to function
  _L122:
	# _tmp1258 = 4
	  li $t2, 4		# load constant value 4 into $t2
	  sw $t2, -400($fp)	# spill _tmp1258 from $t2 to $fp-400
	# _tmp1259 = _tmp1249 * _tmp1258
	  lw $t0, -364($fp)	# fill _tmp1249 to $t0 from $fp-364
	  lw $t1, -400($fp)	# fill _tmp1258 to $t1 from $fp-400
	  mul $t2, $t0, $t1	
	  sw $t2, -404($fp)	# spill _tmp1259 from $t2 to $fp-404
	# _tmp1260 = _tmp1259 + _tmp1258
	  lw $t0, -404($fp)	# fill _tmp1259 to $t0 from $fp-404
	  lw $t1, -400($fp)	# fill _tmp1258 to $t1 from $fp-400
	  add $t2, $t0, $t1	
	  sw $t2, -408($fp)	# spill _tmp1260 from $t2 to $fp-408
	# _tmp1261 = _tmp1248 + _tmp1260
	  lw $t0, -360($fp)	# fill _tmp1248 to $t0 from $fp-360
	  lw $t1, -408($fp)	# fill _tmp1260 to $t1 from $fp-408
	  add $t2, $t0, $t1	
	  sw $t2, -412($fp)	# spill _tmp1261 from $t2 to $fp-412
	# _tmp1262 = *(_tmp1261)
	  lw $t0, -412($fp)	# fill _tmp1261 to $t0 from $fp-412
	  lw $t2, 0($t0) 	# load with offset
	  sw $t2, -416($fp)	# spill _tmp1262 from $t2 to $fp-416
	# PushParam _tmp1262
	  subu $sp, $sp, 4	# decrement sp to make space for param
	  lw $t0, -416($fp)	# fill _tmp1262 to $t0 from $fp-416
	  sw $t0, 4($sp)	# copy param value to stack
	# _tmp1263 = *(_tmp1262)
	  lw $t0, -416($fp)	# fill _tmp1262 to $t0 from $fp-416
	  lw $t2, 0($t0) 	# load with offset
	  sw $t2, -420($fp)	# spill _tmp1263 from $t2 to $fp-420
	# _tmp1264 = *(_tmp1263 + 20)
	  lw $t0, -420($fp)	# fill _tmp1263 to $t0 from $fp-420
	  lw $t2, 20($t0) 	# load with offset
	  sw $t2, -424($fp)	# spill _tmp1264 from $t2 to $fp-424
	# _tmp1265 = ACall _tmp1264
	  lw $t0, -424($fp)	# fill _tmp1264 to $t0 from $fp-424
	  jalr $t0            	# jump to function
	  move $t2, $v0		# copy function return value from $v0
	  sw $t2, -428($fp)	# spill _tmp1265 from $t2 to $fp-428
	# PopParams 8
	  add $sp, $sp, 8	# pop params off stack
	# IfZ _tmp1265 Goto _L120
	  lw $t0, -428($fp)	# fill _tmp1265 to $t0 from $fp-428
	  beqz $t0, _L120	# branch if _tmp1265 is zero 
	# _tmp1266 = 0
	  li $t2, 0		# load constant value 0 into $t2
	  sw $t2, -432($fp)	# spill _tmp1266 from $t2 to $fp-432
	# _tmp1233 = _tmp1266
	  lw $t2, -432($fp)	# fill _tmp1266 to $t2 from $fp-432
	  sw $t2, -300($fp)	# spill _tmp1233 from $t2 to $fp-300
	# Goto _L119
	  b _L119		# unconditional branch
  _L120:
	# _tmp1267 = 1
	  li $t2, 1		# load constant value 1 into $t2
	  sw $t2, -436($fp)	# spill _tmp1267 from $t2 to $fp-436
	# _tmp1233 = _tmp1267
	  lw $t2, -436($fp)	# fill _tmp1267 to $t2 from $fp-436
	  sw $t2, -300($fp)	# spill _tmp1233 from $t2 to $fp-300
  _L119:
	# _tmp1268 = _tmp1232 && _tmp1233
	  lw $t0, -296($fp)	# fill _tmp1232 to $t0 from $fp-296
	  lw $t1, -300($fp)	# fill _tmp1233 to $t1 from $fp-300
	  and $t2, $t0, $t1	
	  sw $t2, -440($fp)	# spill _tmp1268 from $t2 to $fp-440
	# IfZ _tmp1268 Goto _L113
	  lw $t0, -440($fp)	# fill _tmp1268 to $t0 from $fp-440
	  beqz $t0, _L113	# branch if _tmp1268 is zero 
	# _tmp1269 = 0
	  li $t2, 0		# load constant value 0 into $t2
	  sw $t2, -444($fp)	# spill _tmp1269 from $t2 to $fp-444
	# row = _tmp1269
	  lw $t2, -444($fp)	# fill _tmp1269 to $t2 from $fp-444
	  sw $t2, -8($fp)	# spill row from $t2 to $fp-8
	# _tmp1270 = 2
	  li $t2, 2		# load constant value 2 into $t2
	  sw $t2, -448($fp)	# spill _tmp1270 from $t2 to $fp-448
	# column = _tmp1270
	  lw $t2, -448($fp)	# fill _tmp1270 to $t2 from $fp-448
	  sw $t2, -12($fp)	# spill column from $t2 to $fp-12
	# Goto _L114
	  b _L114		# unconditional branch
  _L113:
	# PushParam enemyMark
	  subu $sp, $sp, 4	# decrement sp to make space for param
	  lw $t0, 8($fp)	# fill enemyMark to $t0 from $fp+8
	  sw $t0, 4($sp)	# copy param value to stack
	# _tmp1271 = *(this + 4)
	  lw $t0, 4($fp)	# fill this to $t0 from $fp+4
	  lw $t2, 4($t0) 	# load with offset
	  sw $t2, -452($fp)	# spill _tmp1271 from $t2 to $fp-452
	# _tmp1272 = 1
	  li $t2, 1		# load constant value 1 into $t2
	  sw $t2, -456($fp)	# spill _tmp1272 from $t2 to $fp-456
	# _tmp1273 = 0
	  li $t2, 0		# load constant value 0 into $t2
	  sw $t2, -460($fp)	# spill _tmp1273 from $t2 to $fp-460
	# _tmp1274 = *(_tmp1271)
	  lw $t0, -452($fp)	# fill _tmp1271 to $t0 from $fp-452
	  lw $t2, 0($t0) 	# load with offset
	  sw $t2, -464($fp)	# spill _tmp1274 from $t2 to $fp-464
	# _tmp1275 = _tmp1272 < _tmp1273
	  lw $t0, -456($fp)	# fill _tmp1272 to $t0 from $fp-456
	  lw $t1, -460($fp)	# fill _tmp1273 to $t1 from $fp-460
	  slt $t2, $t0, $t1	
	  sw $t2, -468($fp)	# spill _tmp1275 from $t2 to $fp-468
	# _tmp1276 = _tmp1274 < _tmp1272
	  lw $t0, -464($fp)	# fill _tmp1274 to $t0 from $fp-464
	  lw $t1, -456($fp)	# fill _tmp1272 to $t1 from $fp-456
	  slt $t2, $t0, $t1	
	  sw $t2, -472($fp)	# spill _tmp1276 from $t2 to $fp-472
	# _tmp1277 = _tmp1274 == _tmp1272
	  lw $t0, -464($fp)	# fill _tmp1274 to $t0 from $fp-464
	  lw $t1, -456($fp)	# fill _tmp1272 to $t1 from $fp-456
	  seq $t2, $t0, $t1	
	  sw $t2, -476($fp)	# spill _tmp1277 from $t2 to $fp-476
	# _tmp1278 = _tmp1276 || _tmp1277
	  lw $t0, -472($fp)	# fill _tmp1276 to $t0 from $fp-472
	  lw $t1, -476($fp)	# fill _tmp1277 to $t1 from $fp-476
	  or $t2, $t0, $t1	
	  sw $t2, -480($fp)	# spill _tmp1278 from $t2 to $fp-480
	# _tmp1279 = _tmp1278 || _tmp1275
	  lw $t0, -480($fp)	# fill _tmp1278 to $t0 from $fp-480
	  lw $t1, -468($fp)	# fill _tmp1275 to $t1 from $fp-468
	  or $t2, $t0, $t1	
	  sw $t2, -484($fp)	# spill _tmp1279 from $t2 to $fp-484
	# IfZ _tmp1279 Goto _L125
	  lw $t0, -484($fp)	# fill _tmp1279 to $t0 from $fp-484
	  beqz $t0, _L125	# branch if _tmp1279 is zero 
	# _tmp1280 = "Decaf runtime error: Array subscript out of bound..."
	  .data			# create string constant marked with label
	  _string85: .asciiz "Decaf runtime error: Array subscript out of bounds\n"
	  .text
	  la $t2, _string85	# load label
	  sw $t2, -488($fp)	# spill _tmp1280 from $t2 to $fp-488
	# PushParam _tmp1280
	  subu $sp, $sp, 4	# decrement sp to make space for param
	  lw $t0, -488($fp)	# fill _tmp1280 to $t0 from $fp-488
	  sw $t0, 4($sp)	# copy param value to stack
	# LCall _PrintString
	  jal _PrintString   	# jump to function
	# PopParams 4
	  add $sp, $sp, 4	# pop params off stack
	# LCall _Halt
	  jal _Halt          	# jump to function
  _L125:
	# _tmp1281 = 4
	  li $t2, 4		# load constant value 4 into $t2
	  sw $t2, -492($fp)	# spill _tmp1281 from $t2 to $fp-492
	# _tmp1282 = _tmp1272 * _tmp1281
	  lw $t0, -456($fp)	# fill _tmp1272 to $t0 from $fp-456
	  lw $t1, -492($fp)	# fill _tmp1281 to $t1 from $fp-492
	  mul $t2, $t0, $t1	
	  sw $t2, -496($fp)	# spill _tmp1282 from $t2 to $fp-496
	# _tmp1283 = _tmp1282 + _tmp1281
	  lw $t0, -496($fp)	# fill _tmp1282 to $t0 from $fp-496
	  lw $t1, -492($fp)	# fill _tmp1281 to $t1 from $fp-492
	  add $t2, $t0, $t1	
	  sw $t2, -500($fp)	# spill _tmp1283 from $t2 to $fp-500
	# _tmp1284 = _tmp1271 + _tmp1283
	  lw $t0, -452($fp)	# fill _tmp1271 to $t0 from $fp-452
	  lw $t1, -500($fp)	# fill _tmp1283 to $t1 from $fp-500
	  add $t2, $t0, $t1	
	  sw $t2, -504($fp)	# spill _tmp1284 from $t2 to $fp-504
	# _tmp1285 = *(_tmp1284)
	  lw $t0, -504($fp)	# fill _tmp1284 to $t0 from $fp-504
	  lw $t2, 0($t0) 	# load with offset
	  sw $t2, -508($fp)	# spill _tmp1285 from $t2 to $fp-508
	# _tmp1286 = 0
	  li $t2, 0		# load constant value 0 into $t2
	  sw $t2, -512($fp)	# spill _tmp1286 from $t2 to $fp-512
	# _tmp1287 = 0
	  li $t2, 0		# load constant value 0 into $t2
	  sw $t2, -516($fp)	# spill _tmp1287 from $t2 to $fp-516
	# _tmp1288 = *(_tmp1285)
	  lw $t0, -508($fp)	# fill _tmp1285 to $t0 from $fp-508
	  lw $t2, 0($t0) 	# load with offset
	  sw $t2, -520($fp)	# spill _tmp1288 from $t2 to $fp-520
	# _tmp1289 = _tmp1286 < _tmp1287
	  lw $t0, -512($fp)	# fill _tmp1286 to $t0 from $fp-512
	  lw $t1, -516($fp)	# fill _tmp1287 to $t1 from $fp-516
	  slt $t2, $t0, $t1	
	  sw $t2, -524($fp)	# spill _tmp1289 from $t2 to $fp-524
	# _tmp1290 = _tmp1288 < _tmp1286
	  lw $t0, -520($fp)	# fill _tmp1288 to $t0 from $fp-520
	  lw $t1, -512($fp)	# fill _tmp1286 to $t1 from $fp-512
	  slt $t2, $t0, $t1	
	  sw $t2, -528($fp)	# spill _tmp1290 from $t2 to $fp-528
	# _tmp1291 = _tmp1288 == _tmp1286
	  lw $t0, -520($fp)	# fill _tmp1288 to $t0 from $fp-520
	  lw $t1, -512($fp)	# fill _tmp1286 to $t1 from $fp-512
	  seq $t2, $t0, $t1	
	  sw $t2, -532($fp)	# spill _tmp1291 from $t2 to $fp-532
	# _tmp1292 = _tmp1290 || _tmp1291
	  lw $t0, -528($fp)	# fill _tmp1290 to $t0 from $fp-528
	  lw $t1, -532($fp)	# fill _tmp1291 to $t1 from $fp-532
	  or $t2, $t0, $t1	
	  sw $t2, -536($fp)	# spill _tmp1292 from $t2 to $fp-536
	# _tmp1293 = _tmp1292 || _tmp1289
	  lw $t0, -536($fp)	# fill _tmp1292 to $t0 from $fp-536
	  lw $t1, -524($fp)	# fill _tmp1289 to $t1 from $fp-524
	  or $t2, $t0, $t1	
	  sw $t2, -540($fp)	# spill _tmp1293 from $t2 to $fp-540
	# IfZ _tmp1293 Goto _L126
	  lw $t0, -540($fp)	# fill _tmp1293 to $t0 from $fp-540
	  beqz $t0, _L126	# branch if _tmp1293 is zero 
	# _tmp1294 = "Decaf runtime error: Array subscript out of bound..."
	  .data			# create string constant marked with label
	  _string86: .asciiz "Decaf runtime error: Array subscript out of bounds\n"
	  .text
	  la $t2, _string86	# load label
	  sw $t2, -544($fp)	# spill _tmp1294 from $t2 to $fp-544
	# PushParam _tmp1294
	  subu $sp, $sp, 4	# decrement sp to make space for param
	  lw $t0, -544($fp)	# fill _tmp1294 to $t0 from $fp-544
	  sw $t0, 4($sp)	# copy param value to stack
	# LCall _PrintString
	  jal _PrintString   	# jump to function
	# PopParams 4
	  add $sp, $sp, 4	# pop params off stack
	# LCall _Halt
	  jal _Halt          	# jump to function
  _L126:
	# _tmp1295 = 4
	  li $t2, 4		# load constant value 4 into $t2
	  sw $t2, -548($fp)	# spill _tmp1295 from $t2 to $fp-548
	# _tmp1296 = _tmp1286 * _tmp1295
	  lw $t0, -512($fp)	# fill _tmp1286 to $t0 from $fp-512
	  lw $t1, -548($fp)	# fill _tmp1295 to $t1 from $fp-548
	  mul $t2, $t0, $t1	
	  sw $t2, -552($fp)	# spill _tmp1296 from $t2 to $fp-552
	# _tmp1297 = _tmp1296 + _tmp1295
	  lw $t0, -552($fp)	# fill _tmp1296 to $t0 from $fp-552
	  lw $t1, -548($fp)	# fill _tmp1295 to $t1 from $fp-548
	  add $t2, $t0, $t1	
	  sw $t2, -556($fp)	# spill _tmp1297 from $t2 to $fp-556
	# _tmp1298 = _tmp1285 + _tmp1297
	  lw $t0, -508($fp)	# fill _tmp1285 to $t0 from $fp-508
	  lw $t1, -556($fp)	# fill _tmp1297 to $t1 from $fp-556
	  add $t2, $t0, $t1	
	  sw $t2, -560($fp)	# spill _tmp1298 from $t2 to $fp-560
	# _tmp1299 = *(_tmp1298)
	  lw $t0, -560($fp)	# fill _tmp1298 to $t0 from $fp-560
	  lw $t2, 0($t0) 	# load with offset
	  sw $t2, -564($fp)	# spill _tmp1299 from $t2 to $fp-564
	# PushParam _tmp1299
	  subu $sp, $sp, 4	# decrement sp to make space for param
	  lw $t0, -564($fp)	# fill _tmp1299 to $t0 from $fp-564
	  sw $t0, 4($sp)	# copy param value to stack
	# _tmp1300 = *(_tmp1299)
	  lw $t0, -564($fp)	# fill _tmp1299 to $t0 from $fp-564
	  lw $t2, 0($t0) 	# load with offset
	  sw $t2, -568($fp)	# spill _tmp1300 from $t2 to $fp-568
	# _tmp1301 = *(_tmp1300 + 20)
	  lw $t0, -568($fp)	# fill _tmp1300 to $t0 from $fp-568
	  lw $t2, 20($t0) 	# load with offset
	  sw $t2, -572($fp)	# spill _tmp1301 from $t2 to $fp-572
	# _tmp1302 = ACall _tmp1301
	  lw $t0, -572($fp)	# fill _tmp1301 to $t0 from $fp-572
	  jalr $t0            	# jump to function
	  move $t2, $v0		# copy function return value from $v0
	  sw $t2, -576($fp)	# spill _tmp1302 from $t2 to $fp-576
	# PopParams 8
	  add $sp, $sp, 8	# pop params off stack
	# PushParam enemyMark
	  subu $sp, $sp, 4	# decrement sp to make space for param
	  lw $t0, 8($fp)	# fill enemyMark to $t0 from $fp+8
	  sw $t0, 4($sp)	# copy param value to stack
	# _tmp1303 = *(this + 4)
	  lw $t0, 4($fp)	# fill this to $t0 from $fp+4
	  lw $t2, 4($t0) 	# load with offset
	  sw $t2, -580($fp)	# spill _tmp1303 from $t2 to $fp-580
	# _tmp1304 = 1
	  li $t2, 1		# load constant value 1 into $t2
	  sw $t2, -584($fp)	# spill _tmp1304 from $t2 to $fp-584
	# _tmp1305 = 0
	  li $t2, 0		# load constant value 0 into $t2
	  sw $t2, -588($fp)	# spill _tmp1305 from $t2 to $fp-588
	# _tmp1306 = *(_tmp1303)
	  lw $t0, -580($fp)	# fill _tmp1303 to $t0 from $fp-580
	  lw $t2, 0($t0) 	# load with offset
	  sw $t2, -592($fp)	# spill _tmp1306 from $t2 to $fp-592
	# _tmp1307 = _tmp1304 < _tmp1305
	  lw $t0, -584($fp)	# fill _tmp1304 to $t0 from $fp-584
	  lw $t1, -588($fp)	# fill _tmp1305 to $t1 from $fp-588
	  slt $t2, $t0, $t1	
	  sw $t2, -596($fp)	# spill _tmp1307 from $t2 to $fp-596
	# _tmp1308 = _tmp1306 < _tmp1304
	  lw $t0, -592($fp)	# fill _tmp1306 to $t0 from $fp-592
	  lw $t1, -584($fp)	# fill _tmp1304 to $t1 from $fp-584
	  slt $t2, $t0, $t1	
	  sw $t2, -600($fp)	# spill _tmp1308 from $t2 to $fp-600
	# _tmp1309 = _tmp1306 == _tmp1304
	  lw $t0, -592($fp)	# fill _tmp1306 to $t0 from $fp-592
	  lw $t1, -584($fp)	# fill _tmp1304 to $t1 from $fp-584
	  seq $t2, $t0, $t1	
	  sw $t2, -604($fp)	# spill _tmp1309 from $t2 to $fp-604
	# _tmp1310 = _tmp1308 || _tmp1309
	  lw $t0, -600($fp)	# fill _tmp1308 to $t0 from $fp-600
	  lw $t1, -604($fp)	# fill _tmp1309 to $t1 from $fp-604
	  or $t2, $t0, $t1	
	  sw $t2, -608($fp)	# spill _tmp1310 from $t2 to $fp-608
	# _tmp1311 = _tmp1310 || _tmp1307
	  lw $t0, -608($fp)	# fill _tmp1310 to $t0 from $fp-608
	  lw $t1, -596($fp)	# fill _tmp1307 to $t1 from $fp-596
	  or $t2, $t0, $t1	
	  sw $t2, -612($fp)	# spill _tmp1311 from $t2 to $fp-612
	# IfZ _tmp1311 Goto _L127
	  lw $t0, -612($fp)	# fill _tmp1311 to $t0 from $fp-612
	  beqz $t0, _L127	# branch if _tmp1311 is zero 
	# _tmp1312 = "Decaf runtime error: Array subscript out of bound..."
	  .data			# create string constant marked with label
	  _string87: .asciiz "Decaf runtime error: Array subscript out of bounds\n"
	  .text
	  la $t2, _string87	# load label
	  sw $t2, -616($fp)	# spill _tmp1312 from $t2 to $fp-616
	# PushParam _tmp1312
	  subu $sp, $sp, 4	# decrement sp to make space for param
	  lw $t0, -616($fp)	# fill _tmp1312 to $t0 from $fp-616
	  sw $t0, 4($sp)	# copy param value to stack
	# LCall _PrintString
	  jal _PrintString   	# jump to function
	# PopParams 4
	  add $sp, $sp, 4	# pop params off stack
	# LCall _Halt
	  jal _Halt          	# jump to function
  _L127:
	# _tmp1313 = 4
	  li $t2, 4		# load constant value 4 into $t2
	  sw $t2, -620($fp)	# spill _tmp1313 from $t2 to $fp-620
	# _tmp1314 = _tmp1304 * _tmp1313
	  lw $t0, -584($fp)	# fill _tmp1304 to $t0 from $fp-584
	  lw $t1, -620($fp)	# fill _tmp1313 to $t1 from $fp-620
	  mul $t2, $t0, $t1	
	  sw $t2, -624($fp)	# spill _tmp1314 from $t2 to $fp-624
	# _tmp1315 = _tmp1314 + _tmp1313
	  lw $t0, -624($fp)	# fill _tmp1314 to $t0 from $fp-624
	  lw $t1, -620($fp)	# fill _tmp1313 to $t1 from $fp-620
	  add $t2, $t0, $t1	
	  sw $t2, -628($fp)	# spill _tmp1315 from $t2 to $fp-628
	# _tmp1316 = _tmp1303 + _tmp1315
	  lw $t0, -580($fp)	# fill _tmp1303 to $t0 from $fp-580
	  lw $t1, -628($fp)	# fill _tmp1315 to $t1 from $fp-628
	  add $t2, $t0, $t1	
	  sw $t2, -632($fp)	# spill _tmp1316 from $t2 to $fp-632
	# _tmp1317 = *(_tmp1316)
	  lw $t0, -632($fp)	# fill _tmp1316 to $t0 from $fp-632
	  lw $t2, 0($t0) 	# load with offset
	  sw $t2, -636($fp)	# spill _tmp1317 from $t2 to $fp-636
	# _tmp1318 = 1
	  li $t2, 1		# load constant value 1 into $t2
	  sw $t2, -640($fp)	# spill _tmp1318 from $t2 to $fp-640
	# _tmp1319 = 0
	  li $t2, 0		# load constant value 0 into $t2
	  sw $t2, -644($fp)	# spill _tmp1319 from $t2 to $fp-644
	# _tmp1320 = *(_tmp1317)
	  lw $t0, -636($fp)	# fill _tmp1317 to $t0 from $fp-636
	  lw $t2, 0($t0) 	# load with offset
	  sw $t2, -648($fp)	# spill _tmp1320 from $t2 to $fp-648
	# _tmp1321 = _tmp1318 < _tmp1319
	  lw $t0, -640($fp)	# fill _tmp1318 to $t0 from $fp-640
	  lw $t1, -644($fp)	# fill _tmp1319 to $t1 from $fp-644
	  slt $t2, $t0, $t1	
	  sw $t2, -652($fp)	# spill _tmp1321 from $t2 to $fp-652
	# _tmp1322 = _tmp1320 < _tmp1318
	  lw $t0, -648($fp)	# fill _tmp1320 to $t0 from $fp-648
	  lw $t1, -640($fp)	# fill _tmp1318 to $t1 from $fp-640
	  slt $t2, $t0, $t1	
	  sw $t2, -656($fp)	# spill _tmp1322 from $t2 to $fp-656
	# _tmp1323 = _tmp1320 == _tmp1318
	  lw $t0, -648($fp)	# fill _tmp1320 to $t0 from $fp-648
	  lw $t1, -640($fp)	# fill _tmp1318 to $t1 from $fp-640
	  seq $t2, $t0, $t1	
	  sw $t2, -660($fp)	# spill _tmp1323 from $t2 to $fp-660
	# _tmp1324 = _tmp1322 || _tmp1323
	  lw $t0, -656($fp)	# fill _tmp1322 to $t0 from $fp-656
	  lw $t1, -660($fp)	# fill _tmp1323 to $t1 from $fp-660
	  or $t2, $t0, $t1	
	  sw $t2, -664($fp)	# spill _tmp1324 from $t2 to $fp-664
	# _tmp1325 = _tmp1324 || _tmp1321
	  lw $t0, -664($fp)	# fill _tmp1324 to $t0 from $fp-664
	  lw $t1, -652($fp)	# fill _tmp1321 to $t1 from $fp-652
	  or $t2, $t0, $t1	
	  sw $t2, -668($fp)	# spill _tmp1325 from $t2 to $fp-668
	# IfZ _tmp1325 Goto _L128
	  lw $t0, -668($fp)	# fill _tmp1325 to $t0 from $fp-668
	  beqz $t0, _L128	# branch if _tmp1325 is zero 
	# _tmp1326 = "Decaf runtime error: Array subscript out of bound..."
	  .data			# create string constant marked with label
	  _string88: .asciiz "Decaf runtime error: Array subscript out of bounds\n"
	  .text
	  la $t2, _string88	# load label
	  sw $t2, -672($fp)	# spill _tmp1326 from $t2 to $fp-672
	# PushParam _tmp1326
	  subu $sp, $sp, 4	# decrement sp to make space for param
	  lw $t0, -672($fp)	# fill _tmp1326 to $t0 from $fp-672
	  sw $t0, 4($sp)	# copy param value to stack
	# LCall _PrintString
	  jal _PrintString   	# jump to function
	# PopParams 4
	  add $sp, $sp, 4	# pop params off stack
	# LCall _Halt
	  jal _Halt          	# jump to function
  _L128:
	# _tmp1327 = 4
	  li $t2, 4		# load constant value 4 into $t2
	  sw $t2, -676($fp)	# spill _tmp1327 from $t2 to $fp-676
	# _tmp1328 = _tmp1318 * _tmp1327
	  lw $t0, -640($fp)	# fill _tmp1318 to $t0 from $fp-640
	  lw $t1, -676($fp)	# fill _tmp1327 to $t1 from $fp-676
	  mul $t2, $t0, $t1	
	  sw $t2, -680($fp)	# spill _tmp1328 from $t2 to $fp-680
	# _tmp1329 = _tmp1328 + _tmp1327
	  lw $t0, -680($fp)	# fill _tmp1328 to $t0 from $fp-680
	  lw $t1, -676($fp)	# fill _tmp1327 to $t1 from $fp-676
	  add $t2, $t0, $t1	
	  sw $t2, -684($fp)	# spill _tmp1329 from $t2 to $fp-684
	# _tmp1330 = _tmp1317 + _tmp1329
	  lw $t0, -636($fp)	# fill _tmp1317 to $t0 from $fp-636
	  lw $t1, -684($fp)	# fill _tmp1329 to $t1 from $fp-684
	  add $t2, $t0, $t1	
	  sw $t2, -688($fp)	# spill _tmp1330 from $t2 to $fp-688
	# _tmp1331 = *(_tmp1330)
	  lw $t0, -688($fp)	# fill _tmp1330 to $t0 from $fp-688
	  lw $t2, 0($t0) 	# load with offset
	  sw $t2, -692($fp)	# spill _tmp1331 from $t2 to $fp-692
	# PushParam _tmp1331
	  subu $sp, $sp, 4	# decrement sp to make space for param
	  lw $t0, -692($fp)	# fill _tmp1331 to $t0 from $fp-692
	  sw $t0, 4($sp)	# copy param value to stack
	# _tmp1332 = *(_tmp1331)
	  lw $t0, -692($fp)	# fill _tmp1331 to $t0 from $fp-692
	  lw $t2, 0($t0) 	# load with offset
	  sw $t2, -696($fp)	# spill _tmp1332 from $t2 to $fp-696
	# _tmp1333 = *(_tmp1332 + 20)
	  lw $t0, -696($fp)	# fill _tmp1332 to $t0 from $fp-696
	  lw $t2, 20($t0) 	# load with offset
	  sw $t2, -700($fp)	# spill _tmp1333 from $t2 to $fp-700
	# _tmp1334 = ACall _tmp1333
	  lw $t0, -700($fp)	# fill _tmp1333 to $t0 from $fp-700
	  jalr $t0            	# jump to function
	  move $t2, $v0		# copy function return value from $v0
	  sw $t2, -704($fp)	# spill _tmp1334 from $t2 to $fp-704
	# PopParams 8
	  add $sp, $sp, 8	# pop params off stack
	# _tmp1335 = _tmp1302 && _tmp1334
	  lw $t0, -576($fp)	# fill _tmp1302 to $t0 from $fp-576
	  lw $t1, -704($fp)	# fill _tmp1334 to $t1 from $fp-704
	  and $t2, $t0, $t1	
	  sw $t2, -708($fp)	# spill _tmp1335 from $t2 to $fp-708
	# PushParam playerMark
	  subu $sp, $sp, 4	# decrement sp to make space for param
	  lw $t0, 12($fp)	# fill playerMark to $t0 from $fp+12
	  sw $t0, 4($sp)	# copy param value to stack
	# _tmp1337 = *(this + 4)
	  lw $t0, 4($fp)	# fill this to $t0 from $fp+4
	  lw $t2, 4($t0) 	# load with offset
	  sw $t2, -716($fp)	# spill _tmp1337 from $t2 to $fp-716
	# _tmp1338 = 1
	  li $t2, 1		# load constant value 1 into $t2
	  sw $t2, -720($fp)	# spill _tmp1338 from $t2 to $fp-720
	# _tmp1339 = 0
	  li $t2, 0		# load constant value 0 into $t2
	  sw $t2, -724($fp)	# spill _tmp1339 from $t2 to $fp-724
	# _tmp1340 = *(_tmp1337)
	  lw $t0, -716($fp)	# fill _tmp1337 to $t0 from $fp-716
	  lw $t2, 0($t0) 	# load with offset
	  sw $t2, -728($fp)	# spill _tmp1340 from $t2 to $fp-728
	# _tmp1341 = _tmp1338 < _tmp1339
	  lw $t0, -720($fp)	# fill _tmp1338 to $t0 from $fp-720
	  lw $t1, -724($fp)	# fill _tmp1339 to $t1 from $fp-724
	  slt $t2, $t0, $t1	
	  sw $t2, -732($fp)	# spill _tmp1341 from $t2 to $fp-732
	# _tmp1342 = _tmp1340 < _tmp1338
	  lw $t0, -728($fp)	# fill _tmp1340 to $t0 from $fp-728
	  lw $t1, -720($fp)	# fill _tmp1338 to $t1 from $fp-720
	  slt $t2, $t0, $t1	
	  sw $t2, -736($fp)	# spill _tmp1342 from $t2 to $fp-736
	# _tmp1343 = _tmp1340 == _tmp1338
	  lw $t0, -728($fp)	# fill _tmp1340 to $t0 from $fp-728
	  lw $t1, -720($fp)	# fill _tmp1338 to $t1 from $fp-720
	  seq $t2, $t0, $t1	
	  sw $t2, -740($fp)	# spill _tmp1343 from $t2 to $fp-740
	# _tmp1344 = _tmp1342 || _tmp1343
	  lw $t0, -736($fp)	# fill _tmp1342 to $t0 from $fp-736
	  lw $t1, -740($fp)	# fill _tmp1343 to $t1 from $fp-740
	  or $t2, $t0, $t1	
	  sw $t2, -744($fp)	# spill _tmp1344 from $t2 to $fp-744
	# _tmp1345 = _tmp1344 || _tmp1341
	  lw $t0, -744($fp)	# fill _tmp1344 to $t0 from $fp-744
	  lw $t1, -732($fp)	# fill _tmp1341 to $t1 from $fp-732
	  or $t2, $t0, $t1	
	  sw $t2, -748($fp)	# spill _tmp1345 from $t2 to $fp-748
	# IfZ _tmp1345 Goto _L131
	  lw $t0, -748($fp)	# fill _tmp1345 to $t0 from $fp-748
	  beqz $t0, _L131	# branch if _tmp1345 is zero 
	# _tmp1346 = "Decaf runtime error: Array subscript out of bound..."
	  .data			# create string constant marked with label
	  _string89: .asciiz "Decaf runtime error: Array subscript out of bounds\n"
	  .text
	  la $t2, _string89	# load label
	  sw $t2, -752($fp)	# spill _tmp1346 from $t2 to $fp-752
	# PushParam _tmp1346
	  subu $sp, $sp, 4	# decrement sp to make space for param
	  lw $t0, -752($fp)	# fill _tmp1346 to $t0 from $fp-752
	  sw $t0, 4($sp)	# copy param value to stack
	# LCall _PrintString
	  jal _PrintString   	# jump to function
	# PopParams 4
	  add $sp, $sp, 4	# pop params off stack
	# LCall _Halt
	  jal _Halt          	# jump to function
  _L131:
	# _tmp1347 = 4
	  li $t2, 4		# load constant value 4 into $t2
	  sw $t2, -756($fp)	# spill _tmp1347 from $t2 to $fp-756
	# _tmp1348 = _tmp1338 * _tmp1347
	  lw $t0, -720($fp)	# fill _tmp1338 to $t0 from $fp-720
	  lw $t1, -756($fp)	# fill _tmp1347 to $t1 from $fp-756
	  mul $t2, $t0, $t1	
	  sw $t2, -760($fp)	# spill _tmp1348 from $t2 to $fp-760
	# _tmp1349 = _tmp1348 + _tmp1347
	  lw $t0, -760($fp)	# fill _tmp1348 to $t0 from $fp-760
	  lw $t1, -756($fp)	# fill _tmp1347 to $t1 from $fp-756
	  add $t2, $t0, $t1	
	  sw $t2, -764($fp)	# spill _tmp1349 from $t2 to $fp-764
	# _tmp1350 = _tmp1337 + _tmp1349
	  lw $t0, -716($fp)	# fill _tmp1337 to $t0 from $fp-716
	  lw $t1, -764($fp)	# fill _tmp1349 to $t1 from $fp-764
	  add $t2, $t0, $t1	
	  sw $t2, -768($fp)	# spill _tmp1350 from $t2 to $fp-768
	# _tmp1351 = *(_tmp1350)
	  lw $t0, -768($fp)	# fill _tmp1350 to $t0 from $fp-768
	  lw $t2, 0($t0) 	# load with offset
	  sw $t2, -772($fp)	# spill _tmp1351 from $t2 to $fp-772
	# _tmp1352 = 2
	  li $t2, 2		# load constant value 2 into $t2
	  sw $t2, -776($fp)	# spill _tmp1352 from $t2 to $fp-776
	# _tmp1353 = 0
	  li $t2, 0		# load constant value 0 into $t2
	  sw $t2, -780($fp)	# spill _tmp1353 from $t2 to $fp-780
	# _tmp1354 = *(_tmp1351)
	  lw $t0, -772($fp)	# fill _tmp1351 to $t0 from $fp-772
	  lw $t2, 0($t0) 	# load with offset
	  sw $t2, -784($fp)	# spill _tmp1354 from $t2 to $fp-784
	# _tmp1355 = _tmp1352 < _tmp1353
	  lw $t0, -776($fp)	# fill _tmp1352 to $t0 from $fp-776
	  lw $t1, -780($fp)	# fill _tmp1353 to $t1 from $fp-780
	  slt $t2, $t0, $t1	
	  sw $t2, -788($fp)	# spill _tmp1355 from $t2 to $fp-788
	# _tmp1356 = _tmp1354 < _tmp1352
	  lw $t0, -784($fp)	# fill _tmp1354 to $t0 from $fp-784
	  lw $t1, -776($fp)	# fill _tmp1352 to $t1 from $fp-776
	  slt $t2, $t0, $t1	
	  sw $t2, -792($fp)	# spill _tmp1356 from $t2 to $fp-792
	# _tmp1357 = _tmp1354 == _tmp1352
	  lw $t0, -784($fp)	# fill _tmp1354 to $t0 from $fp-784
	  lw $t1, -776($fp)	# fill _tmp1352 to $t1 from $fp-776
	  seq $t2, $t0, $t1	
	  sw $t2, -796($fp)	# spill _tmp1357 from $t2 to $fp-796
	# _tmp1358 = _tmp1356 || _tmp1357
	  lw $t0, -792($fp)	# fill _tmp1356 to $t0 from $fp-792
	  lw $t1, -796($fp)	# fill _tmp1357 to $t1 from $fp-796
	  or $t2, $t0, $t1	
	  sw $t2, -800($fp)	# spill _tmp1358 from $t2 to $fp-800
	# _tmp1359 = _tmp1358 || _tmp1355
	  lw $t0, -800($fp)	# fill _tmp1358 to $t0 from $fp-800
	  lw $t1, -788($fp)	# fill _tmp1355 to $t1 from $fp-788
	  or $t2, $t0, $t1	
	  sw $t2, -804($fp)	# spill _tmp1359 from $t2 to $fp-804
	# IfZ _tmp1359 Goto _L132
	  lw $t0, -804($fp)	# fill _tmp1359 to $t0 from $fp-804
	  beqz $t0, _L132	# branch if _tmp1359 is zero 
	# _tmp1360 = "Decaf runtime error: Array subscript out of bound..."
	  .data			# create string constant marked with label
	  _string90: .asciiz "Decaf runtime error: Array subscript out of bounds\n"
	  .text
	  la $t2, _string90	# load label
	  sw $t2, -808($fp)	# spill _tmp1360 from $t2 to $fp-808
	# PushParam _tmp1360
	  subu $sp, $sp, 4	# decrement sp to make space for param
	  lw $t0, -808($fp)	# fill _tmp1360 to $t0 from $fp-808
	  sw $t0, 4($sp)	# copy param value to stack
	# LCall _PrintString
	  jal _PrintString   	# jump to function
	# PopParams 4
	  add $sp, $sp, 4	# pop params off stack
	# LCall _Halt
	  jal _Halt          	# jump to function
  _L132:
	# _tmp1361 = 4
	  li $t2, 4		# load constant value 4 into $t2
	  sw $t2, -812($fp)	# spill _tmp1361 from $t2 to $fp-812
	# _tmp1362 = _tmp1352 * _tmp1361
	  lw $t0, -776($fp)	# fill _tmp1352 to $t0 from $fp-776
	  lw $t1, -812($fp)	# fill _tmp1361 to $t1 from $fp-812
	  mul $t2, $t0, $t1	
	  sw $t2, -816($fp)	# spill _tmp1362 from $t2 to $fp-816
	# _tmp1363 = _tmp1362 + _tmp1361
	  lw $t0, -816($fp)	# fill _tmp1362 to $t0 from $fp-816
	  lw $t1, -812($fp)	# fill _tmp1361 to $t1 from $fp-812
	  add $t2, $t0, $t1	
	  sw $t2, -820($fp)	# spill _tmp1363 from $t2 to $fp-820
	# _tmp1364 = _tmp1351 + _tmp1363
	  lw $t0, -772($fp)	# fill _tmp1351 to $t0 from $fp-772
	  lw $t1, -820($fp)	# fill _tmp1363 to $t1 from $fp-820
	  add $t2, $t0, $t1	
	  sw $t2, -824($fp)	# spill _tmp1364 from $t2 to $fp-824
	# _tmp1365 = *(_tmp1364)
	  lw $t0, -824($fp)	# fill _tmp1364 to $t0 from $fp-824
	  lw $t2, 0($t0) 	# load with offset
	  sw $t2, -828($fp)	# spill _tmp1365 from $t2 to $fp-828
	# PushParam _tmp1365
	  subu $sp, $sp, 4	# decrement sp to make space for param
	  lw $t0, -828($fp)	# fill _tmp1365 to $t0 from $fp-828
	  sw $t0, 4($sp)	# copy param value to stack
	# _tmp1366 = *(_tmp1365)
	  lw $t0, -828($fp)	# fill _tmp1365 to $t0 from $fp-828
	  lw $t2, 0($t0) 	# load with offset
	  sw $t2, -832($fp)	# spill _tmp1366 from $t2 to $fp-832
	# _tmp1367 = *(_tmp1366 + 20)
	  lw $t0, -832($fp)	# fill _tmp1366 to $t0 from $fp-832
	  lw $t2, 20($t0) 	# load with offset
	  sw $t2, -836($fp)	# spill _tmp1367 from $t2 to $fp-836
	# _tmp1368 = ACall _tmp1367
	  lw $t0, -836($fp)	# fill _tmp1367 to $t0 from $fp-836
	  jalr $t0            	# jump to function
	  move $t2, $v0		# copy function return value from $v0
	  sw $t2, -840($fp)	# spill _tmp1368 from $t2 to $fp-840
	# PopParams 8
	  add $sp, $sp, 8	# pop params off stack
	# IfZ _tmp1368 Goto _L130
	  lw $t0, -840($fp)	# fill _tmp1368 to $t0 from $fp-840
	  beqz $t0, _L130	# branch if _tmp1368 is zero 
	# _tmp1369 = 0
	  li $t2, 0		# load constant value 0 into $t2
	  sw $t2, -844($fp)	# spill _tmp1369 from $t2 to $fp-844
	# _tmp1336 = _tmp1369
	  lw $t2, -844($fp)	# fill _tmp1369 to $t2 from $fp-844
	  sw $t2, -712($fp)	# spill _tmp1336 from $t2 to $fp-712
	# Goto _L129
	  b _L129		# unconditional branch
  _L130:
	# _tmp1370 = 1
	  li $t2, 1		# load constant value 1 into $t2
	  sw $t2, -848($fp)	# spill _tmp1370 from $t2 to $fp-848
	# _tmp1336 = _tmp1370
	  lw $t2, -848($fp)	# fill _tmp1370 to $t2 from $fp-848
	  sw $t2, -712($fp)	# spill _tmp1336 from $t2 to $fp-712
  _L129:
	# _tmp1371 = _tmp1335 && _tmp1336
	  lw $t0, -708($fp)	# fill _tmp1335 to $t0 from $fp-708
	  lw $t1, -712($fp)	# fill _tmp1336 to $t1 from $fp-712
	  and $t2, $t0, $t1	
	  sw $t2, -852($fp)	# spill _tmp1371 from $t2 to $fp-852
	# IfZ _tmp1371 Goto _L123
	  lw $t0, -852($fp)	# fill _tmp1371 to $t0 from $fp-852
	  beqz $t0, _L123	# branch if _tmp1371 is zero 
	# _tmp1372 = 1
	  li $t2, 1		# load constant value 1 into $t2
	  sw $t2, -856($fp)	# spill _tmp1372 from $t2 to $fp-856
	# row = _tmp1372
	  lw $t2, -856($fp)	# fill _tmp1372 to $t2 from $fp-856
	  sw $t2, -8($fp)	# spill row from $t2 to $fp-8
	# _tmp1373 = 2
	  li $t2, 2		# load constant value 2 into $t2
	  sw $t2, -860($fp)	# spill _tmp1373 from $t2 to $fp-860
	# column = _tmp1373
	  lw $t2, -860($fp)	# fill _tmp1373 to $t2 from $fp-860
	  sw $t2, -12($fp)	# spill column from $t2 to $fp-12
	# Goto _L124
	  b _L124		# unconditional branch
  _L123:
	# PushParam enemyMark
	  subu $sp, $sp, 4	# decrement sp to make space for param
	  lw $t0, 8($fp)	# fill enemyMark to $t0 from $fp+8
	  sw $t0, 4($sp)	# copy param value to stack
	# _tmp1374 = *(this + 4)
	  lw $t0, 4($fp)	# fill this to $t0 from $fp+4
	  lw $t2, 4($t0) 	# load with offset
	  sw $t2, -864($fp)	# spill _tmp1374 from $t2 to $fp-864
	# _tmp1375 = 2
	  li $t2, 2		# load constant value 2 into $t2
	  sw $t2, -868($fp)	# spill _tmp1375 from $t2 to $fp-868
	# _tmp1376 = 0
	  li $t2, 0		# load constant value 0 into $t2
	  sw $t2, -872($fp)	# spill _tmp1376 from $t2 to $fp-872
	# _tmp1377 = *(_tmp1374)
	  lw $t0, -864($fp)	# fill _tmp1374 to $t0 from $fp-864
	  lw $t2, 0($t0) 	# load with offset
	  sw $t2, -876($fp)	# spill _tmp1377 from $t2 to $fp-876
	# _tmp1378 = _tmp1375 < _tmp1376
	  lw $t0, -868($fp)	# fill _tmp1375 to $t0 from $fp-868
	  lw $t1, -872($fp)	# fill _tmp1376 to $t1 from $fp-872
	  slt $t2, $t0, $t1	
	  sw $t2, -880($fp)	# spill _tmp1378 from $t2 to $fp-880
	# _tmp1379 = _tmp1377 < _tmp1375
	  lw $t0, -876($fp)	# fill _tmp1377 to $t0 from $fp-876
	  lw $t1, -868($fp)	# fill _tmp1375 to $t1 from $fp-868
	  slt $t2, $t0, $t1	
	  sw $t2, -884($fp)	# spill _tmp1379 from $t2 to $fp-884
	# _tmp1380 = _tmp1377 == _tmp1375
	  lw $t0, -876($fp)	# fill _tmp1377 to $t0 from $fp-876
	  lw $t1, -868($fp)	# fill _tmp1375 to $t1 from $fp-868
	  seq $t2, $t0, $t1	
	  sw $t2, -888($fp)	# spill _tmp1380 from $t2 to $fp-888
	# _tmp1381 = _tmp1379 || _tmp1380
	  lw $t0, -884($fp)	# fill _tmp1379 to $t0 from $fp-884
	  lw $t1, -888($fp)	# fill _tmp1380 to $t1 from $fp-888
	  or $t2, $t0, $t1	
	  sw $t2, -892($fp)	# spill _tmp1381 from $t2 to $fp-892
	# _tmp1382 = _tmp1381 || _tmp1378
	  lw $t0, -892($fp)	# fill _tmp1381 to $t0 from $fp-892
	  lw $t1, -880($fp)	# fill _tmp1378 to $t1 from $fp-880
	  or $t2, $t0, $t1	
	  sw $t2, -896($fp)	# spill _tmp1382 from $t2 to $fp-896
	# IfZ _tmp1382 Goto _L135
	  lw $t0, -896($fp)	# fill _tmp1382 to $t0 from $fp-896
	  beqz $t0, _L135	# branch if _tmp1382 is zero 
	# _tmp1383 = "Decaf runtime error: Array subscript out of bound..."
	  .data			# create string constant marked with label
	  _string91: .asciiz "Decaf runtime error: Array subscript out of bounds\n"
	  .text
	  la $t2, _string91	# load label
	  sw $t2, -900($fp)	# spill _tmp1383 from $t2 to $fp-900
	# PushParam _tmp1383
	  subu $sp, $sp, 4	# decrement sp to make space for param
	  lw $t0, -900($fp)	# fill _tmp1383 to $t0 from $fp-900
	  sw $t0, 4($sp)	# copy param value to stack
	# LCall _PrintString
	  jal _PrintString   	# jump to function
	# PopParams 4
	  add $sp, $sp, 4	# pop params off stack
	# LCall _Halt
	  jal _Halt          	# jump to function
  _L135:
	# _tmp1384 = 4
	  li $t2, 4		# load constant value 4 into $t2
	  sw $t2, -904($fp)	# spill _tmp1384 from $t2 to $fp-904
	# _tmp1385 = _tmp1375 * _tmp1384
	  lw $t0, -868($fp)	# fill _tmp1375 to $t0 from $fp-868
	  lw $t1, -904($fp)	# fill _tmp1384 to $t1 from $fp-904
	  mul $t2, $t0, $t1	
	  sw $t2, -908($fp)	# spill _tmp1385 from $t2 to $fp-908
	# _tmp1386 = _tmp1385 + _tmp1384
	  lw $t0, -908($fp)	# fill _tmp1385 to $t0 from $fp-908
	  lw $t1, -904($fp)	# fill _tmp1384 to $t1 from $fp-904
	  add $t2, $t0, $t1	
	  sw $t2, -912($fp)	# spill _tmp1386 from $t2 to $fp-912
	# _tmp1387 = _tmp1374 + _tmp1386
	  lw $t0, -864($fp)	# fill _tmp1374 to $t0 from $fp-864
	  lw $t1, -912($fp)	# fill _tmp1386 to $t1 from $fp-912
	  add $t2, $t0, $t1	
	  sw $t2, -916($fp)	# spill _tmp1387 from $t2 to $fp-916
	# _tmp1388 = *(_tmp1387)
	  lw $t0, -916($fp)	# fill _tmp1387 to $t0 from $fp-916
	  lw $t2, 0($t0) 	# load with offset
	  sw $t2, -920($fp)	# spill _tmp1388 from $t2 to $fp-920
	# _tmp1389 = 0
	  li $t2, 0		# load constant value 0 into $t2
	  sw $t2, -924($fp)	# spill _tmp1389 from $t2 to $fp-924
	# _tmp1390 = 0
	  li $t2, 0		# load constant value 0 into $t2
	  sw $t2, -928($fp)	# spill _tmp1390 from $t2 to $fp-928
	# _tmp1391 = *(_tmp1388)
	  lw $t0, -920($fp)	# fill _tmp1388 to $t0 from $fp-920
	  lw $t2, 0($t0) 	# load with offset
	  sw $t2, -932($fp)	# spill _tmp1391 from $t2 to $fp-932
	# _tmp1392 = _tmp1389 < _tmp1390
	  lw $t0, -924($fp)	# fill _tmp1389 to $t0 from $fp-924
	  lw $t1, -928($fp)	# fill _tmp1390 to $t1 from $fp-928
	  slt $t2, $t0, $t1	
	  sw $t2, -936($fp)	# spill _tmp1392 from $t2 to $fp-936
	# _tmp1393 = _tmp1391 < _tmp1389
	  lw $t0, -932($fp)	# fill _tmp1391 to $t0 from $fp-932
	  lw $t1, -924($fp)	# fill _tmp1389 to $t1 from $fp-924
	  slt $t2, $t0, $t1	
	  sw $t2, -940($fp)	# spill _tmp1393 from $t2 to $fp-940
	# _tmp1394 = _tmp1391 == _tmp1389
	  lw $t0, -932($fp)	# fill _tmp1391 to $t0 from $fp-932
	  lw $t1, -924($fp)	# fill _tmp1389 to $t1 from $fp-924
	  seq $t2, $t0, $t1	
	  sw $t2, -944($fp)	# spill _tmp1394 from $t2 to $fp-944
	# _tmp1395 = _tmp1393 || _tmp1394
	  lw $t0, -940($fp)	# fill _tmp1393 to $t0 from $fp-940
	  lw $t1, -944($fp)	# fill _tmp1394 to $t1 from $fp-944
	  or $t2, $t0, $t1	
	  sw $t2, -948($fp)	# spill _tmp1395 from $t2 to $fp-948
	# _tmp1396 = _tmp1395 || _tmp1392
	  lw $t0, -948($fp)	# fill _tmp1395 to $t0 from $fp-948
	  lw $t1, -936($fp)	# fill _tmp1392 to $t1 from $fp-936
	  or $t2, $t0, $t1	
	  sw $t2, -952($fp)	# spill _tmp1396 from $t2 to $fp-952
	# IfZ _tmp1396 Goto _L136
	  lw $t0, -952($fp)	# fill _tmp1396 to $t0 from $fp-952
	  beqz $t0, _L136	# branch if _tmp1396 is zero 
	# _tmp1397 = "Decaf runtime error: Array subscript out of bound..."
	  .data			# create string constant marked with label
	  _string92: .asciiz "Decaf runtime error: Array subscript out of bounds\n"
	  .text
	  la $t2, _string92	# load label
	  sw $t2, -956($fp)	# spill _tmp1397 from $t2 to $fp-956
	# PushParam _tmp1397
	  subu $sp, $sp, 4	# decrement sp to make space for param
	  lw $t0, -956($fp)	# fill _tmp1397 to $t0 from $fp-956
	  sw $t0, 4($sp)	# copy param value to stack
	# LCall _PrintString
	  jal _PrintString   	# jump to function
	# PopParams 4
	  add $sp, $sp, 4	# pop params off stack
	# LCall _Halt
	  jal _Halt          	# jump to function
  _L136:
	# _tmp1398 = 4
	  li $t2, 4		# load constant value 4 into $t2
	  sw $t2, -960($fp)	# spill _tmp1398 from $t2 to $fp-960
	# _tmp1399 = _tmp1389 * _tmp1398
	  lw $t0, -924($fp)	# fill _tmp1389 to $t0 from $fp-924
	  lw $t1, -960($fp)	# fill _tmp1398 to $t1 from $fp-960
	  mul $t2, $t0, $t1	
	  sw $t2, -964($fp)	# spill _tmp1399 from $t2 to $fp-964
	# _tmp1400 = _tmp1399 + _tmp1398
	  lw $t0, -964($fp)	# fill _tmp1399 to $t0 from $fp-964
	  lw $t1, -960($fp)	# fill _tmp1398 to $t1 from $fp-960
	  add $t2, $t0, $t1	
	  sw $t2, -968($fp)	# spill _tmp1400 from $t2 to $fp-968
	# _tmp1401 = _tmp1388 + _tmp1400
	  lw $t0, -920($fp)	# fill _tmp1388 to $t0 from $fp-920
	  lw $t1, -968($fp)	# fill _tmp1400 to $t1 from $fp-968
	  add $t2, $t0, $t1	
	  sw $t2, -972($fp)	# spill _tmp1401 from $t2 to $fp-972
	# _tmp1402 = *(_tmp1401)
	  lw $t0, -972($fp)	# fill _tmp1401 to $t0 from $fp-972
	  lw $t2, 0($t0) 	# load with offset
	  sw $t2, -976($fp)	# spill _tmp1402 from $t2 to $fp-976
	# PushParam _tmp1402
	  subu $sp, $sp, 4	# decrement sp to make space for param
	  lw $t0, -976($fp)	# fill _tmp1402 to $t0 from $fp-976
	  sw $t0, 4($sp)	# copy param value to stack
	# _tmp1403 = *(_tmp1402)
	  lw $t0, -976($fp)	# fill _tmp1402 to $t0 from $fp-976
	  lw $t2, 0($t0) 	# load with offset
	  sw $t2, -980($fp)	# spill _tmp1403 from $t2 to $fp-980
	# _tmp1404 = *(_tmp1403 + 20)
	  lw $t0, -980($fp)	# fill _tmp1403 to $t0 from $fp-980
	  lw $t2, 20($t0) 	# load with offset
	  sw $t2, -984($fp)	# spill _tmp1404 from $t2 to $fp-984
	# _tmp1405 = ACall _tmp1404
	  lw $t0, -984($fp)	# fill _tmp1404 to $t0 from $fp-984
	  jalr $t0            	# jump to function
	  move $t2, $v0		# copy function return value from $v0
	  sw $t2, -988($fp)	# spill _tmp1405 from $t2 to $fp-988
	# PopParams 8
	  add $sp, $sp, 8	# pop params off stack
	# PushParam enemyMark
	  subu $sp, $sp, 4	# decrement sp to make space for param
	  lw $t0, 8($fp)	# fill enemyMark to $t0 from $fp+8
	  sw $t0, 4($sp)	# copy param value to stack
	# _tmp1406 = *(this + 4)
	  lw $t0, 4($fp)	# fill this to $t0 from $fp+4
	  lw $t2, 4($t0) 	# load with offset
	  sw $t2, -992($fp)	# spill _tmp1406 from $t2 to $fp-992
	# _tmp1407 = 2
	  li $t2, 2		# load constant value 2 into $t2
	  sw $t2, -996($fp)	# spill _tmp1407 from $t2 to $fp-996
	# _tmp1408 = 0
	  li $t2, 0		# load constant value 0 into $t2
	  sw $t2, -1000($fp)	# spill _tmp1408 from $t2 to $fp-1000
	# _tmp1409 = *(_tmp1406)
	  lw $t0, -992($fp)	# fill _tmp1406 to $t0 from $fp-992
	  lw $t2, 0($t0) 	# load with offset
	  sw $t2, -1004($fp)	# spill _tmp1409 from $t2 to $fp-1004
	# _tmp1410 = _tmp1407 < _tmp1408
	  lw $t0, -996($fp)	# fill _tmp1407 to $t0 from $fp-996
	  lw $t1, -1000($fp)	# fill _tmp1408 to $t1 from $fp-1000
	  slt $t2, $t0, $t1	
	  sw $t2, -1008($fp)	# spill _tmp1410 from $t2 to $fp-1008
	# _tmp1411 = _tmp1409 < _tmp1407
	  lw $t0, -1004($fp)	# fill _tmp1409 to $t0 from $fp-1004
	  lw $t1, -996($fp)	# fill _tmp1407 to $t1 from $fp-996
	  slt $t2, $t0, $t1	
	  sw $t2, -1012($fp)	# spill _tmp1411 from $t2 to $fp-1012
	# _tmp1412 = _tmp1409 == _tmp1407
	  lw $t0, -1004($fp)	# fill _tmp1409 to $t0 from $fp-1004
	  lw $t1, -996($fp)	# fill _tmp1407 to $t1 from $fp-996
	  seq $t2, $t0, $t1	
	  sw $t2, -1016($fp)	# spill _tmp1412 from $t2 to $fp-1016
	# _tmp1413 = _tmp1411 || _tmp1412
	  lw $t0, -1012($fp)	# fill _tmp1411 to $t0 from $fp-1012
	  lw $t1, -1016($fp)	# fill _tmp1412 to $t1 from $fp-1016
	  or $t2, $t0, $t1	
	  sw $t2, -1020($fp)	# spill _tmp1413 from $t2 to $fp-1020
	# _tmp1414 = _tmp1413 || _tmp1410
	  lw $t0, -1020($fp)	# fill _tmp1413 to $t0 from $fp-1020
	  lw $t1, -1008($fp)	# fill _tmp1410 to $t1 from $fp-1008
	  or $t2, $t0, $t1	
	  sw $t2, -1024($fp)	# spill _tmp1414 from $t2 to $fp-1024
	# IfZ _tmp1414 Goto _L137
	  lw $t0, -1024($fp)	# fill _tmp1414 to $t0 from $fp-1024
	  beqz $t0, _L137	# branch if _tmp1414 is zero 
	# _tmp1415 = "Decaf runtime error: Array subscript out of bound..."
	  .data			# create string constant marked with label
	  _string93: .asciiz "Decaf runtime error: Array subscript out of bounds\n"
	  .text
	  la $t2, _string93	# load label
	  sw $t2, -1028($fp)	# spill _tmp1415 from $t2 to $fp-1028
	# PushParam _tmp1415
	  subu $sp, $sp, 4	# decrement sp to make space for param
	  lw $t0, -1028($fp)	# fill _tmp1415 to $t0 from $fp-1028
	  sw $t0, 4($sp)	# copy param value to stack
	# LCall _PrintString
	  jal _PrintString   	# jump to function
	# PopParams 4
	  add $sp, $sp, 4	# pop params off stack
	# LCall _Halt
	  jal _Halt          	# jump to function
  _L137:
	# _tmp1416 = 4
	  li $t2, 4		# load constant value 4 into $t2
	  sw $t2, -1032($fp)	# spill _tmp1416 from $t2 to $fp-1032
	# _tmp1417 = _tmp1407 * _tmp1416
	  lw $t0, -996($fp)	# fill _tmp1407 to $t0 from $fp-996
	  lw $t1, -1032($fp)	# fill _tmp1416 to $t1 from $fp-1032
	  mul $t2, $t0, $t1	
	  sw $t2, -1036($fp)	# spill _tmp1417 from $t2 to $fp-1036
	# _tmp1418 = _tmp1417 + _tmp1416
	  lw $t0, -1036($fp)	# fill _tmp1417 to $t0 from $fp-1036
	  lw $t1, -1032($fp)	# fill _tmp1416 to $t1 from $fp-1032
	  add $t2, $t0, $t1	
	  sw $t2, -1040($fp)	# spill _tmp1418 from $t2 to $fp-1040
	# _tmp1419 = _tmp1406 + _tmp1418
	  lw $t0, -992($fp)	# fill _tmp1406 to $t0 from $fp-992
	  lw $t1, -1040($fp)	# fill _tmp1418 to $t1 from $fp-1040
	  add $t2, $t0, $t1	
	  sw $t2, -1044($fp)	# spill _tmp1419 from $t2 to $fp-1044
	# _tmp1420 = *(_tmp1419)
	  lw $t0, -1044($fp)	# fill _tmp1419 to $t0 from $fp-1044
	  lw $t2, 0($t0) 	# load with offset
	  sw $t2, -1048($fp)	# spill _tmp1420 from $t2 to $fp-1048
	# _tmp1421 = 1
	  li $t2, 1		# load constant value 1 into $t2
	  sw $t2, -1052($fp)	# spill _tmp1421 from $t2 to $fp-1052
	# _tmp1422 = 0
	  li $t2, 0		# load constant value 0 into $t2
	  sw $t2, -1056($fp)	# spill _tmp1422 from $t2 to $fp-1056
	# _tmp1423 = *(_tmp1420)
	  lw $t0, -1048($fp)	# fill _tmp1420 to $t0 from $fp-1048
	  lw $t2, 0($t0) 	# load with offset
	  sw $t2, -1060($fp)	# spill _tmp1423 from $t2 to $fp-1060
	# _tmp1424 = _tmp1421 < _tmp1422
	  lw $t0, -1052($fp)	# fill _tmp1421 to $t0 from $fp-1052
	  lw $t1, -1056($fp)	# fill _tmp1422 to $t1 from $fp-1056
	  slt $t2, $t0, $t1	
	  sw $t2, -1064($fp)	# spill _tmp1424 from $t2 to $fp-1064
	# _tmp1425 = _tmp1423 < _tmp1421
	  lw $t0, -1060($fp)	# fill _tmp1423 to $t0 from $fp-1060
	  lw $t1, -1052($fp)	# fill _tmp1421 to $t1 from $fp-1052
	  slt $t2, $t0, $t1	
	  sw $t2, -1068($fp)	# spill _tmp1425 from $t2 to $fp-1068
	# _tmp1426 = _tmp1423 == _tmp1421
	  lw $t0, -1060($fp)	# fill _tmp1423 to $t0 from $fp-1060
	  lw $t1, -1052($fp)	# fill _tmp1421 to $t1 from $fp-1052
	  seq $t2, $t0, $t1	
	  sw $t2, -1072($fp)	# spill _tmp1426 from $t2 to $fp-1072
	# _tmp1427 = _tmp1425 || _tmp1426
	  lw $t0, -1068($fp)	# fill _tmp1425 to $t0 from $fp-1068
	  lw $t1, -1072($fp)	# fill _tmp1426 to $t1 from $fp-1072
	  or $t2, $t0, $t1	
	  sw $t2, -1076($fp)	# spill _tmp1427 from $t2 to $fp-1076
	# _tmp1428 = _tmp1427 || _tmp1424
	  lw $t0, -1076($fp)	# fill _tmp1427 to $t0 from $fp-1076
	  lw $t1, -1064($fp)	# fill _tmp1424 to $t1 from $fp-1064
	  or $t2, $t0, $t1	
	  sw $t2, -1080($fp)	# spill _tmp1428 from $t2 to $fp-1080
	# IfZ _tmp1428 Goto _L138
	  lw $t0, -1080($fp)	# fill _tmp1428 to $t0 from $fp-1080
	  beqz $t0, _L138	# branch if _tmp1428 is zero 
	# _tmp1429 = "Decaf runtime error: Array subscript out of bound..."
	  .data			# create string constant marked with label
	  _string94: .asciiz "Decaf runtime error: Array subscript out of bounds\n"
	  .text
	  la $t2, _string94	# load label
	  sw $t2, -1084($fp)	# spill _tmp1429 from $t2 to $fp-1084
	# PushParam _tmp1429
	  subu $sp, $sp, 4	# decrement sp to make space for param
	  lw $t0, -1084($fp)	# fill _tmp1429 to $t0 from $fp-1084
	  sw $t0, 4($sp)	# copy param value to stack
	# LCall _PrintString
	  jal _PrintString   	# jump to function
	# PopParams 4
	  add $sp, $sp, 4	# pop params off stack
	# LCall _Halt
	  jal _Halt          	# jump to function
  _L138:
	# _tmp1430 = 4
	  li $t2, 4		# load constant value 4 into $t2
	  sw $t2, -1088($fp)	# spill _tmp1430 from $t2 to $fp-1088
	# _tmp1431 = _tmp1421 * _tmp1430
	  lw $t0, -1052($fp)	# fill _tmp1421 to $t0 from $fp-1052
	  lw $t1, -1088($fp)	# fill _tmp1430 to $t1 from $fp-1088
	  mul $t2, $t0, $t1	
	  sw $t2, -1092($fp)	# spill _tmp1431 from $t2 to $fp-1092
	# _tmp1432 = _tmp1431 + _tmp1430
	  lw $t0, -1092($fp)	# fill _tmp1431 to $t0 from $fp-1092
	  lw $t1, -1088($fp)	# fill _tmp1430 to $t1 from $fp-1088
	  add $t2, $t0, $t1	
	  sw $t2, -1096($fp)	# spill _tmp1432 from $t2 to $fp-1096
	# _tmp1433 = _tmp1420 + _tmp1432
	  lw $t0, -1048($fp)	# fill _tmp1420 to $t0 from $fp-1048
	  lw $t1, -1096($fp)	# fill _tmp1432 to $t1 from $fp-1096
	  add $t2, $t0, $t1	
	  sw $t2, -1100($fp)	# spill _tmp1433 from $t2 to $fp-1100
	# _tmp1434 = *(_tmp1433)
	  lw $t0, -1100($fp)	# fill _tmp1433 to $t0 from $fp-1100
	  lw $t2, 0($t0) 	# load with offset
	  sw $t2, -1104($fp)	# spill _tmp1434 from $t2 to $fp-1104
	# PushParam _tmp1434
	  subu $sp, $sp, 4	# decrement sp to make space for param
	  lw $t0, -1104($fp)	# fill _tmp1434 to $t0 from $fp-1104
	  sw $t0, 4($sp)	# copy param value to stack
	# _tmp1435 = *(_tmp1434)
	  lw $t0, -1104($fp)	# fill _tmp1434 to $t0 from $fp-1104
	  lw $t2, 0($t0) 	# load with offset
	  sw $t2, -1108($fp)	# spill _tmp1435 from $t2 to $fp-1108
	# _tmp1436 = *(_tmp1435 + 20)
	  lw $t0, -1108($fp)	# fill _tmp1435 to $t0 from $fp-1108
	  lw $t2, 20($t0) 	# load with offset
	  sw $t2, -1112($fp)	# spill _tmp1436 from $t2 to $fp-1112
	# _tmp1437 = ACall _tmp1436
	  lw $t0, -1112($fp)	# fill _tmp1436 to $t0 from $fp-1112
	  jalr $t0            	# jump to function
	  move $t2, $v0		# copy function return value from $v0
	  sw $t2, -1116($fp)	# spill _tmp1437 from $t2 to $fp-1116
	# PopParams 8
	  add $sp, $sp, 8	# pop params off stack
	# _tmp1438 = _tmp1405 && _tmp1437
	  lw $t0, -988($fp)	# fill _tmp1405 to $t0 from $fp-988
	  lw $t1, -1116($fp)	# fill _tmp1437 to $t1 from $fp-1116
	  and $t2, $t0, $t1	
	  sw $t2, -1120($fp)	# spill _tmp1438 from $t2 to $fp-1120
	# PushParam playerMark
	  subu $sp, $sp, 4	# decrement sp to make space for param
	  lw $t0, 12($fp)	# fill playerMark to $t0 from $fp+12
	  sw $t0, 4($sp)	# copy param value to stack
	# _tmp1440 = *(this + 4)
	  lw $t0, 4($fp)	# fill this to $t0 from $fp+4
	  lw $t2, 4($t0) 	# load with offset
	  sw $t2, -1128($fp)	# spill _tmp1440 from $t2 to $fp-1128
	# _tmp1441 = 2
	  li $t2, 2		# load constant value 2 into $t2
	  sw $t2, -1132($fp)	# spill _tmp1441 from $t2 to $fp-1132
	# _tmp1442 = 0
	  li $t2, 0		# load constant value 0 into $t2
	  sw $t2, -1136($fp)	# spill _tmp1442 from $t2 to $fp-1136
	# _tmp1443 = *(_tmp1440)
	  lw $t0, -1128($fp)	# fill _tmp1440 to $t0 from $fp-1128
	  lw $t2, 0($t0) 	# load with offset
	  sw $t2, -1140($fp)	# spill _tmp1443 from $t2 to $fp-1140
	# _tmp1444 = _tmp1441 < _tmp1442
	  lw $t0, -1132($fp)	# fill _tmp1441 to $t0 from $fp-1132
	  lw $t1, -1136($fp)	# fill _tmp1442 to $t1 from $fp-1136
	  slt $t2, $t0, $t1	
	  sw $t2, -1144($fp)	# spill _tmp1444 from $t2 to $fp-1144
	# _tmp1445 = _tmp1443 < _tmp1441
	  lw $t0, -1140($fp)	# fill _tmp1443 to $t0 from $fp-1140
	  lw $t1, -1132($fp)	# fill _tmp1441 to $t1 from $fp-1132
	  slt $t2, $t0, $t1	
	  sw $t2, -1148($fp)	# spill _tmp1445 from $t2 to $fp-1148
	# _tmp1446 = _tmp1443 == _tmp1441
	  lw $t0, -1140($fp)	# fill _tmp1443 to $t0 from $fp-1140
	  lw $t1, -1132($fp)	# fill _tmp1441 to $t1 from $fp-1132
	  seq $t2, $t0, $t1	
	  sw $t2, -1152($fp)	# spill _tmp1446 from $t2 to $fp-1152
	# _tmp1447 = _tmp1445 || _tmp1446
	  lw $t0, -1148($fp)	# fill _tmp1445 to $t0 from $fp-1148
	  lw $t1, -1152($fp)	# fill _tmp1446 to $t1 from $fp-1152
	  or $t2, $t0, $t1	
	  sw $t2, -1156($fp)	# spill _tmp1447 from $t2 to $fp-1156
	# _tmp1448 = _tmp1447 || _tmp1444
	  lw $t0, -1156($fp)	# fill _tmp1447 to $t0 from $fp-1156
	  lw $t1, -1144($fp)	# fill _tmp1444 to $t1 from $fp-1144
	  or $t2, $t0, $t1	
	  sw $t2, -1160($fp)	# spill _tmp1448 from $t2 to $fp-1160
	# IfZ _tmp1448 Goto _L141
	  lw $t0, -1160($fp)	# fill _tmp1448 to $t0 from $fp-1160
	  beqz $t0, _L141	# branch if _tmp1448 is zero 
	# _tmp1449 = "Decaf runtime error: Array subscript out of bound..."
	  .data			# create string constant marked with label
	  _string95: .asciiz "Decaf runtime error: Array subscript out of bounds\n"
	  .text
	  la $t2, _string95	# load label
	  sw $t2, -1164($fp)	# spill _tmp1449 from $t2 to $fp-1164
	# PushParam _tmp1449
	  subu $sp, $sp, 4	# decrement sp to make space for param
	  lw $t0, -1164($fp)	# fill _tmp1449 to $t0 from $fp-1164
	  sw $t0, 4($sp)	# copy param value to stack
	# LCall _PrintString
	  jal _PrintString   	# jump to function
	# PopParams 4
	  add $sp, $sp, 4	# pop params off stack
	# LCall _Halt
	  jal _Halt          	# jump to function
  _L141:
	# _tmp1450 = 4
	  li $t2, 4		# load constant value 4 into $t2
	  sw $t2, -1168($fp)	# spill _tmp1450 from $t2 to $fp-1168
	# _tmp1451 = _tmp1441 * _tmp1450
	  lw $t0, -1132($fp)	# fill _tmp1441 to $t0 from $fp-1132
	  lw $t1, -1168($fp)	# fill _tmp1450 to $t1 from $fp-1168
	  mul $t2, $t0, $t1	
	  sw $t2, -1172($fp)	# spill _tmp1451 from $t2 to $fp-1172
	# _tmp1452 = _tmp1451 + _tmp1450
	  lw $t0, -1172($fp)	# fill _tmp1451 to $t0 from $fp-1172
	  lw $t1, -1168($fp)	# fill _tmp1450 to $t1 from $fp-1168
	  add $t2, $t0, $t1	
	  sw $t2, -1176($fp)	# spill _tmp1452 from $t2 to $fp-1176
	# _tmp1453 = _tmp1440 + _tmp1452
	  lw $t0, -1128($fp)	# fill _tmp1440 to $t0 from $fp-1128
	  lw $t1, -1176($fp)	# fill _tmp1452 to $t1 from $fp-1176
	  add $t2, $t0, $t1	
	  sw $t2, -1180($fp)	# spill _tmp1453 from $t2 to $fp-1180
	# _tmp1454 = *(_tmp1453)
	  lw $t0, -1180($fp)	# fill _tmp1453 to $t0 from $fp-1180
	  lw $t2, 0($t0) 	# load with offset
	  sw $t2, -1184($fp)	# spill _tmp1454 from $t2 to $fp-1184
	# _tmp1455 = 2
	  li $t2, 2		# load constant value 2 into $t2
	  sw $t2, -1188($fp)	# spill _tmp1455 from $t2 to $fp-1188
	# _tmp1456 = 0
	  li $t2, 0		# load constant value 0 into $t2
	  sw $t2, -1192($fp)	# spill _tmp1456 from $t2 to $fp-1192
	# _tmp1457 = *(_tmp1454)
	  lw $t0, -1184($fp)	# fill _tmp1454 to $t0 from $fp-1184
	  lw $t2, 0($t0) 	# load with offset
	  sw $t2, -1196($fp)	# spill _tmp1457 from $t2 to $fp-1196
	# _tmp1458 = _tmp1455 < _tmp1456
	  lw $t0, -1188($fp)	# fill _tmp1455 to $t0 from $fp-1188
	  lw $t1, -1192($fp)	# fill _tmp1456 to $t1 from $fp-1192
	  slt $t2, $t0, $t1	
	  sw $t2, -1200($fp)	# spill _tmp1458 from $t2 to $fp-1200
	# _tmp1459 = _tmp1457 < _tmp1455
	  lw $t0, -1196($fp)	# fill _tmp1457 to $t0 from $fp-1196
	  lw $t1, -1188($fp)	# fill _tmp1455 to $t1 from $fp-1188
	  slt $t2, $t0, $t1	
	  sw $t2, -1204($fp)	# spill _tmp1459 from $t2 to $fp-1204
	# _tmp1460 = _tmp1457 == _tmp1455
	  lw $t0, -1196($fp)	# fill _tmp1457 to $t0 from $fp-1196
	  lw $t1, -1188($fp)	# fill _tmp1455 to $t1 from $fp-1188
	  seq $t2, $t0, $t1	
	  sw $t2, -1208($fp)	# spill _tmp1460 from $t2 to $fp-1208
	# _tmp1461 = _tmp1459 || _tmp1460
	  lw $t0, -1204($fp)	# fill _tmp1459 to $t0 from $fp-1204
	  lw $t1, -1208($fp)	# fill _tmp1460 to $t1 from $fp-1208
	  or $t2, $t0, $t1	
	  sw $t2, -1212($fp)	# spill _tmp1461 from $t2 to $fp-1212
	# _tmp1462 = _tmp1461 || _tmp1458
	  lw $t0, -1212($fp)	# fill _tmp1461 to $t0 from $fp-1212
	  lw $t1, -1200($fp)	# fill _tmp1458 to $t1 from $fp-1200
	  or $t2, $t0, $t1	
	  sw $t2, -1216($fp)	# spill _tmp1462 from $t2 to $fp-1216
	# IfZ _tmp1462 Goto _L142
	  lw $t0, -1216($fp)	# fill _tmp1462 to $t0 from $fp-1216
	  beqz $t0, _L142	# branch if _tmp1462 is zero 
	# _tmp1463 = "Decaf runtime error: Array subscript out of bound..."
	  .data			# create string constant marked with label
	  _string96: .asciiz "Decaf runtime error: Array subscript out of bounds\n"
	  .text
	  la $t2, _string96	# load label
	  sw $t2, -1220($fp)	# spill _tmp1463 from $t2 to $fp-1220
	# PushParam _tmp1463
	  subu $sp, $sp, 4	# decrement sp to make space for param
	  lw $t0, -1220($fp)	# fill _tmp1463 to $t0 from $fp-1220
	  sw $t0, 4($sp)	# copy param value to stack
	# LCall _PrintString
	  jal _PrintString   	# jump to function
	# PopParams 4
	  add $sp, $sp, 4	# pop params off stack
	# LCall _Halt
	  jal _Halt          	# jump to function
  _L142:
	# _tmp1464 = 4
	  li $t2, 4		# load constant value 4 into $t2
	  sw $t2, -1224($fp)	# spill _tmp1464 from $t2 to $fp-1224
	# _tmp1465 = _tmp1455 * _tmp1464
	  lw $t0, -1188($fp)	# fill _tmp1455 to $t0 from $fp-1188
	  lw $t1, -1224($fp)	# fill _tmp1464 to $t1 from $fp-1224
	  mul $t2, $t0, $t1	
	  sw $t2, -1228($fp)	# spill _tmp1465 from $t2 to $fp-1228
	# _tmp1466 = _tmp1465 + _tmp1464
	  lw $t0, -1228($fp)	# fill _tmp1465 to $t0 from $fp-1228
	  lw $t1, -1224($fp)	# fill _tmp1464 to $t1 from $fp-1224
	  add $t2, $t0, $t1	
	  sw $t2, -1232($fp)	# spill _tmp1466 from $t2 to $fp-1232
	# _tmp1467 = _tmp1454 + _tmp1466
	  lw $t0, -1184($fp)	# fill _tmp1454 to $t0 from $fp-1184
	  lw $t1, -1232($fp)	# fill _tmp1466 to $t1 from $fp-1232
	  add $t2, $t0, $t1	
	  sw $t2, -1236($fp)	# spill _tmp1467 from $t2 to $fp-1236
	# _tmp1468 = *(_tmp1467)
	  lw $t0, -1236($fp)	# fill _tmp1467 to $t0 from $fp-1236
	  lw $t2, 0($t0) 	# load with offset
	  sw $t2, -1240($fp)	# spill _tmp1468 from $t2 to $fp-1240
	# PushParam _tmp1468
	  subu $sp, $sp, 4	# decrement sp to make space for param
	  lw $t0, -1240($fp)	# fill _tmp1468 to $t0 from $fp-1240
	  sw $t0, 4($sp)	# copy param value to stack
	# _tmp1469 = *(_tmp1468)
	  lw $t0, -1240($fp)	# fill _tmp1468 to $t0 from $fp-1240
	  lw $t2, 0($t0) 	# load with offset
	  sw $t2, -1244($fp)	# spill _tmp1469 from $t2 to $fp-1244
	# _tmp1470 = *(_tmp1469 + 20)
	  lw $t0, -1244($fp)	# fill _tmp1469 to $t0 from $fp-1244
	  lw $t2, 20($t0) 	# load with offset
	  sw $t2, -1248($fp)	# spill _tmp1470 from $t2 to $fp-1248
	# _tmp1471 = ACall _tmp1470
	  lw $t0, -1248($fp)	# fill _tmp1470 to $t0 from $fp-1248
	  jalr $t0            	# jump to function
	  move $t2, $v0		# copy function return value from $v0
	  sw $t2, -1252($fp)	# spill _tmp1471 from $t2 to $fp-1252
	# PopParams 8
	  add $sp, $sp, 8	# pop params off stack
	# IfZ _tmp1471 Goto _L140
	  lw $t0, -1252($fp)	# fill _tmp1471 to $t0 from $fp-1252
	  beqz $t0, _L140	# branch if _tmp1471 is zero 
	# _tmp1472 = 0
	  li $t2, 0		# load constant value 0 into $t2
	  sw $t2, -1256($fp)	# spill _tmp1472 from $t2 to $fp-1256
	# _tmp1439 = _tmp1472
	  lw $t2, -1256($fp)	# fill _tmp1472 to $t2 from $fp-1256
	  sw $t2, -1124($fp)	# spill _tmp1439 from $t2 to $fp-1124
	# Goto _L139
	  b _L139		# unconditional branch
  _L140:
	# _tmp1473 = 1
	  li $t2, 1		# load constant value 1 into $t2
	  sw $t2, -1260($fp)	# spill _tmp1473 from $t2 to $fp-1260
	# _tmp1439 = _tmp1473
	  lw $t2, -1260($fp)	# fill _tmp1473 to $t2 from $fp-1260
	  sw $t2, -1124($fp)	# spill _tmp1439 from $t2 to $fp-1124
  _L139:
	# _tmp1474 = _tmp1438 && _tmp1439
	  lw $t0, -1120($fp)	# fill _tmp1438 to $t0 from $fp-1120
	  lw $t1, -1124($fp)	# fill _tmp1439 to $t1 from $fp-1124
	  and $t2, $t0, $t1	
	  sw $t2, -1264($fp)	# spill _tmp1474 from $t2 to $fp-1264
	# IfZ _tmp1474 Goto _L133
	  lw $t0, -1264($fp)	# fill _tmp1474 to $t0 from $fp-1264
	  beqz $t0, _L133	# branch if _tmp1474 is zero 
	# _tmp1475 = 2
	  li $t2, 2		# load constant value 2 into $t2
	  sw $t2, -1268($fp)	# spill _tmp1475 from $t2 to $fp-1268
	# row = _tmp1475
	  lw $t2, -1268($fp)	# fill _tmp1475 to $t2 from $fp-1268
	  sw $t2, -8($fp)	# spill row from $t2 to $fp-8
	# _tmp1476 = 2
	  li $t2, 2		# load constant value 2 into $t2
	  sw $t2, -1272($fp)	# spill _tmp1476 from $t2 to $fp-1272
	# column = _tmp1476
	  lw $t2, -1272($fp)	# fill _tmp1476 to $t2 from $fp-1272
	  sw $t2, -12($fp)	# spill column from $t2 to $fp-12
	# Goto _L134
	  b _L134		# unconditional branch
  _L133:
	# PushParam enemyMark
	  subu $sp, $sp, 4	# decrement sp to make space for param
	  lw $t0, 8($fp)	# fill enemyMark to $t0 from $fp+8
	  sw $t0, 4($sp)	# copy param value to stack
	# _tmp1477 = *(this + 4)
	  lw $t0, 4($fp)	# fill this to $t0 from $fp+4
	  lw $t2, 4($t0) 	# load with offset
	  sw $t2, -1276($fp)	# spill _tmp1477 from $t2 to $fp-1276
	# _tmp1478 = 0
	  li $t2, 0		# load constant value 0 into $t2
	  sw $t2, -1280($fp)	# spill _tmp1478 from $t2 to $fp-1280
	# _tmp1479 = 0
	  li $t2, 0		# load constant value 0 into $t2
	  sw $t2, -1284($fp)	# spill _tmp1479 from $t2 to $fp-1284
	# _tmp1480 = *(_tmp1477)
	  lw $t0, -1276($fp)	# fill _tmp1477 to $t0 from $fp-1276
	  lw $t2, 0($t0) 	# load with offset
	  sw $t2, -1288($fp)	# spill _tmp1480 from $t2 to $fp-1288
	# _tmp1481 = _tmp1478 < _tmp1479
	  lw $t0, -1280($fp)	# fill _tmp1478 to $t0 from $fp-1280
	  lw $t1, -1284($fp)	# fill _tmp1479 to $t1 from $fp-1284
	  slt $t2, $t0, $t1	
	  sw $t2, -1292($fp)	# spill _tmp1481 from $t2 to $fp-1292
	# _tmp1482 = _tmp1480 < _tmp1478
	  lw $t0, -1288($fp)	# fill _tmp1480 to $t0 from $fp-1288
	  lw $t1, -1280($fp)	# fill _tmp1478 to $t1 from $fp-1280
	  slt $t2, $t0, $t1	
	  sw $t2, -1296($fp)	# spill _tmp1482 from $t2 to $fp-1296
	# _tmp1483 = _tmp1480 == _tmp1478
	  lw $t0, -1288($fp)	# fill _tmp1480 to $t0 from $fp-1288
	  lw $t1, -1280($fp)	# fill _tmp1478 to $t1 from $fp-1280
	  seq $t2, $t0, $t1	
	  sw $t2, -1300($fp)	# spill _tmp1483 from $t2 to $fp-1300
	# _tmp1484 = _tmp1482 || _tmp1483
	  lw $t0, -1296($fp)	# fill _tmp1482 to $t0 from $fp-1296
	  lw $t1, -1300($fp)	# fill _tmp1483 to $t1 from $fp-1300
	  or $t2, $t0, $t1	
	  sw $t2, -1304($fp)	# spill _tmp1484 from $t2 to $fp-1304
	# _tmp1485 = _tmp1484 || _tmp1481
	  lw $t0, -1304($fp)	# fill _tmp1484 to $t0 from $fp-1304
	  lw $t1, -1292($fp)	# fill _tmp1481 to $t1 from $fp-1292
	  or $t2, $t0, $t1	
	  sw $t2, -1308($fp)	# spill _tmp1485 from $t2 to $fp-1308
	# IfZ _tmp1485 Goto _L145
	  lw $t0, -1308($fp)	# fill _tmp1485 to $t0 from $fp-1308
	  beqz $t0, _L145	# branch if _tmp1485 is zero 
	# _tmp1486 = "Decaf runtime error: Array subscript out of bound..."
	  .data			# create string constant marked with label
	  _string97: .asciiz "Decaf runtime error: Array subscript out of bounds\n"
	  .text
	  la $t2, _string97	# load label
	  sw $t2, -1312($fp)	# spill _tmp1486 from $t2 to $fp-1312
	# PushParam _tmp1486
	  subu $sp, $sp, 4	# decrement sp to make space for param
	  lw $t0, -1312($fp)	# fill _tmp1486 to $t0 from $fp-1312
	  sw $t0, 4($sp)	# copy param value to stack
	# LCall _PrintString
	  jal _PrintString   	# jump to function
	# PopParams 4
	  add $sp, $sp, 4	# pop params off stack
	# LCall _Halt
	  jal _Halt          	# jump to function
  _L145:
	# _tmp1487 = 4
	  li $t2, 4		# load constant value 4 into $t2
	  sw $t2, -1316($fp)	# spill _tmp1487 from $t2 to $fp-1316
	# _tmp1488 = _tmp1478 * _tmp1487
	  lw $t0, -1280($fp)	# fill _tmp1478 to $t0 from $fp-1280
	  lw $t1, -1316($fp)	# fill _tmp1487 to $t1 from $fp-1316
	  mul $t2, $t0, $t1	
	  sw $t2, -1320($fp)	# spill _tmp1488 from $t2 to $fp-1320
	# _tmp1489 = _tmp1488 + _tmp1487
	  lw $t0, -1320($fp)	# fill _tmp1488 to $t0 from $fp-1320
	  lw $t1, -1316($fp)	# fill _tmp1487 to $t1 from $fp-1316
	  add $t2, $t0, $t1	
	  sw $t2, -1324($fp)	# spill _tmp1489 from $t2 to $fp-1324
	# _tmp1490 = _tmp1477 + _tmp1489
	  lw $t0, -1276($fp)	# fill _tmp1477 to $t0 from $fp-1276
	  lw $t1, -1324($fp)	# fill _tmp1489 to $t1 from $fp-1324
	  add $t2, $t0, $t1	
	  sw $t2, -1328($fp)	# spill _tmp1490 from $t2 to $fp-1328
	# _tmp1491 = *(_tmp1490)
	  lw $t0, -1328($fp)	# fill _tmp1490 to $t0 from $fp-1328
	  lw $t2, 0($t0) 	# load with offset
	  sw $t2, -1332($fp)	# spill _tmp1491 from $t2 to $fp-1332
	# _tmp1492 = 1
	  li $t2, 1		# load constant value 1 into $t2
	  sw $t2, -1336($fp)	# spill _tmp1492 from $t2 to $fp-1336
	# _tmp1493 = 0
	  li $t2, 0		# load constant value 0 into $t2
	  sw $t2, -1340($fp)	# spill _tmp1493 from $t2 to $fp-1340
	# _tmp1494 = *(_tmp1491)
	  lw $t0, -1332($fp)	# fill _tmp1491 to $t0 from $fp-1332
	  lw $t2, 0($t0) 	# load with offset
	  sw $t2, -1344($fp)	# spill _tmp1494 from $t2 to $fp-1344
	# _tmp1495 = _tmp1492 < _tmp1493
	  lw $t0, -1336($fp)	# fill _tmp1492 to $t0 from $fp-1336
	  lw $t1, -1340($fp)	# fill _tmp1493 to $t1 from $fp-1340
	  slt $t2, $t0, $t1	
	  sw $t2, -1348($fp)	# spill _tmp1495 from $t2 to $fp-1348
	# _tmp1496 = _tmp1494 < _tmp1492
	  lw $t0, -1344($fp)	# fill _tmp1494 to $t0 from $fp-1344
	  lw $t1, -1336($fp)	# fill _tmp1492 to $t1 from $fp-1336
	  slt $t2, $t0, $t1	
	  sw $t2, -1352($fp)	# spill _tmp1496 from $t2 to $fp-1352
	# _tmp1497 = _tmp1494 == _tmp1492
	  lw $t0, -1344($fp)	# fill _tmp1494 to $t0 from $fp-1344
	  lw $t1, -1336($fp)	# fill _tmp1492 to $t1 from $fp-1336
	  seq $t2, $t0, $t1	
	  sw $t2, -1356($fp)	# spill _tmp1497 from $t2 to $fp-1356
	# _tmp1498 = _tmp1496 || _tmp1497
	  lw $t0, -1352($fp)	# fill _tmp1496 to $t0 from $fp-1352
	  lw $t1, -1356($fp)	# fill _tmp1497 to $t1 from $fp-1356
	  or $t2, $t0, $t1	
	  sw $t2, -1360($fp)	# spill _tmp1498 from $t2 to $fp-1360
	# _tmp1499 = _tmp1498 || _tmp1495
	  lw $t0, -1360($fp)	# fill _tmp1498 to $t0 from $fp-1360
	  lw $t1, -1348($fp)	# fill _tmp1495 to $t1 from $fp-1348
	  or $t2, $t0, $t1	
	  sw $t2, -1364($fp)	# spill _tmp1499 from $t2 to $fp-1364
	# IfZ _tmp1499 Goto _L146
	  lw $t0, -1364($fp)	# fill _tmp1499 to $t0 from $fp-1364
	  beqz $t0, _L146	# branch if _tmp1499 is zero 
	# _tmp1500 = "Decaf runtime error: Array subscript out of bound..."
	  .data			# create string constant marked with label
	  _string98: .asciiz "Decaf runtime error: Array subscript out of bounds\n"
	  .text
	  la $t2, _string98	# load label
	  sw $t2, -1368($fp)	# spill _tmp1500 from $t2 to $fp-1368
	# PushParam _tmp1500
	  subu $sp, $sp, 4	# decrement sp to make space for param
	  lw $t0, -1368($fp)	# fill _tmp1500 to $t0 from $fp-1368
	  sw $t0, 4($sp)	# copy param value to stack
	# LCall _PrintString
	  jal _PrintString   	# jump to function
	# PopParams 4
	  add $sp, $sp, 4	# pop params off stack
	# LCall _Halt
	  jal _Halt          	# jump to function
  _L146:
	# _tmp1501 = 4
	  li $t2, 4		# load constant value 4 into $t2
	  sw $t2, -1372($fp)	# spill _tmp1501 from $t2 to $fp-1372
	# _tmp1502 = _tmp1492 * _tmp1501
	  lw $t0, -1336($fp)	# fill _tmp1492 to $t0 from $fp-1336
	  lw $t1, -1372($fp)	# fill _tmp1501 to $t1 from $fp-1372
	  mul $t2, $t0, $t1	
	  sw $t2, -1376($fp)	# spill _tmp1502 from $t2 to $fp-1376
	# _tmp1503 = _tmp1502 + _tmp1501
	  lw $t0, -1376($fp)	# fill _tmp1502 to $t0 from $fp-1376
	  lw $t1, -1372($fp)	# fill _tmp1501 to $t1 from $fp-1372
	  add $t2, $t0, $t1	
	  sw $t2, -1380($fp)	# spill _tmp1503 from $t2 to $fp-1380
	# _tmp1504 = _tmp1491 + _tmp1503
	  lw $t0, -1332($fp)	# fill _tmp1491 to $t0 from $fp-1332
	  lw $t1, -1380($fp)	# fill _tmp1503 to $t1 from $fp-1380
	  add $t2, $t0, $t1	
	  sw $t2, -1384($fp)	# spill _tmp1504 from $t2 to $fp-1384
	# _tmp1505 = *(_tmp1504)
	  lw $t0, -1384($fp)	# fill _tmp1504 to $t0 from $fp-1384
	  lw $t2, 0($t0) 	# load with offset
	  sw $t2, -1388($fp)	# spill _tmp1505 from $t2 to $fp-1388
	# PushParam _tmp1505
	  subu $sp, $sp, 4	# decrement sp to make space for param
	  lw $t0, -1388($fp)	# fill _tmp1505 to $t0 from $fp-1388
	  sw $t0, 4($sp)	# copy param value to stack
	# _tmp1506 = *(_tmp1505)
	  lw $t0, -1388($fp)	# fill _tmp1505 to $t0 from $fp-1388
	  lw $t2, 0($t0) 	# load with offset
	  sw $t2, -1392($fp)	# spill _tmp1506 from $t2 to $fp-1392
	# _tmp1507 = *(_tmp1506 + 20)
	  lw $t0, -1392($fp)	# fill _tmp1506 to $t0 from $fp-1392
	  lw $t2, 20($t0) 	# load with offset
	  sw $t2, -1396($fp)	# spill _tmp1507 from $t2 to $fp-1396
	# _tmp1508 = ACall _tmp1507
	  lw $t0, -1396($fp)	# fill _tmp1507 to $t0 from $fp-1396
	  jalr $t0            	# jump to function
	  move $t2, $v0		# copy function return value from $v0
	  sw $t2, -1400($fp)	# spill _tmp1508 from $t2 to $fp-1400
	# PopParams 8
	  add $sp, $sp, 8	# pop params off stack
	# PushParam enemyMark
	  subu $sp, $sp, 4	# decrement sp to make space for param
	  lw $t0, 8($fp)	# fill enemyMark to $t0 from $fp+8
	  sw $t0, 4($sp)	# copy param value to stack
	# _tmp1509 = *(this + 4)
	  lw $t0, 4($fp)	# fill this to $t0 from $fp+4
	  lw $t2, 4($t0) 	# load with offset
	  sw $t2, -1404($fp)	# spill _tmp1509 from $t2 to $fp-1404
	# _tmp1510 = 0
	  li $t2, 0		# load constant value 0 into $t2
	  sw $t2, -1408($fp)	# spill _tmp1510 from $t2 to $fp-1408
	# _tmp1511 = 0
	  li $t2, 0		# load constant value 0 into $t2
	  sw $t2, -1412($fp)	# spill _tmp1511 from $t2 to $fp-1412
	# _tmp1512 = *(_tmp1509)
	  lw $t0, -1404($fp)	# fill _tmp1509 to $t0 from $fp-1404
	  lw $t2, 0($t0) 	# load with offset
	  sw $t2, -1416($fp)	# spill _tmp1512 from $t2 to $fp-1416
	# _tmp1513 = _tmp1510 < _tmp1511
	  lw $t0, -1408($fp)	# fill _tmp1510 to $t0 from $fp-1408
	  lw $t1, -1412($fp)	# fill _tmp1511 to $t1 from $fp-1412
	  slt $t2, $t0, $t1	
	  sw $t2, -1420($fp)	# spill _tmp1513 from $t2 to $fp-1420
	# _tmp1514 = _tmp1512 < _tmp1510
	  lw $t0, -1416($fp)	# fill _tmp1512 to $t0 from $fp-1416
	  lw $t1, -1408($fp)	# fill _tmp1510 to $t1 from $fp-1408
	  slt $t2, $t0, $t1	
	  sw $t2, -1424($fp)	# spill _tmp1514 from $t2 to $fp-1424
	# _tmp1515 = _tmp1512 == _tmp1510
	  lw $t0, -1416($fp)	# fill _tmp1512 to $t0 from $fp-1416
	  lw $t1, -1408($fp)	# fill _tmp1510 to $t1 from $fp-1408
	  seq $t2, $t0, $t1	
	  sw $t2, -1428($fp)	# spill _tmp1515 from $t2 to $fp-1428
	# _tmp1516 = _tmp1514 || _tmp1515
	  lw $t0, -1424($fp)	# fill _tmp1514 to $t0 from $fp-1424
	  lw $t1, -1428($fp)	# fill _tmp1515 to $t1 from $fp-1428
	  or $t2, $t0, $t1	
	  sw $t2, -1432($fp)	# spill _tmp1516 from $t2 to $fp-1432
	# _tmp1517 = _tmp1516 || _tmp1513
	  lw $t0, -1432($fp)	# fill _tmp1516 to $t0 from $fp-1432
	  lw $t1, -1420($fp)	# fill _tmp1513 to $t1 from $fp-1420
	  or $t2, $t0, $t1	
	  sw $t2, -1436($fp)	# spill _tmp1517 from $t2 to $fp-1436
	# IfZ _tmp1517 Goto _L147
	  lw $t0, -1436($fp)	# fill _tmp1517 to $t0 from $fp-1436
	  beqz $t0, _L147	# branch if _tmp1517 is zero 
	# _tmp1518 = "Decaf runtime error: Array subscript out of bound..."
	  .data			# create string constant marked with label
	  _string99: .asciiz "Decaf runtime error: Array subscript out of bounds\n"
	  .text
	  la $t2, _string99	# load label
	  sw $t2, -1440($fp)	# spill _tmp1518 from $t2 to $fp-1440
	# PushParam _tmp1518
	  subu $sp, $sp, 4	# decrement sp to make space for param
	  lw $t0, -1440($fp)	# fill _tmp1518 to $t0 from $fp-1440
	  sw $t0, 4($sp)	# copy param value to stack
	# LCall _PrintString
	  jal _PrintString   	# jump to function
	# PopParams 4
	  add $sp, $sp, 4	# pop params off stack
	# LCall _Halt
	  jal _Halt          	# jump to function
  _L147:
	# _tmp1519 = 4
	  li $t2, 4		# load constant value 4 into $t2
	  sw $t2, -1444($fp)	# spill _tmp1519 from $t2 to $fp-1444
	# _tmp1520 = _tmp1510 * _tmp1519
	  lw $t0, -1408($fp)	# fill _tmp1510 to $t0 from $fp-1408
	  lw $t1, -1444($fp)	# fill _tmp1519 to $t1 from $fp-1444
	  mul $t2, $t0, $t1	
	  sw $t2, -1448($fp)	# spill _tmp1520 from $t2 to $fp-1448
	# _tmp1521 = _tmp1520 + _tmp1519
	  lw $t0, -1448($fp)	# fill _tmp1520 to $t0 from $fp-1448
	  lw $t1, -1444($fp)	# fill _tmp1519 to $t1 from $fp-1444
	  add $t2, $t0, $t1	
	  sw $t2, -1452($fp)	# spill _tmp1521 from $t2 to $fp-1452
	# _tmp1522 = _tmp1509 + _tmp1521
	  lw $t0, -1404($fp)	# fill _tmp1509 to $t0 from $fp-1404
	  lw $t1, -1452($fp)	# fill _tmp1521 to $t1 from $fp-1452
	  add $t2, $t0, $t1	
	  sw $t2, -1456($fp)	# spill _tmp1522 from $t2 to $fp-1456
	# _tmp1523 = *(_tmp1522)
	  lw $t0, -1456($fp)	# fill _tmp1522 to $t0 from $fp-1456
	  lw $t2, 0($t0) 	# load with offset
	  sw $t2, -1460($fp)	# spill _tmp1523 from $t2 to $fp-1460
	# _tmp1524 = 2
	  li $t2, 2		# load constant value 2 into $t2
	  sw $t2, -1464($fp)	# spill _tmp1524 from $t2 to $fp-1464
	# _tmp1525 = 0
	  li $t2, 0		# load constant value 0 into $t2
	  sw $t2, -1468($fp)	# spill _tmp1525 from $t2 to $fp-1468
	# _tmp1526 = *(_tmp1523)
	  lw $t0, -1460($fp)	# fill _tmp1523 to $t0 from $fp-1460
	  lw $t2, 0($t0) 	# load with offset
	  sw $t2, -1472($fp)	# spill _tmp1526 from $t2 to $fp-1472
	# _tmp1527 = _tmp1524 < _tmp1525
	  lw $t0, -1464($fp)	# fill _tmp1524 to $t0 from $fp-1464
	  lw $t1, -1468($fp)	# fill _tmp1525 to $t1 from $fp-1468
	  slt $t2, $t0, $t1	
	  sw $t2, -1476($fp)	# spill _tmp1527 from $t2 to $fp-1476
	# _tmp1528 = _tmp1526 < _tmp1524
	  lw $t0, -1472($fp)	# fill _tmp1526 to $t0 from $fp-1472
	  lw $t1, -1464($fp)	# fill _tmp1524 to $t1 from $fp-1464
	  slt $t2, $t0, $t1	
	  sw $t2, -1480($fp)	# spill _tmp1528 from $t2 to $fp-1480
	# _tmp1529 = _tmp1526 == _tmp1524
	  lw $t0, -1472($fp)	# fill _tmp1526 to $t0 from $fp-1472
	  lw $t1, -1464($fp)	# fill _tmp1524 to $t1 from $fp-1464
	  seq $t2, $t0, $t1	
	  sw $t2, -1484($fp)	# spill _tmp1529 from $t2 to $fp-1484
	# _tmp1530 = _tmp1528 || _tmp1529
	  lw $t0, -1480($fp)	# fill _tmp1528 to $t0 from $fp-1480
	  lw $t1, -1484($fp)	# fill _tmp1529 to $t1 from $fp-1484
	  or $t2, $t0, $t1	
	  sw $t2, -1488($fp)	# spill _tmp1530 from $t2 to $fp-1488
	# _tmp1531 = _tmp1530 || _tmp1527
	  lw $t0, -1488($fp)	# fill _tmp1530 to $t0 from $fp-1488
	  lw $t1, -1476($fp)	# fill _tmp1527 to $t1 from $fp-1476
	  or $t2, $t0, $t1	
	  sw $t2, -1492($fp)	# spill _tmp1531 from $t2 to $fp-1492
	# IfZ _tmp1531 Goto _L148
	  lw $t0, -1492($fp)	# fill _tmp1531 to $t0 from $fp-1492
	  beqz $t0, _L148	# branch if _tmp1531 is zero 
	# _tmp1532 = "Decaf runtime error: Array subscript out of bound..."
	  .data			# create string constant marked with label
	  _string100: .asciiz "Decaf runtime error: Array subscript out of bounds\n"
	  .text
	  la $t2, _string100	# load label
	  sw $t2, -1496($fp)	# spill _tmp1532 from $t2 to $fp-1496
	# PushParam _tmp1532
	  subu $sp, $sp, 4	# decrement sp to make space for param
	  lw $t0, -1496($fp)	# fill _tmp1532 to $t0 from $fp-1496
	  sw $t0, 4($sp)	# copy param value to stack
	# LCall _PrintString
	  jal _PrintString   	# jump to function
	# PopParams 4
	  add $sp, $sp, 4	# pop params off stack
	# LCall _Halt
	  jal _Halt          	# jump to function
  _L148:
	# _tmp1533 = 4
	  li $t2, 4		# load constant value 4 into $t2
	  sw $t2, -1500($fp)	# spill _tmp1533 from $t2 to $fp-1500
	# _tmp1534 = _tmp1524 * _tmp1533
	  lw $t0, -1464($fp)	# fill _tmp1524 to $t0 from $fp-1464
	  lw $t1, -1500($fp)	# fill _tmp1533 to $t1 from $fp-1500
	  mul $t2, $t0, $t1	
	  sw $t2, -1504($fp)	# spill _tmp1534 from $t2 to $fp-1504
	# _tmp1535 = _tmp1534 + _tmp1533
	  lw $t0, -1504($fp)	# fill _tmp1534 to $t0 from $fp-1504
	  lw $t1, -1500($fp)	# fill _tmp1533 to $t1 from $fp-1500
	  add $t2, $t0, $t1	
	  sw $t2, -1508($fp)	# spill _tmp1535 from $t2 to $fp-1508
	# _tmp1536 = _tmp1523 + _tmp1535
	  lw $t0, -1460($fp)	# fill _tmp1523 to $t0 from $fp-1460
	  lw $t1, -1508($fp)	# fill _tmp1535 to $t1 from $fp-1508
	  add $t2, $t0, $t1	
	  sw $t2, -1512($fp)	# spill _tmp1536 from $t2 to $fp-1512
	# _tmp1537 = *(_tmp1536)
	  lw $t0, -1512($fp)	# fill _tmp1536 to $t0 from $fp-1512
	  lw $t2, 0($t0) 	# load with offset
	  sw $t2, -1516($fp)	# spill _tmp1537 from $t2 to $fp-1516
	# PushParam _tmp1537
	  subu $sp, $sp, 4	# decrement sp to make space for param
	  lw $t0, -1516($fp)	# fill _tmp1537 to $t0 from $fp-1516
	  sw $t0, 4($sp)	# copy param value to stack
	# _tmp1538 = *(_tmp1537)
	  lw $t0, -1516($fp)	# fill _tmp1537 to $t0 from $fp-1516
	  lw $t2, 0($t0) 	# load with offset
	  sw $t2, -1520($fp)	# spill _tmp1538 from $t2 to $fp-1520
	# _tmp1539 = *(_tmp1538 + 20)
	  lw $t0, -1520($fp)	# fill _tmp1538 to $t0 from $fp-1520
	  lw $t2, 20($t0) 	# load with offset
	  sw $t2, -1524($fp)	# spill _tmp1539 from $t2 to $fp-1524
	# _tmp1540 = ACall _tmp1539
	  lw $t0, -1524($fp)	# fill _tmp1539 to $t0 from $fp-1524
	  jalr $t0            	# jump to function
	  move $t2, $v0		# copy function return value from $v0
	  sw $t2, -1528($fp)	# spill _tmp1540 from $t2 to $fp-1528
	# PopParams 8
	  add $sp, $sp, 8	# pop params off stack
	# _tmp1541 = _tmp1508 && _tmp1540
	  lw $t0, -1400($fp)	# fill _tmp1508 to $t0 from $fp-1400
	  lw $t1, -1528($fp)	# fill _tmp1540 to $t1 from $fp-1528
	  and $t2, $t0, $t1	
	  sw $t2, -1532($fp)	# spill _tmp1541 from $t2 to $fp-1532
	# PushParam playerMark
	  subu $sp, $sp, 4	# decrement sp to make space for param
	  lw $t0, 12($fp)	# fill playerMark to $t0 from $fp+12
	  sw $t0, 4($sp)	# copy param value to stack
	# _tmp1543 = *(this + 4)
	  lw $t0, 4($fp)	# fill this to $t0 from $fp+4
	  lw $t2, 4($t0) 	# load with offset
	  sw $t2, -1540($fp)	# spill _tmp1543 from $t2 to $fp-1540
	# _tmp1544 = 0
	  li $t2, 0		# load constant value 0 into $t2
	  sw $t2, -1544($fp)	# spill _tmp1544 from $t2 to $fp-1544
	# _tmp1545 = 0
	  li $t2, 0		# load constant value 0 into $t2
	  sw $t2, -1548($fp)	# spill _tmp1545 from $t2 to $fp-1548
	# _tmp1546 = *(_tmp1543)
	  lw $t0, -1540($fp)	# fill _tmp1543 to $t0 from $fp-1540
	  lw $t2, 0($t0) 	# load with offset
	  sw $t2, -1552($fp)	# spill _tmp1546 from $t2 to $fp-1552
	# _tmp1547 = _tmp1544 < _tmp1545
	  lw $t0, -1544($fp)	# fill _tmp1544 to $t0 from $fp-1544
	  lw $t1, -1548($fp)	# fill _tmp1545 to $t1 from $fp-1548
	  slt $t2, $t0, $t1	
	  sw $t2, -1556($fp)	# spill _tmp1547 from $t2 to $fp-1556
	# _tmp1548 = _tmp1546 < _tmp1544
	  lw $t0, -1552($fp)	# fill _tmp1546 to $t0 from $fp-1552
	  lw $t1, -1544($fp)	# fill _tmp1544 to $t1 from $fp-1544
	  slt $t2, $t0, $t1	
	  sw $t2, -1560($fp)	# spill _tmp1548 from $t2 to $fp-1560
	# _tmp1549 = _tmp1546 == _tmp1544
	  lw $t0, -1552($fp)	# fill _tmp1546 to $t0 from $fp-1552
	  lw $t1, -1544($fp)	# fill _tmp1544 to $t1 from $fp-1544
	  seq $t2, $t0, $t1	
	  sw $t2, -1564($fp)	# spill _tmp1549 from $t2 to $fp-1564
	# _tmp1550 = _tmp1548 || _tmp1549
	  lw $t0, -1560($fp)	# fill _tmp1548 to $t0 from $fp-1560
	  lw $t1, -1564($fp)	# fill _tmp1549 to $t1 from $fp-1564
	  or $t2, $t0, $t1	
	  sw $t2, -1568($fp)	# spill _tmp1550 from $t2 to $fp-1568
	# _tmp1551 = _tmp1550 || _tmp1547
	  lw $t0, -1568($fp)	# fill _tmp1550 to $t0 from $fp-1568
	  lw $t1, -1556($fp)	# fill _tmp1547 to $t1 from $fp-1556
	  or $t2, $t0, $t1	
	  sw $t2, -1572($fp)	# spill _tmp1551 from $t2 to $fp-1572
	# IfZ _tmp1551 Goto _L151
	  lw $t0, -1572($fp)	# fill _tmp1551 to $t0 from $fp-1572
	  beqz $t0, _L151	# branch if _tmp1551 is zero 
	# _tmp1552 = "Decaf runtime error: Array subscript out of bound..."
	  .data			# create string constant marked with label
	  _string101: .asciiz "Decaf runtime error: Array subscript out of bounds\n"
	  .text
	  la $t2, _string101	# load label
	  sw $t2, -1576($fp)	# spill _tmp1552 from $t2 to $fp-1576
	# PushParam _tmp1552
	  subu $sp, $sp, 4	# decrement sp to make space for param
	  lw $t0, -1576($fp)	# fill _tmp1552 to $t0 from $fp-1576
	  sw $t0, 4($sp)	# copy param value to stack
	# LCall _PrintString
	  jal _PrintString   	# jump to function
	# PopParams 4
	  add $sp, $sp, 4	# pop params off stack
	# LCall _Halt
	  jal _Halt          	# jump to function
  _L151:
	# _tmp1553 = 4
	  li $t2, 4		# load constant value 4 into $t2
	  sw $t2, -1580($fp)	# spill _tmp1553 from $t2 to $fp-1580
	# _tmp1554 = _tmp1544 * _tmp1553
	  lw $t0, -1544($fp)	# fill _tmp1544 to $t0 from $fp-1544
	  lw $t1, -1580($fp)	# fill _tmp1553 to $t1 from $fp-1580
	  mul $t2, $t0, $t1	
	  sw $t2, -1584($fp)	# spill _tmp1554 from $t2 to $fp-1584
	# _tmp1555 = _tmp1554 + _tmp1553
	  lw $t0, -1584($fp)	# fill _tmp1554 to $t0 from $fp-1584
	  lw $t1, -1580($fp)	# fill _tmp1553 to $t1 from $fp-1580
	  add $t2, $t0, $t1	
	  sw $t2, -1588($fp)	# spill _tmp1555 from $t2 to $fp-1588
	# _tmp1556 = _tmp1543 + _tmp1555
	  lw $t0, -1540($fp)	# fill _tmp1543 to $t0 from $fp-1540
	  lw $t1, -1588($fp)	# fill _tmp1555 to $t1 from $fp-1588
	  add $t2, $t0, $t1	
	  sw $t2, -1592($fp)	# spill _tmp1556 from $t2 to $fp-1592
	# _tmp1557 = *(_tmp1556)
	  lw $t0, -1592($fp)	# fill _tmp1556 to $t0 from $fp-1592
	  lw $t2, 0($t0) 	# load with offset
	  sw $t2, -1596($fp)	# spill _tmp1557 from $t2 to $fp-1596
	# _tmp1558 = 0
	  li $t2, 0		# load constant value 0 into $t2
	  sw $t2, -1600($fp)	# spill _tmp1558 from $t2 to $fp-1600
	# _tmp1559 = 0
	  li $t2, 0		# load constant value 0 into $t2
	  sw $t2, -1604($fp)	# spill _tmp1559 from $t2 to $fp-1604
	# _tmp1560 = *(_tmp1557)
	  lw $t0, -1596($fp)	# fill _tmp1557 to $t0 from $fp-1596
	  lw $t2, 0($t0) 	# load with offset
	  sw $t2, -1608($fp)	# spill _tmp1560 from $t2 to $fp-1608
	# _tmp1561 = _tmp1558 < _tmp1559
	  lw $t0, -1600($fp)	# fill _tmp1558 to $t0 from $fp-1600
	  lw $t1, -1604($fp)	# fill _tmp1559 to $t1 from $fp-1604
	  slt $t2, $t0, $t1	
	  sw $t2, -1612($fp)	# spill _tmp1561 from $t2 to $fp-1612
	# _tmp1562 = _tmp1560 < _tmp1558
	  lw $t0, -1608($fp)	# fill _tmp1560 to $t0 from $fp-1608
	  lw $t1, -1600($fp)	# fill _tmp1558 to $t1 from $fp-1600
	  slt $t2, $t0, $t1	
	  sw $t2, -1616($fp)	# spill _tmp1562 from $t2 to $fp-1616
	# _tmp1563 = _tmp1560 == _tmp1558
	  lw $t0, -1608($fp)	# fill _tmp1560 to $t0 from $fp-1608
	  lw $t1, -1600($fp)	# fill _tmp1558 to $t1 from $fp-1600
	  seq $t2, $t0, $t1	
	  sw $t2, -1620($fp)	# spill _tmp1563 from $t2 to $fp-1620
	# _tmp1564 = _tmp1562 || _tmp1563
	  lw $t0, -1616($fp)	# fill _tmp1562 to $t0 from $fp-1616
	  lw $t1, -1620($fp)	# fill _tmp1563 to $t1 from $fp-1620
	  or $t2, $t0, $t1	
	  sw $t2, -1624($fp)	# spill _tmp1564 from $t2 to $fp-1624
	# _tmp1565 = _tmp1564 || _tmp1561
	  lw $t0, -1624($fp)	# fill _tmp1564 to $t0 from $fp-1624
	  lw $t1, -1612($fp)	# fill _tmp1561 to $t1 from $fp-1612
	  or $t2, $t0, $t1	
	  sw $t2, -1628($fp)	# spill _tmp1565 from $t2 to $fp-1628
	# IfZ _tmp1565 Goto _L152
	  lw $t0, -1628($fp)	# fill _tmp1565 to $t0 from $fp-1628
	  beqz $t0, _L152	# branch if _tmp1565 is zero 
	# _tmp1566 = "Decaf runtime error: Array subscript out of bound..."
	  .data			# create string constant marked with label
	  _string102: .asciiz "Decaf runtime error: Array subscript out of bounds\n"
	  .text
	  la $t2, _string102	# load label
	  sw $t2, -1632($fp)	# spill _tmp1566 from $t2 to $fp-1632
	# PushParam _tmp1566
	  subu $sp, $sp, 4	# decrement sp to make space for param
	  lw $t0, -1632($fp)	# fill _tmp1566 to $t0 from $fp-1632
	  sw $t0, 4($sp)	# copy param value to stack
	# LCall _PrintString
	  jal _PrintString   	# jump to function
	# PopParams 4
	  add $sp, $sp, 4	# pop params off stack
	# LCall _Halt
	  jal _Halt          	# jump to function
  _L152:
	# _tmp1567 = 4
	  li $t2, 4		# load constant value 4 into $t2
	  sw $t2, -1636($fp)	# spill _tmp1567 from $t2 to $fp-1636
	# _tmp1568 = _tmp1558 * _tmp1567
	  lw $t0, -1600($fp)	# fill _tmp1558 to $t0 from $fp-1600
	  lw $t1, -1636($fp)	# fill _tmp1567 to $t1 from $fp-1636
	  mul $t2, $t0, $t1	
	  sw $t2, -1640($fp)	# spill _tmp1568 from $t2 to $fp-1640
	# _tmp1569 = _tmp1568 + _tmp1567
	  lw $t0, -1640($fp)	# fill _tmp1568 to $t0 from $fp-1640
	  lw $t1, -1636($fp)	# fill _tmp1567 to $t1 from $fp-1636
	  add $t2, $t0, $t1	
	  sw $t2, -1644($fp)	# spill _tmp1569 from $t2 to $fp-1644
	# _tmp1570 = _tmp1557 + _tmp1569
	  lw $t0, -1596($fp)	# fill _tmp1557 to $t0 from $fp-1596
	  lw $t1, -1644($fp)	# fill _tmp1569 to $t1 from $fp-1644
	  add $t2, $t0, $t1	
	  sw $t2, -1648($fp)	# spill _tmp1570 from $t2 to $fp-1648
	# _tmp1571 = *(_tmp1570)
	  lw $t0, -1648($fp)	# fill _tmp1570 to $t0 from $fp-1648
	  lw $t2, 0($t0) 	# load with offset
	  sw $t2, -1652($fp)	# spill _tmp1571 from $t2 to $fp-1652
	# PushParam _tmp1571
	  subu $sp, $sp, 4	# decrement sp to make space for param
	  lw $t0, -1652($fp)	# fill _tmp1571 to $t0 from $fp-1652
	  sw $t0, 4($sp)	# copy param value to stack
	# _tmp1572 = *(_tmp1571)
	  lw $t0, -1652($fp)	# fill _tmp1571 to $t0 from $fp-1652
	  lw $t2, 0($t0) 	# load with offset
	  sw $t2, -1656($fp)	# spill _tmp1572 from $t2 to $fp-1656
	# _tmp1573 = *(_tmp1572 + 20)
	  lw $t0, -1656($fp)	# fill _tmp1572 to $t0 from $fp-1656
	  lw $t2, 20($t0) 	# load with offset
	  sw $t2, -1660($fp)	# spill _tmp1573 from $t2 to $fp-1660
	# _tmp1574 = ACall _tmp1573
	  lw $t0, -1660($fp)	# fill _tmp1573 to $t0 from $fp-1660
	  jalr $t0            	# jump to function
	  move $t2, $v0		# copy function return value from $v0
	  sw $t2, -1664($fp)	# spill _tmp1574 from $t2 to $fp-1664
	# PopParams 8
	  add $sp, $sp, 8	# pop params off stack
	# IfZ _tmp1574 Goto _L150
	  lw $t0, -1664($fp)	# fill _tmp1574 to $t0 from $fp-1664
	  beqz $t0, _L150	# branch if _tmp1574 is zero 
	# _tmp1575 = 0
	  li $t2, 0		# load constant value 0 into $t2
	  sw $t2, -1668($fp)	# spill _tmp1575 from $t2 to $fp-1668
	# _tmp1542 = _tmp1575
	  lw $t2, -1668($fp)	# fill _tmp1575 to $t2 from $fp-1668
	  sw $t2, -1536($fp)	# spill _tmp1542 from $t2 to $fp-1536
	# Goto _L149
	  b _L149		# unconditional branch
  _L150:
	# _tmp1576 = 1
	  li $t2, 1		# load constant value 1 into $t2
	  sw $t2, -1672($fp)	# spill _tmp1576 from $t2 to $fp-1672
	# _tmp1542 = _tmp1576
	  lw $t2, -1672($fp)	# fill _tmp1576 to $t2 from $fp-1672
	  sw $t2, -1536($fp)	# spill _tmp1542 from $t2 to $fp-1536
  _L149:
	# _tmp1577 = _tmp1541 && _tmp1542
	  lw $t0, -1532($fp)	# fill _tmp1541 to $t0 from $fp-1532
	  lw $t1, -1536($fp)	# fill _tmp1542 to $t1 from $fp-1536
	  and $t2, $t0, $t1	
	  sw $t2, -1676($fp)	# spill _tmp1577 from $t2 to $fp-1676
	# IfZ _tmp1577 Goto _L143
	  lw $t0, -1676($fp)	# fill _tmp1577 to $t0 from $fp-1676
	  beqz $t0, _L143	# branch if _tmp1577 is zero 
	# _tmp1578 = 0
	  li $t2, 0		# load constant value 0 into $t2
	  sw $t2, -1680($fp)	# spill _tmp1578 from $t2 to $fp-1680
	# row = _tmp1578
	  lw $t2, -1680($fp)	# fill _tmp1578 to $t2 from $fp-1680
	  sw $t2, -8($fp)	# spill row from $t2 to $fp-8
	# _tmp1579 = 0
	  li $t2, 0		# load constant value 0 into $t2
	  sw $t2, -1684($fp)	# spill _tmp1579 from $t2 to $fp-1684
	# column = _tmp1579
	  lw $t2, -1684($fp)	# fill _tmp1579 to $t2 from $fp-1684
	  sw $t2, -12($fp)	# spill column from $t2 to $fp-12
	# Goto _L144
	  b _L144		# unconditional branch
  _L143:
	# PushParam enemyMark
	  subu $sp, $sp, 4	# decrement sp to make space for param
	  lw $t0, 8($fp)	# fill enemyMark to $t0 from $fp+8
	  sw $t0, 4($sp)	# copy param value to stack
	# _tmp1580 = *(this + 4)
	  lw $t0, 4($fp)	# fill this to $t0 from $fp+4
	  lw $t2, 4($t0) 	# load with offset
	  sw $t2, -1688($fp)	# spill _tmp1580 from $t2 to $fp-1688
	# _tmp1581 = 1
	  li $t2, 1		# load constant value 1 into $t2
	  sw $t2, -1692($fp)	# spill _tmp1581 from $t2 to $fp-1692
	# _tmp1582 = 0
	  li $t2, 0		# load constant value 0 into $t2
	  sw $t2, -1696($fp)	# spill _tmp1582 from $t2 to $fp-1696
	# _tmp1583 = *(_tmp1580)
	  lw $t0, -1688($fp)	# fill _tmp1580 to $t0 from $fp-1688
	  lw $t2, 0($t0) 	# load with offset
	  sw $t2, -1700($fp)	# spill _tmp1583 from $t2 to $fp-1700
	# _tmp1584 = _tmp1581 < _tmp1582
	  lw $t0, -1692($fp)	# fill _tmp1581 to $t0 from $fp-1692
	  lw $t1, -1696($fp)	# fill _tmp1582 to $t1 from $fp-1696
	  slt $t2, $t0, $t1	
	  sw $t2, -1704($fp)	# spill _tmp1584 from $t2 to $fp-1704
	# _tmp1585 = _tmp1583 < _tmp1581
	  lw $t0, -1700($fp)	# fill _tmp1583 to $t0 from $fp-1700
	  lw $t1, -1692($fp)	# fill _tmp1581 to $t1 from $fp-1692
	  slt $t2, $t0, $t1	
	  sw $t2, -1708($fp)	# spill _tmp1585 from $t2 to $fp-1708
	# _tmp1586 = _tmp1583 == _tmp1581
	  lw $t0, -1700($fp)	# fill _tmp1583 to $t0 from $fp-1700
	  lw $t1, -1692($fp)	# fill _tmp1581 to $t1 from $fp-1692
	  seq $t2, $t0, $t1	
	  sw $t2, -1712($fp)	# spill _tmp1586 from $t2 to $fp-1712
	# _tmp1587 = _tmp1585 || _tmp1586
	  lw $t0, -1708($fp)	# fill _tmp1585 to $t0 from $fp-1708
	  lw $t1, -1712($fp)	# fill _tmp1586 to $t1 from $fp-1712
	  or $t2, $t0, $t1	
	  sw $t2, -1716($fp)	# spill _tmp1587 from $t2 to $fp-1716
	# _tmp1588 = _tmp1587 || _tmp1584
	  lw $t0, -1716($fp)	# fill _tmp1587 to $t0 from $fp-1716
	  lw $t1, -1704($fp)	# fill _tmp1584 to $t1 from $fp-1704
	  or $t2, $t0, $t1	
	  sw $t2, -1720($fp)	# spill _tmp1588 from $t2 to $fp-1720
	# IfZ _tmp1588 Goto _L155
	  lw $t0, -1720($fp)	# fill _tmp1588 to $t0 from $fp-1720
	  beqz $t0, _L155	# branch if _tmp1588 is zero 
	# _tmp1589 = "Decaf runtime error: Array subscript out of bound..."
	  .data			# create string constant marked with label
	  _string103: .asciiz "Decaf runtime error: Array subscript out of bounds\n"
	  .text
	  la $t2, _string103	# load label
	  sw $t2, -1724($fp)	# spill _tmp1589 from $t2 to $fp-1724
	# PushParam _tmp1589
	  subu $sp, $sp, 4	# decrement sp to make space for param
	  lw $t0, -1724($fp)	# fill _tmp1589 to $t0 from $fp-1724
	  sw $t0, 4($sp)	# copy param value to stack
	# LCall _PrintString
	  jal _PrintString   	# jump to function
	# PopParams 4
	  add $sp, $sp, 4	# pop params off stack
	# LCall _Halt
	  jal _Halt          	# jump to function
  _L155:
	# _tmp1590 = 4
	  li $t2, 4		# load constant value 4 into $t2
	  sw $t2, -1728($fp)	# spill _tmp1590 from $t2 to $fp-1728
	# _tmp1591 = _tmp1581 * _tmp1590
	  lw $t0, -1692($fp)	# fill _tmp1581 to $t0 from $fp-1692
	  lw $t1, -1728($fp)	# fill _tmp1590 to $t1 from $fp-1728
	  mul $t2, $t0, $t1	
	  sw $t2, -1732($fp)	# spill _tmp1591 from $t2 to $fp-1732
	# _tmp1592 = _tmp1591 + _tmp1590
	  lw $t0, -1732($fp)	# fill _tmp1591 to $t0 from $fp-1732
	  lw $t1, -1728($fp)	# fill _tmp1590 to $t1 from $fp-1728
	  add $t2, $t0, $t1	
	  sw $t2, -1736($fp)	# spill _tmp1592 from $t2 to $fp-1736
	# _tmp1593 = _tmp1580 + _tmp1592
	  lw $t0, -1688($fp)	# fill _tmp1580 to $t0 from $fp-1688
	  lw $t1, -1736($fp)	# fill _tmp1592 to $t1 from $fp-1736
	  add $t2, $t0, $t1	
	  sw $t2, -1740($fp)	# spill _tmp1593 from $t2 to $fp-1740
	# _tmp1594 = *(_tmp1593)
	  lw $t0, -1740($fp)	# fill _tmp1593 to $t0 from $fp-1740
	  lw $t2, 0($t0) 	# load with offset
	  sw $t2, -1744($fp)	# spill _tmp1594 from $t2 to $fp-1744
	# _tmp1595 = 1
	  li $t2, 1		# load constant value 1 into $t2
	  sw $t2, -1748($fp)	# spill _tmp1595 from $t2 to $fp-1748
	# _tmp1596 = 0
	  li $t2, 0		# load constant value 0 into $t2
	  sw $t2, -1752($fp)	# spill _tmp1596 from $t2 to $fp-1752
	# _tmp1597 = *(_tmp1594)
	  lw $t0, -1744($fp)	# fill _tmp1594 to $t0 from $fp-1744
	  lw $t2, 0($t0) 	# load with offset
	  sw $t2, -1756($fp)	# spill _tmp1597 from $t2 to $fp-1756
	# _tmp1598 = _tmp1595 < _tmp1596
	  lw $t0, -1748($fp)	# fill _tmp1595 to $t0 from $fp-1748
	  lw $t1, -1752($fp)	# fill _tmp1596 to $t1 from $fp-1752
	  slt $t2, $t0, $t1	
	  sw $t2, -1760($fp)	# spill _tmp1598 from $t2 to $fp-1760
	# _tmp1599 = _tmp1597 < _tmp1595
	  lw $t0, -1756($fp)	# fill _tmp1597 to $t0 from $fp-1756
	  lw $t1, -1748($fp)	# fill _tmp1595 to $t1 from $fp-1748
	  slt $t2, $t0, $t1	
	  sw $t2, -1764($fp)	# spill _tmp1599 from $t2 to $fp-1764
	# _tmp1600 = _tmp1597 == _tmp1595
	  lw $t0, -1756($fp)	# fill _tmp1597 to $t0 from $fp-1756
	  lw $t1, -1748($fp)	# fill _tmp1595 to $t1 from $fp-1748
	  seq $t2, $t0, $t1	
	  sw $t2, -1768($fp)	# spill _tmp1600 from $t2 to $fp-1768
	# _tmp1601 = _tmp1599 || _tmp1600
	  lw $t0, -1764($fp)	# fill _tmp1599 to $t0 from $fp-1764
	  lw $t1, -1768($fp)	# fill _tmp1600 to $t1 from $fp-1768
	  or $t2, $t0, $t1	
	  sw $t2, -1772($fp)	# spill _tmp1601 from $t2 to $fp-1772
	# _tmp1602 = _tmp1601 || _tmp1598
	  lw $t0, -1772($fp)	# fill _tmp1601 to $t0 from $fp-1772
	  lw $t1, -1760($fp)	# fill _tmp1598 to $t1 from $fp-1760
	  or $t2, $t0, $t1	
	  sw $t2, -1776($fp)	# spill _tmp1602 from $t2 to $fp-1776
	# IfZ _tmp1602 Goto _L156
	  lw $t0, -1776($fp)	# fill _tmp1602 to $t0 from $fp-1776
	  beqz $t0, _L156	# branch if _tmp1602 is zero 
	# _tmp1603 = "Decaf runtime error: Array subscript out of bound..."
	  .data			# create string constant marked with label
	  _string104: .asciiz "Decaf runtime error: Array subscript out of bounds\n"
	  .text
	  la $t2, _string104	# load label
	  sw $t2, -1780($fp)	# spill _tmp1603 from $t2 to $fp-1780
	# PushParam _tmp1603
	  subu $sp, $sp, 4	# decrement sp to make space for param
	  lw $t0, -1780($fp)	# fill _tmp1603 to $t0 from $fp-1780
	  sw $t0, 4($sp)	# copy param value to stack
	# LCall _PrintString
	  jal _PrintString   	# jump to function
	# PopParams 4
	  add $sp, $sp, 4	# pop params off stack
	# LCall _Halt
	  jal _Halt          	# jump to function
  _L156:
	# _tmp1604 = 4
	  li $t2, 4		# load constant value 4 into $t2
	  sw $t2, -1784($fp)	# spill _tmp1604 from $t2 to $fp-1784
	# _tmp1605 = _tmp1595 * _tmp1604
	  lw $t0, -1748($fp)	# fill _tmp1595 to $t0 from $fp-1748
	  lw $t1, -1784($fp)	# fill _tmp1604 to $t1 from $fp-1784
	  mul $t2, $t0, $t1	
	  sw $t2, -1788($fp)	# spill _tmp1605 from $t2 to $fp-1788
	# _tmp1606 = _tmp1605 + _tmp1604
	  lw $t0, -1788($fp)	# fill _tmp1605 to $t0 from $fp-1788
	  lw $t1, -1784($fp)	# fill _tmp1604 to $t1 from $fp-1784
	  add $t2, $t0, $t1	
	  sw $t2, -1792($fp)	# spill _tmp1606 from $t2 to $fp-1792
	# _tmp1607 = _tmp1594 + _tmp1606
	  lw $t0, -1744($fp)	# fill _tmp1594 to $t0 from $fp-1744
	  lw $t1, -1792($fp)	# fill _tmp1606 to $t1 from $fp-1792
	  add $t2, $t0, $t1	
	  sw $t2, -1796($fp)	# spill _tmp1607 from $t2 to $fp-1796
	# _tmp1608 = *(_tmp1607)
	  lw $t0, -1796($fp)	# fill _tmp1607 to $t0 from $fp-1796
	  lw $t2, 0($t0) 	# load with offset
	  sw $t2, -1800($fp)	# spill _tmp1608 from $t2 to $fp-1800
	# PushParam _tmp1608
	  subu $sp, $sp, 4	# decrement sp to make space for param
	  lw $t0, -1800($fp)	# fill _tmp1608 to $t0 from $fp-1800
	  sw $t0, 4($sp)	# copy param value to stack
	# _tmp1609 = *(_tmp1608)
	  lw $t0, -1800($fp)	# fill _tmp1608 to $t0 from $fp-1800
	  lw $t2, 0($t0) 	# load with offset
	  sw $t2, -1804($fp)	# spill _tmp1609 from $t2 to $fp-1804
	# _tmp1610 = *(_tmp1609 + 20)
	  lw $t0, -1804($fp)	# fill _tmp1609 to $t0 from $fp-1804
	  lw $t2, 20($t0) 	# load with offset
	  sw $t2, -1808($fp)	# spill _tmp1610 from $t2 to $fp-1808
	# _tmp1611 = ACall _tmp1610
	  lw $t0, -1808($fp)	# fill _tmp1610 to $t0 from $fp-1808
	  jalr $t0            	# jump to function
	  move $t2, $v0		# copy function return value from $v0
	  sw $t2, -1812($fp)	# spill _tmp1611 from $t2 to $fp-1812
	# PopParams 8
	  add $sp, $sp, 8	# pop params off stack
	# PushParam enemyMark
	  subu $sp, $sp, 4	# decrement sp to make space for param
	  lw $t0, 8($fp)	# fill enemyMark to $t0 from $fp+8
	  sw $t0, 4($sp)	# copy param value to stack
	# _tmp1612 = *(this + 4)
	  lw $t0, 4($fp)	# fill this to $t0 from $fp+4
	  lw $t2, 4($t0) 	# load with offset
	  sw $t2, -1816($fp)	# spill _tmp1612 from $t2 to $fp-1816
	# _tmp1613 = 1
	  li $t2, 1		# load constant value 1 into $t2
	  sw $t2, -1820($fp)	# spill _tmp1613 from $t2 to $fp-1820
	# _tmp1614 = 0
	  li $t2, 0		# load constant value 0 into $t2
	  sw $t2, -1824($fp)	# spill _tmp1614 from $t2 to $fp-1824
	# _tmp1615 = *(_tmp1612)
	  lw $t0, -1816($fp)	# fill _tmp1612 to $t0 from $fp-1816
	  lw $t2, 0($t0) 	# load with offset
	  sw $t2, -1828($fp)	# spill _tmp1615 from $t2 to $fp-1828
	# _tmp1616 = _tmp1613 < _tmp1614
	  lw $t0, -1820($fp)	# fill _tmp1613 to $t0 from $fp-1820
	  lw $t1, -1824($fp)	# fill _tmp1614 to $t1 from $fp-1824
	  slt $t2, $t0, $t1	
	  sw $t2, -1832($fp)	# spill _tmp1616 from $t2 to $fp-1832
	# _tmp1617 = _tmp1615 < _tmp1613
	  lw $t0, -1828($fp)	# fill _tmp1615 to $t0 from $fp-1828
	  lw $t1, -1820($fp)	# fill _tmp1613 to $t1 from $fp-1820
	  slt $t2, $t0, $t1	
	  sw $t2, -1836($fp)	# spill _tmp1617 from $t2 to $fp-1836
	# _tmp1618 = _tmp1615 == _tmp1613
	  lw $t0, -1828($fp)	# fill _tmp1615 to $t0 from $fp-1828
	  lw $t1, -1820($fp)	# fill _tmp1613 to $t1 from $fp-1820
	  seq $t2, $t0, $t1	
	  sw $t2, -1840($fp)	# spill _tmp1618 from $t2 to $fp-1840
	# _tmp1619 = _tmp1617 || _tmp1618
	  lw $t0, -1836($fp)	# fill _tmp1617 to $t0 from $fp-1836
	  lw $t1, -1840($fp)	# fill _tmp1618 to $t1 from $fp-1840
	  or $t2, $t0, $t1	
	  sw $t2, -1844($fp)	# spill _tmp1619 from $t2 to $fp-1844
	# _tmp1620 = _tmp1619 || _tmp1616
	  lw $t0, -1844($fp)	# fill _tmp1619 to $t0 from $fp-1844
	  lw $t1, -1832($fp)	# fill _tmp1616 to $t1 from $fp-1832
	  or $t2, $t0, $t1	
	  sw $t2, -1848($fp)	# spill _tmp1620 from $t2 to $fp-1848
	# IfZ _tmp1620 Goto _L157
	  lw $t0, -1848($fp)	# fill _tmp1620 to $t0 from $fp-1848
	  beqz $t0, _L157	# branch if _tmp1620 is zero 
	# _tmp1621 = "Decaf runtime error: Array subscript out of bound..."
	  .data			# create string constant marked with label
	  _string105: .asciiz "Decaf runtime error: Array subscript out of bounds\n"
	  .text
	  la $t2, _string105	# load label
	  sw $t2, -1852($fp)	# spill _tmp1621 from $t2 to $fp-1852
	# PushParam _tmp1621
	  subu $sp, $sp, 4	# decrement sp to make space for param
	  lw $t0, -1852($fp)	# fill _tmp1621 to $t0 from $fp-1852
	  sw $t0, 4($sp)	# copy param value to stack
	# LCall _PrintString
	  jal _PrintString   	# jump to function
	# PopParams 4
	  add $sp, $sp, 4	# pop params off stack
	# LCall _Halt
	  jal _Halt          	# jump to function
  _L157:
	# _tmp1622 = 4
	  li $t2, 4		# load constant value 4 into $t2
	  sw $t2, -1856($fp)	# spill _tmp1622 from $t2 to $fp-1856
	# _tmp1623 = _tmp1613 * _tmp1622
	  lw $t0, -1820($fp)	# fill _tmp1613 to $t0 from $fp-1820
	  lw $t1, -1856($fp)	# fill _tmp1622 to $t1 from $fp-1856
	  mul $t2, $t0, $t1	
	  sw $t2, -1860($fp)	# spill _tmp1623 from $t2 to $fp-1860
	# _tmp1624 = _tmp1623 + _tmp1622
	  lw $t0, -1860($fp)	# fill _tmp1623 to $t0 from $fp-1860
	  lw $t1, -1856($fp)	# fill _tmp1622 to $t1 from $fp-1856
	  add $t2, $t0, $t1	
	  sw $t2, -1864($fp)	# spill _tmp1624 from $t2 to $fp-1864
	# _tmp1625 = _tmp1612 + _tmp1624
	  lw $t0, -1816($fp)	# fill _tmp1612 to $t0 from $fp-1816
	  lw $t1, -1864($fp)	# fill _tmp1624 to $t1 from $fp-1864
	  add $t2, $t0, $t1	
	  sw $t2, -1868($fp)	# spill _tmp1625 from $t2 to $fp-1868
	# _tmp1626 = *(_tmp1625)
	  lw $t0, -1868($fp)	# fill _tmp1625 to $t0 from $fp-1868
	  lw $t2, 0($t0) 	# load with offset
	  sw $t2, -1872($fp)	# spill _tmp1626 from $t2 to $fp-1872
	# _tmp1627 = 2
	  li $t2, 2		# load constant value 2 into $t2
	  sw $t2, -1876($fp)	# spill _tmp1627 from $t2 to $fp-1876
	# _tmp1628 = 0
	  li $t2, 0		# load constant value 0 into $t2
	  sw $t2, -1880($fp)	# spill _tmp1628 from $t2 to $fp-1880
	# _tmp1629 = *(_tmp1626)
	  lw $t0, -1872($fp)	# fill _tmp1626 to $t0 from $fp-1872
	  lw $t2, 0($t0) 	# load with offset
	  sw $t2, -1884($fp)	# spill _tmp1629 from $t2 to $fp-1884
	# _tmp1630 = _tmp1627 < _tmp1628
	  lw $t0, -1876($fp)	# fill _tmp1627 to $t0 from $fp-1876
	  lw $t1, -1880($fp)	# fill _tmp1628 to $t1 from $fp-1880
	  slt $t2, $t0, $t1	
	  sw $t2, -1888($fp)	# spill _tmp1630 from $t2 to $fp-1888
	# _tmp1631 = _tmp1629 < _tmp1627
	  lw $t0, -1884($fp)	# fill _tmp1629 to $t0 from $fp-1884
	  lw $t1, -1876($fp)	# fill _tmp1627 to $t1 from $fp-1876
	  slt $t2, $t0, $t1	
	  sw $t2, -1892($fp)	# spill _tmp1631 from $t2 to $fp-1892
	# _tmp1632 = _tmp1629 == _tmp1627
	  lw $t0, -1884($fp)	# fill _tmp1629 to $t0 from $fp-1884
	  lw $t1, -1876($fp)	# fill _tmp1627 to $t1 from $fp-1876
	  seq $t2, $t0, $t1	
	  sw $t2, -1896($fp)	# spill _tmp1632 from $t2 to $fp-1896
	# _tmp1633 = _tmp1631 || _tmp1632
	  lw $t0, -1892($fp)	# fill _tmp1631 to $t0 from $fp-1892
	  lw $t1, -1896($fp)	# fill _tmp1632 to $t1 from $fp-1896
	  or $t2, $t0, $t1	
	  sw $t2, -1900($fp)	# spill _tmp1633 from $t2 to $fp-1900
	# _tmp1634 = _tmp1633 || _tmp1630
	  lw $t0, -1900($fp)	# fill _tmp1633 to $t0 from $fp-1900
	  lw $t1, -1888($fp)	# fill _tmp1630 to $t1 from $fp-1888
	  or $t2, $t0, $t1	
	  sw $t2, -1904($fp)	# spill _tmp1634 from $t2 to $fp-1904
	# IfZ _tmp1634 Goto _L158
	  lw $t0, -1904($fp)	# fill _tmp1634 to $t0 from $fp-1904
	  beqz $t0, _L158	# branch if _tmp1634 is zero 
	# _tmp1635 = "Decaf runtime error: Array subscript out of bound..."
	  .data			# create string constant marked with label
	  _string106: .asciiz "Decaf runtime error: Array subscript out of bounds\n"
	  .text
	  la $t2, _string106	# load label
	  sw $t2, -1908($fp)	# spill _tmp1635 from $t2 to $fp-1908
	# PushParam _tmp1635
	  subu $sp, $sp, 4	# decrement sp to make space for param
	  lw $t0, -1908($fp)	# fill _tmp1635 to $t0 from $fp-1908
	  sw $t0, 4($sp)	# copy param value to stack
	# LCall _PrintString
	  jal _PrintString   	# jump to function
	# PopParams 4
	  add $sp, $sp, 4	# pop params off stack
	# LCall _Halt
	  jal _Halt          	# jump to function
  _L158:
	# _tmp1636 = 4
	  li $t2, 4		# load constant value 4 into $t2
	  sw $t2, -1912($fp)	# spill _tmp1636 from $t2 to $fp-1912
	# _tmp1637 = _tmp1627 * _tmp1636
	  lw $t0, -1876($fp)	# fill _tmp1627 to $t0 from $fp-1876
	  lw $t1, -1912($fp)	# fill _tmp1636 to $t1 from $fp-1912
	  mul $t2, $t0, $t1	
	  sw $t2, -1916($fp)	# spill _tmp1637 from $t2 to $fp-1916
	# _tmp1638 = _tmp1637 + _tmp1636
	  lw $t0, -1916($fp)	# fill _tmp1637 to $t0 from $fp-1916
	  lw $t1, -1912($fp)	# fill _tmp1636 to $t1 from $fp-1912
	  add $t2, $t0, $t1	
	  sw $t2, -1920($fp)	# spill _tmp1638 from $t2 to $fp-1920
	# _tmp1639 = _tmp1626 + _tmp1638
	  lw $t0, -1872($fp)	# fill _tmp1626 to $t0 from $fp-1872
	  lw $t1, -1920($fp)	# fill _tmp1638 to $t1 from $fp-1920
	  add $t2, $t0, $t1	
	  sw $t2, -1924($fp)	# spill _tmp1639 from $t2 to $fp-1924
	# _tmp1640 = *(_tmp1639)
	  lw $t0, -1924($fp)	# fill _tmp1639 to $t0 from $fp-1924
	  lw $t2, 0($t0) 	# load with offset
	  sw $t2, -1928($fp)	# spill _tmp1640 from $t2 to $fp-1928
	# PushParam _tmp1640
	  subu $sp, $sp, 4	# decrement sp to make space for param
	  lw $t0, -1928($fp)	# fill _tmp1640 to $t0 from $fp-1928
	  sw $t0, 4($sp)	# copy param value to stack
	# _tmp1641 = *(_tmp1640)
	  lw $t0, -1928($fp)	# fill _tmp1640 to $t0 from $fp-1928
	  lw $t2, 0($t0) 	# load with offset
	  sw $t2, -1932($fp)	# spill _tmp1641 from $t2 to $fp-1932
	# _tmp1642 = *(_tmp1641 + 20)
	  lw $t0, -1932($fp)	# fill _tmp1641 to $t0 from $fp-1932
	  lw $t2, 20($t0) 	# load with offset
	  sw $t2, -1936($fp)	# spill _tmp1642 from $t2 to $fp-1936
	# _tmp1643 = ACall _tmp1642
	  lw $t0, -1936($fp)	# fill _tmp1642 to $t0 from $fp-1936
	  jalr $t0            	# jump to function
	  move $t2, $v0		# copy function return value from $v0
	  sw $t2, -1940($fp)	# spill _tmp1643 from $t2 to $fp-1940
	# PopParams 8
	  add $sp, $sp, 8	# pop params off stack
	# _tmp1644 = _tmp1611 && _tmp1643
	  lw $t0, -1812($fp)	# fill _tmp1611 to $t0 from $fp-1812
	  lw $t1, -1940($fp)	# fill _tmp1643 to $t1 from $fp-1940
	  and $t2, $t0, $t1	
	  sw $t2, -1944($fp)	# spill _tmp1644 from $t2 to $fp-1944
	# PushParam playerMark
	  subu $sp, $sp, 4	# decrement sp to make space for param
	  lw $t0, 12($fp)	# fill playerMark to $t0 from $fp+12
	  sw $t0, 4($sp)	# copy param value to stack
	# _tmp1646 = *(this + 4)
	  lw $t0, 4($fp)	# fill this to $t0 from $fp+4
	  lw $t2, 4($t0) 	# load with offset
	  sw $t2, -1952($fp)	# spill _tmp1646 from $t2 to $fp-1952
	# _tmp1647 = 1
	  li $t2, 1		# load constant value 1 into $t2
	  sw $t2, -1956($fp)	# spill _tmp1647 from $t2 to $fp-1956
	# _tmp1648 = 0
	  li $t2, 0		# load constant value 0 into $t2
	  sw $t2, -1960($fp)	# spill _tmp1648 from $t2 to $fp-1960
	# _tmp1649 = *(_tmp1646)
	  lw $t0, -1952($fp)	# fill _tmp1646 to $t0 from $fp-1952
	  lw $t2, 0($t0) 	# load with offset
	  sw $t2, -1964($fp)	# spill _tmp1649 from $t2 to $fp-1964
	# _tmp1650 = _tmp1647 < _tmp1648
	  lw $t0, -1956($fp)	# fill _tmp1647 to $t0 from $fp-1956
	  lw $t1, -1960($fp)	# fill _tmp1648 to $t1 from $fp-1960
	  slt $t2, $t0, $t1	
	  sw $t2, -1968($fp)	# spill _tmp1650 from $t2 to $fp-1968
	# _tmp1651 = _tmp1649 < _tmp1647
	  lw $t0, -1964($fp)	# fill _tmp1649 to $t0 from $fp-1964
	  lw $t1, -1956($fp)	# fill _tmp1647 to $t1 from $fp-1956
	  slt $t2, $t0, $t1	
	  sw $t2, -1972($fp)	# spill _tmp1651 from $t2 to $fp-1972
	# _tmp1652 = _tmp1649 == _tmp1647
	  lw $t0, -1964($fp)	# fill _tmp1649 to $t0 from $fp-1964
	  lw $t1, -1956($fp)	# fill _tmp1647 to $t1 from $fp-1956
	  seq $t2, $t0, $t1	
	  sw $t2, -1976($fp)	# spill _tmp1652 from $t2 to $fp-1976
	# _tmp1653 = _tmp1651 || _tmp1652
	  lw $t0, -1972($fp)	# fill _tmp1651 to $t0 from $fp-1972
	  lw $t1, -1976($fp)	# fill _tmp1652 to $t1 from $fp-1976
	  or $t2, $t0, $t1	
	  sw $t2, -1980($fp)	# spill _tmp1653 from $t2 to $fp-1980
	# _tmp1654 = _tmp1653 || _tmp1650
	  lw $t0, -1980($fp)	# fill _tmp1653 to $t0 from $fp-1980
	  lw $t1, -1968($fp)	# fill _tmp1650 to $t1 from $fp-1968
	  or $t2, $t0, $t1	
	  sw $t2, -1984($fp)	# spill _tmp1654 from $t2 to $fp-1984
	# IfZ _tmp1654 Goto _L161
	  lw $t0, -1984($fp)	# fill _tmp1654 to $t0 from $fp-1984
	  beqz $t0, _L161	# branch if _tmp1654 is zero 
	# _tmp1655 = "Decaf runtime error: Array subscript out of bound..."
	  .data			# create string constant marked with label
	  _string107: .asciiz "Decaf runtime error: Array subscript out of bounds\n"
	  .text
	  la $t2, _string107	# load label
	  sw $t2, -1988($fp)	# spill _tmp1655 from $t2 to $fp-1988
	# PushParam _tmp1655
	  subu $sp, $sp, 4	# decrement sp to make space for param
	  lw $t0, -1988($fp)	# fill _tmp1655 to $t0 from $fp-1988
	  sw $t0, 4($sp)	# copy param value to stack
	# LCall _PrintString
	  jal _PrintString   	# jump to function
	# PopParams 4
	  add $sp, $sp, 4	# pop params off stack
	# LCall _Halt
	  jal _Halt          	# jump to function
  _L161:
	# _tmp1656 = 4
	  li $t2, 4		# load constant value 4 into $t2
	  sw $t2, -1992($fp)	# spill _tmp1656 from $t2 to $fp-1992
	# _tmp1657 = _tmp1647 * _tmp1656
	  lw $t0, -1956($fp)	# fill _tmp1647 to $t0 from $fp-1956
	  lw $t1, -1992($fp)	# fill _tmp1656 to $t1 from $fp-1992
	  mul $t2, $t0, $t1	
	  sw $t2, -1996($fp)	# spill _tmp1657 from $t2 to $fp-1996
	# _tmp1658 = _tmp1657 + _tmp1656
	  lw $t0, -1996($fp)	# fill _tmp1657 to $t0 from $fp-1996
	  lw $t1, -1992($fp)	# fill _tmp1656 to $t1 from $fp-1992
	  add $t2, $t0, $t1	
	  sw $t2, -2000($fp)	# spill _tmp1658 from $t2 to $fp-2000
	# _tmp1659 = _tmp1646 + _tmp1658
	  lw $t0, -1952($fp)	# fill _tmp1646 to $t0 from $fp-1952
	  lw $t1, -2000($fp)	# fill _tmp1658 to $t1 from $fp-2000
	  add $t2, $t0, $t1	
	  sw $t2, -2004($fp)	# spill _tmp1659 from $t2 to $fp-2004
	# _tmp1660 = *(_tmp1659)
	  lw $t0, -2004($fp)	# fill _tmp1659 to $t0 from $fp-2004
	  lw $t2, 0($t0) 	# load with offset
	  sw $t2, -2008($fp)	# spill _tmp1660 from $t2 to $fp-2008
	# _tmp1661 = 0
	  li $t2, 0		# load constant value 0 into $t2
	  sw $t2, -2012($fp)	# spill _tmp1661 from $t2 to $fp-2012
	# _tmp1662 = 0
	  li $t2, 0		# load constant value 0 into $t2
	  sw $t2, -2016($fp)	# spill _tmp1662 from $t2 to $fp-2016
	# _tmp1663 = *(_tmp1660)
	  lw $t0, -2008($fp)	# fill _tmp1660 to $t0 from $fp-2008
	  lw $t2, 0($t0) 	# load with offset
	  sw $t2, -2020($fp)	# spill _tmp1663 from $t2 to $fp-2020
	# _tmp1664 = _tmp1661 < _tmp1662
	  lw $t0, -2012($fp)	# fill _tmp1661 to $t0 from $fp-2012
	  lw $t1, -2016($fp)	# fill _tmp1662 to $t1 from $fp-2016
	  slt $t2, $t0, $t1	
	  sw $t2, -2024($fp)	# spill _tmp1664 from $t2 to $fp-2024
	# _tmp1665 = _tmp1663 < _tmp1661
	  lw $t0, -2020($fp)	# fill _tmp1663 to $t0 from $fp-2020
	  lw $t1, -2012($fp)	# fill _tmp1661 to $t1 from $fp-2012
	  slt $t2, $t0, $t1	
	  sw $t2, -2028($fp)	# spill _tmp1665 from $t2 to $fp-2028
	# _tmp1666 = _tmp1663 == _tmp1661
	  lw $t0, -2020($fp)	# fill _tmp1663 to $t0 from $fp-2020
	  lw $t1, -2012($fp)	# fill _tmp1661 to $t1 from $fp-2012
	  seq $t2, $t0, $t1	
	  sw $t2, -2032($fp)	# spill _tmp1666 from $t2 to $fp-2032
	# _tmp1667 = _tmp1665 || _tmp1666
	  lw $t0, -2028($fp)	# fill _tmp1665 to $t0 from $fp-2028
	  lw $t1, -2032($fp)	# fill _tmp1666 to $t1 from $fp-2032
	  or $t2, $t0, $t1	
	  sw $t2, -2036($fp)	# spill _tmp1667 from $t2 to $fp-2036
	# _tmp1668 = _tmp1667 || _tmp1664
	  lw $t0, -2036($fp)	# fill _tmp1667 to $t0 from $fp-2036
	  lw $t1, -2024($fp)	# fill _tmp1664 to $t1 from $fp-2024
	  or $t2, $t0, $t1	
	  sw $t2, -2040($fp)	# spill _tmp1668 from $t2 to $fp-2040
	# IfZ _tmp1668 Goto _L162
	  lw $t0, -2040($fp)	# fill _tmp1668 to $t0 from $fp-2040
	  beqz $t0, _L162	# branch if _tmp1668 is zero 
	# _tmp1669 = "Decaf runtime error: Array subscript out of bound..."
	  .data			# create string constant marked with label
	  _string108: .asciiz "Decaf runtime error: Array subscript out of bounds\n"
	  .text
	  la $t2, _string108	# load label
	  sw $t2, -2044($fp)	# spill _tmp1669 from $t2 to $fp-2044
	# PushParam _tmp1669
	  subu $sp, $sp, 4	# decrement sp to make space for param
	  lw $t0, -2044($fp)	# fill _tmp1669 to $t0 from $fp-2044
	  sw $t0, 4($sp)	# copy param value to stack
	# LCall _PrintString
	  jal _PrintString   	# jump to function
	# PopParams 4
	  add $sp, $sp, 4	# pop params off stack
	# LCall _Halt
	  jal _Halt          	# jump to function
  _L162:
	# _tmp1670 = 4
	  li $t2, 4		# load constant value 4 into $t2
	  sw $t2, -2048($fp)	# spill _tmp1670 from $t2 to $fp-2048
	# _tmp1671 = _tmp1661 * _tmp1670
	  lw $t0, -2012($fp)	# fill _tmp1661 to $t0 from $fp-2012
	  lw $t1, -2048($fp)	# fill _tmp1670 to $t1 from $fp-2048
	  mul $t2, $t0, $t1	
	  sw $t2, -2052($fp)	# spill _tmp1671 from $t2 to $fp-2052
	# _tmp1672 = _tmp1671 + _tmp1670
	  lw $t0, -2052($fp)	# fill _tmp1671 to $t0 from $fp-2052
	  lw $t1, -2048($fp)	# fill _tmp1670 to $t1 from $fp-2048
	  add $t2, $t0, $t1	
	  sw $t2, -2056($fp)	# spill _tmp1672 from $t2 to $fp-2056
	# _tmp1673 = _tmp1660 + _tmp1672
	  lw $t0, -2008($fp)	# fill _tmp1660 to $t0 from $fp-2008
	  lw $t1, -2056($fp)	# fill _tmp1672 to $t1 from $fp-2056
	  add $t2, $t0, $t1	
	  sw $t2, -2060($fp)	# spill _tmp1673 from $t2 to $fp-2060
	# _tmp1674 = *(_tmp1673)
	  lw $t0, -2060($fp)	# fill _tmp1673 to $t0 from $fp-2060
	  lw $t2, 0($t0) 	# load with offset
	  sw $t2, -2064($fp)	# spill _tmp1674 from $t2 to $fp-2064
	# PushParam _tmp1674
	  subu $sp, $sp, 4	# decrement sp to make space for param
	  lw $t0, -2064($fp)	# fill _tmp1674 to $t0 from $fp-2064
	  sw $t0, 4($sp)	# copy param value to stack
	# _tmp1675 = *(_tmp1674)
	  lw $t0, -2064($fp)	# fill _tmp1674 to $t0 from $fp-2064
	  lw $t2, 0($t0) 	# load with offset
	  sw $t2, -2068($fp)	# spill _tmp1675 from $t2 to $fp-2068
	# _tmp1676 = *(_tmp1675 + 20)
	  lw $t0, -2068($fp)	# fill _tmp1675 to $t0 from $fp-2068
	  lw $t2, 20($t0) 	# load with offset
	  sw $t2, -2072($fp)	# spill _tmp1676 from $t2 to $fp-2072
	# _tmp1677 = ACall _tmp1676
	  lw $t0, -2072($fp)	# fill _tmp1676 to $t0 from $fp-2072
	  jalr $t0            	# jump to function
	  move $t2, $v0		# copy function return value from $v0
	  sw $t2, -2076($fp)	# spill _tmp1677 from $t2 to $fp-2076
	# PopParams 8
	  add $sp, $sp, 8	# pop params off stack
	# IfZ _tmp1677 Goto _L160
	  lw $t0, -2076($fp)	# fill _tmp1677 to $t0 from $fp-2076
	  beqz $t0, _L160	# branch if _tmp1677 is zero 
	# _tmp1678 = 0
	  li $t2, 0		# load constant value 0 into $t2
	  sw $t2, -2080($fp)	# spill _tmp1678 from $t2 to $fp-2080
	# _tmp1645 = _tmp1678
	  lw $t2, -2080($fp)	# fill _tmp1678 to $t2 from $fp-2080
	  sw $t2, -1948($fp)	# spill _tmp1645 from $t2 to $fp-1948
	# Goto _L159
	  b _L159		# unconditional branch
  _L160:
	# _tmp1679 = 1
	  li $t2, 1		# load constant value 1 into $t2
	  sw $t2, -2084($fp)	# spill _tmp1679 from $t2 to $fp-2084
	# _tmp1645 = _tmp1679
	  lw $t2, -2084($fp)	# fill _tmp1679 to $t2 from $fp-2084
	  sw $t2, -1948($fp)	# spill _tmp1645 from $t2 to $fp-1948
  _L159:
	# _tmp1680 = _tmp1644 && _tmp1645
	  lw $t0, -1944($fp)	# fill _tmp1644 to $t0 from $fp-1944
	  lw $t1, -1948($fp)	# fill _tmp1645 to $t1 from $fp-1948
	  and $t2, $t0, $t1	
	  sw $t2, -2088($fp)	# spill _tmp1680 from $t2 to $fp-2088
	# IfZ _tmp1680 Goto _L153
	  lw $t0, -2088($fp)	# fill _tmp1680 to $t0 from $fp-2088
	  beqz $t0, _L153	# branch if _tmp1680 is zero 
	# _tmp1681 = 1
	  li $t2, 1		# load constant value 1 into $t2
	  sw $t2, -2092($fp)	# spill _tmp1681 from $t2 to $fp-2092
	# row = _tmp1681
	  lw $t2, -2092($fp)	# fill _tmp1681 to $t2 from $fp-2092
	  sw $t2, -8($fp)	# spill row from $t2 to $fp-8
	# _tmp1682 = 0
	  li $t2, 0		# load constant value 0 into $t2
	  sw $t2, -2096($fp)	# spill _tmp1682 from $t2 to $fp-2096
	# column = _tmp1682
	  lw $t2, -2096($fp)	# fill _tmp1682 to $t2 from $fp-2096
	  sw $t2, -12($fp)	# spill column from $t2 to $fp-12
	# Goto _L154
	  b _L154		# unconditional branch
  _L153:
	# PushParam enemyMark
	  subu $sp, $sp, 4	# decrement sp to make space for param
	  lw $t0, 8($fp)	# fill enemyMark to $t0 from $fp+8
	  sw $t0, 4($sp)	# copy param value to stack
	# _tmp1683 = *(this + 4)
	  lw $t0, 4($fp)	# fill this to $t0 from $fp+4
	  lw $t2, 4($t0) 	# load with offset
	  sw $t2, -2100($fp)	# spill _tmp1683 from $t2 to $fp-2100
	# _tmp1684 = 2
	  li $t2, 2		# load constant value 2 into $t2
	  sw $t2, -2104($fp)	# spill _tmp1684 from $t2 to $fp-2104
	# _tmp1685 = 0
	  li $t2, 0		# load constant value 0 into $t2
	  sw $t2, -2108($fp)	# spill _tmp1685 from $t2 to $fp-2108
	# _tmp1686 = *(_tmp1683)
	  lw $t0, -2100($fp)	# fill _tmp1683 to $t0 from $fp-2100
	  lw $t2, 0($t0) 	# load with offset
	  sw $t2, -2112($fp)	# spill _tmp1686 from $t2 to $fp-2112
	# _tmp1687 = _tmp1684 < _tmp1685
	  lw $t0, -2104($fp)	# fill _tmp1684 to $t0 from $fp-2104
	  lw $t1, -2108($fp)	# fill _tmp1685 to $t1 from $fp-2108
	  slt $t2, $t0, $t1	
	  sw $t2, -2116($fp)	# spill _tmp1687 from $t2 to $fp-2116
	# _tmp1688 = _tmp1686 < _tmp1684
	  lw $t0, -2112($fp)	# fill _tmp1686 to $t0 from $fp-2112
	  lw $t1, -2104($fp)	# fill _tmp1684 to $t1 from $fp-2104
	  slt $t2, $t0, $t1	
	  sw $t2, -2120($fp)	# spill _tmp1688 from $t2 to $fp-2120
	# _tmp1689 = _tmp1686 == _tmp1684
	  lw $t0, -2112($fp)	# fill _tmp1686 to $t0 from $fp-2112
	  lw $t1, -2104($fp)	# fill _tmp1684 to $t1 from $fp-2104
	  seq $t2, $t0, $t1	
	  sw $t2, -2124($fp)	# spill _tmp1689 from $t2 to $fp-2124
	# _tmp1690 = _tmp1688 || _tmp1689
	  lw $t0, -2120($fp)	# fill _tmp1688 to $t0 from $fp-2120
	  lw $t1, -2124($fp)	# fill _tmp1689 to $t1 from $fp-2124
	  or $t2, $t0, $t1	
	  sw $t2, -2128($fp)	# spill _tmp1690 from $t2 to $fp-2128
	# _tmp1691 = _tmp1690 || _tmp1687
	  lw $t0, -2128($fp)	# fill _tmp1690 to $t0 from $fp-2128
	  lw $t1, -2116($fp)	# fill _tmp1687 to $t1 from $fp-2116
	  or $t2, $t0, $t1	
	  sw $t2, -2132($fp)	# spill _tmp1691 from $t2 to $fp-2132
	# IfZ _tmp1691 Goto _L165
	  lw $t0, -2132($fp)	# fill _tmp1691 to $t0 from $fp-2132
	  beqz $t0, _L165	# branch if _tmp1691 is zero 
	# _tmp1692 = "Decaf runtime error: Array subscript out of bound..."
	  .data			# create string constant marked with label
	  _string109: .asciiz "Decaf runtime error: Array subscript out of bounds\n"
	  .text
	  la $t2, _string109	# load label
	  sw $t2, -2136($fp)	# spill _tmp1692 from $t2 to $fp-2136
	# PushParam _tmp1692
	  subu $sp, $sp, 4	# decrement sp to make space for param
	  lw $t0, -2136($fp)	# fill _tmp1692 to $t0 from $fp-2136
	  sw $t0, 4($sp)	# copy param value to stack
	# LCall _PrintString
	  jal _PrintString   	# jump to function
	# PopParams 4
	  add $sp, $sp, 4	# pop params off stack
	# LCall _Halt
	  jal _Halt          	# jump to function
  _L165:
	# _tmp1693 = 4
	  li $t2, 4		# load constant value 4 into $t2
	  sw $t2, -2140($fp)	# spill _tmp1693 from $t2 to $fp-2140
	# _tmp1694 = _tmp1684 * _tmp1693
	  lw $t0, -2104($fp)	# fill _tmp1684 to $t0 from $fp-2104
	  lw $t1, -2140($fp)	# fill _tmp1693 to $t1 from $fp-2140
	  mul $t2, $t0, $t1	
	  sw $t2, -2144($fp)	# spill _tmp1694 from $t2 to $fp-2144
	# _tmp1695 = _tmp1694 + _tmp1693
	  lw $t0, -2144($fp)	# fill _tmp1694 to $t0 from $fp-2144
	  lw $t1, -2140($fp)	# fill _tmp1693 to $t1 from $fp-2140
	  add $t2, $t0, $t1	
	  sw $t2, -2148($fp)	# spill _tmp1695 from $t2 to $fp-2148
	# _tmp1696 = _tmp1683 + _tmp1695
	  lw $t0, -2100($fp)	# fill _tmp1683 to $t0 from $fp-2100
	  lw $t1, -2148($fp)	# fill _tmp1695 to $t1 from $fp-2148
	  add $t2, $t0, $t1	
	  sw $t2, -2152($fp)	# spill _tmp1696 from $t2 to $fp-2152
	# _tmp1697 = *(_tmp1696)
	  lw $t0, -2152($fp)	# fill _tmp1696 to $t0 from $fp-2152
	  lw $t2, 0($t0) 	# load with offset
	  sw $t2, -2156($fp)	# spill _tmp1697 from $t2 to $fp-2156
	# _tmp1698 = 2
	  li $t2, 2		# load constant value 2 into $t2
	  sw $t2, -2160($fp)	# spill _tmp1698 from $t2 to $fp-2160
	# _tmp1699 = 0
	  li $t2, 0		# load constant value 0 into $t2
	  sw $t2, -2164($fp)	# spill _tmp1699 from $t2 to $fp-2164
	# _tmp1700 = *(_tmp1697)
	  lw $t0, -2156($fp)	# fill _tmp1697 to $t0 from $fp-2156
	  lw $t2, 0($t0) 	# load with offset
	  sw $t2, -2168($fp)	# spill _tmp1700 from $t2 to $fp-2168
	# _tmp1701 = _tmp1698 < _tmp1699
	  lw $t0, -2160($fp)	# fill _tmp1698 to $t0 from $fp-2160
	  lw $t1, -2164($fp)	# fill _tmp1699 to $t1 from $fp-2164
	  slt $t2, $t0, $t1	
	  sw $t2, -2172($fp)	# spill _tmp1701 from $t2 to $fp-2172
	# _tmp1702 = _tmp1700 < _tmp1698
	  lw $t0, -2168($fp)	# fill _tmp1700 to $t0 from $fp-2168
	  lw $t1, -2160($fp)	# fill _tmp1698 to $t1 from $fp-2160
	  slt $t2, $t0, $t1	
	  sw $t2, -2176($fp)	# spill _tmp1702 from $t2 to $fp-2176
	# _tmp1703 = _tmp1700 == _tmp1698
	  lw $t0, -2168($fp)	# fill _tmp1700 to $t0 from $fp-2168
	  lw $t1, -2160($fp)	# fill _tmp1698 to $t1 from $fp-2160
	  seq $t2, $t0, $t1	
	  sw $t2, -2180($fp)	# spill _tmp1703 from $t2 to $fp-2180
	# _tmp1704 = _tmp1702 || _tmp1703
	  lw $t0, -2176($fp)	# fill _tmp1702 to $t0 from $fp-2176
	  lw $t1, -2180($fp)	# fill _tmp1703 to $t1 from $fp-2180
	  or $t2, $t0, $t1	
	  sw $t2, -2184($fp)	# spill _tmp1704 from $t2 to $fp-2184
	# _tmp1705 = _tmp1704 || _tmp1701
	  lw $t0, -2184($fp)	# fill _tmp1704 to $t0 from $fp-2184
	  lw $t1, -2172($fp)	# fill _tmp1701 to $t1 from $fp-2172
	  or $t2, $t0, $t1	
	  sw $t2, -2188($fp)	# spill _tmp1705 from $t2 to $fp-2188
	# IfZ _tmp1705 Goto _L166
	  lw $t0, -2188($fp)	# fill _tmp1705 to $t0 from $fp-2188
	  beqz $t0, _L166	# branch if _tmp1705 is zero 
	# _tmp1706 = "Decaf runtime error: Array subscript out of bound..."
	  .data			# create string constant marked with label
	  _string110: .asciiz "Decaf runtime error: Array subscript out of bounds\n"
	  .text
	  la $t2, _string110	# load label
	  sw $t2, -2192($fp)	# spill _tmp1706 from $t2 to $fp-2192
	# PushParam _tmp1706
	  subu $sp, $sp, 4	# decrement sp to make space for param
	  lw $t0, -2192($fp)	# fill _tmp1706 to $t0 from $fp-2192
	  sw $t0, 4($sp)	# copy param value to stack
	# LCall _PrintString
	  jal _PrintString   	# jump to function
	# PopParams 4
	  add $sp, $sp, 4	# pop params off stack
	# LCall _Halt
	  jal _Halt          	# jump to function
  _L166:
	# _tmp1707 = 4
	  li $t2, 4		# load constant value 4 into $t2
	  sw $t2, -2196($fp)	# spill _tmp1707 from $t2 to $fp-2196
	# _tmp1708 = _tmp1698 * _tmp1707
	  lw $t0, -2160($fp)	# fill _tmp1698 to $t0 from $fp-2160
	  lw $t1, -2196($fp)	# fill _tmp1707 to $t1 from $fp-2196
	  mul $t2, $t0, $t1	
	  sw $t2, -2200($fp)	# spill _tmp1708 from $t2 to $fp-2200
	# _tmp1709 = _tmp1708 + _tmp1707
	  lw $t0, -2200($fp)	# fill _tmp1708 to $t0 from $fp-2200
	  lw $t1, -2196($fp)	# fill _tmp1707 to $t1 from $fp-2196
	  add $t2, $t0, $t1	
	  sw $t2, -2204($fp)	# spill _tmp1709 from $t2 to $fp-2204
	# _tmp1710 = _tmp1697 + _tmp1709
	  lw $t0, -2156($fp)	# fill _tmp1697 to $t0 from $fp-2156
	  lw $t1, -2204($fp)	# fill _tmp1709 to $t1 from $fp-2204
	  add $t2, $t0, $t1	
	  sw $t2, -2208($fp)	# spill _tmp1710 from $t2 to $fp-2208
	# _tmp1711 = *(_tmp1710)
	  lw $t0, -2208($fp)	# fill _tmp1710 to $t0 from $fp-2208
	  lw $t2, 0($t0) 	# load with offset
	  sw $t2, -2212($fp)	# spill _tmp1711 from $t2 to $fp-2212
	# PushParam _tmp1711
	  subu $sp, $sp, 4	# decrement sp to make space for param
	  lw $t0, -2212($fp)	# fill _tmp1711 to $t0 from $fp-2212
	  sw $t0, 4($sp)	# copy param value to stack
	# _tmp1712 = *(_tmp1711)
	  lw $t0, -2212($fp)	# fill _tmp1711 to $t0 from $fp-2212
	  lw $t2, 0($t0) 	# load with offset
	  sw $t2, -2216($fp)	# spill _tmp1712 from $t2 to $fp-2216
	# _tmp1713 = *(_tmp1712 + 20)
	  lw $t0, -2216($fp)	# fill _tmp1712 to $t0 from $fp-2216
	  lw $t2, 20($t0) 	# load with offset
	  sw $t2, -2220($fp)	# spill _tmp1713 from $t2 to $fp-2220
	# _tmp1714 = ACall _tmp1713
	  lw $t0, -2220($fp)	# fill _tmp1713 to $t0 from $fp-2220
	  jalr $t0            	# jump to function
	  move $t2, $v0		# copy function return value from $v0
	  sw $t2, -2224($fp)	# spill _tmp1714 from $t2 to $fp-2224
	# PopParams 8
	  add $sp, $sp, 8	# pop params off stack
	# PushParam enemyMark
	  subu $sp, $sp, 4	# decrement sp to make space for param
	  lw $t0, 8($fp)	# fill enemyMark to $t0 from $fp+8
	  sw $t0, 4($sp)	# copy param value to stack
	# _tmp1715 = *(this + 4)
	  lw $t0, 4($fp)	# fill this to $t0 from $fp+4
	  lw $t2, 4($t0) 	# load with offset
	  sw $t2, -2228($fp)	# spill _tmp1715 from $t2 to $fp-2228
	# _tmp1716 = 2
	  li $t2, 2		# load constant value 2 into $t2
	  sw $t2, -2232($fp)	# spill _tmp1716 from $t2 to $fp-2232
	# _tmp1717 = 0
	  li $t2, 0		# load constant value 0 into $t2
	  sw $t2, -2236($fp)	# spill _tmp1717 from $t2 to $fp-2236
	# _tmp1718 = *(_tmp1715)
	  lw $t0, -2228($fp)	# fill _tmp1715 to $t0 from $fp-2228
	  lw $t2, 0($t0) 	# load with offset
	  sw $t2, -2240($fp)	# spill _tmp1718 from $t2 to $fp-2240
	# _tmp1719 = _tmp1716 < _tmp1717
	  lw $t0, -2232($fp)	# fill _tmp1716 to $t0 from $fp-2232
	  lw $t1, -2236($fp)	# fill _tmp1717 to $t1 from $fp-2236
	  slt $t2, $t0, $t1	
	  sw $t2, -2244($fp)	# spill _tmp1719 from $t2 to $fp-2244
	# _tmp1720 = _tmp1718 < _tmp1716
	  lw $t0, -2240($fp)	# fill _tmp1718 to $t0 from $fp-2240
	  lw $t1, -2232($fp)	# fill _tmp1716 to $t1 from $fp-2232
	  slt $t2, $t0, $t1	
	  sw $t2, -2248($fp)	# spill _tmp1720 from $t2 to $fp-2248
	# _tmp1721 = _tmp1718 == _tmp1716
	  lw $t0, -2240($fp)	# fill _tmp1718 to $t0 from $fp-2240
	  lw $t1, -2232($fp)	# fill _tmp1716 to $t1 from $fp-2232
	  seq $t2, $t0, $t1	
	  sw $t2, -2252($fp)	# spill _tmp1721 from $t2 to $fp-2252
	# _tmp1722 = _tmp1720 || _tmp1721
	  lw $t0, -2248($fp)	# fill _tmp1720 to $t0 from $fp-2248
	  lw $t1, -2252($fp)	# fill _tmp1721 to $t1 from $fp-2252
	  or $t2, $t0, $t1	
	  sw $t2, -2256($fp)	# spill _tmp1722 from $t2 to $fp-2256
	# _tmp1723 = _tmp1722 || _tmp1719
	  lw $t0, -2256($fp)	# fill _tmp1722 to $t0 from $fp-2256
	  lw $t1, -2244($fp)	# fill _tmp1719 to $t1 from $fp-2244
	  or $t2, $t0, $t1	
	  sw $t2, -2260($fp)	# spill _tmp1723 from $t2 to $fp-2260
	# IfZ _tmp1723 Goto _L167
	  lw $t0, -2260($fp)	# fill _tmp1723 to $t0 from $fp-2260
	  beqz $t0, _L167	# branch if _tmp1723 is zero 
	# _tmp1724 = "Decaf runtime error: Array subscript out of bound..."
	  .data			# create string constant marked with label
	  _string111: .asciiz "Decaf runtime error: Array subscript out of bounds\n"
	  .text
	  la $t2, _string111	# load label
	  sw $t2, -2264($fp)	# spill _tmp1724 from $t2 to $fp-2264
	# PushParam _tmp1724
	  subu $sp, $sp, 4	# decrement sp to make space for param
	  lw $t0, -2264($fp)	# fill _tmp1724 to $t0 from $fp-2264
	  sw $t0, 4($sp)	# copy param value to stack
	# LCall _PrintString
	  jal _PrintString   	# jump to function
	# PopParams 4
	  add $sp, $sp, 4	# pop params off stack
	# LCall _Halt
	  jal _Halt          	# jump to function
  _L167:
	# _tmp1725 = 4
	  li $t2, 4		# load constant value 4 into $t2
	  sw $t2, -2268($fp)	# spill _tmp1725 from $t2 to $fp-2268
	# _tmp1726 = _tmp1716 * _tmp1725
	  lw $t0, -2232($fp)	# fill _tmp1716 to $t0 from $fp-2232
	  lw $t1, -2268($fp)	# fill _tmp1725 to $t1 from $fp-2268
	  mul $t2, $t0, $t1	
	  sw $t2, -2272($fp)	# spill _tmp1726 from $t2 to $fp-2272
	# _tmp1727 = _tmp1726 + _tmp1725
	  lw $t0, -2272($fp)	# fill _tmp1726 to $t0 from $fp-2272
	  lw $t1, -2268($fp)	# fill _tmp1725 to $t1 from $fp-2268
	  add $t2, $t0, $t1	
	  sw $t2, -2276($fp)	# spill _tmp1727 from $t2 to $fp-2276
	# _tmp1728 = _tmp1715 + _tmp1727
	  lw $t0, -2228($fp)	# fill _tmp1715 to $t0 from $fp-2228
	  lw $t1, -2276($fp)	# fill _tmp1727 to $t1 from $fp-2276
	  add $t2, $t0, $t1	
	  sw $t2, -2280($fp)	# spill _tmp1728 from $t2 to $fp-2280
	# _tmp1729 = *(_tmp1728)
	  lw $t0, -2280($fp)	# fill _tmp1728 to $t0 from $fp-2280
	  lw $t2, 0($t0) 	# load with offset
	  sw $t2, -2284($fp)	# spill _tmp1729 from $t2 to $fp-2284
	# _tmp1730 = 1
	  li $t2, 1		# load constant value 1 into $t2
	  sw $t2, -2288($fp)	# spill _tmp1730 from $t2 to $fp-2288
	# _tmp1731 = 0
	  li $t2, 0		# load constant value 0 into $t2
	  sw $t2, -2292($fp)	# spill _tmp1731 from $t2 to $fp-2292
	# _tmp1732 = *(_tmp1729)
	  lw $t0, -2284($fp)	# fill _tmp1729 to $t0 from $fp-2284
	  lw $t2, 0($t0) 	# load with offset
	  sw $t2, -2296($fp)	# spill _tmp1732 from $t2 to $fp-2296
	# _tmp1733 = _tmp1730 < _tmp1731
	  lw $t0, -2288($fp)	# fill _tmp1730 to $t0 from $fp-2288
	  lw $t1, -2292($fp)	# fill _tmp1731 to $t1 from $fp-2292
	  slt $t2, $t0, $t1	
	  sw $t2, -2300($fp)	# spill _tmp1733 from $t2 to $fp-2300
	# _tmp1734 = _tmp1732 < _tmp1730
	  lw $t0, -2296($fp)	# fill _tmp1732 to $t0 from $fp-2296
	  lw $t1, -2288($fp)	# fill _tmp1730 to $t1 from $fp-2288
	  slt $t2, $t0, $t1	
	  sw $t2, -2304($fp)	# spill _tmp1734 from $t2 to $fp-2304
	# _tmp1735 = _tmp1732 == _tmp1730
	  lw $t0, -2296($fp)	# fill _tmp1732 to $t0 from $fp-2296
	  lw $t1, -2288($fp)	# fill _tmp1730 to $t1 from $fp-2288
	  seq $t2, $t0, $t1	
	  sw $t2, -2308($fp)	# spill _tmp1735 from $t2 to $fp-2308
	# _tmp1736 = _tmp1734 || _tmp1735
	  lw $t0, -2304($fp)	# fill _tmp1734 to $t0 from $fp-2304
	  lw $t1, -2308($fp)	# fill _tmp1735 to $t1 from $fp-2308
	  or $t2, $t0, $t1	
	  sw $t2, -2312($fp)	# spill _tmp1736 from $t2 to $fp-2312
	# _tmp1737 = _tmp1736 || _tmp1733
	  lw $t0, -2312($fp)	# fill _tmp1736 to $t0 from $fp-2312
	  lw $t1, -2300($fp)	# fill _tmp1733 to $t1 from $fp-2300
	  or $t2, $t0, $t1	
	  sw $t2, -2316($fp)	# spill _tmp1737 from $t2 to $fp-2316
	# IfZ _tmp1737 Goto _L168
	  lw $t0, -2316($fp)	# fill _tmp1737 to $t0 from $fp-2316
	  beqz $t0, _L168	# branch if _tmp1737 is zero 
	# _tmp1738 = "Decaf runtime error: Array subscript out of bound..."
	  .data			# create string constant marked with label
	  _string112: .asciiz "Decaf runtime error: Array subscript out of bounds\n"
	  .text
	  la $t2, _string112	# load label
	  sw $t2, -2320($fp)	# spill _tmp1738 from $t2 to $fp-2320
	# PushParam _tmp1738
	  subu $sp, $sp, 4	# decrement sp to make space for param
	  lw $t0, -2320($fp)	# fill _tmp1738 to $t0 from $fp-2320
	  sw $t0, 4($sp)	# copy param value to stack
	# LCall _PrintString
	  jal _PrintString   	# jump to function
	# PopParams 4
	  add $sp, $sp, 4	# pop params off stack
	# LCall _Halt
	  jal _Halt          	# jump to function
  _L168:
	# _tmp1739 = 4
	  li $t2, 4		# load constant value 4 into $t2
	  sw $t2, -2324($fp)	# spill _tmp1739 from $t2 to $fp-2324
	# _tmp1740 = _tmp1730 * _tmp1739
	  lw $t0, -2288($fp)	# fill _tmp1730 to $t0 from $fp-2288
	  lw $t1, -2324($fp)	# fill _tmp1739 to $t1 from $fp-2324
	  mul $t2, $t0, $t1	
	  sw $t2, -2328($fp)	# spill _tmp1740 from $t2 to $fp-2328
	# _tmp1741 = _tmp1740 + _tmp1739
	  lw $t0, -2328($fp)	# fill _tmp1740 to $t0 from $fp-2328
	  lw $t1, -2324($fp)	# fill _tmp1739 to $t1 from $fp-2324
	  add $t2, $t0, $t1	
	  sw $t2, -2332($fp)	# spill _tmp1741 from $t2 to $fp-2332
	# _tmp1742 = _tmp1729 + _tmp1741
	  lw $t0, -2284($fp)	# fill _tmp1729 to $t0 from $fp-2284
	  lw $t1, -2332($fp)	# fill _tmp1741 to $t1 from $fp-2332
	  add $t2, $t0, $t1	
	  sw $t2, -2336($fp)	# spill _tmp1742 from $t2 to $fp-2336
	# _tmp1743 = *(_tmp1742)
	  lw $t0, -2336($fp)	# fill _tmp1742 to $t0 from $fp-2336
	  lw $t2, 0($t0) 	# load with offset
	  sw $t2, -2340($fp)	# spill _tmp1743 from $t2 to $fp-2340
	# PushParam _tmp1743
	  subu $sp, $sp, 4	# decrement sp to make space for param
	  lw $t0, -2340($fp)	# fill _tmp1743 to $t0 from $fp-2340
	  sw $t0, 4($sp)	# copy param value to stack
	# _tmp1744 = *(_tmp1743)
	  lw $t0, -2340($fp)	# fill _tmp1743 to $t0 from $fp-2340
	  lw $t2, 0($t0) 	# load with offset
	  sw $t2, -2344($fp)	# spill _tmp1744 from $t2 to $fp-2344
	# _tmp1745 = *(_tmp1744 + 20)
	  lw $t0, -2344($fp)	# fill _tmp1744 to $t0 from $fp-2344
	  lw $t2, 20($t0) 	# load with offset
	  sw $t2, -2348($fp)	# spill _tmp1745 from $t2 to $fp-2348
	# _tmp1746 = ACall _tmp1745
	  lw $t0, -2348($fp)	# fill _tmp1745 to $t0 from $fp-2348
	  jalr $t0            	# jump to function
	  move $t2, $v0		# copy function return value from $v0
	  sw $t2, -2352($fp)	# spill _tmp1746 from $t2 to $fp-2352
	# PopParams 8
	  add $sp, $sp, 8	# pop params off stack
	# _tmp1747 = _tmp1714 && _tmp1746
	  lw $t0, -2224($fp)	# fill _tmp1714 to $t0 from $fp-2224
	  lw $t1, -2352($fp)	# fill _tmp1746 to $t1 from $fp-2352
	  and $t2, $t0, $t1	
	  sw $t2, -2356($fp)	# spill _tmp1747 from $t2 to $fp-2356
	# PushParam playerMark
	  subu $sp, $sp, 4	# decrement sp to make space for param
	  lw $t0, 12($fp)	# fill playerMark to $t0 from $fp+12
	  sw $t0, 4($sp)	# copy param value to stack
	# _tmp1749 = *(this + 4)
	  lw $t0, 4($fp)	# fill this to $t0 from $fp+4
	  lw $t2, 4($t0) 	# load with offset
	  sw $t2, -2364($fp)	# spill _tmp1749 from $t2 to $fp-2364
	# _tmp1750 = 2
	  li $t2, 2		# load constant value 2 into $t2
	  sw $t2, -2368($fp)	# spill _tmp1750 from $t2 to $fp-2368
	# _tmp1751 = 0
	  li $t2, 0		# load constant value 0 into $t2
	  sw $t2, -2372($fp)	# spill _tmp1751 from $t2 to $fp-2372
	# _tmp1752 = *(_tmp1749)
	  lw $t0, -2364($fp)	# fill _tmp1749 to $t0 from $fp-2364
	  lw $t2, 0($t0) 	# load with offset
	  sw $t2, -2376($fp)	# spill _tmp1752 from $t2 to $fp-2376
	# _tmp1753 = _tmp1750 < _tmp1751
	  lw $t0, -2368($fp)	# fill _tmp1750 to $t0 from $fp-2368
	  lw $t1, -2372($fp)	# fill _tmp1751 to $t1 from $fp-2372
	  slt $t2, $t0, $t1	
	  sw $t2, -2380($fp)	# spill _tmp1753 from $t2 to $fp-2380
	# _tmp1754 = _tmp1752 < _tmp1750
	  lw $t0, -2376($fp)	# fill _tmp1752 to $t0 from $fp-2376
	  lw $t1, -2368($fp)	# fill _tmp1750 to $t1 from $fp-2368
	  slt $t2, $t0, $t1	
	  sw $t2, -2384($fp)	# spill _tmp1754 from $t2 to $fp-2384
	# _tmp1755 = _tmp1752 == _tmp1750
	  lw $t0, -2376($fp)	# fill _tmp1752 to $t0 from $fp-2376
	  lw $t1, -2368($fp)	# fill _tmp1750 to $t1 from $fp-2368
	  seq $t2, $t0, $t1	
	  sw $t2, -2388($fp)	# spill _tmp1755 from $t2 to $fp-2388
	# _tmp1756 = _tmp1754 || _tmp1755
	  lw $t0, -2384($fp)	# fill _tmp1754 to $t0 from $fp-2384
	  lw $t1, -2388($fp)	# fill _tmp1755 to $t1 from $fp-2388
	  or $t2, $t0, $t1	
	  sw $t2, -2392($fp)	# spill _tmp1756 from $t2 to $fp-2392
	# _tmp1757 = _tmp1756 || _tmp1753
	  lw $t0, -2392($fp)	# fill _tmp1756 to $t0 from $fp-2392
	  lw $t1, -2380($fp)	# fill _tmp1753 to $t1 from $fp-2380
	  or $t2, $t0, $t1	
	  sw $t2, -2396($fp)	# spill _tmp1757 from $t2 to $fp-2396
	# IfZ _tmp1757 Goto _L171
	  lw $t0, -2396($fp)	# fill _tmp1757 to $t0 from $fp-2396
	  beqz $t0, _L171	# branch if _tmp1757 is zero 
	# _tmp1758 = "Decaf runtime error: Array subscript out of bound..."
	  .data			# create string constant marked with label
	  _string113: .asciiz "Decaf runtime error: Array subscript out of bounds\n"
	  .text
	  la $t2, _string113	# load label
	  sw $t2, -2400($fp)	# spill _tmp1758 from $t2 to $fp-2400
	# PushParam _tmp1758
	  subu $sp, $sp, 4	# decrement sp to make space for param
	  lw $t0, -2400($fp)	# fill _tmp1758 to $t0 from $fp-2400
	  sw $t0, 4($sp)	# copy param value to stack
	# LCall _PrintString
	  jal _PrintString   	# jump to function
	# PopParams 4
	  add $sp, $sp, 4	# pop params off stack
	# LCall _Halt
	  jal _Halt          	# jump to function
  _L171:
	# _tmp1759 = 4
	  li $t2, 4		# load constant value 4 into $t2
	  sw $t2, -2404($fp)	# spill _tmp1759 from $t2 to $fp-2404
	# _tmp1760 = _tmp1750 * _tmp1759
	  lw $t0, -2368($fp)	# fill _tmp1750 to $t0 from $fp-2368
	  lw $t1, -2404($fp)	# fill _tmp1759 to $t1 from $fp-2404
	  mul $t2, $t0, $t1	
	  sw $t2, -2408($fp)	# spill _tmp1760 from $t2 to $fp-2408
	# _tmp1761 = _tmp1760 + _tmp1759
	  lw $t0, -2408($fp)	# fill _tmp1760 to $t0 from $fp-2408
	  lw $t1, -2404($fp)	# fill _tmp1759 to $t1 from $fp-2404
	  add $t2, $t0, $t1	
	  sw $t2, -2412($fp)	# spill _tmp1761 from $t2 to $fp-2412
	# _tmp1762 = _tmp1749 + _tmp1761
	  lw $t0, -2364($fp)	# fill _tmp1749 to $t0 from $fp-2364
	  lw $t1, -2412($fp)	# fill _tmp1761 to $t1 from $fp-2412
	  add $t2, $t0, $t1	
	  sw $t2, -2416($fp)	# spill _tmp1762 from $t2 to $fp-2416
	# _tmp1763 = *(_tmp1762)
	  lw $t0, -2416($fp)	# fill _tmp1762 to $t0 from $fp-2416
	  lw $t2, 0($t0) 	# load with offset
	  sw $t2, -2420($fp)	# spill _tmp1763 from $t2 to $fp-2420
	# _tmp1764 = 0
	  li $t2, 0		# load constant value 0 into $t2
	  sw $t2, -2424($fp)	# spill _tmp1764 from $t2 to $fp-2424
	# _tmp1765 = 0
	  li $t2, 0		# load constant value 0 into $t2
	  sw $t2, -2428($fp)	# spill _tmp1765 from $t2 to $fp-2428
	# _tmp1766 = *(_tmp1763)
	  lw $t0, -2420($fp)	# fill _tmp1763 to $t0 from $fp-2420
	  lw $t2, 0($t0) 	# load with offset
	  sw $t2, -2432($fp)	# spill _tmp1766 from $t2 to $fp-2432
	# _tmp1767 = _tmp1764 < _tmp1765
	  lw $t0, -2424($fp)	# fill _tmp1764 to $t0 from $fp-2424
	  lw $t1, -2428($fp)	# fill _tmp1765 to $t1 from $fp-2428
	  slt $t2, $t0, $t1	
	  sw $t2, -2436($fp)	# spill _tmp1767 from $t2 to $fp-2436
	# _tmp1768 = _tmp1766 < _tmp1764
	  lw $t0, -2432($fp)	# fill _tmp1766 to $t0 from $fp-2432
	  lw $t1, -2424($fp)	# fill _tmp1764 to $t1 from $fp-2424
	  slt $t2, $t0, $t1	
	  sw $t2, -2440($fp)	# spill _tmp1768 from $t2 to $fp-2440
	# _tmp1769 = _tmp1766 == _tmp1764
	  lw $t0, -2432($fp)	# fill _tmp1766 to $t0 from $fp-2432
	  lw $t1, -2424($fp)	# fill _tmp1764 to $t1 from $fp-2424
	  seq $t2, $t0, $t1	
	  sw $t2, -2444($fp)	# spill _tmp1769 from $t2 to $fp-2444
	# _tmp1770 = _tmp1768 || _tmp1769
	  lw $t0, -2440($fp)	# fill _tmp1768 to $t0 from $fp-2440
	  lw $t1, -2444($fp)	# fill _tmp1769 to $t1 from $fp-2444
	  or $t2, $t0, $t1	
	  sw $t2, -2448($fp)	# spill _tmp1770 from $t2 to $fp-2448
	# _tmp1771 = _tmp1770 || _tmp1767
	  lw $t0, -2448($fp)	# fill _tmp1770 to $t0 from $fp-2448
	  lw $t1, -2436($fp)	# fill _tmp1767 to $t1 from $fp-2436
	  or $t2, $t0, $t1	
	  sw $t2, -2452($fp)	# spill _tmp1771 from $t2 to $fp-2452
	# IfZ _tmp1771 Goto _L172
	  lw $t0, -2452($fp)	# fill _tmp1771 to $t0 from $fp-2452
	  beqz $t0, _L172	# branch if _tmp1771 is zero 
	# _tmp1772 = "Decaf runtime error: Array subscript out of bound..."
	  .data			# create string constant marked with label
	  _string114: .asciiz "Decaf runtime error: Array subscript out of bounds\n"
	  .text
	  la $t2, _string114	# load label
	  sw $t2, -2456($fp)	# spill _tmp1772 from $t2 to $fp-2456
	# PushParam _tmp1772
	  subu $sp, $sp, 4	# decrement sp to make space for param
	  lw $t0, -2456($fp)	# fill _tmp1772 to $t0 from $fp-2456
	  sw $t0, 4($sp)	# copy param value to stack
	# LCall _PrintString
	  jal _PrintString   	# jump to function
	# PopParams 4
	  add $sp, $sp, 4	# pop params off stack
	# LCall _Halt
	  jal _Halt          	# jump to function
  _L172:
	# _tmp1773 = 4
	  li $t2, 4		# load constant value 4 into $t2
	  sw $t2, -2460($fp)	# spill _tmp1773 from $t2 to $fp-2460
	# _tmp1774 = _tmp1764 * _tmp1773
	  lw $t0, -2424($fp)	# fill _tmp1764 to $t0 from $fp-2424
	  lw $t1, -2460($fp)	# fill _tmp1773 to $t1 from $fp-2460
	  mul $t2, $t0, $t1	
	  sw $t2, -2464($fp)	# spill _tmp1774 from $t2 to $fp-2464
	# _tmp1775 = _tmp1774 + _tmp1773
	  lw $t0, -2464($fp)	# fill _tmp1774 to $t0 from $fp-2464
	  lw $t1, -2460($fp)	# fill _tmp1773 to $t1 from $fp-2460
	  add $t2, $t0, $t1	
	  sw $t2, -2468($fp)	# spill _tmp1775 from $t2 to $fp-2468
	# _tmp1776 = _tmp1763 + _tmp1775
	  lw $t0, -2420($fp)	# fill _tmp1763 to $t0 from $fp-2420
	  lw $t1, -2468($fp)	# fill _tmp1775 to $t1 from $fp-2468
	  add $t2, $t0, $t1	
	  sw $t2, -2472($fp)	# spill _tmp1776 from $t2 to $fp-2472
	# _tmp1777 = *(_tmp1776)
	  lw $t0, -2472($fp)	# fill _tmp1776 to $t0 from $fp-2472
	  lw $t2, 0($t0) 	# load with offset
	  sw $t2, -2476($fp)	# spill _tmp1777 from $t2 to $fp-2476
	# PushParam _tmp1777
	  subu $sp, $sp, 4	# decrement sp to make space for param
	  lw $t0, -2476($fp)	# fill _tmp1777 to $t0 from $fp-2476
	  sw $t0, 4($sp)	# copy param value to stack
	# _tmp1778 = *(_tmp1777)
	  lw $t0, -2476($fp)	# fill _tmp1777 to $t0 from $fp-2476
	  lw $t2, 0($t0) 	# load with offset
	  sw $t2, -2480($fp)	# spill _tmp1778 from $t2 to $fp-2480
	# _tmp1779 = *(_tmp1778 + 20)
	  lw $t0, -2480($fp)	# fill _tmp1778 to $t0 from $fp-2480
	  lw $t2, 20($t0) 	# load with offset
	  sw $t2, -2484($fp)	# spill _tmp1779 from $t2 to $fp-2484
	# _tmp1780 = ACall _tmp1779
	  lw $t0, -2484($fp)	# fill _tmp1779 to $t0 from $fp-2484
	  jalr $t0            	# jump to function
	  move $t2, $v0		# copy function return value from $v0
	  sw $t2, -2488($fp)	# spill _tmp1780 from $t2 to $fp-2488
	# PopParams 8
	  add $sp, $sp, 8	# pop params off stack
	# IfZ _tmp1780 Goto _L170
	  lw $t0, -2488($fp)	# fill _tmp1780 to $t0 from $fp-2488
	  beqz $t0, _L170	# branch if _tmp1780 is zero 
	# _tmp1781 = 0
	  li $t2, 0		# load constant value 0 into $t2
	  sw $t2, -2492($fp)	# spill _tmp1781 from $t2 to $fp-2492
	# _tmp1748 = _tmp1781
	  lw $t2, -2492($fp)	# fill _tmp1781 to $t2 from $fp-2492
	  sw $t2, -2360($fp)	# spill _tmp1748 from $t2 to $fp-2360
	# Goto _L169
	  b _L169		# unconditional branch
  _L170:
	# _tmp1782 = 1
	  li $t2, 1		# load constant value 1 into $t2
	  sw $t2, -2496($fp)	# spill _tmp1782 from $t2 to $fp-2496
	# _tmp1748 = _tmp1782
	  lw $t2, -2496($fp)	# fill _tmp1782 to $t2 from $fp-2496
	  sw $t2, -2360($fp)	# spill _tmp1748 from $t2 to $fp-2360
  _L169:
	# _tmp1783 = _tmp1747 && _tmp1748
	  lw $t0, -2356($fp)	# fill _tmp1747 to $t0 from $fp-2356
	  lw $t1, -2360($fp)	# fill _tmp1748 to $t1 from $fp-2360
	  and $t2, $t0, $t1	
	  sw $t2, -2500($fp)	# spill _tmp1783 from $t2 to $fp-2500
	# IfZ _tmp1783 Goto _L163
	  lw $t0, -2500($fp)	# fill _tmp1783 to $t0 from $fp-2500
	  beqz $t0, _L163	# branch if _tmp1783 is zero 
	# _tmp1784 = 2
	  li $t2, 2		# load constant value 2 into $t2
	  sw $t2, -2504($fp)	# spill _tmp1784 from $t2 to $fp-2504
	# row = _tmp1784
	  lw $t2, -2504($fp)	# fill _tmp1784 to $t2 from $fp-2504
	  sw $t2, -8($fp)	# spill row from $t2 to $fp-8
	# _tmp1785 = 0
	  li $t2, 0		# load constant value 0 into $t2
	  sw $t2, -2508($fp)	# spill _tmp1785 from $t2 to $fp-2508
	# column = _tmp1785
	  lw $t2, -2508($fp)	# fill _tmp1785 to $t2 from $fp-2508
	  sw $t2, -12($fp)	# spill column from $t2 to $fp-12
	# Goto _L164
	  b _L164		# unconditional branch
  _L163:
	# PushParam enemyMark
	  subu $sp, $sp, 4	# decrement sp to make space for param
	  lw $t0, 8($fp)	# fill enemyMark to $t0 from $fp+8
	  sw $t0, 4($sp)	# copy param value to stack
	# _tmp1786 = *(this + 4)
	  lw $t0, 4($fp)	# fill this to $t0 from $fp+4
	  lw $t2, 4($t0) 	# load with offset
	  sw $t2, -2512($fp)	# spill _tmp1786 from $t2 to $fp-2512
	# _tmp1787 = 0
	  li $t2, 0		# load constant value 0 into $t2
	  sw $t2, -2516($fp)	# spill _tmp1787 from $t2 to $fp-2516
	# _tmp1788 = 0
	  li $t2, 0		# load constant value 0 into $t2
	  sw $t2, -2520($fp)	# spill _tmp1788 from $t2 to $fp-2520
	# _tmp1789 = *(_tmp1786)
	  lw $t0, -2512($fp)	# fill _tmp1786 to $t0 from $fp-2512
	  lw $t2, 0($t0) 	# load with offset
	  sw $t2, -2524($fp)	# spill _tmp1789 from $t2 to $fp-2524
	# _tmp1790 = _tmp1787 < _tmp1788
	  lw $t0, -2516($fp)	# fill _tmp1787 to $t0 from $fp-2516
	  lw $t1, -2520($fp)	# fill _tmp1788 to $t1 from $fp-2520
	  slt $t2, $t0, $t1	
	  sw $t2, -2528($fp)	# spill _tmp1790 from $t2 to $fp-2528
	# _tmp1791 = _tmp1789 < _tmp1787
	  lw $t0, -2524($fp)	# fill _tmp1789 to $t0 from $fp-2524
	  lw $t1, -2516($fp)	# fill _tmp1787 to $t1 from $fp-2516
	  slt $t2, $t0, $t1	
	  sw $t2, -2532($fp)	# spill _tmp1791 from $t2 to $fp-2532
	# _tmp1792 = _tmp1789 == _tmp1787
	  lw $t0, -2524($fp)	# fill _tmp1789 to $t0 from $fp-2524
	  lw $t1, -2516($fp)	# fill _tmp1787 to $t1 from $fp-2516
	  seq $t2, $t0, $t1	
	  sw $t2, -2536($fp)	# spill _tmp1792 from $t2 to $fp-2536
	# _tmp1793 = _tmp1791 || _tmp1792
	  lw $t0, -2532($fp)	# fill _tmp1791 to $t0 from $fp-2532
	  lw $t1, -2536($fp)	# fill _tmp1792 to $t1 from $fp-2536
	  or $t2, $t0, $t1	
	  sw $t2, -2540($fp)	# spill _tmp1793 from $t2 to $fp-2540
	# _tmp1794 = _tmp1793 || _tmp1790
	  lw $t0, -2540($fp)	# fill _tmp1793 to $t0 from $fp-2540
	  lw $t1, -2528($fp)	# fill _tmp1790 to $t1 from $fp-2528
	  or $t2, $t0, $t1	
	  sw $t2, -2544($fp)	# spill _tmp1794 from $t2 to $fp-2544
	# IfZ _tmp1794 Goto _L175
	  lw $t0, -2544($fp)	# fill _tmp1794 to $t0 from $fp-2544
	  beqz $t0, _L175	# branch if _tmp1794 is zero 
	# _tmp1795 = "Decaf runtime error: Array subscript out of bound..."
	  .data			# create string constant marked with label
	  _string115: .asciiz "Decaf runtime error: Array subscript out of bounds\n"
	  .text
	  la $t2, _string115	# load label
	  sw $t2, -2548($fp)	# spill _tmp1795 from $t2 to $fp-2548
	# PushParam _tmp1795
	  subu $sp, $sp, 4	# decrement sp to make space for param
	  lw $t0, -2548($fp)	# fill _tmp1795 to $t0 from $fp-2548
	  sw $t0, 4($sp)	# copy param value to stack
	# LCall _PrintString
	  jal _PrintString   	# jump to function
	# PopParams 4
	  add $sp, $sp, 4	# pop params off stack
	# LCall _Halt
	  jal _Halt          	# jump to function
  _L175:
	# _tmp1796 = 4
	  li $t2, 4		# load constant value 4 into $t2
	  sw $t2, -2552($fp)	# spill _tmp1796 from $t2 to $fp-2552
	# _tmp1797 = _tmp1787 * _tmp1796
	  lw $t0, -2516($fp)	# fill _tmp1787 to $t0 from $fp-2516
	  lw $t1, -2552($fp)	# fill _tmp1796 to $t1 from $fp-2552
	  mul $t2, $t0, $t1	
	  sw $t2, -2556($fp)	# spill _tmp1797 from $t2 to $fp-2556
	# _tmp1798 = _tmp1797 + _tmp1796
	  lw $t0, -2556($fp)	# fill _tmp1797 to $t0 from $fp-2556
	  lw $t1, -2552($fp)	# fill _tmp1796 to $t1 from $fp-2552
	  add $t2, $t0, $t1	
	  sw $t2, -2560($fp)	# spill _tmp1798 from $t2 to $fp-2560
	# _tmp1799 = _tmp1786 + _tmp1798
	  lw $t0, -2512($fp)	# fill _tmp1786 to $t0 from $fp-2512
	  lw $t1, -2560($fp)	# fill _tmp1798 to $t1 from $fp-2560
	  add $t2, $t0, $t1	
	  sw $t2, -2564($fp)	# spill _tmp1799 from $t2 to $fp-2564
	# _tmp1800 = *(_tmp1799)
	  lw $t0, -2564($fp)	# fill _tmp1799 to $t0 from $fp-2564
	  lw $t2, 0($t0) 	# load with offset
	  sw $t2, -2568($fp)	# spill _tmp1800 from $t2 to $fp-2568
	# _tmp1801 = 0
	  li $t2, 0		# load constant value 0 into $t2
	  sw $t2, -2572($fp)	# spill _tmp1801 from $t2 to $fp-2572
	# _tmp1802 = 0
	  li $t2, 0		# load constant value 0 into $t2
	  sw $t2, -2576($fp)	# spill _tmp1802 from $t2 to $fp-2576
	# _tmp1803 = *(_tmp1800)
	  lw $t0, -2568($fp)	# fill _tmp1800 to $t0 from $fp-2568
	  lw $t2, 0($t0) 	# load with offset
	  sw $t2, -2580($fp)	# spill _tmp1803 from $t2 to $fp-2580
	# _tmp1804 = _tmp1801 < _tmp1802
	  lw $t0, -2572($fp)	# fill _tmp1801 to $t0 from $fp-2572
	  lw $t1, -2576($fp)	# fill _tmp1802 to $t1 from $fp-2576
	  slt $t2, $t0, $t1	
	  sw $t2, -2584($fp)	# spill _tmp1804 from $t2 to $fp-2584
	# _tmp1805 = _tmp1803 < _tmp1801
	  lw $t0, -2580($fp)	# fill _tmp1803 to $t0 from $fp-2580
	  lw $t1, -2572($fp)	# fill _tmp1801 to $t1 from $fp-2572
	  slt $t2, $t0, $t1	
	  sw $t2, -2588($fp)	# spill _tmp1805 from $t2 to $fp-2588
	# _tmp1806 = _tmp1803 == _tmp1801
	  lw $t0, -2580($fp)	# fill _tmp1803 to $t0 from $fp-2580
	  lw $t1, -2572($fp)	# fill _tmp1801 to $t1 from $fp-2572
	  seq $t2, $t0, $t1	
	  sw $t2, -2592($fp)	# spill _tmp1806 from $t2 to $fp-2592
	# _tmp1807 = _tmp1805 || _tmp1806
	  lw $t0, -2588($fp)	# fill _tmp1805 to $t0 from $fp-2588
	  lw $t1, -2592($fp)	# fill _tmp1806 to $t1 from $fp-2592
	  or $t2, $t0, $t1	
	  sw $t2, -2596($fp)	# spill _tmp1807 from $t2 to $fp-2596
	# _tmp1808 = _tmp1807 || _tmp1804
	  lw $t0, -2596($fp)	# fill _tmp1807 to $t0 from $fp-2596
	  lw $t1, -2584($fp)	# fill _tmp1804 to $t1 from $fp-2584
	  or $t2, $t0, $t1	
	  sw $t2, -2600($fp)	# spill _tmp1808 from $t2 to $fp-2600
	# IfZ _tmp1808 Goto _L176
	  lw $t0, -2600($fp)	# fill _tmp1808 to $t0 from $fp-2600
	  beqz $t0, _L176	# branch if _tmp1808 is zero 
	# _tmp1809 = "Decaf runtime error: Array subscript out of bound..."
	  .data			# create string constant marked with label
	  _string116: .asciiz "Decaf runtime error: Array subscript out of bounds\n"
	  .text
	  la $t2, _string116	# load label
	  sw $t2, -2604($fp)	# spill _tmp1809 from $t2 to $fp-2604
	# PushParam _tmp1809
	  subu $sp, $sp, 4	# decrement sp to make space for param
	  lw $t0, -2604($fp)	# fill _tmp1809 to $t0 from $fp-2604
	  sw $t0, 4($sp)	# copy param value to stack
	# LCall _PrintString
	  jal _PrintString   	# jump to function
	# PopParams 4
	  add $sp, $sp, 4	# pop params off stack
	# LCall _Halt
	  jal _Halt          	# jump to function
  _L176:
	# _tmp1810 = 4
	  li $t2, 4		# load constant value 4 into $t2
	  sw $t2, -2608($fp)	# spill _tmp1810 from $t2 to $fp-2608
	# _tmp1811 = _tmp1801 * _tmp1810
	  lw $t0, -2572($fp)	# fill _tmp1801 to $t0 from $fp-2572
	  lw $t1, -2608($fp)	# fill _tmp1810 to $t1 from $fp-2608
	  mul $t2, $t0, $t1	
	  sw $t2, -2612($fp)	# spill _tmp1811 from $t2 to $fp-2612
	# _tmp1812 = _tmp1811 + _tmp1810
	  lw $t0, -2612($fp)	# fill _tmp1811 to $t0 from $fp-2612
	  lw $t1, -2608($fp)	# fill _tmp1810 to $t1 from $fp-2608
	  add $t2, $t0, $t1	
	  sw $t2, -2616($fp)	# spill _tmp1812 from $t2 to $fp-2616
	# _tmp1813 = _tmp1800 + _tmp1812
	  lw $t0, -2568($fp)	# fill _tmp1800 to $t0 from $fp-2568
	  lw $t1, -2616($fp)	# fill _tmp1812 to $t1 from $fp-2616
	  add $t2, $t0, $t1	
	  sw $t2, -2620($fp)	# spill _tmp1813 from $t2 to $fp-2620
	# _tmp1814 = *(_tmp1813)
	  lw $t0, -2620($fp)	# fill _tmp1813 to $t0 from $fp-2620
	  lw $t2, 0($t0) 	# load with offset
	  sw $t2, -2624($fp)	# spill _tmp1814 from $t2 to $fp-2624
	# PushParam _tmp1814
	  subu $sp, $sp, 4	# decrement sp to make space for param
	  lw $t0, -2624($fp)	# fill _tmp1814 to $t0 from $fp-2624
	  sw $t0, 4($sp)	# copy param value to stack
	# _tmp1815 = *(_tmp1814)
	  lw $t0, -2624($fp)	# fill _tmp1814 to $t0 from $fp-2624
	  lw $t2, 0($t0) 	# load with offset
	  sw $t2, -2628($fp)	# spill _tmp1815 from $t2 to $fp-2628
	# _tmp1816 = *(_tmp1815 + 20)
	  lw $t0, -2628($fp)	# fill _tmp1815 to $t0 from $fp-2628
	  lw $t2, 20($t0) 	# load with offset
	  sw $t2, -2632($fp)	# spill _tmp1816 from $t2 to $fp-2632
	# _tmp1817 = ACall _tmp1816
	  lw $t0, -2632($fp)	# fill _tmp1816 to $t0 from $fp-2632
	  jalr $t0            	# jump to function
	  move $t2, $v0		# copy function return value from $v0
	  sw $t2, -2636($fp)	# spill _tmp1817 from $t2 to $fp-2636
	# PopParams 8
	  add $sp, $sp, 8	# pop params off stack
	# PushParam enemyMark
	  subu $sp, $sp, 4	# decrement sp to make space for param
	  lw $t0, 8($fp)	# fill enemyMark to $t0 from $fp+8
	  sw $t0, 4($sp)	# copy param value to stack
	# _tmp1818 = *(this + 4)
	  lw $t0, 4($fp)	# fill this to $t0 from $fp+4
	  lw $t2, 4($t0) 	# load with offset
	  sw $t2, -2640($fp)	# spill _tmp1818 from $t2 to $fp-2640
	# _tmp1819 = 1
	  li $t2, 1		# load constant value 1 into $t2
	  sw $t2, -2644($fp)	# spill _tmp1819 from $t2 to $fp-2644
	# _tmp1820 = 0
	  li $t2, 0		# load constant value 0 into $t2
	  sw $t2, -2648($fp)	# spill _tmp1820 from $t2 to $fp-2648
	# _tmp1821 = *(_tmp1818)
	  lw $t0, -2640($fp)	# fill _tmp1818 to $t0 from $fp-2640
	  lw $t2, 0($t0) 	# load with offset
	  sw $t2, -2652($fp)	# spill _tmp1821 from $t2 to $fp-2652
	# _tmp1822 = _tmp1819 < _tmp1820
	  lw $t0, -2644($fp)	# fill _tmp1819 to $t0 from $fp-2644
	  lw $t1, -2648($fp)	# fill _tmp1820 to $t1 from $fp-2648
	  slt $t2, $t0, $t1	
	  sw $t2, -2656($fp)	# spill _tmp1822 from $t2 to $fp-2656
	# _tmp1823 = _tmp1821 < _tmp1819
	  lw $t0, -2652($fp)	# fill _tmp1821 to $t0 from $fp-2652
	  lw $t1, -2644($fp)	# fill _tmp1819 to $t1 from $fp-2644
	  slt $t2, $t0, $t1	
	  sw $t2, -2660($fp)	# spill _tmp1823 from $t2 to $fp-2660
	# _tmp1824 = _tmp1821 == _tmp1819
	  lw $t0, -2652($fp)	# fill _tmp1821 to $t0 from $fp-2652
	  lw $t1, -2644($fp)	# fill _tmp1819 to $t1 from $fp-2644
	  seq $t2, $t0, $t1	
	  sw $t2, -2664($fp)	# spill _tmp1824 from $t2 to $fp-2664
	# _tmp1825 = _tmp1823 || _tmp1824
	  lw $t0, -2660($fp)	# fill _tmp1823 to $t0 from $fp-2660
	  lw $t1, -2664($fp)	# fill _tmp1824 to $t1 from $fp-2664
	  or $t2, $t0, $t1	
	  sw $t2, -2668($fp)	# spill _tmp1825 from $t2 to $fp-2668
	# _tmp1826 = _tmp1825 || _tmp1822
	  lw $t0, -2668($fp)	# fill _tmp1825 to $t0 from $fp-2668
	  lw $t1, -2656($fp)	# fill _tmp1822 to $t1 from $fp-2656
	  or $t2, $t0, $t1	
	  sw $t2, -2672($fp)	# spill _tmp1826 from $t2 to $fp-2672
	# IfZ _tmp1826 Goto _L177
	  lw $t0, -2672($fp)	# fill _tmp1826 to $t0 from $fp-2672
	  beqz $t0, _L177	# branch if _tmp1826 is zero 
	# _tmp1827 = "Decaf runtime error: Array subscript out of bound..."
	  .data			# create string constant marked with label
	  _string117: .asciiz "Decaf runtime error: Array subscript out of bounds\n"
	  .text
	  la $t2, _string117	# load label
	  sw $t2, -2676($fp)	# spill _tmp1827 from $t2 to $fp-2676
	# PushParam _tmp1827
	  subu $sp, $sp, 4	# decrement sp to make space for param
	  lw $t0, -2676($fp)	# fill _tmp1827 to $t0 from $fp-2676
	  sw $t0, 4($sp)	# copy param value to stack
	# LCall _PrintString
	  jal _PrintString   	# jump to function
	# PopParams 4
	  add $sp, $sp, 4	# pop params off stack
	# LCall _Halt
	  jal _Halt          	# jump to function
  _L177:
	# _tmp1828 = 4
	  li $t2, 4		# load constant value 4 into $t2
	  sw $t2, -2680($fp)	# spill _tmp1828 from $t2 to $fp-2680
	# _tmp1829 = _tmp1819 * _tmp1828
	  lw $t0, -2644($fp)	# fill _tmp1819 to $t0 from $fp-2644
	  lw $t1, -2680($fp)	# fill _tmp1828 to $t1 from $fp-2680
	  mul $t2, $t0, $t1	
	  sw $t2, -2684($fp)	# spill _tmp1829 from $t2 to $fp-2684
	# _tmp1830 = _tmp1829 + _tmp1828
	  lw $t0, -2684($fp)	# fill _tmp1829 to $t0 from $fp-2684
	  lw $t1, -2680($fp)	# fill _tmp1828 to $t1 from $fp-2680
	  add $t2, $t0, $t1	
	  sw $t2, -2688($fp)	# spill _tmp1830 from $t2 to $fp-2688
	# _tmp1831 = _tmp1818 + _tmp1830
	  lw $t0, -2640($fp)	# fill _tmp1818 to $t0 from $fp-2640
	  lw $t1, -2688($fp)	# fill _tmp1830 to $t1 from $fp-2688
	  add $t2, $t0, $t1	
	  sw $t2, -2692($fp)	# spill _tmp1831 from $t2 to $fp-2692
	# _tmp1832 = *(_tmp1831)
	  lw $t0, -2692($fp)	# fill _tmp1831 to $t0 from $fp-2692
	  lw $t2, 0($t0) 	# load with offset
	  sw $t2, -2696($fp)	# spill _tmp1832 from $t2 to $fp-2696
	# _tmp1833 = 0
	  li $t2, 0		# load constant value 0 into $t2
	  sw $t2, -2700($fp)	# spill _tmp1833 from $t2 to $fp-2700
	# _tmp1834 = 0
	  li $t2, 0		# load constant value 0 into $t2
	  sw $t2, -2704($fp)	# spill _tmp1834 from $t2 to $fp-2704
	# _tmp1835 = *(_tmp1832)
	  lw $t0, -2696($fp)	# fill _tmp1832 to $t0 from $fp-2696
	  lw $t2, 0($t0) 	# load with offset
	  sw $t2, -2708($fp)	# spill _tmp1835 from $t2 to $fp-2708
	# _tmp1836 = _tmp1833 < _tmp1834
	  lw $t0, -2700($fp)	# fill _tmp1833 to $t0 from $fp-2700
	  lw $t1, -2704($fp)	# fill _tmp1834 to $t1 from $fp-2704
	  slt $t2, $t0, $t1	
	  sw $t2, -2712($fp)	# spill _tmp1836 from $t2 to $fp-2712
	# _tmp1837 = _tmp1835 < _tmp1833
	  lw $t0, -2708($fp)	# fill _tmp1835 to $t0 from $fp-2708
	  lw $t1, -2700($fp)	# fill _tmp1833 to $t1 from $fp-2700
	  slt $t2, $t0, $t1	
	  sw $t2, -2716($fp)	# spill _tmp1837 from $t2 to $fp-2716
	# _tmp1838 = _tmp1835 == _tmp1833
	  lw $t0, -2708($fp)	# fill _tmp1835 to $t0 from $fp-2708
	  lw $t1, -2700($fp)	# fill _tmp1833 to $t1 from $fp-2700
	  seq $t2, $t0, $t1	
	  sw $t2, -2720($fp)	# spill _tmp1838 from $t2 to $fp-2720
	# _tmp1839 = _tmp1837 || _tmp1838
	  lw $t0, -2716($fp)	# fill _tmp1837 to $t0 from $fp-2716
	  lw $t1, -2720($fp)	# fill _tmp1838 to $t1 from $fp-2720
	  or $t2, $t0, $t1	
	  sw $t2, -2724($fp)	# spill _tmp1839 from $t2 to $fp-2724
	# _tmp1840 = _tmp1839 || _tmp1836
	  lw $t0, -2724($fp)	# fill _tmp1839 to $t0 from $fp-2724
	  lw $t1, -2712($fp)	# fill _tmp1836 to $t1 from $fp-2712
	  or $t2, $t0, $t1	
	  sw $t2, -2728($fp)	# spill _tmp1840 from $t2 to $fp-2728
	# IfZ _tmp1840 Goto _L178
	  lw $t0, -2728($fp)	# fill _tmp1840 to $t0 from $fp-2728
	  beqz $t0, _L178	# branch if _tmp1840 is zero 
	# _tmp1841 = "Decaf runtime error: Array subscript out of bound..."
	  .data			# create string constant marked with label
	  _string118: .asciiz "Decaf runtime error: Array subscript out of bounds\n"
	  .text
	  la $t2, _string118	# load label
	  sw $t2, -2732($fp)	# spill _tmp1841 from $t2 to $fp-2732
	# PushParam _tmp1841
	  subu $sp, $sp, 4	# decrement sp to make space for param
	  lw $t0, -2732($fp)	# fill _tmp1841 to $t0 from $fp-2732
	  sw $t0, 4($sp)	# copy param value to stack
	# LCall _PrintString
	  jal _PrintString   	# jump to function
	# PopParams 4
	  add $sp, $sp, 4	# pop params off stack
	# LCall _Halt
	  jal _Halt          	# jump to function
  _L178:
	# _tmp1842 = 4
	  li $t2, 4		# load constant value 4 into $t2
	  sw $t2, -2736($fp)	# spill _tmp1842 from $t2 to $fp-2736
	# _tmp1843 = _tmp1833 * _tmp1842
	  lw $t0, -2700($fp)	# fill _tmp1833 to $t0 from $fp-2700
	  lw $t1, -2736($fp)	# fill _tmp1842 to $t1 from $fp-2736
	  mul $t2, $t0, $t1	
	  sw $t2, -2740($fp)	# spill _tmp1843 from $t2 to $fp-2740
	# _tmp1844 = _tmp1843 + _tmp1842
	  lw $t0, -2740($fp)	# fill _tmp1843 to $t0 from $fp-2740
	  lw $t1, -2736($fp)	# fill _tmp1842 to $t1 from $fp-2736
	  add $t2, $t0, $t1	
	  sw $t2, -2744($fp)	# spill _tmp1844 from $t2 to $fp-2744
	# _tmp1845 = _tmp1832 + _tmp1844
	  lw $t0, -2696($fp)	# fill _tmp1832 to $t0 from $fp-2696
	  lw $t1, -2744($fp)	# fill _tmp1844 to $t1 from $fp-2744
	  add $t2, $t0, $t1	
	  sw $t2, -2748($fp)	# spill _tmp1845 from $t2 to $fp-2748
	# _tmp1846 = *(_tmp1845)
	  lw $t0, -2748($fp)	# fill _tmp1845 to $t0 from $fp-2748
	  lw $t2, 0($t0) 	# load with offset
	  sw $t2, -2752($fp)	# spill _tmp1846 from $t2 to $fp-2752
	# PushParam _tmp1846
	  subu $sp, $sp, 4	# decrement sp to make space for param
	  lw $t0, -2752($fp)	# fill _tmp1846 to $t0 from $fp-2752
	  sw $t0, 4($sp)	# copy param value to stack
	# _tmp1847 = *(_tmp1846)
	  lw $t0, -2752($fp)	# fill _tmp1846 to $t0 from $fp-2752
	  lw $t2, 0($t0) 	# load with offset
	  sw $t2, -2756($fp)	# spill _tmp1847 from $t2 to $fp-2756
	# _tmp1848 = *(_tmp1847 + 20)
	  lw $t0, -2756($fp)	# fill _tmp1847 to $t0 from $fp-2756
	  lw $t2, 20($t0) 	# load with offset
	  sw $t2, -2760($fp)	# spill _tmp1848 from $t2 to $fp-2760
	# _tmp1849 = ACall _tmp1848
	  lw $t0, -2760($fp)	# fill _tmp1848 to $t0 from $fp-2760
	  jalr $t0            	# jump to function
	  move $t2, $v0		# copy function return value from $v0
	  sw $t2, -2764($fp)	# spill _tmp1849 from $t2 to $fp-2764
	# PopParams 8
	  add $sp, $sp, 8	# pop params off stack
	# _tmp1850 = _tmp1817 && _tmp1849
	  lw $t0, -2636($fp)	# fill _tmp1817 to $t0 from $fp-2636
	  lw $t1, -2764($fp)	# fill _tmp1849 to $t1 from $fp-2764
	  and $t2, $t0, $t1	
	  sw $t2, -2768($fp)	# spill _tmp1850 from $t2 to $fp-2768
	# PushParam playerMark
	  subu $sp, $sp, 4	# decrement sp to make space for param
	  lw $t0, 12($fp)	# fill playerMark to $t0 from $fp+12
	  sw $t0, 4($sp)	# copy param value to stack
	# _tmp1852 = *(this + 4)
	  lw $t0, 4($fp)	# fill this to $t0 from $fp+4
	  lw $t2, 4($t0) 	# load with offset
	  sw $t2, -2776($fp)	# spill _tmp1852 from $t2 to $fp-2776
	# _tmp1853 = 2
	  li $t2, 2		# load constant value 2 into $t2
	  sw $t2, -2780($fp)	# spill _tmp1853 from $t2 to $fp-2780
	# _tmp1854 = 0
	  li $t2, 0		# load constant value 0 into $t2
	  sw $t2, -2784($fp)	# spill _tmp1854 from $t2 to $fp-2784
	# _tmp1855 = *(_tmp1852)
	  lw $t0, -2776($fp)	# fill _tmp1852 to $t0 from $fp-2776
	  lw $t2, 0($t0) 	# load with offset
	  sw $t2, -2788($fp)	# spill _tmp1855 from $t2 to $fp-2788
	# _tmp1856 = _tmp1853 < _tmp1854
	  lw $t0, -2780($fp)	# fill _tmp1853 to $t0 from $fp-2780
	  lw $t1, -2784($fp)	# fill _tmp1854 to $t1 from $fp-2784
	  slt $t2, $t0, $t1	
	  sw $t2, -2792($fp)	# spill _tmp1856 from $t2 to $fp-2792
	# _tmp1857 = _tmp1855 < _tmp1853
	  lw $t0, -2788($fp)	# fill _tmp1855 to $t0 from $fp-2788
	  lw $t1, -2780($fp)	# fill _tmp1853 to $t1 from $fp-2780
	  slt $t2, $t0, $t1	
	  sw $t2, -2796($fp)	# spill _tmp1857 from $t2 to $fp-2796
	# _tmp1858 = _tmp1855 == _tmp1853
	  lw $t0, -2788($fp)	# fill _tmp1855 to $t0 from $fp-2788
	  lw $t1, -2780($fp)	# fill _tmp1853 to $t1 from $fp-2780
	  seq $t2, $t0, $t1	
	  sw $t2, -2800($fp)	# spill _tmp1858 from $t2 to $fp-2800
	# _tmp1859 = _tmp1857 || _tmp1858
	  lw $t0, -2796($fp)	# fill _tmp1857 to $t0 from $fp-2796
	  lw $t1, -2800($fp)	# fill _tmp1858 to $t1 from $fp-2800
	  or $t2, $t0, $t1	
	  sw $t2, -2804($fp)	# spill _tmp1859 from $t2 to $fp-2804
	# _tmp1860 = _tmp1859 || _tmp1856
	  lw $t0, -2804($fp)	# fill _tmp1859 to $t0 from $fp-2804
	  lw $t1, -2792($fp)	# fill _tmp1856 to $t1 from $fp-2792
	  or $t2, $t0, $t1	
	  sw $t2, -2808($fp)	# spill _tmp1860 from $t2 to $fp-2808
	# IfZ _tmp1860 Goto _L181
	  lw $t0, -2808($fp)	# fill _tmp1860 to $t0 from $fp-2808
	  beqz $t0, _L181	# branch if _tmp1860 is zero 
	# _tmp1861 = "Decaf runtime error: Array subscript out of bound..."
	  .data			# create string constant marked with label
	  _string119: .asciiz "Decaf runtime error: Array subscript out of bounds\n"
	  .text
	  la $t2, _string119	# load label
	  sw $t2, -2812($fp)	# spill _tmp1861 from $t2 to $fp-2812
	# PushParam _tmp1861
	  subu $sp, $sp, 4	# decrement sp to make space for param
	  lw $t0, -2812($fp)	# fill _tmp1861 to $t0 from $fp-2812
	  sw $t0, 4($sp)	# copy param value to stack
	# LCall _PrintString
	  jal _PrintString   	# jump to function
	# PopParams 4
	  add $sp, $sp, 4	# pop params off stack
	# LCall _Halt
	  jal _Halt          	# jump to function
  _L181:
	# _tmp1862 = 4
	  li $t2, 4		# load constant value 4 into $t2
	  sw $t2, -2816($fp)	# spill _tmp1862 from $t2 to $fp-2816
	# _tmp1863 = _tmp1853 * _tmp1862
	  lw $t0, -2780($fp)	# fill _tmp1853 to $t0 from $fp-2780
	  lw $t1, -2816($fp)	# fill _tmp1862 to $t1 from $fp-2816
	  mul $t2, $t0, $t1	
	  sw $t2, -2820($fp)	# spill _tmp1863 from $t2 to $fp-2820
	# _tmp1864 = _tmp1863 + _tmp1862
	  lw $t0, -2820($fp)	# fill _tmp1863 to $t0 from $fp-2820
	  lw $t1, -2816($fp)	# fill _tmp1862 to $t1 from $fp-2816
	  add $t2, $t0, $t1	
	  sw $t2, -2824($fp)	# spill _tmp1864 from $t2 to $fp-2824
	# _tmp1865 = _tmp1852 + _tmp1864
	  lw $t0, -2776($fp)	# fill _tmp1852 to $t0 from $fp-2776
	  lw $t1, -2824($fp)	# fill _tmp1864 to $t1 from $fp-2824
	  add $t2, $t0, $t1	
	  sw $t2, -2828($fp)	# spill _tmp1865 from $t2 to $fp-2828
	# _tmp1866 = *(_tmp1865)
	  lw $t0, -2828($fp)	# fill _tmp1865 to $t0 from $fp-2828
	  lw $t2, 0($t0) 	# load with offset
	  sw $t2, -2832($fp)	# spill _tmp1866 from $t2 to $fp-2832
	# _tmp1867 = 0
	  li $t2, 0		# load constant value 0 into $t2
	  sw $t2, -2836($fp)	# spill _tmp1867 from $t2 to $fp-2836
	# _tmp1868 = 0
	  li $t2, 0		# load constant value 0 into $t2
	  sw $t2, -2840($fp)	# spill _tmp1868 from $t2 to $fp-2840
	# _tmp1869 = *(_tmp1866)
	  lw $t0, -2832($fp)	# fill _tmp1866 to $t0 from $fp-2832
	  lw $t2, 0($t0) 	# load with offset
	  sw $t2, -2844($fp)	# spill _tmp1869 from $t2 to $fp-2844
	# _tmp1870 = _tmp1867 < _tmp1868
	  lw $t0, -2836($fp)	# fill _tmp1867 to $t0 from $fp-2836
	  lw $t1, -2840($fp)	# fill _tmp1868 to $t1 from $fp-2840
	  slt $t2, $t0, $t1	
	  sw $t2, -2848($fp)	# spill _tmp1870 from $t2 to $fp-2848
	# _tmp1871 = _tmp1869 < _tmp1867
	  lw $t0, -2844($fp)	# fill _tmp1869 to $t0 from $fp-2844
	  lw $t1, -2836($fp)	# fill _tmp1867 to $t1 from $fp-2836
	  slt $t2, $t0, $t1	
	  sw $t2, -2852($fp)	# spill _tmp1871 from $t2 to $fp-2852
	# _tmp1872 = _tmp1869 == _tmp1867
	  lw $t0, -2844($fp)	# fill _tmp1869 to $t0 from $fp-2844
	  lw $t1, -2836($fp)	# fill _tmp1867 to $t1 from $fp-2836
	  seq $t2, $t0, $t1	
	  sw $t2, -2856($fp)	# spill _tmp1872 from $t2 to $fp-2856
	# _tmp1873 = _tmp1871 || _tmp1872
	  lw $t0, -2852($fp)	# fill _tmp1871 to $t0 from $fp-2852
	  lw $t1, -2856($fp)	# fill _tmp1872 to $t1 from $fp-2856
	  or $t2, $t0, $t1	
	  sw $t2, -2860($fp)	# spill _tmp1873 from $t2 to $fp-2860
	# _tmp1874 = _tmp1873 || _tmp1870
	  lw $t0, -2860($fp)	# fill _tmp1873 to $t0 from $fp-2860
	  lw $t1, -2848($fp)	# fill _tmp1870 to $t1 from $fp-2848
	  or $t2, $t0, $t1	
	  sw $t2, -2864($fp)	# spill _tmp1874 from $t2 to $fp-2864
	# IfZ _tmp1874 Goto _L182
	  lw $t0, -2864($fp)	# fill _tmp1874 to $t0 from $fp-2864
	  beqz $t0, _L182	# branch if _tmp1874 is zero 
	# _tmp1875 = "Decaf runtime error: Array subscript out of bound..."
	  .data			# create string constant marked with label
	  _string120: .asciiz "Decaf runtime error: Array subscript out of bounds\n"
	  .text
	  la $t2, _string120	# load label
	  sw $t2, -2868($fp)	# spill _tmp1875 from $t2 to $fp-2868
	# PushParam _tmp1875
	  subu $sp, $sp, 4	# decrement sp to make space for param
	  lw $t0, -2868($fp)	# fill _tmp1875 to $t0 from $fp-2868
	  sw $t0, 4($sp)	# copy param value to stack
	# LCall _PrintString
	  jal _PrintString   	# jump to function
	# PopParams 4
	  add $sp, $sp, 4	# pop params off stack
	# LCall _Halt
	  jal _Halt          	# jump to function
  _L182:
	# _tmp1876 = 4
	  li $t2, 4		# load constant value 4 into $t2
	  sw $t2, -2872($fp)	# spill _tmp1876 from $t2 to $fp-2872
	# _tmp1877 = _tmp1867 * _tmp1876
	  lw $t0, -2836($fp)	# fill _tmp1867 to $t0 from $fp-2836
	  lw $t1, -2872($fp)	# fill _tmp1876 to $t1 from $fp-2872
	  mul $t2, $t0, $t1	
	  sw $t2, -2876($fp)	# spill _tmp1877 from $t2 to $fp-2876
	# _tmp1878 = _tmp1877 + _tmp1876
	  lw $t0, -2876($fp)	# fill _tmp1877 to $t0 from $fp-2876
	  lw $t1, -2872($fp)	# fill _tmp1876 to $t1 from $fp-2872
	  add $t2, $t0, $t1	
	  sw $t2, -2880($fp)	# spill _tmp1878 from $t2 to $fp-2880
	# _tmp1879 = _tmp1866 + _tmp1878
	  lw $t0, -2832($fp)	# fill _tmp1866 to $t0 from $fp-2832
	  lw $t1, -2880($fp)	# fill _tmp1878 to $t1 from $fp-2880
	  add $t2, $t0, $t1	
	  sw $t2, -2884($fp)	# spill _tmp1879 from $t2 to $fp-2884
	# _tmp1880 = *(_tmp1879)
	  lw $t0, -2884($fp)	# fill _tmp1879 to $t0 from $fp-2884
	  lw $t2, 0($t0) 	# load with offset
	  sw $t2, -2888($fp)	# spill _tmp1880 from $t2 to $fp-2888
	# PushParam _tmp1880
	  subu $sp, $sp, 4	# decrement sp to make space for param
	  lw $t0, -2888($fp)	# fill _tmp1880 to $t0 from $fp-2888
	  sw $t0, 4($sp)	# copy param value to stack
	# _tmp1881 = *(_tmp1880)
	  lw $t0, -2888($fp)	# fill _tmp1880 to $t0 from $fp-2888
	  lw $t2, 0($t0) 	# load with offset
	  sw $t2, -2892($fp)	# spill _tmp1881 from $t2 to $fp-2892
	# _tmp1882 = *(_tmp1881 + 20)
	  lw $t0, -2892($fp)	# fill _tmp1881 to $t0 from $fp-2892
	  lw $t2, 20($t0) 	# load with offset
	  sw $t2, -2896($fp)	# spill _tmp1882 from $t2 to $fp-2896
	# _tmp1883 = ACall _tmp1882
	  lw $t0, -2896($fp)	# fill _tmp1882 to $t0 from $fp-2896
	  jalr $t0            	# jump to function
	  move $t2, $v0		# copy function return value from $v0
	  sw $t2, -2900($fp)	# spill _tmp1883 from $t2 to $fp-2900
	# PopParams 8
	  add $sp, $sp, 8	# pop params off stack
	# IfZ _tmp1883 Goto _L180
	  lw $t0, -2900($fp)	# fill _tmp1883 to $t0 from $fp-2900
	  beqz $t0, _L180	# branch if _tmp1883 is zero 
	# _tmp1884 = 0
	  li $t2, 0		# load constant value 0 into $t2
	  sw $t2, -2904($fp)	# spill _tmp1884 from $t2 to $fp-2904
	# _tmp1851 = _tmp1884
	  lw $t2, -2904($fp)	# fill _tmp1884 to $t2 from $fp-2904
	  sw $t2, -2772($fp)	# spill _tmp1851 from $t2 to $fp-2772
	# Goto _L179
	  b _L179		# unconditional branch
  _L180:
	# _tmp1885 = 1
	  li $t2, 1		# load constant value 1 into $t2
	  sw $t2, -2908($fp)	# spill _tmp1885 from $t2 to $fp-2908
	# _tmp1851 = _tmp1885
	  lw $t2, -2908($fp)	# fill _tmp1885 to $t2 from $fp-2908
	  sw $t2, -2772($fp)	# spill _tmp1851 from $t2 to $fp-2772
  _L179:
	# _tmp1886 = _tmp1850 && _tmp1851
	  lw $t0, -2768($fp)	# fill _tmp1850 to $t0 from $fp-2768
	  lw $t1, -2772($fp)	# fill _tmp1851 to $t1 from $fp-2772
	  and $t2, $t0, $t1	
	  sw $t2, -2912($fp)	# spill _tmp1886 from $t2 to $fp-2912
	# IfZ _tmp1886 Goto _L173
	  lw $t0, -2912($fp)	# fill _tmp1886 to $t0 from $fp-2912
	  beqz $t0, _L173	# branch if _tmp1886 is zero 
	# _tmp1887 = 2
	  li $t2, 2		# load constant value 2 into $t2
	  sw $t2, -2916($fp)	# spill _tmp1887 from $t2 to $fp-2916
	# row = _tmp1887
	  lw $t2, -2916($fp)	# fill _tmp1887 to $t2 from $fp-2916
	  sw $t2, -8($fp)	# spill row from $t2 to $fp-8
	# _tmp1888 = 0
	  li $t2, 0		# load constant value 0 into $t2
	  sw $t2, -2920($fp)	# spill _tmp1888 from $t2 to $fp-2920
	# column = _tmp1888
	  lw $t2, -2920($fp)	# fill _tmp1888 to $t2 from $fp-2920
	  sw $t2, -12($fp)	# spill column from $t2 to $fp-12
	# Goto _L174
	  b _L174		# unconditional branch
  _L173:
	# PushParam enemyMark
	  subu $sp, $sp, 4	# decrement sp to make space for param
	  lw $t0, 8($fp)	# fill enemyMark to $t0 from $fp+8
	  sw $t0, 4($sp)	# copy param value to stack
	# _tmp1889 = *(this + 4)
	  lw $t0, 4($fp)	# fill this to $t0 from $fp+4
	  lw $t2, 4($t0) 	# load with offset
	  sw $t2, -2924($fp)	# spill _tmp1889 from $t2 to $fp-2924
	# _tmp1890 = 0
	  li $t2, 0		# load constant value 0 into $t2
	  sw $t2, -2928($fp)	# spill _tmp1890 from $t2 to $fp-2928
	# _tmp1891 = 0
	  li $t2, 0		# load constant value 0 into $t2
	  sw $t2, -2932($fp)	# spill _tmp1891 from $t2 to $fp-2932
	# _tmp1892 = *(_tmp1889)
	  lw $t0, -2924($fp)	# fill _tmp1889 to $t0 from $fp-2924
	  lw $t2, 0($t0) 	# load with offset
	  sw $t2, -2936($fp)	# spill _tmp1892 from $t2 to $fp-2936
	# _tmp1893 = _tmp1890 < _tmp1891
	  lw $t0, -2928($fp)	# fill _tmp1890 to $t0 from $fp-2928
	  lw $t1, -2932($fp)	# fill _tmp1891 to $t1 from $fp-2932
	  slt $t2, $t0, $t1	
	  sw $t2, -2940($fp)	# spill _tmp1893 from $t2 to $fp-2940
	# _tmp1894 = _tmp1892 < _tmp1890
	  lw $t0, -2936($fp)	# fill _tmp1892 to $t0 from $fp-2936
	  lw $t1, -2928($fp)	# fill _tmp1890 to $t1 from $fp-2928
	  slt $t2, $t0, $t1	
	  sw $t2, -2944($fp)	# spill _tmp1894 from $t2 to $fp-2944
	# _tmp1895 = _tmp1892 == _tmp1890
	  lw $t0, -2936($fp)	# fill _tmp1892 to $t0 from $fp-2936
	  lw $t1, -2928($fp)	# fill _tmp1890 to $t1 from $fp-2928
	  seq $t2, $t0, $t1	
	  sw $t2, -2948($fp)	# spill _tmp1895 from $t2 to $fp-2948
	# _tmp1896 = _tmp1894 || _tmp1895
	  lw $t0, -2944($fp)	# fill _tmp1894 to $t0 from $fp-2944
	  lw $t1, -2948($fp)	# fill _tmp1895 to $t1 from $fp-2948
	  or $t2, $t0, $t1	
	  sw $t2, -2952($fp)	# spill _tmp1896 from $t2 to $fp-2952
	# _tmp1897 = _tmp1896 || _tmp1893
	  lw $t0, -2952($fp)	# fill _tmp1896 to $t0 from $fp-2952
	  lw $t1, -2940($fp)	# fill _tmp1893 to $t1 from $fp-2940
	  or $t2, $t0, $t1	
	  sw $t2, -2956($fp)	# spill _tmp1897 from $t2 to $fp-2956
	# IfZ _tmp1897 Goto _L185
	  lw $t0, -2956($fp)	# fill _tmp1897 to $t0 from $fp-2956
	  beqz $t0, _L185	# branch if _tmp1897 is zero 
	# _tmp1898 = "Decaf runtime error: Array subscript out of bound..."
	  .data			# create string constant marked with label
	  _string121: .asciiz "Decaf runtime error: Array subscript out of bounds\n"
	  .text
	  la $t2, _string121	# load label
	  sw $t2, -2960($fp)	# spill _tmp1898 from $t2 to $fp-2960
	# PushParam _tmp1898
	  subu $sp, $sp, 4	# decrement sp to make space for param
	  lw $t0, -2960($fp)	# fill _tmp1898 to $t0 from $fp-2960
	  sw $t0, 4($sp)	# copy param value to stack
	# LCall _PrintString
	  jal _PrintString   	# jump to function
	# PopParams 4
	  add $sp, $sp, 4	# pop params off stack
	# LCall _Halt
	  jal _Halt          	# jump to function
  _L185:
	# _tmp1899 = 4
	  li $t2, 4		# load constant value 4 into $t2
	  sw $t2, -2964($fp)	# spill _tmp1899 from $t2 to $fp-2964
	# _tmp1900 = _tmp1890 * _tmp1899
	  lw $t0, -2928($fp)	# fill _tmp1890 to $t0 from $fp-2928
	  lw $t1, -2964($fp)	# fill _tmp1899 to $t1 from $fp-2964
	  mul $t2, $t0, $t1	
	  sw $t2, -2968($fp)	# spill _tmp1900 from $t2 to $fp-2968
	# _tmp1901 = _tmp1900 + _tmp1899
	  lw $t0, -2968($fp)	# fill _tmp1900 to $t0 from $fp-2968
	  lw $t1, -2964($fp)	# fill _tmp1899 to $t1 from $fp-2964
	  add $t2, $t0, $t1	
	  sw $t2, -2972($fp)	# spill _tmp1901 from $t2 to $fp-2972
	# _tmp1902 = _tmp1889 + _tmp1901
	  lw $t0, -2924($fp)	# fill _tmp1889 to $t0 from $fp-2924
	  lw $t1, -2972($fp)	# fill _tmp1901 to $t1 from $fp-2972
	  add $t2, $t0, $t1	
	  sw $t2, -2976($fp)	# spill _tmp1902 from $t2 to $fp-2976
	# _tmp1903 = *(_tmp1902)
	  lw $t0, -2976($fp)	# fill _tmp1902 to $t0 from $fp-2976
	  lw $t2, 0($t0) 	# load with offset
	  sw $t2, -2980($fp)	# spill _tmp1903 from $t2 to $fp-2980
	# _tmp1904 = 1
	  li $t2, 1		# load constant value 1 into $t2
	  sw $t2, -2984($fp)	# spill _tmp1904 from $t2 to $fp-2984
	# _tmp1905 = 0
	  li $t2, 0		# load constant value 0 into $t2
	  sw $t2, -2988($fp)	# spill _tmp1905 from $t2 to $fp-2988
	# _tmp1906 = *(_tmp1903)
	  lw $t0, -2980($fp)	# fill _tmp1903 to $t0 from $fp-2980
	  lw $t2, 0($t0) 	# load with offset
	  sw $t2, -2992($fp)	# spill _tmp1906 from $t2 to $fp-2992
	# _tmp1907 = _tmp1904 < _tmp1905
	  lw $t0, -2984($fp)	# fill _tmp1904 to $t0 from $fp-2984
	  lw $t1, -2988($fp)	# fill _tmp1905 to $t1 from $fp-2988
	  slt $t2, $t0, $t1	
	  sw $t2, -2996($fp)	# spill _tmp1907 from $t2 to $fp-2996
	# _tmp1908 = _tmp1906 < _tmp1904
	  lw $t0, -2992($fp)	# fill _tmp1906 to $t0 from $fp-2992
	  lw $t1, -2984($fp)	# fill _tmp1904 to $t1 from $fp-2984
	  slt $t2, $t0, $t1	
	  sw $t2, -3000($fp)	# spill _tmp1908 from $t2 to $fp-3000
	# _tmp1909 = _tmp1906 == _tmp1904
	  lw $t0, -2992($fp)	# fill _tmp1906 to $t0 from $fp-2992
	  lw $t1, -2984($fp)	# fill _tmp1904 to $t1 from $fp-2984
	  seq $t2, $t0, $t1	
	  sw $t2, -3004($fp)	# spill _tmp1909 from $t2 to $fp-3004
	# _tmp1910 = _tmp1908 || _tmp1909
	  lw $t0, -3000($fp)	# fill _tmp1908 to $t0 from $fp-3000
	  lw $t1, -3004($fp)	# fill _tmp1909 to $t1 from $fp-3004
	  or $t2, $t0, $t1	
	  sw $t2, -3008($fp)	# spill _tmp1910 from $t2 to $fp-3008
	# _tmp1911 = _tmp1910 || _tmp1907
	  lw $t0, -3008($fp)	# fill _tmp1910 to $t0 from $fp-3008
	  lw $t1, -2996($fp)	# fill _tmp1907 to $t1 from $fp-2996
	  or $t2, $t0, $t1	
	  sw $t2, -3012($fp)	# spill _tmp1911 from $t2 to $fp-3012
	# IfZ _tmp1911 Goto _L186
	  lw $t0, -3012($fp)	# fill _tmp1911 to $t0 from $fp-3012
	  beqz $t0, _L186	# branch if _tmp1911 is zero 
	# _tmp1912 = "Decaf runtime error: Array subscript out of bound..."
	  .data			# create string constant marked with label
	  _string122: .asciiz "Decaf runtime error: Array subscript out of bounds\n"
	  .text
	  la $t2, _string122	# load label
	  sw $t2, -3016($fp)	# spill _tmp1912 from $t2 to $fp-3016
	# PushParam _tmp1912
	  subu $sp, $sp, 4	# decrement sp to make space for param
	  lw $t0, -3016($fp)	# fill _tmp1912 to $t0 from $fp-3016
	  sw $t0, 4($sp)	# copy param value to stack
	# LCall _PrintString
	  jal _PrintString   	# jump to function
	# PopParams 4
	  add $sp, $sp, 4	# pop params off stack
	# LCall _Halt
	  jal _Halt          	# jump to function
  _L186:
	# _tmp1913 = 4
	  li $t2, 4		# load constant value 4 into $t2
	  sw $t2, -3020($fp)	# spill _tmp1913 from $t2 to $fp-3020
	# _tmp1914 = _tmp1904 * _tmp1913
	  lw $t0, -2984($fp)	# fill _tmp1904 to $t0 from $fp-2984
	  lw $t1, -3020($fp)	# fill _tmp1913 to $t1 from $fp-3020
	  mul $t2, $t0, $t1	
	  sw $t2, -3024($fp)	# spill _tmp1914 from $t2 to $fp-3024
	# _tmp1915 = _tmp1914 + _tmp1913
	  lw $t0, -3024($fp)	# fill _tmp1914 to $t0 from $fp-3024
	  lw $t1, -3020($fp)	# fill _tmp1913 to $t1 from $fp-3020
	  add $t2, $t0, $t1	
	  sw $t2, -3028($fp)	# spill _tmp1915 from $t2 to $fp-3028
	# _tmp1916 = _tmp1903 + _tmp1915
	  lw $t0, -2980($fp)	# fill _tmp1903 to $t0 from $fp-2980
	  lw $t1, -3028($fp)	# fill _tmp1915 to $t1 from $fp-3028
	  add $t2, $t0, $t1	
	  sw $t2, -3032($fp)	# spill _tmp1916 from $t2 to $fp-3032
	# _tmp1917 = *(_tmp1916)
	  lw $t0, -3032($fp)	# fill _tmp1916 to $t0 from $fp-3032
	  lw $t2, 0($t0) 	# load with offset
	  sw $t2, -3036($fp)	# spill _tmp1917 from $t2 to $fp-3036
	# PushParam _tmp1917
	  subu $sp, $sp, 4	# decrement sp to make space for param
	  lw $t0, -3036($fp)	# fill _tmp1917 to $t0 from $fp-3036
	  sw $t0, 4($sp)	# copy param value to stack
	# _tmp1918 = *(_tmp1917)
	  lw $t0, -3036($fp)	# fill _tmp1917 to $t0 from $fp-3036
	  lw $t2, 0($t0) 	# load with offset
	  sw $t2, -3040($fp)	# spill _tmp1918 from $t2 to $fp-3040
	# _tmp1919 = *(_tmp1918 + 20)
	  lw $t0, -3040($fp)	# fill _tmp1918 to $t0 from $fp-3040
	  lw $t2, 20($t0) 	# load with offset
	  sw $t2, -3044($fp)	# spill _tmp1919 from $t2 to $fp-3044
	# _tmp1920 = ACall _tmp1919
	  lw $t0, -3044($fp)	# fill _tmp1919 to $t0 from $fp-3044
	  jalr $t0            	# jump to function
	  move $t2, $v0		# copy function return value from $v0
	  sw $t2, -3048($fp)	# spill _tmp1920 from $t2 to $fp-3048
	# PopParams 8
	  add $sp, $sp, 8	# pop params off stack
	# PushParam enemyMark
	  subu $sp, $sp, 4	# decrement sp to make space for param
	  lw $t0, 8($fp)	# fill enemyMark to $t0 from $fp+8
	  sw $t0, 4($sp)	# copy param value to stack
	# _tmp1921 = *(this + 4)
	  lw $t0, 4($fp)	# fill this to $t0 from $fp+4
	  lw $t2, 4($t0) 	# load with offset
	  sw $t2, -3052($fp)	# spill _tmp1921 from $t2 to $fp-3052
	# _tmp1922 = 1
	  li $t2, 1		# load constant value 1 into $t2
	  sw $t2, -3056($fp)	# spill _tmp1922 from $t2 to $fp-3056
	# _tmp1923 = 0
	  li $t2, 0		# load constant value 0 into $t2
	  sw $t2, -3060($fp)	# spill _tmp1923 from $t2 to $fp-3060
	# _tmp1924 = *(_tmp1921)
	  lw $t0, -3052($fp)	# fill _tmp1921 to $t0 from $fp-3052
	  lw $t2, 0($t0) 	# load with offset
	  sw $t2, -3064($fp)	# spill _tmp1924 from $t2 to $fp-3064
	# _tmp1925 = _tmp1922 < _tmp1923
	  lw $t0, -3056($fp)	# fill _tmp1922 to $t0 from $fp-3056
	  lw $t1, -3060($fp)	# fill _tmp1923 to $t1 from $fp-3060
	  slt $t2, $t0, $t1	
	  sw $t2, -3068($fp)	# spill _tmp1925 from $t2 to $fp-3068
	# _tmp1926 = _tmp1924 < _tmp1922
	  lw $t0, -3064($fp)	# fill _tmp1924 to $t0 from $fp-3064
	  lw $t1, -3056($fp)	# fill _tmp1922 to $t1 from $fp-3056
	  slt $t2, $t0, $t1	
	  sw $t2, -3072($fp)	# spill _tmp1926 from $t2 to $fp-3072
	# _tmp1927 = _tmp1924 == _tmp1922
	  lw $t0, -3064($fp)	# fill _tmp1924 to $t0 from $fp-3064
	  lw $t1, -3056($fp)	# fill _tmp1922 to $t1 from $fp-3056
	  seq $t2, $t0, $t1	
	  sw $t2, -3076($fp)	# spill _tmp1927 from $t2 to $fp-3076
	# _tmp1928 = _tmp1926 || _tmp1927
	  lw $t0, -3072($fp)	# fill _tmp1926 to $t0 from $fp-3072
	  lw $t1, -3076($fp)	# fill _tmp1927 to $t1 from $fp-3076
	  or $t2, $t0, $t1	
	  sw $t2, -3080($fp)	# spill _tmp1928 from $t2 to $fp-3080
	# _tmp1929 = _tmp1928 || _tmp1925
	  lw $t0, -3080($fp)	# fill _tmp1928 to $t0 from $fp-3080
	  lw $t1, -3068($fp)	# fill _tmp1925 to $t1 from $fp-3068
	  or $t2, $t0, $t1	
	  sw $t2, -3084($fp)	# spill _tmp1929 from $t2 to $fp-3084
	# IfZ _tmp1929 Goto _L187
	  lw $t0, -3084($fp)	# fill _tmp1929 to $t0 from $fp-3084
	  beqz $t0, _L187	# branch if _tmp1929 is zero 
	# _tmp1930 = "Decaf runtime error: Array subscript out of bound..."
	  .data			# create string constant marked with label
	  _string123: .asciiz "Decaf runtime error: Array subscript out of bounds\n"
	  .text
	  la $t2, _string123	# load label
	  sw $t2, -3088($fp)	# spill _tmp1930 from $t2 to $fp-3088
	# PushParam _tmp1930
	  subu $sp, $sp, 4	# decrement sp to make space for param
	  lw $t0, -3088($fp)	# fill _tmp1930 to $t0 from $fp-3088
	  sw $t0, 4($sp)	# copy param value to stack
	# LCall _PrintString
	  jal _PrintString   	# jump to function
	# PopParams 4
	  add $sp, $sp, 4	# pop params off stack
	# LCall _Halt
	  jal _Halt          	# jump to function
  _L187:
	# _tmp1931 = 4
	  li $t2, 4		# load constant value 4 into $t2
	  sw $t2, -3092($fp)	# spill _tmp1931 from $t2 to $fp-3092
	# _tmp1932 = _tmp1922 * _tmp1931
	  lw $t0, -3056($fp)	# fill _tmp1922 to $t0 from $fp-3056
	  lw $t1, -3092($fp)	# fill _tmp1931 to $t1 from $fp-3092
	  mul $t2, $t0, $t1	
	  sw $t2, -3096($fp)	# spill _tmp1932 from $t2 to $fp-3096
	# _tmp1933 = _tmp1932 + _tmp1931
	  lw $t0, -3096($fp)	# fill _tmp1932 to $t0 from $fp-3096
	  lw $t1, -3092($fp)	# fill _tmp1931 to $t1 from $fp-3092
	  add $t2, $t0, $t1	
	  sw $t2, -3100($fp)	# spill _tmp1933 from $t2 to $fp-3100
	# _tmp1934 = _tmp1921 + _tmp1933
	  lw $t0, -3052($fp)	# fill _tmp1921 to $t0 from $fp-3052
	  lw $t1, -3100($fp)	# fill _tmp1933 to $t1 from $fp-3100
	  add $t2, $t0, $t1	
	  sw $t2, -3104($fp)	# spill _tmp1934 from $t2 to $fp-3104
	# _tmp1935 = *(_tmp1934)
	  lw $t0, -3104($fp)	# fill _tmp1934 to $t0 from $fp-3104
	  lw $t2, 0($t0) 	# load with offset
	  sw $t2, -3108($fp)	# spill _tmp1935 from $t2 to $fp-3108
	# _tmp1936 = 1
	  li $t2, 1		# load constant value 1 into $t2
	  sw $t2, -3112($fp)	# spill _tmp1936 from $t2 to $fp-3112
	# _tmp1937 = 0
	  li $t2, 0		# load constant value 0 into $t2
	  sw $t2, -3116($fp)	# spill _tmp1937 from $t2 to $fp-3116
	# _tmp1938 = *(_tmp1935)
	  lw $t0, -3108($fp)	# fill _tmp1935 to $t0 from $fp-3108
	  lw $t2, 0($t0) 	# load with offset
	  sw $t2, -3120($fp)	# spill _tmp1938 from $t2 to $fp-3120
	# _tmp1939 = _tmp1936 < _tmp1937
	  lw $t0, -3112($fp)	# fill _tmp1936 to $t0 from $fp-3112
	  lw $t1, -3116($fp)	# fill _tmp1937 to $t1 from $fp-3116
	  slt $t2, $t0, $t1	
	  sw $t2, -3124($fp)	# spill _tmp1939 from $t2 to $fp-3124
	# _tmp1940 = _tmp1938 < _tmp1936
	  lw $t0, -3120($fp)	# fill _tmp1938 to $t0 from $fp-3120
	  lw $t1, -3112($fp)	# fill _tmp1936 to $t1 from $fp-3112
	  slt $t2, $t0, $t1	
	  sw $t2, -3128($fp)	# spill _tmp1940 from $t2 to $fp-3128
	# _tmp1941 = _tmp1938 == _tmp1936
	  lw $t0, -3120($fp)	# fill _tmp1938 to $t0 from $fp-3120
	  lw $t1, -3112($fp)	# fill _tmp1936 to $t1 from $fp-3112
	  seq $t2, $t0, $t1	
	  sw $t2, -3132($fp)	# spill _tmp1941 from $t2 to $fp-3132
	# _tmp1942 = _tmp1940 || _tmp1941
	  lw $t0, -3128($fp)	# fill _tmp1940 to $t0 from $fp-3128
	  lw $t1, -3132($fp)	# fill _tmp1941 to $t1 from $fp-3132
	  or $t2, $t0, $t1	
	  sw $t2, -3136($fp)	# spill _tmp1942 from $t2 to $fp-3136
	# _tmp1943 = _tmp1942 || _tmp1939
	  lw $t0, -3136($fp)	# fill _tmp1942 to $t0 from $fp-3136
	  lw $t1, -3124($fp)	# fill _tmp1939 to $t1 from $fp-3124
	  or $t2, $t0, $t1	
	  sw $t2, -3140($fp)	# spill _tmp1943 from $t2 to $fp-3140
	# IfZ _tmp1943 Goto _L188
	  lw $t0, -3140($fp)	# fill _tmp1943 to $t0 from $fp-3140
	  beqz $t0, _L188	# branch if _tmp1943 is zero 
	# _tmp1944 = "Decaf runtime error: Array subscript out of bound..."
	  .data			# create string constant marked with label
	  _string124: .asciiz "Decaf runtime error: Array subscript out of bounds\n"
	  .text
	  la $t2, _string124	# load label
	  sw $t2, -3144($fp)	# spill _tmp1944 from $t2 to $fp-3144
	# PushParam _tmp1944
	  subu $sp, $sp, 4	# decrement sp to make space for param
	  lw $t0, -3144($fp)	# fill _tmp1944 to $t0 from $fp-3144
	  sw $t0, 4($sp)	# copy param value to stack
	# LCall _PrintString
	  jal _PrintString   	# jump to function
	# PopParams 4
	  add $sp, $sp, 4	# pop params off stack
	# LCall _Halt
	  jal _Halt          	# jump to function
  _L188:
	# _tmp1945 = 4
	  li $t2, 4		# load constant value 4 into $t2
	  sw $t2, -3148($fp)	# spill _tmp1945 from $t2 to $fp-3148
	# _tmp1946 = _tmp1936 * _tmp1945
	  lw $t0, -3112($fp)	# fill _tmp1936 to $t0 from $fp-3112
	  lw $t1, -3148($fp)	# fill _tmp1945 to $t1 from $fp-3148
	  mul $t2, $t0, $t1	
	  sw $t2, -3152($fp)	# spill _tmp1946 from $t2 to $fp-3152
	# _tmp1947 = _tmp1946 + _tmp1945
	  lw $t0, -3152($fp)	# fill _tmp1946 to $t0 from $fp-3152
	  lw $t1, -3148($fp)	# fill _tmp1945 to $t1 from $fp-3148
	  add $t2, $t0, $t1	
	  sw $t2, -3156($fp)	# spill _tmp1947 from $t2 to $fp-3156
	# _tmp1948 = _tmp1935 + _tmp1947
	  lw $t0, -3108($fp)	# fill _tmp1935 to $t0 from $fp-3108
	  lw $t1, -3156($fp)	# fill _tmp1947 to $t1 from $fp-3156
	  add $t2, $t0, $t1	
	  sw $t2, -3160($fp)	# spill _tmp1948 from $t2 to $fp-3160
	# _tmp1949 = *(_tmp1948)
	  lw $t0, -3160($fp)	# fill _tmp1948 to $t0 from $fp-3160
	  lw $t2, 0($t0) 	# load with offset
	  sw $t2, -3164($fp)	# spill _tmp1949 from $t2 to $fp-3164
	# PushParam _tmp1949
	  subu $sp, $sp, 4	# decrement sp to make space for param
	  lw $t0, -3164($fp)	# fill _tmp1949 to $t0 from $fp-3164
	  sw $t0, 4($sp)	# copy param value to stack
	# _tmp1950 = *(_tmp1949)
	  lw $t0, -3164($fp)	# fill _tmp1949 to $t0 from $fp-3164
	  lw $t2, 0($t0) 	# load with offset
	  sw $t2, -3168($fp)	# spill _tmp1950 from $t2 to $fp-3168
	# _tmp1951 = *(_tmp1950 + 20)
	  lw $t0, -3168($fp)	# fill _tmp1950 to $t0 from $fp-3168
	  lw $t2, 20($t0) 	# load with offset
	  sw $t2, -3172($fp)	# spill _tmp1951 from $t2 to $fp-3172
	# _tmp1952 = ACall _tmp1951
	  lw $t0, -3172($fp)	# fill _tmp1951 to $t0 from $fp-3172
	  jalr $t0            	# jump to function
	  move $t2, $v0		# copy function return value from $v0
	  sw $t2, -3176($fp)	# spill _tmp1952 from $t2 to $fp-3176
	# PopParams 8
	  add $sp, $sp, 8	# pop params off stack
	# _tmp1953 = _tmp1920 && _tmp1952
	  lw $t0, -3048($fp)	# fill _tmp1920 to $t0 from $fp-3048
	  lw $t1, -3176($fp)	# fill _tmp1952 to $t1 from $fp-3176
	  and $t2, $t0, $t1	
	  sw $t2, -3180($fp)	# spill _tmp1953 from $t2 to $fp-3180
	# PushParam playerMark
	  subu $sp, $sp, 4	# decrement sp to make space for param
	  lw $t0, 12($fp)	# fill playerMark to $t0 from $fp+12
	  sw $t0, 4($sp)	# copy param value to stack
	# _tmp1955 = *(this + 4)
	  lw $t0, 4($fp)	# fill this to $t0 from $fp+4
	  lw $t2, 4($t0) 	# load with offset
	  sw $t2, -3188($fp)	# spill _tmp1955 from $t2 to $fp-3188
	# _tmp1956 = 2
	  li $t2, 2		# load constant value 2 into $t2
	  sw $t2, -3192($fp)	# spill _tmp1956 from $t2 to $fp-3192
	# _tmp1957 = 0
	  li $t2, 0		# load constant value 0 into $t2
	  sw $t2, -3196($fp)	# spill _tmp1957 from $t2 to $fp-3196
	# _tmp1958 = *(_tmp1955)
	  lw $t0, -3188($fp)	# fill _tmp1955 to $t0 from $fp-3188
	  lw $t2, 0($t0) 	# load with offset
	  sw $t2, -3200($fp)	# spill _tmp1958 from $t2 to $fp-3200
	# _tmp1959 = _tmp1956 < _tmp1957
	  lw $t0, -3192($fp)	# fill _tmp1956 to $t0 from $fp-3192
	  lw $t1, -3196($fp)	# fill _tmp1957 to $t1 from $fp-3196
	  slt $t2, $t0, $t1	
	  sw $t2, -3204($fp)	# spill _tmp1959 from $t2 to $fp-3204
	# _tmp1960 = _tmp1958 < _tmp1956
	  lw $t0, -3200($fp)	# fill _tmp1958 to $t0 from $fp-3200
	  lw $t1, -3192($fp)	# fill _tmp1956 to $t1 from $fp-3192
	  slt $t2, $t0, $t1	
	  sw $t2, -3208($fp)	# spill _tmp1960 from $t2 to $fp-3208
	# _tmp1961 = _tmp1958 == _tmp1956
	  lw $t0, -3200($fp)	# fill _tmp1958 to $t0 from $fp-3200
	  lw $t1, -3192($fp)	# fill _tmp1956 to $t1 from $fp-3192
	  seq $t2, $t0, $t1	
	  sw $t2, -3212($fp)	# spill _tmp1961 from $t2 to $fp-3212
	# _tmp1962 = _tmp1960 || _tmp1961
	  lw $t0, -3208($fp)	# fill _tmp1960 to $t0 from $fp-3208
	  lw $t1, -3212($fp)	# fill _tmp1961 to $t1 from $fp-3212
	  or $t2, $t0, $t1	
	  sw $t2, -3216($fp)	# spill _tmp1962 from $t2 to $fp-3216
	# _tmp1963 = _tmp1962 || _tmp1959
	  lw $t0, -3216($fp)	# fill _tmp1962 to $t0 from $fp-3216
	  lw $t1, -3204($fp)	# fill _tmp1959 to $t1 from $fp-3204
	  or $t2, $t0, $t1	
	  sw $t2, -3220($fp)	# spill _tmp1963 from $t2 to $fp-3220
	# IfZ _tmp1963 Goto _L191
	  lw $t0, -3220($fp)	# fill _tmp1963 to $t0 from $fp-3220
	  beqz $t0, _L191	# branch if _tmp1963 is zero 
	# _tmp1964 = "Decaf runtime error: Array subscript out of bound..."
	  .data			# create string constant marked with label
	  _string125: .asciiz "Decaf runtime error: Array subscript out of bounds\n"
	  .text
	  la $t2, _string125	# load label
	  sw $t2, -3224($fp)	# spill _tmp1964 from $t2 to $fp-3224
	# PushParam _tmp1964
	  subu $sp, $sp, 4	# decrement sp to make space for param
	  lw $t0, -3224($fp)	# fill _tmp1964 to $t0 from $fp-3224
	  sw $t0, 4($sp)	# copy param value to stack
	# LCall _PrintString
	  jal _PrintString   	# jump to function
	# PopParams 4
	  add $sp, $sp, 4	# pop params off stack
	# LCall _Halt
	  jal _Halt          	# jump to function
  _L191:
	# _tmp1965 = 4
	  li $t2, 4		# load constant value 4 into $t2
	  sw $t2, -3228($fp)	# spill _tmp1965 from $t2 to $fp-3228
	# _tmp1966 = _tmp1956 * _tmp1965
	  lw $t0, -3192($fp)	# fill _tmp1956 to $t0 from $fp-3192
	  lw $t1, -3228($fp)	# fill _tmp1965 to $t1 from $fp-3228
	  mul $t2, $t0, $t1	
	  sw $t2, -3232($fp)	# spill _tmp1966 from $t2 to $fp-3232
	# _tmp1967 = _tmp1966 + _tmp1965
	  lw $t0, -3232($fp)	# fill _tmp1966 to $t0 from $fp-3232
	  lw $t1, -3228($fp)	# fill _tmp1965 to $t1 from $fp-3228
	  add $t2, $t0, $t1	
	  sw $t2, -3236($fp)	# spill _tmp1967 from $t2 to $fp-3236
	# _tmp1968 = _tmp1955 + _tmp1967
	  lw $t0, -3188($fp)	# fill _tmp1955 to $t0 from $fp-3188
	  lw $t1, -3236($fp)	# fill _tmp1967 to $t1 from $fp-3236
	  add $t2, $t0, $t1	
	  sw $t2, -3240($fp)	# spill _tmp1968 from $t2 to $fp-3240
	# _tmp1969 = *(_tmp1968)
	  lw $t0, -3240($fp)	# fill _tmp1968 to $t0 from $fp-3240
	  lw $t2, 0($t0) 	# load with offset
	  sw $t2, -3244($fp)	# spill _tmp1969 from $t2 to $fp-3244
	# _tmp1970 = 1
	  li $t2, 1		# load constant value 1 into $t2
	  sw $t2, -3248($fp)	# spill _tmp1970 from $t2 to $fp-3248
	# _tmp1971 = 0
	  li $t2, 0		# load constant value 0 into $t2
	  sw $t2, -3252($fp)	# spill _tmp1971 from $t2 to $fp-3252
	# _tmp1972 = *(_tmp1969)
	  lw $t0, -3244($fp)	# fill _tmp1969 to $t0 from $fp-3244
	  lw $t2, 0($t0) 	# load with offset
	  sw $t2, -3256($fp)	# spill _tmp1972 from $t2 to $fp-3256
	# _tmp1973 = _tmp1970 < _tmp1971
	  lw $t0, -3248($fp)	# fill _tmp1970 to $t0 from $fp-3248
	  lw $t1, -3252($fp)	# fill _tmp1971 to $t1 from $fp-3252
	  slt $t2, $t0, $t1	
	  sw $t2, -3260($fp)	# spill _tmp1973 from $t2 to $fp-3260
	# _tmp1974 = _tmp1972 < _tmp1970
	  lw $t0, -3256($fp)	# fill _tmp1972 to $t0 from $fp-3256
	  lw $t1, -3248($fp)	# fill _tmp1970 to $t1 from $fp-3248
	  slt $t2, $t0, $t1	
	  sw $t2, -3264($fp)	# spill _tmp1974 from $t2 to $fp-3264
	# _tmp1975 = _tmp1972 == _tmp1970
	  lw $t0, -3256($fp)	# fill _tmp1972 to $t0 from $fp-3256
	  lw $t1, -3248($fp)	# fill _tmp1970 to $t1 from $fp-3248
	  seq $t2, $t0, $t1	
	  sw $t2, -3268($fp)	# spill _tmp1975 from $t2 to $fp-3268
	# _tmp1976 = _tmp1974 || _tmp1975
	  lw $t0, -3264($fp)	# fill _tmp1974 to $t0 from $fp-3264
	  lw $t1, -3268($fp)	# fill _tmp1975 to $t1 from $fp-3268
	  or $t2, $t0, $t1	
	  sw $t2, -3272($fp)	# spill _tmp1976 from $t2 to $fp-3272
	# _tmp1977 = _tmp1976 || _tmp1973
	  lw $t0, -3272($fp)	# fill _tmp1976 to $t0 from $fp-3272
	  lw $t1, -3260($fp)	# fill _tmp1973 to $t1 from $fp-3260
	  or $t2, $t0, $t1	
	  sw $t2, -3276($fp)	# spill _tmp1977 from $t2 to $fp-3276
	# IfZ _tmp1977 Goto _L192
	  lw $t0, -3276($fp)	# fill _tmp1977 to $t0 from $fp-3276
	  beqz $t0, _L192	# branch if _tmp1977 is zero 
	# _tmp1978 = "Decaf runtime error: Array subscript out of bound..."
	  .data			# create string constant marked with label
	  _string126: .asciiz "Decaf runtime error: Array subscript out of bounds\n"
	  .text
	  la $t2, _string126	# load label
	  sw $t2, -3280($fp)	# spill _tmp1978 from $t2 to $fp-3280
	# PushParam _tmp1978
	  subu $sp, $sp, 4	# decrement sp to make space for param
	  lw $t0, -3280($fp)	# fill _tmp1978 to $t0 from $fp-3280
	  sw $t0, 4($sp)	# copy param value to stack
	# LCall _PrintString
	  jal _PrintString   	# jump to function
	# PopParams 4
	  add $sp, $sp, 4	# pop params off stack
	# LCall _Halt
	  jal _Halt          	# jump to function
  _L192:
	# _tmp1979 = 4
	  li $t2, 4		# load constant value 4 into $t2
	  sw $t2, -3284($fp)	# spill _tmp1979 from $t2 to $fp-3284
	# _tmp1980 = _tmp1970 * _tmp1979
	  lw $t0, -3248($fp)	# fill _tmp1970 to $t0 from $fp-3248
	  lw $t1, -3284($fp)	# fill _tmp1979 to $t1 from $fp-3284
	  mul $t2, $t0, $t1	
	  sw $t2, -3288($fp)	# spill _tmp1980 from $t2 to $fp-3288
	# _tmp1981 = _tmp1980 + _tmp1979
	  lw $t0, -3288($fp)	# fill _tmp1980 to $t0 from $fp-3288
	  lw $t1, -3284($fp)	# fill _tmp1979 to $t1 from $fp-3284
	  add $t2, $t0, $t1	
	  sw $t2, -3292($fp)	# spill _tmp1981 from $t2 to $fp-3292
	# _tmp1982 = _tmp1969 + _tmp1981
	  lw $t0, -3244($fp)	# fill _tmp1969 to $t0 from $fp-3244
	  lw $t1, -3292($fp)	# fill _tmp1981 to $t1 from $fp-3292
	  add $t2, $t0, $t1	
	  sw $t2, -3296($fp)	# spill _tmp1982 from $t2 to $fp-3296
	# _tmp1983 = *(_tmp1982)
	  lw $t0, -3296($fp)	# fill _tmp1982 to $t0 from $fp-3296
	  lw $t2, 0($t0) 	# load with offset
	  sw $t2, -3300($fp)	# spill _tmp1983 from $t2 to $fp-3300
	# PushParam _tmp1983
	  subu $sp, $sp, 4	# decrement sp to make space for param
	  lw $t0, -3300($fp)	# fill _tmp1983 to $t0 from $fp-3300
	  sw $t0, 4($sp)	# copy param value to stack
	# _tmp1984 = *(_tmp1983)
	  lw $t0, -3300($fp)	# fill _tmp1983 to $t0 from $fp-3300
	  lw $t2, 0($t0) 	# load with offset
	  sw $t2, -3304($fp)	# spill _tmp1984 from $t2 to $fp-3304
	# _tmp1985 = *(_tmp1984 + 20)
	  lw $t0, -3304($fp)	# fill _tmp1984 to $t0 from $fp-3304
	  lw $t2, 20($t0) 	# load with offset
	  sw $t2, -3308($fp)	# spill _tmp1985 from $t2 to $fp-3308
	# _tmp1986 = ACall _tmp1985
	  lw $t0, -3308($fp)	# fill _tmp1985 to $t0 from $fp-3308
	  jalr $t0            	# jump to function
	  move $t2, $v0		# copy function return value from $v0
	  sw $t2, -3312($fp)	# spill _tmp1986 from $t2 to $fp-3312
	# PopParams 8
	  add $sp, $sp, 8	# pop params off stack
	# IfZ _tmp1986 Goto _L190
	  lw $t0, -3312($fp)	# fill _tmp1986 to $t0 from $fp-3312
	  beqz $t0, _L190	# branch if _tmp1986 is zero 
	# _tmp1987 = 0
	  li $t2, 0		# load constant value 0 into $t2
	  sw $t2, -3316($fp)	# spill _tmp1987 from $t2 to $fp-3316
	# _tmp1954 = _tmp1987
	  lw $t2, -3316($fp)	# fill _tmp1987 to $t2 from $fp-3316
	  sw $t2, -3184($fp)	# spill _tmp1954 from $t2 to $fp-3184
	# Goto _L189
	  b _L189		# unconditional branch
  _L190:
	# _tmp1988 = 1
	  li $t2, 1		# load constant value 1 into $t2
	  sw $t2, -3320($fp)	# spill _tmp1988 from $t2 to $fp-3320
	# _tmp1954 = _tmp1988
	  lw $t2, -3320($fp)	# fill _tmp1988 to $t2 from $fp-3320
	  sw $t2, -3184($fp)	# spill _tmp1954 from $t2 to $fp-3184
  _L189:
	# _tmp1989 = _tmp1953 && _tmp1954
	  lw $t0, -3180($fp)	# fill _tmp1953 to $t0 from $fp-3180
	  lw $t1, -3184($fp)	# fill _tmp1954 to $t1 from $fp-3184
	  and $t2, $t0, $t1	
	  sw $t2, -3324($fp)	# spill _tmp1989 from $t2 to $fp-3324
	# IfZ _tmp1989 Goto _L183
	  lw $t0, -3324($fp)	# fill _tmp1989 to $t0 from $fp-3324
	  beqz $t0, _L183	# branch if _tmp1989 is zero 
	# _tmp1990 = 2
	  li $t2, 2		# load constant value 2 into $t2
	  sw $t2, -3328($fp)	# spill _tmp1990 from $t2 to $fp-3328
	# row = _tmp1990
	  lw $t2, -3328($fp)	# fill _tmp1990 to $t2 from $fp-3328
	  sw $t2, -8($fp)	# spill row from $t2 to $fp-8
	# _tmp1991 = 1
	  li $t2, 1		# load constant value 1 into $t2
	  sw $t2, -3332($fp)	# spill _tmp1991 from $t2 to $fp-3332
	# column = _tmp1991
	  lw $t2, -3332($fp)	# fill _tmp1991 to $t2 from $fp-3332
	  sw $t2, -12($fp)	# spill column from $t2 to $fp-12
	# Goto _L184
	  b _L184		# unconditional branch
  _L183:
	# PushParam enemyMark
	  subu $sp, $sp, 4	# decrement sp to make space for param
	  lw $t0, 8($fp)	# fill enemyMark to $t0 from $fp+8
	  sw $t0, 4($sp)	# copy param value to stack
	# _tmp1992 = *(this + 4)
	  lw $t0, 4($fp)	# fill this to $t0 from $fp+4
	  lw $t2, 4($t0) 	# load with offset
	  sw $t2, -3336($fp)	# spill _tmp1992 from $t2 to $fp-3336
	# _tmp1993 = 0
	  li $t2, 0		# load constant value 0 into $t2
	  sw $t2, -3340($fp)	# spill _tmp1993 from $t2 to $fp-3340
	# _tmp1994 = 0
	  li $t2, 0		# load constant value 0 into $t2
	  sw $t2, -3344($fp)	# spill _tmp1994 from $t2 to $fp-3344
	# _tmp1995 = *(_tmp1992)
	  lw $t0, -3336($fp)	# fill _tmp1992 to $t0 from $fp-3336
	  lw $t2, 0($t0) 	# load with offset
	  sw $t2, -3348($fp)	# spill _tmp1995 from $t2 to $fp-3348
	# _tmp1996 = _tmp1993 < _tmp1994
	  lw $t0, -3340($fp)	# fill _tmp1993 to $t0 from $fp-3340
	  lw $t1, -3344($fp)	# fill _tmp1994 to $t1 from $fp-3344
	  slt $t2, $t0, $t1	
	  sw $t2, -3352($fp)	# spill _tmp1996 from $t2 to $fp-3352
	# _tmp1997 = _tmp1995 < _tmp1993
	  lw $t0, -3348($fp)	# fill _tmp1995 to $t0 from $fp-3348
	  lw $t1, -3340($fp)	# fill _tmp1993 to $t1 from $fp-3340
	  slt $t2, $t0, $t1	
	  sw $t2, -3356($fp)	# spill _tmp1997 from $t2 to $fp-3356
	# _tmp1998 = _tmp1995 == _tmp1993
	  lw $t0, -3348($fp)	# fill _tmp1995 to $t0 from $fp-3348
	  lw $t1, -3340($fp)	# fill _tmp1993 to $t1 from $fp-3340
	  seq $t2, $t0, $t1	
	  sw $t2, -3360($fp)	# spill _tmp1998 from $t2 to $fp-3360
	# _tmp1999 = _tmp1997 || _tmp1998
	  lw $t0, -3356($fp)	# fill _tmp1997 to $t0 from $fp-3356
	  lw $t1, -3360($fp)	# fill _tmp1998 to $t1 from $fp-3360
	  or $t2, $t0, $t1	
	  sw $t2, -3364($fp)	# spill _tmp1999 from $t2 to $fp-3364
	# _tmp2000 = _tmp1999 || _tmp1996
	  lw $t0, -3364($fp)	# fill _tmp1999 to $t0 from $fp-3364
	  lw $t1, -3352($fp)	# fill _tmp1996 to $t1 from $fp-3352
	  or $t2, $t0, $t1	
	  sw $t2, -3368($fp)	# spill _tmp2000 from $t2 to $fp-3368
	# IfZ _tmp2000 Goto _L195
	  lw $t0, -3368($fp)	# fill _tmp2000 to $t0 from $fp-3368
	  beqz $t0, _L195	# branch if _tmp2000 is zero 
	# _tmp2001 = "Decaf runtime error: Array subscript out of bound..."
	  .data			# create string constant marked with label
	  _string127: .asciiz "Decaf runtime error: Array subscript out of bounds\n"
	  .text
	  la $t2, _string127	# load label
	  sw $t2, -3372($fp)	# spill _tmp2001 from $t2 to $fp-3372
	# PushParam _tmp2001
	  subu $sp, $sp, 4	# decrement sp to make space for param
	  lw $t0, -3372($fp)	# fill _tmp2001 to $t0 from $fp-3372
	  sw $t0, 4($sp)	# copy param value to stack
	# LCall _PrintString
	  jal _PrintString   	# jump to function
	# PopParams 4
	  add $sp, $sp, 4	# pop params off stack
	# LCall _Halt
	  jal _Halt          	# jump to function
  _L195:
	# _tmp2002 = 4
	  li $t2, 4		# load constant value 4 into $t2
	  sw $t2, -3376($fp)	# spill _tmp2002 from $t2 to $fp-3376
	# _tmp2003 = _tmp1993 * _tmp2002
	  lw $t0, -3340($fp)	# fill _tmp1993 to $t0 from $fp-3340
	  lw $t1, -3376($fp)	# fill _tmp2002 to $t1 from $fp-3376
	  mul $t2, $t0, $t1	
	  sw $t2, -3380($fp)	# spill _tmp2003 from $t2 to $fp-3380
	# _tmp2004 = _tmp2003 + _tmp2002
	  lw $t0, -3380($fp)	# fill _tmp2003 to $t0 from $fp-3380
	  lw $t1, -3376($fp)	# fill _tmp2002 to $t1 from $fp-3376
	  add $t2, $t0, $t1	
	  sw $t2, -3384($fp)	# spill _tmp2004 from $t2 to $fp-3384
	# _tmp2005 = _tmp1992 + _tmp2004
	  lw $t0, -3336($fp)	# fill _tmp1992 to $t0 from $fp-3336
	  lw $t1, -3384($fp)	# fill _tmp2004 to $t1 from $fp-3384
	  add $t2, $t0, $t1	
	  sw $t2, -3388($fp)	# spill _tmp2005 from $t2 to $fp-3388
	# _tmp2006 = *(_tmp2005)
	  lw $t0, -3388($fp)	# fill _tmp2005 to $t0 from $fp-3388
	  lw $t2, 0($t0) 	# load with offset
	  sw $t2, -3392($fp)	# spill _tmp2006 from $t2 to $fp-3392
	# _tmp2007 = 2
	  li $t2, 2		# load constant value 2 into $t2
	  sw $t2, -3396($fp)	# spill _tmp2007 from $t2 to $fp-3396
	# _tmp2008 = 0
	  li $t2, 0		# load constant value 0 into $t2
	  sw $t2, -3400($fp)	# spill _tmp2008 from $t2 to $fp-3400
	# _tmp2009 = *(_tmp2006)
	  lw $t0, -3392($fp)	# fill _tmp2006 to $t0 from $fp-3392
	  lw $t2, 0($t0) 	# load with offset
	  sw $t2, -3404($fp)	# spill _tmp2009 from $t2 to $fp-3404
	# _tmp2010 = _tmp2007 < _tmp2008
	  lw $t0, -3396($fp)	# fill _tmp2007 to $t0 from $fp-3396
	  lw $t1, -3400($fp)	# fill _tmp2008 to $t1 from $fp-3400
	  slt $t2, $t0, $t1	
	  sw $t2, -3408($fp)	# spill _tmp2010 from $t2 to $fp-3408
	# _tmp2011 = _tmp2009 < _tmp2007
	  lw $t0, -3404($fp)	# fill _tmp2009 to $t0 from $fp-3404
	  lw $t1, -3396($fp)	# fill _tmp2007 to $t1 from $fp-3396
	  slt $t2, $t0, $t1	
	  sw $t2, -3412($fp)	# spill _tmp2011 from $t2 to $fp-3412
	# _tmp2012 = _tmp2009 == _tmp2007
	  lw $t0, -3404($fp)	# fill _tmp2009 to $t0 from $fp-3404
	  lw $t1, -3396($fp)	# fill _tmp2007 to $t1 from $fp-3396
	  seq $t2, $t0, $t1	
	  sw $t2, -3416($fp)	# spill _tmp2012 from $t2 to $fp-3416
	# _tmp2013 = _tmp2011 || _tmp2012
	  lw $t0, -3412($fp)	# fill _tmp2011 to $t0 from $fp-3412
	  lw $t1, -3416($fp)	# fill _tmp2012 to $t1 from $fp-3416
	  or $t2, $t0, $t1	
	  sw $t2, -3420($fp)	# spill _tmp2013 from $t2 to $fp-3420
	# _tmp2014 = _tmp2013 || _tmp2010
	  lw $t0, -3420($fp)	# fill _tmp2013 to $t0 from $fp-3420
	  lw $t1, -3408($fp)	# fill _tmp2010 to $t1 from $fp-3408
	  or $t2, $t0, $t1	
	  sw $t2, -3424($fp)	# spill _tmp2014 from $t2 to $fp-3424
	# IfZ _tmp2014 Goto _L196
	  lw $t0, -3424($fp)	# fill _tmp2014 to $t0 from $fp-3424
	  beqz $t0, _L196	# branch if _tmp2014 is zero 
	# _tmp2015 = "Decaf runtime error: Array subscript out of bound..."
	  .data			# create string constant marked with label
	  _string128: .asciiz "Decaf runtime error: Array subscript out of bounds\n"
	  .text
	  la $t2, _string128	# load label
	  sw $t2, -3428($fp)	# spill _tmp2015 from $t2 to $fp-3428
	# PushParam _tmp2015
	  subu $sp, $sp, 4	# decrement sp to make space for param
	  lw $t0, -3428($fp)	# fill _tmp2015 to $t0 from $fp-3428
	  sw $t0, 4($sp)	# copy param value to stack
	# LCall _PrintString
	  jal _PrintString   	# jump to function
	# PopParams 4
	  add $sp, $sp, 4	# pop params off stack
	# LCall _Halt
	  jal _Halt          	# jump to function
  _L196:
	# _tmp2016 = 4
	  li $t2, 4		# load constant value 4 into $t2
	  sw $t2, -3432($fp)	# spill _tmp2016 from $t2 to $fp-3432
	# _tmp2017 = _tmp2007 * _tmp2016
	  lw $t0, -3396($fp)	# fill _tmp2007 to $t0 from $fp-3396
	  lw $t1, -3432($fp)	# fill _tmp2016 to $t1 from $fp-3432
	  mul $t2, $t0, $t1	
	  sw $t2, -3436($fp)	# spill _tmp2017 from $t2 to $fp-3436
	# _tmp2018 = _tmp2017 + _tmp2016
	  lw $t0, -3436($fp)	# fill _tmp2017 to $t0 from $fp-3436
	  lw $t1, -3432($fp)	# fill _tmp2016 to $t1 from $fp-3432
	  add $t2, $t0, $t1	
	  sw $t2, -3440($fp)	# spill _tmp2018 from $t2 to $fp-3440
	# _tmp2019 = _tmp2006 + _tmp2018
	  lw $t0, -3392($fp)	# fill _tmp2006 to $t0 from $fp-3392
	  lw $t1, -3440($fp)	# fill _tmp2018 to $t1 from $fp-3440
	  add $t2, $t0, $t1	
	  sw $t2, -3444($fp)	# spill _tmp2019 from $t2 to $fp-3444
	# _tmp2020 = *(_tmp2019)
	  lw $t0, -3444($fp)	# fill _tmp2019 to $t0 from $fp-3444
	  lw $t2, 0($t0) 	# load with offset
	  sw $t2, -3448($fp)	# spill _tmp2020 from $t2 to $fp-3448
	# PushParam _tmp2020
	  subu $sp, $sp, 4	# decrement sp to make space for param
	  lw $t0, -3448($fp)	# fill _tmp2020 to $t0 from $fp-3448
	  sw $t0, 4($sp)	# copy param value to stack
	# _tmp2021 = *(_tmp2020)
	  lw $t0, -3448($fp)	# fill _tmp2020 to $t0 from $fp-3448
	  lw $t2, 0($t0) 	# load with offset
	  sw $t2, -3452($fp)	# spill _tmp2021 from $t2 to $fp-3452
	# _tmp2022 = *(_tmp2021 + 20)
	  lw $t0, -3452($fp)	# fill _tmp2021 to $t0 from $fp-3452
	  lw $t2, 20($t0) 	# load with offset
	  sw $t2, -3456($fp)	# spill _tmp2022 from $t2 to $fp-3456
	# _tmp2023 = ACall _tmp2022
	  lw $t0, -3456($fp)	# fill _tmp2022 to $t0 from $fp-3456
	  jalr $t0            	# jump to function
	  move $t2, $v0		# copy function return value from $v0
	  sw $t2, -3460($fp)	# spill _tmp2023 from $t2 to $fp-3460
	# PopParams 8
	  add $sp, $sp, 8	# pop params off stack
	# PushParam enemyMark
	  subu $sp, $sp, 4	# decrement sp to make space for param
	  lw $t0, 8($fp)	# fill enemyMark to $t0 from $fp+8
	  sw $t0, 4($sp)	# copy param value to stack
	# _tmp2024 = *(this + 4)
	  lw $t0, 4($fp)	# fill this to $t0 from $fp+4
	  lw $t2, 4($t0) 	# load with offset
	  sw $t2, -3464($fp)	# spill _tmp2024 from $t2 to $fp-3464
	# _tmp2025 = 1
	  li $t2, 1		# load constant value 1 into $t2
	  sw $t2, -3468($fp)	# spill _tmp2025 from $t2 to $fp-3468
	# _tmp2026 = 0
	  li $t2, 0		# load constant value 0 into $t2
	  sw $t2, -3472($fp)	# spill _tmp2026 from $t2 to $fp-3472
	# _tmp2027 = *(_tmp2024)
	  lw $t0, -3464($fp)	# fill _tmp2024 to $t0 from $fp-3464
	  lw $t2, 0($t0) 	# load with offset
	  sw $t2, -3476($fp)	# spill _tmp2027 from $t2 to $fp-3476
	# _tmp2028 = _tmp2025 < _tmp2026
	  lw $t0, -3468($fp)	# fill _tmp2025 to $t0 from $fp-3468
	  lw $t1, -3472($fp)	# fill _tmp2026 to $t1 from $fp-3472
	  slt $t2, $t0, $t1	
	  sw $t2, -3480($fp)	# spill _tmp2028 from $t2 to $fp-3480
	# _tmp2029 = _tmp2027 < _tmp2025
	  lw $t0, -3476($fp)	# fill _tmp2027 to $t0 from $fp-3476
	  lw $t1, -3468($fp)	# fill _tmp2025 to $t1 from $fp-3468
	  slt $t2, $t0, $t1	
	  sw $t2, -3484($fp)	# spill _tmp2029 from $t2 to $fp-3484
	# _tmp2030 = _tmp2027 == _tmp2025
	  lw $t0, -3476($fp)	# fill _tmp2027 to $t0 from $fp-3476
	  lw $t1, -3468($fp)	# fill _tmp2025 to $t1 from $fp-3468
	  seq $t2, $t0, $t1	
	  sw $t2, -3488($fp)	# spill _tmp2030 from $t2 to $fp-3488
	# _tmp2031 = _tmp2029 || _tmp2030
	  lw $t0, -3484($fp)	# fill _tmp2029 to $t0 from $fp-3484
	  lw $t1, -3488($fp)	# fill _tmp2030 to $t1 from $fp-3488
	  or $t2, $t0, $t1	
	  sw $t2, -3492($fp)	# spill _tmp2031 from $t2 to $fp-3492
	# _tmp2032 = _tmp2031 || _tmp2028
	  lw $t0, -3492($fp)	# fill _tmp2031 to $t0 from $fp-3492
	  lw $t1, -3480($fp)	# fill _tmp2028 to $t1 from $fp-3480
	  or $t2, $t0, $t1	
	  sw $t2, -3496($fp)	# spill _tmp2032 from $t2 to $fp-3496
	# IfZ _tmp2032 Goto _L197
	  lw $t0, -3496($fp)	# fill _tmp2032 to $t0 from $fp-3496
	  beqz $t0, _L197	# branch if _tmp2032 is zero 
	# _tmp2033 = "Decaf runtime error: Array subscript out of bound..."
	  .data			# create string constant marked with label
	  _string129: .asciiz "Decaf runtime error: Array subscript out of bounds\n"
	  .text
	  la $t2, _string129	# load label
	  sw $t2, -3500($fp)	# spill _tmp2033 from $t2 to $fp-3500
	# PushParam _tmp2033
	  subu $sp, $sp, 4	# decrement sp to make space for param
	  lw $t0, -3500($fp)	# fill _tmp2033 to $t0 from $fp-3500
	  sw $t0, 4($sp)	# copy param value to stack
	# LCall _PrintString
	  jal _PrintString   	# jump to function
	# PopParams 4
	  add $sp, $sp, 4	# pop params off stack
	# LCall _Halt
	  jal _Halt          	# jump to function
  _L197:
	# _tmp2034 = 4
	  li $t2, 4		# load constant value 4 into $t2
	  sw $t2, -3504($fp)	# spill _tmp2034 from $t2 to $fp-3504
	# _tmp2035 = _tmp2025 * _tmp2034
	  lw $t0, -3468($fp)	# fill _tmp2025 to $t0 from $fp-3468
	  lw $t1, -3504($fp)	# fill _tmp2034 to $t1 from $fp-3504
	  mul $t2, $t0, $t1	
	  sw $t2, -3508($fp)	# spill _tmp2035 from $t2 to $fp-3508
	# _tmp2036 = _tmp2035 + _tmp2034
	  lw $t0, -3508($fp)	# fill _tmp2035 to $t0 from $fp-3508
	  lw $t1, -3504($fp)	# fill _tmp2034 to $t1 from $fp-3504
	  add $t2, $t0, $t1	
	  sw $t2, -3512($fp)	# spill _tmp2036 from $t2 to $fp-3512
	# _tmp2037 = _tmp2024 + _tmp2036
	  lw $t0, -3464($fp)	# fill _tmp2024 to $t0 from $fp-3464
	  lw $t1, -3512($fp)	# fill _tmp2036 to $t1 from $fp-3512
	  add $t2, $t0, $t1	
	  sw $t2, -3516($fp)	# spill _tmp2037 from $t2 to $fp-3516
	# _tmp2038 = *(_tmp2037)
	  lw $t0, -3516($fp)	# fill _tmp2037 to $t0 from $fp-3516
	  lw $t2, 0($t0) 	# load with offset
	  sw $t2, -3520($fp)	# spill _tmp2038 from $t2 to $fp-3520
	# _tmp2039 = 2
	  li $t2, 2		# load constant value 2 into $t2
	  sw $t2, -3524($fp)	# spill _tmp2039 from $t2 to $fp-3524
	# _tmp2040 = 0
	  li $t2, 0		# load constant value 0 into $t2
	  sw $t2, -3528($fp)	# spill _tmp2040 from $t2 to $fp-3528
	# _tmp2041 = *(_tmp2038)
	  lw $t0, -3520($fp)	# fill _tmp2038 to $t0 from $fp-3520
	  lw $t2, 0($t0) 	# load with offset
	  sw $t2, -3532($fp)	# spill _tmp2041 from $t2 to $fp-3532
	# _tmp2042 = _tmp2039 < _tmp2040
	  lw $t0, -3524($fp)	# fill _tmp2039 to $t0 from $fp-3524
	  lw $t1, -3528($fp)	# fill _tmp2040 to $t1 from $fp-3528
	  slt $t2, $t0, $t1	
	  sw $t2, -3536($fp)	# spill _tmp2042 from $t2 to $fp-3536
	# _tmp2043 = _tmp2041 < _tmp2039
	  lw $t0, -3532($fp)	# fill _tmp2041 to $t0 from $fp-3532
	  lw $t1, -3524($fp)	# fill _tmp2039 to $t1 from $fp-3524
	  slt $t2, $t0, $t1	
	  sw $t2, -3540($fp)	# spill _tmp2043 from $t2 to $fp-3540
	# _tmp2044 = _tmp2041 == _tmp2039
	  lw $t0, -3532($fp)	# fill _tmp2041 to $t0 from $fp-3532
	  lw $t1, -3524($fp)	# fill _tmp2039 to $t1 from $fp-3524
	  seq $t2, $t0, $t1	
	  sw $t2, -3544($fp)	# spill _tmp2044 from $t2 to $fp-3544
	# _tmp2045 = _tmp2043 || _tmp2044
	  lw $t0, -3540($fp)	# fill _tmp2043 to $t0 from $fp-3540
	  lw $t1, -3544($fp)	# fill _tmp2044 to $t1 from $fp-3544
	  or $t2, $t0, $t1	
	  sw $t2, -3548($fp)	# spill _tmp2045 from $t2 to $fp-3548
	# _tmp2046 = _tmp2045 || _tmp2042
	  lw $t0, -3548($fp)	# fill _tmp2045 to $t0 from $fp-3548
	  lw $t1, -3536($fp)	# fill _tmp2042 to $t1 from $fp-3536
	  or $t2, $t0, $t1	
	  sw $t2, -3552($fp)	# spill _tmp2046 from $t2 to $fp-3552
	# IfZ _tmp2046 Goto _L198
	  lw $t0, -3552($fp)	# fill _tmp2046 to $t0 from $fp-3552
	  beqz $t0, _L198	# branch if _tmp2046 is zero 
	# _tmp2047 = "Decaf runtime error: Array subscript out of bound..."
	  .data			# create string constant marked with label
	  _string130: .asciiz "Decaf runtime error: Array subscript out of bounds\n"
	  .text
	  la $t2, _string130	# load label
	  sw $t2, -3556($fp)	# spill _tmp2047 from $t2 to $fp-3556
	# PushParam _tmp2047
	  subu $sp, $sp, 4	# decrement sp to make space for param
	  lw $t0, -3556($fp)	# fill _tmp2047 to $t0 from $fp-3556
	  sw $t0, 4($sp)	# copy param value to stack
	# LCall _PrintString
	  jal _PrintString   	# jump to function
	# PopParams 4
	  add $sp, $sp, 4	# pop params off stack
	# LCall _Halt
	  jal _Halt          	# jump to function
  _L198:
	# _tmp2048 = 4
	  li $t2, 4		# load constant value 4 into $t2
	  sw $t2, -3560($fp)	# spill _tmp2048 from $t2 to $fp-3560
	# _tmp2049 = _tmp2039 * _tmp2048
	  lw $t0, -3524($fp)	# fill _tmp2039 to $t0 from $fp-3524
	  lw $t1, -3560($fp)	# fill _tmp2048 to $t1 from $fp-3560
	  mul $t2, $t0, $t1	
	  sw $t2, -3564($fp)	# spill _tmp2049 from $t2 to $fp-3564
	# _tmp2050 = _tmp2049 + _tmp2048
	  lw $t0, -3564($fp)	# fill _tmp2049 to $t0 from $fp-3564
	  lw $t1, -3560($fp)	# fill _tmp2048 to $t1 from $fp-3560
	  add $t2, $t0, $t1	
	  sw $t2, -3568($fp)	# spill _tmp2050 from $t2 to $fp-3568
	# _tmp2051 = _tmp2038 + _tmp2050
	  lw $t0, -3520($fp)	# fill _tmp2038 to $t0 from $fp-3520
	  lw $t1, -3568($fp)	# fill _tmp2050 to $t1 from $fp-3568
	  add $t2, $t0, $t1	
	  sw $t2, -3572($fp)	# spill _tmp2051 from $t2 to $fp-3572
	# _tmp2052 = *(_tmp2051)
	  lw $t0, -3572($fp)	# fill _tmp2051 to $t0 from $fp-3572
	  lw $t2, 0($t0) 	# load with offset
	  sw $t2, -3576($fp)	# spill _tmp2052 from $t2 to $fp-3576
	# PushParam _tmp2052
	  subu $sp, $sp, 4	# decrement sp to make space for param
	  lw $t0, -3576($fp)	# fill _tmp2052 to $t0 from $fp-3576
	  sw $t0, 4($sp)	# copy param value to stack
	# _tmp2053 = *(_tmp2052)
	  lw $t0, -3576($fp)	# fill _tmp2052 to $t0 from $fp-3576
	  lw $t2, 0($t0) 	# load with offset
	  sw $t2, -3580($fp)	# spill _tmp2053 from $t2 to $fp-3580
	# _tmp2054 = *(_tmp2053 + 20)
	  lw $t0, -3580($fp)	# fill _tmp2053 to $t0 from $fp-3580
	  lw $t2, 20($t0) 	# load with offset
	  sw $t2, -3584($fp)	# spill _tmp2054 from $t2 to $fp-3584
	# _tmp2055 = ACall _tmp2054
	  lw $t0, -3584($fp)	# fill _tmp2054 to $t0 from $fp-3584
	  jalr $t0            	# jump to function
	  move $t2, $v0		# copy function return value from $v0
	  sw $t2, -3588($fp)	# spill _tmp2055 from $t2 to $fp-3588
	# PopParams 8
	  add $sp, $sp, 8	# pop params off stack
	# _tmp2056 = _tmp2023 && _tmp2055
	  lw $t0, -3460($fp)	# fill _tmp2023 to $t0 from $fp-3460
	  lw $t1, -3588($fp)	# fill _tmp2055 to $t1 from $fp-3588
	  and $t2, $t0, $t1	
	  sw $t2, -3592($fp)	# spill _tmp2056 from $t2 to $fp-3592
	# PushParam playerMark
	  subu $sp, $sp, 4	# decrement sp to make space for param
	  lw $t0, 12($fp)	# fill playerMark to $t0 from $fp+12
	  sw $t0, 4($sp)	# copy param value to stack
	# _tmp2058 = *(this + 4)
	  lw $t0, 4($fp)	# fill this to $t0 from $fp+4
	  lw $t2, 4($t0) 	# load with offset
	  sw $t2, -3600($fp)	# spill _tmp2058 from $t2 to $fp-3600
	# _tmp2059 = 2
	  li $t2, 2		# load constant value 2 into $t2
	  sw $t2, -3604($fp)	# spill _tmp2059 from $t2 to $fp-3604
	# _tmp2060 = 0
	  li $t2, 0		# load constant value 0 into $t2
	  sw $t2, -3608($fp)	# spill _tmp2060 from $t2 to $fp-3608
	# _tmp2061 = *(_tmp2058)
	  lw $t0, -3600($fp)	# fill _tmp2058 to $t0 from $fp-3600
	  lw $t2, 0($t0) 	# load with offset
	  sw $t2, -3612($fp)	# spill _tmp2061 from $t2 to $fp-3612
	# _tmp2062 = _tmp2059 < _tmp2060
	  lw $t0, -3604($fp)	# fill _tmp2059 to $t0 from $fp-3604
	  lw $t1, -3608($fp)	# fill _tmp2060 to $t1 from $fp-3608
	  slt $t2, $t0, $t1	
	  sw $t2, -3616($fp)	# spill _tmp2062 from $t2 to $fp-3616
	# _tmp2063 = _tmp2061 < _tmp2059
	  lw $t0, -3612($fp)	# fill _tmp2061 to $t0 from $fp-3612
	  lw $t1, -3604($fp)	# fill _tmp2059 to $t1 from $fp-3604
	  slt $t2, $t0, $t1	
	  sw $t2, -3620($fp)	# spill _tmp2063 from $t2 to $fp-3620
	# _tmp2064 = _tmp2061 == _tmp2059
	  lw $t0, -3612($fp)	# fill _tmp2061 to $t0 from $fp-3612
	  lw $t1, -3604($fp)	# fill _tmp2059 to $t1 from $fp-3604
	  seq $t2, $t0, $t1	
	  sw $t2, -3624($fp)	# spill _tmp2064 from $t2 to $fp-3624
	# _tmp2065 = _tmp2063 || _tmp2064
	  lw $t0, -3620($fp)	# fill _tmp2063 to $t0 from $fp-3620
	  lw $t1, -3624($fp)	# fill _tmp2064 to $t1 from $fp-3624
	  or $t2, $t0, $t1	
	  sw $t2, -3628($fp)	# spill _tmp2065 from $t2 to $fp-3628
	# _tmp2066 = _tmp2065 || _tmp2062
	  lw $t0, -3628($fp)	# fill _tmp2065 to $t0 from $fp-3628
	  lw $t1, -3616($fp)	# fill _tmp2062 to $t1 from $fp-3616
	  or $t2, $t0, $t1	
	  sw $t2, -3632($fp)	# spill _tmp2066 from $t2 to $fp-3632
	# IfZ _tmp2066 Goto _L201
	  lw $t0, -3632($fp)	# fill _tmp2066 to $t0 from $fp-3632
	  beqz $t0, _L201	# branch if _tmp2066 is zero 
	# _tmp2067 = "Decaf runtime error: Array subscript out of bound..."
	  .data			# create string constant marked with label
	  _string131: .asciiz "Decaf runtime error: Array subscript out of bounds\n"
	  .text
	  la $t2, _string131	# load label
	  sw $t2, -3636($fp)	# spill _tmp2067 from $t2 to $fp-3636
	# PushParam _tmp2067
	  subu $sp, $sp, 4	# decrement sp to make space for param
	  lw $t0, -3636($fp)	# fill _tmp2067 to $t0 from $fp-3636
	  sw $t0, 4($sp)	# copy param value to stack
	# LCall _PrintString
	  jal _PrintString   	# jump to function
	# PopParams 4
	  add $sp, $sp, 4	# pop params off stack
	# LCall _Halt
	  jal _Halt          	# jump to function
  _L201:
	# _tmp2068 = 4
	  li $t2, 4		# load constant value 4 into $t2
	  sw $t2, -3640($fp)	# spill _tmp2068 from $t2 to $fp-3640
	# _tmp2069 = _tmp2059 * _tmp2068
	  lw $t0, -3604($fp)	# fill _tmp2059 to $t0 from $fp-3604
	  lw $t1, -3640($fp)	# fill _tmp2068 to $t1 from $fp-3640
	  mul $t2, $t0, $t1	
	  sw $t2, -3644($fp)	# spill _tmp2069 from $t2 to $fp-3644
	# _tmp2070 = _tmp2069 + _tmp2068
	  lw $t0, -3644($fp)	# fill _tmp2069 to $t0 from $fp-3644
	  lw $t1, -3640($fp)	# fill _tmp2068 to $t1 from $fp-3640
	  add $t2, $t0, $t1	
	  sw $t2, -3648($fp)	# spill _tmp2070 from $t2 to $fp-3648
	# _tmp2071 = _tmp2058 + _tmp2070
	  lw $t0, -3600($fp)	# fill _tmp2058 to $t0 from $fp-3600
	  lw $t1, -3648($fp)	# fill _tmp2070 to $t1 from $fp-3648
	  add $t2, $t0, $t1	
	  sw $t2, -3652($fp)	# spill _tmp2071 from $t2 to $fp-3652
	# _tmp2072 = *(_tmp2071)
	  lw $t0, -3652($fp)	# fill _tmp2071 to $t0 from $fp-3652
	  lw $t2, 0($t0) 	# load with offset
	  sw $t2, -3656($fp)	# spill _tmp2072 from $t2 to $fp-3656
	# _tmp2073 = 2
	  li $t2, 2		# load constant value 2 into $t2
	  sw $t2, -3660($fp)	# spill _tmp2073 from $t2 to $fp-3660
	# _tmp2074 = 0
	  li $t2, 0		# load constant value 0 into $t2
	  sw $t2, -3664($fp)	# spill _tmp2074 from $t2 to $fp-3664
	# _tmp2075 = *(_tmp2072)
	  lw $t0, -3656($fp)	# fill _tmp2072 to $t0 from $fp-3656
	  lw $t2, 0($t0) 	# load with offset
	  sw $t2, -3668($fp)	# spill _tmp2075 from $t2 to $fp-3668
	# _tmp2076 = _tmp2073 < _tmp2074
	  lw $t0, -3660($fp)	# fill _tmp2073 to $t0 from $fp-3660
	  lw $t1, -3664($fp)	# fill _tmp2074 to $t1 from $fp-3664
	  slt $t2, $t0, $t1	
	  sw $t2, -3672($fp)	# spill _tmp2076 from $t2 to $fp-3672
	# _tmp2077 = _tmp2075 < _tmp2073
	  lw $t0, -3668($fp)	# fill _tmp2075 to $t0 from $fp-3668
	  lw $t1, -3660($fp)	# fill _tmp2073 to $t1 from $fp-3660
	  slt $t2, $t0, $t1	
	  sw $t2, -3676($fp)	# spill _tmp2077 from $t2 to $fp-3676
	# _tmp2078 = _tmp2075 == _tmp2073
	  lw $t0, -3668($fp)	# fill _tmp2075 to $t0 from $fp-3668
	  lw $t1, -3660($fp)	# fill _tmp2073 to $t1 from $fp-3660
	  seq $t2, $t0, $t1	
	  sw $t2, -3680($fp)	# spill _tmp2078 from $t2 to $fp-3680
	# _tmp2079 = _tmp2077 || _tmp2078
	  lw $t0, -3676($fp)	# fill _tmp2077 to $t0 from $fp-3676
	  lw $t1, -3680($fp)	# fill _tmp2078 to $t1 from $fp-3680
	  or $t2, $t0, $t1	
	  sw $t2, -3684($fp)	# spill _tmp2079 from $t2 to $fp-3684
	# _tmp2080 = _tmp2079 || _tmp2076
	  lw $t0, -3684($fp)	# fill _tmp2079 to $t0 from $fp-3684
	  lw $t1, -3672($fp)	# fill _tmp2076 to $t1 from $fp-3672
	  or $t2, $t0, $t1	
	  sw $t2, -3688($fp)	# spill _tmp2080 from $t2 to $fp-3688
	# IfZ _tmp2080 Goto _L202
	  lw $t0, -3688($fp)	# fill _tmp2080 to $t0 from $fp-3688
	  beqz $t0, _L202	# branch if _tmp2080 is zero 
	# _tmp2081 = "Decaf runtime error: Array subscript out of bound..."
	  .data			# create string constant marked with label
	  _string132: .asciiz "Decaf runtime error: Array subscript out of bounds\n"
	  .text
	  la $t2, _string132	# load label
	  sw $t2, -3692($fp)	# spill _tmp2081 from $t2 to $fp-3692
	# PushParam _tmp2081
	  subu $sp, $sp, 4	# decrement sp to make space for param
	  lw $t0, -3692($fp)	# fill _tmp2081 to $t0 from $fp-3692
	  sw $t0, 4($sp)	# copy param value to stack
	# LCall _PrintString
	  jal _PrintString   	# jump to function
	# PopParams 4
	  add $sp, $sp, 4	# pop params off stack
	# LCall _Halt
	  jal _Halt          	# jump to function
  _L202:
	# _tmp2082 = 4
	  li $t2, 4		# load constant value 4 into $t2
	  sw $t2, -3696($fp)	# spill _tmp2082 from $t2 to $fp-3696
	# _tmp2083 = _tmp2073 * _tmp2082
	  lw $t0, -3660($fp)	# fill _tmp2073 to $t0 from $fp-3660
	  lw $t1, -3696($fp)	# fill _tmp2082 to $t1 from $fp-3696
	  mul $t2, $t0, $t1	
	  sw $t2, -3700($fp)	# spill _tmp2083 from $t2 to $fp-3700
	# _tmp2084 = _tmp2083 + _tmp2082
	  lw $t0, -3700($fp)	# fill _tmp2083 to $t0 from $fp-3700
	  lw $t1, -3696($fp)	# fill _tmp2082 to $t1 from $fp-3696
	  add $t2, $t0, $t1	
	  sw $t2, -3704($fp)	# spill _tmp2084 from $t2 to $fp-3704
	# _tmp2085 = _tmp2072 + _tmp2084
	  lw $t0, -3656($fp)	# fill _tmp2072 to $t0 from $fp-3656
	  lw $t1, -3704($fp)	# fill _tmp2084 to $t1 from $fp-3704
	  add $t2, $t0, $t1	
	  sw $t2, -3708($fp)	# spill _tmp2085 from $t2 to $fp-3708
	# _tmp2086 = *(_tmp2085)
	  lw $t0, -3708($fp)	# fill _tmp2085 to $t0 from $fp-3708
	  lw $t2, 0($t0) 	# load with offset
	  sw $t2, -3712($fp)	# spill _tmp2086 from $t2 to $fp-3712
	# PushParam _tmp2086
	  subu $sp, $sp, 4	# decrement sp to make space for param
	  lw $t0, -3712($fp)	# fill _tmp2086 to $t0 from $fp-3712
	  sw $t0, 4($sp)	# copy param value to stack
	# _tmp2087 = *(_tmp2086)
	  lw $t0, -3712($fp)	# fill _tmp2086 to $t0 from $fp-3712
	  lw $t2, 0($t0) 	# load with offset
	  sw $t2, -3716($fp)	# spill _tmp2087 from $t2 to $fp-3716
	# _tmp2088 = *(_tmp2087 + 20)
	  lw $t0, -3716($fp)	# fill _tmp2087 to $t0 from $fp-3716
	  lw $t2, 20($t0) 	# load with offset
	  sw $t2, -3720($fp)	# spill _tmp2088 from $t2 to $fp-3720
	# _tmp2089 = ACall _tmp2088
	  lw $t0, -3720($fp)	# fill _tmp2088 to $t0 from $fp-3720
	  jalr $t0            	# jump to function
	  move $t2, $v0		# copy function return value from $v0
	  sw $t2, -3724($fp)	# spill _tmp2089 from $t2 to $fp-3724
	# PopParams 8
	  add $sp, $sp, 8	# pop params off stack
	# IfZ _tmp2089 Goto _L200
	  lw $t0, -3724($fp)	# fill _tmp2089 to $t0 from $fp-3724
	  beqz $t0, _L200	# branch if _tmp2089 is zero 
	# _tmp2090 = 0
	  li $t2, 0		# load constant value 0 into $t2
	  sw $t2, -3728($fp)	# spill _tmp2090 from $t2 to $fp-3728
	# _tmp2057 = _tmp2090
	  lw $t2, -3728($fp)	# fill _tmp2090 to $t2 from $fp-3728
	  sw $t2, -3596($fp)	# spill _tmp2057 from $t2 to $fp-3596
	# Goto _L199
	  b _L199		# unconditional branch
  _L200:
	# _tmp2091 = 1
	  li $t2, 1		# load constant value 1 into $t2
	  sw $t2, -3732($fp)	# spill _tmp2091 from $t2 to $fp-3732
	# _tmp2057 = _tmp2091
	  lw $t2, -3732($fp)	# fill _tmp2091 to $t2 from $fp-3732
	  sw $t2, -3596($fp)	# spill _tmp2057 from $t2 to $fp-3596
  _L199:
	# _tmp2092 = _tmp2056 && _tmp2057
	  lw $t0, -3592($fp)	# fill _tmp2056 to $t0 from $fp-3592
	  lw $t1, -3596($fp)	# fill _tmp2057 to $t1 from $fp-3596
	  and $t2, $t0, $t1	
	  sw $t2, -3736($fp)	# spill _tmp2092 from $t2 to $fp-3736
	# IfZ _tmp2092 Goto _L193
	  lw $t0, -3736($fp)	# fill _tmp2092 to $t0 from $fp-3736
	  beqz $t0, _L193	# branch if _tmp2092 is zero 
	# _tmp2093 = 2
	  li $t2, 2		# load constant value 2 into $t2
	  sw $t2, -3740($fp)	# spill _tmp2093 from $t2 to $fp-3740
	# row = _tmp2093
	  lw $t2, -3740($fp)	# fill _tmp2093 to $t2 from $fp-3740
	  sw $t2, -8($fp)	# spill row from $t2 to $fp-8
	# _tmp2094 = 2
	  li $t2, 2		# load constant value 2 into $t2
	  sw $t2, -3744($fp)	# spill _tmp2094 from $t2 to $fp-3744
	# column = _tmp2094
	  lw $t2, -3744($fp)	# fill _tmp2094 to $t2 from $fp-3744
	  sw $t2, -12($fp)	# spill column from $t2 to $fp-12
	# Goto _L194
	  b _L194		# unconditional branch
  _L193:
	# PushParam enemyMark
	  subu $sp, $sp, 4	# decrement sp to make space for param
	  lw $t0, 8($fp)	# fill enemyMark to $t0 from $fp+8
	  sw $t0, 4($sp)	# copy param value to stack
	# _tmp2095 = *(this + 4)
	  lw $t0, 4($fp)	# fill this to $t0 from $fp+4
	  lw $t2, 4($t0) 	# load with offset
	  sw $t2, -3748($fp)	# spill _tmp2095 from $t2 to $fp-3748
	# _tmp2096 = 2
	  li $t2, 2		# load constant value 2 into $t2
	  sw $t2, -3752($fp)	# spill _tmp2096 from $t2 to $fp-3752
	# _tmp2097 = 0
	  li $t2, 0		# load constant value 0 into $t2
	  sw $t2, -3756($fp)	# spill _tmp2097 from $t2 to $fp-3756
	# _tmp2098 = *(_tmp2095)
	  lw $t0, -3748($fp)	# fill _tmp2095 to $t0 from $fp-3748
	  lw $t2, 0($t0) 	# load with offset
	  sw $t2, -3760($fp)	# spill _tmp2098 from $t2 to $fp-3760
	# _tmp2099 = _tmp2096 < _tmp2097
	  lw $t0, -3752($fp)	# fill _tmp2096 to $t0 from $fp-3752
	  lw $t1, -3756($fp)	# fill _tmp2097 to $t1 from $fp-3756
	  slt $t2, $t0, $t1	
	  sw $t2, -3764($fp)	# spill _tmp2099 from $t2 to $fp-3764
	# _tmp2100 = _tmp2098 < _tmp2096
	  lw $t0, -3760($fp)	# fill _tmp2098 to $t0 from $fp-3760
	  lw $t1, -3752($fp)	# fill _tmp2096 to $t1 from $fp-3752
	  slt $t2, $t0, $t1	
	  sw $t2, -3768($fp)	# spill _tmp2100 from $t2 to $fp-3768
	# _tmp2101 = _tmp2098 == _tmp2096
	  lw $t0, -3760($fp)	# fill _tmp2098 to $t0 from $fp-3760
	  lw $t1, -3752($fp)	# fill _tmp2096 to $t1 from $fp-3752
	  seq $t2, $t0, $t1	
	  sw $t2, -3772($fp)	# spill _tmp2101 from $t2 to $fp-3772
	# _tmp2102 = _tmp2100 || _tmp2101
	  lw $t0, -3768($fp)	# fill _tmp2100 to $t0 from $fp-3768
	  lw $t1, -3772($fp)	# fill _tmp2101 to $t1 from $fp-3772
	  or $t2, $t0, $t1	
	  sw $t2, -3776($fp)	# spill _tmp2102 from $t2 to $fp-3776
	# _tmp2103 = _tmp2102 || _tmp2099
	  lw $t0, -3776($fp)	# fill _tmp2102 to $t0 from $fp-3776
	  lw $t1, -3764($fp)	# fill _tmp2099 to $t1 from $fp-3764
	  or $t2, $t0, $t1	
	  sw $t2, -3780($fp)	# spill _tmp2103 from $t2 to $fp-3780
	# IfZ _tmp2103 Goto _L205
	  lw $t0, -3780($fp)	# fill _tmp2103 to $t0 from $fp-3780
	  beqz $t0, _L205	# branch if _tmp2103 is zero 
	# _tmp2104 = "Decaf runtime error: Array subscript out of bound..."
	  .data			# create string constant marked with label
	  _string133: .asciiz "Decaf runtime error: Array subscript out of bounds\n"
	  .text
	  la $t2, _string133	# load label
	  sw $t2, -3784($fp)	# spill _tmp2104 from $t2 to $fp-3784
	# PushParam _tmp2104
	  subu $sp, $sp, 4	# decrement sp to make space for param
	  lw $t0, -3784($fp)	# fill _tmp2104 to $t0 from $fp-3784
	  sw $t0, 4($sp)	# copy param value to stack
	# LCall _PrintString
	  jal _PrintString   	# jump to function
	# PopParams 4
	  add $sp, $sp, 4	# pop params off stack
	# LCall _Halt
	  jal _Halt          	# jump to function
  _L205:
	# _tmp2105 = 4
	  li $t2, 4		# load constant value 4 into $t2
	  sw $t2, -3788($fp)	# spill _tmp2105 from $t2 to $fp-3788
	# _tmp2106 = _tmp2096 * _tmp2105
	  lw $t0, -3752($fp)	# fill _tmp2096 to $t0 from $fp-3752
	  lw $t1, -3788($fp)	# fill _tmp2105 to $t1 from $fp-3788
	  mul $t2, $t0, $t1	
	  sw $t2, -3792($fp)	# spill _tmp2106 from $t2 to $fp-3792
	# _tmp2107 = _tmp2106 + _tmp2105
	  lw $t0, -3792($fp)	# fill _tmp2106 to $t0 from $fp-3792
	  lw $t1, -3788($fp)	# fill _tmp2105 to $t1 from $fp-3788
	  add $t2, $t0, $t1	
	  sw $t2, -3796($fp)	# spill _tmp2107 from $t2 to $fp-3796
	# _tmp2108 = _tmp2095 + _tmp2107
	  lw $t0, -3748($fp)	# fill _tmp2095 to $t0 from $fp-3748
	  lw $t1, -3796($fp)	# fill _tmp2107 to $t1 from $fp-3796
	  add $t2, $t0, $t1	
	  sw $t2, -3800($fp)	# spill _tmp2108 from $t2 to $fp-3800
	# _tmp2109 = *(_tmp2108)
	  lw $t0, -3800($fp)	# fill _tmp2108 to $t0 from $fp-3800
	  lw $t2, 0($t0) 	# load with offset
	  sw $t2, -3804($fp)	# spill _tmp2109 from $t2 to $fp-3804
	# _tmp2110 = 0
	  li $t2, 0		# load constant value 0 into $t2
	  sw $t2, -3808($fp)	# spill _tmp2110 from $t2 to $fp-3808
	# _tmp2111 = 0
	  li $t2, 0		# load constant value 0 into $t2
	  sw $t2, -3812($fp)	# spill _tmp2111 from $t2 to $fp-3812
	# _tmp2112 = *(_tmp2109)
	  lw $t0, -3804($fp)	# fill _tmp2109 to $t0 from $fp-3804
	  lw $t2, 0($t0) 	# load with offset
	  sw $t2, -3816($fp)	# spill _tmp2112 from $t2 to $fp-3816
	# _tmp2113 = _tmp2110 < _tmp2111
	  lw $t0, -3808($fp)	# fill _tmp2110 to $t0 from $fp-3808
	  lw $t1, -3812($fp)	# fill _tmp2111 to $t1 from $fp-3812
	  slt $t2, $t0, $t1	
	  sw $t2, -3820($fp)	# spill _tmp2113 from $t2 to $fp-3820
	# _tmp2114 = _tmp2112 < _tmp2110
	  lw $t0, -3816($fp)	# fill _tmp2112 to $t0 from $fp-3816
	  lw $t1, -3808($fp)	# fill _tmp2110 to $t1 from $fp-3808
	  slt $t2, $t0, $t1	
	  sw $t2, -3824($fp)	# spill _tmp2114 from $t2 to $fp-3824
	# _tmp2115 = _tmp2112 == _tmp2110
	  lw $t0, -3816($fp)	# fill _tmp2112 to $t0 from $fp-3816
	  lw $t1, -3808($fp)	# fill _tmp2110 to $t1 from $fp-3808
	  seq $t2, $t0, $t1	
	  sw $t2, -3828($fp)	# spill _tmp2115 from $t2 to $fp-3828
	# _tmp2116 = _tmp2114 || _tmp2115
	  lw $t0, -3824($fp)	# fill _tmp2114 to $t0 from $fp-3824
	  lw $t1, -3828($fp)	# fill _tmp2115 to $t1 from $fp-3828
	  or $t2, $t0, $t1	
	  sw $t2, -3832($fp)	# spill _tmp2116 from $t2 to $fp-3832
	# _tmp2117 = _tmp2116 || _tmp2113
	  lw $t0, -3832($fp)	# fill _tmp2116 to $t0 from $fp-3832
	  lw $t1, -3820($fp)	# fill _tmp2113 to $t1 from $fp-3820
	  or $t2, $t0, $t1	
	  sw $t2, -3836($fp)	# spill _tmp2117 from $t2 to $fp-3836
	# IfZ _tmp2117 Goto _L206
	  lw $t0, -3836($fp)	# fill _tmp2117 to $t0 from $fp-3836
	  beqz $t0, _L206	# branch if _tmp2117 is zero 
	# _tmp2118 = "Decaf runtime error: Array subscript out of bound..."
	  .data			# create string constant marked with label
	  _string134: .asciiz "Decaf runtime error: Array subscript out of bounds\n"
	  .text
	  la $t2, _string134	# load label
	  sw $t2, -3840($fp)	# spill _tmp2118 from $t2 to $fp-3840
	# PushParam _tmp2118
	  subu $sp, $sp, 4	# decrement sp to make space for param
	  lw $t0, -3840($fp)	# fill _tmp2118 to $t0 from $fp-3840
	  sw $t0, 4($sp)	# copy param value to stack
	# LCall _PrintString
	  jal _PrintString   	# jump to function
	# PopParams 4
	  add $sp, $sp, 4	# pop params off stack
	# LCall _Halt
	  jal _Halt          	# jump to function
  _L206:
	# _tmp2119 = 4
	  li $t2, 4		# load constant value 4 into $t2
	  sw $t2, -3844($fp)	# spill _tmp2119 from $t2 to $fp-3844
	# _tmp2120 = _tmp2110 * _tmp2119
	  lw $t0, -3808($fp)	# fill _tmp2110 to $t0 from $fp-3808
	  lw $t1, -3844($fp)	# fill _tmp2119 to $t1 from $fp-3844
	  mul $t2, $t0, $t1	
	  sw $t2, -3848($fp)	# spill _tmp2120 from $t2 to $fp-3848
	# _tmp2121 = _tmp2120 + _tmp2119
	  lw $t0, -3848($fp)	# fill _tmp2120 to $t0 from $fp-3848
	  lw $t1, -3844($fp)	# fill _tmp2119 to $t1 from $fp-3844
	  add $t2, $t0, $t1	
	  sw $t2, -3852($fp)	# spill _tmp2121 from $t2 to $fp-3852
	# _tmp2122 = _tmp2109 + _tmp2121
	  lw $t0, -3804($fp)	# fill _tmp2109 to $t0 from $fp-3804
	  lw $t1, -3852($fp)	# fill _tmp2121 to $t1 from $fp-3852
	  add $t2, $t0, $t1	
	  sw $t2, -3856($fp)	# spill _tmp2122 from $t2 to $fp-3856
	# _tmp2123 = *(_tmp2122)
	  lw $t0, -3856($fp)	# fill _tmp2122 to $t0 from $fp-3856
	  lw $t2, 0($t0) 	# load with offset
	  sw $t2, -3860($fp)	# spill _tmp2123 from $t2 to $fp-3860
	# PushParam _tmp2123
	  subu $sp, $sp, 4	# decrement sp to make space for param
	  lw $t0, -3860($fp)	# fill _tmp2123 to $t0 from $fp-3860
	  sw $t0, 4($sp)	# copy param value to stack
	# _tmp2124 = *(_tmp2123)
	  lw $t0, -3860($fp)	# fill _tmp2123 to $t0 from $fp-3860
	  lw $t2, 0($t0) 	# load with offset
	  sw $t2, -3864($fp)	# spill _tmp2124 from $t2 to $fp-3864
	# _tmp2125 = *(_tmp2124 + 20)
	  lw $t0, -3864($fp)	# fill _tmp2124 to $t0 from $fp-3864
	  lw $t2, 20($t0) 	# load with offset
	  sw $t2, -3868($fp)	# spill _tmp2125 from $t2 to $fp-3868
	# _tmp2126 = ACall _tmp2125
	  lw $t0, -3868($fp)	# fill _tmp2125 to $t0 from $fp-3868
	  jalr $t0            	# jump to function
	  move $t2, $v0		# copy function return value from $v0
	  sw $t2, -3872($fp)	# spill _tmp2126 from $t2 to $fp-3872
	# PopParams 8
	  add $sp, $sp, 8	# pop params off stack
	# PushParam enemyMark
	  subu $sp, $sp, 4	# decrement sp to make space for param
	  lw $t0, 8($fp)	# fill enemyMark to $t0 from $fp+8
	  sw $t0, 4($sp)	# copy param value to stack
	# _tmp2127 = *(this + 4)
	  lw $t0, 4($fp)	# fill this to $t0 from $fp+4
	  lw $t2, 4($t0) 	# load with offset
	  sw $t2, -3876($fp)	# spill _tmp2127 from $t2 to $fp-3876
	# _tmp2128 = 1
	  li $t2, 1		# load constant value 1 into $t2
	  sw $t2, -3880($fp)	# spill _tmp2128 from $t2 to $fp-3880
	# _tmp2129 = 0
	  li $t2, 0		# load constant value 0 into $t2
	  sw $t2, -3884($fp)	# spill _tmp2129 from $t2 to $fp-3884
	# _tmp2130 = *(_tmp2127)
	  lw $t0, -3876($fp)	# fill _tmp2127 to $t0 from $fp-3876
	  lw $t2, 0($t0) 	# load with offset
	  sw $t2, -3888($fp)	# spill _tmp2130 from $t2 to $fp-3888
	# _tmp2131 = _tmp2128 < _tmp2129
	  lw $t0, -3880($fp)	# fill _tmp2128 to $t0 from $fp-3880
	  lw $t1, -3884($fp)	# fill _tmp2129 to $t1 from $fp-3884
	  slt $t2, $t0, $t1	
	  sw $t2, -3892($fp)	# spill _tmp2131 from $t2 to $fp-3892
	# _tmp2132 = _tmp2130 < _tmp2128
	  lw $t0, -3888($fp)	# fill _tmp2130 to $t0 from $fp-3888
	  lw $t1, -3880($fp)	# fill _tmp2128 to $t1 from $fp-3880
	  slt $t2, $t0, $t1	
	  sw $t2, -3896($fp)	# spill _tmp2132 from $t2 to $fp-3896
	# _tmp2133 = _tmp2130 == _tmp2128
	  lw $t0, -3888($fp)	# fill _tmp2130 to $t0 from $fp-3888
	  lw $t1, -3880($fp)	# fill _tmp2128 to $t1 from $fp-3880
	  seq $t2, $t0, $t1	
	  sw $t2, -3900($fp)	# spill _tmp2133 from $t2 to $fp-3900
	# _tmp2134 = _tmp2132 || _tmp2133
	  lw $t0, -3896($fp)	# fill _tmp2132 to $t0 from $fp-3896
	  lw $t1, -3900($fp)	# fill _tmp2133 to $t1 from $fp-3900
	  or $t2, $t0, $t1	
	  sw $t2, -3904($fp)	# spill _tmp2134 from $t2 to $fp-3904
	# _tmp2135 = _tmp2134 || _tmp2131
	  lw $t0, -3904($fp)	# fill _tmp2134 to $t0 from $fp-3904
	  lw $t1, -3892($fp)	# fill _tmp2131 to $t1 from $fp-3892
	  or $t2, $t0, $t1	
	  sw $t2, -3908($fp)	# spill _tmp2135 from $t2 to $fp-3908
	# IfZ _tmp2135 Goto _L207
	  lw $t0, -3908($fp)	# fill _tmp2135 to $t0 from $fp-3908
	  beqz $t0, _L207	# branch if _tmp2135 is zero 
	# _tmp2136 = "Decaf runtime error: Array subscript out of bound..."
	  .data			# create string constant marked with label
	  _string135: .asciiz "Decaf runtime error: Array subscript out of bounds\n"
	  .text
	  la $t2, _string135	# load label
	  sw $t2, -3912($fp)	# spill _tmp2136 from $t2 to $fp-3912
	# PushParam _tmp2136
	  subu $sp, $sp, 4	# decrement sp to make space for param
	  lw $t0, -3912($fp)	# fill _tmp2136 to $t0 from $fp-3912
	  sw $t0, 4($sp)	# copy param value to stack
	# LCall _PrintString
	  jal _PrintString   	# jump to function
	# PopParams 4
	  add $sp, $sp, 4	# pop params off stack
	# LCall _Halt
	  jal _Halt          	# jump to function
  _L207:
	# _tmp2137 = 4
	  li $t2, 4		# load constant value 4 into $t2
	  sw $t2, -3916($fp)	# spill _tmp2137 from $t2 to $fp-3916
	# _tmp2138 = _tmp2128 * _tmp2137
	  lw $t0, -3880($fp)	# fill _tmp2128 to $t0 from $fp-3880
	  lw $t1, -3916($fp)	# fill _tmp2137 to $t1 from $fp-3916
	  mul $t2, $t0, $t1	
	  sw $t2, -3920($fp)	# spill _tmp2138 from $t2 to $fp-3920
	# _tmp2139 = _tmp2138 + _tmp2137
	  lw $t0, -3920($fp)	# fill _tmp2138 to $t0 from $fp-3920
	  lw $t1, -3916($fp)	# fill _tmp2137 to $t1 from $fp-3916
	  add $t2, $t0, $t1	
	  sw $t2, -3924($fp)	# spill _tmp2139 from $t2 to $fp-3924
	# _tmp2140 = _tmp2127 + _tmp2139
	  lw $t0, -3876($fp)	# fill _tmp2127 to $t0 from $fp-3876
	  lw $t1, -3924($fp)	# fill _tmp2139 to $t1 from $fp-3924
	  add $t2, $t0, $t1	
	  sw $t2, -3928($fp)	# spill _tmp2140 from $t2 to $fp-3928
	# _tmp2141 = *(_tmp2140)
	  lw $t0, -3928($fp)	# fill _tmp2140 to $t0 from $fp-3928
	  lw $t2, 0($t0) 	# load with offset
	  sw $t2, -3932($fp)	# spill _tmp2141 from $t2 to $fp-3932
	# _tmp2142 = 0
	  li $t2, 0		# load constant value 0 into $t2
	  sw $t2, -3936($fp)	# spill _tmp2142 from $t2 to $fp-3936
	# _tmp2143 = 0
	  li $t2, 0		# load constant value 0 into $t2
	  sw $t2, -3940($fp)	# spill _tmp2143 from $t2 to $fp-3940
	# _tmp2144 = *(_tmp2141)
	  lw $t0, -3932($fp)	# fill _tmp2141 to $t0 from $fp-3932
	  lw $t2, 0($t0) 	# load with offset
	  sw $t2, -3944($fp)	# spill _tmp2144 from $t2 to $fp-3944
	# _tmp2145 = _tmp2142 < _tmp2143
	  lw $t0, -3936($fp)	# fill _tmp2142 to $t0 from $fp-3936
	  lw $t1, -3940($fp)	# fill _tmp2143 to $t1 from $fp-3940
	  slt $t2, $t0, $t1	
	  sw $t2, -3948($fp)	# spill _tmp2145 from $t2 to $fp-3948
	# _tmp2146 = _tmp2144 < _tmp2142
	  lw $t0, -3944($fp)	# fill _tmp2144 to $t0 from $fp-3944
	  lw $t1, -3936($fp)	# fill _tmp2142 to $t1 from $fp-3936
	  slt $t2, $t0, $t1	
	  sw $t2, -3952($fp)	# spill _tmp2146 from $t2 to $fp-3952
	# _tmp2147 = _tmp2144 == _tmp2142
	  lw $t0, -3944($fp)	# fill _tmp2144 to $t0 from $fp-3944
	  lw $t1, -3936($fp)	# fill _tmp2142 to $t1 from $fp-3936
	  seq $t2, $t0, $t1	
	  sw $t2, -3956($fp)	# spill _tmp2147 from $t2 to $fp-3956
	# _tmp2148 = _tmp2146 || _tmp2147
	  lw $t0, -3952($fp)	# fill _tmp2146 to $t0 from $fp-3952
	  lw $t1, -3956($fp)	# fill _tmp2147 to $t1 from $fp-3956
	  or $t2, $t0, $t1	
	  sw $t2, -3960($fp)	# spill _tmp2148 from $t2 to $fp-3960
	# _tmp2149 = _tmp2148 || _tmp2145
	  lw $t0, -3960($fp)	# fill _tmp2148 to $t0 from $fp-3960
	  lw $t1, -3948($fp)	# fill _tmp2145 to $t1 from $fp-3948
	  or $t2, $t0, $t1	
	  sw $t2, -3964($fp)	# spill _tmp2149 from $t2 to $fp-3964
	# IfZ _tmp2149 Goto _L208
	  lw $t0, -3964($fp)	# fill _tmp2149 to $t0 from $fp-3964
	  beqz $t0, _L208	# branch if _tmp2149 is zero 
	# _tmp2150 = "Decaf runtime error: Array subscript out of bound..."
	  .data			# create string constant marked with label
	  _string136: .asciiz "Decaf runtime error: Array subscript out of bounds\n"
	  .text
	  la $t2, _string136	# load label
	  sw $t2, -3968($fp)	# spill _tmp2150 from $t2 to $fp-3968
	# PushParam _tmp2150
	  subu $sp, $sp, 4	# decrement sp to make space for param
	  lw $t0, -3968($fp)	# fill _tmp2150 to $t0 from $fp-3968
	  sw $t0, 4($sp)	# copy param value to stack
	# LCall _PrintString
	  jal _PrintString   	# jump to function
	# PopParams 4
	  add $sp, $sp, 4	# pop params off stack
	# LCall _Halt
	  jal _Halt          	# jump to function
  _L208:
	# _tmp2151 = 4
	  li $t2, 4		# load constant value 4 into $t2
	  sw $t2, -3972($fp)	# spill _tmp2151 from $t2 to $fp-3972
	# _tmp2152 = _tmp2142 * _tmp2151
	  lw $t0, -3936($fp)	# fill _tmp2142 to $t0 from $fp-3936
	  lw $t1, -3972($fp)	# fill _tmp2151 to $t1 from $fp-3972
	  mul $t2, $t0, $t1	
	  sw $t2, -3976($fp)	# spill _tmp2152 from $t2 to $fp-3976
	# _tmp2153 = _tmp2152 + _tmp2151
	  lw $t0, -3976($fp)	# fill _tmp2152 to $t0 from $fp-3976
	  lw $t1, -3972($fp)	# fill _tmp2151 to $t1 from $fp-3972
	  add $t2, $t0, $t1	
	  sw $t2, -3980($fp)	# spill _tmp2153 from $t2 to $fp-3980
	# _tmp2154 = _tmp2141 + _tmp2153
	  lw $t0, -3932($fp)	# fill _tmp2141 to $t0 from $fp-3932
	  lw $t1, -3980($fp)	# fill _tmp2153 to $t1 from $fp-3980
	  add $t2, $t0, $t1	
	  sw $t2, -3984($fp)	# spill _tmp2154 from $t2 to $fp-3984
	# _tmp2155 = *(_tmp2154)
	  lw $t0, -3984($fp)	# fill _tmp2154 to $t0 from $fp-3984
	  lw $t2, 0($t0) 	# load with offset
	  sw $t2, -3988($fp)	# spill _tmp2155 from $t2 to $fp-3988
	# PushParam _tmp2155
	  subu $sp, $sp, 4	# decrement sp to make space for param
	  lw $t0, -3988($fp)	# fill _tmp2155 to $t0 from $fp-3988
	  sw $t0, 4($sp)	# copy param value to stack
	# _tmp2156 = *(_tmp2155)
	  lw $t0, -3988($fp)	# fill _tmp2155 to $t0 from $fp-3988
	  lw $t2, 0($t0) 	# load with offset
	  sw $t2, -3992($fp)	# spill _tmp2156 from $t2 to $fp-3992
	# _tmp2157 = *(_tmp2156 + 20)
	  lw $t0, -3992($fp)	# fill _tmp2156 to $t0 from $fp-3992
	  lw $t2, 20($t0) 	# load with offset
	  sw $t2, -3996($fp)	# spill _tmp2157 from $t2 to $fp-3996
	# _tmp2158 = ACall _tmp2157
	  lw $t0, -3996($fp)	# fill _tmp2157 to $t0 from $fp-3996
	  jalr $t0            	# jump to function
	  move $t2, $v0		# copy function return value from $v0
	  sw $t2, -4000($fp)	# spill _tmp2158 from $t2 to $fp-4000
	# PopParams 8
	  add $sp, $sp, 8	# pop params off stack
	# _tmp2159 = _tmp2126 && _tmp2158
	  lw $t0, -3872($fp)	# fill _tmp2126 to $t0 from $fp-3872
	  lw $t1, -4000($fp)	# fill _tmp2158 to $t1 from $fp-4000
	  and $t2, $t0, $t1	
	  sw $t2, -4004($fp)	# spill _tmp2159 from $t2 to $fp-4004
	# PushParam playerMark
	  subu $sp, $sp, 4	# decrement sp to make space for param
	  lw $t0, 12($fp)	# fill playerMark to $t0 from $fp+12
	  sw $t0, 4($sp)	# copy param value to stack
	# _tmp2161 = *(this + 4)
	  lw $t0, 4($fp)	# fill this to $t0 from $fp+4
	  lw $t2, 4($t0) 	# load with offset
	  sw $t2, -4012($fp)	# spill _tmp2161 from $t2 to $fp-4012
	# _tmp2162 = 0
	  li $t2, 0		# load constant value 0 into $t2
	  sw $t2, -4016($fp)	# spill _tmp2162 from $t2 to $fp-4016
	# _tmp2163 = 0
	  li $t2, 0		# load constant value 0 into $t2
	  sw $t2, -4020($fp)	# spill _tmp2163 from $t2 to $fp-4020
	# _tmp2164 = *(_tmp2161)
	  lw $t0, -4012($fp)	# fill _tmp2161 to $t0 from $fp-4012
	  lw $t2, 0($t0) 	# load with offset
	  sw $t2, -4024($fp)	# spill _tmp2164 from $t2 to $fp-4024
	# _tmp2165 = _tmp2162 < _tmp2163
	  lw $t0, -4016($fp)	# fill _tmp2162 to $t0 from $fp-4016
	  lw $t1, -4020($fp)	# fill _tmp2163 to $t1 from $fp-4020
	  slt $t2, $t0, $t1	
	  sw $t2, -4028($fp)	# spill _tmp2165 from $t2 to $fp-4028
	# _tmp2166 = _tmp2164 < _tmp2162
	  lw $t0, -4024($fp)	# fill _tmp2164 to $t0 from $fp-4024
	  lw $t1, -4016($fp)	# fill _tmp2162 to $t1 from $fp-4016
	  slt $t2, $t0, $t1	
	  sw $t2, -4032($fp)	# spill _tmp2166 from $t2 to $fp-4032
	# _tmp2167 = _tmp2164 == _tmp2162
	  lw $t0, -4024($fp)	# fill _tmp2164 to $t0 from $fp-4024
	  lw $t1, -4016($fp)	# fill _tmp2162 to $t1 from $fp-4016
	  seq $t2, $t0, $t1	
	  sw $t2, -4036($fp)	# spill _tmp2167 from $t2 to $fp-4036
	# _tmp2168 = _tmp2166 || _tmp2167
	  lw $t0, -4032($fp)	# fill _tmp2166 to $t0 from $fp-4032
	  lw $t1, -4036($fp)	# fill _tmp2167 to $t1 from $fp-4036
	  or $t2, $t0, $t1	
	  sw $t2, -4040($fp)	# spill _tmp2168 from $t2 to $fp-4040
	# _tmp2169 = _tmp2168 || _tmp2165
	  lw $t0, -4040($fp)	# fill _tmp2168 to $t0 from $fp-4040
	  lw $t1, -4028($fp)	# fill _tmp2165 to $t1 from $fp-4028
	  or $t2, $t0, $t1	
	  sw $t2, -4044($fp)	# spill _tmp2169 from $t2 to $fp-4044
	# IfZ _tmp2169 Goto _L211
	  lw $t0, -4044($fp)	# fill _tmp2169 to $t0 from $fp-4044
	  beqz $t0, _L211	# branch if _tmp2169 is zero 
	# _tmp2170 = "Decaf runtime error: Array subscript out of bound..."
	  .data			# create string constant marked with label
	  _string137: .asciiz "Decaf runtime error: Array subscript out of bounds\n"
	  .text
	  la $t2, _string137	# load label
	  sw $t2, -4048($fp)	# spill _tmp2170 from $t2 to $fp-4048
	# PushParam _tmp2170
	  subu $sp, $sp, 4	# decrement sp to make space for param
	  lw $t0, -4048($fp)	# fill _tmp2170 to $t0 from $fp-4048
	  sw $t0, 4($sp)	# copy param value to stack
	# LCall _PrintString
	  jal _PrintString   	# jump to function
	# PopParams 4
	  add $sp, $sp, 4	# pop params off stack
	# LCall _Halt
	  jal _Halt          	# jump to function
  _L211:
	# _tmp2171 = 4
	  li $t2, 4		# load constant value 4 into $t2
	  sw $t2, -4052($fp)	# spill _tmp2171 from $t2 to $fp-4052
	# _tmp2172 = _tmp2162 * _tmp2171
	  lw $t0, -4016($fp)	# fill _tmp2162 to $t0 from $fp-4016
	  lw $t1, -4052($fp)	# fill _tmp2171 to $t1 from $fp-4052
	  mul $t2, $t0, $t1	
	  sw $t2, -4056($fp)	# spill _tmp2172 from $t2 to $fp-4056
	# _tmp2173 = _tmp2172 + _tmp2171
	  lw $t0, -4056($fp)	# fill _tmp2172 to $t0 from $fp-4056
	  lw $t1, -4052($fp)	# fill _tmp2171 to $t1 from $fp-4052
	  add $t2, $t0, $t1	
	  sw $t2, -4060($fp)	# spill _tmp2173 from $t2 to $fp-4060
	# _tmp2174 = _tmp2161 + _tmp2173
	  lw $t0, -4012($fp)	# fill _tmp2161 to $t0 from $fp-4012
	  lw $t1, -4060($fp)	# fill _tmp2173 to $t1 from $fp-4060
	  add $t2, $t0, $t1	
	  sw $t2, -4064($fp)	# spill _tmp2174 from $t2 to $fp-4064
	# _tmp2175 = *(_tmp2174)
	  lw $t0, -4064($fp)	# fill _tmp2174 to $t0 from $fp-4064
	  lw $t2, 0($t0) 	# load with offset
	  sw $t2, -4068($fp)	# spill _tmp2175 from $t2 to $fp-4068
	# _tmp2176 = 0
	  li $t2, 0		# load constant value 0 into $t2
	  sw $t2, -4072($fp)	# spill _tmp2176 from $t2 to $fp-4072
	# _tmp2177 = 0
	  li $t2, 0		# load constant value 0 into $t2
	  sw $t2, -4076($fp)	# spill _tmp2177 from $t2 to $fp-4076
	# _tmp2178 = *(_tmp2175)
	  lw $t0, -4068($fp)	# fill _tmp2175 to $t0 from $fp-4068
	  lw $t2, 0($t0) 	# load with offset
	  sw $t2, -4080($fp)	# spill _tmp2178 from $t2 to $fp-4080
	# _tmp2179 = _tmp2176 < _tmp2177
	  lw $t0, -4072($fp)	# fill _tmp2176 to $t0 from $fp-4072
	  lw $t1, -4076($fp)	# fill _tmp2177 to $t1 from $fp-4076
	  slt $t2, $t0, $t1	
	  sw $t2, -4084($fp)	# spill _tmp2179 from $t2 to $fp-4084
	# _tmp2180 = _tmp2178 < _tmp2176
	  lw $t0, -4080($fp)	# fill _tmp2178 to $t0 from $fp-4080
	  lw $t1, -4072($fp)	# fill _tmp2176 to $t1 from $fp-4072
	  slt $t2, $t0, $t1	
	  sw $t2, -4088($fp)	# spill _tmp2180 from $t2 to $fp-4088
	# _tmp2181 = _tmp2178 == _tmp2176
	  lw $t0, -4080($fp)	# fill _tmp2178 to $t0 from $fp-4080
	  lw $t1, -4072($fp)	# fill _tmp2176 to $t1 from $fp-4072
	  seq $t2, $t0, $t1	
	  sw $t2, -4092($fp)	# spill _tmp2181 from $t2 to $fp-4092
	# _tmp2182 = _tmp2180 || _tmp2181
	  lw $t0, -4088($fp)	# fill _tmp2180 to $t0 from $fp-4088
	  lw $t1, -4092($fp)	# fill _tmp2181 to $t1 from $fp-4092
	  or $t2, $t0, $t1	
	  sw $t2, -4096($fp)	# spill _tmp2182 from $t2 to $fp-4096
	# _tmp2183 = _tmp2182 || _tmp2179
	  lw $t0, -4096($fp)	# fill _tmp2182 to $t0 from $fp-4096
	  lw $t1, -4084($fp)	# fill _tmp2179 to $t1 from $fp-4084
	  or $t2, $t0, $t1	
	  sw $t2, -4100($fp)	# spill _tmp2183 from $t2 to $fp-4100
	# IfZ _tmp2183 Goto _L212
	  lw $t0, -4100($fp)	# fill _tmp2183 to $t0 from $fp-4100
	  beqz $t0, _L212	# branch if _tmp2183 is zero 
	# _tmp2184 = "Decaf runtime error: Array subscript out of bound..."
	  .data			# create string constant marked with label
	  _string138: .asciiz "Decaf runtime error: Array subscript out of bounds\n"
	  .text
	  la $t2, _string138	# load label
	  sw $t2, -4104($fp)	# spill _tmp2184 from $t2 to $fp-4104
	# PushParam _tmp2184
	  subu $sp, $sp, 4	# decrement sp to make space for param
	  lw $t0, -4104($fp)	# fill _tmp2184 to $t0 from $fp-4104
	  sw $t0, 4($sp)	# copy param value to stack
	# LCall _PrintString
	  jal _PrintString   	# jump to function
	# PopParams 4
	  add $sp, $sp, 4	# pop params off stack
	# LCall _Halt
	  jal _Halt          	# jump to function
  _L212:
	# _tmp2185 = 4
	  li $t2, 4		# load constant value 4 into $t2
	  sw $t2, -4108($fp)	# spill _tmp2185 from $t2 to $fp-4108
	# _tmp2186 = _tmp2176 * _tmp2185
	  lw $t0, -4072($fp)	# fill _tmp2176 to $t0 from $fp-4072
	  lw $t1, -4108($fp)	# fill _tmp2185 to $t1 from $fp-4108
	  mul $t2, $t0, $t1	
	  sw $t2, -4112($fp)	# spill _tmp2186 from $t2 to $fp-4112
	# _tmp2187 = _tmp2186 + _tmp2185
	  lw $t0, -4112($fp)	# fill _tmp2186 to $t0 from $fp-4112
	  lw $t1, -4108($fp)	# fill _tmp2185 to $t1 from $fp-4108
	  add $t2, $t0, $t1	
	  sw $t2, -4116($fp)	# spill _tmp2187 from $t2 to $fp-4116
	# _tmp2188 = _tmp2175 + _tmp2187
	  lw $t0, -4068($fp)	# fill _tmp2175 to $t0 from $fp-4068
	  lw $t1, -4116($fp)	# fill _tmp2187 to $t1 from $fp-4116
	  add $t2, $t0, $t1	
	  sw $t2, -4120($fp)	# spill _tmp2188 from $t2 to $fp-4120
	# _tmp2189 = *(_tmp2188)
	  lw $t0, -4120($fp)	# fill _tmp2188 to $t0 from $fp-4120
	  lw $t2, 0($t0) 	# load with offset
	  sw $t2, -4124($fp)	# spill _tmp2189 from $t2 to $fp-4124
	# PushParam _tmp2189
	  subu $sp, $sp, 4	# decrement sp to make space for param
	  lw $t0, -4124($fp)	# fill _tmp2189 to $t0 from $fp-4124
	  sw $t0, 4($sp)	# copy param value to stack
	# _tmp2190 = *(_tmp2189)
	  lw $t0, -4124($fp)	# fill _tmp2189 to $t0 from $fp-4124
	  lw $t2, 0($t0) 	# load with offset
	  sw $t2, -4128($fp)	# spill _tmp2190 from $t2 to $fp-4128
	# _tmp2191 = *(_tmp2190 + 20)
	  lw $t0, -4128($fp)	# fill _tmp2190 to $t0 from $fp-4128
	  lw $t2, 20($t0) 	# load with offset
	  sw $t2, -4132($fp)	# spill _tmp2191 from $t2 to $fp-4132
	# _tmp2192 = ACall _tmp2191
	  lw $t0, -4132($fp)	# fill _tmp2191 to $t0 from $fp-4132
	  jalr $t0            	# jump to function
	  move $t2, $v0		# copy function return value from $v0
	  sw $t2, -4136($fp)	# spill _tmp2192 from $t2 to $fp-4136
	# PopParams 8
	  add $sp, $sp, 8	# pop params off stack
	# IfZ _tmp2192 Goto _L210
	  lw $t0, -4136($fp)	# fill _tmp2192 to $t0 from $fp-4136
	  beqz $t0, _L210	# branch if _tmp2192 is zero 
	# _tmp2193 = 0
	  li $t2, 0		# load constant value 0 into $t2
	  sw $t2, -4140($fp)	# spill _tmp2193 from $t2 to $fp-4140
	# _tmp2160 = _tmp2193
	  lw $t2, -4140($fp)	# fill _tmp2193 to $t2 from $fp-4140
	  sw $t2, -4008($fp)	# spill _tmp2160 from $t2 to $fp-4008
	# Goto _L209
	  b _L209		# unconditional branch
  _L210:
	# _tmp2194 = 1
	  li $t2, 1		# load constant value 1 into $t2
	  sw $t2, -4144($fp)	# spill _tmp2194 from $t2 to $fp-4144
	# _tmp2160 = _tmp2194
	  lw $t2, -4144($fp)	# fill _tmp2194 to $t2 from $fp-4144
	  sw $t2, -4008($fp)	# spill _tmp2160 from $t2 to $fp-4008
  _L209:
	# _tmp2195 = _tmp2159 && _tmp2160
	  lw $t0, -4004($fp)	# fill _tmp2159 to $t0 from $fp-4004
	  lw $t1, -4008($fp)	# fill _tmp2160 to $t1 from $fp-4008
	  and $t2, $t0, $t1	
	  sw $t2, -4148($fp)	# spill _tmp2195 from $t2 to $fp-4148
	# IfZ _tmp2195 Goto _L203
	  lw $t0, -4148($fp)	# fill _tmp2195 to $t0 from $fp-4148
	  beqz $t0, _L203	# branch if _tmp2195 is zero 
	# _tmp2196 = 0
	  li $t2, 0		# load constant value 0 into $t2
	  sw $t2, -4152($fp)	# spill _tmp2196 from $t2 to $fp-4152
	# row = _tmp2196
	  lw $t2, -4152($fp)	# fill _tmp2196 to $t2 from $fp-4152
	  sw $t2, -8($fp)	# spill row from $t2 to $fp-8
	# _tmp2197 = 0
	  li $t2, 0		# load constant value 0 into $t2
	  sw $t2, -4156($fp)	# spill _tmp2197 from $t2 to $fp-4156
	# column = _tmp2197
	  lw $t2, -4156($fp)	# fill _tmp2197 to $t2 from $fp-4156
	  sw $t2, -12($fp)	# spill column from $t2 to $fp-12
	# Goto _L204
	  b _L204		# unconditional branch
  _L203:
	# PushParam enemyMark
	  subu $sp, $sp, 4	# decrement sp to make space for param
	  lw $t0, 8($fp)	# fill enemyMark to $t0 from $fp+8
	  sw $t0, 4($sp)	# copy param value to stack
	# _tmp2198 = *(this + 4)
	  lw $t0, 4($fp)	# fill this to $t0 from $fp+4
	  lw $t2, 4($t0) 	# load with offset
	  sw $t2, -4160($fp)	# spill _tmp2198 from $t2 to $fp-4160
	# _tmp2199 = 2
	  li $t2, 2		# load constant value 2 into $t2
	  sw $t2, -4164($fp)	# spill _tmp2199 from $t2 to $fp-4164
	# _tmp2200 = 0
	  li $t2, 0		# load constant value 0 into $t2
	  sw $t2, -4168($fp)	# spill _tmp2200 from $t2 to $fp-4168
	# _tmp2201 = *(_tmp2198)
	  lw $t0, -4160($fp)	# fill _tmp2198 to $t0 from $fp-4160
	  lw $t2, 0($t0) 	# load with offset
	  sw $t2, -4172($fp)	# spill _tmp2201 from $t2 to $fp-4172
	# _tmp2202 = _tmp2199 < _tmp2200
	  lw $t0, -4164($fp)	# fill _tmp2199 to $t0 from $fp-4164
	  lw $t1, -4168($fp)	# fill _tmp2200 to $t1 from $fp-4168
	  slt $t2, $t0, $t1	
	  sw $t2, -4176($fp)	# spill _tmp2202 from $t2 to $fp-4176
	# _tmp2203 = _tmp2201 < _tmp2199
	  lw $t0, -4172($fp)	# fill _tmp2201 to $t0 from $fp-4172
	  lw $t1, -4164($fp)	# fill _tmp2199 to $t1 from $fp-4164
	  slt $t2, $t0, $t1	
	  sw $t2, -4180($fp)	# spill _tmp2203 from $t2 to $fp-4180
	# _tmp2204 = _tmp2201 == _tmp2199
	  lw $t0, -4172($fp)	# fill _tmp2201 to $t0 from $fp-4172
	  lw $t1, -4164($fp)	# fill _tmp2199 to $t1 from $fp-4164
	  seq $t2, $t0, $t1	
	  sw $t2, -4184($fp)	# spill _tmp2204 from $t2 to $fp-4184
	# _tmp2205 = _tmp2203 || _tmp2204
	  lw $t0, -4180($fp)	# fill _tmp2203 to $t0 from $fp-4180
	  lw $t1, -4184($fp)	# fill _tmp2204 to $t1 from $fp-4184
	  or $t2, $t0, $t1	
	  sw $t2, -4188($fp)	# spill _tmp2205 from $t2 to $fp-4188
	# _tmp2206 = _tmp2205 || _tmp2202
	  lw $t0, -4188($fp)	# fill _tmp2205 to $t0 from $fp-4188
	  lw $t1, -4176($fp)	# fill _tmp2202 to $t1 from $fp-4176
	  or $t2, $t0, $t1	
	  sw $t2, -4192($fp)	# spill _tmp2206 from $t2 to $fp-4192
	# IfZ _tmp2206 Goto _L215
	  lw $t0, -4192($fp)	# fill _tmp2206 to $t0 from $fp-4192
	  beqz $t0, _L215	# branch if _tmp2206 is zero 
	# _tmp2207 = "Decaf runtime error: Array subscript out of bound..."
	  .data			# create string constant marked with label
	  _string139: .asciiz "Decaf runtime error: Array subscript out of bounds\n"
	  .text
	  la $t2, _string139	# load label
	  sw $t2, -4196($fp)	# spill _tmp2207 from $t2 to $fp-4196
	# PushParam _tmp2207
	  subu $sp, $sp, 4	# decrement sp to make space for param
	  lw $t0, -4196($fp)	# fill _tmp2207 to $t0 from $fp-4196
	  sw $t0, 4($sp)	# copy param value to stack
	# LCall _PrintString
	  jal _PrintString   	# jump to function
	# PopParams 4
	  add $sp, $sp, 4	# pop params off stack
	# LCall _Halt
	  jal _Halt          	# jump to function
  _L215:
	# _tmp2208 = 4
	  li $t2, 4		# load constant value 4 into $t2
	  sw $t2, -4200($fp)	# spill _tmp2208 from $t2 to $fp-4200
	# _tmp2209 = _tmp2199 * _tmp2208
	  lw $t0, -4164($fp)	# fill _tmp2199 to $t0 from $fp-4164
	  lw $t1, -4200($fp)	# fill _tmp2208 to $t1 from $fp-4200
	  mul $t2, $t0, $t1	
	  sw $t2, -4204($fp)	# spill _tmp2209 from $t2 to $fp-4204
	# _tmp2210 = _tmp2209 + _tmp2208
	  lw $t0, -4204($fp)	# fill _tmp2209 to $t0 from $fp-4204
	  lw $t1, -4200($fp)	# fill _tmp2208 to $t1 from $fp-4200
	  add $t2, $t0, $t1	
	  sw $t2, -4208($fp)	# spill _tmp2210 from $t2 to $fp-4208
	# _tmp2211 = _tmp2198 + _tmp2210
	  lw $t0, -4160($fp)	# fill _tmp2198 to $t0 from $fp-4160
	  lw $t1, -4208($fp)	# fill _tmp2210 to $t1 from $fp-4208
	  add $t2, $t0, $t1	
	  sw $t2, -4212($fp)	# spill _tmp2211 from $t2 to $fp-4212
	# _tmp2212 = *(_tmp2211)
	  lw $t0, -4212($fp)	# fill _tmp2211 to $t0 from $fp-4212
	  lw $t2, 0($t0) 	# load with offset
	  sw $t2, -4216($fp)	# spill _tmp2212 from $t2 to $fp-4216
	# _tmp2213 = 1
	  li $t2, 1		# load constant value 1 into $t2
	  sw $t2, -4220($fp)	# spill _tmp2213 from $t2 to $fp-4220
	# _tmp2214 = 0
	  li $t2, 0		# load constant value 0 into $t2
	  sw $t2, -4224($fp)	# spill _tmp2214 from $t2 to $fp-4224
	# _tmp2215 = *(_tmp2212)
	  lw $t0, -4216($fp)	# fill _tmp2212 to $t0 from $fp-4216
	  lw $t2, 0($t0) 	# load with offset
	  sw $t2, -4228($fp)	# spill _tmp2215 from $t2 to $fp-4228
	# _tmp2216 = _tmp2213 < _tmp2214
	  lw $t0, -4220($fp)	# fill _tmp2213 to $t0 from $fp-4220
	  lw $t1, -4224($fp)	# fill _tmp2214 to $t1 from $fp-4224
	  slt $t2, $t0, $t1	
	  sw $t2, -4232($fp)	# spill _tmp2216 from $t2 to $fp-4232
	# _tmp2217 = _tmp2215 < _tmp2213
	  lw $t0, -4228($fp)	# fill _tmp2215 to $t0 from $fp-4228
	  lw $t1, -4220($fp)	# fill _tmp2213 to $t1 from $fp-4220
	  slt $t2, $t0, $t1	
	  sw $t2, -4236($fp)	# spill _tmp2217 from $t2 to $fp-4236
	# _tmp2218 = _tmp2215 == _tmp2213
	  lw $t0, -4228($fp)	# fill _tmp2215 to $t0 from $fp-4228
	  lw $t1, -4220($fp)	# fill _tmp2213 to $t1 from $fp-4220
	  seq $t2, $t0, $t1	
	  sw $t2, -4240($fp)	# spill _tmp2218 from $t2 to $fp-4240
	# _tmp2219 = _tmp2217 || _tmp2218
	  lw $t0, -4236($fp)	# fill _tmp2217 to $t0 from $fp-4236
	  lw $t1, -4240($fp)	# fill _tmp2218 to $t1 from $fp-4240
	  or $t2, $t0, $t1	
	  sw $t2, -4244($fp)	# spill _tmp2219 from $t2 to $fp-4244
	# _tmp2220 = _tmp2219 || _tmp2216
	  lw $t0, -4244($fp)	# fill _tmp2219 to $t0 from $fp-4244
	  lw $t1, -4232($fp)	# fill _tmp2216 to $t1 from $fp-4232
	  or $t2, $t0, $t1	
	  sw $t2, -4248($fp)	# spill _tmp2220 from $t2 to $fp-4248
	# IfZ _tmp2220 Goto _L216
	  lw $t0, -4248($fp)	# fill _tmp2220 to $t0 from $fp-4248
	  beqz $t0, _L216	# branch if _tmp2220 is zero 
	# _tmp2221 = "Decaf runtime error: Array subscript out of bound..."
	  .data			# create string constant marked with label
	  _string140: .asciiz "Decaf runtime error: Array subscript out of bounds\n"
	  .text
	  la $t2, _string140	# load label
	  sw $t2, -4252($fp)	# spill _tmp2221 from $t2 to $fp-4252
	# PushParam _tmp2221
	  subu $sp, $sp, 4	# decrement sp to make space for param
	  lw $t0, -4252($fp)	# fill _tmp2221 to $t0 from $fp-4252
	  sw $t0, 4($sp)	# copy param value to stack
	# LCall _PrintString
	  jal _PrintString   	# jump to function
	# PopParams 4
	  add $sp, $sp, 4	# pop params off stack
	# LCall _Halt
	  jal _Halt          	# jump to function
  _L216:
	# _tmp2222 = 4
	  li $t2, 4		# load constant value 4 into $t2
	  sw $t2, -4256($fp)	# spill _tmp2222 from $t2 to $fp-4256
	# _tmp2223 = _tmp2213 * _tmp2222
	  lw $t0, -4220($fp)	# fill _tmp2213 to $t0 from $fp-4220
	  lw $t1, -4256($fp)	# fill _tmp2222 to $t1 from $fp-4256
	  mul $t2, $t0, $t1	
	  sw $t2, -4260($fp)	# spill _tmp2223 from $t2 to $fp-4260
	# _tmp2224 = _tmp2223 + _tmp2222
	  lw $t0, -4260($fp)	# fill _tmp2223 to $t0 from $fp-4260
	  lw $t1, -4256($fp)	# fill _tmp2222 to $t1 from $fp-4256
	  add $t2, $t0, $t1	
	  sw $t2, -4264($fp)	# spill _tmp2224 from $t2 to $fp-4264
	# _tmp2225 = _tmp2212 + _tmp2224
	  lw $t0, -4216($fp)	# fill _tmp2212 to $t0 from $fp-4216
	  lw $t1, -4264($fp)	# fill _tmp2224 to $t1 from $fp-4264
	  add $t2, $t0, $t1	
	  sw $t2, -4268($fp)	# spill _tmp2225 from $t2 to $fp-4268
	# _tmp2226 = *(_tmp2225)
	  lw $t0, -4268($fp)	# fill _tmp2225 to $t0 from $fp-4268
	  lw $t2, 0($t0) 	# load with offset
	  sw $t2, -4272($fp)	# spill _tmp2226 from $t2 to $fp-4272
	# PushParam _tmp2226
	  subu $sp, $sp, 4	# decrement sp to make space for param
	  lw $t0, -4272($fp)	# fill _tmp2226 to $t0 from $fp-4272
	  sw $t0, 4($sp)	# copy param value to stack
	# _tmp2227 = *(_tmp2226)
	  lw $t0, -4272($fp)	# fill _tmp2226 to $t0 from $fp-4272
	  lw $t2, 0($t0) 	# load with offset
	  sw $t2, -4276($fp)	# spill _tmp2227 from $t2 to $fp-4276
	# _tmp2228 = *(_tmp2227 + 20)
	  lw $t0, -4276($fp)	# fill _tmp2227 to $t0 from $fp-4276
	  lw $t2, 20($t0) 	# load with offset
	  sw $t2, -4280($fp)	# spill _tmp2228 from $t2 to $fp-4280
	# _tmp2229 = ACall _tmp2228
	  lw $t0, -4280($fp)	# fill _tmp2228 to $t0 from $fp-4280
	  jalr $t0            	# jump to function
	  move $t2, $v0		# copy function return value from $v0
	  sw $t2, -4284($fp)	# spill _tmp2229 from $t2 to $fp-4284
	# PopParams 8
	  add $sp, $sp, 8	# pop params off stack
	# PushParam enemyMark
	  subu $sp, $sp, 4	# decrement sp to make space for param
	  lw $t0, 8($fp)	# fill enemyMark to $t0 from $fp+8
	  sw $t0, 4($sp)	# copy param value to stack
	# _tmp2230 = *(this + 4)
	  lw $t0, 4($fp)	# fill this to $t0 from $fp+4
	  lw $t2, 4($t0) 	# load with offset
	  sw $t2, -4288($fp)	# spill _tmp2230 from $t2 to $fp-4288
	# _tmp2231 = 1
	  li $t2, 1		# load constant value 1 into $t2
	  sw $t2, -4292($fp)	# spill _tmp2231 from $t2 to $fp-4292
	# _tmp2232 = 0
	  li $t2, 0		# load constant value 0 into $t2
	  sw $t2, -4296($fp)	# spill _tmp2232 from $t2 to $fp-4296
	# _tmp2233 = *(_tmp2230)
	  lw $t0, -4288($fp)	# fill _tmp2230 to $t0 from $fp-4288
	  lw $t2, 0($t0) 	# load with offset
	  sw $t2, -4300($fp)	# spill _tmp2233 from $t2 to $fp-4300
	# _tmp2234 = _tmp2231 < _tmp2232
	  lw $t0, -4292($fp)	# fill _tmp2231 to $t0 from $fp-4292
	  lw $t1, -4296($fp)	# fill _tmp2232 to $t1 from $fp-4296
	  slt $t2, $t0, $t1	
	  sw $t2, -4304($fp)	# spill _tmp2234 from $t2 to $fp-4304
	# _tmp2235 = _tmp2233 < _tmp2231
	  lw $t0, -4300($fp)	# fill _tmp2233 to $t0 from $fp-4300
	  lw $t1, -4292($fp)	# fill _tmp2231 to $t1 from $fp-4292
	  slt $t2, $t0, $t1	
	  sw $t2, -4308($fp)	# spill _tmp2235 from $t2 to $fp-4308
	# _tmp2236 = _tmp2233 == _tmp2231
	  lw $t0, -4300($fp)	# fill _tmp2233 to $t0 from $fp-4300
	  lw $t1, -4292($fp)	# fill _tmp2231 to $t1 from $fp-4292
	  seq $t2, $t0, $t1	
	  sw $t2, -4312($fp)	# spill _tmp2236 from $t2 to $fp-4312
	# _tmp2237 = _tmp2235 || _tmp2236
	  lw $t0, -4308($fp)	# fill _tmp2235 to $t0 from $fp-4308
	  lw $t1, -4312($fp)	# fill _tmp2236 to $t1 from $fp-4312
	  or $t2, $t0, $t1	
	  sw $t2, -4316($fp)	# spill _tmp2237 from $t2 to $fp-4316
	# _tmp2238 = _tmp2237 || _tmp2234
	  lw $t0, -4316($fp)	# fill _tmp2237 to $t0 from $fp-4316
	  lw $t1, -4304($fp)	# fill _tmp2234 to $t1 from $fp-4304
	  or $t2, $t0, $t1	
	  sw $t2, -4320($fp)	# spill _tmp2238 from $t2 to $fp-4320
	# IfZ _tmp2238 Goto _L217
	  lw $t0, -4320($fp)	# fill _tmp2238 to $t0 from $fp-4320
	  beqz $t0, _L217	# branch if _tmp2238 is zero 
	# _tmp2239 = "Decaf runtime error: Array subscript out of bound..."
	  .data			# create string constant marked with label
	  _string141: .asciiz "Decaf runtime error: Array subscript out of bounds\n"
	  .text
	  la $t2, _string141	# load label
	  sw $t2, -4324($fp)	# spill _tmp2239 from $t2 to $fp-4324
	# PushParam _tmp2239
	  subu $sp, $sp, 4	# decrement sp to make space for param
	  lw $t0, -4324($fp)	# fill _tmp2239 to $t0 from $fp-4324
	  sw $t0, 4($sp)	# copy param value to stack
	# LCall _PrintString
	  jal _PrintString   	# jump to function
	# PopParams 4
	  add $sp, $sp, 4	# pop params off stack
	# LCall _Halt
	  jal _Halt          	# jump to function
  _L217:
	# _tmp2240 = 4
	  li $t2, 4		# load constant value 4 into $t2
	  sw $t2, -4328($fp)	# spill _tmp2240 from $t2 to $fp-4328
	# _tmp2241 = _tmp2231 * _tmp2240
	  lw $t0, -4292($fp)	# fill _tmp2231 to $t0 from $fp-4292
	  lw $t1, -4328($fp)	# fill _tmp2240 to $t1 from $fp-4328
	  mul $t2, $t0, $t1	
	  sw $t2, -4332($fp)	# spill _tmp2241 from $t2 to $fp-4332
	# _tmp2242 = _tmp2241 + _tmp2240
	  lw $t0, -4332($fp)	# fill _tmp2241 to $t0 from $fp-4332
	  lw $t1, -4328($fp)	# fill _tmp2240 to $t1 from $fp-4328
	  add $t2, $t0, $t1	
	  sw $t2, -4336($fp)	# spill _tmp2242 from $t2 to $fp-4336
	# _tmp2243 = _tmp2230 + _tmp2242
	  lw $t0, -4288($fp)	# fill _tmp2230 to $t0 from $fp-4288
	  lw $t1, -4336($fp)	# fill _tmp2242 to $t1 from $fp-4336
	  add $t2, $t0, $t1	
	  sw $t2, -4340($fp)	# spill _tmp2243 from $t2 to $fp-4340
	# _tmp2244 = *(_tmp2243)
	  lw $t0, -4340($fp)	# fill _tmp2243 to $t0 from $fp-4340
	  lw $t2, 0($t0) 	# load with offset
	  sw $t2, -4344($fp)	# spill _tmp2244 from $t2 to $fp-4344
	# _tmp2245 = 1
	  li $t2, 1		# load constant value 1 into $t2
	  sw $t2, -4348($fp)	# spill _tmp2245 from $t2 to $fp-4348
	# _tmp2246 = 0
	  li $t2, 0		# load constant value 0 into $t2
	  sw $t2, -4352($fp)	# spill _tmp2246 from $t2 to $fp-4352
	# _tmp2247 = *(_tmp2244)
	  lw $t0, -4344($fp)	# fill _tmp2244 to $t0 from $fp-4344
	  lw $t2, 0($t0) 	# load with offset
	  sw $t2, -4356($fp)	# spill _tmp2247 from $t2 to $fp-4356
	# _tmp2248 = _tmp2245 < _tmp2246
	  lw $t0, -4348($fp)	# fill _tmp2245 to $t0 from $fp-4348
	  lw $t1, -4352($fp)	# fill _tmp2246 to $t1 from $fp-4352
	  slt $t2, $t0, $t1	
	  sw $t2, -4360($fp)	# spill _tmp2248 from $t2 to $fp-4360
	# _tmp2249 = _tmp2247 < _tmp2245
	  lw $t0, -4356($fp)	# fill _tmp2247 to $t0 from $fp-4356
	  lw $t1, -4348($fp)	# fill _tmp2245 to $t1 from $fp-4348
	  slt $t2, $t0, $t1	
	  sw $t2, -4364($fp)	# spill _tmp2249 from $t2 to $fp-4364
	# _tmp2250 = _tmp2247 == _tmp2245
	  lw $t0, -4356($fp)	# fill _tmp2247 to $t0 from $fp-4356
	  lw $t1, -4348($fp)	# fill _tmp2245 to $t1 from $fp-4348
	  seq $t2, $t0, $t1	
	  sw $t2, -4368($fp)	# spill _tmp2250 from $t2 to $fp-4368
	# _tmp2251 = _tmp2249 || _tmp2250
	  lw $t0, -4364($fp)	# fill _tmp2249 to $t0 from $fp-4364
	  lw $t1, -4368($fp)	# fill _tmp2250 to $t1 from $fp-4368
	  or $t2, $t0, $t1	
	  sw $t2, -4372($fp)	# spill _tmp2251 from $t2 to $fp-4372
	# _tmp2252 = _tmp2251 || _tmp2248
	  lw $t0, -4372($fp)	# fill _tmp2251 to $t0 from $fp-4372
	  lw $t1, -4360($fp)	# fill _tmp2248 to $t1 from $fp-4360
	  or $t2, $t0, $t1	
	  sw $t2, -4376($fp)	# spill _tmp2252 from $t2 to $fp-4376
	# IfZ _tmp2252 Goto _L218
	  lw $t0, -4376($fp)	# fill _tmp2252 to $t0 from $fp-4376
	  beqz $t0, _L218	# branch if _tmp2252 is zero 
	# _tmp2253 = "Decaf runtime error: Array subscript out of bound..."
	  .data			# create string constant marked with label
	  _string142: .asciiz "Decaf runtime error: Array subscript out of bounds\n"
	  .text
	  la $t2, _string142	# load label
	  sw $t2, -4380($fp)	# spill _tmp2253 from $t2 to $fp-4380
	# PushParam _tmp2253
	  subu $sp, $sp, 4	# decrement sp to make space for param
	  lw $t0, -4380($fp)	# fill _tmp2253 to $t0 from $fp-4380
	  sw $t0, 4($sp)	# copy param value to stack
	# LCall _PrintString
	  jal _PrintString   	# jump to function
	# PopParams 4
	  add $sp, $sp, 4	# pop params off stack
	# LCall _Halt
	  jal _Halt          	# jump to function
  _L218:
	# _tmp2254 = 4
	  li $t2, 4		# load constant value 4 into $t2
	  sw $t2, -4384($fp)	# spill _tmp2254 from $t2 to $fp-4384
	# _tmp2255 = _tmp2245 * _tmp2254
	  lw $t0, -4348($fp)	# fill _tmp2245 to $t0 from $fp-4348
	  lw $t1, -4384($fp)	# fill _tmp2254 to $t1 from $fp-4384
	  mul $t2, $t0, $t1	
	  sw $t2, -4388($fp)	# spill _tmp2255 from $t2 to $fp-4388
	# _tmp2256 = _tmp2255 + _tmp2254
	  lw $t0, -4388($fp)	# fill _tmp2255 to $t0 from $fp-4388
	  lw $t1, -4384($fp)	# fill _tmp2254 to $t1 from $fp-4384
	  add $t2, $t0, $t1	
	  sw $t2, -4392($fp)	# spill _tmp2256 from $t2 to $fp-4392
	# _tmp2257 = _tmp2244 + _tmp2256
	  lw $t0, -4344($fp)	# fill _tmp2244 to $t0 from $fp-4344
	  lw $t1, -4392($fp)	# fill _tmp2256 to $t1 from $fp-4392
	  add $t2, $t0, $t1	
	  sw $t2, -4396($fp)	# spill _tmp2257 from $t2 to $fp-4396
	# _tmp2258 = *(_tmp2257)
	  lw $t0, -4396($fp)	# fill _tmp2257 to $t0 from $fp-4396
	  lw $t2, 0($t0) 	# load with offset
	  sw $t2, -4400($fp)	# spill _tmp2258 from $t2 to $fp-4400
	# PushParam _tmp2258
	  subu $sp, $sp, 4	# decrement sp to make space for param
	  lw $t0, -4400($fp)	# fill _tmp2258 to $t0 from $fp-4400
	  sw $t0, 4($sp)	# copy param value to stack
	# _tmp2259 = *(_tmp2258)
	  lw $t0, -4400($fp)	# fill _tmp2258 to $t0 from $fp-4400
	  lw $t2, 0($t0) 	# load with offset
	  sw $t2, -4404($fp)	# spill _tmp2259 from $t2 to $fp-4404
	# _tmp2260 = *(_tmp2259 + 20)
	  lw $t0, -4404($fp)	# fill _tmp2259 to $t0 from $fp-4404
	  lw $t2, 20($t0) 	# load with offset
	  sw $t2, -4408($fp)	# spill _tmp2260 from $t2 to $fp-4408
	# _tmp2261 = ACall _tmp2260
	  lw $t0, -4408($fp)	# fill _tmp2260 to $t0 from $fp-4408
	  jalr $t0            	# jump to function
	  move $t2, $v0		# copy function return value from $v0
	  sw $t2, -4412($fp)	# spill _tmp2261 from $t2 to $fp-4412
	# PopParams 8
	  add $sp, $sp, 8	# pop params off stack
	# _tmp2262 = _tmp2229 && _tmp2261
	  lw $t0, -4284($fp)	# fill _tmp2229 to $t0 from $fp-4284
	  lw $t1, -4412($fp)	# fill _tmp2261 to $t1 from $fp-4412
	  and $t2, $t0, $t1	
	  sw $t2, -4416($fp)	# spill _tmp2262 from $t2 to $fp-4416
	# PushParam playerMark
	  subu $sp, $sp, 4	# decrement sp to make space for param
	  lw $t0, 12($fp)	# fill playerMark to $t0 from $fp+12
	  sw $t0, 4($sp)	# copy param value to stack
	# _tmp2264 = *(this + 4)
	  lw $t0, 4($fp)	# fill this to $t0 from $fp+4
	  lw $t2, 4($t0) 	# load with offset
	  sw $t2, -4424($fp)	# spill _tmp2264 from $t2 to $fp-4424
	# _tmp2265 = 0
	  li $t2, 0		# load constant value 0 into $t2
	  sw $t2, -4428($fp)	# spill _tmp2265 from $t2 to $fp-4428
	# _tmp2266 = 0
	  li $t2, 0		# load constant value 0 into $t2
	  sw $t2, -4432($fp)	# spill _tmp2266 from $t2 to $fp-4432
	# _tmp2267 = *(_tmp2264)
	  lw $t0, -4424($fp)	# fill _tmp2264 to $t0 from $fp-4424
	  lw $t2, 0($t0) 	# load with offset
	  sw $t2, -4436($fp)	# spill _tmp2267 from $t2 to $fp-4436
	# _tmp2268 = _tmp2265 < _tmp2266
	  lw $t0, -4428($fp)	# fill _tmp2265 to $t0 from $fp-4428
	  lw $t1, -4432($fp)	# fill _tmp2266 to $t1 from $fp-4432
	  slt $t2, $t0, $t1	
	  sw $t2, -4440($fp)	# spill _tmp2268 from $t2 to $fp-4440
	# _tmp2269 = _tmp2267 < _tmp2265
	  lw $t0, -4436($fp)	# fill _tmp2267 to $t0 from $fp-4436
	  lw $t1, -4428($fp)	# fill _tmp2265 to $t1 from $fp-4428
	  slt $t2, $t0, $t1	
	  sw $t2, -4444($fp)	# spill _tmp2269 from $t2 to $fp-4444
	# _tmp2270 = _tmp2267 == _tmp2265
	  lw $t0, -4436($fp)	# fill _tmp2267 to $t0 from $fp-4436
	  lw $t1, -4428($fp)	# fill _tmp2265 to $t1 from $fp-4428
	  seq $t2, $t0, $t1	
	  sw $t2, -4448($fp)	# spill _tmp2270 from $t2 to $fp-4448
	# _tmp2271 = _tmp2269 || _tmp2270
	  lw $t0, -4444($fp)	# fill _tmp2269 to $t0 from $fp-4444
	  lw $t1, -4448($fp)	# fill _tmp2270 to $t1 from $fp-4448
	  or $t2, $t0, $t1	
	  sw $t2, -4452($fp)	# spill _tmp2271 from $t2 to $fp-4452
	# _tmp2272 = _tmp2271 || _tmp2268
	  lw $t0, -4452($fp)	# fill _tmp2271 to $t0 from $fp-4452
	  lw $t1, -4440($fp)	# fill _tmp2268 to $t1 from $fp-4440
	  or $t2, $t0, $t1	
	  sw $t2, -4456($fp)	# spill _tmp2272 from $t2 to $fp-4456
	# IfZ _tmp2272 Goto _L221
	  lw $t0, -4456($fp)	# fill _tmp2272 to $t0 from $fp-4456
	  beqz $t0, _L221	# branch if _tmp2272 is zero 
	# _tmp2273 = "Decaf runtime error: Array subscript out of bound..."
	  .data			# create string constant marked with label
	  _string143: .asciiz "Decaf runtime error: Array subscript out of bounds\n"
	  .text
	  la $t2, _string143	# load label
	  sw $t2, -4460($fp)	# spill _tmp2273 from $t2 to $fp-4460
	# PushParam _tmp2273
	  subu $sp, $sp, 4	# decrement sp to make space for param
	  lw $t0, -4460($fp)	# fill _tmp2273 to $t0 from $fp-4460
	  sw $t0, 4($sp)	# copy param value to stack
	# LCall _PrintString
	  jal _PrintString   	# jump to function
	# PopParams 4
	  add $sp, $sp, 4	# pop params off stack
	# LCall _Halt
	  jal _Halt          	# jump to function
  _L221:
	# _tmp2274 = 4
	  li $t2, 4		# load constant value 4 into $t2
	  sw $t2, -4464($fp)	# spill _tmp2274 from $t2 to $fp-4464
	# _tmp2275 = _tmp2265 * _tmp2274
	  lw $t0, -4428($fp)	# fill _tmp2265 to $t0 from $fp-4428
	  lw $t1, -4464($fp)	# fill _tmp2274 to $t1 from $fp-4464
	  mul $t2, $t0, $t1	
	  sw $t2, -4468($fp)	# spill _tmp2275 from $t2 to $fp-4468
	# _tmp2276 = _tmp2275 + _tmp2274
	  lw $t0, -4468($fp)	# fill _tmp2275 to $t0 from $fp-4468
	  lw $t1, -4464($fp)	# fill _tmp2274 to $t1 from $fp-4464
	  add $t2, $t0, $t1	
	  sw $t2, -4472($fp)	# spill _tmp2276 from $t2 to $fp-4472
	# _tmp2277 = _tmp2264 + _tmp2276
	  lw $t0, -4424($fp)	# fill _tmp2264 to $t0 from $fp-4424
	  lw $t1, -4472($fp)	# fill _tmp2276 to $t1 from $fp-4472
	  add $t2, $t0, $t1	
	  sw $t2, -4476($fp)	# spill _tmp2277 from $t2 to $fp-4476
	# _tmp2278 = *(_tmp2277)
	  lw $t0, -4476($fp)	# fill _tmp2277 to $t0 from $fp-4476
	  lw $t2, 0($t0) 	# load with offset
	  sw $t2, -4480($fp)	# spill _tmp2278 from $t2 to $fp-4480
	# _tmp2279 = 1
	  li $t2, 1		# load constant value 1 into $t2
	  sw $t2, -4484($fp)	# spill _tmp2279 from $t2 to $fp-4484
	# _tmp2280 = 0
	  li $t2, 0		# load constant value 0 into $t2
	  sw $t2, -4488($fp)	# spill _tmp2280 from $t2 to $fp-4488
	# _tmp2281 = *(_tmp2278)
	  lw $t0, -4480($fp)	# fill _tmp2278 to $t0 from $fp-4480
	  lw $t2, 0($t0) 	# load with offset
	  sw $t2, -4492($fp)	# spill _tmp2281 from $t2 to $fp-4492
	# _tmp2282 = _tmp2279 < _tmp2280
	  lw $t0, -4484($fp)	# fill _tmp2279 to $t0 from $fp-4484
	  lw $t1, -4488($fp)	# fill _tmp2280 to $t1 from $fp-4488
	  slt $t2, $t0, $t1	
	  sw $t2, -4496($fp)	# spill _tmp2282 from $t2 to $fp-4496
	# _tmp2283 = _tmp2281 < _tmp2279
	  lw $t0, -4492($fp)	# fill _tmp2281 to $t0 from $fp-4492
	  lw $t1, -4484($fp)	# fill _tmp2279 to $t1 from $fp-4484
	  slt $t2, $t0, $t1	
	  sw $t2, -4500($fp)	# spill _tmp2283 from $t2 to $fp-4500
	# _tmp2284 = _tmp2281 == _tmp2279
	  lw $t0, -4492($fp)	# fill _tmp2281 to $t0 from $fp-4492
	  lw $t1, -4484($fp)	# fill _tmp2279 to $t1 from $fp-4484
	  seq $t2, $t0, $t1	
	  sw $t2, -4504($fp)	# spill _tmp2284 from $t2 to $fp-4504
	# _tmp2285 = _tmp2283 || _tmp2284
	  lw $t0, -4500($fp)	# fill _tmp2283 to $t0 from $fp-4500
	  lw $t1, -4504($fp)	# fill _tmp2284 to $t1 from $fp-4504
	  or $t2, $t0, $t1	
	  sw $t2, -4508($fp)	# spill _tmp2285 from $t2 to $fp-4508
	# _tmp2286 = _tmp2285 || _tmp2282
	  lw $t0, -4508($fp)	# fill _tmp2285 to $t0 from $fp-4508
	  lw $t1, -4496($fp)	# fill _tmp2282 to $t1 from $fp-4496
	  or $t2, $t0, $t1	
	  sw $t2, -4512($fp)	# spill _tmp2286 from $t2 to $fp-4512
	# IfZ _tmp2286 Goto _L222
	  lw $t0, -4512($fp)	# fill _tmp2286 to $t0 from $fp-4512
	  beqz $t0, _L222	# branch if _tmp2286 is zero 
	# _tmp2287 = "Decaf runtime error: Array subscript out of bound..."
	  .data			# create string constant marked with label
	  _string144: .asciiz "Decaf runtime error: Array subscript out of bounds\n"
	  .text
	  la $t2, _string144	# load label
	  sw $t2, -4516($fp)	# spill _tmp2287 from $t2 to $fp-4516
	# PushParam _tmp2287
	  subu $sp, $sp, 4	# decrement sp to make space for param
	  lw $t0, -4516($fp)	# fill _tmp2287 to $t0 from $fp-4516
	  sw $t0, 4($sp)	# copy param value to stack
	# LCall _PrintString
	  jal _PrintString   	# jump to function
	# PopParams 4
	  add $sp, $sp, 4	# pop params off stack
	# LCall _Halt
	  jal _Halt          	# jump to function
  _L222:
	# _tmp2288 = 4
	  li $t2, 4		# load constant value 4 into $t2
	  sw $t2, -4520($fp)	# spill _tmp2288 from $t2 to $fp-4520
	# _tmp2289 = _tmp2279 * _tmp2288
	  lw $t0, -4484($fp)	# fill _tmp2279 to $t0 from $fp-4484
	  lw $t1, -4520($fp)	# fill _tmp2288 to $t1 from $fp-4520
	  mul $t2, $t0, $t1	
	  sw $t2, -4524($fp)	# spill _tmp2289 from $t2 to $fp-4524
	# _tmp2290 = _tmp2289 + _tmp2288
	  lw $t0, -4524($fp)	# fill _tmp2289 to $t0 from $fp-4524
	  lw $t1, -4520($fp)	# fill _tmp2288 to $t1 from $fp-4520
	  add $t2, $t0, $t1	
	  sw $t2, -4528($fp)	# spill _tmp2290 from $t2 to $fp-4528
	# _tmp2291 = _tmp2278 + _tmp2290
	  lw $t0, -4480($fp)	# fill _tmp2278 to $t0 from $fp-4480
	  lw $t1, -4528($fp)	# fill _tmp2290 to $t1 from $fp-4528
	  add $t2, $t0, $t1	
	  sw $t2, -4532($fp)	# spill _tmp2291 from $t2 to $fp-4532
	# _tmp2292 = *(_tmp2291)
	  lw $t0, -4532($fp)	# fill _tmp2291 to $t0 from $fp-4532
	  lw $t2, 0($t0) 	# load with offset
	  sw $t2, -4536($fp)	# spill _tmp2292 from $t2 to $fp-4536
	# PushParam _tmp2292
	  subu $sp, $sp, 4	# decrement sp to make space for param
	  lw $t0, -4536($fp)	# fill _tmp2292 to $t0 from $fp-4536
	  sw $t0, 4($sp)	# copy param value to stack
	# _tmp2293 = *(_tmp2292)
	  lw $t0, -4536($fp)	# fill _tmp2292 to $t0 from $fp-4536
	  lw $t2, 0($t0) 	# load with offset
	  sw $t2, -4540($fp)	# spill _tmp2293 from $t2 to $fp-4540
	# _tmp2294 = *(_tmp2293 + 20)
	  lw $t0, -4540($fp)	# fill _tmp2293 to $t0 from $fp-4540
	  lw $t2, 20($t0) 	# load with offset
	  sw $t2, -4544($fp)	# spill _tmp2294 from $t2 to $fp-4544
	# _tmp2295 = ACall _tmp2294
	  lw $t0, -4544($fp)	# fill _tmp2294 to $t0 from $fp-4544
	  jalr $t0            	# jump to function
	  move $t2, $v0		# copy function return value from $v0
	  sw $t2, -4548($fp)	# spill _tmp2295 from $t2 to $fp-4548
	# PopParams 8
	  add $sp, $sp, 8	# pop params off stack
	# IfZ _tmp2295 Goto _L220
	  lw $t0, -4548($fp)	# fill _tmp2295 to $t0 from $fp-4548
	  beqz $t0, _L220	# branch if _tmp2295 is zero 
	# _tmp2296 = 0
	  li $t2, 0		# load constant value 0 into $t2
	  sw $t2, -4552($fp)	# spill _tmp2296 from $t2 to $fp-4552
	# _tmp2263 = _tmp2296
	  lw $t2, -4552($fp)	# fill _tmp2296 to $t2 from $fp-4552
	  sw $t2, -4420($fp)	# spill _tmp2263 from $t2 to $fp-4420
	# Goto _L219
	  b _L219		# unconditional branch
  _L220:
	# _tmp2297 = 1
	  li $t2, 1		# load constant value 1 into $t2
	  sw $t2, -4556($fp)	# spill _tmp2297 from $t2 to $fp-4556
	# _tmp2263 = _tmp2297
	  lw $t2, -4556($fp)	# fill _tmp2297 to $t2 from $fp-4556
	  sw $t2, -4420($fp)	# spill _tmp2263 from $t2 to $fp-4420
  _L219:
	# _tmp2298 = _tmp2262 && _tmp2263
	  lw $t0, -4416($fp)	# fill _tmp2262 to $t0 from $fp-4416
	  lw $t1, -4420($fp)	# fill _tmp2263 to $t1 from $fp-4420
	  and $t2, $t0, $t1	
	  sw $t2, -4560($fp)	# spill _tmp2298 from $t2 to $fp-4560
	# IfZ _tmp2298 Goto _L213
	  lw $t0, -4560($fp)	# fill _tmp2298 to $t0 from $fp-4560
	  beqz $t0, _L213	# branch if _tmp2298 is zero 
	# _tmp2299 = 0
	  li $t2, 0		# load constant value 0 into $t2
	  sw $t2, -4564($fp)	# spill _tmp2299 from $t2 to $fp-4564
	# row = _tmp2299
	  lw $t2, -4564($fp)	# fill _tmp2299 to $t2 from $fp-4564
	  sw $t2, -8($fp)	# spill row from $t2 to $fp-8
	# _tmp2300 = 1
	  li $t2, 1		# load constant value 1 into $t2
	  sw $t2, -4568($fp)	# spill _tmp2300 from $t2 to $fp-4568
	# column = _tmp2300
	  lw $t2, -4568($fp)	# fill _tmp2300 to $t2 from $fp-4568
	  sw $t2, -12($fp)	# spill column from $t2 to $fp-12
	# Goto _L214
	  b _L214		# unconditional branch
  _L213:
	# PushParam enemyMark
	  subu $sp, $sp, 4	# decrement sp to make space for param
	  lw $t0, 8($fp)	# fill enemyMark to $t0 from $fp+8
	  sw $t0, 4($sp)	# copy param value to stack
	# _tmp2301 = *(this + 4)
	  lw $t0, 4($fp)	# fill this to $t0 from $fp+4
	  lw $t2, 4($t0) 	# load with offset
	  sw $t2, -4572($fp)	# spill _tmp2301 from $t2 to $fp-4572
	# _tmp2302 = 2
	  li $t2, 2		# load constant value 2 into $t2
	  sw $t2, -4576($fp)	# spill _tmp2302 from $t2 to $fp-4576
	# _tmp2303 = 0
	  li $t2, 0		# load constant value 0 into $t2
	  sw $t2, -4580($fp)	# spill _tmp2303 from $t2 to $fp-4580
	# _tmp2304 = *(_tmp2301)
	  lw $t0, -4572($fp)	# fill _tmp2301 to $t0 from $fp-4572
	  lw $t2, 0($t0) 	# load with offset
	  sw $t2, -4584($fp)	# spill _tmp2304 from $t2 to $fp-4584
	# _tmp2305 = _tmp2302 < _tmp2303
	  lw $t0, -4576($fp)	# fill _tmp2302 to $t0 from $fp-4576
	  lw $t1, -4580($fp)	# fill _tmp2303 to $t1 from $fp-4580
	  slt $t2, $t0, $t1	
	  sw $t2, -4588($fp)	# spill _tmp2305 from $t2 to $fp-4588
	# _tmp2306 = _tmp2304 < _tmp2302
	  lw $t0, -4584($fp)	# fill _tmp2304 to $t0 from $fp-4584
	  lw $t1, -4576($fp)	# fill _tmp2302 to $t1 from $fp-4576
	  slt $t2, $t0, $t1	
	  sw $t2, -4592($fp)	# spill _tmp2306 from $t2 to $fp-4592
	# _tmp2307 = _tmp2304 == _tmp2302
	  lw $t0, -4584($fp)	# fill _tmp2304 to $t0 from $fp-4584
	  lw $t1, -4576($fp)	# fill _tmp2302 to $t1 from $fp-4576
	  seq $t2, $t0, $t1	
	  sw $t2, -4596($fp)	# spill _tmp2307 from $t2 to $fp-4596
	# _tmp2308 = _tmp2306 || _tmp2307
	  lw $t0, -4592($fp)	# fill _tmp2306 to $t0 from $fp-4592
	  lw $t1, -4596($fp)	# fill _tmp2307 to $t1 from $fp-4596
	  or $t2, $t0, $t1	
	  sw $t2, -4600($fp)	# spill _tmp2308 from $t2 to $fp-4600
	# _tmp2309 = _tmp2308 || _tmp2305
	  lw $t0, -4600($fp)	# fill _tmp2308 to $t0 from $fp-4600
	  lw $t1, -4588($fp)	# fill _tmp2305 to $t1 from $fp-4588
	  or $t2, $t0, $t1	
	  sw $t2, -4604($fp)	# spill _tmp2309 from $t2 to $fp-4604
	# IfZ _tmp2309 Goto _L225
	  lw $t0, -4604($fp)	# fill _tmp2309 to $t0 from $fp-4604
	  beqz $t0, _L225	# branch if _tmp2309 is zero 
	# _tmp2310 = "Decaf runtime error: Array subscript out of bound..."
	  .data			# create string constant marked with label
	  _string145: .asciiz "Decaf runtime error: Array subscript out of bounds\n"
	  .text
	  la $t2, _string145	# load label
	  sw $t2, -4608($fp)	# spill _tmp2310 from $t2 to $fp-4608
	# PushParam _tmp2310
	  subu $sp, $sp, 4	# decrement sp to make space for param
	  lw $t0, -4608($fp)	# fill _tmp2310 to $t0 from $fp-4608
	  sw $t0, 4($sp)	# copy param value to stack
	# LCall _PrintString
	  jal _PrintString   	# jump to function
	# PopParams 4
	  add $sp, $sp, 4	# pop params off stack
	# LCall _Halt
	  jal _Halt          	# jump to function
  _L225:
	# _tmp2311 = 4
	  li $t2, 4		# load constant value 4 into $t2
	  sw $t2, -4612($fp)	# spill _tmp2311 from $t2 to $fp-4612
	# _tmp2312 = _tmp2302 * _tmp2311
	  lw $t0, -4576($fp)	# fill _tmp2302 to $t0 from $fp-4576
	  lw $t1, -4612($fp)	# fill _tmp2311 to $t1 from $fp-4612
	  mul $t2, $t0, $t1	
	  sw $t2, -4616($fp)	# spill _tmp2312 from $t2 to $fp-4616
	# _tmp2313 = _tmp2312 + _tmp2311
	  lw $t0, -4616($fp)	# fill _tmp2312 to $t0 from $fp-4616
	  lw $t1, -4612($fp)	# fill _tmp2311 to $t1 from $fp-4612
	  add $t2, $t0, $t1	
	  sw $t2, -4620($fp)	# spill _tmp2313 from $t2 to $fp-4620
	# _tmp2314 = _tmp2301 + _tmp2313
	  lw $t0, -4572($fp)	# fill _tmp2301 to $t0 from $fp-4572
	  lw $t1, -4620($fp)	# fill _tmp2313 to $t1 from $fp-4620
	  add $t2, $t0, $t1	
	  sw $t2, -4624($fp)	# spill _tmp2314 from $t2 to $fp-4624
	# _tmp2315 = *(_tmp2314)
	  lw $t0, -4624($fp)	# fill _tmp2314 to $t0 from $fp-4624
	  lw $t2, 0($t0) 	# load with offset
	  sw $t2, -4628($fp)	# spill _tmp2315 from $t2 to $fp-4628
	# _tmp2316 = 2
	  li $t2, 2		# load constant value 2 into $t2
	  sw $t2, -4632($fp)	# spill _tmp2316 from $t2 to $fp-4632
	# _tmp2317 = 0
	  li $t2, 0		# load constant value 0 into $t2
	  sw $t2, -4636($fp)	# spill _tmp2317 from $t2 to $fp-4636
	# _tmp2318 = *(_tmp2315)
	  lw $t0, -4628($fp)	# fill _tmp2315 to $t0 from $fp-4628
	  lw $t2, 0($t0) 	# load with offset
	  sw $t2, -4640($fp)	# spill _tmp2318 from $t2 to $fp-4640
	# _tmp2319 = _tmp2316 < _tmp2317
	  lw $t0, -4632($fp)	# fill _tmp2316 to $t0 from $fp-4632
	  lw $t1, -4636($fp)	# fill _tmp2317 to $t1 from $fp-4636
	  slt $t2, $t0, $t1	
	  sw $t2, -4644($fp)	# spill _tmp2319 from $t2 to $fp-4644
	# _tmp2320 = _tmp2318 < _tmp2316
	  lw $t0, -4640($fp)	# fill _tmp2318 to $t0 from $fp-4640
	  lw $t1, -4632($fp)	# fill _tmp2316 to $t1 from $fp-4632
	  slt $t2, $t0, $t1	
	  sw $t2, -4648($fp)	# spill _tmp2320 from $t2 to $fp-4648
	# _tmp2321 = _tmp2318 == _tmp2316
	  lw $t0, -4640($fp)	# fill _tmp2318 to $t0 from $fp-4640
	  lw $t1, -4632($fp)	# fill _tmp2316 to $t1 from $fp-4632
	  seq $t2, $t0, $t1	
	  sw $t2, -4652($fp)	# spill _tmp2321 from $t2 to $fp-4652
	# _tmp2322 = _tmp2320 || _tmp2321
	  lw $t0, -4648($fp)	# fill _tmp2320 to $t0 from $fp-4648
	  lw $t1, -4652($fp)	# fill _tmp2321 to $t1 from $fp-4652
	  or $t2, $t0, $t1	
	  sw $t2, -4656($fp)	# spill _tmp2322 from $t2 to $fp-4656
	# _tmp2323 = _tmp2322 || _tmp2319
	  lw $t0, -4656($fp)	# fill _tmp2322 to $t0 from $fp-4656
	  lw $t1, -4644($fp)	# fill _tmp2319 to $t1 from $fp-4644
	  or $t2, $t0, $t1	
	  sw $t2, -4660($fp)	# spill _tmp2323 from $t2 to $fp-4660
	# IfZ _tmp2323 Goto _L226
	  lw $t0, -4660($fp)	# fill _tmp2323 to $t0 from $fp-4660
	  beqz $t0, _L226	# branch if _tmp2323 is zero 
	# _tmp2324 = "Decaf runtime error: Array subscript out of bound..."
	  .data			# create string constant marked with label
	  _string146: .asciiz "Decaf runtime error: Array subscript out of bounds\n"
	  .text
	  la $t2, _string146	# load label
	  sw $t2, -4664($fp)	# spill _tmp2324 from $t2 to $fp-4664
	# PushParam _tmp2324
	  subu $sp, $sp, 4	# decrement sp to make space for param
	  lw $t0, -4664($fp)	# fill _tmp2324 to $t0 from $fp-4664
	  sw $t0, 4($sp)	# copy param value to stack
	# LCall _PrintString
	  jal _PrintString   	# jump to function
	# PopParams 4
	  add $sp, $sp, 4	# pop params off stack
	# LCall _Halt
	  jal _Halt          	# jump to function
  _L226:
	# _tmp2325 = 4
	  li $t2, 4		# load constant value 4 into $t2
	  sw $t2, -4668($fp)	# spill _tmp2325 from $t2 to $fp-4668
	# _tmp2326 = _tmp2316 * _tmp2325
	  lw $t0, -4632($fp)	# fill _tmp2316 to $t0 from $fp-4632
	  lw $t1, -4668($fp)	# fill _tmp2325 to $t1 from $fp-4668
	  mul $t2, $t0, $t1	
	  sw $t2, -4672($fp)	# spill _tmp2326 from $t2 to $fp-4672
	# _tmp2327 = _tmp2326 + _tmp2325
	  lw $t0, -4672($fp)	# fill _tmp2326 to $t0 from $fp-4672
	  lw $t1, -4668($fp)	# fill _tmp2325 to $t1 from $fp-4668
	  add $t2, $t0, $t1	
	  sw $t2, -4676($fp)	# spill _tmp2327 from $t2 to $fp-4676
	# _tmp2328 = _tmp2315 + _tmp2327
	  lw $t0, -4628($fp)	# fill _tmp2315 to $t0 from $fp-4628
	  lw $t1, -4676($fp)	# fill _tmp2327 to $t1 from $fp-4676
	  add $t2, $t0, $t1	
	  sw $t2, -4680($fp)	# spill _tmp2328 from $t2 to $fp-4680
	# _tmp2329 = *(_tmp2328)
	  lw $t0, -4680($fp)	# fill _tmp2328 to $t0 from $fp-4680
	  lw $t2, 0($t0) 	# load with offset
	  sw $t2, -4684($fp)	# spill _tmp2329 from $t2 to $fp-4684
	# PushParam _tmp2329
	  subu $sp, $sp, 4	# decrement sp to make space for param
	  lw $t0, -4684($fp)	# fill _tmp2329 to $t0 from $fp-4684
	  sw $t0, 4($sp)	# copy param value to stack
	# _tmp2330 = *(_tmp2329)
	  lw $t0, -4684($fp)	# fill _tmp2329 to $t0 from $fp-4684
	  lw $t2, 0($t0) 	# load with offset
	  sw $t2, -4688($fp)	# spill _tmp2330 from $t2 to $fp-4688
	# _tmp2331 = *(_tmp2330 + 20)
	  lw $t0, -4688($fp)	# fill _tmp2330 to $t0 from $fp-4688
	  lw $t2, 20($t0) 	# load with offset
	  sw $t2, -4692($fp)	# spill _tmp2331 from $t2 to $fp-4692
	# _tmp2332 = ACall _tmp2331
	  lw $t0, -4692($fp)	# fill _tmp2331 to $t0 from $fp-4692
	  jalr $t0            	# jump to function
	  move $t2, $v0		# copy function return value from $v0
	  sw $t2, -4696($fp)	# spill _tmp2332 from $t2 to $fp-4696
	# PopParams 8
	  add $sp, $sp, 8	# pop params off stack
	# PushParam enemyMark
	  subu $sp, $sp, 4	# decrement sp to make space for param
	  lw $t0, 8($fp)	# fill enemyMark to $t0 from $fp+8
	  sw $t0, 4($sp)	# copy param value to stack
	# _tmp2333 = *(this + 4)
	  lw $t0, 4($fp)	# fill this to $t0 from $fp+4
	  lw $t2, 4($t0) 	# load with offset
	  sw $t2, -4700($fp)	# spill _tmp2333 from $t2 to $fp-4700
	# _tmp2334 = 1
	  li $t2, 1		# load constant value 1 into $t2
	  sw $t2, -4704($fp)	# spill _tmp2334 from $t2 to $fp-4704
	# _tmp2335 = 0
	  li $t2, 0		# load constant value 0 into $t2
	  sw $t2, -4708($fp)	# spill _tmp2335 from $t2 to $fp-4708
	# _tmp2336 = *(_tmp2333)
	  lw $t0, -4700($fp)	# fill _tmp2333 to $t0 from $fp-4700
	  lw $t2, 0($t0) 	# load with offset
	  sw $t2, -4712($fp)	# spill _tmp2336 from $t2 to $fp-4712
	# _tmp2337 = _tmp2334 < _tmp2335
	  lw $t0, -4704($fp)	# fill _tmp2334 to $t0 from $fp-4704
	  lw $t1, -4708($fp)	# fill _tmp2335 to $t1 from $fp-4708
	  slt $t2, $t0, $t1	
	  sw $t2, -4716($fp)	# spill _tmp2337 from $t2 to $fp-4716
	# _tmp2338 = _tmp2336 < _tmp2334
	  lw $t0, -4712($fp)	# fill _tmp2336 to $t0 from $fp-4712
	  lw $t1, -4704($fp)	# fill _tmp2334 to $t1 from $fp-4704
	  slt $t2, $t0, $t1	
	  sw $t2, -4720($fp)	# spill _tmp2338 from $t2 to $fp-4720
	# _tmp2339 = _tmp2336 == _tmp2334
	  lw $t0, -4712($fp)	# fill _tmp2336 to $t0 from $fp-4712
	  lw $t1, -4704($fp)	# fill _tmp2334 to $t1 from $fp-4704
	  seq $t2, $t0, $t1	
	  sw $t2, -4724($fp)	# spill _tmp2339 from $t2 to $fp-4724
	# _tmp2340 = _tmp2338 || _tmp2339
	  lw $t0, -4720($fp)	# fill _tmp2338 to $t0 from $fp-4720
	  lw $t1, -4724($fp)	# fill _tmp2339 to $t1 from $fp-4724
	  or $t2, $t0, $t1	
	  sw $t2, -4728($fp)	# spill _tmp2340 from $t2 to $fp-4728
	# _tmp2341 = _tmp2340 || _tmp2337
	  lw $t0, -4728($fp)	# fill _tmp2340 to $t0 from $fp-4728
	  lw $t1, -4716($fp)	# fill _tmp2337 to $t1 from $fp-4716
	  or $t2, $t0, $t1	
	  sw $t2, -4732($fp)	# spill _tmp2341 from $t2 to $fp-4732
	# IfZ _tmp2341 Goto _L227
	  lw $t0, -4732($fp)	# fill _tmp2341 to $t0 from $fp-4732
	  beqz $t0, _L227	# branch if _tmp2341 is zero 
	# _tmp2342 = "Decaf runtime error: Array subscript out of bound..."
	  .data			# create string constant marked with label
	  _string147: .asciiz "Decaf runtime error: Array subscript out of bounds\n"
	  .text
	  la $t2, _string147	# load label
	  sw $t2, -4736($fp)	# spill _tmp2342 from $t2 to $fp-4736
	# PushParam _tmp2342
	  subu $sp, $sp, 4	# decrement sp to make space for param
	  lw $t0, -4736($fp)	# fill _tmp2342 to $t0 from $fp-4736
	  sw $t0, 4($sp)	# copy param value to stack
	# LCall _PrintString
	  jal _PrintString   	# jump to function
	# PopParams 4
	  add $sp, $sp, 4	# pop params off stack
	# LCall _Halt
	  jal _Halt          	# jump to function
  _L227:
	# _tmp2343 = 4
	  li $t2, 4		# load constant value 4 into $t2
	  sw $t2, -4740($fp)	# spill _tmp2343 from $t2 to $fp-4740
	# _tmp2344 = _tmp2334 * _tmp2343
	  lw $t0, -4704($fp)	# fill _tmp2334 to $t0 from $fp-4704
	  lw $t1, -4740($fp)	# fill _tmp2343 to $t1 from $fp-4740
	  mul $t2, $t0, $t1	
	  sw $t2, -4744($fp)	# spill _tmp2344 from $t2 to $fp-4744
	# _tmp2345 = _tmp2344 + _tmp2343
	  lw $t0, -4744($fp)	# fill _tmp2344 to $t0 from $fp-4744
	  lw $t1, -4740($fp)	# fill _tmp2343 to $t1 from $fp-4740
	  add $t2, $t0, $t1	
	  sw $t2, -4748($fp)	# spill _tmp2345 from $t2 to $fp-4748
	# _tmp2346 = _tmp2333 + _tmp2345
	  lw $t0, -4700($fp)	# fill _tmp2333 to $t0 from $fp-4700
	  lw $t1, -4748($fp)	# fill _tmp2345 to $t1 from $fp-4748
	  add $t2, $t0, $t1	
	  sw $t2, -4752($fp)	# spill _tmp2346 from $t2 to $fp-4752
	# _tmp2347 = *(_tmp2346)
	  lw $t0, -4752($fp)	# fill _tmp2346 to $t0 from $fp-4752
	  lw $t2, 0($t0) 	# load with offset
	  sw $t2, -4756($fp)	# spill _tmp2347 from $t2 to $fp-4756
	# _tmp2348 = 2
	  li $t2, 2		# load constant value 2 into $t2
	  sw $t2, -4760($fp)	# spill _tmp2348 from $t2 to $fp-4760
	# _tmp2349 = 0
	  li $t2, 0		# load constant value 0 into $t2
	  sw $t2, -4764($fp)	# spill _tmp2349 from $t2 to $fp-4764
	# _tmp2350 = *(_tmp2347)
	  lw $t0, -4756($fp)	# fill _tmp2347 to $t0 from $fp-4756
	  lw $t2, 0($t0) 	# load with offset
	  sw $t2, -4768($fp)	# spill _tmp2350 from $t2 to $fp-4768
	# _tmp2351 = _tmp2348 < _tmp2349
	  lw $t0, -4760($fp)	# fill _tmp2348 to $t0 from $fp-4760
	  lw $t1, -4764($fp)	# fill _tmp2349 to $t1 from $fp-4764
	  slt $t2, $t0, $t1	
	  sw $t2, -4772($fp)	# spill _tmp2351 from $t2 to $fp-4772
	# _tmp2352 = _tmp2350 < _tmp2348
	  lw $t0, -4768($fp)	# fill _tmp2350 to $t0 from $fp-4768
	  lw $t1, -4760($fp)	# fill _tmp2348 to $t1 from $fp-4760
	  slt $t2, $t0, $t1	
	  sw $t2, -4776($fp)	# spill _tmp2352 from $t2 to $fp-4776
	# _tmp2353 = _tmp2350 == _tmp2348
	  lw $t0, -4768($fp)	# fill _tmp2350 to $t0 from $fp-4768
	  lw $t1, -4760($fp)	# fill _tmp2348 to $t1 from $fp-4760
	  seq $t2, $t0, $t1	
	  sw $t2, -4780($fp)	# spill _tmp2353 from $t2 to $fp-4780
	# _tmp2354 = _tmp2352 || _tmp2353
	  lw $t0, -4776($fp)	# fill _tmp2352 to $t0 from $fp-4776
	  lw $t1, -4780($fp)	# fill _tmp2353 to $t1 from $fp-4780
	  or $t2, $t0, $t1	
	  sw $t2, -4784($fp)	# spill _tmp2354 from $t2 to $fp-4784
	# _tmp2355 = _tmp2354 || _tmp2351
	  lw $t0, -4784($fp)	# fill _tmp2354 to $t0 from $fp-4784
	  lw $t1, -4772($fp)	# fill _tmp2351 to $t1 from $fp-4772
	  or $t2, $t0, $t1	
	  sw $t2, -4788($fp)	# spill _tmp2355 from $t2 to $fp-4788
	# IfZ _tmp2355 Goto _L228
	  lw $t0, -4788($fp)	# fill _tmp2355 to $t0 from $fp-4788
	  beqz $t0, _L228	# branch if _tmp2355 is zero 
	# _tmp2356 = "Decaf runtime error: Array subscript out of bound..."
	  .data			# create string constant marked with label
	  _string148: .asciiz "Decaf runtime error: Array subscript out of bounds\n"
	  .text
	  la $t2, _string148	# load label
	  sw $t2, -4792($fp)	# spill _tmp2356 from $t2 to $fp-4792
	# PushParam _tmp2356
	  subu $sp, $sp, 4	# decrement sp to make space for param
	  lw $t0, -4792($fp)	# fill _tmp2356 to $t0 from $fp-4792
	  sw $t0, 4($sp)	# copy param value to stack
	# LCall _PrintString
	  jal _PrintString   	# jump to function
	# PopParams 4
	  add $sp, $sp, 4	# pop params off stack
	# LCall _Halt
	  jal _Halt          	# jump to function
  _L228:
	# _tmp2357 = 4
	  li $t2, 4		# load constant value 4 into $t2
	  sw $t2, -4796($fp)	# spill _tmp2357 from $t2 to $fp-4796
	# _tmp2358 = _tmp2348 * _tmp2357
	  lw $t0, -4760($fp)	# fill _tmp2348 to $t0 from $fp-4760
	  lw $t1, -4796($fp)	# fill _tmp2357 to $t1 from $fp-4796
	  mul $t2, $t0, $t1	
	  sw $t2, -4800($fp)	# spill _tmp2358 from $t2 to $fp-4800
	# _tmp2359 = _tmp2358 + _tmp2357
	  lw $t0, -4800($fp)	# fill _tmp2358 to $t0 from $fp-4800
	  lw $t1, -4796($fp)	# fill _tmp2357 to $t1 from $fp-4796
	  add $t2, $t0, $t1	
	  sw $t2, -4804($fp)	# spill _tmp2359 from $t2 to $fp-4804
	# _tmp2360 = _tmp2347 + _tmp2359
	  lw $t0, -4756($fp)	# fill _tmp2347 to $t0 from $fp-4756
	  lw $t1, -4804($fp)	# fill _tmp2359 to $t1 from $fp-4804
	  add $t2, $t0, $t1	
	  sw $t2, -4808($fp)	# spill _tmp2360 from $t2 to $fp-4808
	# _tmp2361 = *(_tmp2360)
	  lw $t0, -4808($fp)	# fill _tmp2360 to $t0 from $fp-4808
	  lw $t2, 0($t0) 	# load with offset
	  sw $t2, -4812($fp)	# spill _tmp2361 from $t2 to $fp-4812
	# PushParam _tmp2361
	  subu $sp, $sp, 4	# decrement sp to make space for param
	  lw $t0, -4812($fp)	# fill _tmp2361 to $t0 from $fp-4812
	  sw $t0, 4($sp)	# copy param value to stack
	# _tmp2362 = *(_tmp2361)
	  lw $t0, -4812($fp)	# fill _tmp2361 to $t0 from $fp-4812
	  lw $t2, 0($t0) 	# load with offset
	  sw $t2, -4816($fp)	# spill _tmp2362 from $t2 to $fp-4816
	# _tmp2363 = *(_tmp2362 + 20)
	  lw $t0, -4816($fp)	# fill _tmp2362 to $t0 from $fp-4816
	  lw $t2, 20($t0) 	# load with offset
	  sw $t2, -4820($fp)	# spill _tmp2363 from $t2 to $fp-4820
	# _tmp2364 = ACall _tmp2363
	  lw $t0, -4820($fp)	# fill _tmp2363 to $t0 from $fp-4820
	  jalr $t0            	# jump to function
	  move $t2, $v0		# copy function return value from $v0
	  sw $t2, -4824($fp)	# spill _tmp2364 from $t2 to $fp-4824
	# PopParams 8
	  add $sp, $sp, 8	# pop params off stack
	# _tmp2365 = _tmp2332 && _tmp2364
	  lw $t0, -4696($fp)	# fill _tmp2332 to $t0 from $fp-4696
	  lw $t1, -4824($fp)	# fill _tmp2364 to $t1 from $fp-4824
	  and $t2, $t0, $t1	
	  sw $t2, -4828($fp)	# spill _tmp2365 from $t2 to $fp-4828
	# PushParam playerMark
	  subu $sp, $sp, 4	# decrement sp to make space for param
	  lw $t0, 12($fp)	# fill playerMark to $t0 from $fp+12
	  sw $t0, 4($sp)	# copy param value to stack
	# _tmp2367 = *(this + 4)
	  lw $t0, 4($fp)	# fill this to $t0 from $fp+4
	  lw $t2, 4($t0) 	# load with offset
	  sw $t2, -4836($fp)	# spill _tmp2367 from $t2 to $fp-4836
	# _tmp2368 = 0
	  li $t2, 0		# load constant value 0 into $t2
	  sw $t2, -4840($fp)	# spill _tmp2368 from $t2 to $fp-4840
	# _tmp2369 = 0
	  li $t2, 0		# load constant value 0 into $t2
	  sw $t2, -4844($fp)	# spill _tmp2369 from $t2 to $fp-4844
	# _tmp2370 = *(_tmp2367)
	  lw $t0, -4836($fp)	# fill _tmp2367 to $t0 from $fp-4836
	  lw $t2, 0($t0) 	# load with offset
	  sw $t2, -4848($fp)	# spill _tmp2370 from $t2 to $fp-4848
	# _tmp2371 = _tmp2368 < _tmp2369
	  lw $t0, -4840($fp)	# fill _tmp2368 to $t0 from $fp-4840
	  lw $t1, -4844($fp)	# fill _tmp2369 to $t1 from $fp-4844
	  slt $t2, $t0, $t1	
	  sw $t2, -4852($fp)	# spill _tmp2371 from $t2 to $fp-4852
	# _tmp2372 = _tmp2370 < _tmp2368
	  lw $t0, -4848($fp)	# fill _tmp2370 to $t0 from $fp-4848
	  lw $t1, -4840($fp)	# fill _tmp2368 to $t1 from $fp-4840
	  slt $t2, $t0, $t1	
	  sw $t2, -4856($fp)	# spill _tmp2372 from $t2 to $fp-4856
	# _tmp2373 = _tmp2370 == _tmp2368
	  lw $t0, -4848($fp)	# fill _tmp2370 to $t0 from $fp-4848
	  lw $t1, -4840($fp)	# fill _tmp2368 to $t1 from $fp-4840
	  seq $t2, $t0, $t1	
	  sw $t2, -4860($fp)	# spill _tmp2373 from $t2 to $fp-4860
	# _tmp2374 = _tmp2372 || _tmp2373
	  lw $t0, -4856($fp)	# fill _tmp2372 to $t0 from $fp-4856
	  lw $t1, -4860($fp)	# fill _tmp2373 to $t1 from $fp-4860
	  or $t2, $t0, $t1	
	  sw $t2, -4864($fp)	# spill _tmp2374 from $t2 to $fp-4864
	# _tmp2375 = _tmp2374 || _tmp2371
	  lw $t0, -4864($fp)	# fill _tmp2374 to $t0 from $fp-4864
	  lw $t1, -4852($fp)	# fill _tmp2371 to $t1 from $fp-4852
	  or $t2, $t0, $t1	
	  sw $t2, -4868($fp)	# spill _tmp2375 from $t2 to $fp-4868
	# IfZ _tmp2375 Goto _L231
	  lw $t0, -4868($fp)	# fill _tmp2375 to $t0 from $fp-4868
	  beqz $t0, _L231	# branch if _tmp2375 is zero 
	# _tmp2376 = "Decaf runtime error: Array subscript out of bound..."
	  .data			# create string constant marked with label
	  _string149: .asciiz "Decaf runtime error: Array subscript out of bounds\n"
	  .text
	  la $t2, _string149	# load label
	  sw $t2, -4872($fp)	# spill _tmp2376 from $t2 to $fp-4872
	# PushParam _tmp2376
	  subu $sp, $sp, 4	# decrement sp to make space for param
	  lw $t0, -4872($fp)	# fill _tmp2376 to $t0 from $fp-4872
	  sw $t0, 4($sp)	# copy param value to stack
	# LCall _PrintString
	  jal _PrintString   	# jump to function
	# PopParams 4
	  add $sp, $sp, 4	# pop params off stack
	# LCall _Halt
	  jal _Halt          	# jump to function
  _L231:
	# _tmp2377 = 4
	  li $t2, 4		# load constant value 4 into $t2
	  sw $t2, -4876($fp)	# spill _tmp2377 from $t2 to $fp-4876
	# _tmp2378 = _tmp2368 * _tmp2377
	  lw $t0, -4840($fp)	# fill _tmp2368 to $t0 from $fp-4840
	  lw $t1, -4876($fp)	# fill _tmp2377 to $t1 from $fp-4876
	  mul $t2, $t0, $t1	
	  sw $t2, -4880($fp)	# spill _tmp2378 from $t2 to $fp-4880
	# _tmp2379 = _tmp2378 + _tmp2377
	  lw $t0, -4880($fp)	# fill _tmp2378 to $t0 from $fp-4880
	  lw $t1, -4876($fp)	# fill _tmp2377 to $t1 from $fp-4876
	  add $t2, $t0, $t1	
	  sw $t2, -4884($fp)	# spill _tmp2379 from $t2 to $fp-4884
	# _tmp2380 = _tmp2367 + _tmp2379
	  lw $t0, -4836($fp)	# fill _tmp2367 to $t0 from $fp-4836
	  lw $t1, -4884($fp)	# fill _tmp2379 to $t1 from $fp-4884
	  add $t2, $t0, $t1	
	  sw $t2, -4888($fp)	# spill _tmp2380 from $t2 to $fp-4888
	# _tmp2381 = *(_tmp2380)
	  lw $t0, -4888($fp)	# fill _tmp2380 to $t0 from $fp-4888
	  lw $t2, 0($t0) 	# load with offset
	  sw $t2, -4892($fp)	# spill _tmp2381 from $t2 to $fp-4892
	# _tmp2382 = 2
	  li $t2, 2		# load constant value 2 into $t2
	  sw $t2, -4896($fp)	# spill _tmp2382 from $t2 to $fp-4896
	# _tmp2383 = 0
	  li $t2, 0		# load constant value 0 into $t2
	  sw $t2, -4900($fp)	# spill _tmp2383 from $t2 to $fp-4900
	# _tmp2384 = *(_tmp2381)
	  lw $t0, -4892($fp)	# fill _tmp2381 to $t0 from $fp-4892
	  lw $t2, 0($t0) 	# load with offset
	  sw $t2, -4904($fp)	# spill _tmp2384 from $t2 to $fp-4904
	# _tmp2385 = _tmp2382 < _tmp2383
	  lw $t0, -4896($fp)	# fill _tmp2382 to $t0 from $fp-4896
	  lw $t1, -4900($fp)	# fill _tmp2383 to $t1 from $fp-4900
	  slt $t2, $t0, $t1	
	  sw $t2, -4908($fp)	# spill _tmp2385 from $t2 to $fp-4908
	# _tmp2386 = _tmp2384 < _tmp2382
	  lw $t0, -4904($fp)	# fill _tmp2384 to $t0 from $fp-4904
	  lw $t1, -4896($fp)	# fill _tmp2382 to $t1 from $fp-4896
	  slt $t2, $t0, $t1	
	  sw $t2, -4912($fp)	# spill _tmp2386 from $t2 to $fp-4912
	# _tmp2387 = _tmp2384 == _tmp2382
	  lw $t0, -4904($fp)	# fill _tmp2384 to $t0 from $fp-4904
	  lw $t1, -4896($fp)	# fill _tmp2382 to $t1 from $fp-4896
	  seq $t2, $t0, $t1	
	  sw $t2, -4916($fp)	# spill _tmp2387 from $t2 to $fp-4916
	# _tmp2388 = _tmp2386 || _tmp2387
	  lw $t0, -4912($fp)	# fill _tmp2386 to $t0 from $fp-4912
	  lw $t1, -4916($fp)	# fill _tmp2387 to $t1 from $fp-4916
	  or $t2, $t0, $t1	
	  sw $t2, -4920($fp)	# spill _tmp2388 from $t2 to $fp-4920
	# _tmp2389 = _tmp2388 || _tmp2385
	  lw $t0, -4920($fp)	# fill _tmp2388 to $t0 from $fp-4920
	  lw $t1, -4908($fp)	# fill _tmp2385 to $t1 from $fp-4908
	  or $t2, $t0, $t1	
	  sw $t2, -4924($fp)	# spill _tmp2389 from $t2 to $fp-4924
	# IfZ _tmp2389 Goto _L232
	  lw $t0, -4924($fp)	# fill _tmp2389 to $t0 from $fp-4924
	  beqz $t0, _L232	# branch if _tmp2389 is zero 
	# _tmp2390 = "Decaf runtime error: Array subscript out of bound..."
	  .data			# create string constant marked with label
	  _string150: .asciiz "Decaf runtime error: Array subscript out of bounds\n"
	  .text
	  la $t2, _string150	# load label
	  sw $t2, -4928($fp)	# spill _tmp2390 from $t2 to $fp-4928
	# PushParam _tmp2390
	  subu $sp, $sp, 4	# decrement sp to make space for param
	  lw $t0, -4928($fp)	# fill _tmp2390 to $t0 from $fp-4928
	  sw $t0, 4($sp)	# copy param value to stack
	# LCall _PrintString
	  jal _PrintString   	# jump to function
	# PopParams 4
	  add $sp, $sp, 4	# pop params off stack
	# LCall _Halt
	  jal _Halt          	# jump to function
  _L232:
	# _tmp2391 = 4
	  li $t2, 4		# load constant value 4 into $t2
	  sw $t2, -4932($fp)	# spill _tmp2391 from $t2 to $fp-4932
	# _tmp2392 = _tmp2382 * _tmp2391
	  lw $t0, -4896($fp)	# fill _tmp2382 to $t0 from $fp-4896
	  lw $t1, -4932($fp)	# fill _tmp2391 to $t1 from $fp-4932
	  mul $t2, $t0, $t1	
	  sw $t2, -4936($fp)	# spill _tmp2392 from $t2 to $fp-4936
	# _tmp2393 = _tmp2392 + _tmp2391
	  lw $t0, -4936($fp)	# fill _tmp2392 to $t0 from $fp-4936
	  lw $t1, -4932($fp)	# fill _tmp2391 to $t1 from $fp-4932
	  add $t2, $t0, $t1	
	  sw $t2, -4940($fp)	# spill _tmp2393 from $t2 to $fp-4940
	# _tmp2394 = _tmp2381 + _tmp2393
	  lw $t0, -4892($fp)	# fill _tmp2381 to $t0 from $fp-4892
	  lw $t1, -4940($fp)	# fill _tmp2393 to $t1 from $fp-4940
	  add $t2, $t0, $t1	
	  sw $t2, -4944($fp)	# spill _tmp2394 from $t2 to $fp-4944
	# _tmp2395 = *(_tmp2394)
	  lw $t0, -4944($fp)	# fill _tmp2394 to $t0 from $fp-4944
	  lw $t2, 0($t0) 	# load with offset
	  sw $t2, -4948($fp)	# spill _tmp2395 from $t2 to $fp-4948
	# PushParam _tmp2395
	  subu $sp, $sp, 4	# decrement sp to make space for param
	  lw $t0, -4948($fp)	# fill _tmp2395 to $t0 from $fp-4948
	  sw $t0, 4($sp)	# copy param value to stack
	# _tmp2396 = *(_tmp2395)
	  lw $t0, -4948($fp)	# fill _tmp2395 to $t0 from $fp-4948
	  lw $t2, 0($t0) 	# load with offset
	  sw $t2, -4952($fp)	# spill _tmp2396 from $t2 to $fp-4952
	# _tmp2397 = *(_tmp2396 + 20)
	  lw $t0, -4952($fp)	# fill _tmp2396 to $t0 from $fp-4952
	  lw $t2, 20($t0) 	# load with offset
	  sw $t2, -4956($fp)	# spill _tmp2397 from $t2 to $fp-4956
	# _tmp2398 = ACall _tmp2397
	  lw $t0, -4956($fp)	# fill _tmp2397 to $t0 from $fp-4956
	  jalr $t0            	# jump to function
	  move $t2, $v0		# copy function return value from $v0
	  sw $t2, -4960($fp)	# spill _tmp2398 from $t2 to $fp-4960
	# PopParams 8
	  add $sp, $sp, 8	# pop params off stack
	# IfZ _tmp2398 Goto _L230
	  lw $t0, -4960($fp)	# fill _tmp2398 to $t0 from $fp-4960
	  beqz $t0, _L230	# branch if _tmp2398 is zero 
	# _tmp2399 = 0
	  li $t2, 0		# load constant value 0 into $t2
	  sw $t2, -4964($fp)	# spill _tmp2399 from $t2 to $fp-4964
	# _tmp2366 = _tmp2399
	  lw $t2, -4964($fp)	# fill _tmp2399 to $t2 from $fp-4964
	  sw $t2, -4832($fp)	# spill _tmp2366 from $t2 to $fp-4832
	# Goto _L229
	  b _L229		# unconditional branch
  _L230:
	# _tmp2400 = 1
	  li $t2, 1		# load constant value 1 into $t2
	  sw $t2, -4968($fp)	# spill _tmp2400 from $t2 to $fp-4968
	# _tmp2366 = _tmp2400
	  lw $t2, -4968($fp)	# fill _tmp2400 to $t2 from $fp-4968
	  sw $t2, -4832($fp)	# spill _tmp2366 from $t2 to $fp-4832
  _L229:
	# _tmp2401 = _tmp2365 && _tmp2366
	  lw $t0, -4828($fp)	# fill _tmp2365 to $t0 from $fp-4828
	  lw $t1, -4832($fp)	# fill _tmp2366 to $t1 from $fp-4832
	  and $t2, $t0, $t1	
	  sw $t2, -4972($fp)	# spill _tmp2401 from $t2 to $fp-4972
	# IfZ _tmp2401 Goto _L223
	  lw $t0, -4972($fp)	# fill _tmp2401 to $t0 from $fp-4972
	  beqz $t0, _L223	# branch if _tmp2401 is zero 
	# _tmp2402 = 0
	  li $t2, 0		# load constant value 0 into $t2
	  sw $t2, -4976($fp)	# spill _tmp2402 from $t2 to $fp-4976
	# row = _tmp2402
	  lw $t2, -4976($fp)	# fill _tmp2402 to $t2 from $fp-4976
	  sw $t2, -8($fp)	# spill row from $t2 to $fp-8
	# _tmp2403 = 2
	  li $t2, 2		# load constant value 2 into $t2
	  sw $t2, -4980($fp)	# spill _tmp2403 from $t2 to $fp-4980
	# column = _tmp2403
	  lw $t2, -4980($fp)	# fill _tmp2403 to $t2 from $fp-4980
	  sw $t2, -12($fp)	# spill column from $t2 to $fp-12
	# Goto _L224
	  b _L224		# unconditional branch
  _L223:
	# PushParam enemyMark
	  subu $sp, $sp, 4	# decrement sp to make space for param
	  lw $t0, 8($fp)	# fill enemyMark to $t0 from $fp+8
	  sw $t0, 4($sp)	# copy param value to stack
	# _tmp2404 = *(this + 4)
	  lw $t0, 4($fp)	# fill this to $t0 from $fp+4
	  lw $t2, 4($t0) 	# load with offset
	  sw $t2, -4984($fp)	# spill _tmp2404 from $t2 to $fp-4984
	# _tmp2405 = 0
	  li $t2, 0		# load constant value 0 into $t2
	  sw $t2, -4988($fp)	# spill _tmp2405 from $t2 to $fp-4988
	# _tmp2406 = 0
	  li $t2, 0		# load constant value 0 into $t2
	  sw $t2, -4992($fp)	# spill _tmp2406 from $t2 to $fp-4992
	# _tmp2407 = *(_tmp2404)
	  lw $t0, -4984($fp)	# fill _tmp2404 to $t0 from $fp-4984
	  lw $t2, 0($t0) 	# load with offset
	  sw $t2, -4996($fp)	# spill _tmp2407 from $t2 to $fp-4996
	# _tmp2408 = _tmp2405 < _tmp2406
	  lw $t0, -4988($fp)	# fill _tmp2405 to $t0 from $fp-4988
	  lw $t1, -4992($fp)	# fill _tmp2406 to $t1 from $fp-4992
	  slt $t2, $t0, $t1	
	  sw $t2, -5000($fp)	# spill _tmp2408 from $t2 to $fp-5000
	# _tmp2409 = _tmp2407 < _tmp2405
	  lw $t0, -4996($fp)	# fill _tmp2407 to $t0 from $fp-4996
	  lw $t1, -4988($fp)	# fill _tmp2405 to $t1 from $fp-4988
	  slt $t2, $t0, $t1	
	  sw $t2, -5004($fp)	# spill _tmp2409 from $t2 to $fp-5004
	# _tmp2410 = _tmp2407 == _tmp2405
	  lw $t0, -4996($fp)	# fill _tmp2407 to $t0 from $fp-4996
	  lw $t1, -4988($fp)	# fill _tmp2405 to $t1 from $fp-4988
	  seq $t2, $t0, $t1	
	  sw $t2, -5008($fp)	# spill _tmp2410 from $t2 to $fp-5008
	# _tmp2411 = _tmp2409 || _tmp2410
	  lw $t0, -5004($fp)	# fill _tmp2409 to $t0 from $fp-5004
	  lw $t1, -5008($fp)	# fill _tmp2410 to $t1 from $fp-5008
	  or $t2, $t0, $t1	
	  sw $t2, -5012($fp)	# spill _tmp2411 from $t2 to $fp-5012
	# _tmp2412 = _tmp2411 || _tmp2408
	  lw $t0, -5012($fp)	# fill _tmp2411 to $t0 from $fp-5012
	  lw $t1, -5000($fp)	# fill _tmp2408 to $t1 from $fp-5000
	  or $t2, $t0, $t1	
	  sw $t2, -5016($fp)	# spill _tmp2412 from $t2 to $fp-5016
	# IfZ _tmp2412 Goto _L235
	  lw $t0, -5016($fp)	# fill _tmp2412 to $t0 from $fp-5016
	  beqz $t0, _L235	# branch if _tmp2412 is zero 
	# _tmp2413 = "Decaf runtime error: Array subscript out of bound..."
	  .data			# create string constant marked with label
	  _string151: .asciiz "Decaf runtime error: Array subscript out of bounds\n"
	  .text
	  la $t2, _string151	# load label
	  sw $t2, -5020($fp)	# spill _tmp2413 from $t2 to $fp-5020
	# PushParam _tmp2413
	  subu $sp, $sp, 4	# decrement sp to make space for param
	  lw $t0, -5020($fp)	# fill _tmp2413 to $t0 from $fp-5020
	  sw $t0, 4($sp)	# copy param value to stack
	# LCall _PrintString
	  jal _PrintString   	# jump to function
	# PopParams 4
	  add $sp, $sp, 4	# pop params off stack
	# LCall _Halt
	  jal _Halt          	# jump to function
  _L235:
	# _tmp2414 = 4
	  li $t2, 4		# load constant value 4 into $t2
	  sw $t2, -5024($fp)	# spill _tmp2414 from $t2 to $fp-5024
	# _tmp2415 = _tmp2405 * _tmp2414
	  lw $t0, -4988($fp)	# fill _tmp2405 to $t0 from $fp-4988
	  lw $t1, -5024($fp)	# fill _tmp2414 to $t1 from $fp-5024
	  mul $t2, $t0, $t1	
	  sw $t2, -5028($fp)	# spill _tmp2415 from $t2 to $fp-5028
	# _tmp2416 = _tmp2415 + _tmp2414
	  lw $t0, -5028($fp)	# fill _tmp2415 to $t0 from $fp-5028
	  lw $t1, -5024($fp)	# fill _tmp2414 to $t1 from $fp-5024
	  add $t2, $t0, $t1	
	  sw $t2, -5032($fp)	# spill _tmp2416 from $t2 to $fp-5032
	# _tmp2417 = _tmp2404 + _tmp2416
	  lw $t0, -4984($fp)	# fill _tmp2404 to $t0 from $fp-4984
	  lw $t1, -5032($fp)	# fill _tmp2416 to $t1 from $fp-5032
	  add $t2, $t0, $t1	
	  sw $t2, -5036($fp)	# spill _tmp2417 from $t2 to $fp-5036
	# _tmp2418 = *(_tmp2417)
	  lw $t0, -5036($fp)	# fill _tmp2417 to $t0 from $fp-5036
	  lw $t2, 0($t0) 	# load with offset
	  sw $t2, -5040($fp)	# spill _tmp2418 from $t2 to $fp-5040
	# _tmp2419 = 0
	  li $t2, 0		# load constant value 0 into $t2
	  sw $t2, -5044($fp)	# spill _tmp2419 from $t2 to $fp-5044
	# _tmp2420 = 0
	  li $t2, 0		# load constant value 0 into $t2
	  sw $t2, -5048($fp)	# spill _tmp2420 from $t2 to $fp-5048
	# _tmp2421 = *(_tmp2418)
	  lw $t0, -5040($fp)	# fill _tmp2418 to $t0 from $fp-5040
	  lw $t2, 0($t0) 	# load with offset
	  sw $t2, -5052($fp)	# spill _tmp2421 from $t2 to $fp-5052
	# _tmp2422 = _tmp2419 < _tmp2420
	  lw $t0, -5044($fp)	# fill _tmp2419 to $t0 from $fp-5044
	  lw $t1, -5048($fp)	# fill _tmp2420 to $t1 from $fp-5048
	  slt $t2, $t0, $t1	
	  sw $t2, -5056($fp)	# spill _tmp2422 from $t2 to $fp-5056
	# _tmp2423 = _tmp2421 < _tmp2419
	  lw $t0, -5052($fp)	# fill _tmp2421 to $t0 from $fp-5052
	  lw $t1, -5044($fp)	# fill _tmp2419 to $t1 from $fp-5044
	  slt $t2, $t0, $t1	
	  sw $t2, -5060($fp)	# spill _tmp2423 from $t2 to $fp-5060
	# _tmp2424 = _tmp2421 == _tmp2419
	  lw $t0, -5052($fp)	# fill _tmp2421 to $t0 from $fp-5052
	  lw $t1, -5044($fp)	# fill _tmp2419 to $t1 from $fp-5044
	  seq $t2, $t0, $t1	
	  sw $t2, -5064($fp)	# spill _tmp2424 from $t2 to $fp-5064
	# _tmp2425 = _tmp2423 || _tmp2424
	  lw $t0, -5060($fp)	# fill _tmp2423 to $t0 from $fp-5060
	  lw $t1, -5064($fp)	# fill _tmp2424 to $t1 from $fp-5064
	  or $t2, $t0, $t1	
	  sw $t2, -5068($fp)	# spill _tmp2425 from $t2 to $fp-5068
	# _tmp2426 = _tmp2425 || _tmp2422
	  lw $t0, -5068($fp)	# fill _tmp2425 to $t0 from $fp-5068
	  lw $t1, -5056($fp)	# fill _tmp2422 to $t1 from $fp-5056
	  or $t2, $t0, $t1	
	  sw $t2, -5072($fp)	# spill _tmp2426 from $t2 to $fp-5072
	# IfZ _tmp2426 Goto _L236
	  lw $t0, -5072($fp)	# fill _tmp2426 to $t0 from $fp-5072
	  beqz $t0, _L236	# branch if _tmp2426 is zero 
	# _tmp2427 = "Decaf runtime error: Array subscript out of bound..."
	  .data			# create string constant marked with label
	  _string152: .asciiz "Decaf runtime error: Array subscript out of bounds\n"
	  .text
	  la $t2, _string152	# load label
	  sw $t2, -5076($fp)	# spill _tmp2427 from $t2 to $fp-5076
	# PushParam _tmp2427
	  subu $sp, $sp, 4	# decrement sp to make space for param
	  lw $t0, -5076($fp)	# fill _tmp2427 to $t0 from $fp-5076
	  sw $t0, 4($sp)	# copy param value to stack
	# LCall _PrintString
	  jal _PrintString   	# jump to function
	# PopParams 4
	  add $sp, $sp, 4	# pop params off stack
	# LCall _Halt
	  jal _Halt          	# jump to function
  _L236:
	# _tmp2428 = 4
	  li $t2, 4		# load constant value 4 into $t2
	  sw $t2, -5080($fp)	# spill _tmp2428 from $t2 to $fp-5080
	# _tmp2429 = _tmp2419 * _tmp2428
	  lw $t0, -5044($fp)	# fill _tmp2419 to $t0 from $fp-5044
	  lw $t1, -5080($fp)	# fill _tmp2428 to $t1 from $fp-5080
	  mul $t2, $t0, $t1	
	  sw $t2, -5084($fp)	# spill _tmp2429 from $t2 to $fp-5084
	# _tmp2430 = _tmp2429 + _tmp2428
	  lw $t0, -5084($fp)	# fill _tmp2429 to $t0 from $fp-5084
	  lw $t1, -5080($fp)	# fill _tmp2428 to $t1 from $fp-5080
	  add $t2, $t0, $t1	
	  sw $t2, -5088($fp)	# spill _tmp2430 from $t2 to $fp-5088
	# _tmp2431 = _tmp2418 + _tmp2430
	  lw $t0, -5040($fp)	# fill _tmp2418 to $t0 from $fp-5040
	  lw $t1, -5088($fp)	# fill _tmp2430 to $t1 from $fp-5088
	  add $t2, $t0, $t1	
	  sw $t2, -5092($fp)	# spill _tmp2431 from $t2 to $fp-5092
	# _tmp2432 = *(_tmp2431)
	  lw $t0, -5092($fp)	# fill _tmp2431 to $t0 from $fp-5092
	  lw $t2, 0($t0) 	# load with offset
	  sw $t2, -5096($fp)	# spill _tmp2432 from $t2 to $fp-5096
	# PushParam _tmp2432
	  subu $sp, $sp, 4	# decrement sp to make space for param
	  lw $t0, -5096($fp)	# fill _tmp2432 to $t0 from $fp-5096
	  sw $t0, 4($sp)	# copy param value to stack
	# _tmp2433 = *(_tmp2432)
	  lw $t0, -5096($fp)	# fill _tmp2432 to $t0 from $fp-5096
	  lw $t2, 0($t0) 	# load with offset
	  sw $t2, -5100($fp)	# spill _tmp2433 from $t2 to $fp-5100
	# _tmp2434 = *(_tmp2433 + 20)
	  lw $t0, -5100($fp)	# fill _tmp2433 to $t0 from $fp-5100
	  lw $t2, 20($t0) 	# load with offset
	  sw $t2, -5104($fp)	# spill _tmp2434 from $t2 to $fp-5104
	# _tmp2435 = ACall _tmp2434
	  lw $t0, -5104($fp)	# fill _tmp2434 to $t0 from $fp-5104
	  jalr $t0            	# jump to function
	  move $t2, $v0		# copy function return value from $v0
	  sw $t2, -5108($fp)	# spill _tmp2435 from $t2 to $fp-5108
	# PopParams 8
	  add $sp, $sp, 8	# pop params off stack
	# PushParam enemyMark
	  subu $sp, $sp, 4	# decrement sp to make space for param
	  lw $t0, 8($fp)	# fill enemyMark to $t0 from $fp+8
	  sw $t0, 4($sp)	# copy param value to stack
	# _tmp2436 = *(this + 4)
	  lw $t0, 4($fp)	# fill this to $t0 from $fp+4
	  lw $t2, 4($t0) 	# load with offset
	  sw $t2, -5112($fp)	# spill _tmp2436 from $t2 to $fp-5112
	# _tmp2437 = 1
	  li $t2, 1		# load constant value 1 into $t2
	  sw $t2, -5116($fp)	# spill _tmp2437 from $t2 to $fp-5116
	# _tmp2438 = 0
	  li $t2, 0		# load constant value 0 into $t2
	  sw $t2, -5120($fp)	# spill _tmp2438 from $t2 to $fp-5120
	# _tmp2439 = *(_tmp2436)
	  lw $t0, -5112($fp)	# fill _tmp2436 to $t0 from $fp-5112
	  lw $t2, 0($t0) 	# load with offset
	  sw $t2, -5124($fp)	# spill _tmp2439 from $t2 to $fp-5124
	# _tmp2440 = _tmp2437 < _tmp2438
	  lw $t0, -5116($fp)	# fill _tmp2437 to $t0 from $fp-5116
	  lw $t1, -5120($fp)	# fill _tmp2438 to $t1 from $fp-5120
	  slt $t2, $t0, $t1	
	  sw $t2, -5128($fp)	# spill _tmp2440 from $t2 to $fp-5128
	# _tmp2441 = _tmp2439 < _tmp2437
	  lw $t0, -5124($fp)	# fill _tmp2439 to $t0 from $fp-5124
	  lw $t1, -5116($fp)	# fill _tmp2437 to $t1 from $fp-5116
	  slt $t2, $t0, $t1	
	  sw $t2, -5132($fp)	# spill _tmp2441 from $t2 to $fp-5132
	# _tmp2442 = _tmp2439 == _tmp2437
	  lw $t0, -5124($fp)	# fill _tmp2439 to $t0 from $fp-5124
	  lw $t1, -5116($fp)	# fill _tmp2437 to $t1 from $fp-5116
	  seq $t2, $t0, $t1	
	  sw $t2, -5136($fp)	# spill _tmp2442 from $t2 to $fp-5136
	# _tmp2443 = _tmp2441 || _tmp2442
	  lw $t0, -5132($fp)	# fill _tmp2441 to $t0 from $fp-5132
	  lw $t1, -5136($fp)	# fill _tmp2442 to $t1 from $fp-5136
	  or $t2, $t0, $t1	
	  sw $t2, -5140($fp)	# spill _tmp2443 from $t2 to $fp-5140
	# _tmp2444 = _tmp2443 || _tmp2440
	  lw $t0, -5140($fp)	# fill _tmp2443 to $t0 from $fp-5140
	  lw $t1, -5128($fp)	# fill _tmp2440 to $t1 from $fp-5128
	  or $t2, $t0, $t1	
	  sw $t2, -5144($fp)	# spill _tmp2444 from $t2 to $fp-5144
	# IfZ _tmp2444 Goto _L237
	  lw $t0, -5144($fp)	# fill _tmp2444 to $t0 from $fp-5144
	  beqz $t0, _L237	# branch if _tmp2444 is zero 
	# _tmp2445 = "Decaf runtime error: Array subscript out of bound..."
	  .data			# create string constant marked with label
	  _string153: .asciiz "Decaf runtime error: Array subscript out of bounds\n"
	  .text
	  la $t2, _string153	# load label
	  sw $t2, -5148($fp)	# spill _tmp2445 from $t2 to $fp-5148
	# PushParam _tmp2445
	  subu $sp, $sp, 4	# decrement sp to make space for param
	  lw $t0, -5148($fp)	# fill _tmp2445 to $t0 from $fp-5148
	  sw $t0, 4($sp)	# copy param value to stack
	# LCall _PrintString
	  jal _PrintString   	# jump to function
	# PopParams 4
	  add $sp, $sp, 4	# pop params off stack
	# LCall _Halt
	  jal _Halt          	# jump to function
  _L237:
	# _tmp2446 = 4
	  li $t2, 4		# load constant value 4 into $t2
	  sw $t2, -5152($fp)	# spill _tmp2446 from $t2 to $fp-5152
	# _tmp2447 = _tmp2437 * _tmp2446
	  lw $t0, -5116($fp)	# fill _tmp2437 to $t0 from $fp-5116
	  lw $t1, -5152($fp)	# fill _tmp2446 to $t1 from $fp-5152
	  mul $t2, $t0, $t1	
	  sw $t2, -5156($fp)	# spill _tmp2447 from $t2 to $fp-5156
	# _tmp2448 = _tmp2447 + _tmp2446
	  lw $t0, -5156($fp)	# fill _tmp2447 to $t0 from $fp-5156
	  lw $t1, -5152($fp)	# fill _tmp2446 to $t1 from $fp-5152
	  add $t2, $t0, $t1	
	  sw $t2, -5160($fp)	# spill _tmp2448 from $t2 to $fp-5160
	# _tmp2449 = _tmp2436 + _tmp2448
	  lw $t0, -5112($fp)	# fill _tmp2436 to $t0 from $fp-5112
	  lw $t1, -5160($fp)	# fill _tmp2448 to $t1 from $fp-5160
	  add $t2, $t0, $t1	
	  sw $t2, -5164($fp)	# spill _tmp2449 from $t2 to $fp-5164
	# _tmp2450 = *(_tmp2449)
	  lw $t0, -5164($fp)	# fill _tmp2449 to $t0 from $fp-5164
	  lw $t2, 0($t0) 	# load with offset
	  sw $t2, -5168($fp)	# spill _tmp2450 from $t2 to $fp-5168
	# _tmp2451 = 1
	  li $t2, 1		# load constant value 1 into $t2
	  sw $t2, -5172($fp)	# spill _tmp2451 from $t2 to $fp-5172
	# _tmp2452 = 0
	  li $t2, 0		# load constant value 0 into $t2
	  sw $t2, -5176($fp)	# spill _tmp2452 from $t2 to $fp-5176
	# _tmp2453 = *(_tmp2450)
	  lw $t0, -5168($fp)	# fill _tmp2450 to $t0 from $fp-5168
	  lw $t2, 0($t0) 	# load with offset
	  sw $t2, -5180($fp)	# spill _tmp2453 from $t2 to $fp-5180
	# _tmp2454 = _tmp2451 < _tmp2452
	  lw $t0, -5172($fp)	# fill _tmp2451 to $t0 from $fp-5172
	  lw $t1, -5176($fp)	# fill _tmp2452 to $t1 from $fp-5176
	  slt $t2, $t0, $t1	
	  sw $t2, -5184($fp)	# spill _tmp2454 from $t2 to $fp-5184
	# _tmp2455 = _tmp2453 < _tmp2451
	  lw $t0, -5180($fp)	# fill _tmp2453 to $t0 from $fp-5180
	  lw $t1, -5172($fp)	# fill _tmp2451 to $t1 from $fp-5172
	  slt $t2, $t0, $t1	
	  sw $t2, -5188($fp)	# spill _tmp2455 from $t2 to $fp-5188
	# _tmp2456 = _tmp2453 == _tmp2451
	  lw $t0, -5180($fp)	# fill _tmp2453 to $t0 from $fp-5180
	  lw $t1, -5172($fp)	# fill _tmp2451 to $t1 from $fp-5172
	  seq $t2, $t0, $t1	
	  sw $t2, -5192($fp)	# spill _tmp2456 from $t2 to $fp-5192
	# _tmp2457 = _tmp2455 || _tmp2456
	  lw $t0, -5188($fp)	# fill _tmp2455 to $t0 from $fp-5188
	  lw $t1, -5192($fp)	# fill _tmp2456 to $t1 from $fp-5192
	  or $t2, $t0, $t1	
	  sw $t2, -5196($fp)	# spill _tmp2457 from $t2 to $fp-5196
	# _tmp2458 = _tmp2457 || _tmp2454
	  lw $t0, -5196($fp)	# fill _tmp2457 to $t0 from $fp-5196
	  lw $t1, -5184($fp)	# fill _tmp2454 to $t1 from $fp-5184
	  or $t2, $t0, $t1	
	  sw $t2, -5200($fp)	# spill _tmp2458 from $t2 to $fp-5200
	# IfZ _tmp2458 Goto _L238
	  lw $t0, -5200($fp)	# fill _tmp2458 to $t0 from $fp-5200
	  beqz $t0, _L238	# branch if _tmp2458 is zero 
	# _tmp2459 = "Decaf runtime error: Array subscript out of bound..."
	  .data			# create string constant marked with label
	  _string154: .asciiz "Decaf runtime error: Array subscript out of bounds\n"
	  .text
	  la $t2, _string154	# load label
	  sw $t2, -5204($fp)	# spill _tmp2459 from $t2 to $fp-5204
	# PushParam _tmp2459
	  subu $sp, $sp, 4	# decrement sp to make space for param
	  lw $t0, -5204($fp)	# fill _tmp2459 to $t0 from $fp-5204
	  sw $t0, 4($sp)	# copy param value to stack
	# LCall _PrintString
	  jal _PrintString   	# jump to function
	# PopParams 4
	  add $sp, $sp, 4	# pop params off stack
	# LCall _Halt
	  jal _Halt          	# jump to function
  _L238:
	# _tmp2460 = 4
	  li $t2, 4		# load constant value 4 into $t2
	  sw $t2, -5208($fp)	# spill _tmp2460 from $t2 to $fp-5208
	# _tmp2461 = _tmp2451 * _tmp2460
	  lw $t0, -5172($fp)	# fill _tmp2451 to $t0 from $fp-5172
	  lw $t1, -5208($fp)	# fill _tmp2460 to $t1 from $fp-5208
	  mul $t2, $t0, $t1	
	  sw $t2, -5212($fp)	# spill _tmp2461 from $t2 to $fp-5212
	# _tmp2462 = _tmp2461 + _tmp2460
	  lw $t0, -5212($fp)	# fill _tmp2461 to $t0 from $fp-5212
	  lw $t1, -5208($fp)	# fill _tmp2460 to $t1 from $fp-5208
	  add $t2, $t0, $t1	
	  sw $t2, -5216($fp)	# spill _tmp2462 from $t2 to $fp-5216
	# _tmp2463 = _tmp2450 + _tmp2462
	  lw $t0, -5168($fp)	# fill _tmp2450 to $t0 from $fp-5168
	  lw $t1, -5216($fp)	# fill _tmp2462 to $t1 from $fp-5216
	  add $t2, $t0, $t1	
	  sw $t2, -5220($fp)	# spill _tmp2463 from $t2 to $fp-5220
	# _tmp2464 = *(_tmp2463)
	  lw $t0, -5220($fp)	# fill _tmp2463 to $t0 from $fp-5220
	  lw $t2, 0($t0) 	# load with offset
	  sw $t2, -5224($fp)	# spill _tmp2464 from $t2 to $fp-5224
	# PushParam _tmp2464
	  subu $sp, $sp, 4	# decrement sp to make space for param
	  lw $t0, -5224($fp)	# fill _tmp2464 to $t0 from $fp-5224
	  sw $t0, 4($sp)	# copy param value to stack
	# _tmp2465 = *(_tmp2464)
	  lw $t0, -5224($fp)	# fill _tmp2464 to $t0 from $fp-5224
	  lw $t2, 0($t0) 	# load with offset
	  sw $t2, -5228($fp)	# spill _tmp2465 from $t2 to $fp-5228
	# _tmp2466 = *(_tmp2465 + 20)
	  lw $t0, -5228($fp)	# fill _tmp2465 to $t0 from $fp-5228
	  lw $t2, 20($t0) 	# load with offset
	  sw $t2, -5232($fp)	# spill _tmp2466 from $t2 to $fp-5232
	# _tmp2467 = ACall _tmp2466
	  lw $t0, -5232($fp)	# fill _tmp2466 to $t0 from $fp-5232
	  jalr $t0            	# jump to function
	  move $t2, $v0		# copy function return value from $v0
	  sw $t2, -5236($fp)	# spill _tmp2467 from $t2 to $fp-5236
	# PopParams 8
	  add $sp, $sp, 8	# pop params off stack
	# _tmp2468 = _tmp2435 && _tmp2467
	  lw $t0, -5108($fp)	# fill _tmp2435 to $t0 from $fp-5108
	  lw $t1, -5236($fp)	# fill _tmp2467 to $t1 from $fp-5236
	  and $t2, $t0, $t1	
	  sw $t2, -5240($fp)	# spill _tmp2468 from $t2 to $fp-5240
	# PushParam playerMark
	  subu $sp, $sp, 4	# decrement sp to make space for param
	  lw $t0, 12($fp)	# fill playerMark to $t0 from $fp+12
	  sw $t0, 4($sp)	# copy param value to stack
	# _tmp2470 = *(this + 4)
	  lw $t0, 4($fp)	# fill this to $t0 from $fp+4
	  lw $t2, 4($t0) 	# load with offset
	  sw $t2, -5248($fp)	# spill _tmp2470 from $t2 to $fp-5248
	# _tmp2471 = 2
	  li $t2, 2		# load constant value 2 into $t2
	  sw $t2, -5252($fp)	# spill _tmp2471 from $t2 to $fp-5252
	# _tmp2472 = 0
	  li $t2, 0		# load constant value 0 into $t2
	  sw $t2, -5256($fp)	# spill _tmp2472 from $t2 to $fp-5256
	# _tmp2473 = *(_tmp2470)
	  lw $t0, -5248($fp)	# fill _tmp2470 to $t0 from $fp-5248
	  lw $t2, 0($t0) 	# load with offset
	  sw $t2, -5260($fp)	# spill _tmp2473 from $t2 to $fp-5260
	# _tmp2474 = _tmp2471 < _tmp2472
	  lw $t0, -5252($fp)	# fill _tmp2471 to $t0 from $fp-5252
	  lw $t1, -5256($fp)	# fill _tmp2472 to $t1 from $fp-5256
	  slt $t2, $t0, $t1	
	  sw $t2, -5264($fp)	# spill _tmp2474 from $t2 to $fp-5264
	# _tmp2475 = _tmp2473 < _tmp2471
	  lw $t0, -5260($fp)	# fill _tmp2473 to $t0 from $fp-5260
	  lw $t1, -5252($fp)	# fill _tmp2471 to $t1 from $fp-5252
	  slt $t2, $t0, $t1	
	  sw $t2, -5268($fp)	# spill _tmp2475 from $t2 to $fp-5268
	# _tmp2476 = _tmp2473 == _tmp2471
	  lw $t0, -5260($fp)	# fill _tmp2473 to $t0 from $fp-5260
	  lw $t1, -5252($fp)	# fill _tmp2471 to $t1 from $fp-5252
	  seq $t2, $t0, $t1	
	  sw $t2, -5272($fp)	# spill _tmp2476 from $t2 to $fp-5272
	# _tmp2477 = _tmp2475 || _tmp2476
	  lw $t0, -5268($fp)	# fill _tmp2475 to $t0 from $fp-5268
	  lw $t1, -5272($fp)	# fill _tmp2476 to $t1 from $fp-5272
	  or $t2, $t0, $t1	
	  sw $t2, -5276($fp)	# spill _tmp2477 from $t2 to $fp-5276
	# _tmp2478 = _tmp2477 || _tmp2474
	  lw $t0, -5276($fp)	# fill _tmp2477 to $t0 from $fp-5276
	  lw $t1, -5264($fp)	# fill _tmp2474 to $t1 from $fp-5264
	  or $t2, $t0, $t1	
	  sw $t2, -5280($fp)	# spill _tmp2478 from $t2 to $fp-5280
	# IfZ _tmp2478 Goto _L241
	  lw $t0, -5280($fp)	# fill _tmp2478 to $t0 from $fp-5280
	  beqz $t0, _L241	# branch if _tmp2478 is zero 
	# _tmp2479 = "Decaf runtime error: Array subscript out of bound..."
	  .data			# create string constant marked with label
	  _string155: .asciiz "Decaf runtime error: Array subscript out of bounds\n"
	  .text
	  la $t2, _string155	# load label
	  sw $t2, -5284($fp)	# spill _tmp2479 from $t2 to $fp-5284
	# PushParam _tmp2479
	  subu $sp, $sp, 4	# decrement sp to make space for param
	  lw $t0, -5284($fp)	# fill _tmp2479 to $t0 from $fp-5284
	  sw $t0, 4($sp)	# copy param value to stack
	# LCall _PrintString
	  jal _PrintString   	# jump to function
	# PopParams 4
	  add $sp, $sp, 4	# pop params off stack
	# LCall _Halt
	  jal _Halt          	# jump to function
  _L241:
	# _tmp2480 = 4
	  li $t2, 4		# load constant value 4 into $t2
	  sw $t2, -5288($fp)	# spill _tmp2480 from $t2 to $fp-5288
	# _tmp2481 = _tmp2471 * _tmp2480
	  lw $t0, -5252($fp)	# fill _tmp2471 to $t0 from $fp-5252
	  lw $t1, -5288($fp)	# fill _tmp2480 to $t1 from $fp-5288
	  mul $t2, $t0, $t1	
	  sw $t2, -5292($fp)	# spill _tmp2481 from $t2 to $fp-5292
	# _tmp2482 = _tmp2481 + _tmp2480
	  lw $t0, -5292($fp)	# fill _tmp2481 to $t0 from $fp-5292
	  lw $t1, -5288($fp)	# fill _tmp2480 to $t1 from $fp-5288
	  add $t2, $t0, $t1	
	  sw $t2, -5296($fp)	# spill _tmp2482 from $t2 to $fp-5296
	# _tmp2483 = _tmp2470 + _tmp2482
	  lw $t0, -5248($fp)	# fill _tmp2470 to $t0 from $fp-5248
	  lw $t1, -5296($fp)	# fill _tmp2482 to $t1 from $fp-5296
	  add $t2, $t0, $t1	
	  sw $t2, -5300($fp)	# spill _tmp2483 from $t2 to $fp-5300
	# _tmp2484 = *(_tmp2483)
	  lw $t0, -5300($fp)	# fill _tmp2483 to $t0 from $fp-5300
	  lw $t2, 0($t0) 	# load with offset
	  sw $t2, -5304($fp)	# spill _tmp2484 from $t2 to $fp-5304
	# _tmp2485 = 2
	  li $t2, 2		# load constant value 2 into $t2
	  sw $t2, -5308($fp)	# spill _tmp2485 from $t2 to $fp-5308
	# _tmp2486 = 0
	  li $t2, 0		# load constant value 0 into $t2
	  sw $t2, -5312($fp)	# spill _tmp2486 from $t2 to $fp-5312
	# _tmp2487 = *(_tmp2484)
	  lw $t0, -5304($fp)	# fill _tmp2484 to $t0 from $fp-5304
	  lw $t2, 0($t0) 	# load with offset
	  sw $t2, -5316($fp)	# spill _tmp2487 from $t2 to $fp-5316
	# _tmp2488 = _tmp2485 < _tmp2486
	  lw $t0, -5308($fp)	# fill _tmp2485 to $t0 from $fp-5308
	  lw $t1, -5312($fp)	# fill _tmp2486 to $t1 from $fp-5312
	  slt $t2, $t0, $t1	
	  sw $t2, -5320($fp)	# spill _tmp2488 from $t2 to $fp-5320
	# _tmp2489 = _tmp2487 < _tmp2485
	  lw $t0, -5316($fp)	# fill _tmp2487 to $t0 from $fp-5316
	  lw $t1, -5308($fp)	# fill _tmp2485 to $t1 from $fp-5308
	  slt $t2, $t0, $t1	
	  sw $t2, -5324($fp)	# spill _tmp2489 from $t2 to $fp-5324
	# _tmp2490 = _tmp2487 == _tmp2485
	  lw $t0, -5316($fp)	# fill _tmp2487 to $t0 from $fp-5316
	  lw $t1, -5308($fp)	# fill _tmp2485 to $t1 from $fp-5308
	  seq $t2, $t0, $t1	
	  sw $t2, -5328($fp)	# spill _tmp2490 from $t2 to $fp-5328
	# _tmp2491 = _tmp2489 || _tmp2490
	  lw $t0, -5324($fp)	# fill _tmp2489 to $t0 from $fp-5324
	  lw $t1, -5328($fp)	# fill _tmp2490 to $t1 from $fp-5328
	  or $t2, $t0, $t1	
	  sw $t2, -5332($fp)	# spill _tmp2491 from $t2 to $fp-5332
	# _tmp2492 = _tmp2491 || _tmp2488
	  lw $t0, -5332($fp)	# fill _tmp2491 to $t0 from $fp-5332
	  lw $t1, -5320($fp)	# fill _tmp2488 to $t1 from $fp-5320
	  or $t2, $t0, $t1	
	  sw $t2, -5336($fp)	# spill _tmp2492 from $t2 to $fp-5336
	# IfZ _tmp2492 Goto _L242
	  lw $t0, -5336($fp)	# fill _tmp2492 to $t0 from $fp-5336
	  beqz $t0, _L242	# branch if _tmp2492 is zero 
	# _tmp2493 = "Decaf runtime error: Array subscript out of bound..."
	  .data			# create string constant marked with label
	  _string156: .asciiz "Decaf runtime error: Array subscript out of bounds\n"
	  .text
	  la $t2, _string156	# load label
	  sw $t2, -5340($fp)	# spill _tmp2493 from $t2 to $fp-5340
	# PushParam _tmp2493
	  subu $sp, $sp, 4	# decrement sp to make space for param
	  lw $t0, -5340($fp)	# fill _tmp2493 to $t0 from $fp-5340
	  sw $t0, 4($sp)	# copy param value to stack
	# LCall _PrintString
	  jal _PrintString   	# jump to function
	# PopParams 4
	  add $sp, $sp, 4	# pop params off stack
	# LCall _Halt
	  jal _Halt          	# jump to function
  _L242:
	# _tmp2494 = 4
	  li $t2, 4		# load constant value 4 into $t2
	  sw $t2, -5344($fp)	# spill _tmp2494 from $t2 to $fp-5344
	# _tmp2495 = _tmp2485 * _tmp2494
	  lw $t0, -5308($fp)	# fill _tmp2485 to $t0 from $fp-5308
	  lw $t1, -5344($fp)	# fill _tmp2494 to $t1 from $fp-5344
	  mul $t2, $t0, $t1	
	  sw $t2, -5348($fp)	# spill _tmp2495 from $t2 to $fp-5348
	# _tmp2496 = _tmp2495 + _tmp2494
	  lw $t0, -5348($fp)	# fill _tmp2495 to $t0 from $fp-5348
	  lw $t1, -5344($fp)	# fill _tmp2494 to $t1 from $fp-5344
	  add $t2, $t0, $t1	
	  sw $t2, -5352($fp)	# spill _tmp2496 from $t2 to $fp-5352
	# _tmp2497 = _tmp2484 + _tmp2496
	  lw $t0, -5304($fp)	# fill _tmp2484 to $t0 from $fp-5304
	  lw $t1, -5352($fp)	# fill _tmp2496 to $t1 from $fp-5352
	  add $t2, $t0, $t1	
	  sw $t2, -5356($fp)	# spill _tmp2497 from $t2 to $fp-5356
	# _tmp2498 = *(_tmp2497)
	  lw $t0, -5356($fp)	# fill _tmp2497 to $t0 from $fp-5356
	  lw $t2, 0($t0) 	# load with offset
	  sw $t2, -5360($fp)	# spill _tmp2498 from $t2 to $fp-5360
	# PushParam _tmp2498
	  subu $sp, $sp, 4	# decrement sp to make space for param
	  lw $t0, -5360($fp)	# fill _tmp2498 to $t0 from $fp-5360
	  sw $t0, 4($sp)	# copy param value to stack
	# _tmp2499 = *(_tmp2498)
	  lw $t0, -5360($fp)	# fill _tmp2498 to $t0 from $fp-5360
	  lw $t2, 0($t0) 	# load with offset
	  sw $t2, -5364($fp)	# spill _tmp2499 from $t2 to $fp-5364
	# _tmp2500 = *(_tmp2499 + 20)
	  lw $t0, -5364($fp)	# fill _tmp2499 to $t0 from $fp-5364
	  lw $t2, 20($t0) 	# load with offset
	  sw $t2, -5368($fp)	# spill _tmp2500 from $t2 to $fp-5368
	# _tmp2501 = ACall _tmp2500
	  lw $t0, -5368($fp)	# fill _tmp2500 to $t0 from $fp-5368
	  jalr $t0            	# jump to function
	  move $t2, $v0		# copy function return value from $v0
	  sw $t2, -5372($fp)	# spill _tmp2501 from $t2 to $fp-5372
	# PopParams 8
	  add $sp, $sp, 8	# pop params off stack
	# IfZ _tmp2501 Goto _L240
	  lw $t0, -5372($fp)	# fill _tmp2501 to $t0 from $fp-5372
	  beqz $t0, _L240	# branch if _tmp2501 is zero 
	# _tmp2502 = 0
	  li $t2, 0		# load constant value 0 into $t2
	  sw $t2, -5376($fp)	# spill _tmp2502 from $t2 to $fp-5376
	# _tmp2469 = _tmp2502
	  lw $t2, -5376($fp)	# fill _tmp2502 to $t2 from $fp-5376
	  sw $t2, -5244($fp)	# spill _tmp2469 from $t2 to $fp-5244
	# Goto _L239
	  b _L239		# unconditional branch
  _L240:
	# _tmp2503 = 1
	  li $t2, 1		# load constant value 1 into $t2
	  sw $t2, -5380($fp)	# spill _tmp2503 from $t2 to $fp-5380
	# _tmp2469 = _tmp2503
	  lw $t2, -5380($fp)	# fill _tmp2503 to $t2 from $fp-5380
	  sw $t2, -5244($fp)	# spill _tmp2469 from $t2 to $fp-5244
  _L239:
	# _tmp2504 = _tmp2468 && _tmp2469
	  lw $t0, -5240($fp)	# fill _tmp2468 to $t0 from $fp-5240
	  lw $t1, -5244($fp)	# fill _tmp2469 to $t1 from $fp-5244
	  and $t2, $t0, $t1	
	  sw $t2, -5384($fp)	# spill _tmp2504 from $t2 to $fp-5384
	# IfZ _tmp2504 Goto _L233
	  lw $t0, -5384($fp)	# fill _tmp2504 to $t0 from $fp-5384
	  beqz $t0, _L233	# branch if _tmp2504 is zero 
	# _tmp2505 = 2
	  li $t2, 2		# load constant value 2 into $t2
	  sw $t2, -5388($fp)	# spill _tmp2505 from $t2 to $fp-5388
	# row = _tmp2505
	  lw $t2, -5388($fp)	# fill _tmp2505 to $t2 from $fp-5388
	  sw $t2, -8($fp)	# spill row from $t2 to $fp-8
	# _tmp2506 = 2
	  li $t2, 2		# load constant value 2 into $t2
	  sw $t2, -5392($fp)	# spill _tmp2506 from $t2 to $fp-5392
	# column = _tmp2506
	  lw $t2, -5392($fp)	# fill _tmp2506 to $t2 from $fp-5392
	  sw $t2, -12($fp)	# spill column from $t2 to $fp-12
	# Goto _L234
	  b _L234		# unconditional branch
  _L233:
	# PushParam enemyMark
	  subu $sp, $sp, 4	# decrement sp to make space for param
	  lw $t0, 8($fp)	# fill enemyMark to $t0 from $fp+8
	  sw $t0, 4($sp)	# copy param value to stack
	# _tmp2507 = *(this + 4)
	  lw $t0, 4($fp)	# fill this to $t0 from $fp+4
	  lw $t2, 4($t0) 	# load with offset
	  sw $t2, -5396($fp)	# spill _tmp2507 from $t2 to $fp-5396
	# _tmp2508 = 2
	  li $t2, 2		# load constant value 2 into $t2
	  sw $t2, -5400($fp)	# spill _tmp2508 from $t2 to $fp-5400
	# _tmp2509 = 0
	  li $t2, 0		# load constant value 0 into $t2
	  sw $t2, -5404($fp)	# spill _tmp2509 from $t2 to $fp-5404
	# _tmp2510 = *(_tmp2507)
	  lw $t0, -5396($fp)	# fill _tmp2507 to $t0 from $fp-5396
	  lw $t2, 0($t0) 	# load with offset
	  sw $t2, -5408($fp)	# spill _tmp2510 from $t2 to $fp-5408
	# _tmp2511 = _tmp2508 < _tmp2509
	  lw $t0, -5400($fp)	# fill _tmp2508 to $t0 from $fp-5400
	  lw $t1, -5404($fp)	# fill _tmp2509 to $t1 from $fp-5404
	  slt $t2, $t0, $t1	
	  sw $t2, -5412($fp)	# spill _tmp2511 from $t2 to $fp-5412
	# _tmp2512 = _tmp2510 < _tmp2508
	  lw $t0, -5408($fp)	# fill _tmp2510 to $t0 from $fp-5408
	  lw $t1, -5400($fp)	# fill _tmp2508 to $t1 from $fp-5400
	  slt $t2, $t0, $t1	
	  sw $t2, -5416($fp)	# spill _tmp2512 from $t2 to $fp-5416
	# _tmp2513 = _tmp2510 == _tmp2508
	  lw $t0, -5408($fp)	# fill _tmp2510 to $t0 from $fp-5408
	  lw $t1, -5400($fp)	# fill _tmp2508 to $t1 from $fp-5400
	  seq $t2, $t0, $t1	
	  sw $t2, -5420($fp)	# spill _tmp2513 from $t2 to $fp-5420
	# _tmp2514 = _tmp2512 || _tmp2513
	  lw $t0, -5416($fp)	# fill _tmp2512 to $t0 from $fp-5416
	  lw $t1, -5420($fp)	# fill _tmp2513 to $t1 from $fp-5420
	  or $t2, $t0, $t1	
	  sw $t2, -5424($fp)	# spill _tmp2514 from $t2 to $fp-5424
	# _tmp2515 = _tmp2514 || _tmp2511
	  lw $t0, -5424($fp)	# fill _tmp2514 to $t0 from $fp-5424
	  lw $t1, -5412($fp)	# fill _tmp2511 to $t1 from $fp-5412
	  or $t2, $t0, $t1	
	  sw $t2, -5428($fp)	# spill _tmp2515 from $t2 to $fp-5428
	# IfZ _tmp2515 Goto _L245
	  lw $t0, -5428($fp)	# fill _tmp2515 to $t0 from $fp-5428
	  beqz $t0, _L245	# branch if _tmp2515 is zero 
	# _tmp2516 = "Decaf runtime error: Array subscript out of bound..."
	  .data			# create string constant marked with label
	  _string157: .asciiz "Decaf runtime error: Array subscript out of bounds\n"
	  .text
	  la $t2, _string157	# load label
	  sw $t2, -5432($fp)	# spill _tmp2516 from $t2 to $fp-5432
	# PushParam _tmp2516
	  subu $sp, $sp, 4	# decrement sp to make space for param
	  lw $t0, -5432($fp)	# fill _tmp2516 to $t0 from $fp-5432
	  sw $t0, 4($sp)	# copy param value to stack
	# LCall _PrintString
	  jal _PrintString   	# jump to function
	# PopParams 4
	  add $sp, $sp, 4	# pop params off stack
	# LCall _Halt
	  jal _Halt          	# jump to function
  _L245:
	# _tmp2517 = 4
	  li $t2, 4		# load constant value 4 into $t2
	  sw $t2, -5436($fp)	# spill _tmp2517 from $t2 to $fp-5436
	# _tmp2518 = _tmp2508 * _tmp2517
	  lw $t0, -5400($fp)	# fill _tmp2508 to $t0 from $fp-5400
	  lw $t1, -5436($fp)	# fill _tmp2517 to $t1 from $fp-5436
	  mul $t2, $t0, $t1	
	  sw $t2, -5440($fp)	# spill _tmp2518 from $t2 to $fp-5440
	# _tmp2519 = _tmp2518 + _tmp2517
	  lw $t0, -5440($fp)	# fill _tmp2518 to $t0 from $fp-5440
	  lw $t1, -5436($fp)	# fill _tmp2517 to $t1 from $fp-5436
	  add $t2, $t0, $t1	
	  sw $t2, -5444($fp)	# spill _tmp2519 from $t2 to $fp-5444
	# _tmp2520 = _tmp2507 + _tmp2519
	  lw $t0, -5396($fp)	# fill _tmp2507 to $t0 from $fp-5396
	  lw $t1, -5444($fp)	# fill _tmp2519 to $t1 from $fp-5444
	  add $t2, $t0, $t1	
	  sw $t2, -5448($fp)	# spill _tmp2520 from $t2 to $fp-5448
	# _tmp2521 = *(_tmp2520)
	  lw $t0, -5448($fp)	# fill _tmp2520 to $t0 from $fp-5448
	  lw $t2, 0($t0) 	# load with offset
	  sw $t2, -5452($fp)	# spill _tmp2521 from $t2 to $fp-5452
	# _tmp2522 = 2
	  li $t2, 2		# load constant value 2 into $t2
	  sw $t2, -5456($fp)	# spill _tmp2522 from $t2 to $fp-5456
	# _tmp2523 = 0
	  li $t2, 0		# load constant value 0 into $t2
	  sw $t2, -5460($fp)	# spill _tmp2523 from $t2 to $fp-5460
	# _tmp2524 = *(_tmp2521)
	  lw $t0, -5452($fp)	# fill _tmp2521 to $t0 from $fp-5452
	  lw $t2, 0($t0) 	# load with offset
	  sw $t2, -5464($fp)	# spill _tmp2524 from $t2 to $fp-5464
	# _tmp2525 = _tmp2522 < _tmp2523
	  lw $t0, -5456($fp)	# fill _tmp2522 to $t0 from $fp-5456
	  lw $t1, -5460($fp)	# fill _tmp2523 to $t1 from $fp-5460
	  slt $t2, $t0, $t1	
	  sw $t2, -5468($fp)	# spill _tmp2525 from $t2 to $fp-5468
	# _tmp2526 = _tmp2524 < _tmp2522
	  lw $t0, -5464($fp)	# fill _tmp2524 to $t0 from $fp-5464
	  lw $t1, -5456($fp)	# fill _tmp2522 to $t1 from $fp-5456
	  slt $t2, $t0, $t1	
	  sw $t2, -5472($fp)	# spill _tmp2526 from $t2 to $fp-5472
	# _tmp2527 = _tmp2524 == _tmp2522
	  lw $t0, -5464($fp)	# fill _tmp2524 to $t0 from $fp-5464
	  lw $t1, -5456($fp)	# fill _tmp2522 to $t1 from $fp-5456
	  seq $t2, $t0, $t1	
	  sw $t2, -5476($fp)	# spill _tmp2527 from $t2 to $fp-5476
	# _tmp2528 = _tmp2526 || _tmp2527
	  lw $t0, -5472($fp)	# fill _tmp2526 to $t0 from $fp-5472
	  lw $t1, -5476($fp)	# fill _tmp2527 to $t1 from $fp-5476
	  or $t2, $t0, $t1	
	  sw $t2, -5480($fp)	# spill _tmp2528 from $t2 to $fp-5480
	# _tmp2529 = _tmp2528 || _tmp2525
	  lw $t0, -5480($fp)	# fill _tmp2528 to $t0 from $fp-5480
	  lw $t1, -5468($fp)	# fill _tmp2525 to $t1 from $fp-5468
	  or $t2, $t0, $t1	
	  sw $t2, -5484($fp)	# spill _tmp2529 from $t2 to $fp-5484
	# IfZ _tmp2529 Goto _L246
	  lw $t0, -5484($fp)	# fill _tmp2529 to $t0 from $fp-5484
	  beqz $t0, _L246	# branch if _tmp2529 is zero 
	# _tmp2530 = "Decaf runtime error: Array subscript out of bound..."
	  .data			# create string constant marked with label
	  _string158: .asciiz "Decaf runtime error: Array subscript out of bounds\n"
	  .text
	  la $t2, _string158	# load label
	  sw $t2, -5488($fp)	# spill _tmp2530 from $t2 to $fp-5488
	# PushParam _tmp2530
	  subu $sp, $sp, 4	# decrement sp to make space for param
	  lw $t0, -5488($fp)	# fill _tmp2530 to $t0 from $fp-5488
	  sw $t0, 4($sp)	# copy param value to stack
	# LCall _PrintString
	  jal _PrintString   	# jump to function
	# PopParams 4
	  add $sp, $sp, 4	# pop params off stack
	# LCall _Halt
	  jal _Halt          	# jump to function
  _L246:
	# _tmp2531 = 4
	  li $t2, 4		# load constant value 4 into $t2
	  sw $t2, -5492($fp)	# spill _tmp2531 from $t2 to $fp-5492
	# _tmp2532 = _tmp2522 * _tmp2531
	  lw $t0, -5456($fp)	# fill _tmp2522 to $t0 from $fp-5456
	  lw $t1, -5492($fp)	# fill _tmp2531 to $t1 from $fp-5492
	  mul $t2, $t0, $t1	
	  sw $t2, -5496($fp)	# spill _tmp2532 from $t2 to $fp-5496
	# _tmp2533 = _tmp2532 + _tmp2531
	  lw $t0, -5496($fp)	# fill _tmp2532 to $t0 from $fp-5496
	  lw $t1, -5492($fp)	# fill _tmp2531 to $t1 from $fp-5492
	  add $t2, $t0, $t1	
	  sw $t2, -5500($fp)	# spill _tmp2533 from $t2 to $fp-5500
	# _tmp2534 = _tmp2521 + _tmp2533
	  lw $t0, -5452($fp)	# fill _tmp2521 to $t0 from $fp-5452
	  lw $t1, -5500($fp)	# fill _tmp2533 to $t1 from $fp-5500
	  add $t2, $t0, $t1	
	  sw $t2, -5504($fp)	# spill _tmp2534 from $t2 to $fp-5504
	# _tmp2535 = *(_tmp2534)
	  lw $t0, -5504($fp)	# fill _tmp2534 to $t0 from $fp-5504
	  lw $t2, 0($t0) 	# load with offset
	  sw $t2, -5508($fp)	# spill _tmp2535 from $t2 to $fp-5508
	# PushParam _tmp2535
	  subu $sp, $sp, 4	# decrement sp to make space for param
	  lw $t0, -5508($fp)	# fill _tmp2535 to $t0 from $fp-5508
	  sw $t0, 4($sp)	# copy param value to stack
	# _tmp2536 = *(_tmp2535)
	  lw $t0, -5508($fp)	# fill _tmp2535 to $t0 from $fp-5508
	  lw $t2, 0($t0) 	# load with offset
	  sw $t2, -5512($fp)	# spill _tmp2536 from $t2 to $fp-5512
	# _tmp2537 = *(_tmp2536 + 20)
	  lw $t0, -5512($fp)	# fill _tmp2536 to $t0 from $fp-5512
	  lw $t2, 20($t0) 	# load with offset
	  sw $t2, -5516($fp)	# spill _tmp2537 from $t2 to $fp-5516
	# _tmp2538 = ACall _tmp2537
	  lw $t0, -5516($fp)	# fill _tmp2537 to $t0 from $fp-5516
	  jalr $t0            	# jump to function
	  move $t2, $v0		# copy function return value from $v0
	  sw $t2, -5520($fp)	# spill _tmp2538 from $t2 to $fp-5520
	# PopParams 8
	  add $sp, $sp, 8	# pop params off stack
	# PushParam enemyMark
	  subu $sp, $sp, 4	# decrement sp to make space for param
	  lw $t0, 8($fp)	# fill enemyMark to $t0 from $fp+8
	  sw $t0, 4($sp)	# copy param value to stack
	# _tmp2539 = *(this + 4)
	  lw $t0, 4($fp)	# fill this to $t0 from $fp+4
	  lw $t2, 4($t0) 	# load with offset
	  sw $t2, -5524($fp)	# spill _tmp2539 from $t2 to $fp-5524
	# _tmp2540 = 1
	  li $t2, 1		# load constant value 1 into $t2
	  sw $t2, -5528($fp)	# spill _tmp2540 from $t2 to $fp-5528
	# _tmp2541 = 0
	  li $t2, 0		# load constant value 0 into $t2
	  sw $t2, -5532($fp)	# spill _tmp2541 from $t2 to $fp-5532
	# _tmp2542 = *(_tmp2539)
	  lw $t0, -5524($fp)	# fill _tmp2539 to $t0 from $fp-5524
	  lw $t2, 0($t0) 	# load with offset
	  sw $t2, -5536($fp)	# spill _tmp2542 from $t2 to $fp-5536
	# _tmp2543 = _tmp2540 < _tmp2541
	  lw $t0, -5528($fp)	# fill _tmp2540 to $t0 from $fp-5528
	  lw $t1, -5532($fp)	# fill _tmp2541 to $t1 from $fp-5532
	  slt $t2, $t0, $t1	
	  sw $t2, -5540($fp)	# spill _tmp2543 from $t2 to $fp-5540
	# _tmp2544 = _tmp2542 < _tmp2540
	  lw $t0, -5536($fp)	# fill _tmp2542 to $t0 from $fp-5536
	  lw $t1, -5528($fp)	# fill _tmp2540 to $t1 from $fp-5528
	  slt $t2, $t0, $t1	
	  sw $t2, -5544($fp)	# spill _tmp2544 from $t2 to $fp-5544
	# _tmp2545 = _tmp2542 == _tmp2540
	  lw $t0, -5536($fp)	# fill _tmp2542 to $t0 from $fp-5536
	  lw $t1, -5528($fp)	# fill _tmp2540 to $t1 from $fp-5528
	  seq $t2, $t0, $t1	
	  sw $t2, -5548($fp)	# spill _tmp2545 from $t2 to $fp-5548
	# _tmp2546 = _tmp2544 || _tmp2545
	  lw $t0, -5544($fp)	# fill _tmp2544 to $t0 from $fp-5544
	  lw $t1, -5548($fp)	# fill _tmp2545 to $t1 from $fp-5548
	  or $t2, $t0, $t1	
	  sw $t2, -5552($fp)	# spill _tmp2546 from $t2 to $fp-5552
	# _tmp2547 = _tmp2546 || _tmp2543
	  lw $t0, -5552($fp)	# fill _tmp2546 to $t0 from $fp-5552
	  lw $t1, -5540($fp)	# fill _tmp2543 to $t1 from $fp-5540
	  or $t2, $t0, $t1	
	  sw $t2, -5556($fp)	# spill _tmp2547 from $t2 to $fp-5556
	# IfZ _tmp2547 Goto _L247
	  lw $t0, -5556($fp)	# fill _tmp2547 to $t0 from $fp-5556
	  beqz $t0, _L247	# branch if _tmp2547 is zero 
	# _tmp2548 = "Decaf runtime error: Array subscript out of bound..."
	  .data			# create string constant marked with label
	  _string159: .asciiz "Decaf runtime error: Array subscript out of bounds\n"
	  .text
	  la $t2, _string159	# load label
	  sw $t2, -5560($fp)	# spill _tmp2548 from $t2 to $fp-5560
	# PushParam _tmp2548
	  subu $sp, $sp, 4	# decrement sp to make space for param
	  lw $t0, -5560($fp)	# fill _tmp2548 to $t0 from $fp-5560
	  sw $t0, 4($sp)	# copy param value to stack
	# LCall _PrintString
	  jal _PrintString   	# jump to function
	# PopParams 4
	  add $sp, $sp, 4	# pop params off stack
	# LCall _Halt
	  jal _Halt          	# jump to function
  _L247:
	# _tmp2549 = 4
	  li $t2, 4		# load constant value 4 into $t2
	  sw $t2, -5564($fp)	# spill _tmp2549 from $t2 to $fp-5564
	# _tmp2550 = _tmp2540 * _tmp2549
	  lw $t0, -5528($fp)	# fill _tmp2540 to $t0 from $fp-5528
	  lw $t1, -5564($fp)	# fill _tmp2549 to $t1 from $fp-5564
	  mul $t2, $t0, $t1	
	  sw $t2, -5568($fp)	# spill _tmp2550 from $t2 to $fp-5568
	# _tmp2551 = _tmp2550 + _tmp2549
	  lw $t0, -5568($fp)	# fill _tmp2550 to $t0 from $fp-5568
	  lw $t1, -5564($fp)	# fill _tmp2549 to $t1 from $fp-5564
	  add $t2, $t0, $t1	
	  sw $t2, -5572($fp)	# spill _tmp2551 from $t2 to $fp-5572
	# _tmp2552 = _tmp2539 + _tmp2551
	  lw $t0, -5524($fp)	# fill _tmp2539 to $t0 from $fp-5524
	  lw $t1, -5572($fp)	# fill _tmp2551 to $t1 from $fp-5572
	  add $t2, $t0, $t1	
	  sw $t2, -5576($fp)	# spill _tmp2552 from $t2 to $fp-5576
	# _tmp2553 = *(_tmp2552)
	  lw $t0, -5576($fp)	# fill _tmp2552 to $t0 from $fp-5576
	  lw $t2, 0($t0) 	# load with offset
	  sw $t2, -5580($fp)	# spill _tmp2553 from $t2 to $fp-5580
	# _tmp2554 = 1
	  li $t2, 1		# load constant value 1 into $t2
	  sw $t2, -5584($fp)	# spill _tmp2554 from $t2 to $fp-5584
	# _tmp2555 = 0
	  li $t2, 0		# load constant value 0 into $t2
	  sw $t2, -5588($fp)	# spill _tmp2555 from $t2 to $fp-5588
	# _tmp2556 = *(_tmp2553)
	  lw $t0, -5580($fp)	# fill _tmp2553 to $t0 from $fp-5580
	  lw $t2, 0($t0) 	# load with offset
	  sw $t2, -5592($fp)	# spill _tmp2556 from $t2 to $fp-5592
	# _tmp2557 = _tmp2554 < _tmp2555
	  lw $t0, -5584($fp)	# fill _tmp2554 to $t0 from $fp-5584
	  lw $t1, -5588($fp)	# fill _tmp2555 to $t1 from $fp-5588
	  slt $t2, $t0, $t1	
	  sw $t2, -5596($fp)	# spill _tmp2557 from $t2 to $fp-5596
	# _tmp2558 = _tmp2556 < _tmp2554
	  lw $t0, -5592($fp)	# fill _tmp2556 to $t0 from $fp-5592
	  lw $t1, -5584($fp)	# fill _tmp2554 to $t1 from $fp-5584
	  slt $t2, $t0, $t1	
	  sw $t2, -5600($fp)	# spill _tmp2558 from $t2 to $fp-5600
	# _tmp2559 = _tmp2556 == _tmp2554
	  lw $t0, -5592($fp)	# fill _tmp2556 to $t0 from $fp-5592
	  lw $t1, -5584($fp)	# fill _tmp2554 to $t1 from $fp-5584
	  seq $t2, $t0, $t1	
	  sw $t2, -5604($fp)	# spill _tmp2559 from $t2 to $fp-5604
	# _tmp2560 = _tmp2558 || _tmp2559
	  lw $t0, -5600($fp)	# fill _tmp2558 to $t0 from $fp-5600
	  lw $t1, -5604($fp)	# fill _tmp2559 to $t1 from $fp-5604
	  or $t2, $t0, $t1	
	  sw $t2, -5608($fp)	# spill _tmp2560 from $t2 to $fp-5608
	# _tmp2561 = _tmp2560 || _tmp2557
	  lw $t0, -5608($fp)	# fill _tmp2560 to $t0 from $fp-5608
	  lw $t1, -5596($fp)	# fill _tmp2557 to $t1 from $fp-5596
	  or $t2, $t0, $t1	
	  sw $t2, -5612($fp)	# spill _tmp2561 from $t2 to $fp-5612
	# IfZ _tmp2561 Goto _L248
	  lw $t0, -5612($fp)	# fill _tmp2561 to $t0 from $fp-5612
	  beqz $t0, _L248	# branch if _tmp2561 is zero 
	# _tmp2562 = "Decaf runtime error: Array subscript out of bound..."
	  .data			# create string constant marked with label
	  _string160: .asciiz "Decaf runtime error: Array subscript out of bounds\n"
	  .text
	  la $t2, _string160	# load label
	  sw $t2, -5616($fp)	# spill _tmp2562 from $t2 to $fp-5616
	# PushParam _tmp2562
	  subu $sp, $sp, 4	# decrement sp to make space for param
	  lw $t0, -5616($fp)	# fill _tmp2562 to $t0 from $fp-5616
	  sw $t0, 4($sp)	# copy param value to stack
	# LCall _PrintString
	  jal _PrintString   	# jump to function
	# PopParams 4
	  add $sp, $sp, 4	# pop params off stack
	# LCall _Halt
	  jal _Halt          	# jump to function
  _L248:
	# _tmp2563 = 4
	  li $t2, 4		# load constant value 4 into $t2
	  sw $t2, -5620($fp)	# spill _tmp2563 from $t2 to $fp-5620
	# _tmp2564 = _tmp2554 * _tmp2563
	  lw $t0, -5584($fp)	# fill _tmp2554 to $t0 from $fp-5584
	  lw $t1, -5620($fp)	# fill _tmp2563 to $t1 from $fp-5620
	  mul $t2, $t0, $t1	
	  sw $t2, -5624($fp)	# spill _tmp2564 from $t2 to $fp-5624
	# _tmp2565 = _tmp2564 + _tmp2563
	  lw $t0, -5624($fp)	# fill _tmp2564 to $t0 from $fp-5624
	  lw $t1, -5620($fp)	# fill _tmp2563 to $t1 from $fp-5620
	  add $t2, $t0, $t1	
	  sw $t2, -5628($fp)	# spill _tmp2565 from $t2 to $fp-5628
	# _tmp2566 = _tmp2553 + _tmp2565
	  lw $t0, -5580($fp)	# fill _tmp2553 to $t0 from $fp-5580
	  lw $t1, -5628($fp)	# fill _tmp2565 to $t1 from $fp-5628
	  add $t2, $t0, $t1	
	  sw $t2, -5632($fp)	# spill _tmp2566 from $t2 to $fp-5632
	# _tmp2567 = *(_tmp2566)
	  lw $t0, -5632($fp)	# fill _tmp2566 to $t0 from $fp-5632
	  lw $t2, 0($t0) 	# load with offset
	  sw $t2, -5636($fp)	# spill _tmp2567 from $t2 to $fp-5636
	# PushParam _tmp2567
	  subu $sp, $sp, 4	# decrement sp to make space for param
	  lw $t0, -5636($fp)	# fill _tmp2567 to $t0 from $fp-5636
	  sw $t0, 4($sp)	# copy param value to stack
	# _tmp2568 = *(_tmp2567)
	  lw $t0, -5636($fp)	# fill _tmp2567 to $t0 from $fp-5636
	  lw $t2, 0($t0) 	# load with offset
	  sw $t2, -5640($fp)	# spill _tmp2568 from $t2 to $fp-5640
	# _tmp2569 = *(_tmp2568 + 20)
	  lw $t0, -5640($fp)	# fill _tmp2568 to $t0 from $fp-5640
	  lw $t2, 20($t0) 	# load with offset
	  sw $t2, -5644($fp)	# spill _tmp2569 from $t2 to $fp-5644
	# _tmp2570 = ACall _tmp2569
	  lw $t0, -5644($fp)	# fill _tmp2569 to $t0 from $fp-5644
	  jalr $t0            	# jump to function
	  move $t2, $v0		# copy function return value from $v0
	  sw $t2, -5648($fp)	# spill _tmp2570 from $t2 to $fp-5648
	# PopParams 8
	  add $sp, $sp, 8	# pop params off stack
	# _tmp2571 = _tmp2538 && _tmp2570
	  lw $t0, -5520($fp)	# fill _tmp2538 to $t0 from $fp-5520
	  lw $t1, -5648($fp)	# fill _tmp2570 to $t1 from $fp-5648
	  and $t2, $t0, $t1	
	  sw $t2, -5652($fp)	# spill _tmp2571 from $t2 to $fp-5652
	# PushParam playerMark
	  subu $sp, $sp, 4	# decrement sp to make space for param
	  lw $t0, 12($fp)	# fill playerMark to $t0 from $fp+12
	  sw $t0, 4($sp)	# copy param value to stack
	# _tmp2573 = *(this + 4)
	  lw $t0, 4($fp)	# fill this to $t0 from $fp+4
	  lw $t2, 4($t0) 	# load with offset
	  sw $t2, -5660($fp)	# spill _tmp2573 from $t2 to $fp-5660
	# _tmp2574 = 0
	  li $t2, 0		# load constant value 0 into $t2
	  sw $t2, -5664($fp)	# spill _tmp2574 from $t2 to $fp-5664
	# _tmp2575 = 0
	  li $t2, 0		# load constant value 0 into $t2
	  sw $t2, -5668($fp)	# spill _tmp2575 from $t2 to $fp-5668
	# _tmp2576 = *(_tmp2573)
	  lw $t0, -5660($fp)	# fill _tmp2573 to $t0 from $fp-5660
	  lw $t2, 0($t0) 	# load with offset
	  sw $t2, -5672($fp)	# spill _tmp2576 from $t2 to $fp-5672
	# _tmp2577 = _tmp2574 < _tmp2575
	  lw $t0, -5664($fp)	# fill _tmp2574 to $t0 from $fp-5664
	  lw $t1, -5668($fp)	# fill _tmp2575 to $t1 from $fp-5668
	  slt $t2, $t0, $t1	
	  sw $t2, -5676($fp)	# spill _tmp2577 from $t2 to $fp-5676
	# _tmp2578 = _tmp2576 < _tmp2574
	  lw $t0, -5672($fp)	# fill _tmp2576 to $t0 from $fp-5672
	  lw $t1, -5664($fp)	# fill _tmp2574 to $t1 from $fp-5664
	  slt $t2, $t0, $t1	
	  sw $t2, -5680($fp)	# spill _tmp2578 from $t2 to $fp-5680
	# _tmp2579 = _tmp2576 == _tmp2574
	  lw $t0, -5672($fp)	# fill _tmp2576 to $t0 from $fp-5672
	  lw $t1, -5664($fp)	# fill _tmp2574 to $t1 from $fp-5664
	  seq $t2, $t0, $t1	
	  sw $t2, -5684($fp)	# spill _tmp2579 from $t2 to $fp-5684
	# _tmp2580 = _tmp2578 || _tmp2579
	  lw $t0, -5680($fp)	# fill _tmp2578 to $t0 from $fp-5680
	  lw $t1, -5684($fp)	# fill _tmp2579 to $t1 from $fp-5684
	  or $t2, $t0, $t1	
	  sw $t2, -5688($fp)	# spill _tmp2580 from $t2 to $fp-5688
	# _tmp2581 = _tmp2580 || _tmp2577
	  lw $t0, -5688($fp)	# fill _tmp2580 to $t0 from $fp-5688
	  lw $t1, -5676($fp)	# fill _tmp2577 to $t1 from $fp-5676
	  or $t2, $t0, $t1	
	  sw $t2, -5692($fp)	# spill _tmp2581 from $t2 to $fp-5692
	# IfZ _tmp2581 Goto _L251
	  lw $t0, -5692($fp)	# fill _tmp2581 to $t0 from $fp-5692
	  beqz $t0, _L251	# branch if _tmp2581 is zero 
	# _tmp2582 = "Decaf runtime error: Array subscript out of bound..."
	  .data			# create string constant marked with label
	  _string161: .asciiz "Decaf runtime error: Array subscript out of bounds\n"
	  .text
	  la $t2, _string161	# load label
	  sw $t2, -5696($fp)	# spill _tmp2582 from $t2 to $fp-5696
	# PushParam _tmp2582
	  subu $sp, $sp, 4	# decrement sp to make space for param
	  lw $t0, -5696($fp)	# fill _tmp2582 to $t0 from $fp-5696
	  sw $t0, 4($sp)	# copy param value to stack
	# LCall _PrintString
	  jal _PrintString   	# jump to function
	# PopParams 4
	  add $sp, $sp, 4	# pop params off stack
	# LCall _Halt
	  jal _Halt          	# jump to function
  _L251:
	# _tmp2583 = 4
	  li $t2, 4		# load constant value 4 into $t2
	  sw $t2, -5700($fp)	# spill _tmp2583 from $t2 to $fp-5700
	# _tmp2584 = _tmp2574 * _tmp2583
	  lw $t0, -5664($fp)	# fill _tmp2574 to $t0 from $fp-5664
	  lw $t1, -5700($fp)	# fill _tmp2583 to $t1 from $fp-5700
	  mul $t2, $t0, $t1	
	  sw $t2, -5704($fp)	# spill _tmp2584 from $t2 to $fp-5704
	# _tmp2585 = _tmp2584 + _tmp2583
	  lw $t0, -5704($fp)	# fill _tmp2584 to $t0 from $fp-5704
	  lw $t1, -5700($fp)	# fill _tmp2583 to $t1 from $fp-5700
	  add $t2, $t0, $t1	
	  sw $t2, -5708($fp)	# spill _tmp2585 from $t2 to $fp-5708
	# _tmp2586 = _tmp2573 + _tmp2585
	  lw $t0, -5660($fp)	# fill _tmp2573 to $t0 from $fp-5660
	  lw $t1, -5708($fp)	# fill _tmp2585 to $t1 from $fp-5708
	  add $t2, $t0, $t1	
	  sw $t2, -5712($fp)	# spill _tmp2586 from $t2 to $fp-5712
	# _tmp2587 = *(_tmp2586)
	  lw $t0, -5712($fp)	# fill _tmp2586 to $t0 from $fp-5712
	  lw $t2, 0($t0) 	# load with offset
	  sw $t2, -5716($fp)	# spill _tmp2587 from $t2 to $fp-5716
	# _tmp2588 = 0
	  li $t2, 0		# load constant value 0 into $t2
	  sw $t2, -5720($fp)	# spill _tmp2588 from $t2 to $fp-5720
	# _tmp2589 = 0
	  li $t2, 0		# load constant value 0 into $t2
	  sw $t2, -5724($fp)	# spill _tmp2589 from $t2 to $fp-5724
	# _tmp2590 = *(_tmp2587)
	  lw $t0, -5716($fp)	# fill _tmp2587 to $t0 from $fp-5716
	  lw $t2, 0($t0) 	# load with offset
	  sw $t2, -5728($fp)	# spill _tmp2590 from $t2 to $fp-5728
	# _tmp2591 = _tmp2588 < _tmp2589
	  lw $t0, -5720($fp)	# fill _tmp2588 to $t0 from $fp-5720
	  lw $t1, -5724($fp)	# fill _tmp2589 to $t1 from $fp-5724
	  slt $t2, $t0, $t1	
	  sw $t2, -5732($fp)	# spill _tmp2591 from $t2 to $fp-5732
	# _tmp2592 = _tmp2590 < _tmp2588
	  lw $t0, -5728($fp)	# fill _tmp2590 to $t0 from $fp-5728
	  lw $t1, -5720($fp)	# fill _tmp2588 to $t1 from $fp-5720
	  slt $t2, $t0, $t1	
	  sw $t2, -5736($fp)	# spill _tmp2592 from $t2 to $fp-5736
	# _tmp2593 = _tmp2590 == _tmp2588
	  lw $t0, -5728($fp)	# fill _tmp2590 to $t0 from $fp-5728
	  lw $t1, -5720($fp)	# fill _tmp2588 to $t1 from $fp-5720
	  seq $t2, $t0, $t1	
	  sw $t2, -5740($fp)	# spill _tmp2593 from $t2 to $fp-5740
	# _tmp2594 = _tmp2592 || _tmp2593
	  lw $t0, -5736($fp)	# fill _tmp2592 to $t0 from $fp-5736
	  lw $t1, -5740($fp)	# fill _tmp2593 to $t1 from $fp-5740
	  or $t2, $t0, $t1	
	  sw $t2, -5744($fp)	# spill _tmp2594 from $t2 to $fp-5744
	# _tmp2595 = _tmp2594 || _tmp2591
	  lw $t0, -5744($fp)	# fill _tmp2594 to $t0 from $fp-5744
	  lw $t1, -5732($fp)	# fill _tmp2591 to $t1 from $fp-5732
	  or $t2, $t0, $t1	
	  sw $t2, -5748($fp)	# spill _tmp2595 from $t2 to $fp-5748
	# IfZ _tmp2595 Goto _L252
	  lw $t0, -5748($fp)	# fill _tmp2595 to $t0 from $fp-5748
	  beqz $t0, _L252	# branch if _tmp2595 is zero 
	# _tmp2596 = "Decaf runtime error: Array subscript out of bound..."
	  .data			# create string constant marked with label
	  _string162: .asciiz "Decaf runtime error: Array subscript out of bounds\n"
	  .text
	  la $t2, _string162	# load label
	  sw $t2, -5752($fp)	# spill _tmp2596 from $t2 to $fp-5752
	# PushParam _tmp2596
	  subu $sp, $sp, 4	# decrement sp to make space for param
	  lw $t0, -5752($fp)	# fill _tmp2596 to $t0 from $fp-5752
	  sw $t0, 4($sp)	# copy param value to stack
	# LCall _PrintString
	  jal _PrintString   	# jump to function
	# PopParams 4
	  add $sp, $sp, 4	# pop params off stack
	# LCall _Halt
	  jal _Halt          	# jump to function
  _L252:
	# _tmp2597 = 4
	  li $t2, 4		# load constant value 4 into $t2
	  sw $t2, -5756($fp)	# spill _tmp2597 from $t2 to $fp-5756
	# _tmp2598 = _tmp2588 * _tmp2597
	  lw $t0, -5720($fp)	# fill _tmp2588 to $t0 from $fp-5720
	  lw $t1, -5756($fp)	# fill _tmp2597 to $t1 from $fp-5756
	  mul $t2, $t0, $t1	
	  sw $t2, -5760($fp)	# spill _tmp2598 from $t2 to $fp-5760
	# _tmp2599 = _tmp2598 + _tmp2597
	  lw $t0, -5760($fp)	# fill _tmp2598 to $t0 from $fp-5760
	  lw $t1, -5756($fp)	# fill _tmp2597 to $t1 from $fp-5756
	  add $t2, $t0, $t1	
	  sw $t2, -5764($fp)	# spill _tmp2599 from $t2 to $fp-5764
	# _tmp2600 = _tmp2587 + _tmp2599
	  lw $t0, -5716($fp)	# fill _tmp2587 to $t0 from $fp-5716
	  lw $t1, -5764($fp)	# fill _tmp2599 to $t1 from $fp-5764
	  add $t2, $t0, $t1	
	  sw $t2, -5768($fp)	# spill _tmp2600 from $t2 to $fp-5768
	# _tmp2601 = *(_tmp2600)
	  lw $t0, -5768($fp)	# fill _tmp2600 to $t0 from $fp-5768
	  lw $t2, 0($t0) 	# load with offset
	  sw $t2, -5772($fp)	# spill _tmp2601 from $t2 to $fp-5772
	# PushParam _tmp2601
	  subu $sp, $sp, 4	# decrement sp to make space for param
	  lw $t0, -5772($fp)	# fill _tmp2601 to $t0 from $fp-5772
	  sw $t0, 4($sp)	# copy param value to stack
	# _tmp2602 = *(_tmp2601)
	  lw $t0, -5772($fp)	# fill _tmp2601 to $t0 from $fp-5772
	  lw $t2, 0($t0) 	# load with offset
	  sw $t2, -5776($fp)	# spill _tmp2602 from $t2 to $fp-5776
	# _tmp2603 = *(_tmp2602 + 20)
	  lw $t0, -5776($fp)	# fill _tmp2602 to $t0 from $fp-5776
	  lw $t2, 20($t0) 	# load with offset
	  sw $t2, -5780($fp)	# spill _tmp2603 from $t2 to $fp-5780
	# _tmp2604 = ACall _tmp2603
	  lw $t0, -5780($fp)	# fill _tmp2603 to $t0 from $fp-5780
	  jalr $t0            	# jump to function
	  move $t2, $v0		# copy function return value from $v0
	  sw $t2, -5784($fp)	# spill _tmp2604 from $t2 to $fp-5784
	# PopParams 8
	  add $sp, $sp, 8	# pop params off stack
	# IfZ _tmp2604 Goto _L250
	  lw $t0, -5784($fp)	# fill _tmp2604 to $t0 from $fp-5784
	  beqz $t0, _L250	# branch if _tmp2604 is zero 
	# _tmp2605 = 0
	  li $t2, 0		# load constant value 0 into $t2
	  sw $t2, -5788($fp)	# spill _tmp2605 from $t2 to $fp-5788
	# _tmp2572 = _tmp2605
	  lw $t2, -5788($fp)	# fill _tmp2605 to $t2 from $fp-5788
	  sw $t2, -5656($fp)	# spill _tmp2572 from $t2 to $fp-5656
	# Goto _L249
	  b _L249		# unconditional branch
  _L250:
	# _tmp2606 = 1
	  li $t2, 1		# load constant value 1 into $t2
	  sw $t2, -5792($fp)	# spill _tmp2606 from $t2 to $fp-5792
	# _tmp2572 = _tmp2606
	  lw $t2, -5792($fp)	# fill _tmp2606 to $t2 from $fp-5792
	  sw $t2, -5656($fp)	# spill _tmp2572 from $t2 to $fp-5656
  _L249:
	# _tmp2607 = _tmp2571 && _tmp2572
	  lw $t0, -5652($fp)	# fill _tmp2571 to $t0 from $fp-5652
	  lw $t1, -5656($fp)	# fill _tmp2572 to $t1 from $fp-5656
	  and $t2, $t0, $t1	
	  sw $t2, -5796($fp)	# spill _tmp2607 from $t2 to $fp-5796
	# IfZ _tmp2607 Goto _L243
	  lw $t0, -5796($fp)	# fill _tmp2607 to $t0 from $fp-5796
	  beqz $t0, _L243	# branch if _tmp2607 is zero 
	# _tmp2608 = 0
	  li $t2, 0		# load constant value 0 into $t2
	  sw $t2, -5800($fp)	# spill _tmp2608 from $t2 to $fp-5800
	# row = _tmp2608
	  lw $t2, -5800($fp)	# fill _tmp2608 to $t2 from $fp-5800
	  sw $t2, -8($fp)	# spill row from $t2 to $fp-8
	# _tmp2609 = 0
	  li $t2, 0		# load constant value 0 into $t2
	  sw $t2, -5804($fp)	# spill _tmp2609 from $t2 to $fp-5804
	# column = _tmp2609
	  lw $t2, -5804($fp)	# fill _tmp2609 to $t2 from $fp-5804
	  sw $t2, -12($fp)	# spill column from $t2 to $fp-12
	# Goto _L244
	  b _L244		# unconditional branch
  _L243:
	# PushParam enemyMark
	  subu $sp, $sp, 4	# decrement sp to make space for param
	  lw $t0, 8($fp)	# fill enemyMark to $t0 from $fp+8
	  sw $t0, 4($sp)	# copy param value to stack
	# _tmp2610 = *(this + 4)
	  lw $t0, 4($fp)	# fill this to $t0 from $fp+4
	  lw $t2, 4($t0) 	# load with offset
	  sw $t2, -5808($fp)	# spill _tmp2610 from $t2 to $fp-5808
	# _tmp2611 = 2
	  li $t2, 2		# load constant value 2 into $t2
	  sw $t2, -5812($fp)	# spill _tmp2611 from $t2 to $fp-5812
	# _tmp2612 = 0
	  li $t2, 0		# load constant value 0 into $t2
	  sw $t2, -5816($fp)	# spill _tmp2612 from $t2 to $fp-5816
	# _tmp2613 = *(_tmp2610)
	  lw $t0, -5808($fp)	# fill _tmp2610 to $t0 from $fp-5808
	  lw $t2, 0($t0) 	# load with offset
	  sw $t2, -5820($fp)	# spill _tmp2613 from $t2 to $fp-5820
	# _tmp2614 = _tmp2611 < _tmp2612
	  lw $t0, -5812($fp)	# fill _tmp2611 to $t0 from $fp-5812
	  lw $t1, -5816($fp)	# fill _tmp2612 to $t1 from $fp-5816
	  slt $t2, $t0, $t1	
	  sw $t2, -5824($fp)	# spill _tmp2614 from $t2 to $fp-5824
	# _tmp2615 = _tmp2613 < _tmp2611
	  lw $t0, -5820($fp)	# fill _tmp2613 to $t0 from $fp-5820
	  lw $t1, -5812($fp)	# fill _tmp2611 to $t1 from $fp-5812
	  slt $t2, $t0, $t1	
	  sw $t2, -5828($fp)	# spill _tmp2615 from $t2 to $fp-5828
	# _tmp2616 = _tmp2613 == _tmp2611
	  lw $t0, -5820($fp)	# fill _tmp2613 to $t0 from $fp-5820
	  lw $t1, -5812($fp)	# fill _tmp2611 to $t1 from $fp-5812
	  seq $t2, $t0, $t1	
	  sw $t2, -5832($fp)	# spill _tmp2616 from $t2 to $fp-5832
	# _tmp2617 = _tmp2615 || _tmp2616
	  lw $t0, -5828($fp)	# fill _tmp2615 to $t0 from $fp-5828
	  lw $t1, -5832($fp)	# fill _tmp2616 to $t1 from $fp-5832
	  or $t2, $t0, $t1	
	  sw $t2, -5836($fp)	# spill _tmp2617 from $t2 to $fp-5836
	# _tmp2618 = _tmp2617 || _tmp2614
	  lw $t0, -5836($fp)	# fill _tmp2617 to $t0 from $fp-5836
	  lw $t1, -5824($fp)	# fill _tmp2614 to $t1 from $fp-5824
	  or $t2, $t0, $t1	
	  sw $t2, -5840($fp)	# spill _tmp2618 from $t2 to $fp-5840
	# IfZ _tmp2618 Goto _L255
	  lw $t0, -5840($fp)	# fill _tmp2618 to $t0 from $fp-5840
	  beqz $t0, _L255	# branch if _tmp2618 is zero 
	# _tmp2619 = "Decaf runtime error: Array subscript out of bound..."
	  .data			# create string constant marked with label
	  _string163: .asciiz "Decaf runtime error: Array subscript out of bounds\n"
	  .text
	  la $t2, _string163	# load label
	  sw $t2, -5844($fp)	# spill _tmp2619 from $t2 to $fp-5844
	# PushParam _tmp2619
	  subu $sp, $sp, 4	# decrement sp to make space for param
	  lw $t0, -5844($fp)	# fill _tmp2619 to $t0 from $fp-5844
	  sw $t0, 4($sp)	# copy param value to stack
	# LCall _PrintString
	  jal _PrintString   	# jump to function
	# PopParams 4
	  add $sp, $sp, 4	# pop params off stack
	# LCall _Halt
	  jal _Halt          	# jump to function
  _L255:
	# _tmp2620 = 4
	  li $t2, 4		# load constant value 4 into $t2
	  sw $t2, -5848($fp)	# spill _tmp2620 from $t2 to $fp-5848
	# _tmp2621 = _tmp2611 * _tmp2620
	  lw $t0, -5812($fp)	# fill _tmp2611 to $t0 from $fp-5812
	  lw $t1, -5848($fp)	# fill _tmp2620 to $t1 from $fp-5848
	  mul $t2, $t0, $t1	
	  sw $t2, -5852($fp)	# spill _tmp2621 from $t2 to $fp-5852
	# _tmp2622 = _tmp2621 + _tmp2620
	  lw $t0, -5852($fp)	# fill _tmp2621 to $t0 from $fp-5852
	  lw $t1, -5848($fp)	# fill _tmp2620 to $t1 from $fp-5848
	  add $t2, $t0, $t1	
	  sw $t2, -5856($fp)	# spill _tmp2622 from $t2 to $fp-5856
	# _tmp2623 = _tmp2610 + _tmp2622
	  lw $t0, -5808($fp)	# fill _tmp2610 to $t0 from $fp-5808
	  lw $t1, -5856($fp)	# fill _tmp2622 to $t1 from $fp-5856
	  add $t2, $t0, $t1	
	  sw $t2, -5860($fp)	# spill _tmp2623 from $t2 to $fp-5860
	# _tmp2624 = *(_tmp2623)
	  lw $t0, -5860($fp)	# fill _tmp2623 to $t0 from $fp-5860
	  lw $t2, 0($t0) 	# load with offset
	  sw $t2, -5864($fp)	# spill _tmp2624 from $t2 to $fp-5864
	# _tmp2625 = 0
	  li $t2, 0		# load constant value 0 into $t2
	  sw $t2, -5868($fp)	# spill _tmp2625 from $t2 to $fp-5868
	# _tmp2626 = 0
	  li $t2, 0		# load constant value 0 into $t2
	  sw $t2, -5872($fp)	# spill _tmp2626 from $t2 to $fp-5872
	# _tmp2627 = *(_tmp2624)
	  lw $t0, -5864($fp)	# fill _tmp2624 to $t0 from $fp-5864
	  lw $t2, 0($t0) 	# load with offset
	  sw $t2, -5876($fp)	# spill _tmp2627 from $t2 to $fp-5876
	# _tmp2628 = _tmp2625 < _tmp2626
	  lw $t0, -5868($fp)	# fill _tmp2625 to $t0 from $fp-5868
	  lw $t1, -5872($fp)	# fill _tmp2626 to $t1 from $fp-5872
	  slt $t2, $t0, $t1	
	  sw $t2, -5880($fp)	# spill _tmp2628 from $t2 to $fp-5880
	# _tmp2629 = _tmp2627 < _tmp2625
	  lw $t0, -5876($fp)	# fill _tmp2627 to $t0 from $fp-5876
	  lw $t1, -5868($fp)	# fill _tmp2625 to $t1 from $fp-5868
	  slt $t2, $t0, $t1	
	  sw $t2, -5884($fp)	# spill _tmp2629 from $t2 to $fp-5884
	# _tmp2630 = _tmp2627 == _tmp2625
	  lw $t0, -5876($fp)	# fill _tmp2627 to $t0 from $fp-5876
	  lw $t1, -5868($fp)	# fill _tmp2625 to $t1 from $fp-5868
	  seq $t2, $t0, $t1	
	  sw $t2, -5888($fp)	# spill _tmp2630 from $t2 to $fp-5888
	# _tmp2631 = _tmp2629 || _tmp2630
	  lw $t0, -5884($fp)	# fill _tmp2629 to $t0 from $fp-5884
	  lw $t1, -5888($fp)	# fill _tmp2630 to $t1 from $fp-5888
	  or $t2, $t0, $t1	
	  sw $t2, -5892($fp)	# spill _tmp2631 from $t2 to $fp-5892
	# _tmp2632 = _tmp2631 || _tmp2628
	  lw $t0, -5892($fp)	# fill _tmp2631 to $t0 from $fp-5892
	  lw $t1, -5880($fp)	# fill _tmp2628 to $t1 from $fp-5880
	  or $t2, $t0, $t1	
	  sw $t2, -5896($fp)	# spill _tmp2632 from $t2 to $fp-5896
	# IfZ _tmp2632 Goto _L256
	  lw $t0, -5896($fp)	# fill _tmp2632 to $t0 from $fp-5896
	  beqz $t0, _L256	# branch if _tmp2632 is zero 
	# _tmp2633 = "Decaf runtime error: Array subscript out of bound..."
	  .data			# create string constant marked with label
	  _string164: .asciiz "Decaf runtime error: Array subscript out of bounds\n"
	  .text
	  la $t2, _string164	# load label
	  sw $t2, -5900($fp)	# spill _tmp2633 from $t2 to $fp-5900
	# PushParam _tmp2633
	  subu $sp, $sp, 4	# decrement sp to make space for param
	  lw $t0, -5900($fp)	# fill _tmp2633 to $t0 from $fp-5900
	  sw $t0, 4($sp)	# copy param value to stack
	# LCall _PrintString
	  jal _PrintString   	# jump to function
	# PopParams 4
	  add $sp, $sp, 4	# pop params off stack
	# LCall _Halt
	  jal _Halt          	# jump to function
  _L256:
	# _tmp2634 = 4
	  li $t2, 4		# load constant value 4 into $t2
	  sw $t2, -5904($fp)	# spill _tmp2634 from $t2 to $fp-5904
	# _tmp2635 = _tmp2625 * _tmp2634
	  lw $t0, -5868($fp)	# fill _tmp2625 to $t0 from $fp-5868
	  lw $t1, -5904($fp)	# fill _tmp2634 to $t1 from $fp-5904
	  mul $t2, $t0, $t1	
	  sw $t2, -5908($fp)	# spill _tmp2635 from $t2 to $fp-5908
	# _tmp2636 = _tmp2635 + _tmp2634
	  lw $t0, -5908($fp)	# fill _tmp2635 to $t0 from $fp-5908
	  lw $t1, -5904($fp)	# fill _tmp2634 to $t1 from $fp-5904
	  add $t2, $t0, $t1	
	  sw $t2, -5912($fp)	# spill _tmp2636 from $t2 to $fp-5912
	# _tmp2637 = _tmp2624 + _tmp2636
	  lw $t0, -5864($fp)	# fill _tmp2624 to $t0 from $fp-5864
	  lw $t1, -5912($fp)	# fill _tmp2636 to $t1 from $fp-5912
	  add $t2, $t0, $t1	
	  sw $t2, -5916($fp)	# spill _tmp2637 from $t2 to $fp-5916
	# _tmp2638 = *(_tmp2637)
	  lw $t0, -5916($fp)	# fill _tmp2637 to $t0 from $fp-5916
	  lw $t2, 0($t0) 	# load with offset
	  sw $t2, -5920($fp)	# spill _tmp2638 from $t2 to $fp-5920
	# PushParam _tmp2638
	  subu $sp, $sp, 4	# decrement sp to make space for param
	  lw $t0, -5920($fp)	# fill _tmp2638 to $t0 from $fp-5920
	  sw $t0, 4($sp)	# copy param value to stack
	# _tmp2639 = *(_tmp2638)
	  lw $t0, -5920($fp)	# fill _tmp2638 to $t0 from $fp-5920
	  lw $t2, 0($t0) 	# load with offset
	  sw $t2, -5924($fp)	# spill _tmp2639 from $t2 to $fp-5924
	# _tmp2640 = *(_tmp2639 + 20)
	  lw $t0, -5924($fp)	# fill _tmp2639 to $t0 from $fp-5924
	  lw $t2, 20($t0) 	# load with offset
	  sw $t2, -5928($fp)	# spill _tmp2640 from $t2 to $fp-5928
	# _tmp2641 = ACall _tmp2640
	  lw $t0, -5928($fp)	# fill _tmp2640 to $t0 from $fp-5928
	  jalr $t0            	# jump to function
	  move $t2, $v0		# copy function return value from $v0
	  sw $t2, -5932($fp)	# spill _tmp2641 from $t2 to $fp-5932
	# PopParams 8
	  add $sp, $sp, 8	# pop params off stack
	# PushParam enemyMark
	  subu $sp, $sp, 4	# decrement sp to make space for param
	  lw $t0, 8($fp)	# fill enemyMark to $t0 from $fp+8
	  sw $t0, 4($sp)	# copy param value to stack
	# _tmp2642 = *(this + 4)
	  lw $t0, 4($fp)	# fill this to $t0 from $fp+4
	  lw $t2, 4($t0) 	# load with offset
	  sw $t2, -5936($fp)	# spill _tmp2642 from $t2 to $fp-5936
	# _tmp2643 = 1
	  li $t2, 1		# load constant value 1 into $t2
	  sw $t2, -5940($fp)	# spill _tmp2643 from $t2 to $fp-5940
	# _tmp2644 = 0
	  li $t2, 0		# load constant value 0 into $t2
	  sw $t2, -5944($fp)	# spill _tmp2644 from $t2 to $fp-5944
	# _tmp2645 = *(_tmp2642)
	  lw $t0, -5936($fp)	# fill _tmp2642 to $t0 from $fp-5936
	  lw $t2, 0($t0) 	# load with offset
	  sw $t2, -5948($fp)	# spill _tmp2645 from $t2 to $fp-5948
	# _tmp2646 = _tmp2643 < _tmp2644
	  lw $t0, -5940($fp)	# fill _tmp2643 to $t0 from $fp-5940
	  lw $t1, -5944($fp)	# fill _tmp2644 to $t1 from $fp-5944
	  slt $t2, $t0, $t1	
	  sw $t2, -5952($fp)	# spill _tmp2646 from $t2 to $fp-5952
	# _tmp2647 = _tmp2645 < _tmp2643
	  lw $t0, -5948($fp)	# fill _tmp2645 to $t0 from $fp-5948
	  lw $t1, -5940($fp)	# fill _tmp2643 to $t1 from $fp-5940
	  slt $t2, $t0, $t1	
	  sw $t2, -5956($fp)	# spill _tmp2647 from $t2 to $fp-5956
	# _tmp2648 = _tmp2645 == _tmp2643
	  lw $t0, -5948($fp)	# fill _tmp2645 to $t0 from $fp-5948
	  lw $t1, -5940($fp)	# fill _tmp2643 to $t1 from $fp-5940
	  seq $t2, $t0, $t1	
	  sw $t2, -5960($fp)	# spill _tmp2648 from $t2 to $fp-5960
	# _tmp2649 = _tmp2647 || _tmp2648
	  lw $t0, -5956($fp)	# fill _tmp2647 to $t0 from $fp-5956
	  lw $t1, -5960($fp)	# fill _tmp2648 to $t1 from $fp-5960
	  or $t2, $t0, $t1	
	  sw $t2, -5964($fp)	# spill _tmp2649 from $t2 to $fp-5964
	# _tmp2650 = _tmp2649 || _tmp2646
	  lw $t0, -5964($fp)	# fill _tmp2649 to $t0 from $fp-5964
	  lw $t1, -5952($fp)	# fill _tmp2646 to $t1 from $fp-5952
	  or $t2, $t0, $t1	
	  sw $t2, -5968($fp)	# spill _tmp2650 from $t2 to $fp-5968
	# IfZ _tmp2650 Goto _L257
	  lw $t0, -5968($fp)	# fill _tmp2650 to $t0 from $fp-5968
	  beqz $t0, _L257	# branch if _tmp2650 is zero 
	# _tmp2651 = "Decaf runtime error: Array subscript out of bound..."
	  .data			# create string constant marked with label
	  _string165: .asciiz "Decaf runtime error: Array subscript out of bounds\n"
	  .text
	  la $t2, _string165	# load label
	  sw $t2, -5972($fp)	# spill _tmp2651 from $t2 to $fp-5972
	# PushParam _tmp2651
	  subu $sp, $sp, 4	# decrement sp to make space for param
	  lw $t0, -5972($fp)	# fill _tmp2651 to $t0 from $fp-5972
	  sw $t0, 4($sp)	# copy param value to stack
	# LCall _PrintString
	  jal _PrintString   	# jump to function
	# PopParams 4
	  add $sp, $sp, 4	# pop params off stack
	# LCall _Halt
	  jal _Halt          	# jump to function
  _L257:
	# _tmp2652 = 4
	  li $t2, 4		# load constant value 4 into $t2
	  sw $t2, -5976($fp)	# spill _tmp2652 from $t2 to $fp-5976
	# _tmp2653 = _tmp2643 * _tmp2652
	  lw $t0, -5940($fp)	# fill _tmp2643 to $t0 from $fp-5940
	  lw $t1, -5976($fp)	# fill _tmp2652 to $t1 from $fp-5976
	  mul $t2, $t0, $t1	
	  sw $t2, -5980($fp)	# spill _tmp2653 from $t2 to $fp-5980
	# _tmp2654 = _tmp2653 + _tmp2652
	  lw $t0, -5980($fp)	# fill _tmp2653 to $t0 from $fp-5980
	  lw $t1, -5976($fp)	# fill _tmp2652 to $t1 from $fp-5976
	  add $t2, $t0, $t1	
	  sw $t2, -5984($fp)	# spill _tmp2654 from $t2 to $fp-5984
	# _tmp2655 = _tmp2642 + _tmp2654
	  lw $t0, -5936($fp)	# fill _tmp2642 to $t0 from $fp-5936
	  lw $t1, -5984($fp)	# fill _tmp2654 to $t1 from $fp-5984
	  add $t2, $t0, $t1	
	  sw $t2, -5988($fp)	# spill _tmp2655 from $t2 to $fp-5988
	# _tmp2656 = *(_tmp2655)
	  lw $t0, -5988($fp)	# fill _tmp2655 to $t0 from $fp-5988
	  lw $t2, 0($t0) 	# load with offset
	  sw $t2, -5992($fp)	# spill _tmp2656 from $t2 to $fp-5992
	# _tmp2657 = 1
	  li $t2, 1		# load constant value 1 into $t2
	  sw $t2, -5996($fp)	# spill _tmp2657 from $t2 to $fp-5996
	# _tmp2658 = 0
	  li $t2, 0		# load constant value 0 into $t2
	  sw $t2, -6000($fp)	# spill _tmp2658 from $t2 to $fp-6000
	# _tmp2659 = *(_tmp2656)
	  lw $t0, -5992($fp)	# fill _tmp2656 to $t0 from $fp-5992
	  lw $t2, 0($t0) 	# load with offset
	  sw $t2, -6004($fp)	# spill _tmp2659 from $t2 to $fp-6004
	# _tmp2660 = _tmp2657 < _tmp2658
	  lw $t0, -5996($fp)	# fill _tmp2657 to $t0 from $fp-5996
	  lw $t1, -6000($fp)	# fill _tmp2658 to $t1 from $fp-6000
	  slt $t2, $t0, $t1	
	  sw $t2, -6008($fp)	# spill _tmp2660 from $t2 to $fp-6008
	# _tmp2661 = _tmp2659 < _tmp2657
	  lw $t0, -6004($fp)	# fill _tmp2659 to $t0 from $fp-6004
	  lw $t1, -5996($fp)	# fill _tmp2657 to $t1 from $fp-5996
	  slt $t2, $t0, $t1	
	  sw $t2, -6012($fp)	# spill _tmp2661 from $t2 to $fp-6012
	# _tmp2662 = _tmp2659 == _tmp2657
	  lw $t0, -6004($fp)	# fill _tmp2659 to $t0 from $fp-6004
	  lw $t1, -5996($fp)	# fill _tmp2657 to $t1 from $fp-5996
	  seq $t2, $t0, $t1	
	  sw $t2, -6016($fp)	# spill _tmp2662 from $t2 to $fp-6016
	# _tmp2663 = _tmp2661 || _tmp2662
	  lw $t0, -6012($fp)	# fill _tmp2661 to $t0 from $fp-6012
	  lw $t1, -6016($fp)	# fill _tmp2662 to $t1 from $fp-6016
	  or $t2, $t0, $t1	
	  sw $t2, -6020($fp)	# spill _tmp2663 from $t2 to $fp-6020
	# _tmp2664 = _tmp2663 || _tmp2660
	  lw $t0, -6020($fp)	# fill _tmp2663 to $t0 from $fp-6020
	  lw $t1, -6008($fp)	# fill _tmp2660 to $t1 from $fp-6008
	  or $t2, $t0, $t1	
	  sw $t2, -6024($fp)	# spill _tmp2664 from $t2 to $fp-6024
	# IfZ _tmp2664 Goto _L258
	  lw $t0, -6024($fp)	# fill _tmp2664 to $t0 from $fp-6024
	  beqz $t0, _L258	# branch if _tmp2664 is zero 
	# _tmp2665 = "Decaf runtime error: Array subscript out of bound..."
	  .data			# create string constant marked with label
	  _string166: .asciiz "Decaf runtime error: Array subscript out of bounds\n"
	  .text
	  la $t2, _string166	# load label
	  sw $t2, -6028($fp)	# spill _tmp2665 from $t2 to $fp-6028
	# PushParam _tmp2665
	  subu $sp, $sp, 4	# decrement sp to make space for param
	  lw $t0, -6028($fp)	# fill _tmp2665 to $t0 from $fp-6028
	  sw $t0, 4($sp)	# copy param value to stack
	# LCall _PrintString
	  jal _PrintString   	# jump to function
	# PopParams 4
	  add $sp, $sp, 4	# pop params off stack
	# LCall _Halt
	  jal _Halt          	# jump to function
  _L258:
	# _tmp2666 = 4
	  li $t2, 4		# load constant value 4 into $t2
	  sw $t2, -6032($fp)	# spill _tmp2666 from $t2 to $fp-6032
	# _tmp2667 = _tmp2657 * _tmp2666
	  lw $t0, -5996($fp)	# fill _tmp2657 to $t0 from $fp-5996
	  lw $t1, -6032($fp)	# fill _tmp2666 to $t1 from $fp-6032
	  mul $t2, $t0, $t1	
	  sw $t2, -6036($fp)	# spill _tmp2667 from $t2 to $fp-6036
	# _tmp2668 = _tmp2667 + _tmp2666
	  lw $t0, -6036($fp)	# fill _tmp2667 to $t0 from $fp-6036
	  lw $t1, -6032($fp)	# fill _tmp2666 to $t1 from $fp-6032
	  add $t2, $t0, $t1	
	  sw $t2, -6040($fp)	# spill _tmp2668 from $t2 to $fp-6040
	# _tmp2669 = _tmp2656 + _tmp2668
	  lw $t0, -5992($fp)	# fill _tmp2656 to $t0 from $fp-5992
	  lw $t1, -6040($fp)	# fill _tmp2668 to $t1 from $fp-6040
	  add $t2, $t0, $t1	
	  sw $t2, -6044($fp)	# spill _tmp2669 from $t2 to $fp-6044
	# _tmp2670 = *(_tmp2669)
	  lw $t0, -6044($fp)	# fill _tmp2669 to $t0 from $fp-6044
	  lw $t2, 0($t0) 	# load with offset
	  sw $t2, -6048($fp)	# spill _tmp2670 from $t2 to $fp-6048
	# PushParam _tmp2670
	  subu $sp, $sp, 4	# decrement sp to make space for param
	  lw $t0, -6048($fp)	# fill _tmp2670 to $t0 from $fp-6048
	  sw $t0, 4($sp)	# copy param value to stack
	# _tmp2671 = *(_tmp2670)
	  lw $t0, -6048($fp)	# fill _tmp2670 to $t0 from $fp-6048
	  lw $t2, 0($t0) 	# load with offset
	  sw $t2, -6052($fp)	# spill _tmp2671 from $t2 to $fp-6052
	# _tmp2672 = *(_tmp2671 + 20)
	  lw $t0, -6052($fp)	# fill _tmp2671 to $t0 from $fp-6052
	  lw $t2, 20($t0) 	# load with offset
	  sw $t2, -6056($fp)	# spill _tmp2672 from $t2 to $fp-6056
	# _tmp2673 = ACall _tmp2672
	  lw $t0, -6056($fp)	# fill _tmp2672 to $t0 from $fp-6056
	  jalr $t0            	# jump to function
	  move $t2, $v0		# copy function return value from $v0
	  sw $t2, -6060($fp)	# spill _tmp2673 from $t2 to $fp-6060
	# PopParams 8
	  add $sp, $sp, 8	# pop params off stack
	# _tmp2674 = _tmp2641 && _tmp2673
	  lw $t0, -5932($fp)	# fill _tmp2641 to $t0 from $fp-5932
	  lw $t1, -6060($fp)	# fill _tmp2673 to $t1 from $fp-6060
	  and $t2, $t0, $t1	
	  sw $t2, -6064($fp)	# spill _tmp2674 from $t2 to $fp-6064
	# PushParam playerMark
	  subu $sp, $sp, 4	# decrement sp to make space for param
	  lw $t0, 12($fp)	# fill playerMark to $t0 from $fp+12
	  sw $t0, 4($sp)	# copy param value to stack
	# _tmp2676 = *(this + 4)
	  lw $t0, 4($fp)	# fill this to $t0 from $fp+4
	  lw $t2, 4($t0) 	# load with offset
	  sw $t2, -6072($fp)	# spill _tmp2676 from $t2 to $fp-6072
	# _tmp2677 = 0
	  li $t2, 0		# load constant value 0 into $t2
	  sw $t2, -6076($fp)	# spill _tmp2677 from $t2 to $fp-6076
	# _tmp2678 = 0
	  li $t2, 0		# load constant value 0 into $t2
	  sw $t2, -6080($fp)	# spill _tmp2678 from $t2 to $fp-6080
	# _tmp2679 = *(_tmp2676)
	  lw $t0, -6072($fp)	# fill _tmp2676 to $t0 from $fp-6072
	  lw $t2, 0($t0) 	# load with offset
	  sw $t2, -6084($fp)	# spill _tmp2679 from $t2 to $fp-6084
	# _tmp2680 = _tmp2677 < _tmp2678
	  lw $t0, -6076($fp)	# fill _tmp2677 to $t0 from $fp-6076
	  lw $t1, -6080($fp)	# fill _tmp2678 to $t1 from $fp-6080
	  slt $t2, $t0, $t1	
	  sw $t2, -6088($fp)	# spill _tmp2680 from $t2 to $fp-6088
	# _tmp2681 = _tmp2679 < _tmp2677
	  lw $t0, -6084($fp)	# fill _tmp2679 to $t0 from $fp-6084
	  lw $t1, -6076($fp)	# fill _tmp2677 to $t1 from $fp-6076
	  slt $t2, $t0, $t1	
	  sw $t2, -6092($fp)	# spill _tmp2681 from $t2 to $fp-6092
	# _tmp2682 = _tmp2679 == _tmp2677
	  lw $t0, -6084($fp)	# fill _tmp2679 to $t0 from $fp-6084
	  lw $t1, -6076($fp)	# fill _tmp2677 to $t1 from $fp-6076
	  seq $t2, $t0, $t1	
	  sw $t2, -6096($fp)	# spill _tmp2682 from $t2 to $fp-6096
	# _tmp2683 = _tmp2681 || _tmp2682
	  lw $t0, -6092($fp)	# fill _tmp2681 to $t0 from $fp-6092
	  lw $t1, -6096($fp)	# fill _tmp2682 to $t1 from $fp-6096
	  or $t2, $t0, $t1	
	  sw $t2, -6100($fp)	# spill _tmp2683 from $t2 to $fp-6100
	# _tmp2684 = _tmp2683 || _tmp2680
	  lw $t0, -6100($fp)	# fill _tmp2683 to $t0 from $fp-6100
	  lw $t1, -6088($fp)	# fill _tmp2680 to $t1 from $fp-6088
	  or $t2, $t0, $t1	
	  sw $t2, -6104($fp)	# spill _tmp2684 from $t2 to $fp-6104
	# IfZ _tmp2684 Goto _L261
	  lw $t0, -6104($fp)	# fill _tmp2684 to $t0 from $fp-6104
	  beqz $t0, _L261	# branch if _tmp2684 is zero 
	# _tmp2685 = "Decaf runtime error: Array subscript out of bound..."
	  .data			# create string constant marked with label
	  _string167: .asciiz "Decaf runtime error: Array subscript out of bounds\n"
	  .text
	  la $t2, _string167	# load label
	  sw $t2, -6108($fp)	# spill _tmp2685 from $t2 to $fp-6108
	# PushParam _tmp2685
	  subu $sp, $sp, 4	# decrement sp to make space for param
	  lw $t0, -6108($fp)	# fill _tmp2685 to $t0 from $fp-6108
	  sw $t0, 4($sp)	# copy param value to stack
	# LCall _PrintString
	  jal _PrintString   	# jump to function
	# PopParams 4
	  add $sp, $sp, 4	# pop params off stack
	# LCall _Halt
	  jal _Halt          	# jump to function
  _L261:
	# _tmp2686 = 4
	  li $t2, 4		# load constant value 4 into $t2
	  sw $t2, -6112($fp)	# spill _tmp2686 from $t2 to $fp-6112
	# _tmp2687 = _tmp2677 * _tmp2686
	  lw $t0, -6076($fp)	# fill _tmp2677 to $t0 from $fp-6076
	  lw $t1, -6112($fp)	# fill _tmp2686 to $t1 from $fp-6112
	  mul $t2, $t0, $t1	
	  sw $t2, -6116($fp)	# spill _tmp2687 from $t2 to $fp-6116
	# _tmp2688 = _tmp2687 + _tmp2686
	  lw $t0, -6116($fp)	# fill _tmp2687 to $t0 from $fp-6116
	  lw $t1, -6112($fp)	# fill _tmp2686 to $t1 from $fp-6112
	  add $t2, $t0, $t1	
	  sw $t2, -6120($fp)	# spill _tmp2688 from $t2 to $fp-6120
	# _tmp2689 = _tmp2676 + _tmp2688
	  lw $t0, -6072($fp)	# fill _tmp2676 to $t0 from $fp-6072
	  lw $t1, -6120($fp)	# fill _tmp2688 to $t1 from $fp-6120
	  add $t2, $t0, $t1	
	  sw $t2, -6124($fp)	# spill _tmp2689 from $t2 to $fp-6124
	# _tmp2690 = *(_tmp2689)
	  lw $t0, -6124($fp)	# fill _tmp2689 to $t0 from $fp-6124
	  lw $t2, 0($t0) 	# load with offset
	  sw $t2, -6128($fp)	# spill _tmp2690 from $t2 to $fp-6128
	# _tmp2691 = 2
	  li $t2, 2		# load constant value 2 into $t2
	  sw $t2, -6132($fp)	# spill _tmp2691 from $t2 to $fp-6132
	# _tmp2692 = 0
	  li $t2, 0		# load constant value 0 into $t2
	  sw $t2, -6136($fp)	# spill _tmp2692 from $t2 to $fp-6136
	# _tmp2693 = *(_tmp2690)
	  lw $t0, -6128($fp)	# fill _tmp2690 to $t0 from $fp-6128
	  lw $t2, 0($t0) 	# load with offset
	  sw $t2, -6140($fp)	# spill _tmp2693 from $t2 to $fp-6140
	# _tmp2694 = _tmp2691 < _tmp2692
	  lw $t0, -6132($fp)	# fill _tmp2691 to $t0 from $fp-6132
	  lw $t1, -6136($fp)	# fill _tmp2692 to $t1 from $fp-6136
	  slt $t2, $t0, $t1	
	  sw $t2, -6144($fp)	# spill _tmp2694 from $t2 to $fp-6144
	# _tmp2695 = _tmp2693 < _tmp2691
	  lw $t0, -6140($fp)	# fill _tmp2693 to $t0 from $fp-6140
	  lw $t1, -6132($fp)	# fill _tmp2691 to $t1 from $fp-6132
	  slt $t2, $t0, $t1	
	  sw $t2, -6148($fp)	# spill _tmp2695 from $t2 to $fp-6148
	# _tmp2696 = _tmp2693 == _tmp2691
	  lw $t0, -6140($fp)	# fill _tmp2693 to $t0 from $fp-6140
	  lw $t1, -6132($fp)	# fill _tmp2691 to $t1 from $fp-6132
	  seq $t2, $t0, $t1	
	  sw $t2, -6152($fp)	# spill _tmp2696 from $t2 to $fp-6152
	# _tmp2697 = _tmp2695 || _tmp2696
	  lw $t0, -6148($fp)	# fill _tmp2695 to $t0 from $fp-6148
	  lw $t1, -6152($fp)	# fill _tmp2696 to $t1 from $fp-6152
	  or $t2, $t0, $t1	
	  sw $t2, -6156($fp)	# spill _tmp2697 from $t2 to $fp-6156
	# _tmp2698 = _tmp2697 || _tmp2694
	  lw $t0, -6156($fp)	# fill _tmp2697 to $t0 from $fp-6156
	  lw $t1, -6144($fp)	# fill _tmp2694 to $t1 from $fp-6144
	  or $t2, $t0, $t1	
	  sw $t2, -6160($fp)	# spill _tmp2698 from $t2 to $fp-6160
	# IfZ _tmp2698 Goto _L262
	  lw $t0, -6160($fp)	# fill _tmp2698 to $t0 from $fp-6160
	  beqz $t0, _L262	# branch if _tmp2698 is zero 
	# _tmp2699 = "Decaf runtime error: Array subscript out of bound..."
	  .data			# create string constant marked with label
	  _string168: .asciiz "Decaf runtime error: Array subscript out of bounds\n"
	  .text
	  la $t2, _string168	# load label
	  sw $t2, -6164($fp)	# spill _tmp2699 from $t2 to $fp-6164
	# PushParam _tmp2699
	  subu $sp, $sp, 4	# decrement sp to make space for param
	  lw $t0, -6164($fp)	# fill _tmp2699 to $t0 from $fp-6164
	  sw $t0, 4($sp)	# copy param value to stack
	# LCall _PrintString
	  jal _PrintString   	# jump to function
	# PopParams 4
	  add $sp, $sp, 4	# pop params off stack
	# LCall _Halt
	  jal _Halt          	# jump to function
  _L262:
	# _tmp2700 = 4
	  li $t2, 4		# load constant value 4 into $t2
	  sw $t2, -6168($fp)	# spill _tmp2700 from $t2 to $fp-6168
	# _tmp2701 = _tmp2691 * _tmp2700
	  lw $t0, -6132($fp)	# fill _tmp2691 to $t0 from $fp-6132
	  lw $t1, -6168($fp)	# fill _tmp2700 to $t1 from $fp-6168
	  mul $t2, $t0, $t1	
	  sw $t2, -6172($fp)	# spill _tmp2701 from $t2 to $fp-6172
	# _tmp2702 = _tmp2701 + _tmp2700
	  lw $t0, -6172($fp)	# fill _tmp2701 to $t0 from $fp-6172
	  lw $t1, -6168($fp)	# fill _tmp2700 to $t1 from $fp-6168
	  add $t2, $t0, $t1	
	  sw $t2, -6176($fp)	# spill _tmp2702 from $t2 to $fp-6176
	# _tmp2703 = _tmp2690 + _tmp2702
	  lw $t0, -6128($fp)	# fill _tmp2690 to $t0 from $fp-6128
	  lw $t1, -6176($fp)	# fill _tmp2702 to $t1 from $fp-6176
	  add $t2, $t0, $t1	
	  sw $t2, -6180($fp)	# spill _tmp2703 from $t2 to $fp-6180
	# _tmp2704 = *(_tmp2703)
	  lw $t0, -6180($fp)	# fill _tmp2703 to $t0 from $fp-6180
	  lw $t2, 0($t0) 	# load with offset
	  sw $t2, -6184($fp)	# spill _tmp2704 from $t2 to $fp-6184
	# PushParam _tmp2704
	  subu $sp, $sp, 4	# decrement sp to make space for param
	  lw $t0, -6184($fp)	# fill _tmp2704 to $t0 from $fp-6184
	  sw $t0, 4($sp)	# copy param value to stack
	# _tmp2705 = *(_tmp2704)
	  lw $t0, -6184($fp)	# fill _tmp2704 to $t0 from $fp-6184
	  lw $t2, 0($t0) 	# load with offset
	  sw $t2, -6188($fp)	# spill _tmp2705 from $t2 to $fp-6188
	# _tmp2706 = *(_tmp2705 + 20)
	  lw $t0, -6188($fp)	# fill _tmp2705 to $t0 from $fp-6188
	  lw $t2, 20($t0) 	# load with offset
	  sw $t2, -6192($fp)	# spill _tmp2706 from $t2 to $fp-6192
	# _tmp2707 = ACall _tmp2706
	  lw $t0, -6192($fp)	# fill _tmp2706 to $t0 from $fp-6192
	  jalr $t0            	# jump to function
	  move $t2, $v0		# copy function return value from $v0
	  sw $t2, -6196($fp)	# spill _tmp2707 from $t2 to $fp-6196
	# PopParams 8
	  add $sp, $sp, 8	# pop params off stack
	# IfZ _tmp2707 Goto _L260
	  lw $t0, -6196($fp)	# fill _tmp2707 to $t0 from $fp-6196
	  beqz $t0, _L260	# branch if _tmp2707 is zero 
	# _tmp2708 = 0
	  li $t2, 0		# load constant value 0 into $t2
	  sw $t2, -6200($fp)	# spill _tmp2708 from $t2 to $fp-6200
	# _tmp2675 = _tmp2708
	  lw $t2, -6200($fp)	# fill _tmp2708 to $t2 from $fp-6200
	  sw $t2, -6068($fp)	# spill _tmp2675 from $t2 to $fp-6068
	# Goto _L259
	  b _L259		# unconditional branch
  _L260:
	# _tmp2709 = 1
	  li $t2, 1		# load constant value 1 into $t2
	  sw $t2, -6204($fp)	# spill _tmp2709 from $t2 to $fp-6204
	# _tmp2675 = _tmp2709
	  lw $t2, -6204($fp)	# fill _tmp2709 to $t2 from $fp-6204
	  sw $t2, -6068($fp)	# spill _tmp2675 from $t2 to $fp-6068
  _L259:
	# _tmp2710 = _tmp2674 && _tmp2675
	  lw $t0, -6064($fp)	# fill _tmp2674 to $t0 from $fp-6064
	  lw $t1, -6068($fp)	# fill _tmp2675 to $t1 from $fp-6068
	  and $t2, $t0, $t1	
	  sw $t2, -6208($fp)	# spill _tmp2710 from $t2 to $fp-6208
	# IfZ _tmp2710 Goto _L253
	  lw $t0, -6208($fp)	# fill _tmp2710 to $t0 from $fp-6208
	  beqz $t0, _L253	# branch if _tmp2710 is zero 
	# _tmp2711 = 0
	  li $t2, 0		# load constant value 0 into $t2
	  sw $t2, -6212($fp)	# spill _tmp2711 from $t2 to $fp-6212
	# row = _tmp2711
	  lw $t2, -6212($fp)	# fill _tmp2711 to $t2 from $fp-6212
	  sw $t2, -8($fp)	# spill row from $t2 to $fp-8
	# _tmp2712 = 2
	  li $t2, 2		# load constant value 2 into $t2
	  sw $t2, -6216($fp)	# spill _tmp2712 from $t2 to $fp-6216
	# column = _tmp2712
	  lw $t2, -6216($fp)	# fill _tmp2712 to $t2 from $fp-6216
	  sw $t2, -12($fp)	# spill column from $t2 to $fp-12
	# Goto _L254
	  b _L254		# unconditional branch
  _L253:
	# PushParam enemyMark
	  subu $sp, $sp, 4	# decrement sp to make space for param
	  lw $t0, 8($fp)	# fill enemyMark to $t0 from $fp+8
	  sw $t0, 4($sp)	# copy param value to stack
	# _tmp2713 = *(this + 4)
	  lw $t0, 4($fp)	# fill this to $t0 from $fp+4
	  lw $t2, 4($t0) 	# load with offset
	  sw $t2, -6220($fp)	# spill _tmp2713 from $t2 to $fp-6220
	# _tmp2714 = 0
	  li $t2, 0		# load constant value 0 into $t2
	  sw $t2, -6224($fp)	# spill _tmp2714 from $t2 to $fp-6224
	# _tmp2715 = 0
	  li $t2, 0		# load constant value 0 into $t2
	  sw $t2, -6228($fp)	# spill _tmp2715 from $t2 to $fp-6228
	# _tmp2716 = *(_tmp2713)
	  lw $t0, -6220($fp)	# fill _tmp2713 to $t0 from $fp-6220
	  lw $t2, 0($t0) 	# load with offset
	  sw $t2, -6232($fp)	# spill _tmp2716 from $t2 to $fp-6232
	# _tmp2717 = _tmp2714 < _tmp2715
	  lw $t0, -6224($fp)	# fill _tmp2714 to $t0 from $fp-6224
	  lw $t1, -6228($fp)	# fill _tmp2715 to $t1 from $fp-6228
	  slt $t2, $t0, $t1	
	  sw $t2, -6236($fp)	# spill _tmp2717 from $t2 to $fp-6236
	# _tmp2718 = _tmp2716 < _tmp2714
	  lw $t0, -6232($fp)	# fill _tmp2716 to $t0 from $fp-6232
	  lw $t1, -6224($fp)	# fill _tmp2714 to $t1 from $fp-6224
	  slt $t2, $t0, $t1	
	  sw $t2, -6240($fp)	# spill _tmp2718 from $t2 to $fp-6240
	# _tmp2719 = _tmp2716 == _tmp2714
	  lw $t0, -6232($fp)	# fill _tmp2716 to $t0 from $fp-6232
	  lw $t1, -6224($fp)	# fill _tmp2714 to $t1 from $fp-6224
	  seq $t2, $t0, $t1	
	  sw $t2, -6244($fp)	# spill _tmp2719 from $t2 to $fp-6244
	# _tmp2720 = _tmp2718 || _tmp2719
	  lw $t0, -6240($fp)	# fill _tmp2718 to $t0 from $fp-6240
	  lw $t1, -6244($fp)	# fill _tmp2719 to $t1 from $fp-6244
	  or $t2, $t0, $t1	
	  sw $t2, -6248($fp)	# spill _tmp2720 from $t2 to $fp-6248
	# _tmp2721 = _tmp2720 || _tmp2717
	  lw $t0, -6248($fp)	# fill _tmp2720 to $t0 from $fp-6248
	  lw $t1, -6236($fp)	# fill _tmp2717 to $t1 from $fp-6236
	  or $t2, $t0, $t1	
	  sw $t2, -6252($fp)	# spill _tmp2721 from $t2 to $fp-6252
	# IfZ _tmp2721 Goto _L265
	  lw $t0, -6252($fp)	# fill _tmp2721 to $t0 from $fp-6252
	  beqz $t0, _L265	# branch if _tmp2721 is zero 
	# _tmp2722 = "Decaf runtime error: Array subscript out of bound..."
	  .data			# create string constant marked with label
	  _string169: .asciiz "Decaf runtime error: Array subscript out of bounds\n"
	  .text
	  la $t2, _string169	# load label
	  sw $t2, -6256($fp)	# spill _tmp2722 from $t2 to $fp-6256
	# PushParam _tmp2722
	  subu $sp, $sp, 4	# decrement sp to make space for param
	  lw $t0, -6256($fp)	# fill _tmp2722 to $t0 from $fp-6256
	  sw $t0, 4($sp)	# copy param value to stack
	# LCall _PrintString
	  jal _PrintString   	# jump to function
	# PopParams 4
	  add $sp, $sp, 4	# pop params off stack
	# LCall _Halt
	  jal _Halt          	# jump to function
  _L265:
	# _tmp2723 = 4
	  li $t2, 4		# load constant value 4 into $t2
	  sw $t2, -6260($fp)	# spill _tmp2723 from $t2 to $fp-6260
	# _tmp2724 = _tmp2714 * _tmp2723
	  lw $t0, -6224($fp)	# fill _tmp2714 to $t0 from $fp-6224
	  lw $t1, -6260($fp)	# fill _tmp2723 to $t1 from $fp-6260
	  mul $t2, $t0, $t1	
	  sw $t2, -6264($fp)	# spill _tmp2724 from $t2 to $fp-6264
	# _tmp2725 = _tmp2724 + _tmp2723
	  lw $t0, -6264($fp)	# fill _tmp2724 to $t0 from $fp-6264
	  lw $t1, -6260($fp)	# fill _tmp2723 to $t1 from $fp-6260
	  add $t2, $t0, $t1	
	  sw $t2, -6268($fp)	# spill _tmp2725 from $t2 to $fp-6268
	# _tmp2726 = _tmp2713 + _tmp2725
	  lw $t0, -6220($fp)	# fill _tmp2713 to $t0 from $fp-6220
	  lw $t1, -6268($fp)	# fill _tmp2725 to $t1 from $fp-6268
	  add $t2, $t0, $t1	
	  sw $t2, -6272($fp)	# spill _tmp2726 from $t2 to $fp-6272
	# _tmp2727 = *(_tmp2726)
	  lw $t0, -6272($fp)	# fill _tmp2726 to $t0 from $fp-6272
	  lw $t2, 0($t0) 	# load with offset
	  sw $t2, -6276($fp)	# spill _tmp2727 from $t2 to $fp-6276
	# _tmp2728 = 2
	  li $t2, 2		# load constant value 2 into $t2
	  sw $t2, -6280($fp)	# spill _tmp2728 from $t2 to $fp-6280
	# _tmp2729 = 0
	  li $t2, 0		# load constant value 0 into $t2
	  sw $t2, -6284($fp)	# spill _tmp2729 from $t2 to $fp-6284
	# _tmp2730 = *(_tmp2727)
	  lw $t0, -6276($fp)	# fill _tmp2727 to $t0 from $fp-6276
	  lw $t2, 0($t0) 	# load with offset
	  sw $t2, -6288($fp)	# spill _tmp2730 from $t2 to $fp-6288
	# _tmp2731 = _tmp2728 < _tmp2729
	  lw $t0, -6280($fp)	# fill _tmp2728 to $t0 from $fp-6280
	  lw $t1, -6284($fp)	# fill _tmp2729 to $t1 from $fp-6284
	  slt $t2, $t0, $t1	
	  sw $t2, -6292($fp)	# spill _tmp2731 from $t2 to $fp-6292
	# _tmp2732 = _tmp2730 < _tmp2728
	  lw $t0, -6288($fp)	# fill _tmp2730 to $t0 from $fp-6288
	  lw $t1, -6280($fp)	# fill _tmp2728 to $t1 from $fp-6280
	  slt $t2, $t0, $t1	
	  sw $t2, -6296($fp)	# spill _tmp2732 from $t2 to $fp-6296
	# _tmp2733 = _tmp2730 == _tmp2728
	  lw $t0, -6288($fp)	# fill _tmp2730 to $t0 from $fp-6288
	  lw $t1, -6280($fp)	# fill _tmp2728 to $t1 from $fp-6280
	  seq $t2, $t0, $t1	
	  sw $t2, -6300($fp)	# spill _tmp2733 from $t2 to $fp-6300
	# _tmp2734 = _tmp2732 || _tmp2733
	  lw $t0, -6296($fp)	# fill _tmp2732 to $t0 from $fp-6296
	  lw $t1, -6300($fp)	# fill _tmp2733 to $t1 from $fp-6300
	  or $t2, $t0, $t1	
	  sw $t2, -6304($fp)	# spill _tmp2734 from $t2 to $fp-6304
	# _tmp2735 = _tmp2734 || _tmp2731
	  lw $t0, -6304($fp)	# fill _tmp2734 to $t0 from $fp-6304
	  lw $t1, -6292($fp)	# fill _tmp2731 to $t1 from $fp-6292
	  or $t2, $t0, $t1	
	  sw $t2, -6308($fp)	# spill _tmp2735 from $t2 to $fp-6308
	# IfZ _tmp2735 Goto _L266
	  lw $t0, -6308($fp)	# fill _tmp2735 to $t0 from $fp-6308
	  beqz $t0, _L266	# branch if _tmp2735 is zero 
	# _tmp2736 = "Decaf runtime error: Array subscript out of bound..."
	  .data			# create string constant marked with label
	  _string170: .asciiz "Decaf runtime error: Array subscript out of bounds\n"
	  .text
	  la $t2, _string170	# load label
	  sw $t2, -6312($fp)	# spill _tmp2736 from $t2 to $fp-6312
	# PushParam _tmp2736
	  subu $sp, $sp, 4	# decrement sp to make space for param
	  lw $t0, -6312($fp)	# fill _tmp2736 to $t0 from $fp-6312
	  sw $t0, 4($sp)	# copy param value to stack
	# LCall _PrintString
	  jal _PrintString   	# jump to function
	# PopParams 4
	  add $sp, $sp, 4	# pop params off stack
	# LCall _Halt
	  jal _Halt          	# jump to function
  _L266:
	# _tmp2737 = 4
	  li $t2, 4		# load constant value 4 into $t2
	  sw $t2, -6316($fp)	# spill _tmp2737 from $t2 to $fp-6316
	# _tmp2738 = _tmp2728 * _tmp2737
	  lw $t0, -6280($fp)	# fill _tmp2728 to $t0 from $fp-6280
	  lw $t1, -6316($fp)	# fill _tmp2737 to $t1 from $fp-6316
	  mul $t2, $t0, $t1	
	  sw $t2, -6320($fp)	# spill _tmp2738 from $t2 to $fp-6320
	# _tmp2739 = _tmp2738 + _tmp2737
	  lw $t0, -6320($fp)	# fill _tmp2738 to $t0 from $fp-6320
	  lw $t1, -6316($fp)	# fill _tmp2737 to $t1 from $fp-6316
	  add $t2, $t0, $t1	
	  sw $t2, -6324($fp)	# spill _tmp2739 from $t2 to $fp-6324
	# _tmp2740 = _tmp2727 + _tmp2739
	  lw $t0, -6276($fp)	# fill _tmp2727 to $t0 from $fp-6276
	  lw $t1, -6324($fp)	# fill _tmp2739 to $t1 from $fp-6324
	  add $t2, $t0, $t1	
	  sw $t2, -6328($fp)	# spill _tmp2740 from $t2 to $fp-6328
	# _tmp2741 = *(_tmp2740)
	  lw $t0, -6328($fp)	# fill _tmp2740 to $t0 from $fp-6328
	  lw $t2, 0($t0) 	# load with offset
	  sw $t2, -6332($fp)	# spill _tmp2741 from $t2 to $fp-6332
	# PushParam _tmp2741
	  subu $sp, $sp, 4	# decrement sp to make space for param
	  lw $t0, -6332($fp)	# fill _tmp2741 to $t0 from $fp-6332
	  sw $t0, 4($sp)	# copy param value to stack
	# _tmp2742 = *(_tmp2741)
	  lw $t0, -6332($fp)	# fill _tmp2741 to $t0 from $fp-6332
	  lw $t2, 0($t0) 	# load with offset
	  sw $t2, -6336($fp)	# spill _tmp2742 from $t2 to $fp-6336
	# _tmp2743 = *(_tmp2742 + 20)
	  lw $t0, -6336($fp)	# fill _tmp2742 to $t0 from $fp-6336
	  lw $t2, 20($t0) 	# load with offset
	  sw $t2, -6340($fp)	# spill _tmp2743 from $t2 to $fp-6340
	# _tmp2744 = ACall _tmp2743
	  lw $t0, -6340($fp)	# fill _tmp2743 to $t0 from $fp-6340
	  jalr $t0            	# jump to function
	  move $t2, $v0		# copy function return value from $v0
	  sw $t2, -6344($fp)	# spill _tmp2744 from $t2 to $fp-6344
	# PopParams 8
	  add $sp, $sp, 8	# pop params off stack
	# PushParam enemyMark
	  subu $sp, $sp, 4	# decrement sp to make space for param
	  lw $t0, 8($fp)	# fill enemyMark to $t0 from $fp+8
	  sw $t0, 4($sp)	# copy param value to stack
	# _tmp2745 = *(this + 4)
	  lw $t0, 4($fp)	# fill this to $t0 from $fp+4
	  lw $t2, 4($t0) 	# load with offset
	  sw $t2, -6348($fp)	# spill _tmp2745 from $t2 to $fp-6348
	# _tmp2746 = 1
	  li $t2, 1		# load constant value 1 into $t2
	  sw $t2, -6352($fp)	# spill _tmp2746 from $t2 to $fp-6352
	# _tmp2747 = 0
	  li $t2, 0		# load constant value 0 into $t2
	  sw $t2, -6356($fp)	# spill _tmp2747 from $t2 to $fp-6356
	# _tmp2748 = *(_tmp2745)
	  lw $t0, -6348($fp)	# fill _tmp2745 to $t0 from $fp-6348
	  lw $t2, 0($t0) 	# load with offset
	  sw $t2, -6360($fp)	# spill _tmp2748 from $t2 to $fp-6360
	# _tmp2749 = _tmp2746 < _tmp2747
	  lw $t0, -6352($fp)	# fill _tmp2746 to $t0 from $fp-6352
	  lw $t1, -6356($fp)	# fill _tmp2747 to $t1 from $fp-6356
	  slt $t2, $t0, $t1	
	  sw $t2, -6364($fp)	# spill _tmp2749 from $t2 to $fp-6364
	# _tmp2750 = _tmp2748 < _tmp2746
	  lw $t0, -6360($fp)	# fill _tmp2748 to $t0 from $fp-6360
	  lw $t1, -6352($fp)	# fill _tmp2746 to $t1 from $fp-6352
	  slt $t2, $t0, $t1	
	  sw $t2, -6368($fp)	# spill _tmp2750 from $t2 to $fp-6368
	# _tmp2751 = _tmp2748 == _tmp2746
	  lw $t0, -6360($fp)	# fill _tmp2748 to $t0 from $fp-6360
	  lw $t1, -6352($fp)	# fill _tmp2746 to $t1 from $fp-6352
	  seq $t2, $t0, $t1	
	  sw $t2, -6372($fp)	# spill _tmp2751 from $t2 to $fp-6372
	# _tmp2752 = _tmp2750 || _tmp2751
	  lw $t0, -6368($fp)	# fill _tmp2750 to $t0 from $fp-6368
	  lw $t1, -6372($fp)	# fill _tmp2751 to $t1 from $fp-6372
	  or $t2, $t0, $t1	
	  sw $t2, -6376($fp)	# spill _tmp2752 from $t2 to $fp-6376
	# _tmp2753 = _tmp2752 || _tmp2749
	  lw $t0, -6376($fp)	# fill _tmp2752 to $t0 from $fp-6376
	  lw $t1, -6364($fp)	# fill _tmp2749 to $t1 from $fp-6364
	  or $t2, $t0, $t1	
	  sw $t2, -6380($fp)	# spill _tmp2753 from $t2 to $fp-6380
	# IfZ _tmp2753 Goto _L267
	  lw $t0, -6380($fp)	# fill _tmp2753 to $t0 from $fp-6380
	  beqz $t0, _L267	# branch if _tmp2753 is zero 
	# _tmp2754 = "Decaf runtime error: Array subscript out of bound..."
	  .data			# create string constant marked with label
	  _string171: .asciiz "Decaf runtime error: Array subscript out of bounds\n"
	  .text
	  la $t2, _string171	# load label
	  sw $t2, -6384($fp)	# spill _tmp2754 from $t2 to $fp-6384
	# PushParam _tmp2754
	  subu $sp, $sp, 4	# decrement sp to make space for param
	  lw $t0, -6384($fp)	# fill _tmp2754 to $t0 from $fp-6384
	  sw $t0, 4($sp)	# copy param value to stack
	# LCall _PrintString
	  jal _PrintString   	# jump to function
	# PopParams 4
	  add $sp, $sp, 4	# pop params off stack
	# LCall _Halt
	  jal _Halt          	# jump to function
  _L267:
	# _tmp2755 = 4
	  li $t2, 4		# load constant value 4 into $t2
	  sw $t2, -6388($fp)	# spill _tmp2755 from $t2 to $fp-6388
	# _tmp2756 = _tmp2746 * _tmp2755
	  lw $t0, -6352($fp)	# fill _tmp2746 to $t0 from $fp-6352
	  lw $t1, -6388($fp)	# fill _tmp2755 to $t1 from $fp-6388
	  mul $t2, $t0, $t1	
	  sw $t2, -6392($fp)	# spill _tmp2756 from $t2 to $fp-6392
	# _tmp2757 = _tmp2756 + _tmp2755
	  lw $t0, -6392($fp)	# fill _tmp2756 to $t0 from $fp-6392
	  lw $t1, -6388($fp)	# fill _tmp2755 to $t1 from $fp-6388
	  add $t2, $t0, $t1	
	  sw $t2, -6396($fp)	# spill _tmp2757 from $t2 to $fp-6396
	# _tmp2758 = _tmp2745 + _tmp2757
	  lw $t0, -6348($fp)	# fill _tmp2745 to $t0 from $fp-6348
	  lw $t1, -6396($fp)	# fill _tmp2757 to $t1 from $fp-6396
	  add $t2, $t0, $t1	
	  sw $t2, -6400($fp)	# spill _tmp2758 from $t2 to $fp-6400
	# _tmp2759 = *(_tmp2758)
	  lw $t0, -6400($fp)	# fill _tmp2758 to $t0 from $fp-6400
	  lw $t2, 0($t0) 	# load with offset
	  sw $t2, -6404($fp)	# spill _tmp2759 from $t2 to $fp-6404
	# _tmp2760 = 1
	  li $t2, 1		# load constant value 1 into $t2
	  sw $t2, -6408($fp)	# spill _tmp2760 from $t2 to $fp-6408
	# _tmp2761 = 0
	  li $t2, 0		# load constant value 0 into $t2
	  sw $t2, -6412($fp)	# spill _tmp2761 from $t2 to $fp-6412
	# _tmp2762 = *(_tmp2759)
	  lw $t0, -6404($fp)	# fill _tmp2759 to $t0 from $fp-6404
	  lw $t2, 0($t0) 	# load with offset
	  sw $t2, -6416($fp)	# spill _tmp2762 from $t2 to $fp-6416
	# _tmp2763 = _tmp2760 < _tmp2761
	  lw $t0, -6408($fp)	# fill _tmp2760 to $t0 from $fp-6408
	  lw $t1, -6412($fp)	# fill _tmp2761 to $t1 from $fp-6412
	  slt $t2, $t0, $t1	
	  sw $t2, -6420($fp)	# spill _tmp2763 from $t2 to $fp-6420
	# _tmp2764 = _tmp2762 < _tmp2760
	  lw $t0, -6416($fp)	# fill _tmp2762 to $t0 from $fp-6416
	  lw $t1, -6408($fp)	# fill _tmp2760 to $t1 from $fp-6408
	  slt $t2, $t0, $t1	
	  sw $t2, -6424($fp)	# spill _tmp2764 from $t2 to $fp-6424
	# _tmp2765 = _tmp2762 == _tmp2760
	  lw $t0, -6416($fp)	# fill _tmp2762 to $t0 from $fp-6416
	  lw $t1, -6408($fp)	# fill _tmp2760 to $t1 from $fp-6408
	  seq $t2, $t0, $t1	
	  sw $t2, -6428($fp)	# spill _tmp2765 from $t2 to $fp-6428
	# _tmp2766 = _tmp2764 || _tmp2765
	  lw $t0, -6424($fp)	# fill _tmp2764 to $t0 from $fp-6424
	  lw $t1, -6428($fp)	# fill _tmp2765 to $t1 from $fp-6428
	  or $t2, $t0, $t1	
	  sw $t2, -6432($fp)	# spill _tmp2766 from $t2 to $fp-6432
	# _tmp2767 = _tmp2766 || _tmp2763
	  lw $t0, -6432($fp)	# fill _tmp2766 to $t0 from $fp-6432
	  lw $t1, -6420($fp)	# fill _tmp2763 to $t1 from $fp-6420
	  or $t2, $t0, $t1	
	  sw $t2, -6436($fp)	# spill _tmp2767 from $t2 to $fp-6436
	# IfZ _tmp2767 Goto _L268
	  lw $t0, -6436($fp)	# fill _tmp2767 to $t0 from $fp-6436
	  beqz $t0, _L268	# branch if _tmp2767 is zero 
	# _tmp2768 = "Decaf runtime error: Array subscript out of bound..."
	  .data			# create string constant marked with label
	  _string172: .asciiz "Decaf runtime error: Array subscript out of bounds\n"
	  .text
	  la $t2, _string172	# load label
	  sw $t2, -6440($fp)	# spill _tmp2768 from $t2 to $fp-6440
	# PushParam _tmp2768
	  subu $sp, $sp, 4	# decrement sp to make space for param
	  lw $t0, -6440($fp)	# fill _tmp2768 to $t0 from $fp-6440
	  sw $t0, 4($sp)	# copy param value to stack
	# LCall _PrintString
	  jal _PrintString   	# jump to function
	# PopParams 4
	  add $sp, $sp, 4	# pop params off stack
	# LCall _Halt
	  jal _Halt          	# jump to function
  _L268:
	# _tmp2769 = 4
	  li $t2, 4		# load constant value 4 into $t2
	  sw $t2, -6444($fp)	# spill _tmp2769 from $t2 to $fp-6444
	# _tmp2770 = _tmp2760 * _tmp2769
	  lw $t0, -6408($fp)	# fill _tmp2760 to $t0 from $fp-6408
	  lw $t1, -6444($fp)	# fill _tmp2769 to $t1 from $fp-6444
	  mul $t2, $t0, $t1	
	  sw $t2, -6448($fp)	# spill _tmp2770 from $t2 to $fp-6448
	# _tmp2771 = _tmp2770 + _tmp2769
	  lw $t0, -6448($fp)	# fill _tmp2770 to $t0 from $fp-6448
	  lw $t1, -6444($fp)	# fill _tmp2769 to $t1 from $fp-6444
	  add $t2, $t0, $t1	
	  sw $t2, -6452($fp)	# spill _tmp2771 from $t2 to $fp-6452
	# _tmp2772 = _tmp2759 + _tmp2771
	  lw $t0, -6404($fp)	# fill _tmp2759 to $t0 from $fp-6404
	  lw $t1, -6452($fp)	# fill _tmp2771 to $t1 from $fp-6452
	  add $t2, $t0, $t1	
	  sw $t2, -6456($fp)	# spill _tmp2772 from $t2 to $fp-6456
	# _tmp2773 = *(_tmp2772)
	  lw $t0, -6456($fp)	# fill _tmp2772 to $t0 from $fp-6456
	  lw $t2, 0($t0) 	# load with offset
	  sw $t2, -6460($fp)	# spill _tmp2773 from $t2 to $fp-6460
	# PushParam _tmp2773
	  subu $sp, $sp, 4	# decrement sp to make space for param
	  lw $t0, -6460($fp)	# fill _tmp2773 to $t0 from $fp-6460
	  sw $t0, 4($sp)	# copy param value to stack
	# _tmp2774 = *(_tmp2773)
	  lw $t0, -6460($fp)	# fill _tmp2773 to $t0 from $fp-6460
	  lw $t2, 0($t0) 	# load with offset
	  sw $t2, -6464($fp)	# spill _tmp2774 from $t2 to $fp-6464
	# _tmp2775 = *(_tmp2774 + 20)
	  lw $t0, -6464($fp)	# fill _tmp2774 to $t0 from $fp-6464
	  lw $t2, 20($t0) 	# load with offset
	  sw $t2, -6468($fp)	# spill _tmp2775 from $t2 to $fp-6468
	# _tmp2776 = ACall _tmp2775
	  lw $t0, -6468($fp)	# fill _tmp2775 to $t0 from $fp-6468
	  jalr $t0            	# jump to function
	  move $t2, $v0		# copy function return value from $v0
	  sw $t2, -6472($fp)	# spill _tmp2776 from $t2 to $fp-6472
	# PopParams 8
	  add $sp, $sp, 8	# pop params off stack
	# _tmp2777 = _tmp2744 && _tmp2776
	  lw $t0, -6344($fp)	# fill _tmp2744 to $t0 from $fp-6344
	  lw $t1, -6472($fp)	# fill _tmp2776 to $t1 from $fp-6472
	  and $t2, $t0, $t1	
	  sw $t2, -6476($fp)	# spill _tmp2777 from $t2 to $fp-6476
	# PushParam playerMark
	  subu $sp, $sp, 4	# decrement sp to make space for param
	  lw $t0, 12($fp)	# fill playerMark to $t0 from $fp+12
	  sw $t0, 4($sp)	# copy param value to stack
	# _tmp2779 = *(this + 4)
	  lw $t0, 4($fp)	# fill this to $t0 from $fp+4
	  lw $t2, 4($t0) 	# load with offset
	  sw $t2, -6484($fp)	# spill _tmp2779 from $t2 to $fp-6484
	# _tmp2780 = 2
	  li $t2, 2		# load constant value 2 into $t2
	  sw $t2, -6488($fp)	# spill _tmp2780 from $t2 to $fp-6488
	# _tmp2781 = 0
	  li $t2, 0		# load constant value 0 into $t2
	  sw $t2, -6492($fp)	# spill _tmp2781 from $t2 to $fp-6492
	# _tmp2782 = *(_tmp2779)
	  lw $t0, -6484($fp)	# fill _tmp2779 to $t0 from $fp-6484
	  lw $t2, 0($t0) 	# load with offset
	  sw $t2, -6496($fp)	# spill _tmp2782 from $t2 to $fp-6496
	# _tmp2783 = _tmp2780 < _tmp2781
	  lw $t0, -6488($fp)	# fill _tmp2780 to $t0 from $fp-6488
	  lw $t1, -6492($fp)	# fill _tmp2781 to $t1 from $fp-6492
	  slt $t2, $t0, $t1	
	  sw $t2, -6500($fp)	# spill _tmp2783 from $t2 to $fp-6500
	# _tmp2784 = _tmp2782 < _tmp2780
	  lw $t0, -6496($fp)	# fill _tmp2782 to $t0 from $fp-6496
	  lw $t1, -6488($fp)	# fill _tmp2780 to $t1 from $fp-6488
	  slt $t2, $t0, $t1	
	  sw $t2, -6504($fp)	# spill _tmp2784 from $t2 to $fp-6504
	# _tmp2785 = _tmp2782 == _tmp2780
	  lw $t0, -6496($fp)	# fill _tmp2782 to $t0 from $fp-6496
	  lw $t1, -6488($fp)	# fill _tmp2780 to $t1 from $fp-6488
	  seq $t2, $t0, $t1	
	  sw $t2, -6508($fp)	# spill _tmp2785 from $t2 to $fp-6508
	# _tmp2786 = _tmp2784 || _tmp2785
	  lw $t0, -6504($fp)	# fill _tmp2784 to $t0 from $fp-6504
	  lw $t1, -6508($fp)	# fill _tmp2785 to $t1 from $fp-6508
	  or $t2, $t0, $t1	
	  sw $t2, -6512($fp)	# spill _tmp2786 from $t2 to $fp-6512
	# _tmp2787 = _tmp2786 || _tmp2783
	  lw $t0, -6512($fp)	# fill _tmp2786 to $t0 from $fp-6512
	  lw $t1, -6500($fp)	# fill _tmp2783 to $t1 from $fp-6500
	  or $t2, $t0, $t1	
	  sw $t2, -6516($fp)	# spill _tmp2787 from $t2 to $fp-6516
	# IfZ _tmp2787 Goto _L271
	  lw $t0, -6516($fp)	# fill _tmp2787 to $t0 from $fp-6516
	  beqz $t0, _L271	# branch if _tmp2787 is zero 
	# _tmp2788 = "Decaf runtime error: Array subscript out of bound..."
	  .data			# create string constant marked with label
	  _string173: .asciiz "Decaf runtime error: Array subscript out of bounds\n"
	  .text
	  la $t2, _string173	# load label
	  sw $t2, -6520($fp)	# spill _tmp2788 from $t2 to $fp-6520
	# PushParam _tmp2788
	  subu $sp, $sp, 4	# decrement sp to make space for param
	  lw $t0, -6520($fp)	# fill _tmp2788 to $t0 from $fp-6520
	  sw $t0, 4($sp)	# copy param value to stack
	# LCall _PrintString
	  jal _PrintString   	# jump to function
	# PopParams 4
	  add $sp, $sp, 4	# pop params off stack
	# LCall _Halt
	  jal _Halt          	# jump to function
  _L271:
	# _tmp2789 = 4
	  li $t2, 4		# load constant value 4 into $t2
	  sw $t2, -6524($fp)	# spill _tmp2789 from $t2 to $fp-6524
	# _tmp2790 = _tmp2780 * _tmp2789
	  lw $t0, -6488($fp)	# fill _tmp2780 to $t0 from $fp-6488
	  lw $t1, -6524($fp)	# fill _tmp2789 to $t1 from $fp-6524
	  mul $t2, $t0, $t1	
	  sw $t2, -6528($fp)	# spill _tmp2790 from $t2 to $fp-6528
	# _tmp2791 = _tmp2790 + _tmp2789
	  lw $t0, -6528($fp)	# fill _tmp2790 to $t0 from $fp-6528
	  lw $t1, -6524($fp)	# fill _tmp2789 to $t1 from $fp-6524
	  add $t2, $t0, $t1	
	  sw $t2, -6532($fp)	# spill _tmp2791 from $t2 to $fp-6532
	# _tmp2792 = _tmp2779 + _tmp2791
	  lw $t0, -6484($fp)	# fill _tmp2779 to $t0 from $fp-6484
	  lw $t1, -6532($fp)	# fill _tmp2791 to $t1 from $fp-6532
	  add $t2, $t0, $t1	
	  sw $t2, -6536($fp)	# spill _tmp2792 from $t2 to $fp-6536
	# _tmp2793 = *(_tmp2792)
	  lw $t0, -6536($fp)	# fill _tmp2792 to $t0 from $fp-6536
	  lw $t2, 0($t0) 	# load with offset
	  sw $t2, -6540($fp)	# spill _tmp2793 from $t2 to $fp-6540
	# _tmp2794 = 0
	  li $t2, 0		# load constant value 0 into $t2
	  sw $t2, -6544($fp)	# spill _tmp2794 from $t2 to $fp-6544
	# _tmp2795 = 0
	  li $t2, 0		# load constant value 0 into $t2
	  sw $t2, -6548($fp)	# spill _tmp2795 from $t2 to $fp-6548
	# _tmp2796 = *(_tmp2793)
	  lw $t0, -6540($fp)	# fill _tmp2793 to $t0 from $fp-6540
	  lw $t2, 0($t0) 	# load with offset
	  sw $t2, -6552($fp)	# spill _tmp2796 from $t2 to $fp-6552
	# _tmp2797 = _tmp2794 < _tmp2795
	  lw $t0, -6544($fp)	# fill _tmp2794 to $t0 from $fp-6544
	  lw $t1, -6548($fp)	# fill _tmp2795 to $t1 from $fp-6548
	  slt $t2, $t0, $t1	
	  sw $t2, -6556($fp)	# spill _tmp2797 from $t2 to $fp-6556
	# _tmp2798 = _tmp2796 < _tmp2794
	  lw $t0, -6552($fp)	# fill _tmp2796 to $t0 from $fp-6552
	  lw $t1, -6544($fp)	# fill _tmp2794 to $t1 from $fp-6544
	  slt $t2, $t0, $t1	
	  sw $t2, -6560($fp)	# spill _tmp2798 from $t2 to $fp-6560
	# _tmp2799 = _tmp2796 == _tmp2794
	  lw $t0, -6552($fp)	# fill _tmp2796 to $t0 from $fp-6552
	  lw $t1, -6544($fp)	# fill _tmp2794 to $t1 from $fp-6544
	  seq $t2, $t0, $t1	
	  sw $t2, -6564($fp)	# spill _tmp2799 from $t2 to $fp-6564
	# _tmp2800 = _tmp2798 || _tmp2799
	  lw $t0, -6560($fp)	# fill _tmp2798 to $t0 from $fp-6560
	  lw $t1, -6564($fp)	# fill _tmp2799 to $t1 from $fp-6564
	  or $t2, $t0, $t1	
	  sw $t2, -6568($fp)	# spill _tmp2800 from $t2 to $fp-6568
	# _tmp2801 = _tmp2800 || _tmp2797
	  lw $t0, -6568($fp)	# fill _tmp2800 to $t0 from $fp-6568
	  lw $t1, -6556($fp)	# fill _tmp2797 to $t1 from $fp-6556
	  or $t2, $t0, $t1	
	  sw $t2, -6572($fp)	# spill _tmp2801 from $t2 to $fp-6572
	# IfZ _tmp2801 Goto _L272
	  lw $t0, -6572($fp)	# fill _tmp2801 to $t0 from $fp-6572
	  beqz $t0, _L272	# branch if _tmp2801 is zero 
	# _tmp2802 = "Decaf runtime error: Array subscript out of bound..."
	  .data			# create string constant marked with label
	  _string174: .asciiz "Decaf runtime error: Array subscript out of bounds\n"
	  .text
	  la $t2, _string174	# load label
	  sw $t2, -6576($fp)	# spill _tmp2802 from $t2 to $fp-6576
	# PushParam _tmp2802
	  subu $sp, $sp, 4	# decrement sp to make space for param
	  lw $t0, -6576($fp)	# fill _tmp2802 to $t0 from $fp-6576
	  sw $t0, 4($sp)	# copy param value to stack
	# LCall _PrintString
	  jal _PrintString   	# jump to function
	# PopParams 4
	  add $sp, $sp, 4	# pop params off stack
	# LCall _Halt
	  jal _Halt          	# jump to function
  _L272:
	# _tmp2803 = 4
	  li $t2, 4		# load constant value 4 into $t2
	  sw $t2, -6580($fp)	# spill _tmp2803 from $t2 to $fp-6580
	# _tmp2804 = _tmp2794 * _tmp2803
	  lw $t0, -6544($fp)	# fill _tmp2794 to $t0 from $fp-6544
	  lw $t1, -6580($fp)	# fill _tmp2803 to $t1 from $fp-6580
	  mul $t2, $t0, $t1	
	  sw $t2, -6584($fp)	# spill _tmp2804 from $t2 to $fp-6584
	# _tmp2805 = _tmp2804 + _tmp2803
	  lw $t0, -6584($fp)	# fill _tmp2804 to $t0 from $fp-6584
	  lw $t1, -6580($fp)	# fill _tmp2803 to $t1 from $fp-6580
	  add $t2, $t0, $t1	
	  sw $t2, -6588($fp)	# spill _tmp2805 from $t2 to $fp-6588
	# _tmp2806 = _tmp2793 + _tmp2805
	  lw $t0, -6540($fp)	# fill _tmp2793 to $t0 from $fp-6540
	  lw $t1, -6588($fp)	# fill _tmp2805 to $t1 from $fp-6588
	  add $t2, $t0, $t1	
	  sw $t2, -6592($fp)	# spill _tmp2806 from $t2 to $fp-6592
	# _tmp2807 = *(_tmp2806)
	  lw $t0, -6592($fp)	# fill _tmp2806 to $t0 from $fp-6592
	  lw $t2, 0($t0) 	# load with offset
	  sw $t2, -6596($fp)	# spill _tmp2807 from $t2 to $fp-6596
	# PushParam _tmp2807
	  subu $sp, $sp, 4	# decrement sp to make space for param
	  lw $t0, -6596($fp)	# fill _tmp2807 to $t0 from $fp-6596
	  sw $t0, 4($sp)	# copy param value to stack
	# _tmp2808 = *(_tmp2807)
	  lw $t0, -6596($fp)	# fill _tmp2807 to $t0 from $fp-6596
	  lw $t2, 0($t0) 	# load with offset
	  sw $t2, -6600($fp)	# spill _tmp2808 from $t2 to $fp-6600
	# _tmp2809 = *(_tmp2808 + 20)
	  lw $t0, -6600($fp)	# fill _tmp2808 to $t0 from $fp-6600
	  lw $t2, 20($t0) 	# load with offset
	  sw $t2, -6604($fp)	# spill _tmp2809 from $t2 to $fp-6604
	# _tmp2810 = ACall _tmp2809
	  lw $t0, -6604($fp)	# fill _tmp2809 to $t0 from $fp-6604
	  jalr $t0            	# jump to function
	  move $t2, $v0		# copy function return value from $v0
	  sw $t2, -6608($fp)	# spill _tmp2810 from $t2 to $fp-6608
	# PopParams 8
	  add $sp, $sp, 8	# pop params off stack
	# IfZ _tmp2810 Goto _L270
	  lw $t0, -6608($fp)	# fill _tmp2810 to $t0 from $fp-6608
	  beqz $t0, _L270	# branch if _tmp2810 is zero 
	# _tmp2811 = 0
	  li $t2, 0		# load constant value 0 into $t2
	  sw $t2, -6612($fp)	# spill _tmp2811 from $t2 to $fp-6612
	# _tmp2778 = _tmp2811
	  lw $t2, -6612($fp)	# fill _tmp2811 to $t2 from $fp-6612
	  sw $t2, -6480($fp)	# spill _tmp2778 from $t2 to $fp-6480
	# Goto _L269
	  b _L269		# unconditional branch
  _L270:
	# _tmp2812 = 1
	  li $t2, 1		# load constant value 1 into $t2
	  sw $t2, -6616($fp)	# spill _tmp2812 from $t2 to $fp-6616
	# _tmp2778 = _tmp2812
	  lw $t2, -6616($fp)	# fill _tmp2812 to $t2 from $fp-6616
	  sw $t2, -6480($fp)	# spill _tmp2778 from $t2 to $fp-6480
  _L269:
	# _tmp2813 = _tmp2777 && _tmp2778
	  lw $t0, -6476($fp)	# fill _tmp2777 to $t0 from $fp-6476
	  lw $t1, -6480($fp)	# fill _tmp2778 to $t1 from $fp-6480
	  and $t2, $t0, $t1	
	  sw $t2, -6620($fp)	# spill _tmp2813 from $t2 to $fp-6620
	# IfZ _tmp2813 Goto _L263
	  lw $t0, -6620($fp)	# fill _tmp2813 to $t0 from $fp-6620
	  beqz $t0, _L263	# branch if _tmp2813 is zero 
	# _tmp2814 = 2
	  li $t2, 2		# load constant value 2 into $t2
	  sw $t2, -6624($fp)	# spill _tmp2814 from $t2 to $fp-6624
	# row = _tmp2814
	  lw $t2, -6624($fp)	# fill _tmp2814 to $t2 from $fp-6624
	  sw $t2, -8($fp)	# spill row from $t2 to $fp-8
	# _tmp2815 = 0
	  li $t2, 0		# load constant value 0 into $t2
	  sw $t2, -6628($fp)	# spill _tmp2815 from $t2 to $fp-6628
	# column = _tmp2815
	  lw $t2, -6628($fp)	# fill _tmp2815 to $t2 from $fp-6628
	  sw $t2, -12($fp)	# spill column from $t2 to $fp-12
	# Goto _L264
	  b _L264		# unconditional branch
  _L263:
  _L264:
  _L254:
  _L244:
  _L234:
  _L224:
  _L214:
  _L204:
  _L194:
  _L184:
  _L174:
  _L164:
  _L154:
  _L144:
  _L134:
  _L124:
  _L114:
	# _tmp2817 = 1
	  li $t2, 1		# load constant value 1 into $t2
	  sw $t2, -6636($fp)	# spill _tmp2817 from $t2 to $fp-6636
	# _tmp2818 = 0
	  li $t2, 0		# load constant value 0 into $t2
	  sw $t2, -6640($fp)	# spill _tmp2818 from $t2 to $fp-6640
	# _tmp2819 = _tmp2818 - _tmp2817
	  lw $t0, -6640($fp)	# fill _tmp2818 to $t0 from $fp-6640
	  lw $t1, -6636($fp)	# fill _tmp2817 to $t1 from $fp-6636
	  sub $t2, $t0, $t1	
	  sw $t2, -6644($fp)	# spill _tmp2819 from $t2 to $fp-6644
	# _tmp2820 = row == _tmp2819
	  lw $t0, -8($fp)	# fill row to $t0 from $fp-8
	  lw $t1, -6644($fp)	# fill _tmp2819 to $t1 from $fp-6644
	  seq $t2, $t0, $t1	
	  sw $t2, -6648($fp)	# spill _tmp2820 from $t2 to $fp-6648
	# IfZ _tmp2820 Goto _L276
	  lw $t0, -6648($fp)	# fill _tmp2820 to $t0 from $fp-6648
	  beqz $t0, _L276	# branch if _tmp2820 is zero 
	# _tmp2821 = 0
	  li $t2, 0		# load constant value 0 into $t2
	  sw $t2, -6652($fp)	# spill _tmp2821 from $t2 to $fp-6652
	# _tmp2816 = _tmp2821
	  lw $t2, -6652($fp)	# fill _tmp2821 to $t2 from $fp-6652
	  sw $t2, -6632($fp)	# spill _tmp2816 from $t2 to $fp-6632
	# Goto _L275
	  b _L275		# unconditional branch
  _L276:
	# _tmp2822 = 1
	  li $t2, 1		# load constant value 1 into $t2
	  sw $t2, -6656($fp)	# spill _tmp2822 from $t2 to $fp-6656
	# _tmp2816 = _tmp2822
	  lw $t2, -6656($fp)	# fill _tmp2822 to $t2 from $fp-6656
	  sw $t2, -6632($fp)	# spill _tmp2816 from $t2 to $fp-6632
  _L275:
	# IfZ _tmp2816 Goto _L273
	  lw $t0, -6632($fp)	# fill _tmp2816 to $t0 from $fp-6632
	  beqz $t0, _L273	# branch if _tmp2816 is zero 
	# PushParam playerMark
	  subu $sp, $sp, 4	# decrement sp to make space for param
	  lw $t0, 12($fp)	# fill playerMark to $t0 from $fp+12
	  sw $t0, 4($sp)	# copy param value to stack
	# PushParam column
	  subu $sp, $sp, 4	# decrement sp to make space for param
	  lw $t0, -12($fp)	# fill column to $t0 from $fp-12
	  sw $t0, 4($sp)	# copy param value to stack
	# PushParam row
	  subu $sp, $sp, 4	# decrement sp to make space for param
	  lw $t0, -8($fp)	# fill row to $t0 from $fp-8
	  sw $t0, 4($sp)	# copy param value to stack
	# PushParam this
	  subu $sp, $sp, 4	# decrement sp to make space for param
	  lw $t0, 4($fp)	# fill this to $t0 from $fp+4
	  sw $t0, 4($sp)	# copy param value to stack
	# _tmp2823 = *(this)
	  lw $t0, 4($fp)	# fill this to $t0 from $fp+4
	  lw $t2, 0($t0) 	# load with offset
	  sw $t2, -6660($fp)	# spill _tmp2823 from $t2 to $fp-6660
	# _tmp2824 = *(_tmp2823 + 12)
	  lw $t0, -6660($fp)	# fill _tmp2823 to $t0 from $fp-6660
	  lw $t2, 12($t0) 	# load with offset
	  sw $t2, -6664($fp)	# spill _tmp2824 from $t2 to $fp-6664
	# ACall _tmp2824
	  lw $t0, -6664($fp)	# fill _tmp2824 to $t0 from $fp-6664
	  jalr $t0            	# jump to function
	# PopParams 16
	  add $sp, $sp, 16	# pop params off stack
	# _tmp2825 = 1
	  li $t2, 1		# load constant value 1 into $t2
	  sw $t2, -6668($fp)	# spill _tmp2825 from $t2 to $fp-6668
	# Return _tmp2825
	  lw $t2, -6668($fp)	# fill _tmp2825 to $t2 from $fp-6668
	  move $v0, $t2		# assign return value into $v0
	  move $sp, $fp		# pop callee frame off stack
	  lw $ra, -4($fp)	# restore saved ra
	  lw $fp, 0($fp)	# restore saved fp
	  jr $ra		# return from function
	# Goto _L274
	  b _L274		# unconditional branch
  _L273:
	# _tmp2826 = 0
	  li $t2, 0		# load constant value 0 into $t2
	  sw $t2, -6672($fp)	# spill _tmp2826 from $t2 to $fp-6672
	# Return _tmp2826
	  lw $t2, -6672($fp)	# fill _tmp2826 to $t2 from $fp-6672
	  move $v0, $t2		# assign return value into $v0
	  move $sp, $fp		# pop callee frame off stack
	  lw $ra, -4($fp)	# restore saved ra
	  lw $fp, 0($fp)	# restore saved fp
	  jr $ra		# return from function
  _L274:
	# EndFunc
	# (below handles reaching end of fn body with no explicit return)
	  move $sp, $fp		# pop callee frame off stack
	  lw $ra, -4($fp)	# restore saved ra
	  lw $fp, 0($fp)	# restore saved fp
	  jr $ra		# return from function
	# VTable for class Grid
	  .data
	  .align 2
	  Grid:		# label for class Grid vtable
	  .word Grid.____Init
	  .word Grid.____Full
	  .word Grid.____Draw
	  .word Grid.____Update
	  .word Grid.____IsMoveLegal
	  .word Grid.____GameNotWon
	  .word Grid.____BlockedPlay
	  .text
  Computer.____Init:
	# BeginFunc 4
	  subu $sp, $sp, 8	# decrement sp to make space to save ra, fp
	  sw $fp, 8($sp)	# save fp
	  sw $ra, 4($sp)	# save ra
	  addiu $fp, $sp, 8	# set up new fp
	  subu $sp, $sp, 4	# decrement sp to make space for locals/temps
	# _tmp2827 = "0"
	  .data			# create string constant marked with label
	  _string175: .asciiz "0"
	  .text
	  la $t2, _string175	# load label
	  sw $t2, -8($fp)	# spill _tmp2827 from $t2 to $fp-8
	# *(this + 4) = _tmp2827
	  lw $t0, -8($fp)	# fill _tmp2827 to $t0 from $fp-8
	  lw $t2, 4($fp)	# fill this to $t2 from $fp+4
	  sw $t0, 4($t2) 	# store with offset
	# EndFunc
	# (below handles reaching end of fn body with no explicit return)
	  move $sp, $fp		# pop callee frame off stack
	  lw $ra, -4($fp)	# restore saved ra
	  lw $fp, 0($fp)	# restore saved fp
	  jr $ra		# return from function
  Computer.____TakeTurn:
	# BeginFunc 216
	  subu $sp, $sp, 8	# decrement sp to make space to save ra, fp
	  sw $fp, 8($sp)	# save fp
	  sw $ra, 4($sp)	# save ra
	  addiu $fp, $sp, 8	# set up new fp
	  subu $sp, $sp, 216	# decrement sp to make space for locals/temps
	# _tmp2828 = 0
	  li $t2, 0		# load constant value 0 into $t2
	  sw $t2, -20($fp)	# spill _tmp2828 from $t2 to $fp-20
	# legalMove = _tmp2828
	  lw $t2, -20($fp)	# fill _tmp2828 to $t2 from $fp-20
	  sw $t2, -16($fp)	# spill legalMove from $t2 to $fp-16
	# PushParam human
	  subu $sp, $sp, 4	# decrement sp to make space for param
	  lw $t0, 12($fp)	# fill human to $t0 from $fp+12
	  sw $t0, 4($sp)	# copy param value to stack
	# _tmp2830 = *(human)
	  lw $t0, 12($fp)	# fill human to $t0 from $fp+12
	  lw $t2, 0($t0) 	# load with offset
	  sw $t2, -28($fp)	# spill _tmp2830 from $t2 to $fp-28
	# _tmp2831 = *(_tmp2830)
	  lw $t0, -28($fp)	# fill _tmp2830 to $t0 from $fp-28
	  lw $t2, 0($t0) 	# load with offset
	  sw $t2, -32($fp)	# spill _tmp2831 from $t2 to $fp-32
	# _tmp2832 = ACall _tmp2831
	  lw $t0, -32($fp)	# fill _tmp2831 to $t0 from $fp-32
	  jalr $t0            	# jump to function
	  move $t2, $v0		# copy function return value from $v0
	  sw $t2, -36($fp)	# spill _tmp2832 from $t2 to $fp-36
	# PopParams 4
	  add $sp, $sp, 4	# pop params off stack
	# PushParam this
	  subu $sp, $sp, 4	# decrement sp to make space for param
	  lw $t0, 4($fp)	# fill this to $t0 from $fp+4
	  sw $t0, 4($sp)	# copy param value to stack
	# _tmp2833 = *(this)
	  lw $t0, 4($fp)	# fill this to $t0 from $fp+4
	  lw $t2, 0($t0) 	# load with offset
	  sw $t2, -40($fp)	# spill _tmp2833 from $t2 to $fp-40
	# _tmp2834 = *(_tmp2833)
	  lw $t0, -40($fp)	# fill _tmp2833 to $t0 from $fp-40
	  lw $t2, 0($t0) 	# load with offset
	  sw $t2, -44($fp)	# spill _tmp2834 from $t2 to $fp-44
	# _tmp2835 = ACall _tmp2834
	  lw $t0, -44($fp)	# fill _tmp2834 to $t0 from $fp-44
	  jalr $t0            	# jump to function
	  move $t2, $v0		# copy function return value from $v0
	  sw $t2, -48($fp)	# spill _tmp2835 from $t2 to $fp-48
	# PopParams 4
	  add $sp, $sp, 4	# pop params off stack
	# PushParam _tmp2835
	  subu $sp, $sp, 4	# decrement sp to make space for param
	  lw $t0, -48($fp)	# fill _tmp2835 to $t0 from $fp-48
	  sw $t0, 4($sp)	# copy param value to stack
	# PushParam _tmp2832
	  subu $sp, $sp, 4	# decrement sp to make space for param
	  lw $t0, -36($fp)	# fill _tmp2832 to $t0 from $fp-36
	  sw $t0, 4($sp)	# copy param value to stack
	# PushParam grid
	  subu $sp, $sp, 4	# decrement sp to make space for param
	  lw $t0, 8($fp)	# fill grid to $t0 from $fp+8
	  sw $t0, 4($sp)	# copy param value to stack
	# _tmp2836 = *(grid)
	  lw $t0, 8($fp)	# fill grid to $t0 from $fp+8
	  lw $t2, 0($t0) 	# load with offset
	  sw $t2, -52($fp)	# spill _tmp2836 from $t2 to $fp-52
	# _tmp2837 = *(_tmp2836 + 24)
	  lw $t0, -52($fp)	# fill _tmp2836 to $t0 from $fp-52
	  lw $t2, 24($t0) 	# load with offset
	  sw $t2, -56($fp)	# spill _tmp2837 from $t2 to $fp-56
	# _tmp2838 = ACall _tmp2837
	  lw $t0, -56($fp)	# fill _tmp2837 to $t0 from $fp-56
	  jalr $t0            	# jump to function
	  move $t2, $v0		# copy function return value from $v0
	  sw $t2, -60($fp)	# spill _tmp2838 from $t2 to $fp-60
	# PopParams 12
	  add $sp, $sp, 12	# pop params off stack
	# IfZ _tmp2838 Goto _L280
	  lw $t0, -60($fp)	# fill _tmp2838 to $t0 from $fp-60
	  beqz $t0, _L280	# branch if _tmp2838 is zero 
	# _tmp2839 = 0
	  li $t2, 0		# load constant value 0 into $t2
	  sw $t2, -64($fp)	# spill _tmp2839 from $t2 to $fp-64
	# _tmp2829 = _tmp2839
	  lw $t2, -64($fp)	# fill _tmp2839 to $t2 from $fp-64
	  sw $t2, -24($fp)	# spill _tmp2829 from $t2 to $fp-24
	# Goto _L279
	  b _L279		# unconditional branch
  _L280:
	# _tmp2840 = 1
	  li $t2, 1		# load constant value 1 into $t2
	  sw $t2, -68($fp)	# spill _tmp2840 from $t2 to $fp-68
	# _tmp2829 = _tmp2840
	  lw $t2, -68($fp)	# fill _tmp2840 to $t2 from $fp-68
	  sw $t2, -24($fp)	# spill _tmp2829 from $t2 to $fp-24
  _L279:
	# IfZ _tmp2829 Goto _L277
	  lw $t0, -24($fp)	# fill _tmp2829 to $t0 from $fp-24
	  beqz $t0, _L277	# branch if _tmp2829 is zero 
  _L281:
	# IfZ legalMove Goto _L284
	  lw $t0, -16($fp)	# fill legalMove to $t0 from $fp-16
	  beqz $t0, _L284	# branch if legalMove is zero 
	# _tmp2842 = 0
	  li $t2, 0		# load constant value 0 into $t2
	  sw $t2, -76($fp)	# spill _tmp2842 from $t2 to $fp-76
	# _tmp2841 = _tmp2842
	  lw $t2, -76($fp)	# fill _tmp2842 to $t2 from $fp-76
	  sw $t2, -72($fp)	# spill _tmp2841 from $t2 to $fp-72
	# Goto _L283
	  b _L283		# unconditional branch
  _L284:
	# _tmp2843 = 1
	  li $t2, 1		# load constant value 1 into $t2
	  sw $t2, -80($fp)	# spill _tmp2843 from $t2 to $fp-80
	# _tmp2841 = _tmp2843
	  lw $t2, -80($fp)	# fill _tmp2843 to $t2 from $fp-80
	  sw $t2, -72($fp)	# spill _tmp2841 from $t2 to $fp-72
  _L283:
	# IfZ _tmp2841 Goto _L282
	  lw $t0, -72($fp)	# fill _tmp2841 to $t0 from $fp-72
	  beqz $t0, _L282	# branch if _tmp2841 is zero 
	# _tmp2844 = 0
	  li $t2, 0		# load constant value 0 into $t2
	  sw $t2, -84($fp)	# spill _tmp2844 from $t2 to $fp-84
	# _tmp2845 = 2
	  li $t2, 2		# load constant value 2 into $t2
	  sw $t2, -88($fp)	# spill _tmp2845 from $t2 to $fp-88
	# PushParam _tmp2845
	  subu $sp, $sp, 4	# decrement sp to make space for param
	  lw $t0, -88($fp)	# fill _tmp2845 to $t0 from $fp-88
	  sw $t0, 4($sp)	# copy param value to stack
	# PushParam _tmp2844
	  subu $sp, $sp, 4	# decrement sp to make space for param
	  lw $t0, -84($fp)	# fill _tmp2844 to $t0 from $fp-84
	  sw $t0, 4($sp)	# copy param value to stack
	# PushParam gRnd
	  subu $sp, $sp, 4	# decrement sp to make space for param
	  lw $t0, 0($gp)	# fill gRnd to $t0 from $gp+0
	  sw $t0, 4($sp)	# copy param value to stack
	# _tmp2846 = *(gRnd)
	  lw $t0, 0($gp)	# fill gRnd to $t0 from $gp+0
	  lw $t2, 0($t0) 	# load with offset
	  sw $t2, -92($fp)	# spill _tmp2846 from $t2 to $fp-92
	# _tmp2847 = *(_tmp2846 + 8)
	  lw $t0, -92($fp)	# fill _tmp2846 to $t0 from $fp-92
	  lw $t2, 8($t0) 	# load with offset
	  sw $t2, -96($fp)	# spill _tmp2847 from $t2 to $fp-96
	# _tmp2848 = ACall _tmp2847
	  lw $t0, -96($fp)	# fill _tmp2847 to $t0 from $fp-96
	  jalr $t0            	# jump to function
	  move $t2, $v0		# copy function return value from $v0
	  sw $t2, -100($fp)	# spill _tmp2848 from $t2 to $fp-100
	# PopParams 12
	  add $sp, $sp, 12	# pop params off stack
	# row = _tmp2848
	  lw $t2, -100($fp)	# fill _tmp2848 to $t2 from $fp-100
	  sw $t2, -8($fp)	# spill row from $t2 to $fp-8
	# _tmp2849 = 0
	  li $t2, 0		# load constant value 0 into $t2
	  sw $t2, -104($fp)	# spill _tmp2849 from $t2 to $fp-104
	# _tmp2850 = 2
	  li $t2, 2		# load constant value 2 into $t2
	  sw $t2, -108($fp)	# spill _tmp2850 from $t2 to $fp-108
	# PushParam _tmp2850
	  subu $sp, $sp, 4	# decrement sp to make space for param
	  lw $t0, -108($fp)	# fill _tmp2850 to $t0 from $fp-108
	  sw $t0, 4($sp)	# copy param value to stack
	# PushParam _tmp2849
	  subu $sp, $sp, 4	# decrement sp to make space for param
	  lw $t0, -104($fp)	# fill _tmp2849 to $t0 from $fp-104
	  sw $t0, 4($sp)	# copy param value to stack
	# PushParam gRnd
	  subu $sp, $sp, 4	# decrement sp to make space for param
	  lw $t0, 0($gp)	# fill gRnd to $t0 from $gp+0
	  sw $t0, 4($sp)	# copy param value to stack
	# _tmp2851 = *(gRnd)
	  lw $t0, 0($gp)	# fill gRnd to $t0 from $gp+0
	  lw $t2, 0($t0) 	# load with offset
	  sw $t2, -112($fp)	# spill _tmp2851 from $t2 to $fp-112
	# _tmp2852 = *(_tmp2851 + 8)
	  lw $t0, -112($fp)	# fill _tmp2851 to $t0 from $fp-112
	  lw $t2, 8($t0) 	# load with offset
	  sw $t2, -116($fp)	# spill _tmp2852 from $t2 to $fp-116
	# _tmp2853 = ACall _tmp2852
	  lw $t0, -116($fp)	# fill _tmp2852 to $t0 from $fp-116
	  jalr $t0            	# jump to function
	  move $t2, $v0		# copy function return value from $v0
	  sw $t2, -120($fp)	# spill _tmp2853 from $t2 to $fp-120
	# PopParams 12
	  add $sp, $sp, 12	# pop params off stack
	# column = _tmp2853
	  lw $t2, -120($fp)	# fill _tmp2853 to $t2 from $fp-120
	  sw $t2, -12($fp)	# spill column from $t2 to $fp-12
	# PushParam column
	  subu $sp, $sp, 4	# decrement sp to make space for param
	  lw $t0, -12($fp)	# fill column to $t0 from $fp-12
	  sw $t0, 4($sp)	# copy param value to stack
	# PushParam row
	  subu $sp, $sp, 4	# decrement sp to make space for param
	  lw $t0, -8($fp)	# fill row to $t0 from $fp-8
	  sw $t0, 4($sp)	# copy param value to stack
	# PushParam grid
	  subu $sp, $sp, 4	# decrement sp to make space for param
	  lw $t0, 8($fp)	# fill grid to $t0 from $fp+8
	  sw $t0, 4($sp)	# copy param value to stack
	# _tmp2854 = *(grid)
	  lw $t0, 8($fp)	# fill grid to $t0 from $fp+8
	  lw $t2, 0($t0) 	# load with offset
	  sw $t2, -124($fp)	# spill _tmp2854 from $t2 to $fp-124
	# _tmp2855 = *(_tmp2854 + 16)
	  lw $t0, -124($fp)	# fill _tmp2854 to $t0 from $fp-124
	  lw $t2, 16($t0) 	# load with offset
	  sw $t2, -128($fp)	# spill _tmp2855 from $t2 to $fp-128
	# _tmp2856 = ACall _tmp2855
	  lw $t0, -128($fp)	# fill _tmp2855 to $t0 from $fp-128
	  jalr $t0            	# jump to function
	  move $t2, $v0		# copy function return value from $v0
	  sw $t2, -132($fp)	# spill _tmp2856 from $t2 to $fp-132
	# PopParams 12
	  add $sp, $sp, 12	# pop params off stack
	# legalMove = _tmp2856
	  lw $t2, -132($fp)	# fill _tmp2856 to $t2 from $fp-132
	  sw $t2, -16($fp)	# spill legalMove from $t2 to $fp-16
	# Goto _L281
	  b _L281		# unconditional branch
  _L282:
	# PushParam this
	  subu $sp, $sp, 4	# decrement sp to make space for param
	  lw $t0, 4($fp)	# fill this to $t0 from $fp+4
	  sw $t0, 4($sp)	# copy param value to stack
	# _tmp2857 = *(this)
	  lw $t0, 4($fp)	# fill this to $t0 from $fp+4
	  lw $t2, 0($t0) 	# load with offset
	  sw $t2, -136($fp)	# spill _tmp2857 from $t2 to $fp-136
	# _tmp2858 = *(_tmp2857)
	  lw $t0, -136($fp)	# fill _tmp2857 to $t0 from $fp-136
	  lw $t2, 0($t0) 	# load with offset
	  sw $t2, -140($fp)	# spill _tmp2858 from $t2 to $fp-140
	# _tmp2859 = ACall _tmp2858
	  lw $t0, -140($fp)	# fill _tmp2858 to $t0 from $fp-140
	  jalr $t0            	# jump to function
	  move $t2, $v0		# copy function return value from $v0
	  sw $t2, -144($fp)	# spill _tmp2859 from $t2 to $fp-144
	# PopParams 4
	  add $sp, $sp, 4	# pop params off stack
	# PushParam _tmp2859
	  subu $sp, $sp, 4	# decrement sp to make space for param
	  lw $t0, -144($fp)	# fill _tmp2859 to $t0 from $fp-144
	  sw $t0, 4($sp)	# copy param value to stack
	# PushParam column
	  subu $sp, $sp, 4	# decrement sp to make space for param
	  lw $t0, -12($fp)	# fill column to $t0 from $fp-12
	  sw $t0, 4($sp)	# copy param value to stack
	# PushParam row
	  subu $sp, $sp, 4	# decrement sp to make space for param
	  lw $t0, -8($fp)	# fill row to $t0 from $fp-8
	  sw $t0, 4($sp)	# copy param value to stack
	# PushParam grid
	  subu $sp, $sp, 4	# decrement sp to make space for param
	  lw $t0, 8($fp)	# fill grid to $t0 from $fp+8
	  sw $t0, 4($sp)	# copy param value to stack
	# _tmp2860 = *(grid)
	  lw $t0, 8($fp)	# fill grid to $t0 from $fp+8
	  lw $t2, 0($t0) 	# load with offset
	  sw $t2, -148($fp)	# spill _tmp2860 from $t2 to $fp-148
	# _tmp2861 = *(_tmp2860 + 12)
	  lw $t0, -148($fp)	# fill _tmp2860 to $t0 from $fp-148
	  lw $t2, 12($t0) 	# load with offset
	  sw $t2, -152($fp)	# spill _tmp2861 from $t2 to $fp-152
	# ACall _tmp2861
	  lw $t0, -152($fp)	# fill _tmp2861 to $t0 from $fp-152
	  jalr $t0            	# jump to function
	# PopParams 16
	  add $sp, $sp, 16	# pop params off stack
	# _tmp2862 = 1
	  li $t2, 1		# load constant value 1 into $t2
	  sw $t2, -156($fp)	# spill _tmp2862 from $t2 to $fp-156
	# _tmp2863 = row + _tmp2862
	  lw $t0, -8($fp)	# fill row to $t0 from $fp-8
	  lw $t1, -156($fp)	# fill _tmp2862 to $t1 from $fp-156
	  add $t2, $t0, $t1	
	  sw $t2, -160($fp)	# spill _tmp2863 from $t2 to $fp-160
	# row = _tmp2863
	  lw $t2, -160($fp)	# fill _tmp2863 to $t2 from $fp-160
	  sw $t2, -8($fp)	# spill row from $t2 to $fp-8
	# _tmp2864 = 1
	  li $t2, 1		# load constant value 1 into $t2
	  sw $t2, -164($fp)	# spill _tmp2864 from $t2 to $fp-164
	# _tmp2865 = column + _tmp2864
	  lw $t0, -12($fp)	# fill column to $t0 from $fp-12
	  lw $t1, -164($fp)	# fill _tmp2864 to $t1 from $fp-164
	  add $t2, $t0, $t1	
	  sw $t2, -168($fp)	# spill _tmp2865 from $t2 to $fp-168
	# column = _tmp2865
	  lw $t2, -168($fp)	# fill _tmp2865 to $t2 from $fp-168
	  sw $t2, -12($fp)	# spill column from $t2 to $fp-12
	# _tmp2866 = "\nThe computer's move is row "
	  .data			# create string constant marked with label
	  _string176: .asciiz "\nThe computer's move is row "
	  .text
	  la $t2, _string176	# load label
	  sw $t2, -172($fp)	# spill _tmp2866 from $t2 to $fp-172
	# PushParam _tmp2866
	  subu $sp, $sp, 4	# decrement sp to make space for param
	  lw $t0, -172($fp)	# fill _tmp2866 to $t0 from $fp-172
	  sw $t0, 4($sp)	# copy param value to stack
	# LCall _PrintString
	  jal _PrintString   	# jump to function
	# PopParams 4
	  add $sp, $sp, 4	# pop params off stack
	# PushParam row
	  subu $sp, $sp, 4	# decrement sp to make space for param
	  lw $t0, -8($fp)	# fill row to $t0 from $fp-8
	  sw $t0, 4($sp)	# copy param value to stack
	# LCall _PrintInt
	  jal _PrintInt      	# jump to function
	# PopParams 4
	  add $sp, $sp, 4	# pop params off stack
	# _tmp2867 = " and column "
	  .data			# create string constant marked with label
	  _string177: .asciiz " and column "
	  .text
	  la $t2, _string177	# load label
	  sw $t2, -176($fp)	# spill _tmp2867 from $t2 to $fp-176
	# PushParam _tmp2867
	  subu $sp, $sp, 4	# decrement sp to make space for param
	  lw $t0, -176($fp)	# fill _tmp2867 to $t0 from $fp-176
	  sw $t0, 4($sp)	# copy param value to stack
	# LCall _PrintString
	  jal _PrintString   	# jump to function
	# PopParams 4
	  add $sp, $sp, 4	# pop params off stack
	# PushParam column
	  subu $sp, $sp, 4	# decrement sp to make space for param
	  lw $t0, -12($fp)	# fill column to $t0 from $fp-12
	  sw $t0, 4($sp)	# copy param value to stack
	# LCall _PrintInt
	  jal _PrintInt      	# jump to function
	# PopParams 4
	  add $sp, $sp, 4	# pop params off stack
	# _tmp2868 = ".\n"
	  .data			# create string constant marked with label
	  _string178: .asciiz ".\n"
	  .text
	  la $t2, _string178	# load label
	  sw $t2, -180($fp)	# spill _tmp2868 from $t2 to $fp-180
	# PushParam _tmp2868
	  subu $sp, $sp, 4	# decrement sp to make space for param
	  lw $t0, -180($fp)	# fill _tmp2868 to $t0 from $fp-180
	  sw $t0, 4($sp)	# copy param value to stack
	# LCall _PrintString
	  jal _PrintString   	# jump to function
	# PopParams 4
	  add $sp, $sp, 4	# pop params off stack
	# Goto _L278
	  b _L278		# unconditional branch
  _L277:
	# _tmp2869 = "Ha! The computer blocked you from winning!\n"
	  .data			# create string constant marked with label
	  _string179: .asciiz "Ha! The computer blocked you from winning!\n"
	  .text
	  la $t2, _string179	# load label
	  sw $t2, -184($fp)	# spill _tmp2869 from $t2 to $fp-184
	# PushParam _tmp2869
	  subu $sp, $sp, 4	# decrement sp to make space for param
	  lw $t0, -184($fp)	# fill _tmp2869 to $t0 from $fp-184
	  sw $t0, 4($sp)	# copy param value to stack
	# LCall _PrintString
	  jal _PrintString   	# jump to function
	# PopParams 4
	  add $sp, $sp, 4	# pop params off stack
  _L278:
	# EndFunc
	# (below handles reaching end of fn body with no explicit return)
	  move $sp, $fp		# pop callee frame off stack
	  lw $ra, -4($fp)	# restore saved ra
	  lw $fp, 0($fp)	# restore saved fp
	  jr $ra		# return from function
	# VTable for class Computer
	  .data
	  .align 2
	  Computer:		# label for class Computer vtable
	  .word Player.____GetMark
	  .word Player.____GetName
	  .word Computer.____Init
	  .word Computer.____TakeTurn
	  .text
  ____InitGame:
	# BeginFunc 24
	  subu $sp, $sp, 8	# decrement sp to make space to save ra, fp
	  sw $fp, 8($sp)	# save fp
	  sw $ra, 4($sp)	# save ra
	  addiu $fp, $sp, 8	# set up new fp
	  subu $sp, $sp, 24	# decrement sp to make space for locals/temps
	# _tmp2870 = "\nWelcome to TicTacToe!\n"
	  .data			# create string constant marked with label
	  _string180: .asciiz "\nWelcome to TicTacToe!\n"
	  .text
	  la $t2, _string180	# load label
	  sw $t2, -8($fp)	# spill _tmp2870 from $t2 to $fp-8
	# PushParam _tmp2870
	  subu $sp, $sp, 4	# decrement sp to make space for param
	  lw $t0, -8($fp)	# fill _tmp2870 to $t0 from $fp-8
	  sw $t0, 4($sp)	# copy param value to stack
	# LCall _PrintString
	  jal _PrintString   	# jump to function
	# PopParams 4
	  add $sp, $sp, 4	# pop params off stack
	# _tmp2871 = "---------------------\n"
	  .data			# create string constant marked with label
	  _string181: .asciiz "---------------------\n"
	  .text
	  la $t2, _string181	# load label
	  sw $t2, -12($fp)	# spill _tmp2871 from $t2 to $fp-12
	# PushParam _tmp2871
	  subu $sp, $sp, 4	# decrement sp to make space for param
	  lw $t0, -12($fp)	# fill _tmp2871 to $t0 from $fp-12
	  sw $t0, 4($sp)	# copy param value to stack
	# LCall _PrintString
	  jal _PrintString   	# jump to function
	# PopParams 4
	  add $sp, $sp, 4	# pop params off stack
	# _tmp2872 = "Please enter a random number seed: "
	  .data			# create string constant marked with label
	  _string182: .asciiz "Please enter a random number seed: "
	  .text
	  la $t2, _string182	# load label
	  sw $t2, -16($fp)	# spill _tmp2872 from $t2 to $fp-16
	# PushParam _tmp2872
	  subu $sp, $sp, 4	# decrement sp to make space for param
	  lw $t0, -16($fp)	# fill _tmp2872 to $t0 from $fp-16
	  sw $t0, 4($sp)	# copy param value to stack
	# LCall _PrintString
	  jal _PrintString   	# jump to function
	# PopParams 4
	  add $sp, $sp, 4	# pop params off stack
	# _tmp2873 = LCall _ReadInteger
	  jal _ReadInteger   	# jump to function
	  move $t2, $v0		# copy function return value from $v0
	  sw $t2, -20($fp)	# spill _tmp2873 from $t2 to $fp-20
	# PushParam _tmp2873
	  subu $sp, $sp, 4	# decrement sp to make space for param
	  lw $t0, -20($fp)	# fill _tmp2873 to $t0 from $fp-20
	  sw $t0, 4($sp)	# copy param value to stack
	# PushParam gRnd
	  subu $sp, $sp, 4	# decrement sp to make space for param
	  lw $t0, 0($gp)	# fill gRnd to $t0 from $gp+0
	  sw $t0, 4($sp)	# copy param value to stack
	# _tmp2874 = *(gRnd)
	  lw $t0, 0($gp)	# fill gRnd to $t0 from $gp+0
	  lw $t2, 0($t0) 	# load with offset
	  sw $t2, -24($fp)	# spill _tmp2874 from $t2 to $fp-24
	# _tmp2875 = *(_tmp2874)
	  lw $t0, -24($fp)	# fill _tmp2874 to $t0 from $fp-24
	  lw $t2, 0($t0) 	# load with offset
	  sw $t2, -28($fp)	# spill _tmp2875 from $t2 to $fp-28
	# ACall _tmp2875
	  lw $t0, -28($fp)	# fill _tmp2875 to $t0 from $fp-28
	  jalr $t0            	# jump to function
	# PopParams 8
	  add $sp, $sp, 8	# pop params off stack
	# EndFunc
	# (below handles reaching end of fn body with no explicit return)
	  move $sp, $fp		# pop callee frame off stack
	  lw $ra, -4($fp)	# restore saved ra
	  lw $fp, 0($fp)	# restore saved fp
	  jr $ra		# return from function
  main:
	# BeginFunc 492
	  subu $sp, $sp, 8	# decrement sp to make space to save ra, fp
	  sw $fp, 8($sp)	# save fp
	  sw $ra, 4($sp)	# save ra
	  addiu $fp, $sp, 8	# set up new fp
	  subu $sp, $sp, 492	# decrement sp to make space for locals/temps
	# _tmp2876 = 4
	  li $t2, 4		# load constant value 4 into $t2
	  sw $t2, -36($fp)	# spill _tmp2876 from $t2 to $fp-36
	# _tmp2877 = 4
	  li $t2, 4		# load constant value 4 into $t2
	  sw $t2, -40($fp)	# spill _tmp2877 from $t2 to $fp-40
	# _tmp2878 = _tmp2877 + _tmp2876
	  lw $t0, -40($fp)	# fill _tmp2877 to $t0 from $fp-40
	  lw $t1, -36($fp)	# fill _tmp2876 to $t1 from $fp-36
	  add $t2, $t0, $t1	
	  sw $t2, -44($fp)	# spill _tmp2878 from $t2 to $fp-44
	# PushParam _tmp2878
	  subu $sp, $sp, 4	# decrement sp to make space for param
	  lw $t0, -44($fp)	# fill _tmp2878 to $t0 from $fp-44
	  sw $t0, 4($sp)	# copy param value to stack
	# _tmp2879 = LCall _Alloc
	  jal _Alloc         	# jump to function
	  move $t2, $v0		# copy function return value from $v0
	  sw $t2, -48($fp)	# spill _tmp2879 from $t2 to $fp-48
	# PopParams 4
	  add $sp, $sp, 4	# pop params off stack
	# _tmp2880 = Grid
	  la $t2, Grid	# load label
	  sw $t2, -52($fp)	# spill _tmp2880 from $t2 to $fp-52
	# *(_tmp2879) = _tmp2880
	  lw $t0, -52($fp)	# fill _tmp2880 to $t0 from $fp-52
	  lw $t2, -48($fp)	# fill _tmp2879 to $t2 from $fp-48
	  sw $t0, 0($t2) 	# store with offset
	# grid = _tmp2879
	  lw $t2, -48($fp)	# fill _tmp2879 to $t2 from $fp-48
	  sw $t2, -8($fp)	# spill grid from $t2 to $fp-8
	# _tmp2881 = 8
	  li $t2, 8		# load constant value 8 into $t2
	  sw $t2, -56($fp)	# spill _tmp2881 from $t2 to $fp-56
	# _tmp2882 = 4
	  li $t2, 4		# load constant value 4 into $t2
	  sw $t2, -60($fp)	# spill _tmp2882 from $t2 to $fp-60
	# _tmp2883 = _tmp2882 + _tmp2881
	  lw $t0, -60($fp)	# fill _tmp2882 to $t0 from $fp-60
	  lw $t1, -56($fp)	# fill _tmp2881 to $t1 from $fp-56
	  add $t2, $t0, $t1	
	  sw $t2, -64($fp)	# spill _tmp2883 from $t2 to $fp-64
	# PushParam _tmp2883
	  subu $sp, $sp, 4	# decrement sp to make space for param
	  lw $t0, -64($fp)	# fill _tmp2883 to $t0 from $fp-64
	  sw $t0, 4($sp)	# copy param value to stack
	# _tmp2884 = LCall _Alloc
	  jal _Alloc         	# jump to function
	  move $t2, $v0		# copy function return value from $v0
	  sw $t2, -68($fp)	# spill _tmp2884 from $t2 to $fp-68
	# PopParams 4
	  add $sp, $sp, 4	# pop params off stack
	# _tmp2885 = Human
	  la $t2, Human	# load label
	  sw $t2, -72($fp)	# spill _tmp2885 from $t2 to $fp-72
	# *(_tmp2884) = _tmp2885
	  lw $t0, -72($fp)	# fill _tmp2885 to $t0 from $fp-72
	  lw $t2, -68($fp)	# fill _tmp2884 to $t2 from $fp-68
	  sw $t0, 0($t2) 	# store with offset
	# human = _tmp2884
	  lw $t2, -68($fp)	# fill _tmp2884 to $t2 from $fp-68
	  sw $t2, -12($fp)	# spill human from $t2 to $fp-12
	# _tmp2886 = 8
	  li $t2, 8		# load constant value 8 into $t2
	  sw $t2, -76($fp)	# spill _tmp2886 from $t2 to $fp-76
	# _tmp2887 = 4
	  li $t2, 4		# load constant value 4 into $t2
	  sw $t2, -80($fp)	# spill _tmp2887 from $t2 to $fp-80
	# _tmp2888 = _tmp2887 + _tmp2886
	  lw $t0, -80($fp)	# fill _tmp2887 to $t0 from $fp-80
	  lw $t1, -76($fp)	# fill _tmp2886 to $t1 from $fp-76
	  add $t2, $t0, $t1	
	  sw $t2, -84($fp)	# spill _tmp2888 from $t2 to $fp-84
	# PushParam _tmp2888
	  subu $sp, $sp, 4	# decrement sp to make space for param
	  lw $t0, -84($fp)	# fill _tmp2888 to $t0 from $fp-84
	  sw $t0, 4($sp)	# copy param value to stack
	# _tmp2889 = LCall _Alloc
	  jal _Alloc         	# jump to function
	  move $t2, $v0		# copy function return value from $v0
	  sw $t2, -88($fp)	# spill _tmp2889 from $t2 to $fp-88
	# PopParams 4
	  add $sp, $sp, 4	# pop params off stack
	# _tmp2890 = Computer
	  la $t2, Computer	# load label
	  sw $t2, -92($fp)	# spill _tmp2890 from $t2 to $fp-92
	# *(_tmp2889) = _tmp2890
	  lw $t0, -92($fp)	# fill _tmp2890 to $t0 from $fp-92
	  lw $t2, -88($fp)	# fill _tmp2889 to $t2 from $fp-88
	  sw $t0, 0($t2) 	# store with offset
	# computer = _tmp2889
	  lw $t2, -88($fp)	# fill _tmp2889 to $t2 from $fp-88
	  sw $t2, -16($fp)	# spill computer from $t2 to $fp-16
	# _tmp2891 = 4
	  li $t2, 4		# load constant value 4 into $t2
	  sw $t2, -96($fp)	# spill _tmp2891 from $t2 to $fp-96
	# _tmp2892 = 4
	  li $t2, 4		# load constant value 4 into $t2
	  sw $t2, -100($fp)	# spill _tmp2892 from $t2 to $fp-100
	# _tmp2893 = _tmp2892 + _tmp2891
	  lw $t0, -100($fp)	# fill _tmp2892 to $t0 from $fp-100
	  lw $t1, -96($fp)	# fill _tmp2891 to $t1 from $fp-96
	  add $t2, $t0, $t1	
	  sw $t2, -104($fp)	# spill _tmp2893 from $t2 to $fp-104
	# PushParam _tmp2893
	  subu $sp, $sp, 4	# decrement sp to make space for param
	  lw $t0, -104($fp)	# fill _tmp2893 to $t0 from $fp-104
	  sw $t0, 4($sp)	# copy param value to stack
	# _tmp2894 = LCall _Alloc
	  jal _Alloc         	# jump to function
	  move $t2, $v0		# copy function return value from $v0
	  sw $t2, -108($fp)	# spill _tmp2894 from $t2 to $fp-108
	# PopParams 4
	  add $sp, $sp, 4	# pop params off stack
	# _tmp2895 = rndModule
	  la $t2, rndModule	# load label
	  sw $t2, -112($fp)	# spill _tmp2895 from $t2 to $fp-112
	# *(_tmp2894) = _tmp2895
	  lw $t0, -112($fp)	# fill _tmp2895 to $t0 from $fp-112
	  lw $t2, -108($fp)	# fill _tmp2894 to $t2 from $fp-108
	  sw $t0, 0($t2) 	# store with offset
	# gRnd = _tmp2894
	  lw $t2, -108($fp)	# fill _tmp2894 to $t2 from $fp-108
	  sw $t2, 0($gp)	# spill gRnd from $t2 to $gp+0
	# LCall ____InitGame
	  jal ____InitGame   	# jump to function
	# PushParam grid
	  subu $sp, $sp, 4	# decrement sp to make space for param
	  lw $t0, -8($fp)	# fill grid to $t0 from $fp-8
	  sw $t0, 4($sp)	# copy param value to stack
	# _tmp2896 = *(grid)
	  lw $t0, -8($fp)	# fill grid to $t0 from $fp-8
	  lw $t2, 0($t0) 	# load with offset
	  sw $t2, -116($fp)	# spill _tmp2896 from $t2 to $fp-116
	# _tmp2897 = *(_tmp2896)
	  lw $t0, -116($fp)	# fill _tmp2896 to $t0 from $fp-116
	  lw $t2, 0($t0) 	# load with offset
	  sw $t2, -120($fp)	# spill _tmp2897 from $t2 to $fp-120
	# ACall _tmp2897
	  lw $t0, -120($fp)	# fill _tmp2897 to $t0 from $fp-120
	  jalr $t0            	# jump to function
	# PopParams 4
	  add $sp, $sp, 4	# pop params off stack
	# PushParam human
	  subu $sp, $sp, 4	# decrement sp to make space for param
	  lw $t0, -12($fp)	# fill human to $t0 from $fp-12
	  sw $t0, 4($sp)	# copy param value to stack
	# _tmp2898 = *(human)
	  lw $t0, -12($fp)	# fill human to $t0 from $fp-12
	  lw $t2, 0($t0) 	# load with offset
	  sw $t2, -124($fp)	# spill _tmp2898 from $t2 to $fp-124
	# _tmp2899 = *(_tmp2898 + 8)
	  lw $t0, -124($fp)	# fill _tmp2898 to $t0 from $fp-124
	  lw $t2, 8($t0) 	# load with offset
	  sw $t2, -128($fp)	# spill _tmp2899 from $t2 to $fp-128
	# ACall _tmp2899
	  lw $t0, -128($fp)	# fill _tmp2899 to $t0 from $fp-128
	  jalr $t0            	# jump to function
	# PopParams 4
	  add $sp, $sp, 4	# pop params off stack
	# PushParam computer
	  subu $sp, $sp, 4	# decrement sp to make space for param
	  lw $t0, -16($fp)	# fill computer to $t0 from $fp-16
	  sw $t0, 4($sp)	# copy param value to stack
	# _tmp2900 = *(computer)
	  lw $t0, -16($fp)	# fill computer to $t0 from $fp-16
	  lw $t2, 0($t0) 	# load with offset
	  sw $t2, -132($fp)	# spill _tmp2900 from $t2 to $fp-132
	# _tmp2901 = *(_tmp2900 + 8)
	  lw $t0, -132($fp)	# fill _tmp2900 to $t0 from $fp-132
	  lw $t2, 8($t0) 	# load with offset
	  sw $t2, -136($fp)	# spill _tmp2901 from $t2 to $fp-136
	# ACall _tmp2901
	  lw $t0, -136($fp)	# fill _tmp2901 to $t0 from $fp-136
	  jalr $t0            	# jump to function
	# PopParams 4
	  add $sp, $sp, 4	# pop params off stack
	# _tmp2902 = 0
	  li $t2, 0		# load constant value 0 into $t2
	  sw $t2, -140($fp)	# spill _tmp2902 from $t2 to $fp-140
	# moveLegal = _tmp2902
	  lw $t2, -140($fp)	# fill _tmp2902 to $t2 from $fp-140
	  sw $t2, -28($fp)	# spill moveLegal from $t2 to $fp-28
	# _tmp2903 = 0
	  li $t2, 0		# load constant value 0 into $t2
	  sw $t2, -144($fp)	# spill _tmp2903 from $t2 to $fp-144
	# gameOver = _tmp2903
	  lw $t2, -144($fp)	# fill _tmp2903 to $t2 from $fp-144
	  sw $t2, -32($fp)	# spill gameOver from $t2 to $fp-32
	# PushParam grid
	  subu $sp, $sp, 4	# decrement sp to make space for param
	  lw $t0, -8($fp)	# fill grid to $t0 from $fp-8
	  sw $t0, 4($sp)	# copy param value to stack
	# _tmp2904 = *(grid)
	  lw $t0, -8($fp)	# fill grid to $t0 from $fp-8
	  lw $t2, 0($t0) 	# load with offset
	  sw $t2, -148($fp)	# spill _tmp2904 from $t2 to $fp-148
	# _tmp2905 = *(_tmp2904 + 8)
	  lw $t0, -148($fp)	# fill _tmp2904 to $t0 from $fp-148
	  lw $t2, 8($t0) 	# load with offset
	  sw $t2, -152($fp)	# spill _tmp2905 from $t2 to $fp-152
	# ACall _tmp2905
	  lw $t0, -152($fp)	# fill _tmp2905 to $t0 from $fp-152
	  jalr $t0            	# jump to function
	# PopParams 4
	  add $sp, $sp, 4	# pop params off stack
  _L285:
	# IfZ gameOver Goto _L288
	  lw $t0, -32($fp)	# fill gameOver to $t0 from $fp-32
	  beqz $t0, _L288	# branch if gameOver is zero 
	# _tmp2907 = 0
	  li $t2, 0		# load constant value 0 into $t2
	  sw $t2, -160($fp)	# spill _tmp2907 from $t2 to $fp-160
	# _tmp2906 = _tmp2907
	  lw $t2, -160($fp)	# fill _tmp2907 to $t2 from $fp-160
	  sw $t2, -156($fp)	# spill _tmp2906 from $t2 to $fp-156
	# Goto _L287
	  b _L287		# unconditional branch
  _L288:
	# _tmp2908 = 1
	  li $t2, 1		# load constant value 1 into $t2
	  sw $t2, -164($fp)	# spill _tmp2908 from $t2 to $fp-164
	# _tmp2906 = _tmp2908
	  lw $t2, -164($fp)	# fill _tmp2908 to $t2 from $fp-164
	  sw $t2, -156($fp)	# spill _tmp2906 from $t2 to $fp-156
  _L287:
	# IfZ _tmp2906 Goto _L286
	  lw $t0, -156($fp)	# fill _tmp2906 to $t0 from $fp-156
	  beqz $t0, _L286	# branch if _tmp2906 is zero 
	# _tmp2909 = 0
	  li $t2, 0		# load constant value 0 into $t2
	  sw $t2, -168($fp)	# spill _tmp2909 from $t2 to $fp-168
	# moveLegal = _tmp2909
	  lw $t2, -168($fp)	# fill _tmp2909 to $t2 from $fp-168
	  sw $t2, -28($fp)	# spill moveLegal from $t2 to $fp-28
  _L289:
	# IfZ moveLegal Goto _L292
	  lw $t0, -28($fp)	# fill moveLegal to $t0 from $fp-28
	  beqz $t0, _L292	# branch if moveLegal is zero 
	# _tmp2911 = 0
	  li $t2, 0		# load constant value 0 into $t2
	  sw $t2, -176($fp)	# spill _tmp2911 from $t2 to $fp-176
	# _tmp2910 = _tmp2911
	  lw $t2, -176($fp)	# fill _tmp2911 to $t2 from $fp-176
	  sw $t2, -172($fp)	# spill _tmp2910 from $t2 to $fp-172
	# Goto _L291
	  b _L291		# unconditional branch
  _L292:
	# _tmp2912 = 1
	  li $t2, 1		# load constant value 1 into $t2
	  sw $t2, -180($fp)	# spill _tmp2912 from $t2 to $fp-180
	# _tmp2910 = _tmp2912
	  lw $t2, -180($fp)	# fill _tmp2912 to $t2 from $fp-180
	  sw $t2, -172($fp)	# spill _tmp2910 from $t2 to $fp-172
  _L291:
	# IfZ _tmp2910 Goto _L290
	  lw $t0, -172($fp)	# fill _tmp2910 to $t0 from $fp-172
	  beqz $t0, _L290	# branch if _tmp2910 is zero 
	# PushParam human
	  subu $sp, $sp, 4	# decrement sp to make space for param
	  lw $t0, -12($fp)	# fill human to $t0 from $fp-12
	  sw $t0, 4($sp)	# copy param value to stack
	# _tmp2913 = *(human)
	  lw $t0, -12($fp)	# fill human to $t0 from $fp-12
	  lw $t2, 0($t0) 	# load with offset
	  sw $t2, -184($fp)	# spill _tmp2913 from $t2 to $fp-184
	# _tmp2914 = *(_tmp2913 + 12)
	  lw $t0, -184($fp)	# fill _tmp2913 to $t0 from $fp-184
	  lw $t2, 12($t0) 	# load with offset
	  sw $t2, -188($fp)	# spill _tmp2914 from $t2 to $fp-188
	# _tmp2915 = ACall _tmp2914
	  lw $t0, -188($fp)	# fill _tmp2914 to $t0 from $fp-188
	  jalr $t0            	# jump to function
	  move $t2, $v0		# copy function return value from $v0
	  sw $t2, -192($fp)	# spill _tmp2915 from $t2 to $fp-192
	# PopParams 4
	  add $sp, $sp, 4	# pop params off stack
	# row = _tmp2915
	  lw $t2, -192($fp)	# fill _tmp2915 to $t2 from $fp-192
	  sw $t2, -20($fp)	# spill row from $t2 to $fp-20
	# PushParam human
	  subu $sp, $sp, 4	# decrement sp to make space for param
	  lw $t0, -12($fp)	# fill human to $t0 from $fp-12
	  sw $t0, 4($sp)	# copy param value to stack
	# _tmp2916 = *(human)
	  lw $t0, -12($fp)	# fill human to $t0 from $fp-12
	  lw $t2, 0($t0) 	# load with offset
	  sw $t2, -196($fp)	# spill _tmp2916 from $t2 to $fp-196
	# _tmp2917 = *(_tmp2916 + 16)
	  lw $t0, -196($fp)	# fill _tmp2916 to $t0 from $fp-196
	  lw $t2, 16($t0) 	# load with offset
	  sw $t2, -200($fp)	# spill _tmp2917 from $t2 to $fp-200
	# _tmp2918 = ACall _tmp2917
	  lw $t0, -200($fp)	# fill _tmp2917 to $t0 from $fp-200
	  jalr $t0            	# jump to function
	  move $t2, $v0		# copy function return value from $v0
	  sw $t2, -204($fp)	# spill _tmp2918 from $t2 to $fp-204
	# PopParams 4
	  add $sp, $sp, 4	# pop params off stack
	# column = _tmp2918
	  lw $t2, -204($fp)	# fill _tmp2918 to $t2 from $fp-204
	  sw $t2, -24($fp)	# spill column from $t2 to $fp-24
	# PushParam column
	  subu $sp, $sp, 4	# decrement sp to make space for param
	  lw $t0, -24($fp)	# fill column to $t0 from $fp-24
	  sw $t0, 4($sp)	# copy param value to stack
	# PushParam row
	  subu $sp, $sp, 4	# decrement sp to make space for param
	  lw $t0, -20($fp)	# fill row to $t0 from $fp-20
	  sw $t0, 4($sp)	# copy param value to stack
	# PushParam grid
	  subu $sp, $sp, 4	# decrement sp to make space for param
	  lw $t0, -8($fp)	# fill grid to $t0 from $fp-8
	  sw $t0, 4($sp)	# copy param value to stack
	# _tmp2919 = *(grid)
	  lw $t0, -8($fp)	# fill grid to $t0 from $fp-8
	  lw $t2, 0($t0) 	# load with offset
	  sw $t2, -208($fp)	# spill _tmp2919 from $t2 to $fp-208
	# _tmp2920 = *(_tmp2919 + 16)
	  lw $t0, -208($fp)	# fill _tmp2919 to $t0 from $fp-208
	  lw $t2, 16($t0) 	# load with offset
	  sw $t2, -212($fp)	# spill _tmp2920 from $t2 to $fp-212
	# _tmp2921 = ACall _tmp2920
	  lw $t0, -212($fp)	# fill _tmp2920 to $t0 from $fp-212
	  jalr $t0            	# jump to function
	  move $t2, $v0		# copy function return value from $v0
	  sw $t2, -216($fp)	# spill _tmp2921 from $t2 to $fp-216
	# PopParams 12
	  add $sp, $sp, 12	# pop params off stack
	# moveLegal = _tmp2921
	  lw $t2, -216($fp)	# fill _tmp2921 to $t2 from $fp-216
	  sw $t2, -28($fp)	# spill moveLegal from $t2 to $fp-28
	# IfZ moveLegal Goto _L296
	  lw $t0, -28($fp)	# fill moveLegal to $t0 from $fp-28
	  beqz $t0, _L296	# branch if moveLegal is zero 
	# _tmp2923 = 0
	  li $t2, 0		# load constant value 0 into $t2
	  sw $t2, -224($fp)	# spill _tmp2923 from $t2 to $fp-224
	# _tmp2922 = _tmp2923
	  lw $t2, -224($fp)	# fill _tmp2923 to $t2 from $fp-224
	  sw $t2, -220($fp)	# spill _tmp2922 from $t2 to $fp-220
	# Goto _L295
	  b _L295		# unconditional branch
  _L296:
	# _tmp2924 = 1
	  li $t2, 1		# load constant value 1 into $t2
	  sw $t2, -228($fp)	# spill _tmp2924 from $t2 to $fp-228
	# _tmp2922 = _tmp2924
	  lw $t2, -228($fp)	# fill _tmp2924 to $t2 from $fp-228
	  sw $t2, -220($fp)	# spill _tmp2922 from $t2 to $fp-220
  _L295:
	# IfZ _tmp2922 Goto _L293
	  lw $t0, -220($fp)	# fill _tmp2922 to $t0 from $fp-220
	  beqz $t0, _L293	# branch if _tmp2922 is zero 
	# _tmp2925 = "Try again. The square is already taken.\n"
	  .data			# create string constant marked with label
	  _string183: .asciiz "Try again. The square is already taken.\n"
	  .text
	  la $t2, _string183	# load label
	  sw $t2, -232($fp)	# spill _tmp2925 from $t2 to $fp-232
	# PushParam _tmp2925
	  subu $sp, $sp, 4	# decrement sp to make space for param
	  lw $t0, -232($fp)	# fill _tmp2925 to $t0 from $fp-232
	  sw $t0, 4($sp)	# copy param value to stack
	# LCall _PrintString
	  jal _PrintString   	# jump to function
	# PopParams 4
	  add $sp, $sp, 4	# pop params off stack
	# Goto _L294
	  b _L294		# unconditional branch
  _L293:
	# PushParam human
	  subu $sp, $sp, 4	# decrement sp to make space for param
	  lw $t0, -12($fp)	# fill human to $t0 from $fp-12
	  sw $t0, 4($sp)	# copy param value to stack
	# _tmp2926 = *(human)
	  lw $t0, -12($fp)	# fill human to $t0 from $fp-12
	  lw $t2, 0($t0) 	# load with offset
	  sw $t2, -236($fp)	# spill _tmp2926 from $t2 to $fp-236
	# _tmp2927 = *(_tmp2926)
	  lw $t0, -236($fp)	# fill _tmp2926 to $t0 from $fp-236
	  lw $t2, 0($t0) 	# load with offset
	  sw $t2, -240($fp)	# spill _tmp2927 from $t2 to $fp-240
	# _tmp2928 = ACall _tmp2927
	  lw $t0, -240($fp)	# fill _tmp2927 to $t0 from $fp-240
	  jalr $t0            	# jump to function
	  move $t2, $v0		# copy function return value from $v0
	  sw $t2, -244($fp)	# spill _tmp2928 from $t2 to $fp-244
	# PopParams 4
	  add $sp, $sp, 4	# pop params off stack
	# PushParam _tmp2928
	  subu $sp, $sp, 4	# decrement sp to make space for param
	  lw $t0, -244($fp)	# fill _tmp2928 to $t0 from $fp-244
	  sw $t0, 4($sp)	# copy param value to stack
	# PushParam column
	  subu $sp, $sp, 4	# decrement sp to make space for param
	  lw $t0, -24($fp)	# fill column to $t0 from $fp-24
	  sw $t0, 4($sp)	# copy param value to stack
	# PushParam row
	  subu $sp, $sp, 4	# decrement sp to make space for param
	  lw $t0, -20($fp)	# fill row to $t0 from $fp-20
	  sw $t0, 4($sp)	# copy param value to stack
	# PushParam grid
	  subu $sp, $sp, 4	# decrement sp to make space for param
	  lw $t0, -8($fp)	# fill grid to $t0 from $fp-8
	  sw $t0, 4($sp)	# copy param value to stack
	# _tmp2929 = *(grid)
	  lw $t0, -8($fp)	# fill grid to $t0 from $fp-8
	  lw $t2, 0($t0) 	# load with offset
	  sw $t2, -248($fp)	# spill _tmp2929 from $t2 to $fp-248
	# _tmp2930 = *(_tmp2929 + 12)
	  lw $t0, -248($fp)	# fill _tmp2929 to $t0 from $fp-248
	  lw $t2, 12($t0) 	# load with offset
	  sw $t2, -252($fp)	# spill _tmp2930 from $t2 to $fp-252
	# ACall _tmp2930
	  lw $t0, -252($fp)	# fill _tmp2930 to $t0 from $fp-252
	  jalr $t0            	# jump to function
	# PopParams 16
	  add $sp, $sp, 16	# pop params off stack
  _L294:
	# Goto _L289
	  b _L289		# unconditional branch
  _L290:
	# PushParam human
	  subu $sp, $sp, 4	# decrement sp to make space for param
	  lw $t0, -12($fp)	# fill human to $t0 from $fp-12
	  sw $t0, 4($sp)	# copy param value to stack
	# PushParam grid
	  subu $sp, $sp, 4	# decrement sp to make space for param
	  lw $t0, -8($fp)	# fill grid to $t0 from $fp-8
	  sw $t0, 4($sp)	# copy param value to stack
	# _tmp2932 = *(grid)
	  lw $t0, -8($fp)	# fill grid to $t0 from $fp-8
	  lw $t2, 0($t0) 	# load with offset
	  sw $t2, -260($fp)	# spill _tmp2932 from $t2 to $fp-260
	# _tmp2933 = *(_tmp2932 + 20)
	  lw $t0, -260($fp)	# fill _tmp2932 to $t0 from $fp-260
	  lw $t2, 20($t0) 	# load with offset
	  sw $t2, -264($fp)	# spill _tmp2933 from $t2 to $fp-264
	# _tmp2934 = ACall _tmp2933
	  lw $t0, -264($fp)	# fill _tmp2933 to $t0 from $fp-264
	  jalr $t0            	# jump to function
	  move $t2, $v0		# copy function return value from $v0
	  sw $t2, -268($fp)	# spill _tmp2934 from $t2 to $fp-268
	# PopParams 8
	  add $sp, $sp, 8	# pop params off stack
	# IfZ _tmp2934 Goto _L300
	  lw $t0, -268($fp)	# fill _tmp2934 to $t0 from $fp-268
	  beqz $t0, _L300	# branch if _tmp2934 is zero 
	# _tmp2935 = 0
	  li $t2, 0		# load constant value 0 into $t2
	  sw $t2, -272($fp)	# spill _tmp2935 from $t2 to $fp-272
	# _tmp2931 = _tmp2935
	  lw $t2, -272($fp)	# fill _tmp2935 to $t2 from $fp-272
	  sw $t2, -256($fp)	# spill _tmp2931 from $t2 to $fp-256
	# Goto _L299
	  b _L299		# unconditional branch
  _L300:
	# _tmp2936 = 1
	  li $t2, 1		# load constant value 1 into $t2
	  sw $t2, -276($fp)	# spill _tmp2936 from $t2 to $fp-276
	# _tmp2931 = _tmp2936
	  lw $t2, -276($fp)	# fill _tmp2936 to $t2 from $fp-276
	  sw $t2, -256($fp)	# spill _tmp2931 from $t2 to $fp-256
  _L299:
	# IfZ _tmp2931 Goto _L297
	  lw $t0, -256($fp)	# fill _tmp2931 to $t0 from $fp-256
	  beqz $t0, _L297	# branch if _tmp2931 is zero 
	# PushParam human
	  subu $sp, $sp, 4	# decrement sp to make space for param
	  lw $t0, -12($fp)	# fill human to $t0 from $fp-12
	  sw $t0, 4($sp)	# copy param value to stack
	# _tmp2937 = *(human)
	  lw $t0, -12($fp)	# fill human to $t0 from $fp-12
	  lw $t2, 0($t0) 	# load with offset
	  sw $t2, -280($fp)	# spill _tmp2937 from $t2 to $fp-280
	# _tmp2938 = *(_tmp2937 + 4)
	  lw $t0, -280($fp)	# fill _tmp2937 to $t0 from $fp-280
	  lw $t2, 4($t0) 	# load with offset
	  sw $t2, -284($fp)	# spill _tmp2938 from $t2 to $fp-284
	# _tmp2939 = ACall _tmp2938
	  lw $t0, -284($fp)	# fill _tmp2938 to $t0 from $fp-284
	  jalr $t0            	# jump to function
	  move $t2, $v0		# copy function return value from $v0
	  sw $t2, -288($fp)	# spill _tmp2939 from $t2 to $fp-288
	# PopParams 4
	  add $sp, $sp, 4	# pop params off stack
	# PushParam _tmp2939
	  subu $sp, $sp, 4	# decrement sp to make space for param
	  lw $t0, -288($fp)	# fill _tmp2939 to $t0 from $fp-288
	  sw $t0, 4($sp)	# copy param value to stack
	# LCall _PrintString
	  jal _PrintString   	# jump to function
	# PopParams 4
	  add $sp, $sp, 4	# pop params off stack
	# _tmp2940 = ", you won!\n"
	  .data			# create string constant marked with label
	  _string184: .asciiz ", you won!\n"
	  .text
	  la $t2, _string184	# load label
	  sw $t2, -292($fp)	# spill _tmp2940 from $t2 to $fp-292
	# PushParam _tmp2940
	  subu $sp, $sp, 4	# decrement sp to make space for param
	  lw $t0, -292($fp)	# fill _tmp2940 to $t0 from $fp-292
	  sw $t0, 4($sp)	# copy param value to stack
	# LCall _PrintString
	  jal _PrintString   	# jump to function
	# PopParams 4
	  add $sp, $sp, 4	# pop params off stack
	# _tmp2941 = 1
	  li $t2, 1		# load constant value 1 into $t2
	  sw $t2, -296($fp)	# spill _tmp2941 from $t2 to $fp-296
	# gameOver = _tmp2941
	  lw $t2, -296($fp)	# fill _tmp2941 to $t2 from $fp-296
	  sw $t2, -32($fp)	# spill gameOver from $t2 to $fp-32
	# Goto _L298
	  b _L298		# unconditional branch
  _L297:
	# IfZ gameOver Goto _L304
	  lw $t0, -32($fp)	# fill gameOver to $t0 from $fp-32
	  beqz $t0, _L304	# branch if gameOver is zero 
	# _tmp2943 = 0
	  li $t2, 0		# load constant value 0 into $t2
	  sw $t2, -304($fp)	# spill _tmp2943 from $t2 to $fp-304
	# _tmp2942 = _tmp2943
	  lw $t2, -304($fp)	# fill _tmp2943 to $t2 from $fp-304
	  sw $t2, -300($fp)	# spill _tmp2942 from $t2 to $fp-300
	# Goto _L303
	  b _L303		# unconditional branch
  _L304:
	# _tmp2944 = 1
	  li $t2, 1		# load constant value 1 into $t2
	  sw $t2, -308($fp)	# spill _tmp2944 from $t2 to $fp-308
	# _tmp2942 = _tmp2944
	  lw $t2, -308($fp)	# fill _tmp2944 to $t2 from $fp-308
	  sw $t2, -300($fp)	# spill _tmp2942 from $t2 to $fp-300
  _L303:
	# PushParam grid
	  subu $sp, $sp, 4	# decrement sp to make space for param
	  lw $t0, -8($fp)	# fill grid to $t0 from $fp-8
	  sw $t0, 4($sp)	# copy param value to stack
	# _tmp2945 = *(grid)
	  lw $t0, -8($fp)	# fill grid to $t0 from $fp-8
	  lw $t2, 0($t0) 	# load with offset
	  sw $t2, -312($fp)	# spill _tmp2945 from $t2 to $fp-312
	# _tmp2946 = *(_tmp2945 + 4)
	  lw $t0, -312($fp)	# fill _tmp2945 to $t0 from $fp-312
	  lw $t2, 4($t0) 	# load with offset
	  sw $t2, -316($fp)	# spill _tmp2946 from $t2 to $fp-316
	# _tmp2947 = ACall _tmp2946
	  lw $t0, -316($fp)	# fill _tmp2946 to $t0 from $fp-316
	  jalr $t0            	# jump to function
	  move $t2, $v0		# copy function return value from $v0
	  sw $t2, -320($fp)	# spill _tmp2947 from $t2 to $fp-320
	# PopParams 4
	  add $sp, $sp, 4	# pop params off stack
	# _tmp2948 = _tmp2942 && _tmp2947
	  lw $t0, -300($fp)	# fill _tmp2942 to $t0 from $fp-300
	  lw $t1, -320($fp)	# fill _tmp2947 to $t1 from $fp-320
	  and $t2, $t0, $t1	
	  sw $t2, -324($fp)	# spill _tmp2948 from $t2 to $fp-324
	# IfZ _tmp2948 Goto _L301
	  lw $t0, -324($fp)	# fill _tmp2948 to $t0 from $fp-324
	  beqz $t0, _L301	# branch if _tmp2948 is zero 
	# _tmp2949 = 1
	  li $t2, 1		# load constant value 1 into $t2
	  sw $t2, -328($fp)	# spill _tmp2949 from $t2 to $fp-328
	# gameOver = _tmp2949
	  lw $t2, -328($fp)	# fill _tmp2949 to $t2 from $fp-328
	  sw $t2, -32($fp)	# spill gameOver from $t2 to $fp-32
	# _tmp2950 = "There was a tie...You all lose!\n"
	  .data			# create string constant marked with label
	  _string185: .asciiz "There was a tie...You all lose!\n"
	  .text
	  la $t2, _string185	# load label
	  sw $t2, -332($fp)	# spill _tmp2950 from $t2 to $fp-332
	# PushParam _tmp2950
	  subu $sp, $sp, 4	# decrement sp to make space for param
	  lw $t0, -332($fp)	# fill _tmp2950 to $t0 from $fp-332
	  sw $t0, 4($sp)	# copy param value to stack
	# LCall _PrintString
	  jal _PrintString   	# jump to function
	# PopParams 4
	  add $sp, $sp, 4	# pop params off stack
	# Goto _L302
	  b _L302		# unconditional branch
  _L301:
	# PushParam human
	  subu $sp, $sp, 4	# decrement sp to make space for param
	  lw $t0, -12($fp)	# fill human to $t0 from $fp-12
	  sw $t0, 4($sp)	# copy param value to stack
	# PushParam grid
	  subu $sp, $sp, 4	# decrement sp to make space for param
	  lw $t0, -8($fp)	# fill grid to $t0 from $fp-8
	  sw $t0, 4($sp)	# copy param value to stack
	# PushParam computer
	  subu $sp, $sp, 4	# decrement sp to make space for param
	  lw $t0, -16($fp)	# fill computer to $t0 from $fp-16
	  sw $t0, 4($sp)	# copy param value to stack
	# _tmp2951 = *(computer)
	  lw $t0, -16($fp)	# fill computer to $t0 from $fp-16
	  lw $t2, 0($t0) 	# load with offset
	  sw $t2, -336($fp)	# spill _tmp2951 from $t2 to $fp-336
	# _tmp2952 = *(_tmp2951 + 12)
	  lw $t0, -336($fp)	# fill _tmp2951 to $t0 from $fp-336
	  lw $t2, 12($t0) 	# load with offset
	  sw $t2, -340($fp)	# spill _tmp2952 from $t2 to $fp-340
	# ACall _tmp2952
	  lw $t0, -340($fp)	# fill _tmp2952 to $t0 from $fp-340
	  jalr $t0            	# jump to function
	# PopParams 12
	  add $sp, $sp, 12	# pop params off stack
  _L302:
  _L298:
	# IfZ gameOver Goto _L308
	  lw $t0, -32($fp)	# fill gameOver to $t0 from $fp-32
	  beqz $t0, _L308	# branch if gameOver is zero 
	# _tmp2954 = 0
	  li $t2, 0		# load constant value 0 into $t2
	  sw $t2, -348($fp)	# spill _tmp2954 from $t2 to $fp-348
	# _tmp2953 = _tmp2954
	  lw $t2, -348($fp)	# fill _tmp2954 to $t2 from $fp-348
	  sw $t2, -344($fp)	# spill _tmp2953 from $t2 to $fp-344
	# Goto _L307
	  b _L307		# unconditional branch
  _L308:
	# _tmp2955 = 1
	  li $t2, 1		# load constant value 1 into $t2
	  sw $t2, -352($fp)	# spill _tmp2955 from $t2 to $fp-352
	# _tmp2953 = _tmp2955
	  lw $t2, -352($fp)	# fill _tmp2955 to $t2 from $fp-352
	  sw $t2, -344($fp)	# spill _tmp2953 from $t2 to $fp-344
  _L307:
	# PushParam computer
	  subu $sp, $sp, 4	# decrement sp to make space for param
	  lw $t0, -16($fp)	# fill computer to $t0 from $fp-16
	  sw $t0, 4($sp)	# copy param value to stack
	# PushParam grid
	  subu $sp, $sp, 4	# decrement sp to make space for param
	  lw $t0, -8($fp)	# fill grid to $t0 from $fp-8
	  sw $t0, 4($sp)	# copy param value to stack
	# _tmp2957 = *(grid)
	  lw $t0, -8($fp)	# fill grid to $t0 from $fp-8
	  lw $t2, 0($t0) 	# load with offset
	  sw $t2, -360($fp)	# spill _tmp2957 from $t2 to $fp-360
	# _tmp2958 = *(_tmp2957 + 20)
	  lw $t0, -360($fp)	# fill _tmp2957 to $t0 from $fp-360
	  lw $t2, 20($t0) 	# load with offset
	  sw $t2, -364($fp)	# spill _tmp2958 from $t2 to $fp-364
	# _tmp2959 = ACall _tmp2958
	  lw $t0, -364($fp)	# fill _tmp2958 to $t0 from $fp-364
	  jalr $t0            	# jump to function
	  move $t2, $v0		# copy function return value from $v0
	  sw $t2, -368($fp)	# spill _tmp2959 from $t2 to $fp-368
	# PopParams 8
	  add $sp, $sp, 8	# pop params off stack
	# IfZ _tmp2959 Goto _L310
	  lw $t0, -368($fp)	# fill _tmp2959 to $t0 from $fp-368
	  beqz $t0, _L310	# branch if _tmp2959 is zero 
	# _tmp2960 = 0
	  li $t2, 0		# load constant value 0 into $t2
	  sw $t2, -372($fp)	# spill _tmp2960 from $t2 to $fp-372
	# _tmp2956 = _tmp2960
	  lw $t2, -372($fp)	# fill _tmp2960 to $t2 from $fp-372
	  sw $t2, -356($fp)	# spill _tmp2956 from $t2 to $fp-356
	# Goto _L309
	  b _L309		# unconditional branch
  _L310:
	# _tmp2961 = 1
	  li $t2, 1		# load constant value 1 into $t2
	  sw $t2, -376($fp)	# spill _tmp2961 from $t2 to $fp-376
	# _tmp2956 = _tmp2961
	  lw $t2, -376($fp)	# fill _tmp2961 to $t2 from $fp-376
	  sw $t2, -356($fp)	# spill _tmp2956 from $t2 to $fp-356
  _L309:
	# _tmp2962 = _tmp2953 && _tmp2956
	  lw $t0, -344($fp)	# fill _tmp2953 to $t0 from $fp-344
	  lw $t1, -356($fp)	# fill _tmp2956 to $t1 from $fp-356
	  and $t2, $t0, $t1	
	  sw $t2, -380($fp)	# spill _tmp2962 from $t2 to $fp-380
	# IfZ _tmp2962 Goto _L305
	  lw $t0, -380($fp)	# fill _tmp2962 to $t0 from $fp-380
	  beqz $t0, _L305	# branch if _tmp2962 is zero 
	# _tmp2963 = "Loser -- the computer won!\n"
	  .data			# create string constant marked with label
	  _string186: .asciiz "Loser -- the computer won!\n"
	  .text
	  la $t2, _string186	# load label
	  sw $t2, -384($fp)	# spill _tmp2963 from $t2 to $fp-384
	# PushParam _tmp2963
	  subu $sp, $sp, 4	# decrement sp to make space for param
	  lw $t0, -384($fp)	# fill _tmp2963 to $t0 from $fp-384
	  sw $t0, 4($sp)	# copy param value to stack
	# LCall _PrintString
	  jal _PrintString   	# jump to function
	# PopParams 4
	  add $sp, $sp, 4	# pop params off stack
	# _tmp2964 = 1
	  li $t2, 1		# load constant value 1 into $t2
	  sw $t2, -388($fp)	# spill _tmp2964 from $t2 to $fp-388
	# gameOver = _tmp2964
	  lw $t2, -388($fp)	# fill _tmp2964 to $t2 from $fp-388
	  sw $t2, -32($fp)	# spill gameOver from $t2 to $fp-32
	# Goto _L306
	  b _L306		# unconditional branch
  _L305:
  _L306:
	# Goto _L285
	  b _L285		# unconditional branch
  _L286:
	# EndFunc
	# (below handles reaching end of fn body with no explicit return)
	  move $sp, $fp		# pop callee frame off stack
	  lw $ra, -4($fp)	# restore saved ra
	  lw $fp, 0($fp)	# restore saved fp
	  jr $ra		# return from function
