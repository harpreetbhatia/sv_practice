## 6.19 Exercises

1. Write the SystemVerilog code for the following items.
* Create a class `Exercise1` containing two random variables, 8-bit `data` and 4-bit `address` . Create a constraint block that keeps `address` to 3 or 4.
* In an initial block, construct an `Exercise1` object and randomize it. Check the status from randomization.

2. Modify the solution for Exercise 1 to create a new class `Exercise2` so that:
* `data` is always equal to 5
* The probability of `address`==0 is 10%
* The probability of `address` being between [1:14] is 80%
* The probability of `address`==15 is 10%

3. Using the solution to either Exercise 1 or 2, demonstrate its usage by generating 20 new `data` and `address` values and check for success from the constraint solver.

4. Create a testbench that randomizes the `Exercise2` class 1000 times.
* Count the number of times each `address` value occurs and print the results in a histogram. Do you see an exact 10% / 80% / 10% distribution? Why or why not?
* Run the simulation with 3 different random seeds, creating histograms, and then comment on the results. Here is how to run a simulation with the seed 42.
VCS: > `simv +ntb_random_seed=42`
IUS: > `irun exercise4.sv −svseed 42`
Questa: > `vsim −sv_seed 42`

5. For the code in Sample 6.4 , describe the constraints on the `len`, `dst`, and `src` variables.

6. Complete Table 6.9 below for the following constraints.

7. For the following class, create:
* A constraint that limits read transaction addresses to the range 0 to 7, inclusive.
* Write behavioral code to turn off the above constraint. Construct and randomize a `MemTrans` object with an in-line constraint that limits read transaction addresses to the range 0 to 8, inclusive. Test that the in-line constraint is working.

8. Create a class for a graphics image that is 10x10 pixels. The value for each pixel can be randomized to black or white. Randomly generate an image that is, on average, 20% white. Print the image and report the number of pixels of each type.  

9. Create a class, `StimData`, containing an array of integer samples. Randomize the size and contents of the array, constraining the size to be between 1 and 1000. Test the constraint by generating 20 transactions and reporting the size.  

10. Expand the `Transaction` class below so back-to-back transactions of the same type do not have the same address. Test the constraint by generating 20 transactions.  

11. Expand the `RandTransaction` class below so back-to-back transactions of the same type do not have the same address. Test the constraint by generating 20 transactions.

> SystemVerilog for Verification,  Ed. 3, C. Spear, G. Tumbush 
> (c) Springer Science+Business Media, LLC 2012
