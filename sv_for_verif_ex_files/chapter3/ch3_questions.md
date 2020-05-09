## Answers to Exercises 3.9

 1. Create the SystemVerilog code with the following requirements:
a. Create a 512 element integer array
b. Create a 9-bit address variable to index into the array
c. Initialize the last location in the array to 5
d. Call a task, `my_task()` , and pass the array and the address
e. Create `my_task()` that takes two inputs: a constant 512-element integer array passed by reference, and a 9-bit address. The task calls a function, `print_int()` , and passes the array element indexed by the address, pre-decrementing the address.
f. Create `print_int()` that prints out the simulation time and the value of the input. The function has no return value.

2. For the following SystemVerilog code, what is displayed if the task `my_task2()` is automatic?

3. For the same SystemVerilog code in Exercise 2, what is displayed if the task `my_task2()` is not automatic?

4. Create the SystemVerilog code to specify that the time should be printed in ps (picoseconds), display 2 digits to the right of the decimal point, and use as few characters as possible.

5. Using the formatting system task from Exercise 4, what is displayed by the following code?

> SystemVerilog for Verification,  Ed. 3, C. Spear, G. Tumbush 
> (c) Springer Science+Business Media, LLC 2012
