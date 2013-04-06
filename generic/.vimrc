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

" Enable matchit plugin (required for ruby text-object)
runtime macros/matchit.vim

set laststatus=2 " Always show the statusline

set showcmd    " Show (partial) command in status line.
set showmatch  " Show matching brackets.
set ignorecase " Do case insensitive matching
set smartcase  " Do smart case matching
set mouse=a    " Enable mouse usage (all modes)
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
map <leader><leader> :nohl<CR>    " Use \\ to clear search highlighting
nmap <F1> <ESC>                   " Remap F1 to ESC to prevent it from opening help
nmap <leader>ws :%s/\s\+$//g<CR><c-o>  " Remove all trailing whitespace
nmap ~ :FufCoverageFile<CR>
nmap <CR> :!
nmap <leader>diff :!git diff --color
nmap <leader>blame :!git blame %
nmap <c-l> :vsp<CR><c-p>
nmap <c-k> :new<CR><c-p>

" Highlight trailing whitespace and all tabs
:highlight ExtraWhitespace ctermbg=red guibg=red
:match ExtraWhitespace /\s\+$\|\t/

" Filetype mappings
autocmd BufNewFile,BufRead *.htm.erb set filetype=html
autocmd BufNewFile,BufRead *.html.erb set filetype=html
autocmd BufNewFile,BufRead *.coffee.erb set filetype=coffee
autocmd BufNewFile,BufRead Gemfile set filetype=ruby


"===== matcher ctrlP support ====="
let g:path_to_matcher = "/usr/local/bin/matcher"

let g:ctrlp_user_command = ['.git/', 'cd %s && git ls-files . -co --exclude-standard']

let g:ctrlp_match_func = { 'match': 'GoodMatch' }

function! GoodMatch(items, str, limit, mmode, ispath, crfile, regex)

  " Create a cache file if not yet exists
  let cachefile = ctrlp#utils#cachedir().'/matcher.cache'
  if !( filereadable(cachefile) && a:items == readfile(cachefile) )
    call writefile(a:items, cachefile)
  endif
  if !filereadable(cachefile)
    return []
  endif

  " a:mmode is currently ignored. In the future, we should probably do
  " something about that. the matcher behaves like "full-line".
  let cmd = g:path_to_matcher.' --limit '.a:limit.' --manifest '.cachefile.' '
  if !( exists('g:ctrlp_dotfiles') && g:ctrlp_dotfiles )
    let cmd = cmd.'--no-dotfiles '
  endif
  let cmd = cmd.a:str

  return split(system(cmd), "\n")

endfunction
"=====  =====  =====  =====  ====="
