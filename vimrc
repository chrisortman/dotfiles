set nocompatible
filetype off                         " vundle required

set nobackup
" set nowritebackup
set noswapfile
set history=1000
set autoindent
set smartindent
set smarttab
set tabstop=2 shiftwidth=2 softtabstop=2
set expandtab
set cursorline
set hidden

set hlsearch
set incsearch
set nu!

" Display tabs and trailing spaces
set list listchars=tab:\ \ ,trail:·

" =============== Completion ===========
set wildmode=list:longest
set wildmenu                "enable ctrl-n and ctrl-p to scroll thru matches
set wildignore=*.o,*.obj,*~ "stuff to ignore when tab completing
set wildignore+=*sass-cache*
set wildignore+=*DS_Store*
set wildignore+=vendor/rails/**
set wildignore+=vendor/cache/**
set wildignore+=*.gem
set wildignore+=log/**
set wildignore+=tmp/**
set wildignore+=*.png,*.jpg,*.gif
" let g:is_posix = 1

let mapleader = ','

" Font
set guifont=Envy\ Code\ R\ VS:h13
if has('mac')
  "set noantialias
endif


" BUNDLES 
" enable vundle
set rtp+=~/.vim/bundle/vundle/
call vundle#rc()

Bundle 'gmarik/vundle'

" regenerate tags file on save
Bundle 'craigemery/vim-autotag'

Bundle 'tpope/vim-sensible'
Bundle 'tpope/vim-sleuth.git'
Bundle 'tpope/vim-rails.git'
Bundle 'tpope/vim-bundler'
Bundle 'tpope/vim-cucumber'

" FuzzyFinder
Bundle 'L9'
Bundle 'FuzzyFinder'
Bundle 'tpope/vim-git'
Bundle 'tpope/vim-fugitive'


" filesystem tree explorer
Bundle "scrooloose/nerdtree.git"

Bundle 'kien/ctrlp.vim'

let g:ctrlp_map = '<leader>f'
let g:ctrlp_max_height = 30
let g:ctrlp_match_window_bottom=1
let g:ctrlp_max_height = 20
let g:ctrlp_match_window_reversed = 1
let g:ctrlp_switch_buffer = 'e'

Bundle 'bling/vim-airline'
" By default vim only shows status line when 2 or more windows open, this will
" always show it
set laststatus=2
Bundle 'gmarik/ingretu'
Bundle 'altercation/vim-colors-solarized'
Bundle 'jnurmine/Zenburn'
Bundle 'sickill/vim-monokai'

" surround
Bundle 'tpope/vim-surround'

" let's surround.vim know about <%=
let g:surround_{char2nr('=')} = "<%= \r %>"
let g:surround_{char2nr('-')} = "<% \r %>"

" convert words
Bundle 'tpope/vim-abolish'
Bundle 'tpope/vim-repeat'

" comment
Bundle 'tomtom/tcomment_vim'
Bundle 'tomtom/tinykeymap_vim'

" shows info from tags file for current file in side bar
Bundle 'majutsushi/tagbar'
"----- additional text objects-----

" came & snake case words
" Bundle 'bkad/CamelCaseMotion' 

"----------------------------------

" Mustache / handlebars
Bundle 'mustache/vim-mustache-handlebars'

" Slim
Bundle 'slim-template/vim-slim.git'

Bundle 'kongo2002/fsharp-vim'
Bundle 'pangloss/vim-javascript'
Bundle 'mxw/vim-jsx'
Bundle 'kchmck/vim-coffee-script'

" browse ruby documentation
Bundle 'danchoi/ri.vim'

" functions for running ruby tests
Bundle 'skalnik/vim-vroom'

" ack support
Bundle 'mileszs/ack.vim'
let g:ackprg = 'ag --nogroup --nocolor --column'

" tmux integration
Bundle 'benmills/vimux'
Bundle 'christoomey/vim-tmux-navigator'

" clojure
Bundle 'tpope/vim-leiningen'
Bundle 'tpope/vim-projectionist'
Bundle 'tpope/vim-dispatch'
Bundle 'tpope/vim-fireplace'

" slime, used for ruby repl
Bundle 'jpalardy/vim-slime'
let g:slime_target = "tmux"

Bundle 'honza/dockerfile.vim'

Bundle 'mtth/scratch.vim'

syntax enable
set background=light
if !has("gui_running")
    let g:solarized_termcolors=16
    " set background=dark
endif
" set background=light
colorscheme monokai

filetype plugin indent on        " vundle  required!

" map .docker file to docker syntax
au! BufNewFile,BufRead *.dockerfile set filetype=dockerfile

" map ecma script 6 syntax to javascript
autocmd BufRead,BufNewFile *.es6 setfiletype javascript

" Add ruby syntax highlighting for Thorfile, Rakefile, Vagrantfile and Gemfile
au BufRead,BufNewFile {Gemfile,Guardfile,Rakefile,Vagrantfile,Thorfile,config.ru} set ft=ruby
"
" Add haml syntax highlighting for .hamlc
au BufRead,BufNewFile *.thor set ft=ruby

" Allow highlighting of fenced code blocks in markdown files
au BufNewFile,BufReadPost *.md set filetype=markdown
let g:markdown_fenced_languages = ['coffee', 'css', 'erb=eruby', 'javascript', 'js=javascript', 'json=javascript', 'ruby', 'sass', 'xml', 'html']
"##############################################################################                                                                         
"" Easier split navigation                                                                                                                               
"##############################################################################                                                                         
"
"" Use ctrl-[hjkl] to select the active split!
nmap <silent> <c-k> :wincmd k<CR>
nmap <silent> <c-j> :wincmd j<CR>
nmap <silent> <c-h> :wincmd h<CR>
nmap <silent> <c-l> :wincmd l<CR>

"" Shortcuts to goto definition in new tabs or splits
" map <c-\> :tab split<CR>:exec("tag ".expand("<cword>"))<CR>
nmap g\ :vsp <CR>:exec(":tag ".expand("<cword>"))<CR>


function! UseLightSolarized()
  set background=light
    " set background=dark
  colorscheme solarized
endfunction

function! UseDarkSolarized()
  set background=dark
  colorscheme solarized
endfunction

function! UseMonokai()
  set background=dark
  colorscheme monokai
endfunction

map <leader>n :NERDTreeCWD<CR>
map <leader>b :CtrlPBuffer<cr>
map <leader>. :CtrlPTag<cr>
map <leader>q :TagbarToggle<cr>

map rp :VimuxPromptCommand<cr>
map rl :VimuxRunLastCommand<cr>
map ri :VimuxInspectRunner<cr>
map rc :VimuxCloseRunner<cr>
nnoremap  ,ri :call ri#OpenSearchPrompt(0)<cr> " horizontal split
nnoremap  ,RI :call ri#OpenSearchPrompt(1)<cr> " vertical split
nnoremap  ,RK :call ri#LookupNameUnderCursor()<cr> " keyword lookup

"clear search when you hit esc
" Works around problem in term where vim starts in replace mode
" http://stackoverflow.com/questions/11940801/mapping-esc-in-vimrc-causes-bizzare-arrow-behaviour
if has('gui_running')
  nnoremap <silent> <esc> :nohlsearch<cr><esc>
else
  nnoremap <cr> :noh<cr><cr>
end

" because otherwise rvm and zsh won't play nice when you use terminal commands
 set shell=bash
