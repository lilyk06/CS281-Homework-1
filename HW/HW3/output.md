# HW3 Output

Notice the process to build and run the demo.  The goal is to print a message to the console every 5 seconds for 10 iterations.  

The first approach attempt timing it by polling.  Notice the loop was traversed a total of `499938` times.  The second approach configured a hardware clock and had the clock iterrupt the main loop.  This demo traversed the loop exactly `10` times.

```bash
bsm23@RISCV:~/SysArch-DGL/HW-DEMOS/HW3$ make
riscv64-unknown-elf-as -march=rv32im_zicsr -mabi=ilp32 -mno-relax -o bootstrap.o bootstrap.s
riscv64-unknown-elf-as -march=rv32im_zicsr -mabi=ilp32 -mno-relax -o poll_demo.o poll_demo.s
riscv64-unknown-elf-ld -m elf32lriscv --no-relax -o poll_demo.elf bootstrap.o poll_demo.o
riscv64-unknown-elf-as -march=rv32im_zicsr -mabi=ilp32 -mno-relax -o interrupt_demo.o interrupt_demo.s
riscv64-unknown-elf-ld -m elf32lriscv --no-relax -o interrupt_demo.elf bootstrap.o interrupt_demo.o
bsm23@RISCV:~/SysArch-DGL/HW-DEMOS/HW3$ make run-poll
renode poll_demo.resc

(renode:80206): Gdk-CRITICAL **: 08:50:39.780: gdk_keymap_get_for_display: assertion 'GDK_IS_DISPLAY (display)' failed
08:50:39.7879 [WARNING] Couldn't start UI - falling back to console mode
08:50:40.0508 [INFO] Loaded monitor commands from: /home/bsm23/renode/scripts/monitor.py
Renode, version 1.16.1 (78ef6f6e-202606150233)

(monitor) i $CWD/poll_demo.resc
08:50:40.1458 [INFO] Including script(s): /home/bsm23/SysArch-DGL/HW-DEMOS/HW3/poll_demo.resc
08:50:40.1560 [INFO] System bus created.
08:50:40.4468 [WARNING] Translation cache size 536870912 is larger than maximum allowed 134217728. It will be clamped to maximum
08:50:40.6054 [INFO] sysbus: Loading block of 818 bytes length at 0x10000.
08:50:40.6240 [INFO] cpu: Setting PC value to 0x10074.
08:50:40.7257 [INFO] Old file /home/bsm23/renode/poll_demo_uart.log moved to /home/bsm23/renode/poll_demo_uart.log.4
Starting emulation...
08:50:40.7317 [INFO] poll_demo: Machine started.
(poll_demo) 08:50:43.2482 [INFO] uart: [host: 2.62s (+2.62s)|virt: 50.7ms (+50.7ms)] poll_demo: busy-polling, watch the CPU work for every tick
08:50:44.8968 [INFO] uart: [host: 4.27s (+1.65s)|virt:     0.1s (+50ms)] poll_demo: loop 1 of 10, iterations so far = 454542
08:50:46.5200 [INFO] uart: [host: 5.89s (+1.62s)|virt:    0.15s (+50ms)] poll_demo: loop 2 of 10, iterations so far = 904533
08:50:46.5260 [INFO] uart: [host: 5.9s (+6.09ms)|virt:   0.15s (+0.5ms)] poll_demo: loop 3 of 10, iterations so far = 1353619
08:50:49.8263 [INFO] uart: [host:   9.2s (+3.3s)|virt:  0.25s (+99.5ms)] poll_demo: loop 4 of 10, iterations so far = 1803609
08:50:51.4501 [INFO] uart: [host: 10.82s (+1.62s)|virt:     0.3s (+50ms)] poll_demo: loop 5 of 10, iterations so far = 2252693
08:50:53.1277 [INFO] uart: [host:  12.5s (+1.68s)|virt:    0.35s (+50ms)] poll_demo: loop 6 of 10, iterations so far = 2701780
08:50:54.7854 [INFO] uart: [host: 14.16s (+1.66s)|virt:     0.4s (+50ms)] poll_demo: loop 7 of 10, iterations so far = 3151771
08:50:56.4367 [INFO] uart: [host: 15.81s (+1.65s)|virt:    0.45s (+50ms)] poll_demo: loop 8 of 10, iterations so far = 3600856
08:50:58.1335 [INFO] uart: [host:  17.51s (+1.7s)|virt:     0.5s (+50ms)] poll_demo: loop 9 of 10, iterations so far = 4049946
08:50:58.1420 [INFO] uart: [host: 17.51s (+8.54ms)|virt:    0.5s (+0.7ms)] poll_demo: loop 10 of 10, iterations so far = 4499938
08:50:58.2876 [INFO] uart: [host:  17.66s (+0.15s)|virt:     0.7s (+0.2s)] poll_demo: done, final iteration count = 4499938
quit
Renode is quitting
08:51:09.6559 [INFO] poll_demo: Machine paused.
08:51:09.6643 [INFO] poll_demo: Disposed.
bsm23@RISCV:~/SysArch-DGL/HW-DEMOS/HW3$ 
bsm23@RISCV:~/SysArch-DGL/HW-DEMOS/HW3$ make run-int
renode interrupt_demo.resc

(renode:80382): Gdk-CRITICAL **: 08:51:17.578: gdk_keymap_get_for_display: assertion 'GDK_IS_DISPLAY (display)' failed
08:51:17.5838 [WARNING] Couldn't start UI - falling back to console mode
08:51:17.8698 [INFO] Loaded monitor commands from: /home/bsm23/renode/scripts/monitor.py
Renode, version 1.16.1 (78ef6f6e-202606150233)

(monitor) i $CWD/interrupt_demo.resc
08:51:17.9635 [INFO] Including script(s): /home/bsm23/SysArch-DGL/HW-DEMOS/HW3/interrupt_demo.resc
08:51:17.9746 [INFO] System bus created.
08:51:18.2730 [WARNING] Translation cache size 536870912 is larger than maximum allowed 134217728. It will be clamped to maximum
08:51:18.4356 [INFO] sysbus: Loading block of 705 bytes length at 0x10000.
08:51:18.4511 [INFO] cpu: Setting PC value to 0x10080.
08:51:18.5264 [INFO] Old file /home/bsm23/renode/interrupt_demo_uart.log moved to /home/bsm23/renode/interrupt_demo_uart.log.4
Starting emulation...
08:51:18.5327 [INFO] interrupt_demo: Machine started.
08:51:18.7342 [INFO] uart: [host: 0.28s (+0.28s)|virt: 0.2s (+0.2s)] interrupt_demo: wfi (truly idle) until an interrupt wakes the CPU
08:51:23.8737 [INFO] uart: [host: 5.42s (+5.14s)|virt: 5.34s (+5.14s)] interrupt_demo: loop 1 of 10
08:51:28.8792 [INFO] uart: [host: 10.42s (+5.01s)|virt: 10.35s (+5.01s)] interrupt_demo: loop 2 of 10
08:51:33.8793 [INFO] uart: [host:    15.42s (+5s)|virt:    15.35s (+5s)] interrupt_demo: loop 3 of 10
08:51:38.8798 [INFO] uart: [host:    20.43s (+5s)|virt:    20.35s (+5s)] interrupt_demo: loop 4 of 10
08:51:43.8805 [INFO] uart: [host:    25.43s (+5s)|virt:    25.35s (+5s)] interrupt_demo: loop 5 of 10
08:51:48.8808 [INFO] uart: [host:    30.43s (+5s)|virt:    30.35s (+5s)] interrupt_demo: loop 6 of 10
08:51:53.8822 [INFO] uart: [host:    35.43s (+5s)|virt:    35.35s (+5s)] interrupt_demo: loop 7 of 10
08:51:58.8830 [INFO] uart: [host:    40.43s (+5s)|virt:    40.35s (+5s)] interrupt_demo: loop 8 of 10
08:52:03.8832 [INFO] uart: [host:    45.43s (+5s)|virt:    45.35s (+5s)] interrupt_demo: loop 9 of 10
(interrupt_demo) 08:52:08.8871 [INFO] uart: [host:    50.43s (+5s)|virt:    50.35s (+5s)] interrupt_demo: loop 10 of 10
quit
Renode is quitting
08:52:22.9216 [INFO] interrupt_demo: Machine paused.
08:52:22.9276 [INFO] interrupt_demo: Disposed.
bsm23@RISCV:~/SysArch-DGL/HW-DEMOS/HW3$ make clean
rm -f *.o *.elf
bsm23@RISCV:~/SysArch-DGL/HW-DEMOS/HW3$ 
```