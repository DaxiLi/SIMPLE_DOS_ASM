/*
 * @Description: 
 * @Author: Yuan Jie
 * @Data: 
 * @LastEdit: moogila@outlook.com
 * @LastEditTime: 2021-09-17 00:20:43
 * @FileName: 
 */
#include <iostream>
#include<fstream>
#include<string>
using namespace std;


int main()
{
	ifstream infile("HZK16", ios::binary);
	unsigned char str[3];
	str[0] = 0xB0;
	str[1] = 0xA1;
	str[2] = '\0';
	char zi[32];
    cin >> str;
     cout << (int)(unsigned char)str[0] << " " << (int)(unsigned char)str[1];
	unsigned int order = str[1] - 0xA1 + 94 * (str[0] - 0xB0) + 15 * 94;
	unsigned int position = order * 32;
    cout << " " << position <<endl;
	infile.seekg(position);
	infile.read(zi, sizeof(zi));
	cout << str << endl;
	int count = 0;
    cout << *(uint16_t*)zi;
	for (int i = 0; i < 32; i++) {
		for (int j = 0; j < 8; j++) {
			if (((zi[i] >> (7 - j)) & 0x01) == 1) {
				cout << "**";
			}
			else {
				cout << "  ";
			}
			count++;
			if (count == 16) {
				cout << endl;
				count = 0;
			}
		}
	}
	infile.close();	
	return 0;
}