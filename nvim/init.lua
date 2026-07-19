vim.opt.number = true
vim.opt.relativenumber = true
vim.opt.wrap = false

vim.opt.expandtab = true
vim.opt.tabstop = 4
vim.opt.shiftwidth = 4
vim.opt.softtabstop = 4

vim.opt.hlsearch = false

vim.opt.clipboard = ""

vim.opt.pumheight = 6    

vim.pack.add({
    "https://github.com/christoomey/vim-tmux-navigator",
    "https://github.com/neanias/everforest-nvim",
    "https://github.com/nvim-tree/nvim-web-devicons",
    "https://github.com/nvim-lualine/lualine.nvim",
    "https://github.com/nvim-treesitter/nvim-treesitter",
    "https://github.com/nvim-treesitter/nvim-treesitter-context",
    "https://github.com/norcalli/nvim-colorizer.lua",
    "https://github.com/nvim-mini/mini.icons",
    "https://github.com/stevearc/oil.nvim",
    "https://github.com/nvim-mini/mini.pairs",
    "https://github.com/nvim-mini/mini.comment",
    "https://github.com/mason-org/mason.nvim",
    "https://github.com/mason-org/mason-lspconfig.nvim",
    "https://github.com/neovim/nvim-lspconfig",
    "https://github.com/nvim-mini/mini.completion",
    "https://github.com/nvim-lua/plenary.nvim",
    "https://github.com/nvim-telescope/telescope.nvim",
    "https://github.com/folke/flash.nvim",
})

vim.opt.completeopt = { "menuone", "noselect" }

local function imap_expr(lhs, rhs)
  vim.keymap.set('i', lhs, rhs, { expr = true })
end

imap_expr('<Tab>',    [[pumvisible() ? "\<C-n>" : "\<Tab>"]])
imap_expr('<S-Tab>', [[pumvisible() ? "\<C-p>" : "\<S-Tab>"]])

-- Normal & visual mode: yank to system clipboard
vim.keymap.set({ "n", "x" }, "y", '"+y', { noremap = true, silent = true })
-- Paste from system clipboard 
vim.keymap.set("n", "p", '"+p', { noremap = true, silent = true })

vim.g.mapleader = " "

vim.keymap.set("n", "<C-d>", "<C-d>zz")
vim.keymap.set("n", "<C-u>", "<C-u>zz")
vim.keymap.set("n", "<C-f>", "<C-f>zz")
vim.keymap.set("n", "<C-b>", "<C-b>zz")
vim.keymap.set("n", "<leader>o", "<cmd>Oil --float<cr>")

vim.keymap.set('n', 'gl', '<cmd>lua vim.diagnostic.open_float()<CR>')

local builtin = require('telescope.builtin')

-- Files
vim.keymap.set('n', '<leader>ff', builtin.find_files, { desc = 'Find files' })
-- Search in current buffer
vim.keymap.set('n', '<leader>fs', builtin.current_buffer_fuzzy_find, { desc = 'Search in current buffer' })
-- Project-wide search (needs ripgrep)
vim.keymap.set('n', '<leader>fg', builtin.live_grep, { desc = 'Live grep in project' })
-- Open buffers
vim.keymap.set('n', '<leader>fb', builtin.buffers, { desc = 'Find buffers' })

vim.keymap.set(
  { "n", "x", "o" },  -- normal, visual, operator-pending
  "<leader>s",
  function() require("flash").jump() end,
  { desc = "Flash jump" }
)

require("everforest").setup({
    transparent_background_level = 1,
    float_style = "bright",
})

vim.cmd([[colorscheme everforest]])

require("lualine").setup({
  options = {
    -- ... other configuration
    theme = "everforest", -- Can also be "auto" to detect automatically.
  }
})

require('nvim-treesitter').setup {
  -- Directory to install parsers and queries to (prepended to `runtimepath` to have priority)
  install_dir = vim.fn.stdpath('data') .. '/site'
}

require('nvim-treesitter').install {
  'c',
  'lua',
  'python',
  'java',
  'rust',
  'html',
  'css',
  'javascript',
}

vim.api.nvim_create_autocmd('FileType', {
  pattern = { 'c', 'cpp', 'h', 'python', 'java', 'rust', 'html', 'css', 'javascript' },
  callback = function() vim.treesitter.start() end,
})


require('colorizer').setup()
require("oil").setup({
    view_options = {
    show_hidden = true
    }
})
require('mini.pairs').setup()
require("mason").setup()

require("flash").setup({

})

require("mason-lspconfig").setup {
    ensure_installed = { "lua_ls", "rust_analyzer", "clangd", "jdtls", "html", "cssls", "pyright" },
}


require('mini.completion').setup({
  lsp_completion = {
    source_func = 'omnifunc',
    auto_setup = false,    
  },
  window = {
    info = {
      height = 10,   -- max height of info window
      width  = 50,   -- max width of info window
      border = 'single',
    },
    signature = {
      height = 8,    -- max height of signature window
      width  = 50,
      border = 'single',
    },
  },

})

-- When an LSP client attaches, enable mini.completion for that buffer
vim.api.nvim_create_autocmd('LspAttach', {
  callback = function(args)
    vim.bo[args.buf].omnifunc = 'v:lua.MiniCompletion.completefunc_lsp'
  end,
})

vim.lsp.config('*', {
  on_attach = function(client, bufnr)
    local opts = { buffer = bufnr, silent = true }
    local tb = require('telescope.builtin')
    
    vim.keymap.set('n', 'gd', vim.lsp.buf.definition, opts)
    vim.keymap.set('n', 'gf', vim.lsp.buf.declaration, opts)
    vim.keymap.set('n', 'gi', vim.lsp.buf.implementation, opts)
    vim.keymap.set('n', 'gr', vim.lsp.buf.references, opts)

    vim.keymap.set('n', 'K', vim.lsp.buf.hover, opts)
    vim.keymap.set('n', '<leader>rn', vim.lsp.buf.rename, opts)
    vim.keymap.set({ 'n', 'v' }, '<leader>ca', vim.lsp.buf.code_action, opts)

    vim.keymap.set('n', '[d', vim.diagnostic.goto_prev, opts)
    vim.keymap.set('n', ']d', vim.diagnostic.goto_next, opts)
    vim.keymap.set('n', '<leader>e', vim.diagnostic.open_float, opts)
  end,

  -- Tell LSP what completion capabilities we support via mini.completion
  capabilities = require('mini.completion').get_lsp_capabilities(),
})

-- Per-server configs (minimal)
vim.lsp.config('clangd', {
  cmd = { 'clangd' },
  filetypes = { 'c', 'cpp', 'objc', 'objcpp' },
})

vim.lsp.config('pyright', {
  cmd = { 'pyright-langserver', '--stdio' },
  filetypes = { 'python' },
})

vim.lsp.config('jdtls', {
  cmd = { 'jdtls' },
  filetypes = { 'java' },
})

vim.lsp.config('rust_analyzer', {
  cmd = { 'rust-analyzer' },
  filetypes = { 'rust' },
})

vim.lsp.config('html', {
  cmd = { 'vscode-html-language-server', '--stdio' },
  filetypes = { 'html' },
})

vim.lsp.config('cssls', {
  cmd = { 'vscode-css-language-server', '--stdio' },
  filetypes = { 'css', 'scss', 'less' },
})

-- Enable the servers; Neovim will start them as needed
vim.lsp.enable({
  'clangd',
  'pyright',
  'jdtls',
  'rust_analyzer',
  'html',
  'cssls',
  'tsserver',
  'lua_ls' 
})

-- Toggle LSP diagnostics for the current buffer
local diagnostics_active = true

vim.keymap.set('n', '<leader>td', function()
  diagnostics_active = not diagnostics_active

  if diagnostics_active then
    -- enable diagnostics in current buffer
    vim.diagnostic.show(nil, 0)
  else
    -- hide diagnostics in current buffer
    vim.diagnostic.hide(nil, 0)
  end
end, { noremap = true, silent = true, desc = 'Toggle LSP diagnostics' })

local telescope = require('telescope')
local actions = require('telescope.actions')

telescope.setup({
  defaults = {
    mappings = {
      i = {
        ["<C-q>"] = actions.send_to_qflist + actions.open_qflist,
      },
      n = {
        ["<C-q>"] = actions.send_to_qflist + actions.open_qflist,
      },
    },
  },
  pickers = {
    -- Example: no preview when searching current buffer
    current_buffer_fuzzy_find = {
      previewer = false,
    },
  },
})
