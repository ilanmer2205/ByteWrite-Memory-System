This memory is word-addressable, byte writable.

For read:
A word is read from the memory and based on the instruction (LW/LH/LB/LHU/LBU), than it will organise the word as per the instruction in the receiver module.

For write:
A word is organized as per the instruction (SB/SH/SW), and the mask is prepared as per the address. then, in the memory model, the word is saved in the byte number corresponding to the mask.

Test_bench:
note: Top Test Bench was made by chatgpt5, while I've made some tweaks

