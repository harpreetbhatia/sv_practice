## 5.20 Exercises

1. Create a class called `MemTrans` that contains the following members, then construct a `MemTrans` object in an initial block.
* An 8-bit `data_in` of logic type
* A 4-bit `address` of logic type
* A void function called print that prints out the value of `data_in` and `address`

2. Using the `MemTrans` class from Exercise 1, create a custom constructor, the new function, so that `data_in` and `address` are both initialized to 0.

3. Using the `MemTrans` class from Exercise 1, create a custom constructor so that
`data_in` and `address` are both initialized to 0 but can also be initialized through arguments passed into the constructor. In addition, write a program to perform the following tasks.
* Create two new `MemTrans` objects.
* Initialize `address` to 2 in the first object, passing arguments by name.
* Initialize `data_in` to 3 and `address` to 4 in the second object, passing arguments by name.

4. Modify the solution from Exercise 3 to perform the following tasks.
* After construction, set the `address` of the first object to 4’hF.
* Use the print function to print out the values of `data_in` and `address` for the two objects.
* Explicitly deallocate the 2nd object.

5. Using the solution from Exercise 4, create a static variable last_address that
holds the initial value of the `address` variable from the most recently created object, as set in the constructor. After allocating objects of class ``MemTrans``(done in Exercise 4) print out the current value of `last_address`.

6. Using the solution from Exercise 5, create a static method called `print_last_
address` that prints out the value of the static variable `last_address`. After allocating objects of class ``MemTrans`` , call the method `print_last_address` to print out the value of `last_address`.

7. Given the following code, complete the function `print_all` in class `MemTrans` to print out `data_in` and `address` using the class `PrintUtilities`.
Demonstrate using the function `print_all`.

8. Complete the following code where indicated by the comments starting with `//`.

9. For the following class, create a `copy` function and demonstrate its use. Assume the `Statistics` class has its own `copy` function.

> SystemVerilog for Verification,  Ed. 3, C. Spear, G. Tumbush 
> (c) Springer Science+Business Media, LLC 2012
