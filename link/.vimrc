syntax on
"set background=light
set background=dark
set smartindent
set number
nnoremap <F2> :set nonumber!<CR>

" changecolor terminal in Constant group foreground color to green.
highlight Constant ctermfg=green

"set non-active window's status line dark gray
highlight StatusLineNC ctermfg=darkgray

"set tabstop=8
set tabstop=4
set softtabstop=4
set expandtab
set shiftwidth=4

set tags=./tags;/

"set term=xterm-color
"set binary noeol
"set vb
set noautoindent

" change leader key to comma
let mapleader=","

"folding
"let perl_fold=1  "fold perl subs and pod
"let perl_fold_blocks=1  "fold perl loops and blocks.
"set foldlevel=99 "default to no folding

" Dictionary completion via ^x ^k
" set dictionary+=/usr/share/dict/words


" Keep 10 lines (top/bottom) for scope
set scrolloff=5

" Show matching brackets when text indicator is over them
set showmatch

filetype on
filetype plugin on
" make status line visiable
set laststatus=2

" display file path in status line
set statusline+=%F

" display current line number and total lines
set statusline+=\ [line\ %l\/%L]
set statusline+=\ [col\ %v]             "virtual column number

"Always show current position
set ruler

" highlight current line
set cursorline

" When searching try to be smart about cases
set smartcase

" Ignore case when searching
set ignorecase

" Highlight search results
set hlsearch

" Set to auto read when a file is changed from the outside
set autoread

" Save undo’s after file closes
if exists('+undofile')
    set undofile
    set undodir=~/.vim/.undo//
endif
" make backup files
set backup
set backupdir=~/.vim/.backup//
set directory=~/.vim/.swp//

" line boundary
set colorcolumn=80

"syntax checking
au BufWritePost *.pl,*.pm,*.t !perl -wc -Ilib %
au BufWritePost *.php !php -l %

" Use the Solarized Dark theme
"let g:solarized_termtrans = 1
"colorscheme solarized
colorscheme lucario

"highlight whitespace end of line.
highlight WhiteSpaceEOL ctermbg=darkgreen guibg=lightgreen
match WhiteSpaceEOL /\s*\ \s*$/
autocmd WinEnter * match WhiteSpaceEOL /\s*\ \s*$/

inoremap <tab> <c-r>=InsertTabWrapper()<cr>

function InsertTabWrapper()
      let col = col('.') - 1
      if !col || getline('.')[col - 1] !~ '\k'
          return "\<tab>"
      else
          return "\<c-p>"
      endif
endfunction

" Return to last edit position when opening files (You want this!)
autocmd BufReadPost *
     \ if line("'\"") > 0 && line("'\"") <= line("$") |
     \ exe "normal! g`\"" |
     \ endif
" Remember info about open buffers on close
set viminfo^=%

" Remap VIM 0 to first non-blank character
map 0 ^

" delete end of line trailing space on save
autocmd BufWritePre *.php :%s/\s\+$//e


" set vim to chdir for each file
if exists('+autochdir')
    set autochdir
else
    autocmd BufEnter * silent! lcd %:p:h:gs/ /\\ /
endif


" Strip trailing whitespace (,ss)
function! StripWhitespace()
   let save_cursor = getpos(".")
   let old_query = getreg('/')
   :%s/\s\+$//e
   call setpos('.', save_cursor)
   call setreg('/', old_query)
endfunction
noremap <leader>ss :call StripWhitespace()<CR>

" Delete trailing white space on save, useful for Python and CoffeeScript ;)
"func! DeleteTrailingWS()
"  exe "normal mz"
"  %s/\s\+$//ge
"  exe "normal `z"
"endfunc
"autocmd BufWrite *.py :call DeleteTrailingWS()
"autocmd BufWrite *.coffee :call DeleteTrailingWS()

"au bufread * syn keyword MyKeywords        TODO FIXME XXX
"au bufread * highlight MyKeywords cterm=bold term=bold ctermbg=darkgreen ctermfg=black
"syn keyword MyKeywords        TODO FIXME XXX
"highlight MyKeywords cterm=bold term=bold ctermbg=darkgreen ctermfg=black

if has("autocmd")
  " Highlight TODO, FIXME, NOTE, etc.
  if v:version > 701
    autocmd Syntax * call matchadd('Todo',  '\W\zs\(TODO\|FIXME\|CHANGED\|XXX\|BUG\|HACK\)')
    autocmd Syntax * call matchadd('Debug', '\W\zs\(NOTE\|INFO\|IDEA\)')
  endif
endif

""autocmd BufWritePost *.php silent! !eval 'ctags -R -o newtags; mv newtags tags' &
"autocmd BufWritePost *.php :TlistUpdate
"let Tlist_Auto_Open =1

" so it doesn't conflict with comments plugin <C-C> key.
nmap <C-E> <Plug>DWMClose

" <C-w><C-O> is vim command for close other window - same as :only. Override
" it so we can avoid mixing it with zoomwin fullscreen shortcut.
nmap <C-w><C-o> <C-w>o

" If you are considering putting this map in your .vimrc be careful to not put
" any comments after it, imap will try to interpret the blank spaces after
" <Esc> producing random jumps after entering normal mode. 
" "inoremap jj <ESC>


call plug#begin()
Plug 'pearofducks/ansible-vim'
" "Plug 'pearofducks/ansible-vim', { 'do': './UltiSnips/generate.sh' }
Plug 'ojroques/vim-oscyank'
call plug#end()


" visual mode no recursive map ,y to OSCYank"
vnoremap <leader>y :OSCYank<CR>
" immediately copy after a yank operation
autocmd TextYankPost * if v:event.operator is 'y' && v:event.regname is '' | OSCYankReg " | endif


" YAML documents are required to have a 2 space indentation.
autocmd FileType yaml setlocal ts=2 sts=2 sw=2 expandtab

autocmd BufWritePost *.py call Flake8()
