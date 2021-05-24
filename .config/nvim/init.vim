"
" init.vim
"

"
" Vim-Plug
"

if empty(glob('~/.local/share/nvim/site/autoload/plug.vim'))
	silent !curl -fLo ~/.local/share/nvim/site/autoload/plug.vim --create-dirs
	    \ https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
	autocmd VimEnter * PlugInstall --sync
endif

call plug#begin('~/.local/share/nvim/plugged')

Plug 'itchyny/lightline.vim'
Plug 'morhetz/gruvbox'
Plug 'rlue/vim-barbaric'

call plug#end()

"
" General
"

" Sets how many lines of history VIM has to remember
set history=500

" Enable filetype plugins
filetype plugin on
filetype indent on

" Set to auto read when a file is changed from the outside
set autoread
autocmd FocusGained,BufEnter * checktime

" With a map leader it's possible to do extra key combinations
" like <leader>w saves the current file
let mapleader = ","

" Make vim more vim-like than vi like
set nocompatible

" Current directory is searched for two files: .nvimrc and .exrc
" Disallow local .nvimrc or .exor to execute :autocmd
set exrc
set secure

" Clipboard access
set clipboard+=unnamedplus

" Fast saving
nmap <leader>w :wa<CR>

"
" User interface
"

" Set 7 lines to the cursor - when moving vertically using j/k
set scrolloff=7

" Turn on the Wild menu
set wildmenu

" Ignore compiled files
set wildignore=*.o,*~,*.pyc
if has("win16") || has("win32")
	set wildignore+=.git\*,.hg\*,.svn\*
else
	set wildignore+=*/.git/*,*/.hg/*,*/.svn/*,*/.DS_Store
endif

"Always show current position
set ruler

" Height of the command bar
set cmdheight=1

" A buffer becomes hidden when it is abandoned
set hidden

" Ignore case when searching
set ignorecase
" When searching try to be smart about cases
set smartcase
" Highlight search results
set hlsearch
" Makes search less responsive
set noincsearch

" Don't redraw while executing macros (good performance config)
set lazyredraw

" For regular expressions turn magic on
set magic

" Show matching brackets when text indicator is over them
set showmatch
" How many tenths of a second to blink when matching brackets
set mat=2

" No annoying sound on errors
set noerrorbells
set novisualbell
set t_vb=
set tm=500

" Add a bit extra margin to the left
set foldcolumn=1

" Show relative line number
set number
set relativenumber

" Show command in bottom bar
set showcmd

" Hightlight current line
set cursorline
" 80 column mark
set colorcolumn=80

" Do not Show mode
set noshowmode

" Number of screen lines to use for the command-line
set cmdheight=1

" neomutt/mutt compatible
au BufRead /tmp/neomutt-*,/tmp/mutt-* setlocal textwidth=72 colorcolumn=72

"
" Colors and Fonts
"

" Enable syntax highlighting
syntax enable

" Color scheme
try
	colorscheme gruvbox
catch
endtry

set background=dark

" Set utf8 as standard encoding and en_US as the standard language
set encoding=utf8

" Use Unix as the standard file type
set ffs=unix,dos,mac

"
" Text, tab and indent related
"

" Tab is tab, and is 8 char wide (follow OpenBSD style)
set noexpandtab
set shiftwidth=8
set tabstop=8

" Auto indent on
set autoindent
set cindent

" press F8 to disable auto indenting
nnoremap <F8> :setl noai nocin nosi inde=<CR>

" Wrap lines
set wrap

"
" Moving around, tabs, windows and buffers
"

" Disable highlight when <leader><space> is pressed
nnoremap <leader><space> :nohlsearch<CR>


" Open new split panes to right and bottom
set splitbelow
set splitright

" Smart way to move between windows
map <C-j> <C-W>j
map <C-k> <C-W>k

" Show all open buffers and their status
nmap <leader>bl :ls<CR>
" delete the current buffer
nmap <leader>bd :ls<CR>:bdelete<Space>
" add a new buffer for a file to the buffer list without opening the file
nmap <leader>ba :badd<CR>

" go to buffer
nnoremap gb :ls<CR>:buffer<Space>
" Move to the next buffer
map <C-l> :bnext<CR>
" Move to the previous buffer
map <C-h> :bprevious<CR>

" Switch PWD to the directory of the open buffer
map <leader>cd :cd %:p:h<CR>:pwd<CR>

"
" Status line
"

" Always show the status line
set laststatus=2

" Format the status line
"set statusline=\ [%n]\ %F\ %<%h%w%m%r
"set statusline+=%=\ \ \ [FORMAT=%{&fileformat}]\ [TYPE=%Y]
"set statusline+=\ \ \ Ln:%02l/%02L\ Col:%02c\ %02p%%
"set statusline+=\ \ \ ASCII:%03b

"
" Editing mappings
"

" Automatically deletes all trailing whitespace and newlines at end of file on save.
autocmd BufWritePre * %s/\s\+$//e

"
" Filetype
"

" Ensure files are read as what I want:
autocmd BufRead,BufNewFile *kshrc,*cvsrc set filetype=sh
autocmd BufRead,BufNewFile *exrc         set filetype=vim
autocmd BufRead,BufNewFile *.tex         set filetype=tex

" view .h file as c header file, not c++
augroup project
	autocmd!
	autocmd BufRead,BufNewFile *.h,*.c set filetype=c
augroup END

" view .tex file in latex syntax, not plain tex
let g:tex_flavor = "latex"

" shell script in posix standard
let g:is_posix = 1

" tab = 2 space width for html file
autocmd FileType html,groff,tex setlocal shiftwidth=2 tabstop=2

" Run xrdb whenever Xdefaults or Xresources are updated.
autocmd BufWritePost *Xresources,*Xdefaults !xrdb "%:p"

" Runs a script that cleans out tex build files whenever I close out of a .tex file.
autocmd VimLeave *.tex !texclear "%:p"


"
" External command
"

" Compile latex document
nnoremap <leader>c :w! \| !compiler "%:p"<CR>
" Open corresponding .pdf/.html or preview
nnoremap <leader>p :!opout "%:p"<CR>
" Check file in shellcheck
nnoremap <leader>s :!clear && shellcheck "%:p"<CR>

"
" Plugins
"

let g:lightline = {
      \ 'colorscheme': 'seoul256',
      \ }

