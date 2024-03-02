# Counter Design and Testbench

## Overview

This repository contains the Verilog code for a simple counter module along with an associated testbench for functional verification. The counter module is designed to count up or down based on the control signals and can load data on demand.

## Files

- **`design.v`**: Verilog file containing the counter module implementation.
- **`testbench.v`**: Verilog testbench for validating the functionality of the counter module.

### Testbench Scenarios

The testbench covers various scenarios, including:

- Counting up and down.
- Loading data onto the counter.
- Random scenarios generated to stress-test the design.

### Bugs

To test the effectiveness of the testbench, a bug has been intentionally introduced in the counter module. Uncomment the `BUGG_CODE` section in `design.v` to activate the bug and observe its impact during simulation.

## Acknowledgments

- Special thanks to Harshal Advane Sir for guiding me in writing this testbench.
- The design and testbench structure are inspired by common Verilog practices and testbench methodologies.

Feel free to contribute, report issues, or suggest improvements!

