" halide.vim - Syntax highlighting for Halide Stmt files

if exists("b:current_syntax")
  finish
endif

" '$' is part of identifiers (e.g. eX$2), so digits after it are no word start
syn iskeyword @,48-57,_,192-255,$

" Define Halide Stmt keywords
syn keyword halideKeyword let if else break continue return reinterpret allocate free in struct custom_new
syn keyword halideLoop for while
syn keyword halideParallelLoop parallel
syn keyword halideGpuLoop gpu_block gpu_thread
syn match halideGpuApi "\<gpu_\(block\|thread\)<\zs\w\+\ze>"
syn match halideBarrier "\<gpu_thread_barrier\ze("
syn keyword halideSpecialKeyword produce consume

" Define Halide Stmt types
syn keyword halideType void float32 float64 uint1 int8 uint8 int16 uint16 int32 uint32 int64 uint64
syn match halideVectorizedType "\<\(int8\|int16\|int32\|int64\|uint1\|uint8\|uint16\|uint32\|uint64\|float16\|float32\|float64\|bool\)x\=[0-9]\+\>"
syn match halideBroadcast "\.\@<!\<x\=[0-9]\+\>\ze("

" Define Halide Stmt functions
syn keyword halideFunction select clamp cast assert alloca offset_pointer
syn keyword halideExpensiveMathFunc sqrt_f32 sqrt_f64 cos_f32 cos_f64 sin_f32 sin_f64 tan_f32 tan_f64 acos_f32 acos_f64 asin_f32 asin_f64 atan_f32 atan_f64 atan2_f32 atan2_f64 exp_f32 exp_f64 log_f32 log_f64
syn keyword halideStrictFunc strict_add strict_sub strict_mul strict_div strict_fma
syn match halideMathFunc "\<\(min\|max\)\ze("

syn keyword halideAnnotation ramp aligned module external internal external_plus_metadata func
syn keyword halideRuntimeFunc load_typed_struct_member
syn match halideRuntimeFunc "_\?halide_\(error\|profiler\|buffer\|do\)_[a-z_]\+\>"

" Define Halide Stmt constants
syn keyword halideConstant true false

" Define comments
syn region halideComment start="/\*" end="\*/" contains=halideTodo
syn match halideComment "//.*" contains=halideTodo

" Define numbers
" Numbers are never preceded by '.' (e.g. input.extent.0)
syn match halideNumber "\.\@<!\<[0-9]\+\>"
syn match halideTypedNumber "\.\@<!\<[0-9]\+_[ui]\(8\|16\|32\|64\)\>" contains=halideNumberSuffix
syn match halideNumberSuffix "_[ui][0-9]\+\>" contained
syn match halideFloat "\.\@<!\<[0-9]*\.[0-9]\+f\?\>"

" Define strings
syn region halideString start=+"+ skip=+\\\\\|\\\"+ end=+"+

" Define operators
syn match halideOperator "[-+*/%<>=!&|^~]"

" Define punctuation
syn match halidePunctuation "[{}()\[\],.;]"

" GPU thread ids (after punctuation so the leading '.' is included)
syn match halideThreadIdX "\.thread_id_x\>"
syn match halideThreadIdY "\.thread_id_y\>"
syn match halideThreadIdZ "\.thread_id_z\>"

" Link the syntax elements to highlight groups
hi def link halideKeyword Keyword
hi def link halideAnnotation Keyword
hi def link halideLoop Repeat
" halideGpuLoop, halideParallelLoop and halideThreadId{X,Y,Z} get explicit
" colors in ftplugin/halide.lua.
hi def link halideGpuApi Type
hi def link halideBarrier Exception
hi def link halideSpecialKeyword Type
hi def link halideType Type
hi def link halideBroadcast Type
hi def link halideVectorizedType Type
hi def link halideFunction Function
hi def link halideExpensiveMathFunc Todo
hi def link halideMathFunc Function
hi def link halideStrictFunc Function
hi def link halideRuntimeFunc Function
hi def link halideConstant Constant
hi def link halideComment Comment
hi def link halideNumber Number
hi def link halideTypedNumber Number
hi def link halideNumberSuffix Type
hi def link halideFloat Float
hi def link halideString String
hi def link halideOperator Operator
hi def link halidePunctuation Delimiter

" Set the file type to halide
let b:current_syntax = "halide"

