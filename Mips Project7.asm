# ------------------------------------------------------
#
# Mips Project7.asm
#
# CDA 3101
# Enrique Kinsey
# Project7
#
# ------------------------------------------------------
.text                   # beginning of code
.globl main             # notice the spelling
	
   main:
      Start:
      li  $v0, 4        # Print the string stored in the oldBase variable
      la  $a0, oldBase      
      syscall          
      
      li  $v0, 5       
      syscall      
      sw $v0, inputOldBase
      
      lw  $a0, inputOldBase
      jal ReadIntAnyBase
      
      li  $v0, 4        # Print the string stored in the newBase variable
      la  $a0, newBase      
      syscall      
      
      li  $v0, 5       
      syscall      
      sw $v0, inputNewBase
        
      la  $a0, inputNewBase
      move $a1, $s5
      jal PrintIntAnyBase
      
      OnError:
      li  $v0, 4        # Print the string stored in the convertMore variable
      la  $a0, convertMore      
      syscall      
      
      li  $v0, 8       
      la  $a0, inputConvertMore
      li  $a1, 3
      syscall    
      
      lb $t0, inputConvertMore($zero)
      beq $t0, 'y', Start

      li  $v0, 10       # service 10, terminate
      syscall           # call the OS
      
 #Functions----------------------------------------------------------------------------     
 
      ErrorTest:
      bge $a3, $s4 PrintError	#s3 = current character converted to an integer
      jr $ra
      
      PrintError:
      li  $v0, 4        # Print the string stored in the convertMore variable
      la  $a0, errorInvalidEntry      
      syscall
      j OnError
      
      ReadIntAnyBase:
      move $s4, $a0	#$s4 = old base
      
      li  $v0, 4        # Print the string stored in the numToBeConverted variable
      la  $a0, numToBeConverted      
      syscall     
      
      li  $v0, 8       # Gets the number to be converted
      la  $a0, inputNumToBeConverted
      li  $a1, 34
      syscall  
         
      li $t0, 0
      move $s6, $ra	#s6 = return address      
      li $s5, 0		#s5 = total integer
      j StartConverting
      Convert:			#Converts the string in the old base to an integer
      mul $s5, $s5, $s4
      bgt $s0, 64 CharactersOverNine
      addi $s1, $s0, -48
      j Continue
      CharactersOverNine:
      addi $s1, $s0, -55
      Continue:
      move $a3, $s1	
      jal ErrorTest
      move $ra, $s6
      add $s5, $s5, $s1 
      addi $t0, $t0, 1
      StartConverting:
      lb $s0, inputNumToBeConverted($t0)
      bne $s0, '\n', Convert
      
      jr $ra
      
      PrintIntAnyBase:
      lw $s3, ($a0)	#$s3 = address of new base
      move $s2, $a1	#$s2 = the integer to be converted
      li $s1, 0		#s2 = total integer
      li $t3, 32	#starting location for final answer
      move $t5, $s2

      Loop:			#Converts the integer into a string in the new base
      div $t5, $s3
      mfhi $t2		#remainder
      mflo $t1		#quotient
      
      bgt $t2, 9 CharactersOverNineNewBase
      addi $s1, $t2, 48
      j ContinueNewBase
      CharactersOverNineNewBase:
      addi $s1, $t2, 55
      ContinueNewBase:
      sb $s1, FinalAnswerString($t3)
      addi $t3, $t3, -1

      #li  $v0, 11        # Final Answer, cept backwards -_- Print
      #move $a0, $s1
      #syscall    

      move $t5, $t1
      bnez $t1 Loop
      
      li  $v0, 4        # Print the final answer
      la  $a0, FinalAnswerString      
      syscall 
      
      jr $ra
      
# ------------------------------------------------------
.data                   # beginning of data area
   oldBase:
      .asciiz  "Enter the old base (2 - 36)       - "
      
   numToBeConverted:
      .asciiz  "\nEnter the number to be converted  - "
      
   newBase:
      .asciiz  "\nEnter the new base                - "
      
   convertMore:
      .asciiz  "\nAgain (y or n)? "
      
   inputOldBase:
      .word 0
      
   inputNumToBeConverted:
      .asciiz  "                                  "
      
   inputNewBase:
      .word 0
      
   FinalAnswerString:
      .asciiz  "                                  "
 
   inputConvertMore:
      .asciiz  "   "
      
   errorInvalidEntry:
      .asciiz  "Sorry, you have entered an invalid digit for the given base."
# ------------------------------------------------------
