local _hx_hidden = {
	__id__ = true,
	hx__closures = true,
	super = true,
	prototype = true,
	__fields__ = true,
	__ifields__ = true,
	__class__ = true,
	__properties__ = true,
	__fields__ = true,
	__name__ = true,
}

_hx_array_mt = {
	__newindex = function(t, k, v)
		local len = t.length
		t.length = k >= len and (k + 1) or len
		rawset(t, k, v)
	end,
}

function _hx_is_array(o)
	return type(o) == "table" and o.__enum__ == nil and getmetatable(o) == _hx_array_mt
end

function _hx_tab_array(tab, length)
	tab.length = length
	return setmetatable(tab, _hx_array_mt)
end

function _hx_print_class(obj, depth)
	local first = true
	local result = ""
	for k, v in pairs(obj) do
		if _hx_hidden[k] == nil then
			if first then
				first = false
			else
				result = result .. ", "
			end
			if _hx_hidden[k] == nil then
				result = result .. k .. ":" .. _hx_tostring(v, depth + 1)
			end
		end
	end
	return "{ " .. result .. " }"
end

function _hx_print_enum(o, depth)
	if o.length == 2 then
		return o[0]
	else
		local str = o[0] .. "("
		for i = 2, (o.length - 1) do
			if i ~= 2 then
				str = str .. "," .. _hx_tostring(o[i], depth + 1)
			else
				str = str .. _hx_tostring(o[i], depth + 1)
			end
		end
		return str .. ")"
	end
end

function _hx_tostring(obj, depth)
	if depth == nil then
		depth = 0
	elseif depth > 5 then
		return "<...>"
	end

	local tstr = _G.type(obj)
	if tstr == "string" then
		return obj
	elseif tstr == "nil" then
		return "null"
	elseif tstr == "number" then
		if obj == _G.math.POSITIVE_INFINITY then
			return "Infinity"
		elseif obj == _G.math.NEGATIVE_INFINITY then
			return "-Infinity"
		elseif obj == 0 then
			return "0"
		elseif obj ~= obj then
			return "NaN"
		else
			return _G.tostring(obj)
		end
	elseif tstr == "boolean" then
		return _G.tostring(obj)
	elseif tstr == "userdata" then
		local mt = _G.getmetatable(obj)
		if mt ~= nil and mt.__tostring ~= nil then
			return _G.tostring(obj)
		else
			return "<userdata>"
		end
	elseif tstr == "function" then
		return "<function>"
	elseif tstr == "thread" then
		return "<thread>"
	elseif tstr == "table" then
		if obj.__enum__ ~= nil then
			return _hx_print_enum(obj, depth)
		elseif obj.toString ~= nil and not _hx_is_array(obj) then
			return obj:toString()
		elseif _hx_is_array(obj) then
			if obj.length > 5 then
				return "[...]"
			else
				local str = ""
				for i = 0, (obj.length - 1) do
					if i == 0 then
						str = str .. _hx_tostring(obj[i], depth + 1)
					else
						str = str .. "," .. _hx_tostring(obj[i], depth + 1)
					end
				end
				return "[" .. str .. "]"
			end
		elseif obj.__class__ ~= nil then
			return _hx_print_class(obj, depth)
		else
			local buffer = {}
			local ref = obj
			if obj.__fields__ ~= nil then
				ref = obj.__fields__
			end
			for k, v in pairs(ref) do
				if _hx_hidden[k] == nil then
					_G.table.insert(buffer, _hx_tostring(k, depth + 1) .. " : " .. _hx_tostring(obj[k], depth + 1))
				end
			end

			return "{ " .. table.concat(buffer, ", ") .. " }"
		end
	else
		_G.error("Unknown Lua type", 0)
		return ""
	end
end

function _hx_error(obj)
	if obj.value then
		_G.print("runtime error:\n " .. _hx_tostring(obj.value))
	else
		_G.print("runtime error:\n " .. tostring(obj))
	end

	if _G.debug and _G.debug.traceback then
		_G.print(debug.traceback())
	end
end

local function _hx_obj_newindex(t, k, v)
	t.__fields__[k] = true
	rawset(t, k, v)
end

local _hx_obj_mt = { __newindex = _hx_obj_newindex, __tostring = _hx_tostring }

local function _hx_a(...)
	local __fields__ = {}
	local ret = { __fields__ = __fields__ }
	local max = select("#", ...)
	local tab = { ... }
	local cur = 1
	while cur < max do
		local v = tab[cur]
		__fields__[v] = true
		ret[v] = tab[cur + 1]
		cur = cur + 2
	end
	return setmetatable(ret, _hx_obj_mt)
end

local function _hx_e()
	return setmetatable({ __fields__ = {} }, _hx_obj_mt)
end

local function _hx_o(obj)
	return setmetatable(obj, _hx_obj_mt)
end

local function _hx_new(prototype)
	return setmetatable(
		{ __fields__ = {} },
		{ __newindex = _hx_obj_newindex, __index = prototype, __tostring = _hx_tostring }
	)
end

function _hx_field_arr(obj)
	res = {}
	idx = 0
	if obj.__fields__ ~= nil then
		obj = obj.__fields__
	end
	for k, v in pairs(obj) do
		if _hx_hidden[k] == nil then
			res[idx] = k
			idx = idx + 1
		end
	end
	return _hx_tab_array(res, idx)
end

local _hxClasses = {}
local Int = _hx_e()
local Dynamic = _hx_e()
local Float = _hx_e()
local Bool = _hx_e()
local Class = _hx_e()
local Enum = _hx_e()

local Array = _hx_e()
local Math = _hx_e()
local Safety = _hx_e()
local String = _hx_e()
local Std = _hx_e()
___TableWrapper_TableWrapper_Impl_ = _hx_e()
___TableWrapper_TableWrapper_Fields_ = _hx_e()
__haxe_Exception = _hx_e()
__haxe_Log = _hx_e()
__haxe_NativeStackTrace = _hx_e()
__haxe_iterators_ArrayIterator = _hx_e()
__haxe_iterators_ArrayKeyValueIterator = _hx_e()
__lua_Thread = _hx_e()
__packer__Macro_Macro_Fields_ = _hx_e()
__packer__Packer_Plugin_Impl_ = _hx_e()
__packer__Packer_Packer_Fields_ = _hx_e()
__plenary_Job = _G.require("plenary.job")
__safety_SafetyException = _hx_e()
__safety_NullPointerException = _hx_e()
__test__RawTable_RawTable_Fields_ = _hx_e()
__test__TestMacros_TestMacros_Fields_ = _hx_e()
__vim__Vim_Vim_Fields_ = _hx_e()
__vim_FunctionOrString = _hx_e()
__vim__VimTypes_GroupOpts_Impl_ = _hx_e()
__vim__VimTypes_LuaArray_Impl_ = _hx_e()
__vim__VimTypes_LuaObj_Impl_ = _hx_e()
__vim__VimTypes_ExpandString_Impl_ = _hx_e()
__vim__VimTypes_Vector3_Impl_ = _hx_e()
__vim__VimTypes_Vector4_Impl_ = _hx_e()
__vim_types_ArgCompleteEnum = _hx_e()
__vim_types__ArgComplete_ArgComplete_Impl_ = _hx_e()

local _hx_bind, _hx_bit, _hx_staticToInstance, _hx_funcToField, _hx_maxn, _hx_print, _hx_apply_self, _hx_box_mr, _hx_bit_clamp, _hx_table, _hx_bit_raw
local _hx_pcall_default = {}
local _hx_pcall_break = {}

Array.new = function()
	local self = _hx_new(Array.prototype)
	Array.super(self)
	return self
end
Array.super = function(self)
	_hx_tab_array(self, 0)
end
Array.prototype = _hx_e()
Array.prototype.concat = function(self, a)
	local _g = _hx_tab_array({}, 0)
	local _g1 = 0
	local _g2 = self
	while _g1 < _g2.length do
		local i = _g2[_g1]
		_g1 = _g1 + 1
		_g:push(i)
	end
	local ret = _g
	local _g = 0
	while _g < a.length do
		local i = a[_g]
		_g = _g + 1
		ret:push(i)
	end
	do
		return ret
	end
end
Array.prototype.join = function(self, sep)
	local tbl = {}
	local _g_current = 0
	local _g_array = self
	while _g_current < _g_array.length do
		_g_current = _g_current + 1
		local i = _g_array[_g_current - 1]
		_G.table.insert(tbl, Std.string(i))
	end
	do
		return _G.table.concat(tbl, sep)
	end
end
Array.prototype.pop = function(self)
	if self.length == 0 then
		do
			return nil
		end
	end
	local ret = self[self.length - 1]
	self[self.length - 1] = nil
	self.length = self.length - 1
	do
		return ret
	end
end
Array.prototype.push = function(self, x)
	self[self.length] = x
	do
		return self.length
	end
end
Array.prototype.reverse = function(self)
	local tmp
	local i = 0
	while i < Std.int(self.length / 2) do
		tmp = self[i]
		self[i] = self[(self.length - i) - 1]
		self[(self.length - i) - 1] = tmp
		i = i + 1
	end
end
Array.prototype.shift = function(self)
	if self.length == 0 then
		do
			return nil
		end
	end
	local ret = self[0]
	if self.length == 1 then
		self[0] = nil
	else
		if self.length > 1 then
			self[0] = self[1]
			_G.table.remove(self, 1)
		end
	end
	local tmp = self
	tmp.length = tmp.length - 1
	do
		return ret
	end
end
Array.prototype.slice = function(self, pos, _end)
	if (_end == nil) or (_end > self.length) then
		_end = self.length
	else
		if _end < 0 then
			_end = _G.math.fmod((self.length - (_G.math.fmod(-_end, self.length))), self.length)
		end
	end
	if pos < 0 then
		pos = _G.math.fmod((self.length - (_G.math.fmod(-pos, self.length))), self.length)
	end
	if (pos > _end) or (pos > self.length) then
		do
			return _hx_tab_array({}, 0)
		end
	end
	local ret = _hx_tab_array({}, 0)
	local _g = pos
	local _g1 = _end
	while _g < _g1 do
		_g = _g + 1
		local i = _g - 1
		ret:push(self[i])
	end
	do
		return ret
	end
end
Array.prototype.sort = function(self, f)
	local i = 0
	local l = self.length
	while i < l do
		local swap = false
		local j = 0
		local max = (l - i) - 1
		while j < max do
			if f(self[j], self[j + 1]) > 0 then
				local tmp = self[j + 1]
				self[j + 1] = self[j]
				self[j] = tmp
				swap = true
			end
			j = j + 1
		end
		if not swap then
			break
		end
		i = i + 1
	end
end
Array.prototype.splice = function(self, pos, len)
	if (len < 0) or (pos > self.length) then
		do
			return _hx_tab_array({}, 0)
		end
	else
		if pos < 0 then
			pos = self.length - (_G.math.fmod(-pos, self.length))
		end
	end
	len = Math.min(len, self.length - pos)
	local ret = _hx_tab_array({}, 0)
	local _g = pos
	local _g1 = pos + len
	while _g < _g1 do
		_g = _g + 1
		local i = _g - 1
		ret:push(self[i])
		self[i] = self[i + len]
	end
	local _g = pos + len
	local _g1 = self.length
	while _g < _g1 do
		_g = _g + 1
		local i = _g - 1
		self[i] = self[i + len]
	end
	local tmp = self
	tmp.length = tmp.length - len
	do
		return ret
	end
end
Array.prototype.toString = function(self)
	local tbl = {}
	_G.table.insert(tbl, "[")
	_G.table.insert(tbl, self:join(","))
	_G.table.insert(tbl, "]")
	do
		return _G.table.concat(tbl, "")
	end
end
Array.prototype.unshift = function(self, x)
	local len = self.length
	local _g = 0
	local _g1 = len
	while _g < _g1 do
		_g = _g + 1
		local i = _g - 1
		self[len - i] = self[(len - i) - 1]
	end
	self[0] = x
end
Array.prototype.insert = function(self, pos, x)
	if pos > self.length then
		pos = self.length
	end
	if pos < 0 then
		pos = self.length + pos
		if pos < 0 then
			pos = 0
		end
	end
	local cur_len = self.length
	while cur_len > pos do
		self[cur_len] = self[cur_len - 1]
		cur_len = cur_len - 1
	end
	self[pos] = x
end
Array.prototype.remove = function(self, x)
	local _g = 0
	local _g1 = self.length
	while _g < _g1 do
		_g = _g + 1
		local i = _g - 1
		if self[i] == x then
			local _g = i
			local _g1 = self.length - 1
			while _g < _g1 do
				_g = _g + 1
				local j = _g - 1
				self[j] = self[j + 1]
			end
			self[self.length - 1] = nil
			self.length = self.length - 1
			do
				return true
			end
		end
	end
	do
		return false
	end
end
Array.prototype.contains = function(self, x)
	local _g = 0
	local _g1 = self.length
	while _g < _g1 do
		_g = _g + 1
		local i = _g - 1
		if self[i] == x then
			do
				return true
			end
		end
	end
	do
		return false
	end
end
Array.prototype.indexOf = function(self, x, fromIndex)
	local _end = self.length
	if fromIndex == nil then
		fromIndex = 0
	else
		if fromIndex < 0 then
			fromIndex = self.length + fromIndex
			if fromIndex < 0 then
				fromIndex = 0
			end
		end
	end
	local _g = fromIndex
	local _g1 = _end
	while _g < _g1 do
		_g = _g + 1
		local i = _g - 1
		if x == self[i] then
			do
				return i
			end
		end
	end
	do
		return -1
	end
end
Array.prototype.lastIndexOf = function(self, x, fromIndex)
	if (fromIndex == nil) or (fromIndex >= self.length) then
		fromIndex = self.length - 1
	else
		if fromIndex < 0 then
			fromIndex = self.length + fromIndex
			if fromIndex < 0 then
				do
					return -1
				end
			end
		end
	end
	local i = fromIndex
	while i >= 0 do
		if self[i] == x then
			do
				return i
			end
		else
			i = i - 1
		end
	end
	do
		return -1
	end
end
Array.prototype.copy = function(self)
	local _g = _hx_tab_array({}, 0)
	local _g1 = 0
	local _g2 = self
	while _g1 < _g2.length do
		local i = _g2[_g1]
		_g1 = _g1 + 1
		_g:push(i)
	end
	do
		return _g
	end
end
Array.prototype.map = function(self, f)
	local _g = _hx_tab_array({}, 0)
	local _g1 = 0
	local _g2 = self
	while _g1 < _g2.length do
		local i = _g2[_g1]
		_g1 = _g1 + 1
		_g:push(f(i))
	end
	do
		return _g
	end
end
Array.prototype.filter = function(self, f)
	local _g = _hx_tab_array({}, 0)
	local _g1 = 0
	local _g2 = self
	while _g1 < _g2.length do
		local i = _g2[_g1]
		_g1 = _g1 + 1
		if f(i) then
			_g:push(i)
		end
	end
	do
		return _g
	end
end
Array.prototype.iterator = function(self)
	do
		return __haxe_iterators_ArrayIterator.new(self)
	end
end
Array.prototype.keyValueIterator = function(self)
	do
		return __haxe_iterators_ArrayKeyValueIterator.new(self)
	end
end
Array.prototype.resize = function(self, len)
	if self.length < len then
		self.length = len
	else
		if self.length > len then
			local _g = len
			local _g1 = self.length
			while _g < _g1 do
				_g = _g + 1
				local i = _g - 1
				self[i] = nil
			end
			self.length = len
		end
	end
end

Math.new = {}
Math.isNaN = function(f)
	do
		return f ~= f
	end
end
Math.isFinite = function(f)
	if f > -_G.math.huge then
		do
			return f < _G.math.huge
		end
	else
		do
			return false
		end
	end
end
Math.min = function(a, b)
	if Math.isNaN(a) or Math.isNaN(b) then
		do
			return (0 / 0)
		end
	else
		do
			return _G.math.min(a, b)
		end
	end
end

Safety.new = {}
Safety["or"] = function(value, defaultValue)
	if value == nil then
		do
			return defaultValue
		end
	else
		do
			return value
		end
	end
end
Safety.orGet = function(value, getter)
	if value == nil then
		do
			return getter()
		end
	else
		do
			return value
		end
	end
end
Safety.sure = function(value)
	if value == nil then
		_G.error(__safety_NullPointerException.new("Null pointer in .sure() call"), 0)
	else
		do
			return value
		end
	end
end
Safety.unsafe = function(value)
	do
		return value
	end
end
Safety.check = function(value, callback)
	if value ~= nil then
		do
			return callback(value)
		end
	else
		do
			return false
		end
	end
end
Safety.let = function(value, callback)
	if value == nil then
		do
			return nil
		end
	else
		do
			return callback(value)
		end
	end
end
Safety.run = function(value, callback)
	if value ~= nil then
		callback(value)
	end
end
Safety.apply = function(value, callback)
	if value ~= nil then
		callback(value)
	end
	do
		return value
	end
end

String.new = function(string)
	local self = _hx_new(String.prototype)
	String.super(self, string)
	self = string
	return self
end
String.super = function(self, string) end
String.__index = function(s, k)
	if k == "length" then
		do
			return _G.string.len(s)
		end
	else
		local o = String.prototype
		local field = k
		if
			(function()
				local _hx_1
				if (_G.type(o) == "string") and ((String.prototype[field] ~= nil) or (field == "length")) then
					_hx_1 = true
				elseif o.__fields__ ~= nil then
					_hx_1 = o.__fields__[field] ~= nil
				else
					_hx_1 = o[field] ~= nil
				end
				return _hx_1
			end)()
		then
			do
				return String.prototype[k]
			end
		else
			if String.__oldindex ~= nil then
				if _G.type(String.__oldindex) == "function" then
					do
						return String.__oldindex(s, k)
					end
				else
					if _G.type(String.__oldindex) == "table" then
						do
							return String.__oldindex[k]
						end
					end
				end
				do
					return nil
				end
			else
				do
					return nil
				end
			end
		end
	end
end
String.indexOfEmpty = function(s, startIndex)
	local length = _G.string.len(s)
	if startIndex < 0 then
		startIndex = length + startIndex
		if startIndex < 0 then
			startIndex = 0
		end
	end
	if startIndex > length then
		do
			return length
		end
	else
		do
			return startIndex
		end
	end
end
String.fromCharCode = function(code)
	do
		return _G.string.char(code)
	end
end
String.prototype = _hx_e()
String.prototype.toUpperCase = function(self)
	do
		return _G.string.upper(self)
	end
end
String.prototype.toLowerCase = function(self)
	do
		return _G.string.lower(self)
	end
end
String.prototype.indexOf = function(self, str, startIndex)
	if startIndex == nil then
		startIndex = 1
	else
		startIndex = startIndex + 1
	end
	if str == "" then
		do
			return String.indexOfEmpty(self, startIndex - 1)
		end
	end
	local r = _G.string.find(self, str, startIndex, true)
	if (r ~= nil) and (r > 0) then
		do
			return r - 1
		end
	else
		do
			return -1
		end
	end
end
String.prototype.lastIndexOf = function(self, str, startIndex)
	local ret = -1
	if startIndex == nil then
		startIndex = #self
	end
	while true do
		local startIndex1 = ret + 1
		if startIndex1 == nil then
			startIndex1 = 1
		else
			startIndex1 = startIndex1 + 1
		end
		local p
		if str == "" then
			p = String.indexOfEmpty(self, startIndex1 - 1)
		else
			local r = _G.string.find(self, str, startIndex1, true)
			p = (function()
				local _hx_1
				if (r ~= nil) and (r > 0) then
					_hx_1 = r - 1
				else
					_hx_1 = -1
				end
				return _hx_1
			end)()
		end
		if ((p == -1) or (p > startIndex)) or (p == ret) then
			break
		end
		ret = p
	end
	do
		return ret
	end
end
String.prototype.split = function(self, delimiter)
	local idx = 1
	local ret = _hx_tab_array({}, 0)
	while idx ~= nil do
		local newidx = 0
		if #delimiter > 0 then
			newidx = _G.string.find(self, delimiter, idx, true)
		else
			if idx >= #self then
				newidx = nil
			else
				newidx = idx + 1
			end
		end
		if newidx ~= nil then
			local match = _G.string.sub(self, idx, newidx - 1)
			ret:push(match)
			idx = newidx + #delimiter
		else
			ret:push(_G.string.sub(self, idx, #self))
			idx = nil
		end
	end
	do
		return ret
	end
end
String.prototype.toString = function(self)
	do
		return self
	end
end
String.prototype.substring = function(self, startIndex, endIndex)
	if endIndex == nil then
		endIndex = #self
	end
	if endIndex < 0 then
		endIndex = 0
	end
	if startIndex < 0 then
		startIndex = 0
	end
	if endIndex < startIndex then
		do
			return _G.string.sub(self, endIndex + 1, startIndex)
		end
	else
		do
			return _G.string.sub(self, startIndex + 1, endIndex)
		end
	end
end
String.prototype.charAt = function(self, index)
	do
		return _G.string.sub(self, index + 1, index + 1)
	end
end
String.prototype.charCodeAt = function(self, index)
	do
		return _G.string.byte(self, index + 1)
	end
end
String.prototype.substr = function(self, pos, len)
	if (len == nil) or (len > (pos + #self)) then
		len = #self
	else
		if len < 0 then
			len = #self + len
		end
	end
	if pos < 0 then
		pos = #self + pos
	end
	if pos < 0 then
		pos = 0
	end
	do
		return _G.string.sub(self, pos + 1, pos + len)
	end
end

Std.new = {}
Std.string = function(s)
	do
		return _hx_tostring(s, 0)
	end
end
Std.int = function(x)
	if not Math.isFinite(x) or Math.isNaN(x) then
		do
			return 0
		end
	else
		do
			return _hx_bit_clamp(x)
		end
	end
end

___TableWrapper_TableWrapper_Impl_.new = {}

___TableWrapper_TableWrapper_Fields_.new = {}
___TableWrapper_TableWrapper_Fields_.uniqueValues = function(array, indexer)
	local index_h = {}
	local _g = _hx_tab_array({}, 0)
	local _g1 = 0
	local _hx_continue_1 = false
	while _g1 < array.length do
		repeat
			local val = array[_g1]
			_g1 = _g1 + 1
			local key = indexer(val)
			if index_h[key] ~= nil then
				break
			end
			index_h[key] = true
			_g:push(val)
		until true
		if _hx_continue_1 then
			_hx_continue_1 = false
			break
		end
	end
	do
		return _g
	end
end

__haxe_Exception.new = function(message, previous, native)
	local self = _hx_new(__haxe_Exception.prototype)
	__haxe_Exception.super(self, message, previous, native)
	return self
end
__haxe_Exception.super = function(self, message, previous, native)
	self.__skipStack = 0
	self.__exceptionMessage = message
	self.__previousException = previous
	if native ~= nil then
		self.__nativeException = native
		self.__nativeStack = __haxe_NativeStackTrace.exceptionStack()
	else
		self.__nativeException = self
		self.__nativeStack = __haxe_NativeStackTrace.callStack()
		self.__skipStack = 1
	end
end
__haxe_Exception.prototype = _hx_e()
__haxe_Exception.prototype.toString = function(self)
	do
		return self:get_message()
	end
end
__haxe_Exception.prototype.get_message = function(self)
	do
		return self.__exceptionMessage
	end
end

__haxe_Log.new = {}
__haxe_Log.formatOutput = function(v, infos)
	local str = Std.string(v)
	if infos == nil then
		do
			return str
		end
	end
	local pstr = Std.string(Std.string(infos.fileName) .. Std.string(":")) .. Std.string(infos.lineNumber)
	if infos.customParams ~= nil then
		local _g = 0
		local _g1 = infos.customParams
		while _g < _g1.length do
			local v = _g1[_g]
			_g = _g + 1
			str = Std.string(str) .. Std.string((Std.string(", ") .. Std.string(Std.string(v))))
		end
	end
	do
		return Std.string(Std.string(pstr) .. Std.string(": ")) .. Std.string(str)
	end
end
__haxe_Log.trace = function(v, infos)
	local str = __haxe_Log.formatOutput(v, infos)
	_hx_print(str)
end

__haxe_NativeStackTrace.new = {}
__haxe_NativeStackTrace.saveStack = function(exception) end
__haxe_NativeStackTrace.callStack = function()
	local _g = debug.traceback()
	if _g == nil then
		do
			return _hx_tab_array({}, 0)
		end
	else
		local s = _g
		local idx = 1
		local ret = _hx_tab_array({}, 0)
		while idx ~= nil do
			local newidx = 0
			if #"\n" > 0 then
				newidx = _G.string.find(s, "\n", idx, true)
			else
				if idx >= #s then
					newidx = nil
				else
					newidx = idx + 1
				end
			end
			if newidx ~= nil then
				local match = _G.string.sub(s, idx, newidx - 1)
				ret:push(match)
				idx = newidx + #"\n"
			else
				ret:push(_G.string.sub(s, idx, #s))
				idx = nil
			end
		end
		do
			return ret:slice(3)
		end
	end
end
__haxe_NativeStackTrace.exceptionStack = function()
	do
		return _hx_tab_array({}, 0)
	end
end

__haxe_iterators_ArrayIterator.new = function(array)
	local self = _hx_new(__haxe_iterators_ArrayIterator.prototype)
	__haxe_iterators_ArrayIterator.super(self, array)
	return self
end
__haxe_iterators_ArrayIterator.super = function(self, array)
	self.current = 0
	self.array = array
end
__haxe_iterators_ArrayIterator.prototype = _hx_e()
__haxe_iterators_ArrayIterator.prototype.hasNext = function(self)
	do
		return self.current < self.array.length
	end
end
__haxe_iterators_ArrayIterator.prototype.next = function(self)
	do
		return self.array[(function()
			local _hx_obj = self
			local _hx_fld = "current"
			local _ = _hx_obj[_hx_fld]
			_hx_obj[_hx_fld] = _hx_obj[_hx_fld] + 1
			return _
		end)()]
	end
end

__haxe_iterators_ArrayKeyValueIterator.new = function(array)
	local self = _hx_new()
	__haxe_iterators_ArrayKeyValueIterator.super(self, array)
	return self
end
__haxe_iterators_ArrayKeyValueIterator.super = function(self, array)
	self.array = array
end

__lua_Thread.new = {}

__packer__Macro_Macro_Fields_.new = {}

__packer__Packer_Plugin_Impl_.new = {}
__packer__Packer_Plugin_Impl_.from = function(spec)
	do
		return {
			spec.name,
			disable = spec.disable,
			as = spec.as,
			installer = spec.installer,
			updater = spec.updater,
			after = spec.after,
			rtp = spec.rtp,
			opt = spec.opt,
			bufread = spec.bufread,
			branch = spec.branch,
			tag = spec.tag,
			commit = spec.commit,
			lock = spec.lock,
			run = spec.run,
			requires = spec.requires,
			rocks = spec.rocks,
			config = spec.config,
			setup = spec.setup,
			cmd = spec.cmd,
			ft = spec.ft,
			keys = spec.keys,
			event = spec.event,
			fn = spec.fn,
			cond = spec.cond,
			module = spec.module,
			module_pattern = spec.module_pattern,
		}
	end
end

__packer__Packer_Packer_Fields_.new = {}
__packer__Packer_Packer_Fields_.get_plugin_version = function(name)
	if _G.packer_plugins ~= nil then
		local path = _G.packer_plugins[name].path
		local args = {
			command = "git",
			cwd = path,
			args = { "rev-parse", "--short", "HEAD" },
			on_stderr = function(args, return_val)
				vim.pretty_print("Job got stderr", args, return_val)
			end,
		}
		local job = __plenary_Job:new(args)
		do
			return job:sync()[1]
		end
	else
		do
			return "unknown"
		end
	end
end
__packer__Packer_Packer_Fields_.ensureInstalled = function()
	local install_path = Std.string(vim.fn.stdpath("data")) .. Std.string("/site/pack/packer/start/packer.nvim")
	if vim.fn.empty(vim.fn.glob(install_path, nil)) > 0 then
		vim.fn.system(
			{ "git", "clone", "--depth", "1", "https://github.com/wbthomason/packer.nvim", install_path },
			nil
		)
		vim.cmd("packadd packer.nvim")
		do
			return true
		end
	else
		do
			return false
		end
	end
end

__safety_SafetyException.new = function(message, previous, native)
	local self = _hx_new(__safety_SafetyException.prototype)
	__safety_SafetyException.super(self, message, previous, native)
	return self
end
__safety_SafetyException.super = function(self, message, previous, native)
	__haxe_Exception.super(self, message, previous, native)
end
__safety_SafetyException.prototype = _hx_e()
__safety_SafetyException.__super__ = __haxe_Exception
setmetatable(__safety_SafetyException.prototype, { __index = __haxe_Exception.prototype })

__safety_NullPointerException.new = function(message, previous, native)
	local self = _hx_new(__safety_NullPointerException.prototype)
	__safety_NullPointerException.super(self, message, previous, native)
	return self
end
__safety_NullPointerException.super = function(self, message, previous, native)
	__safety_SafetyException.super(self, message, previous, native)
end
__safety_NullPointerException.prototype = _hx_e()
__safety_NullPointerException.__super__ = __safety_SafetyException
setmetatable(__safety_NullPointerException.prototype, { __index = __safety_SafetyException.prototype })

__test__RawTable_RawTable_Fields_.new = {}
__test__RawTable_RawTable_Fields_.main = function()
	local x = { name = "rabo", culo = true, cmd = "Rabo" }
	__haxe_Log.trace(
		x,
		_hx_o({
			__fields__ = { fileName = true, lineNumber = true, className = true, methodName = true },
			fileName = "test/RawTable.hx",
			lineNumber = 8,
			className = "test._RawTable.RawTable_Fields_",
			methodName = "main",
		})
	)
end

__test__TestMacros_TestMacros_Fields_.new = {}
__test__TestMacros_TestMacros_Fields_.lotOfNesting = function()
	local _dce1 = ___TableWrapper_TableWrapper_Impl_.check(_hx_o({
		__fields__ = { doX = true, test = true, objWithArr = true, nest = true, arrWithObjs = true },
		doX = 99,
		test = true,
		objWithArr = _hx_o({
			__fields__ = { x = true },
			x = _hx_tab_array({
				[0] = _hx_o({ __fields__ = { y = true }, y = "obj -> array -> obj " }),
				_hx_o({ __fields__ = { y = true }, y = "second obj -> array -> obj " }),
			}, 2),
		}),
		nest = _hx_o({
			__fields__ = { a = true },
			a = _hx_o({
				__fields__ = { renest = true, b = true },
				renest = 99,
				b = _hx_o({ __fields__ = { c = true }, c = _hx_o({ __fields__ = { meganest = true }, meganest = 88 }) }),
			}),
		}),
		arrWithObjs = _hx_tab_array({
			[0] = _hx_o({ __fields__ = { x = true }, x = "inside array -> obj " }),
			_hx_o({ __fields__ = { x = true }, x = "second array -> obj " }),
		}, 2),
	}))
	__test__TestMacros_TestMacros_Fields_.testMethod({
		arrWithObjs = { { x = "inside array -> obj " }, { x = "second array -> obj " } },
		doX = 99,
		nest = { a = { renest = 99, b = { c = { meganest = 88 } } } },
		objWithArr = { x = { { y = "obj -> array -> obj " }, { y = "second obj -> array -> obj " } } },
		test = true,
	})
end
__test__TestMacros_TestMacros_Fields_.objectWithLambdas = function()
	local _dce2 = ___TableWrapper_TableWrapper_Impl_.check(_hx_o({
		__fields__ = { lambda1 = true, nestedLambda = true },
		lambda1 = function(self, name, age)
			_G.print(
				Std.string(
					Std.string(Std.string(Std.string("Hello ") .. Std.string(name)) .. Std.string(", good age "))
						.. Std.string(age)
				)
			)
		end,
		nestedLambda = _hx_o({
			__fields__ = { lambda2 = true },
			lambda2 = function(self, a, b)
				do
					return a + b
				end
			end,
		}),
	}))
	__test__TestMacros_TestMacros_Fields_.testlambdas({
		lambda1 = function(name, age)
			_G.print(
				Std.string(
					Std.string(Std.string(Std.string("Hello ") .. Std.string(name)) .. Std.string(", good age "))
						.. Std.string(age)
				)
			)
		end,
		nestedLambda = {
			lambda2 = function(a, b)
				do
					return a + b
				end
			end,
		},
	})
end

__vim__Vim_Vim_Fields_.new = {}
__vim__Vim_Vim_Fields_.comment = function()
	---@diagnostic disable;
end

__vim_FunctionOrString.Cb = function(cb)
	local _x = _hx_tab_array({ [0] = "Cb", 0, cb, __enum__ = __vim_FunctionOrString }, 3)
	return _x
end
__vim_FunctionOrString.Str = function(cmd)
	local _x = _hx_tab_array({ [0] = "Str", 1, cmd, __enum__ = __vim_FunctionOrString }, 3)
	return _x
end

__vim__VimTypes_GroupOpts_Impl_.new = {}
__vim__VimTypes_GroupOpts_Impl_._new = function(clear)
	local this1 = { clear = clear }
	do
		return this1
	end
end
__vim__VimTypes_GroupOpts_Impl_.fromObj = function(arg)
	local this1 = { clear = arg.clear }
	do
		return this1
	end
end

__vim__VimTypes_LuaArray_Impl_.new = {}
__vim__VimTypes_LuaArray_Impl_.from = function(arr)
	local ret = {}
	local _g = 0
	local _g1 = arr.length
	while _g < _g1 do
		_g = _g + 1
		local idx = _g - 1
		ret[idx + 1] = arr[idx]
	end
	do
		return ret
	end
end
__vim__VimTypes_LuaArray_Impl_.map = function(this1, fn)
	do
		return vim.tbl_map(fn, this1)
	end
end

__vim__VimTypes_LuaObj_Impl_.new = {}
__vim__VimTypes_LuaObj_Impl_.fromType = function(obj)
	obj.__fields__ = nil
	_G.setmetatable(obj, nil)
	do
		return obj
	end
end
__vim__VimTypes_LuaObj_Impl_.to = function(this1)
	do
		return this1
	end
end

__vim__VimTypes_ExpandString_Impl_.new = {}
__vim__VimTypes_ExpandString_Impl_._new = function(path)
	local this1 = path
	do
		return this1
	end
end
__vim__VimTypes_ExpandString_Impl_.from = function(ref)
	local this1 = ref
	do
		return this1
	end
end
__vim__VimTypes_ExpandString_Impl_.plus0 = function(this1, modifiers)
	do
		return _G.string.format("%s%s", this1, modifiers)
	end
end
__vim__VimTypes_ExpandString_Impl_.plus = function(path, modifiers)
	do
		return _G.string.format("%s%s", path, modifiers)
	end
end

__vim__VimTypes_Vector3_Impl_.new = {}
__vim__VimTypes_Vector3_Impl_.first = function(this1)
	do
		return this1[1]
	end
end
__vim__VimTypes_Vector3_Impl_.second = function(this1)
	do
		return this1[2]
	end
end
__vim__VimTypes_Vector3_Impl_.last = function(this1)
	do
		return this1[3]
	end
end

__vim__VimTypes_Vector4_Impl_.new = {}
__vim__VimTypes_Vector4_Impl_.first = function(this1)
	do
		return this1[1]
	end
end
__vim__VimTypes_Vector4_Impl_.second = function(this1)
	do
		return this1[2]
	end
end
__vim__VimTypes_Vector4_Impl_.third = function(this1)
	do
		return this1[3]
	end
end
__vim__VimTypes_Vector4_Impl_.last = function(this1)
	do
		return this1[4]
	end
end

__vim_types_ArgCompleteEnum.Custom = function(vimFn)
	local _x = _hx_tab_array({ [0] = "Custom", 0, vimFn, __enum__ = __vim_types_ArgCompleteEnum }, 3)
	return _x
end
__vim_types_ArgCompleteEnum.CustomLua = function(luaRef)
	local _x = _hx_tab_array({ [0] = "CustomLua", 1, luaRef, __enum__ = __vim_types_ArgCompleteEnum }, 3)
	return _x
end
__vim_types_ArgCompleteEnum.ArgList = _hx_tab_array({ [0] = "ArgList", 2, __enum__ = __vim_types_ArgCompleteEnum }, 2)

__vim_types_ArgCompleteEnum.Augroup = _hx_tab_array({ [0] = "Augroup", 3, __enum__ = __vim_types_ArgCompleteEnum }, 2)

__vim_types_ArgCompleteEnum.Buffer = _hx_tab_array({ [0] = "Buffer", 4, __enum__ = __vim_types_ArgCompleteEnum }, 2)

__vim_types_ArgCompleteEnum.Behave = _hx_tab_array({ [0] = "Behave", 5, __enum__ = __vim_types_ArgCompleteEnum }, 2)

__vim_types_ArgCompleteEnum.Color = _hx_tab_array({ [0] = "Color", 6, __enum__ = __vim_types_ArgCompleteEnum }, 2)

__vim_types_ArgCompleteEnum.Command = _hx_tab_array({ [0] = "Command", 7, __enum__ = __vim_types_ArgCompleteEnum }, 2)

__vim_types_ArgCompleteEnum.Compiler = _hx_tab_array({ [0] = "Compiler", 8, __enum__ = __vim_types_ArgCompleteEnum }, 2)

__vim_types_ArgCompleteEnum.Dir = _hx_tab_array({ [0] = "Dir", 9, __enum__ = __vim_types_ArgCompleteEnum }, 2)

__vim_types_ArgCompleteEnum.Environment =
	_hx_tab_array({ [0] = "Environment", 10, __enum__ = __vim_types_ArgCompleteEnum }, 2)

__vim_types_ArgCompleteEnum.Event = _hx_tab_array({ [0] = "Event", 11, __enum__ = __vim_types_ArgCompleteEnum }, 2)

__vim_types_ArgCompleteEnum.Expression =
	_hx_tab_array({ [0] = "Expression", 12, __enum__ = __vim_types_ArgCompleteEnum }, 2)

__vim_types_ArgCompleteEnum.File = _hx_tab_array({ [0] = "File", 13, __enum__ = __vim_types_ArgCompleteEnum }, 2)

__vim_types_ArgCompleteEnum.File_in_path =
	_hx_tab_array({ [0] = "File_in_path", 14, __enum__ = __vim_types_ArgCompleteEnum }, 2)

__vim_types_ArgCompleteEnum.Filetype =
	_hx_tab_array({ [0] = "Filetype", 15, __enum__ = __vim_types_ArgCompleteEnum }, 2)

__vim_types_ArgCompleteEnum.Function =
	_hx_tab_array({ [0] = "Function", 16, __enum__ = __vim_types_ArgCompleteEnum }, 2)

__vim_types_ArgCompleteEnum.Help = _hx_tab_array({ [0] = "Help", 17, __enum__ = __vim_types_ArgCompleteEnum }, 2)

__vim_types_ArgCompleteEnum.Highlight =
	_hx_tab_array({ [0] = "Highlight", 18, __enum__ = __vim_types_ArgCompleteEnum }, 2)

__vim_types_ArgCompleteEnum.History = _hx_tab_array({ [0] = "History", 19, __enum__ = __vim_types_ArgCompleteEnum }, 2)

__vim_types_ArgCompleteEnum.Locale = _hx_tab_array({ [0] = "Locale", 20, __enum__ = __vim_types_ArgCompleteEnum }, 2)

__vim_types_ArgCompleteEnum.Lua = _hx_tab_array({ [0] = "Lua", 21, __enum__ = __vim_types_ArgCompleteEnum }, 2)

__vim_types_ArgCompleteEnum.Mapclear =
	_hx_tab_array({ [0] = "Mapclear", 22, __enum__ = __vim_types_ArgCompleteEnum }, 2)

__vim_types_ArgCompleteEnum.Mapping = _hx_tab_array({ [0] = "Mapping", 23, __enum__ = __vim_types_ArgCompleteEnum }, 2)

__vim_types_ArgCompleteEnum.Menu = _hx_tab_array({ [0] = "Menu", 24, __enum__ = __vim_types_ArgCompleteEnum }, 2)

__vim_types_ArgCompleteEnum.Messages =
	_hx_tab_array({ [0] = "Messages", 25, __enum__ = __vim_types_ArgCompleteEnum }, 2)

__vim_types_ArgCompleteEnum.Option = _hx_tab_array({ [0] = "Option", 26, __enum__ = __vim_types_ArgCompleteEnum }, 2)

__vim_types_ArgCompleteEnum.Packadd = _hx_tab_array({ [0] = "Packadd", 27, __enum__ = __vim_types_ArgCompleteEnum }, 2)

__vim_types_ArgCompleteEnum.Shellcmd =
	_hx_tab_array({ [0] = "Shellcmd", 28, __enum__ = __vim_types_ArgCompleteEnum }, 2)

__vim_types_ArgCompleteEnum.Sign = _hx_tab_array({ [0] = "Sign", 29, __enum__ = __vim_types_ArgCompleteEnum }, 2)

__vim_types_ArgCompleteEnum.Syntax = _hx_tab_array({ [0] = "Syntax", 30, __enum__ = __vim_types_ArgCompleteEnum }, 2)

__vim_types_ArgCompleteEnum.Syntime = _hx_tab_array({ [0] = "Syntime", 31, __enum__ = __vim_types_ArgCompleteEnum }, 2)

__vim_types_ArgCompleteEnum.Tag = _hx_tab_array({ [0] = "Tag", 32, __enum__ = __vim_types_ArgCompleteEnum }, 2)

__vim_types_ArgCompleteEnum.Tag_listfiles =
	_hx_tab_array({ [0] = "Tag_listfiles", 33, __enum__ = __vim_types_ArgCompleteEnum }, 2)

__vim_types_ArgCompleteEnum.User = _hx_tab_array({ [0] = "User", 34, __enum__ = __vim_types_ArgCompleteEnum }, 2)

__vim_types_ArgCompleteEnum.Var = _hx_tab_array({ [0] = "Var", 35, __enum__ = __vim_types_ArgCompleteEnum }, 2)

__vim_types__ArgComplete_ArgComplete_Impl_.new = {}
__vim_types__ArgComplete_ArgComplete_Impl_._new = function(arg)
	local this1 = arg
	do
		return this1
	end
end
__vim_types__ArgComplete_ArgComplete_Impl_.from = function(enumValue)
	local tmp = enumValue[1]
	if tmp == 0 then
		local ref = enumValue[2]
		local this1 = Std.string("custom,") .. Std.string(ref)
		do
			return this1
		end
	elseif tmp == 1 then
		local ref = enumValue[2]
		local this1 = Std.string("customlist,v:lua.") .. Std.string(ref)
		do
			return this1
		end
	elseif tmp == 2 then
		local this1 = "arglist"
		do
			return this1
		end
	elseif tmp == 3 then
		local this1 = "augroup"
		do
			return this1
		end
	elseif tmp == 4 then
		local this1 = "buffer"
		do
			return this1
		end
	elseif tmp == 5 then
		local this1 = "behave"
		do
			return this1
		end
	elseif tmp == 6 then
		local this1 = "color"
		do
			return this1
		end
	elseif tmp == 7 then
		local this1 = "command"
		do
			return this1
		end
	elseif tmp == 8 then
		local this1 = "compiler"
		do
			return this1
		end
	elseif tmp == 9 then
		local this1 = "dir"
		do
			return this1
		end
	elseif tmp == 10 then
		local this1 = "environment"
		do
			return this1
		end
	elseif tmp == 11 then
		local this1 = "event"
		do
			return this1
		end
	elseif tmp == 12 then
		local this1 = "expression"
		do
			return this1
		end
	elseif tmp == 13 then
		local this1 = "file"
		do
			return this1
		end
	elseif tmp == 14 then
		local this1 = "file_in_path"
		do
			return this1
		end
	elseif tmp == 15 then
		local this1 = "filetype"
		do
			return this1
		end
	elseif tmp == 16 then
		local this1 = "function"
		do
			return this1
		end
	elseif tmp == 17 then
		local this1 = "help"
		do
			return this1
		end
	elseif tmp == 18 then
		local this1 = "highlight"
		do
			return this1
		end
	elseif tmp == 19 then
		local this1 = "history"
		do
			return this1
		end
	elseif tmp == 20 then
		local this1 = "locale"
		do
			return this1
		end
	elseif tmp == 21 then
		local this1 = "lua"
		do
			return this1
		end
	elseif tmp == 22 then
		local this1 = "mapclear"
		do
			return this1
		end
	elseif tmp == 23 then
		local this1 = "mapping"
		do
			return this1
		end
	elseif tmp == 24 then
		local this1 = "menu"
		do
			return this1
		end
	elseif tmp == 25 then
		local this1 = "messages"
		do
			return this1
		end
	elseif tmp == 26 then
		local this1 = "option"
		do
			return this1
		end
	elseif tmp == 27 then
		local this1 = "packadd"
		do
			return this1
		end
	elseif tmp == 28 then
		local this1 = "shellcmd"
		do
			return this1
		end
	elseif tmp == 29 then
		local this1 = "sign"
		do
			return this1
		end
	elseif tmp == 30 then
		local this1 = "syntax"
		do
			return this1
		end
	elseif tmp == 31 then
		local this1 = "syntime"
		do
			return this1
		end
	elseif tmp == 32 then
		local this1 = "tag"
		do
			return this1
		end
	elseif tmp == 33 then
		local this1 = "tag_listfiles"
		do
			return this1
		end
	elseif tmp == 34 then
		local this1 = "user"
		do
			return this1
		end
	elseif tmp == 35 then
		local this1 = "var"
		do
			return this1
		end
	end
end
if _hx_bit_raw then
	_hx_bit_clamp = function(v)
		if v <= 2147483647 and v >= -2147483648 then
			if v > 0 then
				return _G.math.floor(v)
			else
				return _G.math.ceil(v)
			end
		end
		if v > 2251798999999999 then
			v = v * 2
		end
		if v ~= v or math.abs(v) == _G.math.huge then
			return nil
		end
		return _hx_bit_raw.band(v, 2147483647) - math.abs(_hx_bit_raw.band(v, 2147483648))
	end
else
	_hx_bit_clamp = function(v)
		if v < -2147483648 then
			return -2147483648
		elseif v > 2147483647 then
			return 2147483647
		elseif v > 0 then
			return _G.math.floor(v)
		else
			return _G.math.ceil(v)
		end
	end
end

_hx_array_mt.__index = Array.prototype

local _hx_static_init = function() end

_hx_print = print or function() end

_hx_static_init()
