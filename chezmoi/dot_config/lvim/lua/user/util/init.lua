local M = {}

function M.concat_lists(...)
        local result = {}
        for i = 1, select("#", ...) do
                local v = select(i, ...)
                vim.list_extend(result, v)
        end
        return result
end

function M.copy_messages_to_clipboard()
        local cmd = [[
redir @*
messages
redir END
]]
        vim.cmd(cmd)
        vim.notify(":messages copied to the clipboard", "info")
end

pcall(function()
        require("legendary").bind_command {
                ":CopyMessages",
                M.copy_messages_to_clipboard,
                description = "Copy the output of :messages to OS clipboard",
        }
end)

function M.bind(fn, ...)
        local args = { ... }
        return function()
                fn(unpack(args))
        end
end

return M
