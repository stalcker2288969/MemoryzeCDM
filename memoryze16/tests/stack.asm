asect 0
    dc start, 0
asect 0x200
start:
    setstacki 0, 42
    setstack 2, 0
    incstack 2
    decstack 0
    getstack r3, 2
    putmem 0x9000, r3, r2
    swapstack 0, 4
    halt
end
