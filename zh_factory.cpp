// /*
//  * @Description: 字模生成程序
//  * @Author: Yuan Jie
//  * @Data: 
//  * @LastEdit: moogila@outlook.com
//  * @LastEditTime: 2021-09-16 22:57:57
//  * @FileName: 
//  */

// #include <stdio.h>
// #include <iostream>
// #include <string>
// #include <fstream>


// #define ZH_FILE_PATH ".\\chs16"

// using namespace std;


// int main() {
//     // string ZH;
//     char ZH[100] = {0};
//     int ofst ;
//     ifstream ifs(ZH_FILE_PATH,ios::in);
//     if (!ifs.is_open())
//     {
//         cout << "open file fail!" <<endl;
//         return 0;
//     }
//     while (1)
//     {
//         cout << "pls input:";
//         // cin >> ZH;
//         scanf("%s",ZH);
//         // const char *p = ZH.c_str();
//         for (int i = 0; i < 2;i++)
//         {
//             printf("%x ",ZH[i]);
//         }
//         /* code */
//     }
    



//     return 0;
// }

// #include "pch.h"
#include <iostream>
#include<fstream>
#include<string>
using namespace std;


int main()
{
	ifstream infile("HZK16", ios::binary);
	// unsigned char str[0];
    string ZH;
      if (!infile.is_open())
    {
        cout << "open file fail!" <<endl;
        return 0;
    }


    char ZH_LIB[300000];
    long l = infile.tellg(); 
    infile.seekg (0, ios::end); 
    long m = infile.tellg(); 
    long file_size = m - l;
    infile.seekg (0, ios::beg); 
    infile.read(ZH_LIB,file_size);
    
    // for (int i = 0; i < 100;i++)
    // {
    //     printf("%x ",ZH_LIB[i]);
    // }
    infile.close();
    ifstream ofile("CHS.asm",ios::out);
    if (!ofile.is_open())
    {
        cout << "openfile failed!";
        return 0;
    }
    ofile.write()

    while (1)
    {
        cout << "pls input:";
        cin >> ZH;
        const char* str = ZH.c_str();
        unsigned int tmp = (unsigned char)str[1] - 0xA1 + 94 * ((unsigned char)str[0] - 0xB0) + 15 * 94;
        unsigned int ofst = tmp * 32;
        // cout << " " << ofst <<endl;
        char *bp = ZH_LIB + ofst;
        for (int i = 0; i < 32;i++)
        {
            uint8_t index = 0x80;
            while (index)
            {
                if ( bp[i] & index)
                {
                    cout << "**";
                }else
                {
                    cout << "  ";
                }
                index = index >> 1;
            }
            if (i % 2)
            {
                cout << endl;
            }
        }
        printf("code: %x\n",ofst);
        cout << (int)(unsigned char)str[0] << " " << (int)(unsigned char)str[1] <<endl;
        bp = ZH_LIB + ofst;
        for (int i = 0;i < 16;i++)
        {
            int16_t cod = *bp;
            bp++;
            cod = cod << 8;
            cod = cod + *bp;
            printf("0%xH,",cod);
        }
        cout << endl;
        /* code */
    }


    
    // scanf("%s",str);
    // printf("%d %d ",str[0],str[1]);
	// char zi[32];
	// unsigned int order = (unsigned char)str[1] - 0xA1 + 94 * ((unsigned char)str[0] - 0xB0) + 15 * 94;
	// unsigned int position = order * 32;
	// infile.seekg(position);
	// infile.read(zi, sizeof(zi));
	// cout << str << endl;
	
	// infile.close();	

	return 0;
}