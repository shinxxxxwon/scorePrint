//
// Created by dhkwon on 2022-01-12.
//

#ifndef CMPRESSTEST_COMPRESSORLZ4_H
#define CMPRESSTEST_COMPRESSORLZ4_H

//
// Created by dhkwon on 2022-01-04.
//

#pragma once
#include "../ScorePrint/stdafx.h"
#include <stdint.h>

#include "Lz4/lz4.h"
#include "Lz4AES.h"
#include "entrymodel.h"
#include <list>
//


typedef std::list<st_entrymodel_info> ENTRY_MODEL;

int32_t native_add1(int32_t x, int32_t y) ;

int32_t native_add2(int32_t x, int32_t y) ;


class CCompressorLz4 : public CLz4AES
{
public:
	CCompressorLz4(void);
	~CCompressorLz4(void);

private:
	struTiffPack			*m_pTiffPack;
	strucCompFile			*m_pCompPack;

	FILE					*m_fpLz4;

	char*				m_strLZ4Path;
	char*				m_strPrevFolder;

	char					m_pDecompressFolder[MAX_PATH];

	int						m_nFileCount;
	bool					m_bIsFirstFile;
	bool					m_bIsCreateFile;

	int                     m_nFontLength;

public:
    void                    SetFontLength(int nLength);
    int                     GetFontLength();

	BOOL					CreateLz4(struTiffPack *pPack, BOOL bIsTiff, BOOL bIsSaxophone = FALSE, wchar_t *pwcsType = NULL);
	BOOL					OpenLz4(strucCompFile *pPack, const char* szFtpPath);
	BOOL					CloseLz4(void);

	BOOL					AddFileTolz4(int nIndex, BOOL bIsTiff, BOOL bIsSaxophone = FALSE, wchar_t *pwcsType = NULL);
// LJHOON Modify 20170724 Start...
	unsigned long			Decompress_FileHandle(const char* szP0Path);
// LJHOON Modify 20170724 End...

private:
	ENTRY_MODEL				m_EntryModelInfo;
	BOOL					WriteFileInfo(BOOL IsFirst);
	long					Compress_Lz4(FILE *fpIn, char* strSrcPath, char* strRelativePath);

protected:
	void					XOR_Cryto(void *code, long nLen, UINT32 key_value);
	unsigned long			Calculation_Nmea32(void* data, size_t  len);

	size_t					Write_int(FILE *fp, int Val);
	size_t					Write_int(FILE *fp, int Val, size_t size);
	size_t					Write_bin(FILE *fp, const void *array, size_t arrayBytes);
	size_t					Read_int(FILE *fp, unsigned int  *Res);
	size_t					Read_bin(FILE *fp, void *array, size_t arrayBytes);

	unsigned long			GetFILE_Size(FILE *fp, LONG lPos = 0);
	BOOL					GetFileDate_LastModify(char* strPath, DWORD &dwDosDateTime, bool bLocalTime = TRUE);

	FILE*					CreateDecmpPath(const char* strOutputPath);

private:
	char*				    GetFileDirPath(char* strFilePath);
	BOOL					CreateDirTree(char* strDirPath);
private:
	uint8_t					m_EntryModelAesCrypt;
	uint8_t					m_EntryModelAvrCrypt;
	uint8_t					m_EntryModelCompressLevel;
	uint8_t					m_EntryModelIsCompress;
};
//kkondae Modify 2022.01.02 Start...
/*
class CCompressorLz4 : public CLz4AES
{
public:
	CCompressorLz4(void);
	~CCompressorLz4(void);

private:
	struTiffPack			*m_pTiffPack;
	strucCompFile			*m_pCompPack;

	FILE					*m_fpLz4;

	CStringA				m_strLZ4Path;
	CStringA				m_strPrevFolder;

	CString					m_strDecompressFolder;

	int						m_nFileCount;
	bool					m_bIsFirstFile;
	bool					m_bIsCreateFile;

public:
	bool					CreateLz4(struTiffPack *pPack, bool bIsTiff, bool bIsSaxophone = FALSE, wchar_t *pwcsType = NULL);
	bool					OpenLz4(strucCompFile *pPack);
	bool					CloseLz4(void);

	bool					AddFileTolz4(int nIndex, bool bIsTiff, bool bIsSaxophone = FALSE, wchar_t *pwcsType = NULL);
// LJHOON Modify 20170724 Start...
	unsigned long			Decompress_FileHandle(void);
// LJHOON Modify 20170724 End...

private:
	ENTRY_MODEL				m_EntryModelInfo;
	bool					WriteFileInfo(bool IsFirst);
	long					Compress_Lz4(FILE *fpIn, CStringA strSrcPath, CStringA strRelativePath);

protected:
	void					XOR_Cryto(void *code, long nLen, UINT32 key_value);
	unsigned long			Calculation_Nmea32(void* data, size_t  len);

	size_t					Write_int(FILE *fp, int Val);
	size_t					Write_int(FILE *fp, int Val, size_t size);
	size_t					Write_bin(FILE *fp, const void *array, size_t arrayBytes);
	size_t					Read_int(FILE *fp, unsigned long  *Res);
	size_t					Read_bin(FILE *fp, void *array, size_t arrayBytes);

	unsigned long			GetFILE_Size(FILE *fp, LONG lPos = 0);
	bool					GetFileDate_LastModify(CString strPath, DWORD &dwDosDateTime, bool bLocalTime = TRUE);

	FILE*					CreateDecmpPath(CStringA strOutputPath);

private:
	CStringA				GetFileDirPath(CStringA strFilePath);
	bool					CreateDirTree(CStringA strDirPath);
private:
	uint8_t					m_EntryModelAesCrypt;
	uint8_t					m_EntryModelAvrCrypt;
	uint8_t					m_EntryModelCompressLevel;
	uint8_t					m_EntryModelIsCompress;
};
*/



#endif //CMPRESSTEST_COMPRESSORLZ4_H
