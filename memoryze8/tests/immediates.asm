asect 0
start:
    setmem 0xa0, 0xff
    setmem 0xa1, -1
    setmem 0xa2, -128
    setmem 0xa3, 0
    setstacki 0, 0xff
    setstacki 1, -1
    setstacki 2, -128
    halt
end
