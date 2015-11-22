dmd -c -m32 -ofkpropdll.obj kpropdll.d dllmain.d
dmd -m32 -ofkpropdll32.dll kpropdll.obj kpropdll32.def -g -map