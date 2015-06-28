dmd -c -g -m32 -ofgeneric.obj generic.d  memorymanager.d memorypool.d xlcall.d xlcallcpp.d framework.d
dmd -m32 -ofgeneric32.dll -L/IMPLIB generic.obj generic32.def xlcall32d.lib -g -map 