-- This is my personal Nvim configuration supporting Mac, Linux and Windows, with various plugins configured.
-- This configuration evolves as I learn more about Nvim and become more proficient in using Nvim.
-- Since it is very long (more than 1000 lines!), you should read it carefully and take only the settings that suit you.
-- I would not recommend cloning this repo and replace your own config. Good configurations are personal,
-- built over time with a lot of polish.
--
-- Author: Jie-dong Hao
-- Email: jdhao@hotmail.com
-- Blog: https://jdhao.github.io/

local api = vim.api
local utils = require("utils")

-- check if we have the latest stable version of nvim
local expected_ver = "0.8.1"
local nvim_ver = utils.get_nvim_version()

if nvim_ver ~= expected_ver then
  local msg = string.format("Unsupported nvim version: expect %s, but got %s instead!", expected_ver, nvim_ver)
  api.nvim_err_writeln(msg)
  return
end

local core_conf_files = {
  "globals.lua", -- some global settings
  "options.vim", -- setting options in nvim
  "autocommands.vim", -- various autocommands
  "mappings.lua", -- all the user-defined mappings
  "plugins.vim", -- all the plugins installed and their configurations
  "colorschemes.lua", -- colorscheme settings
}

-- source all the core config files
for _, name in ipairs(core_conf_files) do
  local path = string.format("%s/core/%s", vim.fn.stdpath("config"), name)
  local source_cmd = "source " .. path
  vim.cmd(source_cmd)
end

-- Telescope settings (Install & Setup)
local Plug = vim.fn['plug#']
vim.call('plug#begin', '~/.config/nvim/plugged')
Plug 'nvim-telescope/telescope.nvim'
vim.call('plug#end')

local telescope_setup, telescope = pcall(require, "telescope")
if not telescope_setup then
  return
end

-- import telescope actions safely
local actions_setup, actions = pcall(require, "telescope.actions")
if not actions_setup then
  return
end

-- configure telescope
telescope.setup({
  -- configure custom mappings
  defaults = {
    mappings = {
      i = {
        ["<C-k>"] = actions.move_selection_previous, -- move to prev result
        ["<C-j>"] = actions.move_selection_next, -- move to next result
        ["<C-q>"] = actions.send_selected_to_qflist + actions.open_qflist, -- send selected to quickfixlist
      },
    },
  },
})
