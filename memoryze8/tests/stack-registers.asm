asect 0
start:
    getstack r0, 0
    putmem 0xa0, r0, r3
    getstack r1, 1
    putmem 0xa1, r1, r3
    getstack r2, 2
    putmem 0xa2, r2, r3
    getstack r3, 3
    putmem 0xa3, r3, r2
    getstack r2, 64
    putmem 0xa4, r2, r3
    getstack r3, -16
    putmem 0xa5, r3, r2
    halt
end
