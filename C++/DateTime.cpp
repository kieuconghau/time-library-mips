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
	int leapYear = LeapYear(TIME);

	if (leapYear == 1) {
		int count = 0;
		int year = Year(TIME) + 1;

		/* Find 2 following leap years */
		while (count < 2) {
			int flag = isLeap(year);
			if (flag == 1) {
				cout << year << " ";
				count += 1;
			}
			year += 1;
		}
	}
	else {
		/* Find previous leap year */
		int year = Year(TIME) - 1;
		while (true) {
			int flag = isLeap(year);
			if (flag == 1) {
				cout << year << " ";
				break;
			}
			year -= 1;
		}

		/* Find following leap year */
		year = Year(TIME) + 1;
		while (true) {
			int flag = isLeap(year);
			if (flag == 1) {
				cout << year << " ";
				break;
			}
			year += 1;
		}
	}
}

char* Convert(char* TIME, char type, char* str_output) {
	/* Case: 'A' or 'a' */
	if (type == 65 || type == 97) {
		int i = 0;

		while (i < 3) {	// MM/
			str_output[i++] = TIME[i + 3];
		}
	
		while (i < 6) {	// MM/DD/
			str_output[i++] = TIME[i - 3];
		}

		while (i < 11) { // MM/DD/YYYY + '/0'
			str_output[i++] = TIME[i];
		}
	}
	else if (type == 66 || type == 98 || type == 67 || type == 99) {
		char month[10];
		int m = Month(TIME), i = 0;

		switch (m) {
		case 1:
			month[i++] = 74;		// 'J'
			month[i++] = 97;		// 'a'
			month[i++] = 110;		// 'n'
			month[i++] = 117;		// 'u'
			month[i++] = 97;		// 'a'
			month[i++] = 114;		// 'r'
			month[i++] = 121;		// 'y'
			break;
		case 2:
			month[i++] = 70;		// 'F'
			month[i++] = 101;		// 'e'
			month[i++] = 98;		// 'b'
			month[i++] = 114;		// 'r'
			month[i++] = 117;		// 'u'
			month[i++] = 97;		// 'a'
			month[i++] = 114;		// 'r'
			month[i++] = 121;		// 'y'
			break;
		case 3:
			month[i++] = 77;		// 'M'
			month[i++] = 97;		// 'a'
			month[i++] = 114;		// 'r'
			month[i++] = 99;		// 'c'
			month[i++] = 104;		// 'h'
			break;
		case 4:
			month[i++] = 65;		// 'A'
			month[i++] = 112;		// 'p'
			month[i++] = 114;		// 'r'
			month[i++] = 105;		// 'i'
			month[i++] = 108;		// 'l'
			break;
		case 5:
			month[i++] = 77;		// 'M'
			month[i++] = 97;		// 'a'
			month[i++] = 121;		// 'y'
			break;
		case 6:
			month[i++] = 74;		// 'J'
			month[i++] = 117;		// 'u'
			month[i++] = 110;		// 'n'
			month[i++] = 101;		// 'e'
			break;
		case 7:
			month[i++] = 74;		// 'J'
			month[i++] = 117;		// 'u'
			month[i++] = 108;		// 'l'
			month[i++] = 121;		// 'y'
			break;
		case 8:
			month[i++] = 65;		// 'A'
			month[i++] = 117;		// 'u'
			month[i++] = 103;		// 'g'
			month[i++] = 117;		// 'u'
			month[i++] = 115;		// 's'
			month[i++] = 115;		// 't'
			break;
		case 9:
			month[i++] = 83;		// 'S'
			month[i++] = 101;		// 'e'
			month[i++] = 112;		// 'p'
			month[i++] = 115;		// 't'
			month[i++] = 101;		// 'e'
			month[i++] = 109;		// 'm'
			month[i++] = 98;		// 'b'
			month[i++] = 101;		// 'e'
			month[i++] = 114;		// 'r'
			break;
		case 10:
			month[i++] = 79;		// 'O'
			month[i++] = 99;		// 'c'
			month[i++] = 115;		// 't'
			month[i++] = 111;		// 'o'
			month[i++] = 98;		// 'b'
			month[i++] = 101;		// 'e'
			month[i++] = 114;		// 'r'
			break;
		case 11:
			month[i++] = 78;		// 'N'
			month[i++] = 111;		// 'o'
			month[i++] = 1158;		// 'v'
			month[i++] = 101;		// 'e'
			month[i++] = 109;		// 'm'
			month[i++] = 98;		// 'b'
			month[i++] = 101;		// 'e'
			month[i++] = 114;		// 'r'
			break;
		case 12:
			month[i++] = 68;		// 'D'
			month[i++] = 101;		// 'e'
			month[i++] = 99;		// 'c'
			month[i++] = 101;		// 'e'
			month[i++] = 109;		// 'm'
			month[i++] = 98;		// 'b'
			month[i++] = 101;		// 'e'
			month[i++] = 114;		// 'r'
			break;
		}
		month[i] = 0; // '/0'

		i = 0; // reset i

		/* Case: 'B' or 'b' */
		if (type == 66 || type == 98) {
			while (month[i] != 0) { // Month
				str_output[i++] = month[i];
			}
			str_output[i++] = 32; // 32: ' '

			int j = 0;
			while (TIME[j] != 47) { // 47: '/'
				str_output[i++] = TIME[j++];
			}
			str_output[i++] = 44; // Month DD,
			str_output[i++] = 32;

			j = 6; // YYYY
			while (j < 11) { // Month DD, YYYY + '/0'
				str_output[i++] = TIME[j++];
			}
		}

		/* Case: 'C' or 'c' */
		if (type == 67 || type == 99) {
			int j = 0;
			while (TIME[j] != 47) { // 47: '/'
				str_output[i++] = TIME[j++];
			}
			str_output[i++] = 32; // DD

			j = 0;
			while (month[j] != 0) { // DD Month
				str_output[i++] = month[j++];
			}
			str_output[i++] = 44; // DD Month,
			str_output[i++] = 32;

			j = 6; // YYYY
			while (j < 11) { // DD Month, YYYY + '/0'
				str_output[i++] = TIME[j++];
			}
		}
	}
	else { /* Other case: return TIME */
		int i = 0;
		while (i < 11) {
			str_output[i++] = TIME[i];
		}
	}
	
	return str_output;
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
