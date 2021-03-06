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
" https://github.com/neoclide/coc.nvim
" You will have bad experience for diagnostic messages when it's default 4000.
set updatetime=300
set hlsearch
set incsearch
set nu!
" Use the old vim regex engine (version 1, as opposed to version 2, which was
" introduced in Vim 7.3.969). The Ruby syntax highlighting is significantly
" slower with the new regex engine.
set re=1

" Display tabs and trailing spaces
set list listchars=tab:\ \ ,trail:·

set wildmenu                " Show possible completions on command line
set wildmode=list:longest,full " List all options and complete
set wildignore=*.class,*.o,*~,*.pyc,.git,node_modules  " Ignore certain files in tab-completion

let mapleader = ","

" Font
set guifont=JetBrainsMonoNL-Regular:h13
if has('mac')
  "set noantialias
endif

set splitbelow
set splitright

runtime macros/matchit.vim

" Suppress python3 warning
" https://github.com/vim/vim/issues/3117
if has('python3')
  silent! python3 1
endif

" BUNDLES 
call plug#begin('~/.vim/plugged')

  let g:UltiSnipsExpandTrigger="<tab>"
  " Never seen this work
  let g:UltiSnipsListSnippets="<c-s>"
  let g:UltiSnipsEditSplit="vertical"
  let g:UltiSnipsSnippetDirectories=[$HOME.'/Documents/UltiSnips',"UltiSnips"]

  " Color schemes
  Plug 'chrisortman/vim-monokai'
  Plug 'tomasr/molokai'
  Plug 'danilo-augusto/vim-afterglow'
  Plug 'fmoralesc/molokayo'
  Plug 'patstockwell/vim-monokai-tasty'

  " General editing support
  Plug 'scrooloose/nerdtree'
  Plug 'justinmk/vim-dirvish'
  "Plug 'tpope/vim-projectionist'
  Plug 'jpalardy/vim-slime'
  Plug 'AndrewRadev/splitjoin.vim'
  Plug 'neoclide/coc.nvim', {'branch': 'release'}
  Plug 'kana/vim-textobj-user'
  Plug 'wincent/loupe'
  Plug 'rking/ag.vim'
  " Seems incompatible with vim coc
  Plug 'tpope/vim-endwise'
  Plug 'ntpeters/vim-better-whitespace'
  Plug 'SirVer/ultisnips'
  Plug 'tpope/vim-unimpaired'
  Plug '/usr/local/opt/fzf'
  Plug 'junegunn/fzf.vim'
  Plug 'tpope/vim-git'
  Plug 'tpope/vim-fugitive'
  Plug 'tpope/vim-sensible'
  Plug 'tpope/vim-sleuth'
  Plug 'jremmen/vim-ripgrep'
  Plug 'stefandtw/quickfix-reflector.vim'
  Plug 'godlygeek/tabular.git'
  Plug 'majutsushi/tagbar'

  " Tmux integration
  Plug 'christoomey/vim-tmux-navigator'
  Plug 'benmills/vimux'
  Plug 'tomtom/tcomment_vim'
  Plug 'tpope/vim-surround'
  Plug 'tpope/vim-repeat'


  " Specific language support
  " clojure
  Plug 'tpope/vim-leiningen'
  Plug 'tpope/vim-dispatch'
  Plug 'tpope/vim-fireplace'
  Plug 'elixir-editors/vim-elixir'
  Plug 'keith/swift.vim'
  Plug 'udalov/kotlin-vim'
  Plug 'honza/dockerfile.vim'
  Plug 'rust-lang/rust.vim'
  " adds ir and ar to select ruby blocks
  Plug 'nelstrom/vim-textobj-rubyblock'
  Plug 'plasticboy/vim-markdown'
  Plug 'mustache/vim-mustache-handlebars'
  Plug 'vim-ruby/vim-ruby'

  Plug 'tpope/vim-jdaddy' " json helpers
  Plug 'tpope/vim-rails'
  Plug 'janko/vim-test'
  Plug 'cespare/vim-toml'
  " slime, used for ruby repl

  "javascript
  Plug 'othree/yajs.vim'
  Plug 'othree/javascript-libraries-syntax.vim'
  Plug 'othree/es.next.syntax.vim'
  Plug 'moll/vim-node'
  Plug 'leafgarland/typescript-vim'
  Plug 'peitalin/vim-jsx-typescript'
call plug#end()

let g:vimwiki_list = [{'path': '~/Documents/wiki/'}]
" Hide pyc files in nerdtree explorer
let NERDTreeIgnore = ['\.pyc$', '\.egg-info$', '__pycache__', '__pycache__']

" Configuration for fuzzy file finding
" By default vim only shows status line when 2 or more windows open, this will
" always show it
set laststatus=2
set showtabline=2
set guioptions-=e

let g:ale_lint_on_text_changed='never'
let g:ale_lint_on_enter = 0
" let's surround.vim know about <%=
let g:surround_{char2nr('=')} = "<%= \r %>"
let g:surround_{char2nr('-')} = "<% \r %>"

" Key maps and configuration for running tests from editor
let test#strategy='vimux'

" I don't need a map to clear highlighting
let g:LoupeCenterResults=0 

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

if exists("$TMUX")
  let g:slime_target = "tmux"
else
  let g:slime_target = "vimterminal"
endif

syntax on
filetype plugin indent on        " vundle  required!
"set omnifunc=syntaxcomplete#Complete

" Get horrible lag in large ruby files
" Interesting thread here https://github.com/vim/vim/issues/282
set lazyredraw

" let g:molokai_original=1
let g:rehash256=1
set t_Co=256
" colorscheme molokai
let g:afterglow_inherit_background=1
" 2nd favorite colorscheme molokayo
colorscheme molokai

" map .docker file to docker syntax
au! BufNewFile,BufRead *.dockerfile set filetype=dockerfile

" map ecma script 6 syntax to javascript
autocmd BufRead,BufNewFile *.es6 setfiletype javascript

" Add ruby syntax highlighting for Thorfile, Rakefile, Vagrantfile and Gemfile
au BufRead,BufNewFile {Gemfile,Guardfile,Rakefile,Vagrantfile,Thorfile,config.ru,Fastfile,app.god,Eyefile,*.eye} set ft=ruby
"
" Add haml syntax highlighting for .hamlc
au BufRead,BufNewFile *.thor set ft=ruby

" Jump to last cursor position unless it's invalid or in an event handler
autocmd BufReadPost *
      \ if line("'\"") > 0 && line("'\"") <= line("$") |
      \   exe "normal g`\"" |
      \ endif

" Allow highlighting of fenced code blocks in markdown files
au BufNewFile,BufReadPost *.md set filetype=markdown
let g:markdown_fenced_languages = ['coffee', 'css', 'erb=eruby', 'javascript', 'js=javascript', 'json=javascript', 'ruby', 'sass', 'xml', 'html']

nmap <leader>n :NERDTreeCWD<CR>
nmap <leader>b :Buffers<CR>
nmap <leader>f :GFiles<CR>
nmap <leader>F :Files<CR>
nmap <leader>. :Tags<CR>
nmap <leader>q :TagbarToggle<CR>
nmap <Leader>a :Rg<CR>
nmap <silent> <leader>t :TestNearest<CR>
nmap <silent> <leader>T :TestFile<CR>
nmap <silent> <leader>l :TestLast<CR>
nmap ,ss <Plug>SlimeLineSend

"" Use ctrl-[hjkl] to select the active split!
nmap <silent> <c-k> :wincmd k<CR>
nmap <silent> <c-j> :wincmd j<CR>
nmap <silent> <c-h> :wincmd h<CR>
nmap <silent> <c-l> :wincmd l<CR>

map rp :VimuxPromptCommand<cr>
map rl :VimuxRunLastCommand<cr>
map ri :VimuxInspectRunner<cr>
map rc :VimuxCloseRunner<cr>

nnoremap <Space> za

imap <c-l> <space>=><space>

"clear search when you hit esc
" Works around problem in term where vim starts in replace mode
" http://stackoverflow.com/questions/11940801/mapping-esc-in-vimrc-causes-bizzare-arrow-behaviour
if has('gui_running')
  nnoremap <silent> <esc> :nohlsearch<cr><esc>
else
  nnoremap <cr> :noh<cr><cr>
end

""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" SHORTCUT TO REFERENCE CURRENT FILE'S PATH IN COMMAND LINE MODE
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
cnoremap <expr> %% expand('%:h').'/'

function! UseMonokai()
  set background=dark
  colorscheme monokai
endfunction


"
" ----------------------------------------------------------------------------
"
" because otherwise rvm and zsh won't play nice when you use terminal commands
set shell=/bin/zsh
" set shell=$SHELL\ -l
