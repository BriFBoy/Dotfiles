vim.lsp.config["jdtls"] = {
	settings = {
		java = {
			contentProvider = { preferred = "fernflower" },
			signatureHelp = {
				enabled = true,
			},
			inlayHints = {
				parameterNames = {
					enabled = "all",
				},
			},
		},
	},
}

vim.api.nvim_create_autocmd("FileType", {
	pattern = "java",
	callback = function()
		local jdtls = require("jdtls")
		local root_dir = require("jdtls.setup").find_root({ ".git", "mvnw", "gradlew" })
		local workspace_folder = vim.fn.stdpath("data") .. "/jdtls/" .. vim.fn.fnamemodify(root_dir, ":p:h:t")

		local config = {
			cmd = { "jdtls", "-data", workspace_folder },
			root_dir = root_dir,
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
