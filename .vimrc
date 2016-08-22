"  ==============================================================================
"                       ~~ Installation Instructions ~~
"
" * Run :PlugInstall to install all vim extensions listed below.
" * Run :PlugUpdate to update all vim extensions
" * Run :PlugClean to remove unused extensions
" * After cpsm is installed, it requires some additional python compiliation:
"     $ cd ~/.vim/plugged/cpsm
"     $ mkdir build
"     $ cd build
"     $ cmake -DPY3:BOOL=OFF ..
"     $ make install
" * After vim-airline is installed, a patched font is required. Install by
"   double clicking the font, then select it in iTerm (make sure to do it for
"   both the ascii and non-ascii fonts!)
" * Exuberant ctags must be installed for goto-definition features:
"    $ brew install ctags-exuberant
" * Ctags need to be manually generated the first time you open a project:
"    $ ctags -R .
" * After this is done once, the vim-easytags plugin will keep them up to date.
" * After vimproc is installed, it requires additional c compiliation:
"     $ cd ~/.vim/plugged/vimproc
"     $ make
"  =============================================================================
"
"                        ~~ Handy Command Reference ~~
"
"        Command      |   Description
"  -------------------|---------------------------------------------------------
"   :CoffeeWatch vert | Open preview of generated javascript
"   :G <pattern>      | Git Grep the current project
"   :Tab /<pattern>   | Align text along the pattern
"   <c-p>             | Open ctrl-p fuzzy finder
"   :HeaderDecrease   | decrease level of all headers in buffer (markdown)
"   :HeaderIncrease   | increase level of all headers in buffer (markdown)
"   :Toc              | Open a table of contents of the markdown file
"   zc & zo           | Close and Open vim folds respectively
"   QQ                | Open QQ request buffer (or run request)
"   QH                | Open QQ request history
"   QAB               | Add basic auth header to current request
"   QAO               | Add oAuth2 to the current request
"   :ToGithub         | Opens the current line in the github repo
"   :Rename <name>    | Renames the current open file to <name>
"   :so %             | Source the current buffer
"   :Gblame           | Show inline blame of current file
"   gS                | split 1 line into multiple
"   gJ                | combine block into 1 line
"  =============================================================================


" === Plugins === "
call plug#begin('~/.vim/plugged')

Plug 'https://github.com/scrooloose/syntastic.git'                                     " Adds in-line syntax error highlighting
Plug 'https://github.com/tpope/vim-rails.git'                                      " Adds rails syntax support
Plug 'https://github.com/jelera/vim-javascript-syntax.git'                         " Adds better javascript syntax support
Plug 'https://github.com/kchmck/vim-coffee-script.git'                             " Adds coffee-script syntax support
Plug 'https://github.com/plasticboy/vim-markdown.git'                              " Adds markdown syntax support
Plug 'https://github.com/elzr/vim-json.git'                                        " Adds JSON syntax support
Plug 'https://github.com/StanAngeloff/php.vim.git'                                 " Adds better PHP syntax support
Plug 'https://github.com/captbaritone/better-indent-support-for-php-with-html.git' " Adds html/php auto-indent support
Plug 'https://github.com/ap/vim-css-color.git'                                     " Adds css color previews
Plug 'https://github.com/gregsexton/MatchTag.git'                                  " Adds HTML end tag matching
Plug 'https://github.com/scrooloose/nerdtree.git'                                  " Adds directory browser
Plug 'https://github.com/bling/vim-airline.git'                                    " Adds airline status bar
Plug 'https://github.com/godlygeek/tabular.git'                                    " Adds support for aligning text (use :Tab /=> for ex)
"Plug 'https://github.com/xolox/vim-easytags.git'                                   " Keeps ctags up to date automatically
"Plug 'https://github.com/xolox/vim-misc.git'                                       " Dependency of vim-easytags
Plug 'https://github.com/kien/ctrlp.vim.git'                                       " Adds fuzzy finder
Plug 'https://github.com/nixprime/cpsm.git'                                        " Matcher for ctrlp specialized for paths
Plug 'https://github.com/airblade/vim-gitgutter.git'                               " Adds git change notations to the side gutter
Plug 'https://github.com/nicwest/QQ.vim.git'                                       " Curl wrapper
Plug 'https://github.com/tonchis/vim-to-github.git'                                " Adds the :ToGithub command
Plug 'https://github.com/vim-scripts/Rename.git'                                   " Adds :Rename command
Plug 'https://github.com/tpope/vim-fugitive.git'                                   " Adds git commands such as :Gblame
Plug 'https://github.com/AndrewRadev/splitjoin.vim.git'                            " Adds splitting/joining of ruby lines
Plug 'https://github.com/groenewege/vim-less.git'                                  " Adds less syntax highlighting
Plug 'https://github.com/evidens/vim-twig.git'                                     " Adds twig syntax highlighting

call plug#end()


" === SYNTAX HIGHLIGHTING / EDITOR CONFIGURATION === "
syntax on
colorscheme railscasts
filetype plugin indent on
set laststatus=2                            " Always show the statusline
set backspace=2                             " Allow deleting characters not entered during the current insert mode with backspace
set showcmd                                 " Show partial command in status line
set showmatch                               " Show matching brackets
set smartcase                               " Do smart case matching
set cindent smartindent autoindent          " Automatic indenting
set expandtab tabstop=2 shiftwidth=2        " Use 2 space tabs
set number                                  " Show line numbers
set cursorline                              " Highlight the current line being edited
set ic                                      " Use incremental search
set hls is                                  " Highlight search results (and partial results)
set noerrorbells visualbell t_vb=           " Disable beeping and flashing on errors
set foldmethod=indent foldlevelstart=20     " Use the syntax definition to decide where to fold
set synmaxcol=200                           " Only bother highlighting the first 200 characters of a line before giving up
autocmd GUIEnter * set visualbell t_vb=     " Disable beeping and flashing on errors
highlight Pmenu ctermfg=73 ctermbg=15|      " Custom colors for autocomplete menu
highlight PmenuSel ctermfg=255 ctermbg=88|  " Custom colors for autocomplete menu (selected item)
highlight TrailingWhitespace ctermbg=red|   " Highlight extra whitespace
match TrailingWhitespace /\s\+$/         " Defines what trailing whitespace is
let g:airline_powerline_fonts=1|            " Enable patched airline statusbar font
let g:syntastic_always_populate_loc_list=1| " Populate location-list automatically
let g:syntastic_auto_loc_list=1|            " Automatically open the location-list
let g:syntastic_check_on_open=1|            " Check for syntax errors when first loading the buffer
let g:syntastic_check_on_wq=0|              " Don't bother checking syntax errors on :wq
let g:syntastic_eruby_ruby_quiet_messages = {'regex': 'possibly useless use of .* in void context'} " Hide these evil warnings
let g:syntastic_html_tidy_quiet_messages = {'regex': 'trimming empty .*'}
let g:syntastic_ruby_checkers = ["mri", "rubocop"] " Include rubocop checker as well.
let g:ctrlp_match_func = {'match': 'cpsm#CtrlPMatch'} " Tell ctrlp to use cpsm


" === KEY MAPPINGS === "
nnoremap ` :NERDTreeToggle<CR>|                      " Open directory browser
nnoremap <c-l> :vsp<CR>:CtrlP<CR>|                " Open fuzzy finder (in a new vertically split window)
nnoremap <c-k> :new<CR>:CtrlP<CR>|                " Open fuzzy finder (in a new horizontally split window)
nnoremap q: :q|                                      " Common typo that would open an annoying panel
nnoremap K Vk|                                       " Common typo that closes vim momentarily
nnoremap J Vj|                                       " Common typo that joins a line
nnoremap <leader><leader> :nohl<CR>:set nopaste<CR>| " Used to reset back to default editing mode after a search, replace, or paste
nnoremap <leader>ws :%s/\s\+$//g<CR><c-o>|           " Remove all trailing whitespace
nnoremap <LEFT> <c-w><|                              " Decrease current window width
nnoremap <RIGHT> <c-w>>|                             " Increase current window width
nnoremap <UP> <c-w>+|                                " Increase current window height
nnoremap <DOWN> <c-w>-|                              " Decrease current window height
nnoremap j gj|                                       " Allows easier nav on wrapped lines
nnoremap k gk|                                       " Allows easier nav on wrapped lines
vnoremap j gj|                                       " Allows easier nav on wrapped lines
vnoremap k gk|                                       " Allows easier nav on wrapped lines
vnoremap . :norm.<CR>|                               " Execute last command sequence over all selected lines
vnoremap <leader># :norm i#<CR>|                     " Comment out selected lines
vnoremap <leader>3 :norm x<CR>|                      " Uncomment selected lines


" === FILETYPE MAPPINGS === "
autocmd BufNewFile,BufRead *Gemfile*  set filetype=ruby


" === MORE INVOLVED CUSTOMIZATIONS === "

" Make sure pasting in visual mode doesn't replace the paste buffer
function! RestoreRegister()
  let @" = s:restore_reg
  return ''
endfunction
function! s:Repl()
  let s:restore_reg = @"
  return "p@=RestoreRegister()\<cr>"
endfunction
vmap <silent> <expr> p <sid>Repl()


" Adds command :G <pattern> to do fast git grepping
function! GitGrep(...)
  let save = &grepprg
  set grepprg=git\ grep\ -n\ $*
  let s = 'grep'
  for i in a:000
    let s = s . ' ' . i
  endfor
  exe s
  let &grepprg = save
endfun
command! -nargs=? G call GitGrep(<f-args>)
