# JK-Flip Flop example with Clock, Preset and Clear active-low logic

## Truth Table

(Preset, Clear and CLK with active-low logic)
 
| Preset | Clear | CLK | J | K | Output         | Qo  | ~Qo |
|--------|-------|-----|---|---|----------------|-----|-----|
| 0      | 0     | x   | x | x | Invalid        | 1*  | 0*  |
| 0      | 1     | x   | x | x | Preset         | 1   | 0   |
| 1      | 0     | x   | x | x | Clear          | 0   | 1   |
| 1      | 1     | x   | x | x | No change      | Qo  | ~Qo |
| 1      | 1     | NEG | 0 | 0 | No change      | Qo  | ~Qo |
| 1      | 1     | NEG | 0 | 1 | Reset          | 0   | 1   |
| 1      | 1     | NEG | 1 | 0 | Set            | 1   | 0   |
| 1      | 1     | NEG | 1 | 1 | Toggle         | ~Qo | Qo  |

## Dependencies
* verilator (for linting)
* icarus (for simulation)
* gtkwave (for the vcd file)
* quartus (for FPGA synthesis)

## Lint
```
make lint
```

## Simulate
```
make sim
```

## FPGA synthesis
(All input and output ports are mapped as "virtual")
```
make project
```
