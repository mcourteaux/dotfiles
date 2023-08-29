

#CUDA_VERSION=11.4
#export PATH=/usr/local/cuda-${CUDA_VERSION}/bin${PATH:+:${PATH}}
#export CUPIT_LIB_PATH=/usr/local/cuda-${CUDA_VERSION}/extras/CUPTI/lib64
#export LD_LIBRARY_PATH=/usr/local/cuda-${CUDA_VERSION}/lib64:${CUPIT_LIB_PATH}:${LD_LIBRARY_PATH:+:${LD_LIBRARY_PATH}}


#export PATH=/usr/local/cuda/bin${PATH:+:${PATH}}
#export CUPIT_LIB_PATH=/usr/local/cuda/extras/CUPTI/lib64
#export LD_LIBRARY_PATH=/usr/local/cuda/lib64:${CUPIT_LIB_PATH}:${LD_LIBRARY_PATH:+:${LD_LIBRARY_PATH}}

# It seems that extras/CUPTI/lib64 is gone. I'm assuming it's merged with the main lib64 folder.
export PATH=/usr/local/cuda/bin${PATH:+:${PATH}}
export CUPTI_LIB_PATH=/usr/local/cuda/lib64
export LD_LIBRARY_PATH=/usr/local/cuda/lib64:${LD_LIBRARY_PATH:+:${LD_LIBRARY_PATH}}
