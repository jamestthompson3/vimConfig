scriptencoding = utf-8
"                ╔══════════════════════════════════════════╗
"                ║         » LEADER AND QUICK ESCAPE «      ║
"                ╚══════════════════════════════════════════╝
let g:mapleader = "\<Space>"
ve left window
ve left window
ve left window
ve left window
ve left window
inoremap jj <Esc>
"                ╔══════════════════════════════════════════╗
"                ║             » SYSTEM CLIPBOARD «         ║
"                ╚══════════════════════════════════════════╝
xnoremap <Leader>y "+y
xnoremap <Leader>d "+d
nnoremap <Leader>p "+p
nnoremap <Leader>P "+P
"                ╔══════════════════════════════════════════╗
"                ║             » WINDOW MOTIONS «           ║
"                ╚══════════════════════════════════════════╝
nnoremap <C-J> <C-W><C-J>
nnoremap <C-K> <C-W><C-K>
nnoremap <C-L> <C-W><C-L>
nnoremap <C-H> <C-W><C-H>

nnoremap <silent> wq ZZ
nnoremap <silent> q :bp\|bd #<CR>
nnoremap <silent> sq :only<CR>
nnoremap <silent> gl :pc<CR>
"                ╔══════════════════════════════════════════╗
"                ║             » BUFFER SWITCHING «         ║
"                ╚══════════════════════════════════════════╝

nnoremap <silent> <Tab> :bnext<CR>
nnoremap <silent> <S-Tab> :bprevious<CR>
"                ╔══════════════════════════════════════════╗
"                ║                 » MACROS «               ║
"                ╚══════════════════════════════════════════╝
nnoremap mm q
"                ╔══════════════════════════════════════════╗
"                ║               » EASY SPLITS «            ║
"                ╚══════════════════════════════════════════╝
nnoremap <silent> sp :vsplit<CR>
nnoremap <silent> sv :split<CR>
nnoremap <silent> tt :tab split<CR>
"                ╔══════════════════════════════════════════╗
"                ║                » NERDTREE «              ║
"                ╚══════════════════════════════════════════╝
nnoremap <silent><F3> :NERDTreeToggle<CR>
nnoremap <silent><Leader>t :NERDTreeFind<CR>
"                ╔══════════════════════════════════════════╗
"                ║              » SEARCHING «               ║
"                ╚══════════════════════════════════════════╝
nnoremap <silent> <Esc> :noh<CR><Esc>
nnoremap <silent> <Leader>sp :Grepper<CR>
nnoremap <silent> <Leader>fr :Far<CR>
nnoremap <leader>* :Grepper -tool rg -cword -noprompt<cr>

map <silent><C-P> :DeniteProjectDir -buffer-name=git -direction=dynamicbottom file_rec/git<CR>
if exists('g:oni_gui')
map <silent><Leader><Leader> :DeniteProjectDir -buffer-name=git -direction=dynamicbottom file_rec/git<CR>
endif

nnoremap <silent><Leader>g :Denite gitbranch<CR>
nnoremap <silent><C-O> :DeniteProjectDir -buffer-name=files -direction=dynamicbottom file_rec<CR>
nnoremap <silent><Leader>. :Denite buffer  -direction=dynamicbottom<CR>
nnoremap <silent><Leader>, :Denite file_mru  -direction=dynamicbottom<CR>
nnoremap <silent><Leader>F :Denite outline  -direction=dynamicbottom<CR>
nnoremap <silent><Leader>m :Denite mark  -direction=dynamicbottom<CR>
xnoremap <silent><Leader>v :<C-u>Denite register -buffer-name=register -default-action=replace<CR>
map <leader>a :DeniteProjectDir -buffer-name=grep -default-action=quickfix grep:::!<CR>

call denite#custom#source(
\ 'grep', 'matchers', ['matcher_regexp'])

" use ag for content search
call denite#custom#var('grep', 'command', ['ag'])
call denite#custom#var('grep', 'default_opts',
    \ ['-i', '--vimgrep'])
call denite#custom#var('grep', 'recursive_opts', [])
call denite#custom#var('grep', 'pattern_opt', [])
call denite#custom#var('grep', 'separator', ['--'])
call denite#custom#var('grep', 'final_opts', ['ignore node_modules','ignore lib', 'ignore dist'])
call denite#custom#map('insert', '<C-j>', '<denite:move_to_next_line>', 'noremap')
call denite#custom#map('insert', '<C-k>', '<denite:move_to_previous_line>', 'noremap')
call denite#custom#map(
      \ 'normal',
      \ 'a',
      \ '<denite:do_action:add>',
      \ 'noremap'
      \)

call denite#custom#map(
      \ 'normal',
      \ 'd',
      \ '<denite:do_action:delete>',
      \ 'noremap'
      \)

call denite#custom#map(
      \ 'normal',
      \ 'r',
      \ '<denite:do_action:reset>',
      \ 'noremap'
      \)
call denite#custom#map(
      \ 'normal',
      \ 'c',
      \ '<denite:do_action:checkout>',
      \ 'noremap'
      \)
call denite#custom#option('default', 'prompt', '>')
" -u flag to unrestrict (see ag docs)
" call denite#custom#var('branches', 'command', ['git', 'branch'])
" call denite#custom#alias('source', 'branches', 'branches')
call denite#custom#var('file_rec', 'command',
      \ ['ag', '--follow', '--nocolor', '--nogroup','--ignore-case', '-u', '-g', ''])
"      \ ['fd', '--type', 'f', '--hidden',  '--exclude' , '".git"', '|', 'fzf'])
"\ ['fzf'])

call denite#custom#alias('source', 'file_rec/git', 'file_rec')

call denite#custom#var('file_rec/git', 'command',
\ ['git', 'ls-files', '|', 'fzf'])

"                ╔══════════════════════════════════════════╗
"                ║           » ALE JUMP TO ERRORS «         ║
"                ╚══════════════════════════════════════════╝
nnoremap <silent> <Leader>jj :ALENext<CR>
nnoremap <silent> <Leader>kk :ALEPrevious<CR>
"                ╔══════════════════════════════════════════╗
"                ║               » COMPLETION «             ║
"                ╚══════════════════════════════════════════╝
inoremap <expr> <Tab> pumvisible() ? "\<C-n>" : "\<Tab>"
inoremap <expr> <S-Tab> pumvisible() ? "\<C-p>" : "\<S-Tab>"
inoremap <expr> <cr> pumvisible() ? "\<C-y>" : "\<cr>"
"                ╔══════════════════════════════════════════╗
"                ║             » SPELL CHECK «              ║
"                ╚══════════════════════════════════════════╝
nnoremap <silent><F7> :setlocal spell! spell?<CR>
"                ╔══════════════════════════════════════════╗
"                ║                 » MISC «                 ║
"                ╚══════════════════════════════════════════╝
set wildchar=<Tab>
function! OpenTerminalDrawer() abort
  execute ':copen'
  execute ':term'
endfunction
nnoremap <silent><Leader>d :call OpenTerminalDrawer()<CR>
