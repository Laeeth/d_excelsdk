BUILD=DEBUG
PLATFORM=WIN32

all: autogenerated
	$(MAKE) -f ./XLL.mak BUILD=$(BUILD) PLATFORM=$(PLATFORM)
	
clean:
	$(MAKE) -f ./XLL.mak BUILD=$(BUILD) PLATFORM=$(PLATFORM) clean
	@echo Removing ../common_source/xlwTest.cpp
	@$(RM) ../common_source/xlwTest.cpp
	
	
autogenerated :../common_source/xlwTest.cpp

../common_source/xlwTest.cpp:  ../common_source/Test.h
		"$(subst $(strip \),/,$(XLW))/xlw/build/gcc-make/$(BUILD)/BIN/InterfaceGenerator"  ../common_source/Test.h ../common_source/xlwTest.cpp
	
rebuild: clean all