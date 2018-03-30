#include <FrequencyTimer2.h>
#include <TimerOne.h>
#include <TimerThree.h>

#define DIR1 24
#define STEP1 2
#define DIR2 25
#define STEP2 3
#define DIR3 26
#define STEP3 5

void setup() {
  analogWrite(STEP1, 10);
  analogWrite(STEP2, 10);
  analogWrite(STEP3, 10);
  digitalWrite(DIR1,HIGH);
  analogWriteFrequency(STEP1, 1000); // pin 3 also changes

  digitalWrite(DIR2,HIGH);
  analogWriteFrequency(STEP2, 1000); // pins 7, 8, 14, 35, 36, 37, 38 also change

  digitalWrite(DIR3,HIGH);
  analogWriteFrequency(STEP3, 1000); // pins 6, 9, 10, 20, 21, 22, 23 also change
}

void loop() {

}