EXES=cuda_main openmp_c_main openmp_c_cublas

CUDAC=nvcc
ifeq "$(CC)" "xlc"
# XL Compiler
#EXES+=cuf_main 
CXXFLAGS=-O3 -qsmp -qoffload
CFLAGS=$(CXXFLAGS)
CUDAFLAGS=
FFLAGS=$(CXXFLAGS)
LDFLAGS=
else
# CLANG Compiler
CXXFLAGS=-O2 -fopenmp -fopenmp-targets=nvptx64-nvidia-cuda --cuda-path=$(OLCF_CUDA_ROOT)
CFLAGS=$(CXXFLAGS)
CUDAFLAGS=
LDFLAGS=
endif

all: $(EXES)

openmp_cublas: openmp_cublas.o
	$(FC) -o $@ $(CFLAGS) $^ $(LDFLAGS) -lcublas

openmp_c_cublas: openmp_c_cublas.o
	$(CC) -o $@ $(CFLAGS) $^ $(LDFLAGS) -lcublas

openmp_c_main: saxpy_cuda.o openmp_c_main.o
	$(CC) -o $@ $(CFLAGS) $^ $(LDFLAGS)

cuda_main: saxpy_openmp_c.o cuda_main.o
	$(CXX) -o $@ $(CFLAGS) $^ $(LDFLAGS)


.SUFFIXES:
.SUFFIXES: .c .o .f90 .cu .cpp .cuf
.c.o:
	$(CC) $(CFLAGS) -c $<
.cpp.o:
	$(CXX) $(CXXFLAGS) -c $<
.f90.o:
	$(FC) $(FFLAGS) -c $<
.cuf.o:
	$(FC) $(FFLAGS) -c $<
.cu.o:
	$(CUDAC) $(CUDAFLAGS) -c $<
.PHONY: clean
clean:
	rm -rf *.o *.ptx *.cub *.lst *.mod $(EXES)
