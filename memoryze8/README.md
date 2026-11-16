# memoryze8

Byte memory, stack-slot and pointer macros for CdM-8 Mark 5 and CoCAS 0.2.3. Version 0.1.0.

## Include and run

After installing the package through cdmbot, add the package entry to the assembly source.

```asm
# @include "@memoryze8/lib.asm"
```

For a local checkout, run the included example with `cdmbot run example.cdm8.asm`. It sets a counter to 42, multiplies two stack values, stores the product 42 and restores SP to 0xF0.

## Conventions

- `mem[X]` denotes one byte in data memory. Addresses and stack offsets are measured in bytes.
- Arithmetic wraps modulo 256. Immediate values fit the CoCAS byte range, -128 through 255.
- Every macro preserves SP. The caller reserves stack slots before writing them.
- PS is scratch state. Registers and memory outside the documented `@changed` set are preserved.
- A scratch register must differ from every live source or pointer register named in its contract.
- The existing two-argument `setstack` takes the destination offset first. Stack arithmetic takes source then destination.

## Memory macros

| Macro | Result | Register scratch |
| --- | --- | --- |
| `setmem ADDRESS, VALUE` | Store an immediate byte | r0, r1 |
| `getmem REG, ADDRESS` | Load a byte into REG | REG |
| `putmem ADDRESS, REG, TMP` | Store REG using an explicit address scratch | TMP |
| `incmem ADDRESS` | Increment a byte | r0, r1 |
| `decmem ADDRESS` | Decrement a byte | r0, r1 |
| `copymem SRC, DST` | Copy source to destination | r0, r1, r2 |
| `swapmem A, B` | Exchange two bytes | r0, r1, r2, r3 |
| `summem SRC, DST` | Add source to destination | r0, r1, r2, r3 |
| `submem SRC, DST` | Subtract source from destination | r0, r1, r2, r3 |
| `mulmem SRC, DST` | Store the low byte of the product in destination | r0, r1, r2, r3 |

`REG` can be any of r0 through r3. `putmem` requires distinct REG and TMP. Equal memory addresses are supported by copy, swap and arithmetic. Multiplication uses at most 255 repeated additions.

## Stack macros

Offsets are relative to the current SP. Offset 0 addresses the top byte. They can be positive or negative within the CoCAS byte operand range.

| Macro | Result | Register scratch |
| --- | --- | --- |
| `setstacki OFFSET, VALUE` | Store an immediate byte in a slot | r0, r1 |
| `getstack REG, OFFSET` | Load a slot into REG | REG |
| `setstack DST, SRC` | Copy source slot to destination | r0, r1, r2 |
| `incstack OFFSET` | Increment a slot | r0, r1 |
| `decstack OFFSET` | Decrement a slot | r0, r1 |
| `sumstack SRC, DST` | Add source slot to destination | r0, r1, r2, r3 |
| `substack SRC, DST` | Subtract source slot from destination | r0, r1, r2, r3 |
| `swapstack A, B` | Exchange two slots | r0, r1, r2, r3 |
| `mulstack SRC, DST` | Store the low byte of the product in destination | r0, r1, r2, r3 |

Equal offsets are supported by all two-slot operations. A function call pushes a one-byte return address, so offsets inside a called function are relative to its updated SP.

## Pointer macros

| Macro | Result | Register scratch |
| --- | --- | --- |
| `incptr PTR` | Increment the byte at PTR | r3 |
| `decptr PTR` | Decrement the byte at PTR | r3 |
| `incptr PTR, TMP` | Increment using explicit scratch | TMP |
| `decptr PTR, TMP` | Decrement using explicit scratch | TMP |
| `swapptr` | Exchange bytes addressed by r0 and r2 | r1, r3 |
| `swapptr PTR_A, PTR_B, TMP_A, TMP_B` | Exchange bytes using explicit pointers and scratch | TMP_A, TMP_B |

Pointer registers are preserved. One-argument increment/decrement requires PTR in r0, r1 or r2. Explicit-scratch overloads also support a pointer in r3. For explicit swap, the two scratch registers must differ from each other and both pointer registers. Pointers may be identical registers or hold the same address.

## Comment format

Every macro definition uses a signature and description followed by `@param` entries, `@return`, `@changed`, preservation rules and relevant aliasing constraints. CocoVS uses the tags for hover and signature help. The source contract includes the modified memory locations alongside register and PS effects.

## Tests

From this package's source checkout, run `cdmbot test --jobs 4`. Its `project.yaml` checks syntax and runs all cases in unified and Harvard configurations. The root MemoryzeCDM manifest runs both processor versions.

To focus on one case, run `cdmbot tests/memory.asm tests/memory.yaml --case wrap`. The suites cover wraparound, multiplication by zero and one, aliased addresses, explicit scratch registers, all load destinations, stack displacements, SP preservation and memory outside the output regions.
