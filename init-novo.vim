" ------------------------------ Vim Plug ------------------------------
call plug#begin('~/.local/share/nvim/plugged')

" Finder / tree
Plug 'ctrlpvim/ctrlp.vim'
Plug 'nvim-lua/plenary.nvim'
Plug 'nvim-telescope/telescope.nvim'
Plug 'nvim-tree/nvim-web-devicons'
Plug 'nvim-tree/nvim-tree.lua'

" Ruby / Rails
Plug 'thoughtbot/vim-rspec'
Plug 'keith/rspec.vim'
Plug 'vim-ruby/vim-ruby'
Plug 'vim-scripts/tComment'
Plug 'tpope/vim-rails'

" Tmux
Plug 'tmux-plugins/vim-tmux'
Plug 'christoomey/vim-tmux-runner'
Plug 'christoomey/vim-tmux-navigator'

" Tpope
Plug 'tpope/vim-surround'
Plug 'tpope/vim-repeat'
Plug 'tpope/vim-endwise'
Plug 'tpope/vim-fugitive'

" Git
Plug 'lewis6991/gitsigns.nvim'

" Utils
Plug 'jiangmiao/auto-pairs'
Plug 'alvan/vim-closetag'
Plug 'honza/vim-snippets'
Plug 'janko-m/vim-test'

" Theme / UI
Plug 'navarasu/onedark.nvim'
Plug 'vim-airline/vim-airline'
Plug 'vim-airline/vim-airline-themes'
Plug 'Mofiqul/dracula.nvim'
Plug 'nvim-treesitter/nvim-treesitter', {'do': ':TSUpdate'}

" Completion sem LSP
Plug 'hrsh7th/nvim-cmp'
Plug 'hrsh7th/cmp-buffer'
Plug 'hrsh7th/cmp-path'
Plug 'hrsh7th/cmp-cmdline'
Plug 'L3MON4D3/LuaSnip'
Plug 'rafamadriz/friendly-snippets'
Plug 'saadparwaiz1/cmp_luasnip'

" Wiki
Plug 'vimwiki/vimwiki'

call plug#end()

" ------------------------------ General ------------------------------
set nocompatible
filetype plugin on
syntax on

set backspace=2
set nobackup
set nowritebackup
set noswapfile
set history=1000
set hlsearch
set showcmd
set incsearch
set laststatus=2
set autowrite
set ignorecase
set smartcase
set showmode
set visualbell
set noerrorbells
set nowrap
set modeline
set modelines=5
set nomodelineexpr

set tabstop=2
set shiftwidth=2
set shiftround
set expandtab

set number
set numberwidth=5
set relativenumber
set wildmode=list:longest,list:full
set wildignore+=*/tmp/*,*.so,*.swp,*.zip,*.cache
set list
set listchars=tab:»·,trail:·,nbsp:·
set complete+=kspell
set splitbelow
set splitright
set spelllang=en_us,pt_br
set cursorline
set clipboard+=unnamedplus
set termguicolors

" ------------------------------ Theme ------------------------------
let g:onedark_config = {
      \ 'style': 'warm',
      \ }

silent! colorscheme onedark

" ------------------------------ CtrlP / Ag ------------------------------
if executable('ag')
  let g:ackprg = 'ag --nogroup --nocolor --column'
  let g:ctrlp_user_command =
        \ 'ag %s --files-with-matches -g "" --ignore "\.git$\|\.hg$\|\.svn$" --ignore-dir "vcr_cassettes"'
  let g:ctrlp_use_caching = 0
endif

let g:ctrlp_by_filename = 1

" ------------------------------ Keymaps ------------------------------
let mapleader = " "

nmap <silent> // :nohlsearch<CR>
imap jj <Esc>

nnoremap <silent> vv <C-w>v
nnoremap <silent> ss <C-w>s

let g:tmux_navigator_no_mappings = 1

nnoremap <silent> <C-h> :TmuxNavigateLeft<CR>
nnoremap <silent> <C-j> :TmuxNavigateDown<CR>
nnoremap <silent> <C-k> :TmuxNavigateUp<CR>
nnoremap <silent> <C-l> :TmuxNavigateRight<CR>

nnoremap <Leader>- :wincmd _<CR>:wincmd \|<CR>
nnoremap <Leader>= :wincmd =<CR>

nmap <silent> <Leader>vr :source ~/.config/nvim/init.vim<CR>
map <Leader>ct :!ctags -R .<CR>

nnoremap <leader>e :NvimTreeToggle<CR>
nnoremap <leader>r :NvimTreeRefresh<CR>

nnoremap <leader>f <cmd>lua require('telescope.builtin').find_files()<CR>
nnoremap <leader>g <cmd>lua require('telescope.builtin').live_grep()<CR>

" ------------------------------ Lua Plugins ------------------------------
lua << EOF
local function safe_require(module)
  local ok, result = pcall(require, module)
  if not ok then
    return nil
  end
  return result
end

-- CMP sem LSP
local cmp = safe_require("cmp")
local luasnip = safe_require("luasnip")

if cmp and luasnip then
  local vscode_loader = safe_require("luasnip.loaders.from_vscode")
  if vscode_loader then
    vscode_loader.lazy_load()
  end

  cmp.setup({
    snippet = {
      expand = function(args)
        luasnip.lsp_expand(args.body)
      end,
    },

    mapping = cmp.mapping.preset.insert({
      ['<C-k>'] = cmp.mapping.select_prev_item(),
      ['<C-j>'] = cmp.mapping.select_next_item(),
      ['<C-Space>'] = cmp.mapping.complete(),
      ['<C-e>'] = cmp.mapping.abort(),
      ['<CR>'] = cmp.mapping.confirm({ select = true }),
    }),

    sources = cmp.config.sources({
      { name = 'luasnip' },
      { name = 'buffer' },
      { name = 'path' },
    })
  })

  cmp.setup.cmdline('/', {
    mapping = cmp.mapping.preset.cmdline(),
    sources = {
      { name = 'buffer' }
    }
  })

  cmp.setup.cmdline(':', {
    mapping = cmp.mapping.preset.cmdline(),
    sources = cmp.config.sources({
      { name = 'path' }
    }, {
      { name = 'cmdline' }
    })
  })
end

-- Treesitter
local treesitter = safe_require("nvim-treesitter.configs")
if treesitter then
  treesitter.setup({
    highlight = {
      enable = true,
    },
  })
end

-- NvimTree
local nvim_tree = safe_require("nvim-tree")
if nvim_tree then
  nvim_tree.setup({
    update_focused_file = {
      enable = true,
      update_cwd = true,
      ignore_list = {},
    },
  })
end

-- Gitsigns
local gitsigns = safe_require("gitsigns")
if gitsigns then
  gitsigns.setup()
end
EOF
