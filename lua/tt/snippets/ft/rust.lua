vim.snippet.add("l", 'println!("$1");')
vim.snippet.add("fn", "fn $1($2) -> $3 {\n\t$4\n}")
vim.snippet.add("modtest", "#[cfg(test)]\nmod tests {\nuse super::*;\n\n#[test]\nfn $1() {\n\t$2\n}}")
vim.snippet.add("tst", "#[test]\nfn $1() {\n\t$2\n}")
