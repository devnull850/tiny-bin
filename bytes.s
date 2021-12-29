	.section .text
	.globl hello
hello:	movq	$0x57202c6f6c6c6548,%rax
	movq	%rax,0xfffffffffffffff0(%rsp)
	movq	$0xa21646c726f,%rax
	movq	%rax,0xfffffffffffffff8(%rsp)
	movl	$1,%edi
	leaq	0xfffffffffffffff0(%rsp),%rsi
	movl	$0xe,%edx
	movl	$1,%eax
	syscall
	xorl	%edi,%edi
	movl	$0x3c,%eax
	syscall
