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

char* Weekday(char* TIME) {
	// Stored in .data (MIPS)
	static char weekday0[] = "Sun";
	static char weekday1[] = "Mon";
	static char weekday2[] = "Tues";
	static char weekday3[] = "Wed";
	static char weekday4[] = "Thurs";
	static char weekday5[] = "Fri";
	static char weekday6[] = "Sat";
	
	int t[12] = { 0, 3, 2, 5, 0, 3, 
                      5, 1, 4, 6, 2, 4 };
	
	int d = Day(TIME);
	int m = Month(TIME);
	int y = Year(TIME);
	
	if (m < 3)
		--y;
	
	int s = y + y / 4 - y / 100 + y / 400 + t[m - 1] + d;
	
	switch(s % 7)
	{
	case 0:
		return weekday0;
	case 1:
		return weekday1;
	case 2:
		return weekday2;
	case 3:
		return weekday3;
	case 4:
		return weekday4;
	case 5:
		return weekday5;
	case 6:
		return weekday6;
	}
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
		char month[12];
		int m = Month(TIME);

		switch (m) {
		case 1:
			month[0] = 74;		// 'J'
			month[1] = 97;		// 'a'
			month[2] = 110;		// 'n'
			month[3] = 117;		// 'u'
			month[4] = 97;		// 'a'
			month[5] = 114;		// 'r'
			month[6] = 121;		// 'y'
			month[7] = 0;		// '/0'
			break;
		case 2:
			month[0] = 70;		// 'F'
			month[1] = 101;		// 'e'
			month[2] = 98;		// 'b'
			month[3] = 114;		// 'r'
			month[4] = 117;		// 'u'
			month[5] = 97;		// 'a'
			month[6] = 114;		// 'r'
			month[7] = 121;		// 'y'
			month[8] = 0;		// '/0'
			break;
		case 3:
			month[0] = 77;		// 'M'
			month[1] = 97;		// 'a'
			month[2] = 114;		// 'r'
			month[3] = 99;		// 'c'
			month[4] = 104;		// 'h'
			month[5] = 0;		// '/0'
			break;
		case 4:
			month[0] = 65;		// 'A'
			month[1] = 112;		// 'p'
			month[2] = 114;		// 'r'
			month[3] = 105;		// 'i'
			month[4] = 108;		// 'l'
			month[5] = 0;		// '/0'
			break;
		case 5:
			month[0] = 77;		// 'M'
			month[1] = 97;		// 'a'
			month[2] = 121;		// 'y'
			month[3] = 0;		// '/0'
			break;
		case 6:
			month[0] = 74;		// 'J'
			month[1] = 117;		// 'u'
			month[2] = 110;		// 'n'
			month[3] = 101;		// 'e'
			month[4] = 0;		// '/0'
			break;
		case 7:
			month[0] = 74;		// 'J'
			month[1] = 117;		// 'u'
			month[2] = 108;		// 'l'
			month[3] = 121;		// 'y'
			month[4] = 0;		// '/0'
			break;
		case 8:
			month[0] = 65;		// 'A'
			month[1] = 117;		// 'u'
			month[2] = 103;		// 'g'
			month[3] = 117;		// 'u'
			month[4] = 115;		// 's'
			month[5] = 116;		// 't'
			month[6] = 0;		// '/0'
			break;
		case 9:
			month[0] = 83;		// 'S'
			month[1] = 101;		// 'e'
			month[2] = 112;		// 'p'
			month[3] = 116;		// 't'
			month[4] = 101;		// 'e'
			month[5] = 109;		// 'm'
			month[6] = 98;		// 'b'
			month[7] = 101;		// 'e'
			month[8] = 114;		// 'r'
			month[9] = 0;		// '/0'
			break;
		case 10:
			month[0] = 79;		// 'O'
			month[1] = 99;		// 'c'
			month[2] = 116;		// 't'
			month[3] = 111;		// 'o'
			month[4] = 98;		// 'b'
			month[5] = 101;		// 'e'
			month[6] = 114;		// 'r'
			month[7] = 0;		// '/0'
			break;
		case 11:
			month[0] = 78;		// 'N'
			month[1] = 111;		// 'o'
			month[2] = 118;		// 'v'
			month[3] = 101;		// 'e'
			month[4] = 109;		// 'm'
			month[5] = 98;		// 'b'
			month[6] = 101;		// 'e'
			month[7] = 114;		// 'r'
			month[8] = 0;		// '/0'
			break;
		case 12:
			month[0] = 68;		// 'D'
			month[1] = 101;		// 'e'
			month[2] = 99;		// 'c'
			month[3] = 101;		// 'e'
			month[4] = 109;		// 'm'
			month[5] = 98;		// 'b'
			month[6] = 101;		// 'e'
			month[7] = 114;		// 'r'
			month[8] = 0;		// '/0'
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
