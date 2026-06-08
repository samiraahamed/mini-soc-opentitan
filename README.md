# Mini SoC - OpenTitan Learning Project

## Overview
This project implements a minimal System-on-Chip (SoC) to understand the core concepts of OpenTitan, a real open-source silicon design from lowRISC.

## Architecture Block Diagram
┌─────────────┐ ┌─────────────┐ ┌─────────────┐
│ ROM │────▶│ CPU │────▶│ OUTPUT │
│ (16 bytes) │ │ (Accumulator│ │ Peripheral │
│ │ │ + PC) │ │ + STROBE │
└─────────────┘ └─────────────┘ └─────────────┘
│
▼
┌─────────────┐
│ RAM │
│ (16 bytes) │
└─────────────┘


## Instruction Set
| Opcode | Mnemonic | Description |
|--------|----------|-------------|
| 0001 | LDA addr | Load ACC from RAM[addr] |
| 0010 | ADD addr | ACC = ACC + RAM[addr] |
| 0011 | OUT | Write ACC to output peripheral |
| 0100 | HLT | Halt execution |

## Test Program
Address	Instruction	Action
0	LDA RAM[2]	Load 8 into ACC
1	ADD RAM[2]	ACC = 8 + 8 = 16
2	OUT	Send 16 to peripheral
3	HLT	Stop execution
text

## Simulation Results (Waveform)
Time | PC | ACC | OUT | STROBE
20ns | 1 | 8 | 0 | 0
30ns | 2 | 16 | 0 | 0
40ns | 3 | 16 | 16 | 1
50ns | 3 | 16 | 16 | 0



**Final Output: 16 ✓**

## Learning Outcomes Achieved
- ✅ SoC-level architecture understanding
- ✅ IP integration (CPU + Memory + Peripheral)
- ✅ ASIC design exposure
- ✅ Verilog simulation with waveform verification
- ✅ Bus handshake protocol (STROBE signal)

## Connection to OpenTitan
| Mini SoC Component | OpenTitan Equivalent |
|--------------------|----------------------|
| Accumulator CPU | Ibex RISC-V core |
| Instruction ROM | OTP / Flash |
| Data RAM | SRAM banks |
| Output peripheral | GPIO / UART |
| STROBE handshake | TileLink bus protocol |

## Files in This Repository
| File | Description |
|------|-------------|
| `mini_soc.v` | Verilog source code (CPU + RAM + ROM + Peripheral) |
| `WAVEFORM_OUTPUT.txt` | Simulation output proving correct operation |

## How to Run
1. Copy `mini_soc.v` to any Verilog simulator (Jdoodle, EDA Playground, Icarus Verilog)
2. Run the testbench
3. Observe waveform output showing 8 + 8 = 16

## Project Status
![Status](https://img.shields.io/badge/status-complete-brightgreen)
![Test](https://img.shields.io/badge/test-passing-brightgreen)
![SoC](https://img.shields.io/badge/SoC-mini-blue)
