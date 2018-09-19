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
nmap S :%s//g<LEFT><LEFT>
vmap S :s//g<LEFT><LEFT>
nnoremap <silent> <Esc> :noh<CR><Esc>
nnoremap <silent> <Leader>sp :Grepper<CR>
nnoremap <silent> <Leader>fr :Far<CR>
nnoremap <leader>* :Grepper -tool rg -cword -noprompt<cr>

map <silent><Leader><Leader> :DeniteProjectDir -buffer-name=git -direction=dynamicbottom file_rec/git<CR>

nnoremap <silent><Leader>g :Denite gitbranch<CR>
nnoremap <silent><Leader>gl :Denite gitlog<CR>
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
function! GetOpts() abort
  let l:opts = ['ignore flow-typed']
  if getcwd() =~ 'kamu-front'
    call extend(l:opts, ['ignore viiksetjs', 'ignore front/flow-typed'])
  endif
  return l:opts
endfunction

call denite#custom#var('grep', 'command', ['ag'])
call denite#custom#var('grep', 'default_opts',
    \ ['-i', '--vimgrep'])
call denite#custom#var('grep', 'recursive_opts', [])
call denite#custom#var('grep', 'pattern_opt', [])
call denite#custom#var('grep', 'separator', ['--'])
call denite#custom#var('grep', 'final_opts', GetOpts())
call denite#custom#map('insert', '<C-j>', '<denite:move_to_next_line>', 'noremap')
call denite#custom#map('insert', '<Down>', '<denite:move_to_next_line>', 'noremap')
call denite#custom#map('insert', '<C-k>', '<denite:move_to_previous_line>', 'noremap')
call denite#custom#map('insert', '<Up>', '<denite:move_to_previous_line>', 'noremap')
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
call denite#custom#var('file_rec', 'command',
      \ ['rg', '-L', '-i', '--no-ignore', '--files'])
""'-u', '-g', ''

call denite#custom#alias('source', 'file_rec/git', 'file_rec')

call denite#custom#var('file_rec/git', 'command',
\ ['git', 'ls-files', '|', 'fzf'])

"                ╔══════════════════════════════════════════╗
"                ║           » ALE JUMP TO ERRORS «         ║
"                ╚══════════════════════════════════════════╝
nnoremap <silent> <Leader>jj :ALENext<CR>
nnoremap <silent> <Leader>kk :ALEPrevious<CR>
"                ╔══════════════════════════════════════════╗
"                ║          » BLOCK MANIPULATION «          ║
"                ╚══════════════════════════════════════════╝
vmap <up>    <Plug>SchleppUp
vmap <down>  <Plug>SchleppDown
vmap <left>  <Plug>SchleppLeft
vmap <right> <Plug>SchleppRight

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
nnoremap ; :
set wildchar=<Tab>
function! OpenTerminalDrawer() abort
  execute ':copen'
  execute ':term'
endfunction
nnoremap <silent><Leader>d :call OpenTerminalDrawer()<CR>
