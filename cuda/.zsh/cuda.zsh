
CUDA_VERSION=11.4
export PATH=/usr/local/cuda-${CUDA_VERSION}/bin${PATH:+:${PATH}}
export CUPIT_LIB_PATH=/usr/local/cuda-${CUDA_VERSION}/extras/CUPTI/lib64
export LD_LIBRARY_PATH=/usr/local/cuda-${CUDA_VERSION}/lib64:${CUPIT_LIB_PATH}:${LD_LIBRARY_PATH:+:${LD_LIBRARY_PATH}}
