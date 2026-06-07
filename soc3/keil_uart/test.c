/*
 * test.c — HY-SoC Lab3: LED + UART test
 *
 * Test items:
 *   1. SRAM word write/read verification
 *   2. SRAM byte write/read verification
 *   3. LED write/read verification
 *   4. UART init and string transmission (uart_mon prints via $display)
 *   5. UART loopback receive verification (TB connects TX->RX)
 */

#include "hy_soc.h"

/* Completion signal (testbench handshake) */
#define DONE_ADDR  (*(volatile uint32_t *)0x00007FFCu)
#define PASS_CODE  0x900DD00Du
#define FAIL_CODE  0xDEADDEADu

static void fail(void) {
    DONE_ADDR = FAIL_CODE;
    while (1);
}

/* UART helpers (local) */
static void uart_init(void) {
    HY_UART->BAUDDIV = 434u;      // minimum divider → fastest normal baud rate
    HY_UART->CTRL    = HY_UART_CTRL_RX_EN | HY_UART_CTRL_TX_EN;
    // NOTE: CMSDK UART HSTM (high-speed test mode) only accelerates TX,
    //       so it cannot be used for loopback tests.  BAUDDIV=16 is the minimum (fastest).
}

static void uart_puts(const char *s) {
    while (*s) hy_uart_putc((uint8_t)*s++);
}

int main(void) {
    volatile uint32_t *wptr = (volatile uint32_t *)0x00001000u;
    volatile uint8_t  *bptr = (volatile uint8_t  *)0x00002000u;

    /* --- Test 1: Word write/read --- */
    wptr[0] = 0xA5A5A5A5u;
    wptr[1] = 0x12345678u;
    if (wptr[0] != 0xA5A5A5A5u) fail();
    if (wptr[1] != 0x12345678u) fail();

    /* --- Test 2: Byte write/read --- */
    bptr[0] = 0x11u;
    bptr[1] = 0x22u;
    bptr[2] = 0x33u;
    bptr[3] = 0x44u;
    if (bptr[0] != 0x11u) fail();
    if (bptr[1] != 0x22u) fail();
    if (bptr[2] != 0x33u) fail();
    if (bptr[3] != 0x44u) fail();

    /* --- Test 3: LED write/read --- */
    HY_LED->DATA = 0x05u;
    if ((HY_LED->DATA & 0xFFu) != 0x05u) fail();
    HY_LED->DATA = 0x0Au;
    if ((HY_LED->DATA & 0xFFu) != 0x0Au) fail();
    HY_LED->DATA = 0x0Fu;
    if ((HY_LED->DATA & 0xFFu) != 0x0Fu) fail();

    /* --- Test 4: UART TX (uart_mon prints via $display) --- */
    uart_init();
    uart_puts("2023066980_Kimyoungjin\n");

    /* --- Test 5: UART loopback (TB connects TX->RX) --- */
    {
        volatile int i;
        for (i = 0; i < 5000; i++) __NOP();  /* wait for TX serialization */
    }
    /* Drain previous loopback data */
    while (HY_UART->STATE & HY_UART_STATE_RX_FULL)
        (void)HY_UART->DATA;
    /* Clear overrun flags */
    HY_UART->STATE = HY_UART_STATE_TX_OVR | HY_UART_STATE_RX_OVR;

    /* Send 0xA5 and verify loopback reception */
    hy_uart_putc(0xA5u);

    {
        volatile int timeout = 50000;
        while (!(HY_UART->STATE & HY_UART_STATE_RX_FULL) && --timeout > 0);
        if (timeout <= 0) fail();
    }
    if (hy_uart_getc() != 0xA5u) fail();

    DONE_ADDR = PASS_CODE;
    while (1);
    return 0;
}
