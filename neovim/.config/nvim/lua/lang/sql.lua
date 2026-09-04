local mason = require("core.mason")

mason.ensure("sleek")

require("core.format").register("sql", "sleek")
