# Flappy Bird on FPGA (DE0-CV)

An FPGA implementation of **Flappy Bird**, designed for the **Terasic DE0-CV (Cyclone V)** development board.  
The game renders in real-time to a **VGA monitor** and displays the score on the on-board **7-segment HEX displays**.

---

## 🎮 Demo


![Flappy Bird Demo](flappy_bird.gif)

---

## ✨ Features

- Real-time VGA output at **640×480 @ 60 Hz** (25 MHz pixel clock).
- 12-bit color graphics (4 bits per R/G/B channel).
- Flappy Bird gameplay:
  - Bird controlled with the **KEY0 button** (jump).
  - Randomized wall gaps scrolling across the screen.
  - Collision detection with pipes and floor/ceiling.
  - Score increments when passing through a wall gap.
- Score displayed on the on-board **HEX0 / HEX1** 7-segment displays.
- Resettable via the **reset signal (`rst`)**.

---

## 🛠️ Hardware Requirements

- **Terasic DE0-CV (Cyclone V)** development board
- **VGA monitor** + standard VGA cable
- **USB-Blaster** (for programming via Quartus)
- On-board push buttons:
  - `KEY0`: Jump
  - `rst`: Reset

---

## 📂 Repository Structure

| File | Description |
|------|-------------|
| `flappy_bird.sv` | Top-level module. Connects VGA controller, game engine, and IO (buttons, HEX displays). |
| `game_engine.sv` | Core game logic: bird physics, wall movement, scoring, collision detection, color outputs. |
| `vgaCtl.sv` | VGA timing generator (640×480 @ 60Hz). Produces pixel (x,y) coords, sync signals, frame ID. |
| `clock.sv` | Clock divider / generator for pixel timing. |
| `counter.sv` | Generic up/down counter with wrapping. |
| `birdcounter.sv` | Specialized counter for bird position / score counting. |
| `my_dff.sv` | Simple D flip-flop with async reset (utility module). |
| `ourHex.sv` | Drives HEX0 / HEX1 7-segment displays for score output. |
| `flappy_bird.qpf` | Quartus project file. |
| `flappy_bird.qsf` | Quartus settings & pin assignments (DE0-CV specific). |
| `c5_pin_model_dump.txt` | Pin model dump (Cyclone V reference). |

---

## 🚀 Build & Run Instructions

1. Open the project in **Quartus Prime Standard 22.1** (or matching version).
   - Load `flappy_bird.qpf`.
2. Connect your DE0-CV board to your PC via USB-Blaster.
3. Compile the project (`Ctrl+L` in Quartus).
4. Program the FPGA with the generated `.sof` bitstream.
5. Connect a VGA monitor to the DE0-CV’s VGA port.
6. Press **KEY0** to flap.  
   - Score will appear on **HEX0/HEX1**.  
   - Press **reset** (`rst`) to restart the game.

---

## 🎛️ Controls

- **KEY0** → Jump
- **Reset (rst)** → Restart game
- **HEX0 / HEX1** → Score display (decimal)

---

## ⚙️ Customization

- **Difficulty**  
  Adjust wall speed, gap size, or gravity/jump impulse inside `game_engine.sv`.
- **Graphics**  
  Change color assignments in the rendering logic.
- **Scoring**  
  Modify scoring conditions or display logic (`ourHex.sv`).

---

## 🐞 Troubleshooting

- **No VGA signal** → Check clock divider (`clock.sv`) and ensure pixel clock ~25 MHz.  
- **Wrong colors** → Verify VGA pin assignments in `flappy_bird.qsf`.  
- **No response to KEY0** → Confirm button debounce / pin mapping in `.qsf`.  
- **HEX displays blank** → Ensure `ourHex.sv` is instantiated in `flappy_bird.sv`.

---

---

## 👤 Author

FPGA project by **Benjamin Tung**.  
Built for learning digital design, VGA controllers, and real-time game logic on FPGAs.
