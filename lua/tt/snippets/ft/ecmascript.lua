local snippets = require("tt.snippets")
local M = {}
M.init = function()
	snippets.add("l", "console.log($1);")
	snippets.add("lco", "console.log('%c$1%o', 'color: $2;')")
	snippets.add("d", "debugger")
	snippets.add("fn", "function $1 ($2) {\n\t$3\n}")
	snippets.add("efn", "export function $1 ($2) {\n\t$3\n}")
	snippets.add("gei", 'document.getElementById("$1");')
	snippets.add("cn", "const $1 = ($2) => {\n\t$3\n}")
	snippets.add("eaf", "export async function $1 ($2) {\n\t$3\n}")

	-- express/prisma stuff
	snippets.add(
		"dbf",
		[[export async function $1 ($2) {
  return q.run("$1", "$3", {
    $4
  });
}
]]
	)

	snippets.add(
		"nro",
		[[import {Router} from "express";

export const $1 = Router({mergeParams: true});
]]
	)

	snippets.add(
		"nrd",
		[[
$1.$2("$3", async (req, res, next) => {
  $4
})
]]
	)

	snippets.add(
		"ier",
		[[if($1) {
  return next(new InternalServerError())
}
]]
	)

	-- React stuff
	snippets.add("fco", "function $1 ({$2}) {\n\t$3\n}\n\nexport default $1")
	snippets.add("cco", "const $1 = ({$2}) => {\n\t$3\n}\n\nexport default $1")
	snippets.add("usee", "useEffect(() => {\n\t$1\n}, [$2])")

	-- Testing
	snippets.add("tst", 'describe("$1", () => {\n\t it("$2", () => {\n\t$3\n\t}) \n})')
	snippets.add("its", 'it("$1", () => {\n\t$2\n})')
end
return M
