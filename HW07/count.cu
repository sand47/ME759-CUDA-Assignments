#include <iostream>

// Thrust headers
#include <thrust/host_vector.h>
#include <thrust/device_vector.h>
#include <thrust/sort.h>
#include <thrust/find.h>

#include "count.cuh"
#include <stdio.h>

using std::cout;
using std::endl;

void count(const thrust::device_vector<int> &d_in,
           thrust::device_vector<int> &values,
           thrust::device_vector<int> &counts) {

  // Copy the input array to be able to sort it
  thrust::device_vector<int> d_in_cpy = d_in;

  // Sort the input array
  thrust::sort(thrust::device, d_in_cpy.begin(), d_in_cpy.end());

  // Create the histogram
  thrust::reduce_by_key(thrust::device, d_in_cpy.begin(), d_in_cpy.end(),
                        thrust::constant_iterator<int>(1), values.begin(),
                        counts.begin());

  // Resize the values and counts array
  // First find the index of the first occurence of 0 count
  thrust::device_vector<int>::iterator first_zero;
  first_zero = thrust::find(thrust::device, counts.begin(), counts.end(), 0);
  values.resize(first_zero - counts.begin());
  counts.resize(first_zero - counts.begin());
}
