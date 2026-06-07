/*
 * startup_cm0.S — Cortex-M0 startup for HY-SoC Lab3 (Arm Compiler 6 / armclang)
 *
 * UART uses polling, no IRQ handler needed.
 * IRQ0 slot reserved for UART interrupt (future use).
 */
    .syntax unified
    .cpu cortex-m0
    .thumb

/* ---------- Stack top (matches scatter.sct ARM_LIB_STACK) ---------- */
    .equ    __initial_sp, 0x00010000    /* SRAM 64 KB top */
    .globl  __initial_sp

/* ---------- Vector Table (RESET area) ---------- */
    .section RESET, "a", %progbits
    .p2align 3
    .globl  __Vectors
    .globl  __Vectors_End
    .globl  __Vectors_Size

__Vectors:
    .word   __initial_sp        /* 0x00: Initial Stack Pointer          */
    .word   Reset_Handler       /* 0x04: Reset                          */
    .word   NMI_Handler         /* 0x08: NMI                            */
    .word   HardFault_Handler   /* 0x0C: Hard Fault                     */
    .rept   12
    .word   Default_Handler     /* 0x10-0x3C: reserved + SysTick        */
    .endr
    .word   Default_Handler     /* 0x40: IRQ0 (UART) — reserved         */
    .rept   15
    .word   Default_Handler     /* 0x44-0x7C: IRQ1-15                   */
    .endr
__Vectors_End:

    .equ __Vectors_Size, __Vectors_End - __Vectors

/* ---------- Reset Handler ---------- */
    .section .text
    .p2align 2
    .thumb_func
    .globl  Reset_Handler
    .type   Reset_Handler, %function
Reset_Handler:
    ldr     r0, =__main         /* Arm C library: scatter-load + __rt_entry → main() */
    bx      r0

/* ---------- Default Handlers (weak) ---------- */
    .thumb_func
    .weak   NMI_Handler
    .type   NMI_Handler, %function
NMI_Handler:
    b       .

    .thumb_func
    .weak   HardFault_Handler
    .type   HardFault_Handler, %function
HardFault_Handler:
    b       .

    .thumb_func
    .weak   Default_Handler
    .type   Default_Handler, %function
Default_Handler:
    b       .

    .end
