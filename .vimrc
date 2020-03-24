set nocompatible

" This automatically installs the vim-plug plugin manager
" Snippet was taken from the vim-plug wiki
if empty(glob('~/.vim/autoload/plug.vim'))
  silent !curl -fLo ~/.vim/autoload/plug.vim --create-dirs
    \ https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
  autocmd VimEnter * PlugInstall --sync | source $MYVIMRC
endif

call plug#begin('~/.vim/plugged')

" Declare the list of plugins.
Plug 'xuhdev/SingleCompile'
Plug 'vim-airline/vim-airline'
Plug 'vim-airline/vim-airline-themes'

" List ends here. Plugins become visible to Vim after this call.
call plug#end()

let g:airline_theme='powerlineish'

inoremap jk <ESC> 

syntax on
set number
set tabstop=8
set expandtab
set shiftwidth=4
set cindent

imap <F9> <ESC><F9>
imap <F10> <ESC><F10>

nmap <F9> :SCCompile<cr>
nnoremap <F10> :call SingleCompileSplit() \| SCCompileRun<CR>
function! SingleCompileSplit()
   if winwidth(0) > 160
      let g:SingleCompile_split = "vsplit"
      let g:SingleCompile_resultsize = winwidth(0)/2
   else
      let g:SingleCompile_split = "split"
      let g:SingleCompile_resultsize = 15
   endif
endfunction
let g:SingleCompile_showquickfixiferror = 1
let g:SingleCompile_showquickfixifwarning = 1
let g:SingleCompile_silentcompileifshowquickfix = 1
let g:SingleCompile_usetee=0
