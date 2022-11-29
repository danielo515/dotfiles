local fun = require "danielo.fun"
local keymap = require "danielo.keymap"
local _vim = require "danielo.vim"

local M = fun.assign(fun, keymap, _vim)

M.PopupKeys = require "danielo.ui.PopupKeys"

return M
