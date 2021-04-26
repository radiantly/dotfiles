set nocompatible   " run vim not vi

" This automatically installs the vim-plug plugin manager
" Snippet was taken from the vim-plug wiki
if empty(glob('~/.vim/autoload/plug.vim'))
  silent !curl -fLo ~/.vim/autoload/plug.vim --create-dirs
    \ https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
  autocmd VimEnter * PlugInstall --sync | source $MYVIMRC
endif

call plug#begin('~/.vim/plugged')

" Declare the list of plugins.
Plug 'vim-airline/vim-airline'
Plug 'vim-airline/vim-airline-themes'

" List ends here. Plugins become visible to Vim after this call.
call plug#end()

let g:airline_theme='powerlineish'

inoremap jk <ESC>

syntax on          " enable syntax highlighting

set hlsearch       " highlight all search results
set ignorecase     " do case insensitive search 
set incsearch      " show incremental search results as you type
set smartcase      " case-sensitive search if query contains uppercase
set number         " display line number
set relativenumber " relative line numbers

set tabstop=4      " show existing \t as 4 spaces
set expandtab      " on pressing tab convert it to spaces
set shiftwidth=4   " indents have a 4 spaces width
set cindent        " indentation for c files

set mouse=a        " enable mouse

" To set block cursor for normal mode and beam for insert
" Taken from https://stackoverflow.com/a/42118416/5302813
let &t_SI = "\e[6 q"
let &t_EI = "\e[2 q"

" Set correct cursor when starting vim
augroup cursorSet
au!
autocmd VimEnter * silent !echo -ne "\e[2 q"
augroup END
