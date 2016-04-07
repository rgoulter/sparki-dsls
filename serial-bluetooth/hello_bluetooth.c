// Use Sparki's UART1 for communication.

#include <stdio.h>
#include <avr/io.h>
#include <util/delay.h>

#define MYUBRR (((((F_CPU * 10) / (16L * BAUD)) + 5) / 10))

FILE mystdout, mystdin;

int uart_putchar(char c, FILE *stream) {
    if (c == '\n')
        uart_putchar('\r', stream);
    loop_until_bit_is_set(UCSR1A, UDRE1);
    UDR1 = c;

    return 0;
}

char uart_getchar(FILE *stream) {
    loop_until_bit_is_set(UCSR1A, RXC1); /* Wait until data exists. */
    return UDR1;
}

void ioinit (void) {
    UBRR1H = MYUBRR >> 8;
    UBRR1L = MYUBRR;
    UCSR1B = (1<<RXEN1)|(1<<TXEN1);

    // n.b. CAN'T do it following way, in case you were wondering:
    //  FILE mystdout = FDEV_SETUP_STREAM(uart_putchar, uart_getchar, _FDEV_SETUP_RW);

    fdev_setup_stream(&mystdout, uart_putchar, NULL, _FDEV_SETUP_WRITE);
    fdev_setup_stream(&mystdin,  NULL, uart_getchar, _FDEV_SETUP_READ);

    stdout = &mystdout;
    stdin = &mystdin;
}

int main (void) {
    ioinit();

    printf("Hello World!\n");

    char input;

    while(1) {
        printf("Hello world loop\n");

        input = getchar();

        printf("Received char '%c'\n", input);
    }

    return(0);
}
