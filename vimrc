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

let mapleader = ","

" Font
set guifont=Menlo:h13
if has('mac')
  "set noantialias
endif

runtime macros/matchit.vim

" BUNDLES 
call plug#begin('~/.vim/plugged')

  " regenerate tags file on save
  " Plug 'craigemery/vim-autotag'

  Plug 'tpope/vim-sensible'
  Plug 'tpope/vim-sleuth.git'
  Plug 'tpope/vim-rails.git', {'for' : ['ruby','rails'] }
  Plug 'tpope/vim-bundler', {'for' : ['ruby','rails'] }
  Plug 'tpope/vim-cucumber'
  Plug 'tpope/vim-obsession.git'
  Plug 'tpope/vim-unimpaired'

  " FuzzyFinder
  Plug 'L9'
  Plug 'FuzzyFinder'
  Plug 'tpope/vim-git'
  Plug 'tpope/vim-fugitive'
  " Plug 'airblade/vim-gitgutter'


  " filesystem tree explorer
  Plug 'scrooloose/nerdtree'

  Plug 'kien/ctrlp.vim'

  Plug 'SirVer/ultisnips' | Plug 'honza/vim-snippets'

  Plug 'gmarik/ingretu'
  Plug 'altercation/vim-colors-solarized'
  Plug 'jnurmine/Zenburn'
  " Plug 'crusoexia/vim-monokai'
  Plug 'chrisortman/vim-monokai'
  Plug 'tomasr/molokai'

  " surround
  Plug 'tpope/vim-surround'
  " convert words
  " Plug 'tpope/vim-abolish'
  Plug 'tpope/vim-repeat'

  " comment
  Plug 'tomtom/tcomment_vim'
  " Plug 'tomtom/tinykeymap_vim'

  " shows info from tags file for current file in side bar
  Plug 'majutsushi/tagbar'

  " show and clean whitespace
  Plug 'ntpeters/vim-better-whitespace'

  " Plug 'tpope/vim-rbenv'
  Plug 'vim-ruby/vim-ruby'

  " better folding, only methods, classes & it blocks
  Plug 'vim-utils/vim-ruby-fold'

  " Mustache / handlebars
  Plug 'mustache/vim-mustache-handlebars'

  " Slim
  Plug 'slim-template/vim-slim.git'

  Plug 'pangloss/vim-javascript'
  Plug 'tpope/vim-jdaddy' " json helpers

  Plug 'mxw/vim-jsx'
  Plug 'kchmck/vim-coffee-script'

  " markdown support
  " Plug 'godlygeek/tabular'
  Plug 'plasticboy/vim-markdown'

  " browse ruby documentation
  Plug 'danchoi/ri.vim'

  " functions for running ruby tests
  " Plug 'skalnik/vim-vroom'
  Plug 'chrisortman/vim-test'
  " automatic end statement in ruby blocks => 'my-build'
  Plug 'tpope/vim-endwise'

  " adds ir and ar to select ruby blocks
  Plug 'kana/vim-textobj-user', {'for' : ['ruby'] }
  Plug 'nelstrom/vim-textobj-rubyblock', {'for' : ['ruby'] }

  " Adds argument text object
  Plug 'vim-scripts/argtextobj.vim'

  " gS and gJ to split & join code blocks
  Plug 'AndrewRadev/splitjoin.vim'

  " ag support
  Plug 'rking/ag.vim'

  " make incremental search results easier to see
  Plug 'wincent/loupe'

  " Enhanced multi file search
  " Plug 'wincent/ferret'
  " rust lang
  Plug 'rust-lang/rust.vim'
  " nginx config file highlighting
  Plug 'evanmiller/nginx-vim-syntax'
  " tmux integration
  Plug 'benmills/vimux'
  Plug 'christoomey/vim-tmux-navigator'
  Plug 'honza/dockerfile.vim'

  Plug 'elixir-lang/vim-elixir', {'for' : ['elixir'] }
  Plug 'slashmili/alchemist.vim', {'for' : ['elixir'] }
  Plug 'lambdatoast/elm.vim', {'for' : ['elm'] }
  Plug 'keith/swift.vim', {'for' : ['swift'] }
  Plug 'brow/vim-xctool', {'for' : ['swift'] }
  Plug 'mattn/emmet-vim'
  " Intelligent switching between relative & absolute
  " line numbers
  " can also toggle with C-n
  Plug 'jeffkreeftmeijer/vim-numbertoggle'

  " clojure
  Plug 'tpope/vim-leiningen', {'for' : ['clojure'] }
  Plug 'tpope/vim-projectionist', {'for' : ['clojure'] }
  Plug 'tpope/vim-dispatch'
  Plug 'tpope/vim-fireplace', {'for' : ['clojure'] }

  " slime, used for ruby repl
  Plug 'jpalardy/vim-slime'

  Plug 'tpope/vim-flagship'

call plug#end()

let NERDTreeIgnore = ['\.pyc$']
let g:ctrlp_map = '<leader>f'
let g:ctrlp_max_height = 30
let g:ctrlp_match_window_bottom=1
let g:ctrlp_max_height = 20
let g:ctrlp_match_window_reversed = 1
let g:ctrlp_switch_buffer = 'e'

" By default vim only shows status line when 2 or more windows open, this will
" always show it
set laststatus=2
set showtabline=2
set guioptions-=e


" let's surround.vim know about <%=
let g:surround_{char2nr('=')} = "<%= \r %>"
let g:surround_{char2nr('-')} = "<% \r %>"

let test#strategy='vimux'
nmap <silent> <leader>t :TestNearest<CR>
nmap <silent> <leader>T :TestFile<CR>
nmap <silent> <leader>l :TestLast<CR>
" let g:vroom_use_vimux = 1
" let g:vroom_test_unit_command = "rails test"

" I don't need a map to clear highlighting
let g:LoupeCenterResults=0 

au! BufRead,BufNewFile /etc/nginx/*,*/nginx/nginx.conf,*/nginx/conf.d/*,/usr/local/nginx/conf/* set filetype=nginx 


" Change the cursor based on mode 
" when running tmux in iterm
if exists('$ITERM_PROFILE')
  if exists('$TMUX') 
    let &t_SI = "\<Esc>[3 q"
    let &t_EI = "\<Esc>[0 q"
  else
    let &t_SI = "\<Esc>]50;CursorShape=1\x7"
    let &t_EI = "\<Esc>]50;CursorShape=0\x7"
  endif
end


" for tmux to automatically set paste and nopaste mode at the time pasting (as
" " happens in VIM UI)
"
function! WrapForTmux(s)
  if !exists('$TMUX')
    return a:s
  endif

  let tmux_start = "\<Esc>Ptmux;"
  let tmux_end = "\<Esc>\\"

  return tmux_start . substitute(a:s, "\<Esc>", "\<Esc>\<Esc>", 'g') . tmux_end
endfunction

let &t_SI .= WrapForTmux("\<Esc>[?2004h")
let &t_EI .= WrapForTmux("\<Esc>[?2004l")

function! XTermPasteBegin()
  set pastetoggle=<Esc>[201~
  set paste
  return ""
endfunction

inoremap <special> <expr> <Esc>[200~ XTermPasteBegin()

let g:slime_target = "tmux"
nmap ,ss <Plug>SlimeLineSend

syntax on
filetype plugin indent on        " vundle  required!
"set omnifunc=syntaxcomplete#Complete

" Get horrible lag in large ruby files
" Interesting thread here https://github.com/vim/vim/issues/282
set lazyredraw

" let g:molokai_original=1
let g:rehash256=1
colorscheme molokai


" map .docker file to docker syntax
au! BufNewFile,BufRead *.dockerfile set filetype=dockerfile

" map ecma script 6 syntax to javascript
autocmd BufRead,BufNewFile *.es6 setfiletype javascript

" Add ruby syntax highlighting for Thorfile, Rakefile, Vagrantfile and Gemfile
au BufRead,BufNewFile {Gemfile,Guardfile,Rakefile,Vagrantfile,Thorfile,config.ru,Fastfile} set ft=ruby
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
nnoremap <Space> za

"clear search when you hit esc
" Works around problem in term where vim starts in replace mode
" http://stackoverflow.com/questions/11940801/mapping-esc-in-vimrc-causes-bizzare-arrow-behaviour
if has('gui_running')
  nnoremap <silent> <esc> :nohlsearch<cr><esc>
else
  nnoremap <cr> :noh<cr><cr>
end

" Insert current date with F5
" In normal mode use m/d/y in insert use a timestamp
:nnoremap <F5> "=strftime("%m/%d/%y")<CR>P
:inoremap <F5> <C-R>=strftime("%FT%T%z")<CR>

" ----------------------------------------------------------------------------
" from https://github.com/rking/pry-de/blob/master/vim/ftplugin/ruby_pry.vim
"
" …also, Insert Mode as bpry<space>
iabbr bpry require'pry';binding.pry
" And admit that the typos happen:
iabbr bpry require'pry';binding.pry
iabbr brdb require 'debugger';debugger;
iabbr wajax And I wait until all Ajax requests are complete

" Add the pry debug line with \bp (or <Space>bp, if you did: map <Space> <Leader> )
" map <Leader>bp orequire'debugger';debugger<esc>:w<cr>

"
" ----------------------------------------------------------------------------
"
" because otherwise rvm and zsh won't play nice when you use terminal commands
" set shell=bash
" set shell=$SHELL\ -l
