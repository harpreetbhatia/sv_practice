## Specs

#### Message Network Slave ->AXI Write Master

* 64 bit AXI interface, `awsize` hardcoded to 3.
* No transactions cross a 128Byte alignment
* Transactions are either 8 byte aligned (all 0xFF wstrb) or are a single beat
* ATU – Address Translation Unit
    * Parameter for # of windows
    * Register input for AXI `ID` of each window
    * `Node ID` and `Address` all considered ADDR bits
    * Full mask supported
* Register enabled coalition of writes
    * Build up bursts if consecutive writes are to consecutive addresses
    * Register input for # of idle cycles allowed between writes before releasing.
    * Parameter for size of write buffer and limit for AXI burst size.
* Conform to SFM AXI requirements
* Interrupt generated on BRESP error
    * Store first bad AXI ID to an output
* Overlapping Data Integrity on the DATA, all check points must have an error injection point.
    * Generate parity on 32 bits of data
    * Register, then terminate `MN ECC`
    * Generate AXI transactions while carrying through parity
    * Generate ECC on `AXI data`
    * Register, then terminate parity.
    * Generate interrupts as required.
* Fully Pipelined

#### AXI Write Slave -> Message Network Master

* 64 Bit AXI interface
* Support for 32 bit data bus (`awsize` of 3 and 2 supported)
* Break up bursts
* Full support of strobes.
    * Any byte strobe set for a `DW`, all 32 bits are written.
* Full overlapping Data integrity (See above)
* Parameter for size of buffer/storage for incoming write data
* `AWADDR[16:0]` maps directly to `MN Address`
* Register select to have Node ID bits come from `AWADDR` or register input.
* Fully Pipelined.
* Standard AXI requirements for both
    * AXI `ID` width is parameter
    * `AWBURST`, support only for incrementing (wrap is optional)
    * NO support for `AWLOCK`
    * NO Support for `AWCACHE`
    * NO support for `AWPROT`
