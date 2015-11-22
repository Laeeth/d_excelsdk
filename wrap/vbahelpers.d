/**
	VBA helpers for xlld
*/
import xlld;
HINSTANCE hInstanceDLL;

// DLL entry point -- only stores the module handle for later use
BOOL WINAPI DllMain(HINSTANCE hinstDLL, DWORD fdwReason, LPVOID lpvReserved)
{
	hInstanceDLL = hinstDLL;

	return TRUE;
}

// change the dimensionality of a VBA array
extern(Windows) HRESULT XLPyDLLNDims(VARIANT* xlSource, int* xlDimension, bool *xlTranspose, VARIANT* xlDest)
{
	VariantClear(xlDest);

	try
	{
		// determine source dimensions
		int nSrcDims;
		int nSrcRows;
		int nSrcCols;
		SAFEARRAY* pSrcSA;
		if(0 == (xlSource.vt & VT_ARRAY))
		{
			nSrcDims = 0;
			nSrcRows = 1;
			nSrcCols = 1;
			pSrcSA = NULL;
		}
		else
		{
			if(xlSource.vt != (VT_VARIANT | VT_ARRAY) && xlSource.vt != (VT_VARIANT | VT_ARRAY | VT_BYREF))
				throw formatted_exception() << "Source array must be array of variants.";

			pSrcSA = (xlSource.vt & VT_BYREF) ? *xlSource.pparray : xlSource.parray;
			if(pSrcSA.cDims == 1)
			{
				nSrcDims = 1;
				nSrcRows = (int) pSrcSA.rgsabound.cElements;
				nSrcCols = 1;
			}
			else if(pSrcSA.cDims == 2)
			{
				nSrcDims = 2;
				nSrcRows = (int) pSrcSA.rgsabound[0].cElements;
				nSrcCols = (int) pSrcSA.rgsabound[1].cElements;
			}
			else
				throw formatted_exception() << "Source array must be either 1- or 2-dimensional.";
		}

		// determine dest dimension
		int nDestDims = *xlDimension;
		int nDestRows = nSrcRows;
		int nDestCols = nSrcCols;
		if(nDestDims == -1)
		{
			if(nSrcCols == 1 && nSrcRows == 1)
				nDestDims = 0;
			else if(nSrcCols == 1 || nSrcRows == 1)
				nDestDims = 1;
			else
				nDestDims = 2;
		}
		if(nDestDims == 1 && nSrcDims == 2)
		{
			if(nSrcRows != 1 && nSrcCols != 1)
				throw formatted_exception() << "When converting from 2- to 1-dimensional array, source must be (1 x n) or (n x 1).";
			if(nSrcCols != 1)
			{
				nDestRows = nSrcCols;
				nDestCols = nSrcRows;
			}
		}
		if(nDestDims == 0 && nSrcRows * nSrcCols != 1)
			throw formatted_exception() << "When converting array to scalar, source must contain only one element.";
		if(nDestDims == 2 && *xlTranspose)
		{
			int tmp = nDestRows;
			nDestRows = nDestCols;
			nDestCols = tmp;
		}

		// create destination safe array -- note that if nDestDims == 0 then AutoSafeArrayCreate does nothing and leaves pointer == NULL
		// for some reason, with 2-dimensional array bounds get swapped around by SafeArrayCreate
		SAFEARRAYBOUND bounds[2];
		bounds[0].lLbound = 1;
		bounds[0].cElements = (ULONG) nDestDims == 2 ? nDestCols : nDestRows;
		bounds[1].lLbound = 1;
		bounds[1].cElements = (ULONG) nDestDims == 2 ? nDestRows : nDestCols;
		AutoSafeArrayCreate asac(VT_VARIANT, nDestDims, bounds);
	
		// copy the data -- note that if NULL is passed to AutoSafeArrayAccessData then it does nothing 
		{
			VARIANT* pSrcData = xlSource;
			AutoSafeArrayAccessData(pSrcSA, (void**) &pSrcData);

			VARIANT* pDestData = xlDest;
			AutoSafeArrayAccessData(asac.pSafeArray, (void**) &pDestData);

			for(int iDestRow=0; iDestRow<nDestRows; iDestRow++)
			{
				for(int iDestCol=0; iDestCol<nDestCols; iDestCol++)
				{
					// safe array data is column-major -- and treating col-major data as row-major is the same as transposing
					int destIdx = iDestRow * nDestCols + iDestCol;
					int srcIdx = *xlTranspose ? iDestRow + iDestCol * nDestRows : destIdx;

					VariantInit(&pDestData[destIdx]);
					VariantCopy(&pDestData[destIdx], &pSrcData[srcIdx]);
				}
			}
		}

		// if we created a safe array, return and release it
		if(asac.pSafeArray != NULL)
		{
			xlDest.vt = VT_VARIANT | VT_ARRAY;
			xlDest.parray = asac.pSafeArray;
			asac.pSafeArray = NULL;
		}

		return S_OK;
	}
	catch(const std::exception& e)
	{
		ToVariant(e.what(), xlDest);
		return E_FAIL;
	}
}

// entry point - returns existing interface if already available, otherwise tries to activate it
HRESULT extern(Windows) XLPyDLLActivate(VARIANT* xlResult, const char* xlConfigFileName)
{
	try
	{
		VariantClear(xlResult);

		// set default config file
		std::string configFilename = xlConfigFileName;
		if(configFilename.empty())
			configFilename = "xlpython.xlpy";
		Config* pConfig = Config::GetConfig(configFilename);

		// if interface object isn't already available try to create it
		if(pConfig.pInterface == NULL || !pConfig.CheckRPCServer())
			pConfig.ActivateRPCServer();

		// pass it back to VBA
		xlResult.vt = VT_DISPATCH;
		xlResult.pdispVal = pConfig.pInterface;
		xlResult.pdispVal.AddRef();

		return S_OK;
	}
	catch(const std::exception& e)
	{
		ToVariant(e.what(), xlResult);
		return E_FAIL;
	}



void ToVariant(const char* str, VARIANT* var);
void ToVariant(const std::string& str, VARIANT* var);
void ToStdString(const wchar_t* ws, std::string& str);
void ToStdString(BSTR bs, std::string& str);
void ToBStr(const std::string& str, BSTR& bs);

class formatted_exception : public std::exception
{
protected:
	std::string s;

public:
	template<typename T>
	formatted_exception& operator<< (const T& value)
	{
		std::ostringstream oss;
		oss << value;
		s += oss.str();
		return *this;
	}

	formatted_exception& operator<< (const wchar_t* value)
	{
		std::string str;
		ToStdString(value, str);
		s += str;
		return *this;
	}

	virtual const char* what() const
	{
		return s.c_str();
	}
};

const char* GetDLLPath();
const char* GetDLLFolder();
void GetFullPathRelativeToDLLFolder(const std::string& path, std::string& out);

std::string GUIDToStdString(GUID& guid);
void ParseGUID(const char* str, GUID& guid);
void NewGUID(GUID& guid);

void GetLastWriteTime(const char* path, FILETIME* pFileTime);

std::string GetLastErrorMessage();

static inline std::string strlower(std::string& s)
{
	std::transform(s.begin(), s.end(), s.begin(), std::tolower);
	return s;
}

static inline std::string strupper(std::string& s)
{
	std::transform(s.begin(), s.end(), s.begin(), std::toupper);
	return s;
}

static inline std::string strtrim(std::string &s)
{
	s.erase(s.begin(), std::find_if(s.begin(), s.end(), std::not1(std::ptr_fun<int, int>(std::isspace))));
	s.erase(std::find_if(s.rbegin(), s.rend(), std::not1(std::ptr_fun<int, int>(std::isspace))).base(), s.end());
	return s;
}

static inline void strsplit(const std::string& s, const std::string& sep, std::vector<std::string>& out, bool trim=true)
{
	std::string ss = s;
	size_t pos;
	while(std::string::npos != (pos = ss.find(sep)))
	{
		out.push_back(trim ? strtrim(ss.substr(0, pos)) : ss.substr(0, pos));
		ss = ss.substr(pos + sep.length());
	}
	out.push_back(trim ? strtrim(ss) : ss);
}

template<class T>
class AutoArrayDeleter
{
public:
	T* p;
	AutoArrayDeleter(T* p)
	{
		this->p = p;
	}
	~AutoArrayDeleter()
	{
		delete[] p;
	}
};

class AutoSafeArrayAccessData
{
	SAFEARRAY* _pSA;

public:
	AutoSafeArrayAccessData(SAFEARRAY* pSA, void** ppData)
	{
		_pSA = NULL;
		if(pSA != NULL)
		{
			if(FAILED(SafeArrayAccessData(pSA, ppData)))
				throw formatted_exception() << "Could not access safe array data.";
		}
		_pSA = pSA;
	}

	~AutoSafeArrayAccessData()
	{
		if(_pSA != NULL && FAILED(SafeArrayUnaccessData(_pSA)))
			throw formatted_exception() << "Could not unaccess safe array data.";
	}
};

SAFEARRAY* createSafeArray(VARTYPE vt, UINT cDims, SAFEARRAYBOUND* rgsabound)
{
	SAFEARRAY *pSafeArray=null;
		if(cDims > 0)
		{
			pSafeArray = SafeArrayCreate(vt, cDims, rgsabound);
			if(pSafeArray == NULL)
				throw formatted_exception() << "Could not create safe array.";
		}
	}
}


	~AutoSafeArrayCreate()
	{
		if(pSafeArray != NULL && FAILED(SafeArrayDestroy(pSafeArray)))
			throw formatted_exception() << "Could not destroy safe array.";
	}
};

class AutoCloseHandle
{
public:
	HANDLE handle;

	AutoCloseHandle(const HANDLE& handle)
	{
		this->handle = handle;
	}

	~AutoCloseHandle()
	{
		if(this->handle != NULL && this->handle != INVALID_HANDLE_VALUE)
			CloseHandle(this->handle);
	}

	operator HANDLE ()
	{
		return handle;
	}
};


#include "xlpython.h"

void ToVariant(const char* str, VARIANT* var)
{
	VariantClear(var);

	int sz = (int) strlen(str) + 1;
	OLECHAR* wide = new OLECHAR[sz];
	MultiByteToWideChar(CP_ACP, 0, str, sz * sizeof(OLECHAR), wide, sz);
	var->vt = VT_BSTR;
	var->bstrVal = SysAllocString(wide);
	delete[] wide;
}

void ToVariant(const std::string& str, VARIANT* var)
{
	ToVariant(str.c_str(), var);
}

void ToStdString(const wchar_t* ws, std::string& str)
{
	BOOL bUsedDefaultChar;
	int len = (int) wcslen(ws);
	char* narrow = new char[len+1];
	WideCharToMultiByte(CP_ACP, 0, ws, len, narrow, len+1, "?", &bUsedDefaultChar);
	narrow[len] = 0;
	str = narrow;
	delete narrow;
}

void ToStdString(BSTR bs, std::string& str)
{
	BOOL bUsedDefaultChar;
	int len = (int) SysStringLen(bs);
	AutoArrayDeleter<char> narrow(new char[len+1]);
	WideCharToMultiByte(CP_ACP, 0, bs, len, narrow.p, len+1, "?", &bUsedDefaultChar);
	narrow.p[len] = 0;
	str = narrow.p;
}

void ToBStr(const std::string& str, BSTR& bs)
{
	int sz = (int) str.length() + 1;
	OLECHAR* wide = new OLECHAR[sz];
	MultiByteToWideChar(CP_ACP, 0, str.c_str(), sz * sizeof(OLECHAR), wide, sz);
	bs = SysAllocString(wide);
	delete[] wide;
}

std::string GetLastErrorMessage()
{
	DWORD dwError = GetLastError();
	char* lpMsgBuf;
	
	if(0 == FormatMessageA(
		FORMAT_MESSAGE_ALLOCATE_BUFFER | 
		FORMAT_MESSAGE_FROM_SYSTEM |
		FORMAT_MESSAGE_IGNORE_INSERTS,
		NULL,
		dwError,
		0,
		(LPSTR) &lpMsgBuf,
		0,
		NULL))
	{
		return "Could not get error message: FormatMessage failed.";
	}

	std::string ret = lpMsgBuf;
	LocalFree(lpMsgBuf);
	return ret;
}

const char* GetDLLPath()
{
	static bool initialized = false;
	static char path[MAX_PATH];

	if(!initialized)
	{
		if(0 == GetModuleFileNameA(hInstanceDLL, path, MAX_PATH))
			throw formatted_exception() << "GetModuleFileName failed.";

		initialized = true;
	}

	return path;
}


const char* GetDLLFolder()
{
	static bool initialized = false;
	static char folderPath[MAX_PATH];

	if(!initialized)
	{
		if(0 == GetModuleFileNameA(hInstanceDLL, folderPath, MAX_PATH))
			throw formatted_exception() << "GetModuleFileName failed.";

		int n = (int) strlen(folderPath) - 1;
		while(folderPath[n] != '\\' && n > 0)
			n--;

		if(n == 0)
			throw formatted_exception() << "Could deduce DLL folder, GetModuleFileName returned '" << folderPath << "'.";

		folderPath[n] = 0;

		initialized = true;
	}

	return folderPath;
}

void GetFullPathRelativeToDLLFolder(const std::string& path, std::string& out)
{
	char buffer[MAX_PATH];
	char curdir[MAX_PATH];
	if(0 == GetCurrentDirectoryA(MAX_PATH, curdir))
		throw formatted_exception() << "GetCurrentDirectory failed in GetFullPathRelativeToDLLFolder.";
	if(0 == SetCurrentDirectoryA(GetDLLFolder()))
		throw formatted_exception() << "SetCurrentDirectory (1st) failed in GetFullPathRelativeToDLLFolder.";
	if(0 == GetFullPathNameA(path.c_str(), MAX_PATH, buffer, NULL))
		throw formatted_exception() << "GetFullPathName failed in GetFullPathRelativeToDLLFolder.";
	if(0 == SetCurrentDirectoryA(curdir))
		throw formatted_exception() << "SetCurrentDirectory (2nd) failed in GetFullPathRelativeToDLLFolder.";
	out = buffer;
}

std::string GUIDToStdString(GUID& guid)
{
	char buffer[100];
	sprintf_s(buffer, 100, "{%08x-%04x-%04x-%02x%02x-%02x%02x%02x%02x%02x%02x}",
          guid.Data1, guid.Data2, guid.Data3,
          guid.Data4[0], guid.Data4[1], guid.Data4[2],
          guid.Data4[3], guid.Data4[4], guid.Data4[5],
          guid.Data4[6], guid.Data4[7]);
    return buffer;
}

void ParseGUID(const char* s, GUID& guid)
{
    unsigned long p0;
    unsigned short p1, p2, p3, p4, p5, p6, p7, p8, p9, p10;

	int nConverted = sscanf_s(s, "{%8lX-%4hX-%4hX-%2hX%2hX-%2hX%2hX%2hX%2hX%2hX%2hX}", &p0, &p1, &p2, &p3, &p4, &p5, &p6, &p7, &p8, &p9, &p10);
	if(nConverted != 11)
		throw formatted_exception() << "Failed to parse GUID '" << s << "', it should be in the form {xxxxxxxx-xxxx-xxxx-xxxx-xxxxxxxxxxx}.";

    guid.Data1 = p0;
    guid.Data2 = p1;
    guid.Data3 = p2;
    guid.Data4[0] = (unsigned char) p3;
    guid.Data4[1] = (unsigned char) p4;
    guid.Data4[2] = (unsigned char) p5;
    guid.Data4[3] = (unsigned char) p6;
    guid.Data4[4] = (unsigned char) p7;
    guid.Data4[5] = (unsigned char) p8;
    guid.Data4[6] = (unsigned char) p9;
    guid.Data4[7] = (unsigned char) p10;
}

void NewGUID(GUID& guid)
{
	HRESULT hr = CoCreateGuid(&guid);
	if(FAILED(hr))
		throw formatted_exception() << "CoCreateGuid failed.";
}

void GetLastWriteTime(const char* path, FILETIME* pFileTime)
{
	AutoCloseHandle hFile(CreateFileA(
		path,
		GENERIC_READ,
		FILE_SHARE_READ,
		NULL,
		OPEN_EXISTING,
		FILE_ATTRIBUTE_NORMAL,
		NULL
		));

	if(hFile.handle == INVALID_HANDLE_VALUE)
		throw formatted_exception() << "Could not open file '" << path << "' to get last write time.";

	if(!GetFileTime(hFile.handle, NULL, NULL, pFileTime))
		throw formatted_exception() << "Could not get last write time for '" << path << "'.";
}


class AutoSafeArrayAccessData
{
	SAFEARRAY* _pSA;

public:
	AutoSafeArrayAccessData(SAFEARRAY* pSA, void** ppData)
	{
		_pSA = NULL;
		if(pSA != NULL)
		{
			if(FAILED(SafeArrayAccessData(pSA, ppData)))
				throw formatted_exception() << "Could not access safe array data.";
		}
		_pSA = pSA;
	}

	~AutoSafeArrayAccessData()
	{
		if(_pSA != NULL && FAILED(SafeArrayUnaccessData(_pSA)))
			throw formatted_exception() << "Could not unaccess safe array data.";
	}
};

class AutoSafeArrayCreate
{
public:
	SAFEARRAY* pSafeArray;

	AutoSafeArrayCreate(VARTYPE vt, UINT cDims, SAFEARRAYBOUND* rgsabound)
		: pSafeArray(NULL)
	{
		if(cDims > 0)
		{
			pSafeArray = SafeArrayCreate(vt, cDims, rgsabound);
			if(pSafeArray == NULL)
				throw formatted_exception() << "Could not create safe array.";
		}
	}

	~AutoSafeArrayCreate()
	{
		if(pSafeArray != NULL && FAILED(SafeArrayDestroy(pSafeArray)))
			throw formatted_exception() << "Could not destroy safe array.";
	}
};

class AutoCloseHandle
{
public:
	HANDLE handle;

	AutoCloseHandle(const HANDLE& handle)
	{
		this->handle = handle;
	}

	~AutoCloseHandle()
	{
		if(this->handle != NULL && this->handle != INVALID_HANDLE_VALUE)
			CloseHandle(this->handle);
	}

	operator HANDLE ()
	{
		return handle;
	}
};