" more vim
set nocompatible

" allow backspace in insert mode
set backspace=indent,eol,start

" line numbers
set number

" highlight current line
set cursorline

" show the char limit column
set colorcolumn=80

" always show cursor position
set ruler

" enable mouse in all modes
set mouse=a

" move lines
nnoremap <A-j> :m .+1<CR>==
nnoremap <A-k> :m .-2<CR>==
inoremap <A-j> <Esc>:m .+1<CR>==gi
inoremap <A-k> <Esc>:m .-2<CR>==gi
vnoremap <A-j> :m '>+1<CR>gv=gv
vnoremap <A-k> :m '<-2<CR>gv=gv

" exit insert mode
:imap jk <Esc>
:imap kj <Esc>

" faster key codes (including Esc)
set ttimeout
set ttimeoutlen=50

" display incomplete commands
set showcmd

" hide mode display (built-in airline)
set noshowmode

" 4 spaces tabs
set tabstop=4
set shiftwidth=4
set expandtab

" syntax highlighting and filetype
syntax enable
filetype plugin indent on

" 'modern' encoding
set encoding=utf-8

" better command-line completion
set wildmenu

" disable swap files
set noswapfile
set nobackup
set nowritebackup

" better search
set hlsearch
set ignorecase
set incsearch

" always display the status line
set laststatus=2

" disable modelines for security
set modelines=0
set nomodeline

" line numbering
set number relativenumber

" allow saving as root
cmap w!! w !sudo tee > /dev/null %

" set true colors
set termguicolors

" use a vertical bar in insert mode, block otherwise
if &term =~ "xterm\\|rxvt"
  let &t_SI .= "\<Esc>[5 q"
  let &t_EI .= "\<Esc>[2 q"
endif

" plug
call plug#begin('~/.vim/plugged')
" Surround
Plug 'tpope/vim-surround'

" Status bar
Plug 'vim-airline/vim-airline'
Plug 'vim-airline/vim-airline-themes'

" Comments
Plug 'preservim/nerdcommenter'

" File viewer
Plug 'preservim/nerdtree'

" Search
Plug 'junegunn/fzf'
Plug 'junegunn/fzf.vim'

" Git
Plug 'airblade/vim-gitgutter'
Plug 'tpope/vim-fugitive'

" Language pack
Plug 'sheerun/vim-polyglot'

" Linter
Plug 'dense-analysis/ale'

" Autocompletion
Plug 'neoclide/coc.nvim', {'branch': 'release'}

" Themes
Plug 'gruvbox-community/gruvbox'
Plug 'arcticicestudio/nord-vim'
call plug#end()

" theme
set background=dark
colorscheme gruvbox

" airline
let g:airline_powerline_fonts=1
let g:airline_left_sep=''
let g:airline_right_sep=''
let g:airline#extensions#tabline#enabled = 1
let g:airline#extensions#ale#enabled = 1
