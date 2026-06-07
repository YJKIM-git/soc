# Lab 3: Cortex-M0 + UART

Builds on Lab 2 by adding a **CMSDK APB UART** peripheral,
enabling serial communication. Introduces the AHB-to-APB bridge pattern
and interrupt routing.

## Block Diagram

```
┌──────────────────────────────────────────────────────────┐
│  hy_soc (top)                            ┌────────┐      │
│                                          │  SRAM  │      │
│  ┌────────────┐                          │  64KB  │      │
│  │ cm0_rst_   │                          └───▲────┘      │
│  │ sync       │                              │           │
│  └─────┬──────┘                              │           │
│  ┌─────┴──────┐    ┌──────────────────┐      │           │
│  │ Cortex-M0  ├───►│ ahb_interconnect ├──────┘           │
│  │ (manager)  │◄───┤  ├─ ahb_dcd      ├──────┐           │
│  │            │    │  ├─ ahb_slv_mux  ├──┐   │           │
│  │  IRQ[0] ◄─╂────╂──╂── uart_irq    │  │   │           │
│  └────────────┘    │  └─ default_slv  │  │   ▼           │
│                    └──────────────────┘  │ ┌────────┐    │
│                                          │ │ahb_led │    │
│         uart_tx_o ◄──┐                   │ └────────┘    │
│         uart_rx_i ──►│  ┌────────────┐   │               │
│                      └──┤  ahb_uart  │◄──┘               │
│                         │ (AHB→APB)  │                   │
│                         │ ┌────────┐ │                   │
│                         │ │cmsdk_  │ │                   │
│                         │ │apb_uart│ │                   │
│                         │ └────────┘ │                   │
│                         └────────────┘                   │
└──────────────────────────────────────────────────────────┘
```

## Changes from Lab 2

| Type | Description |
|------|-------------|
| **New** | `ahb_uart` — AHB-Lite to APB adapter wrapper (1 wait-state FSM) |
| **New** | `cmsdk_apb_uart` — CMSDK-compatible UART (Verilator-clean rewrite) |
| **Modified** | `hy_soc.v` — Added UART TX/RX ports and interrupt (`IRQ[0]`) routing |
| **Modified** | `ahb_dcd.v` — Added UART address region (3-to-1 decoding) |
| **Modified** | `ahb_slv_mux.v` — Expanded to 4-way mux |

## Key Concepts

- **AHB → APB Bridge**: `ahb_uart` converts AHB-Lite transfers to APB protocol (1 wait state)
- **CMSDK UART**: 100% register-map compatible with ARM CMSDK, ensuring software portability
- **Interrupt Routing**: UART IRQ → CM0 `IRQ[0]`
- **Loopback Test**: Testbench connects TX↔RX for self-test verification

## Memory Map

| Address Range | Device | Notes |
|---------------|--------|-------|
| `0x0000_0000` – `0x0000_FFFF` | SRAM (64KB) | `haddr[31:16] == 16'h0000` |
| `0x5000_0000` – `0x50FF_FFFF` | LED Controller | `haddr[31:24] == 8'h50` |
| `0x5100_0000` – `0x51FF_FFFF` | UART | `haddr[31:24] == 8'h51` |
| All other | Default Slave | ERROR response |

### UART Registers (Base: `0x5100_0000`)

| Offset | Name | Description |
|--------|------|-------------|
| `0x00` | DATA | W: TX data [7:0], R: RX data [7:0] |
| `0x04` | STATE | [3:0] = {rx_ovr, tx_ovr, rx_full, tx_full} |
| `0x08` | CTRL | [6]=HSTM [5:4]=ovr_int_en [3:2]=int_en [1:0]=en |
| `0x0C` | INTSTATUS | R: interrupt status / W: interrupt clear |
| `0x10` | BAUDDIV | [19:0] baud divider (minimum 16) |

## Directory Structure

```
lab3_m0_uart/
├── rtl/
│   ├── hy_soc.v              ← Top-level (UART TX/RX/IRQ added)
│   ├── ahb_interconnect.v    ← Interconnect (3 subordinates)
│   ├── ahb_dcd.v             ← Address decoder (SRAM + LED + UART)
│   └── ahb_slv_mux.v         ← 4-way response mux
├── tb/
│   └── tb_hy_soc.v           ← Testbench (UART loopback + uart_mon)
├── sw/
│   ├── test.c                ← SRAM + LED + UART integration test
│   ├── gcc/                  ← GCC build
│   └── arm/                  ← ARM Compiler build
├── fpga/
│   ├── nexys_a7/             ← Nexys A7-100T (USB-UART on-board)
│   │   ├── top_fpga.v        ← Board-specific top wrapper
│   │   ├── nexys_a7.xdc      ← Pin constraints
│   │   └── create_project.tcl
│   └── zybo_z7/              ← Zybo Z7-20 (UART via Pmod JE)
│       ├── top_fpga.v
│       ├── zybo_z7_20.xdc
│       └── create_project.tcl
├── host/
│   └── hy_term.py            ← Simple serial terminal for FPGA UART
└── Makefile
```

## Firmware (test.c) Behavior

1. **Test 1–2**: SRAM word/byte read/write
2. **Test 3**: LED write/read verification
3. **Test 4**: UART init → transmit string ("Hello from HY-SoC Lab3!")
4. **Test 5**: UART loopback — send `0xA5`, verify reception
5. All tests pass → **PASS**

## Build and Run

```bash
make clean && make all

# Simulator selection
make all SIM=vcs        # VCS (default)
make all SIM=verilator  # Verilator (-CFLAGS "-O2" applied automatically)
```

> **Note**: Verilator requires `-CFLAGS "-O2"` (default `-Os` may cause segfault with trace)

## FPGA Usage

### Vivado Project Creation

```bash
cd fpga/nexys_a7    # or fpga/zybo_z7
vivado -mode batch -source create_project.tcl
```

Then open the generated `.xpr` project in Vivado GUI, run synthesis, implementation,
and generate the bitstream. Program the FPGA via Hardware Manager.

### UART Pin Mapping

| Board | UART TX (FPGA→Host) | UART RX (Host→FPGA) | Notes |
|-------|---------------------|---------------------|-------|
| Nexys A7 | D4 | C4 | USB-UART bridge on-board |
| Zybo Z7 | V12 (Pmod JE) | W16 (Pmod JE) | External USB-UART adapter required |

### Prerequisites

The host tool requires **Python 3** and `pyserial`.

**macOS** (Python 3 is usually pre-installed via Xcode CLT or Homebrew):
```bash
python3 --version          # verify installation
pip3 install pyserial
```

**Windows** (download Python 3 from https://python.org — check **"Add Python to PATH"** during install):
```powershell
python --version           # verify installation
pip install pyserial
```

**Linux** (Python 3 is typically pre-installed):
```bash
pip3 install pyserial
```

### Serial Terminal (hy_term.py)

`host/hy_term.py` is a simple serial terminal for interacting with the FPGA UART.
After programming the FPGA, connect:

```bash
# Linux
python3 host/hy_term.py /dev/ttyUSB0

# macOS
python3 host/hy_term.py /dev/cu.usbserial-XXXX     # FTDI/CP2102
python3 host/hy_term.py /dev/cu.usbmodem-XXXX       # Nexys A7 on-board USB-UART

# Windows
python host/hy_term.py COM3
```

Press **Ctrl+]** to exit (on Windows, use **Ctrl+C**).

Settings: **115200 baud, 8N1** (8 data bits, no parity, 1 stop bit).

The firmware transmits `"Hello from HY-SoC Lab3!"` on startup and toggles LEDs.
On the Nexys A7, the USB-UART is available immediately via the micro-USB cable.
On the Zybo Z7, connect a USB-UART adapter (e.g., FTDI, CP2102) to Pmod JE.

> You can also use any other serial terminal such as `minicom`, `screen`,
> or `python3 -m serial.tools.miniterm`.

## Relationship to Next Lab

**Lab 4** adds Boot ROM + bootloader + remap for UART firmware upload.
