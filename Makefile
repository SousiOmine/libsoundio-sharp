CONFIGURATION = Debug
GEN_SOURCES = libsoundio-sharp/libsoundio-interop.cs
MANAGED_LIB = libsoundio-sharp/bin/$(CONFIGURATION)/libsoundio-sharp.dll
SHARED_LIB = external/libsoundio/libsoundio.dll
PINVOKEGEN = external/nclang/samples/PInvokeGenerator/bin/$(CONFIGURATION)/net462/PInvokeGenerator.exe
C_HEADERS = external/libsoundio/soundio/soundio.h

ifeq ($(shell uname), Linux)
SHARED_LIB = external/libsoundio/libsoundio.so
else
ifeq ($(shell uname), Darwin)
SHARED_LIB = external/libsoundio/libsoundio.dylib
endif
endif

all: $(MANAGED_LIB)

$(MANAGED_LIB): $(GEN_SOURCES) $(SHARED_LIB)
	dotnet restore libsoundio-sharp/libsoundio-sharp.csproj
	dotnet build libsoundio-sharp/libsoundio-sharp.csproj -c $(CONFIGURATION)

$(GEN_SOURCES): $(PINVOKEGEN) $(C_HEADERS)
	dotnet $(PINVOKEGEN) --lib:soundio --ns:SoundIOSharp $(C_HEADERS) > $(GEN_SOURCES) || rm $(GEN_SOURCES)

$(PINVOKEGEN):
	cd external/nclang && dotnet build -c $(CONFIGURATION)

$(SHARED_LIB):
	cd external/libsoundio && cmake . && make
	cp $(SHARED_LIB) libsoundio-sharp/libs/

clean:
	dotnet clean libsoundio-sharp/libsoundio-sharp.csproj
	cd external/nclang && dotnet clean
	cd external/libsoundio && make clean
