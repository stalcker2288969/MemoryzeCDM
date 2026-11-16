asect 0
start:
    incptr r3, r0
    decptr r2, r1
    swapptr r3, r2, r0, r1
    swapptr r3, r3, r0, r1
    halt
end
