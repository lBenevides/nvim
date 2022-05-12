" ------------------------------ Plugins (VimPlug) --------------------------- 
call plug#begin()
  " menus and finder
  Plug 'ctrlpvim/ctrlp.vim' " fuzzy finder
  Plug 'kyazdani42/nvim-web-devicons' " for file icons
  Plug 'kyazdani42/nvim-tree.lua'
  Plug 'nvim-lua/plenary.nvim'
  Plug 'nvim-telescope/telescope.nvim'

  " ruby/rails plugins
  Plug 'thoughtbot/vim-rspec'
  Plug 'keith/rspec.vim'
  Plug 'vim-ruby/vim-ruby'
  Plug 'vim-scripts/tComment'

  " tmux integration
  Plug 'tmux-plugins/vim-tmux'
  Plug 'christoomey/vim-tmux-runner'
  Plug 'christoomey/vim-tmux-navigator'

  " tpope plugins
  Plug 'tpope/vim-surround'
  Plug 'tpope/vim-repeat'
  Plug 'tpope/vim-endwise'
  Plug 'tpope/vim-fugitive'
  Plug 'tpope/vim-rails'

  " git
  Plug 'nvim-lua/plenary.nvim'
  Plug 'lewis6991/gitsigns.nvim', {'branch': 'main'}

  " make things easier
  Plug 'jiangmiao/auto-pairs'
  Plug 'alvan/vim-closetag'  
  Plug 'honza/vim-snippets'
  Plug 'janko-m/vim-test'

  " themes and colors 
  Plug 'navarasu/onedark.nvim'
  Plug 'vim-airline/vim-airline' " Pretty status bar
  Plug 'vim-airline/vim-airline-themes' 
  Plug 'scrooloose/syntastic' " syntax checking
  Plug 'LunarVim/onedarker.nvim'

  " cmp plugins
  Plug 'hrsh7th/nvim-cmp', {'branch': 'main'}
  Plug 'hrsh7th/cmp-nvim-lsp', {'branch': 'main'}
  Plug 'hrsh7th/cmp-buffer', {'branch': 'main'}
  Plug 'hrsh7th/cmp-path', {'branch': 'main'}
  Plug 'hrsh7th/cmp-cmdline', {'branch': 'main'}
  Plug 'saadparwaiz1/cmp_luasnip'

  " snippets
  Plug 'L3MON4D3/LuaSnip'
  Plug 'rafamadriz/friendly-snippets'

  " lsp plugins
  Plug 'neovim/nvim-lspconfig'
  Plug 'williamboman/nvim-lsp-installer', {'branch': 'main'}
call plug#end()

" ------------------------------ General Settings --------------------------- 
set backspace=2   " Backspace deletes like most programs in insert mode
set nobackup
set nowritebackup
set noswapfile    " http://robots.thoughtbot.com/post/18739402579/global-gitignore#comment-458413287
set history=1000  " a lot of history
set ruler         " show the cursor position all the time
set hlsearch
set showcmd       " display incomplete commands
set incsearch     " do incremental searching
set laststatus=2  " Always display the status line
set autowrite     " Automatically :write before running commands
set ignorecase    " Ignore case when searching...
set smartcase     " ...unless we type a capital
set showmode      " Show current mode down the bottom
set visualbell    " No noise
set noerrorbells  " No noise
set t_vb=         " No noise
set nowrap        " Don't wrap lines
set modeline      " Turn modeline on (Vi magic comment)
set modelines=5
set nomodelineexpr
set tabstop=2 " Softtabs, 2 spaces
set shiftwidth=2
set shiftround
set expandtab
set textwidth=80 " Make it obvious where 80 characters is
set colorcolumn=+1
set number " Numbers
set numberwidth=5
set relativenumber " Make easy to navigate
set wildmode=list:longest,list:full " enable list of completion
set wildignore+=*/tmp/*,*.so,*.swp,*.zip,*.cache " skip tmp files
set list listchars=tab:»·,trail:·,nbsp:· " Display extra whitespace
set complete+=kspell " Autocomplete with dictionary words when spell check is on
set splitbelow " Open new split panes to right and bottom,
set splitright " which feels more natural
set spelllang=en_us,pt_br " we're trying to be bilingual
set mmp=5000
colorscheme onedark


" == AG and Fuzzy Finder extra configs
if executable('ag')
  " Use Ag over Grep
  let g:ackprg = 'ag --nogroup --nocolor --column'
  "set grepprg=ag\ --nogroup\ --nocolor

  " Use ag in CtrlP for listing files. Lightning fast and respects .gitignore
  " let g:ctrlp_user_command = 'ag %s -l --nocolor --hidden -g ""'
  let g:ctrlp_user_command =
      \ 'ag %s --files-with-matches -g "" --ignore "\.git$\|\.hg$\|\.svn$" --ignore-dir "vcr_cassettes"'

  " ag is fast enough that CtrlP doesn't need to cache
  let g:ctrlp_use_caching = 0
endif
" Default to filename searches
let g:ctrlp_by_filename = 1

" ------------------------------ Key Mappings --------------------------- 
let mapleader = " "
"Clear current search highlight by double tapping //
nmap <silent> // :nohlsearch<CR>

imap jj <Esc>
" Create window splits easier. 
nnoremap <silent> vv <C-w>v
nnoremap <silent> ss <C-w>s

" Don't allow any default key-mappings.
let g:tmux_navigator_no_mappings = 1

nnoremap <silent> <c-h> :TmuxNavigateLeft<cr>
nnoremap <silent> <c-j> :TmuxNavigateDown<cr>
nnoremap <silent> <c-k> :TmuxNavigateUp<cr>
nnoremap <silent> <c-l> :TmuxNavigateRight<cr>

" zoom a vim pane, <C-w>= to re-balance
nnoremap <Leader>- :wincmd _<cr>:wincmd \|<cr>
nnoremap <Leader>= :wincmd =<cr>

" vim reload
nmap <silent> <Leader>vr :so ~/.config/nvim/init.vim<CR>

" ==== NERD tree
  function! CloseNerdTree()
    if g:NERDTree.IsOpen()
      NERDTreeClose
    else
      NERDTreeFind
    endif
  endfunction

" Open the project tree and expose current file in the nerdtree with Ctrl-\
command! LocalCloseNerdTree call CloseNerdTree()
nnoremap <silent> <C-\> :LocalCloseNerdTree<cr>

" Index ctags from any project, including those outside Rails
map <Leader>ct :!ctags -R .<CR>


" ------------------------------ LSP  --------------------------- 
:lua require('lspconfig').pyright.setup{}

set completeopt=menu,menuone

lua <<EOF
  -- Setup nvim-cmp.
   local cmp_status_ok, cmp = pcall(require, "cmp")
   if not cmp_status_ok then
     return
   end

   local snip_status_ok, luasnip = pcall(require, "luasnip")
   if not snip_status_ok then
     return
   end

  require("luasnip/loaders/from_vscode").lazy_load()

   local check_backspace = function()
     local col = vim.fn.col "." - 1
     return col == 0 or vim.fn.getline("."):sub(col, col):match "%s"
   end

  cmp.setup({
    snippet = {
      expand = function(args)
        luasnip.lsp_expand(args.body) 
      end,
    },
    mapping = {
      ['<C-k>'] = cmp.mapping.select_prev_item(),
      ['<C-j>'] = cmp.mapping.select_next_item(),
      ['<C-Space>'] = cmp.mapping(cmp.mapping.complete(), {"i", "c"}),
      ['<C-e>'] = cmp.mapping {
        i = cmp.mapping.abort(),
        c = cmp.mapping.close(),
       },
      ['<CR>'] = cmp.mapping.confirm({ select = true }), -- Accept currently selected item. Set `select` to `false` to only confirm explicitly selected items.
      ['<Tab>'] = cmp.mapping(function(fallback)
        if cmp.visible() then
          cmp.select_next_item()
        elseif luasnip.expandable() then
          luasnip.expand()
        elseif luasnip.expand_or_jumpable() then
          luasnip.expand_or_jump()
        elseif check_backspace() then
          fallback()
        else
          fallback()
        end
        end, {
          "i",
          "s"
        })
      },
    sources = cmp.config.sources({
      { name = 'nvim_lsp' },
      { name = 'luasnip' },
    }, {
      { name = 'buffer' },
    })
  })

  -- Set configuration for specific filetype.
  cmp.setup.filetype('gitcommit', {
    sources = cmp.config.sources({
      { name = 'cmp_git' }, -- You can specify the `cmp_git` source if you were installed it. 
    }, {
      { name = 'buffer' },
    })
  })

  -- Use buffer source for `/` (if you enabled `native_menu`, this won't work anymore).
  cmp.setup.cmdline('/', {
    sources = {
      { name = 'buffer' },
      { name = 'path' }
    }
  })

  -- Use cmdline & path source for ':' (if you enabled `native_menu`, this won't work anymore).
  cmp.setup.cmdline(':', {
    sources = cmp.config.sources({
      { name = 'path' }
    }, {
      { name = 'cmdline' }
    })
  })
 -- Setup lspconfig.
  local capabilities = require('cmp_nvim_lsp').update_capabilities(vim.lsp.protocol.make_client_capabilities())
  -- Replace <YOUR_LSP_SERVER> with each lsp server you've enabled.
  require('lspconfig')['solargraph'].setup {
    capabilities = capabilities
  }
EOF

let g:nvim_tree_indent_markers = 0 
let g:nvim_tree_git_hl = 1 "0 by default, will enable file highlight for git attributes (can be used without the icons).
let g:nvim_tree_highlight_opened_files = 1 "0 by default, will enable folder and file icon highlight for opened files/directories.
let g:nvim_tree_root_folder_modifier = ':~' "This is the default. See :help filename-modifiers for more options
let g:nvim_tree_add_trailing = 0 "0 by default, append a trailing slash to folder names
let g:nvim_tree_group_empty = 1 " 0 by default, compact folders that only contain a single folder into one node in the file tree
let g:nvim_tree_icon_padding = ' ' "one space by default, used for endering the space between the icon and the filename. Use with caution, it could break rendering if you set an empty string depending on your font.
let g:nvim_tree_symlink_arrow = ' >> ' " defaults to ' ➛ '. used as a separator between symlinks' source and target.
let g:nvim_tree_respect_buf_cwd = 1 "0 by default, will change cwd of nvim-tree to that of new buffer's when opening nvim-tree.
let g:nvim_tree_create_in_closed_folder = 1 "0 by default, When creating files, sets the path of a file when cursor is on a closed folder to the parent folder when 0, and inside the folder when 1.
let g:nvim_tree_special_files = { 'README.md': 1, 'Makefile': 1, 'MAKEFILE': 1 } " List of filenames that gets highlighted with NvimTreeSpecialFile
let g:nvim_tree_show_icons = {
    \ 'git': 1,
    \ 'folders': 1,
    \ 'files': 1,
    \ 'folder_arrows': 1,
    \ 'tree_width': 30,
    \ }
"If 0, do not show the icons for one of 'git' 'folder' and 'files'
"1 by default, notice that if 'files' is 1, it will only display
"if nvim-web-devicons is installed and on your runtimepath.
"if folder is 1, you can also tell folder_arrows 1 to show small arrows next to the folder icons.
"but this will not work when you set indent_markers (because of UI conflict)

" default will show icon by default if no icon is provided
" default shows no icon by default
let g:nvim_tree_icons = {
    \ 'default': '',
    \ 'symlink': '',
    \ 'git': {
    \   'unstaged': "✗",
    \   'staged': "✓",
    \   'unmerged': "",
    \   'renamed': "➜",
    \   'untracked': "★",
    \   'deleted': "",
    \   'ignored': "◌"
    \   },
    \ 'folder': {
    \   'arrow_open': "",
    \   'arrow_closed': "",
    \   'default': "",
    \   'open': "",
    \   'empty': "",
    \   'empty_open': "",
    \   'symlink': "",
    \   'symlink_open': "",
    \   }
    \ }

nnoremap <leader>e :NvimTreeToggle<CR>
nnoremap <leader>r :NvimTreeRefresh<CR>
" NvimTreeOpen, NvimTreeClose, NvimTreeFocus, NvimTreeFindFileToggle, and NvimTreeResize are also available if you need them

set termguicolors " this variable must be enabled for colors to be applied properly

" a list of groups can be found at `:help nvim_tree_highlight`
highlight NvimTreeFolderIcon guibg=bluer

:lua require('nvim-tree').setup{}
nnoremap <leader>f <cmd>lua require('telescope.builtin').find_files()<cr>
noremap <leader>g <cmd>lua require('telescope.builtin').live_grep()<cr>
