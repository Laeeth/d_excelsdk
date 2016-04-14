rm generic64.xll
dmd -c -gc -m64 -map -ofgeneric64.obj generic.d  memorymanager.d memorypool.d xlcall.d xlcallcpp.d framework.d wrap.d
dmd -m64 -g -L/OUT:generic64d.xll  -L/NOLOGO -L generic64.obj generic64.def xlcall64d.lib
