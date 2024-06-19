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
  snippet("dbf",
    fmt(
      [[export async function {} ({}) {{
      return tracer.startActiveSpan('{}', async (span) => {{
        try {{
          const {} = await prisma.{}.{}
          span.end();
          return[{}, undefined]
        }} catch(e) {{
         console.error("[DB] Could not query {} - ", e);
         span.setAttribute("error.msg", JSON.stringify(e));
         span.end();
         return [undefined, e];
        }}
        }});
      }}
      ]],
      { i(1), i(2), rep(1), i(3), i(4), i(5), rep(3), i(6)  })),
  -- React stuff
  snippet("fco", fmt("function {} ({{{}}}) {{\n\t{}\n}}\n\nexport default {}", { i(1), i(2), i(3), rep(1) })),
  snippet("cco", fmt("const {} = ({{{}}}) => {{\n\t{}\n}}\n\nexport default {}", { i(1), i(2), i(3), rep(1) })),
  snippet("usee", fmt("useEffect(() => {{\n\t{}\n}}, [{}])", { i(0), i(1) })),
  -- Testing
  snippet("tst", fmt('describe("{}", () => {{\n\t it("{}", () => {{\n\t{}\n\t}}) \n}})', { i(1), i(2), i(3) })),
  snippet("its", fmt('it("{}", () => {{\n\t{}\n}})', { i(1), i(2) })),
}

return M

-- export async function findVendorByServiceCategory(serviceCategory) {
--   return tracer.startActiveSpan(
--     "findVendorByServiceCategory ",
--     async (span) => {
--       try {
--         const vendors = await prisma.company.findMany({
--           where: {
--             serviceCategory,
--           },
--         });
--         span.end();
--         return [vendors, undefined];
--       } catch (e) {
--         console.error("[DB] Could not query vendors - ", e);
--         span.setAttribute("error.msg", JSON.stringify(e));
--         span.end();
--         return [undefined, e];
--       }
--     },
--   );
-- }
