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
" enable vundle
set rtp+=~/.vim/bundle/Vundle.vim
call vundle#begin()

Plugin 'gmarik/vundle'

" regenerate tags file on save
Plugin 'craigemery/vim-autotag'

Plugin 'tpope/vim-sensible'
Plugin 'tpope/vim-sleuth.git'
Plugin 'tpope/vim-rails.git'
Plugin 'tpope/vim-bundler'
Plugin 'tpope/vim-cucumber'
Plugin 'tpope/vim-obsession.git'
Plugin 'tpope/vim-unimpaired'

" FuzzyFinder
Plugin 'L9'
Plugin 'FuzzyFinder'
Plugin 'tpope/vim-git'
Plugin 'tpope/vim-fugitive'
Plugin 'airblade/vim-gitgutter'


" filesystem tree explorer
Plugin 'scrooloose/nerdtree'

Plugin 'kien/ctrlp.vim'

let g:ctrlp_map = '<leader>f'
let g:ctrlp_max_height = 30
let g:ctrlp_match_window_bottom=1
let g:ctrlp_max_height = 20
let g:ctrlp_match_window_reversed = 1
let g:ctrlp_switch_buffer = 'e'

Plugin 'tpope/vim-flagship'
" By default vim only shows status line when 2 or more windows open, this will
" always show it
set laststatus=2
set showtabline=2
set guioptions-=e

Plugin 'gmarik/ingretu'
Plugin 'altercation/vim-colors-solarized'
Plugin 'jnurmine/Zenburn'
" Plugin 'crusoexia/vim-monokai'
Plugin 'chrisortman/vim-monokai'

" surround
Plugin 'tpope/vim-surround'

" let's surround.vim know about <%=
let g:surround_{char2nr('=')} = "<%= \r %>"
let g:surround_{char2nr('-')} = "<% \r %>"

" convert words
Plugin 'tpope/vim-abolish'
Plugin 'tpope/vim-repeat'

" comment
Plugin 'tomtom/tcomment_vim'
Plugin 'tomtom/tinykeymap_vim'

" shows info from tags file for current file in side bar
Plugin 'majutsushi/tagbar'

" show and clean whitespace
Plugin 'ntpeters/vim-better-whitespace'

Plugin 'vim-ruby/vim-ruby'
" better folding, only methods, classes & it blocks
Plugin 'vim-utils/vim-ruby-fold'
"----- additional text objects-----

" came & snake case words
" Plugin 'bkad/CamelCaseMotion' 

"----------------------------------

" Mustache / handlebars
Plugin 'mustache/vim-mustache-handlebars'

" Slim
Plugin 'slim-template/vim-slim.git'

Plugin 'kongo2002/fsharp-vim'
Plugin 'pangloss/vim-javascript'
Plugin 'mxw/vim-jsx'
Plugin 'kchmck/vim-coffee-script'

" markdown support
Plugin 'godlygeek/tabular'
Plugin 'plasticboy/vim-markdown'

" browse ruby documentation
Plugin 'danchoi/ri.vim'

" functions for running ruby tests
Plugin 'skalnik/vim-vroom'

let g:vroom_use_vimux = 1
let g:vroom_test_unit_command = "m"

" automatic end statement in ruby blocks
Plugin 'tpope/vim-endwise'

" adds ir and ar to select ruby blocks
Plugin 'kana/vim-textobj-user'
Plugin 'nelstrom/vim-textobj-rubyblock'

" Adds argument text object
Plugin 'vim-scripts/argtextobj.vim'

" gS and gJ to split & join code blocks
Plugin 'AndrewRadev/splitjoin.vim'

" ag support
Plugin 'rking/ag.vim'

" make incremental search results easier to see
Plugin 'wincent/loupe'
" I don't need a map to clear highlighting
let g:LoupeCenterResults=0 

" Enhanced multi file search
Plugin 'wincent/ferret'
" rust lang
Plugin 'rust-lang/rust.vim'
" nginx config file highlighting
Plugin 'evanmiller/nginx-vim-syntax'
au! BufRead,BufNewFile /etc/nginx/*,*/nginx/nginx.conf,*/nginx/conf.d/*,/usr/local/nginx/conf/* set filetype=nginx 

" tmux integration
Plugin 'benmills/vimux'
Plugin 'christoomey/vim-tmux-navigator'

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

" Intelligent switching between relative & absolute
" line numbers
" can also toggle with C-n
Plugin 'jeffkreeftmeijer/vim-numbertoggle'

" clojure
Plugin 'tpope/vim-leiningen'
Plugin 'tpope/vim-projectionist'
Plugin 'tpope/vim-dispatch'
Plugin 'tpope/vim-fireplace'

" slime, used for ruby repl
Plugin 'jpalardy/vim-slime'
let g:slime_target = "tmux"
nmap ,ss <Plug>SlimeLineSend

Plugin 'honza/dockerfile.vim'

Plugin 'mtth/scratch.vim'
let g:scratch_no_mappings = 1
let g:scratch_insert_autohide=0
let g:scratch_autohide=0
nmap <leader>gs <plug>(scratch-insert-reuse)
xmap <leader>gs <plug>(scratch-selection-reuse)

Plugin 'elixir-lang/vim-elixir'
Plugin 'lambdatoast/elm.vim'

call vundle#end()
syntax on
filetype plugin indent on        " vundle  required!
set omnifunc=syntaxcomplete#Complete

" Get horrible lag in large ruby files
" Interesting thread here https://github.com/vim/vim/issues/282
set lazyredraw

colorscheme monokai



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
 set shell=bash
