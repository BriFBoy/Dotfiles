-- Java: nvim-jdtls (+ java-debug/java-test bundles) and spring-boot.nvim.
-- Needs JDK 25+ on PATH. Exception to the driver pattern: jdtls must
-- start_or_attach per buffer, so this registers its own FileType autocmd.

local mason = require("core.mason")

mason.ensure("jdtls")
mason.ensure("java-debug-adapter")
mason.ensure("java-test")
mason.ensure("vscode-spring-boot-tools")

-- Doc comments: Javadoc. neogen's stock template also emits `@property` for
-- class fields, which isn't a Javadoc tag, so this keeps only the standard
-- block tags in the order Oracle's style guide uses (@param, @return, @throws).
local docgen = require("core.docgen")
local i = docgen.item
docgen.register("java", {
	template = {
		annotation_convention = "javadoc",
		javadoc = {
			{ nil, "/**", { no_results = true, type = { "class", "func", "type" } } },
			{ nil, " * $1", { no_results = true, type = { "class", "func", "type" } } },
			{ nil, " */", { no_results = true, type = { "class", "func", "type" } } },
			{ nil, "/**", { type = { "class", "func", "type" } } },
			{ nil, " * $1", { type = { "class", "func", "type" } } },
			{ nil, " *", { type = { "func" } } },
			{ i.Parameter, " * @param %s $1", { type = { "func" } } },
			{ i.Return, " * @return $1", { type = { "func" } } },
			{ i.Throw, " * @throws %s $1", { type = { "func" } } },
			{ nil, " */", { type = { "class", "func", "type" } } },
		},
	},
})

-- Spring Boot LS (beans, endpoints, properties completion). Must run before
-- jdtls starts: its classpath-handshake handlers have to be in place before
-- jdtls imports a Spring Boot project.
require("spring_boot").setup({})

local packages = vim.fn.stdpath("data") .. "/mason/packages"

-- Jars in java-test that aren't jdtls bundles (per the nvim-jdtls wiki).
local excluded = { "com.microsoft.java.test.runner-jar-with-dependencies.jar", "jacocoagent.jar" }

local function bundles()
	local out = vim.fn.glob(
		packages .. "/java-debug-adapter/extension/server/com.microsoft.java.debug.plugin-*.jar",
		true,
		true
	)
	for _, jar in ipairs(vim.fn.glob(packages .. "/java-test/extension/server/*.jar", true, true)) do
		if not vim.tbl_contains(excluded, vim.fs.basename(jar)) then
			out[#out + 1] = jar
		end
	end
	return vim.list_extend(out, require("spring_boot").java_extensions())
end

local markers = {
	"mvnw",
	"gradlew",
	"pom.xml",
	"build.gradle",
	"build.gradle.kts",
	"settings.gradle",
	"settings.gradle.kts",
	".git",
}

local function start(buf)
	local root = vim.fs.root(buf, markers)
	if not root then
		return
	end
	local ws = vim.fn.stdpath("cache") .. "/jdtls/" .. vim.fs.basename(root) .. "-" .. vim.fn.sha256(root):sub(1, 8)

	require("jdtls").start_or_attach({
		cmd = { "jdtls", "-data", ws },
		root_dir = root,
		-- start_or_attach doesn't inherit vim.lsp.config("*"); reuse core/lsp.lua's.
		capabilities = vim.lsp.config["*"].capabilities,
		settings = { java = { inlayHints = { parameterNames = { enabled = "all" } } } },
		init_options = { bundles = bundles() },
		on_attach = function()
			require("jdtls").setup_dap({ hotcodereplace = "auto" })
			require("jdtls.dap").setup_dap_main_class_configs()
		end,
	}, nil, { bufnr = buf })
end

vim.api.nvim_create_autocmd("FileType", {
	group = vim.api.nvim_create_augroup("lang_java", { clear = true }),
	pattern = "java",
	callback = function(ev)
		start(ev.buf)
	end,
})

-- The FileType event that loaded this driver already fired for this buffer.
start(vim.api.nvim_get_current_buf())
