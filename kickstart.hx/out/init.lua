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
local Array = _hx_e()
local Math = _hx_e()
local String = _hx_e()
local Std = _hx_e()
__haxe_iterators_ArrayIterator = _hx_e()
__haxe_iterators_ArrayKeyValueIterator = _hx_e()
__kickstart_Cmp = _G.require("cmp")
__kickstart__Kickstart_Kickstart_Fields_ = _hx_e()
__kickstart__Untyped_Untyped_Fields_ = _hx_e()
__lua_StringMap = _hx_e()
__packer__Packer_Packer_Fields_ = _hx_e()
__plugins__Copilot_Copilot_Fields_ = _hx_e()
__plugins__FzfLua_FzfLua_Fields_ = _hx_e()
__plugins__Plugins_Plugins_Fields_ = _hx_e()
__vim__TableTools_TableTools_Fields_ = _hx_e()
__vim__VimTypes_LuaArray_Impl_ = _hx_e()
__vim_Vimx = _hx_e()

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
  while (_g1 < self.length) do 
    local i = self[_g1];
    _g1 = _g1 + 1;
    _g:push(i);
  end;
  local _g1 = 0;
  while (_g1 < a.length) do 
    local i = a[_g1];
    _g1 = _g1 + 1;
    _g:push(i);
  end;
  do return _g end
end
Array.prototype.join = function(self,sep) 
  local tbl = ({});
  local _g_current = 0;
  while (_g_current < self.length) do 
    _g_current = _g_current + 1;
    _G.table.insert(tbl, Std.string(self[_g_current - 1]));
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
    ret:push(self[_g - 1]);
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
  self.length = self.length - len;
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
  while (_g < len) do 
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
    if (self[_g - 1] == x) then 
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
  while (_g < _end) do 
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
  while (_g1 < self.length) do 
    local i = self[_g1];
    _g1 = _g1 + 1;
    _g:push(i);
  end;
  do return _g end
end
Array.prototype.map = function(self,f) 
  local _g = _hx_tab_array({}, 0);
  local _g1 = 0;
  while (_g1 < self.length) do 
    local i = self[_g1];
    _g1 = _g1 + 1;
    _g:push(f(i));
  end;
  do return _g end
end
Array.prototype.filter = function(self,f) 
  local _g = _hx_tab_array({}, 0);
  local _g1 = 0;
  while (_g1 < self.length) do 
    local i = self[_g1];
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
        self[_g - 1] = nil;
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
      ret:push(_G.string.sub(self, idx, newidx - 1));
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

__kickstart__Kickstart_Kickstart_Fields_.new = {}
__kickstart__Kickstart_Kickstart_Fields_.main = function() 
  local spec = _hx_o({__fields__={name=true},name="wbthomason/packer.nvim"});
  local plugins = { 
        spec.name, 
        disable=spec.disable,
        as=spec.as,
        installer=spec.installer,
        updater=spec.updater,
        after=spec.after,
        rtp=spec.rtp,
        opt=spec.opt,
        bufread=spec.bufread,
        branch=spec.branch,
        tag=spec.tag,
        commit=spec.commit,
        lock=spec.lock,
        run=spec.run,
        requires=spec.requires,
        rocks=spec.rocks,
        config=spec.config,
        setup=spec.setup,
        cmd=spec.cmd,
        ft=spec.ft,
        keys=spec.keys,
        event=spec.event,
        fn=spec.fn,
        cond=spec.cond,
        module=spec.module,
        module_pattern=spec.module_pattern
      }
  local spec = _hx_o({__fields__={name=true},name="kylechui/nvim-surround"});
  local plugins1 = { 
        spec.name, 
        disable=spec.disable,
        as=spec.as,
        installer=spec.installer,
        updater=spec.updater,
        after=spec.after,
        rtp=spec.rtp,
        opt=spec.opt,
        bufread=spec.bufread,
        branch=spec.branch,
        tag=spec.tag,
        commit=spec.commit,
        lock=spec.lock,
        run=spec.run,
        requires=spec.requires,
        rocks=spec.rocks,
        config=spec.config,
        setup=spec.setup,
        cmd=spec.cmd,
        ft=spec.ft,
        keys=spec.keys,
        event=spec.event,
        fn=spec.fn,
        cond=spec.cond,
        module=spec.module,
        module_pattern=spec.module_pattern
      }
  local spec = _hx_o({__fields__={name=true},name="folke/which-key.nvim"});
  local plugins2 = { 
        spec.name, 
        disable=spec.disable,
        as=spec.as,
        installer=spec.installer,
        updater=spec.updater,
        after=spec.after,
        rtp=spec.rtp,
        opt=spec.opt,
        bufread=spec.bufread,
        branch=spec.branch,
        tag=spec.tag,
        commit=spec.commit,
        lock=spec.lock,
        run=spec.run,
        requires=spec.requires,
        rocks=spec.rocks,
        config=spec.config,
        setup=spec.setup,
        cmd=spec.cmd,
        ft=spec.ft,
        keys=spec.keys,
        event=spec.event,
        fn=spec.fn,
        cond=spec.cond,
        module=spec.module,
        module_pattern=spec.module_pattern
      }
  local spec = _hx_o({__fields__={name=true,requires=true},name="neovim/nvim-lspconfig",requires=({"williamboman/mason.nvim","williamboman/mason-lspconfig.nvim","j-hui/fidget.nvim","folke/neodev.nvim"})});
  local plugins3 = { 
        spec.name, 
        disable=spec.disable,
        as=spec.as,
        installer=spec.installer,
        updater=spec.updater,
        after=spec.after,
        rtp=spec.rtp,
        opt=spec.opt,
        bufread=spec.bufread,
        branch=spec.branch,
        tag=spec.tag,
        commit=spec.commit,
        lock=spec.lock,
        run=spec.run,
        requires=spec.requires,
        rocks=spec.rocks,
        config=spec.config,
        setup=spec.setup,
        cmd=spec.cmd,
        ft=spec.ft,
        keys=spec.keys,
        event=spec.event,
        fn=spec.fn,
        cond=spec.cond,
        module=spec.module,
        module_pattern=spec.module_pattern
      }
  local spec = _hx_o({__fields__={name=true,requires=true},name="hrsh7th/nvim-cmp",requires=({"hrsh7th/cmp-nvim-lsp","L3MON4D3/LuaSnip","saadparwaiz1/cmp_luasnip"})});
  local plugins4 = { 
        spec.name, 
        disable=spec.disable,
        as=spec.as,
        installer=spec.installer,
        updater=spec.updater,
        after=spec.after,
        rtp=spec.rtp,
        opt=spec.opt,
        bufread=spec.bufread,
        branch=spec.branch,
        tag=spec.tag,
        commit=spec.commit,
        lock=spec.lock,
        run=spec.run,
        requires=spec.requires,
        rocks=spec.rocks,
        config=spec.config,
        setup=spec.setup,
        cmd=spec.cmd,
        ft=spec.ft,
        keys=spec.keys,
        event=spec.event,
        fn=spec.fn,
        cond=spec.cond,
        module=spec.module,
        module_pattern=spec.module_pattern
      }
  local spec = _hx_o({__fields__={name=true,run=true},name="nvim-treesitter/nvim-treesitter",run="pcall(require(\"nvim-treesitter.install\").update({ with_sync = true }))"});
  local plugins5 = { 
        spec.name, 
        disable=spec.disable,
        as=spec.as,
        installer=spec.installer,
        updater=spec.updater,
        after=spec.after,
        rtp=spec.rtp,
        opt=spec.opt,
        bufread=spec.bufread,
        branch=spec.branch,
        tag=spec.tag,
        commit=spec.commit,
        lock=spec.lock,
        run=spec.run,
        requires=spec.requires,
        rocks=spec.rocks,
        config=spec.config,
        setup=spec.setup,
        cmd=spec.cmd,
        ft=spec.ft,
        keys=spec.keys,
        event=spec.event,
        fn=spec.fn,
        cond=spec.cond,
        module=spec.module,
        module_pattern=spec.module_pattern
      }
  local spec = _hx_o({__fields__={name=true},name="b0o/schemastore.nvim"});
  local plugins6 = { 
        spec.name, 
        disable=spec.disable,
        as=spec.as,
        installer=spec.installer,
        updater=spec.updater,
        after=spec.after,
        rtp=spec.rtp,
        opt=spec.opt,
        bufread=spec.bufread,
        branch=spec.branch,
        tag=spec.tag,
        commit=spec.commit,
        lock=spec.lock,
        run=spec.run,
        requires=spec.requires,
        rocks=spec.rocks,
        config=spec.config,
        setup=spec.setup,
        cmd=spec.cmd,
        ft=spec.ft,
        keys=spec.keys,
        event=spec.event,
        fn=spec.fn,
        cond=spec.cond,
        module=spec.module,
        module_pattern=spec.module_pattern
      }
  local spec = _hx_o({__fields__={name=true},name="tpope/vim-fugitive"});
  local plugins7 = { 
        spec.name, 
        disable=spec.disable,
        as=spec.as,
        installer=spec.installer,
        updater=spec.updater,
        after=spec.after,
        rtp=spec.rtp,
        opt=spec.opt,
        bufread=spec.bufread,
        branch=spec.branch,
        tag=spec.tag,
        commit=spec.commit,
        lock=spec.lock,
        run=spec.run,
        requires=spec.requires,
        rocks=spec.rocks,
        config=spec.config,
        setup=spec.setup,
        cmd=spec.cmd,
        ft=spec.ft,
        keys=spec.keys,
        event=spec.event,
        fn=spec.fn,
        cond=spec.cond,
        module=spec.module,
        module_pattern=spec.module_pattern
      }
  local spec = _hx_o({__fields__={name=true},name="tpope/vim-rhubarb"});
  local plugins8 = { 
        spec.name, 
        disable=spec.disable,
        as=spec.as,
        installer=spec.installer,
        updater=spec.updater,
        after=spec.after,
        rtp=spec.rtp,
        opt=spec.opt,
        bufread=spec.bufread,
        branch=spec.branch,
        tag=spec.tag,
        commit=spec.commit,
        lock=spec.lock,
        run=spec.run,
        requires=spec.requires,
        rocks=spec.rocks,
        config=spec.config,
        setup=spec.setup,
        cmd=spec.cmd,
        ft=spec.ft,
        keys=spec.keys,
        event=spec.event,
        fn=spec.fn,
        cond=spec.cond,
        module=spec.module,
        module_pattern=spec.module_pattern
      }
  local spec = _hx_o({__fields__={name=true},name="lewis6991/gitsigns.nvim"});
  local plugins9 = { 
        spec.name, 
        disable=spec.disable,
        as=spec.as,
        installer=spec.installer,
        updater=spec.updater,
        after=spec.after,
        rtp=spec.rtp,
        opt=spec.opt,
        bufread=spec.bufread,
        branch=spec.branch,
        tag=spec.tag,
        commit=spec.commit,
        lock=spec.lock,
        run=spec.run,
        requires=spec.requires,
        rocks=spec.rocks,
        config=spec.config,
        setup=spec.setup,
        cmd=spec.cmd,
        ft=spec.ft,
        keys=spec.keys,
        event=spec.event,
        fn=spec.fn,
        cond=spec.cond,
        module=spec.module,
        module_pattern=spec.module_pattern
      }
  local spec = _hx_o({__fields__={name=true},name="navarasu/onedark.nvim"});
  local plugins10 = { 
        spec.name, 
        disable=spec.disable,
        as=spec.as,
        installer=spec.installer,
        updater=spec.updater,
        after=spec.after,
        rtp=spec.rtp,
        opt=spec.opt,
        bufread=spec.bufread,
        branch=spec.branch,
        tag=spec.tag,
        commit=spec.commit,
        lock=spec.lock,
        run=spec.run,
        requires=spec.requires,
        rocks=spec.rocks,
        config=spec.config,
        setup=spec.setup,
        cmd=spec.cmd,
        ft=spec.ft,
        keys=spec.keys,
        event=spec.event,
        fn=spec.fn,
        cond=spec.cond,
        module=spec.module,
        module_pattern=spec.module_pattern
      }
  local spec = _hx_o({__fields__={name=true},name="nvim-lualine/lualine.nvim"});
  local plugins11 = { 
        spec.name, 
        disable=spec.disable,
        as=spec.as,
        installer=spec.installer,
        updater=spec.updater,
        after=spec.after,
        rtp=spec.rtp,
        opt=spec.opt,
        bufread=spec.bufread,
        branch=spec.branch,
        tag=spec.tag,
        commit=spec.commit,
        lock=spec.lock,
        run=spec.run,
        requires=spec.requires,
        rocks=spec.rocks,
        config=spec.config,
        setup=spec.setup,
        cmd=spec.cmd,
        ft=spec.ft,
        keys=spec.keys,
        event=spec.event,
        fn=spec.fn,
        cond=spec.cond,
        module=spec.module,
        module_pattern=spec.module_pattern
      }
  local spec = _hx_o({__fields__={name=true},name="lukas-reineke/indent-blankline.nvim"});
  local plugins12 = { 
        spec.name, 
        disable=spec.disable,
        as=spec.as,
        installer=spec.installer,
        updater=spec.updater,
        after=spec.after,
        rtp=spec.rtp,
        opt=spec.opt,
        bufread=spec.bufread,
        branch=spec.branch,
        tag=spec.tag,
        commit=spec.commit,
        lock=spec.lock,
        run=spec.run,
        requires=spec.requires,
        rocks=spec.rocks,
        config=spec.config,
        setup=spec.setup,
        cmd=spec.cmd,
        ft=spec.ft,
        keys=spec.keys,
        event=spec.event,
        fn=spec.fn,
        cond=spec.cond,
        module=spec.module,
        module_pattern=spec.module_pattern
      }
  local spec = _hx_o({__fields__={name=true},name="numToStr/Comment.nvim"});
  local plugins13 = { 
        spec.name, 
        disable=spec.disable,
        as=spec.as,
        installer=spec.installer,
        updater=spec.updater,
        after=spec.after,
        rtp=spec.rtp,
        opt=spec.opt,
        bufread=spec.bufread,
        branch=spec.branch,
        tag=spec.tag,
        commit=spec.commit,
        lock=spec.lock,
        run=spec.run,
        requires=spec.requires,
        rocks=spec.rocks,
        config=spec.config,
        setup=spec.setup,
        cmd=spec.cmd,
        ft=spec.ft,
        keys=spec.keys,
        event=spec.event,
        fn=spec.fn,
        cond=spec.cond,
        module=spec.module,
        module_pattern=spec.module_pattern
      }
  local spec = _hx_o({__fields__={name=true},name="tpope/vim-sleuth"});
  local plugins14 = { 
        spec.name, 
        disable=spec.disable,
        as=spec.as,
        installer=spec.installer,
        updater=spec.updater,
        after=spec.after,
        rtp=spec.rtp,
        opt=spec.opt,
        bufread=spec.bufread,
        branch=spec.branch,
        tag=spec.tag,
        commit=spec.commit,
        lock=spec.lock,
        run=spec.run,
        requires=spec.requires,
        rocks=spec.rocks,
        config=spec.config,
        setup=spec.setup,
        cmd=spec.cmd,
        ft=spec.ft,
        keys=spec.keys,
        event=spec.event,
        fn=spec.fn,
        cond=spec.cond,
        module=spec.module,
        module_pattern=spec.module_pattern
      }
  local spec = _hx_o({__fields__={name=true,cmd=true,event=true,config=true},name="zbirenbaum/copilot.lua",cmd="Copilot",event=__vim__VimTypes_LuaArray_Impl_.from(_hx_tab_array({[0]="InsertEnter"}, 1)),config=function(_,...) return __plugins__Copilot_Copilot_Fields_.configure(...) end});
  local plugins15 = { 
        spec.name, 
        disable=spec.disable,
        as=spec.as,
        installer=spec.installer,
        updater=spec.updater,
        after=spec.after,
        rtp=spec.rtp,
        opt=spec.opt,
        bufread=spec.bufread,
        branch=spec.branch,
        tag=spec.tag,
        commit=spec.commit,
        lock=spec.lock,
        run=spec.run,
        requires=spec.requires,
        rocks=spec.rocks,
        config=spec.config,
        setup=spec.setup,
        cmd=spec.cmd,
        ft=spec.ft,
        keys=spec.keys,
        event=spec.event,
        fn=spec.fn,
        cond=spec.cond,
        module=spec.module,
        module_pattern=spec.module_pattern
      }
  local spec = _hx_o({__fields__={name=true,requires=true,config=true},name="ibhagwan/fzf-lua",requires=({"nvim-tree/nvim-web-devicons"}),config=function(_,...) return __plugins__FzfLua_FzfLua_Fields_.configure(...) end});
  local plugins = _hx_tab_array({[0]=plugins, plugins1, plugins2, plugins3, plugins4, plugins5, plugins6, plugins7, plugins8, plugins9, plugins10, plugins11, plugins12, plugins13, plugins14, plugins15, { 
        spec.name, 
        disable=spec.disable,
        as=spec.as,
        installer=spec.installer,
        updater=spec.updater,
        after=spec.after,
        rtp=spec.rtp,
        opt=spec.opt,
        bufread=spec.bufread,
        branch=spec.branch,
        tag=spec.tag,
        commit=spec.commit,
        lock=spec.lock,
        run=spec.run,
        requires=spec.requires,
        rocks=spec.rocks,
        config=spec.config,
        setup=spec.setup,
        cmd=spec.cmd,
        ft=spec.ft,
        keys=spec.keys,
        event=spec.event,
        fn=spec.fn,
        cond=spec.cond,
        module=spec.module,
        module_pattern=spec.module_pattern
      }}, 17);
  local is_bootstrap = __packer__Packer_Packer_Fields_.ensureInstalled();
  local packer = _G.require("packer");
  packer.startup(function(use) 
    local _g = 0;
    while (_g < plugins.length) do 
      local plugin = plugins[_g];
      _g = _g + 1;
      use(plugin);
    end;
  end);
  if (is_bootstrap) then 
    packer.sync();
  end;
  if (is_bootstrap) then 
    vim.pretty_print("==================================");
    vim.pretty_print("    Plugins are being installed");
    vim.pretty_print("    Wait until Packer completes,");
    vim.pretty_print("       then restart nvim");
    vim.pretty_print("==================================");
    do return end;
  end;
  __kickstart__Kickstart_Kickstart_Fields_.keymaps();
  __kickstart__Kickstart_Kickstart_Fields_.setupPlugins();
  vim.cmd("colorscheme onedark");
  vim.o.hlsearch = false;
  vim.o.mouse = "a";
  vim.o.breakindent = true;
  vim.o.undofile = true;
  vim.wo.number = true;
  vim.o.inccommand = "split";
  __kickstart__Kickstart_Kickstart_Fields_.autoCommands();
end
__kickstart__Kickstart_Kickstart_Fields_.autoCommands = function() 
  __vim_Vimx.autocmd("Kickstart", ({"BufWritePost"}), vim.fn.expand("$MYVIMRC"), "Reload the config", function() 
    vim.cmd("source <afile> | PackerCompile");
  end);
  __vim_Vimx.autocmd("Kickstart-yank", __vim__VimTypes_LuaArray_Impl_.from(_hx_tab_array({[0]="TextYankPost"}, 1)), "*", "Highlight on yank", __kickstart__Untyped_Untyped_Fields_.higlightOnYank);
end
__kickstart__Kickstart_Kickstart_Fields_.onAttach = function(x,bufnr) 
  local nmap = function(keys,func,desc) 
    vim.keymap.set("n", keys, func, ({buffer = bufnr, desc = Std.string("LSP: ") .. Std.string(desc)}));
  end;
  nmap("<leader>rn", vim.lsp.buf.rename, "[R]e[n]ame");
  nmap("<leader>ca", vim.lsp.buf.code_action, "[C]ode [A]ction");
  nmap("gd", vim.lsp.buf.definition, "[G]oto [D]efinition");
  nmap("gI", vim.lsp.buf.implementation, "[G]oto [I]mplementation");
  nmap("<leader>D", vim.lsp.buf.type_definition, "Type [D]efinition");
  nmap("K", vim.lsp.buf.hover, "Hover Documentation");
  nmap("<C-k>", vim.lsp.buf.signature_help, "Signature Documentation");
  nmap("gD", vim.lsp.buf.declaration, "[G]oto [D]eclaration");
  nmap("<leader>wa", vim.lsp.buf.add_workspace_folder, "[W]orkspace [A]dd Folder");
  nmap("<leader>wr", vim.lsp.buf.remove_workspace_folder, "[W]orkspace [R]emove Folder");
  nmap("<leader>wl", function() 
    vim.pretty_print(vim.lsp.buf.list_workspace_folders());
  end, "[W]orkspace [L]ist Folders");
  vim.api.nvim_buf_create_user_command(bufnr, "Format", function(_) 
    vim.lsp.buf.format();
  end, ({bang = false, desc = "Format current buffer with LSP", force = true, nargs = 0, range = false}));
end
__kickstart__Kickstart_Kickstart_Fields_.setupPlugins = function() 
  local _v_ = __plugins__Plugins_Plugins_Fields_.safeRequire("Comment");
  if (_v_ ~= nil) then 
    _v_.setup();
  end;
  local _v_ = __plugins__Plugins_Plugins_Fields_.safeRequire("indent_blankline");
  if (_v_ ~= nil) then 
    _v_.setup(({char = "┊", show_trailing_blankline_indent = false}));
  end;
  local _v_ = __plugins__Plugins_Plugins_Fields_.safeRequire("neodev");
  if (_v_ ~= nil) then 
    _v_.setup();
  end;
  local _v_ = __plugins__Plugins_Plugins_Fields_.safeRequire("mason");
  if (_v_ ~= nil) then 
    _v_.setup();
  end;
  local _v_ = __plugins__Plugins_Plugins_Fields_.safeRequire("fidget");
  if (_v_ ~= nil) then 
    _v_.setup();
  end;
  local mapping = __kickstart_Cmp.mapping.preset;
  local ls = __plugins__Plugins_Plugins_Fields_.safeRequire("luasnip");
  local mapping = mapping.insert(
{
    ['<C-d>'] = __kickstart_Cmp.mapping.scroll_docs(-4),
    ['<C-f>'] = __kickstart_Cmp.mapping.scroll_docs(4),
    ['<C-n>'] = __kickstart_Cmp.mapping(__kickstart_Cmp.mapping.complete(),{'i'}),
    ['<CR>'] = __kickstart_Cmp.mapping.confirm {
      behavior = __kickstart_Cmp.ConfirmBehavior.Replace,
      select = true,
    },
    ['<Tab>'] = __kickstart_Cmp.mapping(function(fallback)
      if __kickstart_Cmp.visible() then
        __kickstart_Cmp.select_next_item()
      elseif ls.expand_or_jumpable() then
        ls.expand_or_jump()
      else
        fallback()
      end
    end, { 'i', 's' }),
    ['<S-Tab>'] = __kickstart_Cmp.mapping(function(fallback)
      if __kickstart_Cmp.visible() then
        __kickstart_Cmp.select_prev_item()
      elseif ls.jumpable(-1) then
        ls.jump(-1)
      else
        fallback()
      end
    end, { 'i', 's' }),
  }
      );
  local ls = __plugins__Plugins_Plugins_Fields_.safeRequire("luasnip");
  __kickstart_Cmp.setup(({mapping = mapping, snippet = ({expand = function(args) 
    local _v_ = ls;
    if (_v_ ~= nil) then 
      _v_.lsp_expand(args.body);
    end;
  end}), sources = ({({name = "luasnip"}),({name = "nvim_lsp"})})}));
  local _v_ = __plugins__Plugins_Plugins_Fields_.safeRequire("cmp_nvim_lsp");
  local capabilities = (function() 
    local _hx_1
    if (_v_ == nil) then 
    _hx_1 = nil; else 
    _hx_1 = _v_.default_capabilities(vim.lsp.protocol.make_client_capabilities()); end
    return _hx_1
  end )();
  local _hx_2_module_status, _hx_2_module_value = _G.pcall(_G.require, "lualine");
  local lualine = (function() 
    local _hx_3
    if (_hx_2_module_status) then 
    _hx_3 = _hx_2_module_value; else 
    _hx_3 = nil; end
    return _hx_3
  end )();
  if (lualine ~= nil) then 
    lualine.setup(({options = ({icons_enabled = true, theme = "onedark", component_separators = "|", section_separators = ""})}));
  end;
  local this1;
  local _hx_4_requireResult_status, _hx_4_requireResult_value = _G.pcall(_G.require, "which-key");
  if (_hx_4_requireResult_status) then 
    this1 = _hx_4_requireResult_value;
  else
    this1 = nil;
  end;
  local wk = this1;
  if (wk ~= nil) then 
    vim.o.timeout = true;
    vim.o.timeoutlen = 300;
    wk.setup(({disable = nil, hidden = nil, icons = nil, ignore_missing = nil, key_labels = nil, layout = nil, motions = nil, operators = nil, plugins = ({marks = true, registers = true, spelling = ({enabled = true, suggestions = 20}), presets = ({operators = true, motions = true, text_objects = true, windows = true, nav = true, z = true, g = true})}), popup_mappings = nil, show_help = nil, show_keys = nil, triggers = nil, triggers_blacklist = nil, triggers_nowait = nil, window = nil}));
  end;
  local this1;
  local _hx_5_requireResult_status, _hx_5_requireResult_value = _G.pcall(_G.require, "gitsigns");
  if (_hx_5_requireResult_status) then 
    this1 = _hx_5_requireResult_value;
  else
    this1 = nil;
  end;
  local gs = this1;
  if (gs ~= nil) then 
    gs.setup(({signs = ({add = ({text = "+"}), change = ({text = "~"}), delete = ({text = "_"}), topdelete = ({text = "‾"}), changedelete = ({text = "~"})})}));
  end;
  local this1;
  local _hx_6_requireResult_status, _hx_6_requireResult_value = _G.pcall(_G.require, "lspconfig");
  if (_hx_6_requireResult_status) then 
    this1 = _hx_6_requireResult_value;
  else
    this1 = nil;
  end;
  local lspconfig = this1;
  if (lspconfig ~= nil) then 
    local lspconfig = lspconfig;
    local mason = __plugins__Plugins_Plugins_Fields_.safeRequire("mason-lspconfig");
    if (capabilities ~= nil) then 
      if (mason ~= nil) then 
        mason.setup_handlers(({function(server_name) 
          local server_name1 = server_name;
          if (server_name1) == "haxe_language_server" then 
            local _this = lspconfig.haxe_language_server;
            local config_capabilities = capabilities;
            local config_on_attach = __kickstart__Kickstart_Kickstart_Fields_.onAttach;
            local config_settings = ({});
            _this.setup({
      on_attach = config_on_attach,
      settings = config_settings,
      capabilities = config_capabilities,
    });
          elseif (server_name1) == "jsonls" then 
            local _v_ = __plugins__Plugins_Plugins_Fields_.safeRequire("schemastore");
            local _v_ = (function() 
              local _hx_7
              if (_v_ == nil) then 
              _hx_7 = nil; else 
              _hx_7 = _v_.json; end
              return _hx_7
            end )();
            local jsonSchemas = (function() 
              local _hx_8
              if (_v_ == nil) then 
              _hx_8 = nil; else 
              _hx_8 = _v_:schemas(); end
              return _hx_8
            end )();
            local schemas = ({_hx_o({__fields__={description=true,fileMatch=true,name=true,url=true},description="Haxe format schema",fileMatch=({"hxformat.json"}),name="hxformat.schema.json",url="https://raw.githubusercontent.com/vshaxe/vshaxe/master/schemas/hxformat.schema.json"})});
            if (jsonSchemas ~= nil) then 
              schemas = __vim__TableTools_TableTools_Fields_.concat(schemas, jsonSchemas);
            end;
            local _this = lspconfig.jsonls;
            local config_capabilities = capabilities;
            local config_on_attach = __kickstart__Kickstart_Kickstart_Fields_.onAttach;
            local config_settings = ({json = ({schemas = schemas})});
            _this.setup({
      on_attach = config_on_attach,
      settings = config_settings,
      capabilities = config_capabilities,
    });
          elseif (server_name1) == "lua_ls" then 
            local _this = lspconfig.lua_ls;
            local config_capabilities = capabilities;
            local config_on_attach = __kickstart__Kickstart_Kickstart_Fields_.onAttach;
            local config_settings = ({lua = ({workspace = ({checkThirdParty = false}), telemetry = ({enable = false})})});
            _this.setup({
      on_attach = config_on_attach,
      settings = config_settings,
      capabilities = config_capabilities,
    });else
          vim.pretty_print(Std.string("Ignoring ") .. Std.string(server_name)); end;
        end}));
      end;
    end;
  end;
end
__kickstart__Kickstart_Kickstart_Fields_.keymaps = function() 
  vim.g.mapleader = " ";
  vim.g.maplocalleader = ",";
  vim.keymap.set(({"n"}), "k", "v:count == 0 ? 'gk' : 'k'", ({desc = "up when word-wrap", expr = true, silent = true}));
  vim.keymap.set(({"n"}), "j", "v:count == 0 ? 'gj' : 'j'", ({desc = "down when word-wrap", expr = true, silent = true}));
  vim.keymap.set(({"n"}), "<leader>w", "<Cmd>wa<CR>", ({desc = "Write all files", expr = nil, silent = true}));
  if (__plugins__Plugins_Plugins_Fields_.safeRequire("fzf-lua") ~= nil) then 
    vim.keymap.set(({"n"}), "<leader>ff", "<Cmd>lua require('fzf-lua').files()<CR>", ({desc = "Find files", expr = nil, silent = true}));
    vim.keymap.set(({"n"}), "<leader>fg", "<Cmd>lua require('fzf-lua').grep()<CR>", ({desc = "Grep files", expr = nil, silent = true}));
    vim.keymap.set(({"n"}), "<leader>fb", "<Cmd>lua require('fzf-lua').buffers()<CR>", ({desc = "Find buffers", expr = nil, silent = true}));
    vim.keymap.set(({"n"}), "<leader>fh", "<Cmd>lua require('fzf-lua').help_tags()<CR>", ({desc = "Find help tags", expr = nil, silent = true}));
  end;
end

__kickstart__Untyped_Untyped_Fields_.new = {}
__kickstart__Untyped_Untyped_Fields_.higlightOnYank = function() 
  do return vim.highlight.on_yank() end;
end

__lua_StringMap.new = function() 
  local self = _hx_new(__lua_StringMap.prototype)
  __lua_StringMap.super(self)
  return self
end
__lua_StringMap.super = function(self) 
  self.h = ({});
end
__lua_StringMap.prototype = _hx_e();
__lua_StringMap.prototype.set = function(self,key,value) 
  if (value == nil) then 
    self.h[key] = __lua_StringMap.tnull;
  else
    self.h[key] = value;
  end;
end
__lua_StringMap.prototype.get = function(self,key) 
  local ret = self.h[key];
  if (ret == __lua_StringMap.tnull) then 
    do return nil end;
  end;
  do return ret end
end

__packer__Packer_Packer_Fields_.new = {}
__packer__Packer_Packer_Fields_.ensureInstalled = function() 
  local install_path = Std.string(vim.fn.stdpath("data")) .. Std.string("/site/pack/packer/start/packer.nvim");
  if (vim.fn.empty(vim.fn.glob(install_path, nil)) > 0) then 
    vim.fn.system(({"git","clone","--depth","1","https://github.com/wbthomason/packer.nvim",install_path}), nil);
    vim.cmd("packadd packer.nvim");
    do return true end;
  else
    do return false end;
  end;
end

__plugins__Copilot_Copilot_Fields_.new = {}
__plugins__Copilot_Copilot_Fields_.configure = function() 
  local this1;
  local _hx_1_requireResult_status, _hx_1_requireResult_value = _G.pcall(_G.require, "copilot");
  if (_hx_1_requireResult_status) then 
    this1 = _hx_1_requireResult_value;
  else
    this1 = nil;
  end;
  local x = this1;
  if (x ~= nil) then 
    x.setup(({copilot_node_command = "node", filetypes = ({yaml = false, markdown = false, help = false, gitcommit = false, gitrebase = false, hgcommit = false, svn = false, cvs = false}), panel = ({enabled = true, auto_refresh = true, keymap = ({jump_prev = "[[", jump_next = "]]", accept = "<CR>", refresh = "gr", open = "<M-CR>"}), layout = ({position = "bottom", ratio = 0.4})}), suggestion = ({enabled = true, auto_trigger = true, debounce = 75, keymap = ({accept = "<c-e>", accept_word = false, accept_line = false, next = "<M-b>", prev = "<M-v>", dismiss = "<C-c>"})})}));
  end;
end

__plugins__FzfLua_FzfLua_Fields_.new = {}
__plugins__FzfLua_FzfLua_Fields_.configure = function() 
  local module = __plugins__Plugins_Plugins_Fields_.safeRequire("fzf-lua");
  if (module ~= nil) then 
    module.setup(({}));
  end;
end

__plugins__Plugins_Plugins_Fields_.new = {}
__plugins__Plugins_Plugins_Fields_.safeRequire = function(name) 
  local _hx_1_module_status, _hx_1_module_value = _G.pcall(_G.require, name);
  if (_hx_1_module_status) then 
    do return _hx_1_module_value end;
  else
    do return nil end;
  end;
end

__vim__TableTools_TableTools_Fields_.new = {}
__vim__TableTools_TableTools_Fields_.concat = function(tableA,tableB) 
  do return vim.list_extend(vim.list_extend(({}), tableA), tableB) end;
end

__vim__VimTypes_LuaArray_Impl_.new = {}
__vim__VimTypes_LuaArray_Impl_.from = function(arr) 
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

__vim_Vimx.new = {}
_hx_exports["vimx"] = __vim_Vimx
__vim_Vimx.autocmd = function(groupName,events,pattern,description,cb) 
  local group;
  local _g = __vim_Vimx.autogroups:get(groupName);
  if (_g == nil) then 
    group = vim.api.nvim_create_augroup(groupName, ({clear = true}));
    __vim_Vimx.autogroups:set(groupName, group);
  else
    group = _g;
  end;
  vim.api.nvim_create_autocmd(events, ({pattern = pattern, callback = cb, group = group, desc = (function() 
    local _hx_1
    if (description == nil) then 
    _hx_1 = Std.string(Std.string(Std.string(Std.string("") .. Std.string(groupName)) .. Std.string(":[")) .. Std.string(pattern)) .. Std.string("]"); else 
    _hx_1 = description; end
    return _hx_1
  end )(), once = false, nested = false}));
end
__vim_Vimx.copyToClipboard = function(str) 
  vim.cmd(Std.string(Std.string("let @* = \"") .. Std.string(str)) .. Std.string("\""));
  vim.notify("Copied to clipboard", "info");
end
__vim_Vimx.linesInCurrentWindow = function() 
  do return vim.fn.line("$", 0) end;
end
__vim_Vimx.firstLineVisibleCurrentWindow = function() 
  do return vim.fn.line("w0", 0) end;
end
__vim_Vimx.lastLineVisibleCurrentWindow = function() 
  do return vim.fn.line("w$", 0) end;
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
  __lua_StringMap.tnull = ({});
  
  __vim_Vimx.autogroups = __lua_StringMap.new();
  
  
end

_hx_static_init();
_G.xpcall(__kickstart__Kickstart_Kickstart_Fields_.main, _hx_error)
return _hx_exports
