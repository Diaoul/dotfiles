-- vim: fdm=marker:ts=2:sw=2
local cmd, fn, g, opt = vim.cmd, vim.fn, vim.g, vim.opt

------------
-- Packer --
------------
-- Plugins {{{1
cmd [[packadd packer.nvim]]
local packer = require('packer')
local use = packer.use

packer.startup(function()
  use {'wbthomason/packer.nvim', opt = true}
  use {
    'lewis6991/gitsigns.nvim',
    requires = { 'nvim-lua/plenary.nvim' },
    config = function()
      require('diaoul.gitsigns').config()
    end,
  }
  use {
    'blackCauldron7/surround.nvim',
    config = function()
      require('diaoul.surround').config()
    end,
  }
  use {
    'numToStr/Comment.nvim',
    config = function()
      require('diaoul.comment').config()
    end,
  }
  -- use {
  --   'nvim-treesitter/nvim-treesitter',
  --   requires = {
  --     {
  --       'nvim-treesitter/nvim-treesitter-refactor',
  --       after = 'nvim-treesitter',
  --     },
  --     {
  --       'nvim-treesitter/nvim-treesitter-textobjects',
  --       after = 'nvim-treesitter',
  --     },
  --     {
  --       'nvim-treesitter/playground',
  --       cmd = 'TSPlaygroundToggle',
  --     },
  --   },
  --   run = ':TSUpdate',
  --   config = function()
  --     require('diaoul.treesitter').config()
  --   end,
  -- }
  -- use {
  --   'lewis6991/spellsitter.nvim',
  --   config = function()
  --     require('spellsitter').setup()
  --   end,
  -- }
  use {
    'neovim/nvim-lspconfig',
    setup = function()
        require('diaoul.lsp').setup()
    end,
    config = function()
      require('diaoul.lsp').config()
    end,
  }
  use {
    'L3MON4D3/LuaSnip',
    requires = { 'rafamadriz/friendly-snippets' },
    config = function()
      require('diaoul.luasnip').config()
    end,
  }
  use {
    'hrsh7th/nvim-cmp',
    requires = {
      'hrsh7th/cmp-buffer',
      'hrsh7th/cmp-path',
      'hrsh7th/cmp-nvim-lua',
      'hrsh7th/cmp-nvim-lsp',
      'saadparwaiz1/cmp_luasnip',
      'onsails/lspkind-nvim',
      -- { 'hrsh7th/cmp-buffer', after = 'nvim-cmp' },
      -- { 'hrsh7th/cmp-path', after = 'nvim-cmp' },
      -- { 'hrsh7th/cmp-nvim-lua', after = 'nvim-cmp' },
      -- { 'hrsh7th/cmp-nvim-lsp' },
      -- { 'saadparwaiz1/cmp_luasnip', after = 'nvim-cmp' },
      -- { 'onsails/lspkind-nvim', after = 'nvim-cmp' },
      -- { 'f3fora/cmp-spell', after = 'nvim-cmp' },
    },
    config = function()
      require('diaoul.cmp').config()
    end,
  }
  -- use {
  --   'windwp/nvim-autopairs',
  --   after = { 'nvim-cmp', 'nvim-treesitter' },
  --   config = function()
  --     require('diaoul.autopairs').config()
  --   end,
  -- }
  -- use {
  --   'abecodes/tabout.nvim',
  --   module = 'tabout',
  --   config = function()
  --     require('diaoul.tabout').config()
  --   end,
  --   wants = { 'nvim-treesitter' },
  --   after = { 'nvim-cmp' },
  -- }
  use {
    'nvim-telescope/telescope.nvim',
    module = 'telescope',
    requires = { 'nvim-lua/plenary.nvim' },
    setup = function()
      require('diaoul.telescope').setup()
    end,
    config = function()
      require('diaoul.telescope').config()
    end,
  }
  use {
    'nvim-telescope/telescope-fzf-native.nvim',
    run = 'make',
    after = { 'telescope.nvim' },
    config = function()
      require('telescope').load_extension 'fzf'
    end,
  }
  use {
    'ellisonleao/gruvbox.nvim',
    config = function()
      vim.opt.background = 'dark'
      vim.cmd [[colorscheme gruvbox]]
    end,
  }
  use {
    'feline-nvim/feline.nvim',
    requires = { 'kyazdani42/nvim-web-devicons' },
    config = function()
      require('diaoul.feline').config()
    end,
  }
  use {
    'lukas-reineke/indent-blankline.nvim',
    config = function()
      require('diaoul.indentline').config()
    end,
  }
end)
-- 1}}}

-- TODO
-- - https://github.com/folke/which-key.nvim
-- - https://github.com/RRethy/nvim-treesitter-textsubjects
-- - LSP Status
-- - nvim config structure
-- - inspiration /r/neovim et nvchad
--

-------------------
-- Configuration --
-------------------
-- Utils {{{1
opt.clipboard = 'unnamedplus'
opt.complete:prepend { 'kspell' }
opt.completeopt = { 'menu', 'menuone', 'noselect' }
opt.shortmess:append 'c'

-- restore cursor position
-- cmd [[autocmd BufReadPost * if line("'\"") >= 1 && line("'\"") <= line("$") && @% !~? 'commit' | exe "normal! g`\"" | endif]]

-- commit specific configuration
cmd [[autocmd FileType gitcommit setlocal nonumber norelativenumber spell textwidth=72 colorcolumn=+1]]

-- highlight yanked text briefly
cmd [[autocmd TextYankPost * silent! lua vim.highlight.on_yank()]]

-- resize splits when Vim is resized
cmd [[autocmd VimResized * wincmd =]]

-- Indentation {{{1
opt.expandtab = true
opt.shiftwidth = 4
opt.smartindent = true
opt.tabstop = 4
opt.softtabstop = 4
opt.shiftround = true
opt.joinspaces = false

-- Display {{{1
opt.number = true
opt.relativenumber = true
opt.signcolumn = 'yes:1'
opt.colorcolumn = '80'
opt.cursorline = true
cmd [[
  augroup cursorline_focus
    autocmd!
    autocmd WinEnter * if &bt != 'terminal' | setlocal cursorline
    autocmd WinLeave * if &bt != 'terminal' | setlocal nocursorline
  augroup END
]]
opt.linebreak = true
opt.breakindent = true
opt.showbreak = '↪ '
opt.list = true
opt.listchars = {
  eol = ' ',  -- ¶ ↲
  tab = '→ ',  -- ▸
  precedes = '…',  -- « ‹ ⟨ ❮
  extends = '…',  -- » › ⟩ ❯
  trail = '·',  -- • ¬
  nbsp = '␣',
}
opt.showmatch = true
opt.showmode = false
opt.inccommand = 'nosplit'
g.vimsyn_embed = 'lPr'

-- Title {{{1
opt.title = true
opt.titlestring = '%t (%{expand("%:~:.:h")}) -  Neovim'

-- Folds {{{1
opt.foldmethod = 'syntax'
-- opt.foldexpr = 'nvim_treesitter#foldexpr()'
opt.foldlevelstart = 10

-- Backup {{{1
opt.swapfile = false
opt.backup = false
opt.writebackup = false
opt.undofile = true
opt.confirm = true

-- Search {{{1
opt.ignorecase = true
opt.smartcase = true
opt.scrolloff = 6
-- cmd [[
--   augroup auto-nohlsearch
--     autocmd!
--     autocmd CmdlineEnter /,\? :set hlsearch
--     autocmd CmdlineLeave /,\? :set nohlsearch
--   augroup END
-- ]]
-- TODO
-- opt.grepprg = [[rg --vimgrep --no-heading --smart-case $*]]
-- opt.grepformat:prepend { '%f:%l:%c:%m' }

-- Buffers and windows {{{1
opt.hidden = true
opt.splitbelow = true
opt.splitright = true
opt.fillchars = {
  vert = '│',
  diff = '-', -- alternatives: ⣿ ░
  msgsep = '‾',
  fold = ' ',
  foldopen = '▾',
  foldclose = '▸',
  foldsep = '│',
}

-- Wild {{{1
opt.wildmode = "longest:full,full"
opt.wildignorecase = true
opt.wildignore = {
  '*.aux,*.out,*.toc',
  '*.o,*.obj,*.dll,*.jar,*.pyc,__pycache__,*.rbc,*.class',
  -- media
  '*.ai,*.bmp,*.gif,*.ico,*.jpg,*.jpeg,*.png,*.psd,*.webp',
  '*.avi,*.m4a,*.mp3,*.mp4,*.oga,*.ogg,*.wav,*.webm',
  '*.eot,*.otf,*.ttf,*.woff',
  '*.doc,*.docx,*.xls,*.xlsx*.pdf',
  -- archives
  '*.zip,*.rar,*.tar.gz,*.tar.bz2,*.tar.xz,*.tgz,*.7z',
  -- temp/system
  '*.*~,*~ ',
  '*.swp,.lock,.DS_Store,._*,tags.lock',
  -- version control
  '.git,.svn',
}
opt.wildoptions = 'pum'
opt.pumblend = 10
opt.pumheight = 20

-- Timings {{{1
opt.updatetime = 250

-- Mouse {{{1
opt.mouse = 'a'

-- Colorscheme {{{1
g.gruvbox_sign_column = 'bg0'
g.gruvbox_cursor_line = 'dark0_soft'
g.gruvbox_color_column = 'dark0_soft'
opt.termguicolors = true

-- Terminal {{{1
cmd [[command! Term :botright vsplit term://$SHELL]]
cmd [[
  autocmd TermOpen * setlocal listchars= nonumber norelativenumber nocursorline
  autocmd TermOpen * startinsert
  autocmd BufEnter,BufWinEnter,WinEnter term://* startinsert
  autocmd BufLeave term://* stopinsert
  autocmd TermClose term://* call nvim_input('<CR>')
  autocmd TermClose * call feedkeys("i")
]]

-- Mappings {{{1
local map = vim.api.nvim_set_keymap
g.mapleader = ' '

-- wrapped lines navigation {{{2
map('n', 'j', "v:count ? 'j' : 'gj'", { noremap = true, expr = true })
map('n', 'k', "v:count ? 'k' : 'gk'", { noremap = true, expr = true })
map('n', '<Down>', "v:count ? 'j' : 'gj'", { noremap = true, expr = true })
map('n', '<Up>', "v:count ? 'k' : 'gk'", { noremap = true, expr = true })
map('v', 'j', "v:count ? 'j' : 'gj'", { noremap = true, expr = true })
map('v', 'k', "v:count ? 'k' : 'gk'", { noremap = true, expr = true })
map('v', '<Down>', "v:count ? 'j' : 'gj'", { noremap = true, expr = true })
map('v', '<Up>', "v:count ? 'k' : 'gk'", { noremap = true, expr = true })

-- visual mode move lines
map('v', 'K', ":move '<-2<CR>gv-gv", { noremap = false })
map('v', 'J', ":move '>+1<CR>gv-gv", { noremap = false })

-- window navigation {{{2
map('n', '<C-h>', '<C-w>h', { noremap = false })
map('n', '<C-j>', '<C-w>j', { noremap = false })
map('n', '<C-k>', '<C-w>k', { noremap = false })
map('n', '<C-l>', '<C-w>l', { noremap = false })

-- window resize {{{2
map('n', '<M-h>', '<cmd>vertical resize -2<CR>', { noremap = true })
map('n', '<M-j>', '<cmd>resize -2<CR>', { noremap = true })
map('n', '<M-k>', '<cmd>resize +2<CR>', { noremap = true })
map('n', '<M-l>', '<cmd>vertical resize +2<CR>', { noremap = true })

-- insert mode navigation {{{2
map('i', '<C-h>', '<Left>', { noremap = true })
map('i', '<C-j>', '<Down>', { noremap = true })
map('i', '<C-k>', '<Up>', { noremap = true })
map('i', '<C-l>', '<Right>', { noremap = true })

-- terminal mode navigation
map('t', '<C-h>', '<C-\\><C-N><C-w>h', { noremap = false })
map('t', '<C-j>', '<C-\\><C-N><C-w>j', { noremap = false })
map('t', '<C-k>', '<C-\\><C-N><C-w>k', { noremap = false })
map('t', '<C-l>', '<C-\\><C-N><C-w>l', { noremap = false })
map('t', '<M-C-[>', '<C-\\><C-N>', { noremap = false })

-- command mode navigation with wildmenu support {{{2
map('c', '<Left>', [[wildmenumode() ? "\<Up>" : "\<Left>"]], { noremap = true, expr = true })
map('c', '<Down>', [[wildmenumode() ? "\<Right>" : "\<Down>"]], { noremap = true, expr = true })
map('c', '<Up>', [[wildmenumode() ? "\<Left>" : "\<Up>"]], { noremap = true, expr = true })
map('c', '<Right>', [[wildmenumode() ? " \<BS>\<C-Z>" : "\<Right>"]], { noremap = true, expr = true })
map('c', '<C-h>', '<Left>', { noremap = false })
map('c', '<C-j>', '<Down>', { noremap = false })
map('c', '<C-k>', '<Up>', { noremap = false })
map('c', '<C-l>', '<Right>', { noremap = false })
map('c', '<C-q>', '<Home>', { noremap = false })
map('c', '<C-e>', '<End>', { noremap = false })

-- visual mode indenting preserves selection {{{2
-- note: can also use .
map('v', '<', '<gv', { noremap = true })
map('v', '>', '>gv', { noremap = true })

-- neovim configuration {{{2
map('n', ',e', ':e $MYVIMRC<CR>', { noremap = true })
map('n', ',s', ':luafile $MYVIMRC<CR>', { noremap = true })

-- utils {{{2
map('', 'Y', 'y$', { noremap = true })  -- yank to end of line
map('', 'Q', '', { noremap = true })  -- disable ex mode
map('n', '<C-_>', ':noh<CR>', { noremap = true })  -- ctrl + /: nohighlight
map('n', 'x', '"_x', { noremap = true })  -- delete char without yank
map('v', 'x', '"_x', { noremap = true })  -- delete visual selection without yank
map('v', 'p', '"_dP', { noremap = true }) -- keep paste available in visual mode

-- paste {{{2
opt.pastetoggle = '<F3>'
