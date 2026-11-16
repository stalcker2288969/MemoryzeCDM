# @include "lib.asm"

asect 0
    dc main, 0
asect 0x200
main:
    ldi r7, 0x8000
    stsp r7

    setmem counter, 41
    incmem counter

    addsp -6
    setstacki 0, 6
    setstacki 2, 7
    mulstack 0, 2
    getstack r3, 2
    putmem product, r3, r2
    addsp 6
    halt

asect 0xC000
counter: dw 0
product: dw 0
end
