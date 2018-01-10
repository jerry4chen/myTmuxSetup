if version >= 600
  set nocompatible
  filetype off

  set rtp+=~/.vim/bundle/Vundle.vim
  call vundle#begin()
  
  Plugin 'gmarik/Vundle.vim'

  " ... Add More Plug-ins Here ...

  " Show trailing whitespaces
  Plugin 'vim-scripts/ShowTrailingWhitespace'

  " LLVM assembly and tablegen syntax highlight
  Plugin 'andrewmacp/llvm.vim'

  " Rust programming language syntax highlight
  Plugin 'wting/rust.vim'

  " OpenCL syntax highlight
  Plugin 'petRUShka/vim-opencl'

  " reStructuredText
  Plugin 'Rykka/riv.vim'
  let g:riv_disable_folding=1  " disable folding
  let g:riv_auto_format_table=0

  " Smali
  Plugin 'alderz/smali-vim'

  " Markdown
  Plugin 'godlygeek/tabular'
  let g:vim_markdown_folding_disabled=1  " disable folding
  Plugin 'plasticboy/vim-markdown'

  " Nerd tree
  Plugin 'scrooloose/nerdtree'
  " Plugin 'jistr/vim-nerdtree-tabs'
  let g:nerdtree_tabs_open_on_gui_startup=0
  " map <C-n> :NERDTreeTabsToggle<CR>
  map <C-n> :NERDTreeToggle<CR>

  " Fuzzy filename search
  Plugin 'ctrlpvim/ctrlp.vim'
  let g:ctrlp_prompt_mappings = {
      \ 'AcceptSelection("e")': ['<c-t>'],
      \ 'AcceptSelection("t")': ['<cr>', '<2-LeftMouse>'],
      \ }

  " Stylus
  Plugin 'wavded/vim-stylus'

  " Javascript
  Plugin 'pangloss/vim-javascript'

  " Ag
  Plugin 'rking/ag.vim'

  call vundle#end()
  filetype plugin indent on
end

syn on
set paste
set ts=8
set sts=4
set sw=4
set expandtab
"set nofoldenable  " no folding please

set colorcolumn=81,101

" Highlight the search result
set hlsearch

set t_Co=256
"colorscheme koehler
colorscheme molokai

set autoindent

set wildmode=longest,list
set wildmenu

au FileType cpp setlocal sts=2 sw=2 cindent cinoptions=:0,g0,(0,Ws,l1
au FileType c setlocal sts=4 sw=4 cindent cinoptions=:0,g0,(0,Ws,l1

" Doxygen hacks
au FileType c,cpp setlocal comments=sO:*\ -,mO:*\ \ ,exO:*/,s1:/*,mb:*,ex:*/,bO:///,O://

" Strip trailing whitespaces
"au FileType c,cpp au BufWritePre <buffer> :%s/\s\+$//e

" Better manpage
fun! Man(page)
  new
  set ft=man
  exe"r!man ".a:page." 2>/dev/null \|col -b\|uniq -u"
  set nomod
  set nonu
  normal 1G
endfun
map K :call Man(expand("<cword>"))<CR>

" grep shortcut
fun! Csearch(regex)
  execute "cgetexpr system('csearch -n \"\\b" . a:regex . "\\b\"')"
  tabnew
  set nu
  cw
  set nonu
  set colorcolumn=
endfun

fun! GetSelection()
  let [lnum1, col1] = getpos("'<")[1:2]
  let [lnum2, col2] = getpos("'>")[1:2]
  let lines = getline(lnum1, lnum2)
  let lines[-1] = lines[-1][: col2 - (&selection == 'inclusive' ? 1 : 2)]
  let lines[0] = lines[0][col1 - 1:]
  return join(lines, "\n")
endfun

nmap <F4> :call Csearch(expand("<cword>")) <CR>
vmap <F4> :call Csearch(GetSelection()) <CR>
command -nargs=1 CS call Csearch(<f-args>)

map <F3> :execute "vimgrep /" . expand("<cword>") . "/j **" <BAR> tabnew <BAR> cw <CR>

if &diff | syntax off | endif

set tabpagemax=1000

set tags=./tags;,./TAGS,tags,TAGS

" Check .git/tags for ctags file.
fun! FindTagsFileInGitDir(file)
  let path = fnamemodify(a:file, ':p:h')
  while path != '/'
    let fname = path . '/.git/tags'
    if filereadable(fname)
      silent! exec 'set tags+=' . fname
    endif
    let fname = path . '/.hg/tags'
    if filereadable(fname)
      silent! exec 'set tags+=' . fname
    endif
    let path = fnamemodify(path, ':h')
  endwhile
endfun

autocmd BufRead * call FindTagsFileInGitDir(expand("<afile>"))

autocmd BufRead,BufNew /home/mtk06344/Android/rsc/rsdrv/rsdrv/* set sts=4 sw=4 expandtab

set wrapscan

