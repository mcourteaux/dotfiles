" halide.vim - Syntax highlighting for Halide Stmt files

if exists("b:current_syntax")
  finish
endif

" Define Halide Stmt keywords
syn keyword halideKeyword let if else break continue return reinterpret allocate free in struct
syn keyword halideLoop for while parallel
syn keyword halideSpecialKeyword produce consume

" Define Halide Stmt types
syn keyword halideType void float32 float64 uint1 int8 uint8 int16 uint16 int32 uint32 int64 uint64
syn match halideVectorizedType "\<\(int8\|int16\|int32\|int64\|uint1\|uint8\|uint16\|uint32\|uint64\|float16\|float32\|float64\|bool\)x\=[0-9]\+\>"
syn match halideBroadcast "\<x\=[0-9]\+\>\ze("

" Define Halide Stmt functions
syn keyword halideFunction select clamp cast assert alloca
syn keyword halideExpensiveMathFunc sqrt_f32 sqrt_f64 cos_f32 cos_f64 sin_f32 sin_f64 tan_f32 tan_f64 acos_f32 acos_f64 asin_f32 asin_f64 atan_f32 atan_f64 atan2_f32 atan2_f64 exp_f32 exp_f64 log_f32 log_f64
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
syn match halideNumber "\<[0-9]\+\>"
syn match halideFloat "\<[0-9]*\.[0-9]\+f\?\>"

" Define strings
syn region halideString start=+"+ skip=+\\\\\|\\\"+ end=+"+

" Define operators
syn match halideOperator "[-+*/%<>=!&|^~]"

" Define punctuation
syn match halidePunctuation "[{}()\[\],.;]"

" Link the syntax elements to highlight groups
hi def link halideKeyword Keyword
hi def link halideAnnotation Keyword
hi def link halideLoop Repeat
hi def link halideSpecialKeyword Type
hi def link halideType Type
hi def link halideBroadcast Type
hi def link halideVectorizedType Type
hi def link halideFunction Function
hi def link halideExpensiveMathFunc Todo
hi def link halideMathFunc Function
hi def link halideRuntimeFunc Function
hi def link halideConstant Constant
hi def link halideComment Comment
hi def link halideNumber Number
hi def link halideFloat Float
hi def link halideString String
hi def link halideOperator Operator
hi def link halidePunctuation Delimiter

" Set the file type to halide
let b:current_syntax = "halide"

