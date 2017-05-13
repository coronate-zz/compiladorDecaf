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
	  
  ____PrintLine:
	# BeginFunc 4
	  subu $sp, $sp, 8	# decrement sp to make space to save ra, fp
	  sw $fp, 8($sp)	# save fp
	  sw $ra, 4($sp)	# save ra
	  addiu $fp, $sp, 8	# set up new fp
	  subu $sp, $sp, 4	# decrement sp to make space for locals/temps
	# _tmp0 = "-------------------------------------------------..."
	  .data			# create string constant marked with label
	  _string1: .asciiz "------------------------------------------------------------------------\n"
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
	# EndFunc
	# (below handles reaching end of fn body with no explicit return)
	  move $sp, $fp		# pop callee frame off stack
	  lw $ra, -4($fp)	# restore saved ra
	  lw $fp, 0($fp)	# restore saved fp
	  jr $ra		# return from function
  Person.____InitPerson:
	# BeginFunc 0
	  subu $sp, $sp, 8	# decrement sp to make space to save ra, fp
	  sw $fp, 8($sp)	# save fp
	  sw $ra, 4($sp)	# save ra
	  addiu $fp, $sp, 8	# set up new fp
	# *(this + 4) = f
	  lw $t0, 8($fp)	# fill f to $t0 from $fp+8
	  lw $t2, 4($fp)	# fill this to $t2 from $fp+4
	  sw $t0, 4($t2) 	# store with offset
	# *(this + 8) = l
	  lw $t0, 12($fp)	# fill l to $t0 from $fp+12
	  lw $t2, 4($fp)	# fill this to $t2 from $fp+4
	  sw $t0, 8($t2) 	# store with offset
	# *(this + 12) = p
	  lw $t0, 16($fp)	# fill p to $t0 from $fp+16
	  lw $t2, 4($fp)	# fill this to $t2 from $fp+4
	  sw $t0, 12($t2) 	# store with offset
	# *(this + 16) = a
	  lw $t0, 20($fp)	# fill a to $t0 from $fp+20
	  lw $t2, 4($fp)	# fill this to $t2 from $fp+4
	  sw $t0, 16($t2) 	# store with offset
	# EndFunc
	# (below handles reaching end of fn body with no explicit return)
	  move $sp, $fp		# pop callee frame off stack
	  lw $ra, -4($fp)	# restore saved ra
	  lw $fp, 0($fp)	# restore saved fp
	  jr $ra		# return from function
  Person.____SetFirstName:
	# BeginFunc 0
	  subu $sp, $sp, 8	# decrement sp to make space to save ra, fp
	  sw $fp, 8($sp)	# save fp
	  sw $ra, 4($sp)	# save ra
	  addiu $fp, $sp, 8	# set up new fp
	# *(this + 4) = f
	  lw $t0, 8($fp)	# fill f to $t0 from $fp+8
	  lw $t2, 4($fp)	# fill this to $t2 from $fp+4
	  sw $t0, 4($t2) 	# store with offset
	# EndFunc
	# (below handles reaching end of fn body with no explicit return)
	  move $sp, $fp		# pop callee frame off stack
	  lw $ra, -4($fp)	# restore saved ra
	  lw $fp, 0($fp)	# restore saved fp
	  jr $ra		# return from function
  Person.____GetFirstName:
	# BeginFunc 4
	  subu $sp, $sp, 8	# decrement sp to make space to save ra, fp
	  sw $fp, 8($sp)	# save fp
	  sw $ra, 4($sp)	# save ra
	  addiu $fp, $sp, 8	# set up new fp
	  subu $sp, $sp, 4	# decrement sp to make space for locals/temps
	# _tmp1 = *(this + 4)
	  lw $t0, 4($fp)	# fill this to $t0 from $fp+4
	  lw $t2, 4($t0) 	# load with offset
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
  Person.____SetLastName:
	# BeginFunc 0
	  subu $sp, $sp, 8	# decrement sp to make space to save ra, fp
	  sw $fp, 8($sp)	# save fp
	  sw $ra, 4($sp)	# save ra
	  addiu $fp, $sp, 8	# set up new fp
	# *(this + 8) = l
	  lw $t0, 8($fp)	# fill l to $t0 from $fp+8
	  lw $t2, 4($fp)	# fill this to $t2 from $fp+4
	  sw $t0, 8($t2) 	# store with offset
	# EndFunc
	# (below handles reaching end of fn body with no explicit return)
	  move $sp, $fp		# pop callee frame off stack
	  lw $ra, -4($fp)	# restore saved ra
	  lw $fp, 0($fp)	# restore saved fp
	  jr $ra		# return from function
  Person.____GetLastName:
	# BeginFunc 4
	  subu $sp, $sp, 8	# decrement sp to make space to save ra, fp
	  sw $fp, 8($sp)	# save fp
	  sw $ra, 4($sp)	# save ra
	  addiu $fp, $sp, 8	# set up new fp
	  subu $sp, $sp, 4	# decrement sp to make space for locals/temps
	# _tmp2 = *(this + 8)
	  lw $t0, 4($fp)	# fill this to $t0 from $fp+4
	  lw $t2, 8($t0) 	# load with offset
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
  Person.____SetPhoneNumber:
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
  Person.____GetPhoneNumber:
	# BeginFunc 4
	  subu $sp, $sp, 8	# decrement sp to make space to save ra, fp
	  sw $fp, 8($sp)	# save fp
	  sw $ra, 4($sp)	# save ra
	  addiu $fp, $sp, 8	# set up new fp
	  subu $sp, $sp, 4	# decrement sp to make space for locals/temps
	# _tmp3 = *(this + 12)
	  lw $t0, 4($fp)	# fill this to $t0 from $fp+4
	  lw $t2, 12($t0) 	# load with offset
	  sw $t2, -8($fp)	# spill _tmp3 from $t2 to $fp-8
	# Return _tmp3
	  lw $t2, -8($fp)	# fill _tmp3 to $t2 from $fp-8
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
  Person.____SetAddress:
	# BeginFunc 0
	  subu $sp, $sp, 8	# decrement sp to make space to save ra, fp
	  sw $fp, 8($sp)	# save fp
	  sw $ra, 4($sp)	# save ra
	  addiu $fp, $sp, 8	# set up new fp
	# *(this + 16) = a
	  lw $t0, 8($fp)	# fill a to $t0 from $fp+8
	  lw $t2, 4($fp)	# fill this to $t2 from $fp+4
	  sw $t0, 16($t2) 	# store with offset
	# EndFunc
	# (below handles reaching end of fn body with no explicit return)
	  move $sp, $fp		# pop callee frame off stack
	  lw $ra, -4($fp)	# restore saved ra
	  lw $fp, 0($fp)	# restore saved fp
	  jr $ra		# return from function
  Person.____GetAddress:
	# BeginFunc 4
	  subu $sp, $sp, 8	# decrement sp to make space to save ra, fp
	  sw $fp, 8($sp)	# save fp
	  sw $ra, 4($sp)	# save ra
	  addiu $fp, $sp, 8	# set up new fp
	  subu $sp, $sp, 4	# decrement sp to make space for locals/temps
	# _tmp4 = *(this + 16)
	  lw $t0, 4($fp)	# fill this to $t0 from $fp+4
	  lw $t2, 16($t0) 	# load with offset
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
  Person.____IsNamed:
	# BeginFunc 20
	  subu $sp, $sp, 8	# decrement sp to make space to save ra, fp
	  sw $fp, 8($sp)	# save fp
	  sw $ra, 4($sp)	# save ra
	  addiu $fp, $sp, 8	# set up new fp
	  subu $sp, $sp, 20	# decrement sp to make space for locals/temps
	# _tmp5 = *(this + 4)
	  lw $t0, 4($fp)	# fill this to $t0 from $fp+4
	  lw $t2, 4($t0) 	# load with offset
	  sw $t2, -8($fp)	# spill _tmp5 from $t2 to $fp-8
	# PushParam _tmp5
	  subu $sp, $sp, 4	# decrement sp to make space for param
	  lw $t0, -8($fp)	# fill _tmp5 to $t0 from $fp-8
	  sw $t0, 4($sp)	# copy param value to stack
	# PushParam name
	  subu $sp, $sp, 4	# decrement sp to make space for param
	  lw $t0, 8($fp)	# fill name to $t0 from $fp+8
	  sw $t0, 4($sp)	# copy param value to stack
	# _tmp6 = LCall _StringEqual
	  jal _StringEqual   	# jump to function
	  move $t2, $v0		# copy function return value from $v0
	  sw $t2, -12($fp)	# spill _tmp6 from $t2 to $fp-12
	# PopParams 8
	  add $sp, $sp, 8	# pop params off stack
	# _tmp7 = *(this + 8)
	  lw $t0, 4($fp)	# fill this to $t0 from $fp+4
	  lw $t2, 8($t0) 	# load with offset
	  sw $t2, -16($fp)	# spill _tmp7 from $t2 to $fp-16
	# PushParam _tmp7
	  subu $sp, $sp, 4	# decrement sp to make space for param
	  lw $t0, -16($fp)	# fill _tmp7 to $t0 from $fp-16
	  sw $t0, 4($sp)	# copy param value to stack
	# PushParam name
	  subu $sp, $sp, 4	# decrement sp to make space for param
	  lw $t0, 8($fp)	# fill name to $t0 from $fp+8
	  sw $t0, 4($sp)	# copy param value to stack
	# _tmp8 = LCall _StringEqual
	  jal _StringEqual   	# jump to function
	  move $t2, $v0		# copy function return value from $v0
	  sw $t2, -20($fp)	# spill _tmp8 from $t2 to $fp-20
	# PopParams 8
	  add $sp, $sp, 8	# pop params off stack
	# _tmp9 = _tmp6 || _tmp8
	  lw $t0, -12($fp)	# fill _tmp6 to $t0 from $fp-12
	  lw $t1, -20($fp)	# fill _tmp8 to $t1 from $fp-20
	  or $t2, $t0, $t1	
	  sw $t2, -24($fp)	# spill _tmp9 from $t2 to $fp-24
	# Return _tmp9
	  lw $t2, -24($fp)	# fill _tmp9 to $t2 from $fp-24
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
  Person.____PrintInfo:
	# BeginFunc 48
	  subu $sp, $sp, 8	# decrement sp to make space to save ra, fp
	  sw $fp, 8($sp)	# save fp
	  sw $ra, 4($sp)	# save ra
	  addiu $fp, $sp, 8	# set up new fp
	  subu $sp, $sp, 48	# decrement sp to make space for locals/temps
	# _tmp10 = "First Name: "
	  .data			# create string constant marked with label
	  _string2: .asciiz "First Name: "
	  .text
	  la $t2, _string2	# load label
	  sw $t2, -8($fp)	# spill _tmp10 from $t2 to $fp-8
	# PushParam _tmp10
	  subu $sp, $sp, 4	# decrement sp to make space for param
	  lw $t0, -8($fp)	# fill _tmp10 to $t0 from $fp-8
	  sw $t0, 4($sp)	# copy param value to stack
	# LCall _PrintString
	  jal _PrintString   	# jump to function
	# PopParams 4
	  add $sp, $sp, 4	# pop params off stack
	# _tmp11 = *(this + 4)
	  lw $t0, 4($fp)	# fill this to $t0 from $fp+4
	  lw $t2, 4($t0) 	# load with offset
	  sw $t2, -12($fp)	# spill _tmp11 from $t2 to $fp-12
	# PushParam _tmp11
	  subu $sp, $sp, 4	# decrement sp to make space for param
	  lw $t0, -12($fp)	# fill _tmp11 to $t0 from $fp-12
	  sw $t0, 4($sp)	# copy param value to stack
	# LCall _PrintString
	  jal _PrintString   	# jump to function
	# PopParams 4
	  add $sp, $sp, 4	# pop params off stack
	# _tmp12 = "\n"
	  .data			# create string constant marked with label
	  _string3: .asciiz "\n"
	  .text
	  la $t2, _string3	# load label
	  sw $t2, -16($fp)	# spill _tmp12 from $t2 to $fp-16
	# PushParam _tmp12
	  subu $sp, $sp, 4	# decrement sp to make space for param
	  lw $t0, -16($fp)	# fill _tmp12 to $t0 from $fp-16
	  sw $t0, 4($sp)	# copy param value to stack
	# LCall _PrintString
	  jal _PrintString   	# jump to function
	# PopParams 4
	  add $sp, $sp, 4	# pop params off stack
	# _tmp13 = "Last Name: "
	  .data			# create string constant marked with label
	  _string4: .asciiz "Last Name: "
	  .text
	  la $t2, _string4	# load label
	  sw $t2, -20($fp)	# spill _tmp13 from $t2 to $fp-20
	# PushParam _tmp13
	  subu $sp, $sp, 4	# decrement sp to make space for param
	  lw $t0, -20($fp)	# fill _tmp13 to $t0 from $fp-20
	  sw $t0, 4($sp)	# copy param value to stack
	# LCall _PrintString
	  jal _PrintString   	# jump to function
	# PopParams 4
	  add $sp, $sp, 4	# pop params off stack
	# _tmp14 = *(this + 8)
	  lw $t0, 4($fp)	# fill this to $t0 from $fp+4
	  lw $t2, 8($t0) 	# load with offset
	  sw $t2, -24($fp)	# spill _tmp14 from $t2 to $fp-24
	# PushParam _tmp14
	  subu $sp, $sp, 4	# decrement sp to make space for param
	  lw $t0, -24($fp)	# fill _tmp14 to $t0 from $fp-24
	  sw $t0, 4($sp)	# copy param value to stack
	# LCall _PrintString
	  jal _PrintString   	# jump to function
	# PopParams 4
	  add $sp, $sp, 4	# pop params off stack
	# _tmp15 = "\n"
	  .data			# create string constant marked with label
	  _string5: .asciiz "\n"
	  .text
	  la $t2, _string5	# load label
	  sw $t2, -28($fp)	# spill _tmp15 from $t2 to $fp-28
	# PushParam _tmp15
	  subu $sp, $sp, 4	# decrement sp to make space for param
	  lw $t0, -28($fp)	# fill _tmp15 to $t0 from $fp-28
	  sw $t0, 4($sp)	# copy param value to stack
	# LCall _PrintString
	  jal _PrintString   	# jump to function
	# PopParams 4
	  add $sp, $sp, 4	# pop params off stack
	# _tmp16 = "Phone Number: "
	  .data			# create string constant marked with label
	  _string6: .asciiz "Phone Number: "
	  .text
	  la $t2, _string6	# load label
	  sw $t2, -32($fp)	# spill _tmp16 from $t2 to $fp-32
	# PushParam _tmp16
	  subu $sp, $sp, 4	# decrement sp to make space for param
	  lw $t0, -32($fp)	# fill _tmp16 to $t0 from $fp-32
	  sw $t0, 4($sp)	# copy param value to stack
	# LCall _PrintString
	  jal _PrintString   	# jump to function
	# PopParams 4
	  add $sp, $sp, 4	# pop params off stack
	# _tmp17 = *(this + 12)
	  lw $t0, 4($fp)	# fill this to $t0 from $fp+4
	  lw $t2, 12($t0) 	# load with offset
	  sw $t2, -36($fp)	# spill _tmp17 from $t2 to $fp-36
	# PushParam _tmp17
	  subu $sp, $sp, 4	# decrement sp to make space for param
	  lw $t0, -36($fp)	# fill _tmp17 to $t0 from $fp-36
	  sw $t0, 4($sp)	# copy param value to stack
	# LCall _PrintString
	  jal _PrintString   	# jump to function
	# PopParams 4
	  add $sp, $sp, 4	# pop params off stack
	# _tmp18 = "\n"
	  .data			# create string constant marked with label
	  _string7: .asciiz "\n"
	  .text
	  la $t2, _string7	# load label
	  sw $t2, -40($fp)	# spill _tmp18 from $t2 to $fp-40
	# PushParam _tmp18
	  subu $sp, $sp, 4	# decrement sp to make space for param
	  lw $t0, -40($fp)	# fill _tmp18 to $t0 from $fp-40
	  sw $t0, 4($sp)	# copy param value to stack
	# LCall _PrintString
	  jal _PrintString   	# jump to function
	# PopParams 4
	  add $sp, $sp, 4	# pop params off stack
	# _tmp19 = "Address: "
	  .data			# create string constant marked with label
	  _string8: .asciiz "Address: "
	  .text
	  la $t2, _string8	# load label
	  sw $t2, -44($fp)	# spill _tmp19 from $t2 to $fp-44
	# PushParam _tmp19
	  subu $sp, $sp, 4	# decrement sp to make space for param
	  lw $t0, -44($fp)	# fill _tmp19 to $t0 from $fp-44
	  sw $t0, 4($sp)	# copy param value to stack
	# LCall _PrintString
	  jal _PrintString   	# jump to function
	# PopParams 4
	  add $sp, $sp, 4	# pop params off stack
	# _tmp20 = *(this + 16)
	  lw $t0, 4($fp)	# fill this to $t0 from $fp+4
	  lw $t2, 16($t0) 	# load with offset
	  sw $t2, -48($fp)	# spill _tmp20 from $t2 to $fp-48
	# PushParam _tmp20
	  subu $sp, $sp, 4	# decrement sp to make space for param
	  lw $t0, -48($fp)	# fill _tmp20 to $t0 from $fp-48
	  sw $t0, 4($sp)	# copy param value to stack
	# LCall _PrintString
	  jal _PrintString   	# jump to function
	# PopParams 4
	  add $sp, $sp, 4	# pop params off stack
	# _tmp21 = "\n"
	  .data			# create string constant marked with label
	  _string9: .asciiz "\n"
	  .text
	  la $t2, _string9	# load label
	  sw $t2, -52($fp)	# spill _tmp21 from $t2 to $fp-52
	# PushParam _tmp21
	  subu $sp, $sp, 4	# decrement sp to make space for param
	  lw $t0, -52($fp)	# fill _tmp21 to $t0 from $fp-52
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
	# VTable for class Person
	  .data
	  .align 2
	  Person:		# label for class Person vtable
	  .word Person.____InitPerson
	  .word Person.____SetFirstName
	  .word Person.____GetFirstName
	  .word Person.____SetLastName
	  .word Person.____GetLastName
	  .word Person.____SetPhoneNumber
	  .word Person.____GetPhoneNumber
	  .word Person.____SetAddress
	  .word Person.____GetAddress
	  .word Person.____IsNamed
	  .word Person.____PrintInfo
	  .text
  Database.____InitDatabase:
	# BeginFunc 40
	  subu $sp, $sp, 8	# decrement sp to make space to save ra, fp
	  sw $fp, 8($sp)	# save fp
	  sw $ra, 4($sp)	# save ra
	  addiu $fp, $sp, 8	# set up new fp
	  subu $sp, $sp, 40	# decrement sp to make space for locals/temps
	# _tmp22 = 0
	  li $t2, 0		# load constant value 0 into $t2
	  sw $t2, -8($fp)	# spill _tmp22 from $t2 to $fp-8
	# *(this + 4) = _tmp22
	  lw $t0, -8($fp)	# fill _tmp22 to $t0 from $fp-8
	  lw $t2, 4($fp)	# fill this to $t2 from $fp+4
	  sw $t0, 4($t2) 	# store with offset
	# *(this + 8) = size
	  lw $t0, 8($fp)	# fill size to $t0 from $fp+8
	  lw $t2, 4($fp)	# fill this to $t2 from $fp+4
	  sw $t0, 8($t2) 	# store with offset
	# _tmp23 = 4
	  li $t2, 4		# load constant value 4 into $t2
	  sw $t2, -12($fp)	# spill _tmp23 from $t2 to $fp-12
	# _tmp24 = 0
	  li $t2, 0		# load constant value 0 into $t2
	  sw $t2, -16($fp)	# spill _tmp24 from $t2 to $fp-16
	# _tmp25 = size < _tmp24
	  lw $t0, 8($fp)	# fill size to $t0 from $fp+8
	  lw $t1, -16($fp)	# fill _tmp24 to $t1 from $fp-16
	  slt $t2, $t0, $t1	
	  sw $t2, -20($fp)	# spill _tmp25 from $t2 to $fp-20
	# _tmp26 = size == _tmp24
	  lw $t0, 8($fp)	# fill size to $t0 from $fp+8
	  lw $t1, -16($fp)	# fill _tmp24 to $t1 from $fp-16
	  seq $t2, $t0, $t1	
	  sw $t2, -24($fp)	# spill _tmp26 from $t2 to $fp-24
	# _tmp27 = _tmp25 || _tmp26
	  lw $t0, -20($fp)	# fill _tmp25 to $t0 from $fp-20
	  lw $t1, -24($fp)	# fill _tmp26 to $t1 from $fp-24
	  or $t2, $t0, $t1	
	  sw $t2, -28($fp)	# spill _tmp27 from $t2 to $fp-28
	# IfZ _tmp27 Goto _L0
	  lw $t0, -28($fp)	# fill _tmp27 to $t0 from $fp-28
	  beqz $t0, _L0	# branch if _tmp27 is zero 
	# _tmp28 = "Decaf runtime error: Array size is <= 0\n"
	  .data			# create string constant marked with label
	  _string10: .asciiz "Decaf runtime error: Array size is <= 0\n"
	  .text
	  la $t2, _string10	# load label
	  sw $t2, -32($fp)	# spill _tmp28 from $t2 to $fp-32
	# PushParam _tmp28
	  subu $sp, $sp, 4	# decrement sp to make space for param
	  lw $t0, -32($fp)	# fill _tmp28 to $t0 from $fp-32
	  sw $t0, 4($sp)	# copy param value to stack
	# LCall _PrintString
	  jal _PrintString   	# jump to function
	# PopParams 4
	  add $sp, $sp, 4	# pop params off stack
	# LCall _Halt
	  jal _Halt          	# jump to function
  _L0:
	# _tmp29 = size * _tmp23
	  lw $t0, 8($fp)	# fill size to $t0 from $fp+8
	  lw $t1, -12($fp)	# fill _tmp23 to $t1 from $fp-12
	  mul $t2, $t0, $t1	
	  sw $t2, -36($fp)	# spill _tmp29 from $t2 to $fp-36
	# _tmp30 = _tmp23 + _tmp29
	  lw $t0, -12($fp)	# fill _tmp23 to $t0 from $fp-12
	  lw $t1, -36($fp)	# fill _tmp29 to $t1 from $fp-36
	  add $t2, $t0, $t1	
	  sw $t2, -40($fp)	# spill _tmp30 from $t2 to $fp-40
	# PushParam _tmp30
	  subu $sp, $sp, 4	# decrement sp to make space for param
	  lw $t0, -40($fp)	# fill _tmp30 to $t0 from $fp-40
	  sw $t0, 4($sp)	# copy param value to stack
	# _tmp31 = LCall _Alloc
	  jal _Alloc         	# jump to function
	  move $t2, $v0		# copy function return value from $v0
	  sw $t2, -44($fp)	# spill _tmp31 from $t2 to $fp-44
	# PopParams 4
	  add $sp, $sp, 4	# pop params off stack
	# *(_tmp31) = size
	  lw $t0, 8($fp)	# fill size to $t0 from $fp+8
	  lw $t2, -44($fp)	# fill _tmp31 to $t2 from $fp-44
	  sw $t0, 0($t2) 	# store with offset
	# *(this + 12) = _tmp31
	  lw $t0, -44($fp)	# fill _tmp31 to $t0 from $fp-44
	  lw $t2, 4($fp)	# fill this to $t2 from $fp+4
	  sw $t0, 12($t2) 	# store with offset
	# EndFunc
	# (below handles reaching end of fn body with no explicit return)
	  move $sp, $fp		# pop callee frame off stack
	  lw $ra, -4($fp)	# restore saved ra
	  lw $fp, 0($fp)	# restore saved fp
	  jr $ra		# return from function
  Database.____Search:
	# BeginFunc 260
	  subu $sp, $sp, 8	# decrement sp to make space to save ra, fp
	  sw $fp, 8($sp)	# save fp
	  sw $ra, 4($sp)	# save ra
	  addiu $fp, $sp, 8	# set up new fp
	  subu $sp, $sp, 260	# decrement sp to make space for locals/temps
	# LCall ____PrintLine
	  jal ____PrintLine  	# jump to function
	# _tmp32 = "Enter the name of the person you would like to fi..."
	  .data			# create string constant marked with label
	  _string11: .asciiz "Enter the name of the person you would like to find: "
	  .text
	  la $t2, _string11	# load label
	  sw $t2, -20($fp)	# spill _tmp32 from $t2 to $fp-20
	# PushParam _tmp32
	  subu $sp, $sp, 4	# decrement sp to make space for param
	  lw $t0, -20($fp)	# fill _tmp32 to $t0 from $fp-20
	  sw $t0, 4($sp)	# copy param value to stack
	# LCall _PrintString
	  jal _PrintString   	# jump to function
	# PopParams 4
	  add $sp, $sp, 4	# pop params off stack
	# _tmp33 = LCall _ReadLine
	  jal _ReadLine      	# jump to function
	  move $t2, $v0		# copy function return value from $v0
	  sw $t2, -24($fp)	# spill _tmp33 from $t2 to $fp-24
	# name = _tmp33
	  lw $t2, -24($fp)	# fill _tmp33 to $t2 from $fp-24
	  sw $t2, -12($fp)	# spill name from $t2 to $fp-12
	# _tmp34 = 0
	  li $t2, 0		# load constant value 0 into $t2
	  sw $t2, -28($fp)	# spill _tmp34 from $t2 to $fp-28
	# found = _tmp34
	  lw $t2, -28($fp)	# fill _tmp34 to $t2 from $fp-28
	  sw $t2, -16($fp)	# spill found from $t2 to $fp-16
	# _tmp35 = 0
	  li $t2, 0		# load constant value 0 into $t2
	  sw $t2, -32($fp)	# spill _tmp35 from $t2 to $fp-32
	# i = _tmp35
	  lw $t2, -32($fp)	# fill _tmp35 to $t2 from $fp-32
	  sw $t2, -8($fp)	# spill i from $t2 to $fp-8
  _L1:
	# _tmp36 = *(this + 4)
	  lw $t0, 4($fp)	# fill this to $t0 from $fp+4
	  lw $t2, 4($t0) 	# load with offset
	  sw $t2, -36($fp)	# spill _tmp36 from $t2 to $fp-36
	# _tmp37 = i < _tmp36
	  lw $t0, -8($fp)	# fill i to $t0 from $fp-8
	  lw $t1, -36($fp)	# fill _tmp36 to $t1 from $fp-36
	  slt $t2, $t0, $t1	
	  sw $t2, -40($fp)	# spill _tmp37 from $t2 to $fp-40
	# IfZ _tmp37 Goto _L2
	  lw $t0, -40($fp)	# fill _tmp37 to $t0 from $fp-40
	  beqz $t0, _L2	# branch if _tmp37 is zero 
	# PushParam name
	  subu $sp, $sp, 4	# decrement sp to make space for param
	  lw $t0, -12($fp)	# fill name to $t0 from $fp-12
	  sw $t0, 4($sp)	# copy param value to stack
	# _tmp38 = *(this + 12)
	  lw $t0, 4($fp)	# fill this to $t0 from $fp+4
	  lw $t2, 12($t0) 	# load with offset
	  sw $t2, -44($fp)	# spill _tmp38 from $t2 to $fp-44
	# _tmp39 = 0
	  li $t2, 0		# load constant value 0 into $t2
	  sw $t2, -48($fp)	# spill _tmp39 from $t2 to $fp-48
	# _tmp40 = *(_tmp38)
	  lw $t0, -44($fp)	# fill _tmp38 to $t0 from $fp-44
	  lw $t2, 0($t0) 	# load with offset
	  sw $t2, -52($fp)	# spill _tmp40 from $t2 to $fp-52
	# _tmp41 = i < _tmp39
	  lw $t0, -8($fp)	# fill i to $t0 from $fp-8
	  lw $t1, -48($fp)	# fill _tmp39 to $t1 from $fp-48
	  slt $t2, $t0, $t1	
	  sw $t2, -56($fp)	# spill _tmp41 from $t2 to $fp-56
	# _tmp42 = _tmp40 < i
	  lw $t0, -52($fp)	# fill _tmp40 to $t0 from $fp-52
	  lw $t1, -8($fp)	# fill i to $t1 from $fp-8
	  slt $t2, $t0, $t1	
	  sw $t2, -60($fp)	# spill _tmp42 from $t2 to $fp-60
	# _tmp43 = _tmp40 == i
	  lw $t0, -52($fp)	# fill _tmp40 to $t0 from $fp-52
	  lw $t1, -8($fp)	# fill i to $t1 from $fp-8
	  seq $t2, $t0, $t1	
	  sw $t2, -64($fp)	# spill _tmp43 from $t2 to $fp-64
	# _tmp44 = _tmp42 || _tmp43
	  lw $t0, -60($fp)	# fill _tmp42 to $t0 from $fp-60
	  lw $t1, -64($fp)	# fill _tmp43 to $t1 from $fp-64
	  or $t2, $t0, $t1	
	  sw $t2, -68($fp)	# spill _tmp44 from $t2 to $fp-68
	# _tmp45 = _tmp44 || _tmp41
	  lw $t0, -68($fp)	# fill _tmp44 to $t0 from $fp-68
	  lw $t1, -56($fp)	# fill _tmp41 to $t1 from $fp-56
	  or $t2, $t0, $t1	
	  sw $t2, -72($fp)	# spill _tmp45 from $t2 to $fp-72
	# IfZ _tmp45 Goto _L5
	  lw $t0, -72($fp)	# fill _tmp45 to $t0 from $fp-72
	  beqz $t0, _L5	# branch if _tmp45 is zero 
	# _tmp46 = "Decaf runtime error: Array subscript out of bound..."
	  .data			# create string constant marked with label
	  _string12: .asciiz "Decaf runtime error: Array subscript out of bounds\n"
	  .text
	  la $t2, _string12	# load label
	  sw $t2, -76($fp)	# spill _tmp46 from $t2 to $fp-76
	# PushParam _tmp46
	  subu $sp, $sp, 4	# decrement sp to make space for param
	  lw $t0, -76($fp)	# fill _tmp46 to $t0 from $fp-76
	  sw $t0, 4($sp)	# copy param value to stack
	# LCall _PrintString
	  jal _PrintString   	# jump to function
	# PopParams 4
	  add $sp, $sp, 4	# pop params off stack
	# LCall _Halt
	  jal _Halt          	# jump to function
  _L5:
	# _tmp47 = 4
	  li $t2, 4		# load constant value 4 into $t2
	  sw $t2, -80($fp)	# spill _tmp47 from $t2 to $fp-80
	# _tmp48 = i * _tmp47
	  lw $t0, -8($fp)	# fill i to $t0 from $fp-8
	  lw $t1, -80($fp)	# fill _tmp47 to $t1 from $fp-80
	  mul $t2, $t0, $t1	
	  sw $t2, -84($fp)	# spill _tmp48 from $t2 to $fp-84
	# _tmp49 = _tmp48 + _tmp47
	  lw $t0, -84($fp)	# fill _tmp48 to $t0 from $fp-84
	  lw $t1, -80($fp)	# fill _tmp47 to $t1 from $fp-80
	  add $t2, $t0, $t1	
	  sw $t2, -88($fp)	# spill _tmp49 from $t2 to $fp-88
	# _tmp50 = _tmp38 + _tmp49
	  lw $t0, -44($fp)	# fill _tmp38 to $t0 from $fp-44
	  lw $t1, -88($fp)	# fill _tmp49 to $t1 from $fp-88
	  add $t2, $t0, $t1	
	  sw $t2, -92($fp)	# spill _tmp50 from $t2 to $fp-92
	# _tmp51 = *(_tmp50)
	  lw $t0, -92($fp)	# fill _tmp50 to $t0 from $fp-92
	  lw $t2, 0($t0) 	# load with offset
	  sw $t2, -96($fp)	# spill _tmp51 from $t2 to $fp-96
	# PushParam _tmp51
	  subu $sp, $sp, 4	# decrement sp to make space for param
	  lw $t0, -96($fp)	# fill _tmp51 to $t0 from $fp-96
	  sw $t0, 4($sp)	# copy param value to stack
	# _tmp52 = *(_tmp51)
	  lw $t0, -96($fp)	# fill _tmp51 to $t0 from $fp-96
	  lw $t2, 0($t0) 	# load with offset
	  sw $t2, -100($fp)	# spill _tmp52 from $t2 to $fp-100
	# _tmp53 = *(_tmp52 + 36)
	  lw $t0, -100($fp)	# fill _tmp52 to $t0 from $fp-100
	  lw $t2, 36($t0) 	# load with offset
	  sw $t2, -104($fp)	# spill _tmp53 from $t2 to $fp-104
	# _tmp54 = ACall _tmp53
	  lw $t0, -104($fp)	# fill _tmp53 to $t0 from $fp-104
	  jalr $t0            	# jump to function
	  move $t2, $v0		# copy function return value from $v0
	  sw $t2, -108($fp)	# spill _tmp54 from $t2 to $fp-108
	# PopParams 8
	  add $sp, $sp, 8	# pop params off stack
	# IfZ _tmp54 Goto _L3
	  lw $t0, -108($fp)	# fill _tmp54 to $t0 from $fp-108
	  beqz $t0, _L3	# branch if _tmp54 is zero 
	# IfZ found Goto _L9
	  lw $t0, -16($fp)	# fill found to $t0 from $fp-16
	  beqz $t0, _L9	# branch if found is zero 
	# _tmp56 = 0
	  li $t2, 0		# load constant value 0 into $t2
	  sw $t2, -116($fp)	# spill _tmp56 from $t2 to $fp-116
	# _tmp55 = _tmp56
	  lw $t2, -116($fp)	# fill _tmp56 to $t2 from $fp-116
	  sw $t2, -112($fp)	# spill _tmp55 from $t2 to $fp-112
	# Goto _L8
	  b _L8		# unconditional branch
  _L9:
	# _tmp57 = 1
	  li $t2, 1		# load constant value 1 into $t2
	  sw $t2, -120($fp)	# spill _tmp57 from $t2 to $fp-120
	# _tmp55 = _tmp57
	  lw $t2, -120($fp)	# fill _tmp57 to $t2 from $fp-120
	  sw $t2, -112($fp)	# spill _tmp55 from $t2 to $fp-112
  _L8:
	# IfZ _tmp55 Goto _L6
	  lw $t0, -112($fp)	# fill _tmp55 to $t0 from $fp-112
	  beqz $t0, _L6	# branch if _tmp55 is zero 
	# _tmp58 = 1
	  li $t2, 1		# load constant value 1 into $t2
	  sw $t2, -124($fp)	# spill _tmp58 from $t2 to $fp-124
	# found = _tmp58
	  lw $t2, -124($fp)	# fill _tmp58 to $t2 from $fp-124
	  sw $t2, -16($fp)	# spill found from $t2 to $fp-16
	# _tmp59 = "\nListing people with name '"
	  .data			# create string constant marked with label
	  _string13: .asciiz "\nListing people with name '"
	  .text
	  la $t2, _string13	# load label
	  sw $t2, -128($fp)	# spill _tmp59 from $t2 to $fp-128
	# PushParam _tmp59
	  subu $sp, $sp, 4	# decrement sp to make space for param
	  lw $t0, -128($fp)	# fill _tmp59 to $t0 from $fp-128
	  sw $t0, 4($sp)	# copy param value to stack
	# LCall _PrintString
	  jal _PrintString   	# jump to function
	# PopParams 4
	  add $sp, $sp, 4	# pop params off stack
	# PushParam name
	  subu $sp, $sp, 4	# decrement sp to make space for param
	  lw $t0, -12($fp)	# fill name to $t0 from $fp-12
	  sw $t0, 4($sp)	# copy param value to stack
	# LCall _PrintString
	  jal _PrintString   	# jump to function
	# PopParams 4
	  add $sp, $sp, 4	# pop params off stack
	# _tmp60 = "'...\n"
	  .data			# create string constant marked with label
	  _string14: .asciiz "'...\n"
	  .text
	  la $t2, _string14	# load label
	  sw $t2, -132($fp)	# spill _tmp60 from $t2 to $fp-132
	# PushParam _tmp60
	  subu $sp, $sp, 4	# decrement sp to make space for param
	  lw $t0, -132($fp)	# fill _tmp60 to $t0 from $fp-132
	  sw $t0, 4($sp)	# copy param value to stack
	# LCall _PrintString
	  jal _PrintString   	# jump to function
	# PopParams 4
	  add $sp, $sp, 4	# pop params off stack
	# LCall ____PrintLine
	  jal ____PrintLine  	# jump to function
	# Goto _L7
	  b _L7		# unconditional branch
  _L6:
  _L7:
	# _tmp61 = *(this + 12)
	  lw $t0, 4($fp)	# fill this to $t0 from $fp+4
	  lw $t2, 12($t0) 	# load with offset
	  sw $t2, -136($fp)	# spill _tmp61 from $t2 to $fp-136
	# _tmp62 = 0
	  li $t2, 0		# load constant value 0 into $t2
	  sw $t2, -140($fp)	# spill _tmp62 from $t2 to $fp-140
	# _tmp63 = *(_tmp61)
	  lw $t0, -136($fp)	# fill _tmp61 to $t0 from $fp-136
	  lw $t2, 0($t0) 	# load with offset
	  sw $t2, -144($fp)	# spill _tmp63 from $t2 to $fp-144
	# _tmp64 = i < _tmp62
	  lw $t0, -8($fp)	# fill i to $t0 from $fp-8
	  lw $t1, -140($fp)	# fill _tmp62 to $t1 from $fp-140
	  slt $t2, $t0, $t1	
	  sw $t2, -148($fp)	# spill _tmp64 from $t2 to $fp-148
	# _tmp65 = _tmp63 < i
	  lw $t0, -144($fp)	# fill _tmp63 to $t0 from $fp-144
	  lw $t1, -8($fp)	# fill i to $t1 from $fp-8
	  slt $t2, $t0, $t1	
	  sw $t2, -152($fp)	# spill _tmp65 from $t2 to $fp-152
	# _tmp66 = _tmp63 == i
	  lw $t0, -144($fp)	# fill _tmp63 to $t0 from $fp-144
	  lw $t1, -8($fp)	# fill i to $t1 from $fp-8
	  seq $t2, $t0, $t1	
	  sw $t2, -156($fp)	# spill _tmp66 from $t2 to $fp-156
	# _tmp67 = _tmp65 || _tmp66
	  lw $t0, -152($fp)	# fill _tmp65 to $t0 from $fp-152
	  lw $t1, -156($fp)	# fill _tmp66 to $t1 from $fp-156
	  or $t2, $t0, $t1	
	  sw $t2, -160($fp)	# spill _tmp67 from $t2 to $fp-160
	# _tmp68 = _tmp67 || _tmp64
	  lw $t0, -160($fp)	# fill _tmp67 to $t0 from $fp-160
	  lw $t1, -148($fp)	# fill _tmp64 to $t1 from $fp-148
	  or $t2, $t0, $t1	
	  sw $t2, -164($fp)	# spill _tmp68 from $t2 to $fp-164
	# IfZ _tmp68 Goto _L10
	  lw $t0, -164($fp)	# fill _tmp68 to $t0 from $fp-164
	  beqz $t0, _L10	# branch if _tmp68 is zero 
	# _tmp69 = "Decaf runtime error: Array subscript out of bound..."
	  .data			# create string constant marked with label
	  _string15: .asciiz "Decaf runtime error: Array subscript out of bounds\n"
	  .text
	  la $t2, _string15	# load label
	  sw $t2, -168($fp)	# spill _tmp69 from $t2 to $fp-168
	# PushParam _tmp69
	  subu $sp, $sp, 4	# decrement sp to make space for param
	  lw $t0, -168($fp)	# fill _tmp69 to $t0 from $fp-168
	  sw $t0, 4($sp)	# copy param value to stack
	# LCall _PrintString
	  jal _PrintString   	# jump to function
	# PopParams 4
	  add $sp, $sp, 4	# pop params off stack
	# LCall _Halt
	  jal _Halt          	# jump to function
  _L10:
	# _tmp70 = 4
	  li $t2, 4		# load constant value 4 into $t2
	  sw $t2, -172($fp)	# spill _tmp70 from $t2 to $fp-172
	# _tmp71 = i * _tmp70
	  lw $t0, -8($fp)	# fill i to $t0 from $fp-8
	  lw $t1, -172($fp)	# fill _tmp70 to $t1 from $fp-172
	  mul $t2, $t0, $t1	
	  sw $t2, -176($fp)	# spill _tmp71 from $t2 to $fp-176
	# _tmp72 = _tmp71 + _tmp70
	  lw $t0, -176($fp)	# fill _tmp71 to $t0 from $fp-176
	  lw $t1, -172($fp)	# fill _tmp70 to $t1 from $fp-172
	  add $t2, $t0, $t1	
	  sw $t2, -180($fp)	# spill _tmp72 from $t2 to $fp-180
	# _tmp73 = _tmp61 + _tmp72
	  lw $t0, -136($fp)	# fill _tmp61 to $t0 from $fp-136
	  lw $t1, -180($fp)	# fill _tmp72 to $t1 from $fp-180
	  add $t2, $t0, $t1	
	  sw $t2, -184($fp)	# spill _tmp73 from $t2 to $fp-184
	# _tmp74 = *(_tmp73)
	  lw $t0, -184($fp)	# fill _tmp73 to $t0 from $fp-184
	  lw $t2, 0($t0) 	# load with offset
	  sw $t2, -188($fp)	# spill _tmp74 from $t2 to $fp-188
	# PushParam _tmp74
	  subu $sp, $sp, 4	# decrement sp to make space for param
	  lw $t0, -188($fp)	# fill _tmp74 to $t0 from $fp-188
	  sw $t0, 4($sp)	# copy param value to stack
	# _tmp75 = *(_tmp74)
	  lw $t0, -188($fp)	# fill _tmp74 to $t0 from $fp-188
	  lw $t2, 0($t0) 	# load with offset
	  sw $t2, -192($fp)	# spill _tmp75 from $t2 to $fp-192
	# _tmp76 = *(_tmp75 + 40)
	  lw $t0, -192($fp)	# fill _tmp75 to $t0 from $fp-192
	  lw $t2, 40($t0) 	# load with offset
	  sw $t2, -196($fp)	# spill _tmp76 from $t2 to $fp-196
	# ACall _tmp76
	  lw $t0, -196($fp)	# fill _tmp76 to $t0 from $fp-196
	  jalr $t0            	# jump to function
	# PopParams 4
	  add $sp, $sp, 4	# pop params off stack
	# _tmp77 = "\n"
	  .data			# create string constant marked with label
	  _string16: .asciiz "\n"
	  .text
	  la $t2, _string16	# load label
	  sw $t2, -200($fp)	# spill _tmp77 from $t2 to $fp-200
	# PushParam _tmp77
	  subu $sp, $sp, 4	# decrement sp to make space for param
	  lw $t0, -200($fp)	# fill _tmp77 to $t0 from $fp-200
	  sw $t0, 4($sp)	# copy param value to stack
	# LCall _PrintString
	  jal _PrintString   	# jump to function
	# PopParams 4
	  add $sp, $sp, 4	# pop params off stack
	# Goto _L4
	  b _L4		# unconditional branch
  _L3:
  _L4:
	# _tmp78 = 1
	  li $t2, 1		# load constant value 1 into $t2
	  sw $t2, -204($fp)	# spill _tmp78 from $t2 to $fp-204
	# _tmp79 = i + _tmp78
	  lw $t0, -8($fp)	# fill i to $t0 from $fp-8
	  lw $t1, -204($fp)	# fill _tmp78 to $t1 from $fp-204
	  add $t2, $t0, $t1	
	  sw $t2, -208($fp)	# spill _tmp79 from $t2 to $fp-208
	# i = _tmp79
	  lw $t2, -208($fp)	# fill _tmp79 to $t2 from $fp-208
	  sw $t2, -8($fp)	# spill i from $t2 to $fp-8
	# Goto _L1
	  b _L1		# unconditional branch
  _L2:
	# IfZ found Goto _L14
	  lw $t0, -16($fp)	# fill found to $t0 from $fp-16
	  beqz $t0, _L14	# branch if found is zero 
	# _tmp81 = 0
	  li $t2, 0		# load constant value 0 into $t2
	  sw $t2, -216($fp)	# spill _tmp81 from $t2 to $fp-216
	# _tmp80 = _tmp81
	  lw $t2, -216($fp)	# fill _tmp81 to $t2 from $fp-216
	  sw $t2, -212($fp)	# spill _tmp80 from $t2 to $fp-212
	# Goto _L13
	  b _L13		# unconditional branch
  _L14:
	# _tmp82 = 1
	  li $t2, 1		# load constant value 1 into $t2
	  sw $t2, -220($fp)	# spill _tmp82 from $t2 to $fp-220
	# _tmp80 = _tmp82
	  lw $t2, -220($fp)	# fill _tmp82 to $t2 from $fp-220
	  sw $t2, -212($fp)	# spill _tmp80 from $t2 to $fp-212
  _L13:
	# IfZ _tmp80 Goto _L11
	  lw $t0, -212($fp)	# fill _tmp80 to $t0 from $fp-212
	  beqz $t0, _L11	# branch if _tmp80 is zero 
	# _tmp83 = "\n"
	  .data			# create string constant marked with label
	  _string17: .asciiz "\n"
	  .text
	  la $t2, _string17	# load label
	  sw $t2, -224($fp)	# spill _tmp83 from $t2 to $fp-224
	# PushParam _tmp83
	  subu $sp, $sp, 4	# decrement sp to make space for param
	  lw $t0, -224($fp)	# fill _tmp83 to $t0 from $fp-224
	  sw $t0, 4($sp)	# copy param value to stack
	# LCall _PrintString
	  jal _PrintString   	# jump to function
	# PopParams 4
	  add $sp, $sp, 4	# pop params off stack
	# PushParam name
	  subu $sp, $sp, 4	# decrement sp to make space for param
	  lw $t0, -12($fp)	# fill name to $t0 from $fp-12
	  sw $t0, 4($sp)	# copy param value to stack
	# LCall _PrintString
	  jal _PrintString   	# jump to function
	# PopParams 4
	  add $sp, $sp, 4	# pop params off stack
	# _tmp84 = " not found!\n"
	  .data			# create string constant marked with label
	  _string18: .asciiz " not found!\n"
	  .text
	  la $t2, _string18	# load label
	  sw $t2, -228($fp)	# spill _tmp84 from $t2 to $fp-228
	# PushParam _tmp84
	  subu $sp, $sp, 4	# decrement sp to make space for param
	  lw $t0, -228($fp)	# fill _tmp84 to $t0 from $fp-228
	  sw $t0, 4($sp)	# copy param value to stack
	# LCall _PrintString
	  jal _PrintString   	# jump to function
	# PopParams 4
	  add $sp, $sp, 4	# pop params off stack
	# Goto _L12
	  b _L12		# unconditional branch
  _L11:
  _L12:
	# LCall ____PrintLine
	  jal ____PrintLine  	# jump to function
	# EndFunc
	# (below handles reaching end of fn body with no explicit return)
	  move $sp, $fp		# pop callee frame off stack
	  lw $ra, -4($fp)	# restore saved ra
	  lw $fp, 0($fp)	# restore saved fp
	  jr $ra		# return from function
  Database.____PersonExists:
	# BeginFunc 204
	  subu $sp, $sp, 8	# decrement sp to make space to save ra, fp
	  sw $fp, 8($sp)	# save fp
	  sw $ra, 4($sp)	# save ra
	  addiu $fp, $sp, 8	# set up new fp
	  subu $sp, $sp, 204	# decrement sp to make space for locals/temps
	# _tmp85 = 0
	  li $t2, 0		# load constant value 0 into $t2
	  sw $t2, -12($fp)	# spill _tmp85 from $t2 to $fp-12
	# i = _tmp85
	  lw $t2, -12($fp)	# fill _tmp85 to $t2 from $fp-12
	  sw $t2, -8($fp)	# spill i from $t2 to $fp-8
  _L15:
	# _tmp86 = *(this + 4)
	  lw $t0, 4($fp)	# fill this to $t0 from $fp+4
	  lw $t2, 4($t0) 	# load with offset
	  sw $t2, -16($fp)	# spill _tmp86 from $t2 to $fp-16
	# _tmp87 = i < _tmp86
	  lw $t0, -8($fp)	# fill i to $t0 from $fp-8
	  lw $t1, -16($fp)	# fill _tmp86 to $t1 from $fp-16
	  slt $t2, $t0, $t1	
	  sw $t2, -20($fp)	# spill _tmp87 from $t2 to $fp-20
	# IfZ _tmp87 Goto _L16
	  lw $t0, -20($fp)	# fill _tmp87 to $t0 from $fp-20
	  beqz $t0, _L16	# branch if _tmp87 is zero 
	# _tmp88 = *(this + 12)
	  lw $t0, 4($fp)	# fill this to $t0 from $fp+4
	  lw $t2, 12($t0) 	# load with offset
	  sw $t2, -24($fp)	# spill _tmp88 from $t2 to $fp-24
	# _tmp89 = 0
	  li $t2, 0		# load constant value 0 into $t2
	  sw $t2, -28($fp)	# spill _tmp89 from $t2 to $fp-28
	# _tmp90 = *(_tmp88)
	  lw $t0, -24($fp)	# fill _tmp88 to $t0 from $fp-24
	  lw $t2, 0($t0) 	# load with offset
	  sw $t2, -32($fp)	# spill _tmp90 from $t2 to $fp-32
	# _tmp91 = i < _tmp89
	  lw $t0, -8($fp)	# fill i to $t0 from $fp-8
	  lw $t1, -28($fp)	# fill _tmp89 to $t1 from $fp-28
	  slt $t2, $t0, $t1	
	  sw $t2, -36($fp)	# spill _tmp91 from $t2 to $fp-36
	# _tmp92 = _tmp90 < i
	  lw $t0, -32($fp)	# fill _tmp90 to $t0 from $fp-32
	  lw $t1, -8($fp)	# fill i to $t1 from $fp-8
	  slt $t2, $t0, $t1	
	  sw $t2, -40($fp)	# spill _tmp92 from $t2 to $fp-40
	# _tmp93 = _tmp90 == i
	  lw $t0, -32($fp)	# fill _tmp90 to $t0 from $fp-32
	  lw $t1, -8($fp)	# fill i to $t1 from $fp-8
	  seq $t2, $t0, $t1	
	  sw $t2, -44($fp)	# spill _tmp93 from $t2 to $fp-44
	# _tmp94 = _tmp92 || _tmp93
	  lw $t0, -40($fp)	# fill _tmp92 to $t0 from $fp-40
	  lw $t1, -44($fp)	# fill _tmp93 to $t1 from $fp-44
	  or $t2, $t0, $t1	
	  sw $t2, -48($fp)	# spill _tmp94 from $t2 to $fp-48
	# _tmp95 = _tmp94 || _tmp91
	  lw $t0, -48($fp)	# fill _tmp94 to $t0 from $fp-48
	  lw $t1, -36($fp)	# fill _tmp91 to $t1 from $fp-36
	  or $t2, $t0, $t1	
	  sw $t2, -52($fp)	# spill _tmp95 from $t2 to $fp-52
	# IfZ _tmp95 Goto _L19
	  lw $t0, -52($fp)	# fill _tmp95 to $t0 from $fp-52
	  beqz $t0, _L19	# branch if _tmp95 is zero 
	# _tmp96 = "Decaf runtime error: Array subscript out of bound..."
	  .data			# create string constant marked with label
	  _string19: .asciiz "Decaf runtime error: Array subscript out of bounds\n"
	  .text
	  la $t2, _string19	# load label
	  sw $t2, -56($fp)	# spill _tmp96 from $t2 to $fp-56
	# PushParam _tmp96
	  subu $sp, $sp, 4	# decrement sp to make space for param
	  lw $t0, -56($fp)	# fill _tmp96 to $t0 from $fp-56
	  sw $t0, 4($sp)	# copy param value to stack
	# LCall _PrintString
	  jal _PrintString   	# jump to function
	# PopParams 4
	  add $sp, $sp, 4	# pop params off stack
	# LCall _Halt
	  jal _Halt          	# jump to function
  _L19:
	# _tmp97 = 4
	  li $t2, 4		# load constant value 4 into $t2
	  sw $t2, -60($fp)	# spill _tmp97 from $t2 to $fp-60
	# _tmp98 = i * _tmp97
	  lw $t0, -8($fp)	# fill i to $t0 from $fp-8
	  lw $t1, -60($fp)	# fill _tmp97 to $t1 from $fp-60
	  mul $t2, $t0, $t1	
	  sw $t2, -64($fp)	# spill _tmp98 from $t2 to $fp-64
	# _tmp99 = _tmp98 + _tmp97
	  lw $t0, -64($fp)	# fill _tmp98 to $t0 from $fp-64
	  lw $t1, -60($fp)	# fill _tmp97 to $t1 from $fp-60
	  add $t2, $t0, $t1	
	  sw $t2, -68($fp)	# spill _tmp99 from $t2 to $fp-68
	# _tmp100 = _tmp88 + _tmp99
	  lw $t0, -24($fp)	# fill _tmp88 to $t0 from $fp-24
	  lw $t1, -68($fp)	# fill _tmp99 to $t1 from $fp-68
	  add $t2, $t0, $t1	
	  sw $t2, -72($fp)	# spill _tmp100 from $t2 to $fp-72
	# _tmp101 = *(_tmp100)
	  lw $t0, -72($fp)	# fill _tmp100 to $t0 from $fp-72
	  lw $t2, 0($t0) 	# load with offset
	  sw $t2, -76($fp)	# spill _tmp101 from $t2 to $fp-76
	# PushParam _tmp101
	  subu $sp, $sp, 4	# decrement sp to make space for param
	  lw $t0, -76($fp)	# fill _tmp101 to $t0 from $fp-76
	  sw $t0, 4($sp)	# copy param value to stack
	# _tmp102 = *(_tmp101)
	  lw $t0, -76($fp)	# fill _tmp101 to $t0 from $fp-76
	  lw $t2, 0($t0) 	# load with offset
	  sw $t2, -80($fp)	# spill _tmp102 from $t2 to $fp-80
	# _tmp103 = *(_tmp102 + 8)
	  lw $t0, -80($fp)	# fill _tmp102 to $t0 from $fp-80
	  lw $t2, 8($t0) 	# load with offset
	  sw $t2, -84($fp)	# spill _tmp103 from $t2 to $fp-84
	# _tmp104 = ACall _tmp103
	  lw $t0, -84($fp)	# fill _tmp103 to $t0 from $fp-84
	  jalr $t0            	# jump to function
	  move $t2, $v0		# copy function return value from $v0
	  sw $t2, -88($fp)	# spill _tmp104 from $t2 to $fp-88
	# PopParams 4
	  add $sp, $sp, 4	# pop params off stack
	# PushParam f
	  subu $sp, $sp, 4	# decrement sp to make space for param
	  lw $t0, 8($fp)	# fill f to $t0 from $fp+8
	  sw $t0, 4($sp)	# copy param value to stack
	# PushParam _tmp104
	  subu $sp, $sp, 4	# decrement sp to make space for param
	  lw $t0, -88($fp)	# fill _tmp104 to $t0 from $fp-88
	  sw $t0, 4($sp)	# copy param value to stack
	# _tmp105 = LCall _StringEqual
	  jal _StringEqual   	# jump to function
	  move $t2, $v0		# copy function return value from $v0
	  sw $t2, -92($fp)	# spill _tmp105 from $t2 to $fp-92
	# PopParams 8
	  add $sp, $sp, 8	# pop params off stack
	# _tmp106 = *(this + 12)
	  lw $t0, 4($fp)	# fill this to $t0 from $fp+4
	  lw $t2, 12($t0) 	# load with offset
	  sw $t2, -96($fp)	# spill _tmp106 from $t2 to $fp-96
	# _tmp107 = 0
	  li $t2, 0		# load constant value 0 into $t2
	  sw $t2, -100($fp)	# spill _tmp107 from $t2 to $fp-100
	# _tmp108 = *(_tmp106)
	  lw $t0, -96($fp)	# fill _tmp106 to $t0 from $fp-96
	  lw $t2, 0($t0) 	# load with offset
	  sw $t2, -104($fp)	# spill _tmp108 from $t2 to $fp-104
	# _tmp109 = i < _tmp107
	  lw $t0, -8($fp)	# fill i to $t0 from $fp-8
	  lw $t1, -100($fp)	# fill _tmp107 to $t1 from $fp-100
	  slt $t2, $t0, $t1	
	  sw $t2, -108($fp)	# spill _tmp109 from $t2 to $fp-108
	# _tmp110 = _tmp108 < i
	  lw $t0, -104($fp)	# fill _tmp108 to $t0 from $fp-104
	  lw $t1, -8($fp)	# fill i to $t1 from $fp-8
	  slt $t2, $t0, $t1	
	  sw $t2, -112($fp)	# spill _tmp110 from $t2 to $fp-112
	# _tmp111 = _tmp108 == i
	  lw $t0, -104($fp)	# fill _tmp108 to $t0 from $fp-104
	  lw $t1, -8($fp)	# fill i to $t1 from $fp-8
	  seq $t2, $t0, $t1	
	  sw $t2, -116($fp)	# spill _tmp111 from $t2 to $fp-116
	# _tmp112 = _tmp110 || _tmp111
	  lw $t0, -112($fp)	# fill _tmp110 to $t0 from $fp-112
	  lw $t1, -116($fp)	# fill _tmp111 to $t1 from $fp-116
	  or $t2, $t0, $t1	
	  sw $t2, -120($fp)	# spill _tmp112 from $t2 to $fp-120
	# _tmp113 = _tmp112 || _tmp109
	  lw $t0, -120($fp)	# fill _tmp112 to $t0 from $fp-120
	  lw $t1, -108($fp)	# fill _tmp109 to $t1 from $fp-108
	  or $t2, $t0, $t1	
	  sw $t2, -124($fp)	# spill _tmp113 from $t2 to $fp-124
	# IfZ _tmp113 Goto _L20
	  lw $t0, -124($fp)	# fill _tmp113 to $t0 from $fp-124
	  beqz $t0, _L20	# branch if _tmp113 is zero 
	# _tmp114 = "Decaf runtime error: Array subscript out of bound..."
	  .data			# create string constant marked with label
	  _string20: .asciiz "Decaf runtime error: Array subscript out of bounds\n"
	  .text
	  la $t2, _string20	# load label
	  sw $t2, -128($fp)	# spill _tmp114 from $t2 to $fp-128
	# PushParam _tmp114
	  subu $sp, $sp, 4	# decrement sp to make space for param
	  lw $t0, -128($fp)	# fill _tmp114 to $t0 from $fp-128
	  sw $t0, 4($sp)	# copy param value to stack
	# LCall _PrintString
	  jal _PrintString   	# jump to function
	# PopParams 4
	  add $sp, $sp, 4	# pop params off stack
	# LCall _Halt
	  jal _Halt          	# jump to function
  _L20:
	# _tmp115 = 4
	  li $t2, 4		# load constant value 4 into $t2
	  sw $t2, -132($fp)	# spill _tmp115 from $t2 to $fp-132
	# _tmp116 = i * _tmp115
	  lw $t0, -8($fp)	# fill i to $t0 from $fp-8
	  lw $t1, -132($fp)	# fill _tmp115 to $t1 from $fp-132
	  mul $t2, $t0, $t1	
	  sw $t2, -136($fp)	# spill _tmp116 from $t2 to $fp-136
	# _tmp117 = _tmp116 + _tmp115
	  lw $t0, -136($fp)	# fill _tmp116 to $t0 from $fp-136
	  lw $t1, -132($fp)	# fill _tmp115 to $t1 from $fp-132
	  add $t2, $t0, $t1	
	  sw $t2, -140($fp)	# spill _tmp117 from $t2 to $fp-140
	# _tmp118 = _tmp106 + _tmp117
	  lw $t0, -96($fp)	# fill _tmp106 to $t0 from $fp-96
	  lw $t1, -140($fp)	# fill _tmp117 to $t1 from $fp-140
	  add $t2, $t0, $t1	
	  sw $t2, -144($fp)	# spill _tmp118 from $t2 to $fp-144
	# _tmp119 = *(_tmp118)
	  lw $t0, -144($fp)	# fill _tmp118 to $t0 from $fp-144
	  lw $t2, 0($t0) 	# load with offset
	  sw $t2, -148($fp)	# spill _tmp119 from $t2 to $fp-148
	# PushParam _tmp119
	  subu $sp, $sp, 4	# decrement sp to make space for param
	  lw $t0, -148($fp)	# fill _tmp119 to $t0 from $fp-148
	  sw $t0, 4($sp)	# copy param value to stack
	# _tmp120 = *(_tmp119)
	  lw $t0, -148($fp)	# fill _tmp119 to $t0 from $fp-148
	  lw $t2, 0($t0) 	# load with offset
	  sw $t2, -152($fp)	# spill _tmp120 from $t2 to $fp-152
	# _tmp121 = *(_tmp120 + 16)
	  lw $t0, -152($fp)	# fill _tmp120 to $t0 from $fp-152
	  lw $t2, 16($t0) 	# load with offset
	  sw $t2, -156($fp)	# spill _tmp121 from $t2 to $fp-156
	# _tmp122 = ACall _tmp121
	  lw $t0, -156($fp)	# fill _tmp121 to $t0 from $fp-156
	  jalr $t0            	# jump to function
	  move $t2, $v0		# copy function return value from $v0
	  sw $t2, -160($fp)	# spill _tmp122 from $t2 to $fp-160
	# PopParams 4
	  add $sp, $sp, 4	# pop params off stack
	# PushParam l
	  subu $sp, $sp, 4	# decrement sp to make space for param
	  lw $t0, 12($fp)	# fill l to $t0 from $fp+12
	  sw $t0, 4($sp)	# copy param value to stack
	# PushParam _tmp122
	  subu $sp, $sp, 4	# decrement sp to make space for param
	  lw $t0, -160($fp)	# fill _tmp122 to $t0 from $fp-160
	  sw $t0, 4($sp)	# copy param value to stack
	# _tmp123 = LCall _StringEqual
	  jal _StringEqual   	# jump to function
	  move $t2, $v0		# copy function return value from $v0
	  sw $t2, -164($fp)	# spill _tmp123 from $t2 to $fp-164
	# PopParams 8
	  add $sp, $sp, 8	# pop params off stack
	# _tmp124 = _tmp105 && _tmp123
	  lw $t0, -92($fp)	# fill _tmp105 to $t0 from $fp-92
	  lw $t1, -164($fp)	# fill _tmp123 to $t1 from $fp-164
	  and $t2, $t0, $t1	
	  sw $t2, -168($fp)	# spill _tmp124 from $t2 to $fp-168
	# IfZ _tmp124 Goto _L17
	  lw $t0, -168($fp)	# fill _tmp124 to $t0 from $fp-168
	  beqz $t0, _L17	# branch if _tmp124 is zero 
	# Return i
	  lw $t2, -8($fp)	# fill i to $t2 from $fp-8
	  move $v0, $t2		# assign return value into $v0
	  move $sp, $fp		# pop callee frame off stack
	  lw $ra, -4($fp)	# restore saved ra
	  lw $fp, 0($fp)	# restore saved fp
	  jr $ra		# return from function
	# Goto _L18
	  b _L18		# unconditional branch
  _L17:
  _L18:
	# _tmp125 = 1
	  li $t2, 1		# load constant value 1 into $t2
	  sw $t2, -172($fp)	# spill _tmp125 from $t2 to $fp-172
	# _tmp126 = i + _tmp125
	  lw $t0, -8($fp)	# fill i to $t0 from $fp-8
	  lw $t1, -172($fp)	# fill _tmp125 to $t1 from $fp-172
	  add $t2, $t0, $t1	
	  sw $t2, -176($fp)	# spill _tmp126 from $t2 to $fp-176
	# i = _tmp126
	  lw $t2, -176($fp)	# fill _tmp126 to $t2 from $fp-176
	  sw $t2, -8($fp)	# spill i from $t2 to $fp-8
	# Goto _L15
	  b _L15		# unconditional branch
  _L16:
	# _tmp127 = 1
	  li $t2, 1		# load constant value 1 into $t2
	  sw $t2, -180($fp)	# spill _tmp127 from $t2 to $fp-180
	# _tmp128 = 0
	  li $t2, 0		# load constant value 0 into $t2
	  sw $t2, -184($fp)	# spill _tmp128 from $t2 to $fp-184
	# _tmp129 = _tmp128 - _tmp127
	  lw $t0, -184($fp)	# fill _tmp128 to $t0 from $fp-184
	  lw $t1, -180($fp)	# fill _tmp127 to $t1 from $fp-180
	  sub $t2, $t0, $t1	
	  sw $t2, -188($fp)	# spill _tmp129 from $t2 to $fp-188
	# Return _tmp129
	  lw $t2, -188($fp)	# fill _tmp129 to $t2 from $fp-188
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
  Database.____Edit:
	# BeginFunc 860
	  subu $sp, $sp, 8	# decrement sp to make space to save ra, fp
	  sw $fp, 8($sp)	# save fp
	  sw $ra, 4($sp)	# save ra
	  addiu $fp, $sp, 8	# set up new fp
	  subu $sp, $sp, 860	# decrement sp to make space for locals/temps
	# LCall ____PrintLine
	  jal ____PrintLine  	# jump to function
	# _tmp130 = "Editting person...\n\n"
	  .data			# create string constant marked with label
	  _string21: .asciiz "Editting person...\n\n"
	  .text
	  la $t2, _string21	# load label
	  sw $t2, -28($fp)	# spill _tmp130 from $t2 to $fp-28
	# PushParam _tmp130
	  subu $sp, $sp, 4	# decrement sp to make space for param
	  lw $t0, -28($fp)	# fill _tmp130 to $t0 from $fp-28
	  sw $t0, 4($sp)	# copy param value to stack
	# LCall _PrintString
	  jal _PrintString   	# jump to function
	# PopParams 4
	  add $sp, $sp, 4	# pop params off stack
	# _tmp131 = "Enter first name: "
	  .data			# create string constant marked with label
	  _string22: .asciiz "Enter first name: "
	  .text
	  la $t2, _string22	# load label
	  sw $t2, -32($fp)	# spill _tmp131 from $t2 to $fp-32
	# PushParam _tmp131
	  subu $sp, $sp, 4	# decrement sp to make space for param
	  lw $t0, -32($fp)	# fill _tmp131 to $t0 from $fp-32
	  sw $t0, 4($sp)	# copy param value to stack
	# LCall _PrintString
	  jal _PrintString   	# jump to function
	# PopParams 4
	  add $sp, $sp, 4	# pop params off stack
	# _tmp132 = LCall _ReadLine
	  jal _ReadLine      	# jump to function
	  move $t2, $v0		# copy function return value from $v0
	  sw $t2, -36($fp)	# spill _tmp132 from $t2 to $fp-36
	# f = _tmp132
	  lw $t2, -36($fp)	# fill _tmp132 to $t2 from $fp-36
	  sw $t2, -8($fp)	# spill f from $t2 to $fp-8
	# _tmp133 = "Enter last name: "
	  .data			# create string constant marked with label
	  _string23: .asciiz "Enter last name: "
	  .text
	  la $t2, _string23	# load label
	  sw $t2, -40($fp)	# spill _tmp133 from $t2 to $fp-40
	# PushParam _tmp133
	  subu $sp, $sp, 4	# decrement sp to make space for param
	  lw $t0, -40($fp)	# fill _tmp133 to $t0 from $fp-40
	  sw $t0, 4($sp)	# copy param value to stack
	# LCall _PrintString
	  jal _PrintString   	# jump to function
	# PopParams 4
	  add $sp, $sp, 4	# pop params off stack
	# _tmp134 = LCall _ReadLine
	  jal _ReadLine      	# jump to function
	  move $t2, $v0		# copy function return value from $v0
	  sw $t2, -44($fp)	# spill _tmp134 from $t2 to $fp-44
	# l = _tmp134
	  lw $t2, -44($fp)	# fill _tmp134 to $t2 from $fp-44
	  sw $t2, -12($fp)	# spill l from $t2 to $fp-12
	# PushParam l
	  subu $sp, $sp, 4	# decrement sp to make space for param
	  lw $t0, -12($fp)	# fill l to $t0 from $fp-12
	  sw $t0, 4($sp)	# copy param value to stack
	# PushParam f
	  subu $sp, $sp, 4	# decrement sp to make space for param
	  lw $t0, -8($fp)	# fill f to $t0 from $fp-8
	  sw $t0, 4($sp)	# copy param value to stack
	# PushParam this
	  subu $sp, $sp, 4	# decrement sp to make space for param
	  lw $t0, 4($fp)	# fill this to $t0 from $fp+4
	  sw $t0, 4($sp)	# copy param value to stack
	# _tmp135 = *(this)
	  lw $t0, 4($fp)	# fill this to $t0 from $fp+4
	  lw $t2, 0($t0) 	# load with offset
	  sw $t2, -48($fp)	# spill _tmp135 from $t2 to $fp-48
	# _tmp136 = *(_tmp135 + 8)
	  lw $t0, -48($fp)	# fill _tmp135 to $t0 from $fp-48
	  lw $t2, 8($t0) 	# load with offset
	  sw $t2, -52($fp)	# spill _tmp136 from $t2 to $fp-52
	# _tmp137 = ACall _tmp136
	  lw $t0, -52($fp)	# fill _tmp136 to $t0 from $fp-52
	  jalr $t0            	# jump to function
	  move $t2, $v0		# copy function return value from $v0
	  sw $t2, -56($fp)	# spill _tmp137 from $t2 to $fp-56
	# PopParams 12
	  add $sp, $sp, 12	# pop params off stack
	# index = _tmp137
	  lw $t2, -56($fp)	# fill _tmp137 to $t2 from $fp-56
	  sw $t2, -24($fp)	# spill index from $t2 to $fp-24
	# _tmp138 = 1
	  li $t2, 1		# load constant value 1 into $t2
	  sw $t2, -60($fp)	# spill _tmp138 from $t2 to $fp-60
	# _tmp139 = 0
	  li $t2, 0		# load constant value 0 into $t2
	  sw $t2, -64($fp)	# spill _tmp139 from $t2 to $fp-64
	# _tmp140 = _tmp139 - _tmp138
	  lw $t0, -64($fp)	# fill _tmp139 to $t0 from $fp-64
	  lw $t1, -60($fp)	# fill _tmp138 to $t1 from $fp-60
	  sub $t2, $t0, $t1	
	  sw $t2, -68($fp)	# spill _tmp140 from $t2 to $fp-68
	# _tmp141 = index == _tmp140
	  lw $t0, -24($fp)	# fill index to $t0 from $fp-24
	  lw $t1, -68($fp)	# fill _tmp140 to $t1 from $fp-68
	  seq $t2, $t0, $t1	
	  sw $t2, -72($fp)	# spill _tmp141 from $t2 to $fp-72
	# IfZ _tmp141 Goto _L21
	  lw $t0, -72($fp)	# fill _tmp141 to $t0 from $fp-72
	  beqz $t0, _L21	# branch if _tmp141 is zero 
	# _tmp142 = "\n"
	  .data			# create string constant marked with label
	  _string24: .asciiz "\n"
	  .text
	  la $t2, _string24	# load label
	  sw $t2, -76($fp)	# spill _tmp142 from $t2 to $fp-76
	# PushParam _tmp142
	  subu $sp, $sp, 4	# decrement sp to make space for param
	  lw $t0, -76($fp)	# fill _tmp142 to $t0 from $fp-76
	  sw $t0, 4($sp)	# copy param value to stack
	# LCall _PrintString
	  jal _PrintString   	# jump to function
	# PopParams 4
	  add $sp, $sp, 4	# pop params off stack
	# PushParam l
	  subu $sp, $sp, 4	# decrement sp to make space for param
	  lw $t0, -12($fp)	# fill l to $t0 from $fp-12
	  sw $t0, 4($sp)	# copy param value to stack
	# LCall _PrintString
	  jal _PrintString   	# jump to function
	# PopParams 4
	  add $sp, $sp, 4	# pop params off stack
	# _tmp143 = ", "
	  .data			# create string constant marked with label
	  _string25: .asciiz ", "
	  .text
	  la $t2, _string25	# load label
	  sw $t2, -80($fp)	# spill _tmp143 from $t2 to $fp-80
	# PushParam _tmp143
	  subu $sp, $sp, 4	# decrement sp to make space for param
	  lw $t0, -80($fp)	# fill _tmp143 to $t0 from $fp-80
	  sw $t0, 4($sp)	# copy param value to stack
	# LCall _PrintString
	  jal _PrintString   	# jump to function
	# PopParams 4
	  add $sp, $sp, 4	# pop params off stack
	# PushParam f
	  subu $sp, $sp, 4	# decrement sp to make space for param
	  lw $t0, -8($fp)	# fill f to $t0 from $fp-8
	  sw $t0, 4($sp)	# copy param value to stack
	# LCall _PrintString
	  jal _PrintString   	# jump to function
	# PopParams 4
	  add $sp, $sp, 4	# pop params off stack
	# _tmp144 = " not found!\n"
	  .data			# create string constant marked with label
	  _string26: .asciiz " not found!\n"
	  .text
	  la $t2, _string26	# load label
	  sw $t2, -84($fp)	# spill _tmp144 from $t2 to $fp-84
	# PushParam _tmp144
	  subu $sp, $sp, 4	# decrement sp to make space for param
	  lw $t0, -84($fp)	# fill _tmp144 to $t0 from $fp-84
	  sw $t0, 4($sp)	# copy param value to stack
	# LCall _PrintString
	  jal _PrintString   	# jump to function
	# PopParams 4
	  add $sp, $sp, 4	# pop params off stack
	# LCall ____PrintLine
	  jal ____PrintLine  	# jump to function
	# Return 
	  move $sp, $fp		# pop callee frame off stack
	  lw $ra, -4($fp)	# restore saved ra
	  lw $fp, 0($fp)	# restore saved fp
	  jr $ra		# return from function
	# Goto _L22
	  b _L22		# unconditional branch
  _L21:
  _L22:
	# _tmp145 = "\n"
	  .data			# create string constant marked with label
	  _string27: .asciiz "\n"
	  .text
	  la $t2, _string27	# load label
	  sw $t2, -88($fp)	# spill _tmp145 from $t2 to $fp-88
	# PushParam _tmp145
	  subu $sp, $sp, 4	# decrement sp to make space for param
	  lw $t0, -88($fp)	# fill _tmp145 to $t0 from $fp-88
	  sw $t0, 4($sp)	# copy param value to stack
	# LCall _PrintString
	  jal _PrintString   	# jump to function
	# PopParams 4
	  add $sp, $sp, 4	# pop params off stack
	# PushParam l
	  subu $sp, $sp, 4	# decrement sp to make space for param
	  lw $t0, -12($fp)	# fill l to $t0 from $fp-12
	  sw $t0, 4($sp)	# copy param value to stack
	# LCall _PrintString
	  jal _PrintString   	# jump to function
	# PopParams 4
	  add $sp, $sp, 4	# pop params off stack
	# _tmp146 = ", "
	  .data			# create string constant marked with label
	  _string28: .asciiz ", "
	  .text
	  la $t2, _string28	# load label
	  sw $t2, -92($fp)	# spill _tmp146 from $t2 to $fp-92
	# PushParam _tmp146
	  subu $sp, $sp, 4	# decrement sp to make space for param
	  lw $t0, -92($fp)	# fill _tmp146 to $t0 from $fp-92
	  sw $t0, 4($sp)	# copy param value to stack
	# LCall _PrintString
	  jal _PrintString   	# jump to function
	# PopParams 4
	  add $sp, $sp, 4	# pop params off stack
	# PushParam f
	  subu $sp, $sp, 4	# decrement sp to make space for param
	  lw $t0, -8($fp)	# fill f to $t0 from $fp-8
	  sw $t0, 4($sp)	# copy param value to stack
	# LCall _PrintString
	  jal _PrintString   	# jump to function
	# PopParams 4
	  add $sp, $sp, 4	# pop params off stack
	# _tmp147 = " found...\n\n"
	  .data			# create string constant marked with label
	  _string29: .asciiz " found...\n\n"
	  .text
	  la $t2, _string29	# load label
	  sw $t2, -96($fp)	# spill _tmp147 from $t2 to $fp-96
	# PushParam _tmp147
	  subu $sp, $sp, 4	# decrement sp to make space for param
	  lw $t0, -96($fp)	# fill _tmp147 to $t0 from $fp-96
	  sw $t0, 4($sp)	# copy param value to stack
	# LCall _PrintString
	  jal _PrintString   	# jump to function
	# PopParams 4
	  add $sp, $sp, 4	# pop params off stack
	# _tmp148 = "Old first name: "
	  .data			# create string constant marked with label
	  _string30: .asciiz "Old first name: "
	  .text
	  la $t2, _string30	# load label
	  sw $t2, -100($fp)	# spill _tmp148 from $t2 to $fp-100
	# PushParam _tmp148
	  subu $sp, $sp, 4	# decrement sp to make space for param
	  lw $t0, -100($fp)	# fill _tmp148 to $t0 from $fp-100
	  sw $t0, 4($sp)	# copy param value to stack
	# LCall _PrintString
	  jal _PrintString   	# jump to function
	# PopParams 4
	  add $sp, $sp, 4	# pop params off stack
	# _tmp149 = *(this + 12)
	  lw $t0, 4($fp)	# fill this to $t0 from $fp+4
	  lw $t2, 12($t0) 	# load with offset
	  sw $t2, -104($fp)	# spill _tmp149 from $t2 to $fp-104
	# _tmp150 = 0
	  li $t2, 0		# load constant value 0 into $t2
	  sw $t2, -108($fp)	# spill _tmp150 from $t2 to $fp-108
	# _tmp151 = *(_tmp149)
	  lw $t0, -104($fp)	# fill _tmp149 to $t0 from $fp-104
	  lw $t2, 0($t0) 	# load with offset
	  sw $t2, -112($fp)	# spill _tmp151 from $t2 to $fp-112
	# _tmp152 = index < _tmp150
	  lw $t0, -24($fp)	# fill index to $t0 from $fp-24
	  lw $t1, -108($fp)	# fill _tmp150 to $t1 from $fp-108
	  slt $t2, $t0, $t1	
	  sw $t2, -116($fp)	# spill _tmp152 from $t2 to $fp-116
	# _tmp153 = _tmp151 < index
	  lw $t0, -112($fp)	# fill _tmp151 to $t0 from $fp-112
	  lw $t1, -24($fp)	# fill index to $t1 from $fp-24
	  slt $t2, $t0, $t1	
	  sw $t2, -120($fp)	# spill _tmp153 from $t2 to $fp-120
	# _tmp154 = _tmp151 == index
	  lw $t0, -112($fp)	# fill _tmp151 to $t0 from $fp-112
	  lw $t1, -24($fp)	# fill index to $t1 from $fp-24
	  seq $t2, $t0, $t1	
	  sw $t2, -124($fp)	# spill _tmp154 from $t2 to $fp-124
	# _tmp155 = _tmp153 || _tmp154
	  lw $t0, -120($fp)	# fill _tmp153 to $t0 from $fp-120
	  lw $t1, -124($fp)	# fill _tmp154 to $t1 from $fp-124
	  or $t2, $t0, $t1	
	  sw $t2, -128($fp)	# spill _tmp155 from $t2 to $fp-128
	# _tmp156 = _tmp155 || _tmp152
	  lw $t0, -128($fp)	# fill _tmp155 to $t0 from $fp-128
	  lw $t1, -116($fp)	# fill _tmp152 to $t1 from $fp-116
	  or $t2, $t0, $t1	
	  sw $t2, -132($fp)	# spill _tmp156 from $t2 to $fp-132
	# IfZ _tmp156 Goto _L23
	  lw $t0, -132($fp)	# fill _tmp156 to $t0 from $fp-132
	  beqz $t0, _L23	# branch if _tmp156 is zero 
	# _tmp157 = "Decaf runtime error: Array subscript out of bound..."
	  .data			# create string constant marked with label
	  _string31: .asciiz "Decaf runtime error: Array subscript out of bounds\n"
	  .text
	  la $t2, _string31	# load label
	  sw $t2, -136($fp)	# spill _tmp157 from $t2 to $fp-136
	# PushParam _tmp157
	  subu $sp, $sp, 4	# decrement sp to make space for param
	  lw $t0, -136($fp)	# fill _tmp157 to $t0 from $fp-136
	  sw $t0, 4($sp)	# copy param value to stack
	# LCall _PrintString
	  jal _PrintString   	# jump to function
	# PopParams 4
	  add $sp, $sp, 4	# pop params off stack
	# LCall _Halt
	  jal _Halt          	# jump to function
  _L23:
	# _tmp158 = 4
	  li $t2, 4		# load constant value 4 into $t2
	  sw $t2, -140($fp)	# spill _tmp158 from $t2 to $fp-140
	# _tmp159 = index * _tmp158
	  lw $t0, -24($fp)	# fill index to $t0 from $fp-24
	  lw $t1, -140($fp)	# fill _tmp158 to $t1 from $fp-140
	  mul $t2, $t0, $t1	
	  sw $t2, -144($fp)	# spill _tmp159 from $t2 to $fp-144
	# _tmp160 = _tmp159 + _tmp158
	  lw $t0, -144($fp)	# fill _tmp159 to $t0 from $fp-144
	  lw $t1, -140($fp)	# fill _tmp158 to $t1 from $fp-140
	  add $t2, $t0, $t1	
	  sw $t2, -148($fp)	# spill _tmp160 from $t2 to $fp-148
	# _tmp161 = _tmp149 + _tmp160
	  lw $t0, -104($fp)	# fill _tmp149 to $t0 from $fp-104
	  lw $t1, -148($fp)	# fill _tmp160 to $t1 from $fp-148
	  add $t2, $t0, $t1	
	  sw $t2, -152($fp)	# spill _tmp161 from $t2 to $fp-152
	# _tmp162 = *(_tmp161)
	  lw $t0, -152($fp)	# fill _tmp161 to $t0 from $fp-152
	  lw $t2, 0($t0) 	# load with offset
	  sw $t2, -156($fp)	# spill _tmp162 from $t2 to $fp-156
	# PushParam _tmp162
	  subu $sp, $sp, 4	# decrement sp to make space for param
	  lw $t0, -156($fp)	# fill _tmp162 to $t0 from $fp-156
	  sw $t0, 4($sp)	# copy param value to stack
	# _tmp163 = *(_tmp162)
	  lw $t0, -156($fp)	# fill _tmp162 to $t0 from $fp-156
	  lw $t2, 0($t0) 	# load with offset
	  sw $t2, -160($fp)	# spill _tmp163 from $t2 to $fp-160
	# _tmp164 = *(_tmp163 + 8)
	  lw $t0, -160($fp)	# fill _tmp163 to $t0 from $fp-160
	  lw $t2, 8($t0) 	# load with offset
	  sw $t2, -164($fp)	# spill _tmp164 from $t2 to $fp-164
	# _tmp165 = ACall _tmp164
	  lw $t0, -164($fp)	# fill _tmp164 to $t0 from $fp-164
	  jalr $t0            	# jump to function
	  move $t2, $v0		# copy function return value from $v0
	  sw $t2, -168($fp)	# spill _tmp165 from $t2 to $fp-168
	# PopParams 4
	  add $sp, $sp, 4	# pop params off stack
	# PushParam _tmp165
	  subu $sp, $sp, 4	# decrement sp to make space for param
	  lw $t0, -168($fp)	# fill _tmp165 to $t0 from $fp-168
	  sw $t0, 4($sp)	# copy param value to stack
	# LCall _PrintString
	  jal _PrintString   	# jump to function
	# PopParams 4
	  add $sp, $sp, 4	# pop params off stack
	# _tmp166 = "\n"
	  .data			# create string constant marked with label
	  _string32: .asciiz "\n"
	  .text
	  la $t2, _string32	# load label
	  sw $t2, -172($fp)	# spill _tmp166 from $t2 to $fp-172
	# PushParam _tmp166
	  subu $sp, $sp, 4	# decrement sp to make space for param
	  lw $t0, -172($fp)	# fill _tmp166 to $t0 from $fp-172
	  sw $t0, 4($sp)	# copy param value to stack
	# LCall _PrintString
	  jal _PrintString   	# jump to function
	# PopParams 4
	  add $sp, $sp, 4	# pop params off stack
	# _tmp167 = "Enter new first name (or nothing to leave unchang..."
	  .data			# create string constant marked with label
	  _string33: .asciiz "Enter new first name (or nothing to leave unchanged): "
	  .text
	  la $t2, _string33	# load label
	  sw $t2, -176($fp)	# spill _tmp167 from $t2 to $fp-176
	# PushParam _tmp167
	  subu $sp, $sp, 4	# decrement sp to make space for param
	  lw $t0, -176($fp)	# fill _tmp167 to $t0 from $fp-176
	  sw $t0, 4($sp)	# copy param value to stack
	# LCall _PrintString
	  jal _PrintString   	# jump to function
	# PopParams 4
	  add $sp, $sp, 4	# pop params off stack
	# _tmp168 = LCall _ReadLine
	  jal _ReadLine      	# jump to function
	  move $t2, $v0		# copy function return value from $v0
	  sw $t2, -180($fp)	# spill _tmp168 from $t2 to $fp-180
	# f = _tmp168
	  lw $t2, -180($fp)	# fill _tmp168 to $t2 from $fp-180
	  sw $t2, -8($fp)	# spill f from $t2 to $fp-8
	# _tmp170 = ""
	  .data			# create string constant marked with label
	  _string34: .asciiz ""
	  .text
	  la $t2, _string34	# load label
	  sw $t2, -188($fp)	# spill _tmp170 from $t2 to $fp-188
	# PushParam _tmp170
	  subu $sp, $sp, 4	# decrement sp to make space for param
	  lw $t0, -188($fp)	# fill _tmp170 to $t0 from $fp-188
	  sw $t0, 4($sp)	# copy param value to stack
	# PushParam f
	  subu $sp, $sp, 4	# decrement sp to make space for param
	  lw $t0, -8($fp)	# fill f to $t0 from $fp-8
	  sw $t0, 4($sp)	# copy param value to stack
	# _tmp171 = LCall _StringEqual
	  jal _StringEqual   	# jump to function
	  move $t2, $v0		# copy function return value from $v0
	  sw $t2, -192($fp)	# spill _tmp171 from $t2 to $fp-192
	# PopParams 8
	  add $sp, $sp, 8	# pop params off stack
	# IfZ _tmp171 Goto _L27
	  lw $t0, -192($fp)	# fill _tmp171 to $t0 from $fp-192
	  beqz $t0, _L27	# branch if _tmp171 is zero 
	# _tmp172 = 0
	  li $t2, 0		# load constant value 0 into $t2
	  sw $t2, -196($fp)	# spill _tmp172 from $t2 to $fp-196
	# _tmp169 = _tmp172
	  lw $t2, -196($fp)	# fill _tmp172 to $t2 from $fp-196
	  sw $t2, -184($fp)	# spill _tmp169 from $t2 to $fp-184
	# Goto _L26
	  b _L26		# unconditional branch
  _L27:
	# _tmp173 = 1
	  li $t2, 1		# load constant value 1 into $t2
	  sw $t2, -200($fp)	# spill _tmp173 from $t2 to $fp-200
	# _tmp169 = _tmp173
	  lw $t2, -200($fp)	# fill _tmp173 to $t2 from $fp-200
	  sw $t2, -184($fp)	# spill _tmp169 from $t2 to $fp-184
  _L26:
	# IfZ _tmp169 Goto _L24
	  lw $t0, -184($fp)	# fill _tmp169 to $t0 from $fp-184
	  beqz $t0, _L24	# branch if _tmp169 is zero 
	# PushParam f
	  subu $sp, $sp, 4	# decrement sp to make space for param
	  lw $t0, -8($fp)	# fill f to $t0 from $fp-8
	  sw $t0, 4($sp)	# copy param value to stack
	# _tmp174 = *(this + 12)
	  lw $t0, 4($fp)	# fill this to $t0 from $fp+4
	  lw $t2, 12($t0) 	# load with offset
	  sw $t2, -204($fp)	# spill _tmp174 from $t2 to $fp-204
	# _tmp175 = 0
	  li $t2, 0		# load constant value 0 into $t2
	  sw $t2, -208($fp)	# spill _tmp175 from $t2 to $fp-208
	# _tmp176 = *(_tmp174)
	  lw $t0, -204($fp)	# fill _tmp174 to $t0 from $fp-204
	  lw $t2, 0($t0) 	# load with offset
	  sw $t2, -212($fp)	# spill _tmp176 from $t2 to $fp-212
	# _tmp177 = index < _tmp175
	  lw $t0, -24($fp)	# fill index to $t0 from $fp-24
	  lw $t1, -208($fp)	# fill _tmp175 to $t1 from $fp-208
	  slt $t2, $t0, $t1	
	  sw $t2, -216($fp)	# spill _tmp177 from $t2 to $fp-216
	# _tmp178 = _tmp176 < index
	  lw $t0, -212($fp)	# fill _tmp176 to $t0 from $fp-212
	  lw $t1, -24($fp)	# fill index to $t1 from $fp-24
	  slt $t2, $t0, $t1	
	  sw $t2, -220($fp)	# spill _tmp178 from $t2 to $fp-220
	# _tmp179 = _tmp176 == index
	  lw $t0, -212($fp)	# fill _tmp176 to $t0 from $fp-212
	  lw $t1, -24($fp)	# fill index to $t1 from $fp-24
	  seq $t2, $t0, $t1	
	  sw $t2, -224($fp)	# spill _tmp179 from $t2 to $fp-224
	# _tmp180 = _tmp178 || _tmp179
	  lw $t0, -220($fp)	# fill _tmp178 to $t0 from $fp-220
	  lw $t1, -224($fp)	# fill _tmp179 to $t1 from $fp-224
	  or $t2, $t0, $t1	
	  sw $t2, -228($fp)	# spill _tmp180 from $t2 to $fp-228
	# _tmp181 = _tmp180 || _tmp177
	  lw $t0, -228($fp)	# fill _tmp180 to $t0 from $fp-228
	  lw $t1, -216($fp)	# fill _tmp177 to $t1 from $fp-216
	  or $t2, $t0, $t1	
	  sw $t2, -232($fp)	# spill _tmp181 from $t2 to $fp-232
	# IfZ _tmp181 Goto _L28
	  lw $t0, -232($fp)	# fill _tmp181 to $t0 from $fp-232
	  beqz $t0, _L28	# branch if _tmp181 is zero 
	# _tmp182 = "Decaf runtime error: Array subscript out of bound..."
	  .data			# create string constant marked with label
	  _string35: .asciiz "Decaf runtime error: Array subscript out of bounds\n"
	  .text
	  la $t2, _string35	# load label
	  sw $t2, -236($fp)	# spill _tmp182 from $t2 to $fp-236
	# PushParam _tmp182
	  subu $sp, $sp, 4	# decrement sp to make space for param
	  lw $t0, -236($fp)	# fill _tmp182 to $t0 from $fp-236
	  sw $t0, 4($sp)	# copy param value to stack
	# LCall _PrintString
	  jal _PrintString   	# jump to function
	# PopParams 4
	  add $sp, $sp, 4	# pop params off stack
	# LCall _Halt
	  jal _Halt          	# jump to function
  _L28:
	# _tmp183 = 4
	  li $t2, 4		# load constant value 4 into $t2
	  sw $t2, -240($fp)	# spill _tmp183 from $t2 to $fp-240
	# _tmp184 = index * _tmp183
	  lw $t0, -24($fp)	# fill index to $t0 from $fp-24
	  lw $t1, -240($fp)	# fill _tmp183 to $t1 from $fp-240
	  mul $t2, $t0, $t1	
	  sw $t2, -244($fp)	# spill _tmp184 from $t2 to $fp-244
	# _tmp185 = _tmp184 + _tmp183
	  lw $t0, -244($fp)	# fill _tmp184 to $t0 from $fp-244
	  lw $t1, -240($fp)	# fill _tmp183 to $t1 from $fp-240
	  add $t2, $t0, $t1	
	  sw $t2, -248($fp)	# spill _tmp185 from $t2 to $fp-248
	# _tmp186 = _tmp174 + _tmp185
	  lw $t0, -204($fp)	# fill _tmp174 to $t0 from $fp-204
	  lw $t1, -248($fp)	# fill _tmp185 to $t1 from $fp-248
	  add $t2, $t0, $t1	
	  sw $t2, -252($fp)	# spill _tmp186 from $t2 to $fp-252
	# _tmp187 = *(_tmp186)
	  lw $t0, -252($fp)	# fill _tmp186 to $t0 from $fp-252
	  lw $t2, 0($t0) 	# load with offset
	  sw $t2, -256($fp)	# spill _tmp187 from $t2 to $fp-256
	# PushParam _tmp187
	  subu $sp, $sp, 4	# decrement sp to make space for param
	  lw $t0, -256($fp)	# fill _tmp187 to $t0 from $fp-256
	  sw $t0, 4($sp)	# copy param value to stack
	# _tmp188 = *(_tmp187)
	  lw $t0, -256($fp)	# fill _tmp187 to $t0 from $fp-256
	  lw $t2, 0($t0) 	# load with offset
	  sw $t2, -260($fp)	# spill _tmp188 from $t2 to $fp-260
	# _tmp189 = *(_tmp188 + 4)
	  lw $t0, -260($fp)	# fill _tmp188 to $t0 from $fp-260
	  lw $t2, 4($t0) 	# load with offset
	  sw $t2, -264($fp)	# spill _tmp189 from $t2 to $fp-264
	# ACall _tmp189
	  lw $t0, -264($fp)	# fill _tmp189 to $t0 from $fp-264
	  jalr $t0            	# jump to function
	# PopParams 8
	  add $sp, $sp, 8	# pop params off stack
	# Goto _L25
	  b _L25		# unconditional branch
  _L24:
  _L25:
	# _tmp190 = "Old last name: "
	  .data			# create string constant marked with label
	  _string36: .asciiz "Old last name: "
	  .text
	  la $t2, _string36	# load label
	  sw $t2, -268($fp)	# spill _tmp190 from $t2 to $fp-268
	# PushParam _tmp190
	  subu $sp, $sp, 4	# decrement sp to make space for param
	  lw $t0, -268($fp)	# fill _tmp190 to $t0 from $fp-268
	  sw $t0, 4($sp)	# copy param value to stack
	# LCall _PrintString
	  jal _PrintString   	# jump to function
	# PopParams 4
	  add $sp, $sp, 4	# pop params off stack
	# _tmp191 = *(this + 12)
	  lw $t0, 4($fp)	# fill this to $t0 from $fp+4
	  lw $t2, 12($t0) 	# load with offset
	  sw $t2, -272($fp)	# spill _tmp191 from $t2 to $fp-272
	# _tmp192 = 0
	  li $t2, 0		# load constant value 0 into $t2
	  sw $t2, -276($fp)	# spill _tmp192 from $t2 to $fp-276
	# _tmp193 = *(_tmp191)
	  lw $t0, -272($fp)	# fill _tmp191 to $t0 from $fp-272
	  lw $t2, 0($t0) 	# load with offset
	  sw $t2, -280($fp)	# spill _tmp193 from $t2 to $fp-280
	# _tmp194 = index < _tmp192
	  lw $t0, -24($fp)	# fill index to $t0 from $fp-24
	  lw $t1, -276($fp)	# fill _tmp192 to $t1 from $fp-276
	  slt $t2, $t0, $t1	
	  sw $t2, -284($fp)	# spill _tmp194 from $t2 to $fp-284
	# _tmp195 = _tmp193 < index
	  lw $t0, -280($fp)	# fill _tmp193 to $t0 from $fp-280
	  lw $t1, -24($fp)	# fill index to $t1 from $fp-24
	  slt $t2, $t0, $t1	
	  sw $t2, -288($fp)	# spill _tmp195 from $t2 to $fp-288
	# _tmp196 = _tmp193 == index
	  lw $t0, -280($fp)	# fill _tmp193 to $t0 from $fp-280
	  lw $t1, -24($fp)	# fill index to $t1 from $fp-24
	  seq $t2, $t0, $t1	
	  sw $t2, -292($fp)	# spill _tmp196 from $t2 to $fp-292
	# _tmp197 = _tmp195 || _tmp196
	  lw $t0, -288($fp)	# fill _tmp195 to $t0 from $fp-288
	  lw $t1, -292($fp)	# fill _tmp196 to $t1 from $fp-292
	  or $t2, $t0, $t1	
	  sw $t2, -296($fp)	# spill _tmp197 from $t2 to $fp-296
	# _tmp198 = _tmp197 || _tmp194
	  lw $t0, -296($fp)	# fill _tmp197 to $t0 from $fp-296
	  lw $t1, -284($fp)	# fill _tmp194 to $t1 from $fp-284
	  or $t2, $t0, $t1	
	  sw $t2, -300($fp)	# spill _tmp198 from $t2 to $fp-300
	# IfZ _tmp198 Goto _L29
	  lw $t0, -300($fp)	# fill _tmp198 to $t0 from $fp-300
	  beqz $t0, _L29	# branch if _tmp198 is zero 
	# _tmp199 = "Decaf runtime error: Array subscript out of bound..."
	  .data			# create string constant marked with label
	  _string37: .asciiz "Decaf runtime error: Array subscript out of bounds\n"
	  .text
	  la $t2, _string37	# load label
	  sw $t2, -304($fp)	# spill _tmp199 from $t2 to $fp-304
	# PushParam _tmp199
	  subu $sp, $sp, 4	# decrement sp to make space for param
	  lw $t0, -304($fp)	# fill _tmp199 to $t0 from $fp-304
	  sw $t0, 4($sp)	# copy param value to stack
	# LCall _PrintString
	  jal _PrintString   	# jump to function
	# PopParams 4
	  add $sp, $sp, 4	# pop params off stack
	# LCall _Halt
	  jal _Halt          	# jump to function
  _L29:
	# _tmp200 = 4
	  li $t2, 4		# load constant value 4 into $t2
	  sw $t2, -308($fp)	# spill _tmp200 from $t2 to $fp-308
	# _tmp201 = index * _tmp200
	  lw $t0, -24($fp)	# fill index to $t0 from $fp-24
	  lw $t1, -308($fp)	# fill _tmp200 to $t1 from $fp-308
	  mul $t2, $t0, $t1	
	  sw $t2, -312($fp)	# spill _tmp201 from $t2 to $fp-312
	# _tmp202 = _tmp201 + _tmp200
	  lw $t0, -312($fp)	# fill _tmp201 to $t0 from $fp-312
	  lw $t1, -308($fp)	# fill _tmp200 to $t1 from $fp-308
	  add $t2, $t0, $t1	
	  sw $t2, -316($fp)	# spill _tmp202 from $t2 to $fp-316
	# _tmp203 = _tmp191 + _tmp202
	  lw $t0, -272($fp)	# fill _tmp191 to $t0 from $fp-272
	  lw $t1, -316($fp)	# fill _tmp202 to $t1 from $fp-316
	  add $t2, $t0, $t1	
	  sw $t2, -320($fp)	# spill _tmp203 from $t2 to $fp-320
	# _tmp204 = *(_tmp203)
	  lw $t0, -320($fp)	# fill _tmp203 to $t0 from $fp-320
	  lw $t2, 0($t0) 	# load with offset
	  sw $t2, -324($fp)	# spill _tmp204 from $t2 to $fp-324
	# PushParam _tmp204
	  subu $sp, $sp, 4	# decrement sp to make space for param
	  lw $t0, -324($fp)	# fill _tmp204 to $t0 from $fp-324
	  sw $t0, 4($sp)	# copy param value to stack
	# _tmp205 = *(_tmp204)
	  lw $t0, -324($fp)	# fill _tmp204 to $t0 from $fp-324
	  lw $t2, 0($t0) 	# load with offset
	  sw $t2, -328($fp)	# spill _tmp205 from $t2 to $fp-328
	# _tmp206 = *(_tmp205 + 16)
	  lw $t0, -328($fp)	# fill _tmp205 to $t0 from $fp-328
	  lw $t2, 16($t0) 	# load with offset
	  sw $t2, -332($fp)	# spill _tmp206 from $t2 to $fp-332
	# _tmp207 = ACall _tmp206
	  lw $t0, -332($fp)	# fill _tmp206 to $t0 from $fp-332
	  jalr $t0            	# jump to function
	  move $t2, $v0		# copy function return value from $v0
	  sw $t2, -336($fp)	# spill _tmp207 from $t2 to $fp-336
	# PopParams 4
	  add $sp, $sp, 4	# pop params off stack
	# PushParam _tmp207
	  subu $sp, $sp, 4	# decrement sp to make space for param
	  lw $t0, -336($fp)	# fill _tmp207 to $t0 from $fp-336
	  sw $t0, 4($sp)	# copy param value to stack
	# LCall _PrintString
	  jal _PrintString   	# jump to function
	# PopParams 4
	  add $sp, $sp, 4	# pop params off stack
	# _tmp208 = "\n"
	  .data			# create string constant marked with label
	  _string38: .asciiz "\n"
	  .text
	  la $t2, _string38	# load label
	  sw $t2, -340($fp)	# spill _tmp208 from $t2 to $fp-340
	# PushParam _tmp208
	  subu $sp, $sp, 4	# decrement sp to make space for param
	  lw $t0, -340($fp)	# fill _tmp208 to $t0 from $fp-340
	  sw $t0, 4($sp)	# copy param value to stack
	# LCall _PrintString
	  jal _PrintString   	# jump to function
	# PopParams 4
	  add $sp, $sp, 4	# pop params off stack
	# _tmp209 = "Enter new first name (or nothing to leave unchang..."
	  .data			# create string constant marked with label
	  _string39: .asciiz "Enter new first name (or nothing to leave unchanged): "
	  .text
	  la $t2, _string39	# load label
	  sw $t2, -344($fp)	# spill _tmp209 from $t2 to $fp-344
	# PushParam _tmp209
	  subu $sp, $sp, 4	# decrement sp to make space for param
	  lw $t0, -344($fp)	# fill _tmp209 to $t0 from $fp-344
	  sw $t0, 4($sp)	# copy param value to stack
	# LCall _PrintString
	  jal _PrintString   	# jump to function
	# PopParams 4
	  add $sp, $sp, 4	# pop params off stack
	# _tmp210 = LCall _ReadLine
	  jal _ReadLine      	# jump to function
	  move $t2, $v0		# copy function return value from $v0
	  sw $t2, -348($fp)	# spill _tmp210 from $t2 to $fp-348
	# l = _tmp210
	  lw $t2, -348($fp)	# fill _tmp210 to $t2 from $fp-348
	  sw $t2, -12($fp)	# spill l from $t2 to $fp-12
	# _tmp212 = ""
	  .data			# create string constant marked with label
	  _string40: .asciiz ""
	  .text
	  la $t2, _string40	# load label
	  sw $t2, -356($fp)	# spill _tmp212 from $t2 to $fp-356
	# PushParam _tmp212
	  subu $sp, $sp, 4	# decrement sp to make space for param
	  lw $t0, -356($fp)	# fill _tmp212 to $t0 from $fp-356
	  sw $t0, 4($sp)	# copy param value to stack
	# PushParam l
	  subu $sp, $sp, 4	# decrement sp to make space for param
	  lw $t0, -12($fp)	# fill l to $t0 from $fp-12
	  sw $t0, 4($sp)	# copy param value to stack
	# _tmp213 = LCall _StringEqual
	  jal _StringEqual   	# jump to function
	  move $t2, $v0		# copy function return value from $v0
	  sw $t2, -360($fp)	# spill _tmp213 from $t2 to $fp-360
	# PopParams 8
	  add $sp, $sp, 8	# pop params off stack
	# IfZ _tmp213 Goto _L33
	  lw $t0, -360($fp)	# fill _tmp213 to $t0 from $fp-360
	  beqz $t0, _L33	# branch if _tmp213 is zero 
	# _tmp214 = 0
	  li $t2, 0		# load constant value 0 into $t2
	  sw $t2, -364($fp)	# spill _tmp214 from $t2 to $fp-364
	# _tmp211 = _tmp214
	  lw $t2, -364($fp)	# fill _tmp214 to $t2 from $fp-364
	  sw $t2, -352($fp)	# spill _tmp211 from $t2 to $fp-352
	# Goto _L32
	  b _L32		# unconditional branch
  _L33:
	# _tmp215 = 1
	  li $t2, 1		# load constant value 1 into $t2
	  sw $t2, -368($fp)	# spill _tmp215 from $t2 to $fp-368
	# _tmp211 = _tmp215
	  lw $t2, -368($fp)	# fill _tmp215 to $t2 from $fp-368
	  sw $t2, -352($fp)	# spill _tmp211 from $t2 to $fp-352
  _L32:
	# IfZ _tmp211 Goto _L30
	  lw $t0, -352($fp)	# fill _tmp211 to $t0 from $fp-352
	  beqz $t0, _L30	# branch if _tmp211 is zero 
	# PushParam l
	  subu $sp, $sp, 4	# decrement sp to make space for param
	  lw $t0, -12($fp)	# fill l to $t0 from $fp-12
	  sw $t0, 4($sp)	# copy param value to stack
	# _tmp216 = *(this + 12)
	  lw $t0, 4($fp)	# fill this to $t0 from $fp+4
	  lw $t2, 12($t0) 	# load with offset
	  sw $t2, -372($fp)	# spill _tmp216 from $t2 to $fp-372
	# _tmp217 = 0
	  li $t2, 0		# load constant value 0 into $t2
	  sw $t2, -376($fp)	# spill _tmp217 from $t2 to $fp-376
	# _tmp218 = *(_tmp216)
	  lw $t0, -372($fp)	# fill _tmp216 to $t0 from $fp-372
	  lw $t2, 0($t0) 	# load with offset
	  sw $t2, -380($fp)	# spill _tmp218 from $t2 to $fp-380
	# _tmp219 = index < _tmp217
	  lw $t0, -24($fp)	# fill index to $t0 from $fp-24
	  lw $t1, -376($fp)	# fill _tmp217 to $t1 from $fp-376
	  slt $t2, $t0, $t1	
	  sw $t2, -384($fp)	# spill _tmp219 from $t2 to $fp-384
	# _tmp220 = _tmp218 < index
	  lw $t0, -380($fp)	# fill _tmp218 to $t0 from $fp-380
	  lw $t1, -24($fp)	# fill index to $t1 from $fp-24
	  slt $t2, $t0, $t1	
	  sw $t2, -388($fp)	# spill _tmp220 from $t2 to $fp-388
	# _tmp221 = _tmp218 == index
	  lw $t0, -380($fp)	# fill _tmp218 to $t0 from $fp-380
	  lw $t1, -24($fp)	# fill index to $t1 from $fp-24
	  seq $t2, $t0, $t1	
	  sw $t2, -392($fp)	# spill _tmp221 from $t2 to $fp-392
	# _tmp222 = _tmp220 || _tmp221
	  lw $t0, -388($fp)	# fill _tmp220 to $t0 from $fp-388
	  lw $t1, -392($fp)	# fill _tmp221 to $t1 from $fp-392
	  or $t2, $t0, $t1	
	  sw $t2, -396($fp)	# spill _tmp222 from $t2 to $fp-396
	# _tmp223 = _tmp222 || _tmp219
	  lw $t0, -396($fp)	# fill _tmp222 to $t0 from $fp-396
	  lw $t1, -384($fp)	# fill _tmp219 to $t1 from $fp-384
	  or $t2, $t0, $t1	
	  sw $t2, -400($fp)	# spill _tmp223 from $t2 to $fp-400
	# IfZ _tmp223 Goto _L34
	  lw $t0, -400($fp)	# fill _tmp223 to $t0 from $fp-400
	  beqz $t0, _L34	# branch if _tmp223 is zero 
	# _tmp224 = "Decaf runtime error: Array subscript out of bound..."
	  .data			# create string constant marked with label
	  _string41: .asciiz "Decaf runtime error: Array subscript out of bounds\n"
	  .text
	  la $t2, _string41	# load label
	  sw $t2, -404($fp)	# spill _tmp224 from $t2 to $fp-404
	# PushParam _tmp224
	  subu $sp, $sp, 4	# decrement sp to make space for param
	  lw $t0, -404($fp)	# fill _tmp224 to $t0 from $fp-404
	  sw $t0, 4($sp)	# copy param value to stack
	# LCall _PrintString
	  jal _PrintString   	# jump to function
	# PopParams 4
	  add $sp, $sp, 4	# pop params off stack
	# LCall _Halt
	  jal _Halt          	# jump to function
  _L34:
	# _tmp225 = 4
	  li $t2, 4		# load constant value 4 into $t2
	  sw $t2, -408($fp)	# spill _tmp225 from $t2 to $fp-408
	# _tmp226 = index * _tmp225
	  lw $t0, -24($fp)	# fill index to $t0 from $fp-24
	  lw $t1, -408($fp)	# fill _tmp225 to $t1 from $fp-408
	  mul $t2, $t0, $t1	
	  sw $t2, -412($fp)	# spill _tmp226 from $t2 to $fp-412
	# _tmp227 = _tmp226 + _tmp225
	  lw $t0, -412($fp)	# fill _tmp226 to $t0 from $fp-412
	  lw $t1, -408($fp)	# fill _tmp225 to $t1 from $fp-408
	  add $t2, $t0, $t1	
	  sw $t2, -416($fp)	# spill _tmp227 from $t2 to $fp-416
	# _tmp228 = _tmp216 + _tmp227
	  lw $t0, -372($fp)	# fill _tmp216 to $t0 from $fp-372
	  lw $t1, -416($fp)	# fill _tmp227 to $t1 from $fp-416
	  add $t2, $t0, $t1	
	  sw $t2, -420($fp)	# spill _tmp228 from $t2 to $fp-420
	# _tmp229 = *(_tmp228)
	  lw $t0, -420($fp)	# fill _tmp228 to $t0 from $fp-420
	  lw $t2, 0($t0) 	# load with offset
	  sw $t2, -424($fp)	# spill _tmp229 from $t2 to $fp-424
	# PushParam _tmp229
	  subu $sp, $sp, 4	# decrement sp to make space for param
	  lw $t0, -424($fp)	# fill _tmp229 to $t0 from $fp-424
	  sw $t0, 4($sp)	# copy param value to stack
	# _tmp230 = *(_tmp229)
	  lw $t0, -424($fp)	# fill _tmp229 to $t0 from $fp-424
	  lw $t2, 0($t0) 	# load with offset
	  sw $t2, -428($fp)	# spill _tmp230 from $t2 to $fp-428
	# _tmp231 = *(_tmp230 + 12)
	  lw $t0, -428($fp)	# fill _tmp230 to $t0 from $fp-428
	  lw $t2, 12($t0) 	# load with offset
	  sw $t2, -432($fp)	# spill _tmp231 from $t2 to $fp-432
	# ACall _tmp231
	  lw $t0, -432($fp)	# fill _tmp231 to $t0 from $fp-432
	  jalr $t0            	# jump to function
	# PopParams 8
	  add $sp, $sp, 8	# pop params off stack
	# Goto _L31
	  b _L31		# unconditional branch
  _L30:
  _L31:
	# _tmp232 = "Old phone number: "
	  .data			# create string constant marked with label
	  _string42: .asciiz "Old phone number: "
	  .text
	  la $t2, _string42	# load label
	  sw $t2, -436($fp)	# spill _tmp232 from $t2 to $fp-436
	# PushParam _tmp232
	  subu $sp, $sp, 4	# decrement sp to make space for param
	  lw $t0, -436($fp)	# fill _tmp232 to $t0 from $fp-436
	  sw $t0, 4($sp)	# copy param value to stack
	# LCall _PrintString
	  jal _PrintString   	# jump to function
	# PopParams 4
	  add $sp, $sp, 4	# pop params off stack
	# _tmp233 = *(this + 12)
	  lw $t0, 4($fp)	# fill this to $t0 from $fp+4
	  lw $t2, 12($t0) 	# load with offset
	  sw $t2, -440($fp)	# spill _tmp233 from $t2 to $fp-440
	# _tmp234 = 0
	  li $t2, 0		# load constant value 0 into $t2
	  sw $t2, -444($fp)	# spill _tmp234 from $t2 to $fp-444
	# _tmp235 = *(_tmp233)
	  lw $t0, -440($fp)	# fill _tmp233 to $t0 from $fp-440
	  lw $t2, 0($t0) 	# load with offset
	  sw $t2, -448($fp)	# spill _tmp235 from $t2 to $fp-448
	# _tmp236 = index < _tmp234
	  lw $t0, -24($fp)	# fill index to $t0 from $fp-24
	  lw $t1, -444($fp)	# fill _tmp234 to $t1 from $fp-444
	  slt $t2, $t0, $t1	
	  sw $t2, -452($fp)	# spill _tmp236 from $t2 to $fp-452
	# _tmp237 = _tmp235 < index
	  lw $t0, -448($fp)	# fill _tmp235 to $t0 from $fp-448
	  lw $t1, -24($fp)	# fill index to $t1 from $fp-24
	  slt $t2, $t0, $t1	
	  sw $t2, -456($fp)	# spill _tmp237 from $t2 to $fp-456
	# _tmp238 = _tmp235 == index
	  lw $t0, -448($fp)	# fill _tmp235 to $t0 from $fp-448
	  lw $t1, -24($fp)	# fill index to $t1 from $fp-24
	  seq $t2, $t0, $t1	
	  sw $t2, -460($fp)	# spill _tmp238 from $t2 to $fp-460
	# _tmp239 = _tmp237 || _tmp238
	  lw $t0, -456($fp)	# fill _tmp237 to $t0 from $fp-456
	  lw $t1, -460($fp)	# fill _tmp238 to $t1 from $fp-460
	  or $t2, $t0, $t1	
	  sw $t2, -464($fp)	# spill _tmp239 from $t2 to $fp-464
	# _tmp240 = _tmp239 || _tmp236
	  lw $t0, -464($fp)	# fill _tmp239 to $t0 from $fp-464
	  lw $t1, -452($fp)	# fill _tmp236 to $t1 from $fp-452
	  or $t2, $t0, $t1	
	  sw $t2, -468($fp)	# spill _tmp240 from $t2 to $fp-468
	# IfZ _tmp240 Goto _L35
	  lw $t0, -468($fp)	# fill _tmp240 to $t0 from $fp-468
	  beqz $t0, _L35	# branch if _tmp240 is zero 
	# _tmp241 = "Decaf runtime error: Array subscript out of bound..."
	  .data			# create string constant marked with label
	  _string43: .asciiz "Decaf runtime error: Array subscript out of bounds\n"
	  .text
	  la $t2, _string43	# load label
	  sw $t2, -472($fp)	# spill _tmp241 from $t2 to $fp-472
	# PushParam _tmp241
	  subu $sp, $sp, 4	# decrement sp to make space for param
	  lw $t0, -472($fp)	# fill _tmp241 to $t0 from $fp-472
	  sw $t0, 4($sp)	# copy param value to stack
	# LCall _PrintString
	  jal _PrintString   	# jump to function
	# PopParams 4
	  add $sp, $sp, 4	# pop params off stack
	# LCall _Halt
	  jal _Halt          	# jump to function
  _L35:
	# _tmp242 = 4
	  li $t2, 4		# load constant value 4 into $t2
	  sw $t2, -476($fp)	# spill _tmp242 from $t2 to $fp-476
	# _tmp243 = index * _tmp242
	  lw $t0, -24($fp)	# fill index to $t0 from $fp-24
	  lw $t1, -476($fp)	# fill _tmp242 to $t1 from $fp-476
	  mul $t2, $t0, $t1	
	  sw $t2, -480($fp)	# spill _tmp243 from $t2 to $fp-480
	# _tmp244 = _tmp243 + _tmp242
	  lw $t0, -480($fp)	# fill _tmp243 to $t0 from $fp-480
	  lw $t1, -476($fp)	# fill _tmp242 to $t1 from $fp-476
	  add $t2, $t0, $t1	
	  sw $t2, -484($fp)	# spill _tmp244 from $t2 to $fp-484
	# _tmp245 = _tmp233 + _tmp244
	  lw $t0, -440($fp)	# fill _tmp233 to $t0 from $fp-440
	  lw $t1, -484($fp)	# fill _tmp244 to $t1 from $fp-484
	  add $t2, $t0, $t1	
	  sw $t2, -488($fp)	# spill _tmp245 from $t2 to $fp-488
	# _tmp246 = *(_tmp245)
	  lw $t0, -488($fp)	# fill _tmp245 to $t0 from $fp-488
	  lw $t2, 0($t0) 	# load with offset
	  sw $t2, -492($fp)	# spill _tmp246 from $t2 to $fp-492
	# PushParam _tmp246
	  subu $sp, $sp, 4	# decrement sp to make space for param
	  lw $t0, -492($fp)	# fill _tmp246 to $t0 from $fp-492
	  sw $t0, 4($sp)	# copy param value to stack
	# _tmp247 = *(_tmp246)
	  lw $t0, -492($fp)	# fill _tmp246 to $t0 from $fp-492
	  lw $t2, 0($t0) 	# load with offset
	  sw $t2, -496($fp)	# spill _tmp247 from $t2 to $fp-496
	# _tmp248 = *(_tmp247 + 24)
	  lw $t0, -496($fp)	# fill _tmp247 to $t0 from $fp-496
	  lw $t2, 24($t0) 	# load with offset
	  sw $t2, -500($fp)	# spill _tmp248 from $t2 to $fp-500
	# _tmp249 = ACall _tmp248
	  lw $t0, -500($fp)	# fill _tmp248 to $t0 from $fp-500
	  jalr $t0            	# jump to function
	  move $t2, $v0		# copy function return value from $v0
	  sw $t2, -504($fp)	# spill _tmp249 from $t2 to $fp-504
	# PopParams 4
	  add $sp, $sp, 4	# pop params off stack
	# PushParam _tmp249
	  subu $sp, $sp, 4	# decrement sp to make space for param
	  lw $t0, -504($fp)	# fill _tmp249 to $t0 from $fp-504
	  sw $t0, 4($sp)	# copy param value to stack
	# LCall _PrintString
	  jal _PrintString   	# jump to function
	# PopParams 4
	  add $sp, $sp, 4	# pop params off stack
	# _tmp250 = "\n"
	  .data			# create string constant marked with label
	  _string44: .asciiz "\n"
	  .text
	  la $t2, _string44	# load label
	  sw $t2, -508($fp)	# spill _tmp250 from $t2 to $fp-508
	# PushParam _tmp250
	  subu $sp, $sp, 4	# decrement sp to make space for param
	  lw $t0, -508($fp)	# fill _tmp250 to $t0 from $fp-508
	  sw $t0, 4($sp)	# copy param value to stack
	# LCall _PrintString
	  jal _PrintString   	# jump to function
	# PopParams 4
	  add $sp, $sp, 4	# pop params off stack
	# _tmp251 = "Enter new first name (or nothing to leave unchang..."
	  .data			# create string constant marked with label
	  _string45: .asciiz "Enter new first name (or nothing to leave unchanged): "
	  .text
	  la $t2, _string45	# load label
	  sw $t2, -512($fp)	# spill _tmp251 from $t2 to $fp-512
	# PushParam _tmp251
	  subu $sp, $sp, 4	# decrement sp to make space for param
	  lw $t0, -512($fp)	# fill _tmp251 to $t0 from $fp-512
	  sw $t0, 4($sp)	# copy param value to stack
	# LCall _PrintString
	  jal _PrintString   	# jump to function
	# PopParams 4
	  add $sp, $sp, 4	# pop params off stack
	# _tmp252 = LCall _ReadLine
	  jal _ReadLine      	# jump to function
	  move $t2, $v0		# copy function return value from $v0
	  sw $t2, -516($fp)	# spill _tmp252 from $t2 to $fp-516
	# p = _tmp252
	  lw $t2, -516($fp)	# fill _tmp252 to $t2 from $fp-516
	  sw $t2, -16($fp)	# spill p from $t2 to $fp-16
	# _tmp254 = ""
	  .data			# create string constant marked with label
	  _string46: .asciiz ""
	  .text
	  la $t2, _string46	# load label
	  sw $t2, -524($fp)	# spill _tmp254 from $t2 to $fp-524
	# PushParam _tmp254
	  subu $sp, $sp, 4	# decrement sp to make space for param
	  lw $t0, -524($fp)	# fill _tmp254 to $t0 from $fp-524
	  sw $t0, 4($sp)	# copy param value to stack
	# PushParam p
	  subu $sp, $sp, 4	# decrement sp to make space for param
	  lw $t0, -16($fp)	# fill p to $t0 from $fp-16
	  sw $t0, 4($sp)	# copy param value to stack
	# _tmp255 = LCall _StringEqual
	  jal _StringEqual   	# jump to function
	  move $t2, $v0		# copy function return value from $v0
	  sw $t2, -528($fp)	# spill _tmp255 from $t2 to $fp-528
	# PopParams 8
	  add $sp, $sp, 8	# pop params off stack
	# IfZ _tmp255 Goto _L39
	  lw $t0, -528($fp)	# fill _tmp255 to $t0 from $fp-528
	  beqz $t0, _L39	# branch if _tmp255 is zero 
	# _tmp256 = 0
	  li $t2, 0		# load constant value 0 into $t2
	  sw $t2, -532($fp)	# spill _tmp256 from $t2 to $fp-532
	# _tmp253 = _tmp256
	  lw $t2, -532($fp)	# fill _tmp256 to $t2 from $fp-532
	  sw $t2, -520($fp)	# spill _tmp253 from $t2 to $fp-520
	# Goto _L38
	  b _L38		# unconditional branch
  _L39:
	# _tmp257 = 1
	  li $t2, 1		# load constant value 1 into $t2
	  sw $t2, -536($fp)	# spill _tmp257 from $t2 to $fp-536
	# _tmp253 = _tmp257
	  lw $t2, -536($fp)	# fill _tmp257 to $t2 from $fp-536
	  sw $t2, -520($fp)	# spill _tmp253 from $t2 to $fp-520
  _L38:
	# IfZ _tmp253 Goto _L36
	  lw $t0, -520($fp)	# fill _tmp253 to $t0 from $fp-520
	  beqz $t0, _L36	# branch if _tmp253 is zero 
	# PushParam p
	  subu $sp, $sp, 4	# decrement sp to make space for param
	  lw $t0, -16($fp)	# fill p to $t0 from $fp-16
	  sw $t0, 4($sp)	# copy param value to stack
	# _tmp258 = *(this + 12)
	  lw $t0, 4($fp)	# fill this to $t0 from $fp+4
	  lw $t2, 12($t0) 	# load with offset
	  sw $t2, -540($fp)	# spill _tmp258 from $t2 to $fp-540
	# _tmp259 = 0
	  li $t2, 0		# load constant value 0 into $t2
	  sw $t2, -544($fp)	# spill _tmp259 from $t2 to $fp-544
	# _tmp260 = *(_tmp258)
	  lw $t0, -540($fp)	# fill _tmp258 to $t0 from $fp-540
	  lw $t2, 0($t0) 	# load with offset
	  sw $t2, -548($fp)	# spill _tmp260 from $t2 to $fp-548
	# _tmp261 = index < _tmp259
	  lw $t0, -24($fp)	# fill index to $t0 from $fp-24
	  lw $t1, -544($fp)	# fill _tmp259 to $t1 from $fp-544
	  slt $t2, $t0, $t1	
	  sw $t2, -552($fp)	# spill _tmp261 from $t2 to $fp-552
	# _tmp262 = _tmp260 < index
	  lw $t0, -548($fp)	# fill _tmp260 to $t0 from $fp-548
	  lw $t1, -24($fp)	# fill index to $t1 from $fp-24
	  slt $t2, $t0, $t1	
	  sw $t2, -556($fp)	# spill _tmp262 from $t2 to $fp-556
	# _tmp263 = _tmp260 == index
	  lw $t0, -548($fp)	# fill _tmp260 to $t0 from $fp-548
	  lw $t1, -24($fp)	# fill index to $t1 from $fp-24
	  seq $t2, $t0, $t1	
	  sw $t2, -560($fp)	# spill _tmp263 from $t2 to $fp-560
	# _tmp264 = _tmp262 || _tmp263
	  lw $t0, -556($fp)	# fill _tmp262 to $t0 from $fp-556
	  lw $t1, -560($fp)	# fill _tmp263 to $t1 from $fp-560
	  or $t2, $t0, $t1	
	  sw $t2, -564($fp)	# spill _tmp264 from $t2 to $fp-564
	# _tmp265 = _tmp264 || _tmp261
	  lw $t0, -564($fp)	# fill _tmp264 to $t0 from $fp-564
	  lw $t1, -552($fp)	# fill _tmp261 to $t1 from $fp-552
	  or $t2, $t0, $t1	
	  sw $t2, -568($fp)	# spill _tmp265 from $t2 to $fp-568
	# IfZ _tmp265 Goto _L40
	  lw $t0, -568($fp)	# fill _tmp265 to $t0 from $fp-568
	  beqz $t0, _L40	# branch if _tmp265 is zero 
	# _tmp266 = "Decaf runtime error: Array subscript out of bound..."
	  .data			# create string constant marked with label
	  _string47: .asciiz "Decaf runtime error: Array subscript out of bounds\n"
	  .text
	  la $t2, _string47	# load label
	  sw $t2, -572($fp)	# spill _tmp266 from $t2 to $fp-572
	# PushParam _tmp266
	  subu $sp, $sp, 4	# decrement sp to make space for param
	  lw $t0, -572($fp)	# fill _tmp266 to $t0 from $fp-572
	  sw $t0, 4($sp)	# copy param value to stack
	# LCall _PrintString
	  jal _PrintString   	# jump to function
	# PopParams 4
	  add $sp, $sp, 4	# pop params off stack
	# LCall _Halt
	  jal _Halt          	# jump to function
  _L40:
	# _tmp267 = 4
	  li $t2, 4		# load constant value 4 into $t2
	  sw $t2, -576($fp)	# spill _tmp267 from $t2 to $fp-576
	# _tmp268 = index * _tmp267
	  lw $t0, -24($fp)	# fill index to $t0 from $fp-24
	  lw $t1, -576($fp)	# fill _tmp267 to $t1 from $fp-576
	  mul $t2, $t0, $t1	
	  sw $t2, -580($fp)	# spill _tmp268 from $t2 to $fp-580
	# _tmp269 = _tmp268 + _tmp267
	  lw $t0, -580($fp)	# fill _tmp268 to $t0 from $fp-580
	  lw $t1, -576($fp)	# fill _tmp267 to $t1 from $fp-576
	  add $t2, $t0, $t1	
	  sw $t2, -584($fp)	# spill _tmp269 from $t2 to $fp-584
	# _tmp270 = _tmp258 + _tmp269
	  lw $t0, -540($fp)	# fill _tmp258 to $t0 from $fp-540
	  lw $t1, -584($fp)	# fill _tmp269 to $t1 from $fp-584
	  add $t2, $t0, $t1	
	  sw $t2, -588($fp)	# spill _tmp270 from $t2 to $fp-588
	# _tmp271 = *(_tmp270)
	  lw $t0, -588($fp)	# fill _tmp270 to $t0 from $fp-588
	  lw $t2, 0($t0) 	# load with offset
	  sw $t2, -592($fp)	# spill _tmp271 from $t2 to $fp-592
	# PushParam _tmp271
	  subu $sp, $sp, 4	# decrement sp to make space for param
	  lw $t0, -592($fp)	# fill _tmp271 to $t0 from $fp-592
	  sw $t0, 4($sp)	# copy param value to stack
	# _tmp272 = *(_tmp271)
	  lw $t0, -592($fp)	# fill _tmp271 to $t0 from $fp-592
	  lw $t2, 0($t0) 	# load with offset
	  sw $t2, -596($fp)	# spill _tmp272 from $t2 to $fp-596
	# _tmp273 = *(_tmp272 + 20)
	  lw $t0, -596($fp)	# fill _tmp272 to $t0 from $fp-596
	  lw $t2, 20($t0) 	# load with offset
	  sw $t2, -600($fp)	# spill _tmp273 from $t2 to $fp-600
	# ACall _tmp273
	  lw $t0, -600($fp)	# fill _tmp273 to $t0 from $fp-600
	  jalr $t0            	# jump to function
	# PopParams 8
	  add $sp, $sp, 8	# pop params off stack
	# Goto _L37
	  b _L37		# unconditional branch
  _L36:
  _L37:
	# _tmp274 = "Old first name: "
	  .data			# create string constant marked with label
	  _string48: .asciiz "Old first name: "
	  .text
	  la $t2, _string48	# load label
	  sw $t2, -604($fp)	# spill _tmp274 from $t2 to $fp-604
	# PushParam _tmp274
	  subu $sp, $sp, 4	# decrement sp to make space for param
	  lw $t0, -604($fp)	# fill _tmp274 to $t0 from $fp-604
	  sw $t0, 4($sp)	# copy param value to stack
	# LCall _PrintString
	  jal _PrintString   	# jump to function
	# PopParams 4
	  add $sp, $sp, 4	# pop params off stack
	# _tmp275 = *(this + 12)
	  lw $t0, 4($fp)	# fill this to $t0 from $fp+4
	  lw $t2, 12($t0) 	# load with offset
	  sw $t2, -608($fp)	# spill _tmp275 from $t2 to $fp-608
	# _tmp276 = 0
	  li $t2, 0		# load constant value 0 into $t2
	  sw $t2, -612($fp)	# spill _tmp276 from $t2 to $fp-612
	# _tmp277 = *(_tmp275)
	  lw $t0, -608($fp)	# fill _tmp275 to $t0 from $fp-608
	  lw $t2, 0($t0) 	# load with offset
	  sw $t2, -616($fp)	# spill _tmp277 from $t2 to $fp-616
	# _tmp278 = index < _tmp276
	  lw $t0, -24($fp)	# fill index to $t0 from $fp-24
	  lw $t1, -612($fp)	# fill _tmp276 to $t1 from $fp-612
	  slt $t2, $t0, $t1	
	  sw $t2, -620($fp)	# spill _tmp278 from $t2 to $fp-620
	# _tmp279 = _tmp277 < index
	  lw $t0, -616($fp)	# fill _tmp277 to $t0 from $fp-616
	  lw $t1, -24($fp)	# fill index to $t1 from $fp-24
	  slt $t2, $t0, $t1	
	  sw $t2, -624($fp)	# spill _tmp279 from $t2 to $fp-624
	# _tmp280 = _tmp277 == index
	  lw $t0, -616($fp)	# fill _tmp277 to $t0 from $fp-616
	  lw $t1, -24($fp)	# fill index to $t1 from $fp-24
	  seq $t2, $t0, $t1	
	  sw $t2, -628($fp)	# spill _tmp280 from $t2 to $fp-628
	# _tmp281 = _tmp279 || _tmp280
	  lw $t0, -624($fp)	# fill _tmp279 to $t0 from $fp-624
	  lw $t1, -628($fp)	# fill _tmp280 to $t1 from $fp-628
	  or $t2, $t0, $t1	
	  sw $t2, -632($fp)	# spill _tmp281 from $t2 to $fp-632
	# _tmp282 = _tmp281 || _tmp278
	  lw $t0, -632($fp)	# fill _tmp281 to $t0 from $fp-632
	  lw $t1, -620($fp)	# fill _tmp278 to $t1 from $fp-620
	  or $t2, $t0, $t1	
	  sw $t2, -636($fp)	# spill _tmp282 from $t2 to $fp-636
	# IfZ _tmp282 Goto _L41
	  lw $t0, -636($fp)	# fill _tmp282 to $t0 from $fp-636
	  beqz $t0, _L41	# branch if _tmp282 is zero 
	# _tmp283 = "Decaf runtime error: Array subscript out of bound..."
	  .data			# create string constant marked with label
	  _string49: .asciiz "Decaf runtime error: Array subscript out of bounds\n"
	  .text
	  la $t2, _string49	# load label
	  sw $t2, -640($fp)	# spill _tmp283 from $t2 to $fp-640
	# PushParam _tmp283
	  subu $sp, $sp, 4	# decrement sp to make space for param
	  lw $t0, -640($fp)	# fill _tmp283 to $t0 from $fp-640
	  sw $t0, 4($sp)	# copy param value to stack
	# LCall _PrintString
	  jal _PrintString   	# jump to function
	# PopParams 4
	  add $sp, $sp, 4	# pop params off stack
	# LCall _Halt
	  jal _Halt          	# jump to function
  _L41:
	# _tmp284 = 4
	  li $t2, 4		# load constant value 4 into $t2
	  sw $t2, -644($fp)	# spill _tmp284 from $t2 to $fp-644
	# _tmp285 = index * _tmp284
	  lw $t0, -24($fp)	# fill index to $t0 from $fp-24
	  lw $t1, -644($fp)	# fill _tmp284 to $t1 from $fp-644
	  mul $t2, $t0, $t1	
	  sw $t2, -648($fp)	# spill _tmp285 from $t2 to $fp-648
	# _tmp286 = _tmp285 + _tmp284
	  lw $t0, -648($fp)	# fill _tmp285 to $t0 from $fp-648
	  lw $t1, -644($fp)	# fill _tmp284 to $t1 from $fp-644
	  add $t2, $t0, $t1	
	  sw $t2, -652($fp)	# spill _tmp286 from $t2 to $fp-652
	# _tmp287 = _tmp275 + _tmp286
	  lw $t0, -608($fp)	# fill _tmp275 to $t0 from $fp-608
	  lw $t1, -652($fp)	# fill _tmp286 to $t1 from $fp-652
	  add $t2, $t0, $t1	
	  sw $t2, -656($fp)	# spill _tmp287 from $t2 to $fp-656
	# _tmp288 = *(_tmp287)
	  lw $t0, -656($fp)	# fill _tmp287 to $t0 from $fp-656
	  lw $t2, 0($t0) 	# load with offset
	  sw $t2, -660($fp)	# spill _tmp288 from $t2 to $fp-660
	# PushParam _tmp288
	  subu $sp, $sp, 4	# decrement sp to make space for param
	  lw $t0, -660($fp)	# fill _tmp288 to $t0 from $fp-660
	  sw $t0, 4($sp)	# copy param value to stack
	# _tmp289 = *(_tmp288)
	  lw $t0, -660($fp)	# fill _tmp288 to $t0 from $fp-660
	  lw $t2, 0($t0) 	# load with offset
	  sw $t2, -664($fp)	# spill _tmp289 from $t2 to $fp-664
	# _tmp290 = *(_tmp289 + 32)
	  lw $t0, -664($fp)	# fill _tmp289 to $t0 from $fp-664
	  lw $t2, 32($t0) 	# load with offset
	  sw $t2, -668($fp)	# spill _tmp290 from $t2 to $fp-668
	# _tmp291 = ACall _tmp290
	  lw $t0, -668($fp)	# fill _tmp290 to $t0 from $fp-668
	  jalr $t0            	# jump to function
	  move $t2, $v0		# copy function return value from $v0
	  sw $t2, -672($fp)	# spill _tmp291 from $t2 to $fp-672
	# PopParams 4
	  add $sp, $sp, 4	# pop params off stack
	# PushParam _tmp291
	  subu $sp, $sp, 4	# decrement sp to make space for param
	  lw $t0, -672($fp)	# fill _tmp291 to $t0 from $fp-672
	  sw $t0, 4($sp)	# copy param value to stack
	# LCall _PrintString
	  jal _PrintString   	# jump to function
	# PopParams 4
	  add $sp, $sp, 4	# pop params off stack
	# _tmp292 = "\n"
	  .data			# create string constant marked with label
	  _string50: .asciiz "\n"
	  .text
	  la $t2, _string50	# load label
	  sw $t2, -676($fp)	# spill _tmp292 from $t2 to $fp-676
	# PushParam _tmp292
	  subu $sp, $sp, 4	# decrement sp to make space for param
	  lw $t0, -676($fp)	# fill _tmp292 to $t0 from $fp-676
	  sw $t0, 4($sp)	# copy param value to stack
	# LCall _PrintString
	  jal _PrintString   	# jump to function
	# PopParams 4
	  add $sp, $sp, 4	# pop params off stack
	# _tmp293 = "Enter new address (or nothing to leave unchanged)..."
	  .data			# create string constant marked with label
	  _string51: .asciiz "Enter new address (or nothing to leave unchanged): "
	  .text
	  la $t2, _string51	# load label
	  sw $t2, -680($fp)	# spill _tmp293 from $t2 to $fp-680
	# PushParam _tmp293
	  subu $sp, $sp, 4	# decrement sp to make space for param
	  lw $t0, -680($fp)	# fill _tmp293 to $t0 from $fp-680
	  sw $t0, 4($sp)	# copy param value to stack
	# LCall _PrintString
	  jal _PrintString   	# jump to function
	# PopParams 4
	  add $sp, $sp, 4	# pop params off stack
	# _tmp294 = LCall _ReadLine
	  jal _ReadLine      	# jump to function
	  move $t2, $v0		# copy function return value from $v0
	  sw $t2, -684($fp)	# spill _tmp294 from $t2 to $fp-684
	# a = _tmp294
	  lw $t2, -684($fp)	# fill _tmp294 to $t2 from $fp-684
	  sw $t2, -20($fp)	# spill a from $t2 to $fp-20
	# _tmp296 = ""
	  .data			# create string constant marked with label
	  _string52: .asciiz ""
	  .text
	  la $t2, _string52	# load label
	  sw $t2, -692($fp)	# spill _tmp296 from $t2 to $fp-692
	# PushParam _tmp296
	  subu $sp, $sp, 4	# decrement sp to make space for param
	  lw $t0, -692($fp)	# fill _tmp296 to $t0 from $fp-692
	  sw $t0, 4($sp)	# copy param value to stack
	# PushParam a
	  subu $sp, $sp, 4	# decrement sp to make space for param
	  lw $t0, -20($fp)	# fill a to $t0 from $fp-20
	  sw $t0, 4($sp)	# copy param value to stack
	# _tmp297 = LCall _StringEqual
	  jal _StringEqual   	# jump to function
	  move $t2, $v0		# copy function return value from $v0
	  sw $t2, -696($fp)	# spill _tmp297 from $t2 to $fp-696
	# PopParams 8
	  add $sp, $sp, 8	# pop params off stack
	# IfZ _tmp297 Goto _L45
	  lw $t0, -696($fp)	# fill _tmp297 to $t0 from $fp-696
	  beqz $t0, _L45	# branch if _tmp297 is zero 
	# _tmp298 = 0
	  li $t2, 0		# load constant value 0 into $t2
	  sw $t2, -700($fp)	# spill _tmp298 from $t2 to $fp-700
	# _tmp295 = _tmp298
	  lw $t2, -700($fp)	# fill _tmp298 to $t2 from $fp-700
	  sw $t2, -688($fp)	# spill _tmp295 from $t2 to $fp-688
	# Goto _L44
	  b _L44		# unconditional branch
  _L45:
	# _tmp299 = 1
	  li $t2, 1		# load constant value 1 into $t2
	  sw $t2, -704($fp)	# spill _tmp299 from $t2 to $fp-704
	# _tmp295 = _tmp299
	  lw $t2, -704($fp)	# fill _tmp299 to $t2 from $fp-704
	  sw $t2, -688($fp)	# spill _tmp295 from $t2 to $fp-688
  _L44:
	# IfZ _tmp295 Goto _L42
	  lw $t0, -688($fp)	# fill _tmp295 to $t0 from $fp-688
	  beqz $t0, _L42	# branch if _tmp295 is zero 
	# PushParam a
	  subu $sp, $sp, 4	# decrement sp to make space for param
	  lw $t0, -20($fp)	# fill a to $t0 from $fp-20
	  sw $t0, 4($sp)	# copy param value to stack
	# _tmp300 = *(this + 12)
	  lw $t0, 4($fp)	# fill this to $t0 from $fp+4
	  lw $t2, 12($t0) 	# load with offset
	  sw $t2, -708($fp)	# spill _tmp300 from $t2 to $fp-708
	# _tmp301 = 0
	  li $t2, 0		# load constant value 0 into $t2
	  sw $t2, -712($fp)	# spill _tmp301 from $t2 to $fp-712
	# _tmp302 = *(_tmp300)
	  lw $t0, -708($fp)	# fill _tmp300 to $t0 from $fp-708
	  lw $t2, 0($t0) 	# load with offset
	  sw $t2, -716($fp)	# spill _tmp302 from $t2 to $fp-716
	# _tmp303 = index < _tmp301
	  lw $t0, -24($fp)	# fill index to $t0 from $fp-24
	  lw $t1, -712($fp)	# fill _tmp301 to $t1 from $fp-712
	  slt $t2, $t0, $t1	
	  sw $t2, -720($fp)	# spill _tmp303 from $t2 to $fp-720
	# _tmp304 = _tmp302 < index
	  lw $t0, -716($fp)	# fill _tmp302 to $t0 from $fp-716
	  lw $t1, -24($fp)	# fill index to $t1 from $fp-24
	  slt $t2, $t0, $t1	
	  sw $t2, -724($fp)	# spill _tmp304 from $t2 to $fp-724
	# _tmp305 = _tmp302 == index
	  lw $t0, -716($fp)	# fill _tmp302 to $t0 from $fp-716
	  lw $t1, -24($fp)	# fill index to $t1 from $fp-24
	  seq $t2, $t0, $t1	
	  sw $t2, -728($fp)	# spill _tmp305 from $t2 to $fp-728
	# _tmp306 = _tmp304 || _tmp305
	  lw $t0, -724($fp)	# fill _tmp304 to $t0 from $fp-724
	  lw $t1, -728($fp)	# fill _tmp305 to $t1 from $fp-728
	  or $t2, $t0, $t1	
	  sw $t2, -732($fp)	# spill _tmp306 from $t2 to $fp-732
	# _tmp307 = _tmp306 || _tmp303
	  lw $t0, -732($fp)	# fill _tmp306 to $t0 from $fp-732
	  lw $t1, -720($fp)	# fill _tmp303 to $t1 from $fp-720
	  or $t2, $t0, $t1	
	  sw $t2, -736($fp)	# spill _tmp307 from $t2 to $fp-736
	# IfZ _tmp307 Goto _L46
	  lw $t0, -736($fp)	# fill _tmp307 to $t0 from $fp-736
	  beqz $t0, _L46	# branch if _tmp307 is zero 
	# _tmp308 = "Decaf runtime error: Array subscript out of bound..."
	  .data			# create string constant marked with label
	  _string53: .asciiz "Decaf runtime error: Array subscript out of bounds\n"
	  .text
	  la $t2, _string53	# load label
	  sw $t2, -740($fp)	# spill _tmp308 from $t2 to $fp-740
	# PushParam _tmp308
	  subu $sp, $sp, 4	# decrement sp to make space for param
	  lw $t0, -740($fp)	# fill _tmp308 to $t0 from $fp-740
	  sw $t0, 4($sp)	# copy param value to stack
	# LCall _PrintString
	  jal _PrintString   	# jump to function
	# PopParams 4
	  add $sp, $sp, 4	# pop params off stack
	# LCall _Halt
	  jal _Halt          	# jump to function
  _L46:
	# _tmp309 = 4
	  li $t2, 4		# load constant value 4 into $t2
	  sw $t2, -744($fp)	# spill _tmp309 from $t2 to $fp-744
	# _tmp310 = index * _tmp309
	  lw $t0, -24($fp)	# fill index to $t0 from $fp-24
	  lw $t1, -744($fp)	# fill _tmp309 to $t1 from $fp-744
	  mul $t2, $t0, $t1	
	  sw $t2, -748($fp)	# spill _tmp310 from $t2 to $fp-748
	# _tmp311 = _tmp310 + _tmp309
	  lw $t0, -748($fp)	# fill _tmp310 to $t0 from $fp-748
	  lw $t1, -744($fp)	# fill _tmp309 to $t1 from $fp-744
	  add $t2, $t0, $t1	
	  sw $t2, -752($fp)	# spill _tmp311 from $t2 to $fp-752
	# _tmp312 = _tmp300 + _tmp311
	  lw $t0, -708($fp)	# fill _tmp300 to $t0 from $fp-708
	  lw $t1, -752($fp)	# fill _tmp311 to $t1 from $fp-752
	  add $t2, $t0, $t1	
	  sw $t2, -756($fp)	# spill _tmp312 from $t2 to $fp-756
	# _tmp313 = *(_tmp312)
	  lw $t0, -756($fp)	# fill _tmp312 to $t0 from $fp-756
	  lw $t2, 0($t0) 	# load with offset
	  sw $t2, -760($fp)	# spill _tmp313 from $t2 to $fp-760
	# PushParam _tmp313
	  subu $sp, $sp, 4	# decrement sp to make space for param
	  lw $t0, -760($fp)	# fill _tmp313 to $t0 from $fp-760
	  sw $t0, 4($sp)	# copy param value to stack
	# _tmp314 = *(_tmp313)
	  lw $t0, -760($fp)	# fill _tmp313 to $t0 from $fp-760
	  lw $t2, 0($t0) 	# load with offset
	  sw $t2, -764($fp)	# spill _tmp314 from $t2 to $fp-764
	# _tmp315 = *(_tmp314 + 28)
	  lw $t0, -764($fp)	# fill _tmp314 to $t0 from $fp-764
	  lw $t2, 28($t0) 	# load with offset
	  sw $t2, -768($fp)	# spill _tmp315 from $t2 to $fp-768
	# ACall _tmp315
	  lw $t0, -768($fp)	# fill _tmp315 to $t0 from $fp-768
	  jalr $t0            	# jump to function
	# PopParams 8
	  add $sp, $sp, 8	# pop params off stack
	# Goto _L43
	  b _L43		# unconditional branch
  _L42:
  _L43:
	# _tmp316 = "\nChanges successfully saved!\n"
	  .data			# create string constant marked with label
	  _string54: .asciiz "\nChanges successfully saved!\n"
	  .text
	  la $t2, _string54	# load label
	  sw $t2, -772($fp)	# spill _tmp316 from $t2 to $fp-772
	# PushParam _tmp316
	  subu $sp, $sp, 4	# decrement sp to make space for param
	  lw $t0, -772($fp)	# fill _tmp316 to $t0 from $fp-772
	  sw $t0, 4($sp)	# copy param value to stack
	# LCall _PrintString
	  jal _PrintString   	# jump to function
	# PopParams 4
	  add $sp, $sp, 4	# pop params off stack
	# LCall ____PrintLine
	  jal ____PrintLine  	# jump to function
	# EndFunc
	# (below handles reaching end of fn body with no explicit return)
	  move $sp, $fp		# pop callee frame off stack
	  lw $ra, -4($fp)	# restore saved ra
	  lw $fp, 0($fp)	# restore saved fp
	  jr $ra		# return from function
  Database.____Add:
	# BeginFunc 536
	  subu $sp, $sp, 8	# decrement sp to make space to save ra, fp
	  sw $fp, 8($sp)	# save fp
	  sw $ra, 4($sp)	# save ra
	  addiu $fp, $sp, 8	# set up new fp
	  subu $sp, $sp, 536	# decrement sp to make space for locals/temps
	# LCall ____PrintLine
	  jal ____PrintLine  	# jump to function
	# _tmp317 = "Adding New Person...\n\n"
	  .data			# create string constant marked with label
	  _string55: .asciiz "Adding New Person...\n\n"
	  .text
	  la $t2, _string55	# load label
	  sw $t2, -24($fp)	# spill _tmp317 from $t2 to $fp-24
	# PushParam _tmp317
	  subu $sp, $sp, 4	# decrement sp to make space for param
	  lw $t0, -24($fp)	# fill _tmp317 to $t0 from $fp-24
	  sw $t0, 4($sp)	# copy param value to stack
	# LCall _PrintString
	  jal _PrintString   	# jump to function
	# PopParams 4
	  add $sp, $sp, 4	# pop params off stack
	# _tmp318 = "Enter first name: "
	  .data			# create string constant marked with label
	  _string56: .asciiz "Enter first name: "
	  .text
	  la $t2, _string56	# load label
	  sw $t2, -28($fp)	# spill _tmp318 from $t2 to $fp-28
	# PushParam _tmp318
	  subu $sp, $sp, 4	# decrement sp to make space for param
	  lw $t0, -28($fp)	# fill _tmp318 to $t0 from $fp-28
	  sw $t0, 4($sp)	# copy param value to stack
	# LCall _PrintString
	  jal _PrintString   	# jump to function
	# PopParams 4
	  add $sp, $sp, 4	# pop params off stack
	# _tmp319 = LCall _ReadLine
	  jal _ReadLine      	# jump to function
	  move $t2, $v0		# copy function return value from $v0
	  sw $t2, -32($fp)	# spill _tmp319 from $t2 to $fp-32
	# f = _tmp319
	  lw $t2, -32($fp)	# fill _tmp319 to $t2 from $fp-32
	  sw $t2, -8($fp)	# spill f from $t2 to $fp-8
	# _tmp320 = "Enter last name: "
	  .data			# create string constant marked with label
	  _string57: .asciiz "Enter last name: "
	  .text
	  la $t2, _string57	# load label
	  sw $t2, -36($fp)	# spill _tmp320 from $t2 to $fp-36
	# PushParam _tmp320
	  subu $sp, $sp, 4	# decrement sp to make space for param
	  lw $t0, -36($fp)	# fill _tmp320 to $t0 from $fp-36
	  sw $t0, 4($sp)	# copy param value to stack
	# LCall _PrintString
	  jal _PrintString   	# jump to function
	# PopParams 4
	  add $sp, $sp, 4	# pop params off stack
	# _tmp321 = LCall _ReadLine
	  jal _ReadLine      	# jump to function
	  move $t2, $v0		# copy function return value from $v0
	  sw $t2, -40($fp)	# spill _tmp321 from $t2 to $fp-40
	# l = _tmp321
	  lw $t2, -40($fp)	# fill _tmp321 to $t2 from $fp-40
	  sw $t2, -12($fp)	# spill l from $t2 to $fp-12
	# _tmp322 = 0
	  li $t2, 0		# load constant value 0 into $t2
	  sw $t2, -44($fp)	# spill _tmp322 from $t2 to $fp-44
	# PushParam l
	  subu $sp, $sp, 4	# decrement sp to make space for param
	  lw $t0, -12($fp)	# fill l to $t0 from $fp-12
	  sw $t0, 4($sp)	# copy param value to stack
	# PushParam f
	  subu $sp, $sp, 4	# decrement sp to make space for param
	  lw $t0, -8($fp)	# fill f to $t0 from $fp-8
	  sw $t0, 4($sp)	# copy param value to stack
	# PushParam this
	  subu $sp, $sp, 4	# decrement sp to make space for param
	  lw $t0, 4($fp)	# fill this to $t0 from $fp+4
	  sw $t0, 4($sp)	# copy param value to stack
	# _tmp323 = *(this)
	  lw $t0, 4($fp)	# fill this to $t0 from $fp+4
	  lw $t2, 0($t0) 	# load with offset
	  sw $t2, -48($fp)	# spill _tmp323 from $t2 to $fp-48
	# _tmp324 = *(_tmp323 + 8)
	  lw $t0, -48($fp)	# fill _tmp323 to $t0 from $fp-48
	  lw $t2, 8($t0) 	# load with offset
	  sw $t2, -52($fp)	# spill _tmp324 from $t2 to $fp-52
	# _tmp325 = ACall _tmp324
	  lw $t0, -52($fp)	# fill _tmp324 to $t0 from $fp-52
	  jalr $t0            	# jump to function
	  move $t2, $v0		# copy function return value from $v0
	  sw $t2, -56($fp)	# spill _tmp325 from $t2 to $fp-56
	# PopParams 12
	  add $sp, $sp, 12	# pop params off stack
	# _tmp326 = _tmp322 < _tmp325
	  lw $t0, -44($fp)	# fill _tmp322 to $t0 from $fp-44
	  lw $t1, -56($fp)	# fill _tmp325 to $t1 from $fp-56
	  slt $t2, $t0, $t1	
	  sw $t2, -60($fp)	# spill _tmp326 from $t2 to $fp-60
	# _tmp327 = _tmp322 == _tmp325
	  lw $t0, -44($fp)	# fill _tmp322 to $t0 from $fp-44
	  lw $t1, -56($fp)	# fill _tmp325 to $t1 from $fp-56
	  seq $t2, $t0, $t1	
	  sw $t2, -64($fp)	# spill _tmp327 from $t2 to $fp-64
	# _tmp328 = _tmp326 || _tmp327
	  lw $t0, -60($fp)	# fill _tmp326 to $t0 from $fp-60
	  lw $t1, -64($fp)	# fill _tmp327 to $t1 from $fp-64
	  or $t2, $t0, $t1	
	  sw $t2, -68($fp)	# spill _tmp328 from $t2 to $fp-68
	# IfZ _tmp328 Goto _L47
	  lw $t0, -68($fp)	# fill _tmp328 to $t0 from $fp-68
	  beqz $t0, _L47	# branch if _tmp328 is zero 
	# _tmp329 = "\n"
	  .data			# create string constant marked with label
	  _string58: .asciiz "\n"
	  .text
	  la $t2, _string58	# load label
	  sw $t2, -72($fp)	# spill _tmp329 from $t2 to $fp-72
	# PushParam _tmp329
	  subu $sp, $sp, 4	# decrement sp to make space for param
	  lw $t0, -72($fp)	# fill _tmp329 to $t0 from $fp-72
	  sw $t0, 4($sp)	# copy param value to stack
	# LCall _PrintString
	  jal _PrintString   	# jump to function
	# PopParams 4
	  add $sp, $sp, 4	# pop params off stack
	# PushParam l
	  subu $sp, $sp, 4	# decrement sp to make space for param
	  lw $t0, -12($fp)	# fill l to $t0 from $fp-12
	  sw $t0, 4($sp)	# copy param value to stack
	# LCall _PrintString
	  jal _PrintString   	# jump to function
	# PopParams 4
	  add $sp, $sp, 4	# pop params off stack
	# _tmp330 = ", "
	  .data			# create string constant marked with label
	  _string59: .asciiz ", "
	  .text
	  la $t2, _string59	# load label
	  sw $t2, -76($fp)	# spill _tmp330 from $t2 to $fp-76
	# PushParam _tmp330
	  subu $sp, $sp, 4	# decrement sp to make space for param
	  lw $t0, -76($fp)	# fill _tmp330 to $t0 from $fp-76
	  sw $t0, 4($sp)	# copy param value to stack
	# LCall _PrintString
	  jal _PrintString   	# jump to function
	# PopParams 4
	  add $sp, $sp, 4	# pop params off stack
	# PushParam f
	  subu $sp, $sp, 4	# decrement sp to make space for param
	  lw $t0, -8($fp)	# fill f to $t0 from $fp-8
	  sw $t0, 4($sp)	# copy param value to stack
	# LCall _PrintString
	  jal _PrintString   	# jump to function
	# PopParams 4
	  add $sp, $sp, 4	# pop params off stack
	# _tmp331 = " already exists in the db!\n"
	  .data			# create string constant marked with label
	  _string60: .asciiz " already exists in the db!\n"
	  .text
	  la $t2, _string60	# load label
	  sw $t2, -80($fp)	# spill _tmp331 from $t2 to $fp-80
	# PushParam _tmp331
	  subu $sp, $sp, 4	# decrement sp to make space for param
	  lw $t0, -80($fp)	# fill _tmp331 to $t0 from $fp-80
	  sw $t0, 4($sp)	# copy param value to stack
	# LCall _PrintString
	  jal _PrintString   	# jump to function
	# PopParams 4
	  add $sp, $sp, 4	# pop params off stack
	# LCall ____PrintLine
	  jal ____PrintLine  	# jump to function
	# Return 
	  move $sp, $fp		# pop callee frame off stack
	  lw $ra, -4($fp)	# restore saved ra
	  lw $fp, 0($fp)	# restore saved fp
	  jr $ra		# return from function
	# Goto _L48
	  b _L48		# unconditional branch
  _L47:
  _L48:
	# _tmp332 = "Enter phone number: "
	  .data			# create string constant marked with label
	  _string61: .asciiz "Enter phone number: "
	  .text
	  la $t2, _string61	# load label
	  sw $t2, -84($fp)	# spill _tmp332 from $t2 to $fp-84
	# PushParam _tmp332
	  subu $sp, $sp, 4	# decrement sp to make space for param
	  lw $t0, -84($fp)	# fill _tmp332 to $t0 from $fp-84
	  sw $t0, 4($sp)	# copy param value to stack
	# LCall _PrintString
	  jal _PrintString   	# jump to function
	# PopParams 4
	  add $sp, $sp, 4	# pop params off stack
	# _tmp333 = LCall _ReadLine
	  jal _ReadLine      	# jump to function
	  move $t2, $v0		# copy function return value from $v0
	  sw $t2, -88($fp)	# spill _tmp333 from $t2 to $fp-88
	# p = _tmp333
	  lw $t2, -88($fp)	# fill _tmp333 to $t2 from $fp-88
	  sw $t2, -16($fp)	# spill p from $t2 to $fp-16
	# _tmp334 = "Enter address: "
	  .data			# create string constant marked with label
	  _string62: .asciiz "Enter address: "
	  .text
	  la $t2, _string62	# load label
	  sw $t2, -92($fp)	# spill _tmp334 from $t2 to $fp-92
	# PushParam _tmp334
	  subu $sp, $sp, 4	# decrement sp to make space for param
	  lw $t0, -92($fp)	# fill _tmp334 to $t0 from $fp-92
	  sw $t0, 4($sp)	# copy param value to stack
	# LCall _PrintString
	  jal _PrintString   	# jump to function
	# PopParams 4
	  add $sp, $sp, 4	# pop params off stack
	# _tmp335 = LCall _ReadLine
	  jal _ReadLine      	# jump to function
	  move $t2, $v0		# copy function return value from $v0
	  sw $t2, -96($fp)	# spill _tmp335 from $t2 to $fp-96
	# a = _tmp335
	  lw $t2, -96($fp)	# fill _tmp335 to $t2 from $fp-96
	  sw $t2, -20($fp)	# spill a from $t2 to $fp-20
	# _tmp336 = *(this + 4)
	  lw $t0, 4($fp)	# fill this to $t0 from $fp+4
	  lw $t2, 4($t0) 	# load with offset
	  sw $t2, -100($fp)	# spill _tmp336 from $t2 to $fp-100
	# _tmp337 = *(this + 8)
	  lw $t0, 4($fp)	# fill this to $t0 from $fp+4
	  lw $t2, 8($t0) 	# load with offset
	  sw $t2, -104($fp)	# spill _tmp337 from $t2 to $fp-104
	# _tmp338 = _tmp336 == _tmp337
	  lw $t0, -100($fp)	# fill _tmp336 to $t0 from $fp-100
	  lw $t1, -104($fp)	# fill _tmp337 to $t1 from $fp-104
	  seq $t2, $t0, $t1	
	  sw $t2, -108($fp)	# spill _tmp338 from $t2 to $fp-108
	# IfZ _tmp338 Goto _L49
	  lw $t0, -108($fp)	# fill _tmp338 to $t0 from $fp-108
	  beqz $t0, _L49	# branch if _tmp338 is zero 
	# _tmp339 = *(this + 8)
	  lw $t0, 4($fp)	# fill this to $t0 from $fp+4
	  lw $t2, 8($t0) 	# load with offset
	  sw $t2, -124($fp)	# spill _tmp339 from $t2 to $fp-124
	# cur = _tmp339
	  lw $t2, -124($fp)	# fill _tmp339 to $t2 from $fp-124
	  sw $t2, -116($fp)	# spill cur from $t2 to $fp-116
	# _tmp340 = *(this + 8)
	  lw $t0, 4($fp)	# fill this to $t0 from $fp+4
	  lw $t2, 8($t0) 	# load with offset
	  sw $t2, -128($fp)	# spill _tmp340 from $t2 to $fp-128
	# _tmp341 = 2
	  li $t2, 2		# load constant value 2 into $t2
	  sw $t2, -132($fp)	# spill _tmp341 from $t2 to $fp-132
	# _tmp342 = _tmp340 * _tmp341
	  lw $t0, -128($fp)	# fill _tmp340 to $t0 from $fp-128
	  lw $t1, -132($fp)	# fill _tmp341 to $t1 from $fp-132
	  mul $t2, $t0, $t1	
	  sw $t2, -136($fp)	# spill _tmp342 from $t2 to $fp-136
	# *(this + 8) = _tmp342
	  lw $t0, -136($fp)	# fill _tmp342 to $t0 from $fp-136
	  lw $t2, 4($fp)	# fill this to $t2 from $fp+4
	  sw $t0, 8($t2) 	# store with offset
	# _tmp343 = *(this + 8)
	  lw $t0, 4($fp)	# fill this to $t0 from $fp+4
	  lw $t2, 8($t0) 	# load with offset
	  sw $t2, -140($fp)	# spill _tmp343 from $t2 to $fp-140
	# _tmp344 = 4
	  li $t2, 4		# load constant value 4 into $t2
	  sw $t2, -144($fp)	# spill _tmp344 from $t2 to $fp-144
	# _tmp345 = 0
	  li $t2, 0		# load constant value 0 into $t2
	  sw $t2, -148($fp)	# spill _tmp345 from $t2 to $fp-148
	# _tmp346 = _tmp343 < _tmp345
	  lw $t0, -140($fp)	# fill _tmp343 to $t0 from $fp-140
	  lw $t1, -148($fp)	# fill _tmp345 to $t1 from $fp-148
	  slt $t2, $t0, $t1	
	  sw $t2, -152($fp)	# spill _tmp346 from $t2 to $fp-152
	# _tmp347 = _tmp343 == _tmp345
	  lw $t0, -140($fp)	# fill _tmp343 to $t0 from $fp-140
	  lw $t1, -148($fp)	# fill _tmp345 to $t1 from $fp-148
	  seq $t2, $t0, $t1	
	  sw $t2, -156($fp)	# spill _tmp347 from $t2 to $fp-156
	# _tmp348 = _tmp346 || _tmp347
	  lw $t0, -152($fp)	# fill _tmp346 to $t0 from $fp-152
	  lw $t1, -156($fp)	# fill _tmp347 to $t1 from $fp-156
	  or $t2, $t0, $t1	
	  sw $t2, -160($fp)	# spill _tmp348 from $t2 to $fp-160
	# IfZ _tmp348 Goto _L51
	  lw $t0, -160($fp)	# fill _tmp348 to $t0 from $fp-160
	  beqz $t0, _L51	# branch if _tmp348 is zero 
	# _tmp349 = "Decaf runtime error: Array size is <= 0\n"
	  .data			# create string constant marked with label
	  _string63: .asciiz "Decaf runtime error: Array size is <= 0\n"
	  .text
	  la $t2, _string63	# load label
	  sw $t2, -164($fp)	# spill _tmp349 from $t2 to $fp-164
	# PushParam _tmp349
	  subu $sp, $sp, 4	# decrement sp to make space for param
	  lw $t0, -164($fp)	# fill _tmp349 to $t0 from $fp-164
	  sw $t0, 4($sp)	# copy param value to stack
	# LCall _PrintString
	  jal _PrintString   	# jump to function
	# PopParams 4
	  add $sp, $sp, 4	# pop params off stack
	# LCall _Halt
	  jal _Halt          	# jump to function
  _L51:
	# _tmp350 = _tmp343 * _tmp344
	  lw $t0, -140($fp)	# fill _tmp343 to $t0 from $fp-140
	  lw $t1, -144($fp)	# fill _tmp344 to $t1 from $fp-144
	  mul $t2, $t0, $t1	
	  sw $t2, -168($fp)	# spill _tmp350 from $t2 to $fp-168
	# _tmp351 = _tmp344 + _tmp350
	  lw $t0, -144($fp)	# fill _tmp344 to $t0 from $fp-144
	  lw $t1, -168($fp)	# fill _tmp350 to $t1 from $fp-168
	  add $t2, $t0, $t1	
	  sw $t2, -172($fp)	# spill _tmp351 from $t2 to $fp-172
	# PushParam _tmp351
	  subu $sp, $sp, 4	# decrement sp to make space for param
	  lw $t0, -172($fp)	# fill _tmp351 to $t0 from $fp-172
	  sw $t0, 4($sp)	# copy param value to stack
	# _tmp352 = LCall _Alloc
	  jal _Alloc         	# jump to function
	  move $t2, $v0		# copy function return value from $v0
	  sw $t2, -176($fp)	# spill _tmp352 from $t2 to $fp-176
	# PopParams 4
	  add $sp, $sp, 4	# pop params off stack
	# *(_tmp352) = _tmp343
	  lw $t0, -140($fp)	# fill _tmp343 to $t0 from $fp-140
	  lw $t2, -176($fp)	# fill _tmp352 to $t2 from $fp-176
	  sw $t0, 0($t2) 	# store with offset
	# newPeople = _tmp352
	  lw $t2, -176($fp)	# fill _tmp352 to $t2 from $fp-176
	  sw $t2, -120($fp)	# spill newPeople from $t2 to $fp-120
	# _tmp353 = 0
	  li $t2, 0		# load constant value 0 into $t2
	  sw $t2, -180($fp)	# spill _tmp353 from $t2 to $fp-180
	# i = _tmp353
	  lw $t2, -180($fp)	# fill _tmp353 to $t2 from $fp-180
	  sw $t2, -112($fp)	# spill i from $t2 to $fp-112
  _L52:
	# _tmp354 = i < cur
	  lw $t0, -112($fp)	# fill i to $t0 from $fp-112
	  lw $t1, -116($fp)	# fill cur to $t1 from $fp-116
	  slt $t2, $t0, $t1	
	  sw $t2, -184($fp)	# spill _tmp354 from $t2 to $fp-184
	# IfZ _tmp354 Goto _L53
	  lw $t0, -184($fp)	# fill _tmp354 to $t0 from $fp-184
	  beqz $t0, _L53	# branch if _tmp354 is zero 
	# _tmp355 = *(this + 12)
	  lw $t0, 4($fp)	# fill this to $t0 from $fp+4
	  lw $t2, 12($t0) 	# load with offset
	  sw $t2, -188($fp)	# spill _tmp355 from $t2 to $fp-188
	# _tmp356 = 0
	  li $t2, 0		# load constant value 0 into $t2
	  sw $t2, -192($fp)	# spill _tmp356 from $t2 to $fp-192
	# _tmp357 = *(_tmp355)
	  lw $t0, -188($fp)	# fill _tmp355 to $t0 from $fp-188
	  lw $t2, 0($t0) 	# load with offset
	  sw $t2, -196($fp)	# spill _tmp357 from $t2 to $fp-196
	# _tmp358 = i < _tmp356
	  lw $t0, -112($fp)	# fill i to $t0 from $fp-112
	  lw $t1, -192($fp)	# fill _tmp356 to $t1 from $fp-192
	  slt $t2, $t0, $t1	
	  sw $t2, -200($fp)	# spill _tmp358 from $t2 to $fp-200
	# _tmp359 = _tmp357 < i
	  lw $t0, -196($fp)	# fill _tmp357 to $t0 from $fp-196
	  lw $t1, -112($fp)	# fill i to $t1 from $fp-112
	  slt $t2, $t0, $t1	
	  sw $t2, -204($fp)	# spill _tmp359 from $t2 to $fp-204
	# _tmp360 = _tmp357 == i
	  lw $t0, -196($fp)	# fill _tmp357 to $t0 from $fp-196
	  lw $t1, -112($fp)	# fill i to $t1 from $fp-112
	  seq $t2, $t0, $t1	
	  sw $t2, -208($fp)	# spill _tmp360 from $t2 to $fp-208
	# _tmp361 = _tmp359 || _tmp360
	  lw $t0, -204($fp)	# fill _tmp359 to $t0 from $fp-204
	  lw $t1, -208($fp)	# fill _tmp360 to $t1 from $fp-208
	  or $t2, $t0, $t1	
	  sw $t2, -212($fp)	# spill _tmp361 from $t2 to $fp-212
	# _tmp362 = _tmp361 || _tmp358
	  lw $t0, -212($fp)	# fill _tmp361 to $t0 from $fp-212
	  lw $t1, -200($fp)	# fill _tmp358 to $t1 from $fp-200
	  or $t2, $t0, $t1	
	  sw $t2, -216($fp)	# spill _tmp362 from $t2 to $fp-216
	# IfZ _tmp362 Goto _L54
	  lw $t0, -216($fp)	# fill _tmp362 to $t0 from $fp-216
	  beqz $t0, _L54	# branch if _tmp362 is zero 
	# _tmp363 = "Decaf runtime error: Array subscript out of bound..."
	  .data			# create string constant marked with label
	  _string64: .asciiz "Decaf runtime error: Array subscript out of bounds\n"
	  .text
	  la $t2, _string64	# load label
	  sw $t2, -220($fp)	# spill _tmp363 from $t2 to $fp-220
	# PushParam _tmp363
	  subu $sp, $sp, 4	# decrement sp to make space for param
	  lw $t0, -220($fp)	# fill _tmp363 to $t0 from $fp-220
	  sw $t0, 4($sp)	# copy param value to stack
	# LCall _PrintString
	  jal _PrintString   	# jump to function
	# PopParams 4
	  add $sp, $sp, 4	# pop params off stack
	# LCall _Halt
	  jal _Halt          	# jump to function
  _L54:
	# _tmp364 = 4
	  li $t2, 4		# load constant value 4 into $t2
	  sw $t2, -224($fp)	# spill _tmp364 from $t2 to $fp-224
	# _tmp365 = i * _tmp364
	  lw $t0, -112($fp)	# fill i to $t0 from $fp-112
	  lw $t1, -224($fp)	# fill _tmp364 to $t1 from $fp-224
	  mul $t2, $t0, $t1	
	  sw $t2, -228($fp)	# spill _tmp365 from $t2 to $fp-228
	# _tmp366 = _tmp365 + _tmp364
	  lw $t0, -228($fp)	# fill _tmp365 to $t0 from $fp-228
	  lw $t1, -224($fp)	# fill _tmp364 to $t1 from $fp-224
	  add $t2, $t0, $t1	
	  sw $t2, -232($fp)	# spill _tmp366 from $t2 to $fp-232
	# _tmp367 = _tmp355 + _tmp366
	  lw $t0, -188($fp)	# fill _tmp355 to $t0 from $fp-188
	  lw $t1, -232($fp)	# fill _tmp366 to $t1 from $fp-232
	  add $t2, $t0, $t1	
	  sw $t2, -236($fp)	# spill _tmp367 from $t2 to $fp-236
	# _tmp368 = *(_tmp367)
	  lw $t0, -236($fp)	# fill _tmp367 to $t0 from $fp-236
	  lw $t2, 0($t0) 	# load with offset
	  sw $t2, -240($fp)	# spill _tmp368 from $t2 to $fp-240
	# _tmp369 = 0
	  li $t2, 0		# load constant value 0 into $t2
	  sw $t2, -244($fp)	# spill _tmp369 from $t2 to $fp-244
	# _tmp370 = *(newPeople)
	  lw $t0, -120($fp)	# fill newPeople to $t0 from $fp-120
	  lw $t2, 0($t0) 	# load with offset
	  sw $t2, -248($fp)	# spill _tmp370 from $t2 to $fp-248
	# _tmp371 = i < _tmp369
	  lw $t0, -112($fp)	# fill i to $t0 from $fp-112
	  lw $t1, -244($fp)	# fill _tmp369 to $t1 from $fp-244
	  slt $t2, $t0, $t1	
	  sw $t2, -252($fp)	# spill _tmp371 from $t2 to $fp-252
	# _tmp372 = _tmp370 < i
	  lw $t0, -248($fp)	# fill _tmp370 to $t0 from $fp-248
	  lw $t1, -112($fp)	# fill i to $t1 from $fp-112
	  slt $t2, $t0, $t1	
	  sw $t2, -256($fp)	# spill _tmp372 from $t2 to $fp-256
	# _tmp373 = _tmp370 == i
	  lw $t0, -248($fp)	# fill _tmp370 to $t0 from $fp-248
	  lw $t1, -112($fp)	# fill i to $t1 from $fp-112
	  seq $t2, $t0, $t1	
	  sw $t2, -260($fp)	# spill _tmp373 from $t2 to $fp-260
	# _tmp374 = _tmp372 || _tmp373
	  lw $t0, -256($fp)	# fill _tmp372 to $t0 from $fp-256
	  lw $t1, -260($fp)	# fill _tmp373 to $t1 from $fp-260
	  or $t2, $t0, $t1	
	  sw $t2, -264($fp)	# spill _tmp374 from $t2 to $fp-264
	# _tmp375 = _tmp374 || _tmp371
	  lw $t0, -264($fp)	# fill _tmp374 to $t0 from $fp-264
	  lw $t1, -252($fp)	# fill _tmp371 to $t1 from $fp-252
	  or $t2, $t0, $t1	
	  sw $t2, -268($fp)	# spill _tmp375 from $t2 to $fp-268
	# IfZ _tmp375 Goto _L55
	  lw $t0, -268($fp)	# fill _tmp375 to $t0 from $fp-268
	  beqz $t0, _L55	# branch if _tmp375 is zero 
	# _tmp376 = "Decaf runtime error: Array subscript out of bound..."
	  .data			# create string constant marked with label
	  _string65: .asciiz "Decaf runtime error: Array subscript out of bounds\n"
	  .text
	  la $t2, _string65	# load label
	  sw $t2, -272($fp)	# spill _tmp376 from $t2 to $fp-272
	# PushParam _tmp376
	  subu $sp, $sp, 4	# decrement sp to make space for param
	  lw $t0, -272($fp)	# fill _tmp376 to $t0 from $fp-272
	  sw $t0, 4($sp)	# copy param value to stack
	# LCall _PrintString
	  jal _PrintString   	# jump to function
	# PopParams 4
	  add $sp, $sp, 4	# pop params off stack
	# LCall _Halt
	  jal _Halt          	# jump to function
  _L55:
	# _tmp377 = 4
	  li $t2, 4		# load constant value 4 into $t2
	  sw $t2, -276($fp)	# spill _tmp377 from $t2 to $fp-276
	# _tmp378 = i * _tmp377
	  lw $t0, -112($fp)	# fill i to $t0 from $fp-112
	  lw $t1, -276($fp)	# fill _tmp377 to $t1 from $fp-276
	  mul $t2, $t0, $t1	
	  sw $t2, -280($fp)	# spill _tmp378 from $t2 to $fp-280
	# _tmp379 = _tmp378 + _tmp377
	  lw $t0, -280($fp)	# fill _tmp378 to $t0 from $fp-280
	  lw $t1, -276($fp)	# fill _tmp377 to $t1 from $fp-276
	  add $t2, $t0, $t1	
	  sw $t2, -284($fp)	# spill _tmp379 from $t2 to $fp-284
	# _tmp380 = newPeople + _tmp379
	  lw $t0, -120($fp)	# fill newPeople to $t0 from $fp-120
	  lw $t1, -284($fp)	# fill _tmp379 to $t1 from $fp-284
	  add $t2, $t0, $t1	
	  sw $t2, -288($fp)	# spill _tmp380 from $t2 to $fp-288
	# *(_tmp380) = _tmp368
	  lw $t0, -240($fp)	# fill _tmp368 to $t0 from $fp-240
	  lw $t2, -288($fp)	# fill _tmp380 to $t2 from $fp-288
	  sw $t0, 0($t2) 	# store with offset
	# _tmp381 = *(_tmp380)
	  lw $t0, -288($fp)	# fill _tmp380 to $t0 from $fp-288
	  lw $t2, 0($t0) 	# load with offset
	  sw $t2, -292($fp)	# spill _tmp381 from $t2 to $fp-292
	# _tmp382 = 1
	  li $t2, 1		# load constant value 1 into $t2
	  sw $t2, -296($fp)	# spill _tmp382 from $t2 to $fp-296
	# _tmp383 = i + _tmp382
	  lw $t0, -112($fp)	# fill i to $t0 from $fp-112
	  lw $t1, -296($fp)	# fill _tmp382 to $t1 from $fp-296
	  add $t2, $t0, $t1	
	  sw $t2, -300($fp)	# spill _tmp383 from $t2 to $fp-300
	# i = _tmp383
	  lw $t2, -300($fp)	# fill _tmp383 to $t2 from $fp-300
	  sw $t2, -112($fp)	# spill i from $t2 to $fp-112
	# Goto _L52
	  b _L52		# unconditional branch
  _L53:
	# *(this + 12) = newPeople
	  lw $t0, -120($fp)	# fill newPeople to $t0 from $fp-120
	  lw $t2, 4($fp)	# fill this to $t2 from $fp+4
	  sw $t0, 12($t2) 	# store with offset
	# Goto _L50
	  b _L50		# unconditional branch
  _L49:
  _L50:
	# _tmp384 = 16
	  li $t2, 16		# load constant value 16 into $t2
	  sw $t2, -304($fp)	# spill _tmp384 from $t2 to $fp-304
	# _tmp385 = 4
	  li $t2, 4		# load constant value 4 into $t2
	  sw $t2, -308($fp)	# spill _tmp385 from $t2 to $fp-308
	# _tmp386 = _tmp385 + _tmp384
	  lw $t0, -308($fp)	# fill _tmp385 to $t0 from $fp-308
	  lw $t1, -304($fp)	# fill _tmp384 to $t1 from $fp-304
	  add $t2, $t0, $t1	
	  sw $t2, -312($fp)	# spill _tmp386 from $t2 to $fp-312
	# PushParam _tmp386
	  subu $sp, $sp, 4	# decrement sp to make space for param
	  lw $t0, -312($fp)	# fill _tmp386 to $t0 from $fp-312
	  sw $t0, 4($sp)	# copy param value to stack
	# _tmp387 = LCall _Alloc
	  jal _Alloc         	# jump to function
	  move $t2, $v0		# copy function return value from $v0
	  sw $t2, -316($fp)	# spill _tmp387 from $t2 to $fp-316
	# PopParams 4
	  add $sp, $sp, 4	# pop params off stack
	# _tmp388 = Person
	  la $t2, Person	# load label
	  sw $t2, -320($fp)	# spill _tmp388 from $t2 to $fp-320
	# *(_tmp387) = _tmp388
	  lw $t0, -320($fp)	# fill _tmp388 to $t0 from $fp-320
	  lw $t2, -316($fp)	# fill _tmp387 to $t2 from $fp-316
	  sw $t0, 0($t2) 	# store with offset
	# _tmp389 = *(this + 12)
	  lw $t0, 4($fp)	# fill this to $t0 from $fp+4
	  lw $t2, 12($t0) 	# load with offset
	  sw $t2, -324($fp)	# spill _tmp389 from $t2 to $fp-324
	# _tmp390 = *(this + 4)
	  lw $t0, 4($fp)	# fill this to $t0 from $fp+4
	  lw $t2, 4($t0) 	# load with offset
	  sw $t2, -328($fp)	# spill _tmp390 from $t2 to $fp-328
	# _tmp391 = 0
	  li $t2, 0		# load constant value 0 into $t2
	  sw $t2, -332($fp)	# spill _tmp391 from $t2 to $fp-332
	# _tmp392 = *(_tmp389)
	  lw $t0, -324($fp)	# fill _tmp389 to $t0 from $fp-324
	  lw $t2, 0($t0) 	# load with offset
	  sw $t2, -336($fp)	# spill _tmp392 from $t2 to $fp-336
	# _tmp393 = _tmp390 < _tmp391
	  lw $t0, -328($fp)	# fill _tmp390 to $t0 from $fp-328
	  lw $t1, -332($fp)	# fill _tmp391 to $t1 from $fp-332
	  slt $t2, $t0, $t1	
	  sw $t2, -340($fp)	# spill _tmp393 from $t2 to $fp-340
	# _tmp394 = _tmp392 < _tmp390
	  lw $t0, -336($fp)	# fill _tmp392 to $t0 from $fp-336
	  lw $t1, -328($fp)	# fill _tmp390 to $t1 from $fp-328
	  slt $t2, $t0, $t1	
	  sw $t2, -344($fp)	# spill _tmp394 from $t2 to $fp-344
	# _tmp395 = _tmp392 == _tmp390
	  lw $t0, -336($fp)	# fill _tmp392 to $t0 from $fp-336
	  lw $t1, -328($fp)	# fill _tmp390 to $t1 from $fp-328
	  seq $t2, $t0, $t1	
	  sw $t2, -348($fp)	# spill _tmp395 from $t2 to $fp-348
	# _tmp396 = _tmp394 || _tmp395
	  lw $t0, -344($fp)	# fill _tmp394 to $t0 from $fp-344
	  lw $t1, -348($fp)	# fill _tmp395 to $t1 from $fp-348
	  or $t2, $t0, $t1	
	  sw $t2, -352($fp)	# spill _tmp396 from $t2 to $fp-352
	# _tmp397 = _tmp396 || _tmp393
	  lw $t0, -352($fp)	# fill _tmp396 to $t0 from $fp-352
	  lw $t1, -340($fp)	# fill _tmp393 to $t1 from $fp-340
	  or $t2, $t0, $t1	
	  sw $t2, -356($fp)	# spill _tmp397 from $t2 to $fp-356
	# IfZ _tmp397 Goto _L56
	  lw $t0, -356($fp)	# fill _tmp397 to $t0 from $fp-356
	  beqz $t0, _L56	# branch if _tmp397 is zero 
	# _tmp398 = "Decaf runtime error: Array subscript out of bound..."
	  .data			# create string constant marked with label
	  _string66: .asciiz "Decaf runtime error: Array subscript out of bounds\n"
	  .text
	  la $t2, _string66	# load label
	  sw $t2, -360($fp)	# spill _tmp398 from $t2 to $fp-360
	# PushParam _tmp398
	  subu $sp, $sp, 4	# decrement sp to make space for param
	  lw $t0, -360($fp)	# fill _tmp398 to $t0 from $fp-360
	  sw $t0, 4($sp)	# copy param value to stack
	# LCall _PrintString
	  jal _PrintString   	# jump to function
	# PopParams 4
	  add $sp, $sp, 4	# pop params off stack
	# LCall _Halt
	  jal _Halt          	# jump to function
  _L56:
	# _tmp399 = 4
	  li $t2, 4		# load constant value 4 into $t2
	  sw $t2, -364($fp)	# spill _tmp399 from $t2 to $fp-364
	# _tmp400 = _tmp390 * _tmp399
	  lw $t0, -328($fp)	# fill _tmp390 to $t0 from $fp-328
	  lw $t1, -364($fp)	# fill _tmp399 to $t1 from $fp-364
	  mul $t2, $t0, $t1	
	  sw $t2, -368($fp)	# spill _tmp400 from $t2 to $fp-368
	# _tmp401 = _tmp400 + _tmp399
	  lw $t0, -368($fp)	# fill _tmp400 to $t0 from $fp-368
	  lw $t1, -364($fp)	# fill _tmp399 to $t1 from $fp-364
	  add $t2, $t0, $t1	
	  sw $t2, -372($fp)	# spill _tmp401 from $t2 to $fp-372
	# _tmp402 = _tmp389 + _tmp401
	  lw $t0, -324($fp)	# fill _tmp389 to $t0 from $fp-324
	  lw $t1, -372($fp)	# fill _tmp401 to $t1 from $fp-372
	  add $t2, $t0, $t1	
	  sw $t2, -376($fp)	# spill _tmp402 from $t2 to $fp-376
	# *(_tmp402) = _tmp387
	  lw $t0, -316($fp)	# fill _tmp387 to $t0 from $fp-316
	  lw $t2, -376($fp)	# fill _tmp402 to $t2 from $fp-376
	  sw $t0, 0($t2) 	# store with offset
	# _tmp403 = *(_tmp402)
	  lw $t0, -376($fp)	# fill _tmp402 to $t0 from $fp-376
	  lw $t2, 0($t0) 	# load with offset
	  sw $t2, -380($fp)	# spill _tmp403 from $t2 to $fp-380
	# PushParam a
	  subu $sp, $sp, 4	# decrement sp to make space for param
	  lw $t0, -20($fp)	# fill a to $t0 from $fp-20
	  sw $t0, 4($sp)	# copy param value to stack
	# PushParam p
	  subu $sp, $sp, 4	# decrement sp to make space for param
	  lw $t0, -16($fp)	# fill p to $t0 from $fp-16
	  sw $t0, 4($sp)	# copy param value to stack
	# PushParam l
	  subu $sp, $sp, 4	# decrement sp to make space for param
	  lw $t0, -12($fp)	# fill l to $t0 from $fp-12
	  sw $t0, 4($sp)	# copy param value to stack
	# PushParam f
	  subu $sp, $sp, 4	# decrement sp to make space for param
	  lw $t0, -8($fp)	# fill f to $t0 from $fp-8
	  sw $t0, 4($sp)	# copy param value to stack
	# _tmp404 = *(this + 12)
	  lw $t0, 4($fp)	# fill this to $t0 from $fp+4
	  lw $t2, 12($t0) 	# load with offset
	  sw $t2, -384($fp)	# spill _tmp404 from $t2 to $fp-384
	# _tmp405 = *(this + 4)
	  lw $t0, 4($fp)	# fill this to $t0 from $fp+4
	  lw $t2, 4($t0) 	# load with offset
	  sw $t2, -388($fp)	# spill _tmp405 from $t2 to $fp-388
	# _tmp406 = 0
	  li $t2, 0		# load constant value 0 into $t2
	  sw $t2, -392($fp)	# spill _tmp406 from $t2 to $fp-392
	# _tmp407 = *(_tmp404)
	  lw $t0, -384($fp)	# fill _tmp404 to $t0 from $fp-384
	  lw $t2, 0($t0) 	# load with offset
	  sw $t2, -396($fp)	# spill _tmp407 from $t2 to $fp-396
	# _tmp408 = _tmp405 < _tmp406
	  lw $t0, -388($fp)	# fill _tmp405 to $t0 from $fp-388
	  lw $t1, -392($fp)	# fill _tmp406 to $t1 from $fp-392
	  slt $t2, $t0, $t1	
	  sw $t2, -400($fp)	# spill _tmp408 from $t2 to $fp-400
	# _tmp409 = _tmp407 < _tmp405
	  lw $t0, -396($fp)	# fill _tmp407 to $t0 from $fp-396
	  lw $t1, -388($fp)	# fill _tmp405 to $t1 from $fp-388
	  slt $t2, $t0, $t1	
	  sw $t2, -404($fp)	# spill _tmp409 from $t2 to $fp-404
	# _tmp410 = _tmp407 == _tmp405
	  lw $t0, -396($fp)	# fill _tmp407 to $t0 from $fp-396
	  lw $t1, -388($fp)	# fill _tmp405 to $t1 from $fp-388
	  seq $t2, $t0, $t1	
	  sw $t2, -408($fp)	# spill _tmp410 from $t2 to $fp-408
	# _tmp411 = _tmp409 || _tmp410
	  lw $t0, -404($fp)	# fill _tmp409 to $t0 from $fp-404
	  lw $t1, -408($fp)	# fill _tmp410 to $t1 from $fp-408
	  or $t2, $t0, $t1	
	  sw $t2, -412($fp)	# spill _tmp411 from $t2 to $fp-412
	# _tmp412 = _tmp411 || _tmp408
	  lw $t0, -412($fp)	# fill _tmp411 to $t0 from $fp-412
	  lw $t1, -400($fp)	# fill _tmp408 to $t1 from $fp-400
	  or $t2, $t0, $t1	
	  sw $t2, -416($fp)	# spill _tmp412 from $t2 to $fp-416
	# IfZ _tmp412 Goto _L57
	  lw $t0, -416($fp)	# fill _tmp412 to $t0 from $fp-416
	  beqz $t0, _L57	# branch if _tmp412 is zero 
	# _tmp413 = "Decaf runtime error: Array subscript out of bound..."
	  .data			# create string constant marked with label
	  _string67: .asciiz "Decaf runtime error: Array subscript out of bounds\n"
	  .text
	  la $t2, _string67	# load label
	  sw $t2, -420($fp)	# spill _tmp413 from $t2 to $fp-420
	# PushParam _tmp413
	  subu $sp, $sp, 4	# decrement sp to make space for param
	  lw $t0, -420($fp)	# fill _tmp413 to $t0 from $fp-420
	  sw $t0, 4($sp)	# copy param value to stack
	# LCall _PrintString
	  jal _PrintString   	# jump to function
	# PopParams 4
	  add $sp, $sp, 4	# pop params off stack
	# LCall _Halt
	  jal _Halt          	# jump to function
  _L57:
	# _tmp414 = 4
	  li $t2, 4		# load constant value 4 into $t2
	  sw $t2, -424($fp)	# spill _tmp414 from $t2 to $fp-424
	# _tmp415 = _tmp405 * _tmp414
	  lw $t0, -388($fp)	# fill _tmp405 to $t0 from $fp-388
	  lw $t1, -424($fp)	# fill _tmp414 to $t1 from $fp-424
	  mul $t2, $t0, $t1	
	  sw $t2, -428($fp)	# spill _tmp415 from $t2 to $fp-428
	# _tmp416 = _tmp415 + _tmp414
	  lw $t0, -428($fp)	# fill _tmp415 to $t0 from $fp-428
	  lw $t1, -424($fp)	# fill _tmp414 to $t1 from $fp-424
	  add $t2, $t0, $t1	
	  sw $t2, -432($fp)	# spill _tmp416 from $t2 to $fp-432
	# _tmp417 = _tmp404 + _tmp416
	  lw $t0, -384($fp)	# fill _tmp404 to $t0 from $fp-384
	  lw $t1, -432($fp)	# fill _tmp416 to $t1 from $fp-432
	  add $t2, $t0, $t1	
	  sw $t2, -436($fp)	# spill _tmp417 from $t2 to $fp-436
	# _tmp418 = *(_tmp417)
	  lw $t0, -436($fp)	# fill _tmp417 to $t0 from $fp-436
	  lw $t2, 0($t0) 	# load with offset
	  sw $t2, -440($fp)	# spill _tmp418 from $t2 to $fp-440
	# PushParam _tmp418
	  subu $sp, $sp, 4	# decrement sp to make space for param
	  lw $t0, -440($fp)	# fill _tmp418 to $t0 from $fp-440
	  sw $t0, 4($sp)	# copy param value to stack
	# _tmp419 = *(_tmp418)
	  lw $t0, -440($fp)	# fill _tmp418 to $t0 from $fp-440
	  lw $t2, 0($t0) 	# load with offset
	  sw $t2, -444($fp)	# spill _tmp419 from $t2 to $fp-444
	# _tmp420 = *(_tmp419)
	  lw $t0, -444($fp)	# fill _tmp419 to $t0 from $fp-444
	  lw $t2, 0($t0) 	# load with offset
	  sw $t2, -448($fp)	# spill _tmp420 from $t2 to $fp-448
	# ACall _tmp420
	  lw $t0, -448($fp)	# fill _tmp420 to $t0 from $fp-448
	  jalr $t0            	# jump to function
	# PopParams 20
	  add $sp, $sp, 20	# pop params off stack
	# _tmp421 = *(this + 4)
	  lw $t0, 4($fp)	# fill this to $t0 from $fp+4
	  lw $t2, 4($t0) 	# load with offset
	  sw $t2, -452($fp)	# spill _tmp421 from $t2 to $fp-452
	# _tmp422 = 1
	  li $t2, 1		# load constant value 1 into $t2
	  sw $t2, -456($fp)	# spill _tmp422 from $t2 to $fp-456
	# _tmp423 = _tmp421 + _tmp422
	  lw $t0, -452($fp)	# fill _tmp421 to $t0 from $fp-452
	  lw $t1, -456($fp)	# fill _tmp422 to $t1 from $fp-456
	  add $t2, $t0, $t1	
	  sw $t2, -460($fp)	# spill _tmp423 from $t2 to $fp-460
	# *(this + 4) = _tmp423
	  lw $t0, -460($fp)	# fill _tmp423 to $t0 from $fp-460
	  lw $t2, 4($fp)	# fill this to $t2 from $fp+4
	  sw $t0, 4($t2) 	# store with offset
	# _tmp424 = "\n"
	  .data			# create string constant marked with label
	  _string68: .asciiz "\n"
	  .text
	  la $t2, _string68	# load label
	  sw $t2, -464($fp)	# spill _tmp424 from $t2 to $fp-464
	# PushParam _tmp424
	  subu $sp, $sp, 4	# decrement sp to make space for param
	  lw $t0, -464($fp)	# fill _tmp424 to $t0 from $fp-464
	  sw $t0, 4($sp)	# copy param value to stack
	# LCall _PrintString
	  jal _PrintString   	# jump to function
	# PopParams 4
	  add $sp, $sp, 4	# pop params off stack
	# PushParam l
	  subu $sp, $sp, 4	# decrement sp to make space for param
	  lw $t0, -12($fp)	# fill l to $t0 from $fp-12
	  sw $t0, 4($sp)	# copy param value to stack
	# LCall _PrintString
	  jal _PrintString   	# jump to function
	# PopParams 4
	  add $sp, $sp, 4	# pop params off stack
	# _tmp425 = ", "
	  .data			# create string constant marked with label
	  _string69: .asciiz ", "
	  .text
	  la $t2, _string69	# load label
	  sw $t2, -468($fp)	# spill _tmp425 from $t2 to $fp-468
	# PushParam _tmp425
	  subu $sp, $sp, 4	# decrement sp to make space for param
	  lw $t0, -468($fp)	# fill _tmp425 to $t0 from $fp-468
	  sw $t0, 4($sp)	# copy param value to stack
	# LCall _PrintString
	  jal _PrintString   	# jump to function
	# PopParams 4
	  add $sp, $sp, 4	# pop params off stack
	# PushParam f
	  subu $sp, $sp, 4	# decrement sp to make space for param
	  lw $t0, -8($fp)	# fill f to $t0 from $fp-8
	  sw $t0, 4($sp)	# copy param value to stack
	# LCall _PrintString
	  jal _PrintString   	# jump to function
	# PopParams 4
	  add $sp, $sp, 4	# pop params off stack
	# _tmp426 = " successfully added!\n"
	  .data			# create string constant marked with label
	  _string70: .asciiz " successfully added!\n"
	  .text
	  la $t2, _string70	# load label
	  sw $t2, -472($fp)	# spill _tmp426 from $t2 to $fp-472
	# PushParam _tmp426
	  subu $sp, $sp, 4	# decrement sp to make space for param
	  lw $t0, -472($fp)	# fill _tmp426 to $t0 from $fp-472
	  sw $t0, 4($sp)	# copy param value to stack
	# LCall _PrintString
	  jal _PrintString   	# jump to function
	# PopParams 4
	  add $sp, $sp, 4	# pop params off stack
	# LCall ____PrintLine
	  jal ____PrintLine  	# jump to function
	# EndFunc
	# (below handles reaching end of fn body with no explicit return)
	  move $sp, $fp		# pop callee frame off stack
	  lw $ra, -4($fp)	# restore saved ra
	  lw $fp, 0($fp)	# restore saved fp
	  jr $ra		# return from function
  Database.____Delete:
	# BeginFunc 264
	  subu $sp, $sp, 8	# decrement sp to make space to save ra, fp
	  sw $fp, 8($sp)	# save fp
	  sw $ra, 4($sp)	# save ra
	  addiu $fp, $sp, 8	# set up new fp
	  subu $sp, $sp, 264	# decrement sp to make space for locals/temps
	# LCall ____PrintLine
	  jal ____PrintLine  	# jump to function
	# _tmp427 = "Deleting person...\n\n"
	  .data			# create string constant marked with label
	  _string71: .asciiz "Deleting person...\n\n"
	  .text
	  la $t2, _string71	# load label
	  sw $t2, -20($fp)	# spill _tmp427 from $t2 to $fp-20
	# PushParam _tmp427
	  subu $sp, $sp, 4	# decrement sp to make space for param
	  lw $t0, -20($fp)	# fill _tmp427 to $t0 from $fp-20
	  sw $t0, 4($sp)	# copy param value to stack
	# LCall _PrintString
	  jal _PrintString   	# jump to function
	# PopParams 4
	  add $sp, $sp, 4	# pop params off stack
	# _tmp428 = "Enter first name: "
	  .data			# create string constant marked with label
	  _string72: .asciiz "Enter first name: "
	  .text
	  la $t2, _string72	# load label
	  sw $t2, -24($fp)	# spill _tmp428 from $t2 to $fp-24
	# PushParam _tmp428
	  subu $sp, $sp, 4	# decrement sp to make space for param
	  lw $t0, -24($fp)	# fill _tmp428 to $t0 from $fp-24
	  sw $t0, 4($sp)	# copy param value to stack
	# LCall _PrintString
	  jal _PrintString   	# jump to function
	# PopParams 4
	  add $sp, $sp, 4	# pop params off stack
	# _tmp429 = LCall _ReadLine
	  jal _ReadLine      	# jump to function
	  move $t2, $v0		# copy function return value from $v0
	  sw $t2, -28($fp)	# spill _tmp429 from $t2 to $fp-28
	# f = _tmp429
	  lw $t2, -28($fp)	# fill _tmp429 to $t2 from $fp-28
	  sw $t2, -8($fp)	# spill f from $t2 to $fp-8
	# _tmp430 = "Enter last name: "
	  .data			# create string constant marked with label
	  _string73: .asciiz "Enter last name: "
	  .text
	  la $t2, _string73	# load label
	  sw $t2, -32($fp)	# spill _tmp430 from $t2 to $fp-32
	# PushParam _tmp430
	  subu $sp, $sp, 4	# decrement sp to make space for param
	  lw $t0, -32($fp)	# fill _tmp430 to $t0 from $fp-32
	  sw $t0, 4($sp)	# copy param value to stack
	# LCall _PrintString
	  jal _PrintString   	# jump to function
	# PopParams 4
	  add $sp, $sp, 4	# pop params off stack
	# _tmp431 = LCall _ReadLine
	  jal _ReadLine      	# jump to function
	  move $t2, $v0		# copy function return value from $v0
	  sw $t2, -36($fp)	# spill _tmp431 from $t2 to $fp-36
	# l = _tmp431
	  lw $t2, -36($fp)	# fill _tmp431 to $t2 from $fp-36
	  sw $t2, -12($fp)	# spill l from $t2 to $fp-12
	# PushParam l
	  subu $sp, $sp, 4	# decrement sp to make space for param
	  lw $t0, -12($fp)	# fill l to $t0 from $fp-12
	  sw $t0, 4($sp)	# copy param value to stack
	# PushParam f
	  subu $sp, $sp, 4	# decrement sp to make space for param
	  lw $t0, -8($fp)	# fill f to $t0 from $fp-8
	  sw $t0, 4($sp)	# copy param value to stack
	# PushParam this
	  subu $sp, $sp, 4	# decrement sp to make space for param
	  lw $t0, 4($fp)	# fill this to $t0 from $fp+4
	  sw $t0, 4($sp)	# copy param value to stack
	# _tmp432 = *(this)
	  lw $t0, 4($fp)	# fill this to $t0 from $fp+4
	  lw $t2, 0($t0) 	# load with offset
	  sw $t2, -40($fp)	# spill _tmp432 from $t2 to $fp-40
	# _tmp433 = *(_tmp432 + 8)
	  lw $t0, -40($fp)	# fill _tmp432 to $t0 from $fp-40
	  lw $t2, 8($t0) 	# load with offset
	  sw $t2, -44($fp)	# spill _tmp433 from $t2 to $fp-44
	# _tmp434 = ACall _tmp433
	  lw $t0, -44($fp)	# fill _tmp433 to $t0 from $fp-44
	  jalr $t0            	# jump to function
	  move $t2, $v0		# copy function return value from $v0
	  sw $t2, -48($fp)	# spill _tmp434 from $t2 to $fp-48
	# PopParams 12
	  add $sp, $sp, 12	# pop params off stack
	# index = _tmp434
	  lw $t2, -48($fp)	# fill _tmp434 to $t2 from $fp-48
	  sw $t2, -16($fp)	# spill index from $t2 to $fp-16
	# _tmp436 = 1
	  li $t2, 1		# load constant value 1 into $t2
	  sw $t2, -56($fp)	# spill _tmp436 from $t2 to $fp-56
	# _tmp437 = 0
	  li $t2, 0		# load constant value 0 into $t2
	  sw $t2, -60($fp)	# spill _tmp437 from $t2 to $fp-60
	# _tmp438 = _tmp437 - _tmp436
	  lw $t0, -60($fp)	# fill _tmp437 to $t0 from $fp-60
	  lw $t1, -56($fp)	# fill _tmp436 to $t1 from $fp-56
	  sub $t2, $t0, $t1	
	  sw $t2, -64($fp)	# spill _tmp438 from $t2 to $fp-64
	# _tmp439 = index == _tmp438
	  lw $t0, -16($fp)	# fill index to $t0 from $fp-16
	  lw $t1, -64($fp)	# fill _tmp438 to $t1 from $fp-64
	  seq $t2, $t0, $t1	
	  sw $t2, -68($fp)	# spill _tmp439 from $t2 to $fp-68
	# IfZ _tmp439 Goto _L61
	  lw $t0, -68($fp)	# fill _tmp439 to $t0 from $fp-68
	  beqz $t0, _L61	# branch if _tmp439 is zero 
	# _tmp440 = 0
	  li $t2, 0		# load constant value 0 into $t2
	  sw $t2, -72($fp)	# spill _tmp440 from $t2 to $fp-72
	# _tmp435 = _tmp440
	  lw $t2, -72($fp)	# fill _tmp440 to $t2 from $fp-72
	  sw $t2, -52($fp)	# spill _tmp435 from $t2 to $fp-52
	# Goto _L60
	  b _L60		# unconditional branch
  _L61:
	# _tmp441 = 1
	  li $t2, 1		# load constant value 1 into $t2
	  sw $t2, -76($fp)	# spill _tmp441 from $t2 to $fp-76
	# _tmp435 = _tmp441
	  lw $t2, -76($fp)	# fill _tmp441 to $t2 from $fp-76
	  sw $t2, -52($fp)	# spill _tmp435 from $t2 to $fp-52
  _L60:
	# IfZ _tmp435 Goto _L58
	  lw $t0, -52($fp)	# fill _tmp435 to $t0 from $fp-52
	  beqz $t0, _L58	# branch if _tmp435 is zero 
	# _tmp442 = *(this + 12)
	  lw $t0, 4($fp)	# fill this to $t0 from $fp+4
	  lw $t2, 12($t0) 	# load with offset
	  sw $t2, -80($fp)	# spill _tmp442 from $t2 to $fp-80
	# _tmp443 = *(this + 4)
	  lw $t0, 4($fp)	# fill this to $t0 from $fp+4
	  lw $t2, 4($t0) 	# load with offset
	  sw $t2, -84($fp)	# spill _tmp443 from $t2 to $fp-84
	# _tmp444 = 1
	  li $t2, 1		# load constant value 1 into $t2
	  sw $t2, -88($fp)	# spill _tmp444 from $t2 to $fp-88
	# _tmp445 = _tmp443 - _tmp444
	  lw $t0, -84($fp)	# fill _tmp443 to $t0 from $fp-84
	  lw $t1, -88($fp)	# fill _tmp444 to $t1 from $fp-88
	  sub $t2, $t0, $t1	
	  sw $t2, -92($fp)	# spill _tmp445 from $t2 to $fp-92
	# _tmp446 = 0
	  li $t2, 0		# load constant value 0 into $t2
	  sw $t2, -96($fp)	# spill _tmp446 from $t2 to $fp-96
	# _tmp447 = *(_tmp442)
	  lw $t0, -80($fp)	# fill _tmp442 to $t0 from $fp-80
	  lw $t2, 0($t0) 	# load with offset
	  sw $t2, -100($fp)	# spill _tmp447 from $t2 to $fp-100
	# _tmp448 = _tmp445 < _tmp446
	  lw $t0, -92($fp)	# fill _tmp445 to $t0 from $fp-92
	  lw $t1, -96($fp)	# fill _tmp446 to $t1 from $fp-96
	  slt $t2, $t0, $t1	
	  sw $t2, -104($fp)	# spill _tmp448 from $t2 to $fp-104
	# _tmp449 = _tmp447 < _tmp445
	  lw $t0, -100($fp)	# fill _tmp447 to $t0 from $fp-100
	  lw $t1, -92($fp)	# fill _tmp445 to $t1 from $fp-92
	  slt $t2, $t0, $t1	
	  sw $t2, -108($fp)	# spill _tmp449 from $t2 to $fp-108
	# _tmp450 = _tmp447 == _tmp445
	  lw $t0, -100($fp)	# fill _tmp447 to $t0 from $fp-100
	  lw $t1, -92($fp)	# fill _tmp445 to $t1 from $fp-92
	  seq $t2, $t0, $t1	
	  sw $t2, -112($fp)	# spill _tmp450 from $t2 to $fp-112
	# _tmp451 = _tmp449 || _tmp450
	  lw $t0, -108($fp)	# fill _tmp449 to $t0 from $fp-108
	  lw $t1, -112($fp)	# fill _tmp450 to $t1 from $fp-112
	  or $t2, $t0, $t1	
	  sw $t2, -116($fp)	# spill _tmp451 from $t2 to $fp-116
	# _tmp452 = _tmp451 || _tmp448
	  lw $t0, -116($fp)	# fill _tmp451 to $t0 from $fp-116
	  lw $t1, -104($fp)	# fill _tmp448 to $t1 from $fp-104
	  or $t2, $t0, $t1	
	  sw $t2, -120($fp)	# spill _tmp452 from $t2 to $fp-120
	# IfZ _tmp452 Goto _L62
	  lw $t0, -120($fp)	# fill _tmp452 to $t0 from $fp-120
	  beqz $t0, _L62	# branch if _tmp452 is zero 
	# _tmp453 = "Decaf runtime error: Array subscript out of bound..."
	  .data			# create string constant marked with label
	  _string74: .asciiz "Decaf runtime error: Array subscript out of bounds\n"
	  .text
	  la $t2, _string74	# load label
	  sw $t2, -124($fp)	# spill _tmp453 from $t2 to $fp-124
	# PushParam _tmp453
	  subu $sp, $sp, 4	# decrement sp to make space for param
	  lw $t0, -124($fp)	# fill _tmp453 to $t0 from $fp-124
	  sw $t0, 4($sp)	# copy param value to stack
	# LCall _PrintString
	  jal _PrintString   	# jump to function
	# PopParams 4
	  add $sp, $sp, 4	# pop params off stack
	# LCall _Halt
	  jal _Halt          	# jump to function
  _L62:
	# _tmp454 = 4
	  li $t2, 4		# load constant value 4 into $t2
	  sw $t2, -128($fp)	# spill _tmp454 from $t2 to $fp-128
	# _tmp455 = _tmp445 * _tmp454
	  lw $t0, -92($fp)	# fill _tmp445 to $t0 from $fp-92
	  lw $t1, -128($fp)	# fill _tmp454 to $t1 from $fp-128
	  mul $t2, $t0, $t1	
	  sw $t2, -132($fp)	# spill _tmp455 from $t2 to $fp-132
	# _tmp456 = _tmp455 + _tmp454
	  lw $t0, -132($fp)	# fill _tmp455 to $t0 from $fp-132
	  lw $t1, -128($fp)	# fill _tmp454 to $t1 from $fp-128
	  add $t2, $t0, $t1	
	  sw $t2, -136($fp)	# spill _tmp456 from $t2 to $fp-136
	# _tmp457 = _tmp442 + _tmp456
	  lw $t0, -80($fp)	# fill _tmp442 to $t0 from $fp-80
	  lw $t1, -136($fp)	# fill _tmp456 to $t1 from $fp-136
	  add $t2, $t0, $t1	
	  sw $t2, -140($fp)	# spill _tmp457 from $t2 to $fp-140
	# _tmp458 = *(_tmp457)
	  lw $t0, -140($fp)	# fill _tmp457 to $t0 from $fp-140
	  lw $t2, 0($t0) 	# load with offset
	  sw $t2, -144($fp)	# spill _tmp458 from $t2 to $fp-144
	# _tmp459 = *(this + 12)
	  lw $t0, 4($fp)	# fill this to $t0 from $fp+4
	  lw $t2, 12($t0) 	# load with offset
	  sw $t2, -148($fp)	# spill _tmp459 from $t2 to $fp-148
	# _tmp460 = 0
	  li $t2, 0		# load constant value 0 into $t2
	  sw $t2, -152($fp)	# spill _tmp460 from $t2 to $fp-152
	# _tmp461 = *(_tmp459)
	  lw $t0, -148($fp)	# fill _tmp459 to $t0 from $fp-148
	  lw $t2, 0($t0) 	# load with offset
	  sw $t2, -156($fp)	# spill _tmp461 from $t2 to $fp-156
	# _tmp462 = index < _tmp460
	  lw $t0, -16($fp)	# fill index to $t0 from $fp-16
	  lw $t1, -152($fp)	# fill _tmp460 to $t1 from $fp-152
	  slt $t2, $t0, $t1	
	  sw $t2, -160($fp)	# spill _tmp462 from $t2 to $fp-160
	# _tmp463 = _tmp461 < index
	  lw $t0, -156($fp)	# fill _tmp461 to $t0 from $fp-156
	  lw $t1, -16($fp)	# fill index to $t1 from $fp-16
	  slt $t2, $t0, $t1	
	  sw $t2, -164($fp)	# spill _tmp463 from $t2 to $fp-164
	# _tmp464 = _tmp461 == index
	  lw $t0, -156($fp)	# fill _tmp461 to $t0 from $fp-156
	  lw $t1, -16($fp)	# fill index to $t1 from $fp-16
	  seq $t2, $t0, $t1	
	  sw $t2, -168($fp)	# spill _tmp464 from $t2 to $fp-168
	# _tmp465 = _tmp463 || _tmp464
	  lw $t0, -164($fp)	# fill _tmp463 to $t0 from $fp-164
	  lw $t1, -168($fp)	# fill _tmp464 to $t1 from $fp-168
	  or $t2, $t0, $t1	
	  sw $t2, -172($fp)	# spill _tmp465 from $t2 to $fp-172
	# _tmp466 = _tmp465 || _tmp462
	  lw $t0, -172($fp)	# fill _tmp465 to $t0 from $fp-172
	  lw $t1, -160($fp)	# fill _tmp462 to $t1 from $fp-160
	  or $t2, $t0, $t1	
	  sw $t2, -176($fp)	# spill _tmp466 from $t2 to $fp-176
	# IfZ _tmp466 Goto _L63
	  lw $t0, -176($fp)	# fill _tmp466 to $t0 from $fp-176
	  beqz $t0, _L63	# branch if _tmp466 is zero 
	# _tmp467 = "Decaf runtime error: Array subscript out of bound..."
	  .data			# create string constant marked with label
	  _string75: .asciiz "Decaf runtime error: Array subscript out of bounds\n"
	  .text
	  la $t2, _string75	# load label
	  sw $t2, -180($fp)	# spill _tmp467 from $t2 to $fp-180
	# PushParam _tmp467
	  subu $sp, $sp, 4	# decrement sp to make space for param
	  lw $t0, -180($fp)	# fill _tmp467 to $t0 from $fp-180
	  sw $t0, 4($sp)	# copy param value to stack
	# LCall _PrintString
	  jal _PrintString   	# jump to function
	# PopParams 4
	  add $sp, $sp, 4	# pop params off stack
	# LCall _Halt
	  jal _Halt          	# jump to function
  _L63:
	# _tmp468 = 4
	  li $t2, 4		# load constant value 4 into $t2
	  sw $t2, -184($fp)	# spill _tmp468 from $t2 to $fp-184
	# _tmp469 = index * _tmp468
	  lw $t0, -16($fp)	# fill index to $t0 from $fp-16
	  lw $t1, -184($fp)	# fill _tmp468 to $t1 from $fp-184
	  mul $t2, $t0, $t1	
	  sw $t2, -188($fp)	# spill _tmp469 from $t2 to $fp-188
	# _tmp470 = _tmp469 + _tmp468
	  lw $t0, -188($fp)	# fill _tmp469 to $t0 from $fp-188
	  lw $t1, -184($fp)	# fill _tmp468 to $t1 from $fp-184
	  add $t2, $t0, $t1	
	  sw $t2, -192($fp)	# spill _tmp470 from $t2 to $fp-192
	# _tmp471 = _tmp459 + _tmp470
	  lw $t0, -148($fp)	# fill _tmp459 to $t0 from $fp-148
	  lw $t1, -192($fp)	# fill _tmp470 to $t1 from $fp-192
	  add $t2, $t0, $t1	
	  sw $t2, -196($fp)	# spill _tmp471 from $t2 to $fp-196
	# *(_tmp471) = _tmp458
	  lw $t0, -144($fp)	# fill _tmp458 to $t0 from $fp-144
	  lw $t2, -196($fp)	# fill _tmp471 to $t2 from $fp-196
	  sw $t0, 0($t2) 	# store with offset
	# _tmp472 = *(_tmp471)
	  lw $t0, -196($fp)	# fill _tmp471 to $t0 from $fp-196
	  lw $t2, 0($t0) 	# load with offset
	  sw $t2, -200($fp)	# spill _tmp472 from $t2 to $fp-200
	# _tmp473 = *(this + 4)
	  lw $t0, 4($fp)	# fill this to $t0 from $fp+4
	  lw $t2, 4($t0) 	# load with offset
	  sw $t2, -204($fp)	# spill _tmp473 from $t2 to $fp-204
	# _tmp474 = 1
	  li $t2, 1		# load constant value 1 into $t2
	  sw $t2, -208($fp)	# spill _tmp474 from $t2 to $fp-208
	# _tmp475 = _tmp473 - _tmp474
	  lw $t0, -204($fp)	# fill _tmp473 to $t0 from $fp-204
	  lw $t1, -208($fp)	# fill _tmp474 to $t1 from $fp-208
	  sub $t2, $t0, $t1	
	  sw $t2, -212($fp)	# spill _tmp475 from $t2 to $fp-212
	# *(this + 4) = _tmp475
	  lw $t0, -212($fp)	# fill _tmp475 to $t0 from $fp-212
	  lw $t2, 4($fp)	# fill this to $t2 from $fp+4
	  sw $t0, 4($t2) 	# store with offset
	# _tmp476 = "\n"
	  .data			# create string constant marked with label
	  _string76: .asciiz "\n"
	  .text
	  la $t2, _string76	# load label
	  sw $t2, -216($fp)	# spill _tmp476 from $t2 to $fp-216
	# PushParam _tmp476
	  subu $sp, $sp, 4	# decrement sp to make space for param
	  lw $t0, -216($fp)	# fill _tmp476 to $t0 from $fp-216
	  sw $t0, 4($sp)	# copy param value to stack
	# LCall _PrintString
	  jal _PrintString   	# jump to function
	# PopParams 4
	  add $sp, $sp, 4	# pop params off stack
	# PushParam l
	  subu $sp, $sp, 4	# decrement sp to make space for param
	  lw $t0, -12($fp)	# fill l to $t0 from $fp-12
	  sw $t0, 4($sp)	# copy param value to stack
	# LCall _PrintString
	  jal _PrintString   	# jump to function
	# PopParams 4
	  add $sp, $sp, 4	# pop params off stack
	# _tmp477 = ", "
	  .data			# create string constant marked with label
	  _string77: .asciiz ", "
	  .text
	  la $t2, _string77	# load label
	  sw $t2, -220($fp)	# spill _tmp477 from $t2 to $fp-220
	# PushParam _tmp477
	  subu $sp, $sp, 4	# decrement sp to make space for param
	  lw $t0, -220($fp)	# fill _tmp477 to $t0 from $fp-220
	  sw $t0, 4($sp)	# copy param value to stack
	# LCall _PrintString
	  jal _PrintString   	# jump to function
	# PopParams 4
	  add $sp, $sp, 4	# pop params off stack
	# PushParam f
	  subu $sp, $sp, 4	# decrement sp to make space for param
	  lw $t0, -8($fp)	# fill f to $t0 from $fp-8
	  sw $t0, 4($sp)	# copy param value to stack
	# LCall _PrintString
	  jal _PrintString   	# jump to function
	# PopParams 4
	  add $sp, $sp, 4	# pop params off stack
	# _tmp478 = " successfully deleted!\n"
	  .data			# create string constant marked with label
	  _string78: .asciiz " successfully deleted!\n"
	  .text
	  la $t2, _string78	# load label
	  sw $t2, -224($fp)	# spill _tmp478 from $t2 to $fp-224
	# PushParam _tmp478
	  subu $sp, $sp, 4	# decrement sp to make space for param
	  lw $t0, -224($fp)	# fill _tmp478 to $t0 from $fp-224
	  sw $t0, 4($sp)	# copy param value to stack
	# LCall _PrintString
	  jal _PrintString   	# jump to function
	# PopParams 4
	  add $sp, $sp, 4	# pop params off stack
	# LCall ____PrintLine
	  jal ____PrintLine  	# jump to function
	# Goto _L59
	  b _L59		# unconditional branch
  _L58:
	# _tmp479 = "\n"
	  .data			# create string constant marked with label
	  _string79: .asciiz "\n"
	  .text
	  la $t2, _string79	# load label
	  sw $t2, -228($fp)	# spill _tmp479 from $t2 to $fp-228
	# PushParam _tmp479
	  subu $sp, $sp, 4	# decrement sp to make space for param
	  lw $t0, -228($fp)	# fill _tmp479 to $t0 from $fp-228
	  sw $t0, 4($sp)	# copy param value to stack
	# LCall _PrintString
	  jal _PrintString   	# jump to function
	# PopParams 4
	  add $sp, $sp, 4	# pop params off stack
	# PushParam l
	  subu $sp, $sp, 4	# decrement sp to make space for param
	  lw $t0, -12($fp)	# fill l to $t0 from $fp-12
	  sw $t0, 4($sp)	# copy param value to stack
	# LCall _PrintString
	  jal _PrintString   	# jump to function
	# PopParams 4
	  add $sp, $sp, 4	# pop params off stack
	# _tmp480 = ", "
	  .data			# create string constant marked with label
	  _string80: .asciiz ", "
	  .text
	  la $t2, _string80	# load label
	  sw $t2, -232($fp)	# spill _tmp480 from $t2 to $fp-232
	# PushParam _tmp480
	  subu $sp, $sp, 4	# decrement sp to make space for param
	  lw $t0, -232($fp)	# fill _tmp480 to $t0 from $fp-232
	  sw $t0, 4($sp)	# copy param value to stack
	# LCall _PrintString
	  jal _PrintString   	# jump to function
	# PopParams 4
	  add $sp, $sp, 4	# pop params off stack
	# PushParam f
	  subu $sp, $sp, 4	# decrement sp to make space for param
	  lw $t0, -8($fp)	# fill f to $t0 from $fp-8
	  sw $t0, 4($sp)	# copy param value to stack
	# LCall _PrintString
	  jal _PrintString   	# jump to function
	# PopParams 4
	  add $sp, $sp, 4	# pop params off stack
	# _tmp481 = " not found!\n"
	  .data			# create string constant marked with label
	  _string81: .asciiz " not found!\n"
	  .text
	  la $t2, _string81	# load label
	  sw $t2, -236($fp)	# spill _tmp481 from $t2 to $fp-236
	# PushParam _tmp481
	  subu $sp, $sp, 4	# decrement sp to make space for param
	  lw $t0, -236($fp)	# fill _tmp481 to $t0 from $fp-236
	  sw $t0, 4($sp)	# copy param value to stack
	# LCall _PrintString
	  jal _PrintString   	# jump to function
	# PopParams 4
	  add $sp, $sp, 4	# pop params off stack
	# LCall ____PrintLine
	  jal ____PrintLine  	# jump to function
  _L59:
	# EndFunc
	# (below handles reaching end of fn body with no explicit return)
	  move $sp, $fp		# pop callee frame off stack
	  lw $ra, -4($fp)	# restore saved ra
	  lw $fp, 0($fp)	# restore saved fp
	  jr $ra		# return from function
	# VTable for class Database
	  .data
	  .align 2
	  Database:		# label for class Database vtable
	  .word Database.____InitDatabase
	  .word Database.____Search
	  .word Database.____PersonExists
	  .word Database.____Edit
	  .word Database.____Add
	  .word Database.____Delete
	  .text
  ____PrintHelp:
	# BeginFunc 20
	  subu $sp, $sp, 8	# decrement sp to make space to save ra, fp
	  sw $fp, 8($sp)	# save fp
	  sw $ra, 4($sp)	# save ra
	  addiu $fp, $sp, 8	# set up new fp
	  subu $sp, $sp, 20	# decrement sp to make space for locals/temps
	# LCall ____PrintLine
	  jal ____PrintLine  	# jump to function
	# _tmp482 = "List of Commands...\n\n"
	  .data			# create string constant marked with label
	  _string82: .asciiz "List of Commands...\n\n"
	  .text
	  la $t2, _string82	# load label
	  sw $t2, -8($fp)	# spill _tmp482 from $t2 to $fp-8
	# PushParam _tmp482
	  subu $sp, $sp, 4	# decrement sp to make space for param
	  lw $t0, -8($fp)	# fill _tmp482 to $t0 from $fp-8
	  sw $t0, 4($sp)	# copy param value to stack
	# LCall _PrintString
	  jal _PrintString   	# jump to function
	# PopParams 4
	  add $sp, $sp, 4	# pop params off stack
	# _tmp483 = "add - lets you add a person\n"
	  .data			# create string constant marked with label
	  _string83: .asciiz "add - lets you add a person\n"
	  .text
	  la $t2, _string83	# load label
	  sw $t2, -12($fp)	# spill _tmp483 from $t2 to $fp-12
	# PushParam _tmp483
	  subu $sp, $sp, 4	# decrement sp to make space for param
	  lw $t0, -12($fp)	# fill _tmp483 to $t0 from $fp-12
	  sw $t0, 4($sp)	# copy param value to stack
	# LCall _PrintString
	  jal _PrintString   	# jump to function
	# PopParams 4
	  add $sp, $sp, 4	# pop params off stack
	# _tmp484 = "delete - lets you delete a person\n"
	  .data			# create string constant marked with label
	  _string84: .asciiz "delete - lets you delete a person\n"
	  .text
	  la $t2, _string84	# load label
	  sw $t2, -16($fp)	# spill _tmp484 from $t2 to $fp-16
	# PushParam _tmp484
	  subu $sp, $sp, 4	# decrement sp to make space for param
	  lw $t0, -16($fp)	# fill _tmp484 to $t0 from $fp-16
	  sw $t0, 4($sp)	# copy param value to stack
	# LCall _PrintString
	  jal _PrintString   	# jump to function
	# PopParams 4
	  add $sp, $sp, 4	# pop params off stack
	# _tmp485 = "search - lets you search for a specific person\n"
	  .data			# create string constant marked with label
	  _string85: .asciiz "search - lets you search for a specific person\n"
	  .text
	  la $t2, _string85	# load label
	  sw $t2, -20($fp)	# spill _tmp485 from $t2 to $fp-20
	# PushParam _tmp485
	  subu $sp, $sp, 4	# decrement sp to make space for param
	  lw $t0, -20($fp)	# fill _tmp485 to $t0 from $fp-20
	  sw $t0, 4($sp)	# copy param value to stack
	# LCall _PrintString
	  jal _PrintString   	# jump to function
	# PopParams 4
	  add $sp, $sp, 4	# pop params off stack
	# _tmp486 = "edit - lets you edit the attributes of a specific..."
	  .data			# create string constant marked with label
	  _string86: .asciiz "edit - lets you edit the attributes of a specific person\n"
	  .text
	  la $t2, _string86	# load label
	  sw $t2, -24($fp)	# spill _tmp486 from $t2 to $fp-24
	# PushParam _tmp486
	  subu $sp, $sp, 4	# decrement sp to make space for param
	  lw $t0, -24($fp)	# fill _tmp486 to $t0 from $fp-24
	  sw $t0, 4($sp)	# copy param value to stack
	# LCall _PrintString
	  jal _PrintString   	# jump to function
	# PopParams 4
	  add $sp, $sp, 4	# pop params off stack
	# LCall ____PrintLine
	  jal ____PrintLine  	# jump to function
	# EndFunc
	# (below handles reaching end of fn body with no explicit return)
	  move $sp, $fp		# pop callee frame off stack
	  lw $ra, -4($fp)	# restore saved ra
	  lw $fp, 0($fp)	# restore saved fp
	  jr $ra		# return from function
  main:
	# BeginFunc 196
	  subu $sp, $sp, 8	# decrement sp to make space to save ra, fp
	  sw $fp, 8($sp)	# save fp
	  sw $ra, 4($sp)	# save ra
	  addiu $fp, $sp, 8	# set up new fp
	  subu $sp, $sp, 196	# decrement sp to make space for locals/temps
	# _tmp487 = 12
	  li $t2, 12		# load constant value 12 into $t2
	  sw $t2, -16($fp)	# spill _tmp487 from $t2 to $fp-16
	# _tmp488 = 4
	  li $t2, 4		# load constant value 4 into $t2
	  sw $t2, -20($fp)	# spill _tmp488 from $t2 to $fp-20
	# _tmp489 = _tmp488 + _tmp487
	  lw $t0, -20($fp)	# fill _tmp488 to $t0 from $fp-20
	  lw $t1, -16($fp)	# fill _tmp487 to $t1 from $fp-16
	  add $t2, $t0, $t1	
	  sw $t2, -24($fp)	# spill _tmp489 from $t2 to $fp-24
	# PushParam _tmp489
	  subu $sp, $sp, 4	# decrement sp to make space for param
	  lw $t0, -24($fp)	# fill _tmp489 to $t0 from $fp-24
	  sw $t0, 4($sp)	# copy param value to stack
	# _tmp490 = LCall _Alloc
	  jal _Alloc         	# jump to function
	  move $t2, $v0		# copy function return value from $v0
	  sw $t2, -28($fp)	# spill _tmp490 from $t2 to $fp-28
	# PopParams 4
	  add $sp, $sp, 4	# pop params off stack
	# _tmp491 = Database
	  la $t2, Database	# load label
	  sw $t2, -32($fp)	# spill _tmp491 from $t2 to $fp-32
	# *(_tmp490) = _tmp491
	  lw $t0, -32($fp)	# fill _tmp491 to $t0 from $fp-32
	  lw $t2, -28($fp)	# fill _tmp490 to $t2 from $fp-28
	  sw $t0, 0($t2) 	# store with offset
	# db = _tmp490
	  lw $t2, -28($fp)	# fill _tmp490 to $t2 from $fp-28
	  sw $t2, -8($fp)	# spill db from $t2 to $fp-8
	# _tmp492 = 10
	  li $t2, 10		# load constant value 10 into $t2
	  sw $t2, -36($fp)	# spill _tmp492 from $t2 to $fp-36
	# PushParam _tmp492
	  subu $sp, $sp, 4	# decrement sp to make space for param
	  lw $t0, -36($fp)	# fill _tmp492 to $t0 from $fp-36
	  sw $t0, 4($sp)	# copy param value to stack
	# PushParam db
	  subu $sp, $sp, 4	# decrement sp to make space for param
	  lw $t0, -8($fp)	# fill db to $t0 from $fp-8
	  sw $t0, 4($sp)	# copy param value to stack
	# _tmp493 = *(db)
	  lw $t0, -8($fp)	# fill db to $t0 from $fp-8
	  lw $t2, 0($t0) 	# load with offset
	  sw $t2, -40($fp)	# spill _tmp493 from $t2 to $fp-40
	# _tmp494 = *(_tmp493)
	  lw $t0, -40($fp)	# fill _tmp493 to $t0 from $fp-40
	  lw $t2, 0($t0) 	# load with offset
	  sw $t2, -44($fp)	# spill _tmp494 from $t2 to $fp-44
	# ACall _tmp494
	  lw $t0, -44($fp)	# fill _tmp494 to $t0 from $fp-44
	  jalr $t0            	# jump to function
	# PopParams 8
	  add $sp, $sp, 8	# pop params off stack
	# LCall ____PrintLine
	  jal ____PrintLine  	# jump to function
	# _tmp495 = "Welcome to PeopleSearch!\n"
	  .data			# create string constant marked with label
	  _string87: .asciiz "Welcome to PeopleSearch!\n"
	  .text
	  la $t2, _string87	# load label
	  sw $t2, -48($fp)	# spill _tmp495 from $t2 to $fp-48
	# PushParam _tmp495
	  subu $sp, $sp, 4	# decrement sp to make space for param
	  lw $t0, -48($fp)	# fill _tmp495 to $t0 from $fp-48
	  sw $t0, 4($sp)	# copy param value to stack
	# LCall _PrintString
	  jal _PrintString   	# jump to function
	# PopParams 4
	  add $sp, $sp, 4	# pop params off stack
	# LCall ____PrintLine
	  jal ____PrintLine  	# jump to function
	# _tmp496 = "\n"
	  .data			# create string constant marked with label
	  _string88: .asciiz "\n"
	  .text
	  la $t2, _string88	# load label
	  sw $t2, -52($fp)	# spill _tmp496 from $t2 to $fp-52
	# PushParam _tmp496
	  subu $sp, $sp, 4	# decrement sp to make space for param
	  lw $t0, -52($fp)	# fill _tmp496 to $t0 from $fp-52
	  sw $t0, 4($sp)	# copy param value to stack
	# LCall _PrintString
	  jal _PrintString   	# jump to function
	# PopParams 4
	  add $sp, $sp, 4	# pop params off stack
	# _tmp497 = ""
	  .data			# create string constant marked with label
	  _string89: .asciiz ""
	  .text
	  la $t2, _string89	# load label
	  sw $t2, -56($fp)	# spill _tmp497 from $t2 to $fp-56
	# input = _tmp497
	  lw $t2, -56($fp)	# fill _tmp497 to $t2 from $fp-56
	  sw $t2, -12($fp)	# spill input from $t2 to $fp-12
  _L64:
	# _tmp499 = "quit"
	  .data			# create string constant marked with label
	  _string90: .asciiz "quit"
	  .text
	  la $t2, _string90	# load label
	  sw $t2, -64($fp)	# spill _tmp499 from $t2 to $fp-64
	# PushParam _tmp499
	  subu $sp, $sp, 4	# decrement sp to make space for param
	  lw $t0, -64($fp)	# fill _tmp499 to $t0 from $fp-64
	  sw $t0, 4($sp)	# copy param value to stack
	# PushParam input
	  subu $sp, $sp, 4	# decrement sp to make space for param
	  lw $t0, -12($fp)	# fill input to $t0 from $fp-12
	  sw $t0, 4($sp)	# copy param value to stack
	# _tmp500 = LCall _StringEqual
	  jal _StringEqual   	# jump to function
	  move $t2, $v0		# copy function return value from $v0
	  sw $t2, -68($fp)	# spill _tmp500 from $t2 to $fp-68
	# PopParams 8
	  add $sp, $sp, 8	# pop params off stack
	# IfZ _tmp500 Goto _L67
	  lw $t0, -68($fp)	# fill _tmp500 to $t0 from $fp-68
	  beqz $t0, _L67	# branch if _tmp500 is zero 
	# _tmp501 = 0
	  li $t2, 0		# load constant value 0 into $t2
	  sw $t2, -72($fp)	# spill _tmp501 from $t2 to $fp-72
	# _tmp498 = _tmp501
	  lw $t2, -72($fp)	# fill _tmp501 to $t2 from $fp-72
	  sw $t2, -60($fp)	# spill _tmp498 from $t2 to $fp-60
	# Goto _L66
	  b _L66		# unconditional branch
  _L67:
	# _tmp502 = 1
	  li $t2, 1		# load constant value 1 into $t2
	  sw $t2, -76($fp)	# spill _tmp502 from $t2 to $fp-76
	# _tmp498 = _tmp502
	  lw $t2, -76($fp)	# fill _tmp502 to $t2 from $fp-76
	  sw $t2, -60($fp)	# spill _tmp498 from $t2 to $fp-60
  _L66:
	# IfZ _tmp498 Goto _L65
	  lw $t0, -60($fp)	# fill _tmp498 to $t0 from $fp-60
	  beqz $t0, _L65	# branch if _tmp498 is zero 
	# _tmp503 = "Please enter your command(type help for a list of..."
	  .data			# create string constant marked with label
	  _string91: .asciiz "Please enter your command(type help for a list of commands): "
	  .text
	  la $t2, _string91	# load label
	  sw $t2, -80($fp)	# spill _tmp503 from $t2 to $fp-80
	# PushParam _tmp503
	  subu $sp, $sp, 4	# decrement sp to make space for param
	  lw $t0, -80($fp)	# fill _tmp503 to $t0 from $fp-80
	  sw $t0, 4($sp)	# copy param value to stack
	# LCall _PrintString
	  jal _PrintString   	# jump to function
	# PopParams 4
	  add $sp, $sp, 4	# pop params off stack
	# _tmp504 = LCall _ReadLine
	  jal _ReadLine      	# jump to function
	  move $t2, $v0		# copy function return value from $v0
	  sw $t2, -84($fp)	# spill _tmp504 from $t2 to $fp-84
	# input = _tmp504
	  lw $t2, -84($fp)	# fill _tmp504 to $t2 from $fp-84
	  sw $t2, -12($fp)	# spill input from $t2 to $fp-12
	# _tmp505 = "help"
	  .data			# create string constant marked with label
	  _string92: .asciiz "help"
	  .text
	  la $t2, _string92	# load label
	  sw $t2, -88($fp)	# spill _tmp505 from $t2 to $fp-88
	# PushParam _tmp505
	  subu $sp, $sp, 4	# decrement sp to make space for param
	  lw $t0, -88($fp)	# fill _tmp505 to $t0 from $fp-88
	  sw $t0, 4($sp)	# copy param value to stack
	# PushParam input
	  subu $sp, $sp, 4	# decrement sp to make space for param
	  lw $t0, -12($fp)	# fill input to $t0 from $fp-12
	  sw $t0, 4($sp)	# copy param value to stack
	# _tmp506 = LCall _StringEqual
	  jal _StringEqual   	# jump to function
	  move $t2, $v0		# copy function return value from $v0
	  sw $t2, -92($fp)	# spill _tmp506 from $t2 to $fp-92
	# PopParams 8
	  add $sp, $sp, 8	# pop params off stack
	# IfZ _tmp506 Goto _L68
	  lw $t0, -92($fp)	# fill _tmp506 to $t0 from $fp-92
	  beqz $t0, _L68	# branch if _tmp506 is zero 
	# LCall ____PrintHelp
	  jal ____PrintHelp  	# jump to function
	# Goto _L69
	  b _L69		# unconditional branch
  _L68:
  _L69:
	# _tmp507 = "search"
	  .data			# create string constant marked with label
	  _string93: .asciiz "search"
	  .text
	  la $t2, _string93	# load label
	  sw $t2, -96($fp)	# spill _tmp507 from $t2 to $fp-96
	# PushParam _tmp507
	  subu $sp, $sp, 4	# decrement sp to make space for param
	  lw $t0, -96($fp)	# fill _tmp507 to $t0 from $fp-96
	  sw $t0, 4($sp)	# copy param value to stack
	# PushParam input
	  subu $sp, $sp, 4	# decrement sp to make space for param
	  lw $t0, -12($fp)	# fill input to $t0 from $fp-12
	  sw $t0, 4($sp)	# copy param value to stack
	# _tmp508 = LCall _StringEqual
	  jal _StringEqual   	# jump to function
	  move $t2, $v0		# copy function return value from $v0
	  sw $t2, -100($fp)	# spill _tmp508 from $t2 to $fp-100
	# PopParams 8
	  add $sp, $sp, 8	# pop params off stack
	# IfZ _tmp508 Goto _L70
	  lw $t0, -100($fp)	# fill _tmp508 to $t0 from $fp-100
	  beqz $t0, _L70	# branch if _tmp508 is zero 
	# PushParam db
	  subu $sp, $sp, 4	# decrement sp to make space for param
	  lw $t0, -8($fp)	# fill db to $t0 from $fp-8
	  sw $t0, 4($sp)	# copy param value to stack
	# _tmp509 = *(db)
	  lw $t0, -8($fp)	# fill db to $t0 from $fp-8
	  lw $t2, 0($t0) 	# load with offset
	  sw $t2, -104($fp)	# spill _tmp509 from $t2 to $fp-104
	# _tmp510 = *(_tmp509 + 4)
	  lw $t0, -104($fp)	# fill _tmp509 to $t0 from $fp-104
	  lw $t2, 4($t0) 	# load with offset
	  sw $t2, -108($fp)	# spill _tmp510 from $t2 to $fp-108
	# ACall _tmp510
	  lw $t0, -108($fp)	# fill _tmp510 to $t0 from $fp-108
	  jalr $t0            	# jump to function
	# PopParams 4
	  add $sp, $sp, 4	# pop params off stack
	# Goto _L71
	  b _L71		# unconditional branch
  _L70:
  _L71:
	# _tmp511 = "add"
	  .data			# create string constant marked with label
	  _string94: .asciiz "add"
	  .text
	  la $t2, _string94	# load label
	  sw $t2, -112($fp)	# spill _tmp511 from $t2 to $fp-112
	# PushParam _tmp511
	  subu $sp, $sp, 4	# decrement sp to make space for param
	  lw $t0, -112($fp)	# fill _tmp511 to $t0 from $fp-112
	  sw $t0, 4($sp)	# copy param value to stack
	# PushParam input
	  subu $sp, $sp, 4	# decrement sp to make space for param
	  lw $t0, -12($fp)	# fill input to $t0 from $fp-12
	  sw $t0, 4($sp)	# copy param value to stack
	# _tmp512 = LCall _StringEqual
	  jal _StringEqual   	# jump to function
	  move $t2, $v0		# copy function return value from $v0
	  sw $t2, -116($fp)	# spill _tmp512 from $t2 to $fp-116
	# PopParams 8
	  add $sp, $sp, 8	# pop params off stack
	# IfZ _tmp512 Goto _L72
	  lw $t0, -116($fp)	# fill _tmp512 to $t0 from $fp-116
	  beqz $t0, _L72	# branch if _tmp512 is zero 
	# PushParam db
	  subu $sp, $sp, 4	# decrement sp to make space for param
	  lw $t0, -8($fp)	# fill db to $t0 from $fp-8
	  sw $t0, 4($sp)	# copy param value to stack
	# _tmp513 = *(db)
	  lw $t0, -8($fp)	# fill db to $t0 from $fp-8
	  lw $t2, 0($t0) 	# load with offset
	  sw $t2, -120($fp)	# spill _tmp513 from $t2 to $fp-120
	# _tmp514 = *(_tmp513 + 16)
	  lw $t0, -120($fp)	# fill _tmp513 to $t0 from $fp-120
	  lw $t2, 16($t0) 	# load with offset
	  sw $t2, -124($fp)	# spill _tmp514 from $t2 to $fp-124
	# ACall _tmp514
	  lw $t0, -124($fp)	# fill _tmp514 to $t0 from $fp-124
	  jalr $t0            	# jump to function
	# PopParams 4
	  add $sp, $sp, 4	# pop params off stack
	# Goto _L73
	  b _L73		# unconditional branch
  _L72:
  _L73:
	# _tmp515 = "delete"
	  .data			# create string constant marked with label
	  _string95: .asciiz "delete"
	  .text
	  la $t2, _string95	# load label
	  sw $t2, -128($fp)	# spill _tmp515 from $t2 to $fp-128
	# PushParam _tmp515
	  subu $sp, $sp, 4	# decrement sp to make space for param
	  lw $t0, -128($fp)	# fill _tmp515 to $t0 from $fp-128
	  sw $t0, 4($sp)	# copy param value to stack
	# PushParam input
	  subu $sp, $sp, 4	# decrement sp to make space for param
	  lw $t0, -12($fp)	# fill input to $t0 from $fp-12
	  sw $t0, 4($sp)	# copy param value to stack
	# _tmp516 = LCall _StringEqual
	  jal _StringEqual   	# jump to function
	  move $t2, $v0		# copy function return value from $v0
	  sw $t2, -132($fp)	# spill _tmp516 from $t2 to $fp-132
	# PopParams 8
	  add $sp, $sp, 8	# pop params off stack
	# IfZ _tmp516 Goto _L74
	  lw $t0, -132($fp)	# fill _tmp516 to $t0 from $fp-132
	  beqz $t0, _L74	# branch if _tmp516 is zero 
	# PushParam db
	  subu $sp, $sp, 4	# decrement sp to make space for param
	  lw $t0, -8($fp)	# fill db to $t0 from $fp-8
	  sw $t0, 4($sp)	# copy param value to stack
	# _tmp517 = *(db)
	  lw $t0, -8($fp)	# fill db to $t0 from $fp-8
	  lw $t2, 0($t0) 	# load with offset
	  sw $t2, -136($fp)	# spill _tmp517 from $t2 to $fp-136
	# _tmp518 = *(_tmp517 + 20)
	  lw $t0, -136($fp)	# fill _tmp517 to $t0 from $fp-136
	  lw $t2, 20($t0) 	# load with offset
	  sw $t2, -140($fp)	# spill _tmp518 from $t2 to $fp-140
	# ACall _tmp518
	  lw $t0, -140($fp)	# fill _tmp518 to $t0 from $fp-140
	  jalr $t0            	# jump to function
	# PopParams 4
	  add $sp, $sp, 4	# pop params off stack
	# Goto _L75
	  b _L75		# unconditional branch
  _L74:
  _L75:
	# _tmp519 = "edit"
	  .data			# create string constant marked with label
	  _string96: .asciiz "edit"
	  .text
	  la $t2, _string96	# load label
	  sw $t2, -144($fp)	# spill _tmp519 from $t2 to $fp-144
	# PushParam _tmp519
	  subu $sp, $sp, 4	# decrement sp to make space for param
	  lw $t0, -144($fp)	# fill _tmp519 to $t0 from $fp-144
	  sw $t0, 4($sp)	# copy param value to stack
	# PushParam input
	  subu $sp, $sp, 4	# decrement sp to make space for param
	  lw $t0, -12($fp)	# fill input to $t0 from $fp-12
	  sw $t0, 4($sp)	# copy param value to stack
	# _tmp520 = LCall _StringEqual
	  jal _StringEqual   	# jump to function
	  move $t2, $v0		# copy function return value from $v0
	  sw $t2, -148($fp)	# spill _tmp520 from $t2 to $fp-148
	# PopParams 8
	  add $sp, $sp, 8	# pop params off stack
	# IfZ _tmp520 Goto _L76
	  lw $t0, -148($fp)	# fill _tmp520 to $t0 from $fp-148
	  beqz $t0, _L76	# branch if _tmp520 is zero 
	# PushParam db
	  subu $sp, $sp, 4	# decrement sp to make space for param
	  lw $t0, -8($fp)	# fill db to $t0 from $fp-8
	  sw $t0, 4($sp)	# copy param value to stack
	# _tmp521 = *(db)
	  lw $t0, -8($fp)	# fill db to $t0 from $fp-8
	  lw $t2, 0($t0) 	# load with offset
	  sw $t2, -152($fp)	# spill _tmp521 from $t2 to $fp-152
	# _tmp522 = *(_tmp521 + 12)
	  lw $t0, -152($fp)	# fill _tmp521 to $t0 from $fp-152
	  lw $t2, 12($t0) 	# load with offset
	  sw $t2, -156($fp)	# spill _tmp522 from $t2 to $fp-156
	# ACall _tmp522
	  lw $t0, -156($fp)	# fill _tmp522 to $t0 from $fp-156
	  jalr $t0            	# jump to function
	# PopParams 4
	  add $sp, $sp, 4	# pop params off stack
	# Goto _L77
	  b _L77		# unconditional branch
  _L76:
  _L77:
	# Goto _L64
	  b _L64		# unconditional branch
  _L65:
	# EndFunc
	# (below handles reaching end of fn body with no explicit return)
	  move $sp, $fp		# pop callee frame off stack
	  lw $ra, -4($fp)	# restore saved ra
	  lw $fp, 0($fp)	# restore saved fp
	  jr $ra		# return from function
