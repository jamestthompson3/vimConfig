; extends

; High priority: Block comments (/* */)
; Priority 105 ensures these override the default @comment captures (which are usually 100)
((comment) @comment.block
  (#match? @comment.block "^/\\*")
  (#set! "priority" 110))

; High priority: Line comments (//)
((comment) @comment.line
  (#match? @comment.line "^//")
  (#set! "priority" 110))

; Override default comment highlighting with lower priority fallback
; This ensures any comment that doesn't match above still gets highlighted
((comment) @comment
  (#set! "priority" 90))
