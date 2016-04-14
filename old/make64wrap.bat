rm generic64e.xll
dmd -c -gc -m64 -map -ofgeneric64.obj genericwithwrap.d  memorymanager.d memorypool.d xlcall.d xlcallcpp.d framework.d  wrap.d
dmd -m64 -g -L/OUT:generic64e.xll  -L/NOLOGO -L generic64.obj generic64.def xlcall64d.lib
