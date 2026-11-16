asect 0
    dc start, 0
asect 0x200
start:
    getmem r0, 0xa000
    putmem 0x9000, r0, r3
    getmem r1, 0xa000
    putmem 0x9002, r1, r3
    getmem r2, 0xa000
    putmem 0x9004, r2, r3
    getmem r3, 0xa000
    putmem 0x9006, r3, r2
    getmem r4, 0xa000
    putmem 0x9008, r4, r3
    getmem r5, 0xa000
    putmem 0x900a, r5, r3
    getmem r6, 0xa000
    putmem 0x900c, r6, r3
    getmem r7, 0xa000
    putmem 0x900e, r7, r3
    halt
end
