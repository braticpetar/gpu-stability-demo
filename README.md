# gpu-stability-demo
AMD GPU Stability and Ring Timeout Demo

### Hardware
- AMD Radeon RX 7600 XT (Navi 33, RDNA3)
- Fully open-source stack: linux 6.12, Mesa 25.x, radeonsi

### Contents

- `gpu_stability_test.sh`  
  Fully automated 10-minute stability run:
  - Disables runtime PM
  - Background GPU utilisation + temperature logging
  - Heavy OpenGL compute stress via stress-ng
  - Optional fault injection
  - Automatic collection of amdgpu-related kernel messages
 
- `hang_me.c`  
  ~20-line reproducer that deliberately exhausts all VRAM (1 GB textures in a loop).  
  Reliably triggers a real ring_gfx timeout → GPU fault → driver-initiated GPU reset within 30–90 seconds.  
  Used to generate authentic devcoredumps and reset logs for analysis.


### Why this exists
AMD driver validation:
- Stress workloads
- Targeted fault injection
- Automated parsing of dmesg for ring timeouts, RAS events, ECC errors

I created this as a test / demo generation of kernel level GPU resets, when I need fresh logs for learning or bug reporting.

**Be careful when cloning this repo and running, it can highly increase GPU temperature or crash it completely!**
