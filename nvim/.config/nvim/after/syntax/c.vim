
syn keyword	cCommentNocheckin   contained nocheckin no-checkin no-commit nocommit do-not-commit
syn match	cCommentTags          /@\(Robustness\|Performance\|Speed\|Correctness\)/ contained
syn cluster	cCommentGroup       contains=cTodo,cBadContinuation,cCommentNocheckin,cCommentTags

highlight def link cCommentTags      cTodo
highlight cCommentNocheckin cterm=italic gui=italic guibg=#ff0000
