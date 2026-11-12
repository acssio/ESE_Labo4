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

## Task 2
### Variadic function
To do this variadic function, we will use more or less this following algorithm

```c
int nbLed // In r4, tells us how many parameters there is
int idx   // 

for(idx = 0; idx < 2; idx ++){
    nbLed--;
    ledsCommand(r,g,b,lum);
    if(nbLed == 0) return;
}

while(nbLed >= 0){

}

return;

```