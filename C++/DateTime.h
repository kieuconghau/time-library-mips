#pragma once
#include <iostream>

using namespace std;

int strToInt(char * str, int n);

char* intToStr(int num, char* str_output);

char* Date(int day, int month, int year, char* TIME);

int Day(char* TIME);
int Month(char* TIME);
int Year(char* TIME);

int isLeap(int year);
int LeapYear(char* TIME);

char* Weekday(char* TIME, char* str_output);

int GetTime(char* TIME_1, char* TIME_2);

void printNearLeapYear(char* TIME);

char* Convert(char* TIME, char type, char* str_output);

int checkInput(char* str_input, int n);
int checkMonth(char* str_input);
int checkDay(char* str_input, int m, int y);
void inputDate(char* TIME);