# Synchronous-FIFO-UVM-Verification
This repository contains the UVM-based verification of a Synchronous FIFO. It includes constrained random stimulus generation, functional coverage, and a reference model to check outputs. UVM assertions are used to ensure the correct behavior of flags and counters, focusing on comprehensive validation of the FIFO's functionality.

## Key Features

- **Full UVM environment** for verifying the FIFO design.
- **Constrained random generation** of stimuli to test various FIFO scenarios.
- **Functional coverage** to track verification progress and ensure all functionality is tested.
- **Assertions** to check for correct FIFO behavior under normal and boundary conditions.
- **Modular sequences** for specific verification tasks such as write-only, read-only, and combined operations.

## UVM Environment Components

1. **Driver**: Sends stimuli to the FIFO design based on the generated sequences.
2. **Monitor**: Observes and records transactions, providing data to the scoreboard and coverage collector.
3. **Scoreboard**: Compares the output from the FIFO to expected results.
4. **Sequence Items**: Defines constraints for valid stimuli based on FIFO operation.
5. **Coverage Collector**: Tracks functional coverage using covergroups and coverpoints.

## Sequences

The UVM environment contains several specialized sequences:
- **write_only_sequence**: Verifies the FIFO’s write functionality.
- **read_only_sequence**: Verifies the FIFO’s read functionality.
- **write_read_sequence**: Verifies simultaneous read and write operations.

## Verification Plan

The verification plan is designed to thoroughly test the FIFO in the following areas:
- **Write/Read Operations**: Verify both in isolation and together.
- **Edge Cases**: FIFO full, empty, almost full, and almost empty.
- **Overflow/Underflow**: Ensure proper behavior when limits are reached.

## Requirements

- **QuestaSim** for simulation and waveform analysis.
- **SystemVerilog** for design and testbench.
- **UVM** for creating the verification environment.

## How to Run

1. Clone the repository:
   ```
   git clone https://github.com/yourusername/uvm_fifo_verification.git
   cd uvm_fifo_verification
   ```
2. Set up your environment to support UVM and SystemVerilog simulation.
3. Run the UVM testbench:
    ```
    vsim -do run.do
    ```
