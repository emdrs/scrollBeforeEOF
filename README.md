# Scroll Before EOF

[ScrollEOF](https://github.com/Aasim-A/scrollEOF.nvim) broke on my config in Neovim 0.12, so i made this to replace him.

## How this work

The plugin gets positions of: last file line, window, cursor line, gets window height and scrolloff, calculates the actual blank spaces and blank spaces needed, and then, runs `vim.fn.winrestview` to get a blank lines at bottom. Simple as that. If scrolloff is higher than half of window height, the plugin will get half of (windows height minus 1) and will set on `vim.wo.scrolloff` to prevent neovim to ignores the passed `topline` to `vim.fn.winrestview`. The plugin runs on `CursorMoved` and `WinResized` events but stop if last file line is not visible or if do not have blank lines to add.

> [!WARNING]
> This is a experimental and my first plugin, if you find any bugs feel free to open an issue and i will check fast as possible.

## How to install

### Neovim pack

``` lua
vim.pack.add {{ src="https://github.com/emdrs/scrollBeforeEOF" }}
require("scrollBeforeEOF").setup()
```

### Lazy

``` lua
{ "emdrs/scrollBeforeEOF", opts = {} }
```

## How to use

This plugin uses `scrolloff` as amount of blank spaces. Set him on your config.

``` lua
vim.o.scrolloff = 20
```
