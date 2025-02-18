# Signed Integer Sum and Average Calculator

This program takes 10 signed integer inputs from the user, validates them, and then calculates and displays their sum and average. The user is prompted to enter each integer one at a time, with validation to ensure that each input is a valid signed integer and fits within a 32-bit register. If the user inputs invalid data (such as a non-numeric value or a number too large), an error message is displayed, and the user is prompted to enter a valid number.

After the 10 integers are entered, the program will display:
- The list of integers entered.
- The sum of those integers.
- The truncated average of those integers.

## Features
- **Input Validation**: Ensures that each entered number is a valid signed integer and fits within a 32-bit register.
- **Sum and Average Calculation**: After the user inputs all the integers, the program calculates and displays the sum and average.
- **User-friendly Interface**: Prompts the user for each integer and displays helpful messages, including error handling for invalid input.

## Instructions
1. **Enter 10 signed integers**: The program will prompt you to enter a signed number one at a time.
2. **Error handling**: If you enter an invalid number (non-numeric value or number too large for a 32-bit register), an error message will appear, and you'll be asked to enter a valid number.
3. **Results**: After you've entered all 10 numbers, the program will display the list of numbers, the sum, and the average.

## Example Output
Signed Integer Sum and Average Calculator

Please enter 10 signed integers. Each number must fit in a 32-bit register.

Please enter a signed number: 10 Please enter a signed number: -5 Please enter a signed number: 23 Please enter a signed number: -12 Please enter a signed number: 50 Please enter a signed number: -2 Please enter a signed number: 19 Please enter a signed number: 30 Please enter a signed number: 4 Please enter a signed number: -8

You entered the following numbers: 10, -5, 23, -12, 50, -2, 19, 30, 4, -8

The sum of these numbers is: 109 The truncated average is: 10

## Requirements
- **Assembler**: The program is written in assembly language for the 32-bit x86 architecture.
- **Irvine32 Library**: The program uses the Irvine32 library for I/O operations.

