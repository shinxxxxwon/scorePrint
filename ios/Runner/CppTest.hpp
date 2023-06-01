//
//  CppTest.hpp
//  Runner
//
//  Created by elf-rec on 2022/08/09.
//

#ifndef CppTest_hpp
#define CppTest_hpp

//#include <stdio.h>
#include <iostream>
#include <string.h>

class CppTest{
private:
    char* m_strName;
    int m_nAge;
    double m_fHeight;
    
public:
    void SetName(char* strName);
    void SetAge(int nAge);
    void SetHeight(double fHeight);
    
    char* GetName();
    int GetAge();
    double GetHeight();
    char* GetCopyString();
    
    CppTest();
    ~CppTest();
};

#endif /* CppTest_hpp */
