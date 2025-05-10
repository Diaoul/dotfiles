-- based off LazyVim: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/options.lua
vim.g.mapleader = " "
vim.g.maplocalleader = "\\"

local opt = vim.opt

opt.autowrite = true -- Enable auto write
opt.clipboard = "unnamedplus" -- Sync with system clipboard
opt.completeopt = "menu,menuone,noselect"
opt.conceallevel = 3 -- Hide * markup for bold and italic
opt.confirm = true -- Confirm to save changes before exiting modified buffer
opt.cursorline = true -- Enable highlighting of the current line
opt.expandtab = true -- Use spaces instead of tabs
opt.formatoptions = "jcroqlnt" -- Default is tcqj
opt.grepformat = "%f:%l:%c:%m" -- With ripgrep
opt.grepprg = "rg --vimgrep" -- Use ripgrep
opt.ignorecase = true -- Ignore case
opt.inccommand = "nosplit" -- Preview incremental substitute
opt.laststatus = 3 -- Global statusline
opt.list = true -- Show some invisible characters (tabs...
opt.listchars = {
  eol = " ", -- ¶ ↲
  tab = "→ ", -- ▸
  precedes = require("diaoul.config").icons.dots, -- … 󰇘 « ‹ ⟨ ❮
  extends = require("diaoul.config").icons.dots, -- … 󰇘 » › ⟩ ❯
  trail = "·", -- · • ¬
  nbsp = "␣",
}
opt.mouse = "a" -- Enable mouse mode
opt.mousemoveevent = true -- Enabled for plugins to detect hovers
opt.number = true -- Print line number
opt.pumblend = 10 -- Popup blend
opt.pumheight = 10 -- Maximum number of entries in a popup
opt.relativenumber = true -- Relative line numbers
opt.scrolloff = 8 -- Lines of context
opt.shiftround = true -- Round indent
opt.shiftwidth = 2 -- Size of an indent
opt.shortmess:append({ W = true, I = true, c = true, C = true })
opt.showmode = false -- Dont show mode since we have a statusline
opt.sidescrolloff = 8 -- Columns of context
opt.signcolumn = "yes" -- Always show the signcolumn, otherwise it would shift the text each time
opt.smartcase = true -- Don't ignore case with capitals
opt.smartindent = true -- Insert indents automatically
opt.splitbelow = true -- Put new windows below current
opt.splitkeep = "screen" -- Keep text on the same screen line
opt.splitright = true -- Put new windows right of current
opt.tabstop = 2 -- Number of spaces tabs count for
opt.termguicolors = true -- True color support
opt.timeoutlen = 300 -- Timeout for mapped sequences
opt.undofile = true -- Save undo history
opt.undolevels = 10000 -- Maximum number of changes that can be undone
opt.updatetime = 250 -- Save swap file and trigger CursorHold
opt.virtualedit = "block" -- Allow cursor to move where there is no text in visual block mode
opt.wildmode = "longest:full,full" -- Command-line completion mode
opt.winminwidth = 5 -- Minimum window width
opt.winborder = "none" -- Default border style for all floating windows
opt.wrap = false -- Line wrap
opt.linebreak = true -- Break long lines smartly
opt.breakindent = true -- Ident broken lines
opt.showbreak = "↪ " -- Broken lines character
opt.fillchars = {
  fold = " ", -- . -
  foldopen = "", --    ▾
  foldclose = "", --    ▸
  foldsep = " ", -- │ |
  diff = "-", --  ⣿ ░
  eob = " ", -- ~
}
opt.smoothscroll = true -- Scroll with screen lines (in case of wrap)

-- Folding
opt.foldlevel = 99
opt.foldtext = "v:lua.vim.treesitter.foldtext()"
opt.foldmethod = "indent"
opt.foldexpr = "v:lua.vim.treesitter.foldexpr()"
opt.foldlevelstart = 10
opt.foldnestmax = 5
opt.foldminlines = 1

-- Status column (unused, set by statuscol.nvim)
-- opt.statuscolumn = [[%!v:lua.require'diaoul.config.ui'.statuscolumn()]]

-- Formating
vim.o.formatexpr = "v:lua.require'conform'.formatexpr()"

-- Fix markdown indentation settings
vim.g.markdown_recommended_style = 0

-- Title
opt.title = true
opt.titlestring = '%t (%{expand("%:~:.:h")}) -  Neovim'

-- Wild
opt.wildignorecase = true
opt.wildignore = {
  "*.aux,*.out,*.toc",
  "*.o,*.obj,*.dll,*.jar,*.pyc,__pycache__,*.rbc,*.class",
  -- media
  "*.ai,*.bmp,*.gif,*.ico,*.jpg,*.jpeg,*.png,*.psd,*.webp",
  "*.avi,*.m4a,*.mp3,*.mp4,*.oga,*.ogg,*.wav,*.webm",
  "*.eot,*.otf,*.ttf,*.woff",
  "*.doc,*.docx,*.xls,*.xlsx*.pdf",
  -- archives
  "*.zip,*.rar,*.tar.gz,*.tar.bz2,*.tar.xz,*.tgz,*.7z",
  -- temp/system
  "*.*~,*~ ",
  "*.swp,.lock,.DS_Store,._*,tags.lock",
  -- version control
  ".git,.svn",
}
opt.wildoptions = "pum"

-- Disable providers
vim.g.loaded_python3_provider = 0
vim.g.loaded_node_provider = 0
vim.g.loaded_perl_provider = 0
vim.g.loaded_ruby_provider = 0
