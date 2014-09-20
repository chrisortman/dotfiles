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

set hlsearch
set incsearch
set nu!

" Display tabs and trailing spaces
set list listchars=tab:\ \ ,trail:·

" =============== Folds ===============
set foldmethod=indent
set foldnestmax=3
set nofoldenable

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
" set noantialias
endif


" BUNDLES 
" enable vundle
set rtp+=~/.vim/bundle/vundle/
call vundle#rc()

Bundle 'gmarik/vundle'

" regenerate tags file on save
Bundle 'craigemery/vim-autotag'

Bundle 'tpope/vim-rails.git'

" FuzzyFinder
Bundle 'L9'
Bundle 'FuzzyFinder'
Bundle 'tpope/vim-git'

" filesystem tree explorer
Bundle "scrooloose/nerdtree.git"

Bundle 'kien/ctrlp.vim'

let g:ctrlp_map = '<leader>f'
let g:ctrlp_max_height = 30
let g:ctrlp_match_window_bottom=1
let g:ctrlp_max_height = 20
let g:ctrlp_match_window_reversed = 1
let g:ctrlp_switch_buffer = 'e'


Bundle 'gmarik/ingretu'
Bundle 'altercation/vim-colors-solarized'
Bundle 'jnurmine/Zenburn'
" surround
Bundle 'tpope/vim-surround'

" let's surround.vim know about <%=
let g:surround_{char2nr('=')} = "<%= \r %>"
let g:surround_{char2nr('-')} = "<% \r %>"

" comment
Bundle 'tomtom/tcomment_vim'
" convert words
Bundle 'tpope/vim-abolish'
Bundle 'tpope/vim-repeat'

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

" HTML zen coding
Bundle 'mattn/emmet-vim'

Bundle 'kongo2002/fsharp-vim'
Bundle 'pangloss/vim-javascript'
Bundle 'mxw/vim-jsx'

" ack support
Bundle 'mileszs/ack.vim'

" tmux integration
Bundle 'benmills/vimux'
Bundle 'christoomey/vim-tmux-navigator'

syntax enable
set background=light
if !has("gui_running")
    let g:solarized_termcolors=16
    set background=dark
endif
set background=dark
colorscheme solarized

filetype plugin indent on        " vundle  required!

"##############################################################################                                                                         
"" Easier split navigation                                                                                                                               
"##############################################################################                                                                         
"
"" Use ctrl-[hjkl] to select the active split!
nmap <silent> <c-k> :wincmd k<CR>                                                                                                                       
nmap <silent> <c-j> :wincmd j<CR>                                                                                                                       
nmap <silent> <c-h> :wincmd h<CR>                                                                                                                       
nmap <silent> <c-l> :wincmd l<CR>

" put useful info in status bar
if has('gui_running')
set statusline=%F%m%r%h%w\ %{fugitive#statusline()}\ [%l,%c]\ [%L,%p%%]
  " highlight the status bar when in insert mode
  if version >= 700
    au InsertEnter * hi StatusLine ctermfg=235 ctermbg=2
    au InsertLeave * hi StatusLine ctermbg=240 ctermfg=12
  endif
endif


" run specs with ',t' via Gary Bernhardt
function! RunTests(filename)
  " Write the file and run tests for the given filename
  :w
  :silent !clear
  if match(a:filename, '\.feature$') != -1
    exec ":!script/features " . a:filename
  elseif match(a:filename, '_test\.rb$') != -1
    exec ":!ruby -Itest " . a:filename
  else
    if filereadable("script/test")
      exec ":!script/test " . a:filename
    elseif filereadable("Gemfile")
      exec ":!bundle exec rspec --color " . a:filename
    else
      exec ":!rspec --color " . a:filename
    end
  end
endfunction

function! SetTestFile()
  " set the spec file that tests will be run for.
  let t:grb_test_file=@%
endfunction

function! RunTestFile(...)
  if a:0
    let command_suffix = a:1
  else
    let command_suffix = ""
  endif

  " run the tests for the previously-marked file.
  let in_test_file = match(expand("%"), '\(.feature\|_spec.rb\|_test.rb\)$') != -1
  if in_test_file
    call SetTestFile()
  elseif !exists("t:grb_test_file")
    return
  end
  call RunTests(t:grb_test_file . command_suffix)
endfunction

function! RunNearestTest()
  let spec_line_number = line('.')
  call RunTestFile(":" . spec_line_number . " -b")
endfunction

function! RSpecCurrent()
    execute("!clear && rake spec SPEC=" . expand("%p") . ":" . line("."))
endfunction
" run test runner
map <leader>t :call RunTestFile()<cr>
map <leader>T :call RunNearestTest()<cr>
" map <leader>r :w\|:call RSpecCurrent()<cr>

map <leader>n :NERDTreeCWD<CR>
map <leader>b :CtrlPBuffer<cr>
map <leader>. :CtrlPTag<cr>
map <leader>q :TagbarToggle<cr>

map rp :VimuxPromptCommand<cr>
map rl :VimuxRunLastCommand<cr>
map ri :VimuxInspectRunner<cr>
map rc :VimuxCloseRunner<cr>

"clear search when you hit esc
" Works around problem in term where vim starts in replace mode
" http://stackoverflow.com/questions/11940801/mapping-esc-in-vimrc-causes-bizzare-arrow-behaviour
if has('gui_running')
  nnoremap <silent> <esc> :nohlsearch<cr><esc>
else
  augroup no_highlight
    autocmd TermResponse * nnoremap <esc> :noh<cr><esc>
  augroup END
end

" because otherwise rvm and zsh won't play nice when you use terminal commands
 set shell=bash
