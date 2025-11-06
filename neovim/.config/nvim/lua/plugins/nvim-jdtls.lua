return {
	"mfussenegger/nvim-jdtls",
	ft = "java",
	config = function()
		vim.api.nvim_create_autocmd("FileType", {
			pattern = "java",
			callback = function(args)
				local jdtls = require("jdtls")
				local root_dir = require("jdtls.setup").find_root({ ".git", "mvnw", "gradlew" })
				local workspace_folder = vim.fn.stdpath("data") .. "/jdtls/" .. vim.fn.fnamemodify(root_dir, ":p:h:t")

				local config = {
					cmd = { "jdtls", "-data", workspace_folder },
					root_dir = root_dir,
					settings = {
						java = {
							signatureHelp = { enabled = true },
							contentProvider = { preferred = "fernflower" },
						},
					},
					init_options = {
						bundles = {
							vim.fn.glob(
								vim.fn.stdpath("data")
									.. "/mason/packages/java-debug-adapter/extension/server/com.microsoft.java.debug.plugin-*.jar"
							),
						},
					},
				}

				jdtls.start_or_attach(config)
				jdtls.setup_dap({ hotcodereplace = "auto" })
			end,
		})
	end,
}
