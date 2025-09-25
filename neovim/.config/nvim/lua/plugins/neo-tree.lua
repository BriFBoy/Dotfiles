return {
  
    "nvim-neo-tree/neo-tree.nvim",
    branch = "v3.x",
    dependencies = {
      "nvim-lua/plenary.nvim",
      "MunifTanjim/nui.nvim",
      "nvim-tree/nvim-web-devicons", 
    },
    lazy = false,
    opts = {
      window = {
        position = "left",
        width = 30,
        mapping_options = {
          noremap = true,
          nowait = true,
        }
      },
      filesystem = {
        filtered_items = {
          visible = false, -- when true, they will just be displayed differently than normal items
          hide_dotfiles = false,
          hide_gitignored = true,
        }
      }
    },
    init = function ()
        vim.keymap.set("n", "<leader>ts", ":Neotree filesystem reveal left<CR>", {desc = "Neotree tree show"})
        vim.keymap.set("n", "<leader>th", ":Neotree close<CR>", {desc = "Neotree tree hide"})
    end
  
}
