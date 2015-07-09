"  ==============================================================================
"                       ~~ Installation Instructions ~~
"
" * Run :PlugInstall to install all vim extensions listed below.
" * Run :PlugClean to remove unused extensions
" * After command-p is installed, it requires some additional c compiliation:
"     $ cd ~/.vim/plugged/matcher
"     $ make
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
"  =============================================================================


" === Plugins === "
call plug#begin('~/.vim/plugged')

Plug 'git@github.com:scrooloose/syntastic.git'                                 " Adds in-line syntax error highlighting
Plug 'git@github.com:vim-ruby/vim-ruby.git'                                    " Adds ruby syntax support
Plug 'git@github.com:tpope/vim-rails.git'                                      " Adds rails syntax support
Plug 'git@github.com:jelera/vim-javascript-syntax.git'                         " Adds better javascript syntax support
Plug 'git@github.com:kchmck/vim-coffee-script.git'                             " Adds coffee-script syntax support
Plug 'git@github.com:plasticboy/vim-markdown.git'                              " Adds markdown syntax support
Plug 'git@github.com:elzr/vim-json.git'                                        " Adds JSON syntax support
Plug 'git@github.com:StanAngeloff/php.vim.git'                                 " Adds better PHP syntax support
Plug 'git@github.com:captbaritone/better-indent-support-for-php-with-html.git' " Adds html/php combined syntax support
Plug 'git@github.com:ap/vim-css-color.git'                                     " Adds css color previews
Plug 'git@github.com:gregsexton/MatchTag.git'                                  " Adds HTML end tag matching
Plug 'git@github.com:scrooloose/nerdtree.git'                                  " Adds directory browser
Plug 'git@github.com:bling/vim-airline.git'                                    " Adds airline status bar
Plug 'git@github.com:godlygeek/tabular.git'                                    " Adds support for aligning text (use :Tab /=> for ex)
Plug 'git@github.com:xolox/vim-easytags.git'                                   " Keeps ctags up to date automatically
Plug 'git@github.com:xolox/vim-misc.git'                                       " Dependency of vim-easytags
Plug 'git@github.com:kien/ctrlp.vim.git'                                       " Adds fuzzy finder
Plug 'git@github.com:burke/matcher.git'                                        " Standalone version of command-t to plug into ctrl-p (no ruby needed)
Plug 'git@github.com:airblade/vim-gitgutter.git'                               " Adds git change notations to the side gutter
Plug 'git@github.com:nicwest/QQ.vim.git'                                       " Curl wrapper
Plug 'git@github.com:tonchis/vim-to-github.git'                                " Adds the :ToGithub command
Plug 'git@github.com:sjl/gundo.vim.git'                                        " Adds the gundo undo-tree browser
Plug 'git@github.com:mhinz/vim-startify.git'                                   " Adds a better start menu (MRU file list)
Plug 'git@github.com:vim-scripts/Rename.git'                                   " Adds :Rename command
Plug 'git@github.com:tpope/vim-fugitive.git'                                   " Adds git commands such as :Gblame

call plug#end()


" === SYNTAX HIGHLIGHTING / EDITOR CONFIGURATION === "
syntax on
colorscheme railscasts
filetype plugin indent on
set laststatus=2                            " Always show the statusline
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
set foldmethod=syntax foldlevelstart=20     " Use the syntax definition to decide where to fold
autocmd GUIEnter * set visualbell t_vb=     " Disable beeping and flashing on errors
highlight Pmenu ctermfg=73 ctermbg=15|      " Custom colors for autocomplete menu
highlight PmenuSel ctermfg=255 ctermbg=88|  " Custom colors for autocomplete menu (selected item)
highlight TrailingWhitespace ctermbg=red|   " Highlight extra whitespace
match TrailingWhitespace /\s\+$/|          " Defines what trailing whitespace is
highlight TabWhitespace ctermbg=gray|       " Highlight tabs
match TabWhitespace /\t/|                   " Defines what tab whitespace is
let g:airline_powerline_fonts=1|            " Enable patched airline statusbar font
let g:syntastic_always_populate_loc_list=1| " Populate location-list automatically
let g:syntastic_auto_loc_list=1|            " Automatically open the location-list
let g:syntastic_check_on_open=1|            " Check for syntax errors when first loading the buffer
let g:syntastic_check_on_wq=0|              " Don't bother checking syntax errors on :wq


" === KEY MAPPINGS === "
nnoremap ` :NERDTreeToggle<CR>|                      " Open directory browser
nnoremap <c-l> :vsp<CR>:Startify<CR>|                " Open fuzzy finder (in a new vertically split window)
nnoremap <c-k> :new<CR>:Startify<CR>|                " Open fuzzy finder (in a new horizontally split window)
nnoremap q: :q|                                      " Common typo that would open an annoying panel
nnoremap K Vk|                                       " Common typo that closes vim momentarily
nnoremap J Vj|                                       " Common typo that joins a line
nnoremap <leader><leader> :nohl<CR>:set nopaste<CR>| " Used to reset back to default editing mode after a search, replace, or paste
nnoremap <leader>ws :%s/\s\+$//g<CR><c-o>|           " Remove all trailing whitespace
nnoremap <F5> :GundoToggle<CR>|                      " Open the gundo browser
nnoremap <F6> :Startify<CR>|                         " Open the startify menu
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

" Integrates matcher with ctrl+p
let g:path_to_matcher = "/usr/local/bin/matcher"
let g:ctrlp_user_command = ['.git/', 'cd %s && git ls-files . -co --exclude-standard']
let g:ctrlp_match_func = { 'match': 'GoodMatch' }
function! GoodMatch(items, str, limit, mmode, ispath, crfile, regex)
  let cachefile = ctrlp#utils#cachedir().'/matcher.cache'
  if !( filereadable(cachefile) && a:items == readfile(cachefile) )
    call writefile(a:items, cachefile)
  endif
  if !filereadable(cachefile)
    return []
  endif
  let cmd = g:path_to_matcher.' --limit '.a:limit.' --manifest '.cachefile.' '
  if !( exists('g:ctrlp_dotfiles') && g:ctrlp_dotfiles )
    let cmd = cmd.'--no-dotfiles '
  endif
  let cmd = cmd.a:str
  return split(system(cmd), "\n")
endfunction

" Better indent support for PHP by making it possible to indent HTML sections
" as well.
if exists("b:did_indent")
  finish
endif
" This script pulls in the default indent/php.vim with the :runtime command
" which could re-run this script recursively unless we catch that:
if exists('s:doing_indent_inits')
  finish
endif
let s:doing_indent_inits = 1
runtime! indent/html.vim
unlet b:did_indent
runtime! indent/php.vim
unlet s:doing_indent_inits
function! GetPhpHtmlIndent(lnum)
  if exists('*HtmlIndent')
    let html_ind = HtmlIndent()
  else
    let html_ind = HtmlIndentGet(a:lnum)
  endif
  let php_ind = GetPhpIndent()
  " priority one for php indent script
  if php_ind > -1
    return php_ind
  endif
  if html_ind > -1
    if getline(a:num) =~ "^<?" && (0< searchpair('<?', '', '?>', 'nWb')
          \ || 0 < searchpair('<?', '', '?>', 'nW'))
      return -1
    endif
    return html_ind
  endif
  return -1
endfunction
setlocal indentexpr=GetPhpHtmlIndent(v:lnum)
setlocal indentkeys+=<>>
