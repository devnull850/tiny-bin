all: exe

exe: mod
	chmod +x a.out

mod: init
	dd if=data of=a.out conv=notrunc bs=1 skip=8 count=8 seek=24
	dd if=data of=a.out conv=notrunc bs=1 count=8 seek=40
	dd if=data of=a.out conv=notrunc bs=1 skip=24 count=2 seek=56
	dd if=data of=a.out conv=notrunc bs=1 count=4 seek=60
	dd if=data of=a.out conv=notrunc bs=1 skip=8 count=8 seek=72
	dd if=data of=a.out conv=notrunc bs=1 skip=8 count=8 seek=80
	dd if=data of=a.out conv=notrunc bs=1 skip=8 count=8 seek=88
	dd if=data of=a.out conv=notrunc bs=1 skip=16 count=8 seek=96
	dd if=data of=a.out conv=notrunc bs=1 skip=16 count=8 seek=104
	dd if=data of=a.out conv=notrunc bs=1 count=8 seek=112

init: base blob
	dd if=base of=a.out bs=1 count=64
	dd if=base of=a.out bs=1 seek=64 skip=232 count=56
	dd if=blob of=a.out bs=1 seek=120 count=61
	rm base blob

base: base.c
	gcc -Wall -Werror -o base base.c

blob: bytes.o
	dd if=bytes.o of=blob bs=1 count=61 skip=64
	rm bytes.o

bytes.o: bytes.s
	as -o bytes.o bytes.s

.PHONY:
clean:
	rm a.out
