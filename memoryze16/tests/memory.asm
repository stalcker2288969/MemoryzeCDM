asect 0
    dc start, 0
asect 0x200
start:
    incmem 0x9000
    decmem 0x9002
    setmem 0x9004, 42
    copymem 0x9006, 0x9008
    swapmem 0x900a, 0x900c
    getmem r3, 0x9008
    putmem 0x900e, r3, r2
    halt
end
