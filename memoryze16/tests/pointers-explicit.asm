asect 0
    dc start, 0
asect 0x200
start:
    incptr r7, r4
    decptr r6, r5
    swapptr r7, r6, r4, r5
    swapptr r7, r7, r4, r5
    halt
end
