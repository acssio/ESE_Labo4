# ESE_Labo4
## Task 1
To control the led, the concept code in C that will be used is the following. I used an arduino-like writing beacause it is easy to understand

```c
void writeDataLed(uint32_t dataToWrite){
    for(int idx = 31; idx >= 0; idx --){
        digitalWrite(ClockPin, 0);
        digitalWrite(DataPin, dataToWrite>>idx);
        digitalWrite(ClockPin, 1);
    }
}
```
