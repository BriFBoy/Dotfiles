local config = {
	cmd = { "jdtls" },
	root_dir = vim.fs.root(0, { "gradlew", ".git", "mvnw" }),
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

require("jdtls").start_or_attach(config)
