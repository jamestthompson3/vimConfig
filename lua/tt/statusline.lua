local gl = require('galaxyline')

function is_buffer_empty()
  -- Check whether the current buffer is empty
  return vim.fn.empty(vim.fn.expand('%:t')) == 1
end

function has_width_gt(cols)
  -- Check if the windows width is greater than a given number of columns
  return vim.fn.winwidth(0) / 2 > cols
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
  red = '#ff5555'
}

-- Local helper functions
local buffer_not_empty = function()
  return not is_buffer_empty()
end

local checkwidth = function()
  return has_width_gt(40) and buffer_not_empty()
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

-- Left side
gls.left[1] = {
  FirstElement = {
    provider = function() return '▋' end,
    highlight = { colors.cyan, colors.section_bg }
  },
}
gls.left[2] = {
  ViMode = {
    provider = function()
      local alias = {
        n = 'NORMAL',
        i = 'INSERT',
        c = 'COMMAND',
        V = 'VISUAL',
        [''] = 'VISUAL',
        v = 'VISUAL',
        R = 'REPLACE',
      }
      vim.api.nvim_command('hi GalaxyViMode guifg='..mode_color())
      return alias[vim.fn.mode()]..' '
    end,
    highlight = { colors.bg, colors.bg },
    separator_highlight = {colors.bg, colors.section_bg},
  },
}
gls.left[3] ={
  FileIcon = {
    provider = 'FileIcon',
    condition = buffer_not_empty,
    highlight = { require('galaxyline.provider_fileinfo').get_file_icon_color, colors.section_bg },
  },
}
gls.left[4] = {
  FileName = {
    provider = { 'FileName' },
    condition = buffer_not_empty,
    highlight = { colors.fg, colors.section_bg },
    separator_highlight = {colors.section_bg, colors.bg},
  }
}
gls.left[5] = {
  GitIcon = {
    provider = function() return '  ' end,
    condition = buffer_not_empty,
    highlight = {colors.red,colors.bg},
  }
}
gls.left[6] = {
  GitBranch = {
    provider = 'GitBranch',
    condition = buffer_not_empty,
    highlight = {colors.fg,colors.bg},
  }
}
gls.left[7] = {
  DiffAdd = {
    provider = 'DiffAdd',
    condition = checkwidth,
    icon = ' ',
    highlight = { colors.green, colors.bg },
  }
}
gls.left[8] = {
  DiffModified = {
    provider = 'DiffModified',
    condition = checkwidth,
    icon = ' ',
    highlight = { colors.orange, colors.bg },
  }
}
gls.left[9] = {
  DiffRemove = {
    provider = 'DiffRemove',
    condition = checkwidth,
    icon = ' ',
    highlight = { colors.red,colors.bg },
  }
}
gls.left[11] = {
  DiagnosticError = {
    provider = 'DiagnosticError',
    icon = '  ',
    highlight = {colors.red,colors.section_bg}
  }
}
gls.left[12] = {
  Space = {
    provider = function () return ' ' end,
    highlight = {colors.section_bg,colors.section_bg},
  }
}
gls.left[13] = {
  DiagnosticWarn = {
    provider = 'DiagnosticWarn',
    icon = '  ',
    highlight = {colors.orange,colors.section_bg},
  }
}
gls.left[14] = {
  Space = {
    provider = function () return ' ' end,
    highlight = {colors.section_bg,colors.section_bg},
  }
}
gls.left[15] = {
  DiagnosticInfo = {
    provider = 'DiagnosticInfo',
    icon = '  ',
    highlight = {colors.blue,colors.section_bg},
    separator_highlight = { colors.section_bg, colors.bg },
  }
}

-- Right side
gls.right[2] = {
  LineInfo = {
    provider = 'LineColumn',
    highlight = { colors.fg, colors.section_bg },
    separator_highlight = { colors.bg, colors.section_bg },
  },
}

-- Force manual load so that nvim boots with a status line
gl.load_galaxyline()
