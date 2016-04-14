dmd -c -g -m32 -ofgeneric32.obj generic.d  memorymanager.d memorypool.d xlcall.d xlcallcpp.d framework.d wrap.d
dmd -m32 -ofgeneric32.xll -L/IMPLIB generic32.obj generic32.def xlcall32d.lib -g -map 
