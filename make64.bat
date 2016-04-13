C:\D\dmd2\windows\bin\dmd -c -g -m64 -ofgeneric.obj generic.d  memorymanager.d memorypool.d xlcall.d xlcallcpp.d framework.d
C:\d\dmd2\windows\bin\dmd -m64 -ofgeneric64.dll generic.obj generic64.def xlcall64d.lib -g -map 
