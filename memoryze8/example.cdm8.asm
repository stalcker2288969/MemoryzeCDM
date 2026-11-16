# @include "lib.asm"

asect 0
main:
    setsp 0xF0

    setmem counter, 41
    incmem counter

    addsp -3
    setstacki 0, 6
    setstacki 1, 7
    mulstack 0, 1
    getstack r3, 1
    putmem product, r3, r2
    addsp 3
    halt

asect 0xC0
counter: dc 0
product: dc 0
end
