#pragma once
//
#include "AES/aes.h"
#include "AES/pwd2key.h"

class CLz4AES
{
public:
	CLz4AES(void);
	~CLz4AES(void);

protected:	
	bool				Lz4SetKey(unsigned long file_size, unsigned long file_date);

	bool				Encrpyt_Data(unsigned char *input, unsigned long ulength);
	bool				Decrpyt_Data(unsigned char *input, unsigned long ulength);
	

private:
	bool				m_bIsSetKey;
	bool				SetKey(const char *pszKey, int nLen = -1, const char *pszSaltKey = NULL, int nSaltKeyLen = -1);
	bool				Encrpyt(const unsigned char *pInBuffer, unsigned char *pOutBuffer, int nBufSize);
	bool				Decrypt(const unsigned char *pInBuffer, unsigned char *pOutBuffer, int nBufSize);

	void				ConvertKeyStringA(char *dst, const char *src);
	void				ConvertKeyStringW(wchar_t *dst, const wchar_t *src);
protected:
	static const int	KDF_ROUNDS		= 5;
	static const int	IV_SIZE			= 16;
	static const int	SALT_KEY_SIZE	= 16;
	static const int	ENC_KEY_LENGTH	= 32;

	static const int	FILE_ENC_UNIT_SIZE = 512;

	static const char	SALT_KEY_BUF[SALT_KEY_SIZE + 1];
	unsigned char		m_szEncKeyBuffer[ENC_KEY_LENGTH];
};

