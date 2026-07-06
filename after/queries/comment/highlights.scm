; extends

; nvim-treesitter ships the base comment/highlights.scm, which assigns these
; keyword captures (@comment.todo/note/warning/error) at the default treesitter
; priority (100). Once the LSP attaches, its semantic token for the whole comment
; lands at priority 125 and overrides them -- so the keyword colors show for a
; moment and then revert as the LSP finishes initializing (only TODO survived,
; because Todo's reverse/bold fall through where the semantic token sets none).
;
; This file `; extends` that base and simply re-asserts the same keyword captures
; at priority 200 (the `user` tier), which beats both treesitter (100) and
; semantic tokens (125), so keyword highlighting always wins on the keyword span.
; The base still supplies the actual colors and the uri/number captures.

((tag (name) @comment.todo)
  (#any-of? @comment.todo "TODO" "WIP")
  (#set! "priority" 200))
("text" @comment.todo
  (#any-of? @comment.todo "TODO" "WIP")
  (#set! "priority" 200))

((tag (name) @comment.note)
  (#any-of? @comment.note "NOTE" "XXX" "INFO" "DOCS" "PERF" "TEST")
  (#set! "priority" 200))
("text" @comment.note
  (#any-of? @comment.note "NOTE" "XXX" "INFO" "DOCS" "PERF" "TEST")
  (#set! "priority" 200))

((tag (name) @comment.warning)
  (#any-of? @comment.warning "HACK" "WARNING" "WARN" "FIX")
  (#set! "priority" 200))
("text" @comment.warning
  (#any-of? @comment.warning "HACK" "WARNING" "WARN" "FIX")
  (#set! "priority" 200))

((tag (name) @comment.error)
  (#any-of? @comment.error "FIXME" "BUG" "ERROR")
  (#set! "priority" 200))
("text" @comment.error
  (#any-of? @comment.error "FIXME" "BUG" "ERROR")
  (#set! "priority" 200))
