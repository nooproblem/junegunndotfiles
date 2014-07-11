" ============================================================================
" .vimrc of Junegunn Choi
" ============================================================================

let s:darwin = has('mac')
let s:ag     = executable('ag')

" ============================================================================
" VIM-PLUG BLOCK
" ============================================================================

silent! if plug#begin('~/.vim/plugged')

if s:darwin
  Plug 'git@github.com:junegunn/vim-easy-align.git',       { 'on': ['<Plug>(EasyAlign)', 'EasyAlign'] }
  Plug 'git@github.com:junegunn/vim-github-dashboard.git', { 'on': ['GHDashboard', 'GHActivity']      }
  Plug 'git@github.com:junegunn/vim-emoji.git'
  Plug 'git@github.com:junegunn/vim-pseudocl.git'
  Plug 'git@github.com:junegunn/vim-oblique.git'
  Plug 'git@github.com:junegunn/vim-fnr.git'
  Plug 'git@github.com:junegunn/seoul256.vim.git'
  Plug 'git@github.com:junegunn/vader.vim.git',     { 'on': 'Vader', 'for': 'vader' }
  Plug 'git@github.com:junegunn/vim-ruby-x.git',    { 'on': 'RubyX'                 }
  Plug 'git@github.com:junegunn/goyo.vim.git',      { 'on': 'Goyo'                  }
  Plug 'git@github.com:junegunn/limelight.vim.git', { 'on': 'Limelight'             }
else
  let $GIT_SSL_NO_VERIFY = 'true'
  Plug 'junegunn/vim-easy-align',       { 'on': ['<Plug>(EasyAlign)', 'EasyAlign'] }
  Plug 'junegunn/vim-github-dashboard', { 'on': ['GHDashboard', 'GHActivity']      }
  Plug 'junegunn/vim-pseudocl'
  Plug 'junegunn/vim-oblique'
  Plug 'junegunn/vim-fnr'
  Plug 'junegunn/seoul256.vim'
  Plug 'junegunn/vader.vim',     { 'on': 'Vader', 'for': 'vader' }
  Plug 'junegunn/vim-ruby-x',    { 'on': 'RubyX'                 }
  Plug 'junegunn/goyo.vim',      { 'on': 'Goyo'                  }
  Plug 'junegunn/limelight.vim', { 'on': 'Limelight'             }
endif

" Edit
Plug 'tpope/vim-repeat'
Plug 'tpope/vim-surround'
Plug 'tpope/vim-endwise'
Plug 'tpope/vim-commentary',        { 'on': '<Plug>Commentary' }
Plug 'mbbill/undotree',             { 'on': 'UndotreeToggle'   }
Plug 'ConradIrwin/vim-bracketed-paste'
if s:darwin
  Plug 'zerowidth/vim-copy-as-rtf', { 'on': 'CopyRTF'          }
endif

" Tmux
Plug 'tpope/vim-tbone'
Plug 'tpope/vim-dispatch'

" Browsing
Plug 'Yggdroot/indentLine', { 'on': 'IndentLinesToggle' }
Plug 'mileszs/ack.vim',     { 'on': 'Ack'               }
Plug 'scrooloose/nerdtree', { 'on': 'NERDTreeToggle'    }
if v:version >= 703
  Plug 'majutsushi/tagbar', { 'on': 'TagbarToggle'      }
endif

" Git
Plug 'tpope/vim-fugitive'
Plug 'gregsexton/gitv', { 'on': 'Gitv' }
if v:version >= 703
  Plug 'airblade/vim-gitgutter'
else
  Plug 'mhinz/vim-signify'
endif

" Lang
if v:version >= 703
  Plug 'vim-ruby/vim-ruby',      { 'for': 'ruby'       }
  Plug 'vim-scripts/VimClojure', { 'for': 'clojure'    }
  Plug 'tpope/vim-fireplace',    { 'for': 'clojure'    }
  Plug 'kovisoft/paredit',       { 'for': 'clojure'    }
endif
Plug 'tpope/vim-rails'
Plug 'pangloss/vim-javascript',  { 'for': 'javascript' }
Plug 'kchmck/vim-coffee-script', { 'for': 'coffee'     }
Plug 'plasticboy/vim-markdown',  { 'for': 'markdown'   }
Plug 'slim-template/vim-slim',   { 'for': 'slim'       }
Plug 'wting/rust.vim',           { 'for': 'rust'       }
Plug 'Glench/Vim-Jinja2-Syntax'
if s:darwin
  Plug 'Keithbsmiley/investigate.vim'
endif

call plug#end()
endif

" ============================================================================
" Basic settings
" ============================================================================

let mapleader      = ' '
let maplocalleader = ' '

set nu
set autoindent
set smartindent
set lazyredraw
set laststatus=2
set showcmd
set visualbell
set backspace=indent,eol,start
set timeoutlen=500
set whichwrap=b,s
set shortmess=aI
set shortmess+=T
set hlsearch " CTRL-L / CTRL-R W
set incsearch
set hidden
set ignorecase smartcase
set wildmenu
set tabstop=2
set shiftwidth=2
set expandtab smarttab
set scrolloff=5
set encoding=utf-8
set fileencodings=ucs-bom,utf-8,euc-kr,latin1
set list
set listchars=tab:\|\ ,
set virtualedit=block
set nojoinspaces
set diffopt=filler,vertical
set autoread

" %< Where to truncate
" %n buffer number
" %F Full path
" %m Modified flag: [+], [-]
" %r Readonly flag: [RO]
" %y Type:          [vim]
" fugitive#statusline()
" %= Separator
" %-14.(...)
" %l Line
" %c Column
" %V Virtual column
" %P Percentage
" %#HighlightGroup#
set statusline=%<[%n]\ %F\ %m%r%y\ %{exists('g:loaded_fugitive')?fugitive#statusline():''}\ %=%-14.(%l,%c%V%)\ %P
silent! if emoji#available()
  set statusline=%{emoji#for('cherry_blossom')}\ %<[%n]\ %F\ %{MyModified()}%{MyReadonly()}%{MyFileType()}\ %{MyFugitiveHead()}\ %=%-14.(%l,%c%V%)\ %P\ %{emoji#for('cherry_blossom')}

  let s:ft_emoji = map({
    \ 'c':          'baby_chick',
    \ 'clojure':    'lollipop',
    \ 'coffee':     'coffee',
    \ 'cpp':        'chicken',
    \ 'css':        'art',
    \ 'eruby':      'ring',
    \ 'gitcommit':  'soon',
    \ 'haml':       'hammer',
    \ 'help':       'angel',
    \ 'html':       'herb',
    \ 'java':       'older_man',
    \ 'javascript': 'monkey',
    \ 'make':       'seedling',
    \ 'markdown':   'book',
    \ 'perl':       'camel',
    \ 'python':     'snake',
    \ 'ruby':       'gem',
    \ 'scala':      'barber',
    \ 'sh':         'shell',
    \ 'slim':       'dancer',
    \ 'text':       'books',
    \ 'vim':        'poop',
    \ 'vim-plug':   'electric_plug',
    \ 'yaml':       'yum',
    \ 'yaml.jinja': 'yum'
  \ }, 'emoji#for(v:val)')

  function! MyFileType()
    if empty(&filetype)
      return emoji#for('grey_question')
    else
      return get(s:ft_emoji, &filetype, '['.&filetype.']')
    endif
  endfunction

  function! MyModified()
    if &modified
      return emoji#for('kiss').' '
    elseif !&modifiable
      return emoji#for('construction').' '
    else
      return ''
    endif
  endfunction

  function! MyReadonly()
    return &readonly ? emoji#for('lock') . ' ' : ''
  endfunction

  function! MyFugitiveHead()
    if !exists('g:loaded_fugitive')
      return ''
    endif
    let head = fugitive#head()
    if empty(head)
      return ''
    else
      return head == 'master' ? emoji#for('crown') : emoji#for('dango').'='.head
    endif
  endfunction
endif

set pastetoggle=<Ins>
set pastetoggle=<F9> " For Mac
set modelines=2
set synmaxcol=400

" For MacVim
set noimd
set imi=1
set ims=-1

" ctags
set tags=./tags;/

" Annoying temporary files
set backupdir=/tmp,.
set directory=/tmp,.

" Shift-tab on GNU screen
" http://superuser.com/questions/195794/gnu-screen-shift-tab-issue
set t_kB=[Z

" set complete=.,w,b,u,t
set complete-=i

" Color setting
silent! colo seoul256

" mouse
set ttymouse=xterm2
set mouse=a

" Googling
" set keywordprg=open\ http://www.google.com/search?q=\

" 80 chars/line
set textwidth=0
if exists('&colorcolumn')
  set colorcolumn=80
endif

" Keep the cursor on the same column
set nostartofline


" ============================================================================
" MAPPINGS
" ============================================================================

" ----------------------------------------------------------------------------
" Basic mappings
" ----------------------------------------------------------------------------

noremap <C-F> <C-D>
noremap <C-B> <C-U>

" Save
inoremap <C-s> <C-O>:update<cr>
nnoremap <C-s> :update<cr>

" Select-all (don't need confusing increment C-a)
noremap  <C-a> gg0vG$

" Quit
inoremap <C-Q>     <esc>:q<cr>
nnoremap <C-Q>     :q<cr>
vnoremap <C-Q>     <esc>
nnoremap <Leader>q :q<cr>
nnoremap <Leader>Q :qa!<cr>

" Tag stack
nnoremap g<Left>  :pop<cr>
nnoremap g<Right> :tag<cr>

" Jump list
nnoremap _ <C-o>
nnoremap + <C-i>

" <F10> | NERD Tree
inoremap <F10> <esc>:NERDTreeToggle<cr>
nnoremap <F10> :NERDTreeToggle<cr>

" <F11> | Tagbar
if v:version >= 703
  inoremap <F11> <esc>:TagbarToggle<cr>
  nnoremap <F11> :TagbarToggle<cr>
  let g:tagbar_sort = 0
endif

" <F12> Toggle line number display
nnoremap <F12> :set nonumber!<cr>

" jk | Escaping!
noremap! jk <C-c>
vnoremap jk <C-c>

" No delay in visual mode by jk
vnoremap v <down>
vnoremap V <down>

" Movement in insert mode
inoremap <C-h> <C-o>h
inoremap <C-l> <C-o>a
inoremap <C-j> <C-o>j
inoremap <C-k> <C-o>k
inoremap <C-^> <C-o><C-^>

" Make Y behave like other capitals
nnoremap Y y$

" qq to record, Q to replay
nnoremap Q @q

" ----------------------------------------------------------------------------
" <tab> / <s-tab> | Circular windows navigation
" ----------------------------------------------------------------------------
nnoremap <tab>   <c-w>w
nnoremap <S-tab> <c-w>W

" ----------------------------------------------------------------------------
" <tab> / <s-tab> / <c-v><tab> | super-duper-tab
" ----------------------------------------------------------------------------
function! s:super_duper_tab(k, o)
  let line = getline('.')
  let col = col('.') - 2
  if !empty(line) && line[col] =~ '\k' && line[col + 1] !~ '\k'
    return a:k
  else
    return a:o
  endif
endfunction
inoremap <expr> <tab>   <SID>super_duper_tab("\<c-n>", "\<tab>")
inoremap <expr> <s-tab> <SID>super_duper_tab("\<c-p>", "\<s-tab>")

" ----------------------------------------------------------------------------
" Markdown headings
" ----------------------------------------------------------------------------
nnoremap <leader>1 m`yypVr=``
nnoremap <leader>2 m`yypVr-``
nnoremap <leader>3 m`^i### <esc>``4l
nnoremap <leader>4 m`^i#### <esc>``5l
nnoremap <leader>5 m`^i##### <esc>``6l

" ----------------------------------------------------------------------------
" Moving lines
" ----------------------------------------------------------------------------
nnoremap <silent> <C-k> :execute ":move ".max([0,         line('.') - 2])<cr>
nnoremap <silent> <C-j> :execute ":move ".min([line('$'), line('.') + 1])<cr>
nnoremap <silent> <C-h> <<
nnoremap <silent> <C-l> >>
vnoremap <silent> <C-k> :<C-U>execute "normal! gv:move ".max([0,         line("'<") - 2])."\n"<cr>gv
vnoremap <silent> <C-j> :<C-U>execute "normal! gv:move ".min([line('$'), line("'>") + 1])."\n"<cr>gv
vnoremap <silent> <C-h> <gv
vnoremap <silent> <C-l> >gv
vnoremap < <gv
vnoremap > >gv

" ----------------------------------------------------------------------------
" Cscope mappings
" ----------------------------------------------------------------------------
function! s:add_cscope_db()
  " add any database in current directory
  let db = findfile('cscope.out', '.;')
  if !empty(db)
    silent cs reset
    silent! execute "cs add ".db
  " else add database pointed to by environment
  elseif !empty($CSCOPE_DB)
    silent cs reset
    silent! execute "cs add ".$CSCOPE_DB
  endif
endfunction

if has("cscope")
  set csprg=/usr/local/bin/cscope
  set csto=0
  set cst
  set nocsverb
  set csverb
  call s:add_cscope_db()

  "   's'   symbol: find all references to the token under cursor
  "   'g'   global: find global definition(s) of the token under cursor
  "   'c'   calls:  find all calls to the function name under cursor
  "   't'   text:   find all instances of the text under cursor
  "   'e'   egrep:  egrep search for the word under cursor
  "   'f'   file:   open the filename under cursor
  "   'i'   includes: find files that include the filename under cursor
  "   'd'   called: find functions that function under cursor calls
  nnoremap <C-\>s :cs find s <C-R>=expand("<cword>")<CR><CR>
  nnoremap <C-\>g :cs find g <C-R>=expand("<cword>")<CR><CR>
  nnoremap <C-\>c :cs find c <C-R>=expand("<cword>")<CR><CR>
  nnoremap <C-\>t :cs find t <C-R>=expand("<cword>")<CR><CR>
  nnoremap <C-\>e :cs find e <C-R>=expand("<cword>")<CR><CR>
  nnoremap <C-\>f :cs find f <C-R>=expand("<cfile>")<CR><CR>
  nnoremap <C-\>i :cs find i ^<C-R>=expand("<cfile>")<CR>$<CR>
  nnoremap <C-\>d :cs find d <C-R>=expand("<cword>")<CR><CR>
endif

" ----------------------------------------------------------------------------
" <Leader>c Counting occurrences of the pattern
" ----------------------------------------------------------------------------
vnoremap <Leader>c :s@\%V@@gn<Left><Left><Left><Left>
nnoremap <Leader>c :%s@@@gn<Left><Left><Left><Left>

" ----------------------------------------------------------------------------
" Readline-style key bindings in command-line (excerpt from rsi.vim)
" ----------------------------------------------------------------------------
cnoremap        <C-A> <Home>
cnoremap        <C-B> <Left>
cnoremap <expr> <C-D> getcmdpos()>strlen(getcmdline())?"\<Lt>C-D>":"\<Lt>Del>"
cnoremap <expr> <C-F> getcmdpos()>strlen(getcmdline())?&cedit:"\<Lt>Right>"
cnoremap        <M-b> <S-Left>
cnoremap        <M-f> <S-Right>
silent! exe "set <S-Left>=\<Esc>b"
silent! exe "set <S-Right>=\<Esc>f"

" ----------------------------------------------------------------------------
" #gi / #gpi | go to next/previous indentation level
" ----------------------------------------------------------------------------
function! s:go_indent(times, dir)
  for _ in range(a:times)
    let l = line('.')
    let x = line('$')
    let i = s:indent_len(getline(l))
    let e = empty(getline(l))

    while l >= 1 && l <= x
      let line = getline(l + a:dir)
      let l += a:dir
      if s:indent_len(line) != i || empty(line) != e
        break
      endif
    endwhile
    let l = min([max([1, l]), x])
    execute 'normal! '. l .'G^'
  endfor
endfunction
nnoremap <silent> gi :<c-u>call <SID>go_indent(v:count1, 1)<cr>
nnoremap <silent> gpi :<c-u>call <SID>go_indent(v:count1, -1)<cr>

" ----------------------------------------------------------------------------
" <leader>bs | buf-search
" ----------------------------------------------------------------------------
nnoremap <leader>bs :cex [] <BAR> bufdo vimgrepadd @@g %<BAR>cw<s-left><s-left><right>

" ----------------------------------------------------------------------------
" #! | Shebang (to cancel: CTRL-V)
" ----------------------------------------------------------------------------
iabbrev <expr> #! "#!/usr/bin/env ".&filetype

" ============================================================================
" FUNCTIONS & COMMANDS
" ============================================================================

" ----------------------------------------------------------------------------
" :PlugSnapshot
" ----------------------------------------------------------------------------
command! PlugSnapshot !tar -cvzf ~/.vim/plugged.tgz -C ~/.vim plugged

" ----------------------------------------------------------------------------
" :CSBuild
" ----------------------------------------------------------------------------
function! s:build_cscope_db(...)
  let git_dir = system('git rev-parse --git-dir')
  let chdired = 0
  if !v:shell_error
    let chdired = 1
    execute 'cd '. substitute(fnamemodify(git_dir, ':p:h'), ' ', '\\ ', 'g')
  endif

  let exts = empty(a:000) ?
    \ ['java', 'c', 'h', 'cc', 'hh', 'cpp', 'hpp'] : a:000

  let cmd = "find . " . join(map(exts, "\"-name '*.\" . v:val . \"'\""), ' -o ')
  let tmp = tempname()
  try
    echon 'Building cscope.files'
    call system(cmd.' > '.tmp)
    echon ' - cscoped db'
    call system('cscope -b -q -i'.tmp)
    echon ' - complete!'
    call s:add_cscope_db()
  finally
    silent! call delete(tmp)
    if chdired
      cd -
    endif
  endtry
endfunction
command! CSBuild call s:build_cscope_db(<f-args>)

" ----------------------------------------------------------------------------
" :Chomp
" ----------------------------------------------------------------------------
command! Chomp silent! normal! :%s/\s\+$//<cr>

" ----------------------------------------------------------------------------
" :Root | Change directory to the root of the Git repository
" ----------------------------------------------------------------------------
function! s:root()
  let me = expand('%:p:h')
  let gitd = finddir('.git', me.';')
  if empty(gitd)
    echo "Not in Git repo"
  else
    let gitp = fnamemodify(gitd, ':h')
    echo "Change directory to: ".gitp
    execute 'lcd '.gitp
  endif
endfunction
command! Root call s:root()

" ----------------------------------------------------------------------------
" R | Replace
" ----------------------------------------------------------------------------
function! s:replace()
  if visualmode() ==# 'V'
    if line("'>") == line('$')
      normal! gv"_dp
    else
      normal! gv"_dP
    endif
  else
    if col("'>") == col('$') - 1
      normal! gv"_dp
    else
      normal! gv"_dP
    endif
  endif
endfunction
" vnoremap R "_dP
vnoremap R :<C-U>call <SID>replace()<cr>

" ----------------------------------------------------------------------------
" <F5> / <F6> | Run script
" ----------------------------------------------------------------------------
function! s:run_this_script(output)
  let head  = getline(1)
  let pos   = stridx(head, '#!')
  let file  = expand('%:p')
  let ofile = tempname()
  let rdr   = " 2>&1 | tee ".ofile
  " She-bang found
  if pos != -1
    execute '!'.strpart(head, pos + 2).' '.file.rdr
  " She-bang not found but executable
  elseif executable(file)
    execute '!'.file.rdr
  elseif &filetype == 'ruby'
    execute '!/usr/bin/env ruby '.file.rdr
  elseif &filetype == 'tex'
    execute '!latex '.file. '; [ $? -eq 0 ] && xdvi '. expand('%:r').rdr
  elseif &filetype == 'dot'
    let svg = expand('%:r') . '.svg'
    let png = expand('%:r') . '.png'
    execute '!dot -Tsvg '.file.' -o '.svg.' && '
          \ 'mogrify -density 300 -format png '.svg.' && open '.png.rdr
  else
    return
  end
  if !a:output | return | endif

  " Scratch buffer
  execute get(s:, 'vim_exec_win', 0) . 'wincmd w'
  if exists('b:vim_exec_win')
    %d
  else
    silent!  bdelete [vim-exec-output]
    silent!  vertical botright split new
    silent!  file [vim-exec-output]
    setlocal buftype=nofile bufhidden=hide noswapfile
    let      b:vi_exec_win = 1
    let      s:vim_exec_win = winnr()
  endif
  execute  "silent! read ".ofile
  normal!  gg"_dd
  execute  "normal! \<C-W>p"
endfunction
inoremap <silent> <F5> <esc>:call <SID>run_this_script(0)<cr>
nnoremap <silent> <F5> :call <SID>run_this_script(0)<cr>
inoremap <silent> <F6> <esc>:call <SID>run_this_script(1)<cr>
nnoremap <silent> <F6> :call <SID>run_this_script(1)<cr>

" ----------------------------------------------------------------------------
" <F8> | Color scheme selector
" ----------------------------------------------------------------------------
function! s:rotate_colors()
  if !exists("s:colors_list")
    let s:colors_list =
    \ sort(map(
    \   filter(split(globpath(&rtp, "colors/*.vim"), "\n"), 'v:val !~ "^/usr/"'),
    \   "substitute(fnamemodify(v:val, ':t'), '\\..\\{-}$', '', '')"))
  endif
  if !exists("s:colors_index")
    let s:colors_index = index(s:colors_list, g:colors_name)
  endif
  let s:colors_index = (s:colors_index + 1) % len(s:colors_list)
  let name = s:colors_list[s:colors_index]
  execute "colorscheme " . name
  redraw
  echo name
endfunction
nnoremap <F8> :call <SID>rotate_colors()<cr>

" ----------------------------------------------------------------------------
" :Shuffle | Shuffle selected lines
" ----------------------------------------------------------------------------
function! s:shuffle() range
ruby << RB
  first, last = %w[a:firstline a:lastline].map { |e| VIM::evaluate(e).to_i }
  (first..last).map { |l| $curbuf[l] }.shuffle.each_with_index do |line, i|
    $curbuf[first + i] = line
  end
RB
endfunction
command! -range Shuffle <line1>,<line2>call s:shuffle()

" ----------------------------------------------------------------------------
" <tab> | Case conversion
" ----------------------------------------------------------------------------
function! s:coerce()
  " snake_case -> kebab-case -> camelCase -> MixedCase
  let word = @"
  if word =~# '^[a-z0-9_]\+[!?]\?$'
    let @" = substitute(word, '_', '-', 'g')
  elseif word =~# '^[a-z0-9?!-]\+[!?]\?$'
    let @" = substitute(word, '\C-\([^-]\)', '\u\1', 'g')
  elseif word =~# '^[a-z0-9]\+\([A-Z][a-z0-9]*\)\+[!?]\?$'
    let @" = toupper(word[0]) . strpart(word, 1)
  elseif word =~# '^\([A-Z][a-z0-9]*\)\{2,}[!?]\?$'
    let @" = strpart(substitute(word, '\C\([A-Z]\)', '_\l\1', 'g'), 1)
  else
    normal gv
  endif

  let e = col("'>") + len(@") - len(word)
  execute "normal gv\"_c\<C-R>\"\<esc>".col("'<"). "|v" . e . '|'
endfunction
vnoremap <silent> <tab> y:call <sid>coerce()<cr>

" ----------------------------------------------------------------------------
" Syntax highlighting in code snippets
" ----------------------------------------------------------------------------
function! s:syntax_include(lang, b, e, inclusive)
  let syns = split(globpath(&rtp, "syntax/".a:lang.".vim"), "\n")
  if empty(syns)
    return
  endif

  if exists('b:current_syntax')
    let csyn = b:current_syntax
    unlet b:current_syntax
  endif

  let z = "'" " Default
  for nr in range(char2nr('a'), char2nr('z'))
    let char = nr2char(nr)
    if a:b !~ char && a:e !~ char
      let z = char
      break
    endif
  endfor

  silent! exec printf("syntax include @%s %s", a:lang, syns[0])
  if a:inclusive
    exec printf('syntax region %sSnip start=%s\(\)\(%s\)\@=%s ' .
                \ 'end=%s\(%s\)\@<=\(\)%s contains=@%s containedin=ALL',
                \ a:lang, z, a:b, z, z, a:e, z, a:lang)
  else
    exec printf('syntax region %sSnip matchgroup=Snip start=%s%s%s ' .
                \ 'end=%s%s%s contains=@%s containedin=ALL',
                \ a:lang, z, a:b, z, z, a:e, z, a:lang)
  endif

  if exists('csyn')
    let b:current_syntax = csyn
  endif
endfunction

function! s:file_type_handler()
  if &ft =~ 'jinja' && &ft != 'jinja'
    call s:syntax_include('jinja', '{{', '}}', 1)
    call s:syntax_include('jinja', '{%', '%}', 1)
  elseif &ft == 'mkd' || &ft == 'markdown'
    let map = { 'bash': 'sh' }
    for lang in ['ruby', 'yaml', 'vim', 'sh', 'bash', 'python', 'java', 'c', 'sql']
      call s:syntax_include(get(map, lang, lang), '```'.lang, '```', 0)
    endfor

    if &background == 'light'
      highlight def Snip ctermfg=231
    else
      highlight def Snip ctermfg=232
    endif
    setlocal textwidth=78
    setlocal completefunc=emoji#complete
  endif
endfunction

" ----------------------------------------------------------------------------
" SaveMacro / LoadMacro
" ----------------------------------------------------------------------------
function! s:save_macro(name, file)
  let content = eval('@'.a:name)
  if !empty(content)
    call writefile(split(content, "\n"), a:file)
    echom len(content) . " bytes save to ". a:file
  endif
endfunction
command! -nargs=* SaveMacro call <SID>save_macro(<f-args>)

function! s:load_macro(file, name)
  let data = join(readfile(a:file), "\n")
  call setreg(a:name, data, 'c')
  echom "Macro loaded to @". a:name
endfunction
command! -nargs=* LoadMacro call <SID>load_macro(<f-args>)

" ----------------------------------------------------------------------------
" HL | Find out syntax group
" ----------------------------------------------------------------------------
function! s:hl()
  " echo synIDattr(synID(line('.'), col('.'), 0), 'name')
  echo join(map(synstack(line('.'), col('.')), 'synIDattr(v:val,"name")'), '/')
endfunction
command! HL call <SID>hl()

" ----------------------------------------------------------------------------
" (v) <c-t>d / <c-t>n / <c-t>s | indenTation adjustment
" ----------------------------------------------------------------------------
function! s:adjust_indentation(idt) range
  let [min, max, range] = [10000, 0, range(a:firstline, a:lastline)]
  for l in range
    let line = getline(l)
    if empty(line) | continue | endif
    let ilen = len(matchstr(line, '^\s\+'))
    let [min, max] = [min([ilen, min]), max([ilen, max])]
  endfor
  let idt = repeat(' ', a:idt == 'd' ? max : (a:idt == 's' ? min : 0))
  for l in range
    let line = getline(l)
    if empty(line) | continue | endif
    call setline(l, substitute(line, '^\s*', idt, ''))
  endfor
endfunction
vnoremap <silent> <c-t>d :call <sid>adjust_indentation('d')<cr>
vnoremap <silent> <c-t>n :call <sid>adjust_indentation('n')<cr>
vnoremap <silent> <c-t>s :call <sid>adjust_indentation('s')<cr>

" ----------------------------------------------------------------------------
" :A
" ----------------------------------------------------------------------------
function! s:a()
  let name = expand('%:r')
  let ext = tolower(expand('%:e'))
  let sources = ['c', 'cc', 'cpp', 'cxx']
  let headers = ['h', 'hh', 'hpp', 'hxx']
  for pair in [[sources, headers], [headers, sources]]
    let [set1, set2] = pair
    if index(set1, ext) >= 0
      for h in set2
        let aname = name.'.'.h
        for a in [aname, toupper(aname)]
          if filereadable(a)
            execute "e ".a
            return
          end
        endfor
      endfor
    endif
  endfor
endfunction
command! A call s:a()

" ----------------------------------------------------------------------------
" Todo
" ----------------------------------------------------------------------------
function! s:todo() abort
  let entries = []
  for cmd in ['git grep -n -e TODO -e FIXME -e XXX 2> /dev/null',
            \ 'grep -rn -e TODO -e FIXME -e XXX * 2> /dev/null']
    let lines = split(system(cmd), '\n')
    if v:shell_error != 0 | continue | endif
    for line in lines
      let [fname, lno, text] = matchlist(line, '^\([^:]*\):\([^:]*\):\(.*\)')[1:3]
      call add(entries, { 'filename': fname, 'lnum': lno, 'text': text })
    endfor
  endfor

  if !empty(entries)
    call setqflist(entries)
    copen
  endif
endfunction
command! Todo call s:todo()

" ----------------------------------------------------------------------------
" EX | chmod +x
" ----------------------------------------------------------------------------
command! EX if !empty(expand('%')) && filereadable(expand('%'))
         \|   silent! execute '!chmod +x %'
         \|   redraw!
         \| else
         \|   echohl WarningMsg
         \|   echo 'Save the file first'
         \|   echohl None
         \| endif

" ----------------------------------------------------------------------------
" call LSD()
" ----------------------------------------------------------------------------
function! LSD()
  syntax clear

  for i in range(16, 255)
    execute printf('highlight LSD%s ctermfg=%s', i - 16, i)
  endfor

  let block = 4
  for l in range(1, line('$'))
    let c = 1
    let max = len(getline(l))
    while c < max
      let stride = 4 + reltime()[1] % 8
      execute printf('syntax region lsd%s_%s start=/\%%%sl\%%%sc/ end=/\%%%sl\%%%sc/ contains=ALL', l, c, l, c, l, min([c + stride, max]))
      let rand = abs(reltime()[1] % (256 - 16))
      execute printf('hi def link lsd%s_%s LSD%s', l, c, rand)
      let c += stride
    endwhile
  endfor
endfunction

" ----------------------------------------------------------------------------
" co? : Toggle options (inspired by unimpaired.vim)
" ----------------------------------------------------------------------------
function! s:map_change_option(...)
  let [key, opt] = a:000[0:1]
  let op = get(a:, 3, 'set '.opt.'!')
  execute printf("nnoremap co%s :%s<bar>echo '%s: '. &%s<cr>",
        \ key, op, opt, opt)
endfunction

call s:map_change_option('p', 'paste')
call s:map_change_option('n', 'number')
call s:map_change_option('w', 'wrap')
call s:map_change_option('h', 'hlsearch')
call s:map_change_option('m', 'mouse', 'let &mouse = &mouse == "" ? "a" : ""')
call s:map_change_option('t', 'textwidth',
    \ 'let &textwidth = input("textwidth (". &textwidth ."): ")<bar>redraw')
call s:map_change_option('b', 'background',
    \ 'let &background = &background == "dark" ? "light" : "dark"<bar>redraw')

" ----------------------------------------------------------------------------
" <Leader>? | Google it
" ----------------------------------------------------------------------------
function! s:goog(q)
  let url = 'https://www.google.co.kr/search?q='
  " Excerpt from vim-unimpared
  let q = substitute(
        \ '"'.a:q.'"',
        \ '[^A-Za-z0-9_.~-]',
        \ '\="%".printf("%02X", char2nr(submatch(0)))',
        \ 'g')
  call system('open ' . url . q)
endfunction

vnoremap <leader>? "gy:call <SID>goog(@g)<cr>

" ============================================================================
" TEXT OBJECTS
" ============================================================================
"
" ----------------------------------------------------------------------------
" ?ii / ?ai | indent-object
" ?io       | strictly-indent-object
" ----------------------------------------------------------------------------
function! s:indent_len(str)
  return type(a:str) == 1 ? len(matchstr(a:str, '^\s*')) : 0
endfunction

function! s:indent_object(op, skip_blank, b, e, bd, ed)
  let i = min([s:indent_len(getline(a:b)), s:indent_len(getline(a:e))])
  let x = line('$')
  let d = [a:b, a:e]

  if i == 0 && empty(getline(a:b)) && empty(getline(a:e))
    let [b, e] = [a:b, a:e]
    while b > 0 && e <= line('$')
      let b -= 1
      let e += 1
      let i = min(filter(map([b, e], 's:indent_len(getline(v:val))'), 'v:val != 0'))
      if i > 0
        break
      endif
    endwhile
  endif

  for triple in [[0, 'd[o] > 1', -1], [1, 'd[o] < x', +1]]
    let [o, ev, df] = triple

    while eval(ev)
      let line = getline(d[o] + df)
      let idt = s:indent_len(line)

      if eval('idt '.a:op.' i') && (a:skip_blank || !empty(line)) || (a:skip_blank && empty(line))
        let d[o] += df
      else | break | end
    endwhile
  endfor
  execute printf('normal! %dGV%dG', max([1, d[0] + a:bd]), min([x, d[1] + a:ed]))
endfunction
vnoremap <silent> ii :<c-u>call <SID>indent_object('>=', 1, line("'<"), line("'>"), 0, 0)<cr>
onoremap <silent> ii :<c-u>call <SID>indent_object('>=', 1, line('.'), line('.'), 0, 0)<cr>
vnoremap <silent> ai :<c-u>call <SID>indent_object('>=', 1, line("'<"), line("'>"), -1, 1)<cr>
onoremap <silent> ai :<c-u>call <SID>indent_object('>=', 1, line('.'), line('.'), -1, 1)<cr>
vnoremap <silent> io :<c-u>call <SID>indent_object('==', 0, line("'<"), line("'>"), 0, 0)<cr>
onoremap <silent> io :<c-u>call <SID>indent_object('==', 0, line('.'), line('.'), 0, 0)<cr>

" ----------------------------------------------------------------------------
" <Leader>I | Prepend to all adjacent lines with same indentation
" ----------------------------------------------------------------------------
nmap <silent> <leader>I ^vio<C-V>I

" ----------------------------------------------------------------------------
" ?i_ ?a_ ?i. ?a. ?i, ?a, ?i/
" ----------------------------------------------------------------------------
function! s:between_the_bars(incll, inclr, char)
  let cursor = col('.')
  let line   = getline('.')
  let before = line[0 : cursor - 1]
  let after  = line[cursor : -1]
  let [b, e] = [cursor, cursor]

  let i = stridx(join(reverse(split(before, '\zs')), ''), a:char)
  if i >= 0
    let b = len(before) - i + (a:incll ? 0 : 1)
  end

  let i = stridx(after, a:char)
  if i >= 0
    let e = cursor + i + 1 - (a:inclr ? 0 : 1)
  end

  execute printf("normal! %d|v%d|", b, e)
endfunction

for [s:c, s:l] in items({'_': 0, '.': 0, ',': 0, '/': 1})
  execute printf("vnoremap <silent> i%s :<C-U>call <SID>between_the_bars(0, 0, '%s')<CR>", s:c, s:c)
  execute printf("onoremap <silent> i%s :<C-U>call <SID>between_the_bars(0, 0, '%s')<CR>", s:c, s:c)
  execute printf("vnoremap <silent> a%s :<C-U>call <SID>between_the_bars(%s, 1, '%s')<CR>", s:c, s:l, s:c)
  execute printf("onoremap <silent> a%s :<C-U>call <SID>between_the_bars(%s, 1, '%s')<CR>", s:c, s:l, s:c)
endfor

" ----------------------------------------------------------------------------
" ?ie | entire object
" ----------------------------------------------------------------------------
vnoremap <silent> ie gg0oG$
onoremap <silent> ie :<C-U>execute "normal! m`" <Bar> keepjumps normal! ggVG<CR>

" ----------------------------------------------------------------------------
" ?il | inner line
" ----------------------------------------------------------------------------
vnoremap <silent> il <Esc>^vg_
onoremap <silent> il :<C-U>normal! ^vg_<CR>

" ----------------------------------------------------------------------------
" ?ic / ?iC | Blockwise column object
" ----------------------------------------------------------------------------
function! s:inner_blockwise_column(vmode, cmd)
  if a:vmode == "\<C-V>"
    let [pvb, pve] = [getpos("'<"), getpos("'>")]
    normal! `z
  endif

  execute "normal! \<C-V>".a:cmd."o\<C-C>"
  let [line, col] = [line('.'), col('.')]
  let [cb, ce]    = [col("'<"), col("'>")]
  let [mn, mx]    = [line, line]

  for dir in [1, -1]
    let l = line + dir
    while line('.') > 1 && line('.') < line('$')
      execute "normal! ".l."G".col."|"
      execute "normal! v".a:cmd."\<C-C>"
      if cb != col("'<") || ce != col("'>")
        break
      endif
      let [mn, mx] = [min([line('.'), mn]), max([line('.'), mx])]
      let l += dir
    endwhile
  endfor

  execute printf("normal! %dG%d|\<C-V>%s%dG", mn, col, a:cmd, mx)

  if a:vmode == "\<C-V>"
    normal! o
    if pvb[1] < line('.') | execute "normal! ".pvb[1]."G" | endif
    if pvb[2] < col('.')  | execute "normal! ".pvb[2]."|" | endif
    normal! o
    if pve[1] > line('.') | execute "normal! ".pve[1]."G" | endif
    if pve[2] > col('.')  | execute "normal! ".pve[2]."|" | endif
  endif
endfunction

vnoremap <silent> ic mz:<C-U>call <SID>inner_blockwise_column(visualmode(), 'iw')<CR>
vnoremap <silent> iC mz:<C-U>call <SID>inner_blockwise_column(visualmode(), 'iW')<CR>
vnoremap <silent> ac mz:<C-U>call <SID>inner_blockwise_column(visualmode(), 'aw')<CR>
vnoremap <silent> aC mz:<C-U>call <SID>inner_blockwise_column(visualmode(), 'aW')<CR>
onoremap <silent> ic :<C-U>call   <SID>inner_blockwise_column('',           'iw')<CR>
onoremap <silent> iC :<C-U>call   <SID>inner_blockwise_column('',           'iW')<CR>
onoremap <silent> ac :<C-U>call   <SID>inner_blockwise_column('',           'aw')<CR>
onoremap <silent> aC :<C-U>call   <SID>inner_blockwise_column('',           'aW')<CR>

" ----------------------------------------------------------------------------
" ?a: / ?a= / ?aa= | after :/= / before =
" ----------------------------------------------------------------------------
" *map-error*
"   Note that when an error is encountered (that causes an error message or beep)
"   the rest of the mapping is not executed.  This is Vi-compatible.
vnoremap <silent> a: <Esc>0f:wvg_
onoremap <silent> a: :<C-U>normal! 0f:wvg_<CR>
vnoremap <silent> a- <Esc>0f-wvg_
onoremap <silent> a- :<C-U>normal! 0f-wvg_<CR>
vnoremap <silent> a= <Esc>0f=wvg_
onoremap <silent> a= :<C-U>normal! 0f=wvg_<CR>
vnoremap <silent> aa= <Esc>0vf=ge
onoremap <silent> aa= :<C-U>normal! 0vf=ge<CR>

" ============================================================================
" PLUGINS
" ============================================================================

" ----------------------------------------------------------------------------
" MatchParen delay
" ----------------------------------------------------------------------------
let g:matchparen_insert_timeout=5

" ----------------------------------------------------------------------------
" vim-commentary
" ----------------------------------------------------------------------------
map  gc  <Plug>Commentary
nmap gcc <Plug>CommentaryLine

" ----------------------------------------------------------------------------
" vim-fugitive
" ----------------------------------------------------------------------------
nnoremap <Leader>g :Gstatus<CR>
nnoremap <Leader>d :Gdiff<CR>

" ----------------------------------------------------------------------------
" vim-ruby (https://github.com/vim-ruby/vim-ruby/issues/33)
" ----------------------------------------------------------------------------
if !empty(matchstr($MY_RUBY_HOME, 'jruby'))
  let g:ruby_path = join(split(
    \ glob($MY_RUBY_HOME.'/lib/ruby/*.*')."\n".
    \ glob($MY_RUBY_HOME.'/lib/rubysite_ruby/*'),"\n"), ',')
endif

" ----------------------------------------------------------------------------
" vim-textobj-rubyblock
" ----------------------------------------------------------------------------
runtime macros/matchit.vim

" ----------------------------------------------------------------------------
" vim-scroll-position
" ----------------------------------------------------------------------------
" let g:scroll_position_jump = '-'
" let g:scroll_position_change = 'x'
" let g:scroll_position_auto_enable = 0
" let g:scroll_position_auto_enable = 0
" call scroll_position#show()

" ----------------------------------------------------------------------------
" ack.vim
" ----------------------------------------------------------------------------
if s:ag
  let g:ackprg = 'ag --nogroup --nocolor --column'
elseif !executable('ack')
  let g:ackprg = 'grep -rn "$*" * \| sed "s/:\([0-9]*\):/:\1:1:/" '
endif

" ----------------------------------------------------------------------------
" vim-copy-as-rtf
" ----------------------------------------------------------------------------
if s:darwin
  " Clipboard
  vnoremap <C-c> "*y

  " <C-V><C-V> Paste clipboard content
  inoremap <C-V><C-V> <c-o>"*P

  " Clipboard-RTF
  vnoremap <S-c> <esc>:colo seoul256-light<cr>gv:CopyRTF<cr>:colo seoul256<cr>
endif

" ----------------------------------------------------------------------------
" <Enter> | vim-easy-align
" ----------------------------------------------------------------------------
let g:easy_align_delimiters = {
\ '>': { 'pattern': '>>\|=>\|>' },
\ '\': { 'pattern': '\\' },
\ '/': { 'pattern': '//\+\|/\*\|\*/', 'delimiter_align': 'l', 'ignore_groups': ['^\(.\(Comment\)\@!\)*$'] },
\ ']': {
\     'pattern':       '[[\]]',
\     'left_margin':   0,
\     'right_margin':  0,
\     'stick_to_left': 0
\   },
\ ')': {
\     'pattern':       '[()]',
\     'left_margin':   0,
\     'right_margin':  0,
\     'stick_to_left': 0
\   },
\ 'f': {
\     'pattern': ' \(\S\+(\)\@=',
\     'left_margin': 0,
\     'right_margin': 0
\   },
\ 'd': {
\     'pattern': ' \(\S\+\s*[;=]\)\@=',
\     'left_margin': 0,
\     'right_margin': 0
\   }
\ }

" Start interactive EasyAlign in visual mode
vmap <Enter> <Plug>(EasyAlign)

" Start interactive EasyAlign with a Vim movement
nmap <Leader>a <Plug>(EasyAlign)

" vmap <Leader><Enter>   <Plug>(LiveEasyAlign)
" nmap <Leader><Leader>a <Plug>(LiveEasyAlign)

" inoremap <silent> => =><Esc>mzvip:EasyAlign/=>/<CR>`z$a<Space>

" ----------------------------------------------------------------------------
" vim-github-dashboard
" ----------------------------------------------------------------------------
let g:github_dashboard = { 'username': 'junegunn' }

" ----------------------------------------------------------------------------
" <leader>t | vim-tbone
" ----------------------------------------------------------------------------
function! s:tmux_send(dest) range
  call inputsave()
  let dest = empty(a:dest) ? input('To which pane? ') : a:dest
  call inputrestore()
  silent call tbone#write_command(0, a:firstline, a:lastline, 1, dest)
endfunction
noremap <silent> <leader>t  :call <SID>tmux_send('')<cr>
noremap <silent> <leader>t1 :call <SID>tmux_send('.1')<cr>
noremap <silent> <leader>t2 :call <SID>tmux_send('.2')<cr>

" ----------------------------------------------------------------------------
" indentLine
" ----------------------------------------------------------------------------
let g:indentLine_enabled = 0

" ----------------------------------------------------------------------------
" vim-gitgutter
" ----------------------------------------------------------------------------
nmap gh <Plug>GitGutterNextHunk
nmap gph <Plug>GitGutterPrevHunk

silent! if emoji#available()
  let g:gitgutter_sign_added = emoji#for('small_blue_diamond')
  let g:gitgutter_sign_modified = emoji#for('small_orange_diamond')
  let g:gitgutter_sign_removed = emoji#for('small_red_triangle')
  let g:gitgutter_sign_modified_removed = emoji#for('collision')
endif

let g:gitgutter_realtime = 0
let g:gitgutter_eager = 0

" ----------------------------------------------------------------------------
" vim-emoji :dog: :cat: :rabbit:!
" ----------------------------------------------------------------------------
function! s:replace_emojis() range
  for lnum in range(a:firstline, a:lastline)
    let line = getline(lnum)
    let subs = substitute(line,
          \ ':\([^:]\+\):', '\=emoji#for(submatch(1), submatch(0))', 'g')
    if line != subs
      call setline(lnum, subs)
    endif
  endfor
endfunction
command! -range ReplaceEmojis <line1>,<line2>call s:replace_emojis()

" ----------------------------------------------------------------------------
" goyo.vim
" ----------------------------------------------------------------------------
function! GoyoBefore()
  if has('gui_running')
    set fullscreen
    set background=light
    set linespace=7
  elseif exists('$TMUX')
    silent !tmux set status off
  endif
  Limelight
endfunction

function! GoyoAfter()
  if has('gui_running')
    set nofullscreen
    set background=dark
    set linespace=0
  elseif exists('$TMUX')
    silent !tmux set status on
  endif
  Limelight!
endfunction

let g:goyo_callbacks = [function('GoyoBefore'), function('GoyoAfter')]

nnoremap <Leader>G :Goyo<CR>

" ----------------------------------------------------------------------------
" tcomment.vim
" ----------------------------------------------------------------------------
let g:tcommentTextObjectInlineComment = ''

" ----------------------------------------------------------------------------
" undotree
" ----------------------------------------------------------------------------
let g:undotree_WindowLayout = 2
nnoremap U :UndotreeToggle<CR>

" ----------------------------------------------------------------------------
" fzf
" ----------------------------------------------------------------------------
set rtp+=~/.fzf
nnoremap <silent> <Leader><Leader> :FZF -m<CR>

nnoremap <silent> <Leader>s :call fzf#run({ 'tmux_height': '40%', 'sink': 'botright split' })<CR>
nnoremap <silent> <Leader>v :call fzf#run({ 'tmux_width': winwidth('.') / 2, 'sink': 'vertical botright split' })<CR>

function! BufList()
  redir => ls
  silent ls
  redir END
  return split(ls, '\n')
endfunction

function! BufOpen(e)
  execute 'buffer '. matchstr(a:e, '^[ 0-9]*')
endfunction

nnoremap <silent> <Leader><Enter> :call fzf#run({
\   'source':      reverse(BufList()),
\   'sink':        function('BufOpen'),
\   'options':     '+m',
\   'tmux_height': '40%'
\ })<CR>

nnoremap <silent> <Leader>C :call fzf#run({
\   'source':
\     map(split(globpath(&rtp, "colors/*.vim"), "\n"),
\         "substitute(fnamemodify(v:val, ':t'), '\\..\\{-}$', '', '')"),
\   'sink':       'colo',
\   'options':    '+m',
\   'tmux_width': 20,
\   'launcher':   'iterm2-launcher 20 30 %s'
\ })<CR>

function! s:tmux_words(query)
  let g:_tmux_q = a:query
  let matches = fzf#run({
  \ 'source':      'tmuxwords.rb --all-but-current --scroll 500 --min 5',
  \ 'sink':        function('Tmux_feedkeys'),
  \ 'options':     '--no-multi --query='.a:query,
  \ 'tmux_height': '40%'
  \ })
endfunction

function! Tmux_feedkeys(data)
  echom empty(g:_tmux_q)
  execute "normal! ".(empty(g:_tmux_q) ? 'a' : 'ciW')."\<C-R>=a:data\<CR>"
  startinsert!
endfunction

inoremap <silent> <C-X><C-T> <C-o>:call <SID>tmux_words(expand('<cWORD>'))<CR>

command! FZFLines call fzf#run({
  \ 'source':  BuffersLines(),
  \ 'sink':    function('LineHandler'),
  \ 'options': '--extended --nth=3..,',
  \ 'tmux_height': '60%'
\})

function! LineHandler(l)
  let keys = split(a:l, ':\t')
  exec 'buf ' . keys[0]
  exec keys[1]
  normal! ^zz
endfunction

function! BuffersLines()
  let res = []
  for b in filter(range(1, bufnr('$')), 'buflisted(v:val)')
    call extend(res, map(getbufline(b,0,"$"), 'b . ":\t" . (v:key + 1) . ":\t" . v:val '))
  endfor
  return res
endfunction

" ----------------------------------------------------------------------------
" VimClojure
" ----------------------------------------------------------------------------
let vimclojure#SetupKeyMap     = 0
let vimclojure#ParenRainbow    = 1
let vimclojure#SearchThreshold = 30
let vimclojure#WantNailgun     = 0

" ----------------------------------------------------------------------------
" vim-markdown
" ----------------------------------------------------------------------------
let g:vim_markdown_folding_disabled = 1

" ============================================================================
" AUTOCMD
" ============================================================================

augroup vimrc
  autocmd!

  au BufRead * setlocal foldmethod=manual nofoldenable
  au BufWritePost .vimrc if expand('%') !~ 'fugitive' | source % | endif

  " IndentLines
  au Filetype slim if get(b:, 'indentLine_enabled', 0) == 0
               \ |   execute 'IndentLinesToggle'
               \ | endif

  " File types
  au BufNewFile,BufRead *.md                set filetype=markdown
  au BufNewFile,BufRead *.icc               set filetype=cpp
  au BufNewFile,BufRead *.pde               set filetype=java
  au BufNewFile,BufRead *.less              set filetype=less
  au BufNewFile,BufRead *.coffee-processing set filetype=coffee

  " Included syntax
  au Filetype,ColorScheme * call <SID>file_type_handler()

  " Clojure
  au FileType clojure nmap     <Leader><Enter> cpa)
  au FileType clojure vnoremap <Leader><Enter> :Eval<CR>

  " http://vim.wikia.com/wiki/Highlight_unwanted_spaces
  au BufNewFile,BufRead,InsertLeave * silent! match ExtraWhitespace /\s\+$/
  au InsertEnter * silent! match ExtraWhitespace /\s\+\%#\@<!$/

  " Unset paste on InsertLeave
  au InsertLeave * silent! set nopaste
augroup END

" ----------------------------------------------------------------------------
" gt / q | Help in new tabs
" ----------------------------------------------------------------------------
function! s:helptab()
  if &buftype == 'help'
    execute "normal! \<C-W>T"
    nnoremap q :q<cr>
  endif
endfunction

augroup helptxt
  autocmd!
  autocmd BufEnter *.txt call s:helptab()
augroup END

" ----------------------------------------------------------------------------
" For screencasting with Keycastr
" ----------------------------------------------------------------------------
" map  <tab> <nop>
" imap <tab> <nop>
" vmap <tab> <nop>

