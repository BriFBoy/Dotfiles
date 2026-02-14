return {
	name = "Java: Run project",
	condition = {
		filetype = {
			"javascript",
		},
	},
	builder = function()
		local env_loader = require("utils.env")
		local cwd = vim.fn.getcwd()
		local env = env_loader.load_env(cwd .. "/.env")
		local has_pom = vim.fn.filereadable(cwd .. "/pom.xml") == 1
		local has_gradle = (
			vim.fn.filereadable(cwd .. "/build.gradle") == 1 or vim.fn.filereadable(cwd .. "/build.gradle.kts") == 1
		)
		local is_spring_boot = false

		-- Detect Spring Boot
		if has_pom then
			local pom = table.concat(vim.fn.readfile(cwd .. "/pom.xml"), "\n")
			is_spring_boot = pom:match("spring%-boot") ~= nil
		elseif has_gradle then
			local gradle = table.concat(vim.fn.readfile(cwd .. "/build.gradle"), "\n")
			is_spring_boot = gradle:match("spring%-boot") ~= nil
		end
		-- If no Java project is detected, return a harmless dummy task
		if not has_pom and not has_gradle then
			return {
				cmd = { "echo" },
				args = { "No Maven or Gradle project detected in: " .. cwd },
				env = env,
				components = { "default", "open_output" },
			}
		end
		-- Spring Boot (Maven)
		if is_spring_boot and has_pom then
			return {
				cmd = { "mvn" },
				args = { "spring-boot:run" },
				cwd = cwd,
				env = env,
				components = { "default", "open_output" },
			}
		end

		-- Spring Boot (Gradle)
		if is_spring_boot and has_gradle then
			return {
				cmd = { "./gradlew" },
				args = { "bootRun" },
				cwd = cwd,
				env = env,
				components = { "default", "open_output" },
			}
		end

		-- Maven Exec Plugin
		if has_pom then
			return {
				cmd = { "mvn" },
				args = { "exec:java" },
				cwd = cwd,
				env = env,
				components = { "default", "open_output" },
			}
		end

		-- Gradle Application Plugin
		if has_gradle then
			return {
				cmd = { "./gradlew" },
				args = { "run" },
				cwd = cwd,
				env = env,
				components = { "default", "open_output" },
			}
		end

		-- No Java build system found
		vim.notify("No Maven or Gradle project detected.", vim.log.levels.ERROR)
	end,
}
