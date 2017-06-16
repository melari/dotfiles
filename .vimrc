"  ==============================================================================
"                       ~~ Installation Instructions ~~
"
" * Run :PlugInstall to install all vim extensions listed below.
" * Run :PlugUpdate to update all vim extensions
" * Run :PlugClean to remove unused extensions
" * After vim-airline is installed, a patched font is required. Install by
"   double clicking the font, then select it in iTerm (make sure to do it for
"   both the ascii and non-ascii fonts!)
" * Exuberant ctags must be installed for goto-definition features:
"    $ brew install ctags-exuberant [OSX]
"    $ sudo apt-get install exuberant-ctags [LINUX]
" * Ctags need to be manually generated the first time you open a project:
"    $ ctags -R .
" * After this is done once, the vim-easytags plugin will keep them up to date.
" * After vimproc is installed, it requires additional c compiliation:
"     $ cd ~/.vim/plugged/vimproc
"     $ make
" * Make sure to install FZF:
"     $ brew install fzf
"     $ /usr/local/opt/fzf/install
"  =============================================================================
"
"                        ~~ Handy Command Reference ~~
"
"        Command      |   Description
"  -------------------|---------------------------------------------------------
"   :CoffeeWatch vert | Open preview of generated javascript
"   :G <pattern>      | Git Grep the current project
"   :Tab /<pattern>   | Align text along the pattern
"   <c-p>             | Open FZF fuzzy finder
"   :HeaderDecrease   | decrease level of all headers in buffer (markdown)
"   :HeaderIncrease   | increase level of all headers in buffer (markdown)
"   :Toc              | Open a table of contents of the markdown file
"   :Rename <name>    | Renames the current open file to <name>
"   :so %             | Source the current buffer
"   :Gblame           | Show inline blame of current file
"   :Gbrowse          | Opens the current line in the github repo
"   gS                | split 1 line into multiple
"   gJ                | combine block into 1 line
"   zf                | fold selected lines
"   zo                | open selected fold
"   tt                | copy current file name
"  =============================================================================


" === Plugins === "
call plug#begin('~/.vim/plugged')

Plug 'https://github.com/w0rp/ale.git'                                           " Async Lint Engine (ALE) - forked to include patch for bundled rubocop support
Plug 'https://github.com/tpope/vim-rails.git'                                      " Adds rails syntax support
Plug 'https://github.com/vim-ruby/vim-ruby.git'
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
" Plug 'https://github.com/xolox/vim-easytags.git'                                   " Keeps ctags up to date automatically
" Plug 'https://github.com/xolox/vim-misc.git'                                       " Dependency of vim-easytags
Plug 'https://github.com/airblade/vim-gitgutter.git'                               " Adds git change notations to the side gutter
Plug 'https://github.com/vim-scripts/Rename.git'                                   " Adds :Rename command
Plug 'https://github.com/tpope/vim-fugitive.git'                                   " Adds git commands such as :Gblame
Plug 'https://github.com/AndrewRadev/splitjoin.vim.git'                            " Adds splitting/joining of ruby lines
Plug 'https://github.com/groenewege/vim-less.git'                                  " Adds less syntax highlighting
Plug 'https://github.com/evidens/vim-twig.git'                                     " Adds twig syntax highlighting
Plug '/usr/local/opt/fzf' | Plug 'junegunn/fzf.vim'                                " FZF support

Plug 'https://github.com/vim-scripts/taglist.vim.git'
Plug 'https://github.com/majutsushi/tagbar.git'


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
"set cursorline                              " Highlight the current line being edited
set ic                                      " Use incremental search
set hls is                                  " Highlight search results (and partial results)
set noerrorbells visualbell t_vb=           " Disable beeping and flashing on errors
set foldmethod=manual foldlevelstart=20     " Use manual folding
set synmaxcol=200                           " Only bother highlighting the first 200 characters of a line before giving up
autocmd GUIEnter * set visualbell t_vb=     " Disable beeping and flashing on errors
let g:syntastic_always_populate_loc_list=1| " Populate location-list automatically
let g:syntastic_check_on_open=1|            " Check for syntax errors when first loading the buffer
let g:syntastic_check_on_wq=0|              " Don't bother checking syntax errors on :wq
let g:syntastic_ruby_checkers = ["mri", "rubocop"] " Include rubocop checker as well.
let g:tagbar_autoclose=1|                   " Tagbar closes after selecting a tag to view
let g:easytags_auto_highlight=0|            " Dont auto highlight tags

" === Error messages to hide === "
" let g:syntastic_eruby_ruby_quiet_messages = {'regex': 'possibly useless use of .* in void context'}
" let g:syntastic_ruby_mri_quiet_messages = {'regex': 'ambiguous first argument.*'}
" let g:syntastic_html_tidy_quiet_messages = {'regex': 'trimming empty .*'}

let g:ale_ruby_rubocop_executable = 'bundle'
let g:ale_echo_msg_format = '[%linter%] %s'
let g:ale_linters = {
\ 'ruby': ['rubocop', 'ruby'],
\}

let g:airline_powerline_fonts=1|            " Enable patched airline statusbar font
" Section layout customization (see https://github.com/vim-airline/vim-airline/blob/master/doc/airline.txt#L299-L360)
let g:airline#extensions#default#layout = [
\ ['error', 'warning', 'a', 'c'],
\ ['z', 'b']
\ ]

" === Custom syntax highlighting === "
highlight Pmenu ctermfg=73 ctermbg=15|      " Custom colors for autocomplete menu
highlight PmenuSel ctermfg=255 ctermbg=88|  " Custom colors for autocomplete menu (selected item)
highlight TrailingWhitespace ctermbg=red|   " Highlight extra whitespace
match TrailingWhitespace /\s\+$/            " Defines what trailing whitespace is



" === KEY MAPPINGS === "
nnoremap ` :NERDTreeToggle<CR>|                      " Open directory browser
nnoremap <c-p> :FZF<CR>|                             " Open fuzzy finder (in current window)
nnoremap <c-l> :vsp<CR>:FZF<CR>|                     " Open fuzzy finder (in a new vertically split window)
nnoremap <c-k> :new<CR>:FZF<CR>|                     " Open fuzzy finder (in a new horizontally split window)
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
nnoremap ~ :TagbarToggle<CR>|                        " Open tagbar
nnoremap tt :let @+ = expand("%")<CR>|               " Copy open filename to clipboard

" === FILETYPE MAPPINGS === "
autocmd BufNewFile,BufRead *Gemfile*  set filetype=ruby

" === PROJECT SPECIFIC SETTINGS === "

" >> shopify/billing"
autocmd BufRead ~/code/Shopify/billing/* let g:syntastic_ruby_checkers = ["mri"]  " Disable rubocop

" >> shopify/shopify"
autocmd BufRead ~/code/Shopify/shopify/* let g:syntastic_ruby_checkers = ["mri"]  " Disable rubocop


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
