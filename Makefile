CONFIGURATION = Debug
MANAGED_LIB = libsoundio-sharp/bin/$(CONFIGURATION)/libsoundio-sharp.dll
SHARED_LIB = external/libsoundio/libsoundio.dll

ifeq ($(shell uname), Linux)
SHARED_LIB = external/libsoundio/libsoundio.so
else
ifeq ($(shell uname), Darwin)
SHARED_LIB = external/libsoundio/libsoundio.dylib
endif
endif

all: $(MANAGED_LIB)

$(MANAGED_LIB): $(SHARED_LIB)
	dotnet restore libsoundio-sharp/libsoundio-sharp.csproj
	dotnet build libsoundio-sharp/libsoundio-sharp.csproj -c $(CONFIGURATION)

$(SHARED_LIB):
	cd external/libsoundio && cmake . && make
	cp $(SHARED_LIB) libsoundio-sharp/libs/

clean:
	dotnet clean libsoundio-sharp/libsoundio-sharp.csproj
	cd external/libsoundio && make clean
