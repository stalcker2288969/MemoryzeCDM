asect 0
    dc start, 0
asect 0x200
start:
    getstack r0, 0
    putmem 0x9000, r0, r3
    getstack r1, 2
    putmem 0x9002, r1, r3
    getstack r2, 4
    putmem 0x9004, r2, r3
    getstack r3, 6
    putmem 0x9006, r3, r2
    getstack r4, 8
    putmem 0x9008, r4, r3
    getstack r5, 10
    putmem 0x900a, r5, r3
    getstack r6, 12
    putmem 0x900c, r6, r3
    getstack r7, 14
    putmem 0x900e, r7, r3
    getstack r2, 256
    putmem 0x9010, r2, r3
    getstack r3, -256
    putmem 0x9012, r3, r2
    halt
end
