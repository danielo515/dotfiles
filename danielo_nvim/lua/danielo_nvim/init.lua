local _hx_hidden = {__id__=true, hx__closures=true, super=true, prototype=true, __fields__=true, __ifields__=true, __class__=true, __properties__=true, __fields__=true, __name__=true}

_hx_array_mt = {
    __newindex = function(t,k,v)
        local len = t.length
        t.length =  k >= len and (k + 1) or len
        rawset(t,k,v)
    end
}

function _hx_is_array(o)
    return type(o) == "table"
        and o.__enum__ == nil
        and getmetatable(o) == _hx_array_mt
end



function _hx_tab_array(tab, length)
    tab.length = length
    return setmetatable(tab, _hx_array_mt)
end



function _hx_print_class(obj, depth)
    local first = true
    local result = ''
    for k,v in pairs(obj) do
        if _hx_hidden[k] == nil then
            if first then
                first = false
            else
                result = result .. ', '
            end
            if _hx_hidden[k] == nil then
                result = result .. k .. ':' .. _hx_tostring(v, depth+1)
            end
        end
    end
    return '{ ' .. result .. ' }'
end

function _hx_print_enum(o, depth)
    if o.length == 2 then
        return o[0]
    else
        local str = o[0] .. "("
        for i = 2, (o.length-1) do
            if i ~= 2 then
                str = str .. "," .. _hx_tostring(o[i], depth+1)
            else
                str = str .. _hx_tostring(o[i], depth+1)
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
    if tstr == "string" then return obj
    elseif tstr == "nil" then return "null"
    elseif tstr == "number" then
        if obj == _G.math.POSITIVE_INFINITY then return "Infinity"
        elseif obj == _G.math.NEGATIVE_INFINITY then return "-Infinity"
        elseif obj == 0 then return "0"
        elseif obj ~= obj then return "NaN"
        else return _G.tostring(obj)
        end
    elseif tstr == "boolean" then return _G.tostring(obj)
    elseif tstr == "userdata" then
        local mt = _G.getmetatable(obj)
        if mt ~= nil and mt.__tostring ~= nil then
            return _G.tostring(obj)
        else
            return "<userdata>"
        end
    elseif tstr == "function" then return "<function>"
    elseif tstr == "thread" then return "<thread>"
    elseif tstr == "table" then
        if obj.__enum__ ~= nil then
            return _hx_print_enum(obj, depth)
        elseif obj.toString ~= nil and not _hx_is_array(obj) then return obj:toString()
        elseif _hx_is_array(obj) then
            if obj.length > 5 then
                return "[...]"
            else
                local str = ""
                for i=0, (obj.length-1) do
                    if i == 0 then
                        str = str .. _hx_tostring(obj[i], depth+1)
                    else
                        str = str .. "," .. _hx_tostring(obj[i], depth+1)
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
            for k,v in pairs(ref) do
                if _hx_hidden[k] == nil then
                    _G.table.insert(buffer, _hx_tostring(k, depth+1) .. ' : ' .. _hx_tostring(obj[k], depth+1))
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
        _G.print("runtime error:\n " .. _hx_tostring(obj.value));
    else
        _G.print("runtime error:\n " .. tostring(obj));
    end

    if _G.debug and _G.debug.traceback then
        _G.print(debug.traceback());
    end
end


local function _hx_obj_newindex(t,k,v)
    t.__fields__[k] = true
    rawset(t,k,v)
end

local _hx_obj_mt = {__newindex=_hx_obj_newindex, __tostring=_hx_tostring}

local function _hx_a(...)
  local __fields__ = {};
  local ret = {__fields__ = __fields__};
  local max = select('#',...);
  local tab = {...};
  local cur = 1;
  while cur < max do
    local v = tab[cur];
    __fields__[v] = true;
    ret[v] = tab[cur+1];
    cur = cur + 2
  end
  return setmetatable(ret, _hx_obj_mt)
end

local function _hx_e()
  return setmetatable({__fields__ = {}}, _hx_obj_mt)
end

local function _hx_o(obj)
  return setmetatable(obj, _hx_obj_mt)
end

local function _hx_new(prototype)
  return setmetatable({__fields__ = {}}, {__newindex=_hx_obj_newindex, __index=prototype, __tostring=_hx_tostring})
end

function _hx_field_arr(obj)
    res = {}
    idx = 0
    if obj.__fields__ ~= nil then
        obj = obj.__fields__
    end
    for k,v in pairs(obj) do
        if _hx_hidden[k] == nil then
            res[idx] = k
            idx = idx + 1
        end
    end
    return _hx_tab_array(res, idx)
end

local _hxClasses = {}
local Int = _hx_e();
local Dynamic = _hx_e();
local Float = _hx_e();
local Bool = _hx_e();
local Class = _hx_e();
local Enum = _hx_e();

local _hx_exports = _hx_exports or {}
_hx_exports["parser"] = _hx_exports["parser"] or _hx_e()
local Array = _hx_e()
local Math = _hx_e()
local String = _hx_e()
local Std = _hx_e()
local Test = _hx_e()
___VimTypes_LuaArray_Impl_ = _hx_e()
___VimTypes_BufferId_Impl_ = _hx_e()
___VimTypes_WindowId_Impl_ = _hx_e()
__haxe_Log = _hx_e()
__haxe_iterators_ArrayIterator = _hx_e()
__haxe_iterators_ArrayKeyValueIterator = _hx_e()
__parser_State = _hx_e()
__parser_Parser = _hx_e()
__parser_ClassName = _hx_e()
__vim__Vim_GroupOpts_Impl_ = _hx_e()
__vim__Vim_AutoCmdOpts_Impl_ = _hx_e()
__vim_DanieloVim = _hx_e()
__vim__Vim_Vim_Fields_ = _hx_e()

local _hx_bind, _hx_bit, _hx_staticToInstance, _hx_funcToField, _hx_maxn, _hx_print, _hx_apply_self, _hx_box_mr, _hx_bit_clamp, _hx_table, _hx_bit_raw
local _hx_pcall_default = {};
local _hx_pcall_break = {};

Array.new = function() 
  local self = _hx_new(Array.prototype)
  Array.super(self)
  return self
end
Array.super = function(self) 
  _hx_tab_array(self, 0);
end
Array.prototype = _hx_e();
Array.prototype.concat = function(self,a) 
  local _g = _hx_tab_array({}, 0);
  local _g1 = 0;
  local _g2 = self;
  while (_g1 < _g2.length) do 
    local i = _g2[_g1];
    _g1 = _g1 + 1;
    _g:push(i);
  end;
  local ret = _g;
  local _g = 0;
  while (_g < a.length) do 
    local i = a[_g];
    _g = _g + 1;
    ret:push(i);
  end;
  do return ret end
end
Array.prototype.join = function(self,sep) 
  local tbl = ({});
  local _g_current = 0;
  local _g_array = self;
  while (_g_current < _g_array.length) do 
    _g_current = _g_current + 1;
    local i = _g_array[_g_current - 1];
    _G.table.insert(tbl, Std.string(i));
  end;
  do return _G.table.concat(tbl, sep) end
end
Array.prototype.pop = function(self) 
  if (self.length == 0) then 
    do return nil end;
  end;
  local ret = self[self.length - 1];
  self[self.length - 1] = nil;
  self.length = self.length - 1;
  do return ret end
end
Array.prototype.push = function(self,x) 
  self[self.length] = x;
  do return self.length end
end
Array.prototype.reverse = function(self) 
  local tmp;
  local i = 0;
  while (i < Std.int(self.length / 2)) do 
    tmp = self[i];
    self[i] = self[(self.length - i) - 1];
    self[(self.length - i) - 1] = tmp;
    i = i + 1;
  end;
end
Array.prototype.shift = function(self) 
  if (self.length == 0) then 
    do return nil end;
  end;
  local ret = self[0];
  if (self.length == 1) then 
    self[0] = nil;
  else
    if (self.length > 1) then 
      self[0] = self[1];
      _G.table.remove(self, 1);
    end;
  end;
  local tmp = self;
  tmp.length = tmp.length - 1;
  do return ret end
end
Array.prototype.slice = function(self,pos,_end) 
  if ((_end == nil) or (_end > self.length)) then 
    _end = self.length;
  else
    if (_end < 0) then 
      _end = _G.math.fmod((self.length - (_G.math.fmod(-_end, self.length))), self.length);
    end;
  end;
  if (pos < 0) then 
    pos = _G.math.fmod((self.length - (_G.math.fmod(-pos, self.length))), self.length);
  end;
  if ((pos > _end) or (pos > self.length)) then 
    do return _hx_tab_array({}, 0) end;
  end;
  local ret = _hx_tab_array({}, 0);
  local _g = pos;
  local _g1 = _end;
  while (_g < _g1) do 
    _g = _g + 1;
    local i = _g - 1;
    ret:push(self[i]);
  end;
  do return ret end
end
Array.prototype.sort = function(self,f) 
  local i = 0;
  local l = self.length;
  while (i < l) do 
    local swap = false;
    local j = 0;
    local max = (l - i) - 1;
    while (j < max) do 
      if (f(self[j], self[j + 1]) > 0) then 
        local tmp = self[j + 1];
        self[j + 1] = self[j];
        self[j] = tmp;
        swap = true;
      end;
      j = j + 1;
    end;
    if (not swap) then 
      break;
    end;
    i = i + 1;
  end;
end
Array.prototype.splice = function(self,pos,len) 
  if ((len < 0) or (pos > self.length)) then 
    do return _hx_tab_array({}, 0) end;
  else
    if (pos < 0) then 
      pos = self.length - (_G.math.fmod(-pos, self.length));
    end;
  end;
  len = Math.min(len, self.length - pos);
  local ret = _hx_tab_array({}, 0);
  local _g = pos;
  local _g1 = pos + len;
  while (_g < _g1) do 
    _g = _g + 1;
    local i = _g - 1;
    ret:push(self[i]);
    self[i] = self[i + len];
  end;
  local _g = pos + len;
  local _g1 = self.length;
  while (_g < _g1) do 
    _g = _g + 1;
    local i = _g - 1;
    self[i] = self[i + len];
  end;
  local tmp = self;
  tmp.length = tmp.length - len;
  do return ret end
end
Array.prototype.toString = function(self) 
  local tbl = ({});
  _G.table.insert(tbl, "[");
  _G.table.insert(tbl, self:join(","));
  _G.table.insert(tbl, "]");
  do return _G.table.concat(tbl, "") end
end
Array.prototype.unshift = function(self,x) 
  local len = self.length;
  local _g = 0;
  local _g1 = len;
  while (_g < _g1) do 
    _g = _g + 1;
    local i = _g - 1;
    self[len - i] = self[(len - i) - 1];
  end;
  self[0] = x;
end
Array.prototype.insert = function(self,pos,x) 
  if (pos > self.length) then 
    pos = self.length;
  end;
  if (pos < 0) then 
    pos = self.length + pos;
    if (pos < 0) then 
      pos = 0;
    end;
  end;
  local cur_len = self.length;
  while (cur_len > pos) do 
    self[cur_len] = self[cur_len - 1];
    cur_len = cur_len - 1;
  end;
  self[pos] = x;
end
Array.prototype.remove = function(self,x) 
  local _g = 0;
  local _g1 = self.length;
  while (_g < _g1) do 
    _g = _g + 1;
    local i = _g - 1;
    if (self[i] == x) then 
      local _g = i;
      local _g1 = self.length - 1;
      while (_g < _g1) do 
        _g = _g + 1;
        local j = _g - 1;
        self[j] = self[j + 1];
      end;
      self[self.length - 1] = nil;
      self.length = self.length - 1;
      do return true end;
    end;
  end;
  do return false end
end
Array.prototype.contains = function(self,x) 
  local _g = 0;
  local _g1 = self.length;
  while (_g < _g1) do 
    _g = _g + 1;
    local i = _g - 1;
    if (self[i] == x) then 
      do return true end;
    end;
  end;
  do return false end
end
Array.prototype.indexOf = function(self,x,fromIndex) 
  local _end = self.length;
  if (fromIndex == nil) then 
    fromIndex = 0;
  else
    if (fromIndex < 0) then 
      fromIndex = self.length + fromIndex;
      if (fromIndex < 0) then 
        fromIndex = 0;
      end;
    end;
  end;
  local _g = fromIndex;
  local _g1 = _end;
  while (_g < _g1) do 
    _g = _g + 1;
    local i = _g - 1;
    if (x == self[i]) then 
      do return i end;
    end;
  end;
  do return -1 end
end
Array.prototype.lastIndexOf = function(self,x,fromIndex) 
  if ((fromIndex == nil) or (fromIndex >= self.length)) then 
    fromIndex = self.length - 1;
  else
    if (fromIndex < 0) then 
      fromIndex = self.length + fromIndex;
      if (fromIndex < 0) then 
        do return -1 end;
      end;
    end;
  end;
  local i = fromIndex;
  while (i >= 0) do 
    if (self[i] == x) then 
      do return i end;
    else
      i = i - 1;
    end;
  end;
  do return -1 end
end
Array.prototype.copy = function(self) 
  local _g = _hx_tab_array({}, 0);
  local _g1 = 0;
  local _g2 = self;
  while (_g1 < _g2.length) do 
    local i = _g2[_g1];
    _g1 = _g1 + 1;
    _g:push(i);
  end;
  do return _g end
end
Array.prototype.map = function(self,f) 
  local _g = _hx_tab_array({}, 0);
  local _g1 = 0;
  local _g2 = self;
  while (_g1 < _g2.length) do 
    local i = _g2[_g1];
    _g1 = _g1 + 1;
    _g:push(f(i));
  end;
  do return _g end
end
Array.prototype.filter = function(self,f) 
  local _g = _hx_tab_array({}, 0);
  local _g1 = 0;
  local _g2 = self;
  while (_g1 < _g2.length) do 
    local i = _g2[_g1];
    _g1 = _g1 + 1;
    if (f(i)) then 
      _g:push(i);
    end;
  end;
  do return _g end
end
Array.prototype.iterator = function(self) 
  do return __haxe_iterators_ArrayIterator.new(self) end
end
Array.prototype.keyValueIterator = function(self) 
  do return __haxe_iterators_ArrayKeyValueIterator.new(self) end
end
Array.prototype.resize = function(self,len) 
  if (self.length < len) then 
    self.length = len;
  else
    if (self.length > len) then 
      local _g = len;
      local _g1 = self.length;
      while (_g < _g1) do 
        _g = _g + 1;
        local i = _g - 1;
        self[i] = nil;
      end;
      self.length = len;
    end;
  end;
end

Math.new = {}
Math.isNaN = function(f) 
  do return f ~= f end;
end
Math.isFinite = function(f) 
  if (f > -_G.math.huge) then 
    do return f < _G.math.huge end;
  else
    do return false end;
  end;
end
Math.min = function(a,b) 
  if (Math.isNaN(a) or Math.isNaN(b)) then 
    do return (0/0) end;
  else
    do return _G.math.min(a, b) end;
  end;
end

String.new = function(string) 
  local self = _hx_new(String.prototype)
  String.super(self,string)
  self = string
  return self
end
String.super = function(self,string) 
end
String.__index = function(s,k) 
  if (k == "length") then 
    do return _G.string.len(s) end;
  else
    local o = String.prototype;
    local field = k;
    if ((function() 
      local _hx_1
      if ((_G.type(o) == "string") and ((String.prototype[field] ~= nil) or (field == "length"))) then 
      _hx_1 = true; elseif (o.__fields__ ~= nil) then 
      _hx_1 = o.__fields__[field] ~= nil; else 
      _hx_1 = o[field] ~= nil; end
      return _hx_1
    end )()) then 
      do return String.prototype[k] end;
    else
      if (String.__oldindex ~= nil) then 
        if (_G.type(String.__oldindex) == "function") then 
          do return String.__oldindex(s, k) end;
        else
          if (_G.type(String.__oldindex) == "table") then 
            do return String.__oldindex[k] end;
          end;
        end;
        do return nil end;
      else
        do return nil end;
      end;
    end;
  end;
end
String.indexOfEmpty = function(s,startIndex) 
  local length = _G.string.len(s);
  if (startIndex < 0) then 
    startIndex = length + startIndex;
    if (startIndex < 0) then 
      startIndex = 0;
    end;
  end;
  if (startIndex > length) then 
    do return length end;
  else
    do return startIndex end;
  end;
end
String.fromCharCode = function(code) 
  do return _G.string.char(code) end;
end
String.prototype = _hx_e();
String.prototype.toUpperCase = function(self) 
  do return _G.string.upper(self) end
end
String.prototype.toLowerCase = function(self) 
  do return _G.string.lower(self) end
end
String.prototype.indexOf = function(self,str,startIndex) 
  if (startIndex == nil) then 
    startIndex = 1;
  else
    startIndex = startIndex + 1;
  end;
  if (str == "") then 
    do return String.indexOfEmpty(self, startIndex - 1) end;
  end;
  local r = _G.string.find(self, str, startIndex, true);
  if ((r ~= nil) and (r > 0)) then 
    do return r - 1 end;
  else
    do return -1 end;
  end;
end
String.prototype.lastIndexOf = function(self,str,startIndex) 
  local ret = -1;
  if (startIndex == nil) then 
    startIndex = #self;
  end;
  while (true) do 
    local startIndex1 = ret + 1;
    if (startIndex1 == nil) then 
      startIndex1 = 1;
    else
      startIndex1 = startIndex1 + 1;
    end;
    local p;
    if (str == "") then 
      p = String.indexOfEmpty(self, startIndex1 - 1);
    else
      local r = _G.string.find(self, str, startIndex1, true);
      p = (function() 
        local _hx_1
        if ((r ~= nil) and (r > 0)) then 
        _hx_1 = r - 1; else 
        _hx_1 = -1; end
        return _hx_1
      end )();
    end;
    if (((p == -1) or (p > startIndex)) or (p == ret)) then 
      break;
    end;
    ret = p;
  end;
  do return ret end
end
String.prototype.split = function(self,delimiter) 
  local idx = 1;
  local ret = _hx_tab_array({}, 0);
  while (idx ~= nil) do 
    local newidx = 0;
    if (#delimiter > 0) then 
      newidx = _G.string.find(self, delimiter, idx, true);
    else
      if (idx >= #self) then 
        newidx = nil;
      else
        newidx = idx + 1;
      end;
    end;
    if (newidx ~= nil) then 
      local match = _G.string.sub(self, idx, newidx - 1);
      ret:push(match);
      idx = newidx + #delimiter;
    else
      ret:push(_G.string.sub(self, idx, #self));
      idx = nil;
    end;
  end;
  do return ret end
end
String.prototype.toString = function(self) 
  do return self end
end
String.prototype.substring = function(self,startIndex,endIndex) 
  if (endIndex == nil) then 
    endIndex = #self;
  end;
  if (endIndex < 0) then 
    endIndex = 0;
  end;
  if (startIndex < 0) then 
    startIndex = 0;
  end;
  if (endIndex < startIndex) then 
    do return _G.string.sub(self, endIndex + 1, startIndex) end;
  else
    do return _G.string.sub(self, startIndex + 1, endIndex) end;
  end;
end
String.prototype.charAt = function(self,index) 
  do return _G.string.sub(self, index + 1, index + 1) end
end
String.prototype.charCodeAt = function(self,index) 
  do return _G.string.byte(self, index + 1) end
end
String.prototype.substr = function(self,pos,len) 
  if ((len == nil) or (len > (pos + #self))) then 
    len = #self;
  else
    if (len < 0) then 
      len = #self + len;
    end;
  end;
  if (pos < 0) then 
    pos = #self + pos;
  end;
  if (pos < 0) then 
    pos = 0;
  end;
  do return _G.string.sub(self, pos + 1, pos + len) end
end

Std.new = {}
Std.string = function(s) 
  do return _hx_tostring(s, 0) end;
end
Std.int = function(x) 
  if (not Math.isFinite(x) or Math.isNaN(x)) then 
    do return 0 end;
  else
    do return _hx_bit_clamp(x) end;
  end;
end

Test.new = {}
Test["or"] = function(v,fallback) 
  if (v ~= nil) then 
    do return v end;
  else
    do return fallback end;
  end;
end

___VimTypes_LuaArray_Impl_.new = {}
___VimTypes_LuaArray_Impl_.from = function(arr) 
  local ret = ({});
  local _g = 0;
  local _g1 = arr.length;
  while (_g < _g1) do 
    _g = _g + 1;
    local idx = _g - 1;
    ret[idx + 1] = arr[idx];
  end;
  do return ret end;
end

___VimTypes_BufferId_Impl_.new = {}
___VimTypes_BufferId_Impl_._new = function(buf) 
  local this1 = buf;
  do return this1 end;
end
___VimTypes_BufferId_Impl_.from = function(bufNum) 
  do return ___VimTypes_BufferId_Impl_._new(bufNum) end;
end

___VimTypes_WindowId_Impl_.new = {}
___VimTypes_WindowId_Impl_._new = function(id) 
  local this1 = id;
  do return this1 end;
end
___VimTypes_WindowId_Impl_.from = function(id) 
  do return ___VimTypes_WindowId_Impl_._new(id) end;
end

__haxe_Log.new = {}
__haxe_Log.formatOutput = function(v,infos) 
  local str = Std.string(v);
  if (infos == nil) then 
    do return str end;
  end;
  local pstr = Std.string(Std.string(infos.fileName) .. Std.string(":")) .. Std.string(infos.lineNumber);
  if (infos.customParams ~= nil) then 
    local _g = 0;
    local _g1 = infos.customParams;
    while (_g < _g1.length) do 
      local v = _g1[_g];
      _g = _g + 1;
      str = Std.string(str) .. Std.string((Std.string(", ") .. Std.string(Std.string(v))));
    end;
  end;
  do return Std.string(Std.string(pstr) .. Std.string(": ")) .. Std.string(str) end;
end
__haxe_Log.trace = function(v,infos) 
  local str = __haxe_Log.formatOutput(v, infos);
  _hx_print(str);
end

__haxe_iterators_ArrayIterator.new = function(array) 
  local self = _hx_new(__haxe_iterators_ArrayIterator.prototype)
  __haxe_iterators_ArrayIterator.super(self,array)
  return self
end
__haxe_iterators_ArrayIterator.super = function(self,array) 
  self.current = 0;
  self.array = array;
end
__haxe_iterators_ArrayIterator.prototype = _hx_e();
__haxe_iterators_ArrayIterator.prototype.hasNext = function(self) 
  do return self.current < self.array.length end
end
__haxe_iterators_ArrayIterator.prototype.next = function(self) 
  do return self.array[(function() 
  local _hx_obj = self;
  local _hx_fld = 'current';
  local _ = _hx_obj[_hx_fld];
  _hx_obj[_hx_fld] = _hx_obj[_hx_fld]  + 1;
   return _;
   end)()] end
end

__haxe_iterators_ArrayKeyValueIterator.new = function(array) 
  local self = _hx_new()
  __haxe_iterators_ArrayKeyValueIterator.super(self,array)
  return self
end
__haxe_iterators_ArrayKeyValueIterator.super = function(self,array) 
  self.array = array;
end

__parser_State.Initial = _hx_tab_array({[0]="Initial",0,__enum__ = __parser_State},2)

__parser_State.Finished = function(tokens) local _x = _hx_tab_array({[0]="Finished",1,tokens,__enum__=__parser_State}, 3); return _x; end 
__parser_State.Running = function(buffer,position) local _x = _hx_tab_array({[0]="Running",2,buffer,position,__enum__=__parser_State}, 4); return _x; end 

__parser_Parser.new = function(str,checker) 
  local self = _hx_new(__parser_Parser.prototype)
  __parser_Parser.super(self,str,checker)
  return self
end
__parser_Parser.super = function(self,str,checker) 
  self.string = str;
  self.state = __parser_State.Initial;
  self.tokens = _hx_tab_array({}, 0);
  self.checker = _hx_funcToField(checker);
end
__parser_Parser.prototype = _hx_e();
__parser_Parser.prototype.seek = function(self) 
  local nextChar;
  local _g = self.state;
  local nextChar1 = _g[1];
  if (nextChar1) == 0 then 
    nextChar = _G.string.sub(self.string, 1, 1);
  elseif (nextChar1) == 1 then 
    local _g = _g[2];
    nextChar = "";
  elseif (nextChar1) == 2 then 
    local _g1 = _g[2];
    local pos = _g[3];
    nextChar = _G.string.sub(self.string, pos + 1, pos + 1); end;
  do return nextChar end
end
__parser_Parser.prototype.advance = function(self) 
  local _g = self.state;
  local tmp;
  local tmp1 = _g[1];
  if (tmp1) == 0 then 
    tmp = __parser_State.Running("", 1);
  elseif (tmp1) == 1 then 
    local tokens = _g[2];
    tmp = __parser_State.Finished(tokens);
  elseif (tmp1) == 2 then 
    local buffer = _g[2];
    local pos = _g[3];
    if ((pos + 1) >= #self.string) then 
      self.tokens:push(buffer);
      tmp = __parser_State.Finished(_hx_tab_array({}, 0));
    else
      tmp = __parser_State.Running(buffer, pos + 1);
    end; end;
  self.state = tmp;
  local _g = self.state;
  local tmp = _g[1];
  if (tmp) == 0 then 
    do return self:tokenize() end;
  elseif (tmp) == 1 then 
    local _g = _g[2];
    do return self.tokens end;
  elseif (tmp) == 2 then 
    local _g1 = _g[2];
    local _g = _g[3];
    do return self:tokenize() end; end;
end
__parser_Parser.prototype.tokenize = function(self) 
  local nextChar = self:seek();
  local isValidChar = self:checker(nextChar);
  local _g = self.state;
  local tmp;
  if (isValidChar) then 
    local tmp1 = _g[1];
    if (tmp1) == 0 then 
      tmp = __parser_State.Running(nextChar, 0);
    elseif (tmp1) == 1 then 
      local tokens = _g[2];
      tmp = __parser_State.Finished(tokens);
    elseif (tmp1) == 2 then 
      local buffer = _g[2];
      local pos = _g[3];
      tmp = __parser_State.Running(Std.string(buffer) .. Std.string(nextChar), pos); end;
  else
    local tmp1 = _g[1];
    if (tmp1) == 0 then 
      tmp = __parser_State.Running("", 0);
    elseif (tmp1) == 1 then 
      local tokens = _g[2];
      tmp = __parser_State.Finished(tokens);
    elseif (tmp1) == 2 then 
      local buffer = _g[2];
      local pos = _g[3];
      self.tokens:push(buffer);
      tmp = __parser_State.Running("", pos); end;
  end;
  self.state = tmp;
  do return self:advance() end
end

__parser_ClassName.new = function(str) 
  local self = _hx_new(__parser_ClassName.prototype)
  __parser_ClassName.super(self,str)
  return self
end
__parser_ClassName.super = function(self,str) 
  self.parser = __parser_Parser.new(str, __parser_ClassName.isNotWhitespace);
end
_hx_exports["parser"]["ClassName"] = __parser_ClassName
__parser_ClassName.isNotWhitespace = function(arg) 
  do return arg ~= " " end;
end
__parser_ClassName.main = function() 
  local res = __parser_ClassName.new("a be x-pene nabo:99"):parse();
  __haxe_Log.trace(res, _hx_o({__fields__={fileName=true,lineNumber=true,className=true,methodName=true},fileName="src/parser/ClassName.hx",lineNumber=88,className="parser.ClassName",methodName="main"}));
end
__parser_ClassName.prototype = _hx_e();
__parser_ClassName.prototype.parse = function(self) 
  do return self.parser:tokenize() end
end

__vim__Vim_GroupOpts_Impl_.new = {}
__vim__Vim_GroupOpts_Impl_._new = function(clear) 
  local this1 = ({clear = clear});
  do return this1 end;
end
__vim__Vim_GroupOpts_Impl_.fromObj = function(arg) 
  local this1 = ({clear = arg.clear});
  do return this1 end;
end

__vim__Vim_AutoCmdOpts_Impl_.new = {}
__vim__Vim_AutoCmdOpts_Impl_._new = function(pattern,cb,group,description,once,nested) 
  if (nested == nil) then 
    nested = false;
  end;
  if (once == nil) then 
    once = false;
  end;
  local this1 = ({pattern = pattern, callback = cb, group = group, desc = description, once = once, nested = nested});
  do return this1 end;
end

__vim_DanieloVim.new = {}
_hx_exports["vim"] = __vim_DanieloVim
__vim_DanieloVim.autocmd = function(groupName,events,pattern,description,cb) 
  local inlobj_clear = false;
  local this1 = ({clear = inlobj_clear});
  local group = vim.api.nvim_create_augroup(groupName, this1);
  local this1 = ({pattern = pattern, callback = cb, group = group, desc = (function() 
    local _hx_1
    if (description ~= nil) then 
    _hx_1 = description; else 
    _hx_1 = Std.string(Std.string(Std.string(Std.string("") .. Std.string(groupName)) .. Std.string(":[")) .. Std.string(pattern)) .. Std.string("]"); end
    return _hx_1
  end )(), once = false, nested = false});
  vim.api.nvim_create_autocmd(events, this1);
end
__vim_DanieloVim.chezmoi = function(args) 
end
__vim_DanieloVim.main = function() 
  __vim_DanieloVim.autocmd("HaxeEvent", ___VimTypes_LuaArray_Impl_.from(_hx_tab_array({[0]="BufWritePost"}, 1)), "*.hx", "Created from haxe", function() 
    vim.pretty_print("Hello from axe");
    do return true end;
  end);
end

__vim__Vim_Vim_Fields_.new = {}
__vim__Vim_Vim_Fields_.comment = function() 
  ---@diagnostic disable;
end
if _hx_bit_raw then
    _hx_bit_clamp = function(v)
    if v <= 2147483647 and v >= -2147483648 then
        if v > 0 then return _G.math.floor(v)
        else return _G.math.ceil(v)
        end
    end
    if v > 2251798999999999 then v = v*2 end;
    if (v ~= v or math.abs(v) == _G.math.huge) then return nil end
    return _hx_bit_raw.band(v, 2147483647 ) - math.abs(_hx_bit_raw.band(v, 2147483648))
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
end;



_hx_array_mt.__index = Array.prototype

local _hx_static_init = function()
  
end

_hx_funcToField = function(f)
  if type(f) == 'function' then
    return function(self,...)
      return f(...)
    end
  else
    return f
  end
end

_hx_print = print or (function() end)

_hx_static_init();
return _hx_exports
