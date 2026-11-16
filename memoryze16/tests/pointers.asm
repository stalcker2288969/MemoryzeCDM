asect 0
    dc start, 0
asect 0x200
start:
    incptr r0
    decptr r2
    swapptr
    halt
end
