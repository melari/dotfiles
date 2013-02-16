runtime! debian.vim

" Turn on syntax highlighting.
" Color schemes are located in ~/.vim/colors/
if has("syntax")
  syntax on
  if $COLORTERM == 'gnome-terminal'
    set term=gnome-256color " make sure to `sudo apt-get install ncurses-term` for this to work.
  endif
  colorscheme railscasts
  set background=dark
endif

" Load filetype dependant indentation
" Indentation files are located in ~/.vim/indent/
if has("autocmd")
  filetype plugin indent on
endif

" Source a global configuration file if available
if filereadable("/etc/vim/vimrc.local")
  source /etc/vim/vimrc.local
endif

set showcmd		 " Show (partial) command in status line.
set showmatch	 " Show matching brackets.
set ignorecase " Do case insensitive matching
set smartcase	 " Do smart case matching
set mouse=a		 " Enable mouse usage (all modes)
set cindent
set smartindent
set autoindent
set expandtab
set tabstop=2
set shiftwidth=2
set number
set cursorline
set ic            " Incremental Search
set hls           " Highlight Search
set is 


:vnoremap . :norm.<CR>          " Allow for using dot command in insert mode
map ` :NERDTreeToggle<CR>       " Use ` to toggle NERD Tree Sidebar
map <leader><leader> :nohl<CR>  " Use \\ to clear search highlighting
nmap <F1> <ESC>                 " Remap F1 to ESC to prevent it from opening help
