# memoryze16

Word memory, stack-slot and pointer macros for CdM-16 and CoCAS 0.2.3. Version 0.1.0.

## Include and run

After installing the package through cdmbot, add the package entry to the assembly source.

```asm
# @include "@memoryze16/lib.asm"
```

For a local checkout, run the included example with `cdmbot run example.cdm16.asm`. It sets a counter to 42, multiplies two stack words, stores the product 42 and restores SP to 0x8000. Execution requires JDK 17+ or cdmbot's managed-Java installation.

## Conventions

- `mem[X]` denotes one little-endian word occupying two bytes in data memory.
- All addresses and stack displacements are byte-based. Word addresses, SP and word-slot displacements must be even.
- Arithmetic wraps modulo 65536. Immediate values fit the CoCAS word range, -32768 through 65535.
- Every macro preserves SP. The caller reserves stack storage before writing slots.
- PS is scratch state. Registers and memory outside the documented `@changed` set are preserved.
- A scratch register must differ from every live source or pointer register named in its contract.
- `setstack` takes destination then source. Stack arithmetic takes source then destination.
- Stack macros use the current SP. r7/fp participates as an ordinary register only when explicitly requested by an argument.

## Memory macros

| Macro | Result | Register scratch |
| --- | --- | --- |
| `setmem ADDRESS, VALUE` | Store an immediate word | r0, r1 |
| `getmem REG, ADDRESS` | Load a word into REG | REG |
| `putmem ADDRESS, REG, TMP` | Store REG using an explicit address scratch | TMP |
| `incmem ADDRESS` | Increment a word | r0, r1 |
| `decmem ADDRESS` | Decrement a word | r0, r1 |
| `copymem SRC, DST` | Copy source to destination | r0, r1, r2 |
| `swapmem A, B` | Exchange two words | r0, r1, r2, r3 |
| `summem SRC, DST` | Add source to destination | r0, r1, r2, r3 |
| `submem SRC, DST` | Subtract source from destination | r0, r1, r2, r3 |
| `mulmem SRC, DST` | Store the low word of the product in destination | r0, r1, r2, r3 |

`REG` and TMP can use r0 through r7. `putmem` requires distinct REG and TMP. Equal addresses are supported by copy, swap and arithmetic. Multiplication uses at most 16 shift-and-add iterations.

## Stack macros

Word slots use byte offsets 0, 2, 4, and so on. Full word-sized positive and negative offset expressions are supported. SP-relative address calculation uses r0 through r3 and preserves r4 through r7 except an explicitly selected destination register.

| Macro | Result | Register scratch |
| --- | --- | --- |
| `setstacki OFFSET, VALUE` | Store an immediate word in a slot | r0, r1 |
| `getstack REG, OFFSET` | Load a slot into REG | r0, r1, REG |
| `setstack DST, SRC` | Copy source slot to destination | r0, r1, r2, r3 |
| `incstack OFFSET` | Increment a slot | r0, r1 |
| `decstack OFFSET` | Decrement a slot | r0, r1 |
| `sumstack SRC, DST` | Add source slot to destination | r0, r1, r2, r3 |
| `substack SRC, DST` | Subtract source slot from destination | r0, r1, r2, r3 |
| `swapstack A, B` | Exchange two slots | r0, r1, r2, r3 |
| `mulstack SRC, DST` | Store the low word of the product in destination | r0, r1, r2, r3 |

Equal offsets are supported by all two-slot operations. The `mz_stackaddr` definition supports internal address calculation. A function call pushes a two-byte return address, so offsets inside a called function are relative to its updated SP.

## Pointer macros

| Macro | Result | Register scratch |
| --- | --- | --- |
| `incptr PTR` | Increment the word at PTR | r3 |
| `decptr PTR` | Decrement the word at PTR | r3 |
| `incptr PTR, TMP` | Increment using explicit scratch | TMP |
| `decptr PTR, TMP` | Decrement using explicit scratch | TMP |
| `swapptr` | Exchange words addressed by r0 and r2 | r1, r3 |
| `swapptr PTR_A, PTR_B, TMP_A, TMP_B` | Exchange words using explicit pointers and scratch | TMP_A, TMP_B |

Pointer registers are preserved. One-argument increment/decrement requires PTR distinct from r3. The explicit-scratch overloads support every general-purpose register as a pointer. For explicit swap, the two scratch registers must differ from each other and both pointer registers. Pointers may be identical registers or hold the same address.

## Comment format

Every macro definition uses a signature and description followed by `@param` entries, `@return`, `@changed`, preservation rules and relevant aliasing constraints. CocoVS uses the tags for hover and signature help. The source contract includes the modified memory locations alongside register and PS effects.

## Tests

From this package's source checkout, run `cdmbot test --jobs 4`. Its `project.yaml` checks syntax and runs all cases in unified and Harvard configurations. The root MemoryzeCDM manifest runs both processor versions.

To focus on one case, run `cdmbot tests/arithmetic.asm tests/arithmetic.yaml --case overflow`. The suites cover wraparound, multiplication by zero and one, aliased addresses, all eight load destinations, explicit high-register pointers, large and negative stack displacements, SP preservation and memory outside the output regions.
