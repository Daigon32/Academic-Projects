.data
prompt: .asciiz "Enter a hexadecimal value.\n"
invalid_digit: .asciiz "Invalid hex digit: "
too_many_digits: .asciiz "More than 8 hex digits entered.\n"
output: .asciiz "The hexadecimal number entered is the decimal value: "

hex_input: .space 10  # Space for the hex input (9 + null terminator)

.text
.globl main

main:
    # Print prompt
    li $v0, 4
    la $a0, prompt
    syscall
    
    # Read input
    li $v0, 8        # syscall for reading a string
    la $a0, hex_input
    li $a1, 10      # maximum bytes to read
    syscall

    # Check for more than 8 hex digits
    la $t0, hex_input
    li $t1, 0       # Counter for length
check_length:
    lb $t2, 0($t0)
    beqz $t2, convert_hex # If null terminator is reached, go to conversion
    addi $t1, $t1, 1
    addi $t0, $t0, 1
    bne $t1, 9, check_length

    # If more than 8, print error
    li $v0, 4
    la $a0, too_many_digits
    syscall
    j exit

convert_hex:
    li $t1, 0       # Reset decimal value
    li $t3, 0       # Index for hex input
convert_loop:
    lb $t2, hex_input($t3)
    beqz $t2, print_decimal # End of string

    # Validate hex digit
    li $t4, '0'
    li $t5, '9'
    blt $t2, $t4, invalid_hex
    bgt $t2, $t5, check_a_f

    # Convert '0' - '9' to int
    subu $t2, $t2, $t4 # Now $t2 has the int value
    j shift_value

check_a_f:
    li $t4, 'a'
    li $t5, 'f'
    blt $t2, $t4, invalid_hex
    bgt $t2, $t5, invalid_hex

    # Convert 'a' - 'f' to int
    subu $t2, $t2, $t4 # Now $t2 has the value from 0-5
    addi $t2, $t2, 10   # Convert to 10-15
    j shift_value

invalid_hex:
    # Print invalid digit message
    li $v0, 4
    la $a0, invalid_digit
    syscall
    move $a0, $t2
    li $v0, 11        # Print character syscall
    syscall
    j exit

shift_value:
    # Decimal value = (decimal_value << 4) | new_value
    sll $t1, $t1, 4    # Shift left by 4
    or $t1, $t1, $t2   # Add new value
    addi $t3, $t3, 1
    j convert_loop

print_decimal:
    # Print output string
    li $v0, 4
    la $a0, output
    syscall

    # Print decimal value
    move $a0, $t1
    li $v0, 1         # Print integer syscall
    syscall

exit:
    li $v0, 10        # Exit syscall
    syscall
