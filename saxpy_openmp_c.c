void saxpy(int n, float a, float * restrict x, float * restrict y)
{
  #pragma omp target teams distribute parallel for is_device_ptr(x,y)
  {
    for(int i=0; i<n; i++)
    {
      y[i] += a*x[i];
    }
  }
}
void set(int n, float val, float * restrict arr)
{
#pragma omp target teams distribute parallel for is_device_ptr(arr)
  {
    for(int i=0; i<n; i++)
    {
      arr[i] = val;
    }
  }
}
