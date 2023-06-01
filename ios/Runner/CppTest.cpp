//
//  CppTest.cpp
//  Runner
//
//  Created by elf-rec on 2022/08/09.
//

#include "CppTest.hpp"

CppTest::CppTest()
{
//    memset(m_strName, 0x00, 256);
//    m_nAge = 0;
//    m_fHeight = 0.0f;
}

CppTest::~CppTest()
{
    printf("CppTest Finish");
}

void CppTest::SetName(char* strName)
{
    m_strName = strName;
}

void CppTest::SetAge(int nAge)
{
    m_nAge = nAge;
}

void CppTest::SetHeight(double fHeight)
{
    m_fHeight = fHeight;
}

char* CppTest::GetName()
{
    return m_strName;
}

int CppTest::GetAge()
{
    return m_nAge;
}

double CppTest::GetHeight()
{
    return m_fHeight;
}
