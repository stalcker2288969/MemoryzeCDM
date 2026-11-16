asect 0
    dc start, 0
asect 0x200
start:
    sumstack 0, 2
    substack 4, 6
    mulstack 8, 10
    mulstack 12, 14
    halt
end
