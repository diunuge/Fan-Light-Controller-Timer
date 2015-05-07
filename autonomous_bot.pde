/* Power Controller for MAS. 
*
* Set the clock to a time then loop over reading time and 
* output the time and date to the serial console.
*
* After loading and starting the sketch, use the serial monitor
* to see the device output.
*
* Diunuge Buddhika Wijesinghe
* diunuge.10@cse.mrt.ac.lk
*/ 
//#include <iostream>
#include <Wire.h>
#include <Rtc_Pcf8563.h>

#define FAN_POWER_PIN 2
#define FAN_POWER_PIN_2 3
#define LIGHT_POWER_PIN 4

//init the real time clock
Rtc_Pcf8563 rtc;
bool TEST;

typedef struct _time{
	unsigned int hour;
	unsigned int minute;
}diutime;

diutime time;
int timeVal;

void setup()
{
	Serial.begin( 9600 );
	Serial.write( "Starting.." );

	pinMode( FAN_POWER_PIN , OUTPUT );
	pinMode( FAN_POWER_PIN_2 , OUTPUT );
	pinMode( LIGHT_POWER_PIN , OUTPUT );

	digitalWrite( FAN_POWER_PIN , LOW );
	digitalWrite( FAN_POWER_PIN_2 , LOW );
	digitalWrite( LIGHT_POWER_PIN , LOW );
	
	//Comment when you do not need to set the clock
	//initClock( );

	//TEST = true;
	TEST = false;
}

void loop()
{
	if(TEST)
	{
		//both format functions call the internal getTime() so that the 
		//formatted strings are at the current time/date.
		Serial.write("Update..");
		//Serial.print(rtc.formatTime());
		//Serial.print("\r\n");
		//Serial.print(rtc.formatDate());
		//rtc.getAlarmWeekday();
		//Serial.print("\r\n");

		
		lights(true);
		//fans(true);
		delay(1000);
		lights(false);
		//fans(false);
		delay(1000);
		
	}
	else
	{
		//get time
		time.hour = rtc.getHour();
		time.minute = rtc.getMinute();
		timeVal = time.hour*100+time.minute;
		// 0700h - 0830h 
		// 1230h - 1400h
		// 1530h - 1700h
		if( (timeVal>=700 && timeVal<=830) || (timeVal>=1230 && timeVal<=1400) || (timeVal>=1530 && timeVal<=1700) )
		{
			//power up
			Serial.write("Powered up");		
			lights(true);
			fans(true);
		}
		else
		{
			Serial.write("Powered down");	
			lights(false);
			fans(false);
		}

		Serial.write("\tTime/Date:\t");
		Serial.print(rtc.formatTime());
		Serial.print("\t");
		Serial.print(rtc.formatDate());
		rtc.getAlarmWeekday();
		Serial.print("\r\n");
		delay(1000);
	}
}


void initClock()
{
	//clear out the registers
	rtc.initClock();
	//set a time to start with.
	//day, weekday, month, century(1=1900, 0=2000), year(0-99)
	rtc.setDate(26, 0, 4, 0, 15);
	//hr, min, sec
	rtc.setTime(18, 20, 50);
	Serial.write("Initialized..");

}

void lights(bool status){
	if(status){
		digitalWrite( LIGHT_POWER_PIN , HIGH );
	}
	else{
		digitalWrite( LIGHT_POWER_PIN , LOW );
	}
}

void fans(bool status){
	if(status){
		digitalWrite( FAN_POWER_PIN , HIGH );
		digitalWrite( FAN_POWER_PIN_2 , HIGH );
	}
	else{
		digitalWrite( FAN_POWER_PIN , LOW );
		digitalWrite( FAN_POWER_PIN_2 , LOW );
	}
}