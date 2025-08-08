local M = {}
M.init = function()
	vim.snippet.add("l", "console.log($1);")
	vim.snippet.add("lco", "console.log('%c$1%o', 'color: $2;')")
	vim.snippet.add("d", "debugger")
	vim.snippet.add("fn", "function $1 ($2) {\n\t$3\n}")
	vim.snippet.add("efn", "export function $1 ($2) {\n\t$3\n}")
	vim.snippet.add("gei", 'document.getElementById("$1");')
	vim.snippet.add("cn", "const $1 = ($2) => {\n\t$3\n}")
	vim.snippet.add("eaf", "export async function $1 ($2) {\n\t$3\n}")

	-- express/prisma stuff
	vim.snippet.add(
		"dbf",
		[[export async function $1 ($2) {
  return q.run("$1", "$3", {
    $4
  });
}
]]
	)

	vim.snippet.add(
		"nro",
		[[import {Router} from "express";

export const $1 = Router({mergeParams: true});
]]
	)

	vim.snippet.add(
		"nrd",
		[[
$1.$2("$3", async (req, res, next) => {
  $4
})
]]
	)

	vim.snippet.add(
		"ier",
		[[if($1) {
  return next(new InternalServerError())
}
]]
	)

	-- React stuff
	vim.snippet.add("fco", "function $1 ({$2}) {\n\t$3\n}\n\nexport default $1")
	vim.snippet.add("cco", "const $1 = ({$2}) => {\n\t$3\n}\n\nexport default $1")
	vim.snippet.add("usee", "useEffect(() => {\n\t$1\n}, [$2])")

	-- Testing
	vim.snippet.add("tst", 'describe("$1", () => {\n\t it("$2", () => {\n\t$3\n\t}) \n})')
	vim.snippet.add("its", 'it("$1", () => {\n\t$2\n})')
end
return M
