This memory is word-addressable and byte writable.

For read:
A word is read from memory, and based on the instruction (LW/LH/LB/LHU/LBU), it is organised in the receiver module.

For write:
A word is organized according to the instruction (SB/SH/SW), and the mask is prepared according to the address. Then, in the memory model, the word is stored at the byte location corresponding to the mask.

Test_bench:
ChatGPT5 made the Top Test Bench, while I've made some tweaks.
I've made other Test Benches to verify that the design works properly.

