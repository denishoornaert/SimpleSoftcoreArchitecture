# CPU architecture

The actual architecture of the CPU is composed of six components (listed below) that are typical of any state of the art implementation.

Therefore, the SSA CPU is composed of the following sub-circuits :
 - An accumulator `acc` that records temporarily the result of the `alu`
 - An arithmetic-logic-unit `alu` that performs all the data manipulation
 - An instruction decoder `id` that translate the given instruction into a bunch of signals that drives the `alu`
 - A memory `mem` that is in charge of storing both the data and the instructions of the program ran
 - A program counter `pc` that stores the address of the next instruction that will be fetched
 - A register file `rf` that consists in a bunch of registers that are manipulated by the `id` and read by the `alu`

## TODOs
 - [ ] implement the `acc`
 - [ ] implement the `id`
 - [ ] implement the `mem`
 - [ ] implement the `pc`
 - [ ] implement the `rf`
