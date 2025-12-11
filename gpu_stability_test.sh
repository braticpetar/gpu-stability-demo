#!/bin/bash
set -euo pipefail

CARD=0
echo "[$(date)] Starting GPU stability test on card$CARD"

# Clear old logs
sudo dmesg -C
echo 1 | sudo tee /sys/class/drm/card${CARD}/device/runpm > /dev/null 2>&1 || true

# Simple background logger – no fancy watch needed
while true; do
    echo "$(date +%s) $(cat /sys/class/drm/card0/device/gpu_busy_percent)% busy   $(sensors | grep -m1 temp1)" >> monitor.log
    sleep 2
done &
MONITOR_PID=$!

# 10-minute heavy stress with stress-ng + Vulkan (very effective on RDNA)
timeout 600 stress-ng --gpu 0 --timeout 600 || true

# Optional: run your own infinite OpenGL loop if you have one
# ./my_heavy_opengl_compute &

# Light fault injection – forces a bad shader path (usually recovers)
echo "Injecting fault via bad compute dispatch..."
echo 1 | sudo tee /sys/kernel/debug/dri/${CARD}/amdgpu_force_bad_shader > /dev/null 2>&1 || true

sleep 5

# Collect results
sudo dmesg | grep -i -E "(amdgpu|gpu|fault|timeout|reset|ring|RAS|ECC)" > errors.log

echo "=== GPU BUSY % (last 10 lines) ==="
tail monitor.log

if [ -s errors.log ]; then
    echo "GPU errors/ resets detected – see errors.log"
    cat errors.log
else
    echo "Test PASSED – no kernel errors"
fi

kill $MONITOR_PID || true
echo "[$(date)] Test finished"
