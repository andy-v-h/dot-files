colorscheme thaumaturge
syntax enable
set expandtab
au BufRead,BufNewFile *.py set tabstop=4 softtabstop=4 shiftwidth=4
au BufRead,BufNewFile *.thor set filetype=ruby
au BufRead,BufNewFile *.rb set tabstop=2 softtabstop=2 shiftwidth=2
set ai si "Set auto indent and smart indent
filetype indent on
set number
set wildmenu
set lazyredraw
set incsearch
set hlsearch
nnoremap ,<space> :nohlsearch<CR>
set nocompatible backspace=2
autocmd BufWritePre * %s/\s\+$//e
