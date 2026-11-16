asect 0
    dc start, 0
asect 0x200
start:
    setmem 0x9000, 0xffff
    setmem 0x9002, -1
    setmem 0x9004, -32768
    setmem 0x9006, 0
    setstacki 0, 0xffff
    setstacki 2, -1
    setstacki 4, -32768
    halt
end
