
--terralib luapower extensions.

local ffi = require'ffi'
local List = require'asdl'.List

--reset include paths (terralib looks for Visual Studio ones by default).
terra.systemincludes = List()

--using mingw64 headers from `mingw64-headers` package.
if ffi.os == "Windows" then
	terra.systemincludes:insertall {
		("%s/../../csrc/mingw64-headers/mingw64/include"):format(terra.terrahome),
		("%s/../../csrc/mingw64-headers/mingw64/include-fixed"):format(terra.terrahome),
		("%s/../../csrc/mingw64-headers/mingw32"):format(terra.terrahome),
	}
end

--overload loadfile() to interpret *.t files as Terra code.
local lua_loadfile = loadfile
_G.loadfile = function(file)
	local loadfile = file:find'%.t$' and terra.loadfile or lua_loadfile
	return loadfile(file)
end
