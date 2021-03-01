require'compe'.setup {
  enabled = true;
  autocomplete = true;
  debug = false;
  min_length = 1;
  preselect = 'disabled';
  throttle_time = 80;
  source_timeout = 200;
  incomplete_delay = 80;
  max_abbr_width = 100;
  max_kind_width = 100;
  max_menu_width = 100;
  documentation = true;

  source = {
    path = true;
    buffer = {priority = 1};
    vsnip = {priority = 4};
    nvim_lsp = {priority = 100};
    nvim_lua = true;
    treesitter = true;
    tags = {priority = 2};
    calc = false;
    spell = false;
    snippets_nvim = false;
  };
}
