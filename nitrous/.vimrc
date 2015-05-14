runtime! debian.vim

" Turn on syntax highlighting.
" Color schemes are located in ~/.vim/colors/
if has("syntax")
  syntax on
  if $COLORTERM == 'gnome-terminal'
    set term=gnome-256color " make sure to `sudo apt-get install ncurses-term` for this to work.
  endif
  set background=dark
  colorscheme railscasts
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

" Enable matchit plugin (required for ruby text-object)
runtime macros/matchit.vim

set laststatus=2 " Always show the statusline

set showcmd    " Show (partial) command in status line.
set showmatch  " Show matching brackets.
set ignorecase " Do case insensitive matching
set smartcase  " Do smart case matching
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

" Disable beeping and flashing on errors
set noerrorbells visualbell t_vb=
autocmd GUIEnter * set visualbell t_vb=


vnoremap . :norm.<CR>            " Allow for using dot command in insert mode
vnoremap <leader># :norm i#<CR>
vnoremap <leader>3 :norm x<CR>
map ` :NERDTreeToggle<CR>         " Use ` to toggle NERD Tree Sidebar
map <leader><leader> :nohl<CR>:set nopaste<CR>    " Use \\ to clear search highlighting and paste mode
nmap <F1> <ESC>                   " Remap F1 to ESC to prevent it from opening help
nmap <leader>ws :%s/\s\+$//g<CR><c-o>  " Remove all trailing whitespace
nmap ~ :FufCoverageFile<CR>
nmap <CR> :!
nmap <leader>diff :!git diff --color
nmap <leader>blame :!git blame %
nmap <c-l> :vsp<CR><c-p>
nmap <c-k> :new<CR><c-p>

" Better window resizing
nmap <LEFT> <c-w><
nmap <RIGHT> <c-w>>
nmap <UP> <c-w>+
nmap <DOWN> <c-w>-
nmap <c-w><LEFT> 40<LEFT>
nmap <c-w><RIGHT> 40<RIGHT>
nmap <c-w><UP> 40<UP>
nmap <c-w><DOWN> 40<DOWN>

" Remap c-w to c-e for Nitrous (to prevent tab closing)
nmap <c-e>j <c-w>j
nmap <c-e>k <c-w>k
nmap <c-e>l <c-w>l
nmap <c-e>h <c-w>h

" Highlight trailing whitespace and all tabs
:highlight ExtraWhitespace ctermbg=red guibg=red
:match ExtraWhitespace /\s\+$\|\t/

" Filetype mappings
autocmd BufNewFile,BufRead *.htm.erb set filetype=html
autocmd BufNewFile,BufRead *.html.erb set filetype=html
autocmd BufNewFile,BufRead *.coffee.erb set filetype=coffee
autocmd BufNewFile,BufRead *Gemfile* set filetype=ruby
autocmd BufNewFile,BufRead *.g set syntax=antlr3
autocmd BufNewFile,BufRead *.e set syntax=ruby

" Autocompile coffeescript on save
" Disabled for now. Use the built in tool in Harmony instead.
"autocmd BufWritePost,FileWritePost *.coffee :silent !coffee -o htdocs/assets/javascript -c <afile>
