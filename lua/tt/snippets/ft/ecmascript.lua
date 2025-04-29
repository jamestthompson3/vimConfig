vim.snippet.add("l", "console.log($1);")
vim.snippet.add("lco", "console.log('%c$1%o', 'color: $2;')")
vim.snippet.add("d", "debugger")
vim.snippet.add("fn", "function $1 ($2) {\n\t$3\n}")
vim.snippet.add("efn", "export function $1 ($2) {\n\t$3\n}")
vim.snippet.add("gei", 'document.getElementById("$1");')
-- snippet("cn", fmt("const {} = ({}) => {{\n\t{}\n}}", { i(1), i(2), i(3) })),
--   snippet("eaf", fmt("export async function {} ({}) {{\n\t{}\n}}", { i(1), i(2), i(3) })),
--   -- express/prisma stuff
--   snippet("dbf",
--     fmt(
--       [[export async function {} ({}) {{
--         return q.run("{}", "{}", {{
--         {}
--       }});
--   }}
--       ]],
--       { i(1), i(2), rep(1), i(3), i(4) })),
--   snippet("nro",
--     fmt(
--       [[import {{Router}} from "express";
--
--      export const {} = Router({{mergeParams: true}});
--     ]],
--       { i(1) }
--     )
--   ),
--   snippet("nrd",
--     fmt(
--       [[
--   {}.{}("{}", async (req, res, next) => {{
--     {}
--   }})
-- ]],
--       { i(1), i(2), i(3), i(4) }
--     )
--   ),
--   snippet("ier", fmt(
--     [[if({}) {{
--      return next(new InternalServerError())
--    }}
--    ]], { i(1) }
--   )),
--   -- React stuff
--   snippet("fco", fmt("function {} ({{{}}}) {{\n\t{}\n}}\n\nexport default {}", { i(1), i(2), i(3), rep(1) })),
--   snippet("cco", fmt("const {} = ({{{}}}) => {{\n\t{}\n}}\n\nexport default {}", { i(1), i(2), i(3), rep(1) })),
--   snippet("usee", fmt("useEffect(() => {{\n\t{}\n}}, [{}])", { i(0), i(1) })),
--   -- Testing
--   snippet("tst", fmt('describe("{}", () => {{\n\t it("{}", () => {{\n\t{}\n\t}}) \n}})', { i(1), i(2), i(3) })),
--   snippet("its", fmt('it("{}", () => {{\n\t{}\n}})', { i(1), i(2) })),
-- }
--
-- return M
