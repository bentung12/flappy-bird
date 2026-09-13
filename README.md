# Flappy Bird on an FPGA

Playable Flappy Bird in SystemVerilog on a Terasic DE0-CV. Renders live to VGA without a processor or software.

**Stack:** SystemVerilog · Cyclone V (DE0-CV) · Quartus Prime 22.1 · VGA 640×480

![Demo](flappy_bird.gif)

## Highlights

- **No framebuffer.** Without enough on-chip RAM to store a frame, the design computes each pixel's color on the fly at 25 MHz.
- Sprites are inequalities instead of stored bitmaps. Bird and wall are bounding-box comparisons against the current pixel coordinate.
- Collision detection uses the same comparison already used for rendering.
- Full game loop in hardware: physics, scrolling walls, scoring, death latch, 2-second start-up grace period.
- 12-bit color (4 bits/channel), registered outputs, score on 7-segment displays.

## How it works

| Piece | Implementation |
|---|---|
| Rendering | Priority mux over bounding-box comparisons, evaluated per pixel |
| Bird position | Saturating counter, 480 states. Clamps at ceiling, does not wrap |
| Wall position | Wrapping counter, 640 states, decrements 1 px / 166,667 cycles (~3 ms) |
| Gravity | Bird falls 1 px / 150,000 cycles |
| Death | Latched flip-flop: bird box ∩ wall box, or `pix_y == 479` (floor) |
| Score | Two mod-10 counters, incremented when a wall clears the bird's x-range |

Ceiling clamps but doesn't kill, matching the original game. Only walls and the floor are lethal.

## Files

| File | Purpose |
|---|---|
| `flappy_bird.sv` | Top level. VGA controller + game engine + IO. |
| `game_engine.sv` | Physics, walls, collision, scoring, per-pixel color. |
| `vgaCtl.sv` | VGA timing. Pixel coords, pixel-valid, H/V sync. |
| `clock.sv` | ÷2 divider. 50 MHz → 25 MHz pixel clock. |
| `counter.sv` / `birdcounter.sv` | Parameterized wrapping / saturating counters. |
| `my_dff.sv` / `ourHex.sv` | D flip-flop with enable; BCD → 7-segment. |

## Build

1. Open `flappy_bird.qpf` in Quartus Prime 22.1
2. Compile, program `.sof` to a DE0-CV
3. `KEY0` flaps. Score on `HEX1:HEX0`.

## Limitations
- **Wall gaps are not truly random.** Free-running mod-250 counter sampled at a fixed interval. A linear-feedback shift register would fix it.
- **`wall_pos - 50` underflows** within 50 px of the left edge, breaking the wall's x-range test as it exits screen.
- Bird counter saturates at the top but wraps at the bottom. Masked by the death latch except during the start-up grace period.
