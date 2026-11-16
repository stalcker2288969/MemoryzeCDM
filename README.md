# MemoryzeCDM

Memory, stack-slot and pointer macros for the Coco-de-Mer processors, using CoCAS 0.2.3.

| Package | Processor | Memory value | Stack slot offsets |
| --- | --- | --- | --- |
| [memoryze8](memoryze8/README.md) | CdM-8 Mark 5 | One byte, arithmetic modulo 256 | 0, 1, 2, ... |
| [memoryze16](memoryze16/README.md) | CdM-16 | One little-endian word, arithmetic modulo 65536 | 0, 2, 4, ... |

All addresses and stack offsets are byte-based. Every macro preserves SP. Register and memory effects are documented directly above each definition with `@param`, `@return` and `@changed`, which CocoVS displays in hover and signature help. PS is scratch state after each macro.

Each package contains `memory.mlb`, `stack.mlb`, `pointers.mlb` and a `lib.asm` include entry. The package manifests list all required macro files.

## Run the examples

With cdmbot 0.2.1 or newer installed, run from the repository root.

```sh
cdmbot run memoryze8/example.cdm8.asm
cdmbot run memoryze16/example.cdm16.asm
```

Both examples store 42 in `counter` and `product`, leave r3 equal to 42, restore the initial SP and halt. CdM-8 uses SP 0xF0 and CdM-16 uses SP 0x8000. CdM-16 execution requires JDK 17+ or cdmbot's managed-Java installation.

## Run the automated tests

```sh
cdmbot test --jobs 4
cdmbot test memoryze8 --jobs 4
cdmbot test memoryze16 --jobs 4
```

The root `project.yaml` runs both packages. Each package also has its own `project.yaml` for focused testing. CocoVS discovers these manifests in its Testing view.

The suites cover ordinary values, zero, one, the sign boundary, overflow, underflow, unequal subtraction operands, aliased addresses, every general-purpose register in load macros, explicit scratch registers, large and negative stack offsets, and repeated multiplication expansions. Every suite runs in unified and Harvard memory configurations. Core suites check SP, preserved registers and memory outside the declared output regions.

To run one case while developing a macro, select a suite and a case.

```sh
cdmbot memoryze8/tests/memory.asm memoryze8/tests/memory.yaml --case wrap
cdmbot memoryze16/tests/arithmetic.asm memoryze16/tests/arithmetic.yaml --case overflow
```

## Use the packages

After installing the matching package from a catalog, include its entry file and call its macros directly.

```asm
# @include "@memoryze8/lib.asm"

asect 0
main:
    setsp 0xF0
    setmem counter, 41
    incmem counter
    getmem r3, counter
    halt
counter: dc 0
end
```

For CdM-16 use `@memoryze16/lib.asm`, the matching reset vector, even data addresses and `dw` storage. The [CdM-16 example](memoryze16/example.cdm16.asm) provides a complete startup and stack frame.

For local development, the examples use `# @include "lib.asm"` inside their package folders. Direct CoCAS builds pass the `.mlb` files explicitly.

```powershell
New-Item -ItemType Directory -Force memoryze8/build,memoryze16/build | Out-Null
cocas -t cdm8 -o memoryze8/build/example.img memoryze8/example.cdm8.asm memoryze8/memory.mlb memoryze8/stack.mlb memoryze8/pointers.mlb
cocas -t cdm16 -o memoryze16/build/example.img memoryze16/example.cdm16.asm memoryze16/memory.mlb memoryze16/stack.mlb memoryze16/pointers.mlb
```

## Publish package releases

Both packages are prepared as version 0.1.0. Commit the source repository and publish a release tag. Register each subdirectory in the existing cdmbot catalog. Replace `YOUR_ACCOUNT` with the source repository's actual owner.

```sh
cdmbot pub publish ./memoryze8 --git https://github.com/YOUR_ACCOUNT/MemoryzeCDM.git --ref v0.1.0 --subdir memoryze8 --registry ../CDMBot/registry
cdmbot pub publish ./memoryze16 --git https://github.com/YOUR_ACCOUNT/MemoryzeCDM.git --ref v0.1.0 --subdir memoryze16 --registry ../CDMBot/registry
```

Publish the resulting `registry/packages/memoryze8/package.json` and `registry/packages/memoryze16/package.json` cards in the cdmbot repository. Consumers can then add the package by name or build a source containing its package include. The package manager records exact commits in the consumer's lock file.
