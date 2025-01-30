## Sobre el acumulador

In the context of the Intel x86 architecture, the accumulator is a special purpose register that is used for arithmetic, logic, shifting, and other operations. The accumulator is often involved in operations by default, without needing to be explicitly named.

In the x86 architecture, the accumulator can be one of the following registers, depending on the operation size:

	- AX for 16-bit operations
	- EAX for 32-bit operations
	- RAX for 64-bit operations

For example, in the MUL instruction (MUL operand), the multiplication is performed between the value in the accumulator and the operand, and the result is stored back in the accumulator.
