#include <stdio.h>
#include <avr/io.h>
#include <util/delay.h>

#define MYUBRR (((((F_CPU * 10) / (16L * BAUD)) + 5) / 10))

FILE mystdout;

int uart_putchar(char c, FILE *stream) {
    if (c == '\n')
        uart_putchar('\r', stream);
    loop_until_bit_is_set(UCSR1A, UDRE1);
    UDR1 = c;

    return 0;
}

void ioinit (void) {
    UBRR1H = MYUBRR >> 8;
    UBRR1L = MYUBRR;
    UCSR1B = (1<<RXEN1)|(1<<TXEN1);

    fdev_setup_stream(&mystdout, uart_putchar, NULL, _FDEV_SETUP_WRITE);
    stdout = &mystdout;
}

int main (void) {
    ioinit();

    printf("Hello World!\n");

    while(1) {
        printf("Hello world loop\n");
        _delay_ms(1000);
    }

    return(0);
}
