"===== Download Config Automatically ========
" Install Plug
if empty(glob('~/.config/nvim/autoload/plug.vim'))
  !curl -fLo ~/.config/nvim/autoload/plug.vim --create-dirs
    \ https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
  !brew install fzf ripgrep
  autocmd VimEnter * PlugInstall --sync | source $MYVIMRC
endif

" Install railscasts color scheme
if empty(glob('~/.config/nvim/colors/railscasts.vim'))
  silent !curl -fLo ~/.config/nvim/colors/railscasts.vim --create-dirs
    \ https://raw.githubusercontent.com/melari/dotfiles/master/.vim/colors/railscasts.vim
endif

" ============ Declare Plugins ============
call plug#begin('~/.vim/plugged')
Plug 'https://github.com/scrooloose/nerdtree.git'
Plug 'https://github.com/bling/vim-airline.git'
Plug 'https://github.com/airblade/vim-gitgutter.git'
Plug 'https://github.com/vim-scripts/Rename.git'
Plug 'https://github.com/tpope/vim-fugitive.git'
Plug 'https://github.com/tpope/vim-rhubarb.git'
Plug 'https://github.com/w0rp/ale.git'
Plug 'junegunn/fzf', { 'do': { -> fzf#install() } }
Plug 'junegunn/fzf.vim'

" ==== Language Plugins ====
Plug 'https://github.com/tpope/vim-rails.git'
Plug 'https://github.com/vim-ruby/vim-ruby.git'
Plug 'https://github.com/derekwyatt/vim-scala'
Plug 'tomlion/vim-solidity'

call plug#end()

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

" ALE CONFIG
let g:ale_ruby_rubocop_executable = 'bundle'
let g:ale_echo_msg_format = '[%linter%] %s'
let g:ale_linters = {
\ 'ruby': ['rubocop', 'ruby'],
\}

let g:gitgutter_sign_added = '•'
let g:gitgutter_sign_modified = '•'
let g:gitgutter_sign_removed = '•'
let g:gitgutter_sign_removed_first_line = '•↑'
let g:gitgutter_sign_modified_removed = '•'

let g:ale_sign_error = '!!'
let g:ale_sign_warning = '!!'

" AIRLINE CONFIG
let g:airline#extensions#default#layout = [
\ ['error', 'warning', 'a', 'c'],
\ ['z', 'b']
\ ]

" === Custom syntax highlighting === "
highlight Pmenu ctermfg=73 ctermbg=15|      " Custom colors for autocomplete menu
highlight PmenuSel ctermfg=255 ctermbg=88|  " Custom colors for autocomplete menu (selected item)
highlight TrailingWhitespace ctermbg=red|   " Highlight extra whitespace
highlight ALEWarning ctermbg=none cterm=underline| " Syntastic warnings
match TrailingWhitespace /\s\+$/            " Defines what trailing whitespace is

" === KEY MAPPINGS === "
nnoremap ` :NERDTreeToggle<CR>|                      " Open directory browser
nnoremap <c-p> :FZF<CR>|                             " Open fuzzy finder (in current window)
nnoremap <c-l> :vsp<CR>:FZF<CR>|                     " Open fuzzy finder (in a new vertically split window)
nnoremap <c-k> :new<CR>:FZF<CR>|                     " Open fuzzy finder (in a new horizontally split window)
nnoremap q: :q|                                      " Common typo that would open an annoying panel
nnoremap K Vk|                                       " Common typo that closes vim momentarily
nnoremap J Vj|                                       " Common typo that joins a line
nnoremap <leader><leader> :nohl<CR>:set nopaste<CR>:redraw!<CR>| " Used to reset back to default editing mode after a search, replace, or paste
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
nnoremap U :Find <C-R><C-W><CR>|             " Find all usage of word under cursor
"nnoremap D :Find def <C-R><C-W><CR>|         " Find definition of word under cursor
nnoremap D g<c-]>|                            " Find definition of word under cursor using ctags

" === CUSTOM COMMANDS === "
" :Delete           Delete current file
command Delete :call delete(expand('%'))
" :Find [pattern]   Pipe RipGrep into FZF
command! -bang -nargs=* Find call fzf#vim#grep('rg --column --line-number --no-heading --fixed-strings --ignore-case --hidden --follow --glob "!.git/*" --color "always" '.shellescape(<q-args>), 1, <bang>0)

" === FILETYPE MAPPINGS === "
autocmd BufNewFile,BufRead *Gemfile*  set filetype=ruby

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

" Make Fugitive work with Shopify Galaxy ===============
function! GalaxyUrl(opts, ...) abort
  if a:0 || type(a:opts) != type({})
    return ''
  endif

  let remote = matchlist(a:opts.remote, '\v^https:\/\/git-mirror.shopifycloud.com\/(.{-1,})(\.git)?$')
  if empty(remote)
    return ''
  end

  let opts = copy(a:opts)
  let opts.remote = "https://github.com/" . remote[1] . ".git"
  return call("rhubarb#FugitiveUrl", [opts])
endfunction

if !exists('g:fugitive_browse_handlers')
  let g:fugitive_browse_handlers = []
endif

if index(g:fugitive_browse_handlers, function('GalaxyUrl')) < 0
  call insert(g:fugitive_browse_handlers, function('GalaxyUrl'))
endif
" Galaxy fix end ======================================
