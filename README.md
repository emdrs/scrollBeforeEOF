# Scroll Before EOF

[ScrollEOF](https://github.com/Aasim-A/scrollEOF.nvim) broke on my config in Neovim 0.12, so i made this to replace him.

## How this work

The plugin gets positions of: last file line, window, cursor line, gets window height and scrolloff, calculates the actual blank spaces and blank spaces needed, and then, runs `n<C-e>` to get a blank lines at bottom. Simple as that. If scrollof is higher than half of window height, the plugin will get half of windows minus 1 and will set on `vim.wo.scrolloff` to prevent fight with neovim. The plugin runs on `CursorMoved` event but stop if last file line if not in window or if do not have blank lines to add.

## How to install

### Neovim pack

``` lua
vim.pack.add {{ src="https://github.com/emdrs/scrollBeforeEOF" }}
require("scrollBeforeEOF").setup()
```

### Lazy

``` lua
{ "emdrs/scrollBeforeEOF" }
```

## How to use

This plugin uses `scrolloff` as amount of blank spaces. Set him on your config.

``` lua
vim.o.scrolloff = 20
```
