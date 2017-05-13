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
	  
  QueueItem.____Init:
	# BeginFunc 0
	  subu $sp, $sp, 8	# decrement sp to make space to save ra, fp
	  sw $fp, 8($sp)	# save fp
	  sw $ra, 4($sp)	# save ra
	  addiu $fp, $sp, 8	# set up new fp
	# *(this + 4) = data
	  lw $t0, 8($fp)	# fill data to $t0 from $fp+8
	  lw $t2, 4($fp)	# fill this to $t2 from $fp+4
	  sw $t0, 4($t2) 	# store with offset
	# *(this + 8) = next
	  lw $t0, 12($fp)	# fill next to $t0 from $fp+12
	  lw $t2, 4($fp)	# fill this to $t2 from $fp+4
	  sw $t0, 8($t2) 	# store with offset
	# *(next + 12) = this
	  lw $t0, 4($fp)	# fill this to $t0 from $fp+4
	  lw $t2, 12($fp)	# fill next to $t2 from $fp+12
	  sw $t0, 12($t2) 	# store with offset
	# *(this + 12) = prev
	  lw $t0, 16($fp)	# fill prev to $t0 from $fp+16
	  lw $t2, 4($fp)	# fill this to $t2 from $fp+4
	  sw $t0, 12($t2) 	# store with offset
	# *(prev + 8) = this
	  lw $t0, 4($fp)	# fill this to $t0 from $fp+4
	  lw $t2, 16($fp)	# fill prev to $t2 from $fp+16
	  sw $t0, 8($t2) 	# store with offset
	# EndFunc
	# (below handles reaching end of fn body with no explicit return)
	  move $sp, $fp		# pop callee frame off stack
	  lw $ra, -4($fp)	# restore saved ra
	  lw $fp, 0($fp)	# restore saved fp
	  jr $ra		# return from function
  QueueItem.____GetData:
	# BeginFunc 4
	  subu $sp, $sp, 8	# decrement sp to make space to save ra, fp
	  sw $fp, 8($sp)	# save fp
	  sw $ra, 4($sp)	# save ra
	  addiu $fp, $sp, 8	# set up new fp
	  subu $sp, $sp, 4	# decrement sp to make space for locals/temps
	# _tmp0 = *(this + 4)
	  lw $t0, 4($fp)	# fill this to $t0 from $fp+4
	  lw $t2, 4($t0) 	# load with offset
	  sw $t2, -8($fp)	# spill _tmp0 from $t2 to $fp-8
	# Return _tmp0
	  lw $t2, -8($fp)	# fill _tmp0 to $t2 from $fp-8
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
  QueueItem.____GetNext:
	# BeginFunc 4
	  subu $sp, $sp, 8	# decrement sp to make space to save ra, fp
	  sw $fp, 8($sp)	# save fp
	  sw $ra, 4($sp)	# save ra
	  addiu $fp, $sp, 8	# set up new fp
	  subu $sp, $sp, 4	# decrement sp to make space for locals/temps
	# _tmp1 = *(this + 8)
	  lw $t0, 4($fp)	# fill this to $t0 from $fp+4
	  lw $t2, 8($t0) 	# load with offset
	  sw $t2, -8($fp)	# spill _tmp1 from $t2 to $fp-8
	# Return _tmp1
	  lw $t2, -8($fp)	# fill _tmp1 to $t2 from $fp-8
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
  QueueItem.____GetPrev:
	# BeginFunc 4
	  subu $sp, $sp, 8	# decrement sp to make space to save ra, fp
	  sw $fp, 8($sp)	# save fp
	  sw $ra, 4($sp)	# save ra
	  addiu $fp, $sp, 8	# set up new fp
	  subu $sp, $sp, 4	# decrement sp to make space for locals/temps
	# _tmp2 = *(this + 12)
	  lw $t0, 4($fp)	# fill this to $t0 from $fp+4
	  lw $t2, 12($t0) 	# load with offset
	  sw $t2, -8($fp)	# spill _tmp2 from $t2 to $fp-8
	# Return _tmp2
	  lw $t2, -8($fp)	# fill _tmp2 to $t2 from $fp-8
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
  QueueItem.____SetNext:
	# BeginFunc 0
	  subu $sp, $sp, 8	# decrement sp to make space to save ra, fp
	  sw $fp, 8($sp)	# save fp
	  sw $ra, 4($sp)	# save ra
	  addiu $fp, $sp, 8	# set up new fp
	# *(this + 8) = n
	  lw $t0, 8($fp)	# fill n to $t0 from $fp+8
	  lw $t2, 4($fp)	# fill this to $t2 from $fp+4
	  sw $t0, 8($t2) 	# store with offset
	# EndFunc
	# (below handles reaching end of fn body with no explicit return)
	  move $sp, $fp		# pop callee frame off stack
	  lw $ra, -4($fp)	# restore saved ra
	  lw $fp, 0($fp)	# restore saved fp
	  jr $ra		# return from function
  QueueItem.____SetPrev:
	# BeginFunc 0
	  subu $sp, $sp, 8	# decrement sp to make space to save ra, fp
	  sw $fp, 8($sp)	# save fp
	  sw $ra, 4($sp)	# save ra
	  addiu $fp, $sp, 8	# set up new fp
	# *(this + 12) = p
	  lw $t0, 8($fp)	# fill p to $t0 from $fp+8
	  lw $t2, 4($fp)	# fill this to $t2 from $fp+4
	  sw $t0, 12($t2) 	# store with offset
	# EndFunc
	# (below handles reaching end of fn body with no explicit return)
	  move $sp, $fp		# pop callee frame off stack
	  lw $ra, -4($fp)	# restore saved ra
	  lw $fp, 0($fp)	# restore saved fp
	  jr $ra		# return from function
	# VTable for class QueueItem
	  .data
	  .align 2
	  QueueItem:		# label for class QueueItem vtable
	  .word QueueItem.____Init
	  .word QueueItem.____GetData
	  .word QueueItem.____GetNext
	  .word QueueItem.____GetPrev
	  .word QueueItem.____SetNext
	  .word QueueItem.____SetPrev
	  .text
  Queue.____Init:
	# BeginFunc 44
	  subu $sp, $sp, 8	# decrement sp to make space to save ra, fp
	  sw $fp, 8($sp)	# save fp
	  sw $ra, 4($sp)	# save ra
	  addiu $fp, $sp, 8	# set up new fp
	  subu $sp, $sp, 44	# decrement sp to make space for locals/temps
	# _tmp3 = 12
	  li $t2, 12		# load constant value 12 into $t2
	  sw $t2, -8($fp)	# spill _tmp3 from $t2 to $fp-8
	# _tmp4 = 4
	  li $t2, 4		# load constant value 4 into $t2
	  sw $t2, -12($fp)	# spill _tmp4 from $t2 to $fp-12
	# _tmp5 = _tmp4 + _tmp3
	  lw $t0, -12($fp)	# fill _tmp4 to $t0 from $fp-12
	  lw $t1, -8($fp)	# fill _tmp3 to $t1 from $fp-8
	  add $t2, $t0, $t1	
	  sw $t2, -16($fp)	# spill _tmp5 from $t2 to $fp-16
	# PushParam _tmp5
	  subu $sp, $sp, 4	# decrement sp to make space for param
	  lw $t0, -16($fp)	# fill _tmp5 to $t0 from $fp-16
	  sw $t0, 4($sp)	# copy param value to stack
	# _tmp6 = LCall _Alloc
	  jal _Alloc         	# jump to function
	  move $t2, $v0		# copy function return value from $v0
	  sw $t2, -20($fp)	# spill _tmp6 from $t2 to $fp-20
	# PopParams 4
	  add $sp, $sp, 4	# pop params off stack
	# _tmp7 = QueueItem
	  la $t2, QueueItem	# load label
	  sw $t2, -24($fp)	# spill _tmp7 from $t2 to $fp-24
	# *(_tmp6) = _tmp7
	  lw $t0, -24($fp)	# fill _tmp7 to $t0 from $fp-24
	  lw $t2, -20($fp)	# fill _tmp6 to $t2 from $fp-20
	  sw $t0, 0($t2) 	# store with offset
	# *(this + 4) = _tmp6
	  lw $t0, -20($fp)	# fill _tmp6 to $t0 from $fp-20
	  lw $t2, 4($fp)	# fill this to $t2 from $fp+4
	  sw $t0, 4($t2) 	# store with offset
	# _tmp8 = 0
	  li $t2, 0		# load constant value 0 into $t2
	  sw $t2, -28($fp)	# spill _tmp8 from $t2 to $fp-28
	# _tmp9 = *(this + 4)
	  lw $t0, 4($fp)	# fill this to $t0 from $fp+4
	  lw $t2, 4($t0) 	# load with offset
	  sw $t2, -32($fp)	# spill _tmp9 from $t2 to $fp-32
	# _tmp10 = *(this + 4)
	  lw $t0, 4($fp)	# fill this to $t0 from $fp+4
	  lw $t2, 4($t0) 	# load with offset
	  sw $t2, -36($fp)	# spill _tmp10 from $t2 to $fp-36
	# PushParam _tmp10
	  subu $sp, $sp, 4	# decrement sp to make space for param
	  lw $t0, -36($fp)	# fill _tmp10 to $t0 from $fp-36
	  sw $t0, 4($sp)	# copy param value to stack
	# PushParam _tmp9
	  subu $sp, $sp, 4	# decrement sp to make space for param
	  lw $t0, -32($fp)	# fill _tmp9 to $t0 from $fp-32
	  sw $t0, 4($sp)	# copy param value to stack
	# PushParam _tmp8
	  subu $sp, $sp, 4	# decrement sp to make space for param
	  lw $t0, -28($fp)	# fill _tmp8 to $t0 from $fp-28
	  sw $t0, 4($sp)	# copy param value to stack
	# _tmp11 = *(this + 4)
	  lw $t0, 4($fp)	# fill this to $t0 from $fp+4
	  lw $t2, 4($t0) 	# load with offset
	  sw $t2, -40($fp)	# spill _tmp11 from $t2 to $fp-40
	# PushParam _tmp11
	  subu $sp, $sp, 4	# decrement sp to make space for param
	  lw $t0, -40($fp)	# fill _tmp11 to $t0 from $fp-40
	  sw $t0, 4($sp)	# copy param value to stack
	# _tmp12 = *(_tmp11)
	  lw $t0, -40($fp)	# fill _tmp11 to $t0 from $fp-40
	  lw $t2, 0($t0) 	# load with offset
	  sw $t2, -44($fp)	# spill _tmp12 from $t2 to $fp-44
	# _tmp13 = *(_tmp12)
	  lw $t0, -44($fp)	# fill _tmp12 to $t0 from $fp-44
	  lw $t2, 0($t0) 	# load with offset
	  sw $t2, -48($fp)	# spill _tmp13 from $t2 to $fp-48
	# ACall _tmp13
	  lw $t0, -48($fp)	# fill _tmp13 to $t0 from $fp-48
	  jalr $t0            	# jump to function
	# PopParams 16
	  add $sp, $sp, 16	# pop params off stack
	# EndFunc
	# (below handles reaching end of fn body with no explicit return)
	  move $sp, $fp		# pop callee frame off stack
	  lw $ra, -4($fp)	# restore saved ra
	  lw $fp, 0($fp)	# restore saved fp
	  jr $ra		# return from function
  Queue.____EnQueue:
	# BeginFunc 56
	  subu $sp, $sp, 8	# decrement sp to make space to save ra, fp
	  sw $fp, 8($sp)	# save fp
	  sw $ra, 4($sp)	# save ra
	  addiu $fp, $sp, 8	# set up new fp
	  subu $sp, $sp, 56	# decrement sp to make space for locals/temps
	# _tmp14 = 12
	  li $t2, 12		# load constant value 12 into $t2
	  sw $t2, -12($fp)	# spill _tmp14 from $t2 to $fp-12
	# _tmp15 = 4
	  li $t2, 4		# load constant value 4 into $t2
	  sw $t2, -16($fp)	# spill _tmp15 from $t2 to $fp-16
	# _tmp16 = _tmp15 + _tmp14
	  lw $t0, -16($fp)	# fill _tmp15 to $t0 from $fp-16
	  lw $t1, -12($fp)	# fill _tmp14 to $t1 from $fp-12
	  add $t2, $t0, $t1	
	  sw $t2, -20($fp)	# spill _tmp16 from $t2 to $fp-20
	# PushParam _tmp16
	  subu $sp, $sp, 4	# decrement sp to make space for param
	  lw $t0, -20($fp)	# fill _tmp16 to $t0 from $fp-20
	  sw $t0, 4($sp)	# copy param value to stack
	# _tmp17 = LCall _Alloc
	  jal _Alloc         	# jump to function
	  move $t2, $v0		# copy function return value from $v0
	  sw $t2, -24($fp)	# spill _tmp17 from $t2 to $fp-24
	# PopParams 4
	  add $sp, $sp, 4	# pop params off stack
	# _tmp18 = QueueItem
	  la $t2, QueueItem	# load label
	  sw $t2, -28($fp)	# spill _tmp18 from $t2 to $fp-28
	# *(_tmp17) = _tmp18
	  lw $t0, -28($fp)	# fill _tmp18 to $t0 from $fp-28
	  lw $t2, -24($fp)	# fill _tmp17 to $t2 from $fp-24
	  sw $t0, 0($t2) 	# store with offset
	# temp = _tmp17
	  lw $t2, -24($fp)	# fill _tmp17 to $t2 from $fp-24
	  sw $t2, -8($fp)	# spill temp from $t2 to $fp-8
	# _tmp19 = *(this + 4)
	  lw $t0, 4($fp)	# fill this to $t0 from $fp+4
	  lw $t2, 4($t0) 	# load with offset
	  sw $t2, -32($fp)	# spill _tmp19 from $t2 to $fp-32
	# PushParam _tmp19
	  subu $sp, $sp, 4	# decrement sp to make space for param
	  lw $t0, -32($fp)	# fill _tmp19 to $t0 from $fp-32
	  sw $t0, 4($sp)	# copy param value to stack
	# _tmp20 = *(_tmp19)
	  lw $t0, -32($fp)	# fill _tmp19 to $t0 from $fp-32
	  lw $t2, 0($t0) 	# load with offset
	  sw $t2, -36($fp)	# spill _tmp20 from $t2 to $fp-36
	# _tmp21 = *(_tmp20 + 8)
	  lw $t0, -36($fp)	# fill _tmp20 to $t0 from $fp-36
	  lw $t2, 8($t0) 	# load with offset
	  sw $t2, -40($fp)	# spill _tmp21 from $t2 to $fp-40
	# _tmp22 = ACall _tmp21
	  lw $t0, -40($fp)	# fill _tmp21 to $t0 from $fp-40
	  jalr $t0            	# jump to function
	  move $t2, $v0		# copy function return value from $v0
	  sw $t2, -44($fp)	# spill _tmp22 from $t2 to $fp-44
	# PopParams 4
	  add $sp, $sp, 4	# pop params off stack
	# _tmp23 = *(this + 4)
	  lw $t0, 4($fp)	# fill this to $t0 from $fp+4
	  lw $t2, 4($t0) 	# load with offset
	  sw $t2, -48($fp)	# spill _tmp23 from $t2 to $fp-48
	# PushParam _tmp23
	  subu $sp, $sp, 4	# decrement sp to make space for param
	  lw $t0, -48($fp)	# fill _tmp23 to $t0 from $fp-48
	  sw $t0, 4($sp)	# copy param value to stack
	# PushParam _tmp22
	  subu $sp, $sp, 4	# decrement sp to make space for param
	  lw $t0, -44($fp)	# fill _tmp22 to $t0 from $fp-44
	  sw $t0, 4($sp)	# copy param value to stack
	# PushParam i
	  subu $sp, $sp, 4	# decrement sp to make space for param
	  lw $t0, 8($fp)	# fill i to $t0 from $fp+8
	  sw $t0, 4($sp)	# copy param value to stack
	# PushParam temp
	  subu $sp, $sp, 4	# decrement sp to make space for param
	  lw $t0, -8($fp)	# fill temp to $t0 from $fp-8
	  sw $t0, 4($sp)	# copy param value to stack
	# _tmp24 = *(temp)
	  lw $t0, -8($fp)	# fill temp to $t0 from $fp-8
	  lw $t2, 0($t0) 	# load with offset
	  sw $t2, -52($fp)	# spill _tmp24 from $t2 to $fp-52
	# _tmp25 = *(_tmp24)
	  lw $t0, -52($fp)	# fill _tmp24 to $t0 from $fp-52
	  lw $t2, 0($t0) 	# load with offset
	  sw $t2, -56($fp)	# spill _tmp25 from $t2 to $fp-56
	# ACall _tmp25
	  lw $t0, -56($fp)	# fill _tmp25 to $t0 from $fp-56
	  jalr $t0            	# jump to function
	# PopParams 16
	  add $sp, $sp, 16	# pop params off stack
	# EndFunc
	# (below handles reaching end of fn body with no explicit return)
	  move $sp, $fp		# pop callee frame off stack
	  lw $ra, -4($fp)	# restore saved ra
	  lw $fp, 0($fp)	# restore saved fp
	  jr $ra		# return from function
  Queue.____DeQueue:
	# BeginFunc 156
	  subu $sp, $sp, 8	# decrement sp to make space to save ra, fp
	  sw $fp, 8($sp)	# save fp
	  sw $ra, 4($sp)	# save ra
	  addiu $fp, $sp, 8	# set up new fp
	  subu $sp, $sp, 156	# decrement sp to make space for locals/temps
	# _tmp26 = *(this + 4)
	  lw $t0, 4($fp)	# fill this to $t0 from $fp+4
	  lw $t2, 4($t0) 	# load with offset
	  sw $t2, -12($fp)	# spill _tmp26 from $t2 to $fp-12
	# PushParam _tmp26
	  subu $sp, $sp, 4	# decrement sp to make space for param
	  lw $t0, -12($fp)	# fill _tmp26 to $t0 from $fp-12
	  sw $t0, 4($sp)	# copy param value to stack
	# _tmp27 = *(_tmp26)
	  lw $t0, -12($fp)	# fill _tmp26 to $t0 from $fp-12
	  lw $t2, 0($t0) 	# load with offset
	  sw $t2, -16($fp)	# spill _tmp27 from $t2 to $fp-16
	# _tmp28 = *(_tmp27 + 12)
	  lw $t0, -16($fp)	# fill _tmp27 to $t0 from $fp-16
	  lw $t2, 12($t0) 	# load with offset
	  sw $t2, -20($fp)	# spill _tmp28 from $t2 to $fp-20
	# _tmp29 = ACall _tmp28
	  lw $t0, -20($fp)	# fill _tmp28 to $t0 from $fp-20
	  jalr $t0            	# jump to function
	  move $t2, $v0		# copy function return value from $v0
	  sw $t2, -24($fp)	# spill _tmp29 from $t2 to $fp-24
	# PopParams 4
	  add $sp, $sp, 4	# pop params off stack
	# _tmp30 = *(this + 4)
	  lw $t0, 4($fp)	# fill this to $t0 from $fp+4
	  lw $t2, 4($t0) 	# load with offset
	  sw $t2, -28($fp)	# spill _tmp30 from $t2 to $fp-28
	# _tmp31 = _tmp29 == _tmp30
	  lw $t0, -24($fp)	# fill _tmp29 to $t0 from $fp-24
	  lw $t1, -28($fp)	# fill _tmp30 to $t1 from $fp-28
	  seq $t2, $t0, $t1	
	  sw $t2, -32($fp)	# spill _tmp31 from $t2 to $fp-32
	# IfZ _tmp31 Goto _L0
	  lw $t0, -32($fp)	# fill _tmp31 to $t0 from $fp-32
	  beqz $t0, _L0	# branch if _tmp31 is zero 
	# _tmp32 = "Queue Is Empty"
	  .data			# create string constant marked with label
	  _string1: .asciiz "Queue Is Empty"
	  .text
	  la $t2, _string1	# load label
	  sw $t2, -36($fp)	# spill _tmp32 from $t2 to $fp-36
	# PushParam _tmp32
	  subu $sp, $sp, 4	# decrement sp to make space for param
	  lw $t0, -36($fp)	# fill _tmp32 to $t0 from $fp-36
	  sw $t0, 4($sp)	# copy param value to stack
	# LCall _PrintString
	  jal _PrintString   	# jump to function
	# PopParams 4
	  add $sp, $sp, 4	# pop params off stack
	# _tmp33 = 0
	  li $t2, 0		# load constant value 0 into $t2
	  sw $t2, -40($fp)	# spill _tmp33 from $t2 to $fp-40
	# Return _tmp33
	  lw $t2, -40($fp)	# fill _tmp33 to $t2 from $fp-40
	  move $v0, $t2		# assign return value into $v0
	  move $sp, $fp		# pop callee frame off stack
	  lw $ra, -4($fp)	# restore saved ra
	  lw $fp, 0($fp)	# restore saved fp
	  jr $ra		# return from function
	# Goto _L1
	  b _L1		# unconditional branch
  _L0:
	# _tmp34 = *(this + 4)
	  lw $t0, 4($fp)	# fill this to $t0 from $fp+4
	  lw $t2, 4($t0) 	# load with offset
	  sw $t2, -48($fp)	# spill _tmp34 from $t2 to $fp-48
	# PushParam _tmp34
	  subu $sp, $sp, 4	# decrement sp to make space for param
	  lw $t0, -48($fp)	# fill _tmp34 to $t0 from $fp-48
	  sw $t0, 4($sp)	# copy param value to stack
	# _tmp35 = *(_tmp34)
	  lw $t0, -48($fp)	# fill _tmp34 to $t0 from $fp-48
	  lw $t2, 0($t0) 	# load with offset
	  sw $t2, -52($fp)	# spill _tmp35 from $t2 to $fp-52
	# _tmp36 = *(_tmp35 + 12)
	  lw $t0, -52($fp)	# fill _tmp35 to $t0 from $fp-52
	  lw $t2, 12($t0) 	# load with offset
	  sw $t2, -56($fp)	# spill _tmp36 from $t2 to $fp-56
	# _tmp37 = ACall _tmp36
	  lw $t0, -56($fp)	# fill _tmp36 to $t0 from $fp-56
	  jalr $t0            	# jump to function
	  move $t2, $v0		# copy function return value from $v0
	  sw $t2, -60($fp)	# spill _tmp37 from $t2 to $fp-60
	# PopParams 4
	  add $sp, $sp, 4	# pop params off stack
	# temp = _tmp37
	  lw $t2, -60($fp)	# fill _tmp37 to $t2 from $fp-60
	  sw $t2, -44($fp)	# spill temp from $t2 to $fp-44
	# PushParam temp
	  subu $sp, $sp, 4	# decrement sp to make space for param
	  lw $t0, -44($fp)	# fill temp to $t0 from $fp-44
	  sw $t0, 4($sp)	# copy param value to stack
	# _tmp38 = *(temp)
	  lw $t0, -44($fp)	# fill temp to $t0 from $fp-44
	  lw $t2, 0($t0) 	# load with offset
	  sw $t2, -64($fp)	# spill _tmp38 from $t2 to $fp-64
	# _tmp39 = *(_tmp38 + 4)
	  lw $t0, -64($fp)	# fill _tmp38 to $t0 from $fp-64
	  lw $t2, 4($t0) 	# load with offset
	  sw $t2, -68($fp)	# spill _tmp39 from $t2 to $fp-68
	# _tmp40 = ACall _tmp39
	  lw $t0, -68($fp)	# fill _tmp39 to $t0 from $fp-68
	  jalr $t0            	# jump to function
	  move $t2, $v0		# copy function return value from $v0
	  sw $t2, -72($fp)	# spill _tmp40 from $t2 to $fp-72
	# PopParams 4
	  add $sp, $sp, 4	# pop params off stack
	# val = _tmp40
	  lw $t2, -72($fp)	# fill _tmp40 to $t2 from $fp-72
	  sw $t2, -8($fp)	# spill val from $t2 to $fp-8
	# PushParam temp
	  subu $sp, $sp, 4	# decrement sp to make space for param
	  lw $t0, -44($fp)	# fill temp to $t0 from $fp-44
	  sw $t0, 4($sp)	# copy param value to stack
	# _tmp41 = *(temp)
	  lw $t0, -44($fp)	# fill temp to $t0 from $fp-44
	  lw $t2, 0($t0) 	# load with offset
	  sw $t2, -76($fp)	# spill _tmp41 from $t2 to $fp-76
	# _tmp42 = *(_tmp41 + 8)
	  lw $t0, -76($fp)	# fill _tmp41 to $t0 from $fp-76
	  lw $t2, 8($t0) 	# load with offset
	  sw $t2, -80($fp)	# spill _tmp42 from $t2 to $fp-80
	# _tmp43 = ACall _tmp42
	  lw $t0, -80($fp)	# fill _tmp42 to $t0 from $fp-80
	  jalr $t0            	# jump to function
	  move $t2, $v0		# copy function return value from $v0
	  sw $t2, -84($fp)	# spill _tmp43 from $t2 to $fp-84
	# PopParams 4
	  add $sp, $sp, 4	# pop params off stack
	# PushParam _tmp43
	  subu $sp, $sp, 4	# decrement sp to make space for param
	  lw $t0, -84($fp)	# fill _tmp43 to $t0 from $fp-84
	  sw $t0, 4($sp)	# copy param value to stack
	# PushParam temp
	  subu $sp, $sp, 4	# decrement sp to make space for param
	  lw $t0, -44($fp)	# fill temp to $t0 from $fp-44
	  sw $t0, 4($sp)	# copy param value to stack
	# _tmp44 = *(temp)
	  lw $t0, -44($fp)	# fill temp to $t0 from $fp-44
	  lw $t2, 0($t0) 	# load with offset
	  sw $t2, -88($fp)	# spill _tmp44 from $t2 to $fp-88
	# _tmp45 = *(_tmp44 + 12)
	  lw $t0, -88($fp)	# fill _tmp44 to $t0 from $fp-88
	  lw $t2, 12($t0) 	# load with offset
	  sw $t2, -92($fp)	# spill _tmp45 from $t2 to $fp-92
	# _tmp46 = ACall _tmp45
	  lw $t0, -92($fp)	# fill _tmp45 to $t0 from $fp-92
	  jalr $t0            	# jump to function
	  move $t2, $v0		# copy function return value from $v0
	  sw $t2, -96($fp)	# spill _tmp46 from $t2 to $fp-96
	# PopParams 4
	  add $sp, $sp, 4	# pop params off stack
	# PushParam _tmp46
	  subu $sp, $sp, 4	# decrement sp to make space for param
	  lw $t0, -96($fp)	# fill _tmp46 to $t0 from $fp-96
	  sw $t0, 4($sp)	# copy param value to stack
	# _tmp47 = *(_tmp46)
	  lw $t0, -96($fp)	# fill _tmp46 to $t0 from $fp-96
	  lw $t2, 0($t0) 	# load with offset
	  sw $t2, -100($fp)	# spill _tmp47 from $t2 to $fp-100
	# _tmp48 = *(_tmp47 + 16)
	  lw $t0, -100($fp)	# fill _tmp47 to $t0 from $fp-100
	  lw $t2, 16($t0) 	# load with offset
	  sw $t2, -104($fp)	# spill _tmp48 from $t2 to $fp-104
	# ACall _tmp48
	  lw $t0, -104($fp)	# fill _tmp48 to $t0 from $fp-104
	  jalr $t0            	# jump to function
	# PopParams 8
	  add $sp, $sp, 8	# pop params off stack
	# PushParam temp
	  subu $sp, $sp, 4	# decrement sp to make space for param
	  lw $t0, -44($fp)	# fill temp to $t0 from $fp-44
	  sw $t0, 4($sp)	# copy param value to stack
	# _tmp49 = *(temp)
	  lw $t0, -44($fp)	# fill temp to $t0 from $fp-44
	  lw $t2, 0($t0) 	# load with offset
	  sw $t2, -108($fp)	# spill _tmp49 from $t2 to $fp-108
	# _tmp50 = *(_tmp49 + 12)
	  lw $t0, -108($fp)	# fill _tmp49 to $t0 from $fp-108
	  lw $t2, 12($t0) 	# load with offset
	  sw $t2, -112($fp)	# spill _tmp50 from $t2 to $fp-112
	# _tmp51 = ACall _tmp50
	  lw $t0, -112($fp)	# fill _tmp50 to $t0 from $fp-112
	  jalr $t0            	# jump to function
	  move $t2, $v0		# copy function return value from $v0
	  sw $t2, -116($fp)	# spill _tmp51 from $t2 to $fp-116
	# PopParams 4
	  add $sp, $sp, 4	# pop params off stack
	# PushParam _tmp51
	  subu $sp, $sp, 4	# decrement sp to make space for param
	  lw $t0, -116($fp)	# fill _tmp51 to $t0 from $fp-116
	  sw $t0, 4($sp)	# copy param value to stack
	# PushParam temp
	  subu $sp, $sp, 4	# decrement sp to make space for param
	  lw $t0, -44($fp)	# fill temp to $t0 from $fp-44
	  sw $t0, 4($sp)	# copy param value to stack
	# _tmp52 = *(temp)
	  lw $t0, -44($fp)	# fill temp to $t0 from $fp-44
	  lw $t2, 0($t0) 	# load with offset
	  sw $t2, -120($fp)	# spill _tmp52 from $t2 to $fp-120
	# _tmp53 = *(_tmp52 + 8)
	  lw $t0, -120($fp)	# fill _tmp52 to $t0 from $fp-120
	  lw $t2, 8($t0) 	# load with offset
	  sw $t2, -124($fp)	# spill _tmp53 from $t2 to $fp-124
	# _tmp54 = ACall _tmp53
	  lw $t0, -124($fp)	# fill _tmp53 to $t0 from $fp-124
	  jalr $t0            	# jump to function
	  move $t2, $v0		# copy function return value from $v0
	  sw $t2, -128($fp)	# spill _tmp54 from $t2 to $fp-128
	# PopParams 4
	  add $sp, $sp, 4	# pop params off stack
	# PushParam _tmp54
	  subu $sp, $sp, 4	# decrement sp to make space for param
	  lw $t0, -128($fp)	# fill _tmp54 to $t0 from $fp-128
	  sw $t0, 4($sp)	# copy param value to stack
	# _tmp55 = *(_tmp54)
	  lw $t0, -128($fp)	# fill _tmp54 to $t0 from $fp-128
	  lw $t2, 0($t0) 	# load with offset
	  sw $t2, -132($fp)	# spill _tmp55 from $t2 to $fp-132
	# _tmp56 = *(_tmp55 + 20)
	  lw $t0, -132($fp)	# fill _tmp55 to $t0 from $fp-132
	  lw $t2, 20($t0) 	# load with offset
	  sw $t2, -136($fp)	# spill _tmp56 from $t2 to $fp-136
	# ACall _tmp56
	  lw $t0, -136($fp)	# fill _tmp56 to $t0 from $fp-136
	  jalr $t0            	# jump to function
	# PopParams 8
	  add $sp, $sp, 8	# pop params off stack
  _L1:
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
	# VTable for class Queue
	  .data
	  .align 2
	  Queue:		# label for class Queue vtable
	  .word Queue.____Init
	  .word Queue.____EnQueue
	  .word Queue.____DeQueue
	  .text
  main:
	# BeginFunc 280
	  subu $sp, $sp, 8	# decrement sp to make space to save ra, fp
	  sw $fp, 8($sp)	# save fp
	  sw $ra, 4($sp)	# save ra
	  addiu $fp, $sp, 8	# set up new fp
	  subu $sp, $sp, 280	# decrement sp to make space for locals/temps
	# _tmp57 = 4
	  li $t2, 4		# load constant value 4 into $t2
	  sw $t2, -16($fp)	# spill _tmp57 from $t2 to $fp-16
	# _tmp58 = 4
	  li $t2, 4		# load constant value 4 into $t2
	  sw $t2, -20($fp)	# spill _tmp58 from $t2 to $fp-20
	# _tmp59 = _tmp58 + _tmp57
	  lw $t0, -20($fp)	# fill _tmp58 to $t0 from $fp-20
	  lw $t1, -16($fp)	# fill _tmp57 to $t1 from $fp-16
	  add $t2, $t0, $t1	
	  sw $t2, -24($fp)	# spill _tmp59 from $t2 to $fp-24
	# PushParam _tmp59
	  subu $sp, $sp, 4	# decrement sp to make space for param
	  lw $t0, -24($fp)	# fill _tmp59 to $t0 from $fp-24
	  sw $t0, 4($sp)	# copy param value to stack
	# _tmp60 = LCall _Alloc
	  jal _Alloc         	# jump to function
	  move $t2, $v0		# copy function return value from $v0
	  sw $t2, -28($fp)	# spill _tmp60 from $t2 to $fp-28
	# PopParams 4
	  add $sp, $sp, 4	# pop params off stack
	# _tmp61 = Queue
	  la $t2, Queue	# load label
	  sw $t2, -32($fp)	# spill _tmp61 from $t2 to $fp-32
	# *(_tmp60) = _tmp61
	  lw $t0, -32($fp)	# fill _tmp61 to $t0 from $fp-32
	  lw $t2, -28($fp)	# fill _tmp60 to $t2 from $fp-28
	  sw $t0, 0($t2) 	# store with offset
	# q = _tmp60
	  lw $t2, -28($fp)	# fill _tmp60 to $t2 from $fp-28
	  sw $t2, -8($fp)	# spill q from $t2 to $fp-8
	# PushParam q
	  subu $sp, $sp, 4	# decrement sp to make space for param
	  lw $t0, -8($fp)	# fill q to $t0 from $fp-8
	  sw $t0, 4($sp)	# copy param value to stack
	# _tmp62 = *(q)
	  lw $t0, -8($fp)	# fill q to $t0 from $fp-8
	  lw $t2, 0($t0) 	# load with offset
	  sw $t2, -36($fp)	# spill _tmp62 from $t2 to $fp-36
	# _tmp63 = *(_tmp62)
	  lw $t0, -36($fp)	# fill _tmp62 to $t0 from $fp-36
	  lw $t2, 0($t0) 	# load with offset
	  sw $t2, -40($fp)	# spill _tmp63 from $t2 to $fp-40
	# ACall _tmp63
	  lw $t0, -40($fp)	# fill _tmp63 to $t0 from $fp-40
	  jalr $t0            	# jump to function
	# PopParams 4
	  add $sp, $sp, 4	# pop params off stack
	# _tmp64 = 0
	  li $t2, 0		# load constant value 0 into $t2
	  sw $t2, -44($fp)	# spill _tmp64 from $t2 to $fp-44
	# i = _tmp64
	  lw $t2, -44($fp)	# fill _tmp64 to $t2 from $fp-44
	  sw $t2, -12($fp)	# spill i from $t2 to $fp-12
  _L2:
	# _tmp66 = 10
	  li $t2, 10		# load constant value 10 into $t2
	  sw $t2, -52($fp)	# spill _tmp66 from $t2 to $fp-52
	# _tmp67 = i == _tmp66
	  lw $t0, -12($fp)	# fill i to $t0 from $fp-12
	  lw $t1, -52($fp)	# fill _tmp66 to $t1 from $fp-52
	  seq $t2, $t0, $t1	
	  sw $t2, -56($fp)	# spill _tmp67 from $t2 to $fp-56
	# IfZ _tmp67 Goto _L5
	  lw $t0, -56($fp)	# fill _tmp67 to $t0 from $fp-56
	  beqz $t0, _L5	# branch if _tmp67 is zero 
	# _tmp68 = 0
	  li $t2, 0		# load constant value 0 into $t2
	  sw $t2, -60($fp)	# spill _tmp68 from $t2 to $fp-60
	# _tmp65 = _tmp68
	  lw $t2, -60($fp)	# fill _tmp68 to $t2 from $fp-60
	  sw $t2, -48($fp)	# spill _tmp65 from $t2 to $fp-48
	# Goto _L4
	  b _L4		# unconditional branch
  _L5:
	# _tmp69 = 1
	  li $t2, 1		# load constant value 1 into $t2
	  sw $t2, -64($fp)	# spill _tmp69 from $t2 to $fp-64
	# _tmp65 = _tmp69
	  lw $t2, -64($fp)	# fill _tmp69 to $t2 from $fp-64
	  sw $t2, -48($fp)	# spill _tmp65 from $t2 to $fp-48
  _L4:
	# IfZ _tmp65 Goto _L3
	  lw $t0, -48($fp)	# fill _tmp65 to $t0 from $fp-48
	  beqz $t0, _L3	# branch if _tmp65 is zero 
	# PushParam i
	  subu $sp, $sp, 4	# decrement sp to make space for param
	  lw $t0, -12($fp)	# fill i to $t0 from $fp-12
	  sw $t0, 4($sp)	# copy param value to stack
	# PushParam q
	  subu $sp, $sp, 4	# decrement sp to make space for param
	  lw $t0, -8($fp)	# fill q to $t0 from $fp-8
	  sw $t0, 4($sp)	# copy param value to stack
	# _tmp70 = *(q)
	  lw $t0, -8($fp)	# fill q to $t0 from $fp-8
	  lw $t2, 0($t0) 	# load with offset
	  sw $t2, -68($fp)	# spill _tmp70 from $t2 to $fp-68
	# _tmp71 = *(_tmp70 + 4)
	  lw $t0, -68($fp)	# fill _tmp70 to $t0 from $fp-68
	  lw $t2, 4($t0) 	# load with offset
	  sw $t2, -72($fp)	# spill _tmp71 from $t2 to $fp-72
	# ACall _tmp71
	  lw $t0, -72($fp)	# fill _tmp71 to $t0 from $fp-72
	  jalr $t0            	# jump to function
	# PopParams 8
	  add $sp, $sp, 8	# pop params off stack
	# _tmp72 = 1
	  li $t2, 1		# load constant value 1 into $t2
	  sw $t2, -76($fp)	# spill _tmp72 from $t2 to $fp-76
	# _tmp73 = i + _tmp72
	  lw $t0, -12($fp)	# fill i to $t0 from $fp-12
	  lw $t1, -76($fp)	# fill _tmp72 to $t1 from $fp-76
	  add $t2, $t0, $t1	
	  sw $t2, -80($fp)	# spill _tmp73 from $t2 to $fp-80
	# i = _tmp73
	  lw $t2, -80($fp)	# fill _tmp73 to $t2 from $fp-80
	  sw $t2, -12($fp)	# spill i from $t2 to $fp-12
	# Goto _L2
	  b _L2		# unconditional branch
  _L3:
	# _tmp74 = 0
	  li $t2, 0		# load constant value 0 into $t2
	  sw $t2, -84($fp)	# spill _tmp74 from $t2 to $fp-84
	# i = _tmp74
	  lw $t2, -84($fp)	# fill _tmp74 to $t2 from $fp-84
	  sw $t2, -12($fp)	# spill i from $t2 to $fp-12
  _L6:
	# _tmp76 = 4
	  li $t2, 4		# load constant value 4 into $t2
	  sw $t2, -92($fp)	# spill _tmp76 from $t2 to $fp-92
	# _tmp77 = i == _tmp76
	  lw $t0, -12($fp)	# fill i to $t0 from $fp-12
	  lw $t1, -92($fp)	# fill _tmp76 to $t1 from $fp-92
	  seq $t2, $t0, $t1	
	  sw $t2, -96($fp)	# spill _tmp77 from $t2 to $fp-96
	# IfZ _tmp77 Goto _L9
	  lw $t0, -96($fp)	# fill _tmp77 to $t0 from $fp-96
	  beqz $t0, _L9	# branch if _tmp77 is zero 
	# _tmp78 = 0
	  li $t2, 0		# load constant value 0 into $t2
	  sw $t2, -100($fp)	# spill _tmp78 from $t2 to $fp-100
	# _tmp75 = _tmp78
	  lw $t2, -100($fp)	# fill _tmp78 to $t2 from $fp-100
	  sw $t2, -88($fp)	# spill _tmp75 from $t2 to $fp-88
	# Goto _L8
	  b _L8		# unconditional branch
  _L9:
	# _tmp79 = 1
	  li $t2, 1		# load constant value 1 into $t2
	  sw $t2, -104($fp)	# spill _tmp79 from $t2 to $fp-104
	# _tmp75 = _tmp79
	  lw $t2, -104($fp)	# fill _tmp79 to $t2 from $fp-104
	  sw $t2, -88($fp)	# spill _tmp75 from $t2 to $fp-88
  _L8:
	# IfZ _tmp75 Goto _L7
	  lw $t0, -88($fp)	# fill _tmp75 to $t0 from $fp-88
	  beqz $t0, _L7	# branch if _tmp75 is zero 
	# PushParam q
	  subu $sp, $sp, 4	# decrement sp to make space for param
	  lw $t0, -8($fp)	# fill q to $t0 from $fp-8
	  sw $t0, 4($sp)	# copy param value to stack
	# _tmp80 = *(q)
	  lw $t0, -8($fp)	# fill q to $t0 from $fp-8
	  lw $t2, 0($t0) 	# load with offset
	  sw $t2, -108($fp)	# spill _tmp80 from $t2 to $fp-108
	# _tmp81 = *(_tmp80 + 8)
	  lw $t0, -108($fp)	# fill _tmp80 to $t0 from $fp-108
	  lw $t2, 8($t0) 	# load with offset
	  sw $t2, -112($fp)	# spill _tmp81 from $t2 to $fp-112
	# _tmp82 = ACall _tmp81
	  lw $t0, -112($fp)	# fill _tmp81 to $t0 from $fp-112
	  jalr $t0            	# jump to function
	  move $t2, $v0		# copy function return value from $v0
	  sw $t2, -116($fp)	# spill _tmp82 from $t2 to $fp-116
	# PopParams 4
	  add $sp, $sp, 4	# pop params off stack
	# PushParam _tmp82
	  subu $sp, $sp, 4	# decrement sp to make space for param
	  lw $t0, -116($fp)	# fill _tmp82 to $t0 from $fp-116
	  sw $t0, 4($sp)	# copy param value to stack
	# LCall _PrintInt
	  jal _PrintInt      	# jump to function
	# PopParams 4
	  add $sp, $sp, 4	# pop params off stack
	# _tmp83 = " "
	  .data			# create string constant marked with label
	  _string2: .asciiz " "
	  .text
	  la $t2, _string2	# load label
	  sw $t2, -120($fp)	# spill _tmp83 from $t2 to $fp-120
	# PushParam _tmp83
	  subu $sp, $sp, 4	# decrement sp to make space for param
	  lw $t0, -120($fp)	# fill _tmp83 to $t0 from $fp-120
	  sw $t0, 4($sp)	# copy param value to stack
	# LCall _PrintString
	  jal _PrintString   	# jump to function
	# PopParams 4
	  add $sp, $sp, 4	# pop params off stack
	# _tmp84 = 1
	  li $t2, 1		# load constant value 1 into $t2
	  sw $t2, -124($fp)	# spill _tmp84 from $t2 to $fp-124
	# _tmp85 = i + _tmp84
	  lw $t0, -12($fp)	# fill i to $t0 from $fp-12
	  lw $t1, -124($fp)	# fill _tmp84 to $t1 from $fp-124
	  add $t2, $t0, $t1	
	  sw $t2, -128($fp)	# spill _tmp85 from $t2 to $fp-128
	# i = _tmp85
	  lw $t2, -128($fp)	# fill _tmp85 to $t2 from $fp-128
	  sw $t2, -12($fp)	# spill i from $t2 to $fp-12
	# Goto _L6
	  b _L6		# unconditional branch
  _L7:
	# _tmp86 = "\n"
	  .data			# create string constant marked with label
	  _string3: .asciiz "\n"
	  .text
	  la $t2, _string3	# load label
	  sw $t2, -132($fp)	# spill _tmp86 from $t2 to $fp-132
	# PushParam _tmp86
	  subu $sp, $sp, 4	# decrement sp to make space for param
	  lw $t0, -132($fp)	# fill _tmp86 to $t0 from $fp-132
	  sw $t0, 4($sp)	# copy param value to stack
	# LCall _PrintString
	  jal _PrintString   	# jump to function
	# PopParams 4
	  add $sp, $sp, 4	# pop params off stack
	# _tmp87 = 0
	  li $t2, 0		# load constant value 0 into $t2
	  sw $t2, -136($fp)	# spill _tmp87 from $t2 to $fp-136
	# i = _tmp87
	  lw $t2, -136($fp)	# fill _tmp87 to $t2 from $fp-136
	  sw $t2, -12($fp)	# spill i from $t2 to $fp-12
  _L10:
	# _tmp89 = 10
	  li $t2, 10		# load constant value 10 into $t2
	  sw $t2, -144($fp)	# spill _tmp89 from $t2 to $fp-144
	# _tmp90 = i == _tmp89
	  lw $t0, -12($fp)	# fill i to $t0 from $fp-12
	  lw $t1, -144($fp)	# fill _tmp89 to $t1 from $fp-144
	  seq $t2, $t0, $t1	
	  sw $t2, -148($fp)	# spill _tmp90 from $t2 to $fp-148
	# IfZ _tmp90 Goto _L13
	  lw $t0, -148($fp)	# fill _tmp90 to $t0 from $fp-148
	  beqz $t0, _L13	# branch if _tmp90 is zero 
	# _tmp91 = 0
	  li $t2, 0		# load constant value 0 into $t2
	  sw $t2, -152($fp)	# spill _tmp91 from $t2 to $fp-152
	# _tmp88 = _tmp91
	  lw $t2, -152($fp)	# fill _tmp91 to $t2 from $fp-152
	  sw $t2, -140($fp)	# spill _tmp88 from $t2 to $fp-140
	# Goto _L12
	  b _L12		# unconditional branch
  _L13:
	# _tmp92 = 1
	  li $t2, 1		# load constant value 1 into $t2
	  sw $t2, -156($fp)	# spill _tmp92 from $t2 to $fp-156
	# _tmp88 = _tmp92
	  lw $t2, -156($fp)	# fill _tmp92 to $t2 from $fp-156
	  sw $t2, -140($fp)	# spill _tmp88 from $t2 to $fp-140
  _L12:
	# IfZ _tmp88 Goto _L11
	  lw $t0, -140($fp)	# fill _tmp88 to $t0 from $fp-140
	  beqz $t0, _L11	# branch if _tmp88 is zero 
	# PushParam i
	  subu $sp, $sp, 4	# decrement sp to make space for param
	  lw $t0, -12($fp)	# fill i to $t0 from $fp-12
	  sw $t0, 4($sp)	# copy param value to stack
	# PushParam q
	  subu $sp, $sp, 4	# decrement sp to make space for param
	  lw $t0, -8($fp)	# fill q to $t0 from $fp-8
	  sw $t0, 4($sp)	# copy param value to stack
	# _tmp93 = *(q)
	  lw $t0, -8($fp)	# fill q to $t0 from $fp-8
	  lw $t2, 0($t0) 	# load with offset
	  sw $t2, -160($fp)	# spill _tmp93 from $t2 to $fp-160
	# _tmp94 = *(_tmp93 + 4)
	  lw $t0, -160($fp)	# fill _tmp93 to $t0 from $fp-160
	  lw $t2, 4($t0) 	# load with offset
	  sw $t2, -164($fp)	# spill _tmp94 from $t2 to $fp-164
	# ACall _tmp94
	  lw $t0, -164($fp)	# fill _tmp94 to $t0 from $fp-164
	  jalr $t0            	# jump to function
	# PopParams 8
	  add $sp, $sp, 8	# pop params off stack
	# _tmp95 = 1
	  li $t2, 1		# load constant value 1 into $t2
	  sw $t2, -168($fp)	# spill _tmp95 from $t2 to $fp-168
	# _tmp96 = i + _tmp95
	  lw $t0, -12($fp)	# fill i to $t0 from $fp-12
	  lw $t1, -168($fp)	# fill _tmp95 to $t1 from $fp-168
	  add $t2, $t0, $t1	
	  sw $t2, -172($fp)	# spill _tmp96 from $t2 to $fp-172
	# i = _tmp96
	  lw $t2, -172($fp)	# fill _tmp96 to $t2 from $fp-172
	  sw $t2, -12($fp)	# spill i from $t2 to $fp-12
	# Goto _L10
	  b _L10		# unconditional branch
  _L11:
	# _tmp97 = 0
	  li $t2, 0		# load constant value 0 into $t2
	  sw $t2, -176($fp)	# spill _tmp97 from $t2 to $fp-176
	# i = _tmp97
	  lw $t2, -176($fp)	# fill _tmp97 to $t2 from $fp-176
	  sw $t2, -12($fp)	# spill i from $t2 to $fp-12
  _L14:
	# _tmp99 = 17
	  li $t2, 17		# load constant value 17 into $t2
	  sw $t2, -184($fp)	# spill _tmp99 from $t2 to $fp-184
	# _tmp100 = i == _tmp99
	  lw $t0, -12($fp)	# fill i to $t0 from $fp-12
	  lw $t1, -184($fp)	# fill _tmp99 to $t1 from $fp-184
	  seq $t2, $t0, $t1	
	  sw $t2, -188($fp)	# spill _tmp100 from $t2 to $fp-188
	# IfZ _tmp100 Goto _L17
	  lw $t0, -188($fp)	# fill _tmp100 to $t0 from $fp-188
	  beqz $t0, _L17	# branch if _tmp100 is zero 
	# _tmp101 = 0
	  li $t2, 0		# load constant value 0 into $t2
	  sw $t2, -192($fp)	# spill _tmp101 from $t2 to $fp-192
	# _tmp98 = _tmp101
	  lw $t2, -192($fp)	# fill _tmp101 to $t2 from $fp-192
	  sw $t2, -180($fp)	# spill _tmp98 from $t2 to $fp-180
	# Goto _L16
	  b _L16		# unconditional branch
  _L17:
	# _tmp102 = 1
	  li $t2, 1		# load constant value 1 into $t2
	  sw $t2, -196($fp)	# spill _tmp102 from $t2 to $fp-196
	# _tmp98 = _tmp102
	  lw $t2, -196($fp)	# fill _tmp102 to $t2 from $fp-196
	  sw $t2, -180($fp)	# spill _tmp98 from $t2 to $fp-180
  _L16:
	# IfZ _tmp98 Goto _L15
	  lw $t0, -180($fp)	# fill _tmp98 to $t0 from $fp-180
	  beqz $t0, _L15	# branch if _tmp98 is zero 
	# PushParam q
	  subu $sp, $sp, 4	# decrement sp to make space for param
	  lw $t0, -8($fp)	# fill q to $t0 from $fp-8
	  sw $t0, 4($sp)	# copy param value to stack
	# _tmp103 = *(q)
	  lw $t0, -8($fp)	# fill q to $t0 from $fp-8
	  lw $t2, 0($t0) 	# load with offset
	  sw $t2, -200($fp)	# spill _tmp103 from $t2 to $fp-200
	# _tmp104 = *(_tmp103 + 8)
	  lw $t0, -200($fp)	# fill _tmp103 to $t0 from $fp-200
	  lw $t2, 8($t0) 	# load with offset
	  sw $t2, -204($fp)	# spill _tmp104 from $t2 to $fp-204
	# _tmp105 = ACall _tmp104
	  lw $t0, -204($fp)	# fill _tmp104 to $t0 from $fp-204
	  jalr $t0            	# jump to function
	  move $t2, $v0		# copy function return value from $v0
	  sw $t2, -208($fp)	# spill _tmp105 from $t2 to $fp-208
	# PopParams 4
	  add $sp, $sp, 4	# pop params off stack
	# PushParam _tmp105
	  subu $sp, $sp, 4	# decrement sp to make space for param
	  lw $t0, -208($fp)	# fill _tmp105 to $t0 from $fp-208
	  sw $t0, 4($sp)	# copy param value to stack
	# LCall _PrintInt
	  jal _PrintInt      	# jump to function
	# PopParams 4
	  add $sp, $sp, 4	# pop params off stack
	# _tmp106 = " "
	  .data			# create string constant marked with label
	  _string4: .asciiz " "
	  .text
	  la $t2, _string4	# load label
	  sw $t2, -212($fp)	# spill _tmp106 from $t2 to $fp-212
	# PushParam _tmp106
	  subu $sp, $sp, 4	# decrement sp to make space for param
	  lw $t0, -212($fp)	# fill _tmp106 to $t0 from $fp-212
	  sw $t0, 4($sp)	# copy param value to stack
	# LCall _PrintString
	  jal _PrintString   	# jump to function
	# PopParams 4
	  add $sp, $sp, 4	# pop params off stack
	# _tmp107 = 1
	  li $t2, 1		# load constant value 1 into $t2
	  sw $t2, -216($fp)	# spill _tmp107 from $t2 to $fp-216
	# _tmp108 = i + _tmp107
	  lw $t0, -12($fp)	# fill i to $t0 from $fp-12
	  lw $t1, -216($fp)	# fill _tmp107 to $t1 from $fp-216
	  add $t2, $t0, $t1	
	  sw $t2, -220($fp)	# spill _tmp108 from $t2 to $fp-220
	# i = _tmp108
	  lw $t2, -220($fp)	# fill _tmp108 to $t2 from $fp-220
	  sw $t2, -12($fp)	# spill i from $t2 to $fp-12
	# Goto _L14
	  b _L14		# unconditional branch
  _L15:
	# _tmp109 = "\n"
	  .data			# create string constant marked with label
	  _string5: .asciiz "\n"
	  .text
	  la $t2, _string5	# load label
	  sw $t2, -224($fp)	# spill _tmp109 from $t2 to $fp-224
	# PushParam _tmp109
	  subu $sp, $sp, 4	# decrement sp to make space for param
	  lw $t0, -224($fp)	# fill _tmp109 to $t0 from $fp-224
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
