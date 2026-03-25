local M = {}

local function scroll_eof()
    local win_id = vim.api.nvim_get_current_win() -- Window id
    local buf_id = vim.api.nvim_get_current_buf() -- Buffer id
    
    -- Get the last line position on window
    local last_line = vim.api.nvim_buf_line_count(buf_id)
    local win_info = vim.fn.getwininfo(win_id)[1] -- Some info of window

    -- This get the end of line, in case the line is wrapped
    -- max function prevent a 0 return when line is equals window width
    local last_col = math.max(1, vim.fn.col({last_line, '$'}) - 1)
    local last_line_pos = vim.fn.screenpos(win_id, last_line, last_col).row

    if last_line_pos == 0 then return end -- Is not visible

    -- If scrolloff if higher than window half height, change scrolloff to half window height
    local max_scrolloff = math.floor((win_info.height - 1) / 2)
    local scrolloff = math.min(vim.go.scrolloff, max_scrolloff)
    vim.wo.scrolloff = scrolloff -- Without this, winrestview ignores some toplines

    local blank_lines = win_info.height - last_line_pos

    -- Get the position of row, this prevents to scroll when cursor get on wrapped line
    -- maybe turn this into an option of setup.
    local cursor_pos = vim.fn.screenpos(0, vim.fn.line("."), 1).row
    local lines_to_scroll = scrolloff - (last_line_pos + blank_lines - cursor_pos)

    if lines_to_scroll <= 0 then return end

    local top_line = win_info.topline + lines_to_scroll

    -- Set top line of the window, this does not move the cursor
    vim.fn.winrestview({ topline = top_line })
end


M.setup = function ()
    local scroll_group = vim.api.nvim_create_augroup("ScrollEOF", { clear = true }) -- Prevents multiple adds

    vim.api.nvim_create_autocmd({ "CursorMoved", "WinResized" }, {
        group = scroll_group,
        callback = scroll_eof,
    })
end

return M
