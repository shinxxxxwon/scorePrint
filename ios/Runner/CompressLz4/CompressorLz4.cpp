//
// Created by dhkwon on 2022-01-12.
//
#include <stdio.h>
#include <string.h>
//#include "../ScorePrint/stdafx.h"
#include "CompressorLz4.h"
#include "Lz4/lz4.h"
#include "Lz4/lz4hc.h"
#include "Lz4/lz4frame.h"

//kkondae Modify 2022.12.25 Start...
#include "../main.h"
extern MainControll* g_pMainControll;

//#include "ExLib/atlstr.h"

//#include "mmsystem.h"
//#include <sys/types.h>    // stat, utime //

#include <sys/stat.h>     // stat //
//#include <sys/utime.h>  // utime //
//#include <io.h>         // _chmod //

//kkondae Modify 2022.01.13 Start...
typedef unsigned long       DWORD;
//kkondae Modify 2022.01.13 End...




#ifdef _DEBUG
#define new DEBUG_NEW
#undef THIS_FILE
static char THIS_FILE[] = __FILE__;
#endif

#define RELEASE_FILE(x)		{if(x) fclose(x); x= NULL;}
#define RELEASE_BUFFER(x)	{if(x) delete x; x = NULL;}
#define MEMORY_CLEAR(x)		{memset(x, 0x00, sizeof(x));}
#define SWAP_BYTE(x,y)		t = *(x); *(x) = *(y); *(y) = t;

#define INIT_MEMBER()		{RELEASE_FILE(m_fpLz4); m_nFileCount = 0; m_bIsFirstFile = FALSE; m_bIsCreateFile = FALSE;}

#define MAGICNUMBER_SIZE				4
#define LZ4IO_MAGICNUMBER				0x184D2204
#define LZ4IO_SKIPPABLE0				0x184D2A50
#define LZ4IO_SKIPPABLEMASK				0xFFFFFFF0
#define ERROR_FILE						-1
#define LZ4HC_DEFAULT_COMPRESS_LEVEL	9
#define LZ4IO_BLOCKSIZEID_DEFAULT		7
#define BACKSLASH_LEN					1


static int g_blockSizeId			= LZ4IO_BLOCKSIZEID_DEFAULT;
static int g_streamChecksum			= 1;
static int g_blockIndependence		= 1;
static int g_sparseFileSupport		= 0;		//소도와 복잡성 때문에 배제 , fat32 에도 적용 될수 있기 때문에
static int g_contentSizeFlag		= 1;		//파일 원본 사이즈

static unsigned g_magicRead = 0;				// out-parameter of LZ4IO_decodeLegacyStream()


typedef struct {
	void*  srcBuffer;
	size_t srcBufferSize;
	void*  dstBuffer;
	size_t dstBufferSize;
	LZ4F_compressionContext_t ctx;
} cRess_t;

typedef struct {
	void*  srcBuffer;
	size_t srcBufferSize;
	void*  dstBuffer;
	size_t dstBufferSize;
	FILE*  dstFile;

	size_t acc_readsize;
	LZ4F_decompressionContext_t dCtx;
} dRess_t;


void CCompressorLz4::SetFontLength(int nLength)
{
    m_nFontLength = nLength;
}

int CCompressorLz4::GetFontLength(){
    return m_nFontLength;
}

BOOL CCompressorLz4::CreateLz4(struTiffPack *pPack, BOOL bIsTiff, BOOL bIsSaxophone/* = FALSE*/, wchar_t *pwcsType /*= NULL*/)
{
    char strOutputPath[MAX_LZ4_PATH];
    memset(strOutputPath, 0, MAX_LZ4_PATH);

    INIT_MEMBER();

	m_strLZ4Path	= strOutputPath;
	m_pTiffPack		= pPack;

    m_fpLz4 = fopen(strOutputPath, "wb+");
    if( m_fpLz4 != NULL ) {
        RELEASE_FILE(m_fpLz4);
        return FALSE;
    }

	m_bIsFirstFile	= TRUE;
	m_bIsCreateFile	= TRUE;

	return TRUE;
}

BOOL CCompressorLz4::OpenLz4(strucCompFile *pPack, const char* szFtpPath)
{
	char* strTemp;
    char pathBuffer[MAX_PATH] = { 0,};
    char *tptr = NULL;
    /*//p02파일 생성 경로 만들기
    //flutter에서 경로 지정해서 넘겨줌
    strTemp = pPack->pCompFilePath;
    memset(strTemp,0x00 ,MAX_PATH);

	tptr = strrchr(strTemp, '\\');
	memset(m_pDecompressFolder,0x00 ,MAX_PATH);
	strncpy(m_pDecompressFolder, strTemp, tptr - strTemp);
    */
	RELEASE_FILE(m_fpLz4);
	INIT_MEMBER();

	m_pCompPack = pPack;
    //경로 만들어 줄것
    //kkondae Modify 2022.02.24 TempPath
    //m_fpLz4 = fopen("/data/user/0/com.example.elfscoreprint_mobile_20220531/cache/99079.C02", "rb");
    m_fpLz4 = fopen(szFtpPath, "rb");
    //m_fpLz4 = fopen(pPack->pCompFilePath, "rb");

	if( m_fpLz4 == NULL  ) {
		RELEASE_FILE(m_fpLz4);
		return FALSE;
	}

	return TRUE;
}

/*
static int LZ4IO_GetBlockSize_FromBlockId (int id)
{
	return (1 << (8 + (2 * id)));
}

static int LZ4IO_isSkippableMagicNumber(unsigned int magic)
{
	return (magic & LZ4IO_SKIPPABLEMASK) == LZ4IO_SKIPPABLE0;
}

*/
static unsigned LZ4IO_readLE32 (const void* s)
{
	const unsigned char* const srcPtr = (const unsigned char*)s;
	unsigned value32 = srcPtr[0];
	value32 += (srcPtr[1]<<8);
	value32 += (srcPtr[2]<<16);
	value32 += ((unsigned)srcPtr[3])<<24;
	return value32;
}

// unoptimized version; solves endianess & alignment issues //
static void LZ4IO_writeLE32 (void* p, unsigned value32)
{
	unsigned char* const dstPtr = (unsigned char*)p;
	dstPtr[0] = (unsigned char)value32;
	dstPtr[1] = (unsigned char)(value32 >> 8);
	dstPtr[2] = (unsigned char)(value32 >> 16);
	dstPtr[3] = (unsigned char)(value32 >> 24);
}

/*
static __inline unsigned long long  UTIL_getFileSize(const char* infilename)
{
	int r;
#if defined(_MSC_VER)
	struct __stat64 statbuf;
	r = _stat64(infilename, &statbuf);
	if (r || !(statbuf.st_mode & S_IFREG)) return 0;   // No good... //
#elif defined(__MINGW32__) && defined (__MSVCRT__)
	struct _stati64 statbuf;
	r = _stati64(infilename, &statbuf);
	if (r || !(statbuf.st_mode & S_IFREG)) return 0;   // No good... //
#else
	struct stat statbuf;
	r = stat(infilename, &statbuf);
	if (r || !S_ISREG(statbuf.st_mode)) return 0;   // No good... //
#endif
	return (unsigned long long)statbuf.st_size;
}


static cRess_t LZ4IO_createCResources(long *ret_err)
{
	const size_t blockSize = (size_t)LZ4IO_GetBlockSize_FromBlockId (g_blockSizeId);
	cRess_t ress;

	*ret_err = 0;
	LZ4F_errorCode_t const errorCode = LZ4F_createCompressionContext(&(ress.ctx), LZ4F_VERSION);
	if (LZ4F_isError(errorCode)) {
		*ret_err = -30;
		return ress;
	}

	// Allocate Memory
	ress.srcBuffer = malloc(blockSize);
	ress.srcBufferSize = blockSize;
	ress.dstBufferSize = LZ4F_compressFrameBound(blockSize, NULL);   // cover worst case
	ress.dstBuffer = malloc(ress.dstBufferSize);
	if (!ress.srcBuffer || !ress.dstBuffer)
	{
		*ret_err = -31;
		return ress;
	}

	return ress;
}

static void LZ4IO_freeCResources(cRess_t ress, long *ret_err)
{
	*ret_err = 0;
	free(ress.srcBuffer);
	free(ress.dstBuffer);
	LZ4F_errorCode_t const errorCode = LZ4F_freeCompressionContext(ress.ctx);
	if (LZ4F_isError(errorCode))
	{
		*ret_err = -38;
		return;
	}
}

static unsigned long LZ4IO_compressBuffer_extRess(cRess_t ress, char* strSrcPath, const char* ptr_src, unsigned  long src_size, char* ptr_dst, int compressionLevel, long *ret_err)
{
	unsigned long		acc_readsize = 0;
	unsigned long		compressed_filesize = 0;
	void* const			srcBuffer = ress.srcBuffer;
	void* const			dstBuffer = ress.dstBuffer;
	const size_t		dstBufferSize = ress.dstBufferSize;
	const size_t		blockSize = (size_t)LZ4IO_GetBlockSize_FromBlockId (g_blockSizeId);
	size_t				readSize;

	LZ4F_compressionContext_t	ctx = ress.ctx;   // just a pointer
	LZ4F_preferences_t			prefs;

	*ret_err = 0;

	memset(&prefs, 0, sizeof(prefs));

	// Set compression parameters
	prefs.autoFlush = 1;
	prefs.compressionLevel = compressionLevel;
	prefs.frameInfo.blockMode = (LZ4F_blockMode_t)g_blockIndependence;
	prefs.frameInfo.blockSizeID = (LZ4F_blockSizeID_t)g_blockSizeId;
	prefs.frameInfo.contentChecksumFlag = (LZ4F_contentChecksum_t)g_streamChecksum;
	if (g_contentSizeFlag)
	{
		unsigned long long fileSize = UTIL_getFileSize(strSrcPath);
		prefs.frameInfo.contentSize = fileSize;   // == 0 if input == stdin
		if (fileSize==0) {
			*ret_err = -40;
			return 0;
		}
	}

	// read first block
	if(blockSize > (src_size - acc_readsize)) {
		readSize = (src_size - (unsigned long)acc_readsize);
	} else {
		readSize = blockSize;
	}
	memcpy(srcBuffer, ptr_src, readSize);
	ptr_src += readSize;
	acc_readsize += readSize;

	//single-block file
	if (readSize < blockSize)		 //dstBufferSize 가 blockSize bound 한 사이즈라 조금 높아야 하는데 테스트 필요
	{
		// Compress in single pass
		size_t const cSize = LZ4F_compressFrame(dstBuffer, dstBufferSize, srcBuffer, readSize, &prefs);
		if (LZ4F_isError(cSize)) {
			*ret_err = -41;
			return 0;
		}
		compressed_filesize = cSize;

		// Write Block
		memcpy(ptr_dst, dstBuffer, cSize);
		ptr_dst += cSize;
	}
	else
	{
		// multiple-blocks file
		// Write Archive Header
		size_t headerSize = LZ4F_compressBegin(ctx, dstBuffer, dstBufferSize, &prefs);
		if (LZ4F_isError(headerSize)) {
			*ret_err = -43;
			return 0;
		}

		memcpy(ptr_dst, dstBuffer, headerSize);
		ptr_dst += headerSize;

		compressed_filesize += headerSize;

		// Main Loop
		while (readSize>0)
		{
			size_t outSize;

			// Compress Block
			outSize = LZ4F_compressUpdate(ctx, dstBuffer, dstBufferSize, srcBuffer, readSize, NULL);
			if (LZ4F_isError(outSize)) {
				*ret_err = -45;
				return 0;
			}
			compressed_filesize += outSize;

			// Write Block
			memcpy(ptr_dst, dstBuffer, outSize);
			ptr_dst += outSize;

			// Read next block
			if(blockSize > (src_size - acc_readsize))
			{
				readSize = (src_size - (unsigned long)acc_readsize);
			} else {
				readSize = blockSize;
			}

			if(readSize)
			{
				memcpy(srcBuffer, ptr_src, readSize);
				ptr_src += readSize;
				acc_readsize += readSize;
			}
		}
		// End of Stream mark
		headerSize = LZ4F_compressEnd(ctx, dstBuffer, dstBufferSize, NULL);
		if (LZ4F_isError(headerSize)) {
			*ret_err = -48;
			return 0;
		}

		memcpy(ptr_dst, dstBuffer, headerSize);
		ptr_dst += headerSize;

		compressed_filesize += headerSize;
	}
	return compressed_filesize;
}

*/
static const size_t LZ4IO_dBufferSize = 64 * 1024;


static dRess_t LZ4IO_createDResources(int *ret_err)
{
	dRess_t ress;
	*ret_err = 0;

	// init
	LZ4F_errorCode_t const errorCode = LZ4F_createDecompressionContext(&ress.dCtx, LZ4F_VERSION);
	if (LZ4F_isError(errorCode)) {
		*ret_err = -60;
		return ress;

	}

	// Allocate Memory
	ress.acc_readsize = 0;
	ress.srcBufferSize = LZ4IO_dBufferSize;
	ress.srcBuffer = malloc(ress.srcBufferSize);
	ress.dstBufferSize = LZ4IO_dBufferSize;
	ress.dstBuffer = malloc(ress.dstBufferSize);
	if (!ress.srcBuffer || !ress.dstBuffer) {
		*ret_err = -61;
		return ress;
	}

	ress.dstFile = NULL;
	return ress;
}

static void LZ4IO_freeDResources(dRess_t ress, int *ret_err)
{
	*ret_err = 0;

	LZ4F_errorCode_t errorCode = LZ4F_freeDecompressionContext(ress.dCtx);
	if (LZ4F_isError(errorCode)) {
		*ret_err = -69;
	}
	free(ress.srcBuffer);
	free(ress.dstBuffer);
}

static unsigned long long LZ4IO_decompressLZ4FBuf(dRess_t ress, const char* ptr_src, DWORD src_size, DWORD *ptr_acc_readsize, char* ptr_dest, DWORD dest_size, int *ret_err)
{
	unsigned long long filesize = 0;
	LZ4F_errorCode_t nextToLoad;
	unsigned storedSkips = 0;

	*ret_err = 0;

	// Init feed with magic number (already consumed from FILE* sFile)
	{
		size_t inSize = MAGICNUMBER_SIZE;
		size_t outSize= 0;
		LZ4IO_writeLE32(ress.srcBuffer, LZ4IO_MAGICNUMBER);
		nextToLoad = LZ4F_decompress(ress.dCtx, ress.dstBuffer, &outSize, ress.srcBuffer, &inSize, NULL);
		if (LZ4F_isError(nextToLoad)) {
			*ret_err = -62;
			return 0;
		}
	}

	// Main Loop
	for (;nextToLoad;) {
		size_t readSize;
		size_t pos = 0;
		size_t decodedBytes = ress.dstBufferSize;

		// Read input
		if (nextToLoad > ress.srcBufferSize) nextToLoad = ress.srcBufferSize;
		//readSize = fread(ress.srcBuffer, 1, nextToLoad, srcFile);

		if(nextToLoad > (src_size - *ptr_acc_readsize) )
		{
			readSize = (src_size - *ptr_acc_readsize);
		}
		else
		{
			readSize = nextToLoad;
		}

		if (!readSize) break;   // reached end of file or stream

		memcpy(ress.srcBuffer, ptr_src, readSize);
		ptr_src += readSize;
		*ptr_acc_readsize += readSize;

		while ((pos < readSize) || (decodedBytes == ress.dstBufferSize)) {  // still to read, or still to flush
			//Decode Input (at least partially)
			size_t remaining = readSize - pos;
			decodedBytes = ress.dstBufferSize;
			nextToLoad = LZ4F_decompress(ress.dCtx, ress.dstBuffer, &decodedBytes, (char*)(ress.srcBuffer)+pos, &remaining, NULL);
			if (LZ4F_isError(nextToLoad))
			{
				if(*ptr_acc_readsize == src_size && src_size > dest_size)
				{
					return filesize;
				}
				else
				{
					*ret_err = -66;
					return 0;
				}
			}
			pos += remaining;

			// Write Block
			if (decodedBytes) {
				//storedSkips = LZ4IO_fwriteSparse(dstFile, ress.dstBuffer, decodedBytes, storedSkips);
				memcpy(ptr_dest, ress.dstBuffer, decodedBytes);
				ptr_dest += decodedBytes;
				filesize += decodedBytes;
			}

			if (!nextToLoad) break;
		}
	}
	//LZ4IO_fwriteSparseEnd(dstFile, storedSkips);
	if ( nextToLoad !=0 ) {
		*ret_err = -68;
		return 0;
	}

	return filesize;
}

#define ENDOFSTREAM ((unsigned long long)-1)
static unsigned long long selectDecoderBuffer(dRess_t ress, const char* ptr_src, DWORD src_size, DWORD *ptr_acc_readsize, char* ptr_dest, DWORD dest_size, int *ret_err)
{
	unsigned char MNstore[MAGICNUMBER_SIZE];
	unsigned magicNumber;
	static unsigned nbCalls = 0;

	// init
	nbCalls++;

	*ret_err = 0;

	// Check Archive Header
	if (g_magicRead) {  // magic number already read from finput (see legacy frame)
		magicNumber = g_magicRead;
		g_magicRead = 0;
	}
	else
	{
		size_t nbReadBytes;
		if(MAGICNUMBER_SIZE > (src_size - *ptr_acc_readsize))
			nbReadBytes = (src_size - *ptr_acc_readsize);
		else
			nbReadBytes = MAGICNUMBER_SIZE;

		if(nbReadBytes)
		{
			memcpy(MNstore, ptr_src, nbReadBytes);
			ptr_src += nbReadBytes;
			*ptr_acc_readsize += nbReadBytes;
		}

		if (nbReadBytes==0) { nbCalls = 0; return ENDOFSTREAM; }   // EOF //
		if (nbReadBytes != MAGICNUMBER_SIZE || src_size ==0  || src_size < MAGICNUMBER_SIZE)
		{
			*ret_err = -40;
			return 0;
		}
		magicNumber = LZ4IO_readLE32(MNstore);   // Little Endian format
	}
	//if (LZ4IO_isSkippableMagicNumber(magicNumber)) magicNumber = LZ4IO_SKIPPABLE0;  // fold skippable magic numbers

	switch(magicNumber)
	{
	case LZ4IO_MAGICNUMBER:
		return LZ4IO_decompressLZ4FBuf(ress, ptr_src, src_size, ptr_acc_readsize, ptr_dest, dest_size, ret_err);

	}

	return 0;
}

CCompressorLz4::CCompressorLz4(void)
:m_fpLz4(NULL)
,m_pTiffPack(NULL)
,m_pCompPack(NULL)
,m_nFileCount(0)
,m_bIsFirstFile(true)
,m_bIsCreateFile(false)
,m_EntryModelAvrCrypt(0)
,m_EntryModelAesCrypt(1)
{
}

CCompressorLz4::~CCompressorLz4(void)
{
	CloseLz4();
}

/*
bool CCompressorLz4::CreateLz4(struTiffPack *pPack, bool bIsTiff, bool bIsSaxophone, wchar_t *pwcsType)
{
	char*			strOutputPath;

	INIT_MEMBER();

	if(bIsTiff == true)
	{
		if(bIsSaxophone == false)
			strOutputPath.Format(_T("%s%d.C01"), pPack->wcsResFolder, pPack->nSongNum);
		else
			strOutputPath.Format(_T("%s%d_%s.C01"), pPack->wcsResFolder, pPack->nSongNum, pwcsType);
	}
	else  {
		strOutputPath.Format(_T("%s%d.C02"), pPack->wcsResFolder, pPack->nSongNum);
	}

	m_strLZ4Path	= CW2A(strOutputPath);
	m_pTiffPack		= pPack;

	if(_wfopen_s(&m_fpLz4, strOutputPath, _T("wb+")) != 0) {
		RELEASE_FILE(m_fpLz4);
		return false;
	}
	m_bIsFirstFile	= true;
	m_bIsCreateFile	= true;

	WriteFileInfo(true);

	return true;
}

bool CCompressorLz4::OpenLz4(strucCompFile *pPack)
{
	char*		strTemp;

	RELEASE_FILE(m_fpLz4);
	INIT_MEMBER();

	m_pCompPack = pPack;

	strTemp = pPack->pCompFilePath;

	m_pDecompressFolder.Empty();
	m_pDecompressFolder = strTemp.Left(strTemp.ReverseFind('\\'));

	if(_wfopen_s(&m_fpLz4, pPack->pCompFilePath, _T("rb")) != 0) {
		RELEASE_FILE(m_fpLz4);
		return false;
	}

	return true;
}
*/
BOOL CCompressorLz4::CloseLz4(void)
{
	BOOL blRes = true;

	if(m_bIsCreateFile == true)
		blRes = WriteFileInfo(false);	//aes

	INIT_MEMBER();
	RELEASE_FILE(m_fpLz4);

	return blRes;
}

BOOL CCompressorLz4::WriteFileInfo(BOOL IsFirst)
{
	st_entrymodel_list	entry_list;
	uint32_t			data_size = 0;


	if(IsFirst == true)
	{
		if(m_fpLz4 != NULL)
			m_bIsFirstFile = false;

		m_EntryModelInfo.clear();
		return true;
	}
	else if(m_bIsFirstFile == false)
	{
		if(m_nFileCount != m_pTiffPack->nCount) {
			RELEASE_FILE(m_fpLz4);
			return false;
		}

		Write_bin(m_fpLz4, (const void*)ENTRYMODEL_ID, 4);
		Write_bin(m_fpLz4, (const void*)&m_nFileCount, 4);

		for (std::list<st_entrymodel_info>::iterator iter = m_EntryModelInfo.begin(); iter != m_EntryModelInfo.end(); iter++)
		{
			memcpy(&entry_list, &iter->entry_list, sizeof(st_entrymodel_list));

			entry_list.file_offset = sizeof(st_entrymodel_list) + iter->entry_list.path_size + 1 + data_size;
			XOR_Cryto( &iter->entry_path[0], entry_list.path_size, entry_list.file_crc);
			Write_bin(m_fpLz4, (char*)&entry_list, sizeof(entry_list));
			Write_bin(m_fpLz4, (char*)iter->entry_path, entry_list.path_size);

			if(entry_list.is_compress)	data_size = entry_list.compress_size;
			else						data_size = entry_list.file_size;
		}


#define MAX_FILE_DATA 10000000
		uint32_t			data_len;
		BYTE				*ptr_file_data;
		FILE				*fp;
		char				szlz4path[MAX_LZ4_PATH];

		//sprintf_s(szlz4path, _countof(szlz4path), "%s.lz4", m_strLZ4Path.GetBuffer());
        sprintf(szlz4path, "%s.lz4", m_strLZ4Path);
        fp = fopen(szlz4path, "rb");
        if(fp == NULL)
        {
                RELEASE_FILE(m_fpLz4);
                return false;
        }
        /*
		if(fopen_s(&fp, szlz4path, "rb") != 0) {
			RELEASE_FILE(m_fpLz4);
			return false;
		}
        */
		long nFileSize = GetFILE_Size(fp, 0);

		if(nFileSize == ERROR_FILE)  {
			RELEASE_FILE(fp);
			RELEASE_FILE(m_fpLz4);
			return false;
		}

		ptr_file_data = (BYTE*)malloc(MAX_FILE_DATA);

		if(ptr_file_data == NULL) {
			RELEASE_FILE(fp);
			RELEASE_FILE(m_fpLz4);
			return false;
		}

		while(1)
		{
			memset(ptr_file_data, 0, MAX_FILE_DATA);

			if(nFileSize > MAX_FILE_DATA)	data_len = MAX_FILE_DATA;

			else							data_len = nFileSize;

			nFileSize -= data_len;

			Read_bin(fp, ptr_file_data, data_len);
			Write_bin(m_fpLz4, ptr_file_data, data_len);
			if( nFileSize <= 0) break;
		}

		free(ptr_file_data);
		fclose(fp);

		//DeleteFileA(szlz4path);

		RELEASE_FILE(m_fpLz4);

		return true;
	}
	return false;
}
/*

bool CCompressorLz4::AddFileTolz4(int nIndex, bool bIsTiff, bool bIsSaxophone //= false//, wchar_t *pwcsType)
{
	FILE		*fpInput = NULL;

	char*	strRelativePathA = "";
	char*		strSrcPath;
	char*	strSrcPathA = "";
	char*		strSongType;
	char*	strSongTypeA;

	strSongType.Format(_T("%s"), pwcsType);
	strSongTypeA = CW2A(strSongType);

	if(m_pTiffPack == NULL)
		return false;

	if(bIsTiff == true)
	{
		if(bIsSaxophone == false)
		{
			strSrcPath.Format(_T("%s%d%03d.tiff"), m_pTiffPack->wcsResFolder, m_pTiffPack->nSongNum, nIndex + 1);
			strRelativePathA.Format("\\%d%03d.tiff", m_pTiffPack->nSongNum, nIndex + 1);
		}
		else
		{
			strSrcPath.Format(_T("%s%d_%s_%03d.tiff"), m_pTiffPack->wcsResFolder, m_pTiffPack->nSongNum, strSongType, nIndex + 1);
			strRelativePathA.Format("\\%d_%s_%03d.tiff", m_pTiffPack->nSongNum, strSongTypeA, nIndex + 1);
		}
	}
	else {
		strSrcPath.Format(_T("%s"), m_pTiffPack->pTiffPath[0]);
		strRelativePathA.Format("\\%d.P02", m_pTiffPack->nSongNum);
	}

	strSrcPathA = CW2A(strSrcPath);

	if(_wfopen_s(&fpInput, strSrcPath, _T("rb")) != 0) {
		RELEASE_FILE(fpInput);
		return false;
	}

	if(Compress_Lz4(fpInput, strSrcPathA, strRelativePathA) != 0) {
		RELEASE_FILE(fpInput);
		return false;
	}


	RELEASE_FILE(fpInput);

	if(bIsTiff == true) {
		DeleteFile(strSrcPath);
	}

	return true;
}

long CCompressorLz4::Compress_Lz4(FILE *fpIn, char* strSrcPath, char* strRelativePath)
{
	LZ4_stream_t		lz4Stream_body;
	LZ4_stream_t*		lz4Stream = &lz4Stream_body;
	unsigned long		file_date, data_size, lz4_buf_size;
	unsigned long		file_size = 0, compress_size = 0, lz4_crc = 0;
	char				*ptr_source_buf = NULL, *ptr_compress_buf = NULL;
	char*				str_file_widepath;
	long				ret_error;

	// Get data file size
	if((file_size = GetFILE_Size(fpIn)) == ERROR_FILE)
		return -1;

	// Read source data
	if((ptr_source_buf = (char*)malloc(file_size)) == NULL)
		return -2;

	// Get data file size
	memset(ptr_source_buf, 0x00, file_size);
	if((int)Read_bin(fpIn, ptr_source_buf, file_size) == 0) {
		free(ptr_source_buf);
		return -3;
	}

#if defined(DO_NOT_COMPRESS)
	data_size = file_size;
	m_EntryModelIsCompress = 0;
#else
	// Estimate the maximum size of a compressed file
	lz4_buf_size = LZ4_COMPRESSBOUND(file_size);
	if((ptr_compress_buf = (char*)malloc( lz4_buf_size )) == NULL)
		return -4;

	// Compress
	int compressionLevel		= LZ4HC_DEFAULT_COMPRESS_LEVEL;
	m_EntryModelCompressLevel	= compressionLevel;

	cRess_t const ress = LZ4IO_createCResources(&ret_error);
	if(ret_error != 0)
		return ret_error;

	compress_size = LZ4IO_compressBuffer_extRess(ress, strSrcPath, ptr_source_buf, file_size, ptr_compress_buf, compressionLevel, &ret_error);
	if(ret_error != 0)
		return ret_error;

	// Free resources
	LZ4IO_freeCResources(ress, &ret_error);
	if(ret_error != 0)
		return ret_error;

	// Release original source data

	free(ptr_source_buf);

	if(compress_size <= 0)	{					//"compress failed!" 이어도  return 이 false 이어서는 안됨
		data_size = file_size;
		m_EntryModelIsCompress = 0;
	}
	else {
		data_size = compress_size;
		m_EntryModelIsCompress = 1;
	}
#endif

	// Get file date
	str_file_widepath = CA2W(strSrcPath);
	GetFileDate_LastModify(str_file_widepath, file_date, true);

	if(m_EntryModelAesCrypt)
	{
		if(Lz4SetKey(file_size, file_date) != true) return -5;

#if defined(DO_NOT_COMPRESS)
		if(Encrpyt_Data((BYTE*)ptr_source_buf, data_size) != true) {
			free(ptr_source_buf);
			return -5;
		}
#else
		if(Encrpyt_Data((BYTE*)ptr_compress_buf, data_size) != true) {
			free(ptr_compress_buf);
			return -5;
		}
#endif
	}

#if defined(DO_NOT_COMPRESS)
	lz4_crc = Calculation_Nmea32((void*)ptr_source_buf, data_size);

	st_entrymodel_info	st_entrinfo;
	FILE				*fp = NULL;
	char				szLZ4[MAX_LZ4_PATH];

	sprintf_s(szLZ4, _countof(szLZ4), "%s.lz4", m_strLZ4Path.GetBuffer());

	if(fopen_s(&fp, szLZ4, "ab+") != 0) {
		RELEASE_FILE(fp);
		free(ptr_source_buf);
		return -6;
	}

	fseek(fp, 0x00, SEEK_END);

	Write_bin(fp, ptr_source_buf, (size_t)data_size);			// Write AES computed compress data
	fclose(fp);

	free(ptr_source_buf);
#else
	// Get CRC
	lz4_crc = Calculation_Nmea32((void*)ptr_compress_buf, data_size);

	/////////////////////////////////
	st_entrymodel_info	st_entrinfo;
	FILE				*fp = NULL;
	char				szLZ4[MAX_LZ4_PATH];

	sprintf_s(szLZ4, _countof(szLZ4), "%s.lz4", m_strLZ4Path.GetBuffer());

	if(fopen_s(&fp, szLZ4, "ab+") != 0) {
		RELEASE_FILE(fp);
		free(ptr_compress_buf);
		return -6;
	}

	fseek(fp, 0x00, SEEK_END);

	Write_bin(fp, ptr_compress_buf, (size_t)data_size);			// Write AES computed compress data
	fclose(fp);

	free(ptr_compress_buf);
#endif
	// Count file
	m_nFileCount++;

	// Write data infomation
	st_entrinfo.entry_list.is_data_encrypt		= m_EntryModelAesCrypt;
	st_entrinfo.entry_list.is_avr_encrypt		= m_EntryModelAvrCrypt;
	st_entrinfo.entry_list.is_compress			= m_EntryModelIsCompress;
	st_entrinfo.entry_list.compress_size		= compress_size;
	st_entrinfo.entry_list.file_crc				= lz4_crc;
	st_entrinfo.entry_list.file_size			= file_size;
	st_entrinfo.entry_list.file_date			= file_date;
	st_entrinfo.entry_list.file_offset			= 0;
	st_entrinfo.entry_list.path_size			= strRelativePath.GetLength();

	if(st_entrinfo.entry_list.path_size >= 255) {
		free(ptr_compress_buf);
		return -7;
	}

	memset(st_entrinfo.entry_path, 0, MAX_LZ4_PATH);
	memcpy(st_entrinfo.entry_path, strRelativePath.GetBuffer(0), st_entrinfo.entry_list.path_size);

	m_EntryModelInfo.push_back(st_entrinfo);

	return 0;
}


// LJHOON Modify 20170724 Start...
*/

///SJW Modify 2022.09.22 Start...
///매개변수로 파일경로 복사
unsigned long CCompressorLz4::Decompress_FileHandle(const char* szP0Path)
{
	st_entrymodel_info			*ptr_entry_info;
	st_entrymodel_list			*ptr_entry_list;
	FILE						*fOut = NULL;
	char						ptr_model_id[5] = {0,};
	char					    pOutputPath[MAX_PATH];//CStringA strOutputPathA
	unsigned int 				entry_cnt = 0, nIndex;
	unsigned int				data_size, file_size;
	char						*ptr_data_buf = NULL;
	char						*ptr_file_buf = NULL;
	int						ret_error;
	char						ptr_path_buf[MAX_LZ4_PATH] = {0,};

    /*
	if(m_fpLz4 == NULL || m_pDecompressFolder.IsEmpty() == true)
		return 0;

*/
    if(m_fpLz4 == NULL)
        return 0;
	// Check ID
	if(Read_bin(m_fpLz4, ptr_model_id, 4) == 0)
		return 91;

	if(memcmp(ptr_model_id, ENTRYMODEL_ID, 4) != 0)
		return 92;

	// Encryption file count
	if(Read_int(m_fpLz4, &entry_cnt) == 0)
		return 93;

	// Encryption info
    if((ptr_entry_info = (st_entrymodel_info *)malloc(entry_cnt * sizeof(st_entrymodel_info))) == NULL)
        return 94;

	memset(&ptr_entry_info[0], 0, sizeof(st_entrymodel_info) * entry_cnt);


	// Header profile
	for(nIndex=0; nIndex < entry_cnt; nIndex++) {
		Read_bin(m_fpLz4, &ptr_entry_info[nIndex].entry_list, sizeof(st_entrymodel_list) );
		Read_bin(m_fpLz4, (ptr_entry_info[nIndex].entry_path), ptr_entry_info[nIndex].entry_list.path_size);
		XOR_Cryto(&ptr_entry_info[nIndex].entry_path[0], ptr_entry_info[nIndex].entry_list.path_size, ptr_entry_info[nIndex].entry_list.file_crc);
	}

	// Encryption data
	for(nIndex = 0; nIndex < entry_cnt; nIndex++)
	{
		ptr_entry_list = &ptr_entry_info[nIndex].entry_list;

		if(ptr_entry_list->file_size <= 1) {
			free(ptr_entry_info);
			return 95;
		}

		if(ptr_entry_list->is_compress) data_size = ptr_entry_list->compress_size;
		else                            data_size = ptr_entry_list->file_size;

		if(data_size <= 1) {free(ptr_entry_info); return 0; }

		ptr_data_buf = (char *)malloc(data_size);
		if(ptr_data_buf == NULL) {free(ptr_entry_info); return 0; }

		if(Read_bin(m_fpLz4, ptr_data_buf, (size_t)data_size) != (size_t)data_size) {
			free(ptr_entry_info);
			free(ptr_data_buf);
			return 96;
		}

		if(ptr_entry_list->is_avr_encrypt) {
			//되어있으면 오류임 난 한적 없기 때문이지
			return 97;
		}

		if(ptr_entry_list->is_data_encrypt)
		{
			Lz4SetKey(ptr_entry_list->file_size, ptr_entry_list->file_date);

			if(Decrpyt_Data((byte*)ptr_data_buf, data_size) != true) {
				free(ptr_entry_info);
				free(ptr_data_buf);
				return 98;
			}
		}


		file_size		= ptr_entry_list->file_size;

		if(ptr_entry_list->is_compress)
		{
			ptr_file_buf	= (char *)malloc(file_size);
			if(ptr_file_buf == NULL) {
				free(ptr_entry_info);
				free(ptr_data_buf);
				return 99;
			}

			dRess_t const ress = LZ4IO_createDResources(&ret_error);
			if(ret_error != 0)
			{
				free(ptr_entry_info);
				free(ptr_file_buf);
				free(ptr_data_buf);
				return 100;
			}

			unsigned long acc_readsize = 0;
			unsigned long long filesize = 0, decodedSize=0;
			do {
				decodedSize = selectDecoderBuffer(ress, ptr_data_buf, data_size, &acc_readsize, ptr_file_buf, file_size, &ret_error);
				if(ret_error != 0)
				{
					//AfxMessageBox(_T("해제 오류"));
					free(ptr_entry_info);
					free(ptr_file_buf);
					free(ptr_data_buf);
					return 101;
				}
				if (decodedSize != ENDOFSTREAM)
					filesize += decodedSize;
			} while (decodedSize != ENDOFSTREAM);

			// Free resources
			LZ4IO_freeDResources(ress, &ret_error);
			if(ret_error != 0)
			{
				free(ptr_entry_info);
				free(ptr_file_buf);
				free(ptr_data_buf);
				return 102;
			}

			free(ptr_data_buf);

			// Decompress path
			memset(ptr_path_buf, 0, MAX_LZ4_PATH);
			memcpy(ptr_path_buf, ptr_entry_info[nIndex].entry_path, ptr_entry_list->path_size);

            strcat(m_pDecompressFolder, ptr_path_buf);

            memset(pOutputPath, 0x00, sizeof(char) * MAX_PATH);
            memcpy(pOutputPath,szP0Path, strlen(szP0Path));

            pOutputPath[strlen(pOutputPath) - 6] += nIndex;

			if((fOut = CreateDecmpPath(pOutputPath)) == NULL) {
				free(ptr_entry_info);
				free(ptr_file_buf);
				return 103;
			}

			Write_bin(fOut, ptr_file_buf, file_size);
			free(ptr_file_buf);
			RELEASE_FILE(fOut);
		}
		else
		{
			// Decompress path
			memset(ptr_path_buf, 0, MAX_LZ4_PATH);
			memcpy(ptr_path_buf, ptr_entry_info[nIndex].entry_path, ptr_entry_list->path_size);

            strcat(m_pDecompressFolder, ptr_path_buf);

			if((fOut = CreateDecmpPath(szP0Path)) == NULL) {
				free(ptr_entry_info);
				return 0;
			}

			Write_bin(fOut, ptr_data_buf, file_size);
			free(ptr_data_buf);
			RELEASE_FILE(fOut);
		}
	}

	RELEASE_FILE(m_fpLz4);
	free(ptr_entry_info);

	return entry_cnt;
}
// LJHOON Modify 20170724 End...

void CCompressorLz4::XOR_Cryto(void *code, long nLen, UINT32 key_value)
{
	unsigned char		keycode = 0;
	unsigned char		*ptr_code = (unsigned char*)code;
	long 				i = 0;

	keycode = (key_value >> 16) & 0xff | (key_value >> 8) & 0xff | (key_value) & 0xff;
	for(i; i < nLen; i++)
	{
		keycode = keycode ^ (unsigned char)i;
		ptr_code[i] = ptr_code[i] ^ keycode;
	}
	return;
}
/*
unsigned long CCompressorLz4::Calculation_Nmea32(void* data, size_t  len)
{
	unsigned char		*ptr_data = (unsigned char*)data;
	long				i, j, mok,remain;
	typedef union {
		BYTE  Byte[4];
		DWORD DWord;
	} DW_B;

	DW_B nmea;

	nmea.DWord = len;

	mok = len / 4;
	remain = len % 4;
	for(i=0; i<mok; i+=4 )
	{
		nmea.Byte[0] ^= *ptr_data++;
		nmea.Byte[1] ^= *ptr_data++;
		nmea.Byte[2] ^= *ptr_data++;
		nmea.Byte[3] ^= *ptr_data++;
	}

	for(i=0,j=0 ; i<remain; i++ )
	{
		nmea.Byte[j++] ^= *ptr_data++;
		j %= 4;
	}

	nmea.Byte[0] = ~nmea.Byte[0];
	nmea.Byte[1] = ~nmea.Byte[1];
	nmea.Byte[2] = ~nmea.Byte[2];
	nmea.Byte[3] = ~nmea.Byte[3];

	return(nmea.DWord);
}
*/
size_t CCompressorLz4::Write_int(FILE *fp, int Val)
{
	return fwrite(&Val, sizeof(Val), 1, fp);
}

size_t CCompressorLz4::Write_int(FILE *fp, int Val, size_t size)
{
	return fwrite(&Val, size, Val, fp);
}

size_t CCompressorLz4::Write_bin(FILE *fp, const void *array, size_t arrayBytes)
{
	return fwrite(array, 1, arrayBytes, fp);
}

size_t CCompressorLz4::Read_int(FILE *fp, unsigned int *Res)
{
	return fread(Res, sizeof(*Res), 1, fp);
}

size_t CCompressorLz4::Read_bin(FILE *fp, void *array, size_t arrayBytes)
{
	return fread(array, 1, arrayBytes, fp);
}

unsigned long CCompressorLz4::GetFILE_Size(FILE *fp, LONG lPos )//= 0
{
	unsigned long nFileSize = 0;

	if(fp == NULL) return ERROR_FILE;

	fseek(fp, 0x00, SEEK_END);
	if((nFileSize = ftell(fp)) <= 0)
		return ERROR_FILE;

	fseek(fp, lPos, SEEK_SET);

	return nFileSize;
}
/*
bool CCompressorLz4::GetFileDate_LastModify(char* strPath, DWORD &dwDosDateTime, bool bLocalTime)  //= true
{
	WORD wDate;
	WORD wTime;
	FILETIME FileTime;

	HANDLE hFile = CreateFile(strPath, 0, FILE_SHARE_READ, NULL, OPEN_EXISTING, FILE_ATTRIBUTE_NORMAL | FILE_FLAG_BACKUP_SEMANTICS, NULL);

	if( hFile == INVALID_HANDLE_VALUE )
		return false;

	GetFileTime(hFile, NULL, NULL, &FileTime);

	CloseHandle(hFile);

	if( bLocalTime ) {
		FILETIME GmtTime = FileTime;
		FileTimeToLocalFileTime(&GmtTime, &FileTime);
	}

	FileTimeToDosDateTime(&FileTime, &wDate, &wTime);

	dwDosDateTime = wTime & 0xFFFF;
	dwDosDateTime |= (wDate << 16) & 0xFFFF0000UL;

	return true;
}
*/

////////////함수 수정 필요

FILE* CCompressorLz4::CreateDecmpPath(const char* pOutputPath)
{
	char*		pDirPath = NULL;
	FILE		*fpOut = NULL;

//	strDirPath = GetFileDirPath(strOutputPath.GetBuffer());

	//Folder path check
	/*
	if((m_strPrevFolder.IsEmpty() == TRUE) || (m_strPrevFolder.CompareNoCase(strDirPath) != 0))
	{
		m_strPrevFolder = strDirPath;

		if(CreateDirTree(strDirPath) != TRUE)
		{
			strOutputPath.ReleaseBuffer();
			return NULL;
		}
	}*/

    //kkondae Modify 2022.02.24 Start... FILE* fpLz4 = fopen("/data/user/0/com.example.elfscoreprint_mobile/cache/87170.C02", "rb");
   // fpOut = fopen("/data/user/0/com.example.elfscoreprint_mobile_20220531/cache/99079.P02", "wb+");
   // fpOut = fopen("./87170.P02", "wb+");
    fpOut = fopen(pOutputPath, "wb+");

    if(fpOut != NULL)   return fpOut;
    else                return NULL;
}

/*
char* CCompressorLz4::GetFileDirPath(char* strFilePath)
{
	char*		strDirPath;
	int				nBackslashPos;

	nBackslashPos	= strFilePath.ReverseFind('\\');
	strDirPath		= strFilePath.Left(nBackslashPos + BACKSLASH_LEN);

	return strDirPath;
}

FILE* CCompressorLz4::CreateDecmpPath(CStringA strOutputPath)
{
	CStringA		strDirPath = "";
	FILE			*fpOut = NULL;

	strDirPath = GetFileDirPath(strOutputPath.GetBuffer());

	//Folder path check
	if((m_strPrevFolder.IsEmpty() == TRUE) || (m_strPrevFolder.CompareNoCase(strDirPath) != 0))
	{
		m_strPrevFolder = strDirPath;

		if(CreateDirTree(strDirPath) != TRUE)
		{
			strOutputPath.ReleaseBuffer();
			return NULL;
		}
	}

	if(fopen_s(&fpOut, strOutputPath.GetBuffer(), "wb+") == 0)
	{
		return fpOut;
	}

	strOutputPath.ReleaseBuffer();
	return NULL;
}
*/

/*
FILE* CCompressorLz4::CreateDecmpPath(char* strOutputPath)
{
	char*		strDirPath = "";
	FILE			*fpOut = NULL;

	strDirPath = GetFileDirPath(strOutputPath.GetBuffer());

	//Folder path check
	if((m_strPrevFolder.IsEmpty() == true) || (m_strPrevFolder.CompareNoCase(strDirPath) != 0))
	{
		m_strPrevFolder = strDirPath;

		if(CreateDirTree(strDirPath) != true)
		{
			strOutputPath.ReleaseBuffer();
			return NULL;
		}
	}

	if(fopen_s(&fpOut, strOutputPath.GetBuffer(), "wb+") == 0)
	{
		return fpOut;
	}

	strOutputPath.ReleaseBuffer();
	return NULL;
}*/

/*
char* CCompressorLz4::GetFileDirPath(char* strFilePath)
{
	char*		strDirPath;
	int				nBackslashPos;

	nBackslashPos	= strFilePath.ReverseFind('\\');
	strDirPath		= strFilePath.Left(nBackslashPos + BACKSLASH_LEN);

	return strDirPath;
}

bool CCompressorLz4::CreateDirTree(char* strDirPath)
{
	char*		strMakeDirPath;
	int				nLen = 0;

	if(PathFileExistsA(strDirPath) == true){
		return true;
	}

	nLen = strlen(strDirPath) + 1;

	for(LPCSTR lptzCursor = strDirPath; _T('\0') != *lptzCursor; lptzCursor++ )
	{
		if(('\\') == *lptzCursor ) {
			strMakeDirPath.Format(strDirPath.Left(strDirPath.GetLength() - strlen(lptzCursor)));
			CreateDirectoryA(strMakeDirPath, NULL);
		}
	}

	if(PathFileExistsA(strDirPath) != true) {
		return false;
	}

	return true;
}
*/
