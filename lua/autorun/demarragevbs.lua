local rep = "vbs/"
local file, folder = file.Find(rep.."*", "LUA")
SetGlobalBool( "volley_enabled", false)

print([[
	-------------------------------------------------------------
	VBS : Volleyball System
	created by Lombrès in late 2020
	-------------------------------------------------------------
]])


if (SERVER) then
    for k, v in pairs(file) do
        if (string.StartWith(v, "sv") and string.EndsWith(v, ".lua")) then
            include(rep..v)
        elseif (string.StartWith(v, 'sh') and string.EndsWith(v,".lua")) then
            include(rep..v)
            AddCSLuaFile(rep..v)
        elseif (string.StartWith(v, "cl") and string.EndsWith(v, ".lua") ) then  
			AddCSLuaFile(rep..v)
		end
    end
else
	for k, v in pairs(file) do
		if ( string.StartWith(v, "cl") or string.StartWith(v, "sh") and string.EndsWith(v, ".lua") ) then
			include(rep..v)
		end
	end
end





