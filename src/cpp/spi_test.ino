#include <SPI.h>

int mode = 0;
uint8_t ptr[15];
int bytecount = 0;

ISR(SPI_STC_vect)
{
    ptr[bytecount++] = SPDR;
    if (bytecount == 9 && ptr[0] == 0x08) {
        mode = 1;
        Serial.println("Receive Mode in Arduino");
        bytecount = 0;
    } else if (bytecount == 13) {
        mode = 2;
        Serial.println("Send Mode in Arduino");
        bytecount = 0;
    }
}

void setup()
{
    // put your setup code here, to run once:
    pinMode(MISO, OUTPUT);
    pinMode(MOSI, INPUT);
    pinMode(SCK, INPUT);
    pinMode(SS, INPUT);

    SPCR |= _BV(SPE);
    SPCR &= ~_BV(MSTR);
    SPCR |= _BV(SPIE);

    SPI.setClockDivider(5000000);
    SPI.attachInterrupt();

    Serial.begin(9600);
}

void loop()
{
    // put your main code here, to run repeatedly:
    if (mode == 1) {
        for (int i = 0; i < 9; i++) {
            Serial.print(i);
            Serial.print(": ");
            Serial.println(ptr[i]);
        }
        mode = 0;
    } else if (mode == 2) {
        byte write_buffer[13] = { 0x00, 0x01, 0x03, 0x05, 0x07, 0x06, 0x15, 0x94, 0x45, 0x95, 0x12, 0x65, 0x04 };
        for (int i = 0; i < 13; i++)
            SPI.transfer(write_buffer[i]);
        mode = 0;
    }
}