/**
	Idiomatic D wrapper for Excel SDK inspired by PyD and PyXLL:
		- allows writing excel user defined functions in D without extra glue code
		- simply annotate the function with xlld attributes and it will be wrapped and automatically registered
		  on workbook open and deregistered on close

	That's the ultimate goal.  For the time being we start by using annotations to automatically register and
	deregister functions but still require user to accept LPXLOPER as arguments and return type.  Function should be
	extern(Windows) too.  Later we can transparently wrap these as D variants/native types.

	To do:
		- wrap arguments and return types
		- custom menu helper
		- custom toolbar helper
		- dialogue box helper
		- handle more types: int, long, float, double, string, bool, DateTime/SysTime, D matrices
		- excel errors: null, div/0, value, ref, name, num,na (map to exceptions)
			Lookup, ZeroDivision, Value, Reference, Name, Arithmetic, Runtime
		- cell metadata: value, address, formula, note, sheetName, sheetId, rect (xlRect - coordinates)
		- async returns
		- calling excel from D
		- COM
		- callbacks: onOpen, onReload, onClose, reloadXLL,
		- object cache
*/

module xlld.boilerplate;
import win32.winuser:PostMessage,CallWindowProc,GetWindowLongPtr,SetWindowLongPtr,DialogBox;
import std.c.windows.windows;
import core.sys.windows.windows;
import xlcall;
import framework;
import core.stdc.wchar_ : wcslen;
import core.stdc.wctype:towlower;
import std.format;

enum GWLP_WNDPROC=-4;
enum MAXWORD = 0xFFFF;
debug=0;
extern(Windows)
{
	pragma(lib, "gdi32");
	pragma(lib, "kernel32");
	pragma(lib, "user32");
	pragma(lib, "gdi32");
	pragma(lib, "winspool");
	pragma(lib, "comdlg32");
	pragma(lib, "advapi32");
	pragma(lib, "shell32");
	pragma(lib, "ole32");
	pragma(lib, "oleaut32");
	pragma(lib, "uuid");
	pragma(lib, "odbc32");
	pragma(lib, "xlcall32d");
	//pragma(lib, "odbccp32");
	//pragma(lib, "msvcrt32");

	enum GMEM_MOVEABLE = 0x02;
	void* GlobalAlloc(uint, size_t);
   void* GlobalLock(void*);
   bool GlobalUnlock(void*);
	void cwCenter(HWND, int);
	//INT_PTR /*CALLBACK*/ DIALOGMsgProc(HWND hWndDlg, UINT message, WPARAM wParam, LPARAM lParam);
}


/**
   DllMain()
  
   Purpose:
  
        Windows calls DllMain, for both initialization and termination.
  		It also makes calls on both a per-process and per-thread basis,
  		so several initialization calls can be made if a process is multithreaded.
  
        This function is called when the DLL is first loaded, with a dwReason
        of DLL_PROCESS_ATTACH.
  
   Parameters:
  
        HANDLE hDLL         Module handle.
        DWORD dwReason,     Reason for call
        LPVOID lpReserved   Reserved
  
   Returns: 
        The function returns true (1) to indicate success. If, during
        per-process initialization, the function returns zero, 
        the system cancels the process.
  
   Comments:
  
   History:  Date       Author        Reason
*/

extern(Windows) BOOL /*APIENTRY*/ DllMain( HANDLE hDLL, DWORD dwReason, LPVOID lpReserved )
{
	import core.runtime;
	import std.c.windows.windows;
	import core.sys.windows.dll;
	switch (dwReason)
	{
	case DLL_PROCESS_ATTACH:
		Runtime.initialize();
		// The instance handle passed into DllMain is saved
		// in the global variable g_hInst for later use.
		g_hInst = hDLL;
		dll_process_attach( hDLL, true );
		break;
	case DLL_PROCESS_DETACH:
		Runtime.terminate();
	    dll_process_detach( hDLL, true );
		break;
	case DLL_THREAD_ATTACH:
	    dll_thread_attach( true, true );
		break;
	case DLL_THREAD_DETACH:
		dll_thread_detach( true, true );
		break;
	default:
		break;
	}
	return true;
}

/**
   xlAutoOpen()
  
   Purpose: 
        Microsoft Excel call this function when the DLL is loaded.
  
        Microsoft Excel uses xlAutoOpen to load XLL files.
        When you open an XLL file, the only action
        Microsoft Excel takes is to call the xlAutoOpen function.
  
        More specifically, xlAutoOpen is called:
  
         - when you open this XLL file from the File menu,
         - when this XLL is in the XLSTART directory, and is
           automatically opened when Microsoft Excel starts,
         - when Microsoft Excel opens this XLL for any other reason, or
         - when a macro calls REGISTER(), with only one argument, which is the
           name of this XLL.
  
        xlAutoOpen is also called by the Add-in Manager when you add this XLL 
        as an add-in. The Add-in Manager first calls xlAutoAdd, then calls
        REGISTER("EXAMPLE.XLL"), which in turn calls xlAutoOpen.
  
        xlAutoOpen should:
  
         - register all the functions you want to make available while this
           XLL is open,
  
         - add any menus or menu items that this XLL supports,
  
         - perform any other initialization you need, and
  
         - return 1 if successful, or return 0 if your XLL cannot be opened.
  
   Parameters:
  
   Returns: 
  
        int         1 on success, 0 on failure
  
   Comments:
  
   History:  Date       Author        Reason
*/

extern(Windows) int /*WINAPI*/ xlAutoOpen()
{
	import std.conv;

	static XLOPER12 xDLL,	   // name of this DLL //
	xMenu,	 // xltypeMulti containing the menu //
	xTool,	 // xltypeMulti containing the toolbar //
	xTest;	 // used for menu test //
	LPXLOPER12 pxMenu;	   // Points to first menu item //
	LPXLOPER12 px;		   // Points to the current item //
	LPXLOPER12 pxTool;	   // Points to first toolbar item //
	int i, j;			   // Loop indices //

	/**
	   In the following block of code the name of the XLL is obtained by
	   calling xlGetName. This name is used as the first argument to the
	   REGISTER function to specify the name of the XLL. Next, the XLL loops
	   through the g_rgWorksheetFuncs[] table, and the g_rgCommandFuncs[]
	   tableregistering each function in the table using xlfRegister. 
	   Functions must be registered before you can add a menu item.
	*/
	
	Excel12f(xlGetName, &xDLL, []);

	foreach(row;exportedFunctionTable.length)
		Excel12f(xlfRegister, cast(LPXLOPER12)0, [cast(LPXLOPER12) &xDLL] ~ TempStr12(row[]));

	foreach(row;exportedFunctionTable[0].length)
		Excel12f(xlfRegister,  cast(LPXLOPER12)0, [cast(LPXLOPER12) &xDLL] ~ TempStr12(row[]));

	}

	}

	// Free the XLL filename //
	Excel12f(xlFree, cast(XLOPER12*)0, [cast(LPXLOPER12) &xTest, cast(LPXLOPER12) &xDLL]);
	return 1;
}




/**
   xlAutoClose()
  
   Purpose: Microsoft Excel call this function when the DLL is unloaded.
  
        xlAutoClose is called by Microsoft Excel:
  
         - when you quit Microsoft Excel, or 
         - when a macro sheet calls UNREGISTER(), giving a string argument
           which is the name of this XLL.
  
        xlAutoClose is called by the Add-in Manager when you remove this XLL from
        the list of loaded add-ins. The Add-in Manager first calls xlAutoRemove,
        then calls UNREGISTER("GENERIC.XLL"), which in turn calls xlAutoClose.
   
        xlAutoClose is called by GENERIC.XLL by the function fExit. This function
        is called when you exit Generic.
   
        xlAutoClose should:
   
         - Remove any menus or menu items that were added in xlAutoOpen,
   
         - do any necessary global cleanup, and
   
         - delete any names that were added (names of exported functions, and 
           so on). Remember that registering functions may cause names to 
           be created.
   
        xlAutoClose does NOT have to unregister the functions that were registered
        in xlAutoOpen. This is done automatically by Microsoft Excel after
        xlAutoClose returns.
   
        xlAutoClose should return 1.
  
   Parameters:
  
   Returns: 
  
        int         1
  
   Comments:
  
   History:  Date       Author        Reason
*/

extern(Windows) int /*WINAPI*/ xlAutoClose()
{
	int i;
	XLOPER12 xRes;

	
	/**
	  This block first deletes all names added by xlAutoOpen or
	   xlAutoRegister12. Next, it checks if the drop-down menu Generic still
	   exists. If it does, it is deleted using xlfDeleteMenu. It then checks
	   if the Test toolbar still exists. If it is, xlfDeleteToolbar is
	   used to delete it.
	*/

	/**
	   Due to a bug in Excel the following code to delete the defined names
	   does not work.  There is no way to delete these
	   names once they are Registered
	   The code is left in, in hopes that it will be
	   fixed in a future version.
	*/

	for (i = 0; i < g_rgWorksheetFuncsRows; i++)
		Excel12f(xlfSetName, cast(XLOPER12*)0,[TempStr12(g_rgWorksheetFuncs[i][2])]);


	return 1;
}



// user-initiated routine to exit the DLL

extern(Windows) int  exitDLL()
{
	XLOPER12  xDLL,    // The name of this DLL //
	xFunc,             // The name of the function //
	xRegId;            // The registration ID //
	int i;

	/**
		This code gets the DLL name. It then uses this along with information
		from g_rgFuncs[] to obtain a REGISTER.ID() for each function. The
		register ID is then used to unregister each function. Then the code
		frees the DLL name and calls xlAutoClose.
	*/

	xFunc.xltype = xltypeStr; // Make xFunc a string //
	
	Excel12f(xlGetName, &xDLL, []);

	foreach(i,func;exportedFunctionTable)
	{
		xFunc.val.str = cast(LPWSTR) (func[0]);
		Excel12f(xlfRegisterId,&xRegId,[cast(LPXLOPER12)&xDLL,cast(LPXLOPER12)&xFunc]);
		Excel12f(xlfUnregister, cast(XLOPER*)0,[cast(LPXLOPER12) &xRegId]);
	}

	foreach(i,func;exportedFunctionTable)
	{
		xFunc.val.str = cast(LPWSTR) (func[0]);
		Excel12f(xlfRegisterId,&xRegId,[cast(LPXLOPER12)&xDLL,cast(LPXLOPER12)&xFunc]);
		Excel12f(xlfUnregister, cast(XLOPER*)0, [cast(LPXLOPER12) &xRegId]);
	}

	Excel12f(xlFree, cast(XLOPER*)0, [cast(LPXLOPER12) &xDLL]);

	return xlAutoClose();
}



/**
   xlAutoRegister12()
  
   Purpose:
  
        This function is called by Microsoft Excel if a macro sheet tries to
        register a function without specifying the type_text argument. If that
        happens, Microsoft Excel calls xlAutoRegister12, passing the name of the
        function that the user tried to register. xlAutoRegister12 should use the
        normal REGISTER function to register the function, only this time it must
        specify the type_text argument. If xlAutoRegister12 does not recognize the
        function name, it should return a #VALUE! error. Otherwise, it should
        return whatever REGISTER returned.
  
   Parameters:
  
        LPXLOPER12 pxName   xltypeStr containing the
                            name of the function
                            to be registered. This is not
                            case sensitive.
  
   Returns: 
  
        LPXLOPER12          xltypeNum containing the result
                            of registering the function,
                            or xltypeErr containing #VALUE!
                            if the function could not be
                            registered.
  
   Comments:
  
   History:  Date       Author        Reason
*/

extern(Windows) LPXLOPER12 /*WINAPI*/ xlAutoRegister12(LPXLOPER12 pxName)
{
	static XLOPER12 xDLL, xRegId;
	int i;

	
	/**
	   This block initializes xRegId to a #VALUE! error first. This is done in
	   case a function is not found to register. Next, the code loops through 
	   the functions in g_rgFuncs[] and uses lpwstricmp to determine if the 
	   current row in g_rgFuncs[] represents the function that needs to be 
	   registered. When it finds the proper row, the function is registered 
	   and the register ID is returned to Microsoft Excel. If no matching 
	   function is found, an xRegId is returned containing a #VALUE! error.
	*/

	xRegId.xltype = xltypeErr;
	xRegId.val.err = xlerrValue;


	for (i=0; i<g_rgWorksheetFuncsRows; i++)
	{
		if (!lpwstricmp(g_rgWorksheetFuncs[i][0].ptr, pxName.val.str))
		{
			Excel12f(xlfRegister, cast(XLOPER12*)0,
				  [cast(LPXLOPER12) &xDLL,
				  cast(LPXLOPER12) TempStr12(g_rgWorksheetFuncs[i][0]),
				  cast(LPXLOPER12) TempStr12(g_rgWorksheetFuncs[i][1]),
				  cast(LPXLOPER12) TempStr12(g_rgWorksheetFuncs[i][2]),
				  cast(LPXLOPER12) TempStr12(g_rgWorksheetFuncs[i][3]),
				  cast(LPXLOPER12) TempStr12(g_rgWorksheetFuncs[i][4]),
				  cast(LPXLOPER12) TempStr12(g_rgWorksheetFuncs[i][5]),
				  cast(LPXLOPER12) TempStr12(g_rgWorksheetFuncs[i][6]),
				  cast(LPXLOPER12) TempStr12(g_rgWorksheetFuncs[i][7]),
				  cast(LPXLOPER12) TempStr12(g_rgWorksheetFuncs[i][8]),
				  cast(LPXLOPER12) TempStr12(g_rgWorksheetFuncs[i][9])]);
			/// Free oper returned by xl //
			Excel12f(xlFree, cast(XLOPER12*)0,[cast(LPXLOPER12) &xDLL]);

			return cast (LPXLOPER12) &xRegId;
		}
	}

	for (i=0; i<g_rgCommandFuncsRows; i++)
	{
		if (!lpwstricmp(g_rgCommandFuncs[i][0].ptr, pxName.val.str))
		{
			Excel12f(xlfRegister, cast(XLOPER12*)0, 
				  [cast(LPXLOPER12) &xDLL,
				  cast(LPXLOPER12) TempStr12(g_rgCommandFuncs[i][0]),
				  cast(LPXLOPER12) TempStr12(g_rgCommandFuncs[i][1]),
				  cast(LPXLOPER12) TempStr12(g_rgCommandFuncs[i][2]),
				  cast(LPXLOPER12) TempStr12(g_rgCommandFuncs[i][3]),
				  cast(LPXLOPER12) TempStr12(g_rgCommandFuncs[i][4]),
				  cast(LPXLOPER12) TempStr12(g_rgCommandFuncs[i][5]),
				  cast(LPXLOPER12) TempStr12(g_rgCommandFuncs[i][6])]);
			/// Free oper returned by xl //
			Excel12f(xlFree, cast(XLOPER12*)0, [cast(LPXLOPER12) &xDLL]);

			return cast(LPXLOPER12) &xRegId;
		}
	}     
	return cast(LPXLOPER12) &xRegId;
}
/**
   xlAutoAdd()
  
   Purpose:
  
        This function is called by the Add-in Manager only. When you add a
        DLL to the list of active add-ins, the Add-in Manager calls xlAutoAdd()
        and then opens the XLL, which in turn calls xlAutoOpen.
  
   Parameters:
  
   Returns: 
  
        int         1
  
   Comments:
  
   History:  Date       Author        Reason
*/

extern(Windows) int /*WINAPI*/ xlAutoAdd()
{
	enum szBuf=format("Thank you for adding GENERIC.XLL\n built on %s at %s",__DATE__,__TIME__);
	// Display a dialog box indicating that the XLL was successfully added //
	Excel12f(xlcAlert, cast(XLOPER*)0, [TempStr12(szBuf), TempInt12(2)]);
	return 1;
}

/**
   xlAutoRemove()
  
   Purpose:
  
        This function is called by the Add-in Manager only. When you remove
        an XLL from the list of active add-ins, the Add-in Manager calls
        xlAutoRemove() and then UNREGISTER("GENERIC.XLL").
     
        You can use this function to perform any special tasks that need to be
        performed when you remove the XLL from the Add-in Manager's list
        of active add-ins. For example, you may want to delete an
        initialization file when the XLL is removed from the list.
  
   Parameters:
  
   Returns: 
  
        int         1
  
   Comments:
  
   History:  Date       Author        Reason
*/

extern(Windows) int /*WINAPI*/ xlAutoRemove()
{
	// Show a dialog box indicating that the XLL was successfully removed //
	Excel12f(xlcAlert, cast(XLOPER*)0,[TempStr12("Thank you for removing GENERIC.XLL!"w),
		  TempInt12(2)]);
	return 1;
}

/**
   xlAddInManagerInfo12()
  
   Purpose:
  
        This function is called by the Add-in Manager to find the long name
        of the add-in. If xAction = 1, this function should return a string
        containing the long name of this XLL, which the Add-in Manager will use
        to describe this XLL. If xAction = 2 or 3, this function should return
        #VALUE!.
  
   Parameters:
  
        LPXLOPER12 xAction  What information you want. One of:
                              1 = the long name of the
                                  add-in
                              2 = reserved
                              3 = reserved
  
   Returns: 
  
        LPXLOPER12          The long name or #VALUE!.
  
   Comments:
  
   History:  Date       Author        Reason
*/

extern(Windows) LPXLOPER12 /*WINAPI*/ xlAddInManagerInfo12(LPXLOPER12 xAction)
{
	static XLOPER12 xInfo, xIntAction;

	//
	// This code coerces the passed-in value to an integer. This is how the
	// code determines what is being requested. If it receives a 1, 
	// it returns a string representing the long name. If it receives 
	// anything else, it returns a #VALUE! error.
	//

	Excel12f(xlCoerce, &xIntAction,[xAction, TempInt12(xltypeInt)]);

	if (xIntAction.val.w == 1)
	{
		xInfo.xltype = xltypeStr;
		xInfo.val.str = TempStr12("Generic Standalone DLL"w).val.str;
	}
	else
	{
		xInfo.xltype = xltypeErr;
		xInfo.val.err = xlerrValue;
	}

	//Word of caution - returning static XLOPERs/XLOPER12s is not thread safe
	//for UDFs declared as thread safe, use alternate memory allocation mechanisms
	return cast(LPXLOPER12) &xInfo;
}

/**
   GetHwnd()
  
   Purpose:
  
        This function returns the hWnd of Excel's main window. 
  
   Parameters:
  
        HWND * phwnd    Will contain Excel's hWnd
  
   Returns: 
  
        BOOL            false  Could not find Excel's hWnd
                        true   Found Excel's hWnd
  
   Comments:
  
   History:  Date       Author        Reason
*/
extern(Windows) BOOL GetHwnd(HWND * pHwnd)
{
	XLOPER12 x;

	if (Excel12f(xlGetHwnd, &x, []) == xlretSuccess)
	{
		*pHwnd = cast(HWND)x.val.w;
		return true;
	}
	return false;
}
