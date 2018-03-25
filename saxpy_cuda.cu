__global__
void saxpy_kernel(int n, float a, float *x, float *y)
{
  int i = blockDim.x * blockIdx.x + threadIdx.x;

  if ( i < n )
    y[i] += a * x[i];
}
extern "C" void saxpy(int n ,float a, float *x, float *y)
{
  dim3 griddim, blockdim;

  blockdim = dim3(128,1,1);
  griddim = dim3(n/blockdim.x,1,1);

  saxpy_kernel<<<griddim,blockdim>>>(n,a,x,y);
}
