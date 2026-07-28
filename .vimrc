" vim is the fallback editor here ($EDITOR is nano), so this stays small.

" Automatic indentation off, deliberately: it mangles pasted text, and that
" costs more than auto-indent saves at the scale vim gets used here.
set noautoindent
set nocindent
set nosmartindent
set indentexpr=
filetype indent off

" Belt and braces for pasting: F2 toggles paste mode.
nnoremap <F2> :set paste!<CR>

" --- minimal usability -----------------------------------------------------

syntax on
filetype plugin on

set incsearch          " jump to matches while typing
set hlsearch           " highlight all matches
set ignorecase         " case-insensitive search...
set smartcase          " ...unless the pattern contains a capital
set ruler              " line/column in the corner -- enough to know where you
                       " are, without a number gutter that breaks mouse-select
                       " copying of the text itself (:set nu to turn it on)
set showcmd            " show the partial command being typed
set wildmenu           " completion menu for : commands
set scrolloff=3        " keep a few lines visible above/below the cursor
set backspace=indent,eol,start
set mouse=             " leave the mouse to the terminal, so selection copies

" Clear search highlight.
nnoremap <silent> <Esc><Esc> :nohlsearch<CR>
