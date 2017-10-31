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

set wildmenu                " Show possible completions on command line
set wildmode=list:longest,full " List all options and complete
set wildignore=*.class,*.o,*~,*.pyc,.git,node_modules  " Ignore certain files in tab-completion

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
  Plug 'craigemery/vim-autotag'

  Plug 'tpope/vim-sensible'
  Plug 'tpope/vim-sleuth'
  Plug 'tpope/vim-rails'
  Plug 'tpope/vim-bundler'
  Plug 'tpope/vim-cucumber'
  Plug 'tpope/vim-obsession'

  " Provides navigation with [q ]q etc
  Plug 'tpope/vim-unimpaired'

  Plug 'junegunn/fzf', { 'dir': '~/.fzf', 'do': './install --all' }
  Plug 'tpope/vim-git'
  Plug 'tpope/vim-fugitive'


  " filesystem tree explorer
  Plug 'scrooloose/nerdtree'

"  Plug 'kien/ctrlp.vim'
  Plug 'junegunn/fzf.vim'
  Plug 'SirVer/ultisnips' | Plug 'honza/vim-snippets'
  Plug 'vim-syntastic/syntastic'
  "Plug 'neomake/neomake'

  " Color schemes
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
  Plug 'slim-template/vim-slim'

  Plug 'pangloss/vim-javascript'
  Plug 'tpope/vim-jdaddy' " json helpers

  Plug 'mxw/vim-jsx'
  Plug 'kchmck/vim-coffee-script'
  Plug 'posva/vim-vue'

  " markdown support
  " Plug 'godlygeek/tabular'
  Plug 'plasticboy/vim-markdown'

  " browse ruby documentation
  Plug 'danchoi/ri.vim'

  " functions for running ruby tests
  " Plug 'skalnik/vim-vroom'
  Plug 'janko-m/vim-test'
  " automatic end statement in ruby blocks => 'my-build'
  Plug 'tpope/vim-endwise'

  " adds ir and ar to select ruby blocks
  Plug 'kana/vim-textobj-user'
  Plug 'nelstrom/vim-textobj-rubyblock'

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

  Plug 'elixir-lang/vim-elixir'
  Plug 'slashmili/alchemist.vim'
  Plug 'lambdatoast/elm.vim'
  Plug 'keith/swift.vim'
  Plug 'brow/vim-xctool'
  Plug 'mattn/emmet-vim'
  Plug 'udalov/kotlin-vim'
  " Intelligent switching between relative & absolute
  " line numbers
  " can also toggle with C-n
  Plug 'jeffkreeftmeijer/vim-numbertoggle'

  " clojure
  Plug 'tpope/vim-leiningen'
  Plug 'tpope/vim-projectionist'
  Plug 'tpope/vim-dispatch'
  Plug 'tpope/vim-fireplace'

  " slime, used for ruby repl
  Plug 'jpalardy/vim-slime'

  " Plug 'tpope/vim-flagship'

call plug#end()

" Hide pyc files in nerdtree explorer
let NERDTreeIgnore = ['\.pyc$']

" Configuration for fuzzy file finding
" By default vim only shows status line when 2 or more windows open, this will
" always show it
set laststatus=2
set showtabline=2
set guioptions-=e
set statusline+=%#warningmsg#
"set statusline+=%{SyntasticStatuslineFlag()}
set statusline+=%*

let g:syntastic_swift_checkers = ['swiftlint']
let g:syntastic_always_populate_loc_list = 1
let g:syntastic_auto_loc_list = 1
let g:syntastic_check_on_open = 1
let g:syntastic_check_on_wq = 0
let g:syntastic_javascript_checkers=['eslint']
let g:syntastic_javascript_eslint_exe='$(npm bin)/eslint'
" Prevent syntastic from checking handlebars files as html
let g:syntastic_mode_map={ 'mode': 'active',
                     \ 'active_filetypes': [],
                     \ 'passive_filetypes': ['html','java','javascript'] }

" Run Neomake on save
" autocmd! BufWritePost * Neomake
"let g:neomake_javascript_eslint_exe='$(npm bin)/eslint'
let g:neomake_javascript_enabled_makers = ['eslint']
" let's surround.vim know about <%=
let g:surround_{char2nr('=')} = "<%= \r %>"
let g:surround_{char2nr('-')} = "<% \r %>"

" Key maps and configuration for running tests from editor
let test#strategy='vimux'
" let g:vroom_use_vimux = 1
" let g:vroom_test_unit_command = "rails test"

" I don't need a map to clear highlighting
let g:LoupeCenterResults=0 

" Let vim recognize nginx files
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


let g:slime_target = "tmux"

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

nmap <leader>n :NERDTreeCWD<CR>
nmap <leader>b :Buffers<CR>
nmap <leader>f :Files<CR>
nmap <leader>. :Tags<CR>
nmap <leader>q :TagbarToggle<cr>
nmap <Leader>a :Ag<CR>
nmap <silent> <leader>t :TestNearest<CR>
nmap <silent> <leader>T :TestFile<CR>
nmap <silent> <leader>l :TestLast<CR>
nmap ,ss <Plug>SlimeLineSend
"" Use ctrl-[hjkl] to select the active split!
nmap <silent> <c-k> :wincmd k<CR>
nmap <silent> <c-j> :wincmd j<CR>
nmap <silent> <c-h> :wincmd h<CR>
nmap <silent> <c-l> :wincmd l<CR>

"" Shortcuts to goto definition in new tabs or splits
" map <c-\> :tab split<CR>:exec("tag ".expand("<cword>"))<CR>
nmap g\ :vsp <CR>:exec(":tag ".expand("<cword>"))<CR>

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

function! RunEmberTest()
  let lineNumber = line('.')

  while lineNumber > 0
    let test = matchlist(getline(lineNumber), '^test \(.*\), ->$')
    if len(test) > 0
      exe "!ember test --filter ".substitute(test[1], '"', '\\"', 'g'))
    else
      let lineNumber -= 1
    endif
  endwhile
endfunction
