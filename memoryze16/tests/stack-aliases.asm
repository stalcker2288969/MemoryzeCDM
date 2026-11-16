asect 0
    dc start, 0
asect 0x200
start:
    setstack 0, 0
    swapstack 2, 2
    sumstack 4, 4
    substack 6, 6
    mulstack 8, 8
    mulstack 10, 10
    halt
end
