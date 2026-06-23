local langs = {
  "bash",
  "comment",
  "css",
  "dockerfile",
  "gitcommit",
  "gitignore",
  "go",
  "html",
  "htmldjango",
  "http",
  "javascript",
  "json",
  "just",
  "kotlin",
  "lua",
  "markdown",
  "markdown_inline",
  "python",
  "query",
  "rust",
  "terraform",
  "toml",
  "typescript",
  "vim",
  "vimdoc",
  "vue",
  "yaml",
}

-- Based on https://github.com/nvim-treesitter/nvim-treesitter/discussions/8621#discussioncomment-16411732
local install_or_enable_lang = function(bufnr, lang)
  if not vim.treesitter.language.add(lang) then
    -- The language is not available, we should install it

    -- Some tracking to avoid some warning about missing parsers or something like that
    local available = vim.g.ts_available or require("nvim-treesitter").get_available()
    if not vim.g.ts_available then vim.g.ts_available = available end

    if vim.tbl_contains(available, lang) then require("nvim-treesitter").install(lang) end
  end

  if vim.treesitter.language.add(lang) then
    -- Highlighting
    vim.treesitter.start(bufnr, lang)

    -- Indent
    vim.bo.indentexpr = "v:lua.require'nvim-treesitter'.indentexpr()"

    -- Folding
    vim.wo[0][0].foldexpr = "v:lua.vim.treesitter.foldexpr()"
    vim.wo[0][0].foldmethod = "expr"
  end
end

return {
  {
    "nvim-treesitter/nvim-treesitter",
    lazy = false,
    build = ":TSUpdate",
    config = function(opts)
      require("nvim-treesitter").setup(opts)
      -- Make sure the list of languages that I want for sure to be installed are there
      require("nvim-treesitter").install(langs)

      -- Setup
      vim.api.nvim_create_autocmd("FileType", {
        pattern = { "*" },
        callback = function(args)
          local ft = vim.bo[args.buf].filetype
          local lang = vim.treesitter.language.get_lang(ft)
          install_or_enable_lang(args.buf, lang)
        end,
      })
    end,
  },
  {
    "nvim-treesitter/nvim-treesitter-textobjects",
    branch = "main",
    init = function()
      -- Disable entire built-in ftplugin mappings to avoid conflicts.
      vim.g.no_plugin_maps = true
    end,
    config = function()
      require("nvim-treesitter-textobjects").setup({
        -- FIXME(alvaro): In the old config we disabled rust and typescript
        select = {
          -- You can use capture groups defined in textobjects.scm
          keymaps = {
            ["if"] = "@function.inner",
            ["af"] = "@function.outer",
            ["ic"] = "@class.inner",
            ["ac"] = "@class.outer",
            ["ia"] = "@parameter.inner",
            ["aa"] = "@parameter.outer",
            ["ib"] = "@block.inner",
            ["ab"] = "@block.outer",
          },
          include_surrounding_whitespace = true,
          selection_modes = {
            -- Make these selections line wise instead of characterwise
            ["@function.inner"] = "V",
            ["@function.outer"] = "V",
            ["@class.inner"] = "V",
            ["@class.outer"] = "V",
            ["@block.outer"] = "V",
          },
        },
      })

      -- Swap keymaps
      vim.keymap.set(
        "n",
        "<Leader>a",
        function() require("nvim-treesitter-textobjects.swap").swap_next("@parameter.inner") end
      )
      vim.keymap.set(
        "n",
        "<Leader>A",
        function() require("nvim-treesitter-textobjects.swap").swap_previous("@parameter.outer") end
      )
    end,
  },
  {
    "nvim-treesitter/nvim-treesitter-context",
    dependencies = { "nvim-treesitter/nvim-treesitter" },
    opts = {
      max_lines = 5,
      min_window_height = 20,
    },
  },
}
