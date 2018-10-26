export PATH=/usr/local/cuda-9.0/bin${PATH:+:${PATH}}
export CUPIT_LIB_PATH=/usr/local/cuda-9.0/extras/CUPTI/lib64
export LD_LIBRARY_PATH=/usr/local/cuda-9.0/lib64:${CUPIT_LIB_PATH}:${LD_LIBRARY_PATH:+:${LD_LIBRARY_PATH}}
