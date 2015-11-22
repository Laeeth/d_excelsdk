module xlld.helper;

/**
   lpwstricmp()
  
   Purpose: 
  
        Compares a pascal string and a null-terminated C-string to see
        if they are equal.  Method is case insensitive
  
   Parameters:
  
        LPWSTR s    First string (null-terminated)
        LPWSTR t    Second string (byte counted)
  
   Returns: 
  
        int         0 if they are equal
                    Nonzero otherwise
  
   Comments:
  
        Unlike the usual string functions, lpwstricmp
        doesn't care about collating sequence.
  
   History:  Date       Author        Reason
*/

int lpwstricmp(const(wchar*) s, const(wchar*) t)
{
	int i;

	if (wcslen(s) != *t)
		return 1;

	for (i = 1; i <= s[0]; i++)
	{
		if (towlower(s[i-1]) != towlower(t[i]))
			return 1;
	}										  
	return 0;
}


/**
   DIALOGMsgProc()
  
   Purpose:
  
       This procedure is associated with the native Windows dialog box that
       fShowDialog displays. It provides the service routines for the events
       (messages) that occur when the user operates one of the dialog
       box's buttons, entry fields, or controls.
  
   Parameters:
  
        HWND hWndDlg        Contains the HWND of the dialog box
        UINT message        The message to respond to
        WPARAM wParam       Arguments passed by Windows
        LPARAM lParam
  
   Returns: 
  
        INT_PTR                true if message processed, false if not.
  
   Comments:
  
   History:  Date       Author        Reason
*/

extern(Windows) INT_PTR /*CALLBACK*/ DIALOGMsgProc(HWND hWndDlg, UINT message, WPARAM wParam, LPARAM lParam)
{

  /**
     This block is a very simple message loop for a dialog box. It checks for
     only three messages. When it receives WM_INITDIALOG, it uses a buffer to
     set a static text item to the amount of free space on the stack. When it
     receives WM_CLOSE it posts a CANCEL message to the dialog box. When it
     receives WM_COMMAND it checks if the OK button was pressed. If it was,
     the dialog box is closed and control returned to fShowDialog.
  */

  switch (message)
  {
  
  case WM_INITDIALOG:
    SetDlgItemTextW(hWndDlg, FREE_SPACE, cast(wchar*)g_szBuffer);
    break;

  case WM_CLOSE:
    PostMessage(hWndDlg, WM_COMMAND, IDCANCEL, 0L);
    break;

  case WM_COMMAND:
    switch (wParam)
    {
    case IDOK:
      EndDialog(hWndDlg, false);
      break;
    default:
      break;
    }
    break;

  default:
    return false;
  }

  return true;
}

/**
   ExcelCursorProc()
  
   Purpose:
  
        When a modal dialog box is displayed over Microsoft Excel's window, the
        cursor is a busy cursor over Microsoft Excel's window. This WndProc traps
        WM_SETCURSORs and changes the cursor back to a normal arrow.
  
   Parameters:
  
        HWND hWndDlg        Contains the HWND Window
        UINT message        The message to respond to
        WPARAM wParam       Arguments passed by Windows
        LPARAM lParam
  
   Returns: 
  
        LRESULT             0 if message handled, otherwise the result of the
                            default WndProc
  
   Comments:
  
   History:  Date       Author        Reason
*/

// Create a place to store Microsoft Excel's WndProc address //
static WNDPROC g_lpfnExcelWndProc = null;

extern(Windows) LRESULT /*CALLBACK*/ ExcelCursorProc(HWND hwnd, 
                                 UINT wMsg, 
                                 WPARAM wParam, 
                                 LPARAM lParam)
{
  //
  // This block checks to see if the message that was passed in is a
  // WM_SETCURSOR message. If so, the cursor is set to an arrow; if not,
  // the default WndProc is called.
  //

  if (wMsg == WM_SETCURSOR)
  {
    SetCursor(LoadCursorW(null, cast(wchar*)IDC_ARROW));
    return 0L;
  }
  else
  {
    return CallWindowProc(g_lpfnExcelWndProc, hwnd, wMsg, wParam, lParam);
  }
}

/**
   HookExcelWindow()
  
   Purpose:
  
       This is the function that installs ExcelCursorProc so that it is
       called before Microsoft Excel's main WndProc.
  
   Parameters:
  
        HANDLE hWndExcel    This is a handle to Microsoft Excel's hWnd
  
   Returns: 
  
   Comments:
  
   History:  Date       Author        Reason
*/

extern(Windows) void /*FAR PASCAL*/ HookExcelWindow(HANDLE hWndExcel)
{
  /**
     This block obtains the address of Microsoft Excel's WndProc through the
     use of GetWindowLongPtr(). It stores this value in a global that can be
     used to call the default WndProc and also to restore it. Finally, it
     replaces this address with the address of ExcelCursorProc using
     SetWindowLongPtr().
  */

  g_lpfnExcelWndProc = cast(WNDPROC) GetWindowLongPtr(hWndExcel, GWLP_WNDPROC);
  SetWindowLongPtr(hWndExcel, GWLP_WNDPROC, cast(LONG_PTR)/*(FARPROC)*/ &ExcelCursorProc);
}

/**
   UnhookExcelWindow()
  
   Purpose:
  
        This is the function that removes the ExcelCursorProc that was
        called before Microsoft Excel's main WndProc.
  
   Parameters:
  
        HANDLE hWndExcel    This is a handle to Microsoft Excel's hWnd
  
   Returns: 
  
   Comments:
  
   History:  Date       Author        Reason
*/

extern(Windows) void /*FAR PASCAL*/ UnhookExcelWindow(HANDLE hWndExcel)
{
  /**
     This function restores Microsoft Excel's default WndProc using
     SetWindowLongPtr to restore the address that was saved into
     g_lpfnExcelWndProc by HookExcelWindow(). It then sets g_lpfnExcelWndProc
     to null.
  */

  SetWindowLongPtr(hWndExcel, GWLP_WNDPROC, cast(LONG_PTR) g_lpfnExcelWndProc);
  g_lpfnExcelWndProc = null;
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
