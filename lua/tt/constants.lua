local M = {}

M.prettier_roots = {
	".prettierrc",
	".prettierrc.json",
	".prettierrc.js",
	".prettierrc.yml",
	".prettierrc.yaml",
	".prettierrc.json5",
	".prettierrc.mjs",
	".prettierrc.cjs",
	".prettierrc.toml",
}

M.eslint_roots = {
	"eslint.config.js",
	"eslint.config.mjs",
	"eslint.config.cjs",
	"eslint.config.ts",
	"eslint.config.mts",
	"eslint.config.cts",
	".eslintrc",
}

M.biome_roots = {
	"biome.json",
	"biome.jsonc",
}

return M
