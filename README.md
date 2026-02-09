# 🚀 Parameterized Pipelined ALU based Mini CPU (Verilog)

## 📌 Overview

This project implements a **fully synthesizable Parameterized Pipelined ALU based Mini CPU** designed in Verilog and verified using Xilinx Vivado.
The design includes full RTL simulation, pipeline architecture, synthesis verification, and timing-constraint validated hardware implementation.

---

## 🧠 Architecture

The CPU consists of:

* Parameterized ALU (supports scalable bit-width)
* 3-Stage Pipeline (Fetch → Decode → Execute)
* Register File
* Barrel Shifter
* Program Counter
* Instruction Decoder
* Flag Logic (Zero, Carry, Negative, Overflow)

---

## ⚙️ Features

* Fully Parameterized ALU (bit-width scalable)
* Pipelined Architecture for improved throughput
* Synthesizable RTL Design
* Barrel Shifter Integration
* Verified using Behavioral Simulation
* RTL & Synthesized Schematic Verified
* Timing Constraints Applied & Met
* FPGA Ready Design

---

## 🧪 Simulation Result

| Component     | Status     |
| ------------- | ---------- |
| ALU           | ✅ Verified |
| Pipeline      | ✅ Verified |
| Register File | ✅ Verified |
| CPU Execution | ✅ Verified |

Waveforms confirm correct instruction execution, register updates, and ALU operation.

---

## ⏱ Timing Result

* Worst Negative Slack (WNS): **+3.001 ns**
* No timing violations
* Fully timing-clean design
* Max Frequency ≈ **143 MHz**

---

## 🖼 Design Views

* RTL Schematic
* Synthesized Schematic
* CPU Architecture Diagram
* Simulation Waveforms
* Timing Summary

(All included in repository)

---

## 🛠 Tools Used

* Verilog HDL
* Xilinx Vivado 2025.2
* Behavioral Simulation
* RTL Analysis
* Synthesis & Timing Verification

---

## 📂 Repository Structure

* `rtl/` → RTL source files
* `tb/` → Testbenches
* `simulation/` → Waveforms
* `synthesis/` → Schematics & timing
* `architecture/` → CPU block diagram
* `constraints/` → XDC file

---

## 🎯 Learning Outcome

* Digital CPU Design
* Pipeline Architecture
* Parameterized Hardware Design
* FPGA Timing Closure
* RTL to Synthesized Flow
* Hardware Verification

---

## 👨‍💻 Author

**Samir Makwana**
Electronics & Communication Engineer
FPGA / VLSI / Digital Design Enthusiast

---

## ⭐ If you like this project, give it a star!
