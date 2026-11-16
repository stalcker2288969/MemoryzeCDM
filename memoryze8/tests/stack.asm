asect 0
start:
    setstacki 0, 42
    setstack 1, 0
    incstack 1
    decstack 0
    getstack r3, 1
    putmem 0xa0, r3, r2
    swapstack 0, 2
    halt
end
