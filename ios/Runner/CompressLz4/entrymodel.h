
#pragma once

#include	<stdint.h>

#define ENTRYMODEL_ID	"!elf"
#define MAX_LZ4_PATH	255
#define MAX_TIFF_COUNT	32

//kkondae Modify 2022.01.02 Start...
#define MAX_PATH        255


typedef wchar_t WCHAR;
typedef WCHAR TCHAR;
//kkondae Modify 2022.01.02 End...


typedef struct {
	uint8_t				is_data_encrypt;
	uint8_t				is_avr_encrypt;
	uint8_t				is_compress;
	uint8_t				path_size;

	uint32_t			file_date;
	uint32_t			file_crc;
	uint32_t			file_size;
	uint32_t			compress_size;
	uint32_t			file_offset;
} st_entrymodel_list;

typedef struct {
	st_entrymodel_list  entry_list;
	uint8_t				entry_path[MAX_LZ4_PATH];	
} st_entrymodel_info;


typedef struct {
	uint8_t				entry_id[4];
	uint32_t			entry_count;
	st_entrymodel_info	*ptr_entry_info;
} st_entrymodel_profile;


typedef struct tiffPack
{
	int			nCount;
	int			nSongNum;
	char		pTiffPath[MAX_TIFF_COUNT];
	char		wcsResFolder[MAX_PATH];
	bool		bIsError;
}struTiffPack, *pStrucTiffPack;

typedef struct compFile
{
	int			nSongNum;
	char		pCompFilePath[MAX_PATH];
	bool		bIsError;
}strucCompFile, *pStrucCompFile;