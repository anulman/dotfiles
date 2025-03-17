set nocompatible              " be iMproved, required
filetype off                  " required

" Required before plugins are initialized/used
let g:ale_disable_lsp = 1

" Using `vim-plug`, see https://github.com/junegunn/vim-plug
call plug#begin()
so $HOME/.vimplugs " sources our neighbour file
call plug#end()

colorscheme smyck
filetype plugin indent on    " required
" To ignore plugin indent changes, instead use:
"filetype plugin on
"
" Brief help
" :PluginList       - lists configured plugins
" :PluginInstall    - installs plugins; append `!` to update or just :PluginUpdate
" :PluginSearch foo - searches for foo; append `!` to refresh local cache
" :PluginClean      - confirms removal of unused plugins; append `!` to auto-approve removal
"
" see :h vundle for more details or wiki for FAQ
" Put your non-Plugin stuff after this line

let mapleader = "\<Space>"

set expandtab
set modelines=0
set shiftwidth=2
set clipboard=unnamed
set synmaxcol=128
if !has('nvim')
  set ttyscroll=10
endif
set encoding=utf-8
set tabstop=2
set nowrap
set number
set expandtab
set nowritebackup
set noswapfile
set nobackup
set hlsearch
set ignorecase
set smartcase
set noautochdir
set showcmd

" <Space>o to open new file
nnoremap <Leader>o :FZF<CR>

" <Space>w to save
nnoremap <Leader>w :w<CR>

" <Space>q to quit
nnoremap <Leader>q :q<CR>

" <Space>Q to force-quit
nnoremap <Leader>Q :q!<CR>

" <Space><Space> for visual line mode
nmap <Leader><Leader> V

" w!! runs the 'i forgot sudo so using tee instead' trick
cmap w!! w !sudo tee > /dev/null %

" <Space>W to force-write
nnoremap <Leader>W w!!<CR>

" <Space>t to create tab
nnoremap <Leader>t :tabnew<CR>

" <Space>k or <Space><tab> to next-tab
nnoremap <Leader>k :tabn<CR>
nnoremap <Leader><tab> :tabn<CR>

" <Space>j or <Space><s-tab> to prev-tab
nnoremap <Leader>j :tabp<CR>
nnoremap <Leader><s-tab> :tabp<CR>

" <Space>x to close tab
nnoremap <Leader>x :tabclose<CR>

" <Space>X to close other tabs
nnoremap <Leader>X :tabonly<CR>

" <Space><CR> to esc
inoremap <Space><CR> <Esc>

" <Leader>gR to reset --hard HEAD
nnoremap <Leader>gR :Git reset --hard HEAD<CR>

" <Space>e & <Space>ec to emojify
nnoremap <Leader>e :%s/:\([^:]\+\):/\=emoji#for(submatch(1), submatch(0))/g<CR>
nnoremap <Leader>ec :%s/:\([^:]\+\):/\=emoji#for(submatch(1), submatch(0))/gc<CR>

" Better region expanding shortcuts (v for char, vv for word, vvv for para)
vmap v <Plug>(expand_region_expand)
vmap <C-v> <Plug>(expand_region_shrink)

" vp doesn't replace paste buffer
function! RestoreRegister()
  let @" = s:restore_reg
  return ''
endfunction
function! s:Repl()
  let s:restore_reg = @"
  return "p@=RestoreRegister()\<cr>"
endfunction
vmap <silent> <expr> p <sid>Repl()

" Highlight col80
set colorcolumn=80

" Quicker window movement
nnoremap <C-j> <C-w>j
nnoremap <C-k> <C-w>k
nnoremap <C-h> <C-w>h
nnoremap <C-l> <C-w>l

" Automatic formatting
autocmd BufEnter *.{js,jsx,ts,tsx} :syntax sync fromstart
autocmd BufLeave *.{js,jsx,ts,tsx} :syntax sync clear
autocmd BufWritePre *.rb :%s/\s\+$//e
autocmd BufWritePre *.go :%s/\s\+$//e
autocmd BufWritePre *.haml :%s/\s\+$//e
autocmd BufWritePre *.html :%s/\s\+$//e
autocmd BufWritePre *.scss :%s/\s\+$//e
autocmd BufWritePre *.slim :%s/\s\+$//e

au BufNewFile * set noeol
au BufRead,BufNewFile *.go set filetype=go

" Open new buffers
nmap <leader>sh  :leftabove  vnew<cr>
nmap <leader>sl  :rightbelow vnew<cr>
nmap <leader>sk  :leftabove  new<cr>
nmap <leader>sj  :rightbelow new<cr>

" Tab between buffers
noremap <tab> <c-w><c-w>
noremap <s-tab> <c-w><s-w>

" Ack
let g:ackprg = 'ag --nogroup --nocolor --column'
map <leader>/ :Ack 

" NERDTree
let NERDTreeHijackNetrw = 0
map <leader>n :NERDTreeToggle<CR>
let NERDTreeHighlightCursorline=1
let NERDTreeIgnore = ['node_modules', 'tmp', '.yardoc', 'pkg']

augroup AuNERDTreeCmd
" autocmd AuNERDTreeCmd VimEnter * call s:CdIfDirectory(expand("<amatch>"))
autocmd AuNERDTreeCmd FocusGained * call s:UpdateNERDTree()

" If the parameter is a directory, cd into it
function s:CdIfDirectory(directory)
  let explicitDirectory = isdirectory(a:directory)
  let directory = explicitDirectory || empty(a:directory)

  if explicitDirectory
    exe "cd " . fnameescape(a:directory)
  endif

  " Allows reading from stdin
  " ex: git diff | mvim -R -
  if strlen(a:directory) == 0
    return
  endif

  if directory
    NERDTree
    wincmd p
    bd
  endif

  if explicitDirectory
    wincmd p
  endif
endfunction

" NERDTree utility function
function s:UpdateNERDTree(...)
  let stay = 0

  if(exists("a:1"))
    let stay = a:1
  end

  if exists("t:NERDTreeBufName")
    let nr = bufwinnr(t:NERDTreeBufName)
    if nr != -1
      exe nr . "wincmd w"
      exe substitute(mapcheck("R"), "<CR>", "", "")
      if !stay
        wincmd p
      end
    endif
  endif
endfunction

" FZF
let $FZF_DEFAULT_COMMAND = 'rg --hidden --files -g "!.git"'
let g:fzf_layout = {'down': '~10'}

autocmd! FileType fzf
autocmd  FileType fzf set laststatus=0 noshowmode noruler
  \| autocmd BufLeave <buffer> set laststatus=2 showmode ruler

" Mappings

" Underline the current line with '=' or '-'
nmap <silent> <leader>= :t.<CR>Vr=k
nmap <silent> <leader>- :t.<CR>Vr-k

" Aboveline the current line with '=' or '-'
nmap <silent> <leader>== yyPVr=j
nmap <silent> <leader>-- yyPVr-j

" find merge conflict markers
nmap <silent> <leader>fc <ESC>/\v^[<=>]{7}( .*\|$)<CR>

" Toggle hlsearch with <leader>hs
nmap <leader>hs :set hlsearch! hlsearch?<CR>
nmap <leader>hl :nohl<CR>

" Coc
" - lots of this config based on
"   https://thoughtbot.com/blog/modern-typescript-and-react-development-in-vim
" ========
let g:coc_global_extensions = [
\ 'coc-tsserver'
\ ]

if !empty(glob('./.yarn/cache/prettier-*')) || !empty(glob('./node_modules/prettier'))
  let g:coc_global_extensions += ['coc-prettier']
endif

if !empty(glob('./.yarn/cache/eslint-*')) || !empty(glob('./node_modules/eslint'))
  let g:coc_global_extensions += ['coc-eslint']
endif

" display diagnostics in a tooltip
nnoremap <silent> K :call CocAction('doHover')<CR>
function! ShowDocIfNoDiagnostic(timer_id)
  if (coc#float#has_float() == 0 && CocHasProvider('hover') == 1)
    silent call CocActionAsync('doHover')
  endif
endfunction

function! s:show_hover_doc()
  call timer_start(500, 'ShowDocIfNoDiagnostic')
endfunction

autocmd CursorHoldI * :call <SID>show_hover_doc()
autocmd CursorHold * :call <SID>show_hover_doc()

nmap <silent> <Leader>gg <Plug>(coc-definition)
nmap <silent> <Leader>gy <Plug>(coc-type-definition)
nmap <silent> <Leader>gr <Plug>(coc-references)
nmap <leader>do <Plug>(coc-codeaction)

" Ale
" =========
let g:ale_completion_enabled = 0
let g:ale_completion_tsserver_autoimport = 0
let g:ale_linters_explicit = 1
let g:ale_fix_on_save = 0
let g:ale_fixers = ['eslint']
let g:ale_linters = {
\   'cpp': ['clangtidy', 'cppcheck'],
\   'javascript': ['eslint'],
\   'typescript': ['eslint'],
\   'yaml': ['eslint'],
\}

set omnifunc=ale#completion#OmniFunc

nmap <silent> <Leader>lN <Plug>(ale_previous_wrap)
nmap <silent> <Leader>ln <Plug>(ale_next_wrap)
nmap <silent> <Leader>ll <Plug>(ale_detail)
nmap <silent> <Leader>lf <Plug>(ale_fix)


" Nerdcommenter
" =============
let g:NERDSpaceDelims = 1

" Dash
" ====
nmap <silent> <leader>d <Plug>DashSearch

" Emoji!!!
" ========
set completefunc=emoji#complete

" Elixir
" ======
let g:mix_format_on_save = 1
let g:mix_format_options = '--check-equivalent'

" Prettier
" ========
let g:prettier#autoformat = 0
autocmd BufWritePre *.js,*.jsx,*.ts,*.tsx,*.json,*.graphql,*.yml,*.yaml PrettierAsync

" vim-rzip
" ========
" Decode URI encoded characters
function! DecodeURI(uri)
  return substitute(a:uri, '%\([a-fA-F0-9][a-fA-F0-9]\)', '\=nr2char("0x" . submatch(1))', "g")
endfunction

" CPP formatting
" ==============
autocmd BufWritePre *.cpp,*.h :silent! %!clang-format

" Attempt to clear non-focused buffers with matching name
function! ClearDuplicateBuffers(uri)
  " if our filename has URI encoded characters
  if DecodeURI(a:uri) !=# a:uri
    " wipeout buffer with URI decoded name - can print error if buffer in focus
    sil! exe "bwipeout " . fnameescape(DecodeURI(a:uri))
    " change the name of the current buffer to the URI decoded name
    exe "keepalt file " . fnameescape(DecodeURI(a:uri))
    " ensure we don't have any open buffer matching non-URI decoded name
    sil! exe "bwipeout " . fnameescape(a:uri)
  endif
endfunction

function! RzipOverride()
  " Disable vim-rzip's autocommands
  autocmd! zip BufReadCmd   zipfile:*,zipfile:*/*
  exe "au! zip BufReadCmd ".g:zipPlugin_ext

  " order is important here, setup name of new buffer correctly then fallback to vim-rzip's handling
  autocmd zip BufReadCmd   zipfile:*  call ClearDuplicateBuffers(expand("<afile>"))
  autocmd zip BufReadCmd   zipfile:*  call rzip#Read(DecodeURI(expand("<afile>")), 1)

  if has("unix")
    autocmd zip BufReadCmd   zipfile:*/*  call ClearDuplicateBuffers(expand("<afile>"))
    autocmd zip BufReadCmd   zipfile:*/*  call rzip#Read(DecodeURI(expand("<afile>")), 1)
  endif

  exe "au zip BufReadCmd ".g:zipPlugin_ext."  call rzip#Browse(DecodeURI(expand('<afile>')))"
endfunction

autocmd VimEnter * call RzipOverride()
