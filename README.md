# eighties.nvim

> Automatically resizes your windows in Neovim

A Lua port of [vim-eighties](https://github.com/justincampbell/vim-eighties) for Neovim.

## Features

* Resizes the width of the current window when switching
* Calculates the minimum width (80 by default) + line numbers/signs/etc
* Won't shrink the current window
* Won't resize side panels (supports NERDTree and other file browsers)
* Additional bufname patterns can be specified

## Installation

### [lazy.nvim](https://github.com/folke/lazy.nvim)

```lua
{
  'justincampbell/eighties.nvim',
  config = function()
    require('eighties').setup({
      -- optional settings (see below)
    })
  end
}
```

### [packer.nvim](https://github.com/wbthomason/packer.nvim)

```lua
use {
  'justincampbell/eighties.nvim',
  config = function()
    require('eighties').setup({
      -- optional settings (see below)
    })
  end
}
```

## Configuration

```lua
require('eighties').setup({
  enabled = true, -- Enable automatic resizing
  minimum_width = 80, -- Minimum width of the active window
  extra_width = 0, -- Increase this if you want some extra room
  compute = true, -- Disable this if you just want the minimum + extra
  bufname_additional_patterns = {} -- Additional buffer patterns to ignore (e.g. {'fugitiveblame'})
})
```

## Commands

* `:EightiesDisable` - Disable automatic resizing
* `:EightiesEnable` - Enable automatic resizing
* `:EightiesResize` - Manually trigger a resize
