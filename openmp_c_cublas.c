#include <stdio.h>
#include <stdlib.h>
#include <unistd.h>

extern void cublasSaxpy(int,float,float*,int,float*,int);

int main(int argc, char **argv)
{
  float *x, *y, tmp;
  int n = 1<<20, i;

  x = (float*)malloc(n*sizeof(float));
  y = (float*)malloc(n*sizeof(float));

  #pragma omp target data map(alloc:x[0:n]) map(from:y[0:n])
  {
    #pragma omp target teams distribute parallel for
    {
      for( i = 0; i < n; i++)
      {
        x[i] = 1.0f;
        y[i] = 0.0f;
      }
    }
      
    #pragma omp target data use_device_ptr(x,y)
    {
      cublasSaxpy(n, 2.0, x, 1, y, 1);
    }
  }

  fprintf(stdout, "y[0] = %f\n",y[0]);
  return 0;
}
