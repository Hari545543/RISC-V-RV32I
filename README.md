# RISC-V-RV32I
Github : [https://github.com/Hari545543/RISC-V-RV32I](https://github.com/Hari545543/RISC-V-RV32I)

RV32I is one of the variants of RISC-V, which is a 32-bit implementation of the ISA that includes a basic set of integer instructions written using **Verilog HDL**.

The RV32I ISA includes a set of 32 general-purpose registers, each of which is 32 bits wide. The instruction set includes basic arithmetic and logical operations, as well as load and store instructions for accessing memory. The RV32I ISA also includes conditional branches and jumps, which are used to control program flow.

A 5-stage pipeline RISC-V RV32I has been implemented here.

## Overview
![image](https://user-images.githubusercontent.com/98028428/222489244-6595b7d8-f7ae-44d8-bba8-122c4169bb78.png)

RV32I contains 6 type of instruction Format:

![image](https://user-images.githubusercontent.com/98028428/222492445-acf5b4ce-bac7-44b3-9956-89222098dce3.png)

## Pipeline Hazards
**`Structural Hazard : `** Structural hazards occur when more than one instruction needs to use the same
datapath resource at the same time. There are two main causes of structural hazards:
      
**Register File**: The register file is accessed both during ID, when it is read, and
during WB, when it is written to. We can solve this by having separate
read and write ports. To account for reads and writes to the same register,
processors usually write to the register during the first half of the clock cycle,
and read from it during in the second half. This is also known as double
pumping.

**Memory**: Memory is accessed for both instructions and data. Having a separate
instruction memory (abbreviated IMEM) and data memory (abbreviated
DMEM) solves this hazard.

**`Data Hazard : `** Data hazards are caused by data dependencies between instructions. There are two starategies that was followed to eliminate this problem:

**Forwarding** : Most data hazards can be resolved by forwarding, which is when the result of the
EX or MEM stage is sent to the EX stage for a following instruction to use.

**Stall** : A stall is a cycle in the pipeline without new input. Although, this strategy completely resolves the data hazard, it increases the **CPI** (`Cycles Per Instruction`)

**`Control hazard :`** They are caused by jump and branch instructions, because for all jumps and some branches, the next PC is not PC + 4, but the result of the computation completed in the EX stage. We could stall the pipeline for control hazards, but this decreases performance.

There are 2 strategies that was implemented here:

**Flushing** : The naïve way is to flush the pipeline if the branch is taken. If our prediction is wrong, we have to flush the pipeline, else everything can continue with no performance loss.

**2-bit Dynamic Predictor** : A 2-bit dynamic predictor has been implemented here to predict if the branch is taken or not. Implemented using Fininte State Machine (FSM).


## Features

* Fixed-length instructions: All instructions in RV32I are 32 bits in length, which simplifies instruction fetching and decoding.

* Load/store architecture: RV32I uses a load/store architecture, which means that data is transferred between memory and registers using load and store instructions.

* 32 general-purpose registers: RV32I provides a set of 32 general-purpose registers, each of which is 32 bits in length.

* Basic arithmetic and logical instructions: RV32I includes basic arithmetic and logical instructions such as add, subtract, and bitwise logical operations.

* Branch instructions: RV32I includes branch instructions that allow for conditional execution and program flow control.

* Immediate instructions: RV32I includes instructions that allow for immediate values to be added to or logically operated on with register values.

* Reduced instruction set: As a RISC architecture, RV32I has a reduced instruction set compared to complex instruction set architectures (CISAs), which simplifies the  design of the processor.

* Open-source architecture: The RISC-V ISA is open-source, which means that anyone can use, modify, and distribute it without restrictions.

## Acknowldgement

All the modules and sub-modules have personally written by myself.
