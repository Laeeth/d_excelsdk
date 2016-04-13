/**  
    Microsoft Excel Developer's Toolkit
    Version 14.0
  
    File:           SRC\XLCALL.CPP
    Description:    Code file for Excel callbacks
    Platform:       Microsoft Windows
  
    This file defines the entry points 
    which are used in the Microsoft Excel C API.
  
*/

// import windows.h
//import std.c.windows.windows;
import core.sys.windows.windows;
import xlcall;
import core.vararg;

/**
   Excel 12 entry points backwards compatible with Excel 11
  
   Excel12 and Excel12v ensure backwards compatibility with Excel 11
   and earlier versions. These functions will return xlretFailed when
   used to callback into Excel 11 and earlier versions
*/

enum cxloper12Max=255;
enum EXCEL12ENTRYPT="MdCallBack12";

// PASCAL
alias EXCEL12PROC=extern(Windows) int function (int xlfn, int coper, LPXLOPER12 *rgpxloper12, LPXLOPER12 xloper12Res);

HMODULE hmodule;
EXCEL12PROC pexcel12;

void FetchExcel12EntryPt() // __forceinline 
{
	if (pexcel12 is null)
	{
		hmodule = GetModuleHandleW(null);
		if (hmodule !is null)
		{
			pexcel12 = cast(EXCEL12PROC) GetProcAddress(hmodule, EXCEL12ENTRYPT);
		}
	}
}

/**
   This function explicitly sets EXCEL12ENTRYPT.
  
   If the XLL is loaded not by Excel.exe, but by a HPC cluster container DLL,
   then GetModuleHandle(null) would return the process EXE module handle.
   In that case GetProcAddress would fail, since the process EXE doesn't
   export EXCEL12ENTRYPT ( since it's not Excel.exe).
  
   First try to fetch the known good entry point,
   then set the passed in address.
*/

//pascal
extern(Windows) void SetExcel12EntryPt(EXCEL12PROC pexcel12New)
{
	FetchExcel12EntryPt();
	if (pexcel12 is null)
	{
		pexcel12 = pexcel12New;
	}
}

//_cdecl
int Excel12(int xlfn, LPXLOPER12 operRes, LPXLOPER12[] args ...)
{

	LPXLOPER12[cxloper12Max] rgxloper12;
	va_list ap;
	int ioper;
	int mdRet;

	FetchExcel12EntryPt();
	if (pexcel12 is null)
	{
		mdRet = xlretFailed;
	}
	else
	{
		mdRet = xlretInvCount;
		if ((args.length >= 0)  && (args.length<= cxloper12Max))
		{
			foreach(i,arg;args)
				rgxloper12[ioper] = arg;
//			original line was mdRet = (pexcel12)(xlfn, count, &rgxloper12[0], operRes);
			mdRet = (*pexcel12)(xlfn, cast(int)args.length, rgxloper12.ptr, operRes);
		}
	}
	return(mdRet);
	
}

//pascal
extern(Windows) int Excel12v(int xlfn, LPXLOPER12 operRes, int count, LPXLOPER12* opers)
{
	int mdRet;
	FetchExcel12EntryPt();
	if (pexcel12 is null)
	{
		mdRet = xlretFailed;
	}
	else
	{
		// original line was mdRet = (pexcel12)(xlfn, count, &rgxloper12[0], operRes);
		mdRet = (*pexcel12)(xlfn, count, opers, operRes);
	}
	return(mdRet);

}
