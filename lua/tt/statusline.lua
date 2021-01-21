local gl = require('galaxyline')
require('tt.nvim_utils')

function is_buffer_empty()
  -- Check whether the current buffer is empty
  return vim.fn.empty(vim.fn.expand('%:t')) == 1
end

function has_width_gt(cols)
  -- Check if the windows width is greater than a given number of columns
  return vim.fn.winwidth(0) / 2 > cols
end

function has_git()
  return fn.len(gitBranch()) > 0
end


local gls = gl.section
gl.short_line_list = { 'packager' }

-- Colors
local colors = {
  bg = '#000000',
  fg = '#f8f8f2',
  section_bg = '#0b0d0f',
  yellow = '#f1fa8c',
  cyan = '#8be9fd',
  green = '#72ffcf',
  orange = '#ffb86c',
  magenta = '#fb7da7',
  blue = '#2de2e6',
  red = '#ff5555',
  mod = '#711283'
}

-- Local helper functions
local buffer_not_empty = function()
  return not is_buffer_empty()
end

local mode_color = function()
  local mode_colors = {
    n = colors.cyan,
    i = colors.green,
    c = colors.orange,
    V = colors.magenta,
    [''] = colors.magenta,
    v = colors.magenta,

    R = colors.red,
  }

  return mode_colors[vim.fn.mode()]
end

local mod = function()
  if vim.api.nvim_buf_get_option(0, "modified") then
    vim.api.nvim_command('hi GalaxyFileName guifg=White guibg='..colors.mod)
  else
    vim.api.nvim_command('hi GalaxyFileName guifg='..colors.fg..'guibg='..colors.bg)
  end
end

-- Left side
gls.left[1] = {
  FirstElement = {
    provider = function()
      vim.api.nvim_command('hi GalaxyFirstElement guifg='..mode_color())
      return '⣿⣿'
    end,
    separator = " ",
    separator_highlight = {colors.section_bg, colors.section_bg},
    highlight = { colors.bg, colors.section_bg }
  },
}
gls.left[2] ={
  FileIcon = {
    provider = 'FileIcon',
    condition = buffer_not_empty,
    highlight = { require('galaxyline.provider_fileinfo').get_file_icon_color, colors.section_bg },
  },
}
gls.left[3] = {
  FileName = {
    provider = function ()
      mod()
      return fn.expand("%f")
    end,
    condition = buffer_not_empty,
    highlight = { colors.fg, colors.section_bg },
    separator = "  ",
    separator_highlight = {colors.section_bg, colors.section_bg},
  }
}
gls.left[4] = {
  GitIcon = {
    provider = function() return '  ' end,
    condition = has_git,
    highlight = {colors.red,colors.section_bg},
  }
}
gls.left[5] = {
  GitBranch = {
    provider = 'GitBranch',
    condition = buffer_not_empty,
    highlight = {colors.fg,colors.section_bg},
  }
}
gls.left[6] = {
  DiagnosticError = {
    provider = 'DiagnosticError',
    icon = '  ',
    highlight = {colors.red,colors.section_bg}
  }
}
gls.left[7] = {
  Space = {
    provider = function () return ' ' end,
    highlight = {colors.section_bg,colors.section_bg},
  }
}
gls.left[8] = {
  DiagnosticWarn = {
    provider = 'DiagnosticWarn',
    icon = '  ',
    highlight = {colors.orange,colors.section_bg},
  }
}
gls.left[9] = {
  Space = {
    provider = function () return ' ' end,
    highlight = {colors.section_bg,colors.section_bg},
  }
}
gls.left[10] = {
  DiagnosticInfo = {
    provider = 'DiagnosticInfo',
    icon = '  ',
    highlight = {colors.blue,colors.section_bg},
    separator_highlight = { colors.section_bg, colors.bg },
  }
}

-- Right side
gls.right[1] = {
  LineInfo = {
    provider = 'LineColumn',
    highlight = { colors.fg, colors.section_bg },
    separator_highlight = { colors.bg, colors.section_bg },
  },
}

-- Short status line
gls.short_line_left[1] = {
  BufferType = {
    provider = 'FileName',
    highlight = { colors.fg, colors.section_bg },
    separator_highlight = { colors.section_bg, colors.bg },
  }
}

gls.short_line_right[1] = {
  BufferIcon = {
    provider= 'BufferIcon',
    highlight = { colors.yellow, colors.section_bg },
    separator_highlight = { colors.section_bg, colors.bg },
  }
}

-- Force manual load so that nvim boots with a status line
gl.load_galaxyline()
