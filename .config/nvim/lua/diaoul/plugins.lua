-- Install Packer
local execute = vim.api.nvim_command
local fn = vim.fn

local install_path = fn.stdpath('data')..'/site/pack/packer/start/packer.nvim'

if fn.empty(fn.glob(install_path)) > 0 then
  fn.system({'git', 'clone', 'https://github.com/wbthomason/packer.nvim', install_path})
  execute 'packadd packer.nvim'
end

-- Define plugins
require('packer').startup(function()
  -- Package manager
  use 'wbthomason/packer.nvim'
  -- Git
  use 'tpope/vim-fugitive'
  use {'lewis6991/gitsigns.nvim', requires = {'nvim-lua/plenary.nvim'} }
  -- Comments
  use 'tpope/vim-commentary'         
  -- Autocomplete
  use 'neovim/nvim-lspconfig'
  use 'hrsh7th/nvim-compe'
  -- Fuzzy finder
  use {'nvim-telescope/telescope.nvim', requires = {{'nvim-lua/popup.nvim'}, {'nvim-lua/plenary.nvim'}} }
  -- Theme
  use 'gruvbox-community/gruvbox'
  -- Status line
  use 'itchyny/lightline.vim'
  -- Indentation mark
  use { 'lukas-reineke/indent-blankline.nvim', branch = "lua" }
  -- Markdown preview
  use {'iamcco/markdown-preview.nvim', config = "vim.call('mkdp#util#install')"}
end)
