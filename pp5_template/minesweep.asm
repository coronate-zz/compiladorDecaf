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
	# VTable for class rndModule
	  .data
	  .align 2
	  rndModule:		# label for class rndModule vtable
	  .word rndModule.____Init
	  .word rndModule.____Random
	  .word rndModule.____RndInt
	  .text
  Block.____Init:
	# BeginFunc 12
	  subu $sp, $sp, 8	# decrement sp to make space to save ra, fp
	  sw $fp, 8($sp)	# save fp
	  sw $ra, 4($sp)	# save ra
	  addiu $fp, $sp, 8	# set up new fp
	  subu $sp, $sp, 12	# decrement sp to make space for locals/temps
	# _tmp14 = 0
	  li $t2, 0		# load constant value 0 into $t2
	  sw $t2, -8($fp)	# spill _tmp14 from $t2 to $fp-8
	# *(this + 4) = _tmp14
	  lw $t0, -8($fp)	# fill _tmp14 to $t0 from $fp-8
	  lw $t2, 4($fp)	# fill this to $t2 from $fp+4
	  sw $t0, 4($t2) 	# store with offset
	# _tmp15 = 0
	  li $t2, 0		# load constant value 0 into $t2
	  sw $t2, -12($fp)	# spill _tmp15 from $t2 to $fp-12
	# *(this + 8) = _tmp15
	  lw $t0, -12($fp)	# fill _tmp15 to $t0 from $fp-12
	  lw $t2, 4($fp)	# fill this to $t2 from $fp+4
	  sw $t0, 8($t2) 	# store with offset
	# _tmp16 = 0
	  li $t2, 0		# load constant value 0 into $t2
	  sw $t2, -16($fp)	# spill _tmp16 from $t2 to $fp-16
	# *(this + 12) = _tmp16
	  lw $t0, -16($fp)	# fill _tmp16 to $t0 from $fp-16
	  lw $t2, 4($fp)	# fill this to $t2 from $fp+4
	  sw $t0, 12($t2) 	# store with offset
	# EndFunc
	# (below handles reaching end of fn body with no explicit return)
	  move $sp, $fp		# pop callee frame off stack
	  lw $ra, -4($fp)	# restore saved ra
	  lw $fp, 0($fp)	# restore saved fp
	  jr $ra		# return from function
  Block.____Uncover:
	# BeginFunc 4
	  subu $sp, $sp, 8	# decrement sp to make space to save ra, fp
	  sw $fp, 8($sp)	# save fp
	  sw $ra, 4($sp)	# save ra
	  addiu $fp, $sp, 8	# set up new fp
	  subu $sp, $sp, 4	# decrement sp to make space for locals/temps
	# _tmp17 = 1
	  li $t2, 1		# load constant value 1 into $t2
	  sw $t2, -8($fp)	# spill _tmp17 from $t2 to $fp-8
	# *(this + 12) = _tmp17
	  lw $t0, -8($fp)	# fill _tmp17 to $t0 from $fp-8
	  lw $t2, 4($fp)	# fill this to $t2 from $fp+4
	  sw $t0, 12($t2) 	# store with offset
	# EndFunc
	# (below handles reaching end of fn body with no explicit return)
	  move $sp, $fp		# pop callee frame off stack
	  lw $ra, -4($fp)	# restore saved ra
	  lw $fp, 0($fp)	# restore saved fp
	  jr $ra		# return from function
  Block.____IsUncovered:
	# BeginFunc 4
	  subu $sp, $sp, 8	# decrement sp to make space to save ra, fp
	  sw $fp, 8($sp)	# save fp
	  sw $ra, 4($sp)	# save ra
	  addiu $fp, $sp, 8	# set up new fp
	  subu $sp, $sp, 4	# decrement sp to make space for locals/temps
	# _tmp18 = *(this + 12)
	  lw $t0, 4($fp)	# fill this to $t0 from $fp+4
	  lw $t2, 12($t0) 	# load with offset
	  sw $t2, -8($fp)	# spill _tmp18 from $t2 to $fp-8
	# Return _tmp18
	  lw $t2, -8($fp)	# fill _tmp18 to $t2 from $fp-8
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
  Block.____SetMine:
	# BeginFunc 0
	  subu $sp, $sp, 8	# decrement sp to make space to save ra, fp
	  sw $fp, 8($sp)	# save fp
	  sw $ra, 4($sp)	# save ra
	  addiu $fp, $sp, 8	# set up new fp
	# *(this + 4) = m
	  lw $t0, 8($fp)	# fill m to $t0 from $fp+8
	  lw $t2, 4($fp)	# fill this to $t2 from $fp+4
	  sw $t0, 4($t2) 	# store with offset
	# EndFunc
	# (below handles reaching end of fn body with no explicit return)
	  move $sp, $fp		# pop callee frame off stack
	  lw $ra, -4($fp)	# restore saved ra
	  lw $fp, 0($fp)	# restore saved fp
	  jr $ra		# return from function
  Block.____HasMine:
	# BeginFunc 4
	  subu $sp, $sp, 8	# decrement sp to make space to save ra, fp
	  sw $fp, 8($sp)	# save fp
	  sw $ra, 4($sp)	# save ra
	  addiu $fp, $sp, 8	# set up new fp
	  subu $sp, $sp, 4	# decrement sp to make space for locals/temps
	# _tmp19 = *(this + 4)
	  lw $t0, 4($fp)	# fill this to $t0 from $fp+4
	  lw $t2, 4($t0) 	# load with offset
	  sw $t2, -8($fp)	# spill _tmp19 from $t2 to $fp-8
	# Return _tmp19
	  lw $t2, -8($fp)	# fill _tmp19 to $t2 from $fp-8
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
  Block.____IncrementAdjacents:
	# BeginFunc 8
	  subu $sp, $sp, 8	# decrement sp to make space to save ra, fp
	  sw $fp, 8($sp)	# save fp
	  sw $ra, 4($sp)	# save ra
	  addiu $fp, $sp, 8	# set up new fp
	  subu $sp, $sp, 8	# decrement sp to make space for locals/temps
	# _tmp20 = *(this + 8)
	  lw $t0, 4($fp)	# fill this to $t0 from $fp+4
	  lw $t2, 8($t0) 	# load with offset
	  sw $t2, -8($fp)	# spill _tmp20 from $t2 to $fp-8
	# _tmp21 = _tmp20 + i
	  lw $t0, -8($fp)	# fill _tmp20 to $t0 from $fp-8
	  lw $t1, 8($fp)	# fill i to $t1 from $fp+8
	  add $t2, $t0, $t1	
	  sw $t2, -12($fp)	# spill _tmp21 from $t2 to $fp-12
	# *(this + 8) = _tmp21
	  lw $t0, -12($fp)	# fill _tmp21 to $t0 from $fp-12
	  lw $t2, 4($fp)	# fill this to $t2 from $fp+4
	  sw $t0, 8($t2) 	# store with offset
	# EndFunc
	# (below handles reaching end of fn body with no explicit return)
	  move $sp, $fp		# pop callee frame off stack
	  lw $ra, -4($fp)	# restore saved ra
	  lw $fp, 0($fp)	# restore saved fp
	  jr $ra		# return from function
  Block.____SetAdjacents:
	# BeginFunc 0
	  subu $sp, $sp, 8	# decrement sp to make space to save ra, fp
	  sw $fp, 8($sp)	# save fp
	  sw $ra, 4($sp)	# save ra
	  addiu $fp, $sp, 8	# set up new fp
	# *(this + 8) = i
	  lw $t0, 8($fp)	# fill i to $t0 from $fp+8
	  lw $t2, 4($fp)	# fill this to $t2 from $fp+4
	  sw $t0, 8($t2) 	# store with offset
	# EndFunc
	# (below handles reaching end of fn body with no explicit return)
	  move $sp, $fp		# pop callee frame off stack
	  lw $ra, -4($fp)	# restore saved ra
	  lw $fp, 0($fp)	# restore saved fp
	  jr $ra		# return from function
  Block.____NumAdjacents:
	# BeginFunc 4
	  subu $sp, $sp, 8	# decrement sp to make space to save ra, fp
	  sw $fp, 8($sp)	# save fp
	  sw $ra, 4($sp)	# save ra
	  addiu $fp, $sp, 8	# set up new fp
	  subu $sp, $sp, 4	# decrement sp to make space for locals/temps
	# _tmp22 = *(this + 8)
	  lw $t0, 4($fp)	# fill this to $t0 from $fp+4
	  lw $t2, 8($t0) 	# load with offset
	  sw $t2, -8($fp)	# spill _tmp22 from $t2 to $fp-8
	# Return _tmp22
	  lw $t2, -8($fp)	# fill _tmp22 to $t2 from $fp-8
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
  Block.____PrintOutput:
	# BeginFunc 60
	  subu $sp, $sp, 8	# decrement sp to make space to save ra, fp
	  sw $fp, 8($sp)	# save fp
	  sw $ra, 4($sp)	# save ra
	  addiu $fp, $sp, 8	# set up new fp
	  subu $sp, $sp, 60	# decrement sp to make space for locals/temps
	# IfZ printSolution Goto _L0
	  lw $t0, 8($fp)	# fill printSolution to $t0 from $fp+8
	  beqz $t0, _L0	# branch if printSolution is zero 
	# _tmp23 = *(this + 4)
	  lw $t0, 4($fp)	# fill this to $t0 from $fp+4
	  lw $t2, 4($t0) 	# load with offset
	  sw $t2, -8($fp)	# spill _tmp23 from $t2 to $fp-8
	# IfZ _tmp23 Goto _L2
	  lw $t0, -8($fp)	# fill _tmp23 to $t0 from $fp-8
	  beqz $t0, _L2	# branch if _tmp23 is zero 
	# _tmp25 = *(this + 12)
	  lw $t0, 4($fp)	# fill this to $t0 from $fp+4
	  lw $t2, 12($t0) 	# load with offset
	  sw $t2, -16($fp)	# spill _tmp25 from $t2 to $fp-16
	# IfZ _tmp25 Goto _L7
	  lw $t0, -16($fp)	# fill _tmp25 to $t0 from $fp-16
	  beqz $t0, _L7	# branch if _tmp25 is zero 
	# _tmp26 = 0
	  li $t2, 0		# load constant value 0 into $t2
	  sw $t2, -20($fp)	# spill _tmp26 from $t2 to $fp-20
	# _tmp24 = _tmp26
	  lw $t2, -20($fp)	# fill _tmp26 to $t2 from $fp-20
	  sw $t2, -12($fp)	# spill _tmp24 from $t2 to $fp-12
	# Goto _L6
	  b _L6		# unconditional branch
  _L7:
	# _tmp27 = 1
	  li $t2, 1		# load constant value 1 into $t2
	  sw $t2, -24($fp)	# spill _tmp27 from $t2 to $fp-24
	# _tmp24 = _tmp27
	  lw $t2, -24($fp)	# fill _tmp27 to $t2 from $fp-24
	  sw $t2, -12($fp)	# spill _tmp24 from $t2 to $fp-12
  _L6:
	# IfZ _tmp24 Goto _L4
	  lw $t0, -12($fp)	# fill _tmp24 to $t0 from $fp-12
	  beqz $t0, _L4	# branch if _tmp24 is zero 
	# _tmp28 = "x"
	  .data			# create string constant marked with label
	  _string1: .asciiz "x"
	  .text
	  la $t2, _string1	# load label
	  sw $t2, -28($fp)	# spill _tmp28 from $t2 to $fp-28
	# PushParam _tmp28
	  subu $sp, $sp, 4	# decrement sp to make space for param
	  lw $t0, -28($fp)	# fill _tmp28 to $t0 from $fp-28
	  sw $t0, 4($sp)	# copy param value to stack
	# LCall _PrintString
	  jal _PrintString   	# jump to function
	# PopParams 4
	  add $sp, $sp, 4	# pop params off stack
	# Goto _L5
	  b _L5		# unconditional branch
  _L4:
	# _tmp29 = "%"
	  .data			# create string constant marked with label
	  _string2: .asciiz "%"
	  .text
	  la $t2, _string2	# load label
	  sw $t2, -32($fp)	# spill _tmp29 from $t2 to $fp-32
	# PushParam _tmp29
	  subu $sp, $sp, 4	# decrement sp to make space for param
	  lw $t0, -32($fp)	# fill _tmp29 to $t0 from $fp-32
	  sw $t0, 4($sp)	# copy param value to stack
	# LCall _PrintString
	  jal _PrintString   	# jump to function
	# PopParams 4
	  add $sp, $sp, 4	# pop params off stack
  _L5:
	# Goto _L3
	  b _L3		# unconditional branch
  _L2:
	# _tmp30 = *(this + 8)
	  lw $t0, 4($fp)	# fill this to $t0 from $fp+4
	  lw $t2, 8($t0) 	# load with offset
	  sw $t2, -36($fp)	# spill _tmp30 from $t2 to $fp-36
	# PushParam _tmp30
	  subu $sp, $sp, 4	# decrement sp to make space for param
	  lw $t0, -36($fp)	# fill _tmp30 to $t0 from $fp-36
	  sw $t0, 4($sp)	# copy param value to stack
	# LCall _PrintInt
	  jal _PrintInt      	# jump to function
	# PopParams 4
	  add $sp, $sp, 4	# pop params off stack
  _L3:
	# Return 
	  move $sp, $fp		# pop callee frame off stack
	  lw $ra, -4($fp)	# restore saved ra
	  lw $fp, 0($fp)	# restore saved fp
	  jr $ra		# return from function
	# Goto _L1
	  b _L1		# unconditional branch
  _L0:
  _L1:
	# _tmp31 = *(this + 12)
	  lw $t0, 4($fp)	# fill this to $t0 from $fp+4
	  lw $t2, 12($t0) 	# load with offset
	  sw $t2, -40($fp)	# spill _tmp31 from $t2 to $fp-40
	# IfZ _tmp31 Goto _L8
	  lw $t0, -40($fp)	# fill _tmp31 to $t0 from $fp-40
	  beqz $t0, _L8	# branch if _tmp31 is zero 
	# _tmp33 = *(this + 4)
	  lw $t0, 4($fp)	# fill this to $t0 from $fp+4
	  lw $t2, 4($t0) 	# load with offset
	  sw $t2, -48($fp)	# spill _tmp33 from $t2 to $fp-48
	# IfZ _tmp33 Goto _L13
	  lw $t0, -48($fp)	# fill _tmp33 to $t0 from $fp-48
	  beqz $t0, _L13	# branch if _tmp33 is zero 
	# _tmp34 = 0
	  li $t2, 0		# load constant value 0 into $t2
	  sw $t2, -52($fp)	# spill _tmp34 from $t2 to $fp-52
	# _tmp32 = _tmp34
	  lw $t2, -52($fp)	# fill _tmp34 to $t2 from $fp-52
	  sw $t2, -44($fp)	# spill _tmp32 from $t2 to $fp-44
	# Goto _L12
	  b _L12		# unconditional branch
  _L13:
	# _tmp35 = 1
	  li $t2, 1		# load constant value 1 into $t2
	  sw $t2, -56($fp)	# spill _tmp35 from $t2 to $fp-56
	# _tmp32 = _tmp35
	  lw $t2, -56($fp)	# fill _tmp35 to $t2 from $fp-56
	  sw $t2, -44($fp)	# spill _tmp32 from $t2 to $fp-44
  _L12:
	# IfZ _tmp32 Goto _L10
	  lw $t0, -44($fp)	# fill _tmp32 to $t0 from $fp-44
	  beqz $t0, _L10	# branch if _tmp32 is zero 
	# _tmp36 = *(this + 8)
	  lw $t0, 4($fp)	# fill this to $t0 from $fp+4
	  lw $t2, 8($t0) 	# load with offset
	  sw $t2, -60($fp)	# spill _tmp36 from $t2 to $fp-60
	# PushParam _tmp36
	  subu $sp, $sp, 4	# decrement sp to make space for param
	  lw $t0, -60($fp)	# fill _tmp36 to $t0 from $fp-60
	  sw $t0, 4($sp)	# copy param value to stack
	# LCall _PrintInt
	  jal _PrintInt      	# jump to function
	# PopParams 4
	  add $sp, $sp, 4	# pop params off stack
	# Goto _L11
	  b _L11		# unconditional branch
  _L10:
  _L11:
	# Goto _L9
	  b _L9		# unconditional branch
  _L8:
	# _tmp37 = "+"
	  .data			# create string constant marked with label
	  _string3: .asciiz "+"
	  .text
	  la $t2, _string3	# load label
	  sw $t2, -64($fp)	# spill _tmp37 from $t2 to $fp-64
	# PushParam _tmp37
	  subu $sp, $sp, 4	# decrement sp to make space for param
	  lw $t0, -64($fp)	# fill _tmp37 to $t0 from $fp-64
	  sw $t0, 4($sp)	# copy param value to stack
	# LCall _PrintString
	  jal _PrintString   	# jump to function
	# PopParams 4
	  add $sp, $sp, 4	# pop params off stack
  _L9:
	# EndFunc
	# (below handles reaching end of fn body with no explicit return)
	  move $sp, $fp		# pop callee frame off stack
	  lw $ra, -4($fp)	# restore saved ra
	  lw $fp, 0($fp)	# restore saved fp
	  jr $ra		# return from function
	# VTable for class Block
	  .data
	  .align 2
	  Block:		# label for class Block vtable
	  .word Block.____Init
	  .word Block.____Uncover
	  .word Block.____IsUncovered
	  .word Block.____SetMine
	  .word Block.____HasMine
	  .word Block.____IncrementAdjacents
	  .word Block.____SetAdjacents
	  .word Block.____NumAdjacents
	  .word Block.____PrintOutput
	  .text
  Field.____Init:
	# BeginFunc 512
	  subu $sp, $sp, 8	# decrement sp to make space to save ra, fp
	  sw $fp, 8($sp)	# save fp
	  sw $ra, 4($sp)	# save ra
	  addiu $fp, $sp, 8	# set up new fp
	  subu $sp, $sp, 512	# decrement sp to make space for locals/temps
	# *(this + 4) = h
	  lw $t0, 8($fp)	# fill h to $t0 from $fp+8
	  lw $t2, 4($fp)	# fill this to $t2 from $fp+4
	  sw $t0, 4($t2) 	# store with offset
	# *(this + 8) = w
	  lw $t0, 12($fp)	# fill w to $t0 from $fp+12
	  lw $t2, 4($fp)	# fill this to $t2 from $fp+4
	  sw $t0, 8($t2) 	# store with offset
	# _tmp38 = 1
	  li $t2, 1		# load constant value 1 into $t2
	  sw $t2, -16($fp)	# spill _tmp38 from $t2 to $fp-16
	# *(this + 16) = _tmp38
	  lw $t0, -16($fp)	# fill _tmp38 to $t0 from $fp-16
	  lw $t2, 4($fp)	# fill this to $t2 from $fp+4
	  sw $t0, 16($t2) 	# store with offset
	# _tmp39 = h * w
	  lw $t0, 8($fp)	# fill h to $t0 from $fp+8
	  lw $t1, 12($fp)	# fill w to $t1 from $fp+12
	  mul $t2, $t0, $t1	
	  sw $t2, -20($fp)	# spill _tmp39 from $t2 to $fp-20
	# *(this + 20) = _tmp39
	  lw $t0, -20($fp)	# fill _tmp39 to $t0 from $fp-20
	  lw $t2, 4($fp)	# fill this to $t2 from $fp+4
	  sw $t0, 20($t2) 	# store with offset
	# _tmp40 = 0
	  li $t2, 0		# load constant value 0 into $t2
	  sw $t2, -24($fp)	# spill _tmp40 from $t2 to $fp-24
	# *(this + 24) = _tmp40
	  lw $t0, -24($fp)	# fill _tmp40 to $t0 from $fp-24
	  lw $t2, 4($fp)	# fill this to $t2 from $fp+4
	  sw $t0, 24($t2) 	# store with offset
	# _tmp41 = *(this + 8)
	  lw $t0, 4($fp)	# fill this to $t0 from $fp+4
	  lw $t2, 8($t0) 	# load with offset
	  sw $t2, -28($fp)	# spill _tmp41 from $t2 to $fp-28
	# _tmp42 = 4
	  li $t2, 4		# load constant value 4 into $t2
	  sw $t2, -32($fp)	# spill _tmp42 from $t2 to $fp-32
	# _tmp43 = 0
	  li $t2, 0		# load constant value 0 into $t2
	  sw $t2, -36($fp)	# spill _tmp43 from $t2 to $fp-36
	# _tmp44 = _tmp41 < _tmp43
	  lw $t0, -28($fp)	# fill _tmp41 to $t0 from $fp-28
	  lw $t1, -36($fp)	# fill _tmp43 to $t1 from $fp-36
	  slt $t2, $t0, $t1	
	  sw $t2, -40($fp)	# spill _tmp44 from $t2 to $fp-40
	# _tmp45 = _tmp41 == _tmp43
	  lw $t0, -28($fp)	# fill _tmp41 to $t0 from $fp-28
	  lw $t1, -36($fp)	# fill _tmp43 to $t1 from $fp-36
	  seq $t2, $t0, $t1	
	  sw $t2, -44($fp)	# spill _tmp45 from $t2 to $fp-44
	# _tmp46 = _tmp44 || _tmp45
	  lw $t0, -40($fp)	# fill _tmp44 to $t0 from $fp-40
	  lw $t1, -44($fp)	# fill _tmp45 to $t1 from $fp-44
	  or $t2, $t0, $t1	
	  sw $t2, -48($fp)	# spill _tmp46 from $t2 to $fp-48
	# IfZ _tmp46 Goto _L14
	  lw $t0, -48($fp)	# fill _tmp46 to $t0 from $fp-48
	  beqz $t0, _L14	# branch if _tmp46 is zero 
	# _tmp47 = "Decaf runtime error: Array size is <= 0\n"
	  .data			# create string constant marked with label
	  _string4: .asciiz "Decaf runtime error: Array size is <= 0\n"
	  .text
	  la $t2, _string4	# load label
	  sw $t2, -52($fp)	# spill _tmp47 from $t2 to $fp-52
	# PushParam _tmp47
	  subu $sp, $sp, 4	# decrement sp to make space for param
	  lw $t0, -52($fp)	# fill _tmp47 to $t0 from $fp-52
	  sw $t0, 4($sp)	# copy param value to stack
	# LCall _PrintString
	  jal _PrintString   	# jump to function
	# PopParams 4
	  add $sp, $sp, 4	# pop params off stack
	# LCall _Halt
	  jal _Halt          	# jump to function
  _L14:
	# _tmp48 = _tmp41 * _tmp42
	  lw $t0, -28($fp)	# fill _tmp41 to $t0 from $fp-28
	  lw $t1, -32($fp)	# fill _tmp42 to $t1 from $fp-32
	  mul $t2, $t0, $t1	
	  sw $t2, -56($fp)	# spill _tmp48 from $t2 to $fp-56
	# _tmp49 = _tmp42 + _tmp48
	  lw $t0, -32($fp)	# fill _tmp42 to $t0 from $fp-32
	  lw $t1, -56($fp)	# fill _tmp48 to $t1 from $fp-56
	  add $t2, $t0, $t1	
	  sw $t2, -60($fp)	# spill _tmp49 from $t2 to $fp-60
	# PushParam _tmp49
	  subu $sp, $sp, 4	# decrement sp to make space for param
	  lw $t0, -60($fp)	# fill _tmp49 to $t0 from $fp-60
	  sw $t0, 4($sp)	# copy param value to stack
	# _tmp50 = LCall _Alloc
	  jal _Alloc         	# jump to function
	  move $t2, $v0		# copy function return value from $v0
	  sw $t2, -64($fp)	# spill _tmp50 from $t2 to $fp-64
	# PopParams 4
	  add $sp, $sp, 4	# pop params off stack
	# *(_tmp50) = _tmp41
	  lw $t0, -28($fp)	# fill _tmp41 to $t0 from $fp-28
	  lw $t2, -64($fp)	# fill _tmp50 to $t2 from $fp-64
	  sw $t0, 0($t2) 	# store with offset
	# *(this + 12) = _tmp50
	  lw $t0, -64($fp)	# fill _tmp50 to $t0 from $fp-64
	  lw $t2, 4($fp)	# fill this to $t2 from $fp+4
	  sw $t0, 12($t2) 	# store with offset
	# _tmp51 = 0
	  li $t2, 0		# load constant value 0 into $t2
	  sw $t2, -68($fp)	# spill _tmp51 from $t2 to $fp-68
	# i = _tmp51
	  lw $t2, -68($fp)	# fill _tmp51 to $t2 from $fp-68
	  sw $t2, -8($fp)	# spill i from $t2 to $fp-8
  _L15:
	# _tmp52 = *(this + 8)
	  lw $t0, 4($fp)	# fill this to $t0 from $fp+4
	  lw $t2, 8($t0) 	# load with offset
	  sw $t2, -72($fp)	# spill _tmp52 from $t2 to $fp-72
	# _tmp53 = i < _tmp52
	  lw $t0, -8($fp)	# fill i to $t0 from $fp-8
	  lw $t1, -72($fp)	# fill _tmp52 to $t1 from $fp-72
	  slt $t2, $t0, $t1	
	  sw $t2, -76($fp)	# spill _tmp53 from $t2 to $fp-76
	# IfZ _tmp53 Goto _L16
	  lw $t0, -76($fp)	# fill _tmp53 to $t0 from $fp-76
	  beqz $t0, _L16	# branch if _tmp53 is zero 
	# _tmp54 = *(this + 4)
	  lw $t0, 4($fp)	# fill this to $t0 from $fp+4
	  lw $t2, 4($t0) 	# load with offset
	  sw $t2, -80($fp)	# spill _tmp54 from $t2 to $fp-80
	# _tmp55 = 4
	  li $t2, 4		# load constant value 4 into $t2
	  sw $t2, -84($fp)	# spill _tmp55 from $t2 to $fp-84
	# _tmp56 = 0
	  li $t2, 0		# load constant value 0 into $t2
	  sw $t2, -88($fp)	# spill _tmp56 from $t2 to $fp-88
	# _tmp57 = _tmp54 < _tmp56
	  lw $t0, -80($fp)	# fill _tmp54 to $t0 from $fp-80
	  lw $t1, -88($fp)	# fill _tmp56 to $t1 from $fp-88
	  slt $t2, $t0, $t1	
	  sw $t2, -92($fp)	# spill _tmp57 from $t2 to $fp-92
	# _tmp58 = _tmp54 == _tmp56
	  lw $t0, -80($fp)	# fill _tmp54 to $t0 from $fp-80
	  lw $t1, -88($fp)	# fill _tmp56 to $t1 from $fp-88
	  seq $t2, $t0, $t1	
	  sw $t2, -96($fp)	# spill _tmp58 from $t2 to $fp-96
	# _tmp59 = _tmp57 || _tmp58
	  lw $t0, -92($fp)	# fill _tmp57 to $t0 from $fp-92
	  lw $t1, -96($fp)	# fill _tmp58 to $t1 from $fp-96
	  or $t2, $t0, $t1	
	  sw $t2, -100($fp)	# spill _tmp59 from $t2 to $fp-100
	# IfZ _tmp59 Goto _L17
	  lw $t0, -100($fp)	# fill _tmp59 to $t0 from $fp-100
	  beqz $t0, _L17	# branch if _tmp59 is zero 
	# _tmp60 = "Decaf runtime error: Array size is <= 0\n"
	  .data			# create string constant marked with label
	  _string5: .asciiz "Decaf runtime error: Array size is <= 0\n"
	  .text
	  la $t2, _string5	# load label
	  sw $t2, -104($fp)	# spill _tmp60 from $t2 to $fp-104
	# PushParam _tmp60
	  subu $sp, $sp, 4	# decrement sp to make space for param
	  lw $t0, -104($fp)	# fill _tmp60 to $t0 from $fp-104
	  sw $t0, 4($sp)	# copy param value to stack
	# LCall _PrintString
	  jal _PrintString   	# jump to function
	# PopParams 4
	  add $sp, $sp, 4	# pop params off stack
	# LCall _Halt
	  jal _Halt          	# jump to function
  _L17:
	# _tmp61 = _tmp54 * _tmp55
	  lw $t0, -80($fp)	# fill _tmp54 to $t0 from $fp-80
	  lw $t1, -84($fp)	# fill _tmp55 to $t1 from $fp-84
	  mul $t2, $t0, $t1	
	  sw $t2, -108($fp)	# spill _tmp61 from $t2 to $fp-108
	# _tmp62 = _tmp55 + _tmp61
	  lw $t0, -84($fp)	# fill _tmp55 to $t0 from $fp-84
	  lw $t1, -108($fp)	# fill _tmp61 to $t1 from $fp-108
	  add $t2, $t0, $t1	
	  sw $t2, -112($fp)	# spill _tmp62 from $t2 to $fp-112
	# PushParam _tmp62
	  subu $sp, $sp, 4	# decrement sp to make space for param
	  lw $t0, -112($fp)	# fill _tmp62 to $t0 from $fp-112
	  sw $t0, 4($sp)	# copy param value to stack
	# _tmp63 = LCall _Alloc
	  jal _Alloc         	# jump to function
	  move $t2, $v0		# copy function return value from $v0
	  sw $t2, -116($fp)	# spill _tmp63 from $t2 to $fp-116
	# PopParams 4
	  add $sp, $sp, 4	# pop params off stack
	# *(_tmp63) = _tmp54
	  lw $t0, -80($fp)	# fill _tmp54 to $t0 from $fp-80
	  lw $t2, -116($fp)	# fill _tmp63 to $t2 from $fp-116
	  sw $t0, 0($t2) 	# store with offset
	# _tmp64 = *(this + 12)
	  lw $t0, 4($fp)	# fill this to $t0 from $fp+4
	  lw $t2, 12($t0) 	# load with offset
	  sw $t2, -120($fp)	# spill _tmp64 from $t2 to $fp-120
	# _tmp65 = 0
	  li $t2, 0		# load constant value 0 into $t2
	  sw $t2, -124($fp)	# spill _tmp65 from $t2 to $fp-124
	# _tmp66 = *(_tmp64)
	  lw $t0, -120($fp)	# fill _tmp64 to $t0 from $fp-120
	  lw $t2, 0($t0) 	# load with offset
	  sw $t2, -128($fp)	# spill _tmp66 from $t2 to $fp-128
	# _tmp67 = i < _tmp65
	  lw $t0, -8($fp)	# fill i to $t0 from $fp-8
	  lw $t1, -124($fp)	# fill _tmp65 to $t1 from $fp-124
	  slt $t2, $t0, $t1	
	  sw $t2, -132($fp)	# spill _tmp67 from $t2 to $fp-132
	# _tmp68 = _tmp66 < i
	  lw $t0, -128($fp)	# fill _tmp66 to $t0 from $fp-128
	  lw $t1, -8($fp)	# fill i to $t1 from $fp-8
	  slt $t2, $t0, $t1	
	  sw $t2, -136($fp)	# spill _tmp68 from $t2 to $fp-136
	# _tmp69 = _tmp66 == i
	  lw $t0, -128($fp)	# fill _tmp66 to $t0 from $fp-128
	  lw $t1, -8($fp)	# fill i to $t1 from $fp-8
	  seq $t2, $t0, $t1	
	  sw $t2, -140($fp)	# spill _tmp69 from $t2 to $fp-140
	# _tmp70 = _tmp68 || _tmp69
	  lw $t0, -136($fp)	# fill _tmp68 to $t0 from $fp-136
	  lw $t1, -140($fp)	# fill _tmp69 to $t1 from $fp-140
	  or $t2, $t0, $t1	
	  sw $t2, -144($fp)	# spill _tmp70 from $t2 to $fp-144
	# _tmp71 = _tmp70 || _tmp67
	  lw $t0, -144($fp)	# fill _tmp70 to $t0 from $fp-144
	  lw $t1, -132($fp)	# fill _tmp67 to $t1 from $fp-132
	  or $t2, $t0, $t1	
	  sw $t2, -148($fp)	# spill _tmp71 from $t2 to $fp-148
	# IfZ _tmp71 Goto _L18
	  lw $t0, -148($fp)	# fill _tmp71 to $t0 from $fp-148
	  beqz $t0, _L18	# branch if _tmp71 is zero 
	# _tmp72 = "Decaf runtime error: Array subscript out of bound..."
	  .data			# create string constant marked with label
	  _string6: .asciiz "Decaf runtime error: Array subscript out of bounds\n"
	  .text
	  la $t2, _string6	# load label
	  sw $t2, -152($fp)	# spill _tmp72 from $t2 to $fp-152
	# PushParam _tmp72
	  subu $sp, $sp, 4	# decrement sp to make space for param
	  lw $t0, -152($fp)	# fill _tmp72 to $t0 from $fp-152
	  sw $t0, 4($sp)	# copy param value to stack
	# LCall _PrintString
	  jal _PrintString   	# jump to function
	# PopParams 4
	  add $sp, $sp, 4	# pop params off stack
	# LCall _Halt
	  jal _Halt          	# jump to function
  _L18:
	# _tmp73 = 4
	  li $t2, 4		# load constant value 4 into $t2
	  sw $t2, -156($fp)	# spill _tmp73 from $t2 to $fp-156
	# _tmp74 = i * _tmp73
	  lw $t0, -8($fp)	# fill i to $t0 from $fp-8
	  lw $t1, -156($fp)	# fill _tmp73 to $t1 from $fp-156
	  mul $t2, $t0, $t1	
	  sw $t2, -160($fp)	# spill _tmp74 from $t2 to $fp-160
	# _tmp75 = _tmp74 + _tmp73
	  lw $t0, -160($fp)	# fill _tmp74 to $t0 from $fp-160
	  lw $t1, -156($fp)	# fill _tmp73 to $t1 from $fp-156
	  add $t2, $t0, $t1	
	  sw $t2, -164($fp)	# spill _tmp75 from $t2 to $fp-164
	# _tmp76 = _tmp64 + _tmp75
	  lw $t0, -120($fp)	# fill _tmp64 to $t0 from $fp-120
	  lw $t1, -164($fp)	# fill _tmp75 to $t1 from $fp-164
	  add $t2, $t0, $t1	
	  sw $t2, -168($fp)	# spill _tmp76 from $t2 to $fp-168
	# *(_tmp76) = _tmp63
	  lw $t0, -116($fp)	# fill _tmp63 to $t0 from $fp-116
	  lw $t2, -168($fp)	# fill _tmp76 to $t2 from $fp-168
	  sw $t0, 0($t2) 	# store with offset
	# _tmp77 = *(_tmp76)
	  lw $t0, -168($fp)	# fill _tmp76 to $t0 from $fp-168
	  lw $t2, 0($t0) 	# load with offset
	  sw $t2, -172($fp)	# spill _tmp77 from $t2 to $fp-172
	# _tmp78 = 1
	  li $t2, 1		# load constant value 1 into $t2
	  sw $t2, -176($fp)	# spill _tmp78 from $t2 to $fp-176
	# _tmp79 = i + _tmp78
	  lw $t0, -8($fp)	# fill i to $t0 from $fp-8
	  lw $t1, -176($fp)	# fill _tmp78 to $t1 from $fp-176
	  add $t2, $t0, $t1	
	  sw $t2, -180($fp)	# spill _tmp79 from $t2 to $fp-180
	# i = _tmp79
	  lw $t2, -180($fp)	# fill _tmp79 to $t2 from $fp-180
	  sw $t2, -8($fp)	# spill i from $t2 to $fp-8
	# Goto _L15
	  b _L15		# unconditional branch
  _L16:
	# _tmp80 = 0
	  li $t2, 0		# load constant value 0 into $t2
	  sw $t2, -184($fp)	# spill _tmp80 from $t2 to $fp-184
	# i = _tmp80
	  lw $t2, -184($fp)	# fill _tmp80 to $t2 from $fp-184
	  sw $t2, -8($fp)	# spill i from $t2 to $fp-8
  _L19:
	# _tmp81 = *(this + 8)
	  lw $t0, 4($fp)	# fill this to $t0 from $fp+4
	  lw $t2, 8($t0) 	# load with offset
	  sw $t2, -188($fp)	# spill _tmp81 from $t2 to $fp-188
	# _tmp82 = i < _tmp81
	  lw $t0, -8($fp)	# fill i to $t0 from $fp-8
	  lw $t1, -188($fp)	# fill _tmp81 to $t1 from $fp-188
	  slt $t2, $t0, $t1	
	  sw $t2, -192($fp)	# spill _tmp82 from $t2 to $fp-192
	# IfZ _tmp82 Goto _L20
	  lw $t0, -192($fp)	# fill _tmp82 to $t0 from $fp-192
	  beqz $t0, _L20	# branch if _tmp82 is zero 
	# _tmp83 = 0
	  li $t2, 0		# load constant value 0 into $t2
	  sw $t2, -196($fp)	# spill _tmp83 from $t2 to $fp-196
	# j = _tmp83
	  lw $t2, -196($fp)	# fill _tmp83 to $t2 from $fp-196
	  sw $t2, -12($fp)	# spill j from $t2 to $fp-12
  _L21:
	# _tmp84 = *(this + 4)
	  lw $t0, 4($fp)	# fill this to $t0 from $fp+4
	  lw $t2, 4($t0) 	# load with offset
	  sw $t2, -200($fp)	# spill _tmp84 from $t2 to $fp-200
	# _tmp85 = j < _tmp84
	  lw $t0, -12($fp)	# fill j to $t0 from $fp-12
	  lw $t1, -200($fp)	# fill _tmp84 to $t1 from $fp-200
	  slt $t2, $t0, $t1	
	  sw $t2, -204($fp)	# spill _tmp85 from $t2 to $fp-204
	# IfZ _tmp85 Goto _L22
	  lw $t0, -204($fp)	# fill _tmp85 to $t0 from $fp-204
	  beqz $t0, _L22	# branch if _tmp85 is zero 
	# _tmp86 = 12
	  li $t2, 12		# load constant value 12 into $t2
	  sw $t2, -208($fp)	# spill _tmp86 from $t2 to $fp-208
	# _tmp87 = 4
	  li $t2, 4		# load constant value 4 into $t2
	  sw $t2, -212($fp)	# spill _tmp87 from $t2 to $fp-212
	# _tmp88 = _tmp87 + _tmp86
	  lw $t0, -212($fp)	# fill _tmp87 to $t0 from $fp-212
	  lw $t1, -208($fp)	# fill _tmp86 to $t1 from $fp-208
	  add $t2, $t0, $t1	
	  sw $t2, -216($fp)	# spill _tmp88 from $t2 to $fp-216
	# PushParam _tmp88
	  subu $sp, $sp, 4	# decrement sp to make space for param
	  lw $t0, -216($fp)	# fill _tmp88 to $t0 from $fp-216
	  sw $t0, 4($sp)	# copy param value to stack
	# _tmp89 = LCall _Alloc
	  jal _Alloc         	# jump to function
	  move $t2, $v0		# copy function return value from $v0
	  sw $t2, -220($fp)	# spill _tmp89 from $t2 to $fp-220
	# PopParams 4
	  add $sp, $sp, 4	# pop params off stack
	# _tmp90 = Block
	  la $t2, Block	# load label
	  sw $t2, -224($fp)	# spill _tmp90 from $t2 to $fp-224
	# *(_tmp89) = _tmp90
	  lw $t0, -224($fp)	# fill _tmp90 to $t0 from $fp-224
	  lw $t2, -220($fp)	# fill _tmp89 to $t2 from $fp-220
	  sw $t0, 0($t2) 	# store with offset
	# _tmp91 = *(this + 12)
	  lw $t0, 4($fp)	# fill this to $t0 from $fp+4
	  lw $t2, 12($t0) 	# load with offset
	  sw $t2, -228($fp)	# spill _tmp91 from $t2 to $fp-228
	# _tmp92 = 0
	  li $t2, 0		# load constant value 0 into $t2
	  sw $t2, -232($fp)	# spill _tmp92 from $t2 to $fp-232
	# _tmp93 = *(_tmp91)
	  lw $t0, -228($fp)	# fill _tmp91 to $t0 from $fp-228
	  lw $t2, 0($t0) 	# load with offset
	  sw $t2, -236($fp)	# spill _tmp93 from $t2 to $fp-236
	# _tmp94 = i < _tmp92
	  lw $t0, -8($fp)	# fill i to $t0 from $fp-8
	  lw $t1, -232($fp)	# fill _tmp92 to $t1 from $fp-232
	  slt $t2, $t0, $t1	
	  sw $t2, -240($fp)	# spill _tmp94 from $t2 to $fp-240
	# _tmp95 = _tmp93 < i
	  lw $t0, -236($fp)	# fill _tmp93 to $t0 from $fp-236
	  lw $t1, -8($fp)	# fill i to $t1 from $fp-8
	  slt $t2, $t0, $t1	
	  sw $t2, -244($fp)	# spill _tmp95 from $t2 to $fp-244
	# _tmp96 = _tmp93 == i
	  lw $t0, -236($fp)	# fill _tmp93 to $t0 from $fp-236
	  lw $t1, -8($fp)	# fill i to $t1 from $fp-8
	  seq $t2, $t0, $t1	
	  sw $t2, -248($fp)	# spill _tmp96 from $t2 to $fp-248
	# _tmp97 = _tmp95 || _tmp96
	  lw $t0, -244($fp)	# fill _tmp95 to $t0 from $fp-244
	  lw $t1, -248($fp)	# fill _tmp96 to $t1 from $fp-248
	  or $t2, $t0, $t1	
	  sw $t2, -252($fp)	# spill _tmp97 from $t2 to $fp-252
	# _tmp98 = _tmp97 || _tmp94
	  lw $t0, -252($fp)	# fill _tmp97 to $t0 from $fp-252
	  lw $t1, -240($fp)	# fill _tmp94 to $t1 from $fp-240
	  or $t2, $t0, $t1	
	  sw $t2, -256($fp)	# spill _tmp98 from $t2 to $fp-256
	# IfZ _tmp98 Goto _L23
	  lw $t0, -256($fp)	# fill _tmp98 to $t0 from $fp-256
	  beqz $t0, _L23	# branch if _tmp98 is zero 
	# _tmp99 = "Decaf runtime error: Array subscript out of bound..."
	  .data			# create string constant marked with label
	  _string7: .asciiz "Decaf runtime error: Array subscript out of bounds\n"
	  .text
	  la $t2, _string7	# load label
	  sw $t2, -260($fp)	# spill _tmp99 from $t2 to $fp-260
	# PushParam _tmp99
	  subu $sp, $sp, 4	# decrement sp to make space for param
	  lw $t0, -260($fp)	# fill _tmp99 to $t0 from $fp-260
	  sw $t0, 4($sp)	# copy param value to stack
	# LCall _PrintString
	  jal _PrintString   	# jump to function
	# PopParams 4
	  add $sp, $sp, 4	# pop params off stack
	# LCall _Halt
	  jal _Halt          	# jump to function
  _L23:
	# _tmp100 = 4
	  li $t2, 4		# load constant value 4 into $t2
	  sw $t2, -264($fp)	# spill _tmp100 from $t2 to $fp-264
	# _tmp101 = i * _tmp100
	  lw $t0, -8($fp)	# fill i to $t0 from $fp-8
	  lw $t1, -264($fp)	# fill _tmp100 to $t1 from $fp-264
	  mul $t2, $t0, $t1	
	  sw $t2, -268($fp)	# spill _tmp101 from $t2 to $fp-268
	# _tmp102 = _tmp101 + _tmp100
	  lw $t0, -268($fp)	# fill _tmp101 to $t0 from $fp-268
	  lw $t1, -264($fp)	# fill _tmp100 to $t1 from $fp-264
	  add $t2, $t0, $t1	
	  sw $t2, -272($fp)	# spill _tmp102 from $t2 to $fp-272
	# _tmp103 = _tmp91 + _tmp102
	  lw $t0, -228($fp)	# fill _tmp91 to $t0 from $fp-228
	  lw $t1, -272($fp)	# fill _tmp102 to $t1 from $fp-272
	  add $t2, $t0, $t1	
	  sw $t2, -276($fp)	# spill _tmp103 from $t2 to $fp-276
	# _tmp104 = *(_tmp103)
	  lw $t0, -276($fp)	# fill _tmp103 to $t0 from $fp-276
	  lw $t2, 0($t0) 	# load with offset
	  sw $t2, -280($fp)	# spill _tmp104 from $t2 to $fp-280
	# _tmp105 = 0
	  li $t2, 0		# load constant value 0 into $t2
	  sw $t2, -284($fp)	# spill _tmp105 from $t2 to $fp-284
	# _tmp106 = *(_tmp104)
	  lw $t0, -280($fp)	# fill _tmp104 to $t0 from $fp-280
	  lw $t2, 0($t0) 	# load with offset
	  sw $t2, -288($fp)	# spill _tmp106 from $t2 to $fp-288
	# _tmp107 = j < _tmp105
	  lw $t0, -12($fp)	# fill j to $t0 from $fp-12
	  lw $t1, -284($fp)	# fill _tmp105 to $t1 from $fp-284
	  slt $t2, $t0, $t1	
	  sw $t2, -292($fp)	# spill _tmp107 from $t2 to $fp-292
	# _tmp108 = _tmp106 < j
	  lw $t0, -288($fp)	# fill _tmp106 to $t0 from $fp-288
	  lw $t1, -12($fp)	# fill j to $t1 from $fp-12
	  slt $t2, $t0, $t1	
	  sw $t2, -296($fp)	# spill _tmp108 from $t2 to $fp-296
	# _tmp109 = _tmp106 == j
	  lw $t0, -288($fp)	# fill _tmp106 to $t0 from $fp-288
	  lw $t1, -12($fp)	# fill j to $t1 from $fp-12
	  seq $t2, $t0, $t1	
	  sw $t2, -300($fp)	# spill _tmp109 from $t2 to $fp-300
	# _tmp110 = _tmp108 || _tmp109
	  lw $t0, -296($fp)	# fill _tmp108 to $t0 from $fp-296
	  lw $t1, -300($fp)	# fill _tmp109 to $t1 from $fp-300
	  or $t2, $t0, $t1	
	  sw $t2, -304($fp)	# spill _tmp110 from $t2 to $fp-304
	# _tmp111 = _tmp110 || _tmp107
	  lw $t0, -304($fp)	# fill _tmp110 to $t0 from $fp-304
	  lw $t1, -292($fp)	# fill _tmp107 to $t1 from $fp-292
	  or $t2, $t0, $t1	
	  sw $t2, -308($fp)	# spill _tmp111 from $t2 to $fp-308
	# IfZ _tmp111 Goto _L24
	  lw $t0, -308($fp)	# fill _tmp111 to $t0 from $fp-308
	  beqz $t0, _L24	# branch if _tmp111 is zero 
	# _tmp112 = "Decaf runtime error: Array subscript out of bound..."
	  .data			# create string constant marked with label
	  _string8: .asciiz "Decaf runtime error: Array subscript out of bounds\n"
	  .text
	  la $t2, _string8	# load label
	  sw $t2, -312($fp)	# spill _tmp112 from $t2 to $fp-312
	# PushParam _tmp112
	  subu $sp, $sp, 4	# decrement sp to make space for param
	  lw $t0, -312($fp)	# fill _tmp112 to $t0 from $fp-312
	  sw $t0, 4($sp)	# copy param value to stack
	# LCall _PrintString
	  jal _PrintString   	# jump to function
	# PopParams 4
	  add $sp, $sp, 4	# pop params off stack
	# LCall _Halt
	  jal _Halt          	# jump to function
  _L24:
	# _tmp113 = 4
	  li $t2, 4		# load constant value 4 into $t2
	  sw $t2, -316($fp)	# spill _tmp113 from $t2 to $fp-316
	# _tmp114 = j * _tmp113
	  lw $t0, -12($fp)	# fill j to $t0 from $fp-12
	  lw $t1, -316($fp)	# fill _tmp113 to $t1 from $fp-316
	  mul $t2, $t0, $t1	
	  sw $t2, -320($fp)	# spill _tmp114 from $t2 to $fp-320
	# _tmp115 = _tmp114 + _tmp113
	  lw $t0, -320($fp)	# fill _tmp114 to $t0 from $fp-320
	  lw $t1, -316($fp)	# fill _tmp113 to $t1 from $fp-316
	  add $t2, $t0, $t1	
	  sw $t2, -324($fp)	# spill _tmp115 from $t2 to $fp-324
	# _tmp116 = _tmp104 + _tmp115
	  lw $t0, -280($fp)	# fill _tmp104 to $t0 from $fp-280
	  lw $t1, -324($fp)	# fill _tmp115 to $t1 from $fp-324
	  add $t2, $t0, $t1	
	  sw $t2, -328($fp)	# spill _tmp116 from $t2 to $fp-328
	# *(_tmp116) = _tmp89
	  lw $t0, -220($fp)	# fill _tmp89 to $t0 from $fp-220
	  lw $t2, -328($fp)	# fill _tmp116 to $t2 from $fp-328
	  sw $t0, 0($t2) 	# store with offset
	# _tmp117 = *(_tmp116)
	  lw $t0, -328($fp)	# fill _tmp116 to $t0 from $fp-328
	  lw $t2, 0($t0) 	# load with offset
	  sw $t2, -332($fp)	# spill _tmp117 from $t2 to $fp-332
	# _tmp118 = *(this + 12)
	  lw $t0, 4($fp)	# fill this to $t0 from $fp+4
	  lw $t2, 12($t0) 	# load with offset
	  sw $t2, -336($fp)	# spill _tmp118 from $t2 to $fp-336
	# _tmp119 = 0
	  li $t2, 0		# load constant value 0 into $t2
	  sw $t2, -340($fp)	# spill _tmp119 from $t2 to $fp-340
	# _tmp120 = *(_tmp118)
	  lw $t0, -336($fp)	# fill _tmp118 to $t0 from $fp-336
	  lw $t2, 0($t0) 	# load with offset
	  sw $t2, -344($fp)	# spill _tmp120 from $t2 to $fp-344
	# _tmp121 = i < _tmp119
	  lw $t0, -8($fp)	# fill i to $t0 from $fp-8
	  lw $t1, -340($fp)	# fill _tmp119 to $t1 from $fp-340
	  slt $t2, $t0, $t1	
	  sw $t2, -348($fp)	# spill _tmp121 from $t2 to $fp-348
	# _tmp122 = _tmp120 < i
	  lw $t0, -344($fp)	# fill _tmp120 to $t0 from $fp-344
	  lw $t1, -8($fp)	# fill i to $t1 from $fp-8
	  slt $t2, $t0, $t1	
	  sw $t2, -352($fp)	# spill _tmp122 from $t2 to $fp-352
	# _tmp123 = _tmp120 == i
	  lw $t0, -344($fp)	# fill _tmp120 to $t0 from $fp-344
	  lw $t1, -8($fp)	# fill i to $t1 from $fp-8
	  seq $t2, $t0, $t1	
	  sw $t2, -356($fp)	# spill _tmp123 from $t2 to $fp-356
	# _tmp124 = _tmp122 || _tmp123
	  lw $t0, -352($fp)	# fill _tmp122 to $t0 from $fp-352
	  lw $t1, -356($fp)	# fill _tmp123 to $t1 from $fp-356
	  or $t2, $t0, $t1	
	  sw $t2, -360($fp)	# spill _tmp124 from $t2 to $fp-360
	# _tmp125 = _tmp124 || _tmp121
	  lw $t0, -360($fp)	# fill _tmp124 to $t0 from $fp-360
	  lw $t1, -348($fp)	# fill _tmp121 to $t1 from $fp-348
	  or $t2, $t0, $t1	
	  sw $t2, -364($fp)	# spill _tmp125 from $t2 to $fp-364
	# IfZ _tmp125 Goto _L25
	  lw $t0, -364($fp)	# fill _tmp125 to $t0 from $fp-364
	  beqz $t0, _L25	# branch if _tmp125 is zero 
	# _tmp126 = "Decaf runtime error: Array subscript out of bound..."
	  .data			# create string constant marked with label
	  _string9: .asciiz "Decaf runtime error: Array subscript out of bounds\n"
	  .text
	  la $t2, _string9	# load label
	  sw $t2, -368($fp)	# spill _tmp126 from $t2 to $fp-368
	# PushParam _tmp126
	  subu $sp, $sp, 4	# decrement sp to make space for param
	  lw $t0, -368($fp)	# fill _tmp126 to $t0 from $fp-368
	  sw $t0, 4($sp)	# copy param value to stack
	# LCall _PrintString
	  jal _PrintString   	# jump to function
	# PopParams 4
	  add $sp, $sp, 4	# pop params off stack
	# LCall _Halt
	  jal _Halt          	# jump to function
  _L25:
	# _tmp127 = 4
	  li $t2, 4		# load constant value 4 into $t2
	  sw $t2, -372($fp)	# spill _tmp127 from $t2 to $fp-372
	# _tmp128 = i * _tmp127
	  lw $t0, -8($fp)	# fill i to $t0 from $fp-8
	  lw $t1, -372($fp)	# fill _tmp127 to $t1 from $fp-372
	  mul $t2, $t0, $t1	
	  sw $t2, -376($fp)	# spill _tmp128 from $t2 to $fp-376
	# _tmp129 = _tmp128 + _tmp127
	  lw $t0, -376($fp)	# fill _tmp128 to $t0 from $fp-376
	  lw $t1, -372($fp)	# fill _tmp127 to $t1 from $fp-372
	  add $t2, $t0, $t1	
	  sw $t2, -380($fp)	# spill _tmp129 from $t2 to $fp-380
	# _tmp130 = _tmp118 + _tmp129
	  lw $t0, -336($fp)	# fill _tmp118 to $t0 from $fp-336
	  lw $t1, -380($fp)	# fill _tmp129 to $t1 from $fp-380
	  add $t2, $t0, $t1	
	  sw $t2, -384($fp)	# spill _tmp130 from $t2 to $fp-384
	# _tmp131 = *(_tmp130)
	  lw $t0, -384($fp)	# fill _tmp130 to $t0 from $fp-384
	  lw $t2, 0($t0) 	# load with offset
	  sw $t2, -388($fp)	# spill _tmp131 from $t2 to $fp-388
	# _tmp132 = 0
	  li $t2, 0		# load constant value 0 into $t2
	  sw $t2, -392($fp)	# spill _tmp132 from $t2 to $fp-392
	# _tmp133 = *(_tmp131)
	  lw $t0, -388($fp)	# fill _tmp131 to $t0 from $fp-388
	  lw $t2, 0($t0) 	# load with offset
	  sw $t2, -396($fp)	# spill _tmp133 from $t2 to $fp-396
	# _tmp134 = j < _tmp132
	  lw $t0, -12($fp)	# fill j to $t0 from $fp-12
	  lw $t1, -392($fp)	# fill _tmp132 to $t1 from $fp-392
	  slt $t2, $t0, $t1	
	  sw $t2, -400($fp)	# spill _tmp134 from $t2 to $fp-400
	# _tmp135 = _tmp133 < j
	  lw $t0, -396($fp)	# fill _tmp133 to $t0 from $fp-396
	  lw $t1, -12($fp)	# fill j to $t1 from $fp-12
	  slt $t2, $t0, $t1	
	  sw $t2, -404($fp)	# spill _tmp135 from $t2 to $fp-404
	# _tmp136 = _tmp133 == j
	  lw $t0, -396($fp)	# fill _tmp133 to $t0 from $fp-396
	  lw $t1, -12($fp)	# fill j to $t1 from $fp-12
	  seq $t2, $t0, $t1	
	  sw $t2, -408($fp)	# spill _tmp136 from $t2 to $fp-408
	# _tmp137 = _tmp135 || _tmp136
	  lw $t0, -404($fp)	# fill _tmp135 to $t0 from $fp-404
	  lw $t1, -408($fp)	# fill _tmp136 to $t1 from $fp-408
	  or $t2, $t0, $t1	
	  sw $t2, -412($fp)	# spill _tmp137 from $t2 to $fp-412
	# _tmp138 = _tmp137 || _tmp134
	  lw $t0, -412($fp)	# fill _tmp137 to $t0 from $fp-412
	  lw $t1, -400($fp)	# fill _tmp134 to $t1 from $fp-400
	  or $t2, $t0, $t1	
	  sw $t2, -416($fp)	# spill _tmp138 from $t2 to $fp-416
	# IfZ _tmp138 Goto _L26
	  lw $t0, -416($fp)	# fill _tmp138 to $t0 from $fp-416
	  beqz $t0, _L26	# branch if _tmp138 is zero 
	# _tmp139 = "Decaf runtime error: Array subscript out of bound..."
	  .data			# create string constant marked with label
	  _string10: .asciiz "Decaf runtime error: Array subscript out of bounds\n"
	  .text
	  la $t2, _string10	# load label
	  sw $t2, -420($fp)	# spill _tmp139 from $t2 to $fp-420
	# PushParam _tmp139
	  subu $sp, $sp, 4	# decrement sp to make space for param
	  lw $t0, -420($fp)	# fill _tmp139 to $t0 from $fp-420
	  sw $t0, 4($sp)	# copy param value to stack
	# LCall _PrintString
	  jal _PrintString   	# jump to function
	# PopParams 4
	  add $sp, $sp, 4	# pop params off stack
	# LCall _Halt
	  jal _Halt          	# jump to function
  _L26:
	# _tmp140 = 4
	  li $t2, 4		# load constant value 4 into $t2
	  sw $t2, -424($fp)	# spill _tmp140 from $t2 to $fp-424
	# _tmp141 = j * _tmp140
	  lw $t0, -12($fp)	# fill j to $t0 from $fp-12
	  lw $t1, -424($fp)	# fill _tmp140 to $t1 from $fp-424
	  mul $t2, $t0, $t1	
	  sw $t2, -428($fp)	# spill _tmp141 from $t2 to $fp-428
	# _tmp142 = _tmp141 + _tmp140
	  lw $t0, -428($fp)	# fill _tmp141 to $t0 from $fp-428
	  lw $t1, -424($fp)	# fill _tmp140 to $t1 from $fp-424
	  add $t2, $t0, $t1	
	  sw $t2, -432($fp)	# spill _tmp142 from $t2 to $fp-432
	# _tmp143 = _tmp131 + _tmp142
	  lw $t0, -388($fp)	# fill _tmp131 to $t0 from $fp-388
	  lw $t1, -432($fp)	# fill _tmp142 to $t1 from $fp-432
	  add $t2, $t0, $t1	
	  sw $t2, -436($fp)	# spill _tmp143 from $t2 to $fp-436
	# _tmp144 = *(_tmp143)
	  lw $t0, -436($fp)	# fill _tmp143 to $t0 from $fp-436
	  lw $t2, 0($t0) 	# load with offset
	  sw $t2, -440($fp)	# spill _tmp144 from $t2 to $fp-440
	# PushParam _tmp144
	  subu $sp, $sp, 4	# decrement sp to make space for param
	  lw $t0, -440($fp)	# fill _tmp144 to $t0 from $fp-440
	  sw $t0, 4($sp)	# copy param value to stack
	# _tmp145 = *(_tmp144)
	  lw $t0, -440($fp)	# fill _tmp144 to $t0 from $fp-440
	  lw $t2, 0($t0) 	# load with offset
	  sw $t2, -444($fp)	# spill _tmp145 from $t2 to $fp-444
	# _tmp146 = *(_tmp145)
	  lw $t0, -444($fp)	# fill _tmp145 to $t0 from $fp-444
	  lw $t2, 0($t0) 	# load with offset
	  sw $t2, -448($fp)	# spill _tmp146 from $t2 to $fp-448
	# ACall _tmp146
	  lw $t0, -448($fp)	# fill _tmp146 to $t0 from $fp-448
	  jalr $t0            	# jump to function
	# PopParams 4
	  add $sp, $sp, 4	# pop params off stack
	# _tmp147 = 1
	  li $t2, 1		# load constant value 1 into $t2
	  sw $t2, -452($fp)	# spill _tmp147 from $t2 to $fp-452
	# _tmp148 = j + _tmp147
	  lw $t0, -12($fp)	# fill j to $t0 from $fp-12
	  lw $t1, -452($fp)	# fill _tmp147 to $t1 from $fp-452
	  add $t2, $t0, $t1	
	  sw $t2, -456($fp)	# spill _tmp148 from $t2 to $fp-456
	# j = _tmp148
	  lw $t2, -456($fp)	# fill _tmp148 to $t2 from $fp-456
	  sw $t2, -12($fp)	# spill j from $t2 to $fp-12
	# Goto _L21
	  b _L21		# unconditional branch
  _L22:
	# _tmp149 = 1
	  li $t2, 1		# load constant value 1 into $t2
	  sw $t2, -460($fp)	# spill _tmp149 from $t2 to $fp-460
	# _tmp150 = i + _tmp149
	  lw $t0, -8($fp)	# fill i to $t0 from $fp-8
	  lw $t1, -460($fp)	# fill _tmp149 to $t1 from $fp-460
	  add $t2, $t0, $t1	
	  sw $t2, -464($fp)	# spill _tmp150 from $t2 to $fp-464
	# i = _tmp150
	  lw $t2, -464($fp)	# fill _tmp150 to $t2 from $fp-464
	  sw $t2, -8($fp)	# spill i from $t2 to $fp-8
	# Goto _L19
	  b _L19		# unconditional branch
  _L20:
	# PushParam this
	  subu $sp, $sp, 4	# decrement sp to make space for param
	  lw $t0, 4($fp)	# fill this to $t0 from $fp+4
	  sw $t0, 4($sp)	# copy param value to stack
	# _tmp151 = *(this)
	  lw $t0, 4($fp)	# fill this to $t0 from $fp+4
	  lw $t2, 0($t0) 	# load with offset
	  sw $t2, -468($fp)	# spill _tmp151 from $t2 to $fp-468
	# _tmp152 = *(_tmp151 + 12)
	  lw $t0, -468($fp)	# fill _tmp151 to $t0 from $fp-468
	  lw $t2, 12($t0) 	# load with offset
	  sw $t2, -472($fp)	# spill _tmp152 from $t2 to $fp-472
	# ACall _tmp152
	  lw $t0, -472($fp)	# fill _tmp152 to $t0 from $fp-472
	  jalr $t0            	# jump to function
	# PopParams 4
	  add $sp, $sp, 4	# pop params off stack
	# EndFunc
	# (below handles reaching end of fn body with no explicit return)
	  move $sp, $fp		# pop callee frame off stack
	  lw $ra, -4($fp)	# restore saved ra
	  lw $fp, 0($fp)	# restore saved fp
	  jr $ra		# return from function
  Field.____GetWidth:
	# BeginFunc 4
	  subu $sp, $sp, 8	# decrement sp to make space to save ra, fp
	  sw $fp, 8($sp)	# save fp
	  sw $ra, 4($sp)	# save ra
	  addiu $fp, $sp, 8	# set up new fp
	  subu $sp, $sp, 4	# decrement sp to make space for locals/temps
	# _tmp153 = *(this + 8)
	  lw $t0, 4($fp)	# fill this to $t0 from $fp+4
	  lw $t2, 8($t0) 	# load with offset
	  sw $t2, -8($fp)	# spill _tmp153 from $t2 to $fp-8
	# Return _tmp153
	  lw $t2, -8($fp)	# fill _tmp153 to $t2 from $fp-8
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
  Field.____GetHeight:
	# BeginFunc 4
	  subu $sp, $sp, 8	# decrement sp to make space to save ra, fp
	  sw $fp, 8($sp)	# save fp
	  sw $ra, 4($sp)	# save ra
	  addiu $fp, $sp, 8	# set up new fp
	  subu $sp, $sp, 4	# decrement sp to make space for locals/temps
	# _tmp154 = *(this + 4)
	  lw $t0, 4($fp)	# fill this to $t0 from $fp+4
	  lw $t2, 4($t0) 	# load with offset
	  sw $t2, -8($fp)	# spill _tmp154 from $t2 to $fp-8
	# Return _tmp154
	  lw $t2, -8($fp)	# fill _tmp154 to $t2 from $fp-8
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
  Field.____PlantMines:
	# BeginFunc 80
	  subu $sp, $sp, 8	# decrement sp to make space to save ra, fp
	  sw $fp, 8($sp)	# save fp
	  sw $ra, 4($sp)	# save ra
	  addiu $fp, $sp, 8	# set up new fp
	  subu $sp, $sp, 80	# decrement sp to make space for locals/temps
	# _tmp155 = 0
	  li $t2, 0		# load constant value 0 into $t2
	  sw $t2, -16($fp)	# spill _tmp155 from $t2 to $fp-16
	# i = _tmp155
	  lw $t2, -16($fp)	# fill _tmp155 to $t2 from $fp-16
	  sw $t2, -8($fp)	# spill i from $t2 to $fp-8
  _L27:
	# _tmp156 = *(this + 8)
	  lw $t0, 4($fp)	# fill this to $t0 from $fp+4
	  lw $t2, 8($t0) 	# load with offset
	  sw $t2, -20($fp)	# spill _tmp156 from $t2 to $fp-20
	# _tmp157 = i < _tmp156
	  lw $t0, -8($fp)	# fill i to $t0 from $fp-8
	  lw $t1, -20($fp)	# fill _tmp156 to $t1 from $fp-20
	  slt $t2, $t0, $t1	
	  sw $t2, -24($fp)	# spill _tmp157 from $t2 to $fp-24
	# IfZ _tmp157 Goto _L28
	  lw $t0, -24($fp)	# fill _tmp157 to $t0 from $fp-24
	  beqz $t0, _L28	# branch if _tmp157 is zero 
	# _tmp158 = 0
	  li $t2, 0		# load constant value 0 into $t2
	  sw $t2, -28($fp)	# spill _tmp158 from $t2 to $fp-28
	# j = _tmp158
	  lw $t2, -28($fp)	# fill _tmp158 to $t2 from $fp-28
	  sw $t2, -12($fp)	# spill j from $t2 to $fp-12
  _L29:
	# _tmp159 = *(this + 4)
	  lw $t0, 4($fp)	# fill this to $t0 from $fp+4
	  lw $t2, 4($t0) 	# load with offset
	  sw $t2, -32($fp)	# spill _tmp159 from $t2 to $fp-32
	# _tmp160 = j < _tmp159
	  lw $t0, -12($fp)	# fill j to $t0 from $fp-12
	  lw $t1, -32($fp)	# fill _tmp159 to $t1 from $fp-32
	  slt $t2, $t0, $t1	
	  sw $t2, -36($fp)	# spill _tmp160 from $t2 to $fp-36
	# IfZ _tmp160 Goto _L30
	  lw $t0, -36($fp)	# fill _tmp160 to $t0 from $fp-36
	  beqz $t0, _L30	# branch if _tmp160 is zero 
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
	# _tmp161 = *(this)
	  lw $t0, 4($fp)	# fill this to $t0 from $fp+4
	  lw $t2, 0($t0) 	# load with offset
	  sw $t2, -40($fp)	# spill _tmp161 from $t2 to $fp-40
	# _tmp162 = *(_tmp161 + 16)
	  lw $t0, -40($fp)	# fill _tmp161 to $t0 from $fp-40
	  lw $t2, 16($t0) 	# load with offset
	  sw $t2, -44($fp)	# spill _tmp162 from $t2 to $fp-44
	# ACall _tmp162
	  lw $t0, -44($fp)	# fill _tmp162 to $t0 from $fp-44
	  jalr $t0            	# jump to function
	# PopParams 12
	  add $sp, $sp, 12	# pop params off stack
	# _tmp163 = 1
	  li $t2, 1		# load constant value 1 into $t2
	  sw $t2, -48($fp)	# spill _tmp163 from $t2 to $fp-48
	# _tmp164 = j + _tmp163
	  lw $t0, -12($fp)	# fill j to $t0 from $fp-12
	  lw $t1, -48($fp)	# fill _tmp163 to $t1 from $fp-48
	  add $t2, $t0, $t1	
	  sw $t2, -52($fp)	# spill _tmp164 from $t2 to $fp-52
	# j = _tmp164
	  lw $t2, -52($fp)	# fill _tmp164 to $t2 from $fp-52
	  sw $t2, -12($fp)	# spill j from $t2 to $fp-12
	# Goto _L29
	  b _L29		# unconditional branch
  _L30:
	# _tmp165 = 1
	  li $t2, 1		# load constant value 1 into $t2
	  sw $t2, -56($fp)	# spill _tmp165 from $t2 to $fp-56
	# _tmp166 = i + _tmp165
	  lw $t0, -8($fp)	# fill i to $t0 from $fp-8
	  lw $t1, -56($fp)	# fill _tmp165 to $t1 from $fp-56
	  add $t2, $t0, $t1	
	  sw $t2, -60($fp)	# spill _tmp166 from $t2 to $fp-60
	# i = _tmp166
	  lw $t2, -60($fp)	# fill _tmp166 to $t2 from $fp-60
	  sw $t2, -8($fp)	# spill i from $t2 to $fp-8
	# Goto _L27
	  b _L27		# unconditional branch
  _L28:
	# EndFunc
	# (below handles reaching end of fn body with no explicit return)
	  move $sp, $fp		# pop callee frame off stack
	  lw $ra, -4($fp)	# restore saved ra
	  lw $fp, 0($fp)	# restore saved fp
	  jr $ra		# return from function
  Field.____PlantOneMine:
	# BeginFunc 600
	  subu $sp, $sp, 8	# decrement sp to make space to save ra, fp
	  sw $fp, 8($sp)	# save fp
	  sw $ra, 4($sp)	# save ra
	  addiu $fp, $sp, 8	# set up new fp
	  subu $sp, $sp, 600	# decrement sp to make space for locals/temps
	# _tmp167 = 100
	  li $t2, 100		# load constant value 100 into $t2
	  sw $t2, -20($fp)	# spill _tmp167 from $t2 to $fp-20
	# PushParam _tmp167
	  subu $sp, $sp, 4	# decrement sp to make space for param
	  lw $t0, -20($fp)	# fill _tmp167 to $t0 from $fp-20
	  sw $t0, 4($sp)	# copy param value to stack
	# PushParam gRnd
	  subu $sp, $sp, 4	# decrement sp to make space for param
	  lw $t0, 4($gp)	# fill gRnd to $t0 from $gp+4
	  sw $t0, 4($sp)	# copy param value to stack
	# _tmp168 = *(gRnd)
	  lw $t0, 4($gp)	# fill gRnd to $t0 from $gp+4
	  lw $t2, 0($t0) 	# load with offset
	  sw $t2, -24($fp)	# spill _tmp168 from $t2 to $fp-24
	# _tmp169 = *(_tmp168 + 8)
	  lw $t0, -24($fp)	# fill _tmp168 to $t0 from $fp-24
	  lw $t2, 8($t0) 	# load with offset
	  sw $t2, -28($fp)	# spill _tmp169 from $t2 to $fp-28
	# _tmp170 = ACall _tmp169
	  lw $t0, -28($fp)	# fill _tmp169 to $t0 from $fp-28
	  jalr $t0            	# jump to function
	  move $t2, $v0		# copy function return value from $v0
	  sw $t2, -32($fp)	# spill _tmp170 from $t2 to $fp-32
	# PopParams 8
	  add $sp, $sp, 8	# pop params off stack
	# rand = _tmp170
	  lw $t2, -32($fp)	# fill _tmp170 to $t2 from $fp-32
	  sw $t2, -16($fp)	# spill rand from $t2 to $fp-16
	# _tmp171 = rand < probOfMine
	  lw $t0, -16($fp)	# fill rand to $t0 from $fp-16
	  lw $t1, 0($gp)	# fill probOfMine to $t1 from $gp+0
	  slt $t2, $t0, $t1	
	  sw $t2, -36($fp)	# spill _tmp171 from $t2 to $fp-36
	# IfZ _tmp171 Goto _L31
	  lw $t0, -36($fp)	# fill _tmp171 to $t0 from $fp-36
	  beqz $t0, _L31	# branch if _tmp171 is zero 
	# _tmp172 = 1
	  li $t2, 1		# load constant value 1 into $t2
	  sw $t2, -40($fp)	# spill _tmp172 from $t2 to $fp-40
	# PushParam _tmp172
	  subu $sp, $sp, 4	# decrement sp to make space for param
	  lw $t0, -40($fp)	# fill _tmp172 to $t0 from $fp-40
	  sw $t0, 4($sp)	# copy param value to stack
	# _tmp173 = *(this + 12)
	  lw $t0, 4($fp)	# fill this to $t0 from $fp+4
	  lw $t2, 12($t0) 	# load with offset
	  sw $t2, -44($fp)	# spill _tmp173 from $t2 to $fp-44
	# _tmp174 = 0
	  li $t2, 0		# load constant value 0 into $t2
	  sw $t2, -48($fp)	# spill _tmp174 from $t2 to $fp-48
	# _tmp175 = *(_tmp173)
	  lw $t0, -44($fp)	# fill _tmp173 to $t0 from $fp-44
	  lw $t2, 0($t0) 	# load with offset
	  sw $t2, -52($fp)	# spill _tmp175 from $t2 to $fp-52
	# _tmp176 = i < _tmp174
	  lw $t0, 8($fp)	# fill i to $t0 from $fp+8
	  lw $t1, -48($fp)	# fill _tmp174 to $t1 from $fp-48
	  slt $t2, $t0, $t1	
	  sw $t2, -56($fp)	# spill _tmp176 from $t2 to $fp-56
	# _tmp177 = _tmp175 < i
	  lw $t0, -52($fp)	# fill _tmp175 to $t0 from $fp-52
	  lw $t1, 8($fp)	# fill i to $t1 from $fp+8
	  slt $t2, $t0, $t1	
	  sw $t2, -60($fp)	# spill _tmp177 from $t2 to $fp-60
	# _tmp178 = _tmp175 == i
	  lw $t0, -52($fp)	# fill _tmp175 to $t0 from $fp-52
	  lw $t1, 8($fp)	# fill i to $t1 from $fp+8
	  seq $t2, $t0, $t1	
	  sw $t2, -64($fp)	# spill _tmp178 from $t2 to $fp-64
	# _tmp179 = _tmp177 || _tmp178
	  lw $t0, -60($fp)	# fill _tmp177 to $t0 from $fp-60
	  lw $t1, -64($fp)	# fill _tmp178 to $t1 from $fp-64
	  or $t2, $t0, $t1	
	  sw $t2, -68($fp)	# spill _tmp179 from $t2 to $fp-68
	# _tmp180 = _tmp179 || _tmp176
	  lw $t0, -68($fp)	# fill _tmp179 to $t0 from $fp-68
	  lw $t1, -56($fp)	# fill _tmp176 to $t1 from $fp-56
	  or $t2, $t0, $t1	
	  sw $t2, -72($fp)	# spill _tmp180 from $t2 to $fp-72
	# IfZ _tmp180 Goto _L33
	  lw $t0, -72($fp)	# fill _tmp180 to $t0 from $fp-72
	  beqz $t0, _L33	# branch if _tmp180 is zero 
	# _tmp181 = "Decaf runtime error: Array subscript out of bound..."
	  .data			# create string constant marked with label
	  _string11: .asciiz "Decaf runtime error: Array subscript out of bounds\n"
	  .text
	  la $t2, _string11	# load label
	  sw $t2, -76($fp)	# spill _tmp181 from $t2 to $fp-76
	# PushParam _tmp181
	  subu $sp, $sp, 4	# decrement sp to make space for param
	  lw $t0, -76($fp)	# fill _tmp181 to $t0 from $fp-76
	  sw $t0, 4($sp)	# copy param value to stack
	# LCall _PrintString
	  jal _PrintString   	# jump to function
	# PopParams 4
	  add $sp, $sp, 4	# pop params off stack
	# LCall _Halt
	  jal _Halt          	# jump to function
  _L33:
	# _tmp182 = 4
	  li $t2, 4		# load constant value 4 into $t2
	  sw $t2, -80($fp)	# spill _tmp182 from $t2 to $fp-80
	# _tmp183 = i * _tmp182
	  lw $t0, 8($fp)	# fill i to $t0 from $fp+8
	  lw $t1, -80($fp)	# fill _tmp182 to $t1 from $fp-80
	  mul $t2, $t0, $t1	
	  sw $t2, -84($fp)	# spill _tmp183 from $t2 to $fp-84
	# _tmp184 = _tmp183 + _tmp182
	  lw $t0, -84($fp)	# fill _tmp183 to $t0 from $fp-84
	  lw $t1, -80($fp)	# fill _tmp182 to $t1 from $fp-80
	  add $t2, $t0, $t1	
	  sw $t2, -88($fp)	# spill _tmp184 from $t2 to $fp-88
	# _tmp185 = _tmp173 + _tmp184
	  lw $t0, -44($fp)	# fill _tmp173 to $t0 from $fp-44
	  lw $t1, -88($fp)	# fill _tmp184 to $t1 from $fp-88
	  add $t2, $t0, $t1	
	  sw $t2, -92($fp)	# spill _tmp185 from $t2 to $fp-92
	# _tmp186 = *(_tmp185)
	  lw $t0, -92($fp)	# fill _tmp185 to $t0 from $fp-92
	  lw $t2, 0($t0) 	# load with offset
	  sw $t2, -96($fp)	# spill _tmp186 from $t2 to $fp-96
	# _tmp187 = 0
	  li $t2, 0		# load constant value 0 into $t2
	  sw $t2, -100($fp)	# spill _tmp187 from $t2 to $fp-100
	# _tmp188 = *(_tmp186)
	  lw $t0, -96($fp)	# fill _tmp186 to $t0 from $fp-96
	  lw $t2, 0($t0) 	# load with offset
	  sw $t2, -104($fp)	# spill _tmp188 from $t2 to $fp-104
	# _tmp189 = j < _tmp187
	  lw $t0, 12($fp)	# fill j to $t0 from $fp+12
	  lw $t1, -100($fp)	# fill _tmp187 to $t1 from $fp-100
	  slt $t2, $t0, $t1	
	  sw $t2, -108($fp)	# spill _tmp189 from $t2 to $fp-108
	# _tmp190 = _tmp188 < j
	  lw $t0, -104($fp)	# fill _tmp188 to $t0 from $fp-104
	  lw $t1, 12($fp)	# fill j to $t1 from $fp+12
	  slt $t2, $t0, $t1	
	  sw $t2, -112($fp)	# spill _tmp190 from $t2 to $fp-112
	# _tmp191 = _tmp188 == j
	  lw $t0, -104($fp)	# fill _tmp188 to $t0 from $fp-104
	  lw $t1, 12($fp)	# fill j to $t1 from $fp+12
	  seq $t2, $t0, $t1	
	  sw $t2, -116($fp)	# spill _tmp191 from $t2 to $fp-116
	# _tmp192 = _tmp190 || _tmp191
	  lw $t0, -112($fp)	# fill _tmp190 to $t0 from $fp-112
	  lw $t1, -116($fp)	# fill _tmp191 to $t1 from $fp-116
	  or $t2, $t0, $t1	
	  sw $t2, -120($fp)	# spill _tmp192 from $t2 to $fp-120
	# _tmp193 = _tmp192 || _tmp189
	  lw $t0, -120($fp)	# fill _tmp192 to $t0 from $fp-120
	  lw $t1, -108($fp)	# fill _tmp189 to $t1 from $fp-108
	  or $t2, $t0, $t1	
	  sw $t2, -124($fp)	# spill _tmp193 from $t2 to $fp-124
	# IfZ _tmp193 Goto _L34
	  lw $t0, -124($fp)	# fill _tmp193 to $t0 from $fp-124
	  beqz $t0, _L34	# branch if _tmp193 is zero 
	# _tmp194 = "Decaf runtime error: Array subscript out of bound..."
	  .data			# create string constant marked with label
	  _string12: .asciiz "Decaf runtime error: Array subscript out of bounds\n"
	  .text
	  la $t2, _string12	# load label
	  sw $t2, -128($fp)	# spill _tmp194 from $t2 to $fp-128
	# PushParam _tmp194
	  subu $sp, $sp, 4	# decrement sp to make space for param
	  lw $t0, -128($fp)	# fill _tmp194 to $t0 from $fp-128
	  sw $t0, 4($sp)	# copy param value to stack
	# LCall _PrintString
	  jal _PrintString   	# jump to function
	# PopParams 4
	  add $sp, $sp, 4	# pop params off stack
	# LCall _Halt
	  jal _Halt          	# jump to function
  _L34:
	# _tmp195 = 4
	  li $t2, 4		# load constant value 4 into $t2
	  sw $t2, -132($fp)	# spill _tmp195 from $t2 to $fp-132
	# _tmp196 = j * _tmp195
	  lw $t0, 12($fp)	# fill j to $t0 from $fp+12
	  lw $t1, -132($fp)	# fill _tmp195 to $t1 from $fp-132
	  mul $t2, $t0, $t1	
	  sw $t2, -136($fp)	# spill _tmp196 from $t2 to $fp-136
	# _tmp197 = _tmp196 + _tmp195
	  lw $t0, -136($fp)	# fill _tmp196 to $t0 from $fp-136
	  lw $t1, -132($fp)	# fill _tmp195 to $t1 from $fp-132
	  add $t2, $t0, $t1	
	  sw $t2, -140($fp)	# spill _tmp197 from $t2 to $fp-140
	# _tmp198 = _tmp186 + _tmp197
	  lw $t0, -96($fp)	# fill _tmp186 to $t0 from $fp-96
	  lw $t1, -140($fp)	# fill _tmp197 to $t1 from $fp-140
	  add $t2, $t0, $t1	
	  sw $t2, -144($fp)	# spill _tmp198 from $t2 to $fp-144
	# _tmp199 = *(_tmp198)
	  lw $t0, -144($fp)	# fill _tmp198 to $t0 from $fp-144
	  lw $t2, 0($t0) 	# load with offset
	  sw $t2, -148($fp)	# spill _tmp199 from $t2 to $fp-148
	# PushParam _tmp199
	  subu $sp, $sp, 4	# decrement sp to make space for param
	  lw $t0, -148($fp)	# fill _tmp199 to $t0 from $fp-148
	  sw $t0, 4($sp)	# copy param value to stack
	# _tmp200 = *(_tmp199)
	  lw $t0, -148($fp)	# fill _tmp199 to $t0 from $fp-148
	  lw $t2, 0($t0) 	# load with offset
	  sw $t2, -152($fp)	# spill _tmp200 from $t2 to $fp-152
	# _tmp201 = *(_tmp200 + 12)
	  lw $t0, -152($fp)	# fill _tmp200 to $t0 from $fp-152
	  lw $t2, 12($t0) 	# load with offset
	  sw $t2, -156($fp)	# spill _tmp201 from $t2 to $fp-156
	# ACall _tmp201
	  lw $t0, -156($fp)	# fill _tmp201 to $t0 from $fp-156
	  jalr $t0            	# jump to function
	# PopParams 8
	  add $sp, $sp, 8	# pop params off stack
	# _tmp202 = *(this + 20)
	  lw $t0, 4($fp)	# fill this to $t0 from $fp+4
	  lw $t2, 20($t0) 	# load with offset
	  sw $t2, -160($fp)	# spill _tmp202 from $t2 to $fp-160
	# _tmp203 = 1
	  li $t2, 1		# load constant value 1 into $t2
	  sw $t2, -164($fp)	# spill _tmp203 from $t2 to $fp-164
	# _tmp204 = _tmp202 - _tmp203
	  lw $t0, -160($fp)	# fill _tmp202 to $t0 from $fp-160
	  lw $t1, -164($fp)	# fill _tmp203 to $t1 from $fp-164
	  sub $t2, $t0, $t1	
	  sw $t2, -168($fp)	# spill _tmp204 from $t2 to $fp-168
	# *(this + 20) = _tmp204
	  lw $t0, -168($fp)	# fill _tmp204 to $t0 from $fp-168
	  lw $t2, 4($fp)	# fill this to $t2 from $fp+4
	  sw $t0, 20($t2) 	# store with offset
	# _tmp205 = 1
	  li $t2, 1		# load constant value 1 into $t2
	  sw $t2, -172($fp)	# spill _tmp205 from $t2 to $fp-172
	# _tmp206 = i - _tmp205
	  lw $t0, 8($fp)	# fill i to $t0 from $fp+8
	  lw $t1, -172($fp)	# fill _tmp205 to $t1 from $fp-172
	  sub $t2, $t0, $t1	
	  sw $t2, -176($fp)	# spill _tmp206 from $t2 to $fp-176
	# x = _tmp206
	  lw $t2, -176($fp)	# fill _tmp206 to $t2 from $fp-176
	  sw $t2, -8($fp)	# spill x from $t2 to $fp-8
  _L35:
	# _tmp207 = 1
	  li $t2, 1		# load constant value 1 into $t2
	  sw $t2, -180($fp)	# spill _tmp207 from $t2 to $fp-180
	# _tmp208 = i + _tmp207
	  lw $t0, 8($fp)	# fill i to $t0 from $fp+8
	  lw $t1, -180($fp)	# fill _tmp207 to $t1 from $fp-180
	  add $t2, $t0, $t1	
	  sw $t2, -184($fp)	# spill _tmp208 from $t2 to $fp-184
	# _tmp209 = x < _tmp208
	  lw $t0, -8($fp)	# fill x to $t0 from $fp-8
	  lw $t1, -184($fp)	# fill _tmp208 to $t1 from $fp-184
	  slt $t2, $t0, $t1	
	  sw $t2, -188($fp)	# spill _tmp209 from $t2 to $fp-188
	# _tmp210 = x == _tmp208
	  lw $t0, -8($fp)	# fill x to $t0 from $fp-8
	  lw $t1, -184($fp)	# fill _tmp208 to $t1 from $fp-184
	  seq $t2, $t0, $t1	
	  sw $t2, -192($fp)	# spill _tmp210 from $t2 to $fp-192
	# _tmp211 = _tmp209 || _tmp210
	  lw $t0, -188($fp)	# fill _tmp209 to $t0 from $fp-188
	  lw $t1, -192($fp)	# fill _tmp210 to $t1 from $fp-192
	  or $t2, $t0, $t1	
	  sw $t2, -196($fp)	# spill _tmp211 from $t2 to $fp-196
	# IfZ _tmp211 Goto _L36
	  lw $t0, -196($fp)	# fill _tmp211 to $t0 from $fp-196
	  beqz $t0, _L36	# branch if _tmp211 is zero 
	# _tmp212 = 1
	  li $t2, 1		# load constant value 1 into $t2
	  sw $t2, -200($fp)	# spill _tmp212 from $t2 to $fp-200
	# _tmp213 = j - _tmp212
	  lw $t0, 12($fp)	# fill j to $t0 from $fp+12
	  lw $t1, -200($fp)	# fill _tmp212 to $t1 from $fp-200
	  sub $t2, $t0, $t1	
	  sw $t2, -204($fp)	# spill _tmp213 from $t2 to $fp-204
	# y = _tmp213
	  lw $t2, -204($fp)	# fill _tmp213 to $t2 from $fp-204
	  sw $t2, -12($fp)	# spill y from $t2 to $fp-12
  _L37:
	# _tmp214 = 1
	  li $t2, 1		# load constant value 1 into $t2
	  sw $t2, -208($fp)	# spill _tmp214 from $t2 to $fp-208
	# _tmp215 = j + _tmp214
	  lw $t0, 12($fp)	# fill j to $t0 from $fp+12
	  lw $t1, -208($fp)	# fill _tmp214 to $t1 from $fp-208
	  add $t2, $t0, $t1	
	  sw $t2, -212($fp)	# spill _tmp215 from $t2 to $fp-212
	# _tmp216 = y < _tmp215
	  lw $t0, -12($fp)	# fill y to $t0 from $fp-12
	  lw $t1, -212($fp)	# fill _tmp215 to $t1 from $fp-212
	  slt $t2, $t0, $t1	
	  sw $t2, -216($fp)	# spill _tmp216 from $t2 to $fp-216
	# _tmp217 = y == _tmp215
	  lw $t0, -12($fp)	# fill y to $t0 from $fp-12
	  lw $t1, -212($fp)	# fill _tmp215 to $t1 from $fp-212
	  seq $t2, $t0, $t1	
	  sw $t2, -220($fp)	# spill _tmp217 from $t2 to $fp-220
	# _tmp218 = _tmp216 || _tmp217
	  lw $t0, -216($fp)	# fill _tmp216 to $t0 from $fp-216
	  lw $t1, -220($fp)	# fill _tmp217 to $t1 from $fp-220
	  or $t2, $t0, $t1	
	  sw $t2, -224($fp)	# spill _tmp218 from $t2 to $fp-224
	# IfZ _tmp218 Goto _L38
	  lw $t0, -224($fp)	# fill _tmp218 to $t0 from $fp-224
	  beqz $t0, _L38	# branch if _tmp218 is zero 
	# _tmp219 = 0
	  li $t2, 0		# load constant value 0 into $t2
	  sw $t2, -228($fp)	# spill _tmp219 from $t2 to $fp-228
	# _tmp220 = _tmp219 < x
	  lw $t0, -228($fp)	# fill _tmp219 to $t0 from $fp-228
	  lw $t1, -8($fp)	# fill x to $t1 from $fp-8
	  slt $t2, $t0, $t1	
	  sw $t2, -232($fp)	# spill _tmp220 from $t2 to $fp-232
	# _tmp221 = _tmp219 == x
	  lw $t0, -228($fp)	# fill _tmp219 to $t0 from $fp-228
	  lw $t1, -8($fp)	# fill x to $t1 from $fp-8
	  seq $t2, $t0, $t1	
	  sw $t2, -236($fp)	# spill _tmp221 from $t2 to $fp-236
	# _tmp222 = _tmp220 || _tmp221
	  lw $t0, -232($fp)	# fill _tmp220 to $t0 from $fp-232
	  lw $t1, -236($fp)	# fill _tmp221 to $t1 from $fp-236
	  or $t2, $t0, $t1	
	  sw $t2, -240($fp)	# spill _tmp222 from $t2 to $fp-240
	# _tmp223 = *(this + 8)
	  lw $t0, 4($fp)	# fill this to $t0 from $fp+4
	  lw $t2, 8($t0) 	# load with offset
	  sw $t2, -244($fp)	# spill _tmp223 from $t2 to $fp-244
	# _tmp224 = x < _tmp223
	  lw $t0, -8($fp)	# fill x to $t0 from $fp-8
	  lw $t1, -244($fp)	# fill _tmp223 to $t1 from $fp-244
	  slt $t2, $t0, $t1	
	  sw $t2, -248($fp)	# spill _tmp224 from $t2 to $fp-248
	# _tmp225 = _tmp222 && _tmp224
	  lw $t0, -240($fp)	# fill _tmp222 to $t0 from $fp-240
	  lw $t1, -248($fp)	# fill _tmp224 to $t1 from $fp-248
	  and $t2, $t0, $t1	
	  sw $t2, -252($fp)	# spill _tmp225 from $t2 to $fp-252
	# _tmp226 = 0
	  li $t2, 0		# load constant value 0 into $t2
	  sw $t2, -256($fp)	# spill _tmp226 from $t2 to $fp-256
	# _tmp227 = _tmp226 < y
	  lw $t0, -256($fp)	# fill _tmp226 to $t0 from $fp-256
	  lw $t1, -12($fp)	# fill y to $t1 from $fp-12
	  slt $t2, $t0, $t1	
	  sw $t2, -260($fp)	# spill _tmp227 from $t2 to $fp-260
	# _tmp228 = _tmp226 == y
	  lw $t0, -256($fp)	# fill _tmp226 to $t0 from $fp-256
	  lw $t1, -12($fp)	# fill y to $t1 from $fp-12
	  seq $t2, $t0, $t1	
	  sw $t2, -264($fp)	# spill _tmp228 from $t2 to $fp-264
	# _tmp229 = _tmp227 || _tmp228
	  lw $t0, -260($fp)	# fill _tmp227 to $t0 from $fp-260
	  lw $t1, -264($fp)	# fill _tmp228 to $t1 from $fp-264
	  or $t2, $t0, $t1	
	  sw $t2, -268($fp)	# spill _tmp229 from $t2 to $fp-268
	# _tmp230 = _tmp225 && _tmp229
	  lw $t0, -252($fp)	# fill _tmp225 to $t0 from $fp-252
	  lw $t1, -268($fp)	# fill _tmp229 to $t1 from $fp-268
	  and $t2, $t0, $t1	
	  sw $t2, -272($fp)	# spill _tmp230 from $t2 to $fp-272
	# _tmp231 = *(this + 4)
	  lw $t0, 4($fp)	# fill this to $t0 from $fp+4
	  lw $t2, 4($t0) 	# load with offset
	  sw $t2, -276($fp)	# spill _tmp231 from $t2 to $fp-276
	# _tmp232 = y < _tmp231
	  lw $t0, -12($fp)	# fill y to $t0 from $fp-12
	  lw $t1, -276($fp)	# fill _tmp231 to $t1 from $fp-276
	  slt $t2, $t0, $t1	
	  sw $t2, -280($fp)	# spill _tmp232 from $t2 to $fp-280
	# _tmp233 = _tmp230 && _tmp232
	  lw $t0, -272($fp)	# fill _tmp230 to $t0 from $fp-272
	  lw $t1, -280($fp)	# fill _tmp232 to $t1 from $fp-280
	  and $t2, $t0, $t1	
	  sw $t2, -284($fp)	# spill _tmp233 from $t2 to $fp-284
	# IfZ _tmp233 Goto _L39
	  lw $t0, -284($fp)	# fill _tmp233 to $t0 from $fp-284
	  beqz $t0, _L39	# branch if _tmp233 is zero 
	# _tmp235 = *(this + 12)
	  lw $t0, 4($fp)	# fill this to $t0 from $fp+4
	  lw $t2, 12($t0) 	# load with offset
	  sw $t2, -292($fp)	# spill _tmp235 from $t2 to $fp-292
	# _tmp236 = 0
	  li $t2, 0		# load constant value 0 into $t2
	  sw $t2, -296($fp)	# spill _tmp236 from $t2 to $fp-296
	# _tmp237 = *(_tmp235)
	  lw $t0, -292($fp)	# fill _tmp235 to $t0 from $fp-292
	  lw $t2, 0($t0) 	# load with offset
	  sw $t2, -300($fp)	# spill _tmp237 from $t2 to $fp-300
	# _tmp238 = x < _tmp236
	  lw $t0, -8($fp)	# fill x to $t0 from $fp-8
	  lw $t1, -296($fp)	# fill _tmp236 to $t1 from $fp-296
	  slt $t2, $t0, $t1	
	  sw $t2, -304($fp)	# spill _tmp238 from $t2 to $fp-304
	# _tmp239 = _tmp237 < x
	  lw $t0, -300($fp)	# fill _tmp237 to $t0 from $fp-300
	  lw $t1, -8($fp)	# fill x to $t1 from $fp-8
	  slt $t2, $t0, $t1	
	  sw $t2, -308($fp)	# spill _tmp239 from $t2 to $fp-308
	# _tmp240 = _tmp237 == x
	  lw $t0, -300($fp)	# fill _tmp237 to $t0 from $fp-300
	  lw $t1, -8($fp)	# fill x to $t1 from $fp-8
	  seq $t2, $t0, $t1	
	  sw $t2, -312($fp)	# spill _tmp240 from $t2 to $fp-312
	# _tmp241 = _tmp239 || _tmp240
	  lw $t0, -308($fp)	# fill _tmp239 to $t0 from $fp-308
	  lw $t1, -312($fp)	# fill _tmp240 to $t1 from $fp-312
	  or $t2, $t0, $t1	
	  sw $t2, -316($fp)	# spill _tmp241 from $t2 to $fp-316
	# _tmp242 = _tmp241 || _tmp238
	  lw $t0, -316($fp)	# fill _tmp241 to $t0 from $fp-316
	  lw $t1, -304($fp)	# fill _tmp238 to $t1 from $fp-304
	  or $t2, $t0, $t1	
	  sw $t2, -320($fp)	# spill _tmp242 from $t2 to $fp-320
	# IfZ _tmp242 Goto _L45
	  lw $t0, -320($fp)	# fill _tmp242 to $t0 from $fp-320
	  beqz $t0, _L45	# branch if _tmp242 is zero 
	# _tmp243 = "Decaf runtime error: Array subscript out of bound..."
	  .data			# create string constant marked with label
	  _string13: .asciiz "Decaf runtime error: Array subscript out of bounds\n"
	  .text
	  la $t2, _string13	# load label
	  sw $t2, -324($fp)	# spill _tmp243 from $t2 to $fp-324
	# PushParam _tmp243
	  subu $sp, $sp, 4	# decrement sp to make space for param
	  lw $t0, -324($fp)	# fill _tmp243 to $t0 from $fp-324
	  sw $t0, 4($sp)	# copy param value to stack
	# LCall _PrintString
	  jal _PrintString   	# jump to function
	# PopParams 4
	  add $sp, $sp, 4	# pop params off stack
	# LCall _Halt
	  jal _Halt          	# jump to function
  _L45:
	# _tmp244 = 4
	  li $t2, 4		# load constant value 4 into $t2
	  sw $t2, -328($fp)	# spill _tmp244 from $t2 to $fp-328
	# _tmp245 = x * _tmp244
	  lw $t0, -8($fp)	# fill x to $t0 from $fp-8
	  lw $t1, -328($fp)	# fill _tmp244 to $t1 from $fp-328
	  mul $t2, $t0, $t1	
	  sw $t2, -332($fp)	# spill _tmp245 from $t2 to $fp-332
	# _tmp246 = _tmp245 + _tmp244
	  lw $t0, -332($fp)	# fill _tmp245 to $t0 from $fp-332
	  lw $t1, -328($fp)	# fill _tmp244 to $t1 from $fp-328
	  add $t2, $t0, $t1	
	  sw $t2, -336($fp)	# spill _tmp246 from $t2 to $fp-336
	# _tmp247 = _tmp235 + _tmp246
	  lw $t0, -292($fp)	# fill _tmp235 to $t0 from $fp-292
	  lw $t1, -336($fp)	# fill _tmp246 to $t1 from $fp-336
	  add $t2, $t0, $t1	
	  sw $t2, -340($fp)	# spill _tmp247 from $t2 to $fp-340
	# _tmp248 = *(_tmp247)
	  lw $t0, -340($fp)	# fill _tmp247 to $t0 from $fp-340
	  lw $t2, 0($t0) 	# load with offset
	  sw $t2, -344($fp)	# spill _tmp248 from $t2 to $fp-344
	# _tmp249 = 0
	  li $t2, 0		# load constant value 0 into $t2
	  sw $t2, -348($fp)	# spill _tmp249 from $t2 to $fp-348
	# _tmp250 = *(_tmp248)
	  lw $t0, -344($fp)	# fill _tmp248 to $t0 from $fp-344
	  lw $t2, 0($t0) 	# load with offset
	  sw $t2, -352($fp)	# spill _tmp250 from $t2 to $fp-352
	# _tmp251 = y < _tmp249
	  lw $t0, -12($fp)	# fill y to $t0 from $fp-12
	  lw $t1, -348($fp)	# fill _tmp249 to $t1 from $fp-348
	  slt $t2, $t0, $t1	
	  sw $t2, -356($fp)	# spill _tmp251 from $t2 to $fp-356
	# _tmp252 = _tmp250 < y
	  lw $t0, -352($fp)	# fill _tmp250 to $t0 from $fp-352
	  lw $t1, -12($fp)	# fill y to $t1 from $fp-12
	  slt $t2, $t0, $t1	
	  sw $t2, -360($fp)	# spill _tmp252 from $t2 to $fp-360
	# _tmp253 = _tmp250 == y
	  lw $t0, -352($fp)	# fill _tmp250 to $t0 from $fp-352
	  lw $t1, -12($fp)	# fill y to $t1 from $fp-12
	  seq $t2, $t0, $t1	
	  sw $t2, -364($fp)	# spill _tmp253 from $t2 to $fp-364
	# _tmp254 = _tmp252 || _tmp253
	  lw $t0, -360($fp)	# fill _tmp252 to $t0 from $fp-360
	  lw $t1, -364($fp)	# fill _tmp253 to $t1 from $fp-364
	  or $t2, $t0, $t1	
	  sw $t2, -368($fp)	# spill _tmp254 from $t2 to $fp-368
	# _tmp255 = _tmp254 || _tmp251
	  lw $t0, -368($fp)	# fill _tmp254 to $t0 from $fp-368
	  lw $t1, -356($fp)	# fill _tmp251 to $t1 from $fp-356
	  or $t2, $t0, $t1	
	  sw $t2, -372($fp)	# spill _tmp255 from $t2 to $fp-372
	# IfZ _tmp255 Goto _L46
	  lw $t0, -372($fp)	# fill _tmp255 to $t0 from $fp-372
	  beqz $t0, _L46	# branch if _tmp255 is zero 
	# _tmp256 = "Decaf runtime error: Array subscript out of bound..."
	  .data			# create string constant marked with label
	  _string14: .asciiz "Decaf runtime error: Array subscript out of bounds\n"
	  .text
	  la $t2, _string14	# load label
	  sw $t2, -376($fp)	# spill _tmp256 from $t2 to $fp-376
	# PushParam _tmp256
	  subu $sp, $sp, 4	# decrement sp to make space for param
	  lw $t0, -376($fp)	# fill _tmp256 to $t0 from $fp-376
	  sw $t0, 4($sp)	# copy param value to stack
	# LCall _PrintString
	  jal _PrintString   	# jump to function
	# PopParams 4
	  add $sp, $sp, 4	# pop params off stack
	# LCall _Halt
	  jal _Halt          	# jump to function
  _L46:
	# _tmp257 = 4
	  li $t2, 4		# load constant value 4 into $t2
	  sw $t2, -380($fp)	# spill _tmp257 from $t2 to $fp-380
	# _tmp258 = y * _tmp257
	  lw $t0, -12($fp)	# fill y to $t0 from $fp-12
	  lw $t1, -380($fp)	# fill _tmp257 to $t1 from $fp-380
	  mul $t2, $t0, $t1	
	  sw $t2, -384($fp)	# spill _tmp258 from $t2 to $fp-384
	# _tmp259 = _tmp258 + _tmp257
	  lw $t0, -384($fp)	# fill _tmp258 to $t0 from $fp-384
	  lw $t1, -380($fp)	# fill _tmp257 to $t1 from $fp-380
	  add $t2, $t0, $t1	
	  sw $t2, -388($fp)	# spill _tmp259 from $t2 to $fp-388
	# _tmp260 = _tmp248 + _tmp259
	  lw $t0, -344($fp)	# fill _tmp248 to $t0 from $fp-344
	  lw $t1, -388($fp)	# fill _tmp259 to $t1 from $fp-388
	  add $t2, $t0, $t1	
	  sw $t2, -392($fp)	# spill _tmp260 from $t2 to $fp-392
	# _tmp261 = *(_tmp260)
	  lw $t0, -392($fp)	# fill _tmp260 to $t0 from $fp-392
	  lw $t2, 0($t0) 	# load with offset
	  sw $t2, -396($fp)	# spill _tmp261 from $t2 to $fp-396
	# PushParam _tmp261
	  subu $sp, $sp, 4	# decrement sp to make space for param
	  lw $t0, -396($fp)	# fill _tmp261 to $t0 from $fp-396
	  sw $t0, 4($sp)	# copy param value to stack
	# _tmp262 = *(_tmp261)
	  lw $t0, -396($fp)	# fill _tmp261 to $t0 from $fp-396
	  lw $t2, 0($t0) 	# load with offset
	  sw $t2, -400($fp)	# spill _tmp262 from $t2 to $fp-400
	# _tmp263 = *(_tmp262 + 16)
	  lw $t0, -400($fp)	# fill _tmp262 to $t0 from $fp-400
	  lw $t2, 16($t0) 	# load with offset
	  sw $t2, -404($fp)	# spill _tmp263 from $t2 to $fp-404
	# _tmp264 = ACall _tmp263
	  lw $t0, -404($fp)	# fill _tmp263 to $t0 from $fp-404
	  jalr $t0            	# jump to function
	  move $t2, $v0		# copy function return value from $v0
	  sw $t2, -408($fp)	# spill _tmp264 from $t2 to $fp-408
	# PopParams 4
	  add $sp, $sp, 4	# pop params off stack
	# IfZ _tmp264 Goto _L44
	  lw $t0, -408($fp)	# fill _tmp264 to $t0 from $fp-408
	  beqz $t0, _L44	# branch if _tmp264 is zero 
	# _tmp265 = 0
	  li $t2, 0		# load constant value 0 into $t2
	  sw $t2, -412($fp)	# spill _tmp265 from $t2 to $fp-412
	# _tmp234 = _tmp265
	  lw $t2, -412($fp)	# fill _tmp265 to $t2 from $fp-412
	  sw $t2, -288($fp)	# spill _tmp234 from $t2 to $fp-288
	# Goto _L43
	  b _L43		# unconditional branch
  _L44:
	# _tmp266 = 1
	  li $t2, 1		# load constant value 1 into $t2
	  sw $t2, -416($fp)	# spill _tmp266 from $t2 to $fp-416
	# _tmp234 = _tmp266
	  lw $t2, -416($fp)	# fill _tmp266 to $t2 from $fp-416
	  sw $t2, -288($fp)	# spill _tmp234 from $t2 to $fp-288
  _L43:
	# IfZ _tmp234 Goto _L41
	  lw $t0, -288($fp)	# fill _tmp234 to $t0 from $fp-288
	  beqz $t0, _L41	# branch if _tmp234 is zero 
	# _tmp267 = 1
	  li $t2, 1		# load constant value 1 into $t2
	  sw $t2, -420($fp)	# spill _tmp267 from $t2 to $fp-420
	# PushParam _tmp267
	  subu $sp, $sp, 4	# decrement sp to make space for param
	  lw $t0, -420($fp)	# fill _tmp267 to $t0 from $fp-420
	  sw $t0, 4($sp)	# copy param value to stack
	# _tmp268 = *(this + 12)
	  lw $t0, 4($fp)	# fill this to $t0 from $fp+4
	  lw $t2, 12($t0) 	# load with offset
	  sw $t2, -424($fp)	# spill _tmp268 from $t2 to $fp-424
	# _tmp269 = 0
	  li $t2, 0		# load constant value 0 into $t2
	  sw $t2, -428($fp)	# spill _tmp269 from $t2 to $fp-428
	# _tmp270 = *(_tmp268)
	  lw $t0, -424($fp)	# fill _tmp268 to $t0 from $fp-424
	  lw $t2, 0($t0) 	# load with offset
	  sw $t2, -432($fp)	# spill _tmp270 from $t2 to $fp-432
	# _tmp271 = x < _tmp269
	  lw $t0, -8($fp)	# fill x to $t0 from $fp-8
	  lw $t1, -428($fp)	# fill _tmp269 to $t1 from $fp-428
	  slt $t2, $t0, $t1	
	  sw $t2, -436($fp)	# spill _tmp271 from $t2 to $fp-436
	# _tmp272 = _tmp270 < x
	  lw $t0, -432($fp)	# fill _tmp270 to $t0 from $fp-432
	  lw $t1, -8($fp)	# fill x to $t1 from $fp-8
	  slt $t2, $t0, $t1	
	  sw $t2, -440($fp)	# spill _tmp272 from $t2 to $fp-440
	# _tmp273 = _tmp270 == x
	  lw $t0, -432($fp)	# fill _tmp270 to $t0 from $fp-432
	  lw $t1, -8($fp)	# fill x to $t1 from $fp-8
	  seq $t2, $t0, $t1	
	  sw $t2, -444($fp)	# spill _tmp273 from $t2 to $fp-444
	# _tmp274 = _tmp272 || _tmp273
	  lw $t0, -440($fp)	# fill _tmp272 to $t0 from $fp-440
	  lw $t1, -444($fp)	# fill _tmp273 to $t1 from $fp-444
	  or $t2, $t0, $t1	
	  sw $t2, -448($fp)	# spill _tmp274 from $t2 to $fp-448
	# _tmp275 = _tmp274 || _tmp271
	  lw $t0, -448($fp)	# fill _tmp274 to $t0 from $fp-448
	  lw $t1, -436($fp)	# fill _tmp271 to $t1 from $fp-436
	  or $t2, $t0, $t1	
	  sw $t2, -452($fp)	# spill _tmp275 from $t2 to $fp-452
	# IfZ _tmp275 Goto _L47
	  lw $t0, -452($fp)	# fill _tmp275 to $t0 from $fp-452
	  beqz $t0, _L47	# branch if _tmp275 is zero 
	# _tmp276 = "Decaf runtime error: Array subscript out of bound..."
	  .data			# create string constant marked with label
	  _string15: .asciiz "Decaf runtime error: Array subscript out of bounds\n"
	  .text
	  la $t2, _string15	# load label
	  sw $t2, -456($fp)	# spill _tmp276 from $t2 to $fp-456
	# PushParam _tmp276
	  subu $sp, $sp, 4	# decrement sp to make space for param
	  lw $t0, -456($fp)	# fill _tmp276 to $t0 from $fp-456
	  sw $t0, 4($sp)	# copy param value to stack
	# LCall _PrintString
	  jal _PrintString   	# jump to function
	# PopParams 4
	  add $sp, $sp, 4	# pop params off stack
	# LCall _Halt
	  jal _Halt          	# jump to function
  _L47:
	# _tmp277 = 4
	  li $t2, 4		# load constant value 4 into $t2
	  sw $t2, -460($fp)	# spill _tmp277 from $t2 to $fp-460
	# _tmp278 = x * _tmp277
	  lw $t0, -8($fp)	# fill x to $t0 from $fp-8
	  lw $t1, -460($fp)	# fill _tmp277 to $t1 from $fp-460
	  mul $t2, $t0, $t1	
	  sw $t2, -464($fp)	# spill _tmp278 from $t2 to $fp-464
	# _tmp279 = _tmp278 + _tmp277
	  lw $t0, -464($fp)	# fill _tmp278 to $t0 from $fp-464
	  lw $t1, -460($fp)	# fill _tmp277 to $t1 from $fp-460
	  add $t2, $t0, $t1	
	  sw $t2, -468($fp)	# spill _tmp279 from $t2 to $fp-468
	# _tmp280 = _tmp268 + _tmp279
	  lw $t0, -424($fp)	# fill _tmp268 to $t0 from $fp-424
	  lw $t1, -468($fp)	# fill _tmp279 to $t1 from $fp-468
	  add $t2, $t0, $t1	
	  sw $t2, -472($fp)	# spill _tmp280 from $t2 to $fp-472
	# _tmp281 = *(_tmp280)
	  lw $t0, -472($fp)	# fill _tmp280 to $t0 from $fp-472
	  lw $t2, 0($t0) 	# load with offset
	  sw $t2, -476($fp)	# spill _tmp281 from $t2 to $fp-476
	# _tmp282 = 0
	  li $t2, 0		# load constant value 0 into $t2
	  sw $t2, -480($fp)	# spill _tmp282 from $t2 to $fp-480
	# _tmp283 = *(_tmp281)
	  lw $t0, -476($fp)	# fill _tmp281 to $t0 from $fp-476
	  lw $t2, 0($t0) 	# load with offset
	  sw $t2, -484($fp)	# spill _tmp283 from $t2 to $fp-484
	# _tmp284 = y < _tmp282
	  lw $t0, -12($fp)	# fill y to $t0 from $fp-12
	  lw $t1, -480($fp)	# fill _tmp282 to $t1 from $fp-480
	  slt $t2, $t0, $t1	
	  sw $t2, -488($fp)	# spill _tmp284 from $t2 to $fp-488
	# _tmp285 = _tmp283 < y
	  lw $t0, -484($fp)	# fill _tmp283 to $t0 from $fp-484
	  lw $t1, -12($fp)	# fill y to $t1 from $fp-12
	  slt $t2, $t0, $t1	
	  sw $t2, -492($fp)	# spill _tmp285 from $t2 to $fp-492
	# _tmp286 = _tmp283 == y
	  lw $t0, -484($fp)	# fill _tmp283 to $t0 from $fp-484
	  lw $t1, -12($fp)	# fill y to $t1 from $fp-12
	  seq $t2, $t0, $t1	
	  sw $t2, -496($fp)	# spill _tmp286 from $t2 to $fp-496
	# _tmp287 = _tmp285 || _tmp286
	  lw $t0, -492($fp)	# fill _tmp285 to $t0 from $fp-492
	  lw $t1, -496($fp)	# fill _tmp286 to $t1 from $fp-496
	  or $t2, $t0, $t1	
	  sw $t2, -500($fp)	# spill _tmp287 from $t2 to $fp-500
	# _tmp288 = _tmp287 || _tmp284
	  lw $t0, -500($fp)	# fill _tmp287 to $t0 from $fp-500
	  lw $t1, -488($fp)	# fill _tmp284 to $t1 from $fp-488
	  or $t2, $t0, $t1	
	  sw $t2, -504($fp)	# spill _tmp288 from $t2 to $fp-504
	# IfZ _tmp288 Goto _L48
	  lw $t0, -504($fp)	# fill _tmp288 to $t0 from $fp-504
	  beqz $t0, _L48	# branch if _tmp288 is zero 
	# _tmp289 = "Decaf runtime error: Array subscript out of bound..."
	  .data			# create string constant marked with label
	  _string16: .asciiz "Decaf runtime error: Array subscript out of bounds\n"
	  .text
	  la $t2, _string16	# load label
	  sw $t2, -508($fp)	# spill _tmp289 from $t2 to $fp-508
	# PushParam _tmp289
	  subu $sp, $sp, 4	# decrement sp to make space for param
	  lw $t0, -508($fp)	# fill _tmp289 to $t0 from $fp-508
	  sw $t0, 4($sp)	# copy param value to stack
	# LCall _PrintString
	  jal _PrintString   	# jump to function
	# PopParams 4
	  add $sp, $sp, 4	# pop params off stack
	# LCall _Halt
	  jal _Halt          	# jump to function
  _L48:
	# _tmp290 = 4
	  li $t2, 4		# load constant value 4 into $t2
	  sw $t2, -512($fp)	# spill _tmp290 from $t2 to $fp-512
	# _tmp291 = y * _tmp290
	  lw $t0, -12($fp)	# fill y to $t0 from $fp-12
	  lw $t1, -512($fp)	# fill _tmp290 to $t1 from $fp-512
	  mul $t2, $t0, $t1	
	  sw $t2, -516($fp)	# spill _tmp291 from $t2 to $fp-516
	# _tmp292 = _tmp291 + _tmp290
	  lw $t0, -516($fp)	# fill _tmp291 to $t0 from $fp-516
	  lw $t1, -512($fp)	# fill _tmp290 to $t1 from $fp-512
	  add $t2, $t0, $t1	
	  sw $t2, -520($fp)	# spill _tmp292 from $t2 to $fp-520
	# _tmp293 = _tmp281 + _tmp292
	  lw $t0, -476($fp)	# fill _tmp281 to $t0 from $fp-476
	  lw $t1, -520($fp)	# fill _tmp292 to $t1 from $fp-520
	  add $t2, $t0, $t1	
	  sw $t2, -524($fp)	# spill _tmp293 from $t2 to $fp-524
	# _tmp294 = *(_tmp293)
	  lw $t0, -524($fp)	# fill _tmp293 to $t0 from $fp-524
	  lw $t2, 0($t0) 	# load with offset
	  sw $t2, -528($fp)	# spill _tmp294 from $t2 to $fp-528
	# PushParam _tmp294
	  subu $sp, $sp, 4	# decrement sp to make space for param
	  lw $t0, -528($fp)	# fill _tmp294 to $t0 from $fp-528
	  sw $t0, 4($sp)	# copy param value to stack
	# _tmp295 = *(_tmp294)
	  lw $t0, -528($fp)	# fill _tmp294 to $t0 from $fp-528
	  lw $t2, 0($t0) 	# load with offset
	  sw $t2, -532($fp)	# spill _tmp295 from $t2 to $fp-532
	# _tmp296 = *(_tmp295 + 20)
	  lw $t0, -532($fp)	# fill _tmp295 to $t0 from $fp-532
	  lw $t2, 20($t0) 	# load with offset
	  sw $t2, -536($fp)	# spill _tmp296 from $t2 to $fp-536
	# ACall _tmp296
	  lw $t0, -536($fp)	# fill _tmp296 to $t0 from $fp-536
	  jalr $t0            	# jump to function
	# PopParams 8
	  add $sp, $sp, 8	# pop params off stack
	# Goto _L42
	  b _L42		# unconditional branch
  _L41:
  _L42:
	# Goto _L40
	  b _L40		# unconditional branch
  _L39:
  _L40:
	# _tmp297 = 1
	  li $t2, 1		# load constant value 1 into $t2
	  sw $t2, -540($fp)	# spill _tmp297 from $t2 to $fp-540
	# _tmp298 = y + _tmp297
	  lw $t0, -12($fp)	# fill y to $t0 from $fp-12
	  lw $t1, -540($fp)	# fill _tmp297 to $t1 from $fp-540
	  add $t2, $t0, $t1	
	  sw $t2, -544($fp)	# spill _tmp298 from $t2 to $fp-544
	# y = _tmp298
	  lw $t2, -544($fp)	# fill _tmp298 to $t2 from $fp-544
	  sw $t2, -12($fp)	# spill y from $t2 to $fp-12
	# Goto _L37
	  b _L37		# unconditional branch
  _L38:
	# _tmp299 = 1
	  li $t2, 1		# load constant value 1 into $t2
	  sw $t2, -548($fp)	# spill _tmp299 from $t2 to $fp-548
	# _tmp300 = x + _tmp299
	  lw $t0, -8($fp)	# fill x to $t0 from $fp-8
	  lw $t1, -548($fp)	# fill _tmp299 to $t1 from $fp-548
	  add $t2, $t0, $t1	
	  sw $t2, -552($fp)	# spill _tmp300 from $t2 to $fp-552
	# x = _tmp300
	  lw $t2, -552($fp)	# fill _tmp300 to $t2 from $fp-552
	  sw $t2, -8($fp)	# spill x from $t2 to $fp-8
	# Goto _L35
	  b _L35		# unconditional branch
  _L36:
	# Goto _L32
	  b _L32		# unconditional branch
  _L31:
  _L32:
	# EndFunc
	# (below handles reaching end of fn body with no explicit return)
	  move $sp, $fp		# pop callee frame off stack
	  lw $ra, -4($fp)	# restore saved ra
	  lw $fp, 0($fp)	# restore saved fp
	  jr $ra		# return from function
  Field.____PrintField:
	# BeginFunc 284
	  subu $sp, $sp, 8	# decrement sp to make space to save ra, fp
	  sw $fp, 8($sp)	# save fp
	  sw $ra, 4($sp)	# save ra
	  addiu $fp, $sp, 8	# set up new fp
	  subu $sp, $sp, 284	# decrement sp to make space for locals/temps
	# _tmp301 = "   "
	  .data			# create string constant marked with label
	  _string17: .asciiz "   "
	  .text
	  la $t2, _string17	# load label
	  sw $t2, -16($fp)	# spill _tmp301 from $t2 to $fp-16
	# PushParam _tmp301
	  subu $sp, $sp, 4	# decrement sp to make space for param
	  lw $t0, -16($fp)	# fill _tmp301 to $t0 from $fp-16
	  sw $t0, 4($sp)	# copy param value to stack
	# LCall _PrintString
	  jal _PrintString   	# jump to function
	# PopParams 4
	  add $sp, $sp, 4	# pop params off stack
	# _tmp302 = 0
	  li $t2, 0		# load constant value 0 into $t2
	  sw $t2, -20($fp)	# spill _tmp302 from $t2 to $fp-20
	# i = _tmp302
	  lw $t2, -20($fp)	# fill _tmp302 to $t2 from $fp-20
	  sw $t2, -8($fp)	# spill i from $t2 to $fp-8
  _L49:
	# _tmp303 = *(this + 8)
	  lw $t0, 4($fp)	# fill this to $t0 from $fp+4
	  lw $t2, 8($t0) 	# load with offset
	  sw $t2, -24($fp)	# spill _tmp303 from $t2 to $fp-24
	# _tmp304 = i < _tmp303
	  lw $t0, -8($fp)	# fill i to $t0 from $fp-8
	  lw $t1, -24($fp)	# fill _tmp303 to $t1 from $fp-24
	  slt $t2, $t0, $t1	
	  sw $t2, -28($fp)	# spill _tmp304 from $t2 to $fp-28
	# IfZ _tmp304 Goto _L50
	  lw $t0, -28($fp)	# fill _tmp304 to $t0 from $fp-28
	  beqz $t0, _L50	# branch if _tmp304 is zero 
	# PushParam i
	  subu $sp, $sp, 4	# decrement sp to make space for param
	  lw $t0, -8($fp)	# fill i to $t0 from $fp-8
	  sw $t0, 4($sp)	# copy param value to stack
	# LCall _PrintInt
	  jal _PrintInt      	# jump to function
	# PopParams 4
	  add $sp, $sp, 4	# pop params off stack
	# _tmp305 = " "
	  .data			# create string constant marked with label
	  _string18: .asciiz " "
	  .text
	  la $t2, _string18	# load label
	  sw $t2, -32($fp)	# spill _tmp305 from $t2 to $fp-32
	# PushParam _tmp305
	  subu $sp, $sp, 4	# decrement sp to make space for param
	  lw $t0, -32($fp)	# fill _tmp305 to $t0 from $fp-32
	  sw $t0, 4($sp)	# copy param value to stack
	# LCall _PrintString
	  jal _PrintString   	# jump to function
	# PopParams 4
	  add $sp, $sp, 4	# pop params off stack
	# _tmp306 = 1
	  li $t2, 1		# load constant value 1 into $t2
	  sw $t2, -36($fp)	# spill _tmp306 from $t2 to $fp-36
	# _tmp307 = i + _tmp306
	  lw $t0, -8($fp)	# fill i to $t0 from $fp-8
	  lw $t1, -36($fp)	# fill _tmp306 to $t1 from $fp-36
	  add $t2, $t0, $t1	
	  sw $t2, -40($fp)	# spill _tmp307 from $t2 to $fp-40
	# i = _tmp307
	  lw $t2, -40($fp)	# fill _tmp307 to $t2 from $fp-40
	  sw $t2, -8($fp)	# spill i from $t2 to $fp-8
	# Goto _L49
	  b _L49		# unconditional branch
  _L50:
	# _tmp308 = "\n +"
	  .data			# create string constant marked with label
	  _string19: .asciiz "\n +"
	  .text
	  la $t2, _string19	# load label
	  sw $t2, -44($fp)	# spill _tmp308 from $t2 to $fp-44
	# PushParam _tmp308
	  subu $sp, $sp, 4	# decrement sp to make space for param
	  lw $t0, -44($fp)	# fill _tmp308 to $t0 from $fp-44
	  sw $t0, 4($sp)	# copy param value to stack
	# LCall _PrintString
	  jal _PrintString   	# jump to function
	# PopParams 4
	  add $sp, $sp, 4	# pop params off stack
	# _tmp309 = 0
	  li $t2, 0		# load constant value 0 into $t2
	  sw $t2, -48($fp)	# spill _tmp309 from $t2 to $fp-48
	# i = _tmp309
	  lw $t2, -48($fp)	# fill _tmp309 to $t2 from $fp-48
	  sw $t2, -8($fp)	# spill i from $t2 to $fp-8
  _L51:
	# _tmp310 = *(this + 8)
	  lw $t0, 4($fp)	# fill this to $t0 from $fp+4
	  lw $t2, 8($t0) 	# load with offset
	  sw $t2, -52($fp)	# spill _tmp310 from $t2 to $fp-52
	# _tmp311 = i < _tmp310
	  lw $t0, -8($fp)	# fill i to $t0 from $fp-8
	  lw $t1, -52($fp)	# fill _tmp310 to $t1 from $fp-52
	  slt $t2, $t0, $t1	
	  sw $t2, -56($fp)	# spill _tmp311 from $t2 to $fp-56
	# IfZ _tmp311 Goto _L52
	  lw $t0, -56($fp)	# fill _tmp311 to $t0 from $fp-56
	  beqz $t0, _L52	# branch if _tmp311 is zero 
	# _tmp312 = "--"
	  .data			# create string constant marked with label
	  _string20: .asciiz "--"
	  .text
	  la $t2, _string20	# load label
	  sw $t2, -60($fp)	# spill _tmp312 from $t2 to $fp-60
	# PushParam _tmp312
	  subu $sp, $sp, 4	# decrement sp to make space for param
	  lw $t0, -60($fp)	# fill _tmp312 to $t0 from $fp-60
	  sw $t0, 4($sp)	# copy param value to stack
	# LCall _PrintString
	  jal _PrintString   	# jump to function
	# PopParams 4
	  add $sp, $sp, 4	# pop params off stack
	# _tmp313 = 1
	  li $t2, 1		# load constant value 1 into $t2
	  sw $t2, -64($fp)	# spill _tmp313 from $t2 to $fp-64
	# _tmp314 = i + _tmp313
	  lw $t0, -8($fp)	# fill i to $t0 from $fp-8
	  lw $t1, -64($fp)	# fill _tmp313 to $t1 from $fp-64
	  add $t2, $t0, $t1	
	  sw $t2, -68($fp)	# spill _tmp314 from $t2 to $fp-68
	# i = _tmp314
	  lw $t2, -68($fp)	# fill _tmp314 to $t2 from $fp-68
	  sw $t2, -8($fp)	# spill i from $t2 to $fp-8
	# Goto _L51
	  b _L51		# unconditional branch
  _L52:
	# _tmp315 = "\n"
	  .data			# create string constant marked with label
	  _string21: .asciiz "\n"
	  .text
	  la $t2, _string21	# load label
	  sw $t2, -72($fp)	# spill _tmp315 from $t2 to $fp-72
	# PushParam _tmp315
	  subu $sp, $sp, 4	# decrement sp to make space for param
	  lw $t0, -72($fp)	# fill _tmp315 to $t0 from $fp-72
	  sw $t0, 4($sp)	# copy param value to stack
	# LCall _PrintString
	  jal _PrintString   	# jump to function
	# PopParams 4
	  add $sp, $sp, 4	# pop params off stack
	# _tmp316 = 0
	  li $t2, 0		# load constant value 0 into $t2
	  sw $t2, -76($fp)	# spill _tmp316 from $t2 to $fp-76
	# j = _tmp316
	  lw $t2, -76($fp)	# fill _tmp316 to $t2 from $fp-76
	  sw $t2, -12($fp)	# spill j from $t2 to $fp-12
  _L53:
	# _tmp317 = *(this + 4)
	  lw $t0, 4($fp)	# fill this to $t0 from $fp+4
	  lw $t2, 4($t0) 	# load with offset
	  sw $t2, -80($fp)	# spill _tmp317 from $t2 to $fp-80
	# _tmp318 = j < _tmp317
	  lw $t0, -12($fp)	# fill j to $t0 from $fp-12
	  lw $t1, -80($fp)	# fill _tmp317 to $t1 from $fp-80
	  slt $t2, $t0, $t1	
	  sw $t2, -84($fp)	# spill _tmp318 from $t2 to $fp-84
	# IfZ _tmp318 Goto _L54
	  lw $t0, -84($fp)	# fill _tmp318 to $t0 from $fp-84
	  beqz $t0, _L54	# branch if _tmp318 is zero 
	# PushParam j
	  subu $sp, $sp, 4	# decrement sp to make space for param
	  lw $t0, -12($fp)	# fill j to $t0 from $fp-12
	  sw $t0, 4($sp)	# copy param value to stack
	# LCall _PrintInt
	  jal _PrintInt      	# jump to function
	# PopParams 4
	  add $sp, $sp, 4	# pop params off stack
	# _tmp319 = "| "
	  .data			# create string constant marked with label
	  _string22: .asciiz "| "
	  .text
	  la $t2, _string22	# load label
	  sw $t2, -88($fp)	# spill _tmp319 from $t2 to $fp-88
	# PushParam _tmp319
	  subu $sp, $sp, 4	# decrement sp to make space for param
	  lw $t0, -88($fp)	# fill _tmp319 to $t0 from $fp-88
	  sw $t0, 4($sp)	# copy param value to stack
	# LCall _PrintString
	  jal _PrintString   	# jump to function
	# PopParams 4
	  add $sp, $sp, 4	# pop params off stack
	# _tmp320 = 0
	  li $t2, 0		# load constant value 0 into $t2
	  sw $t2, -92($fp)	# spill _tmp320 from $t2 to $fp-92
	# i = _tmp320
	  lw $t2, -92($fp)	# fill _tmp320 to $t2 from $fp-92
	  sw $t2, -8($fp)	# spill i from $t2 to $fp-8
  _L55:
	# _tmp321 = *(this + 8)
	  lw $t0, 4($fp)	# fill this to $t0 from $fp+4
	  lw $t2, 8($t0) 	# load with offset
	  sw $t2, -96($fp)	# spill _tmp321 from $t2 to $fp-96
	# _tmp322 = i < _tmp321
	  lw $t0, -8($fp)	# fill i to $t0 from $fp-8
	  lw $t1, -96($fp)	# fill _tmp321 to $t1 from $fp-96
	  slt $t2, $t0, $t1	
	  sw $t2, -100($fp)	# spill _tmp322 from $t2 to $fp-100
	# IfZ _tmp322 Goto _L56
	  lw $t0, -100($fp)	# fill _tmp322 to $t0 from $fp-100
	  beqz $t0, _L56	# branch if _tmp322 is zero 
	# PushParam printSolution
	  subu $sp, $sp, 4	# decrement sp to make space for param
	  lw $t0, 8($fp)	# fill printSolution to $t0 from $fp+8
	  sw $t0, 4($sp)	# copy param value to stack
	# _tmp323 = *(this + 12)
	  lw $t0, 4($fp)	# fill this to $t0 from $fp+4
	  lw $t2, 12($t0) 	# load with offset
	  sw $t2, -104($fp)	# spill _tmp323 from $t2 to $fp-104
	# _tmp324 = 0
	  li $t2, 0		# load constant value 0 into $t2
	  sw $t2, -108($fp)	# spill _tmp324 from $t2 to $fp-108
	# _tmp325 = *(_tmp323)
	  lw $t0, -104($fp)	# fill _tmp323 to $t0 from $fp-104
	  lw $t2, 0($t0) 	# load with offset
	  sw $t2, -112($fp)	# spill _tmp325 from $t2 to $fp-112
	# _tmp326 = i < _tmp324
	  lw $t0, -8($fp)	# fill i to $t0 from $fp-8
	  lw $t1, -108($fp)	# fill _tmp324 to $t1 from $fp-108
	  slt $t2, $t0, $t1	
	  sw $t2, -116($fp)	# spill _tmp326 from $t2 to $fp-116
	# _tmp327 = _tmp325 < i
	  lw $t0, -112($fp)	# fill _tmp325 to $t0 from $fp-112
	  lw $t1, -8($fp)	# fill i to $t1 from $fp-8
	  slt $t2, $t0, $t1	
	  sw $t2, -120($fp)	# spill _tmp327 from $t2 to $fp-120
	# _tmp328 = _tmp325 == i
	  lw $t0, -112($fp)	# fill _tmp325 to $t0 from $fp-112
	  lw $t1, -8($fp)	# fill i to $t1 from $fp-8
	  seq $t2, $t0, $t1	
	  sw $t2, -124($fp)	# spill _tmp328 from $t2 to $fp-124
	# _tmp329 = _tmp327 || _tmp328
	  lw $t0, -120($fp)	# fill _tmp327 to $t0 from $fp-120
	  lw $t1, -124($fp)	# fill _tmp328 to $t1 from $fp-124
	  or $t2, $t0, $t1	
	  sw $t2, -128($fp)	# spill _tmp329 from $t2 to $fp-128
	# _tmp330 = _tmp329 || _tmp326
	  lw $t0, -128($fp)	# fill _tmp329 to $t0 from $fp-128
	  lw $t1, -116($fp)	# fill _tmp326 to $t1 from $fp-116
	  or $t2, $t0, $t1	
	  sw $t2, -132($fp)	# spill _tmp330 from $t2 to $fp-132
	# IfZ _tmp330 Goto _L57
	  lw $t0, -132($fp)	# fill _tmp330 to $t0 from $fp-132
	  beqz $t0, _L57	# branch if _tmp330 is zero 
	# _tmp331 = "Decaf runtime error: Array subscript out of bound..."
	  .data			# create string constant marked with label
	  _string23: .asciiz "Decaf runtime error: Array subscript out of bounds\n"
	  .text
	  la $t2, _string23	# load label
	  sw $t2, -136($fp)	# spill _tmp331 from $t2 to $fp-136
	# PushParam _tmp331
	  subu $sp, $sp, 4	# decrement sp to make space for param
	  lw $t0, -136($fp)	# fill _tmp331 to $t0 from $fp-136
	  sw $t0, 4($sp)	# copy param value to stack
	# LCall _PrintString
	  jal _PrintString   	# jump to function
	# PopParams 4
	  add $sp, $sp, 4	# pop params off stack
	# LCall _Halt
	  jal _Halt          	# jump to function
  _L57:
	# _tmp332 = 4
	  li $t2, 4		# load constant value 4 into $t2
	  sw $t2, -140($fp)	# spill _tmp332 from $t2 to $fp-140
	# _tmp333 = i * _tmp332
	  lw $t0, -8($fp)	# fill i to $t0 from $fp-8
	  lw $t1, -140($fp)	# fill _tmp332 to $t1 from $fp-140
	  mul $t2, $t0, $t1	
	  sw $t2, -144($fp)	# spill _tmp333 from $t2 to $fp-144
	# _tmp334 = _tmp333 + _tmp332
	  lw $t0, -144($fp)	# fill _tmp333 to $t0 from $fp-144
	  lw $t1, -140($fp)	# fill _tmp332 to $t1 from $fp-140
	  add $t2, $t0, $t1	
	  sw $t2, -148($fp)	# spill _tmp334 from $t2 to $fp-148
	# _tmp335 = _tmp323 + _tmp334
	  lw $t0, -104($fp)	# fill _tmp323 to $t0 from $fp-104
	  lw $t1, -148($fp)	# fill _tmp334 to $t1 from $fp-148
	  add $t2, $t0, $t1	
	  sw $t2, -152($fp)	# spill _tmp335 from $t2 to $fp-152
	# _tmp336 = *(_tmp335)
	  lw $t0, -152($fp)	# fill _tmp335 to $t0 from $fp-152
	  lw $t2, 0($t0) 	# load with offset
	  sw $t2, -156($fp)	# spill _tmp336 from $t2 to $fp-156
	# _tmp337 = 0
	  li $t2, 0		# load constant value 0 into $t2
	  sw $t2, -160($fp)	# spill _tmp337 from $t2 to $fp-160
	# _tmp338 = *(_tmp336)
	  lw $t0, -156($fp)	# fill _tmp336 to $t0 from $fp-156
	  lw $t2, 0($t0) 	# load with offset
	  sw $t2, -164($fp)	# spill _tmp338 from $t2 to $fp-164
	# _tmp339 = j < _tmp337
	  lw $t0, -12($fp)	# fill j to $t0 from $fp-12
	  lw $t1, -160($fp)	# fill _tmp337 to $t1 from $fp-160
	  slt $t2, $t0, $t1	
	  sw $t2, -168($fp)	# spill _tmp339 from $t2 to $fp-168
	# _tmp340 = _tmp338 < j
	  lw $t0, -164($fp)	# fill _tmp338 to $t0 from $fp-164
	  lw $t1, -12($fp)	# fill j to $t1 from $fp-12
	  slt $t2, $t0, $t1	
	  sw $t2, -172($fp)	# spill _tmp340 from $t2 to $fp-172
	# _tmp341 = _tmp338 == j
	  lw $t0, -164($fp)	# fill _tmp338 to $t0 from $fp-164
	  lw $t1, -12($fp)	# fill j to $t1 from $fp-12
	  seq $t2, $t0, $t1	
	  sw $t2, -176($fp)	# spill _tmp341 from $t2 to $fp-176
	# _tmp342 = _tmp340 || _tmp341
	  lw $t0, -172($fp)	# fill _tmp340 to $t0 from $fp-172
	  lw $t1, -176($fp)	# fill _tmp341 to $t1 from $fp-176
	  or $t2, $t0, $t1	
	  sw $t2, -180($fp)	# spill _tmp342 from $t2 to $fp-180
	# _tmp343 = _tmp342 || _tmp339
	  lw $t0, -180($fp)	# fill _tmp342 to $t0 from $fp-180
	  lw $t1, -168($fp)	# fill _tmp339 to $t1 from $fp-168
	  or $t2, $t0, $t1	
	  sw $t2, -184($fp)	# spill _tmp343 from $t2 to $fp-184
	# IfZ _tmp343 Goto _L58
	  lw $t0, -184($fp)	# fill _tmp343 to $t0 from $fp-184
	  beqz $t0, _L58	# branch if _tmp343 is zero 
	# _tmp344 = "Decaf runtime error: Array subscript out of bound..."
	  .data			# create string constant marked with label
	  _string24: .asciiz "Decaf runtime error: Array subscript out of bounds\n"
	  .text
	  la $t2, _string24	# load label
	  sw $t2, -188($fp)	# spill _tmp344 from $t2 to $fp-188
	# PushParam _tmp344
	  subu $sp, $sp, 4	# decrement sp to make space for param
	  lw $t0, -188($fp)	# fill _tmp344 to $t0 from $fp-188
	  sw $t0, 4($sp)	# copy param value to stack
	# LCall _PrintString
	  jal _PrintString   	# jump to function
	# PopParams 4
	  add $sp, $sp, 4	# pop params off stack
	# LCall _Halt
	  jal _Halt          	# jump to function
  _L58:
	# _tmp345 = 4
	  li $t2, 4		# load constant value 4 into $t2
	  sw $t2, -192($fp)	# spill _tmp345 from $t2 to $fp-192
	# _tmp346 = j * _tmp345
	  lw $t0, -12($fp)	# fill j to $t0 from $fp-12
	  lw $t1, -192($fp)	# fill _tmp345 to $t1 from $fp-192
	  mul $t2, $t0, $t1	
	  sw $t2, -196($fp)	# spill _tmp346 from $t2 to $fp-196
	# _tmp347 = _tmp346 + _tmp345
	  lw $t0, -196($fp)	# fill _tmp346 to $t0 from $fp-196
	  lw $t1, -192($fp)	# fill _tmp345 to $t1 from $fp-192
	  add $t2, $t0, $t1	
	  sw $t2, -200($fp)	# spill _tmp347 from $t2 to $fp-200
	# _tmp348 = _tmp336 + _tmp347
	  lw $t0, -156($fp)	# fill _tmp336 to $t0 from $fp-156
	  lw $t1, -200($fp)	# fill _tmp347 to $t1 from $fp-200
	  add $t2, $t0, $t1	
	  sw $t2, -204($fp)	# spill _tmp348 from $t2 to $fp-204
	# _tmp349 = *(_tmp348)
	  lw $t0, -204($fp)	# fill _tmp348 to $t0 from $fp-204
	  lw $t2, 0($t0) 	# load with offset
	  sw $t2, -208($fp)	# spill _tmp349 from $t2 to $fp-208
	# PushParam _tmp349
	  subu $sp, $sp, 4	# decrement sp to make space for param
	  lw $t0, -208($fp)	# fill _tmp349 to $t0 from $fp-208
	  sw $t0, 4($sp)	# copy param value to stack
	# _tmp350 = *(_tmp349)
	  lw $t0, -208($fp)	# fill _tmp349 to $t0 from $fp-208
	  lw $t2, 0($t0) 	# load with offset
	  sw $t2, -212($fp)	# spill _tmp350 from $t2 to $fp-212
	# _tmp351 = *(_tmp350 + 32)
	  lw $t0, -212($fp)	# fill _tmp350 to $t0 from $fp-212
	  lw $t2, 32($t0) 	# load with offset
	  sw $t2, -216($fp)	# spill _tmp351 from $t2 to $fp-216
	# ACall _tmp351
	  lw $t0, -216($fp)	# fill _tmp351 to $t0 from $fp-216
	  jalr $t0            	# jump to function
	# PopParams 8
	  add $sp, $sp, 8	# pop params off stack
	# _tmp352 = " "
	  .data			# create string constant marked with label
	  _string25: .asciiz " "
	  .text
	  la $t2, _string25	# load label
	  sw $t2, -220($fp)	# spill _tmp352 from $t2 to $fp-220
	# PushParam _tmp352
	  subu $sp, $sp, 4	# decrement sp to make space for param
	  lw $t0, -220($fp)	# fill _tmp352 to $t0 from $fp-220
	  sw $t0, 4($sp)	# copy param value to stack
	# LCall _PrintString
	  jal _PrintString   	# jump to function
	# PopParams 4
	  add $sp, $sp, 4	# pop params off stack
	# _tmp353 = 1
	  li $t2, 1		# load constant value 1 into $t2
	  sw $t2, -224($fp)	# spill _tmp353 from $t2 to $fp-224
	# _tmp354 = i + _tmp353
	  lw $t0, -8($fp)	# fill i to $t0 from $fp-8
	  lw $t1, -224($fp)	# fill _tmp353 to $t1 from $fp-224
	  add $t2, $t0, $t1	
	  sw $t2, -228($fp)	# spill _tmp354 from $t2 to $fp-228
	# i = _tmp354
	  lw $t2, -228($fp)	# fill _tmp354 to $t2 from $fp-228
	  sw $t2, -8($fp)	# spill i from $t2 to $fp-8
	# Goto _L55
	  b _L55		# unconditional branch
  _L56:
	# _tmp355 = "\n |\n"
	  .data			# create string constant marked with label
	  _string26: .asciiz "\n |\n"
	  .text
	  la $t2, _string26	# load label
	  sw $t2, -232($fp)	# spill _tmp355 from $t2 to $fp-232
	# PushParam _tmp355
	  subu $sp, $sp, 4	# decrement sp to make space for param
	  lw $t0, -232($fp)	# fill _tmp355 to $t0 from $fp-232
	  sw $t0, 4($sp)	# copy param value to stack
	# LCall _PrintString
	  jal _PrintString   	# jump to function
	# PopParams 4
	  add $sp, $sp, 4	# pop params off stack
	# _tmp356 = 1
	  li $t2, 1		# load constant value 1 into $t2
	  sw $t2, -236($fp)	# spill _tmp356 from $t2 to $fp-236
	# _tmp357 = j + _tmp356
	  lw $t0, -12($fp)	# fill j to $t0 from $fp-12
	  lw $t1, -236($fp)	# fill _tmp356 to $t1 from $fp-236
	  add $t2, $t0, $t1	
	  sw $t2, -240($fp)	# spill _tmp357 from $t2 to $fp-240
	# j = _tmp357
	  lw $t2, -240($fp)	# fill _tmp357 to $t2 from $fp-240
	  sw $t2, -12($fp)	# spill j from $t2 to $fp-12
	# Goto _L53
	  b _L53		# unconditional branch
  _L54:
	# EndFunc
	# (below handles reaching end of fn body with no explicit return)
	  move $sp, $fp		# pop callee frame off stack
	  lw $ra, -4($fp)	# restore saved ra
	  lw $fp, 0($fp)	# restore saved fp
	  jr $ra		# return from function
  Field.____Expand:
	# BeginFunc 700
	  subu $sp, $sp, 8	# decrement sp to make space to save ra, fp
	  sw $fp, 8($sp)	# save fp
	  sw $ra, 4($sp)	# save ra
	  addiu $fp, $sp, 8	# set up new fp
	  subu $sp, $sp, 700	# decrement sp to make space for locals/temps
	# _tmp358 = *(this + 12)
	  lw $t0, 4($fp)	# fill this to $t0 from $fp+4
	  lw $t2, 12($t0) 	# load with offset
	  sw $t2, -16($fp)	# spill _tmp358 from $t2 to $fp-16
	# _tmp359 = 0
	  li $t2, 0		# load constant value 0 into $t2
	  sw $t2, -20($fp)	# spill _tmp359 from $t2 to $fp-20
	# _tmp360 = *(_tmp358)
	  lw $t0, -16($fp)	# fill _tmp358 to $t0 from $fp-16
	  lw $t2, 0($t0) 	# load with offset
	  sw $t2, -24($fp)	# spill _tmp360 from $t2 to $fp-24
	# _tmp361 = x < _tmp359
	  lw $t0, 8($fp)	# fill x to $t0 from $fp+8
	  lw $t1, -20($fp)	# fill _tmp359 to $t1 from $fp-20
	  slt $t2, $t0, $t1	
	  sw $t2, -28($fp)	# spill _tmp361 from $t2 to $fp-28
	# _tmp362 = _tmp360 < x
	  lw $t0, -24($fp)	# fill _tmp360 to $t0 from $fp-24
	  lw $t1, 8($fp)	# fill x to $t1 from $fp+8
	  slt $t2, $t0, $t1	
	  sw $t2, -32($fp)	# spill _tmp362 from $t2 to $fp-32
	# _tmp363 = _tmp360 == x
	  lw $t0, -24($fp)	# fill _tmp360 to $t0 from $fp-24
	  lw $t1, 8($fp)	# fill x to $t1 from $fp+8
	  seq $t2, $t0, $t1	
	  sw $t2, -36($fp)	# spill _tmp363 from $t2 to $fp-36
	# _tmp364 = _tmp362 || _tmp363
	  lw $t0, -32($fp)	# fill _tmp362 to $t0 from $fp-32
	  lw $t1, -36($fp)	# fill _tmp363 to $t1 from $fp-36
	  or $t2, $t0, $t1	
	  sw $t2, -40($fp)	# spill _tmp364 from $t2 to $fp-40
	# _tmp365 = _tmp364 || _tmp361
	  lw $t0, -40($fp)	# fill _tmp364 to $t0 from $fp-40
	  lw $t1, -28($fp)	# fill _tmp361 to $t1 from $fp-28
	  or $t2, $t0, $t1	
	  sw $t2, -44($fp)	# spill _tmp365 from $t2 to $fp-44
	# IfZ _tmp365 Goto _L61
	  lw $t0, -44($fp)	# fill _tmp365 to $t0 from $fp-44
	  beqz $t0, _L61	# branch if _tmp365 is zero 
	# _tmp366 = "Decaf runtime error: Array subscript out of bound..."
	  .data			# create string constant marked with label
	  _string27: .asciiz "Decaf runtime error: Array subscript out of bounds\n"
	  .text
	  la $t2, _string27	# load label
	  sw $t2, -48($fp)	# spill _tmp366 from $t2 to $fp-48
	# PushParam _tmp366
	  subu $sp, $sp, 4	# decrement sp to make space for param
	  lw $t0, -48($fp)	# fill _tmp366 to $t0 from $fp-48
	  sw $t0, 4($sp)	# copy param value to stack
	# LCall _PrintString
	  jal _PrintString   	# jump to function
	# PopParams 4
	  add $sp, $sp, 4	# pop params off stack
	# LCall _Halt
	  jal _Halt          	# jump to function
  _L61:
	# _tmp367 = 4
	  li $t2, 4		# load constant value 4 into $t2
	  sw $t2, -52($fp)	# spill _tmp367 from $t2 to $fp-52
	# _tmp368 = x * _tmp367
	  lw $t0, 8($fp)	# fill x to $t0 from $fp+8
	  lw $t1, -52($fp)	# fill _tmp367 to $t1 from $fp-52
	  mul $t2, $t0, $t1	
	  sw $t2, -56($fp)	# spill _tmp368 from $t2 to $fp-56
	# _tmp369 = _tmp368 + _tmp367
	  lw $t0, -56($fp)	# fill _tmp368 to $t0 from $fp-56
	  lw $t1, -52($fp)	# fill _tmp367 to $t1 from $fp-52
	  add $t2, $t0, $t1	
	  sw $t2, -60($fp)	# spill _tmp369 from $t2 to $fp-60
	# _tmp370 = _tmp358 + _tmp369
	  lw $t0, -16($fp)	# fill _tmp358 to $t0 from $fp-16
	  lw $t1, -60($fp)	# fill _tmp369 to $t1 from $fp-60
	  add $t2, $t0, $t1	
	  sw $t2, -64($fp)	# spill _tmp370 from $t2 to $fp-64
	# _tmp371 = *(_tmp370)
	  lw $t0, -64($fp)	# fill _tmp370 to $t0 from $fp-64
	  lw $t2, 0($t0) 	# load with offset
	  sw $t2, -68($fp)	# spill _tmp371 from $t2 to $fp-68
	# _tmp372 = 0
	  li $t2, 0		# load constant value 0 into $t2
	  sw $t2, -72($fp)	# spill _tmp372 from $t2 to $fp-72
	# _tmp373 = *(_tmp371)
	  lw $t0, -68($fp)	# fill _tmp371 to $t0 from $fp-68
	  lw $t2, 0($t0) 	# load with offset
	  sw $t2, -76($fp)	# spill _tmp373 from $t2 to $fp-76
	# _tmp374 = y < _tmp372
	  lw $t0, 12($fp)	# fill y to $t0 from $fp+12
	  lw $t1, -72($fp)	# fill _tmp372 to $t1 from $fp-72
	  slt $t2, $t0, $t1	
	  sw $t2, -80($fp)	# spill _tmp374 from $t2 to $fp-80
	# _tmp375 = _tmp373 < y
	  lw $t0, -76($fp)	# fill _tmp373 to $t0 from $fp-76
	  lw $t1, 12($fp)	# fill y to $t1 from $fp+12
	  slt $t2, $t0, $t1	
	  sw $t2, -84($fp)	# spill _tmp375 from $t2 to $fp-84
	# _tmp376 = _tmp373 == y
	  lw $t0, -76($fp)	# fill _tmp373 to $t0 from $fp-76
	  lw $t1, 12($fp)	# fill y to $t1 from $fp+12
	  seq $t2, $t0, $t1	
	  sw $t2, -88($fp)	# spill _tmp376 from $t2 to $fp-88
	# _tmp377 = _tmp375 || _tmp376
	  lw $t0, -84($fp)	# fill _tmp375 to $t0 from $fp-84
	  lw $t1, -88($fp)	# fill _tmp376 to $t1 from $fp-88
	  or $t2, $t0, $t1	
	  sw $t2, -92($fp)	# spill _tmp377 from $t2 to $fp-92
	# _tmp378 = _tmp377 || _tmp374
	  lw $t0, -92($fp)	# fill _tmp377 to $t0 from $fp-92
	  lw $t1, -80($fp)	# fill _tmp374 to $t1 from $fp-80
	  or $t2, $t0, $t1	
	  sw $t2, -96($fp)	# spill _tmp378 from $t2 to $fp-96
	# IfZ _tmp378 Goto _L62
	  lw $t0, -96($fp)	# fill _tmp378 to $t0 from $fp-96
	  beqz $t0, _L62	# branch if _tmp378 is zero 
	# _tmp379 = "Decaf runtime error: Array subscript out of bound..."
	  .data			# create string constant marked with label
	  _string28: .asciiz "Decaf runtime error: Array subscript out of bounds\n"
	  .text
	  la $t2, _string28	# load label
	  sw $t2, -100($fp)	# spill _tmp379 from $t2 to $fp-100
	# PushParam _tmp379
	  subu $sp, $sp, 4	# decrement sp to make space for param
	  lw $t0, -100($fp)	# fill _tmp379 to $t0 from $fp-100
	  sw $t0, 4($sp)	# copy param value to stack
	# LCall _PrintString
	  jal _PrintString   	# jump to function
	# PopParams 4
	  add $sp, $sp, 4	# pop params off stack
	# LCall _Halt
	  jal _Halt          	# jump to function
  _L62:
	# _tmp380 = 4
	  li $t2, 4		# load constant value 4 into $t2
	  sw $t2, -104($fp)	# spill _tmp380 from $t2 to $fp-104
	# _tmp381 = y * _tmp380
	  lw $t0, 12($fp)	# fill y to $t0 from $fp+12
	  lw $t1, -104($fp)	# fill _tmp380 to $t1 from $fp-104
	  mul $t2, $t0, $t1	
	  sw $t2, -108($fp)	# spill _tmp381 from $t2 to $fp-108
	# _tmp382 = _tmp381 + _tmp380
	  lw $t0, -108($fp)	# fill _tmp381 to $t0 from $fp-108
	  lw $t1, -104($fp)	# fill _tmp380 to $t1 from $fp-104
	  add $t2, $t0, $t1	
	  sw $t2, -112($fp)	# spill _tmp382 from $t2 to $fp-112
	# _tmp383 = _tmp371 + _tmp382
	  lw $t0, -68($fp)	# fill _tmp371 to $t0 from $fp-68
	  lw $t1, -112($fp)	# fill _tmp382 to $t1 from $fp-112
	  add $t2, $t0, $t1	
	  sw $t2, -116($fp)	# spill _tmp383 from $t2 to $fp-116
	# _tmp384 = *(_tmp383)
	  lw $t0, -116($fp)	# fill _tmp383 to $t0 from $fp-116
	  lw $t2, 0($t0) 	# load with offset
	  sw $t2, -120($fp)	# spill _tmp384 from $t2 to $fp-120
	# PushParam _tmp384
	  subu $sp, $sp, 4	# decrement sp to make space for param
	  lw $t0, -120($fp)	# fill _tmp384 to $t0 from $fp-120
	  sw $t0, 4($sp)	# copy param value to stack
	# _tmp385 = *(_tmp384)
	  lw $t0, -120($fp)	# fill _tmp384 to $t0 from $fp-120
	  lw $t2, 0($t0) 	# load with offset
	  sw $t2, -124($fp)	# spill _tmp385 from $t2 to $fp-124
	# _tmp386 = *(_tmp385 + 8)
	  lw $t0, -124($fp)	# fill _tmp385 to $t0 from $fp-124
	  lw $t2, 8($t0) 	# load with offset
	  sw $t2, -128($fp)	# spill _tmp386 from $t2 to $fp-128
	# _tmp387 = ACall _tmp386
	  lw $t0, -128($fp)	# fill _tmp386 to $t0 from $fp-128
	  jalr $t0            	# jump to function
	  move $t2, $v0		# copy function return value from $v0
	  sw $t2, -132($fp)	# spill _tmp387 from $t2 to $fp-132
	# PopParams 4
	  add $sp, $sp, 4	# pop params off stack
	# IfZ _tmp387 Goto _L59
	  lw $t0, -132($fp)	# fill _tmp387 to $t0 from $fp-132
	  beqz $t0, _L59	# branch if _tmp387 is zero 
	# Return 
	  move $sp, $fp		# pop callee frame off stack
	  lw $ra, -4($fp)	# restore saved ra
	  lw $fp, 0($fp)	# restore saved fp
	  jr $ra		# return from function
	# Goto _L60
	  b _L60		# unconditional branch
  _L59:
  _L60:
	# _tmp388 = *(this + 12)
	  lw $t0, 4($fp)	# fill this to $t0 from $fp+4
	  lw $t2, 12($t0) 	# load with offset
	  sw $t2, -136($fp)	# spill _tmp388 from $t2 to $fp-136
	# _tmp389 = 0
	  li $t2, 0		# load constant value 0 into $t2
	  sw $t2, -140($fp)	# spill _tmp389 from $t2 to $fp-140
	# _tmp390 = *(_tmp388)
	  lw $t0, -136($fp)	# fill _tmp388 to $t0 from $fp-136
	  lw $t2, 0($t0) 	# load with offset
	  sw $t2, -144($fp)	# spill _tmp390 from $t2 to $fp-144
	# _tmp391 = x < _tmp389
	  lw $t0, 8($fp)	# fill x to $t0 from $fp+8
	  lw $t1, -140($fp)	# fill _tmp389 to $t1 from $fp-140
	  slt $t2, $t0, $t1	
	  sw $t2, -148($fp)	# spill _tmp391 from $t2 to $fp-148
	# _tmp392 = _tmp390 < x
	  lw $t0, -144($fp)	# fill _tmp390 to $t0 from $fp-144
	  lw $t1, 8($fp)	# fill x to $t1 from $fp+8
	  slt $t2, $t0, $t1	
	  sw $t2, -152($fp)	# spill _tmp392 from $t2 to $fp-152
	# _tmp393 = _tmp390 == x
	  lw $t0, -144($fp)	# fill _tmp390 to $t0 from $fp-144
	  lw $t1, 8($fp)	# fill x to $t1 from $fp+8
	  seq $t2, $t0, $t1	
	  sw $t2, -156($fp)	# spill _tmp393 from $t2 to $fp-156
	# _tmp394 = _tmp392 || _tmp393
	  lw $t0, -152($fp)	# fill _tmp392 to $t0 from $fp-152
	  lw $t1, -156($fp)	# fill _tmp393 to $t1 from $fp-156
	  or $t2, $t0, $t1	
	  sw $t2, -160($fp)	# spill _tmp394 from $t2 to $fp-160
	# _tmp395 = _tmp394 || _tmp391
	  lw $t0, -160($fp)	# fill _tmp394 to $t0 from $fp-160
	  lw $t1, -148($fp)	# fill _tmp391 to $t1 from $fp-148
	  or $t2, $t0, $t1	
	  sw $t2, -164($fp)	# spill _tmp395 from $t2 to $fp-164
	# IfZ _tmp395 Goto _L63
	  lw $t0, -164($fp)	# fill _tmp395 to $t0 from $fp-164
	  beqz $t0, _L63	# branch if _tmp395 is zero 
	# _tmp396 = "Decaf runtime error: Array subscript out of bound..."
	  .data			# create string constant marked with label
	  _string29: .asciiz "Decaf runtime error: Array subscript out of bounds\n"
	  .text
	  la $t2, _string29	# load label
	  sw $t2, -168($fp)	# spill _tmp396 from $t2 to $fp-168
	# PushParam _tmp396
	  subu $sp, $sp, 4	# decrement sp to make space for param
	  lw $t0, -168($fp)	# fill _tmp396 to $t0 from $fp-168
	  sw $t0, 4($sp)	# copy param value to stack
	# LCall _PrintString
	  jal _PrintString   	# jump to function
	# PopParams 4
	  add $sp, $sp, 4	# pop params off stack
	# LCall _Halt
	  jal _Halt          	# jump to function
  _L63:
	# _tmp397 = 4
	  li $t2, 4		# load constant value 4 into $t2
	  sw $t2, -172($fp)	# spill _tmp397 from $t2 to $fp-172
	# _tmp398 = x * _tmp397
	  lw $t0, 8($fp)	# fill x to $t0 from $fp+8
	  lw $t1, -172($fp)	# fill _tmp397 to $t1 from $fp-172
	  mul $t2, $t0, $t1	
	  sw $t2, -176($fp)	# spill _tmp398 from $t2 to $fp-176
	# _tmp399 = _tmp398 + _tmp397
	  lw $t0, -176($fp)	# fill _tmp398 to $t0 from $fp-176
	  lw $t1, -172($fp)	# fill _tmp397 to $t1 from $fp-172
	  add $t2, $t0, $t1	
	  sw $t2, -180($fp)	# spill _tmp399 from $t2 to $fp-180
	# _tmp400 = _tmp388 + _tmp399
	  lw $t0, -136($fp)	# fill _tmp388 to $t0 from $fp-136
	  lw $t1, -180($fp)	# fill _tmp399 to $t1 from $fp-180
	  add $t2, $t0, $t1	
	  sw $t2, -184($fp)	# spill _tmp400 from $t2 to $fp-184
	# _tmp401 = *(_tmp400)
	  lw $t0, -184($fp)	# fill _tmp400 to $t0 from $fp-184
	  lw $t2, 0($t0) 	# load with offset
	  sw $t2, -188($fp)	# spill _tmp401 from $t2 to $fp-188
	# _tmp402 = 0
	  li $t2, 0		# load constant value 0 into $t2
	  sw $t2, -192($fp)	# spill _tmp402 from $t2 to $fp-192
	# _tmp403 = *(_tmp401)
	  lw $t0, -188($fp)	# fill _tmp401 to $t0 from $fp-188
	  lw $t2, 0($t0) 	# load with offset
	  sw $t2, -196($fp)	# spill _tmp403 from $t2 to $fp-196
	# _tmp404 = y < _tmp402
	  lw $t0, 12($fp)	# fill y to $t0 from $fp+12
	  lw $t1, -192($fp)	# fill _tmp402 to $t1 from $fp-192
	  slt $t2, $t0, $t1	
	  sw $t2, -200($fp)	# spill _tmp404 from $t2 to $fp-200
	# _tmp405 = _tmp403 < y
	  lw $t0, -196($fp)	# fill _tmp403 to $t0 from $fp-196
	  lw $t1, 12($fp)	# fill y to $t1 from $fp+12
	  slt $t2, $t0, $t1	
	  sw $t2, -204($fp)	# spill _tmp405 from $t2 to $fp-204
	# _tmp406 = _tmp403 == y
	  lw $t0, -196($fp)	# fill _tmp403 to $t0 from $fp-196
	  lw $t1, 12($fp)	# fill y to $t1 from $fp+12
	  seq $t2, $t0, $t1	
	  sw $t2, -208($fp)	# spill _tmp406 from $t2 to $fp-208
	# _tmp407 = _tmp405 || _tmp406
	  lw $t0, -204($fp)	# fill _tmp405 to $t0 from $fp-204
	  lw $t1, -208($fp)	# fill _tmp406 to $t1 from $fp-208
	  or $t2, $t0, $t1	
	  sw $t2, -212($fp)	# spill _tmp407 from $t2 to $fp-212
	# _tmp408 = _tmp407 || _tmp404
	  lw $t0, -212($fp)	# fill _tmp407 to $t0 from $fp-212
	  lw $t1, -200($fp)	# fill _tmp404 to $t1 from $fp-200
	  or $t2, $t0, $t1	
	  sw $t2, -216($fp)	# spill _tmp408 from $t2 to $fp-216
	# IfZ _tmp408 Goto _L64
	  lw $t0, -216($fp)	# fill _tmp408 to $t0 from $fp-216
	  beqz $t0, _L64	# branch if _tmp408 is zero 
	# _tmp409 = "Decaf runtime error: Array subscript out of bound..."
	  .data			# create string constant marked with label
	  _string30: .asciiz "Decaf runtime error: Array subscript out of bounds\n"
	  .text
	  la $t2, _string30	# load label
	  sw $t2, -220($fp)	# spill _tmp409 from $t2 to $fp-220
	# PushParam _tmp409
	  subu $sp, $sp, 4	# decrement sp to make space for param
	  lw $t0, -220($fp)	# fill _tmp409 to $t0 from $fp-220
	  sw $t0, 4($sp)	# copy param value to stack
	# LCall _PrintString
	  jal _PrintString   	# jump to function
	# PopParams 4
	  add $sp, $sp, 4	# pop params off stack
	# LCall _Halt
	  jal _Halt          	# jump to function
  _L64:
	# _tmp410 = 4
	  li $t2, 4		# load constant value 4 into $t2
	  sw $t2, -224($fp)	# spill _tmp410 from $t2 to $fp-224
	# _tmp411 = y * _tmp410
	  lw $t0, 12($fp)	# fill y to $t0 from $fp+12
	  lw $t1, -224($fp)	# fill _tmp410 to $t1 from $fp-224
	  mul $t2, $t0, $t1	
	  sw $t2, -228($fp)	# spill _tmp411 from $t2 to $fp-228
	# _tmp412 = _tmp411 + _tmp410
	  lw $t0, -228($fp)	# fill _tmp411 to $t0 from $fp-228
	  lw $t1, -224($fp)	# fill _tmp410 to $t1 from $fp-224
	  add $t2, $t0, $t1	
	  sw $t2, -232($fp)	# spill _tmp412 from $t2 to $fp-232
	# _tmp413 = _tmp401 + _tmp412
	  lw $t0, -188($fp)	# fill _tmp401 to $t0 from $fp-188
	  lw $t1, -232($fp)	# fill _tmp412 to $t1 from $fp-232
	  add $t2, $t0, $t1	
	  sw $t2, -236($fp)	# spill _tmp413 from $t2 to $fp-236
	# _tmp414 = *(_tmp413)
	  lw $t0, -236($fp)	# fill _tmp413 to $t0 from $fp-236
	  lw $t2, 0($t0) 	# load with offset
	  sw $t2, -240($fp)	# spill _tmp414 from $t2 to $fp-240
	# PushParam _tmp414
	  subu $sp, $sp, 4	# decrement sp to make space for param
	  lw $t0, -240($fp)	# fill _tmp414 to $t0 from $fp-240
	  sw $t0, 4($sp)	# copy param value to stack
	# _tmp415 = *(_tmp414)
	  lw $t0, -240($fp)	# fill _tmp414 to $t0 from $fp-240
	  lw $t2, 0($t0) 	# load with offset
	  sw $t2, -244($fp)	# spill _tmp415 from $t2 to $fp-244
	# _tmp416 = *(_tmp415 + 4)
	  lw $t0, -244($fp)	# fill _tmp415 to $t0 from $fp-244
	  lw $t2, 4($t0) 	# load with offset
	  sw $t2, -248($fp)	# spill _tmp416 from $t2 to $fp-248
	# ACall _tmp416
	  lw $t0, -248($fp)	# fill _tmp416 to $t0 from $fp-248
	  jalr $t0            	# jump to function
	# PopParams 4
	  add $sp, $sp, 4	# pop params off stack
	# _tmp417 = *(this + 12)
	  lw $t0, 4($fp)	# fill this to $t0 from $fp+4
	  lw $t2, 12($t0) 	# load with offset
	  sw $t2, -252($fp)	# spill _tmp417 from $t2 to $fp-252
	# _tmp418 = 0
	  li $t2, 0		# load constant value 0 into $t2
	  sw $t2, -256($fp)	# spill _tmp418 from $t2 to $fp-256
	# _tmp419 = *(_tmp417)
	  lw $t0, -252($fp)	# fill _tmp417 to $t0 from $fp-252
	  lw $t2, 0($t0) 	# load with offset
	  sw $t2, -260($fp)	# spill _tmp419 from $t2 to $fp-260
	# _tmp420 = x < _tmp418
	  lw $t0, 8($fp)	# fill x to $t0 from $fp+8
	  lw $t1, -256($fp)	# fill _tmp418 to $t1 from $fp-256
	  slt $t2, $t0, $t1	
	  sw $t2, -264($fp)	# spill _tmp420 from $t2 to $fp-264
	# _tmp421 = _tmp419 < x
	  lw $t0, -260($fp)	# fill _tmp419 to $t0 from $fp-260
	  lw $t1, 8($fp)	# fill x to $t1 from $fp+8
	  slt $t2, $t0, $t1	
	  sw $t2, -268($fp)	# spill _tmp421 from $t2 to $fp-268
	# _tmp422 = _tmp419 == x
	  lw $t0, -260($fp)	# fill _tmp419 to $t0 from $fp-260
	  lw $t1, 8($fp)	# fill x to $t1 from $fp+8
	  seq $t2, $t0, $t1	
	  sw $t2, -272($fp)	# spill _tmp422 from $t2 to $fp-272
	# _tmp423 = _tmp421 || _tmp422
	  lw $t0, -268($fp)	# fill _tmp421 to $t0 from $fp-268
	  lw $t1, -272($fp)	# fill _tmp422 to $t1 from $fp-272
	  or $t2, $t0, $t1	
	  sw $t2, -276($fp)	# spill _tmp423 from $t2 to $fp-276
	# _tmp424 = _tmp423 || _tmp420
	  lw $t0, -276($fp)	# fill _tmp423 to $t0 from $fp-276
	  lw $t1, -264($fp)	# fill _tmp420 to $t1 from $fp-264
	  or $t2, $t0, $t1	
	  sw $t2, -280($fp)	# spill _tmp424 from $t2 to $fp-280
	# IfZ _tmp424 Goto _L67
	  lw $t0, -280($fp)	# fill _tmp424 to $t0 from $fp-280
	  beqz $t0, _L67	# branch if _tmp424 is zero 
	# _tmp425 = "Decaf runtime error: Array subscript out of bound..."
	  .data			# create string constant marked with label
	  _string31: .asciiz "Decaf runtime error: Array subscript out of bounds\n"
	  .text
	  la $t2, _string31	# load label
	  sw $t2, -284($fp)	# spill _tmp425 from $t2 to $fp-284
	# PushParam _tmp425
	  subu $sp, $sp, 4	# decrement sp to make space for param
	  lw $t0, -284($fp)	# fill _tmp425 to $t0 from $fp-284
	  sw $t0, 4($sp)	# copy param value to stack
	# LCall _PrintString
	  jal _PrintString   	# jump to function
	# PopParams 4
	  add $sp, $sp, 4	# pop params off stack
	# LCall _Halt
	  jal _Halt          	# jump to function
  _L67:
	# _tmp426 = 4
	  li $t2, 4		# load constant value 4 into $t2
	  sw $t2, -288($fp)	# spill _tmp426 from $t2 to $fp-288
	# _tmp427 = x * _tmp426
	  lw $t0, 8($fp)	# fill x to $t0 from $fp+8
	  lw $t1, -288($fp)	# fill _tmp426 to $t1 from $fp-288
	  mul $t2, $t0, $t1	
	  sw $t2, -292($fp)	# spill _tmp427 from $t2 to $fp-292
	# _tmp428 = _tmp427 + _tmp426
	  lw $t0, -292($fp)	# fill _tmp427 to $t0 from $fp-292
	  lw $t1, -288($fp)	# fill _tmp426 to $t1 from $fp-288
	  add $t2, $t0, $t1	
	  sw $t2, -296($fp)	# spill _tmp428 from $t2 to $fp-296
	# _tmp429 = _tmp417 + _tmp428
	  lw $t0, -252($fp)	# fill _tmp417 to $t0 from $fp-252
	  lw $t1, -296($fp)	# fill _tmp428 to $t1 from $fp-296
	  add $t2, $t0, $t1	
	  sw $t2, -300($fp)	# spill _tmp429 from $t2 to $fp-300
	# _tmp430 = *(_tmp429)
	  lw $t0, -300($fp)	# fill _tmp429 to $t0 from $fp-300
	  lw $t2, 0($t0) 	# load with offset
	  sw $t2, -304($fp)	# spill _tmp430 from $t2 to $fp-304
	# _tmp431 = 0
	  li $t2, 0		# load constant value 0 into $t2
	  sw $t2, -308($fp)	# spill _tmp431 from $t2 to $fp-308
	# _tmp432 = *(_tmp430)
	  lw $t0, -304($fp)	# fill _tmp430 to $t0 from $fp-304
	  lw $t2, 0($t0) 	# load with offset
	  sw $t2, -312($fp)	# spill _tmp432 from $t2 to $fp-312
	# _tmp433 = y < _tmp431
	  lw $t0, 12($fp)	# fill y to $t0 from $fp+12
	  lw $t1, -308($fp)	# fill _tmp431 to $t1 from $fp-308
	  slt $t2, $t0, $t1	
	  sw $t2, -316($fp)	# spill _tmp433 from $t2 to $fp-316
	# _tmp434 = _tmp432 < y
	  lw $t0, -312($fp)	# fill _tmp432 to $t0 from $fp-312
	  lw $t1, 12($fp)	# fill y to $t1 from $fp+12
	  slt $t2, $t0, $t1	
	  sw $t2, -320($fp)	# spill _tmp434 from $t2 to $fp-320
	# _tmp435 = _tmp432 == y
	  lw $t0, -312($fp)	# fill _tmp432 to $t0 from $fp-312
	  lw $t1, 12($fp)	# fill y to $t1 from $fp+12
	  seq $t2, $t0, $t1	
	  sw $t2, -324($fp)	# spill _tmp435 from $t2 to $fp-324
	# _tmp436 = _tmp434 || _tmp435
	  lw $t0, -320($fp)	# fill _tmp434 to $t0 from $fp-320
	  lw $t1, -324($fp)	# fill _tmp435 to $t1 from $fp-324
	  or $t2, $t0, $t1	
	  sw $t2, -328($fp)	# spill _tmp436 from $t2 to $fp-328
	# _tmp437 = _tmp436 || _tmp433
	  lw $t0, -328($fp)	# fill _tmp436 to $t0 from $fp-328
	  lw $t1, -316($fp)	# fill _tmp433 to $t1 from $fp-316
	  or $t2, $t0, $t1	
	  sw $t2, -332($fp)	# spill _tmp437 from $t2 to $fp-332
	# IfZ _tmp437 Goto _L68
	  lw $t0, -332($fp)	# fill _tmp437 to $t0 from $fp-332
	  beqz $t0, _L68	# branch if _tmp437 is zero 
	# _tmp438 = "Decaf runtime error: Array subscript out of bound..."
	  .data			# create string constant marked with label
	  _string32: .asciiz "Decaf runtime error: Array subscript out of bounds\n"
	  .text
	  la $t2, _string32	# load label
	  sw $t2, -336($fp)	# spill _tmp438 from $t2 to $fp-336
	# PushParam _tmp438
	  subu $sp, $sp, 4	# decrement sp to make space for param
	  lw $t0, -336($fp)	# fill _tmp438 to $t0 from $fp-336
	  sw $t0, 4($sp)	# copy param value to stack
	# LCall _PrintString
	  jal _PrintString   	# jump to function
	# PopParams 4
	  add $sp, $sp, 4	# pop params off stack
	# LCall _Halt
	  jal _Halt          	# jump to function
  _L68:
	# _tmp439 = 4
	  li $t2, 4		# load constant value 4 into $t2
	  sw $t2, -340($fp)	# spill _tmp439 from $t2 to $fp-340
	# _tmp440 = y * _tmp439
	  lw $t0, 12($fp)	# fill y to $t0 from $fp+12
	  lw $t1, -340($fp)	# fill _tmp439 to $t1 from $fp-340
	  mul $t2, $t0, $t1	
	  sw $t2, -344($fp)	# spill _tmp440 from $t2 to $fp-344
	# _tmp441 = _tmp440 + _tmp439
	  lw $t0, -344($fp)	# fill _tmp440 to $t0 from $fp-344
	  lw $t1, -340($fp)	# fill _tmp439 to $t1 from $fp-340
	  add $t2, $t0, $t1	
	  sw $t2, -348($fp)	# spill _tmp441 from $t2 to $fp-348
	# _tmp442 = _tmp430 + _tmp441
	  lw $t0, -304($fp)	# fill _tmp430 to $t0 from $fp-304
	  lw $t1, -348($fp)	# fill _tmp441 to $t1 from $fp-348
	  add $t2, $t0, $t1	
	  sw $t2, -352($fp)	# spill _tmp442 from $t2 to $fp-352
	# _tmp443 = *(_tmp442)
	  lw $t0, -352($fp)	# fill _tmp442 to $t0 from $fp-352
	  lw $t2, 0($t0) 	# load with offset
	  sw $t2, -356($fp)	# spill _tmp443 from $t2 to $fp-356
	# PushParam _tmp443
	  subu $sp, $sp, 4	# decrement sp to make space for param
	  lw $t0, -356($fp)	# fill _tmp443 to $t0 from $fp-356
	  sw $t0, 4($sp)	# copy param value to stack
	# _tmp444 = *(_tmp443)
	  lw $t0, -356($fp)	# fill _tmp443 to $t0 from $fp-356
	  lw $t2, 0($t0) 	# load with offset
	  sw $t2, -360($fp)	# spill _tmp444 from $t2 to $fp-360
	# _tmp445 = *(_tmp444 + 16)
	  lw $t0, -360($fp)	# fill _tmp444 to $t0 from $fp-360
	  lw $t2, 16($t0) 	# load with offset
	  sw $t2, -364($fp)	# spill _tmp445 from $t2 to $fp-364
	# _tmp446 = ACall _tmp445
	  lw $t0, -364($fp)	# fill _tmp445 to $t0 from $fp-364
	  jalr $t0            	# jump to function
	  move $t2, $v0		# copy function return value from $v0
	  sw $t2, -368($fp)	# spill _tmp446 from $t2 to $fp-368
	# PopParams 4
	  add $sp, $sp, 4	# pop params off stack
	# IfZ _tmp446 Goto _L65
	  lw $t0, -368($fp)	# fill _tmp446 to $t0 from $fp-368
	  beqz $t0, _L65	# branch if _tmp446 is zero 
	# _tmp447 = 0
	  li $t2, 0		# load constant value 0 into $t2
	  sw $t2, -372($fp)	# spill _tmp447 from $t2 to $fp-372
	# *(this + 16) = _tmp447
	  lw $t0, -372($fp)	# fill _tmp447 to $t0 from $fp-372
	  lw $t2, 4($fp)	# fill this to $t2 from $fp+4
	  sw $t0, 16($t2) 	# store with offset
	# Return 
	  move $sp, $fp		# pop callee frame off stack
	  lw $ra, -4($fp)	# restore saved ra
	  lw $fp, 0($fp)	# restore saved fp
	  jr $ra		# return from function
	# Goto _L66
	  b _L66		# unconditional branch
  _L65:
  _L66:
	# _tmp448 = *(this + 24)
	  lw $t0, 4($fp)	# fill this to $t0 from $fp+4
	  lw $t2, 24($t0) 	# load with offset
	  sw $t2, -376($fp)	# spill _tmp448 from $t2 to $fp-376
	# _tmp449 = 1
	  li $t2, 1		# load constant value 1 into $t2
	  sw $t2, -380($fp)	# spill _tmp449 from $t2 to $fp-380
	# _tmp450 = _tmp448 + _tmp449
	  lw $t0, -376($fp)	# fill _tmp448 to $t0 from $fp-376
	  lw $t1, -380($fp)	# fill _tmp449 to $t1 from $fp-380
	  add $t2, $t0, $t1	
	  sw $t2, -384($fp)	# spill _tmp450 from $t2 to $fp-384
	# *(this + 24) = _tmp450
	  lw $t0, -384($fp)	# fill _tmp450 to $t0 from $fp-384
	  lw $t2, 4($fp)	# fill this to $t2 from $fp+4
	  sw $t0, 24($t2) 	# store with offset
	# _tmp452 = *(this + 12)
	  lw $t0, 4($fp)	# fill this to $t0 from $fp+4
	  lw $t2, 12($t0) 	# load with offset
	  sw $t2, -392($fp)	# spill _tmp452 from $t2 to $fp-392
	# _tmp453 = 0
	  li $t2, 0		# load constant value 0 into $t2
	  sw $t2, -396($fp)	# spill _tmp453 from $t2 to $fp-396
	# _tmp454 = *(_tmp452)
	  lw $t0, -392($fp)	# fill _tmp452 to $t0 from $fp-392
	  lw $t2, 0($t0) 	# load with offset
	  sw $t2, -400($fp)	# spill _tmp454 from $t2 to $fp-400
	# _tmp455 = x < _tmp453
	  lw $t0, 8($fp)	# fill x to $t0 from $fp+8
	  lw $t1, -396($fp)	# fill _tmp453 to $t1 from $fp-396
	  slt $t2, $t0, $t1	
	  sw $t2, -404($fp)	# spill _tmp455 from $t2 to $fp-404
	# _tmp456 = _tmp454 < x
	  lw $t0, -400($fp)	# fill _tmp454 to $t0 from $fp-400
	  lw $t1, 8($fp)	# fill x to $t1 from $fp+8
	  slt $t2, $t0, $t1	
	  sw $t2, -408($fp)	# spill _tmp456 from $t2 to $fp-408
	# _tmp457 = _tmp454 == x
	  lw $t0, -400($fp)	# fill _tmp454 to $t0 from $fp-400
	  lw $t1, 8($fp)	# fill x to $t1 from $fp+8
	  seq $t2, $t0, $t1	
	  sw $t2, -412($fp)	# spill _tmp457 from $t2 to $fp-412
	# _tmp458 = _tmp456 || _tmp457
	  lw $t0, -408($fp)	# fill _tmp456 to $t0 from $fp-408
	  lw $t1, -412($fp)	# fill _tmp457 to $t1 from $fp-412
	  or $t2, $t0, $t1	
	  sw $t2, -416($fp)	# spill _tmp458 from $t2 to $fp-416
	# _tmp459 = _tmp458 || _tmp455
	  lw $t0, -416($fp)	# fill _tmp458 to $t0 from $fp-416
	  lw $t1, -404($fp)	# fill _tmp455 to $t1 from $fp-404
	  or $t2, $t0, $t1	
	  sw $t2, -420($fp)	# spill _tmp459 from $t2 to $fp-420
	# IfZ _tmp459 Goto _L73
	  lw $t0, -420($fp)	# fill _tmp459 to $t0 from $fp-420
	  beqz $t0, _L73	# branch if _tmp459 is zero 
	# _tmp460 = "Decaf runtime error: Array subscript out of bound..."
	  .data			# create string constant marked with label
	  _string33: .asciiz "Decaf runtime error: Array subscript out of bounds\n"
	  .text
	  la $t2, _string33	# load label
	  sw $t2, -424($fp)	# spill _tmp460 from $t2 to $fp-424
	# PushParam _tmp460
	  subu $sp, $sp, 4	# decrement sp to make space for param
	  lw $t0, -424($fp)	# fill _tmp460 to $t0 from $fp-424
	  sw $t0, 4($sp)	# copy param value to stack
	# LCall _PrintString
	  jal _PrintString   	# jump to function
	# PopParams 4
	  add $sp, $sp, 4	# pop params off stack
	# LCall _Halt
	  jal _Halt          	# jump to function
  _L73:
	# _tmp461 = 4
	  li $t2, 4		# load constant value 4 into $t2
	  sw $t2, -428($fp)	# spill _tmp461 from $t2 to $fp-428
	# _tmp462 = x * _tmp461
	  lw $t0, 8($fp)	# fill x to $t0 from $fp+8
	  lw $t1, -428($fp)	# fill _tmp461 to $t1 from $fp-428
	  mul $t2, $t0, $t1	
	  sw $t2, -432($fp)	# spill _tmp462 from $t2 to $fp-432
	# _tmp463 = _tmp462 + _tmp461
	  lw $t0, -432($fp)	# fill _tmp462 to $t0 from $fp-432
	  lw $t1, -428($fp)	# fill _tmp461 to $t1 from $fp-428
	  add $t2, $t0, $t1	
	  sw $t2, -436($fp)	# spill _tmp463 from $t2 to $fp-436
	# _tmp464 = _tmp452 + _tmp463
	  lw $t0, -392($fp)	# fill _tmp452 to $t0 from $fp-392
	  lw $t1, -436($fp)	# fill _tmp463 to $t1 from $fp-436
	  add $t2, $t0, $t1	
	  sw $t2, -440($fp)	# spill _tmp464 from $t2 to $fp-440
	# _tmp465 = *(_tmp464)
	  lw $t0, -440($fp)	# fill _tmp464 to $t0 from $fp-440
	  lw $t2, 0($t0) 	# load with offset
	  sw $t2, -444($fp)	# spill _tmp465 from $t2 to $fp-444
	# _tmp466 = 0
	  li $t2, 0		# load constant value 0 into $t2
	  sw $t2, -448($fp)	# spill _tmp466 from $t2 to $fp-448
	# _tmp467 = *(_tmp465)
	  lw $t0, -444($fp)	# fill _tmp465 to $t0 from $fp-444
	  lw $t2, 0($t0) 	# load with offset
	  sw $t2, -452($fp)	# spill _tmp467 from $t2 to $fp-452
	# _tmp468 = y < _tmp466
	  lw $t0, 12($fp)	# fill y to $t0 from $fp+12
	  lw $t1, -448($fp)	# fill _tmp466 to $t1 from $fp-448
	  slt $t2, $t0, $t1	
	  sw $t2, -456($fp)	# spill _tmp468 from $t2 to $fp-456
	# _tmp469 = _tmp467 < y
	  lw $t0, -452($fp)	# fill _tmp467 to $t0 from $fp-452
	  lw $t1, 12($fp)	# fill y to $t1 from $fp+12
	  slt $t2, $t0, $t1	
	  sw $t2, -460($fp)	# spill _tmp469 from $t2 to $fp-460
	# _tmp470 = _tmp467 == y
	  lw $t0, -452($fp)	# fill _tmp467 to $t0 from $fp-452
	  lw $t1, 12($fp)	# fill y to $t1 from $fp+12
	  seq $t2, $t0, $t1	
	  sw $t2, -464($fp)	# spill _tmp470 from $t2 to $fp-464
	# _tmp471 = _tmp469 || _tmp470
	  lw $t0, -460($fp)	# fill _tmp469 to $t0 from $fp-460
	  lw $t1, -464($fp)	# fill _tmp470 to $t1 from $fp-464
	  or $t2, $t0, $t1	
	  sw $t2, -468($fp)	# spill _tmp471 from $t2 to $fp-468
	# _tmp472 = _tmp471 || _tmp468
	  lw $t0, -468($fp)	# fill _tmp471 to $t0 from $fp-468
	  lw $t1, -456($fp)	# fill _tmp468 to $t1 from $fp-456
	  or $t2, $t0, $t1	
	  sw $t2, -472($fp)	# spill _tmp472 from $t2 to $fp-472
	# IfZ _tmp472 Goto _L74
	  lw $t0, -472($fp)	# fill _tmp472 to $t0 from $fp-472
	  beqz $t0, _L74	# branch if _tmp472 is zero 
	# _tmp473 = "Decaf runtime error: Array subscript out of bound..."
	  .data			# create string constant marked with label
	  _string34: .asciiz "Decaf runtime error: Array subscript out of bounds\n"
	  .text
	  la $t2, _string34	# load label
	  sw $t2, -476($fp)	# spill _tmp473 from $t2 to $fp-476
	# PushParam _tmp473
	  subu $sp, $sp, 4	# decrement sp to make space for param
	  lw $t0, -476($fp)	# fill _tmp473 to $t0 from $fp-476
	  sw $t0, 4($sp)	# copy param value to stack
	# LCall _PrintString
	  jal _PrintString   	# jump to function
	# PopParams 4
	  add $sp, $sp, 4	# pop params off stack
	# LCall _Halt
	  jal _Halt          	# jump to function
  _L74:
	# _tmp474 = 4
	  li $t2, 4		# load constant value 4 into $t2
	  sw $t2, -480($fp)	# spill _tmp474 from $t2 to $fp-480
	# _tmp475 = y * _tmp474
	  lw $t0, 12($fp)	# fill y to $t0 from $fp+12
	  lw $t1, -480($fp)	# fill _tmp474 to $t1 from $fp-480
	  mul $t2, $t0, $t1	
	  sw $t2, -484($fp)	# spill _tmp475 from $t2 to $fp-484
	# _tmp476 = _tmp475 + _tmp474
	  lw $t0, -484($fp)	# fill _tmp475 to $t0 from $fp-484
	  lw $t1, -480($fp)	# fill _tmp474 to $t1 from $fp-480
	  add $t2, $t0, $t1	
	  sw $t2, -488($fp)	# spill _tmp476 from $t2 to $fp-488
	# _tmp477 = _tmp465 + _tmp476
	  lw $t0, -444($fp)	# fill _tmp465 to $t0 from $fp-444
	  lw $t1, -488($fp)	# fill _tmp476 to $t1 from $fp-488
	  add $t2, $t0, $t1	
	  sw $t2, -492($fp)	# spill _tmp477 from $t2 to $fp-492
	# _tmp478 = *(_tmp477)
	  lw $t0, -492($fp)	# fill _tmp477 to $t0 from $fp-492
	  lw $t2, 0($t0) 	# load with offset
	  sw $t2, -496($fp)	# spill _tmp478 from $t2 to $fp-496
	# PushParam _tmp478
	  subu $sp, $sp, 4	# decrement sp to make space for param
	  lw $t0, -496($fp)	# fill _tmp478 to $t0 from $fp-496
	  sw $t0, 4($sp)	# copy param value to stack
	# _tmp479 = *(_tmp478)
	  lw $t0, -496($fp)	# fill _tmp478 to $t0 from $fp-496
	  lw $t2, 0($t0) 	# load with offset
	  sw $t2, -500($fp)	# spill _tmp479 from $t2 to $fp-500
	# _tmp480 = *(_tmp479 + 28)
	  lw $t0, -500($fp)	# fill _tmp479 to $t0 from $fp-500
	  lw $t2, 28($t0) 	# load with offset
	  sw $t2, -504($fp)	# spill _tmp480 from $t2 to $fp-504
	# _tmp481 = ACall _tmp480
	  lw $t0, -504($fp)	# fill _tmp480 to $t0 from $fp-504
	  jalr $t0            	# jump to function
	  move $t2, $v0		# copy function return value from $v0
	  sw $t2, -508($fp)	# spill _tmp481 from $t2 to $fp-508
	# PopParams 4
	  add $sp, $sp, 4	# pop params off stack
	# _tmp482 = 0
	  li $t2, 0		# load constant value 0 into $t2
	  sw $t2, -512($fp)	# spill _tmp482 from $t2 to $fp-512
	# _tmp483 = _tmp481 == _tmp482
	  lw $t0, -508($fp)	# fill _tmp481 to $t0 from $fp-508
	  lw $t1, -512($fp)	# fill _tmp482 to $t1 from $fp-512
	  seq $t2, $t0, $t1	
	  sw $t2, -516($fp)	# spill _tmp483 from $t2 to $fp-516
	# IfZ _tmp483 Goto _L72
	  lw $t0, -516($fp)	# fill _tmp483 to $t0 from $fp-516
	  beqz $t0, _L72	# branch if _tmp483 is zero 
	# _tmp484 = 0
	  li $t2, 0		# load constant value 0 into $t2
	  sw $t2, -520($fp)	# spill _tmp484 from $t2 to $fp-520
	# _tmp451 = _tmp484
	  lw $t2, -520($fp)	# fill _tmp484 to $t2 from $fp-520
	  sw $t2, -388($fp)	# spill _tmp451 from $t2 to $fp-388
	# Goto _L71
	  b _L71		# unconditional branch
  _L72:
	# _tmp485 = 1
	  li $t2, 1		# load constant value 1 into $t2
	  sw $t2, -524($fp)	# spill _tmp485 from $t2 to $fp-524
	# _tmp451 = _tmp485
	  lw $t2, -524($fp)	# fill _tmp485 to $t2 from $fp-524
	  sw $t2, -388($fp)	# spill _tmp451 from $t2 to $fp-388
  _L71:
	# IfZ _tmp451 Goto _L69
	  lw $t0, -388($fp)	# fill _tmp451 to $t0 from $fp-388
	  beqz $t0, _L69	# branch if _tmp451 is zero 
	# Return 
	  move $sp, $fp		# pop callee frame off stack
	  lw $ra, -4($fp)	# restore saved ra
	  lw $fp, 0($fp)	# restore saved fp
	  jr $ra		# return from function
	# Goto _L70
	  b _L70		# unconditional branch
  _L69:
  _L70:
	# _tmp486 = 1
	  li $t2, 1		# load constant value 1 into $t2
	  sw $t2, -528($fp)	# spill _tmp486 from $t2 to $fp-528
	# _tmp487 = x - _tmp486
	  lw $t0, 8($fp)	# fill x to $t0 from $fp+8
	  lw $t1, -528($fp)	# fill _tmp486 to $t1 from $fp-528
	  sub $t2, $t0, $t1	
	  sw $t2, -532($fp)	# spill _tmp487 from $t2 to $fp-532
	# i = _tmp487
	  lw $t2, -532($fp)	# fill _tmp487 to $t2 from $fp-532
	  sw $t2, -8($fp)	# spill i from $t2 to $fp-8
  _L75:
	# _tmp488 = 1
	  li $t2, 1		# load constant value 1 into $t2
	  sw $t2, -536($fp)	# spill _tmp488 from $t2 to $fp-536
	# _tmp489 = x + _tmp488
	  lw $t0, 8($fp)	# fill x to $t0 from $fp+8
	  lw $t1, -536($fp)	# fill _tmp488 to $t1 from $fp-536
	  add $t2, $t0, $t1	
	  sw $t2, -540($fp)	# spill _tmp489 from $t2 to $fp-540
	# _tmp490 = i < _tmp489
	  lw $t0, -8($fp)	# fill i to $t0 from $fp-8
	  lw $t1, -540($fp)	# fill _tmp489 to $t1 from $fp-540
	  slt $t2, $t0, $t1	
	  sw $t2, -544($fp)	# spill _tmp490 from $t2 to $fp-544
	# _tmp491 = i == _tmp489
	  lw $t0, -8($fp)	# fill i to $t0 from $fp-8
	  lw $t1, -540($fp)	# fill _tmp489 to $t1 from $fp-540
	  seq $t2, $t0, $t1	
	  sw $t2, -548($fp)	# spill _tmp491 from $t2 to $fp-548
	# _tmp492 = _tmp490 || _tmp491
	  lw $t0, -544($fp)	# fill _tmp490 to $t0 from $fp-544
	  lw $t1, -548($fp)	# fill _tmp491 to $t1 from $fp-548
	  or $t2, $t0, $t1	
	  sw $t2, -552($fp)	# spill _tmp492 from $t2 to $fp-552
	# IfZ _tmp492 Goto _L76
	  lw $t0, -552($fp)	# fill _tmp492 to $t0 from $fp-552
	  beqz $t0, _L76	# branch if _tmp492 is zero 
	# _tmp493 = 1
	  li $t2, 1		# load constant value 1 into $t2
	  sw $t2, -556($fp)	# spill _tmp493 from $t2 to $fp-556
	# _tmp494 = y - _tmp493
	  lw $t0, 12($fp)	# fill y to $t0 from $fp+12
	  lw $t1, -556($fp)	# fill _tmp493 to $t1 from $fp-556
	  sub $t2, $t0, $t1	
	  sw $t2, -560($fp)	# spill _tmp494 from $t2 to $fp-560
	# j = _tmp494
	  lw $t2, -560($fp)	# fill _tmp494 to $t2 from $fp-560
	  sw $t2, -12($fp)	# spill j from $t2 to $fp-12
  _L77:
	# _tmp495 = 1
	  li $t2, 1		# load constant value 1 into $t2
	  sw $t2, -564($fp)	# spill _tmp495 from $t2 to $fp-564
	# _tmp496 = y + _tmp495
	  lw $t0, 12($fp)	# fill y to $t0 from $fp+12
	  lw $t1, -564($fp)	# fill _tmp495 to $t1 from $fp-564
	  add $t2, $t0, $t1	
	  sw $t2, -568($fp)	# spill _tmp496 from $t2 to $fp-568
	# _tmp497 = j < _tmp496
	  lw $t0, -12($fp)	# fill j to $t0 from $fp-12
	  lw $t1, -568($fp)	# fill _tmp496 to $t1 from $fp-568
	  slt $t2, $t0, $t1	
	  sw $t2, -572($fp)	# spill _tmp497 from $t2 to $fp-572
	# _tmp498 = j == _tmp496
	  lw $t0, -12($fp)	# fill j to $t0 from $fp-12
	  lw $t1, -568($fp)	# fill _tmp496 to $t1 from $fp-568
	  seq $t2, $t0, $t1	
	  sw $t2, -576($fp)	# spill _tmp498 from $t2 to $fp-576
	# _tmp499 = _tmp497 || _tmp498
	  lw $t0, -572($fp)	# fill _tmp497 to $t0 from $fp-572
	  lw $t1, -576($fp)	# fill _tmp498 to $t1 from $fp-576
	  or $t2, $t0, $t1	
	  sw $t2, -580($fp)	# spill _tmp499 from $t2 to $fp-580
	# IfZ _tmp499 Goto _L78
	  lw $t0, -580($fp)	# fill _tmp499 to $t0 from $fp-580
	  beqz $t0, _L78	# branch if _tmp499 is zero 
	# _tmp500 = 0
	  li $t2, 0		# load constant value 0 into $t2
	  sw $t2, -584($fp)	# spill _tmp500 from $t2 to $fp-584
	# _tmp501 = _tmp500 < i
	  lw $t0, -584($fp)	# fill _tmp500 to $t0 from $fp-584
	  lw $t1, -8($fp)	# fill i to $t1 from $fp-8
	  slt $t2, $t0, $t1	
	  sw $t2, -588($fp)	# spill _tmp501 from $t2 to $fp-588
	# _tmp502 = _tmp500 == i
	  lw $t0, -584($fp)	# fill _tmp500 to $t0 from $fp-584
	  lw $t1, -8($fp)	# fill i to $t1 from $fp-8
	  seq $t2, $t0, $t1	
	  sw $t2, -592($fp)	# spill _tmp502 from $t2 to $fp-592
	# _tmp503 = _tmp501 || _tmp502
	  lw $t0, -588($fp)	# fill _tmp501 to $t0 from $fp-588
	  lw $t1, -592($fp)	# fill _tmp502 to $t1 from $fp-592
	  or $t2, $t0, $t1	
	  sw $t2, -596($fp)	# spill _tmp503 from $t2 to $fp-596
	# _tmp504 = *(this + 8)
	  lw $t0, 4($fp)	# fill this to $t0 from $fp+4
	  lw $t2, 8($t0) 	# load with offset
	  sw $t2, -600($fp)	# spill _tmp504 from $t2 to $fp-600
	# _tmp505 = i < _tmp504
	  lw $t0, -8($fp)	# fill i to $t0 from $fp-8
	  lw $t1, -600($fp)	# fill _tmp504 to $t1 from $fp-600
	  slt $t2, $t0, $t1	
	  sw $t2, -604($fp)	# spill _tmp505 from $t2 to $fp-604
	# _tmp506 = _tmp503 && _tmp505
	  lw $t0, -596($fp)	# fill _tmp503 to $t0 from $fp-596
	  lw $t1, -604($fp)	# fill _tmp505 to $t1 from $fp-604
	  and $t2, $t0, $t1	
	  sw $t2, -608($fp)	# spill _tmp506 from $t2 to $fp-608
	# _tmp507 = 0
	  li $t2, 0		# load constant value 0 into $t2
	  sw $t2, -612($fp)	# spill _tmp507 from $t2 to $fp-612
	# _tmp508 = _tmp507 < j
	  lw $t0, -612($fp)	# fill _tmp507 to $t0 from $fp-612
	  lw $t1, -12($fp)	# fill j to $t1 from $fp-12
	  slt $t2, $t0, $t1	
	  sw $t2, -616($fp)	# spill _tmp508 from $t2 to $fp-616
	# _tmp509 = _tmp507 == j
	  lw $t0, -612($fp)	# fill _tmp507 to $t0 from $fp-612
	  lw $t1, -12($fp)	# fill j to $t1 from $fp-12
	  seq $t2, $t0, $t1	
	  sw $t2, -620($fp)	# spill _tmp509 from $t2 to $fp-620
	# _tmp510 = _tmp508 || _tmp509
	  lw $t0, -616($fp)	# fill _tmp508 to $t0 from $fp-616
	  lw $t1, -620($fp)	# fill _tmp509 to $t1 from $fp-620
	  or $t2, $t0, $t1	
	  sw $t2, -624($fp)	# spill _tmp510 from $t2 to $fp-624
	# _tmp511 = _tmp506 && _tmp510
	  lw $t0, -608($fp)	# fill _tmp506 to $t0 from $fp-608
	  lw $t1, -624($fp)	# fill _tmp510 to $t1 from $fp-624
	  and $t2, $t0, $t1	
	  sw $t2, -628($fp)	# spill _tmp511 from $t2 to $fp-628
	# _tmp512 = *(this + 4)
	  lw $t0, 4($fp)	# fill this to $t0 from $fp+4
	  lw $t2, 4($t0) 	# load with offset
	  sw $t2, -632($fp)	# spill _tmp512 from $t2 to $fp-632
	# _tmp513 = j < _tmp512
	  lw $t0, -12($fp)	# fill j to $t0 from $fp-12
	  lw $t1, -632($fp)	# fill _tmp512 to $t1 from $fp-632
	  slt $t2, $t0, $t1	
	  sw $t2, -636($fp)	# spill _tmp513 from $t2 to $fp-636
	# _tmp514 = _tmp511 && _tmp513
	  lw $t0, -628($fp)	# fill _tmp511 to $t0 from $fp-628
	  lw $t1, -636($fp)	# fill _tmp513 to $t1 from $fp-636
	  and $t2, $t0, $t1	
	  sw $t2, -640($fp)	# spill _tmp514 from $t2 to $fp-640
	# IfZ _tmp514 Goto _L79
	  lw $t0, -640($fp)	# fill _tmp514 to $t0 from $fp-640
	  beqz $t0, _L79	# branch if _tmp514 is zero 
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
	# _tmp515 = *(this)
	  lw $t0, 4($fp)	# fill this to $t0 from $fp+4
	  lw $t2, 0($t0) 	# load with offset
	  sw $t2, -644($fp)	# spill _tmp515 from $t2 to $fp-644
	# _tmp516 = *(_tmp515 + 24)
	  lw $t0, -644($fp)	# fill _tmp515 to $t0 from $fp-644
	  lw $t2, 24($t0) 	# load with offset
	  sw $t2, -648($fp)	# spill _tmp516 from $t2 to $fp-648
	# ACall _tmp516
	  lw $t0, -648($fp)	# fill _tmp516 to $t0 from $fp-648
	  jalr $t0            	# jump to function
	# PopParams 12
	  add $sp, $sp, 12	# pop params off stack
	# Goto _L80
	  b _L80		# unconditional branch
  _L79:
  _L80:
	# _tmp517 = 1
	  li $t2, 1		# load constant value 1 into $t2
	  sw $t2, -652($fp)	# spill _tmp517 from $t2 to $fp-652
	# _tmp518 = j + _tmp517
	  lw $t0, -12($fp)	# fill j to $t0 from $fp-12
	  lw $t1, -652($fp)	# fill _tmp517 to $t1 from $fp-652
	  add $t2, $t0, $t1	
	  sw $t2, -656($fp)	# spill _tmp518 from $t2 to $fp-656
	# j = _tmp518
	  lw $t2, -656($fp)	# fill _tmp518 to $t2 from $fp-656
	  sw $t2, -12($fp)	# spill j from $t2 to $fp-12
	# Goto _L77
	  b _L77		# unconditional branch
  _L78:
	# _tmp519 = 1
	  li $t2, 1		# load constant value 1 into $t2
	  sw $t2, -660($fp)	# spill _tmp519 from $t2 to $fp-660
	# _tmp520 = i + _tmp519
	  lw $t0, -8($fp)	# fill i to $t0 from $fp-8
	  lw $t1, -660($fp)	# fill _tmp519 to $t1 from $fp-660
	  add $t2, $t0, $t1	
	  sw $t2, -664($fp)	# spill _tmp520 from $t2 to $fp-664
	# i = _tmp520
	  lw $t2, -664($fp)	# fill _tmp520 to $t2 from $fp-664
	  sw $t2, -8($fp)	# spill i from $t2 to $fp-8
	# Goto _L75
	  b _L75		# unconditional branch
  _L76:
	# EndFunc
	# (below handles reaching end of fn body with no explicit return)
	  move $sp, $fp		# pop callee frame off stack
	  lw $ra, -4($fp)	# restore saved ra
	  lw $fp, 0($fp)	# restore saved fp
	  jr $ra		# return from function
  Field.____HasNotBlownUp:
	# BeginFunc 4
	  subu $sp, $sp, 8	# decrement sp to make space to save ra, fp
	  sw $fp, 8($sp)	# save fp
	  sw $ra, 4($sp)	# save ra
	  addiu $fp, $sp, 8	# set up new fp
	  subu $sp, $sp, 4	# decrement sp to make space for locals/temps
	# _tmp521 = *(this + 16)
	  lw $t0, 4($fp)	# fill this to $t0 from $fp+4
	  lw $t2, 16($t0) 	# load with offset
	  sw $t2, -8($fp)	# spill _tmp521 from $t2 to $fp-8
	# Return _tmp521
	  lw $t2, -8($fp)	# fill _tmp521 to $t2 from $fp-8
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
  Field.____HasClearedEverything:
	# BeginFunc 12
	  subu $sp, $sp, 8	# decrement sp to make space to save ra, fp
	  sw $fp, 8($sp)	# save fp
	  sw $ra, 4($sp)	# save ra
	  addiu $fp, $sp, 8	# set up new fp
	  subu $sp, $sp, 12	# decrement sp to make space for locals/temps
	# _tmp522 = *(this + 24)
	  lw $t0, 4($fp)	# fill this to $t0 from $fp+4
	  lw $t2, 24($t0) 	# load with offset
	  sw $t2, -8($fp)	# spill _tmp522 from $t2 to $fp-8
	# _tmp523 = *(this + 20)
	  lw $t0, 4($fp)	# fill this to $t0 from $fp+4
	  lw $t2, 20($t0) 	# load with offset
	  sw $t2, -12($fp)	# spill _tmp523 from $t2 to $fp-12
	# _tmp524 = _tmp522 == _tmp523
	  lw $t0, -8($fp)	# fill _tmp522 to $t0 from $fp-8
	  lw $t1, -12($fp)	# fill _tmp523 to $t1 from $fp-12
	  seq $t2, $t0, $t1	
	  sw $t2, -16($fp)	# spill _tmp524 from $t2 to $fp-16
	# Return _tmp524
	  lw $t2, -16($fp)	# fill _tmp524 to $t2 from $fp-16
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
	# VTable for class Field
	  .data
	  .align 2
	  Field:		# label for class Field vtable
	  .word Field.____Init
	  .word Field.____GetWidth
	  .word Field.____GetHeight
	  .word Field.____PlantMines
	  .word Field.____PlantOneMine
	  .word Field.____PrintField
	  .word Field.____Expand
	  .word Field.____HasNotBlownUp
	  .word Field.____HasClearedEverything
	  .text
  Game.____Init:
	# BeginFunc 32
	  subu $sp, $sp, 8	# decrement sp to make space to save ra, fp
	  sw $fp, 8($sp)	# save fp
	  sw $ra, 4($sp)	# save ra
	  addiu $fp, $sp, 8	# set up new fp
	  subu $sp, $sp, 32	# decrement sp to make space for locals/temps
	# _tmp525 = 24
	  li $t2, 24		# load constant value 24 into $t2
	  sw $t2, -8($fp)	# spill _tmp525 from $t2 to $fp-8
	# _tmp526 = 4
	  li $t2, 4		# load constant value 4 into $t2
	  sw $t2, -12($fp)	# spill _tmp526 from $t2 to $fp-12
	# _tmp527 = _tmp526 + _tmp525
	  lw $t0, -12($fp)	# fill _tmp526 to $t0 from $fp-12
	  lw $t1, -8($fp)	# fill _tmp525 to $t1 from $fp-8
	  add $t2, $t0, $t1	
	  sw $t2, -16($fp)	# spill _tmp527 from $t2 to $fp-16
	# PushParam _tmp527
	  subu $sp, $sp, 4	# decrement sp to make space for param
	  lw $t0, -16($fp)	# fill _tmp527 to $t0 from $fp-16
	  sw $t0, 4($sp)	# copy param value to stack
	# _tmp528 = LCall _Alloc
	  jal _Alloc         	# jump to function
	  move $t2, $v0		# copy function return value from $v0
	  sw $t2, -20($fp)	# spill _tmp528 from $t2 to $fp-20
	# PopParams 4
	  add $sp, $sp, 4	# pop params off stack
	# _tmp529 = Field
	  la $t2, Field	# load label
	  sw $t2, -24($fp)	# spill _tmp529 from $t2 to $fp-24
	# *(_tmp528) = _tmp529
	  lw $t0, -24($fp)	# fill _tmp529 to $t0 from $fp-24
	  lw $t2, -20($fp)	# fill _tmp528 to $t2 from $fp-20
	  sw $t0, 0($t2) 	# store with offset
	# *(this + 4) = _tmp528
	  lw $t0, -20($fp)	# fill _tmp528 to $t0 from $fp-20
	  lw $t2, 4($fp)	# fill this to $t2 from $fp+4
	  sw $t0, 4($t2) 	# store with offset
	# PushParam height
	  subu $sp, $sp, 4	# decrement sp to make space for param
	  lw $t0, 12($fp)	# fill height to $t0 from $fp+12
	  sw $t0, 4($sp)	# copy param value to stack
	# PushParam width
	  subu $sp, $sp, 4	# decrement sp to make space for param
	  lw $t0, 8($fp)	# fill width to $t0 from $fp+8
	  sw $t0, 4($sp)	# copy param value to stack
	# _tmp530 = *(this + 4)
	  lw $t0, 4($fp)	# fill this to $t0 from $fp+4
	  lw $t2, 4($t0) 	# load with offset
	  sw $t2, -28($fp)	# spill _tmp530 from $t2 to $fp-28
	# PushParam _tmp530
	  subu $sp, $sp, 4	# decrement sp to make space for param
	  lw $t0, -28($fp)	# fill _tmp530 to $t0 from $fp-28
	  sw $t0, 4($sp)	# copy param value to stack
	# _tmp531 = *(_tmp530)
	  lw $t0, -28($fp)	# fill _tmp530 to $t0 from $fp-28
	  lw $t2, 0($t0) 	# load with offset
	  sw $t2, -32($fp)	# spill _tmp531 from $t2 to $fp-32
	# _tmp532 = *(_tmp531)
	  lw $t0, -32($fp)	# fill _tmp531 to $t0 from $fp-32
	  lw $t2, 0($t0) 	# load with offset
	  sw $t2, -36($fp)	# spill _tmp532 from $t2 to $fp-36
	# ACall _tmp532
	  lw $t0, -36($fp)	# fill _tmp532 to $t0 from $fp-36
	  jalr $t0            	# jump to function
	# PopParams 12
	  add $sp, $sp, 12	# pop params off stack
	# EndFunc
	# (below handles reaching end of fn body with no explicit return)
	  move $sp, $fp		# pop callee frame off stack
	  lw $ra, -4($fp)	# restore saved ra
	  lw $fp, 0($fp)	# restore saved fp
	  jr $ra		# return from function
  Game.____PlayGame:
	# BeginFunc 288
	  subu $sp, $sp, 8	# decrement sp to make space to save ra, fp
	  sw $fp, 8($sp)	# save fp
	  sw $ra, 4($sp)	# save ra
	  addiu $fp, $sp, 8	# set up new fp
	  subu $sp, $sp, 288	# decrement sp to make space for locals/temps
  _L81:
	# _tmp533 = *(this + 4)
	  lw $t0, 4($fp)	# fill this to $t0 from $fp+4
	  lw $t2, 4($t0) 	# load with offset
	  sw $t2, -16($fp)	# spill _tmp533 from $t2 to $fp-16
	# PushParam _tmp533
	  subu $sp, $sp, 4	# decrement sp to make space for param
	  lw $t0, -16($fp)	# fill _tmp533 to $t0 from $fp-16
	  sw $t0, 4($sp)	# copy param value to stack
	# _tmp534 = *(_tmp533)
	  lw $t0, -16($fp)	# fill _tmp533 to $t0 from $fp-16
	  lw $t2, 0($t0) 	# load with offset
	  sw $t2, -20($fp)	# spill _tmp534 from $t2 to $fp-20
	# _tmp535 = *(_tmp534 + 28)
	  lw $t0, -20($fp)	# fill _tmp534 to $t0 from $fp-20
	  lw $t2, 28($t0) 	# load with offset
	  sw $t2, -24($fp)	# spill _tmp535 from $t2 to $fp-24
	# _tmp536 = ACall _tmp535
	  lw $t0, -24($fp)	# fill _tmp535 to $t0 from $fp-24
	  jalr $t0            	# jump to function
	  move $t2, $v0		# copy function return value from $v0
	  sw $t2, -28($fp)	# spill _tmp536 from $t2 to $fp-28
	# PopParams 4
	  add $sp, $sp, 4	# pop params off stack
	# _tmp538 = *(this + 4)
	  lw $t0, 4($fp)	# fill this to $t0 from $fp+4
	  lw $t2, 4($t0) 	# load with offset
	  sw $t2, -36($fp)	# spill _tmp538 from $t2 to $fp-36
	# PushParam _tmp538
	  subu $sp, $sp, 4	# decrement sp to make space for param
	  lw $t0, -36($fp)	# fill _tmp538 to $t0 from $fp-36
	  sw $t0, 4($sp)	# copy param value to stack
	# _tmp539 = *(_tmp538)
	  lw $t0, -36($fp)	# fill _tmp538 to $t0 from $fp-36
	  lw $t2, 0($t0) 	# load with offset
	  sw $t2, -40($fp)	# spill _tmp539 from $t2 to $fp-40
	# _tmp540 = *(_tmp539 + 32)
	  lw $t0, -40($fp)	# fill _tmp539 to $t0 from $fp-40
	  lw $t2, 32($t0) 	# load with offset
	  sw $t2, -44($fp)	# spill _tmp540 from $t2 to $fp-44
	# _tmp541 = ACall _tmp540
	  lw $t0, -44($fp)	# fill _tmp540 to $t0 from $fp-44
	  jalr $t0            	# jump to function
	  move $t2, $v0		# copy function return value from $v0
	  sw $t2, -48($fp)	# spill _tmp541 from $t2 to $fp-48
	# PopParams 4
	  add $sp, $sp, 4	# pop params off stack
	# IfZ _tmp541 Goto _L84
	  lw $t0, -48($fp)	# fill _tmp541 to $t0 from $fp-48
	  beqz $t0, _L84	# branch if _tmp541 is zero 
	# _tmp542 = 0
	  li $t2, 0		# load constant value 0 into $t2
	  sw $t2, -52($fp)	# spill _tmp542 from $t2 to $fp-52
	# _tmp537 = _tmp542
	  lw $t2, -52($fp)	# fill _tmp542 to $t2 from $fp-52
	  sw $t2, -32($fp)	# spill _tmp537 from $t2 to $fp-32
	# Goto _L83
	  b _L83		# unconditional branch
  _L84:
	# _tmp543 = 1
	  li $t2, 1		# load constant value 1 into $t2
	  sw $t2, -56($fp)	# spill _tmp543 from $t2 to $fp-56
	# _tmp537 = _tmp543
	  lw $t2, -56($fp)	# fill _tmp543 to $t2 from $fp-56
	  sw $t2, -32($fp)	# spill _tmp537 from $t2 to $fp-32
  _L83:
	# _tmp544 = _tmp536 && _tmp537
	  lw $t0, -28($fp)	# fill _tmp536 to $t0 from $fp-28
	  lw $t1, -32($fp)	# fill _tmp537 to $t1 from $fp-32
	  and $t2, $t0, $t1	
	  sw $t2, -60($fp)	# spill _tmp544 from $t2 to $fp-60
	# IfZ _tmp544 Goto _L82
	  lw $t0, -60($fp)	# fill _tmp544 to $t0 from $fp-60
	  beqz $t0, _L82	# branch if _tmp544 is zero 
	# _tmp545 = 0
	  li $t2, 0		# load constant value 0 into $t2
	  sw $t2, -64($fp)	# spill _tmp545 from $t2 to $fp-64
	# PushParam _tmp545
	  subu $sp, $sp, 4	# decrement sp to make space for param
	  lw $t0, -64($fp)	# fill _tmp545 to $t0 from $fp-64
	  sw $t0, 4($sp)	# copy param value to stack
	# _tmp546 = *(this + 4)
	  lw $t0, 4($fp)	# fill this to $t0 from $fp+4
	  lw $t2, 4($t0) 	# load with offset
	  sw $t2, -68($fp)	# spill _tmp546 from $t2 to $fp-68
	# PushParam _tmp546
	  subu $sp, $sp, 4	# decrement sp to make space for param
	  lw $t0, -68($fp)	# fill _tmp546 to $t0 from $fp-68
	  sw $t0, 4($sp)	# copy param value to stack
	# _tmp547 = *(_tmp546)
	  lw $t0, -68($fp)	# fill _tmp546 to $t0 from $fp-68
	  lw $t2, 0($t0) 	# load with offset
	  sw $t2, -72($fp)	# spill _tmp547 from $t2 to $fp-72
	# _tmp548 = *(_tmp547 + 20)
	  lw $t0, -72($fp)	# fill _tmp547 to $t0 from $fp-72
	  lw $t2, 20($t0) 	# load with offset
	  sw $t2, -76($fp)	# spill _tmp548 from $t2 to $fp-76
	# ACall _tmp548
	  lw $t0, -76($fp)	# fill _tmp548 to $t0 from $fp-76
	  jalr $t0            	# jump to function
	# PopParams 8
	  add $sp, $sp, 8	# pop params off stack
	# _tmp549 = "Enter horizontal coordinate, -1 to quit, -2 for h..."
	  .data			# create string constant marked with label
	  _string35: .asciiz "Enter horizontal coordinate, -1 to quit, -2 for help, -3 for grid: "
	  .text
	  la $t2, _string35	# load label
	  sw $t2, -80($fp)	# spill _tmp549 from $t2 to $fp-80
	# _tmp550 = 3
	  li $t2, 3		# load constant value 3 into $t2
	  sw $t2, -84($fp)	# spill _tmp550 from $t2 to $fp-84
	# _tmp551 = 0
	  li $t2, 0		# load constant value 0 into $t2
	  sw $t2, -88($fp)	# spill _tmp551 from $t2 to $fp-88
	# _tmp552 = _tmp551 - _tmp550
	  lw $t0, -88($fp)	# fill _tmp551 to $t0 from $fp-88
	  lw $t1, -84($fp)	# fill _tmp550 to $t1 from $fp-84
	  sub $t2, $t0, $t1	
	  sw $t2, -92($fp)	# spill _tmp552 from $t2 to $fp-92
	# _tmp553 = *(this + 4)
	  lw $t0, 4($fp)	# fill this to $t0 from $fp+4
	  lw $t2, 4($t0) 	# load with offset
	  sw $t2, -96($fp)	# spill _tmp553 from $t2 to $fp-96
	# PushParam _tmp553
	  subu $sp, $sp, 4	# decrement sp to make space for param
	  lw $t0, -96($fp)	# fill _tmp553 to $t0 from $fp-96
	  sw $t0, 4($sp)	# copy param value to stack
	# _tmp554 = *(_tmp553)
	  lw $t0, -96($fp)	# fill _tmp553 to $t0 from $fp-96
	  lw $t2, 0($t0) 	# load with offset
	  sw $t2, -100($fp)	# spill _tmp554 from $t2 to $fp-100
	# _tmp555 = *(_tmp554 + 4)
	  lw $t0, -100($fp)	# fill _tmp554 to $t0 from $fp-100
	  lw $t2, 4($t0) 	# load with offset
	  sw $t2, -104($fp)	# spill _tmp555 from $t2 to $fp-104
	# _tmp556 = ACall _tmp555
	  lw $t0, -104($fp)	# fill _tmp555 to $t0 from $fp-104
	  jalr $t0            	# jump to function
	  move $t2, $v0		# copy function return value from $v0
	  sw $t2, -108($fp)	# spill _tmp556 from $t2 to $fp-108
	# PopParams 4
	  add $sp, $sp, 4	# pop params off stack
	# _tmp557 = 1
	  li $t2, 1		# load constant value 1 into $t2
	  sw $t2, -112($fp)	# spill _tmp557 from $t2 to $fp-112
	# _tmp558 = _tmp556 - _tmp557
	  lw $t0, -108($fp)	# fill _tmp556 to $t0 from $fp-108
	  lw $t1, -112($fp)	# fill _tmp557 to $t1 from $fp-112
	  sub $t2, $t0, $t1	
	  sw $t2, -116($fp)	# spill _tmp558 from $t2 to $fp-116
	# PushParam _tmp558
	  subu $sp, $sp, 4	# decrement sp to make space for param
	  lw $t0, -116($fp)	# fill _tmp558 to $t0 from $fp-116
	  sw $t0, 4($sp)	# copy param value to stack
	# PushParam _tmp552
	  subu $sp, $sp, 4	# decrement sp to make space for param
	  lw $t0, -92($fp)	# fill _tmp552 to $t0 from $fp-92
	  sw $t0, 4($sp)	# copy param value to stack
	# PushParam _tmp549
	  subu $sp, $sp, 4	# decrement sp to make space for param
	  lw $t0, -80($fp)	# fill _tmp549 to $t0 from $fp-80
	  sw $t0, 4($sp)	# copy param value to stack
	# PushParam this
	  subu $sp, $sp, 4	# decrement sp to make space for param
	  lw $t0, 4($fp)	# fill this to $t0 from $fp+4
	  sw $t0, 4($sp)	# copy param value to stack
	# _tmp559 = *(this)
	  lw $t0, 4($fp)	# fill this to $t0 from $fp+4
	  lw $t2, 0($t0) 	# load with offset
	  sw $t2, -120($fp)	# spill _tmp559 from $t2 to $fp-120
	# _tmp560 = *(_tmp559 + 8)
	  lw $t0, -120($fp)	# fill _tmp559 to $t0 from $fp-120
	  lw $t2, 8($t0) 	# load with offset
	  sw $t2, -124($fp)	# spill _tmp560 from $t2 to $fp-124
	# _tmp561 = ACall _tmp560
	  lw $t0, -124($fp)	# fill _tmp560 to $t0 from $fp-124
	  jalr $t0            	# jump to function
	  move $t2, $v0		# copy function return value from $v0
	  sw $t2, -128($fp)	# spill _tmp561 from $t2 to $fp-128
	# PopParams 16
	  add $sp, $sp, 16	# pop params off stack
	# x = _tmp561
	  lw $t2, -128($fp)	# fill _tmp561 to $t2 from $fp-128
	  sw $t2, -8($fp)	# spill x from $t2 to $fp-8
	# _tmp562 = 1
	  li $t2, 1		# load constant value 1 into $t2
	  sw $t2, -132($fp)	# spill _tmp562 from $t2 to $fp-132
	# _tmp563 = 0
	  li $t2, 0		# load constant value 0 into $t2
	  sw $t2, -136($fp)	# spill _tmp563 from $t2 to $fp-136
	# _tmp564 = _tmp563 - _tmp562
	  lw $t0, -136($fp)	# fill _tmp563 to $t0 from $fp-136
	  lw $t1, -132($fp)	# fill _tmp562 to $t1 from $fp-132
	  sub $t2, $t0, $t1	
	  sw $t2, -140($fp)	# spill _tmp564 from $t2 to $fp-140
	# _tmp565 = x == _tmp564
	  lw $t0, -8($fp)	# fill x to $t0 from $fp-8
	  lw $t1, -140($fp)	# fill _tmp564 to $t1 from $fp-140
	  seq $t2, $t0, $t1	
	  sw $t2, -144($fp)	# spill _tmp565 from $t2 to $fp-144
	# IfZ _tmp565 Goto _L85
	  lw $t0, -144($fp)	# fill _tmp565 to $t0 from $fp-144
	  beqz $t0, _L85	# branch if _tmp565 is zero 
	# Goto _L82
	  b _L82		# unconditional branch
	# Goto _L86
	  b _L86		# unconditional branch
  _L85:
  _L86:
	# _tmp566 = "Enter vertical coordinate, -1 to quit, -2 for hel..."
	  .data			# create string constant marked with label
	  _string36: .asciiz "Enter vertical coordinate, -1 to quit, -2 for help, -3 for grid: "
	  .text
	  la $t2, _string36	# load label
	  sw $t2, -148($fp)	# spill _tmp566 from $t2 to $fp-148
	# _tmp567 = 3
	  li $t2, 3		# load constant value 3 into $t2
	  sw $t2, -152($fp)	# spill _tmp567 from $t2 to $fp-152
	# _tmp568 = 0
	  li $t2, 0		# load constant value 0 into $t2
	  sw $t2, -156($fp)	# spill _tmp568 from $t2 to $fp-156
	# _tmp569 = _tmp568 - _tmp567
	  lw $t0, -156($fp)	# fill _tmp568 to $t0 from $fp-156
	  lw $t1, -152($fp)	# fill _tmp567 to $t1 from $fp-152
	  sub $t2, $t0, $t1	
	  sw $t2, -160($fp)	# spill _tmp569 from $t2 to $fp-160
	# _tmp570 = *(this + 4)
	  lw $t0, 4($fp)	# fill this to $t0 from $fp+4
	  lw $t2, 4($t0) 	# load with offset
	  sw $t2, -164($fp)	# spill _tmp570 from $t2 to $fp-164
	# PushParam _tmp570
	  subu $sp, $sp, 4	# decrement sp to make space for param
	  lw $t0, -164($fp)	# fill _tmp570 to $t0 from $fp-164
	  sw $t0, 4($sp)	# copy param value to stack
	# _tmp571 = *(_tmp570)
	  lw $t0, -164($fp)	# fill _tmp570 to $t0 from $fp-164
	  lw $t2, 0($t0) 	# load with offset
	  sw $t2, -168($fp)	# spill _tmp571 from $t2 to $fp-168
	# _tmp572 = *(_tmp571 + 8)
	  lw $t0, -168($fp)	# fill _tmp571 to $t0 from $fp-168
	  lw $t2, 8($t0) 	# load with offset
	  sw $t2, -172($fp)	# spill _tmp572 from $t2 to $fp-172
	# _tmp573 = ACall _tmp572
	  lw $t0, -172($fp)	# fill _tmp572 to $t0 from $fp-172
	  jalr $t0            	# jump to function
	  move $t2, $v0		# copy function return value from $v0
	  sw $t2, -176($fp)	# spill _tmp573 from $t2 to $fp-176
	# PopParams 4
	  add $sp, $sp, 4	# pop params off stack
	# _tmp574 = 1
	  li $t2, 1		# load constant value 1 into $t2
	  sw $t2, -180($fp)	# spill _tmp574 from $t2 to $fp-180
	# _tmp575 = _tmp573 - _tmp574
	  lw $t0, -176($fp)	# fill _tmp573 to $t0 from $fp-176
	  lw $t1, -180($fp)	# fill _tmp574 to $t1 from $fp-180
	  sub $t2, $t0, $t1	
	  sw $t2, -184($fp)	# spill _tmp575 from $t2 to $fp-184
	# PushParam _tmp575
	  subu $sp, $sp, 4	# decrement sp to make space for param
	  lw $t0, -184($fp)	# fill _tmp575 to $t0 from $fp-184
	  sw $t0, 4($sp)	# copy param value to stack
	# PushParam _tmp569
	  subu $sp, $sp, 4	# decrement sp to make space for param
	  lw $t0, -160($fp)	# fill _tmp569 to $t0 from $fp-160
	  sw $t0, 4($sp)	# copy param value to stack
	# PushParam _tmp566
	  subu $sp, $sp, 4	# decrement sp to make space for param
	  lw $t0, -148($fp)	# fill _tmp566 to $t0 from $fp-148
	  sw $t0, 4($sp)	# copy param value to stack
	# PushParam this
	  subu $sp, $sp, 4	# decrement sp to make space for param
	  lw $t0, 4($fp)	# fill this to $t0 from $fp+4
	  sw $t0, 4($sp)	# copy param value to stack
	# _tmp576 = *(this)
	  lw $t0, 4($fp)	# fill this to $t0 from $fp+4
	  lw $t2, 0($t0) 	# load with offset
	  sw $t2, -188($fp)	# spill _tmp576 from $t2 to $fp-188
	# _tmp577 = *(_tmp576 + 8)
	  lw $t0, -188($fp)	# fill _tmp576 to $t0 from $fp-188
	  lw $t2, 8($t0) 	# load with offset
	  sw $t2, -192($fp)	# spill _tmp577 from $t2 to $fp-192
	# _tmp578 = ACall _tmp577
	  lw $t0, -192($fp)	# fill _tmp577 to $t0 from $fp-192
	  jalr $t0            	# jump to function
	  move $t2, $v0		# copy function return value from $v0
	  sw $t2, -196($fp)	# spill _tmp578 from $t2 to $fp-196
	# PopParams 16
	  add $sp, $sp, 16	# pop params off stack
	# y = _tmp578
	  lw $t2, -196($fp)	# fill _tmp578 to $t2 from $fp-196
	  sw $t2, -12($fp)	# spill y from $t2 to $fp-12
	# _tmp579 = 1
	  li $t2, 1		# load constant value 1 into $t2
	  sw $t2, -200($fp)	# spill _tmp579 from $t2 to $fp-200
	# _tmp580 = 0
	  li $t2, 0		# load constant value 0 into $t2
	  sw $t2, -204($fp)	# spill _tmp580 from $t2 to $fp-204
	# _tmp581 = _tmp580 - _tmp579
	  lw $t0, -204($fp)	# fill _tmp580 to $t0 from $fp-204
	  lw $t1, -200($fp)	# fill _tmp579 to $t1 from $fp-200
	  sub $t2, $t0, $t1	
	  sw $t2, -208($fp)	# spill _tmp581 from $t2 to $fp-208
	# _tmp582 = y == _tmp581
	  lw $t0, -12($fp)	# fill y to $t0 from $fp-12
	  lw $t1, -208($fp)	# fill _tmp581 to $t1 from $fp-208
	  seq $t2, $t0, $t1	
	  sw $t2, -212($fp)	# spill _tmp582 from $t2 to $fp-212
	# IfZ _tmp582 Goto _L87
	  lw $t0, -212($fp)	# fill _tmp582 to $t0 from $fp-212
	  beqz $t0, _L87	# branch if _tmp582 is zero 
	# Goto _L82
	  b _L82		# unconditional branch
	# Goto _L88
	  b _L88		# unconditional branch
  _L87:
  _L88:
	# _tmp583 = "Clearing ("
	  .data			# create string constant marked with label
	  _string37: .asciiz "Clearing ("
	  .text
	  la $t2, _string37	# load label
	  sw $t2, -216($fp)	# spill _tmp583 from $t2 to $fp-216
	# PushParam _tmp583
	  subu $sp, $sp, 4	# decrement sp to make space for param
	  lw $t0, -216($fp)	# fill _tmp583 to $t0 from $fp-216
	  sw $t0, 4($sp)	# copy param value to stack
	# LCall _PrintString
	  jal _PrintString   	# jump to function
	# PopParams 4
	  add $sp, $sp, 4	# pop params off stack
	# PushParam x
	  subu $sp, $sp, 4	# decrement sp to make space for param
	  lw $t0, -8($fp)	# fill x to $t0 from $fp-8
	  sw $t0, 4($sp)	# copy param value to stack
	# LCall _PrintInt
	  jal _PrintInt      	# jump to function
	# PopParams 4
	  add $sp, $sp, 4	# pop params off stack
	# _tmp584 = ", "
	  .data			# create string constant marked with label
	  _string38: .asciiz ", "
	  .text
	  la $t2, _string38	# load label
	  sw $t2, -220($fp)	# spill _tmp584 from $t2 to $fp-220
	# PushParam _tmp584
	  subu $sp, $sp, 4	# decrement sp to make space for param
	  lw $t0, -220($fp)	# fill _tmp584 to $t0 from $fp-220
	  sw $t0, 4($sp)	# copy param value to stack
	# LCall _PrintString
	  jal _PrintString   	# jump to function
	# PopParams 4
	  add $sp, $sp, 4	# pop params off stack
	# PushParam y
	  subu $sp, $sp, 4	# decrement sp to make space for param
	  lw $t0, -12($fp)	# fill y to $t0 from $fp-12
	  sw $t0, 4($sp)	# copy param value to stack
	# LCall _PrintInt
	  jal _PrintInt      	# jump to function
	# PopParams 4
	  add $sp, $sp, 4	# pop params off stack
	# _tmp585 = ")\n"
	  .data			# create string constant marked with label
	  _string39: .asciiz ")\n"
	  .text
	  la $t2, _string39	# load label
	  sw $t2, -224($fp)	# spill _tmp585 from $t2 to $fp-224
	# PushParam _tmp585
	  subu $sp, $sp, 4	# decrement sp to make space for param
	  lw $t0, -224($fp)	# fill _tmp585 to $t0 from $fp-224
	  sw $t0, 4($sp)	# copy param value to stack
	# LCall _PrintString
	  jal _PrintString   	# jump to function
	# PopParams 4
	  add $sp, $sp, 4	# pop params off stack
	# PushParam y
	  subu $sp, $sp, 4	# decrement sp to make space for param
	  lw $t0, -12($fp)	# fill y to $t0 from $fp-12
	  sw $t0, 4($sp)	# copy param value to stack
	# PushParam x
	  subu $sp, $sp, 4	# decrement sp to make space for param
	  lw $t0, -8($fp)	# fill x to $t0 from $fp-8
	  sw $t0, 4($sp)	# copy param value to stack
	# _tmp586 = *(this + 4)
	  lw $t0, 4($fp)	# fill this to $t0 from $fp+4
	  lw $t2, 4($t0) 	# load with offset
	  sw $t2, -228($fp)	# spill _tmp586 from $t2 to $fp-228
	# PushParam _tmp586
	  subu $sp, $sp, 4	# decrement sp to make space for param
	  lw $t0, -228($fp)	# fill _tmp586 to $t0 from $fp-228
	  sw $t0, 4($sp)	# copy param value to stack
	# _tmp587 = *(_tmp586)
	  lw $t0, -228($fp)	# fill _tmp586 to $t0 from $fp-228
	  lw $t2, 0($t0) 	# load with offset
	  sw $t2, -232($fp)	# spill _tmp587 from $t2 to $fp-232
	# _tmp588 = *(_tmp587 + 24)
	  lw $t0, -232($fp)	# fill _tmp587 to $t0 from $fp-232
	  lw $t2, 24($t0) 	# load with offset
	  sw $t2, -236($fp)	# spill _tmp588 from $t2 to $fp-236
	# ACall _tmp588
	  lw $t0, -236($fp)	# fill _tmp588 to $t0 from $fp-236
	  jalr $t0            	# jump to function
	# PopParams 12
	  add $sp, $sp, 12	# pop params off stack
	# Goto _L81
	  b _L81		# unconditional branch
  _L82:
	# _tmp589 = *(this + 4)
	  lw $t0, 4($fp)	# fill this to $t0 from $fp+4
	  lw $t2, 4($t0) 	# load with offset
	  sw $t2, -240($fp)	# spill _tmp589 from $t2 to $fp-240
	# PushParam _tmp589
	  subu $sp, $sp, 4	# decrement sp to make space for param
	  lw $t0, -240($fp)	# fill _tmp589 to $t0 from $fp-240
	  sw $t0, 4($sp)	# copy param value to stack
	# _tmp590 = *(_tmp589)
	  lw $t0, -240($fp)	# fill _tmp589 to $t0 from $fp-240
	  lw $t2, 0($t0) 	# load with offset
	  sw $t2, -244($fp)	# spill _tmp590 from $t2 to $fp-244
	# _tmp591 = *(_tmp590 + 28)
	  lw $t0, -244($fp)	# fill _tmp590 to $t0 from $fp-244
	  lw $t2, 28($t0) 	# load with offset
	  sw $t2, -248($fp)	# spill _tmp591 from $t2 to $fp-248
	# _tmp592 = ACall _tmp591
	  lw $t0, -248($fp)	# fill _tmp591 to $t0 from $fp-248
	  jalr $t0            	# jump to function
	  move $t2, $v0		# copy function return value from $v0
	  sw $t2, -252($fp)	# spill _tmp592 from $t2 to $fp-252
	# PopParams 4
	  add $sp, $sp, 4	# pop params off stack
	# IfZ _tmp592 Goto _L89
	  lw $t0, -252($fp)	# fill _tmp592 to $t0 from $fp-252
	  beqz $t0, _L89	# branch if _tmp592 is zero 
	# PushParam this
	  subu $sp, $sp, 4	# decrement sp to make space for param
	  lw $t0, 4($fp)	# fill this to $t0 from $fp+4
	  sw $t0, 4($sp)	# copy param value to stack
	# _tmp593 = *(this)
	  lw $t0, 4($fp)	# fill this to $t0 from $fp+4
	  lw $t2, 0($t0) 	# load with offset
	  sw $t2, -256($fp)	# spill _tmp593 from $t2 to $fp-256
	# _tmp594 = *(_tmp593 + 12)
	  lw $t0, -256($fp)	# fill _tmp593 to $t0 from $fp-256
	  lw $t2, 12($t0) 	# load with offset
	  sw $t2, -260($fp)	# spill _tmp594 from $t2 to $fp-260
	# ACall _tmp594
	  lw $t0, -260($fp)	# fill _tmp594 to $t0 from $fp-260
	  jalr $t0            	# jump to function
	# PopParams 4
	  add $sp, $sp, 4	# pop params off stack
	# Goto _L90
	  b _L90		# unconditional branch
  _L89:
	# PushParam this
	  subu $sp, $sp, 4	# decrement sp to make space for param
	  lw $t0, 4($fp)	# fill this to $t0 from $fp+4
	  sw $t0, 4($sp)	# copy param value to stack
	# _tmp595 = *(this)
	  lw $t0, 4($fp)	# fill this to $t0 from $fp+4
	  lw $t2, 0($t0) 	# load with offset
	  sw $t2, -264($fp)	# spill _tmp595 from $t2 to $fp-264
	# _tmp596 = *(_tmp595 + 16)
	  lw $t0, -264($fp)	# fill _tmp595 to $t0 from $fp-264
	  lw $t2, 16($t0) 	# load with offset
	  sw $t2, -268($fp)	# spill _tmp596 from $t2 to $fp-268
	# ACall _tmp596
	  lw $t0, -268($fp)	# fill _tmp596 to $t0 from $fp-268
	  jalr $t0            	# jump to function
	# PopParams 4
	  add $sp, $sp, 4	# pop params off stack
  _L90:
	# EndFunc
	# (below handles reaching end of fn body with no explicit return)
	  move $sp, $fp		# pop callee frame off stack
	  lw $ra, -4($fp)	# restore saved ra
	  lw $fp, 0($fp)	# restore saved fp
	  jr $ra		# return from function
  Game.____PromptForInt:
	# BeginFunc 140
	  subu $sp, $sp, 8	# decrement sp to make space to save ra, fp
	  sw $fp, 8($sp)	# save fp
	  sw $ra, 4($sp)	# save ra
	  addiu $fp, $sp, 8	# set up new fp
	  subu $sp, $sp, 140	# decrement sp to make space for locals/temps
  _L91:
	# _tmp597 = 1
	  li $t2, 1		# load constant value 1 into $t2
	  sw $t2, -12($fp)	# spill _tmp597 from $t2 to $fp-12
	# IfZ _tmp597 Goto _L92
	  lw $t0, -12($fp)	# fill _tmp597 to $t0 from $fp-12
	  beqz $t0, _L92	# branch if _tmp597 is zero 
	# PushParam prompt
	  subu $sp, $sp, 4	# decrement sp to make space for param
	  lw $t0, 8($fp)	# fill prompt to $t0 from $fp+8
	  sw $t0, 4($sp)	# copy param value to stack
	# LCall _PrintString
	  jal _PrintString   	# jump to function
	# PopParams 4
	  add $sp, $sp, 4	# pop params off stack
	# _tmp598 = LCall _ReadInteger
	  jal _ReadInteger   	# jump to function
	  move $t2, $v0		# copy function return value from $v0
	  sw $t2, -16($fp)	# spill _tmp598 from $t2 to $fp-16
	# x = _tmp598
	  lw $t2, -16($fp)	# fill _tmp598 to $t2 from $fp-16
	  sw $t2, -8($fp)	# spill x from $t2 to $fp-8
	# _tmp599 = min < x
	  lw $t0, 12($fp)	# fill min to $t0 from $fp+12
	  lw $t1, -8($fp)	# fill x to $t1 from $fp-8
	  slt $t2, $t0, $t1	
	  sw $t2, -20($fp)	# spill _tmp599 from $t2 to $fp-20
	# _tmp600 = min == x
	  lw $t0, 12($fp)	# fill min to $t0 from $fp+12
	  lw $t1, -8($fp)	# fill x to $t1 from $fp-8
	  seq $t2, $t0, $t1	
	  sw $t2, -24($fp)	# spill _tmp600 from $t2 to $fp-24
	# _tmp601 = _tmp599 || _tmp600
	  lw $t0, -20($fp)	# fill _tmp599 to $t0 from $fp-20
	  lw $t1, -24($fp)	# fill _tmp600 to $t1 from $fp-24
	  or $t2, $t0, $t1	
	  sw $t2, -28($fp)	# spill _tmp601 from $t2 to $fp-28
	# _tmp602 = x < max
	  lw $t0, -8($fp)	# fill x to $t0 from $fp-8
	  lw $t1, 16($fp)	# fill max to $t1 from $fp+16
	  slt $t2, $t0, $t1	
	  sw $t2, -32($fp)	# spill _tmp602 from $t2 to $fp-32
	# _tmp603 = x == max
	  lw $t0, -8($fp)	# fill x to $t0 from $fp-8
	  lw $t1, 16($fp)	# fill max to $t1 from $fp+16
	  seq $t2, $t0, $t1	
	  sw $t2, -36($fp)	# spill _tmp603 from $t2 to $fp-36
	# _tmp604 = _tmp602 || _tmp603
	  lw $t0, -32($fp)	# fill _tmp602 to $t0 from $fp-32
	  lw $t1, -36($fp)	# fill _tmp603 to $t1 from $fp-36
	  or $t2, $t0, $t1	
	  sw $t2, -40($fp)	# spill _tmp604 from $t2 to $fp-40
	# _tmp605 = _tmp601 && _tmp604
	  lw $t0, -28($fp)	# fill _tmp601 to $t0 from $fp-28
	  lw $t1, -40($fp)	# fill _tmp604 to $t1 from $fp-40
	  and $t2, $t0, $t1	
	  sw $t2, -44($fp)	# spill _tmp605 from $t2 to $fp-44
	# IfZ _tmp605 Goto _L93
	  lw $t0, -44($fp)	# fill _tmp605 to $t0 from $fp-44
	  beqz $t0, _L93	# branch if _tmp605 is zero 
	# _tmp606 = 1
	  li $t2, 1		# load constant value 1 into $t2
	  sw $t2, -48($fp)	# spill _tmp606 from $t2 to $fp-48
	# _tmp607 = 0
	  li $t2, 0		# load constant value 0 into $t2
	  sw $t2, -52($fp)	# spill _tmp607 from $t2 to $fp-52
	# _tmp608 = _tmp607 - _tmp606
	  lw $t0, -52($fp)	# fill _tmp607 to $t0 from $fp-52
	  lw $t1, -48($fp)	# fill _tmp606 to $t1 from $fp-48
	  sub $t2, $t0, $t1	
	  sw $t2, -56($fp)	# spill _tmp608 from $t2 to $fp-56
	# _tmp609 = x == _tmp608
	  lw $t0, -8($fp)	# fill x to $t0 from $fp-8
	  lw $t1, -56($fp)	# fill _tmp608 to $t1 from $fp-56
	  seq $t2, $t0, $t1	
	  sw $t2, -60($fp)	# spill _tmp609 from $t2 to $fp-60
	# IfZ _tmp609 Goto _L95
	  lw $t0, -60($fp)	# fill _tmp609 to $t0 from $fp-60
	  beqz $t0, _L95	# branch if _tmp609 is zero 
	# _tmp610 = 1
	  li $t2, 1		# load constant value 1 into $t2
	  sw $t2, -64($fp)	# spill _tmp610 from $t2 to $fp-64
	# _tmp611 = 0
	  li $t2, 0		# load constant value 0 into $t2
	  sw $t2, -68($fp)	# spill _tmp611 from $t2 to $fp-68
	# _tmp612 = _tmp611 - _tmp610
	  lw $t0, -68($fp)	# fill _tmp611 to $t0 from $fp-68
	  lw $t1, -64($fp)	# fill _tmp610 to $t1 from $fp-64
	  sub $t2, $t0, $t1	
	  sw $t2, -72($fp)	# spill _tmp612 from $t2 to $fp-72
	# Return _tmp612
	  lw $t2, -72($fp)	# fill _tmp612 to $t2 from $fp-72
	  move $v0, $t2		# assign return value into $v0
	  move $sp, $fp		# pop callee frame off stack
	  lw $ra, -4($fp)	# restore saved ra
	  lw $fp, 0($fp)	# restore saved fp
	  jr $ra		# return from function
	# Goto _L96
	  b _L96		# unconditional branch
  _L95:
  _L96:
	# _tmp613 = 2
	  li $t2, 2		# load constant value 2 into $t2
	  sw $t2, -76($fp)	# spill _tmp613 from $t2 to $fp-76
	# _tmp614 = 0
	  li $t2, 0		# load constant value 0 into $t2
	  sw $t2, -80($fp)	# spill _tmp614 from $t2 to $fp-80
	# _tmp615 = _tmp614 - _tmp613
	  lw $t0, -80($fp)	# fill _tmp614 to $t0 from $fp-80
	  lw $t1, -76($fp)	# fill _tmp613 to $t1 from $fp-76
	  sub $t2, $t0, $t1	
	  sw $t2, -84($fp)	# spill _tmp615 from $t2 to $fp-84
	# _tmp616 = x == _tmp615
	  lw $t0, -8($fp)	# fill x to $t0 from $fp-8
	  lw $t1, -84($fp)	# fill _tmp615 to $t1 from $fp-84
	  seq $t2, $t0, $t1	
	  sw $t2, -88($fp)	# spill _tmp616 from $t2 to $fp-88
	# IfZ _tmp616 Goto _L97
	  lw $t0, -88($fp)	# fill _tmp616 to $t0 from $fp-88
	  beqz $t0, _L97	# branch if _tmp616 is zero 
	# LCall ____PrintHelp
	  jal ____PrintHelp  	# jump to function
	# Goto _L98
	  b _L98		# unconditional branch
  _L97:
	# _tmp617 = 3
	  li $t2, 3		# load constant value 3 into $t2
	  sw $t2, -92($fp)	# spill _tmp617 from $t2 to $fp-92
	# _tmp618 = 0
	  li $t2, 0		# load constant value 0 into $t2
	  sw $t2, -96($fp)	# spill _tmp618 from $t2 to $fp-96
	# _tmp619 = _tmp618 - _tmp617
	  lw $t0, -96($fp)	# fill _tmp618 to $t0 from $fp-96
	  lw $t1, -92($fp)	# fill _tmp617 to $t1 from $fp-92
	  sub $t2, $t0, $t1	
	  sw $t2, -100($fp)	# spill _tmp619 from $t2 to $fp-100
	# _tmp620 = x == _tmp619
	  lw $t0, -8($fp)	# fill x to $t0 from $fp-8
	  lw $t1, -100($fp)	# fill _tmp619 to $t1 from $fp-100
	  seq $t2, $t0, $t1	
	  sw $t2, -104($fp)	# spill _tmp620 from $t2 to $fp-104
	# IfZ _tmp620 Goto _L99
	  lw $t0, -104($fp)	# fill _tmp620 to $t0 from $fp-104
	  beqz $t0, _L99	# branch if _tmp620 is zero 
	# _tmp621 = 0
	  li $t2, 0		# load constant value 0 into $t2
	  sw $t2, -108($fp)	# spill _tmp621 from $t2 to $fp-108
	# PushParam _tmp621
	  subu $sp, $sp, 4	# decrement sp to make space for param
	  lw $t0, -108($fp)	# fill _tmp621 to $t0 from $fp-108
	  sw $t0, 4($sp)	# copy param value to stack
	# _tmp622 = *(this + 4)
	  lw $t0, 4($fp)	# fill this to $t0 from $fp+4
	  lw $t2, 4($t0) 	# load with offset
	  sw $t2, -112($fp)	# spill _tmp622 from $t2 to $fp-112
	# PushParam _tmp622
	  subu $sp, $sp, 4	# decrement sp to make space for param
	  lw $t0, -112($fp)	# fill _tmp622 to $t0 from $fp-112
	  sw $t0, 4($sp)	# copy param value to stack
	# _tmp623 = *(_tmp622)
	  lw $t0, -112($fp)	# fill _tmp622 to $t0 from $fp-112
	  lw $t2, 0($t0) 	# load with offset
	  sw $t2, -116($fp)	# spill _tmp623 from $t2 to $fp-116
	# _tmp624 = *(_tmp623 + 20)
	  lw $t0, -116($fp)	# fill _tmp623 to $t0 from $fp-116
	  lw $t2, 20($t0) 	# load with offset
	  sw $t2, -120($fp)	# spill _tmp624 from $t2 to $fp-120
	# ACall _tmp624
	  lw $t0, -120($fp)	# fill _tmp624 to $t0 from $fp-120
	  jalr $t0            	# jump to function
	# PopParams 8
	  add $sp, $sp, 8	# pop params off stack
	# Goto _L100
	  b _L100		# unconditional branch
  _L99:
	# Return x
	  lw $t2, -8($fp)	# fill x to $t2 from $fp-8
	  move $v0, $t2		# assign return value into $v0
	  move $sp, $fp		# pop callee frame off stack
	  lw $ra, -4($fp)	# restore saved ra
	  lw $fp, 0($fp)	# restore saved fp
	  jr $ra		# return from function
  _L100:
  _L98:
	# Goto _L94
	  b _L94		# unconditional branch
  _L93:
  _L94:
	# Goto _L91
	  b _L91		# unconditional branch
  _L92:
	# EndFunc
	# (below handles reaching end of fn body with no explicit return)
	  move $sp, $fp		# pop callee frame off stack
	  lw $ra, -4($fp)	# restore saved ra
	  lw $fp, 0($fp)	# restore saved fp
	  jr $ra		# return from function
  Game.____AnnounceWin:
	# BeginFunc 40
	  subu $sp, $sp, 8	# decrement sp to make space to save ra, fp
	  sw $fp, 8($sp)	# save fp
	  sw $ra, 4($sp)	# save ra
	  addiu $fp, $sp, 8	# set up new fp
	  subu $sp, $sp, 40	# decrement sp to make space for locals/temps
	# _tmp625 = 1
	  li $t2, 1		# load constant value 1 into $t2
	  sw $t2, -8($fp)	# spill _tmp625 from $t2 to $fp-8
	# PushParam _tmp625
	  subu $sp, $sp, 4	# decrement sp to make space for param
	  lw $t0, -8($fp)	# fill _tmp625 to $t0 from $fp-8
	  sw $t0, 4($sp)	# copy param value to stack
	# _tmp626 = *(this + 4)
	  lw $t0, 4($fp)	# fill this to $t0 from $fp+4
	  lw $t2, 4($t0) 	# load with offset
	  sw $t2, -12($fp)	# spill _tmp626 from $t2 to $fp-12
	# PushParam _tmp626
	  subu $sp, $sp, 4	# decrement sp to make space for param
	  lw $t0, -12($fp)	# fill _tmp626 to $t0 from $fp-12
	  sw $t0, 4($sp)	# copy param value to stack
	# _tmp627 = *(_tmp626)
	  lw $t0, -12($fp)	# fill _tmp626 to $t0 from $fp-12
	  lw $t2, 0($t0) 	# load with offset
	  sw $t2, -16($fp)	# spill _tmp627 from $t2 to $fp-16
	# _tmp628 = *(_tmp627 + 20)
	  lw $t0, -16($fp)	# fill _tmp627 to $t0 from $fp-16
	  lw $t2, 20($t0) 	# load with offset
	  sw $t2, -20($fp)	# spill _tmp628 from $t2 to $fp-20
	# ACall _tmp628
	  lw $t0, -20($fp)	# fill _tmp628 to $t0 from $fp-20
	  jalr $t0            	# jump to function
	# PopParams 8
	  add $sp, $sp, 8	# pop params off stack
	# _tmp629 = *(this + 4)
	  lw $t0, 4($fp)	# fill this to $t0 from $fp+4
	  lw $t2, 4($t0) 	# load with offset
	  sw $t2, -24($fp)	# spill _tmp629 from $t2 to $fp-24
	# PushParam _tmp629
	  subu $sp, $sp, 4	# decrement sp to make space for param
	  lw $t0, -24($fp)	# fill _tmp629 to $t0 from $fp-24
	  sw $t0, 4($sp)	# copy param value to stack
	# _tmp630 = *(_tmp629)
	  lw $t0, -24($fp)	# fill _tmp629 to $t0 from $fp-24
	  lw $t2, 0($t0) 	# load with offset
	  sw $t2, -28($fp)	# spill _tmp630 from $t2 to $fp-28
	# _tmp631 = *(_tmp630 + 32)
	  lw $t0, -28($fp)	# fill _tmp630 to $t0 from $fp-28
	  lw $t2, 32($t0) 	# load with offset
	  sw $t2, -32($fp)	# spill _tmp631 from $t2 to $fp-32
	# _tmp632 = ACall _tmp631
	  lw $t0, -32($fp)	# fill _tmp631 to $t0 from $fp-32
	  jalr $t0            	# jump to function
	  move $t2, $v0		# copy function return value from $v0
	  sw $t2, -36($fp)	# spill _tmp632 from $t2 to $fp-36
	# PopParams 4
	  add $sp, $sp, 4	# pop params off stack
	# IfZ _tmp632 Goto _L101
	  lw $t0, -36($fp)	# fill _tmp632 to $t0 from $fp-36
	  beqz $t0, _L101	# branch if _tmp632 is zero 
	# _tmp633 = "You win!  Good job.\n"
	  .data			# create string constant marked with label
	  _string40: .asciiz "You win!  Good job.\n"
	  .text
	  la $t2, _string40	# load label
	  sw $t2, -40($fp)	# spill _tmp633 from $t2 to $fp-40
	# PushParam _tmp633
	  subu $sp, $sp, 4	# decrement sp to make space for param
	  lw $t0, -40($fp)	# fill _tmp633 to $t0 from $fp-40
	  sw $t0, 4($sp)	# copy param value to stack
	# LCall _PrintString
	  jal _PrintString   	# jump to function
	# PopParams 4
	  add $sp, $sp, 4	# pop params off stack
	# Goto _L102
	  b _L102		# unconditional branch
  _L101:
	# _tmp634 = "Quitter!!\n"
	  .data			# create string constant marked with label
	  _string41: .asciiz "Quitter!!\n"
	  .text
	  la $t2, _string41	# load label
	  sw $t2, -44($fp)	# spill _tmp634 from $t2 to $fp-44
	# PushParam _tmp634
	  subu $sp, $sp, 4	# decrement sp to make space for param
	  lw $t0, -44($fp)	# fill _tmp634 to $t0 from $fp-44
	  sw $t0, 4($sp)	# copy param value to stack
	# LCall _PrintString
	  jal _PrintString   	# jump to function
	# PopParams 4
	  add $sp, $sp, 4	# pop params off stack
  _L102:
	# EndFunc
	# (below handles reaching end of fn body with no explicit return)
	  move $sp, $fp		# pop callee frame off stack
	  lw $ra, -4($fp)	# restore saved ra
	  lw $fp, 0($fp)	# restore saved fp
	  jr $ra		# return from function
  Game.____AnnounceLoss:
	# BeginFunc 20
	  subu $sp, $sp, 8	# decrement sp to make space to save ra, fp
	  sw $fp, 8($sp)	# save fp
	  sw $ra, 4($sp)	# save ra
	  addiu $fp, $sp, 8	# set up new fp
	  subu $sp, $sp, 20	# decrement sp to make space for locals/temps
	# _tmp635 = 1
	  li $t2, 1		# load constant value 1 into $t2
	  sw $t2, -8($fp)	# spill _tmp635 from $t2 to $fp-8
	# PushParam _tmp635
	  subu $sp, $sp, 4	# decrement sp to make space for param
	  lw $t0, -8($fp)	# fill _tmp635 to $t0 from $fp-8
	  sw $t0, 4($sp)	# copy param value to stack
	# _tmp636 = *(this + 4)
	  lw $t0, 4($fp)	# fill this to $t0 from $fp+4
	  lw $t2, 4($t0) 	# load with offset
	  sw $t2, -12($fp)	# spill _tmp636 from $t2 to $fp-12
	# PushParam _tmp636
	  subu $sp, $sp, 4	# decrement sp to make space for param
	  lw $t0, -12($fp)	# fill _tmp636 to $t0 from $fp-12
	  sw $t0, 4($sp)	# copy param value to stack
	# _tmp637 = *(_tmp636)
	  lw $t0, -12($fp)	# fill _tmp636 to $t0 from $fp-12
	  lw $t2, 0($t0) 	# load with offset
	  sw $t2, -16($fp)	# spill _tmp637 from $t2 to $fp-16
	# _tmp638 = *(_tmp637 + 20)
	  lw $t0, -16($fp)	# fill _tmp637 to $t0 from $fp-16
	  lw $t2, 20($t0) 	# load with offset
	  sw $t2, -20($fp)	# spill _tmp638 from $t2 to $fp-20
	# ACall _tmp638
	  lw $t0, -20($fp)	# fill _tmp638 to $t0 from $fp-20
	  jalr $t0            	# jump to function
	# PopParams 8
	  add $sp, $sp, 8	# pop params off stack
	# _tmp639 = "Ha ha!! You blew up!!  Ha ha!!\n"
	  .data			# create string constant marked with label
	  _string42: .asciiz "Ha ha!! You blew up!!  Ha ha!!\n"
	  .text
	  la $t2, _string42	# load label
	  sw $t2, -24($fp)	# spill _tmp639 from $t2 to $fp-24
	# PushParam _tmp639
	  subu $sp, $sp, 4	# decrement sp to make space for param
	  lw $t0, -24($fp)	# fill _tmp639 to $t0 from $fp-24
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
	# VTable for class Game
	  .data
	  .align 2
	  Game:		# label for class Game vtable
	  .word Game.____Init
	  .word Game.____PlayGame
	  .word Game.____PromptForInt
	  .word Game.____AnnounceWin
	  .word Game.____AnnounceLoss
	  .text
  ____PrintHelp:
	# BeginFunc 72
	  subu $sp, $sp, 8	# decrement sp to make space to save ra, fp
	  sw $fp, 8($sp)	# save fp
	  sw $ra, 4($sp)	# save ra
	  addiu $fp, $sp, 8	# set up new fp
	  subu $sp, $sp, 72	# decrement sp to make space for locals/temps
	# _tmp640 = "Welcome to Low-Fat Decaf Minesweeper!\n"
	  .data			# create string constant marked with label
	  _string43: .asciiz "Welcome to Low-Fat Decaf Minesweeper!\n"
	  .text
	  la $t2, _string43	# load label
	  sw $t2, -8($fp)	# spill _tmp640 from $t2 to $fp-8
	# PushParam _tmp640
	  subu $sp, $sp, 4	# decrement sp to make space for param
	  lw $t0, -8($fp)	# fill _tmp640 to $t0 from $fp-8
	  sw $t0, 4($sp)	# copy param value to stack
	# LCall _PrintString
	  jal _PrintString   	# jump to function
	# PopParams 4
	  add $sp, $sp, 4	# pop params off stack
	# _tmp641 = "On the screen you will see a grid that represents..."
	  .data			# create string constant marked with label
	  _string44: .asciiz "On the screen you will see a grid that represents your field.\n"
	  .text
	  la $t2, _string44	# load label
	  sw $t2, -12($fp)	# spill _tmp641 from $t2 to $fp-12
	# PushParam _tmp641
	  subu $sp, $sp, 4	# decrement sp to make space for param
	  lw $t0, -12($fp)	# fill _tmp641 to $t0 from $fp-12
	  sw $t0, 4($sp)	# copy param value to stack
	# LCall _PrintString
	  jal _PrintString   	# jump to function
	# PopParams 4
	  add $sp, $sp, 4	# pop params off stack
	# _tmp642 = "In each location there may or may not be a mine h..."
	  .data			# create string constant marked with label
	  _string45: .asciiz "In each location there may or may not be a mine hidden.  In \n"
	  .text
	  la $t2, _string45	# load label
	  sw $t2, -16($fp)	# spill _tmp642 from $t2 to $fp-16
	# PushParam _tmp642
	  subu $sp, $sp, 4	# decrement sp to make space for param
	  lw $t0, -16($fp)	# fill _tmp642 to $t0 from $fp-16
	  sw $t0, 4($sp)	# copy param value to stack
	# LCall _PrintString
	  jal _PrintString   	# jump to function
	# PopParams 4
	  add $sp, $sp, 4	# pop params off stack
	# _tmp643 = "order to clear the field, enter in the coordinate..."
	  .data			# create string constant marked with label
	  _string46: .asciiz "order to clear the field, enter in the coordinates of the \n"
	  .text
	  la $t2, _string46	# load label
	  sw $t2, -20($fp)	# spill _tmp643 from $t2 to $fp-20
	# PushParam _tmp643
	  subu $sp, $sp, 4	# decrement sp to make space for param
	  lw $t0, -20($fp)	# fill _tmp643 to $t0 from $fp-20
	  sw $t0, 4($sp)	# copy param value to stack
	# LCall _PrintString
	  jal _PrintString   	# jump to function
	# PopParams 4
	  add $sp, $sp, 4	# pop params off stack
	# _tmp644 = "location you want to uncover.\n\n"
	  .data			# create string constant marked with label
	  _string47: .asciiz "location you want to uncover.\n\n"
	  .text
	  la $t2, _string47	# load label
	  sw $t2, -24($fp)	# spill _tmp644 from $t2 to $fp-24
	# PushParam _tmp644
	  subu $sp, $sp, 4	# decrement sp to make space for param
	  lw $t0, -24($fp)	# fill _tmp644 to $t0 from $fp-24
	  sw $t0, 4($sp)	# copy param value to stack
	# LCall _PrintString
	  jal _PrintString   	# jump to function
	# PopParams 4
	  add $sp, $sp, 4	# pop params off stack
	# _tmp645 = "As you clear mines, the grid will change.  There ..."
	  .data			# create string constant marked with label
	  _string48: .asciiz "As you clear mines, the grid will change.  There are two symbols:\n"
	  .text
	  la $t2, _string48	# load label
	  sw $t2, -28($fp)	# spill _tmp645 from $t2 to $fp-28
	# PushParam _tmp645
	  subu $sp, $sp, 4	# decrement sp to make space for param
	  lw $t0, -28($fp)	# fill _tmp645 to $t0 from $fp-28
	  sw $t0, 4($sp)	# copy param value to stack
	# LCall _PrintString
	  jal _PrintString   	# jump to function
	# PopParams 4
	  add $sp, $sp, 4	# pop params off stack
	# _tmp646 = "    '+'  - you haven't uncovered this location ye..."
	  .data			# create string constant marked with label
	  _string49: .asciiz "    '+'  - you haven't uncovered this location yet\n"
	  .text
	  la $t2, _string49	# load label
	  sw $t2, -32($fp)	# spill _tmp646 from $t2 to $fp-32
	# PushParam _tmp646
	  subu $sp, $sp, 4	# decrement sp to make space for param
	  lw $t0, -32($fp)	# fill _tmp646 to $t0 from $fp-32
	  sw $t0, 4($sp)	# copy param value to stack
	# LCall _PrintString
	  jal _PrintString   	# jump to function
	# PopParams 4
	  add $sp, $sp, 4	# pop params off stack
	# _tmp647 = "a number - there is no mine here, but there are t..."
	  .data			# create string constant marked with label
	  _string50: .asciiz "a number - there is no mine here, but there are the specified \n"
	  .text
	  la $t2, _string50	# load label
	  sw $t2, -36($fp)	# spill _tmp647 from $t2 to $fp-36
	# PushParam _tmp647
	  subu $sp, $sp, 4	# decrement sp to make space for param
	  lw $t0, -36($fp)	# fill _tmp647 to $t0 from $fp-36
	  sw $t0, 4($sp)	# copy param value to stack
	# LCall _PrintString
	  jal _PrintString   	# jump to function
	# PopParams 4
	  add $sp, $sp, 4	# pop params off stack
	# _tmp648 = "           number of mines directly adjacent to t..."
	  .data			# create string constant marked with label
	  _string51: .asciiz "           number of mines directly adjacent to this location\n"
	  .text
	  la $t2, _string51	# load label
	  sw $t2, -40($fp)	# spill _tmp648 from $t2 to $fp-40
	# PushParam _tmp648
	  subu $sp, $sp, 4	# decrement sp to make space for param
	  lw $t0, -40($fp)	# fill _tmp648 to $t0 from $fp-40
	  sw $t0, 4($sp)	# copy param value to stack
	# LCall _PrintString
	  jal _PrintString   	# jump to function
	# PopParams 4
	  add $sp, $sp, 4	# pop params off stack
	# _tmp649 = "           (including diagonals)\n"
	  .data			# create string constant marked with label
	  _string52: .asciiz "           (including diagonals)\n"
	  .text
	  la $t2, _string52	# load label
	  sw $t2, -44($fp)	# spill _tmp649 from $t2 to $fp-44
	# PushParam _tmp649
	  subu $sp, $sp, 4	# decrement sp to make space for param
	  lw $t0, -44($fp)	# fill _tmp649 to $t0 from $fp-44
	  sw $t0, 4($sp)	# copy param value to stack
	# LCall _PrintString
	  jal _PrintString   	# jump to function
	# PopParams 4
	  add $sp, $sp, 4	# pop params off stack
	# _tmp650 = "The field will keep on expanding from the point y..."
	  .data			# create string constant marked with label
	  _string53: .asciiz "The field will keep on expanding from the point you specified\n"
	  .text
	  la $t2, _string53	# load label
	  sw $t2, -48($fp)	# spill _tmp650 from $t2 to $fp-48
	# PushParam _tmp650
	  subu $sp, $sp, 4	# decrement sp to make space for param
	  lw $t0, -48($fp)	# fill _tmp650 to $t0 from $fp-48
	  sw $t0, 4($sp)	# copy param value to stack
	# LCall _PrintString
	  jal _PrintString   	# jump to function
	# PopParams 4
	  add $sp, $sp, 4	# pop params off stack
	# _tmp651 = "and clear all adjacent points that have no mines...."
	  .data			# create string constant marked with label
	  _string54: .asciiz "and clear all adjacent points that have no mines.\n\n"
	  .text
	  la $t2, _string54	# load label
	  sw $t2, -52($fp)	# spill _tmp651 from $t2 to $fp-52
	# PushParam _tmp651
	  subu $sp, $sp, 4	# decrement sp to make space for param
	  lw $t0, -52($fp)	# fill _tmp651 to $t0 from $fp-52
	  sw $t0, 4($sp)	# copy param value to stack
	# LCall _PrintString
	  jal _PrintString   	# jump to function
	# PopParams 4
	  add $sp, $sp, 4	# pop params off stack
	# _tmp652 = "If you uncover a location with a mine, you die, a..."
	  .data			# create string constant marked with label
	  _string55: .asciiz "If you uncover a location with a mine, you die, and the solution\n"
	  .text
	  la $t2, _string55	# load label
	  sw $t2, -56($fp)	# spill _tmp652 from $t2 to $fp-56
	# PushParam _tmp652
	  subu $sp, $sp, 4	# decrement sp to make space for param
	  lw $t0, -56($fp)	# fill _tmp652 to $t0 from $fp-56
	  sw $t0, 4($sp)	# copy param value to stack
	# LCall _PrintString
	  jal _PrintString   	# jump to function
	# PopParams 4
	  add $sp, $sp, 4	# pop params off stack
	# _tmp653 = "will be printed.  The solution will show these sy..."
	  .data			# create string constant marked with label
	  _string56: .asciiz "will be printed.  The solution will show these symbols: \n"
	  .text
	  la $t2, _string56	# load label
	  sw $t2, -60($fp)	# spill _tmp653 from $t2 to $fp-60
	# PushParam _tmp653
	  subu $sp, $sp, 4	# decrement sp to make space for param
	  lw $t0, -60($fp)	# fill _tmp653 to $t0 from $fp-60
	  sw $t0, 4($sp)	# copy param value to stack
	# LCall _PrintString
	  jal _PrintString   	# jump to function
	# PopParams 4
	  add $sp, $sp, 4	# pop params off stack
	# _tmp654 = "    'x'  - this location has a mine\n"
	  .data			# create string constant marked with label
	  _string57: .asciiz "    'x'  - this location has a mine\n"
	  .text
	  la $t2, _string57	# load label
	  sw $t2, -64($fp)	# spill _tmp654 from $t2 to $fp-64
	# PushParam _tmp654
	  subu $sp, $sp, 4	# decrement sp to make space for param
	  lw $t0, -64($fp)	# fill _tmp654 to $t0 from $fp-64
	  sw $t0, 4($sp)	# copy param value to stack
	# LCall _PrintString
	  jal _PrintString   	# jump to function
	# PopParams 4
	  add $sp, $sp, 4	# pop params off stack
	# _tmp655 = "    '%'  - this is where you blew up\n"
	  .data			# create string constant marked with label
	  _string58: .asciiz "    '%'  - this is where you blew up\n"
	  .text
	  la $t2, _string58	# load label
	  sw $t2, -68($fp)	# spill _tmp655 from $t2 to $fp-68
	# PushParam _tmp655
	  subu $sp, $sp, 4	# decrement sp to make space for param
	  lw $t0, -68($fp)	# fill _tmp655 to $t0 from $fp-68
	  sw $t0, 4($sp)	# copy param value to stack
	# LCall _PrintString
	  jal _PrintString   	# jump to function
	# PopParams 4
	  add $sp, $sp, 4	# pop params off stack
	# _tmp656 = "a number - same as before\n\n"
	  .data			# create string constant marked with label
	  _string59: .asciiz "a number - same as before\n\n"
	  .text
	  la $t2, _string59	# load label
	  sw $t2, -72($fp)	# spill _tmp656 from $t2 to $fp-72
	# PushParam _tmp656
	  subu $sp, $sp, 4	# decrement sp to make space for param
	  lw $t0, -72($fp)	# fill _tmp656 to $t0 from $fp-72
	  sw $t0, 4($sp)	# copy param value to stack
	# LCall _PrintString
	  jal _PrintString   	# jump to function
	# PopParams 4
	  add $sp, $sp, 4	# pop params off stack
	# _tmp657 = "You win when you have uncovered all locations wit..."
	  .data			# create string constant marked with label
	  _string60: .asciiz "You win when you have uncovered all locations without a mine.\n"
	  .text
	  la $t2, _string60	# load label
	  sw $t2, -76($fp)	# spill _tmp657 from $t2 to $fp-76
	# PushParam _tmp657
	  subu $sp, $sp, 4	# decrement sp to make space for param
	  lw $t0, -76($fp)	# fill _tmp657 to $t0 from $fp-76
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
	# BeginFunc 124
	  subu $sp, $sp, 8	# decrement sp to make space to save ra, fp
	  sw $fp, 8($sp)	# save fp
	  sw $ra, 4($sp)	# save ra
	  addiu $fp, $sp, 8	# set up new fp
	  subu $sp, $sp, 124	# decrement sp to make space for locals/temps
	# _tmp658 = 4
	  li $t2, 4		# load constant value 4 into $t2
	  sw $t2, -20($fp)	# spill _tmp658 from $t2 to $fp-20
	# _tmp659 = 4
	  li $t2, 4		# load constant value 4 into $t2
	  sw $t2, -24($fp)	# spill _tmp659 from $t2 to $fp-24
	# _tmp660 = _tmp659 + _tmp658
	  lw $t0, -24($fp)	# fill _tmp659 to $t0 from $fp-24
	  lw $t1, -20($fp)	# fill _tmp658 to $t1 from $fp-20
	  add $t2, $t0, $t1	
	  sw $t2, -28($fp)	# spill _tmp660 from $t2 to $fp-28
	# PushParam _tmp660
	  subu $sp, $sp, 4	# decrement sp to make space for param
	  lw $t0, -28($fp)	# fill _tmp660 to $t0 from $fp-28
	  sw $t0, 4($sp)	# copy param value to stack
	# _tmp661 = LCall _Alloc
	  jal _Alloc         	# jump to function
	  move $t2, $v0		# copy function return value from $v0
	  sw $t2, -32($fp)	# spill _tmp661 from $t2 to $fp-32
	# PopParams 4
	  add $sp, $sp, 4	# pop params off stack
	# _tmp662 = rndModule
	  la $t2, rndModule	# load label
	  sw $t2, -36($fp)	# spill _tmp662 from $t2 to $fp-36
	# *(_tmp661) = _tmp662
	  lw $t0, -36($fp)	# fill _tmp662 to $t0 from $fp-36
	  lw $t2, -32($fp)	# fill _tmp661 to $t2 from $fp-32
	  sw $t0, 0($t2) 	# store with offset
	# gRnd = _tmp661
	  lw $t2, -32($fp)	# fill _tmp661 to $t2 from $fp-32
	  sw $t2, 4($gp)	# spill gRnd from $t2 to $gp+4
	# _tmp663 = "Please enter in a random seed: "
	  .data			# create string constant marked with label
	  _string61: .asciiz "Please enter in a random seed: "
	  .text
	  la $t2, _string61	# load label
	  sw $t2, -40($fp)	# spill _tmp663 from $t2 to $fp-40
	# PushParam _tmp663
	  subu $sp, $sp, 4	# decrement sp to make space for param
	  lw $t0, -40($fp)	# fill _tmp663 to $t0 from $fp-40
	  sw $t0, 4($sp)	# copy param value to stack
	# LCall _PrintString
	  jal _PrintString   	# jump to function
	# PopParams 4
	  add $sp, $sp, 4	# pop params off stack
	# _tmp664 = LCall _ReadInteger
	  jal _ReadInteger   	# jump to function
	  move $t2, $v0		# copy function return value from $v0
	  sw $t2, -44($fp)	# spill _tmp664 from $t2 to $fp-44
	# PushParam _tmp664
	  subu $sp, $sp, 4	# decrement sp to make space for param
	  lw $t0, -44($fp)	# fill _tmp664 to $t0 from $fp-44
	  sw $t0, 4($sp)	# copy param value to stack
	# PushParam gRnd
	  subu $sp, $sp, 4	# decrement sp to make space for param
	  lw $t0, 4($gp)	# fill gRnd to $t0 from $gp+4
	  sw $t0, 4($sp)	# copy param value to stack
	# _tmp665 = *(gRnd)
	  lw $t0, 4($gp)	# fill gRnd to $t0 from $gp+4
	  lw $t2, 0($t0) 	# load with offset
	  sw $t2, -48($fp)	# spill _tmp665 from $t2 to $fp-48
	# _tmp666 = *(_tmp665)
	  lw $t0, -48($fp)	# fill _tmp665 to $t0 from $fp-48
	  lw $t2, 0($t0) 	# load with offset
	  sw $t2, -52($fp)	# spill _tmp666 from $t2 to $fp-52
	# ACall _tmp666
	  lw $t0, -52($fp)	# fill _tmp666 to $t0 from $fp-52
	  jalr $t0            	# jump to function
	# PopParams 8
	  add $sp, $sp, 8	# pop params off stack
	# _tmp667 = "How much of the field do you want to have mines? ..."
	  .data			# create string constant marked with label
	  _string62: .asciiz "How much of the field do you want to have mines? (0%-100%) "
	  .text
	  la $t2, _string62	# load label
	  sw $t2, -56($fp)	# spill _tmp667 from $t2 to $fp-56
	# PushParam _tmp667
	  subu $sp, $sp, 4	# decrement sp to make space for param
	  lw $t0, -56($fp)	# fill _tmp667 to $t0 from $fp-56
	  sw $t0, 4($sp)	# copy param value to stack
	# LCall _PrintString
	  jal _PrintString   	# jump to function
	# PopParams 4
	  add $sp, $sp, 4	# pop params off stack
	# _tmp668 = LCall _ReadInteger
	  jal _ReadInteger   	# jump to function
	  move $t2, $v0		# copy function return value from $v0
	  sw $t2, -60($fp)	# spill _tmp668 from $t2 to $fp-60
	# probOfMine = _tmp668
	  lw $t2, -60($fp)	# fill _tmp668 to $t2 from $fp-60
	  sw $t2, 0($gp)	# spill probOfMine from $t2 to $gp+0
	# _tmp669 = "How wide do you want the field to be? "
	  .data			# create string constant marked with label
	  _string63: .asciiz "How wide do you want the field to be? "
	  .text
	  la $t2, _string63	# load label
	  sw $t2, -64($fp)	# spill _tmp669 from $t2 to $fp-64
	# PushParam _tmp669
	  subu $sp, $sp, 4	# decrement sp to make space for param
	  lw $t0, -64($fp)	# fill _tmp669 to $t0 from $fp-64
	  sw $t0, 4($sp)	# copy param value to stack
	# LCall _PrintString
	  jal _PrintString   	# jump to function
	# PopParams 4
	  add $sp, $sp, 4	# pop params off stack
	# _tmp670 = LCall _ReadInteger
	  jal _ReadInteger   	# jump to function
	  move $t2, $v0		# copy function return value from $v0
	  sw $t2, -68($fp)	# spill _tmp670 from $t2 to $fp-68
	# w = _tmp670
	  lw $t2, -68($fp)	# fill _tmp670 to $t2 from $fp-68
	  sw $t2, -8($fp)	# spill w from $t2 to $fp-8
	# _tmp671 = "How tall do you want the field to be? "
	  .data			# create string constant marked with label
	  _string64: .asciiz "How tall do you want the field to be? "
	  .text
	  la $t2, _string64	# load label
	  sw $t2, -72($fp)	# spill _tmp671 from $t2 to $fp-72
	# PushParam _tmp671
	  subu $sp, $sp, 4	# decrement sp to make space for param
	  lw $t0, -72($fp)	# fill _tmp671 to $t0 from $fp-72
	  sw $t0, 4($sp)	# copy param value to stack
	# LCall _PrintString
	  jal _PrintString   	# jump to function
	# PopParams 4
	  add $sp, $sp, 4	# pop params off stack
	# _tmp672 = LCall _ReadInteger
	  jal _ReadInteger   	# jump to function
	  move $t2, $v0		# copy function return value from $v0
	  sw $t2, -76($fp)	# spill _tmp672 from $t2 to $fp-76
	# h = _tmp672
	  lw $t2, -76($fp)	# fill _tmp672 to $t2 from $fp-76
	  sw $t2, -12($fp)	# spill h from $t2 to $fp-12
	# _tmp673 = 4
	  li $t2, 4		# load constant value 4 into $t2
	  sw $t2, -80($fp)	# spill _tmp673 from $t2 to $fp-80
	# _tmp674 = 4
	  li $t2, 4		# load constant value 4 into $t2
	  sw $t2, -84($fp)	# spill _tmp674 from $t2 to $fp-84
	# _tmp675 = _tmp674 + _tmp673
	  lw $t0, -84($fp)	# fill _tmp674 to $t0 from $fp-84
	  lw $t1, -80($fp)	# fill _tmp673 to $t1 from $fp-80
	  add $t2, $t0, $t1	
	  sw $t2, -88($fp)	# spill _tmp675 from $t2 to $fp-88
	# PushParam _tmp675
	  subu $sp, $sp, 4	# decrement sp to make space for param
	  lw $t0, -88($fp)	# fill _tmp675 to $t0 from $fp-88
	  sw $t0, 4($sp)	# copy param value to stack
	# _tmp676 = LCall _Alloc
	  jal _Alloc         	# jump to function
	  move $t2, $v0		# copy function return value from $v0
	  sw $t2, -92($fp)	# spill _tmp676 from $t2 to $fp-92
	# PopParams 4
	  add $sp, $sp, 4	# pop params off stack
	# _tmp677 = Game
	  la $t2, Game	# load label
	  sw $t2, -96($fp)	# spill _tmp677 from $t2 to $fp-96
	# *(_tmp676) = _tmp677
	  lw $t0, -96($fp)	# fill _tmp677 to $t0 from $fp-96
	  lw $t2, -92($fp)	# fill _tmp676 to $t2 from $fp-92
	  sw $t0, 0($t2) 	# store with offset
	# g = _tmp676
	  lw $t2, -92($fp)	# fill _tmp676 to $t2 from $fp-92
	  sw $t2, -16($fp)	# spill g from $t2 to $fp-16
	# PushParam h
	  subu $sp, $sp, 4	# decrement sp to make space for param
	  lw $t0, -12($fp)	# fill h to $t0 from $fp-12
	  sw $t0, 4($sp)	# copy param value to stack
	# PushParam w
	  subu $sp, $sp, 4	# decrement sp to make space for param
	  lw $t0, -8($fp)	# fill w to $t0 from $fp-8
	  sw $t0, 4($sp)	# copy param value to stack
	# PushParam g
	  subu $sp, $sp, 4	# decrement sp to make space for param
	  lw $t0, -16($fp)	# fill g to $t0 from $fp-16
	  sw $t0, 4($sp)	# copy param value to stack
	# _tmp678 = *(g)
	  lw $t0, -16($fp)	# fill g to $t0 from $fp-16
	  lw $t2, 0($t0) 	# load with offset
	  sw $t2, -100($fp)	# spill _tmp678 from $t2 to $fp-100
	# _tmp679 = *(_tmp678)
	  lw $t0, -100($fp)	# fill _tmp678 to $t0 from $fp-100
	  lw $t2, 0($t0) 	# load with offset
	  sw $t2, -104($fp)	# spill _tmp679 from $t2 to $fp-104
	# ACall _tmp679
	  lw $t0, -104($fp)	# fill _tmp679 to $t0 from $fp-104
	  jalr $t0            	# jump to function
	# PopParams 12
	  add $sp, $sp, 12	# pop params off stack
	# PushParam g
	  subu $sp, $sp, 4	# decrement sp to make space for param
	  lw $t0, -16($fp)	# fill g to $t0 from $fp-16
	  sw $t0, 4($sp)	# copy param value to stack
	# _tmp680 = *(g)
	  lw $t0, -16($fp)	# fill g to $t0 from $fp-16
	  lw $t2, 0($t0) 	# load with offset
	  sw $t2, -108($fp)	# spill _tmp680 from $t2 to $fp-108
	# _tmp681 = *(_tmp680 + 4)
	  lw $t0, -108($fp)	# fill _tmp680 to $t0 from $fp-108
	  lw $t2, 4($t0) 	# load with offset
	  sw $t2, -112($fp)	# spill _tmp681 from $t2 to $fp-112
	# ACall _tmp681
	  lw $t0, -112($fp)	# fill _tmp681 to $t0 from $fp-112
	  jalr $t0            	# jump to function
	# PopParams 4
	  add $sp, $sp, 4	# pop params off stack
	# EndFunc
	# (below handles reaching end of fn body with no explicit return)
	  move $sp, $fp		# pop callee frame off stack
	  lw $ra, -4($fp)	# restore saved ra
	  lw $fp, 0($fp)	# restore saved fp
	  jr $ra		# return from function
