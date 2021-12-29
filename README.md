# Tiny Binary

The goal of this experiment is to attempt to make the smallest possible binary that will do something. As typical, I will have the program print "Hello, World!" to the terminal.

First I make a simple C source file for printing "Hello, World!". I compile the program using gcc and use the resulting binary as a base file for the ELF header and program header. I discard the actual code. I will instead use x86 assembly to leverage `syscall` directly and not have to import library code and thus link to libc. I use gas to assemble the assembly for printing "Hello, World!".

Now for some fun! Having a look at the ELF specification a few areas stick out. The information contained in an ELF file is essentially composed of three parts: the ELF header, Program Headers, and Section Headers. I learned from solving a crackme on crackmes.one that the section headers are not required to effectively run a binary. We can thus ignore that data and information. I experimented with program headers and it appears that one is only required. That is the one that contains or is associated with the .text section, our actual code.

Modifying various fields in the ELF header and one program header will allow the raw assembly to run. The raw assembly must leverage the exit syscall to return control to the operating system in an appropriate way as to not crash. The fields of interest and their respective address are seen below. Note the size is in bytes.

| Header	| Address	| Size 	| Description		|
| ------------- | ------------- | -----	| ---------------------	|
| ELF		| 0x18		| 8	| Entry point address   |
| ELF		| 0x28          | 8	| Section Header start  |
| ELF		| 0x38		| 2     | Number of entries     |
|					  Program Header Table	|
| ELF		| 0x3c		| 2	| Number of entries     |
|					  Section Header Table  |
| ELF		| 0x3e		| 2	| Index Section Header  |
|					  Table with names      |
| Program	| offset+0x8	| 8	| Offset in file image  |
| Program	| offset+0x10	| 8	| Virtual address       |
| Program	| offset+0x18	| 8	| Physical address	|
| Program	| offset+0x20	| 8	| Size in file image	|
| Program	| offset+0x28	| 8	| Size in memory	|
| Program	| offset+0x30	| 8	| Alignment		|

For the example binary the table below shows the values for each. Note offset will be equal to 0x40 or 64 because the ELF header is 64 bytes and the program header comes immediately after. 0x3d is the size in bytes of the raw machine code for printing "Hello, World!".

| Address	| Size	| Value		|
| ------------- | ----- | ------------- |
| 0x18		| 8	| 0x78		|
| 0x28		| 8	| 0x0		|
| 0x38		| 2	| 0x1		|
| 0x3c		| 2	| 0x0		|
| 0x3e		| 2	| 0x0		|
| offset+0x8	| 8	| 0x78		| 
| offset+0x10	| 8	| 0x78		|
| offset+0x18	| 8	| 0x78		|
| offset+0x20	| 8	| 0x3d		|
| offset+0x28	| 8	| 0x3d		|
| offset+0x30	| 8	| 0x0		|

With the values modified, one just needs to copy the ELF header, the program header, and the raw x86 assembly. The file will print "Hello, World!" and will be 120 bytes plus the size of the raw assembly. The Makefile will run all these to produce the binary.

