asect 0
start:
    getmem r0, 0xc0
    putmem 0xa0, r0, r3
    getmem r1, 0xc0
    putmem 0xa1, r1, r3
    getmem r2, 0xc0
    putmem 0xa2, r2, r3
    getmem r3, 0xc0
    putmem 0xa3, r3, r2
    halt
end
