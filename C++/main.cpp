#include "DateTime.h"


int main() {
	char TIME_1[11]; // DD/MM/YYYY: 10 + '/0'
	char TIME_2[11];
	char str_output[20];

	inputDate(TIME_1);

	cout << TIME_1 << endl;
	cout << Date(29, 2, 2020, TIME_2) << endl;
	cout << "Different year: " <<  GetTime(TIME_1, TIME_2) << endl;
	cout << "Near leap year: "; printNearLeapYear(TIME_1); cout << endl;
	cout << Convert(TIME_1, 'C', str_output);
}