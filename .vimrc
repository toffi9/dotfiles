set encoding=utf-8

call plug#begin('~/.vim/plugged')
Plug 'endel/vim-github-colorscheme'
Plug 'gregsexton/Muon'
Plug 'itchyny/lightline.vim'
Plug 'junegunn/fzf.vim'
Plug 'justinmk/vim-sneak'
Plug 'tpope/vim-vinegar'
Plug 'tpope/vim-commentary'
Plug 'tpope/vim-surround'
Plug 'tpope/vim-repeat'
Plug 'tpope/vim-fugitive'
Plug 'airblade/vim-gitgutter'
Plug 'danro/rename.vim'
Plug 'w0rp/ale'
Plug 'craigemery/vim-autotag'
Plug 'jiangmiao/auto-pairs'
Plug 'mileszs/ack.vim'
Plug 'janko-m/vim-test'
Plug 'alfredodeza/coveragepy.vim'
Plug 'iamcco/markdown-preview.vim'
Plug 'Shougo/deoplete.nvim'
Plug 'roxma/nvim-yarp'
Plug 'roxma/vim-hug-neovim-rpc'
Plug 'zchee/deoplete-jedi'
Plug 'davidhalter/jedi-vim'
Plug 'plytophogy/vim-virtualenv'
Plug 'fisadev/vim-isort'
Plug 'tmhedberg/matchit'
Plug 'google/yapf', { 'rtp': 'plugins/vim' }
" Plug 'fatih/vim-go', { 'do': ':GoUpdateBinaries' }
Plug 'SirVer/ultisnips'
Plug 'sheerun/vim-polyglot'
Plug 'Glench/Vim-Jinja2-Syntax'
call plug#end()

filetype on
filetype plugin indent on
syntax on
set autoindent
set tabstop=2
set path+=**
set shiftwidth=2
set backspace=2
set expandtab
set nocompatible
set relativenumber
set number
set showmatch
set showcmd
set noshowmode
set ignorecase
set nohlsearch
set cursorline
set smartcase
set incsearch
set ttimeoutlen=100
set vb
set ruler
set scrolloff=2
set laststatus=2
set foldmethod=indent
set foldnestmax=3
set foldlevel=3
set clipboard=unnamed
set wildmenu
set wildmode=list:longest,full
set nobackup
set nowritebackup
set noswapfile
set colorcolumn=80
set list listchars=tab:»·,trail:·,nbsp:·
set rtp+=/usr/local/opt/fzf
set rtp+=~/.fzf
set wildignore+=*.pyc,node_modules
set wildignore+=node_modules/*
set autoread

colorscheme github
" colorscheme muon

autocmd Filetype gitcommit setlocal spell textwidth=72
" Per default, netrw leaves unmodified buffers open. This autocommand
" deletes netrw's buffer once it's hidden (using ':q', for example)
" https://vi.stackexchange.com/a/13012
" https://github.com/tpope/vim-vinegar/issues/13#issuecomment-47133890
autocmd FileType netrw setl bufhidden=delete
let g:netrw_banner = 0
let g:netrw_bufsettings = 'noma nomod nu nobl nowrap ro'
let g:netrw_keepdir = 1
let g:netrw_liststyle = 3

if executable('ag')
  let g:ackprg = 'ag --vimgrep'
endif

let g:python_docker_command = 'docker-compose -f dev.yml run --rm --no-deps django '

" let test#python#runner = 'djangotest'
" let test#python#djangotest#executable = 'python setup.py test'
let test#python#runner = 'pytest'
let test#python#pytest#executable = python_docker_command . 'pytest -vv'

let g:jedi#completions_enabled = 0
let g:jedi#use_tabs_not_buffers = 1
let g:python_host_prog  = '/usr/local/bin/python'
let g:python3_host_prog = '/usr/local/bin/python3'
let g:deoplete#enable_at_startup = 1

let g:sneak#label = 1

let g:ale_echo_msg_error_str = 'E'
let g:ale_echo_msg_warning_str = 'W'
let g:ale_echo_msg_format = '[%linter%] %s [%severity%]'
let g:ale_sign_warning = '▲'
let g:ale_sign_error = '✗'
highlight link ALEWarningSign String
highlight link ALEErrorSign Title

let g:lightline = {
\ 'colorscheme': 'wombat',
\ 'active': {
\   'left': [['mode', 'paste'], ['gitbranch', 'relativepath', 'modified']],
\   'right': [['lineinfo'], ['percent'], ['readonly', 'linter_warnings', 'linter_errors', 'linter_ok'], ['filetype'],]
\ },
\ 'component_function': {
\   'gitbranch': 'fugitive#head'
\ },
\ 'component_expand': {
\   'linter_warnings': 'LightlineLinterWarnings',
\   'linter_errors': 'LightlineLinterErrors',
\   'linter_ok': 'LightlineLinterOK'
\ },
\ 'component_type': {
\   'readonly': 'error',
\   'linter_warnings': 'warning',
\   'linter_errors': 'error'
\ },
\ }

function! LightlineLinterWarnings() abort
  let l:counts = ale#statusline#Count(bufnr(''))
  let l:all_errors = l:counts.error + l:counts.style_error
  let l:all_non_errors = l:counts.total - l:all_errors
  return l:counts.total == 0 ? '' : printf('%d ◆', all_non_errors)
endfunction

function! LightlineLinterErrors() abort
  let l:counts = ale#statusline#Count(bufnr(''))
  let l:all_errors = l:counts.error + l:counts.style_error
  let l:all_non_errors = l:counts.total - l:all_errors
  return l:counts.total == 0 ? '' : printf('%d ✗', all_errors)
endfunction

function! LightlineLinterOK() abort
  let l:counts = ale#statusline#Count(bufnr(''))
  let l:all_errors = l:counts.error + l:counts.style_error
  let l:all_non_errors = l:counts.total - l:all_errors
  return l:counts.total == 0 ? '✓ ' : ''
endfunction

autocmd User ALELint call s:MaybeUpdateLightline()
let g:ale_linters = {
\   'javascript': ['eslint'],
\}

" Update and show lightline but only if it's visible (e.g., not in Goyo)
function! s:MaybeUpdateLightline()
  if exists('#lightline')
    call lightline#update()
  end
endfunction

let mapleader = ","
map <Leader>q :q<cr>
map <Leader>w :w<cr>
nmap <Leader><F6> :source ~/.vimrc<CR>
nmap <Leader>F :tabnew .<cr>
nmap <Leader>S :Ack! -i 
nmap <Leader>na :ALENext<cr>
nmap <Leader>cn :cnext<CR>
nmap <Leader>co :copen<CR>
nmap <Leader>cp :cprev<CR>
nmap <Leader>cx :cclose<CR>
nmap <Leader>ea :tabnew ~/.aliases<CR>
nmap <Leader>es :tabnew ~/.vim/UltiSnips/<CR>
nmap <Leader>ev :tabnew ~/.vimrc<CR>
nmap <Leader>et :tabnew ~/.tmux.conf<CR>
nmap <Leader>ez :tabnew ~/.zshrc<CR>
nmap <Leader>eg :tabnew ~/.gitconfig<CR>
nmap <Leader>en :tabnew ~/Documents/<CR>
nmap <Leader>f :e .<CR>
nmap <c-t> :Tags<CR>
nmap <c-p> :Files<CR>
nmap <Leader>v :vsp<cr>
nmap <Leader>W :OpenBrowserSmartSearch 
nmap <Leader>gs :Gstatus<CR>
nmap <Leader>gsp :Git st<CR>
nmap <Leader>gdf :Git diff<CR>
nmap <Leader>gm :Gcommit<CR>
nmap <Leader>gco :Git checkout 
nmap <Leader>gcb :Git checkout -b 
nmap <c-h> <c-w>h
nmap <c-j> <c-w>j
nmap <c-k> <c-w>k
nmap <c-l> <c-w>l
nmap <silent> <Leader>tf :TestFile<CR>
nmap <silent> <Leader>tl :TestLast<CR>
nmap <silent> <Leader>tn :TestNearest<CR>
nmap <silent> <Leader>ts :TestSuite<CR>
nmap <silent> <Leader>tc :!coverage run setup.py test && coverage report -m<CR>
nnoremap <F3> :set hlsearch! hlsearch?<cr>
noremap <Leader>0 :tabnext<cr>
noremap <Leader>1 1gt
noremap <Leader>2 2gt
noremap <Leader>3 3gt
noremap <Leader>4 4gt
noremap <Leader>5 5gt
noremap <Leader>6 6gt
noremap <Leader>7 7gt
noremap <Leader>8 8gt
noremap <Leader>9 9gt
noremap <Leader>bs :resize 90<cr>
noremap <Leader>ss :resize 10<cr>
vnoremap <Leader>fy :'<,'>call yapf#YAPF()<cr>
vnoremap < <gv
noremap > >gv
