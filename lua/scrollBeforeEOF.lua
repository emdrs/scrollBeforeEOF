local function get_win_info()
    return vim.fn.getwininfo(vim.api.nvim_get_current_win())[1]
end

local function get_virtual_empty_lines()
    local total_lines = vim.api.nvim_buf_line_count(0)
    local win_info = get_win_info()
    local lines_of_text_visible = math.max(0, total_lines - win_info.topline + 1)
    return math.max(0, win_info.height - lines_of_text_visible)
end

local scroll_eof = function()
    local win_half_height = math.floor(get_win_info().height / 2)
    local offset = vim.o.scrolloff < win_half_height and vim.o.scrolloff or win_half_height
    local current_row = vim.api.nvim_win_get_cursor(0)[1]
    local total_rows = vim.api.nvim_buf_line_count(0)
    local blank_lines = get_virtual_empty_lines()

    local lines_to_scroll = offset - (total_rows + blank_lines - current_row)

    if lines_to_scroll > 0 then
        local ctrl_e = vim.api.nvim_replace_termcodes("<C-e>", true, true, true)
        for i = 1, lines_to_scroll do
            vim.api.nvim_feedkeys(ctrl_e, "n", false)
        end
    end
end

local scroll_group = vim.api.nvim_create_augroup("ScrollEOF", { clear = true })

vim.api.nvim_create_autocmd({ "CursorMoved" }, {
    group = scroll_group,
    pattern = "*",
    callback = function()
        scroll_eof()
    end,
})
