## 4.13 Exercises

1. Design an interface and testbench for the ARM Advanced High-performance Bus (AHB). You are provided a bus master as verifi cation IP that can initiate AHB transactions. You are testing a slave design. The testbench instantiates the interface, slave, and master. Your interface will display an error if the transaction type is not IDLE or NONSEQ on the negative edge of HCLK. The AHB signals are described in Table 4.2.

*Table 4.2* AHB Signal Description
Signal | Width | Direction | Description
--- | --- | --- | ---
HCLK | 1 | Output | Clock
HADDR | 21 | Output | Address
HWRITE | 1 | Output | Write | fl | ag: | 1=write, | 0=read
HTRANS | 2 | Output | Transaction | type: | 2'b00=IDLE, | 2'b10=NONSEQ
HWDATA | 8 | Output | Write | data
HRDATA | 8 | Input | Read | data

2. For the following interface, add the following code.
* A clocking block that is sensitive to the negative edge of the clock, and all I/O
that are synchronous to the clock.
* A modport for the testbench called master , and a modport for the DUT called
slave
* Use the clocking block in the I/O list for the master modport.

3. For the clocking block in Exercise 2, fill in the `data_in` and `data_out` signals
in the following timing diagram.


4. Modify the clocking block in Exercise 2 to have:
* output skew of 25ns for output write and address
* input skew of 15ns
* restrict `data_in` to only change on the positive edge of the clock

5. For the clocking block in Exercise 4, fill in the following timing diagram, assuming a clock period of 100ns.

> SystemVerilog for Verification,  Ed. 3, C. Spear, G. Tumbush 
> (c) Springer Science+Business Media, LLC 2012
