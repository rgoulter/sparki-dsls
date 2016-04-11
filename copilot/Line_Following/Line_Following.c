/*******************************************
 Sparki Line-following example

 Threshold is the value that helps you
 determine what's black and white. Sparki's
 infrared reflectance sensors indicate white
 as close to 900, and black as around 200.
 This example uses a threshold of 700 for
 the example, but if you have a narrow line,
 or perhaps a lighter black, you may need to
 adjust.
********************************************/

#include <Sparki.h> // include the sparki library
#include <stdint.h>
#include "copilot.h" // generated from LineFollowing.hs

// Utility functions for copilot

void updateLCD(int16_t lineLeft, int16_t lineCenter, int16_t lineRight) {
  sparki_clearLCD(); // wipe the screen

  sparki_textWrite_sz("Line Left: "); // show left line sensor on screen
  sparki_textWrite_i(lineLeft);
  sparki_textWriteln();

  sparki_textWrite_sz("Line Center: "); // show center line sensor on screen
  sparki_textWrite_i(lineCenter);
  sparki_textWriteln();

  sparki_textWrite_sz("Line Right: "); // show right line sensor on screen
  sparki_textWrite_i(lineRight);
  sparki_textWriteln();

  sparki_updateLCD(); // display all of the information written to the screen
}

void setup()
{
}

void loop() {
  // Use copilot
  step();

  delay(100);
}

int main(int argc, char *argv[])
{
    init();
    sparki_begin();
    setup();
    while(1) { loop(); }
    return 0;
}

