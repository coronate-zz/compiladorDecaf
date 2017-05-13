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
	  
  Animal.____InitAnimal:
	# BeginFunc 0
	  subu $sp, $sp, 8	# decrement sp to make space to save ra, fp
	  sw $fp, 8($sp)	# save fp
	  sw $ra, 4($sp)	# save ra
	  addiu $fp, $sp, 8	# set up new fp
	# *(this + 4) = h
	  lw $t0, 8($fp)	# fill h to $t0 from $fp+8
	  lw $t2, 4($fp)	# fill this to $t2 from $fp+4
	  sw $t0, 4($t2) 	# store with offset
	# *(this + 8) = mom
	  lw $t0, 12($fp)	# fill mom to $t0 from $fp+12
	  lw $t2, 4($fp)	# fill this to $t2 from $fp+4
	  sw $t0, 8($t2) 	# store with offset
	# EndFunc
	# (below handles reaching end of fn body with no explicit return)
	  move $sp, $fp		# pop callee frame off stack
	  lw $ra, -4($fp)	# restore saved ra
	  lw $fp, 0($fp)	# restore saved fp
	  jr $ra		# return from function
  Animal.____GetHeight:
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
  Animal.____GetMom:
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
	# VTable for class Animal
	  .data
	  .align 2
	  Animal:		# label for class Animal vtable
	  .word Animal.____InitAnimal
	  .word Animal.____GetHeight
	  .word Animal.____GetMom
	  .text
  Cow.____InitCow:
	# BeginFunc 8
	  subu $sp, $sp, 8	# decrement sp to make space to save ra, fp
	  sw $fp, 8($sp)	# save fp
	  sw $ra, 4($sp)	# save ra
	  addiu $fp, $sp, 8	# set up new fp
	  subu $sp, $sp, 8	# decrement sp to make space for locals/temps
	# *(this + 12) = spot
	  lw $t0, 16($fp)	# fill spot to $t0 from $fp+16
	  lw $t2, 4($fp)	# fill this to $t2 from $fp+4
	  sw $t0, 12($t2) 	# store with offset
	# PushParam m
	  subu $sp, $sp, 4	# decrement sp to make space for param
	  lw $t0, 12($fp)	# fill m to $t0 from $fp+12
	  sw $t0, 4($sp)	# copy param value to stack
	# PushParam h
	  subu $sp, $sp, 4	# decrement sp to make space for param
	  lw $t0, 8($fp)	# fill h to $t0 from $fp+8
	  sw $t0, 4($sp)	# copy param value to stack
	# PushParam this
	  subu $sp, $sp, 4	# decrement sp to make space for param
	  lw $t0, 4($fp)	# fill this to $t0 from $fp+4
	  sw $t0, 4($sp)	# copy param value to stack
	# _tmp2 = *(this)
	  lw $t0, 4($fp)	# fill this to $t0 from $fp+4
	  lw $t2, 0($t0) 	# load with offset
	  sw $t2, -8($fp)	# spill _tmp2 from $t2 to $fp-8
	# _tmp3 = *(_tmp2)
	  lw $t0, -8($fp)	# fill _tmp2 to $t0 from $fp-8
	  lw $t2, 0($t0) 	# load with offset
	  sw $t2, -12($fp)	# spill _tmp3 from $t2 to $fp-12
	# ACall _tmp3
	  lw $t0, -12($fp)	# fill _tmp3 to $t0 from $fp-12
	  jalr $t0            	# jump to function
	# PopParams 12
	  add $sp, $sp, 12	# pop params off stack
	# EndFunc
	# (below handles reaching end of fn body with no explicit return)
	  move $sp, $fp		# pop callee frame off stack
	  lw $ra, -4($fp)	# restore saved ra
	  lw $fp, 0($fp)	# restore saved fp
	  jr $ra		# return from function
  Cow.____IsSpottedCow:
	# BeginFunc 4
	  subu $sp, $sp, 8	# decrement sp to make space to save ra, fp
	  sw $fp, 8($sp)	# save fp
	  sw $ra, 4($sp)	# save ra
	  addiu $fp, $sp, 8	# set up new fp
	  subu $sp, $sp, 4	# decrement sp to make space for locals/temps
	# _tmp4 = *(this + 12)
	  lw $t0, 4($fp)	# fill this to $t0 from $fp+4
	  lw $t2, 12($t0) 	# load with offset
	  sw $t2, -8($fp)	# spill _tmp4 from $t2 to $fp-8
	# Return _tmp4
	  lw $t2, -8($fp)	# fill _tmp4 to $t2 from $fp-8
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
	# VTable for class Cow
	  .data
	  .align 2
	  Cow:		# label for class Cow vtable
	  .word Animal.____InitAnimal
	  .word Animal.____GetHeight
	  .word Animal.____GetMom
	  .word Cow.____InitCow
	  .word Cow.____IsSpottedCow
	  .text
  main:
	# BeginFunc 112
	  subu $sp, $sp, 8	# decrement sp to make space to save ra, fp
	  sw $fp, 8($sp)	# save fp
	  sw $ra, 4($sp)	# save ra
	  addiu $fp, $sp, 8	# set up new fp
	  subu $sp, $sp, 112	# decrement sp to make space for locals/temps
	# _tmp5 = 12
	  li $t2, 12		# load constant value 12 into $t2
	  sw $t2, -16($fp)	# spill _tmp5 from $t2 to $fp-16
	# _tmp6 = 4
	  li $t2, 4		# load constant value 4 into $t2
	  sw $t2, -20($fp)	# spill _tmp6 from $t2 to $fp-20
	# _tmp7 = _tmp6 + _tmp5
	  lw $t0, -20($fp)	# fill _tmp6 to $t0 from $fp-20
	  lw $t1, -16($fp)	# fill _tmp5 to $t1 from $fp-16
	  add $t2, $t0, $t1	
	  sw $t2, -24($fp)	# spill _tmp7 from $t2 to $fp-24
	# PushParam _tmp7
	  subu $sp, $sp, 4	# decrement sp to make space for param
	  lw $t0, -24($fp)	# fill _tmp7 to $t0 from $fp-24
	  sw $t0, 4($sp)	# copy param value to stack
	# _tmp8 = LCall _Alloc
	  jal _Alloc         	# jump to function
	  move $t2, $v0		# copy function return value from $v0
	  sw $t2, -28($fp)	# spill _tmp8 from $t2 to $fp-28
	# PopParams 4
	  add $sp, $sp, 4	# pop params off stack
	# _tmp9 = Cow
	  la $t2, Cow	# load label
	  sw $t2, -32($fp)	# spill _tmp9 from $t2 to $fp-32
	# *(_tmp8) = _tmp9
	  lw $t0, -32($fp)	# fill _tmp9 to $t0 from $fp-32
	  lw $t2, -28($fp)	# fill _tmp8 to $t2 from $fp-28
	  sw $t0, 0($t2) 	# store with offset
	# betsy = _tmp8
	  lw $t2, -28($fp)	# fill _tmp8 to $t2 from $fp-28
	  sw $t2, -8($fp)	# spill betsy from $t2 to $fp-8
	# _tmp10 = 5
	  li $t2, 5		# load constant value 5 into $t2
	  sw $t2, -36($fp)	# spill _tmp10 from $t2 to $fp-36
	# _tmp11 = 0
	  li $t2, 0		# load constant value 0 into $t2
	  sw $t2, -40($fp)	# spill _tmp11 from $t2 to $fp-40
	# _tmp12 = 1
	  li $t2, 1		# load constant value 1 into $t2
	  sw $t2, -44($fp)	# spill _tmp12 from $t2 to $fp-44
	# PushParam _tmp12
	  subu $sp, $sp, 4	# decrement sp to make space for param
	  lw $t0, -44($fp)	# fill _tmp12 to $t0 from $fp-44
	  sw $t0, 4($sp)	# copy param value to stack
	# PushParam _tmp11
	  subu $sp, $sp, 4	# decrement sp to make space for param
	  lw $t0, -40($fp)	# fill _tmp11 to $t0 from $fp-40
	  sw $t0, 4($sp)	# copy param value to stack
	# PushParam _tmp10
	  subu $sp, $sp, 4	# decrement sp to make space for param
	  lw $t0, -36($fp)	# fill _tmp10 to $t0 from $fp-36
	  sw $t0, 4($sp)	# copy param value to stack
	# PushParam betsy
	  subu $sp, $sp, 4	# decrement sp to make space for param
	  lw $t0, -8($fp)	# fill betsy to $t0 from $fp-8
	  sw $t0, 4($sp)	# copy param value to stack
	# _tmp13 = *(betsy)
	  lw $t0, -8($fp)	# fill betsy to $t0 from $fp-8
	  lw $t2, 0($t0) 	# load with offset
	  sw $t2, -48($fp)	# spill _tmp13 from $t2 to $fp-48
	# _tmp14 = *(_tmp13 + 12)
	  lw $t0, -48($fp)	# fill _tmp13 to $t0 from $fp-48
	  lw $t2, 12($t0) 	# load with offset
	  sw $t2, -52($fp)	# spill _tmp14 from $t2 to $fp-52
	# ACall _tmp14
	  lw $t0, -52($fp)	# fill _tmp14 to $t0 from $fp-52
	  jalr $t0            	# jump to function
	# PopParams 16
	  add $sp, $sp, 16	# pop params off stack
	# b = betsy
	  lw $t2, -8($fp)	# fill betsy to $t2 from $fp-8
	  sw $t2, -12($fp)	# spill b from $t2 to $fp-12
	# PushParam b
	  subu $sp, $sp, 4	# decrement sp to make space for param
	  lw $t0, -12($fp)	# fill b to $t0 from $fp-12
	  sw $t0, 4($sp)	# copy param value to stack
	# _tmp15 = *(b)
	  lw $t0, -12($fp)	# fill b to $t0 from $fp-12
	  lw $t2, 0($t0) 	# load with offset
	  sw $t2, -56($fp)	# spill _tmp15 from $t2 to $fp-56
	# _tmp16 = *(_tmp15 + 8)
	  lw $t0, -56($fp)	# fill _tmp15 to $t0 from $fp-56
	  lw $t2, 8($t0) 	# load with offset
	  sw $t2, -60($fp)	# spill _tmp16 from $t2 to $fp-60
	# _tmp17 = ACall _tmp16
	  lw $t0, -60($fp)	# fill _tmp16 to $t0 from $fp-60
	  jalr $t0            	# jump to function
	  move $t2, $v0		# copy function return value from $v0
	  sw $t2, -64($fp)	# spill _tmp17 from $t2 to $fp-64
	# PopParams 4
	  add $sp, $sp, 4	# pop params off stack
	# _tmp18 = "spots: "
	  .data			# create string constant marked with label
	  _string1: .asciiz "spots: "
	  .text
	  la $t2, _string1	# load label
	  sw $t2, -68($fp)	# spill _tmp18 from $t2 to $fp-68
	# PushParam _tmp18
	  subu $sp, $sp, 4	# decrement sp to make space for param
	  lw $t0, -68($fp)	# fill _tmp18 to $t0 from $fp-68
	  sw $t0, 4($sp)	# copy param value to stack
	# LCall _PrintString
	  jal _PrintString   	# jump to function
	# PopParams 4
	  add $sp, $sp, 4	# pop params off stack
	# PushParam betsy
	  subu $sp, $sp, 4	# decrement sp to make space for param
	  lw $t0, -8($fp)	# fill betsy to $t0 from $fp-8
	  sw $t0, 4($sp)	# copy param value to stack
	# _tmp19 = *(betsy)
	  lw $t0, -8($fp)	# fill betsy to $t0 from $fp-8
	  lw $t2, 0($t0) 	# load with offset
	  sw $t2, -72($fp)	# spill _tmp19 from $t2 to $fp-72
	# _tmp20 = *(_tmp19 + 16)
	  lw $t0, -72($fp)	# fill _tmp19 to $t0 from $fp-72
	  lw $t2, 16($t0) 	# load with offset
	  sw $t2, -76($fp)	# spill _tmp20 from $t2 to $fp-76
	# _tmp21 = ACall _tmp20
	  lw $t0, -76($fp)	# fill _tmp20 to $t0 from $fp-76
	  jalr $t0            	# jump to function
	  move $t2, $v0		# copy function return value from $v0
	  sw $t2, -80($fp)	# spill _tmp21 from $t2 to $fp-80
	# PopParams 4
	  add $sp, $sp, 4	# pop params off stack
	# PushParam _tmp21
	  subu $sp, $sp, 4	# decrement sp to make space for param
	  lw $t0, -80($fp)	# fill _tmp21 to $t0 from $fp-80
	  sw $t0, 4($sp)	# copy param value to stack
	# LCall _PrintBool
	  jal _PrintBool     	# jump to function
	# PopParams 4
	  add $sp, $sp, 4	# pop params off stack
	# _tmp22 = "    height: "
	  .data			# create string constant marked with label
	  _string2: .asciiz "    height: "
	  .text
	  la $t2, _string2	# load label
	  sw $t2, -84($fp)	# spill _tmp22 from $t2 to $fp-84
	# PushParam _tmp22
	  subu $sp, $sp, 4	# decrement sp to make space for param
	  lw $t0, -84($fp)	# fill _tmp22 to $t0 from $fp-84
	  sw $t0, 4($sp)	# copy param value to stack
	# LCall _PrintString
	  jal _PrintString   	# jump to function
	# PopParams 4
	  add $sp, $sp, 4	# pop params off stack
	# PushParam b
	  subu $sp, $sp, 4	# decrement sp to make space for param
	  lw $t0, -12($fp)	# fill b to $t0 from $fp-12
	  sw $t0, 4($sp)	# copy param value to stack
	# _tmp23 = *(b)
	  lw $t0, -12($fp)	# fill b to $t0 from $fp-12
	  lw $t2, 0($t0) 	# load with offset
	  sw $t2, -88($fp)	# spill _tmp23 from $t2 to $fp-88
	# _tmp24 = *(_tmp23 + 4)
	  lw $t0, -88($fp)	# fill _tmp23 to $t0 from $fp-88
	  lw $t2, 4($t0) 	# load with offset
	  sw $t2, -92($fp)	# spill _tmp24 from $t2 to $fp-92
	# _tmp25 = ACall _tmp24
	  lw $t0, -92($fp)	# fill _tmp24 to $t0 from $fp-92
	  jalr $t0            	# jump to function
	  move $t2, $v0		# copy function return value from $v0
	  sw $t2, -96($fp)	# spill _tmp25 from $t2 to $fp-96
	# PopParams 4
	  add $sp, $sp, 4	# pop params off stack
	# PushParam _tmp25
	  subu $sp, $sp, 4	# decrement sp to make space for param
	  lw $t0, -96($fp)	# fill _tmp25 to $t0 from $fp-96
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
