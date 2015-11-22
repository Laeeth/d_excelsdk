#Describes the xll 
BUILD=DEBUG
LIBRARY = ExampleHandwritten
LIBTYPE=SHARE
LIBPREFIX=
EXT_SHARE=xll

#Describes the Linker details
ifeq ($(PLATFORM), x64)
LIBDIRS = ../../../lib/x64
else
LIBDIRS = ../../../lib
endif
ifeq ($(BUILD),DEBUG)
LIBS=xlw-gcc-s-gd-5_0_2f0
else
LIBS=xlw-gcc-s-5_0_2f0
endif 

#Describes the Compiler details
INCLUDE_DIR =../common_source  ../../../include
CXXFLAGS = 


#The source
SRC_DIR=../common_source
LIBSRC = xlwAsynchExample.cpp \
	xlwCommands.cpp \
	xlwExample.cpp \
	xlwMatrixTest.cpp \
	xlwXlmMacros.cpp
  
		
MAKEDIR = ../../../make
include $(MAKEDIR)/make.rules
include $(MAKEDIR)/make.targets