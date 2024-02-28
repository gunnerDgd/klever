## KLEVER - CMake Linux Kernel / Kernel Module Toolset

---


## Use with CLion

---

- First of all, **build and generate** kernel image (bzImage). Just build (Kernel Name)-build target in CLion.

<img src="docs/03.png" width="500">

- When build progress finished, open CLion's Run / Debug Configuration.

<img src="docs/01.png" width="500">

- Add **"Remote Debug"** to attach GDB (Debugger) to compiled kernel, which is being run at QEMU.

<img src="docs/02.png" width="700">

- Set name, symbol file (vmlinux) 's location and QEMU's local provision port at configuration.
- **Default GDB provision port is "1234".**

<img src="docs/04.png" width="700">

- Execute QEMU by **pressing "build" button** for CMake target added with add_kernel_target().

<img src="docs/05.png" width="700">

- QEMU window will appear and kernel will wait any GDB connection. 

<img src="docs/06.png" width="700">

- Let's Set Breakpoint at start_kernel() function, the entrypoint of the Linux kernel.
- **start_kernel() function is located at (Kernel Path)/init/main.c.**

<img src="docs/07.png" width="700">

- Run GDB using setting we have made. This will resume the QEMU machine and invoke breakpoint.
- If kernel stopped execution at the breakpoint we set, You're ready to go!

<img src="docs/08.png" width="700">
<img src="docs/09.png" width="700">