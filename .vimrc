set nocompatible              " be iMproved, required
filetype off                  " required

" set the runtime path to include Vundle and initialize
set rtp+=~/.vim/bundle/Vundle.vim
call vundle#begin()
" alternatively, pass a path where Vundle should install plugins
"call vundle#begin('~/some/path/here')

" let Vundle manage Vundle, required
Plugin 'VundleVim/Vundle.vim'
Plugin 'NLKNguyen/papercolor-theme'
Plugin 'vim-airline/vim-airline'
Plugin 'vim-airline/vim-airline-themes'
" The following are examples of different formats supported.
" Keep Plugin commands between vundle#begin/end.
" plugin on GitHub repo
Plugin 'tpope/vim-fugitive'
" plugin from http://vim-scripts.org/vim/scripts.html
" Plugin 'L9'
" Git plugin not hosted on GitHub
Plugin 'wincent/command-t'
Plugin 'davidhalter/jedi-vim'
" git repos on your local machine (i.e. when working on your own plugin)
""Plugin 'file:///home/gmarik/path/to/plugin'
" The sparkup vim script is in a subdirectory of this repo called vim.
" Pass the path to set the runtimepath properly.
Plugin 'rstacruz/sparkup', {'rtp': 'vim/'}
Plugin 'ycm-core/YouCompleteMe'
" Install L9 and avoid a Naming conflict if you've already installed a
" different version somewhere else.
" Plugin 'ascenator/L9', {'name': 'newL9'}

" All of your Plugins must be added before the following line
call vundle#end()            " required
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
let g:airline_theme='papercolor'
let g:PaperColor_Theme_Options = {
  \   'theme': {
  \     'default': {
  \       'transparent_background': 0
  \     }
  \   }
  \ }

syntax on
set nu
set tabstop=2
set shiftwidth=2
set expandtab
set softtabstop=2
set cin
set t_Co=256
set background=light
colorscheme PaperColor
set mouse=a

inoremap {<CR> {<CR>}<ESC>O

inoremap ( ()<ESC>i
inoremap [ []<ESC>i
inoremap { {}<ESC>i
inoremap " ""<ESC>i
inoremap ' ''<ESC>i
inoremap <C-h> <left>
inoremap <C-j> <down>
inoremap <C-k> <up>
inoremap <C-l> <right>
set backspace=indent,eol,start

func SkipPair()
	if getline('.')[col('.') - 1] == ')' || getline('.')[col('.') - 1]  == ']' || getline('.')[col('.') - 1] == '"' || getline('.')[col('.') - 1] == "'" || getline('.')[col('.') - 1] == '}' || getline('.')[col('.') - 1] == '>'
	return "\<ESC>la"
	else 
	return "\t"
	endif
endfunc

func BackPair()
	if (getline('.')[col('.') - 1] == ')' && getline('.')[col('.')-2] == '(') || (getline('.')[col('.') - 1]  == ']' && getline('.')[col('.') - 2]  == '[') || (getline('.')[col('.') - 1] == '"' && getline('.')[col('.') - 2]  == '"') || (getline('.')[col('.') - 1] == "'" && getline('.')[col('.') - 2]  == "'") || (getline('.')[col('.') - 1] == '}' && getline('.')[col('.') - 2]  == '{') || (getline('.')[col('.') - 1] == '>' && getline('.')[col('.') - 2]  == '<')
	if strchars(getline('.')) == col('.')
		return "\<ESC>xxa"
	else
		return "\<ESC>xxi"
	endif
	else
	return nr2char(8) 
	endif
endfunc

inoremap <TAB> <c-r>=SkipPair()<CR>
inoremap <BS> <c-r>=BackPair()<CR>

map <F9> : call CR()<CR>
func! CR()
	if &filetype == 'cpp'
		exec "w"
		exec "!g++ % -O2 -Wall -std=c++14 -D DEBUG -o %<"
		exec "! ./%< && rm ./%<"
	endif
	if &filetype == 'python'
		exec "w"
		exec "!python3 %"
  endif
	if &filetype == 'sh'
		exec "w"
		exec "!bash %"
  endif
endfunc

map <F8> : call CRR()<CR>
func! CRR()
	if &filetype == 'cpp'
		exec "w"
		exec "!g++ % -O2 -Wall -std=c++17 -D DEBUG -o %<"
		exec "! ./%< < in1.txt && rm ./%<"
	endif
	if &filetype == 'python'
		exec "w"
		exec "!python3 %"
    endif
endfunc

map <F3> :YcmCompleter FixIt<CR>

autocmd BufNewFile *.cpp,*.[ch],*.sh,*.java,*.py,*.cc exec ":call SetTitle()" 
autocmd BufReadPre *.py exec "set expandtab"
autocmd BufReadPre *.py exec "set softtabstop=4"

""定义函数SetTitle，自动插入文件头 

func SetTitle()
        "如果文件类型为.sh文件
        if &filetype == 'sh' || &filetype == 'python'
                  call setline(1,"\#########################################################################")
            ""call append(line("."), "\# File Name: ".expand("%"))
                  call append(line("."), "\# Author: Zongwei Lan (lanzongwei541@gmail.com)")
      call append(line(".")+1, "\# mail: lanzongwei541@gmail.com")
      ""call append(line(".")+3, "\# Created Time: ".strftime("%c"))
      call append(line(".")+2, "\#########################################################################")
      if &filetype == 'python'
        call append(line(".")+3, "\#!/bin/python3")
      else
        call append(line(".")+3, "\#!/bin/bash")
      endif
      call append(line(".")+4, "")
        elseif &filetype != 'python'
        call setline(1, "// Copyright 2022 Zongwei Lan. All rights reserved.")
        ""call append(line("."), "// File Name: ".expand("%"))
        call append(line("."), "// Author: Zongwei Lan (lanzongwei541@gmail.com)")
        ""call append(line(".")+2, "// Created Time: ".strftime("%c"))
        call append(line(".")+1, "")
    endif
    if &filetype == 'c'
       call append(line(".")+2, "#include<stdio.h>")
       call append(line(".")+3, "")
    endif
    if &filetype == 'python'
        exec "set expandtab"
        exec "set softtabstop=4"
    endif
   "新建文件后，自动定位到文件末尾
    autocmd BufNewFile * normal G
endfunc

let g:copy_file=$HOME . "/.vim_copybuffer"
function Write_copy_file()
let lines=split(@", "\n")
call writefile(lines,g:copy_file)
endfunction

function Read_copy_file()
let l:buf=readfile(g:copy_file)
let @"=join(l:buf,"\n")
normal ""p
endfunction
nmap <silent> ;y :call Write_copy_file()<Enter>
nmap <silent> ;p :call Read_copy_file()<Enter>

augroup filetype
    autocmd! BufRead,BufNewFile BUILD set filetype=blade
augroup end
set hlsearch

set pastetoggle=<F12>

" Let clangd fully control code completion
let g:ycm_clangd_uses_ycmd_caching = 0
" Use installed clangd, not YCM-bundled clangd which doesn't get updates.
let g:ycm_clangd_binary_path = exepath("clangd-15")

let g:ycm_key_list_select_completion = ['<Down>']
let g:ycm_path_to_python_interpreter = '/usr/bin/python3'
