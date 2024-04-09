x="""
0x10000513	addi x10 x0 256	addi x10, x0, 0x100 # array = [4, 8, 3, 1] 
0x00400593	addi x11 x0 4	addi x11, x0, 4 # size = 4
0x04050263	beq x10 x0 68	beq x10, x0, sorted # address is null
0x04058063	beq x11 x0 64	beq x11, x0, sorted # len is 0
0x00158413	addi x8 x11 1	addi x8, x11, 1 # i = len
0xfff40413	addi x8 x8 -1	addi x8, x8, -1 # i stores ending index for j
0x02040a63	beq x8 x0 48	blt x8, x0, sorted # if i is less than 0, then no more of list to sort
0xfff40413	addi x8 x8 -1	addi x8, x8, -1 # decrement i after each loop
0x000004b3	add x9 x0 x0	add x9, x0, x0 # j = 0
0x00349e13	slli x28 x9 3	slli x28, x9, 3
0x00ae0e33	add x28 x28 x10	add x28, x28, x10 # a[j]
0x000e3a03	lw x20 0(x28)	lw x20, 0(x28) # get a[j]
0x008e3a83	lw x21 8(x28)	lw x21, 8(x28) # get a[j+1]
0x015a4663	blt x20 x21 12	blt x20, x21, else # if a[j] < a[j+1] then do nothing
0x015e3023	sw x21 0(x28)	sw x21, 0(x28)
0x014e3423	sw x20 8(x28)	sw x20, 8(x28)
0x00148493	addi x9 x9 1	addi x9, x9, 1 # j = j + 1
0xfe84c0e3	blt x9 x8 -32	blt x9, x8, inner # if j < i, then continue inner loop
0xfc0008e3	beq x0 x0 -48	beq x0, x0, outer # else move to next iteration of outer loop
0x00000263
"""

y = x.strip().split("\n")
instructions = []
for l in y:
    # print(l)
    inst = l.split()
    a = inst[0]
    # inst[0]
    instructions.append(a[2:])
print(instructions)

idx = 0
for i in instructions:
    for j in range(8, 0, -2):
        print(f"IM[{idx}] <= 8'h{i[j-2:j]};")
        idx += 1

# IM[0] <= 8'h63 ;