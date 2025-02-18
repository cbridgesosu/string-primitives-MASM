TITLE Signed Integer Sum and Average Calculator     (string-primitives.asm)

; Author: Chris Bridges
; Last Modified: 8/7/2023
; Description: Program that requests 10 signed integer inputs from the user. If the integer doesn't fit in a 32 bit register or there are 
;				non-numeric symbols excluding a leading negative or positive sign, an error message is returned. After all inputs,
;				the program returns a list of the numbers, the sum, and the average.

INCLUDE Irvine32.inc

;------------------------------------------------------------------------------------------
;   Name: mGetString
;
;   Retrieves user input array from console.
;
;   Preconditions: input array buffer must be at least 15 bytes
;   
;   Receives:
;   prompt = array address for user prompt
;   input = array address to store user input
;   input_count = user input array length
;
;   Returns: input = user input string address
;------------------------------------------------------------------------------------------
mGetString MACRO prompt, input, input_count
    pushad

    ; display user prompt
    mov	  edx, prompt
    call	  WriteString

    ; retrieve user input
    mov	  edx, input
    mov     ecx, 15
    call	  ReadString
    mov	  [input_count], eax

    popad
ENDM

;------------------------------------------------------------------------------------------
;   Name: mDisplayString
;
;   Writes a string array to the console.
;
;   Preconditions: none
;   
;   Receives: output = array address of string to print
;
;   Returns: output printed to console
;------------------------------------------------------------------------------------------
mDisplayString MACRO output
    push	  edx

    ; display output
    mov	  edx, output
    call	  WriteString

    pop	  edx
ENDM

.data

    ecred_1		BYTE	   "**EC: Numbers each line of user input and displays running subtotal.",10,13,0
    ecred_2		BYTE	   "**EC: Implemented ReadFloatVal and WriteFloatVal procedures for floating point values.",13,10,0

    intro			BYTE    "Signed Integer Sum and Average Calculator		 by Chris Bridges",0
    instructions	BYTE	   "Please input 10 signed integers. Each number must fit in a 32 bit register.",10,13
				BYTE	   "After you have finished inputing the raw integers, I will display a list of the integers, the sum, and the average.",13,10,13,10,0
    prompt1		BYTE    "Please enter a signed number: ",0
    print_list		BYTE    "You entered the following numbers: ",13,10,0
    print_sum		BYTE    "The sum of these numbers is: ",0
    new_line		BYTE    13,10,13,10,0
    print_avg		BYTE    "The truncated average is: ",0
    outro			BYTE    "Thank you for using this program.",0
    invalid		BYTE    "ERROR: You did not enter a signed integer or your number was too big.",13,10,0
    current_sum	BYTE    ".) Current sum is: ",0
    spacer		BYTE    9,9,0
    prompt2		BYTE	   "Please enter 10 floating point numbers. After you have finished I will display a list of the floating point input.",13,10,0
    invalid_float	BYTE	   "ERROR: You did not enter a float.",13,10,0

    user_num		SDWORD  50 DUP (?)
    output_num		BYTE    15 DUP (?)
    num_count		DWORD   ?
    num_array		SDWORD  50 DUP(?)
    comma			BYTE    ", ",0
    running_sum	SDWORD  ?
    average		SDWORD  ?

    float_array	REAL4   11 DUP(?)
    radix			BYTE	   ".",0
    negative		BYTE	   "-",0

.code
main PROC
    ;display intro, instructions, and extra credit description
    mDisplayString	OFFSET  intro
    mDisplayString	OFFSET  new_line
    mDisplayString	OFFSET  ecred_1
    mDisplayString	OFFSET  ecred_2
    mDisplayString	OFFSET  new_line
    mDisplayString	OFFSET  instructions

    ; gets user integer input
    mov	  ecx, 10  ; user input count
    mov	  edi, OFFSET num_array
    mov	  ebx, 1	;input counter initialzed to 1

    ; ec-1 - displays first line label and running sum 
    push	  OFFSET output_num
    push	  ebx
    call	  WriteVal
    inc	  ebx
    mDisplayString	OFFSET current_sum
    push	  OFFSET output_num
    push	  running_sum
    call	  WriteVal
    mDisplayString	OFFSET spacer

    ; gets and validates user input
_get_num:
    push	  OFFSET invalid
    push	  OFFSET running_sum
    push	  OFFSET num_count
    push	  OFFSET user_num
    push	  OFFSET prompt1
    call	  ReadVal

    ; ec-1 - displays line number and running sum
    cmp	  ecx, 1
    je	  _last_sum ; jumps if final intenger input
    push	  OFFSET output_num
    push	  ebx
    call	  WriteVal
    inc	  ebx
    mDisplayString	OFFSET current_sum
    ; retrieves user input
    push	  OFFSET output_num
    push	  running_sum
    call	  WriteVal
    mDisplayString	OFFSET spacer
_last_sum:
    ; stores current user input
    mov	  eax, user_num
    stosd
    loop	  _get_num

    ; displays description of integer list 
    mDisplayString OFFSET new_line
    mDisplayString OFFSET print_list

    ; displays list of integers
    mov	  ecx, 10
    mov	  esi, OFFSET num_array
_print_num:
    lodsd
    push	  OFFSET output_num
    push	  eax
    call	  WriteVal
    cmp	  ecx, 1
    je	  _last_num		  ; checks for last number printed to skip comma+space
    mDisplayString OFFSET comma
_last_num:
    loop _print_num


    ; displays sum of user input
    mDisplayString OFFSET new_line
    mDisplayString OFFSET print_sum
    push	  OFFSET output_num
    push	  running_sum
    call	  WriteVal

    ;display the truncated average
    mDisplayString OFFSET new_line
    mDisplayString OFFSET print_avg
    mov	  ebx, 10
    mov	  eax, running_sum
    cdq
    idiv	  ebx
    mov	  average, eax
    push	  OFFSET output_num
    push	  average
    call	  WriteVal


    ;display prompt for floating point numbers
    mDisplayString OFFSET new_line
    mDisplayString OFFSET prompt2

    ; get and validate user input floating point numbers
    mov	  ecx, 10  ; nums to enter
    mov	  edi, OFFSET float_array
_get_float:
    push	  OFFSET invalid_float
    push	  OFFSET num_count
    push	  OFFSET user_num
    push	  OFFSET prompt1
    call	  ReadFloatVal
    ; stores current user input
    mov	  eax, user_num
    stosd
    loop	  _get_float

    ; display description of float list
    mDisplayString OFFSET new_line
    mDisplayString OFFSET print_list

    ; displays list of floats
    mov	  ecx, 10
    mov	  esi, OFFSET float_array
_print_float:
    lodsd
    push    OFFSET output_num
    push	  OFFSET radix
    push	  OFFSET negative
    push	  eax
    call	  WriteFloatVal
    cmp	  ecx, 1
    je	  _last_float		  ; checks for last number printed to skip comma+space
    mDisplayString OFFSET comma
_last_float:
    loop _print_float
    
    ; display goodbye message
    mDisplayString OFFSET new_line
    mDisplayString OFFSET outro

	Invoke ExitProcess,0	; exit to operating system
main ENDP


;------------------------------------------------------------------------------------------
;   Name: ReadVal
;
;   Retrieves user input array from console, converts it from ascii to an integer, and stores it in an array.
;
;   Preconditions: user input array must be at least 15 bytes
;				input length counter must be dword
;				running sum accumulator must be sdword
;
;   Postconditions: none
;   
;   Receives:
;   [ebp + 24] = array address for invalid input error message
;   [ebp + 20] = address of running sum accumulator
;   [ebp + 16] = address of user input length counter
;   [ebp + 12] = array address of user input 
;   [ebp + 8] = array address of string for user input prompt
;
;   Returns: [ebp + 12] = user input converted integer 
;------------------------------------------------------------------------------------------
ReadVal PROC
    push	  ebp
    mov	  ebp, esp
    pushad

_start:
    ; gets user input 
    mGetString [ebp+ 8], [ebp + 12], [ebp + 16] 

    ; initialize ecx with length of string input and set string source array
    mov	  ecx, [ebp + 16]
    mov	  esi, [ebp + 12]
    cld

    ; intialize edx as 0 for conversion accumulator 
    mov	  edx, 0
    push	  edx
 
    ; converts string input to integer 
_add_digit:
    mov	  eax, 0
    lodsb	 
    ; checks for +/- sign as first digit
    pop	  edx
    cmp	  al, "-"
    je	  _skip_sign
    cmp	  al, "+"
    je	  _skip_sign
    ; checks for non numerical input
    cmp	  al, "0"
    jl	  _invalid
    cmp	  al, "9"
    jg	  _invalid
    push	  edx
    ; converts ascii integers to decimal integers
    sub	  al, 48
    pop	  edx
    push	  eax
    ; increments integer by factor of 10 
    mov	  eax, edx
    mov	  ebx, 10
    mov	  edx, 0
    mul	  ebx
    jo	  _high_num
    ; adds next digit to accumulator 
    mov	  edx, eax
    pop	  eax
    add	  edx, eax
_skip_sign:
    push	  edx
    loop	  _add_digit
    pop	  edx

    ; negates negative numbers
    mov	  eax, [ebp + 12]
    mov	  bl, [eax]
    cmp	  bl, "-"
    jne	  _not_negative

    ; checks for negative integer too large for 32 bits
    cmp	  edx, 2147483648
    ja	  _invalid
    ; negates integer for negative input
    neg	  edx
    jmp	  _add_sum

_not_negative:
    ; checks for positive integer too large for 32 bits
    cmp	  edx, 2147483647
    ja	  _invalid

_add_sum:
    ; add input to running sum
    mov	  ebx, [ebp + 20]
    mov	  eax, [ebx]
    add	  eax, edx
    mov	  [ebx], eax
    mov	  esi, [ebp + 12]
    mov	  [esi], edx
    jmp	  _terminate

    ; clears stack for reprompt on too large input
_high_num:
    pop eax

    ; displays error message for invalid input and reprompts user
_invalid:
    mov	  edx, [ebp + 24]
    call	  WriteString
    jmp	  _start

_terminate:

    popad
    pop	  ebp
    ret	  20
ReadVal ENDP

;------------------------------------------------------------------------------------------
;   Name: WriteVal
;
;   Converts integer to ascii and displays it in the console window.
;
;   Preconditions: integer to display must be size SDWORD
;
;   Postconditions: none
;   
;   Receives:
;   [ebp + 12] = array address of number display string
;   [ebp + 8] = integer value to be printed
;
;   Returns: [ebp + 12] = number display string printed to console window
;------------------------------------------------------------------------------------------
WriteVal PROC
    push	  ebp
    mov	  ebp, esp
    pushad

    mov	  ecx, 0			 ; initialize ecx as 0 for integer count
    mov	  edi, [ebp + 12]    ; set edi as storage array

    ; check for positive and negative integers
    mov	  eax, [ebp + 8]
    cmp	  eax, 0
    jns	  _positive
    push	  eax
    mov	  al, "-" ; move negative sign to array for negative numbers
    stosb	  
    pop	  eax
    neg	  eax
_positive:
    ; convert integer to ascii
    mov	  edx, 0
    mov	  ebx, 10
    div	  ebx
    add	  edx, 48
    ; stores digits in stack
    push edx
    inc ecx
    cmp	  eax, 0
    jne	  _positive ; jumps if all digits in integer have been converted

    ; pops all stored digits from stack and adds to print string array
_add_array:
    pop	  eax
    stosb	  
    loop	  _add_array

    mDisplayString [ebp +12]	  ; prints integer string to console

    ; clears out print storage array
    mov	  edi, [ebp + 12]
    mov	  ecx, 15
    mov	  al, 0
_clear_array:
    stosb
    loop _clear_array

    popad
    pop	  ebp
    ret	  8
WriteVal ENDP

;------------------------------------------------------------------------------------------
;   Name: ReadFloatVal
;
;   Retrieves user input array from console, converts it from ascii to an float, and stores it in an array.
;
;   Preconditions: user input array must be at least 15 bytes
;				input length counter must be dword
;
;   Postconditions: none
;   
;   Receives:
;   [ebp + 20] = array address for invalid input error message
;   [ebp + 16] = address of user input length counter
;   [ebp + 12] = array address of user input 
;   [ebp + 8] = array address of string for user input prompt
;
;   Returns: [ebp + 12] = user input converted integer 
;------------------------------------------------------------------------------------------
ReadFloatVal PROC
    LOCAL	  float_integer:REAL4, float_decimal:DWORD, dec_count:DWORD, is_neg:BYTE, out_num:SDWORD
    pushad

    mov	  dec_count, 0  ; initialize decimal count as 0

_start:

    mGetString [ebp+ 8], [ebp + 12], [ebp + 16] 

    mov	  ecx, [ebp + 16] ; initialize ecx as input length for loop
    mov	  esi, [ebp + 12] ; set esi as source for string array
    mov	  ebx, [esi]
    mov	  is_neg, bl ; stores first array byte in negative check
    cld

    ; converts string to integer portion of float value
    mov	  edx, 0
    push	  edx
_add_digit:
    mov	  eax, 0
    lodsb	 
    ; skips first input byte if it's a sign
    pop	  edx
    cmp	  al, "-"
    je	  _skip_sign
    cmp	  al, "+"
    je	  _skip_sign
    ;checks for radix
    cmp	  al, "."
    je	  _calc_decimal ; jumps to decimal calulation if radix input
    ; checks for invalid non-numeric input
    cmp	  al, "0"
    jl	  _invalid
    cmp	  al, "9"
    jg	  _invalid
    push	  edx
    ; converts ascii to integer value
    sub	  al, 48
    pop	  edx
    push	  eax
    ; increments digits by value of 10
    mov	  eax, edx
    mov	  ebx, 10
    mov	  edx, 0
    mul	  ebx
    ; adds current digit to total integer value
    mov	  edx, eax
    pop	  eax
    add	  edx, eax
_skip_sign:
    push	  edx
    loop	  _add_digit

    pop	  edx
    jmp	  _invalid ; jumps to invalid input if no radix input

_high_num:
    pop eax

    ; displays error message for invalid float input
_invalid:
    mov	  edx, [ebp + 20]
    call	  WriteString
    jmp	  _start

_calc_decimal:
    ; stores integer value as a float 
    mov	  float_integer, edx
    finit
    fild	  float_integer
    fst	  float_integer

    mov	  edx, 0  ; initialize edx as 0 for float accumulator
    dec	  ecx	; dec ecx loop to account for radix

    push	  edx
_add_decimal:
    mov	  eax, 0
    lodsb	 
    pop	  edx
    ; checks for non numerical input
    cmp	  al, "0"
    jl	  _invalid
    cmp	  al, "9"
    jg	  _invalid
    push	  edx
    ; converts ascii to integer
    sub	  al, 48
    pop	  edx
    push	  eax
    ; increments decimal integer by factor of 10
    mov	  eax, edx
    mov	  ebx, 10
    mov	  edx, 0
    mul	  ebx
    ; adds current digit to decimal integer
    mov	  edx, eax
    pop	  eax
    add	  edx, eax
    push	  edx
    inc	  dec_count ;adds 1 to decimal counter
    loop	  _add_decimal
    pop	  edx
    mov	  float_decimal, edx

    ; converts decimal integer to decimal value
    mov	  ecx, dec_count
    mov	  eax, 1 ; changed from 10
_decimal_factor:
    mov	  ebx, 10
    mul	  ebx
    loop	  _decimal_factor
    mov	  dec_count, eax
    finit	  
    fild	  float_decimal
    fild	  dec_count
    fdiv
    fst	  float_decimal

    ; adds float whole number and float decimal value
_terminate:
    finit
    fld	  float_integer
    fld	  float_decimal
    fadd
    fst	  out_num

    ; negates negative numbers
    cmp	  is_neg, "-"
    jne	  _not_negative_float
    finit
    fld	  out_num
    fchs
    fst	  out_num

_not_negative_float:
    ; stores float value in output 
    mov	  eax, [ebp + 12]
    mov	  ebx, [out_num]
    mov	  [eax], ebx

    popad
    ret	  16
ReadFloatVal ENDP

;------------------------------------------------------------------------------------------
;   Name: WriteFloatVal
;
;   Converts float to ascii and displays it in the console window.
;
;   Preconditions: float to convert must be size REAL4
;
;   Postconditions: none
;   
;   Receives:
;   [ebp + 20] = array address for number display string
;   [ebp + 16] = array address of radix string
;   [ebp + 12] = array address of negative sign string
;   [ebp + 8] = float value to be displayed
;
;   Returns: [ebp + 12] = float display string printed to console window
;------------------------------------------------------------------------------------------
WriteFloatVal PROC
    LOCAL	  float_num:REAL4, num10:DWORD, num100:DWORD, integer:DWORD, dec_count:DWORD, dec_num:DWORD
    pushad

    mov	  num10, 10	    ; sets num factor to 10
    mov	  num100, 100   ; sets num factor to 100
    mov	  dec_count, 100000000  ; sets decimal control factor to 8 digits

    ; move float to br printed from stack to eax
    mov	  ebx, [ebp + 8]
    mov	  float_num, ebx
    mov	  eax, float_num

    mov	  ecx, 1 ; initialize ecx to 1 as a digit counter

    ; calculates the integer portions of a float to display
    finit
    fld	  float_num
_divide:
    cmp	  dec_num, 0
    jle	  _skip
    inc	  ecx
    fild	  num10
    fdiv
    fist	  dec_num
    mov	  eax, dec_num
    jmp	  _divide
    finit
    fld	  float_num
    fild	  num100
    fmul
_skip:
    fild	  num10
    fmul
    fist	  dec_num
    mov	  eax, dec_num
    cdq
    idiv	  num10
    loop	  _skip

    ; displays negative sign for negative floats
    cmp	  eax, 0
    jne	  _nonzeroPositive
    cmp	  float_num, 0
    jg	  _nonzeroPositive
    mDisplayString [ebp + 12]  ;display negative sign

    ; displays the integer portion of float to console 
_nonzeroPositive:
    push	  [ebp + 20]
    push	  eax
    call	  WriteVal

    mov	  integer, eax

    ; clears out print storage array
    mov	  edi, [ebp + 20]
    mov	  ecx, 15
    mov	  al, 0
_clear_array:
    stosb
    loop _clear_array

    mDisplayString [ebp + 16] ; displays radix for float

    ; calculates decimal portion of float to display
    finit
    fld	  float_num
    fild	  integer
    fsub
    fild	  dec_count
    fmul	  
    fist	  integer
    mov	  eax, integer
    cmp	  eax, 0
    jg	  _positive
    neg	  eax
    mov	  integer, eax

    ; prints leading 0's for float decimal
_positive:
    mov	  eax, 9999999
_leading_zeros:
    cmp	  integer, eax
    jge	  _no_leading_zeros
    mov	  edx, 0
    push	  [ebp + 20]
    push	  edx
    call	  WriteVal
    mov	  ebx, 10
    div	  ebx
    jmp _leading_zeros

    ; prints decimal portion of float
_no_leading_zeros:
    push	  [ebp + 20]
    push	  integer
    call	  WriteVal

    popad
    ret	  16
WriteFloatVal ENDP

END main



