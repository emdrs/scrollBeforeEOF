local M = {}

local last_line = 0

local function get_line_end_win_pos(line_number)
    local last_col = vim.fn.col({line_number, '$'})
    if last_col > 1 then last_col = last_col - 1 end
    return vim.fn.screenpos(0, line_number, last_col)
end

local scroll_eof = function()
    local win_id = vim.api.nvim_get_current_win()
    local win_info = vim.fn.getwininfo(win_id)[1]
    local win_safe_scrolloff = math.floor((win_info.height - 1) / 2)

    local line_end_pos = get_line_end_win_pos(vim.api.nvim_buf_line_count(0)).row - win_info.winrow + 1

    if line_end_pos <= 0 then return end

    local offset = vim.go.scrolloff > win_safe_scrolloff and win_safe_scrolloff or vim.go.scrolloff

    vim.wo.scrolloff = offset

    local current_line = vim.fn.screenpos(0, vim.fn.line("."), 1).row

    local blank_lines = win_info.height - line_end_pos
    local lines_to_scroll = offset - (win_info.height - current_line)

    if vim.wo.wrap and current_line < last_line then
        local line_content = vim.fn.getline(win_info.topline)
        local display_width = vim.fn.strdisplaywidth(line_content)
        local win_width = vim.api.nvim_win_get_width(0) - win_info.textoff

        local lines_count = math.max(math.ceil(display_width / win_width), 1)
        lines_to_scroll = lines_to_scroll - (lines_count -1)
    end

    last_line = current_line

    if lines_to_scroll <= 0 then return end

    local ctrl_e = vim.api.nvim_replace_termcodes(lines_to_scroll .. "<C-e>", true, true, true)
    vim.api.nvim_feedkeys(ctrl_e, "n", false)
end

M.setup = function()
    local scroll_group = vim.api.nvim_create_augroup("ScrollEOF", { clear = true })

    vim.api.nvim_create_autocmd({ "CursorMoved", "VimResized" }, {
        group = scroll_group,
        pattern = "*",
        callback = function()
            scroll_eof()
        end,
    })
end

return M
