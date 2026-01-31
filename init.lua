-- HELLO, welcome to NormalNvim!
-- ---------------------------------------
-- This is the entry point of your config.
-- ---------------------------------------

local function load_source(source)
  local status_ok, error = pcall(require, source)
  if not status_ok then
    vim.api.nvim_echo(
      {{"Failed to load " .. source .. "\n\n" .. error}}, true, {err = true}
    )
  end
end

local function load_sources(source_files)
  vim.loader.enable()
  for _, source in ipairs(source_files) do
    load_source(source)
  end
end

local function load_sources_async(source_files)
  for _, source in ipairs(source_files) do
    vim.defer_fn(function()
      load_source(source)
    end, 50)
  end
end

local function load_colorscheme(colorscheme)
    if vim.g.default_colorscheme then
      if not pcall(vim.cmd.colorscheme, colorscheme) then
        require("base.utils").notify(
          "Error setting up colorscheme: " .. colorscheme,
          vim.log.levels.ERROR
        )
      end
    end
end

-- Call the functions defined above.
load_sources({
  "base.1-options",
  -- Modern plugin manager: lazy.nvim
  local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
  if not vim.loop.fs_stat(lazypath) then
    vim.fn.system({
      "git", "clone", "--filter=blob:none",
      "https://github.com/folke/lazy.nvim.git", lazypath
    })
  end
  vim.opt.rtp:prepend(lazypath)
  require("lazy").setup(require("plugins.plugins"))
  -- End lazy.nvim setup
  "base.3-autocmds", -- critical stuff, don't change the execution order.
})
load_colorscheme(vim.g.default_colorscheme)
load_sources_async({ "base.4-mappings" })

-- Modern Neovim settings (add more as needed)
vim.opt.number = true
vim.opt.relativenumber = true
vim.opt.termguicolors = true
vim.opt.expandtab = true
vim.opt.shiftwidth = 2
vim.opt.tabstop = 2
vim.opt.smartindent = true
vim.opt.cursorline = true
vim.opt.clipboard = "unnamedplus"

-- Theme (pick one)
vim.cmd.colorscheme "catppuccin"
-- vim.cmd.colorscheme "tokyonight"
-- vim.cmd.colorscheme "onedark"
-- vim.cmd.colorscheme "rose-pine"

-- Add more config as needed for LSP, completion, treesitter, etc.
-- See plugin docs for details.
