#include "DateTime.h"

int strToInt(char * str_input, int n) {		// str_input must be a valid str
	int result = 0;

	for (int i = 0; i < n; i++) {
		//if (str_input[i] >= 48 && str_input[i] <= 57) {
		//	result += (str_input[i] - 48) * pow(10, n - i - 1); // ASCII: '0' = 48
		//}
		result *= 10;
		result += str_input[i] - 48;
	}

	return result;
}

char* intToStr(int num, char* str_output) {

	for (int i = 3; i >= 0; i--) { // 4: string length
		int digit = num % 10;
		num /= 10;

		str_output[i] = digit + 48;
	}

	str_output[4] = 0; // add '\0'
	return str_output;
}

char* Date(int day, int month, int year, char* TIME) {
	char temp[5];

	/* Day */
	intToStr(day, temp);
	int i = 0, j = 0;
	if (day < 10) TIME[i++] = 48; // '0': 48
	while (i < 2) { // DD
		while (temp[j] == 48)
			j++;

		TIME[i++] = temp[j++];
	}
	TIME[i++] = 47; // DD/


	/* Month */
	intToStr(month, temp);
	j = 0;
	if (month < 10) TIME[i++] = 48;
	while (i < 5) { // DD/MM
		while (temp[j] == 48)
			j++;

		TIME[i++] = temp[j++];
	}
	TIME[i++] = 47; // DD/MM/


	/* Year */
	intToStr(year, temp);
	j = 0;
	while (i < 10) { // DD//MM//YYYY
		TIME[i++] = temp[j++];
	}
	TIME[i++] = 0; // DD/MM/YYYY + /0


	return TIME;
}

int Day(char* TIME) {
	return strToInt(TIME, 2);
}

int Month(char* TIME) {
	return strToInt(TIME + 3, 2);
}

int Year(char* TIME) {
	return strToInt(TIME + 6, 4);
}

int isLeap(int year) {
	if (year % 400 == 0)
		return 1;
	
	if (year % 100 == 0)
		return 0;
	
	if (year % 4 == 0)
		return 1;

	return 0;
}

int LeapYear(char* TIME) {
	int year = Year(TIME);

	return isLeap(year);
}

char* Weekday(char* TIME, char* str_output) {
	int MonthTable[12] = { 0,3,3,6,1,4,6,2,5,0,3,5 };

	int d = Day(TIME);

	int m, month = Month(TIME), leapYear = LeapYear(TIME);
	if (leapYear == 1) {
		if (month == 1) m = 6;
		if (month == 2) m = 2;
	}
	else m = MonthTable[month - 1];

	int year = Year(TIME);
	int y = year % 100;
	int c = year / 100 + 1;
	int q = y / 4;

	int sum = d + m + y + q + c - 1;
	int weekday = sum % 7;

	int i = 0;
	switch (weekday) {
	case 0:
		str_output[i++] = 83;		// 'S'
		str_output[i++] = 117;		// 'u'
		str_output[i++] = 110;		// 'n'
		break;
	case 1:
		str_output[i++] = 77;		// 'M'
		str_output[i++] = 111;		// 'o'
		str_output[i++] = 110;		// 'n'
		break;
	case 2:
		str_output[i++] = 84;		// 'T'
		str_output[i++] = 117;		// 'u'
		str_output[i++] = 101;		// 'e'
		str_output[i++] = 115;		// 's'
		break;
	case 3:
		str_output[i++] = 87;		// 'W'
		str_output[i++] = 101;		// 'e'
		str_output[i++] = 100;		// 'd'
		break;
	case 4:
		str_output[i++] = 84;		// 'T'
		str_output[i++] = 104;		// 'h'
		str_output[i++] = 117;		// 'u'
		str_output[i++] = 114;		// 'r'
		str_output[i++] = 115;		// 's'
		break;
	case 5:
		str_output[i++] = 70;		// 'F'
		str_output[i++] = 114;		// 'r'
		str_output[i++] = 105;		// 'i'
		break;
	case 6:
		str_output[i++] = 83;		// 'S'
		str_output[i++] = 97;		// 'a'
		str_output[i++] = 116;		// 't'
		break;
	}

	str_output[i] = 0;				// '/0'

	return str_output;
}

int GetTime(char* TIME_1, char* TIME_2) {
	int result = 0;
	int day_1 = Day(TIME_1), month_1 = Month(TIME_1), year_1 = Year(TIME_1);
	int day_2 = Day(TIME_2), month_2 = Month(TIME_2), year_2 = Year(TIME_2);

	char *t1 = nullptr, *t2 = nullptr;

	if (year_1 == year_2) return result;

	if (year_1 > year_2) {
		t1 = TIME_2;
		t2 = TIME_1;
		day_1 = Day(TIME_2), month_1 = Month(TIME_2), year_1 = Year(TIME_2);
		day_2 = Day(TIME_1), month_2 = Month(TIME_1), year_2 = Year(TIME_1);
	}

	result = year_2 - year_1 - 1;

	if (month_2 > month_1) 
		result += 1;

	if (month_2 == month_1) {
		if (day_2 >= day_1) 
			result += 1;
		else if (month_1 == 2) {
			int leapYear_1 = LeapYear(t1);
			int leapYear_2 = LeapYear(t2);

			if (leapYear_1 == 1 && day_1 == 29 && day_2 == 28)
				result += 1;

			if (leapYear_2 == 1 && day_2 == 29 && day_1 == 28)
				result += 1;
		}
	}

	return result;
}

void printNearLeapYear(char* TIME) {
	int year = Year(TIME);
	int i = 0;
	int d;
	
	if (LeapYear(TIME) == 1)
		d = 4;
	else
		d = 1;
	
	while (i < 2)
	{
		year += d;
		if (isLeap(year) == 1)
		{
			++i;
			cout << year;
			cout << endl;
		}
	}
}

char* Convert(char* TIME, char type) {	// size of str TIME must be at least 20
	char str[12];
	
	int i = 0;
	while (i < 11) {
		str[i] = TIME[i];
		++i;
	}
	
	/* Case: 'A' or 'a' */
	if (type == 65 || type == 97) {
		int i = 0;

		while (i < 2) {
			TIME[i] = str[i + 3];
			TIME[i + 3] = str[i];
			++i;
		}
	}
	else if (type == 66 || type == 98 || type == 67 || type == 99) {
		// Stored in .data (MIPS)
		char Month1[8] = "January";
		char Month2[9] = "February";
		char Month3[6] = "March";
		char Month4[6] = "April";
		char Month5[4] = "May";
		char Month6[5] = "June";
		char Month7[5] = "July";
		char Month8[7] = "August";
		char Month9[10] = "September";
		char Month10[8] = "October";
		char Month11[9] = "November";
		char Month12[9] = "December";
		
		char* month;	// A pointer to Month1 or Month2 or ... Month12
		switch (Month(TIME)) {
		case 1:
			month = Month1;
			break;
		case 2:
			month = Month2;
			break;
		case 3:
			month = Month3;
			break;
		case 4:
			month = Month4;
			break;
		case 5:
			month = Month5;
			break;
		case 6:
			month = Month6;
			break;
		case 7:
			month = Month7;
			break;
		case 8:
			month = Month8;
			break;
		case 9:
			month = Month9;
			break;
		case 10:
			month = Month10;
			break;
		case 11:
			month = Month11;
			break;
		case 12:
			month = Month12;
			break;
		}

		int i = 0;
		
		/* Case: 'B' or 'b' */
		if (type == 66 || type == 98) {
			// Month
			while (month[i] != 0) {
				TIME[i] = month[i];
				++i;
			}
			TIME[i] = 32;		// 32: ' '
			++i;
			
			// Month_DD,_
			int j = 0;
			while (j < 2) {
				TIME[i] = str[j];
				++i;
				++j;
			}
			TIME[i] = 44;		// 44: ','
			++i;
			TIME[i] = 32;		// 32: ' '
			++i;
			
			// Month_DD,_YYYY + '/0'
			j = 6;
			while (j < 11) {
				TIME[i] = str[j];
				++i;
				++j;
			}
		}

		/* Case: 'C' or 'c' */
		if (type == 67 || type == 99) {
			int j = 0;
			while (j < 2) {
				TIME[i] = str[j];
				++i;
				++j;
			}
			TIME[i] = 32; // DD_
			++i;

			j = 0;
			while (month[j] != 0) { 	// DD Month
				TIME[i] = month[j];
				++i;
				++j;
			}
			TIME[i] = 44; 	// DD Month,
			++i;
			TIME[i] = 32;
			++i;

			j = 6; // YYYY
			while (j < 11) { 	// DD Month, YYYY + '/0'
				TIME[i] = str[j];
				++i;
				++j;
			}
		}
	}
	
	return TIME;
}

int checkInput(char* str_input, int n) {
	if (str_input[n] != 0) // 0: '\0'
		return 0;

	int i = 0;
	while (i < n) {
		if (str_input[i] < 48 || str_input[i] > 57)
			return 0;
		i += 1;
	}

	return 1;
}

int checkMonth(char* str_input) {
	if (str_input[1] == 0) {
		str_input[2] = 0;
		str_input[1] = str_input[0];
		str_input[0] = 48;
	}

	int check = checkInput(str_input, 2); // 2: MM

	if (check == 1) {
		int m = strToInt(str_input, 2);
		
		if (m > 12) {
			check = 0;
		}
	}
	
	return check;
}

int checkDay(char* str_input, int m, int y) {
	int DoM[12] = { 31,28,31,30,31,30,31,31,30,31,30,31 };

	if (str_input[1] == 0) {
		str_input[2] = 0;
		str_input[1] = str_input[0];
		str_input[0] = 48;
	}

	int check = checkInput(str_input, 2); // 2: DD

	if (check == 1) {
		int d = strToInt(str_input, 2);

		int leapYear = isLeap(y);
		if (leapYear == 1 && m == 2) {
			if (d > DoM[m - 1] + 1)
				check = 0;
		}

		if (d > DoM[m - 1])
			check = 0;
	}

	return check;
}

void inputDate(char* TIME) {
	char str_input[10];

	/* Input Year */
	cout << "Year: "; gets_s(str_input);
	while (checkInput(str_input, 4) == 0) { // 4: YYYY
		cout << "Error: Invalid input" << endl;
		cout << "Year: "; gets_s(str_input);
	}
	int y = strToInt(str_input, 4);
	
	/* Input Month */
	cout << "Month: "; gets_s(str_input);
	while (checkMonth(str_input) == 0) {
		cout << "Error: Invalid input" << endl;
		cout << "Month: "; gets_s(str_input);
	}
	int m = strToInt(str_input, 2);

	/* Input Day */
	cout << "Day: "; gets_s(str_input);
	while (checkDay(str_input, m, y) == 0) {
		cout << "Error: Invalid input" << endl;
		cout << "Day "; gets_s(str_input);
	}
	int d = strToInt(str_input, 2);

	Date(d, m, y, TIME);
}
