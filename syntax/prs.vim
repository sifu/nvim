if exists("b:current_syntax") | finish | endif

syn match prsHeader      /^\S.*$/
syn match prsNothing     /^\s\+Nothing\s*$/
syn match prsPrNum       /#\d\+/                       contained
syn match prsAuthor      /\v\(by [^)]+\)/              contained
syn match prsApproved    /✓approved/                   contained
syn match prsRejected    /✗changes requested/          contained
syn match prsPrLine      /^\s\+#\d\+\s.*$/             contains=prsPrNum,prsAuthor,prsApproved,prsRejected
syn match prsUrlLine     /\v^\s+https?:\/\/\S+\s*$/
syn match prsBranchLine  /\v^\s+⎇\s+\S+.*$/
syn match prsCommentLine /\v^  \S+:\s.*$/

hi default link prsHeader      Title
hi default link prsNothing     Comment
hi default link prsPrNum       Identifier
hi default link prsAuthor      Comment
hi default link prsApproved    DiagnosticOk
hi default link prsRejected    DiagnosticError
hi default link prsUrlLine     Comment
hi default link prsBranchLine  String
hi default link prsCommentLine Comment
hi default prsPrLine gui=bold cterm=bold

let b:current_syntax = "prs"
