local fun = require "danielo.fun"
local keymap = require "danielo.keymap"
local _vim = require "danielo.vim"

local M = fun.assign(fun, keymap, _vim)

local ok
ok, M.PopupKeys = pcall(require, "danielo.ui.PopupKeys")

return M
