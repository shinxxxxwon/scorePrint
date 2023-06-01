#include "stdafx.h"
#include "Lz4AES.h"

#ifdef _DEBUG
#define new DEBUG_NEW
#undef THIS_FILE
static char THIS_FILE[] = __FILE__;
#endif

const char CLz4AES::SALT_KEY_BUF[CLz4AES::SALT_KEY_SIZE + 1] =
{
"05DQ84KG9HZK3OXL"
};

#ifdef UNICODE
#define ConvertKeyString	ConvertKeyStringW
#else
#define ConvertKeyString	ConvertKeyStringA
#endif

const char AES_KEY[] = {
	'H' - 20, 'C' - 20, 'L' - 20, 'K' - 20, 'K' - 20, '2' - 20, 't' - 20, 'C' - 20,
	'!' - 20, 'B' - 20, '!' - 20, '^' - 20, 'S' - 20, 'a' - 20, '9' - 20, '9' - 20,
	'B' - 20, '1' - 20, '2' - 20, 'c' - 20, 'k' - 20, '!' - 20, 'M' - 20, 'I' - 20,
	'K' - 20, 'O' - 20, 'u' - 20, 'f' - 20, 'B' - 20, 'B' - 20, 'q' - 20, '1' - 20,
	0
};

CLz4AES::CLz4AES(void)
:m_bIsSetKey(FALSE)
{

}


CLz4AES::~CLz4AES(void)
{
}

bool CLz4AES::Lz4SetKey(unsigned long file_size, unsigned long file_date)
{
	char szkey[33] = {0,};

	ConvertKeyStringA(szkey, AES_KEY);

	szkey[7]  = (file_size >> 24) & 0xff;
	szkey[8]  = (file_size >> 16) & 0xff;
	szkey[9]  = (file_size >>  8) & 0xff;
	szkey[10] = (file_size      ) & 0xff;

	szkey[15] = (file_date >> 24) & 0xff;
	szkey[16] = (file_date >> 16) & 0xff;
	szkey[17] = (file_date >>  8) & 0xff;
	szkey[18] = (file_date      ) & 0xff;

	return SetKey(szkey);
}

bool CLz4AES::SetKey(const char *pszKey, int nLen /*= -1*/, const char *pszSaltKey /*= NULL*/, int nSaltKeyLen /*= -1*/)
{

	if(pszKey == NULL) {
		m_bIsSetKey = FALSE;
		return FALSE;
	}

	if(nLen <= 0) {
		nLen = strlen(pszKey);
	}

	if(pszSaltKey == NULL || nSaltKeyLen <= 0) {
		pszSaltKey	= SALT_KEY_BUF;
		nSaltKeyLen = SALT_KEY_SIZE;
	}

	derive_key((const unsigned char *)&pszKey[0], nLen, (const unsigned char *)&pszSaltKey[0], nSaltKeyLen, KDF_ROUNDS, m_szEncKeyBuffer, ENC_KEY_LENGTH);

	m_bIsSetKey = TRUE;

	return TRUE;
}

bool CLz4AES::Encrpyt_Data(BYTE *input, unsigned long ulength)
{
	BYTE					byInput[FILE_ENC_UNIT_SIZE];
	BYTE					byOutput[FILE_ENC_UNIT_SIZE];
	unsigned long			done = 0, worksize = 0;

	if(input == NULL || ulength <= 0 || m_bIsSetKey != TRUE) {
		ASSERT(0);
		return FALSE;
	}

	do 
	{
		worksize = ulength - done;
		if(worksize > FILE_ENC_UNIT_SIZE) 
			worksize = FILE_ENC_UNIT_SIZE;

		if(worksize<FILE_ENC_UNIT_SIZE)
			break;

		memcpy(byInput, &input[done], worksize);
		memset(byOutput, 0x00, FILE_ENC_UNIT_SIZE);

		if(this->Encrpyt(byInput, byOutput, worksize) != TRUE) return FALSE;
		
		memcpy(&input[done],byOutput, worksize);
		done += worksize;

	} while (done < ulength);	

	return TRUE;
}

bool CLz4AES::Encrpyt(const BYTE *pInBuffer, BYTE *pOutBuffer, int nBufSize)
{
	if( pInBuffer == NULL || pOutBuffer == NULL || nBufSize <= 0 || m_bIsSetKey != TRUE ) {
		ASSERT(0);
		return FALSE;
	}

	aes_encrypt_ctx		actx;
	unsigned char		*pPlainIV;
	unsigned char		*pEncrypedIV;
	unsigned char		IVTemp[IV_SIZE];

	nBufSize	-= IV_SIZE;

	pPlainIV	= (unsigned char *)(pInBuffer + nBufSize);
	pEncrypedIV = pOutBuffer + nBufSize;

	memcpy(IVTemp, m_szEncKeyBuffer, IV_SIZE);

	aes_encrypt_key256(m_szEncKeyBuffer, &actx);

	if(aes_cbc_encrypt(pPlainIV, pEncrypedIV, IV_SIZE, IVTemp, &actx) != EXIT_SUCCESS)
		return FALSE;

	memcpy(IVTemp, pEncrypedIV, IV_SIZE);

	if( aes_cbc_encrypt(pInBuffer, pOutBuffer, nBufSize, IVTemp, &actx) != EXIT_SUCCESS )
		return FALSE;

	return TRUE;
}

bool CLz4AES::Decrpyt_Data(BYTE *input, unsigned long ulength)
{
	//BYTE					byInput[FILE_ENC_UNIT_SIZE];
	BYTE					byOutput[FILE_ENC_UNIT_SIZE];
	unsigned long			done = 0, worksize = 0;

	if(input == NULL || ulength <= 0 || m_bIsSetKey != TRUE) {
		ASSERT(0);
		return FALSE;
	}

	do 
	{
		worksize = ulength - done;
		if (worksize>FILE_ENC_UNIT_SIZE) 
			worksize = FILE_ENC_UNIT_SIZE;

		if (worksize<FILE_ENC_UNIT_SIZE) {
			break;
		}

		if(this->Decrypt(&input[done], byOutput, worksize) != TRUE) return FALSE;
		memcpy(&input[done],byOutput, worksize);
		done += worksize;
	} while (done < ulength);	

	return TRUE;
}

bool CLz4AES::Decrypt(const BYTE *pInBuffer, BYTE *pOutBuffer, int nBufSize)
{
	if( pInBuffer == NULL || pOutBuffer == NULL || nBufSize <= 0 || m_bIsSetKey != TRUE )
	{
		ASSERT(0);
		return FALSE;
	}

	aes_decrypt_ctx actx;

	unsigned char *pPlainIV;
	unsigned char *pEncrypedIV;
	unsigned char IVTemp[IV_SIZE];

	nBufSize -= IV_SIZE;

	pEncrypedIV = (unsigned char *)(pInBuffer + nBufSize);
	pPlainIV = pOutBuffer + nBufSize;

	memcpy(IVTemp, m_szEncKeyBuffer, IV_SIZE);

	aes_decrypt_key256(m_szEncKeyBuffer, &actx);

	if( aes_cbc_decrypt(pEncrypedIV, pPlainIV, IV_SIZE, IVTemp, &actx) != EXIT_SUCCESS )
	{
		return FALSE;
	}

	memcpy(IVTemp, pEncrypedIV, IV_SIZE);

	if( aes_cbc_decrypt(pInBuffer, pOutBuffer, nBufSize, IVTemp, &actx) != EXIT_SUCCESS )
	{
		return FALSE;
	}

	return TRUE;
}

void CLz4AES::ConvertKeyStringA(char *dst, const char *src)
{
	int k=0;

	while(*src) {
		*dst = *src + 20;
		src++;
		dst++;
		if (++k > MAX_PATH) break;
	}
	*dst = 0;
}

void CLz4AES::ConvertKeyStringW(wchar_t *dst, const wchar_t *src)
{
	int k=0;

	while(*src) {
		*dst = *src + 20;
		src++;
		dst++;
		if (++k > MAX_PATH) break;
	}
	*dst = 0;
}