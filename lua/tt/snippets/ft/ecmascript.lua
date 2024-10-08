local ls = require("luasnip")

local snippet = ls.s
local fmt = require("luasnip.extras.fmt").fmt
local rep = require("luasnip.extras").rep

local i = ls.insert_node
local t = ls.text_node

local M = {
  snippet("l", fmt("console.log({});", { i(1) })),
  snippet("lco", fmt("console.log('%c{}%o', 'color: {};')", { i(1), i(2) })),
  snippet("d", { t("debugger") }),
  snippet("fn", fmt("function {} ({}) {{\n\t{}\n}}", { i(1), i(2), i(3) })),
  snippet("cn", fmt("const {} = ({}) => {{\n\t{}\n}}", { i(1), i(2), i(3) })),
  snippet("eaf", fmt("export async function {} ({}) {{\n\t{}\n}}", { i(1), i(2), i(3) })),
  -- express/prisma stuff
  snippet("dbf",
    fmt(
      [[export async function {} ({}) {{
        return q.run("{}", "{}", {{
        {}
      }});
  }}
      ]],
      { i(1), i(2), rep(1), i(3), i(4) })),
  snippet("nro",
    fmt(
      [[import {{Router}} from "express";

     export const {} = Router({{mergeParams: true}});
    ]],
      { i(1) }
    )
  ),
  snippet("nrd",
    fmt(
      [[
  {}.{}("{}", async (req, res, next) => {{
    {}
  }})
]],
      { i(1), i(2), i(3), i(4) }
    )
  ),
  snippet("ier", fmt(
    [[if({}) {{
     return next(new InternalServerError())
   }}
   ]], { i(1) }
  )),
  -- React stuff
  snippet("fco", fmt("function {} ({{{}}}) {{\n\t{}\n}}\n\nexport default {}", { i(1), i(2), i(3), rep(1) })),
  snippet("cco", fmt("const {} = ({{{}}}) => {{\n\t{}\n}}\n\nexport default {}", { i(1), i(2), i(3), rep(1) })),
  snippet("usee", fmt("useEffect(() => {{\n\t{}\n}}, [{}])", { i(0), i(1) })),
  -- Testing
  snippet("tst", fmt('describe("{}", () => {{\n\t it("{}", () => {{\n\t{}\n\t}}) \n}})', { i(1), i(2), i(3) })),
  snippet("its", fmt('it("{}", () => {{\n\t{}\n}})', { i(1), i(2) })),
}

return M
